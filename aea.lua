--========================================
-- Yu UI 监狱辅助完整版
--========================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- ============================================================
--  配置
-- ============================================================
local Config = {
    彩虹 = true,
    透视 = false,
    连点 = true,
    秒射 = false,
    子追 = false,
    静默 = false,
    FOV = 200,
}

local ESP表 = {}
local ShootEvent

-- ============================================================
--  获取射击事件
-- ============================================================
local function findShootEvent()
    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
        if v.Name == "Shoot" or v.Name == "ShootEvent" or v.Name == "Fire" then
            ShootEvent = v
            return
        end
    end
end
findShootEvent()

-- ============================================================
--  工具函数
-- ============================================================
local function 是否敌人(p)
    if p == LocalPlayer then return false end
    if p.Team and LocalPlayer.Team and p.Team == LocalPlayer.Team then return false end
    return true
end

local function 是否活着(p)
    local c = p.Character
    if not c then return false end
    local h = c:FindFirstChildOfClass("Humanoid")
    return h and h.Health > 0
end

local function 获取目标部位(c)
    if not c then return nil end
    return c:FindFirstChild("Head") or c:FindFirstChild("HumanoidRootPart")
end

local function 获取最近敌人()
    local mouse = UserInputService:GetMouseLocation()
    local 最近 = nil
    local 最近距离 = Config.FOV
    for _, p in pairs(Players:GetPlayers()) do
        if not 是否敌人(p) then continue end
        if not 是否活着(p) then continue end
        local c = p.Character
        if not c then continue end
        local part = 获取目标部位(c)
        if not part then continue end
        local pos, on = Camera:WorldToViewportPoint(part.Position)
        if not on then continue end
        local dist = (Vector2.new(pos.X, pos.Y) - mouse).Magnitude
        if dist < 最近距离 then
            最近距离 = dist
            最近 = {player = p, part = part}
        end
    end
    return 最近
end

-- ============================================================
--  功能函数
-- ============================================================

-- 1. 彩虹武器
local function 彩虹效果()
    if not Config.彩虹 then return end
    local c = LocalPlayer.Character
    if not c then return end
    local hue = (tick() * 0.25) % 1
    local function 扫描(tool)
        for _, p in pairs(tool:GetDescendants()) do
            if p:IsA("BasePart") or p:IsA("MeshPart") or p:IsA("Part") then
                local ph = (hue + p.Name:len() * 0.015) % 1
                p.Material = Enum.Material.Neon
                p.Color = Color3.fromHSV(ph, 0.9, 1)
                p.Transparency = 0.35
                p.Reflectance = 0.3
            end
        end
    end
    for _, t in pairs(c:GetChildren()) do if t:IsA("Tool") then 扫描(t) end end
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if bp then for _, t in pairs(bp:GetChildren()) do if t:IsA("Tool") then 扫描(t) end end end
end

-- 2. 透视
local function 创建透视(p)
    if p == LocalPlayer then return end
    local c = p.Character
    if not c then return end
    local hl = Instance.new("Highlight")
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.FillTransparency = 0.4
    hl.FillColor = 是否敌人(p) and Color3.fromRGB(255,0,0) or Color3.fromRGB(0,255,0)
    hl.Adornee = c
    hl.Parent = c
    ESP表[p] = hl
end

local function 更新透视()
    if not Config.透视 then
        for _, hl in pairs(ESP表) do pcall(function() hl:Destroy() end) end
        ESP表 = {}
        return
    end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and not ESP表[p] then
            创建透视(p)
        end
    end
end

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        task.wait(0.5)
        if Config.透视 then 创建透视(p) end
    end)
end)

-- 3. 静默自瞄
local function 静默自瞄射击()
    if not Config.静默 then return end
    if not ShootEvent then return end
    local target = 获取最近敌人()
    if not target then return end
    local c = LocalPlayer.Character
    if not c then return end
    local tool = c:FindFirstChildOfClass("Tool")
    if not tool then return end
    local head = c:FindFirstChild("Head")
    if not head then return end
    local data = {{head.Position, target.part.Position, target.part}}
    pcall(function() ShootEvent:FireServer(data) end)
end

-- 4. 子追
local function 子追拦截射线()
    if not Config.子追 then return end
    local target = 获取最近敌人()
    if not target then return end
    local old = Workspace.Raycast
    Workspace.Raycast = function(self, o, d, p)
        local r = old(self, o, d, p)
        if r and r.Instance and r.Instance:IsDescendantOf(target.part.Parent) then
            return r
        end
        return {Instance = target.part, Position = target.part.Position, Normal = d, Material = Enum.Material.Plastic}
    end
    task.spawn(function() task.wait(0.01); Workspace.Raycast = old end)
end

-- 5. 秒射
local function 秒射修改武器()
    if not Config.秒射 then return end
    local c = LocalPlayer.Character
    if not c then return end
    for _, t in pairs(c:GetChildren()) do
        if t:IsA("Tool") then
            pcall(function()
                for _, a in ipairs({"FireRate","ShootRate","RPM","RateOfFire","FireDelay","ShootDelay","Cooldown","Delay"}) do
                    t:SetAttribute(a, 0.001)
                end
                for _, a in ipairs({"MuzzleVelocity","BulletSpeed","Velocity","Speed","ProjectileSpeed"}) do
                    t:SetAttribute(a, 99999)
                end
            end)
        end
    end
