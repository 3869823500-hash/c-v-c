-- 自动射击脚本 (带UI界面)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local ProjectileRender = ReplicatedStorage:WaitForChild("ModuleScripts"):WaitForChild("GunModules"):WaitForChild("Remote"):WaitForChild("ProjectileRender")

-- ==================== 变量 ====================
local shooting = false
local connection = nil
local targetPlayer = nil

local config = {
    FireRate = 0.1,
    Speed = 110,
    Gravity = 5,
    AutoAim = true,
    TargetPart = "Head"
}

-- ==================== UI 创建 ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoShoot"
ScreenGui.Parent = game:GetService("CoreGui")

-- 主框架
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 280)
MainFrame.Position = UDim2.new(0.7, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- 标题栏
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -30, 1, 0)
TitleText.Position = UDim2.new(0, 10, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "🔫 自动射击"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 16
TitleText.Font = Enum.Font.GothamBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

-- 关闭按钮
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 16
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TitleBar
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    shooting = false
end)

-- 分隔线
local Divider = Instance.new("Frame")
Divider.Size = UDim2.new(1, 0, 0, 2)
Divider.Position = UDim2.new(0, 0, 0, 32)
Divider.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
Divider.BorderSizePixel = 0
Divider.Parent = MainFrame

-- 内容区域
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -20, 1, -42)
ContentFrame.Position = UDim2.new(0, 10, 0, 42)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- 辅助函数：创建滑块
local function createSlider(parent, yPos, title, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 35)
    frame.Position = UDim2.new(0, 0, 0, yPos)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 15)
    label.BackgroundTransparency = 1
    label.Text = title .. ": " .. default
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 12
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, 0, 0, 15)
    sliderFrame.Position = UDim2.new(0, 0, 0, 18)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = frame
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
    fill.BorderSizePixel = 0
    fill.Parent = sliderFrame
    
    local slider = Instance.new("TextButton")
    slider.Size = UDim2.new(0, 14, 0, 14)
    slider.Position = UDim2.new((default - min) / (max - min), -7, 0, 0)
    slider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    slider.BorderSizePixel = 0
    slider.Text = ""
    slider.AutoButtonColor = false
    slider.Parent = sliderFrame
    
    local value = default
    local dragging = false
    
    slider.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    sliderFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local mousePos = UserInputService:GetMouseLocation()
            local guiPos = sliderFrame.AbsolutePosition
            local percent = math.clamp((mousePos.X - guiPos.X) / sliderFrame.AbsoluteSize.X, 0, 1)
            value = min + (max - min) * percent
            value = math.floor(value * 100 + 0.5) / 100
            fill.Size = UDim2.new(percent, 0, 1, 0)
            slider.Position = UDim2.new(percent, -7, 0, 0)
            label.Text = title .. ": " .. value
            callback(value)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation()
            local guiPos = sliderFrame.AbsolutePosition
            local percent = math.clamp((mousePos.X - guiPos.X) / sliderFrame.AbsoluteSize.X, 0, 1)
            value = min + (max - min) * percent
            value = math.floor(value * 100 + 0.5) / 100
            fill.Size = UDim2.new(percent, 0, 1, 0)
            slider.Position = UDim2.new(percent, -7, 0, 0)
            label.Text = title .. ": " .. value
            callback(value)
        end
    end)
    
    return value
end

-- 辅助函数：创建按钮
local function createButton(parent, yPos, title, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 30)
    button.Position = UDim2.new(0, 0, 0, yPos)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.BorderSizePixel = 0
    button.Text = title
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.Font = Enum.Font.GothamBold
    button.Parent = parent
    
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 200, 80)}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
    end)
    button.MouseButton1Click:Connect(callback)
    
    return button
end

-- ==================== UI 元素 ====================
local yOffset = 0

-- 射速滑块
createSlider(ContentFrame, yOffset, "射速 (秒)", 0.05, 1, 0.1, function(val)
    config.FireRate = val
end)
yOffset = yOffset + 40

-- 速度滑块
createSlider(ContentFrame, yOffset, "子弹速度", 50, 300, 110, function(val)
    config.Speed = val
end)
yOffset = yOffset + 40

