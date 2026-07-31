-- ============================================================
--  WindUI 版本（加载失败自动切备用）
-- ============================================================

local player = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")
local uis = game:GetService("UserInputService")

print("✅ 脚本开始运行")

-- ===== 删除旧UI =====
local old = player.PlayerGui:FindFirstChild("CombatUI")
if old then old:Destroy() end

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
local range = 70
local lastFist = 0
local lastGun = 0

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
--  🎨 加载 WindUI
-- ============================================================

local WindUI = nil
local useWindUI = false

local function createNativeUI()
    print("📌 使用备用UI")
    
    local sg = Instance.new("ScreenGui")
    sg.Name = "CombatUI"
    sg.ResetOnSpawn = false
    sg.DisplayOrder = 99999
    sg.Parent = player:WaitForChild("PlayerGui")

    local f = Instance.new("Frame")
    f.Size = UDim2.new(0, 160, 0, 200)
    f.Position = UDim2.new(0.02, 0, 0.2, 0)
    f.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
    f.BackgroundTransparency = 0.1
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
    f.Parent = sg

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 28)
    title.BackgroundTransparency = 1
    title.Text = "⚔️ 战斗"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 14
    title.Font = Enum.Font.GothamBold
    title.Parent = f

    local fistBg = Instance.new("Frame")
    fistBg.Size = UDim2.new(0, 130, 0, 30)
    fistBg.Position = UDim2.new(0.5, -65, 0, 38)
    fistBg.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    fistBg.BackgroundTransparency = 0.2
    Instance.new("UICorner", fistBg).CornerRadius = UDim.new(0, 6)
    fistBg.Parent = f

    local fistBtn = Instance.new("TextButton")
    fistBtn.Size = UDim2.new(1, 0, 1, 0)
    fistBtn.BackgroundTransparency = 1
    fistBtn.Text = "🥊 拳头 ❌"
    fistBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
    fistBtn.TextSize = 13
    fistBtn.Font = Enum.Font.GothamBold
    fistBtn.Parent = fistBg

    local gunBg = Instance.new("Frame")
    gunBg.Size = UDim2.new(0, 130, 0, 30)
    gunBg.Position = UDim2.new(0.5, -65, 0, 78)
    gunBg.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    gunBg.BackgroundTransparency = 0.2
    Instance.new("UICorner", gunBg).CornerRadius = UDim.new(0, 6)
    gunBg.Parent = f

    local gunBtn = Instance.new("TextButton")
    gunBtn.Size = UDim2.new(1, 0, 1, 0)
    gunBtn.BackgroundTransparency = 1
    gunBtn.Text = "🔫 枪械 ❌"
    gunBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
    gunBtn.TextSize = 13
    gunBtn.Font = Enum.Font.GothamBold
    gunBtn.Parent = gunBg

    local espBg = Instance.new("Frame")
    espBg.Size = UDim2.new(0, 130, 0, 30)
    espBg.Position = UDim2.new(0.5, -65, 0, 118)
    espBg.BackgroundColor3 = Color3.fromRGB(60, 200, 80)
    espBg.BackgroundTransparency = 0.2
    Instance.new("UICorner", espBg).CornerRadius = UDim.new(0, 6)
    espBg.Parent = f

    local espBtn = Instance.new("TextButton")
    espBtn.Size = UDim2.new(1, 0, 1, 0)
    espBtn.BackgroundTransparency = 1
    espBtn.Text = "👁️ 透视 ✅"
    espBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
    espBtn.TextSize = 13
    espBtn.Font = Enum.Font.GothamBold
    espBtn.Parent = espBg

    local info = Instance.new("TextLabel")
    info.Size = UDim2.new(1, 0, 0, 16)
    info.Position = UDim2.new(0, 0, 0, 160)
    info.BackgroundTransparency = 1
    info.Text = "范围: 70"
    info.TextColor3 = Color3.fromRGB(150, 150, 200)
    info.TextSize = 10
    info.Font = Enum.Font.Gotham
    info.Parent = f

    fistBtn.MouseButton1Click:Connect(function()
        fistOn = not fistOn
        fistBtn.Text = fistOn and "🥊 拳头 ✅" or "🥊 拳头 ❌"
        fistBtn.TextColor3 = fistOn and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 80, 80)
        fistBg.BackgroundColor3 = fistOn and Color3.fromRGB(60, 200, 80) or Color3.fromRGB(200, 50, 50)
    end)

    gunBtn.MouseButton1Click:Connect(function()
        gunOn = not gunOn
        gunBtn.Text = gunOn and "🔫 枪械 ✅" or "🔫 枪械 ❌"
        gunBtn.TextColor3 = gunOn and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 80, 80)
        gunBg.BackgroundColor3 = gunOn and Color3.fromRGB(60, 200, 80) or Color3.fromRGB(200, 50, 50)
    end)

    espBtn.MouseButton1Click:Connect(function()
        espOn = not espOn
        espBtn.Text = espOn and "👁️ 透视 ✅" or "👁️ 透视 ❌"
        espBtn.TextColor3 = espOn and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 80, 80)
        espBg.BackgroundColor3 = espOn and Color3.fromRGB(60, 200, 80) or Color3.fromRGB(200, 50, 50)
        updateESP()
    end)

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
            f.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + (input.Position.X - dx), startPos.Y.Scale, startPos.Y.Offset + (input.Position.Y - dy))
        end
    end)
    uis.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            drag = false
        end
    end)
