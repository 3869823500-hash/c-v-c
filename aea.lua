-- 自动射击脚本 (手机触屏版 - 修复版)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- 找到远程事件
local ProjectileRender
pcall(function()
    ProjectileRender = ReplicatedStorage:WaitForChild("ModuleScripts"):WaitForChild("GunModules"):WaitForChild("Remote"):WaitForChild("ProjectileRender")
end)

-- ==================== 变量 ====================
local shooting = false
local targetPlayer = nil

local config = {
    fireRate = 0.15,
    speed = 110,
    gravity = 5,
}

-- ==================== UI ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoShootMobile"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

-- 主按钮
local MainButton = Instance.new("TextButton")
MainButton.Size = UDim2.new(0, 65, 0, 65)
MainButton.Position = UDim2.new(1, -85, 1, -220)
MainButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
MainButton.BorderSizePixel = 0
MainButton.Text = "🔫"
MainButton.TextSize = 30
MainButton.Font = Enum.Font.GothamBold
MainButton.Parent = ScreenGui

local BC = Instance.new("UICorner")
BC.CornerRadius = UDim.new(1, 0)
BC.Parent = MainButton

-- 设置面板
local Panel = Instance.new("Frame")
Panel.Size = UDim2.new(0, 250, 0, 350)
Panel.Position = UDim2.new(1, -270, 1, -590)
Panel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Panel.BorderSizePixel = 0
Panel.Visible = false
Panel.Parent = ScreenGui

local PC = Instance.new("UICorner")
PC.CornerRadius = UDim.new(0, 10)
PC.Parent = Panel

-- 标题
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 38)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.Text = "⚙️ 设置面板"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.Parent = Panel

local TC = Instance.new("UICorner")
TC.CornerRadius = UDim.new(0, 10)
TC.Parent = Title

-- 辅助函数：创建输入行
local function createInputRow(parent, yPos, labelText, defaultValue, callback)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 80, 0, 36)
    label.Position = UDim2.new(0, 12, 0, yPos)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent
    
    local input = Instance.new("TextBox")
    input.Size = UDim2.new(1, -110, 0, 36)
    input.Position = UDim2.new(0, 95, 0, yPos)
    input.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    input.BorderSizePixel = 0
    input.Text = tostring(defaultValue)
    input.TextColor3 = Color3.fromRGB(255, 255, 255)
    input.TextSize = 16
    input.Font = Enum.Font.GothamBold
    input.PlaceholderText = "输入数字..."
    input.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
    input.ClearTextOnFocus = false
    input.Parent = parent
    
    local ic = Instance.new("UICorner")
    ic.CornerRadius = UDim.new(0, 6)
    ic.Parent = input
    
    input.FocusLost:Connect(function(enterPressed)
        local num = tonumber(input.Text)
        if num then
            callback(num)
            input.Text = tostring(num)
        else
            input.Text = tostring(defaultValue)
        end
    end)
    
    return input
end

-- 射速输入
local rateInput = createInputRow(Panel, 50, "射速(秒)", config.fireRate, function(val)
    config.fireRate = math.max(0.01, val)
end)

-- 速度输入
local speedInput = createInputRow(Panel, 100, "子弹速度", config.speed, function(val)
    config.speed = math.max(1, val)
end)

-- 重力输入
local gravityInput = createInputRow(Panel, 150, "重力", config.gravity, function(val)
    config.gravity = math.max(0, val)
end)

-- 玩家列表标题
local PlayerListTitle = Instance.new("TextLabel")
PlayerListTitle.Size = UDim2.new(1, -20, 0, 22)
PlayerListTitle.Position = UDim2.new(0, 12, 0, 200)
PlayerListTitle.BackgroundTransparency = 1
PlayerListTitle.Text = "🎯 选择目标 (点击选择)"
PlayerListTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
PlayerListTitle.TextSize = 13
PlayerListTitle.Font = Enum.Font.Gotham
PlayerListTitle.TextXAlignment = Enum.TextXAlignment.Left
PlayerListTitle.Parent = Panel

-- 玩家列表
local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Size = UDim2.new(1, -24, 0, 60)
PlayerList.Position = UDim2.new(0, 12, 0, 225)
PlayerList.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
PlayerList.BorderSizePixel = 0
PlayerList.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerList.ScrollBarThickness = 4
PlayerList.Parent = Panel

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 3)
ListLayout.Parent = PlayerList

-- 更新玩家列表
local function updatePlayerList()
    for _, child in ipairs(PlayerList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    local h = 0
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -4, 0, 30)
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            btn.BorderSizePixel = 0
            btn.Text = p.DisplayName
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.TextSize = 13
            btn.Font = Enum.Font.Gotham
            btn.Parent = PlayerList
            
            btn.Activated:Connect(function()
                targetPlayer = p
                for _, b in ipairs(PlayerList:GetChildren()) do
                    if b:IsA("TextButton") then
                        b.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                    end
                end
                btn.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
            end)
            
            h = h + 33
        end
    end
    PlayerList.CanvasSize = UDim2.new(0, 0, 0, h)
end

updatePlayerList()

-- 开关按钮
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(1, -24, 0, 46)
ToggleBtn.Position = UDim2.new(0, 12, 0, 292)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ToggleBtn.Text = "🔴 开始射击"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 17
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Parent = Panel

local TBC = Instance.new("UICorner")
TBC.CornerRadius = UDim.new(0, 8)
TBC.Parent = ToggleBtn

-- ==================== 逻辑 ====================
local function getTarget()
    if targetPlayer and targetPlayer.Character then
        local root = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then return targetPlayer.Character, root end
    end
    
    local myChar = player.Character
    if not myChar then return nil, nil end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil, nil end
    
    local nearestChar, nearestRoot = nil, nil
    local nearestDist = math.huge
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local root = p.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local dist = (root.Position - myRoot.Position).Magnitude
                if dist < nearestDist then
                    nearestDist = dist
                    nearestChar = p.Character
                    nearestRoot = root
                end
            end
        end
    end
    return nearestChar, nearestRoot
end

local function fire()
    if not ProjectileRender then return end
    local _, targetRoot = getTarget()
    if not targetRoot then return end
    
    local myChar = player.Character
    if not myChar then return end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    
    local args = {
        tick(),
        Instance.new("Model"),
        myRoot.Position,
        targetRoot.Position,
        config.speed,
        1,
        Vector3.zero,
        config.gravity,
        "HoldUp"
    }
    
    pcall(function()
        ProjectileRender:FireServer(unpack(args))
    end)
end

-- 射击循环
local shootLoop
local function startShoot()
    if shooting then return end
    shooting = true
    shootLoop = task.spawn(function()
        while shooting do
            fire()
            task.wait(config.fireRate)
        end
    end)
end

local function stopShoot()
    shooting = false
    if shootLoop then
        task.cancel(shootLoop)
        shootLoop = nil
    end
end

-- 面板开关
MainButton.Activated:Connect(function()
    Panel.Visible = not Panel.Visible
end)

-- 开关射击
ToggleBtn.Activated:Connect(function()
    if shooting then
        stopShoot()
        ToggleBtn.Text = "🔴 开始射击"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        MainButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    else
        startShoot()
        ToggleBtn.Text = "🟢 射击中..."
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 60)
        MainButton.BackgroundColor3 = Color3.fromRGB(0, 200, 60)
    end
end)

-- 玩家列表实时更新
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(function(p)
    if p == targetPlayer then targetPlayer = nil end
    updatePlayerList()
end)

print("✅ 脚本已加载！点击右下角🔫按钮打开设置")
