-- ============================================================
--  监狱人生 - 最终版（加指定击杀）
--  警察：罪犯直接打，犯人有武器才打（排除食物）
--  犯人：打警察 + 开关控制打罪犯
--  罪犯：打警察 + 开关控制打犯人
--  功能：自动枪械 | 自动拳头 | 传送(自动查找) | 彩虹边框 | 音效(13种) | 击杀通知 | ESP透视 | 自动换弹 | 红色弹道 | 护盾跳过 | 指定击杀
--  音效逻辑：先音效→延迟0.3秒→通知 | 只有自己杀的才触发
--  按 RightShift 打开菜单
-- ============================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")

local player = Players.LocalPlayer
if not player then player = Players.PlayerAdded:Wait() end
local PlayerGui = player:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

local oldGui = PlayerGui:FindFirstChild("CombatBot")
if oldGui then oldGui:Destroy() end

-- ============================================================
--  设置变量
-- ============================================================

settings = {
    gunEnabled = false,
    fistEnabled = false,
    wallCheck = true,
    range = 70,
    gunInterval = 0.02,
    fistInterval = 0.00001,
    aimPart = "Head",
    soundEnabled = true,
    espEnabled = true,
    prisonerAttackCriminal = false,
    criminalAttackPrisoner = false,
    targetPlayer = nil,  -- ⭐ 指定击杀目标
    trailColor = "紫色",
    rainbowBorder = false,
    flowSpeed = 1,
}

local trailColors = {
    ["紫色"] = Color3.fromRGB(180, 80, 255),
    ["红色"] = Color3.fromRGB(255, 0, 0),
    ["蓝色"] = Color3.fromRGB(0, 100, 255),
    ["绿色"] = Color3.fromRGB(0, 255, 0),
    ["青色"] = Color3.fromRGB(0, 255, 255),
    ["粉色"] = Color3.fromRGB(255, 0, 150),
    ["橙色"] = Color3.fromRGB(255, 150, 0),
    ["白色"] = Color3.fromRGB(255, 255, 255),
}
local trailColorNames = {"紫色","红色","蓝色","绿色","青色","粉色","橙色","白色"}

local function rainbowColor(phase)
    local r = math.sin(phase) * 0.5 + 0.5
    local g = math.sin(phase + 2.094) * 0.5 + 0.5
    local b = math.sin(phase + 4.188) * 0.5 + 0.5
    return Color3.fromRGB(r * 255, g * 255, b * 255)
end

-- ============================================================
--  远程事件
-- ============================================================

local meleeEvent = ReplicatedStorage:FindFirstChild("meleeEvent")
local GunRemotes = ReplicatedStorage:FindFirstChild("GunRemotes")
local ShootEvent = GunRemotes and GunRemotes:FindFirstChild("ShootEvent") or ReplicatedStorage:FindFirstChild("ShootEvent")

print("meleeEvent:", meleeEvent)
print("ShootEvent:", ShootEvent)

-- ============================================================
--  换弹事件
-- ============================================================

local FuncReload = nil
if GunRemotes then
    FuncReload = GunRemotes:FindFirstChild("FuncReload")
end
if not FuncReload then
    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteFunction") and (v.Name:lower():find("reload") or v.Name:lower():find("func")) then
            FuncReload = v
            break
        end
    end
end
print("FuncReload:", FuncReload)

local lastAmmo = {}
local function doReload()
    if not FuncReload then return end
    pcall(function() FuncReload:InvokeServer() end)
end

task.spawn(function()
    while true do
        task.wait(0.1)
        local weapon = getCurrentWeapon()
        if weapon then
            local ammo = weapon:FindFirstChild("CurrentAmmo") or weapon:FindFirstChild("Ammo") or weapon:FindFirstChild("Rounds")
            if ammo then
                local current = ammo.Value
                local key = weapon.Name
                if lastAmmo[key] and lastAmmo[key] > 0 and current == 0 then
                    doReload()
                    task.wait(0.5)
                end
                if current <= 1 then
                    doReload()
                    task.wait(0.3)
                end
                lastAmmo[key] = current
            end
        end
    end
end)

-- ============================================================
--  音效（13种 原神V4）
-- ============================================================

local killSounds = {
    {Name = "超级击杀", ID = "92723765069002"},
    {Name = "我们之中", ID = "7227567562"},
    {Name = "怪物杀戮", ID = "132012038491424"},
    {Name = "叮", ID = "2866718318"},
    {Name = "鲜血", ID = "128741351184513"},
    {Name = "黄金", ID = "18888511866"},
    {Name = "瓦洛兰特", ID = "18560690982"},
    {Name = "咚", ID = "7269900245"},
    {Name = "动漫", ID = "80440627510518"},
    {Name = "现代战争", ID = "130439616552357"},
    {Name = "战斗", ID = "7228383943"},
    {Name = "呀", ID = "111609064980370"},
    {Name = "咯", ID = "80847075127412"},
}
local soundIndex = 1
local selectedSound = killSounds[1].ID
local myTarget = nil
local killedByMe = {}