end

-- 6. 连点
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and Config.连点 then
        task.spawn(function()
            while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) and Config.连点 do
                local c = LocalPlayer.Character
                if c then
                    local t = c:FindFirstChildOfClass("Tool")
                    if t then pcall(function() t:Activate() end) end
                end
                task.wait(0.003)
            end
        end)
    end
end)

-- ============================================================
--  主循环
-- ============================================================
local function 主循环()
    if Config.彩虹 then 彩虹效果() end
    if Config.透视 then 更新透视() end
    if Config.静默 then 静默自瞄射击() end
    if Config.子追 then 子追拦截射线() end
    if Config.秒射 then 秒射修改武器() end
end

RunService.Heartbeat:Connect(主循环)

LocalPlayer.CharacterAdded:Connect(function() task.wait(0.5) end)

-- ============================================================
--  UI（你的Yu UI框架）
-- ============================================================

local gui = Instance.new("ScreenGui")
gui.Name = "YuUI"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- 主窗口
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 340, 0, 360)
Main.Position = UDim2.new(0.5, -170, 0.5, -180)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.BorderSizePixel = 0
Main.Parent = gui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 15)
Corner.Parent = Main

-- 彩色边框
local Stroke = Instance.new("UIStroke")
Stroke.Thickness = 3
Stroke.Parent = Main

task.spawn(function()
    while Stroke and Stroke.Parent do
        for i = 0, 1, 0.02 do
            Stroke.Color = Color3.fromHSV(i, 1, 1)
            task.wait()
        end
    end
end)

-- 标题
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundTransparency = 1
Title.Text = "🏛️ 监狱辅助"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextScaled = true
Title.Parent = Main

-- 关闭按钮
local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 40, 0, 40)
Close.Position = UDim2.new(1, -45, 0, 5)
Close.Text = "✕"
Close.TextScaled = true
Close.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
Close.Parent = Main
Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 6)

Close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- 拖动
local dragging = false
local dragStart, startPos

Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function()
    dragging = false
end)

-- ============================================================
--  创建按钮
-- ============================================================
local y = 60

local function CreateButton(text, getter, setter)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 35)
    frame.Position = UDim2.new(0, 10, 0, y)
    frame.BackgroundTransparency = 1
    frame.Parent = Main
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextSize = 14
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 65, 0, 28)
    btn.Position = UDim2.new(1, -70, 0.5, -14)
    btn.BackgroundColor3 = getter() and Color3.fromRGB(60, 200, 80) or Color3.fromRGB(200, 50, 50)
    btn.BackgroundTransparency = 0.2
    btn.Text = getter() and "开启" or "关闭"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.Parent = frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    
    btn.MouseButton1Click:Connect(function()
        local v = not getter()
        setter(v)
        btn.Text = v and "开启" or "关闭"
        btn.BackgroundColor3 = v and Color3.fromRGB(60, 200, 80) or Color3.fromRGB(200, 50, 50)
    end)
    
    y = y + 40
end

-- 创建所有按钮
CreateButton("🌈 彩虹武器", function() return Config.彩虹 end, function(v) Config.彩虹 = v end)
CreateButton("👁️ 透视", function() return Config.透视 end, function(v) Config.透视 = v end)
CreateButton("🔫 连点", function() return Config.连点 end, function(v) Config.连点 = v end)
CreateButton("⚡ 秒射", function() return Config.秒射 end, function(v) Config.秒射 = v end)
CreateButton("🎯 子追", function() return Config.子追 end, function(v) Config.子追 = v end)
CreateButton("🔇 静默自瞄", function() return Config.静默 end, function(v) Config.静默 = v end)

-- 底部信息
local Info = Instance.new("TextLabel")
Info.Size = UDim2.new(1, 0, 0, 18)
Info.Position = UDim2.new(0, 0, 0, 325)
Info.BackgroundTransparency = 1
Info.Text = "按住左键连发 | 拖动窗口 | 彩色边框"
Info.TextColor3 = Color3.fromRGB(160, 160, 180)
Info.TextSize = 11
Info.Font = Enum.Font.Gotham
Info.TextXAlignment = Enum.TextXAlignment.Center
Info.Parent = Main

-- ============================================================
--  悬浮球
-- ============================================================
local Ball = Instance.new("TextButton")
Ball.Size = UDim2.new(0, 55, 0, 55)
Ball.Position = UDim2.new(0.01, 0, 0.5, 0)
Ball.Text = "🏛️"
Ball.TextScaled = true
Ball.BackgroundColor3 = Color3.fromRGB(80, 0, 255)
Ball.BackgroundTransparency = 0.2
Ball.Parent = gui
Instance.new("UICorner", Ball).CornerRadius = UDim.new(1, 0)

Ball.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

print("✅ Yu UI 监狱辅助完整版已加载")
print("📌 点击悬浮球开关菜单")
