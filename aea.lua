-- ============================================
--  罗伯特斯 · Roblox 脚本 (全新重写版)
--  使用 ScreenGui + 独立拖动系统
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

-- ===== 创建 GUI =====
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- ===== 主窗口 =====
local window = Instance.new("Frame")
window.Size = UDim2.new(0, 280, 0, 320)
window.Position = UDim2.new(0, 30, 0, 80)
window.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
window.BackgroundTransparency = 0.08
window.BorderSizePixel = 0
window.ClipsDescendants = true
window.Parent = screenGui

local windowCorner = Instance.new("UICorner")
windowCorner.CornerRadius = UDim.new(0, 10)
windowCorner.Parent = window

-- ===== 标题栏 (拖动用) =====
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 38)
header.BackgroundColor3 = Color3.fromRGB(30, 35, 48)
header.BackgroundTransparency = 0.4
header.BorderSizePixel = 0
header.Parent = window

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 10)
headerCorner.Parent = header

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(0, 150, 1, 0)
titleText.Position = UDim2.new(0, 12, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "⚡ 罗伯特斯"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextSize = 15
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Font = Enum.Font.GothamBold
titleText.Parent = header

-- ===== 按钮 =====
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -34, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
closeBtn.BackgroundTransparency = 0.7
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 14
closeBtn.BorderSizePixel = 0
closeBtn.Parent = header

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

local miniBtn = Instance.new("TextButton")
miniBtn.Size = UDim2.new(0, 28, 0, 28)
miniBtn.Position = UDim2.new(1, -66, 0, 5)
miniBtn.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
miniBtn.BackgroundTransparency = 0.7
miniBtn.Text = "−"
miniBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
miniBtn.TextSize = 16
miniBtn.BorderSizePixel = 0
miniBtn.Parent = header

-- ===== 内容区域 =====
local content = Instance.new("Frame")
content.Size = UDim2.new(1, 0, 1, -38)
content.Position = UDim2.new(0, 0, 0, 38)
content.BackgroundTransparency = 1
content.Parent = window

-- ===== 创建开关 =====
local function makeSwitch(y, label, key)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -20, 0, 34)
    row.Position = UDim2.new(0, 10, 0, y)
    row.BackgroundTransparency = 1
    row.Parent = content

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 120, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = Color3.fromRGB(210, 215, 225)
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Font = Enum.Font.Gotham
    lbl.Parent = row

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 40, 0, 22)
    btn.Position = UDim2.new(1, -44, 0.5, -11)
    btn.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.Parent = row

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(1, 0)
    btnCorner.Parent = btn

    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 16, 0, 16)
    dot.Position = UDim2.new(0, 3, 0.5, -8)
    dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    dot.BorderSizePixel = 0
    dot.Parent = btn

    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(1, 0)
    dotCorner.Parent = dot

    local function update()
        local on = features[key]
        btn.BackgroundColor3 = on and Color3.fromRGB(60, 200, 120) or Color3.fromRGB(55, 55, 65)
        dot.Position = on and UDim2.new(0, 21, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    end

    btn.MouseButton1Click:Connect(function()
        features[key] = not features[key]
        update()
        updateStatus()
        print("[罗伯特斯] " .. label .. " " .. (features[key] and "开启" or "关闭"))
    end)

    update()
    return row
end

makeSwitch(8, "🎯 自瞄", "aimbot")
makeSwitch(46, "👁 透视", "esp")
makeSwitch(84, "✈️ 飞行", "fly")
makeSwitch(122, "🧱 穿墙", "noclip")

-- ===== 状态栏 =====
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 28)
status.Position = UDim2.new(0, 10, 0, 168)
status.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
status.BackgroundTransparency = 0.95
status.Text = "● 就绪"
status.TextColor3 = Color3.fromRGB(140, 145, 160)
status.TextSize = 12
status.Font = Enum.Font.Gotham
status.Parent = content

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 6)
statusCorner.Parent = status

function updateStatus()
    local count = 0
    for _, v in pairs(features) do if v then count = count + 1 end end
    if count > 0 then
        status.Text = "● " .. count .. " 个功能已开启"
        status.TextColor3 = Color3.fromRGB(60, 200, 120)
    else
        status.Text = "● 就绪"
        status.TextColor3 = Color3.fromRGB(140, 145, 160)
    end
end

-- ============================================
--  🖱️ 拖动系统
-- ============================================
local dragging = false
local dragOffX = 0
local dragOffY = 0

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragOffX = input.Position.X - window.AbsolutePosition.X
        dragOffY = input.Position.Y - window.AbsolutePosition.Y
    end
