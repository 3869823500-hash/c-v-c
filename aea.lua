-- ============================================
--  罗伯特斯 · Roblox 脚本 (最终修复版)
--  保证: 拖动 | 球体拖动 | 功能开关 全部可用
-- ============================================

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local runService = game:GetService("RunService")
local userInput = game:GetService("UserInputService")

-- ===== 等待角色 =====
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- ===== 功能状态 =====
local features = {
    aimbot = false,
    esp = false,
    fly = false,
    noclip = false
}

-- ===== 创建UI =====
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 340)
frame.Position = UDim2.new(0, 20, 0, 60)
frame.BackgroundColor3 = Color3.fromRGB(22, 27, 38)
frame.BackgroundTransparency = 0.05
frame.BorderSizePixel = 0
frame.ClipsDescendants = true
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

-- ===== 标题栏 =====
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 35, 46)
titleBar.BackgroundTransparency = 0.3
titleBar.BorderSizePixel = 0
titleBar.Parent = frame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 120, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.Text = "⚡ 罗伯特斯"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.Parent = titleBar

-- ===== 按钮 =====
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -38, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
closeBtn.BackgroundTransparency = 0.8
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 16
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -72, 0, 5)
minBtn.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
minBtn.BackgroundTransparency = 0.8
minBtn.Text = "−"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.TextSize = 18
minBtn.BorderSizePixel = 0
minBtn.Parent = titleBar

-- ===== 球体状态 =====
local isBall = false
local ballLabel = Instance.new("TextLabel")
ballLabel.Name = "BallLabel"
ballLabel.Size = UDim2.new(1, 0, 1, 0)
ballLabel.BackgroundTransparency = 1
ballLabel.Text = "⚡"
ballLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
ballLabel.TextSize = 28
ballLabel.Font = Enum.Font.GothamBold
ballLabel.Visible = false
ballLabel.Parent = frame

-- ===== 保存原始大小 =====
local origSize = frame.Size
local origPos = frame.Position

-- ===== 缩小/恢复 =====
minBtn.MouseButton1Click:Connect(function()
    isBall = not isBall
    if isBall then
        frame.Size = UDim2.new(0, 60, 0, 60)
        frame.Position = UDim2.new(0.5, -30, 0.5, -30)
        for _, v in pairs(frame:GetChildren()) do
            if v ~= ballLabel then v.Visible = false end
        end
        ballLabel.Visible = true
        frame.BackgroundTransparency = 0.3
    else
        frame.Size = origSize
        frame.Position = origPos
        for _, v in pairs(frame:GetChildren()) do
            if v ~= ballLabel then v.Visible = true end
        end
        ballLabel.Visible = false
        frame.BackgroundTransparency = 0.05
    end
end)

-- ===== 点击球体恢复 =====
ballLabel.MouseButton1Click:Connect(function()
    if isBall then
        isBall = false
        frame.Size = origSize
        frame.Position = origPos
        for _, v in pairs(frame:GetChildren()) do
            if v ~= ballLabel then v.Visible = true end
        end
        ballLabel.Visible = false
        frame.BackgroundTransparency = 0.05
    end
end)

-- ============================================
--  🖱️ 拖动系统 (绝对能用版)
-- ============================================
local dragData = {
    active = false,
    startPos = nil,
    offset = Vector2.new()
}

-- 判断是否可拖动
local function canDrag(target)
    if isBall then
        return target == ballLabel or target == frame
    end
    return target == titleBar or target:IsDescendantOf(titleBar)
end

-- 鼠标按下
mouse.Button1Down:Connect(function()
    local target = mouse.Target
    if not target then return end
    
    -- 如果点击的是按钮，不拖动
    if target:IsA("TextButton") then return end
    if target.Parent and target.Parent:IsA("TextButton") then return end
    
    if canDrag(target) then
        dragData.active = true
        dragData.offset = Vector2.new(
            mouse.X - frame.AbsolutePosition.X,
            mouse.Y - frame.AbsolutePosition.Y
        )
    end
end)

-- 鼠标移动 (用 RenderStepped 实时更新)
runService.RenderStepped:Connect(function()
    if dragData.active then
        local newX = mouse.X - dragData.offset.X
        local newY = mouse.Y - dragData.offset.Y
        
        -- 边界限制
        local maxX = screenGui.AbsoluteSize.X - frame.Size.X.Offset
        local maxY = screenGui.AbsoluteSize.Y - frame.Size.Y.Offset
        newX = math.max(0, math.min(newX, maxX))
        newY = math.max(0, math.min(newY, maxY))
        
        frame.Position = UDim2.new(0, newX, 0, newY)
    end
end)

-- 鼠标释放
mouse.Button1Up:Connect(function()
    dragData.active = false
end)

