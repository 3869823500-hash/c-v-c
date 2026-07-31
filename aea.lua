-- ============================================================
--  多音效版（可切换音效）
-- ============================================================

local player = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")
local uis = game:GetService("UserInputService")

print("✅ 脚本开始运行")

-- ===== 不删除UI =====
local sg = player.PlayerGui:FindFirstChild("CombatUI")
if not sg then
    sg = Instance.new("ScreenGui")
    sg.Name = "CombatUI"
    sg.ResetOnSpawn = false
    sg.DisplayOrder = 99999
    sg.Parent = player:WaitForChild("PlayerGui")
    print("✅ 新UI已创建")
else
    print("✅ UI已存在，复用")
end

-- ===== 获取事件 =====
local meleeEvent = rs:FindFirstChild("meleeEvent")
local ShootEvent = rs:FindFirstChild("ShootEvent")
if not ShootEvent then
    local GunRemotes = rs:FindFirstChild("GunRemotes")
    if GunRemotes then
        ShootEvent = GunRemotes:FindFirstChild("ShootEvent")
    end
end

-- ===== 参数 =====
local fistOn = false
local gunOn = false
local espOn = true
local wallOn = true
local rainbowOn = true
local soundOn = true
local range = 70
local lastFist = 0
local lastGun = 0
local lastSound = 0
local playedSound = {}

-- ============================================================
--  🔊 多个音效（随便切换）
-- ============================================================