end)

userInput.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

runService.RenderStepped:Connect(function()
    if dragging then
        local pos = userInput:GetMouseLocation()
        local newX = pos.X - dragOffX
        local newY = pos.Y - dragOffY
        newX = math.max(0, math.min(newX, screenGui.AbsoluteSize.X - window.Size.X.Offset))
        newY = math.max(0, math.min(newY, screenGui.AbsoluteSize.Y - window.Size.Y.Offset))
        window.Position = UDim2.new(0, newX, 0, newY)
    end
end)

-- ============================================
--  🟠 球体模式 (独立窗口)
-- ============================================
local ballMode = false
local ballFrame = nil

function createBall()
    if ballFrame then return end
    
    ballFrame = Instance.new("Frame")
    ballFrame.Size = UDim2.new(0, 60, 0, 60)
    ballFrame.Position = UDim2.new(0, window.Position.X.Offset + 110, 0, window.Position.Y.Offset + 130)
    ballFrame.BackgroundColor3 = Color3.fromRGB(25, 30, 45)
    ballFrame.BackgroundTransparency = 0.2
    ballFrame.BorderSizePixel = 0
    ballFrame.ClipsDescendants = true
    ballFrame.Parent = screenGui

    local ballCorner = Instance.new("UICorner")
    ballCorner.CornerRadius = UDim.new(1, 0)
    ballCorner.Parent = ballFrame

    local ballText = Instance.new("TextLabel")
    ballText.Size = UDim2.new(1, 0, 1, 0)
    ballText.BackgroundTransparency = 1
    ballText.Text = "⚡"
    ballText.TextColor3 = Color3.fromRGB(255, 215, 0)
    ballText.TextSize = 28
    ballText.Font = Enum.Font.GothamBold
    ballText.Parent = ballFrame

    -- 球体拖动
    local ballDrag = false
    local bOffX, bOffY = 0, 0

    ballFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            ballDrag = true
            bOffX = input.Position.X - ballFrame.AbsolutePosition.X
            bOffY = input.Position.Y - ballFrame.AbsolutePosition.Y
        end
    end)

    userInput.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            ballDrag = false
        end
    end)

    runService.RenderStepped:Connect(function()
        if ballDrag and ballFrame then
            local pos = userInput:GetMouseLocation()
            local nx = pos.X - bOffX
            local ny = pos.Y - bOffY
            nx = math.max(0, math.min(nx, screenGui.AbsoluteSize.X - 60))
            ny = math.max(0, math.min(ny, screenGui.AbsoluteSize.Y - 60))
            ballFrame.Position = UDim2.new(0, nx, 0, ny)
        end
    end)

    -- 点击球体恢复
    ballText.MouseButton1Click:Connect(function()
        if ballFrame then
            ballFrame:Destroy()
            ballFrame = nil
        end
        ballMode = false
        window.Visible = true
    end)
end

-- ===== 缩小按钮 =====
miniBtn.MouseButton1Click:Connect(function()
    if not ballMode then
        ballMode = true
        window.Visible = false
        createBall()
    end
end)

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
local espBoxes = {}
runService.RenderStepped:Connect(function()
    if not features.esp then
        for _, v in pairs(espBoxes) do
            if v and v.Parent then v:Destroy() end
        end
        espBoxes = {}
        return
    end
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("Head") then
            local head = v.Character.Head
            if not head:FindFirstChild("ESP") then
                local box = Instance.new("BoxHandleAdornment")
                box.Name = "ESP"
                box.Size = Vector3.new(4, 5, 2)
                box.Adornee = head
                box.Color3 = Color3.fromRGB(255, 60, 60)
                box.Transparency = 0.35
                box.ZIndex = 10
                box.Parent = head
                table.insert(espBoxes, box)
            end
        end
    end
end)

-- 飞行
local flying = false
local flyBV = nil
userInput.InputBegan:Connect(function(input, chat)
    if chat then return end
    if input.KeyCode == Enum.KeyCode.Space and features.fly then
        flying = not flying
        if flying then
            flyBV = Instance.new("BodyVelocity")
            flyBV.MaxForce = Vector3.new(1, 1, 1) * 4000
            flyBV.Velocity = Vector3.new(0, 50, 0)
            flyBV.Parent = hrp
        else
            if flyBV then flyBV:Destroy() end
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
print("功能: aimbot(自瞄) esp(透视) fly(飞行) noclip(穿墙)")
print("使用: _G.features.aimbot = true")
_G.features = features

-- 防检测
if syn and syn.protect_gui then
    syn.protect_gui(screenGui)
end

print("✅ 启动成功!")