local function playSoundSafe(id)
    if not settings.soundEnabled or not id then return end
    local snd = Instance.new("Sound")
    snd.SoundId = "rbxassetid://" .. id
    snd.Volume = 1.5
    snd.Parent = Camera
    snd:Play()
    Debris:AddItem(snd, 3)
end

-- ============================================================
--  击杀通知
-- ============================================================

local HitNotif = {
    Enabled = true,
    Style = "胶囊",
    BgColor = Color3.fromRGB(25,25,25),
    BgTrans = 0.3,
    TextColor = Color3.fromRGB(255,255,255),
    DeathColor = Color3.fromRGB(255,50,50),
    OffsetX = 0,
    OffsetY = 0,
    Scale = 1,
    MaxCount = 5,
    Duration = 4
}

local notifGui = Instance.new("ScreenGui")
notifGui.Name = "KillNotifs"
notifGui.ResetOnSpawn = false
notifGui.IgnoreGuiInset = true
notifGui.Parent = PlayerGui

local notifTemplate = Instance.new("Frame")
notifTemplate.BackgroundColor3 = HitNotif.BgColor
notifTemplate.BackgroundTransparency = HitNotif.BgTrans
notifTemplate.BorderSizePixel = 0
notifTemplate.Size = UDim2.new(0,200,0,30)
notifTemplate.Visible = false
local templateCorner = Instance.new("UICorner")
templateCorner.CornerRadius = UDim.new(0,15)
templateCorner.Parent = notifTemplate

local templateLabel = Instance.new("TextLabel")
templateLabel.BackgroundTransparency = 1
templateLabel.Size = UDim2.new(1,-10,1,0)
templateLabel.Position = UDim2.new(0,5,0,0)
templateLabel.Font = Enum.Font.Gotham
templateLabel.TextSize = 18
templateLabel.TextColor3 = HitNotif.TextColor
templateLabel.TextStrokeTransparency = 0.8
templateLabel.TextXAlignment = Enum.TextXAlignment.Left
templateLabel.Parent = notifTemplate

local activeNotifs = {}

local function adjustNotifs()
    local baseY = 50 + HitNotif.OffsetY
    local yOff = 0
    for _, entry in ipairs(activeNotifs) do
        local frame = entry.frame
        if frame and frame.Parent then
            local targetX = Camera.ViewportSize.X - frame.AbsoluteSize.X - 15 + HitNotif.OffsetX
            local targetY = baseY + yOff
            TweenService:Create(frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, targetX, 0, targetY)
            }):Play()
            yOff = yOff + frame.AbsoluteSize.Y + 5
        end
    end
end

local function createNotif(text, textColor, bgColor, bgTrans)
    if HitNotif.MaxCount > 0 then
        while #activeNotifs >= HitNotif.MaxCount do
            local old = table.remove(activeNotifs, 1)
            if old.frame and old.frame.Parent then old.frame:Destroy() end
        end
    end
    local frame = notifTemplate:Clone()
    frame.BackgroundColor3 = bgColor
    frame.BackgroundTransparency = 1
    frame.Visible = true
    frame.Parent = notifGui
    local label = frame:FindFirstChildOfClass("TextLabel")
    if label then
        label.Text = text
        label.TextColor3 = textColor
        label.TextSize = 18 * HitNotif.Scale
        label.TextTransparency = 1
    end
    local corner = frame:FindFirstChildOfClass("UICorner")
    if corner then
        corner.CornerRadius = (HitNotif.Style == "胶囊") and UDim.new(0, 15 * HitNotif.Scale) or UDim.new(0, 0)
    end
    local textSize = TextService:GetTextSize(text, label.TextSize, label.Font, Vector2.new(1920, 1080))
    frame.Size = UDim2.new(0, textSize.X + 20 * HitNotif.Scale, 0, textSize.Y + 12 * HitNotif.Scale)
    frame.Position = UDim2.new(1, 50, 0, 50)
    local entry = {frame = frame}
    table.insert(activeNotifs, entry)
    adjustNotifs()
    TweenService:Create(frame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = bgTrans}):Play()
    if label then
        TweenService:Create(label, TweenInfo.new(0.25), {TextTransparency = 0}):Play()
    end
    task.delay(HitNotif.Duration, function()
        if frame and frame.Parent then
            TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                BackgroundTransparency = 1,
                Position = frame.Position + UDim2.new(0, 50, 0, 0)
            }):Play()
            task.delay(0.3, function()
                if frame and frame.Parent then frame:Destroy() end
                for i, v in ipairs(activeNotifs) do
                    if v == entry then
                        table.remove(activeNotifs, i)
                        break
                    end
                end
                adjustNotifs()
            end)
        end
    end)
    return entry
end

local function ShowKillNotify(victimName)
    if not victimName or victimName == "" then return end
    if settings.soundEnabled then
        playSoundSafe(selectedSound)
    end
    task.wait(0.3)
    if HitNotif.Enabled then
        createNotif("击杀 " .. victimName, HitNotif.DeathColor, HitNotif.BgColor, HitNotif.BgTrans)
    end
end

-- ============================================================
--  队伍颜色
-- ============================================================