local soundList = {
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

local selectedSound = soundList[1]
local soundIndex = 1

local function playSound(id)
    if not soundOn or not id then return end
    local snd = Instance.new("Sound")
    snd.SoundId = "rbxassetid://" .. id
    snd.Volume = 1
    snd.Parent = workspace.CurrentCamera
    snd:Play()
    task.delay(2, function() if snd then snd:Destroy() end end)
end

-- ============================================================
--  🎯 阵营检测
-- ============================================================

local function getTeam(target)
    if not target then return "unknown"
    local team = target.Team
    if team then
        local name = string.lower(team.Name)
        if name:find("police") or name:find("cop") or name:find("guard") then return "警察"
        if name:find("prisoner") or name:find("inmate") then return "囚犯"
        if name:find("criminal") or name:find("犯人") then return "犯人"
    end
    return "unknown"
end

local function isEnemy(target)
    if target == player then return false end
    local my = getTeam(player)
    local their = getTeam(target)
    if my == "unknown" or their == "unknown" then return false end
    if my == "警察" then return their == "囚犯" or their == "犯人" end
    if my == "囚犯" or my == "犯人" then return their == "警察" end
    return false
end

-- ============================================================
--  🧱 墙壁检测
-- ============================================================

local function isVisible(targetPart)
    if not wallOn then return true end
    local char = player.Character
    if not char or not targetPart then return false end
    local origin = char:FindFirstChild("Head")
    if not origin then return false end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {char}
    params.IgnoreWater = true
    local direction = targetPart.Position - origin.Position
    local result = workspace:Raycast(origin.Position, direction, params)
    if result then
        return result.Instance:IsDescendantOf(targetPart.Parent)
    end
    return true
end

-- ============================================================
--  🔫 检测是否拿枪
-- ============================================================

local function hasWeapon()
    local char = player.Character
    if not char then return false end
    for _, v in pairs(char:GetChildren()) do
        if v:IsA("Tool") then return true end
    end
    return false
end

-- ============================================================
--  🎯 获取目标
-- ============================================================

local function getTarget()
    local closest, closestDist = nil, math.huge
    local cam = workspace.CurrentCamera
    for _, p in pairs(game.Players:GetPlayers()) do
        if isEnemy(p) then
            local char = p.Character
            if char then
                local part = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
                if part then
                    if not isVisible(part) then continue end
                    local dist = (part.Position - cam.CFrame.Position).Magnitude
                    if dist < closestDist and dist <= range then
                        closest = p
                        closestDist = dist
                    end
                end
            end
        end
    end
    return closest
end

-- ============================================================
--  🔴 红色弹道
-- ============================================================

local function createRedTrail(origin, targetPos)
    if not hasWeapon() then return end
    local dist = (origin - targetPos).Magnitude
    if dist < 1 then return end
    local trail = Instance.new("Part")
    trail.Size = Vector3.new(0.05, 0.05, dist)
    trail.CFrame = CFrame.lookAt(origin, targetPos) * CFrame.new(0, 0, -dist / 2)
    trail.BrickColor = BrickColor.new("Bright red")
    trail.Material = Enum.Material.Neon
    trail.Anchored = true
    trail.CanCollide = false
    trail.Transparency = 0.15
    trail.Parent = workspace
    game:GetService("Debris"):AddItem(trail, 0.3)
end

-- ============================================================
--  🔫 射击
-- ============================================================

local function shoot()
    local target = getTarget()
    if not target or not ShootEvent then return end
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local head = char:FindFirstChild("Head")
    local origin = head and head.Position + root.CFrame.LookVector * 3.5 or root.Position + Vector3.new(0, 1.5, 0)
    local targetPart = target.Character:FindFirstChild("Head") or target.Character:FindFirstChild("HumanoidRootPart")
    if not targetPart then return end
    local targetPos = targetPart.Position
    createRedTrail(origin, targetPos)
    local args = {{origin, targetPos, targetPart}}
    pcall(function() ShootEvent:FireServer(unpack(args)) end)
    -- 击杀音效
    if target then
        local now = tick()
        if now - lastSound > 0.5 then
            local charTarget = target.Character
            local isDead = false
            if not charTarget then
                isDead = true
            else
                local hum = charTarget:FindFirstChildOfClass("Humanoid")
                if not hum or hum.Health <= 0 then
                    isDead = true
                end
            end
            if isDead and not playedSound[target] then
                playSound(selectedSound.ID)
                lastSound = now
                playedSound[target] = true
                print("💀 击杀: " .. target.Name .. " 音效: " .. selectedSound.Name)
            end
        end
    end
end

-- ============================================================
--  🥊 拳头
-- ============================================================

local function fistAttack()
    local target = getTarget()
    if not target or not meleeEvent then return end
    pcall(function() meleeEvent:FireServer(target, 1, 1) end)
end

-- ============================================================
--  🔄 主循环
-- ============================================================

runService.Heartbeat:Connect(function()
    local now = tick()
    local target = getTarget()
    if fistOn and target and meleeEvent then
        if now - lastFist >= 0.00001 then
            fistAttack()
            lastFist = now
        end
    end
    if gunOn and target and ShootEvent then
        if now - lastGun >= 0.02 then
            shoot()
            lastGun = now
        end
    end
end)

-- ============================================================
--  🎨 透视头（三阵营）
-- ============================================================

local teamColors = {
    ["警察"] = Color3.fromRGB(0, 150, 255),
    ["囚犯"] = Color3.fromRGB(255, 165, 0),
    ["犯人"] = Color3.fromRGB(255, 0, 0),
    ["unknown"] = Color3.fromRGB(128, 128, 128),
}
local tags = {}

local function createESP(plr)
    if tags[plr] then pcall(function() tags[plr]:Destroy() end); tags[plr] = nil end
    if not espOn then return end
    local char = plr.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    local team = getTeam(plr)
    local color = teamColors[team] or Color3.fromRGB(128, 128, 128)
    local gui = Instance.new("BillboardGui")
    gui.Name = "TeamESP"
    gui.Size = UDim2.new(0, 50, 0, 16)
    gui.Adornee = head
    gui.AlwaysOnTop = true
    gui.StudsOffset = Vector3.new(0, 2.5, 0)
    gui.MaxDistance = 150
    gui.Parent = head
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 0.35
    bg.BorderSizePixel = 0
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 3)
    bg.Parent = gui
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = team
    label.TextColor3 = color
    label.TextSize = 10
    label.Font = Enum.Font.Gotham
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.TextStrokeTransparency = 0.2
    label.Parent = gui
    tags[plr] = gui
end

local function updateESP()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player then
            if espOn then createESP(p) else if tags[p] then pcall(function() tags[p]:Destroy() end); tags[p] = nil end end
        end
    end
end

game.Players.PlayerAdded:Connect(updateESP)
game.Players.PlayerRemoving:Connect(function(p) if tags[p] then pcall(function() tags[p]:Destroy() end); tags[p] = nil end end)
player.CharacterAdded:Connect(updateESP)
runService.Heartbeat:Connect(function()
    if espOn then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player and not tags[p] then createESP(p) end
        end
    end
end)

-- ============================================================
--  🌈 彩虹美化
-- ============================================================

local rainbowColors = {
    Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 165, 0), Color3.fromRGB(255, 255, 0),
    Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 255, 255), Color3.fromRGB(0, 0, 255),
    Color3.fromRGB(255, 0, 255), Color3.fromRGB(255, 20, 147),
}
local originalColors = {}
local originalMaterials = {}
local originalTransparency = {}