end

-- ===== 尝试加载 WindUI =====
local function loadWindUI()
    print("📌 正在加载 WindUI...")
    local ok, err = pcall(function()
        local url = "https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"
        local result = game:HttpGet(url)
        if result then
            WindUI = loadstring(result)()
        end
    end)
    
    if ok and WindUI then
        print("✅ WindUI 加载成功")
        useWindUI = true
        return true
    else
        print("❌ WindUI 加载失败: " .. tostring(err))
        return false
    end
end

-- ===== 创建 WindUI 界面 =====
local function createWindUI()
    print("📌 创建 WindUI 界面")
    
    -- 删除旧UI
    local old = player.PlayerGui:FindFirstChild("CombatUI")
    if old then old:Destroy() end
    
    local ok, err = pcall(function()
        local Window = WindUI:CreateWindow({
            Title = "⚔️ 战斗机器人",
            Author = "v3.0",
            Size = UDim2.fromOffset(550, 400),
        })
        
        local mainTab = Window:Tab({
            Title = "战斗",
            Icon = "crosshair"
        })
        
        local attackGroup = mainTab:Group({ Title = "攻击设置" })
        attackGroup:Toggle({
            Title = "🥊 拳头自动攻击",
            Default = false,
            Callback = function(state)
                fistOn = state
            end
        })
        attackGroup:Toggle({
            Title = "🔫 枪械自动射击",
            Default = false,
            Callback = function(state)
                gunOn = state
            end
        })
        attackGroup:Slider({
            Title = "📏 攻击范围",
            Min = 30,
            Max = 150,
            Default = 70,
            Step = 5,
            Callback = function(value)
                range = value
            end
        })
        
        local assistGroup = mainTab:Group({ Title = "辅助功能" })
        assistGroup:Toggle({
            Title = "👁️ 透视头（三阵营）",
            Default = true,
            Callback = function(state)
                espOn = state
                updateESP()
            end
        })
        
        local infoGroup = mainTab:Group({ Title = "信息" })
        infoGroup:Label({ Title = "👤 阵营: " .. getTeam(player) })
        infoGroup:Label({ Title = "🔫 ShootEvent: " .. (ShootEvent and "✅" or "❌") })
        infoGroup:Label({ Title = "🥊 meleeEvent: " .. (meleeEvent and "✅" or "❌") })
        
        print("✅ WindUI 界面创建成功")
    end)
    
    if not ok then
        print("❌ WindUI 界面创建失败: " .. tostring(err))
        useWindUI = false
        createNativeUI()
    end
end

-- ===== 主加载 =====
task.spawn(function()
    local success = loadWindUI()
    if success then
        createWindUI()
    else
        createNativeUI()
    end
end)

task.wait(0.5)
updateESP()

print("========================================")
print("✅ 脚本已加载")
if useWindUI then
    print("📌 使用 WindUI 界面")
else
    print("📌 使用备用UI")
end
print("🥊 拳头 | 🔫 枪械 | 👁️ 透视")
print("========================================")