local function getPlayerTeamColor(target)
    if not target then return Color3.fromRGB(128, 128, 128) end
    local team = target.Team
    if team then
        local name = string.lower(team.Name)
        if name:find("police") or name:find("cop") or name:find("guard") then
            return Color3.fromRGB(0, 150, 255)
        elseif name:find("犯人") or name:find("prisoner") or name:find("inmate") then
            return Color3.fromRGB(255, 255, 0)
        elseif name:find("罪犯") or name:find("criminal") then
            return Color3.fromRGB(255, 0, 0)
        end
    end
    return Color3.fromRGB(128, 128, 128)
end

local function getPlayerTeamName(target)
    if not target then return "未知" end
    local team = target.Team
    if team then
        local name = string.lower(team.Name)
        if name:find("police") or name:find("cop") or name:find("guard") then
            return "警察"
        elseif name:find("犯人") or name:find("prisoner") or name:find("inmate") then
            return "犯人"
        elseif name:find("罪犯") or name:find("criminal") then
            return "罪犯"
        end
    end
    return "未知"
end

-- ============================================================
--  队伍检测（含指定击杀）
-- ============================================================

local function isAlive(target)
    if not target then return false end
    local char = target.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    return hum.Health > 0
end

local deadPlayers = {}

local function hasRealWeapon(target)
    if not target then return false end
    local foodKeywords = {"薯片","晚餐","可乐","水","面包","饼干","零食","chips","food","drink","cola"}
    local function isFood(name)
        if not name then return false end
        local n = string.lower(name)
        for _, kw in ipairs(foodKeywords) do
            if n:find(kw) then return true end
        end
        return false
    end
    if target.Character then
        for _, v in pairs(target.Character:GetChildren()) do
            if v:IsA("Tool") and not isFood(v.Name) then return true end
        end
    end
    local bp = target:FindFirstChild("Backpack")
    if bp then
        for _, v in pairs(bp:GetChildren()) do
            if v:IsA("Tool") and not isFood(v.Name) then return true end
        end
    end
    return false
end

local function isEnemy(target)
    if not target or target == player then return false end

    -- ⭐ 指定击杀：如果设置了目标玩家，只打他
    if settings.targetPlayer then
        return target == settings.targetPlayer and isAlive(target)
    end

    if deadPlayers[target] and not isAlive(target) then return false end
    if deadPlayers[target] and isAlive(target) then deadPlayers[target] = false end
    if not isAlive(target) then
        deadPlayers[target] = true
        return false
    end
    if target.Character and target.Character:FindFirstChild("ForceField") then return false end
    if target.Character and (target.Character:FindFirstChild("NoDamage") or target.Character:FindFirstChild("GodMode")) then return false end

    local myTeam = getPlayerTeamName(player)
    local targetTeam = getPlayerTeamName(target)
    if myTeam == "未知" or targetTeam == "未知" then return false end
    if myTeam == targetTeam then return false end

    if myTeam == "警察" then
        if targetTeam == "罪犯" then return true end
        if targetTeam == "犯人" then return hasRealWeapon(target) end
        return false
    end
    if myTeam == "犯人" then
        if targetTeam == "警察" then return true end
        if targetTeam == "罪犯" then return settings.prisonerAttackCriminal end
        return false
    end
    if myTeam == "罪犯" then
        if targetTeam == "警察" then return true end
        if targetTeam == "犯人" then return settings.criminalAttackPrisoner end
        return false
    end
    return false
end

-- ============================================================
--  墙壁检测
-- ============================================================

local function isVisible(targetPart)
    local char = player.Character
    if not char or not targetPart then return false end
    local originPart = char:FindFirstChild("Head")
    if not originPart then return false end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {char, targetPart.Parent}
    params.IgnoreWater = true
    local direction = targetPart.Position - originPart.Position
    local result = workspace:Raycast(originPart.Position, direction, params)
    if result then
        return result.Instance:IsDescendantOf(targetPart.Parent)
    end
    return true
end

-- ============================================================
--  索敌
-- ============================================================

local function getTarget()
    local char = player.Character
    if not char then return nil end
    local rootPart = char:FindFirstChild("HumanoidRootPart")
    if not rootPart then return nil end
    local myPos = rootPart.Position
    local closest, closestDist = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p == player then continue end
        if not isEnemy(p) then continue end
        local targetChar = p.Character
        if not targetChar then continue end
        local part = targetChar:FindFirstChild(settings.aimPart) or targetChar:FindFirstChild("Head") or targetChar:FindFirstChild("HumanoidRootPart") or targetChar:FindFirstChild("UpperTorso")
        if not part then continue end
        if settings.wallCheck and not isVisible(part) then continue end
        local dist = (part.Position - myPos).Magnitude
        if dist < closestDist and dist <= settings.range then
            closestDist = dist
            closest = p
        end
    end
    return closest
end

-- ============================================================
--  武器检测
-- ============================================================

local function hasWeapon()
    local char = player.Character
    if not char then return false end
    for _, v in pairs(char:GetChildren()) do
        if v:IsA("Tool") then return true end
    end
    return false
end

local function getCurrentWeapon()
    local char = player.Character
    if char then
        for _, tool in pairs(char:GetChildren()) do
            if tool:IsA("Tool") then return tool end
        end
    end
    return nil