local function getWeaponParts()
    local parts = {}
    local char = player.Character
    if not char then return parts end
    for _, tool in pairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            for _, child in pairs(tool:GetDescendants()) do
                if child:IsA("BasePart") or child:IsA("MeshPart") or child:IsA("Part") then
                    table.insert(parts, child)
                end
            end
        end
    end
    return parts
end

local function applyRainbow()
    if not rainbowOn then return end
    local parts = getWeaponParts()
    if #parts == 0 then return end
    for _, part in pairs(parts) do
        if not originalColors[part] then
            originalColors[part] = part.Color
            originalMaterials[part] = part.Material
            originalTransparency[part] = part.Transparency
        end
        local color = rainbowColors[math.random(1, #rainbowColors)]
        pcall(function()
            part.Color = color
            part.Material = Enum.Material.Neon
            part.Transparency = 0.3
        end)
    end
end

local function restoreWeaponColors()
    for part, color in pairs(originalColors) do
        pcall(function()
            part.Color = color
            part.Material = originalMaterials[part] or Enum.Material.Plastic
            part.Transparency = originalTransparency[part] or 0
        end)
    end
    table.clear(originalColors)
    table.clear(originalMaterials)
    table.clear(originalTransparency)
end

runService.Heartbeat:Connect(function()
    applyRainbow()
end)

-- ============================================================
--  🎨 UI
-- ============================================================

local f = sg:FindFirstChild("MainFrame")
if not f then
    f = Instance.new("Frame")
    f.Name = "MainFrame"
    f.Size = UDim2.new(0, 180, 0, 230)
    f.Position = UDim2.new(0.02, 0, 0.15, 0)
    f.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
    f.BackgroundTransparency = 0.1
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
    f.Parent = sg
end

local title = f:FindFirstChild("Title")
if not title then
    title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 28)
    title.BackgroundTransparency = 1
    title.Text = "⚔️ 战斗"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 14
    title.Font = Enum.Font.GothamBold
    title.Parent = f
end

local function createSwitch(y, icon, name, default, callback)
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(0, 150, 0, 28)
    bg.Position = UDim2.new(0.5, -75, 0, y)
    bg.BackgroundColor3 = default and Color3.fromRGB(60, 200, 80) or Color3.fromRGB(200, 50, 50)
    bg.BackgroundTransparency = 0.2
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 6)
    bg.Parent = f
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 70, 0, 26)
    label.Position = UDim2.new(0, 6, 0.5, -13)
    label.BackgroundTransparency = 1
    label.Text = icon .. " " .. name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 12
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = bg
    
    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(0, 16, 0, 16)
    status.Position = UDim2.new(0, 85, 0.5, -8)
    status.BackgroundTransparency = 1
    status.Text = default and "✅" or "❌"
    status.TextColor3 = default and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 80, 80)
    status.TextSize = 12
    status.Parent = bg
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 40, 0, 22)
    btn.Position = UDim2.new(1, -44, 0.5, -11)
    btn.BackgroundTransparency = 1
    btn.Text = default and "关" or "开"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.Parent = bg
    
    btn.MouseButton1Click:Connect(function()
        local state = not default
        default = state
        btn.Text = state and "关" or "开"
        bg.BackgroundColor3 = state and Color3.fromRGB(60, 200, 80) or Color3.fromRGB(200, 50, 50)
        status.Text = state and "✅" or "❌"
        status.TextColor3 = state and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 80, 80)
        callback(state)
    end)
    
    return bg
end

-- 拳头
local fistY = 36
local fistBg = Instance.new("Frame")
fistBg.Size = UDim2.new(0, 150, 0, 28)
fistBg.Position = UDim2.new(0.5, -75, 0, fistY)
fistBg.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
fistBg.BackgroundTransparency = 0.2
Instance.new("UICorner", fistBg).CornerRadius = UDim.new(0, 6)
fistBg.Parent = f

local fistLabel = Instance.new("TextLabel")
fistLabel.Size = UDim2.new(0, 70, 0, 26)
fistLabel.Position = UDim2.new(0, 6, 0.5, -13)
fistLabel.BackgroundTransparency = 1
fistLabel.Text = "🥊 拳头"
fistLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
fistLabel.TextSize = 12
fistLabel.Font = Enum.Font.GothamBold
fistLabel.TextXAlignment = Enum.TextXAlignment.Left
fistLabel.Parent = fistBg

