-- ============================================================
--  监狱人生
--  队伍颜色：警察=蓝色 | 犯人=黄色 | 罪犯=红色
--  打死后保持原颜色，不会变蓝
--  功能：枪械+拳头 | 红色弹道 | 透视 | 彩虹美化 | 墙壁检测
--  击杀音效（双重保险，每杀必播） | 不打尸体
--  罪犯打犯人 开关控制
-- ============================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local PlayerGui = player:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

local oldGui = PlayerGui:FindFirstChild("PrisonLife")
if oldGui then oldGui:Destroy() end

-- ========== 设置 ==========
local settings = {
    gunEnabled = false,
    fistEnabled = false,
    wallCheck = true,
    range = 800,
    gunInterval = 0.02,
    fistInterval = 0.00001,
    aimPart = "Head",
    rainbowEnabled = true,
    soundEnabled = true,
    espEnabled = true,
    criminalAttackPrisoner = false,  -- 罪犯打犯人开关
}

-- ========== 远程事件 ==========
local meleeEvent = ReplicatedStorage:FindFirstChild("meleeEvent")
local GunRemotes = ReplicatedStorage:FindFirstChild("GunRemotes")
local ShootEvent = GunRemotes and GunRemotes:FindFirstChild("ShootEvent") or ReplicatedStorage:FindFirstChild("ShootEvent")

print("meleeEvent:", meleeEvent)
print("ShootEvent:", ShootEvent)

-- ============================================================
--  音效
-- ============================================================

local killSounds = {
    {Name = "超级击杀", ID = "92723765069002"},
    {Name = "叮", ID = "2866718318"},
    {Name = "鲜血", ID = "128741351184513"},
    {Name = "黄金", ID = "18888511866"},
    {Name = "战斗", ID = "7228383943"},
}
local soundIndex = 1
local selectedSound = killSounds[1].ID
local playedSoundForPlayer = {}
local myTarget = nil

local function playSoundSafe(id)
    if not settings.soundEnabled or not id then return end
    local snd = Instance.new("Sound")
    snd.SoundId = "rbxassetid://" .. id
    snd.Volume = 2
    snd.Parent = Camera
    snd:Play()
    task.delay(3, function() if snd then snd:Destroy() end end)
end

-- ============================================================
--  队伍颜色（警察=蓝 | 犯人=黄 | 罪犯=红）
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
--  队伍检测（不打尸体 + 罪犯打犯人开关）
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

local function isEnemy(target)
    if not target or target == player then return false end
    if deadPlayers[target] and not isAlive(target) then return false end
    if deadPlayers[target] and isAlive(target) then deadPlayers[target] = false end
    if not isAlive(target) then
        deadPlayers[target] = true
        return false
    end
    
    local myTeam = getPlayerTeamName(player)
    local targetTeam = getPlayerTeamName(target)
    
    if myTeam == "未知" or targetTeam == "未知" then return false end
    if myTeam == targetTeam then return false end
    
    -- 警察打犯人/罪犯
    if myTeam == "警察" then
        return targetTeam == "犯人" or targetTeam == "罪犯"
    end
    
    -- 犯人打警察
    if myTeam == "犯人" then
        return targetTeam == "警察"
    end
    
    -- 罪犯打警察，打犯人取决于开关
    if myTeam == "罪犯" then
        if targetTeam == "警察" then return true end
        if targetTeam == "犯人" and settings.criminalAttackPrisoner then
            return true
        end
        return false
    end
    
    return false
end

-- 玩家复活时重置音效标记
local function resetSoundFlag(targetPlayer)
    if targetPlayer ~= player then
        playedSoundForPlayer[targetPlayer] = false
    end
end

for _, p in pairs(Players:GetPlayers()) do
    if p ~= player then
        p.CharacterAdded:Connect(function()
            resetSoundFlag(p)
        end)
    end
end

