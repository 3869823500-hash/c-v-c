-- ============================================================
--  监狱辅助 V5（WindUI 版本）
--  最好看的UI，功能全齐
-- ============================================================

-- ===== 加载 WindUI =====
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

-- ===== 创建窗口 =====
local Window = WindUI:CreateWindow({
    Title = "🏛️ 监狱辅助 V5",
    Icon = "sword",
    Author = "监狱人生专用",
    Theme = "Dark",
    Size = UDim2.fromOffset(650, 460),
    Resizable = true,
    ToggleKey = Enum.KeyCode.RightShift,
})

-- ===== 添加标签 =====
Window:Tag({
    Title = "V5",
    Icon = "shield",
    Color = Color3.fromRGB(100, 200, 255),
})

-- ============================================================
--  服务引用
-- ============================================================
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
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
    目标部位 = "头",
}

local ESP表 = {}

-- ============================================================
--  工具函数
-- ============================================================
local function 是否敌人(p)
    if p == LocalPlayer then return false end
    if p.Team and LocalPlayer.Team and p.Team == LocalPlayer.Team then return false end
    local c = p.Character
    if c then
        local root = c:FindFirstChild("HumanoidRootPart")
        if root and root:FindFirstChild("TeammateLabel") then return false end
    end
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
    if Config.目标部位 == "头" then return c:FindFirstChild("Head") end
    return c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Head")
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
            最近 = {player = p, part = part, pos = pos}
        end
    end
    return 最近
end

-- ============================================================
--  彩虹透明武器
-- ============================================================
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

-- ============================================================
--  透视
-- ============================================================
local function 获取职业(p)
    if not p then return "未知"
    if p.Team then
        local n = p.Team.Name
        if n == "Police" or n == "POLICE" or n == "警察" then return "👮警察"
        if n == "Inmates" or n == "囚犯" then return "🧑囚犯"
        if n == "Criminals" or n == "罪犯" then return "🔫罪犯"
    end
    return "未知"
end

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
    local bb = Instance.new("BillboardGui")
    bb.AlwaysOnTop = true
    bb.Size = UDim2.new(0, 180, 0, 40)
    bb.StudsOffset = Vector3.new(0, 2.5, 0)
    bb.Parent = c
    local lb = Instance.new("TextLabel")
    lb.BackgroundTransparency = 1
    lb.Size = UDim2.new(1,0,1,0)
    lb.Font = Enum.Font.GothamBold
    lb.TextSize = 12
    lb.TextColor3 = Color3.fromRGB(255,255,255)
    lb.TextStrokeTransparency = 0.3
    lb.Text = p.DisplayName .. "\n" .. 获取职业(p)
    lb.Parent = bb
    ESP表[p] = {hl = hl, bb = bb}
end

local function 更新透视()
    if not Config.透视 then
        for _, d in pairs(ESP表) do pcall(function() d.hl:Destroy(); d.bb:Destroy() end) end
        ESP表 = {}
        return
    end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and not ESP表[p] then
            创建透视(p)
        end
    end
end

-- ============================================================
--  静默自瞄
-- ============================================================
local ShootEvent
local function findShootEvent()
    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
        if v.Name == "Shoot" or v.Name == "ShootEvent" or v.Name == "Fire" then
            ShootEvent = v
            return
        end
    end
end
findShootEvent()

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

-- ============================================================
--  子追
-- ============================================================
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

-- ============================================================
--  秒射
-- ============================================================
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

-- 连点（按住左键）
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

LocalPlayer.CharacterAdded:Connect(function() task.wait(0.5) end)

-- ============================================================
--  UI 构建
-- ============================================================

-- ===== 主标签页 =====
local MainTab = Window:Tab({
    Title = "战斗",
    Icon = "sword",
})

-- 左侧分组：自瞄
local AimGroup = MainTab:LeftGroupbox("🎯 自瞄设置")

AimGroup:Toggle({
    Title = "子追（子弹追踪）",
    Value = false,
    Callback = function(v) Config.子追 = v end
})

AimGroup:Toggle({
    Title = "静默自瞄",
    Value = false,
    Callback = function(v) Config.静默 = v end
})

AimGroup:Dropdown({
    Title = "瞄准部位",
    Values = {"头", "身体"},
    Value = "头",
    Callback = function(v) Config.目标部位 = v end
})

AimGroup:Slider({
    Title = "FOV 范围",
    Value = 200,
    Min = 30,
    Max = 500,
    Callback = function(v) Config.FOV = v end
})

-- 右侧分组：武器
local WeaponGroup = MainTab:RightGroupbox("⚡ 武器设置")

WeaponGroup:Toggle({
    Title = "彩虹透明武器",
    Value = true,
    Callback = function(v) Config.彩虹 = v end
})

WeaponGroup:Toggle({
    Title = "秒射（极速连发）",
    Value = false,
    Callback = function(v) Config.秒射 = v end
})

WeaponGroup:Toggle({
    Title = "自动连点",
    Value = true,
    Callback = function(v) Config.连点 = v end
})

-- ===== 视觉标签页 =====
local VisualTab = Window:Tab({
    Title = "视觉",
    Icon = "eye",
})

local VisualGroup = VisualTab:LeftGroupbox("👁️ 透视设置")

VisualGroup:Toggle({
    Title = "启用玩家透视",
    Value = false,
    Callback = function(v)
        Config.透视 = v
        if v then 更新透视() end
    end
})

-- ===== 设置标签页 =====
local SettingsTab = Window:Tab({
    Title = "设置",
    Icon = "settings",
})

local SettingsGroup = SettingsTab:LeftGroupbox("⚙️ 通用设置")

SettingsGroup:Button({
    Title = "卸载脚本",
    Callback = function()
        Window:Close()
    end
})

-- ============================================================
--  完成
-- ============================================================
print("✅ 监狱辅助 V5（WindUI）已加载")
print("📌 按 RightShift 显示/隐藏菜单")
print("🌈 彩虹武器默认开启 | 功能请在菜单中开关")