local fistStatus = Instance.new("TextLabel")
fistStatus.Size = UDim2.new(0, 16, 0, 16)
fistStatus.Position = UDim2.new(0, 85, 0.5, -8)
fistStatus.BackgroundTransparency = 1
fistStatus.Text = "❌"
fistStatus.TextColor3 = Color3.fromRGB(255, 80, 80)
fistStatus.TextSize = 12
fistStatus.Parent = fistBg

local fistBtn = Instance.new("TextButton")
fistBtn.Size = UDim2.new(0, 40, 0, 22)
fistBtn.Position = UDim2.new(1, -44, 0.5, -11)
fistBtn.BackgroundTransparency = 1
fistBtn.Text = "开"
fistBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
fistBtn.TextSize = 11
fistBtn.Font = Enum.Font.GothamBold
fistBtn.Parent = fistBg

fistBtn.MouseButton1Click:Connect(function()
    fistOn = not fistOn
    fistBtn.Text = fistOn and "关" or "开"
    fistBg.BackgroundColor3 = fistOn and Color3.fromRGB(60, 200, 80) or Color3.fromRGB(200, 50, 50)
    fistStatus.Text = fistOn and "✅" or "❌"
    fistStatus.TextColor3 = fistOn and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 80, 80)
end)

-- 枪械
local gunY = 72
local gunBg = Instance.new("Frame")
gunBg.Size = UDim2.new(0, 150, 0, 28)
gunBg.Position = UDim2.new(0.5, -75, 0, gunY)
gunBg.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
gunBg.BackgroundTransparency = 0.2
Instance.new("UICorner", gunBg).CornerRadius = UDim.new(0, 6)
gunBg.Parent = f

local gunLabel = Instance.new("TextLabel")
gunLabel.Size = UDim2.new(0, 70, 0, 26)
gunLabel.Position = UDim2.new(0, 6, 0.5, -13)
gunLabel.BackgroundTransparency = 1
gunLabel.Text = "🔫 枪械"
gunLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
gunLabel.TextSize = 12
gunLabel.Font = Enum.Font.GothamBold
gunLabel.TextXAlignment = Enum.TextXAlignment.Left
gunLabel.Parent = gunBg

local gunStatus = Instance.new("TextLabel")
gunStatus.Size = UDim2.new(0, 16, 0, 16)
gunStatus.Position = UDim2.new(0, 85, 0.5, -8)
gunStatus.BackgroundTransparency = 1
gunStatus.Text = "❌"
gunStatus.TextColor3 = Color3.fromRGB(255, 80, 80)
gunStatus.TextSize = 12
gunStatus.Parent = gunBg

local gunBtn = Instance.new("TextButton")
gunBtn.Size = UDim2.new(0, 40, 0, 22)
gunBtn.Position = UDim2.new(1, -44, 0.5, -11)
gunBtn.BackgroundTransparency = 1
gunBtn.Text = "开"
gunBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
gunBtn.TextSize = 11
gunBtn.Font = Enum.Font.GothamBold
gunBtn.Parent = gunBg

gunBtn.MouseButton1Click:Connect(function()
    gunOn = not gunOn
    gunBtn.Text = gunOn and "关" or "开"
    gunBg.BackgroundColor3 = gunOn and Color3.fromRGB(60, 200, 80) or Color3.fromRGB(200, 50, 50)
    gunStatus.Text = gunOn and "✅" or "❌"
    gunStatus.TextColor3 = gunOn and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 80, 80)
end)

-- 透视
local espY = 108
local espBg = Instance.new("Frame")
espBg.Size = UDim2.new(0, 150, 0, 28)
espBg.Position = UDim2.new(0.5, -75, 0, espY)
espBg.BackgroundColor3 = Color3.fromRGB(60, 200, 80)
espBg.BackgroundTransparency = 0.2
Instance.new("UICorner", espBg).CornerRadius = UDim.new(0, 6)
espBg.Parent = f

local espLabel = Instance.new("TextLabel")
espLabel.Size = UDim2.new(0, 70, 0, 26)
espLabel.Position = UDim2.new(0, 6, 0.5, -13)
espLabel.BackgroundTransparency = 1
espLabel.Text = "👁️ 透视"
espLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
espLabel.TextSize = 12
espLabel.Font = Enum.Font.GothamBold
espLabel.TextXAlignment = Enum.TextXAlignment.Left
espLabel.Parent = espBg