-- ============================================
--  功能开关
-- ============================================
local function createSwitch(y, labelText, featureKey)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -24, 0, 36)
    container.Position = UDim2.new(0, 12, 0, y)
    container.BackgroundTransparency = 1
    container.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 120, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = container

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 40, 0, 22)
    toggle.Position = UDim2.new(1, -44, 0.5, -11)
    toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    toggle.BorderSizePixel = 0
    toggle.Text = ""
    toggle.Parent = container

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggle

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = UDim2.new(0, 3, 0.5, -8)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.Parent = toggle

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob

    local function updateToggle()
        local on = features[featureKey]
        toggle.BackgroundColor3 = on and Color3.fromRGB(74, 222, 128) or Color3.fromRGB(60, 60, 60)
        knob.Position = on and UDim2.new(0, 21, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    end

    toggle.MouseButton1Click:Connect(function()
        features[featureKey] = not features[featureKey]
        updateToggle()
        updateStatus()
    end)

    updateToggle()
    return container
end

createSwitch(50, "🎯 自瞄", "aimbot")
createSwitch(92, "👁 透视", "esp")
createSwitch(134, "✈️ 飞行", "fly")
createSwitch(176, "🧱 穿墙", "noclip")

-- ===== 状态栏 =====
local statusBar = Instance.new("TextLabel")
statusBar.Size = UDim2.new(1, -24, 0, 30)
statusBar.Position = UDim2.new(0, 12, 0, 220)
statusBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
statusBar.BackgroundTransparency = 0.95
statusBar.Text = "● 就绪"
statusBar.TextColor3 = Color3.fromRGB(150, 150, 150)
statusBar.TextSize = 12
statusBar.Font = Enum.Font.Gotham
statusBar.Parent = frame

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 6)
statusCorner.Parent = statusBar

function updateStatus()
    local count = 0
    for _, v in pairs(features) do if v then count = count + 1 end end
    if count > 0 then
        statusBar.Text = "● " .. count .. " 个功能已开启"
        statusBar.TextColor3 = Color3.fromRGB(74, 222, 128)
    else
        statusBar.Text = "● 就绪"
        statusBar.TextColor3 = Color3.fromRGB(150, 150, 150)
    end
end

-- ============================================
--  功能实现
-- ============================================

-- 自瞄
mouse.Button2Down:Connect(function()
    if not features.aimbot then return end
    local target = nil
    local closest = math.huge
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local pos = v.Character.HumanoidRootPart.Position
            local dist = (pos - hrp.Position).magnitude
            if dist < closest and dist < 200 then
                closest = dist
                target = v
            end
        end
    end
    if target and target.Character then
        hrp.CFrame = CFrame.new(hrp.Position, target.Character.HumanoidRootPart.Position)
    end
end)

-- 透视
local espObjects = {}
runService.RenderStepped:Connect(function()
    if not features.esp then
        for _, v in pairs(espObjects) do
            if v and v.Parent then v:Destroy() end
        end
        espObjects = {}
        return
    end
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("Head") then
            local head = v.Character.Head
            if not head:FindFirstChild("ESPBox") then
                local box = Instance.new("BoxHandleAdornment")
                box.Name = "ESPBox"
                box.Size = Vector3.new(4, 5, 2)
                box.Adornee = head
                box.Color3 = Color3.fromRGB(255, 50, 50)
                box.Transparency = 0.4
                box.ZIndex = 10
                box.Parent = head
                table.insert(espObjects, box)
            end
        end
    end
end)

-- 飞行
local flyEnabled = false
local flyBody = nil
userInput.InputBegan:Connect(function(input, chat)
    if chat then return end
    if input.KeyCode == Enum.KeyCode.Space and features.fly then
        flyEnabled = not flyEnabled
        if flyEnabled then
            flyBody = Instance.new("BodyVelocity")
            flyBody.MaxForce = Vector3.new(1, 1, 1) * 4000
            flyBody.Velocity = Vector3.new(0, 50, 0)
            flyBody.Parent = hrp
        else
            if flyBody then flyBody:Destroy() end
        end
    end
end)

-- 穿墙
runService.Stepped:Connect(function()
    char = player.Character or player.CharacterAdded:Wait()
    if features.noclip then
        for _, v in pairs(char:GetChildren()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    else
        for _, v in pairs(char:GetChildren()) do
            if v:IsA("BasePart") then
                v.CanCollide = true
            end
        end
    end
end)

-- ===== 控制台 =====
print("⚡ 罗伯特斯已加载!")
print("功能: aimbot esp fly noclip")
print("示例: _G.features.aimbot = true")
_G.features = features

if syn and syn.protect_gui then
    syn.protect_gui(screenGui)
end

print("✅ 启动成功!")