Players.PlayerAdded:Connect(function(p)
    if p ~= player then
        p.CharacterAdded:Connect(function()
            resetSoundFlag(p)
        end)
    end
end)

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
    local closest, closestDist = nil, math.huge
    local char = player.Character
    if not char then return nil end
    local rootPart = char:FindFirstChild("HumanoidRootPart")
    if not rootPart then return nil end
    local myPos = rootPart.Position

    for _, p in pairs(Players:GetPlayers()) do
        if p == player then continue end
        if not isEnemy(p) then continue end
        local targetChar = p.Character
        if not targetChar then continue end
        local part = targetChar:FindFirstChild("Head")
            or targetChar:FindFirstChild("HumanoidRootPart")
            or targetChar:FindFirstChild("UpperTorso")
        if not part then continue end
        if settings.wallCheck and not isVisible(part) then continue end
        local dist = (part.Position - myPos).Magnitude
        if dist < closestDist and dist <= settings.range then
            closest = p
            closestDist = dist
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

-- ============================================================
--  红色弹道
-- ============================================================

local function createRedTrail(origin, targetPos)
    if not hasWeapon() then return end
    local distance = (origin - targetPos).Magnitude
    if distance < 1 then return end
    local trail = Instance.new("Part")
    trail.Size = Vector3.new(0.05, 0.05, distance)
    trail.CFrame = CFrame.lookAt(origin, targetPos) * CFrame.new(0, 0, -distance / 2)
    trail.BrickColor = BrickColor.new("Bright red")
    trail.Material = Enum.Material.Neon
    trail.Anchored = true
    trail.CanCollide = false
    trail.CanQuery = false
    trail.CanTouch = false
    trail.Transparency = 0.15
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
    beam.Width0 = 0.8
    beam.Width1 = 0.8
    beam.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
    beam.Transparency = NumberSequence.new(0.05)
    beam.LightEmission = 1
    beam.LightInfluence = 0
    beam.Parent = trail
    Debris:AddItem(trail, 0.3)
end

-- ============================================================
--  拳头
-- ============================================================

local function fistAttack(target)
    if not target or not meleeEvent then return end
    myTarget = target
    pcall(function() meleeEvent:FireServer(target, 1, 1) end)
    
    task.wait(0.05)
    local charTarget = target.Character
    if charTarget then
        local hum = charTarget:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health <= 0 and not playedSoundForPlayer[target] then
            playedSoundForPlayer[target] = true
            playSoundSafe(selectedSound)
            deadPlayers[target] = true
            print("拳头击杀: " .. target.Name)
        end
    end
end

-- ============================================================
--  枪械射击 + 音效检测
-- ============================================================

local function gunShoot()
    if not hasWeapon() then return end
    local target = getTarget()
    if not target or not ShootEvent then return end
    
    myTarget = target
    
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local head = char:FindFirstChild("Head")
    local origin = head and head.Position + root.CFrame.LookVector * 3.5 or root.Position + Vector3.new(0, 1.5, 0)
    local targetPart = target.Character:FindFirstChild("Head")
        or target.Character:FindFirstChild("HumanoidRootPart")
        or target.Character:FindFirstChild("UpperTorso")
    if not targetPart then return end
    local targetPos = targetPart.Position
    createRedTrail(origin, targetPos)
    local args = { { { origin, targetPos, targetPart } } }
    pcall(function() ShootEvent:FireServer(unpack(args)) end)

    task.wait(0.03)
    local charTarget = target.Character
    if charTarget then
        local hum = charTarget:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health <= 0 and not playedSoundForPlayer[target] then
            playedSoundForPlayer[target] = true
            playSoundSafe(selectedSound)
            deadPlayers[target] = true
            print("击杀: " .. target.Name .. " " .. killSounds[soundIndex].Name)
        end
    end
end

-- ============================================================
--  Died事件备份
-- ============================================================

local function setupDeathListener(targetPlayer)
    if targetPlayer == player then return end
    
    targetPlayer.CharacterAdded:Connect(function(char)
        local hum = char:WaitForChild("Humanoid")
        hum.Died:Connect(function()
            if targetPlayer == myTarget and isEnemy(targetPlayer) then
                if not playedSoundForPlayer[targetPlayer] then
                    playedSoundForPlayer[targetPlayer] = true
                    playSoundSafe(selectedSound)
                    deadPlayers[targetPlayer] = true
                    print("Died事件击杀: " .. targetPlayer.Name)
                end
            end
            myTarget = nil
        end)
    end)
end

for _, p in pairs(Players:GetPlayers()) do
    setupDeathListener(p)
end

Players.PlayerAdded:Connect(function(p)
    setupDeathListener(p)
end)

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
--  彩虹美化
-- ============================================================