-- 重力滑块
createSlider(ContentFrame, yOffset, "重力", 0, 20, 5, function(val)
    config.Gravity = val
end)
yOffset = yOffset + 40

-- 目标选择下拉
local targetLabel = Instance.new("TextLabel")
targetLabel.Size = UDim2.new(1, 0, 0, 15)
targetLabel.Position = UDim2.new(0, 0, 0, yOffset)
targetLabel.BackgroundTransparency = 1
targetLabel.Text = "目标玩家:"
targetLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
targetLabel.TextSize = 12
targetLabel.Font = Enum.Font.Gotham
targetLabel.TextXAlignment = Enum.TextXAlignment.Left
targetLabel.Parent = ContentFrame

-- 玩家列表
local playerList = Instance.new("ScrollingFrame")
playerList.Size = UDim2.new(1, 0, 0, 60)
playerList.Position = UDim2.new(0, 0, 0, yOffset + 18)
playerList.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
playerList.BorderSizePixel = 0
playerList.CanvasSize = UDim2.new(0, 0, 0, 0)
playerList.ScrollBarThickness = 4
playerList.Parent = ContentFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Parent = playerList

local function updatePlayerList()
    for _, child in ipairs(playerList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    local totalHeight = 0
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -4, 0, 22)
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            btn.BorderSizePixel = 0
            btn.Text = p.Name
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.TextSize = 12
            btn.Font = Enum.Font.Gotham
            btn.Parent = playerList
            
            btn.MouseButton1Click:Connect(function()
                targetPlayer = p
                for _, b in ipairs(playerList:GetChildren()) do
                    if b:IsA("TextButton") then
                        b.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                    end
                end
                btn.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
            end)
            
            totalHeight = totalHeight + 24
        end
    end
    playerList.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
end

updatePlayerList()
yOffset = yOffset + 85

-- 开/关按钮
local toggleButton = createButton(ContentFrame, yOffset, "🔴 关闭", function()
    shooting = not shooting
    if shooting then
        toggleButton.Text = "🟢 开启中..."
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 180, 60)
        startShooting()
    else
        toggleButton.Text = "🔴 关闭"
        toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        stopShooting()
    end
end)

-- ==================== 射击逻辑 ====================
local function getTarget()
    if targetPlayer and targetPlayer.Character then
        return targetPlayer
    end
    
    local nearest = nil
    local nearestDist = math.huge
    local myChar = player.Character
    if not myChar then return nil end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local root = p.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local dist = (root.Position - myRoot.Position).Magnitude
                if dist < nearestDist then
                    nearestDist = dist
                    nearest = p
                end
            end
        end
    end
    return nearest
end

function startShooting()
    shooting = true
    task.spawn(function()
        while shooting do
            pcall(function()
                local target = getTarget()
                if target and target.Character then
                    local myChar = player.Character
                    if myChar then
                        local myRoot = myChar:FindFirstChild("HumanoidRootPart")
                        local targetPart = target.Character:FindFirstChild("HumanoidRootPart")
                        
                        if myRoot and targetPart then
                            local args = {
                                tick(),
                                Instance.new("Model"),
                                myRoot.Position,
                                targetPart.Position + Vector3.new(0, 2, 0), -- 稍微抬高瞄准
                                config.Speed,
                                1,
                                Vector3.zero,
                                config.Gravity,
                                "HoldUp"
                            }
                            ProjectileRender:FireServer(unpack(args))
                        end
                    end
                end
            end)
            task.wait(config.FireRate)
        end
    end)
end

function stopShooting()
    shooting = false
end

-- ==================== 快捷键 ====================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F then -- 按 F 切换射击
        shooting = not shooting
        if shooting then
            toggleButton.Text = "🟢 开启中..."
            toggleButton.BackgroundColor3 = Color3.fromRGB(0, 180, 60)
            startShooting()
        else
            toggleButton.Text = "🔴 关闭"
            toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            stopShooting()
        end
    end
end)

-- 玩家加入/离开时更新列表
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)

print("✅ 自动射击UI已加载！按 F 键开关，或点击界面按钮")