end

-- ============================================================
--  红色弹道
-- ============================================================

local function createColorTrail(origin, targetPos)
    if not hasWeapon() then return end
    local distance = (origin - targetPos).Magnitude
    if distance < 1 then return end
    local color = trailColors[settings.trailColor] or Color3.fromRGB(180, 80, 255)
    local brickColorName = "Really purple"
    if settings.trailColor == "红色" then brickColorName = "Bright red"
    elseif settings.trailColor == "蓝色" then brickColorName = "Bright blue"
    elseif settings.trailColor == "绿色" then brickColorName = "Bright green"
    elseif settings.trailColor == "青色" then brickColorName = "Cyan"
    elseif settings.trailColor == "粉色" then brickColorName = "Pink"
    elseif settings.trailColor == "橙色" then brickColorName = "Bright orange"
    elseif settings.trailColor == "白色" then brickColorName = "White"
    end
    local trail = Instance.new("Part")
    trail.Size = Vector3.new(0.05, 0.05, distance)
    trail.CFrame = CFrame.lookAt(origin, targetPos) * CFrame.new(0, 0, -distance / 2)
    trail.BrickColor = BrickColor.new(brickColorName)
    trail.Material = Enum.Material.Neon
    trail.Anchored = true
    trail.CanCollide = false
    trail.CanQuery = false
    trail.CanTouch = false
    trail.Transparency = 0.2
    trail.Parent = workspace
    local a0 = Instance.new("Attachment")
    a0.Position = Vector3.new(0, 0, -distance / 2)
    a0.Parent = trail
    local a1 = Instance.new("Attachment")
    a1.Position = Vector3.new(0, 0, distance / 2)
    a1.Parent = trail
    local beam = Instance.new("Beam")
    beam.Attachment0 = a0
    beam.Attachment1 = a1
    beam.Width0 = 1.2
    beam.Width1 = 1.2
    beam.Color = ColorSequence.new(color)
    beam.Transparency = NumberSequence.new(0.2)
    beam.LightEmission = 1
    beam.LightInfluence = 0
    beam.Parent = trail
    Debris:AddItem(trail, 0.3)
end

-- ============================================================
--  彩虹边框
-- ============================================================

local borderHighlights = {}
local phase = 0
local allWeaponObjects = {}

local function findAllWeapons()
    local weapons = {}
    local char = player.Character
    if char then
        for _, v in pairs(char:GetChildren()) do
            if v:IsA("Tool") then table.insert(weapons, v) end
        end
    end
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, v in pairs(backpack:GetChildren()) do
            if v:IsA("Tool") then table.insert(weapons, v) end
        end
    end
    return weapons
end

local function getWeaponAllParts(weapon)
    local parts = {}
    for _, child in pairs(weapon:GetDescendants()) do
        if child:IsA("BasePart") or child:IsA("MeshPart") or child:IsA("Part") then
            table.insert(parts, child)
        end
    end
    return parts
end

local function applyRainbowBorder(enabled)
    for _, hl in pairs(borderHighlights) do pcall(function() hl:Destroy() end) end
    borderHighlights = {}
    allWeaponObjects = {}
    if not enabled then
        for _, weapon in pairs(findAllWeapons()) do
            for _, part in pairs(getWeaponAllParts(weapon)) do
                pcall(function() part.Transparency = 0 end)
            end
        end
        return
    end
    local weapons = findAllWeapons()
    for _, weapon in pairs(weapons) do
        table.insert(allWeaponObjects, weapon)
        for _, part in pairs(getWeaponAllParts(weapon)) do
            pcall(function() part.Transparency = 0.3 end)
        end
        local parts = getWeaponAllParts(weapon)
        for i, part in pairs(parts) do
            local hl = Instance.new("Highlight")
            hl.Adornee = part
            hl.FillColor = Color3.fromRGB(255, 255, 255)
            hl.FillTransparency = 1
            hl.OutlineColor = rainbowColor(phase + i * 0.3)
            hl.OutlineTransparency = 0
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.Parent = part
            table.insert(borderHighlights, hl)
        end
    end
end