local rainbowColors = {
    Color3.fromRGB(255,0,0), Color3.fromRGB(255,165,0), Color3.fromRGB(255,255,0),
    Color3.fromRGB(0,255,0), Color3.fromRGB(0,255,255), Color3.fromRGB(0,0,255),
    Color3.fromRGB(255,0,255), Color3.fromRGB(255,20,147),
}
local originalColors, originalMaterials, originalTransparency = {}, {}, {}

local function getWeaponParts()
    local parts, char = {}, player.Character
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
    if not settings.rainbowEnabled then return end
    local parts = getWeaponParts()
    if #parts == 0 then return end
    for _, part in pairs(parts) do
        if not originalColors[part] then
            originalColors[part] = part.Color
            originalMaterials[part] = part.Material
            originalTransparency[part] = part.Transparency
        end
        pcall(function()
            part.Color = rainbowColors[math.random(1, #rainbowColors)]
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
    table.clear(originalColors); table.clear(originalMaterials); table.clear(originalTransparency)
end

local rainbowCounter = 0
RunService.Heartbeat:Connect(function(dt)
    rainbowCounter = rainbowCounter + dt
    if rainbowCounter >= 0.1 then rainbowCounter = 0; applyRainbow() end
end)

-- ============================================================
--  武器切换检测
-- ============================================================

local currentWeapon = nil
local function checkWeapon()
    local char = player.Character
    if not char then return end
    local tool = nil
    for _, v in pairs(char:GetChildren()) do
        if v:IsA("Tool") then
            tool = v
            break
        end
    end
    if tool and tool ~= currentWeapon then
        currentWeapon = tool
    end
    if not tool then currentWeapon = nil end
end

RunService.Heartbeat:Connect(checkWeapon)

player.CharacterAdded:Connect(function()
    currentWeapon = nil
    for p in pairs(deadPlayers) do
        if p ~= player then deadPlayers[p] = false end
    end
    task.wait(0.3)
    checkWeapon()
end)

-- ============================================================
--  透视（打死后保持原颜色）
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
    billboard.Size = UDim2.new(0,200,0,40)
    billboard.Adornee = head
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 9999
    billboard.StudsOffset = Vector3.new(0,2.5,0)
    billboard.Enabled = settings.espEnabled
    billboard.Parent = espFolder
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1,0,0.5,0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = playerObj.Name .. " (" .. getPlayerTeamName(playerObj) .. ")"
    nameLabel.TextColor3 = textColor
    nameLabel.TextSize = 14
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextStrokeTransparency = 0.5
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    nameLabel.Parent = billboard
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1,0,0.5,0)
    infoLabel.Position = UDim2.new(0,0,0.5,0)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = "生命: 100"
    infoLabel.TextColor3 = Color3.fromRGB(255,255,255)
    infoLabel.TextSize = 11
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.TextStrokeTransparency = 0.5
    infoLabel.TextStrokeColor3 = Color3.fromRGB(0,0,0)
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
                local health = math.round(hum.Health)
                infoLabel.Text = "生命: " .. health
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

for _, p in pairs(Players:GetPlayers()) do
    setupPlayerESP(p)
end

Players.PlayerAdded:Connect(function(p)
    setupPlayerESP(p)
end)

Players.PlayerRemoving:Connect(function(p)
    deleteESP(p)
end)

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
--  UI
-- ============================================================

local sg = Instance.new("ScreenGui")
sg.Name = "PrisonLife"
sg.ResetOnSpawn = false
sg.Parent = PlayerGui

local f = Instance.new("Frame")
f.Size = UDim2.new(0, 200, 0, 270)
f.Position = UDim2.new(0.03, 0, 0.1, 0)
f.BackgroundColor3 = Color3.fromRGB(15,15,30)
f.BackgroundTransparency = 0.15
f.BorderSizePixel = 0
Instance.new("UICorner", f).CornerRadius = UDim.new(0,12)
f.Parent = sg

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency = 1
title.Text = "监狱人生"
title.TextColor3 = Color3.fromRGB(255,50,50)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.Parent = f

local line = Instance.new("Frame")
line.Size = UDim2.new(0.9,0,0,1)
line.Position = UDim2.new(0.05,0,0,32)
line.BackgroundColor3 = Color3.fromRGB(255,50,50)
line.BackgroundTransparency = 0.5
line.Parent = f

local teamName = getPlayerTeamName(player)
local teamColor = getPlayerTeamColor(player)
local teamLabel = Instance.new("TextLabel")
teamLabel.Size = UDim2.new(1,-20,0,22)
teamLabel.Position = UDim2.new(0,10,0,38)
teamLabel.BackgroundTransparency = 1
teamLabel.Text = "阵营: " .. teamName
teamLabel.TextColor3 = teamColor
teamLabel.TextSize = 12
teamLabel.Font = Enum.Font.GothamBold
teamLabel.TextXAlignment = Enum.TextXAlignment.Left
teamLabel.Parent = f

-- 拳头
local fistStatus = Instance.new("TextLabel")
fistStatus.Size = UDim2.new(0, 60, 0, 24)
fistStatus.Position = UDim2.new(0,10,0,66)
fistStatus.BackgroundTransparency = 1
fistStatus.Text = "拳头 关"
fistStatus.TextColor3 = Color3.fromRGB(255,80,80)
fistStatus.TextSize = 13
fistStatus.Font = Enum.Font.GothamBold
fistStatus.TextXAlignment = Enum.TextXAlignment.Left
fistStatus.Parent = f
local fistBtn = Instance.new("TextButton")
fistBtn.Size = UDim2.new(0, 50, 0, 24)
fistBtn.Position = UDim2.new(1,-58,0,64)
fistBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
fistBtn.BackgroundTransparency = 0.2
fistBtn.Text = "开"
fistBtn.TextColor3 = Color3.fromRGB(255,255,255)
fistBtn.TextSize = 13
fistBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", fistBtn).CornerRadius = UDim.new(0,6)
fistBtn.Parent = f

-- 枪械
local gunStatus = Instance.new("TextLabel")
gunStatus.Size = UDim2.new(0, 60, 0, 24)
gunStatus.Position = UDim2.new(0,10,0,96)
gunStatus.BackgroundTransparency = 1
gunStatus.Text = "枪械 关"
gunStatus.TextColor3 = Color3.fromRGB(255,80,80)
gunStatus.TextSize = 13
gunStatus.Font = Enum.Font.GothamBold
gunStatus.TextXAlignment = Enum.TextXAlignment.Left
gunStatus.Parent = f
local gunBtn = Instance.new("TextButton")
gunBtn.Size = UDim2.new(0, 50, 0, 24)
gunBtn.Position = UDim2.new(1,-58,0,94)
gunBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
gunBtn.BackgroundTransparency = 0.2
gunBtn.Text = "开"
gunBtn.TextColor3 = Color3.fromRGB(255,255,255)
gunBtn.TextSize = 13
gunBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", gunBtn).CornerRadius = UDim.new(0,6)
gunBtn.Parent = f

-- 美化
local rainbowStatus = Instance.new("TextLabel")
rainbowStatus.Size = UDim2.new(0, 60, 0, 24)
rainbowStatus.Position = UDim2.new(0,10,0,126)
rainbowStatus.BackgroundTransparency = 1
rainbowStatus.Text = "美化 开"
rainbowStatus.TextColor3 = Color3.fromRGB(100,255,100)
rainbowStatus.TextSize = 13
rainbowStatus.Font = Enum.Font.GothamBold
rainbowStatus.TextXAlignment = Enum.TextXAlignment.Left
rainbowStatus.Parent = f
local rainbowBtn = Instance.new("TextButton")
rainbowBtn.Size = UDim2.new(0, 50, 0, 24)
rainbowBtn.Position = UDim2.new(1,-58,0,124)
rainbowBtn.BackgroundColor3 = Color3.fromRGB(60,200,80)
rainbowBtn.BackgroundTransparency = 0.2
rainbowBtn.Text = "关"
rainbowBtn.TextColor3 = Color3.fromRGB(255,255,255)
rainbowBtn.TextSize = 13
rainbowBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", rainbowBtn).CornerRadius = UDim.new(0,6)
rainbowBtn.Parent = f

-- 音效
local soundStatus = Instance.new("TextLabel")
soundStatus.Size = UDim2.new(0, 60, 0, 24)
soundStatus.Position = UDim2.new(0,10,0,156)
soundStatus.BackgroundTransparency = 1
soundStatus.Text = "音效 开"
soundStatus.TextColor3 = Color3.fromRGB(100,255,100)
soundStatus.TextSize = 13
soundStatus.Font = Enum.Font.GothamBold
soundStatus.TextXAlignment = Enum.TextXAlignment.Left
soundStatus.Parent = f
local soundBtn = Instance.new("TextButton")
soundBtn.Size = UDim2.new(0, 50, 0, 24)
soundBtn.Position = UDim2.new(1,-58,0,154)
soundBtn.BackgroundColor3 = Color3.fromRGB(60,200,80)
soundBtn.BackgroundTransparency = 0.2
soundBtn.Text = "关"
soundBtn.TextColor3 = Color3.fromRGB(255,255,255)
soundBtn.TextSize = 13
soundBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", soundBtn).CornerRadius = UDim.new(0,6)
soundBtn.Parent = f

-- 透视
local espStatus = Instance.new("TextLabel")
espStatus.Size = UDim2.new(0, 60, 0, 24)
espStatus.Position = UDim2.new(0,10,0,186)
espStatus.BackgroundTransparency = 1
espStatus.Text = "透视 开"
espStatus.TextColor3 = Color3.fromRGB(100,255,100)
espStatus.TextSize = 13
espStatus.Font = Enum.Font.GothamBold
espStatus.TextXAlignment = Enum.TextXAlignment.Left
espStatus.Parent = f
local espBtn = Instance.new("TextButton")
espBtn.Size = UDim2.new(0, 50, 0, 24)
espBtn.Position = UDim2.new(1,-58,0,184)
espBtn.BackgroundColor3 = Color3.fromRGB(60,200,80)
espBtn.BackgroundTransparency = 0.2
espBtn.Text = "关"
espBtn.TextColor3 = Color3.fromRGB(255,255,255)
espBtn.TextSize = 13
espBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", espBtn).CornerRadius = UDim.new(0,6)
espBtn.Parent = f

-- 罪犯打犯人开关
local criminalStatus = Instance.new("TextLabel")
criminalStatus.Size = UDim2.new(0, 100, 0, 24)
criminalStatus.Position = UDim2.new(0,10,0,216)
criminalStatus.BackgroundTransparency = 1
criminalStatus.Text = "罪犯打犯人 关"
criminalStatus.TextColor3 = Color3.fromRGB(255,80,80)
criminalStatus.TextSize = 13
criminalStatus.Font = Enum.Font.GothamBold
criminalStatus.TextXAlignment = Enum.TextXAlignment.Left
criminalStatus.Parent = f

local criminalBtn = Instance.new("TextButton")
criminalBtn.Size = UDim2.new(0, 50, 0, 24)
criminalBtn.Position = UDim2.new(1,-58,0,214)
criminalBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
criminalBtn.BackgroundTransparency = 0.2
criminalBtn.Text = "开"
criminalBtn.TextColor3 = Color3.fromRGB(255,255,255)
criminalBtn.TextSize = 13
criminalBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", criminalBtn).CornerRadius = UDim.new(0,6)
criminalBtn.Parent = f

criminalBtn.MouseButton1Click:Connect(function()
    settings.criminalAttackPrisoner = not settings.criminalAttackPrisoner
    if settings.criminalAttackPrisoner then
        criminalBtn.Text = "关"
        criminalBtn.BackgroundColor3 = Color3.fromRGB(60,200,80)
        criminalStatus.Text = "罪犯打犯人 开"
        criminalStatus.TextColor3 = Color3.fromRGB(100,255,100)
    else
        criminalBtn.Text = "开"
        criminalBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
        criminalStatus.Text = "罪犯打犯人 关"
        criminalStatus.TextColor3 = Color3.fromRGB(255,80,80)
    end
end)

-- 音效切换
local soundChangeBtn = Instance.new("TextButton")
soundChangeBtn.Size = UDim2.new(0, 80, 0, 22)
soundChangeBtn.Position = UDim2.new(0.5, -40, 0, 246)
soundChangeBtn.BackgroundColor3 = Color3.fromRGB(50,50,100)
soundChangeBtn.BackgroundTransparency = 0.2
soundChangeBtn.Text = killSounds[1].Name
soundChangeBtn.TextColor3 = Color3.fromRGB(255,255,255)
soundChangeBtn.TextSize = 11
soundChangeBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", soundChangeBtn).CornerRadius = UDim.new(0,6)
soundChangeBtn.Parent = f

soundChangeBtn.MouseButton1Click:Connect(function()
    soundIndex = soundIndex % #killSounds + 1
    selectedSound = killSounds[soundIndex].ID
    soundChangeBtn.Text = killSounds[soundIndex].Name
    playSoundSafe(selectedSound)
    print("音效切换为: " .. killSounds[soundIndex].Name)
end)

-- ============================================================
--  按钮事件
-- ============================================================

fistBtn.MouseButton1Click:Connect(function()
    settings.fistEnabled = not settings.fistEnabled
    if settings.fistEnabled then
        fistBtn.Text = "关"
        fistBtn.BackgroundColor3 = Color3.fromRGB(60,200,80)
        fistStatus.Text = "拳头 开"
        fistStatus.TextColor3 = Color3.fromRGB(100,255,100)
    else
        fistBtn.Text = "开"
        fistBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
        fistStatus.Text = "拳头 关"
        fistStatus.TextColor3 = Color3.fromRGB(255,80,80)
    end
end)

gunBtn.MouseButton1Click:Connect(function()
    settings.gunEnabled = not settings.gunEnabled
    if settings.gunEnabled then
        gunBtn.Text = "关"
        gunBtn.BackgroundColor3 = Color3.fromRGB(60,200,80)
        gunStatus.Text = "枪械 开"
        gunStatus.TextColor3 = Color3.fromRGB(100,255,100)
    else
        gunBtn.Text = "开"
        gunBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
        gunStatus.Text = "枪械 关"
        gunStatus.TextColor3 = Color3.fromRGB(255,80,80)
    end
end)

rainbowBtn.MouseButton1Click:Connect(function()
    settings.rainbowEnabled = not settings.rainbowEnabled
    if settings.rainbowEnabled then
        rainbowBtn.Text = "关"
        rainbowBtn.BackgroundColor3 = Color3.fromRGB(60,200,80)
        rainbowStatus.Text = "美化 开"
        rainbowStatus.TextColor3 = Color3.fromRGB(100,255,100)
    else
        rainbowBtn.Text = "开"
        rainbowBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
        rainbowStatus.Text = "美化 关"
        rainbowStatus.TextColor3 = Color3.fromRGB(255,80,80)
        restoreWeaponColors()
    end
end)

soundBtn.MouseButton1Click:Connect(function()
    settings.soundEnabled = not settings.soundEnabled
    if settings.soundEnabled then
        soundBtn.Text = "关"
        soundBtn.BackgroundColor3 = Color3.fromRGB(60,200,80)
        soundStatus.Text = "音效 开"
        soundStatus.TextColor3 = Color3.fromRGB(100,255,100)
    else
        soundBtn.Text = "开"
        soundBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
        soundStatus.Text = "音效 关"
        soundStatus.TextColor3 = Color3.fromRGB(255,80,80)
    end
end)

espBtn.MouseButton1Click:Connect(function()
    settings.espEnabled = not settings.espEnabled
    if settings.espEnabled then
        espBtn.Text = "关"
        espBtn.BackgroundColor3 = Color3.fromRGB(60,200,80)
        espStatus.Text = "透视 开"
        espStatus.TextColor3 = Color3.fromRGB(100,255,100)
    else
        espBtn.Text = "开"
        espBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
        espStatus.Text = "透视 关"
        espStatus.TextColor3 = Color3.fromRGB(255,80,80)
    end
    updateESPVisibility()
end)

-- ============================================================
--  拖动
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

UserInputService.InputChanged:Connect(function(input)
    if drag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        f.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + (input.Position.X - dx),
            startPos.Y.Scale,
            startPos.Y.Offset + (input.Position.Y - dy)
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        drag = false
    end
end)

print("========================================")
print("监狱人生已加载！")
print("阵营: " .. teamName)
print("警察=蓝色 | 犯人=黄色 | 罪犯=红色")
print("打死后保持原颜色")
print("不打尸体 | 墙壁检测 | 只播自己击杀")
print("罪犯打犯人: " .. (settings.criminalAttackPrisoner and "开" or "关"))
print("拳头 | 枪械 | 透视 | 音效 | 美化")
print("========================================")