local espStatus = Instance.new("TextLabel")
espStatus.Size = UDim2.new(0, 16, 0, 16)
espStatus.Position = UDim2.new(0, 85, 0.5, -8)
espStatus.BackgroundTransparency = 1
espStatus.Text = "✅"
espStatus.TextColor3 = Color3.fromRGB(100, 255, 100)
espStatus.TextSize = 12
espStatus.Parent = espBg

local espBtn = Instance.new("TextButton")
espBtn.Size = UDim2.new(0, 40, 0, 22)
espBtn.Position = UDim2.new(1, -44, 0.5, -11)
espBtn.BackgroundTransparency = 1
espBtn.Text = "关"
espBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
espBtn.TextSize = 11
espBtn.Font = Enum.Font.GothamBold
espBtn.Parent = espBg

espBtn.MouseButton1Click:Connect(function()
    espOn = not espOn
    espBtn.Text = espOn and "关" or "开"
    espBg.BackgroundColor3 = espOn and Color3.fromRGB(60, 200, 80) or Color3.fromRGB(200, 50, 50)
    espStatus.Text = espOn and "✅" or "❌"
    espStatus.TextColor3 = espOn and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 80, 80)
    updateESP()
end)

-- 音效切换按钮
local soundY = 144
local soundBg = Instance.new("Frame")
soundBg.Size = UDim2.new(0, 150, 0, 28)
soundBg.Position = UDim2.new(0.5, -75, 0, soundY)
soundBg.BackgroundColor3 = Color3.fromRGB(60, 200, 80)
soundBg.BackgroundTransparency = 0.2
Instance.new("UICorner", soundBg).CornerRadius = UDim.new(0, 6)
soundBg.Parent = f

local soundLabel = Instance.new("TextLabel")
soundLabel.Size = UDim2.new(0, 80, 0, 26)
soundLabel.Position = UDim2.new(0, 6, 0.5, -13)
soundLabel.BackgroundTransparency = 1
soundLabel.Text = "🔊 " .. soundList[soundIndex].Name
soundLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
soundLabel.TextSize = 11
soundLabel.Font = Enum.Font.GothamBold
soundLabel.TextXAlignment = Enum.TextXAlignment.Left
soundLabel.Parent = soundBg

local soundBtn = Instance.new("TextButton")
soundBtn.Size = UDim2.new(0, 40, 0, 22)
soundBtn.Position = UDim2.new(1, -44, 0.5, -11)
soundBtn.BackgroundTransparency = 1
soundBtn.Text = "切换"
soundBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
soundBtn.TextSize = 11
soundBtn.Font = Enum.Font.GothamBold
soundBtn.Parent = soundBg

soundBtn.MouseButton1Click:Connect(function()
    soundIndex = soundIndex % #soundList + 1
    selectedSound = soundList[soundIndex]
    soundLabel.Text = "🔊 " .. selectedSound.Name
    print("🔊 音效切换: " .. selectedSound.Name)
    -- 试听一下
    playSound(selectedSound.ID)
end)

-- 范围显示
local rangeLabel = Instance.new("TextLabel")
rangeLabel.Size = UDim2.new(1, 0, 0, 16)
rangeLabel.Position = UDim2.new(0, 0, 0, 182)
rangeLabel.BackgroundTransparency = 1
rangeLabel.Text = "📏 范围: 70"
rangeLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
rangeLabel.TextSize = 10
rangeLabel.Font = Enum.Font.Gotham
rangeLabel.Parent = f

-- 阵营显示
local teamLabel = Instance.new("TextLabel")
teamLabel.Size = UDim2.new(1, 0, 0, 16)
teamLabel.Position = UDim2.new(0, 0, 0, 198)
teamLabel.BackgroundTransparency = 1
teamLabel.Text = "👤 阵营: " .. getTeam(player)
teamLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
teamLabel.TextSize = 10
teamLabel.Font = Enum.Font.Gotham
teamLabel.Parent = f

-- ============================================================
--  🖱️ 拖动
-- ============================================================

local drag = false
local dx, dy, startPos

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        drag = true
        dx = input.Position.X
        dy = input.Position.Y
        startPos = f.Position
    end
end)

uis.InputChanged:Connect(function(input)
    if drag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        f.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + (input.Position.X - dx),
            startPos.Y.Scale,
            startPos.Y.Offset + (input.Position.Y - dy)
        )
    end
end)

uis.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        drag = false
    end
end)

task.wait(0.5)
updateESP()

print("========================================")
print("✅ 全功能版已加载！")
print("🥊 拳头 | 🔫 枪械 | 👁️ 透视 | 🔊 音效切换")
print("📌 点击音效切换按钮选择不同音效")
print("========================================")