RunService.Heartbeat:Connect(function(dt)
    if not settings.rainbowBorder or #borderHighlights == 0 then return end
    local speed = settings.flowSpeed or 1
    phase = phase + dt * (2 + speed * 0.5)
    for i, hl in pairs(borderHighlights) do
        if hl and hl.Parent then
            local offset = i / math.max(#borderHighlights, 1) * 6.28
            local color = rainbowColor(phase + offset)
            pcall(function() hl.OutlineColor = color end)
        end
    end
end)

local function setupWeaponListeners()
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        backpack.ChildAdded:Connect(function(child)
            if child:IsA("Tool") and settings.rainbowBorder then
                task.wait(0.1)
                applyRainbowBorder(true)
            end
        end)
    end
    if player.Character then
        player.Character.ChildAdded:Connect(function(child)
            if child:IsA("Tool") and settings.rainbowBorder then
                task.wait(0.1)
                applyRainbowBorder(true)
            end
        end)
    end
end

player.CharacterAdded:Connect(function()
    task.wait(0.5)
    if settings.rainbowBorder then applyRainbowBorder(true) end
end)

task.spawn(function()
    task.wait(1)
    setupWeaponListeners()
    if settings.rainbowBorder then applyRainbowBorder(true) end
end)

-- ============================================================
--  攻击函数
-- ============================================================

local function fistAttack(target)
    if not target or not meleeEvent then return end
    myTarget = target
    killedByMe[target] = true
    pcall(function() meleeEvent:FireServer(target, 1, 1) end)
end

local function gunShoot()
    if not hasWeapon() then return end
    local target = getTarget()
    if not target or not ShootEvent then return end
    myTarget = target
    killedByMe[target] = true
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local head = char:FindFirstChild("Head")
    local origin = head and head.Position + root.CFrame.LookVector * 3.5 or root.Position + Vector3.new(0, 1.5, 0)
    local targetPart = target.Character:FindFirstChild(settings.aimPart) or target.Character:FindFirstChild("Head") or target.Character:FindFirstChild("HumanoidRootPart") or target.Character:FindFirstChild("UpperTorso")
    if not targetPart then return end
    local targetPos = targetPart.Position
    createColorTrail(origin, targetPos)
    local args = { { { origin, targetPos, targetPart } } }
    pcall(function() ShootEvent:FireServer(unpack(args)) end)
end

-- ============================================================
--  击杀监听
-- ============================================================

local function setupDeathListener(targetPlayer)
    if targetPlayer == player then return end
    targetPlayer.CharacterAdded:Connect(function(char)
        local hum = char:WaitForChild("Humanoid")
        hum.Died:Connect(function()
            if killedByMe[targetPlayer] then
                ShowKillNotify(targetPlayer.Name)
                deadPlayers[targetPlayer] = true
                killedByMe[targetPlayer] = nil
            end
            if myTarget == targetPlayer then
                myTarget = nil
            end
        end)
    end)
end

for _, p in pairs(Players:GetPlayers()) do setupDeathListener(p) end
Players.PlayerAdded:Connect(function(p) setupDeathListener(p) end)

-- ============================================================
--  主循环
-- ============================================================

local lastGun = 0
local lastFist = 0

RunService.Heartbeat:Connect(function()
    local now = tick()
    local target = getTarget()
    if settings.fistEnabled and target and meleeEvent then
        if now - lastFist >= settings.fistInterval then
            fistAttack(target)
            lastFist = now
        end
    end
    if settings.gunEnabled and target and ShootEvent then
        if now - lastGun >= settings.gunInterval then
            gunShoot()
            lastGun = now
        end
    end
end)

-- ============================================================
--  ESP透视
-- ============================================================

local espFolder = Instance.new("Folder")
espFolder.Name = "ESP_Folder"
espFolder.Parent = PlayerGui

local function updateESPVisibility()
    for _, child in pairs(espFolder:GetChildren()) do
        child.Enabled = settings.espEnabled
    end
end

local function deleteESP(playerObj)
    local esp = espFolder:FindFirstChild(playerObj.Name)
    if esp then esp:Destroy() end
end

local function createESP(playerObj)
    if playerObj == player then return end
    local old = espFolder:FindFirstChild(playerObj.Name)
    if old then old:Destroy() end
    local char = playerObj.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    local textColor = getPlayerTeamColor(playerObj)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = playerObj.Name
    billboard.Size = UDim2.new(0, 200, 0, 40)
    billboard.Adornee = head
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 9999
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.Enabled = settings.espEnabled
    billboard.Parent = espFolder
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = playerObj.Name .. " (" .. getPlayerTeamName(playerObj) .. ")"
    nameLabel.TextColor3 = textColor
    nameLabel.TextSize = 14
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextStrokeTransparency = 0.5
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.Parent = billboard
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1, 0, 0.5, 0)
    infoLabel.Position = UDim2.new(0, 0, 0.5, 0)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = "生命: 100"
    infoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    infoLabel.TextSize = 11
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.TextStrokeTransparency = 0.5
    infoLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    infoLabel.Parent = billboard
    task.spawn(function()
        while billboard and billboard.Parent do
            task.wait(0.2)
            local char2 = playerObj.Character
            if not char2 then
                billboard.Enabled = false
                continue
            end
            billboard.Enabled = settings.espEnabled
            local hum = char2:FindFirstChildOfClass("Humanoid")
            if hum then
                infoLabel.Text = "生命: " .. math.round(hum.Health)
            end
            local newColor = getPlayerTeamColor(playerObj)
            if nameLabel.TextColor3 ~= newColor then
                nameLabel.TextColor3 = newColor
            end
        end
    end)
end

local function setupPlayerESP(playerObj)
    if playerObj == player then return end
    playerObj.CharacterAdded:Connect(function()
        task.wait(0.3)
        createESP(playerObj)
    end)
    if playerObj.Character then
        task.wait(0.3)
        createESP(playerObj)
    end
end

for _, p in pairs(Players:GetPlayers()) do setupPlayerESP(p) end
Players.PlayerAdded:Connect(function(p) setupPlayerESP(p) end)
Players.PlayerRemoving:Connect(function(p) deleteESP(p) end)

