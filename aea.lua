-- ============================================================
--  监狱辅助 V4（Obsidian UI框架）
--  来源：原神V4 UI框架 + 你的功能
-- ============================================================

local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
local Options = Library.Options

-- ===== 创建窗口 =====
local Window = Library:CreateWindow({
    Title = "🏛️ 监狱辅助 V4",
    Footer = "子追 | 静默自瞄 | 透视 | 秒射 | 彩虹武器",
    NotifySide = "Right",
    ShowCustomCursor = true,
})

-- ===== 标签页 =====
local Tabs = {
    Combat = Window:AddTab("战斗", "crosshair"),
    Visuals = Window:AddTab("视觉", "eye"),
    Settings = Window:AddTab("设置", "settings"),
}

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
    子追 = false,
    静默自瞄 = false,
    透视 = false,
    秒射 = false,
    彩虹 = true,
    FOV = 150,
    目标部位 = "头",
}

local ESP数据 = {}

-- ============================================================
--  获取射击事件
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

-- ============================================================
--  工具函数
-- ============================================================
local function 是否队友(p)
    if p == LocalPlayer then return false end
    if p.Team and LocalPlayer.Team and p.Team == LocalPlayer.Team then return true end
    local c = p.Character
    if c then
        local root = c:FindFirstChild("HumanoidRootPart")
        if root and root:FindFirstChild("TeammateLabel") then return true end
    end
    return false
end

local function 是否敌人(p)
    if p == LocalPlayer then return false end
    if 是否队友(p) then return false end
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

-- ============================================================
--  获取最近敌人
-- ============================================================
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
--  静默自瞄
-- ============================================================
local function 静默自瞄射击()
    if not Config.静默自瞄 then return end
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
--  彩虹透明武器
-- ============================================================
local function 彩虹效果()
    if not Config.彩虹 then return end
    local c = LocalPlayer.Character
    if not c then return end
    local all = {}
    for _, t in pairs(c:GetChildren()) do if t:IsA("Tool") then table.insert(all, t) end end
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if bp then for _, t in pairs(bp:GetChildren()) do if t:IsA("Tool") then table.insert(all, t) end end end
    local hue = (tick() * 0.25) % 1
    for _, t in pairs(all) do
        for _, p in pairs(t:GetDescendants()) do
            if p:IsA("BasePart") or p:IsA("MeshPart") or p:IsA("Part") then
                local ph = (hue + p.Name:len() * 0.015) % 1
                p.Material = Enum.Material.Neon
                p.Color = Color3.fromHSV(ph, 0.9, 1)
                p.Transparency = 0.35
                p.Reflectance = 0.3
            end
        end
    end
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
    ESP数据[p] = {hl = hl, bb = bb}
end

local function 更新透视()
    if not Config.透视 then
        for _, d in pairs(ESP数据) do pcall(function() d.hl:Destroy(); d.bb:Destroy() end) end
        ESP数据 = {}
        return
    end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and not ESP数据[p] then
            创建透视(p)
        end
    end
end

-- ============================================================
--  主循环
-- ============================================================
local function 主循环()
    if Config.子追 then 子追拦截射线() end
    if Config.静默自瞄 then 静默自瞄射击() end
    if Config.秒射 then 秒射修改武器() end
    if Config.彩虹 then 彩虹效果() end
    更新透视()
end

RunService.Heartbeat:Connect(主循环)

-- 按住左键射击（秒射用）
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        task.spawn(function()
            while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                if Config.秒射 then
                    local c = LocalPlayer.Character
                    if c then
                        local t = c:FindFirstChildOfClass("Tool")
                        if t then pcall(function() t:Activate() end) end
                    end
                end
                task.wait(0.003)
            end
        end)
    end
end)

LocalPlayer.CharacterAdded:Connect(function() task.wait(0.5) end)

-- ============================================================
--  UI（Obsidian框架）
-- ============================================================

-- ===== 战斗标签页 =====
local CombatGroup = Tabs.Combat:AddLeftGroupbox("🎯 自瞄 & 射击", "crosshair")

CombatGroup:AddToggle("子追", {
    Text = "启用子弹追踪",
    Default = false,
    Callback = function(v) Config.子追 = v end
})

CombatGroup:AddToggle("静默自瞄", {
    Text = "启用静默自瞄（无弹道）",
    Default = false,
    Callback = function(v) Config.静默自瞄 = v end
})

CombatGroup:AddToggle("秒射", {
    Text = "启用极速连发",
    Default = false,
    Callback = function(v) Config.秒射 = v end
})

CombatGroup:AddToggle("彩虹武器", {
    Text = "启用彩虹透明武器",
    Default = true,
    Callback = function(v) Config.彩虹 = v end
})

CombatGroup:AddSlider("FOV范围", {
    Text = "自瞄范围",
    Default = 150,
    Min = 30,
    Max = 500,
    Rounding = 0,
    Suffix = "°",
    Callback = function(v) Config.FOV = v end
})

-- ===== 瞄准设置 =====
local CombatGroup2 = Tabs.Combat:AddLeftGroupbox("🎯 瞄准设置", "target")

CombatGroup2:AddDropdown("目标部位", {
    Text = "瞄准部位",
    Values = {"头", "身体"},
    Default = "头",
    Callback = function(v) Config.目标部位 = v end
})

-- ===== 视觉标签页 =====
local VisualGroup = Tabs.Visuals:AddLeftGroupbox("👁️ 透视", "eye")

VisualGroup:AddToggle("透视", {
    Text = "启用玩家透视",
    Default = false,
    Callback = function(v)
        Config.透视 = v
        if v then 更新透视() end
    end
})

-- ===== 设置标签页 =====
local SettingsGroup = Tabs.Settings:AddLeftGroupbox("⚙️ 设置", "settings")

SettingsGroup:AddButton("卸载脚本", function()
    Library:Unload()
end)

-- ===== 主题管理 =====
task.spawn(function()
    task.wait(0.5)
    pcall(function()
        ThemeManager:SetLibrary(Library)
        SaveManager:SetLibrary(Library)
        SaveManager:IgnoreThemeSettings()
        ThemeManager:SetFolder("监狱辅助")
        SaveManager:SetFolder("监狱辅助")
        SaveManager:SetSubFolder("PrisonLife")
        SaveManager:BuildConfigSection(Tabs.Settings)
        ThemeManager:ApplyToTab(Tabs.Settings)
        SaveManager:LoadAutoloadConfig()
    end)
end)

Library:OnUnload(function()
    for _, d in pairs(ESP数据) do
        pcall(function() d.hl:Destroy(); d.bb:Destroy() end)
    end
    print("✅ 已卸载")
                        
end)

print("✅ 监狱辅助 V4 已加载（Obsidian UI）")