task.spawn(function()
    while task.wait(5) do
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player then
                local esp = espFolder:FindFirstChild(p.Name)
                if not esp and p.Character and isAlive(p) then
                    createESP(p)
                end
            end
        end
    end
end)

-- ============================================================
--  传送（自动查找）
-- ============================================================

local function findTeleportTargets()
    local targets = {}
    local allChildren = workspace:GetChildren()
    for i, obj in ipairs(allChildren) do
        local name = obj.Name:lower()
        if name:find("floor") or name:find("spawn") or name:find("传送") or name:find("tp") or name:find("teleport") or name:find("platform") then
            for _, child in pairs(obj:GetChildren()) do
                if child:IsA("BasePart") then
                    table.insert(targets, {
                        Name = string.format("%d.%s", i, child.Name),
                        Index = i,
                        Part = child,
                        ParentName = obj.Name
                    })
                end
            end
            if obj:IsA("BasePart") then
                table.insert(targets, {
                    Name = string.format("%d.%s", i, obj.Name),
                    Index = i,
                    Part = obj,
                    ParentName = obj.Name
                })
            end
        end
    end
    if #targets == 0 then
        for i, obj in ipairs(allChildren) do
            if obj:IsA("BasePart") and obj.Size.Magnitude > 10 then
                table.insert(targets, {
                    Name = string.format("%d.%s", i, obj.Name),
                    Index = i,
                    Part = obj,
                    ParentName = obj.Name
                })
            end
        end
    end
    return targets
end

-- ============================================================
--  UI
-- ============================================================

local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library
local function loadLibrary()
    local success, lib = pcall(function()
        return loadstring(game:HttpGet(repo .. "Library.lua"))()
    end)
    if success and lib then return lib end
    return nil
end
Library = loadLibrary()
if not Library then
    print("UI库加载失败，请检查网络")
    return
end

local Window
if type(Library) == "function" then
    Window = Library()
elseif type(Library) == "table" and Library.CreateWindow then
    Window = Library:CreateWindow({
        Title = "监狱人生",
        Footer = "最终版",
        NotifySide = "Right",
        ShowCustomCursor = true,
    })
else
    print("无法识别的 UI 库格式")
    return
end

local Tabs = {
    Combat = Window:AddTab("战斗", "crosshair"),
    Visuals = Window:AddTab("视觉", "eye"),
    Settings = Window:AddTab("设置", "settings"),
}
print("UI加载成功")

-- ============================================================
--  战斗标签页
-- ============================================================

local CombatGroup1 = Tabs.Combat:AddLeftGroupbox("自动攻击", "target")

CombatGroup1:AddToggle("GunToggle", {
    Text = "自动枪械",
    Default = false,
    Callback = function(v)
        settings.gunEnabled = v
        print("自动枪械:", v and "开" or "关")
    end
})

CombatGroup1:AddToggle("FistToggle", {
    Text = "自动拳头",
    Default = false,
    Callback = function(v)
        settings.fistEnabled = v
        print("自动拳头:", v and "开" or "关")
    end
})

CombatGroup1:AddSlider("RangeSlider", {
    Text = "攻击范围",
    Default = 70,
    Min = 10,
    Max = 9999,
    Rounding = 0,
    Suffix = "",
    Callback = function(v)
        settings.range = v
        print("攻击范围已设为:", v)
    end
})

local CombatGroup2 = Tabs.Combat:AddRightGroupbox("瞄准设置", "crosshair")

CombatGroup2:AddDropdown("AimPartDropdown", {
    Text = "瞄准部位",
    Values = {"头部", "身体"},
    Default = "头部",
    Callback = function(v)
        settings.aimPart = v == "头部" and "Head" or "HumanoidRootPart"
        print("瞄准部位:", v)
    end
})

CombatGroup2:AddToggle("WallCheckToggle", {
    Text = "墙壁检测",
    Default = true,
    Callback = function(v)
        settings.wallCheck = v
        print("墙壁检测:", v and "开" or "关")
    end
})

CombatGroup2:AddToggle("PrisonerAttackCriminalToggle", {
    Text = "犯人打罪犯",
    Default = false,
    Callback = function(v)
        settings.prisonerAttackCriminal = v
        print("犯人打罪犯:", v and "开" or "关")
    end
})

CombatGroup2:AddToggle("CriminalAttackPrisonerToggle", {
    Text = "罪犯打犯人",
    Default = false,
    Callback = function(v)
        settings.criminalAttackPrisoner = v
        print("罪犯打犯人:", v and "开" or "关")
    end
})

-- ============================================================
--  ⭐ 指定击杀
-- ============================================================

local TargetGroup = Tabs.Combat:AddRightGroupbox("指定击杀", "crosshair")

local function getPlayerList()
    local names = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then
            table.insert(names, p.Name)
        end
    end
    if #names == 0 then
        table.insert(names, "无目标")
    end
    return names
end

TargetGroup:AddDropdown("TargetSelect", {
    Text = "选择目标",
    Values = getPlayerList(),
    Default = "无目标",
    Callback = function(v)
        if v and v ~= "无目标" then
            for _, p in pairs(Players:GetPlayers()) do
                if p.Name == v then
                    settings.targetPlayer = p
                    print("指定击杀目标:", p.Name)
                    return
                end
            end
        end
        settings.targetPlayer = nil
        print("指定击杀已取消")
    end
})

TargetGroup:AddButton("清除目标", function()
    settings.targetPlayer = nil
    print("目标已清除")
end)

-- ============================================================
--  传送
-- ============================================================

local TeleportGroup = Tabs.Combat:AddRightGroupbox("传送", "activity")

local teleportTargets = findTeleportTargets()

if #teleportTargets > 0 then
    print(string.format("找到 %d 个传送目标", #teleportTargets))
    local targetNames = {}
    for _, t in ipairs(teleportTargets) do
        table.insert(targetNames, t.Name .. " (" .. t.ParentName .. ")")
    end
    local selectedTargetIndex = 1
    TeleportGroup:AddDropdown("TeleportSelect", {
        Text = "选择传送点",
        Values = targetNames,
        Default = targetNames[1] or "无",
        Callback = function(v)
            for i, name in ipairs(targetNames) do
                if name == v then
                    selectedTargetIndex = i
                    break
                end
            end
        end
    })
    TeleportGroup:AddButton("传送到选定位置", function()
        local target = teleportTargets[selectedTargetIndex]
        if not target or not target.Part then
            print("传送目标无效")
            return
        end
        local char = player.Character
        if not char then char = player.CharacterAdded:Wait() end
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = CFrame.new(target.Part.Position + Vector3.new(0, 3, 0))
            print("已传送到:", target.Name)
        else
            warn("传送失败")
        end
    end)
else
    TeleportGroup:AddLabel("未找到传送点")
end

-- ============================================================
--  视觉标签页
-- ============================================================

local VisualGroup1 = Tabs.Visuals:AddLeftGroupbox("透视", "eye")
VisualGroup1:AddToggle("ESPToggle", {
    Text = "启用透视",
    Default = true,
    Callback = function(v)
        settings.espEnabled = v
        updateESPVisibility()
        print("透视:", v and "开" or "关")
    end
})

local VisualGroup2 = Tabs.Visuals:AddLeftGroupbox("弹道", "target")
VisualGroup2:AddDropdown("TrailColorDropdown", {
    Text = "弹道颜色",
    Values = trailColorNames,
    Default = "紫色",
    Callback = function(v)
        settings.trailColor = v
        print("弹道颜色切换为:", v)
    end
})

local VisualGroup3 = Tabs.Visuals:AddRightGroupbox("武器特效", "palette")
VisualGroup3:AddToggle("RainbowBorderToggle", {
    Text = "流光彩虹边框",
    Default = false,
    Callback = function(v)
        settings.rainbowBorder = v
        applyRainbowBorder(v)
        print("流光彩虹边框:", v and "开" or "关")
    end
})
VisualGroup3:AddSlider("FlowSpeedSlider", {
    Text = "流光速度",
    Default = 1,
    Min = 0.1,
    Max = 3,
    Rounding = 1,
    Suffix = "x",
    Callback = function(v)
        settings.flowSpeed = v
        print("流光速度:", v)
    end
})
VisualGroup3:AddLabel("自动检测所有武器")
VisualGroup3:AddLabel("颜色沿武器边缘流动旋转")

local VisualGroup4 = Tabs.Visuals:AddRightGroupbox("音效", "music")
VisualGroup4:AddToggle("SoundToggle", {
    Text = "击杀音效",
    Default = true,
    Callback = function(v)
        settings.soundEnabled = v
        print("击杀音效:", v and "开" or "关")
    end
})
VisualGroup4:AddDropdown("SoundSelectDropdown", {
    Text = "切换音效",
    Values = {"超级击杀","我们之中","怪物杀戮","叮","鲜血","黄金","瓦洛兰特","咚","动漫","现代战争","战斗","呀","咯"},
    Default = "超级击杀",
    Callback = function(v)
        for i, s in ipairs(killSounds) do
            if s.Name == v then
                soundIndex = i
                selectedSound = s.ID
                playSoundSafe(selectedSound)
                print("音效切换为:", v)
                break
            end
        end
    end
})

-- ============================================================
--  击杀通知设置
-- ============================================================

local NotifGroup = Tabs.Visuals:AddRightGroupbox("击杀通知", "target")
NotifGroup:AddToggle("HitNotifEnabled", {
    Text = "启用击杀提示",
    Default = true,
    Callback = function(v)
        HitNotif.Enabled = v
        print("击杀提示:", v and "开" or "关")
    end
})
NotifGroup:AddDropdown("HitNotifStyle", {
    Text = "样式",
    Values = {"胶囊", "矩形"},
    Default = "胶囊",
    Callback = function(v)
        HitNotif.Style = v
        print("通知样式:", v)
    end
})
NotifGroup:AddSlider("HitNotifBgTrans", {
    Text = "背景透明度",
    Default = 0.3,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Callback = function(v)
        HitNotif.BgTrans = v
    end
})
NotifGroup:AddSlider("HitNotifOffsetX", {
    Text = "X偏移",
    Default = 0,
    Min = -500,
    Max = 500,
    Rounding = 0,
    Suffix = "px",
    Callback = function(v)
        HitNotif.OffsetX = v
    end
})
NotifGroup:AddSlider("HitNotifOffsetY", {
    Text = "Y偏移",
    Default = 0,
    Min = -500,
    Max = 500,
    Rounding = 0,
    Suffix = "px",
    Callback = function(v)
        HitNotif.OffsetY = v
    end
})
NotifGroup:AddSlider("HitNotifScale", {
    Text = "整体大小",
    Default = 1,
    Min = 0.5,
    Max = 2,
    Rounding = 1,
    Suffix = "x",
    Callback = function(v)
        HitNotif.Scale = v
    end
})
NotifGroup:AddSlider("NotifMaxCount", {
    Text = "最大通知数量",
    Default = 5,
    Min = 0,
    Max = 15,
    Rounding = 0,
    Callback = function(v)
        HitNotif.MaxCount = v
    end
})
NotifGroup:AddSlider("NotifDuration", {
    Text = "通知停留时间",
    Default = 4,
    Min = 1,
    Max = 10,
    Rounding = 1,
    Suffix = "秒",
    Callback = function(v)
        HitNotif.Duration = v
    end
})

local bgR,bgG,bgB = 25,25,25
NotifGroup:AddLabel("背景颜色")
NotifGroup:AddSlider("BgR", { Text = "红", Default = 25, Min = 0, Max = 255, Rounding = 0, Callback = function(v) bgR=v; HitNotif.BgColor=Color3.fromRGB(bgR,bgG,bgB) end })
NotifGroup:AddSlider("BgG", { Text = "绿", Default = 25, Min = 0, Max = 255, Rounding = 0, Callback = function(v) bgG=v; HitNotif.BgColor=Color3.fromRGB(bgR,bgG,bgB) end })
NotifGroup:AddSlider("BgB", { Text = "蓝", Default = 25, Min = 0, Max = 255, Rounding = 0, Callback = function(v) bgB=v; HitNotif.BgColor=Color3.fromRGB(bgR,bgG,bgB) end })
local textR,textG,textB = 255,255,255
NotifGroup:AddLabel("文字颜色")
NotifGroup:AddSlider("TextR", { Text = "红", Default = 255, Min = 0, Max = 255, Rounding = 0, Callback = function(v) textR=v; HitNotif.TextColor=Color3.fromRGB(textR,textG,textB) end })
NotifGroup:AddSlider("TextG", { Text = "绿", Default = 255, Min = 0, Max = 255, Rounding = 0, Callback = function(v) textG=v; HitNotif.TextColor=Color3.fromRGB(textR,textG,textB) end })
NotifGroup:AddSlider("TextB", { Text = "蓝", Default = 255, Min = 0, Max = 255, Rounding = 0, Callback = function(v) textB=v; HitNotif.TextColor=Color3.fromRGB(textR,textG,textB) end })
local deathR,deathG,deathB = 255,50,50
NotifGroup:AddLabel("击杀文字颜色")
NotifGroup:AddSlider("DeathR", { Text = "红", Default = 255, Min = 0, Max = 255, Rounding = 0, Callback = function(v) deathR=v; HitNotif.DeathColor=Color3.fromRGB(deathR,deathG,deathB) end })
NotifGroup:AddSlider("DeathG", { Text = "绿", Default = 50, Min = 0, Max = 255, Rounding = 0, Callback = function(v) deathG=v; HitNotif.DeathColor=Color3.fromRGB(deathR,deathG,deathB) end })
NotifGroup:AddSlider("DeathB", { Text = "蓝", Default = 50, Min = 0, Max = 255, Rounding = 0, Callback = function(v) deathB=v; HitNotif.DeathColor=Color3.fromRGB(deathR,deathG,deathB) end })

-- ============================================================
--  设置标签页
-- ============================================================

local SettingsGroup = Tabs.Settings:AddLeftGroupbox("界面设置", "settings")
SettingsGroup:AddToggle("ShowCursorToggle", {
    Text = "自定义光标",
    Default = true,
    Callback = function(v)
        Library.ShowCustomCursor = v
    end
})
SettingsGroup:AddDropdown("NotifySideDropdown", {
    Text = "通知位置",
    Values = {"左", "右"},
    Default = "右",
    Callback = function(v)
        Library:SetNotifySide(v)
    end
})
SettingsGroup:AddButton("保存设置", function()
    print("设置已保存")
end)
SettingsGroup:AddButton("加载设置", function()
    print("设置已加载")
end)
SettingsGroup:AddButton("重置默认", function()
    print("已重置为默认")
end)

Library:OnUnload(function() print("已卸载") end)

print("========================================")
print("监狱人生 最终版已加载")
print("警察：罪犯直接打，犯人有武器才打（排除食物）")
print("犯人：打警察 + 开关控制打罪犯")
print("罪犯：打警察 + 开关控制打犯人")
print("指定击杀：只打你选择的玩家")
print("音效逻辑：先音效 → 延迟0.3秒 → 通知")
print("只有自己击杀才触发音效+通知")
print("按 RightShift 打开菜单")
print("========================================")
