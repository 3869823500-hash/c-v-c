-- ============================================
--  罗伯特斯 · Roblox 脚本 (极简稳定版)
--  全部用 TextButton 实现，绝对可用
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

-- ============================================
--  创建按钮列表 (不用Frame, 全用TextButton)
-- ============================================

local buttons = {}
local buttonNames = {"🎯 自瞄", "👁 透视", "✈️ 飞行", "🧱 穿墙"}
local buttonKeys = {"aimbot", "esp", "fly", "noclip"}
local buttonStatus = {}  -- 记录每个按钮的开关状态

-- 创建背景框 (简单装饰)
local bg = Instance.new("TextLabel")
bg.Size = UDim2.new(0, 200, 0, 220)
bg.Position = UDim2.new(0, 20, 0, 50)
bg.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
bg.BackgroundTransparency = 0.1
bg.Text = ""
bg.BorderSizePixel = 0
bg.Parent = screenGui

local bgCorner = Instance.new("UICorner")
bgCorner.CornerRadius = UDim.new(0, 10)
bgCorner.Parent = bg

-- 标题
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 200, 0, 35)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "⚡ 罗伯特斯"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.Parent = bg

-- 关闭按钮
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 3)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
closeBtn.BackgroundTransparency = 0.6
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 14
closeBtn.BorderSizePixel = 0
closeBtn.Parent = bg

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- 缩小按钮
local miniBtn = Instance.new("TextButton")
miniBtn.Size = UDim2.new(0, 30, 0, 30)
miniBtn.Position = UDim2.new(1, -68, 0, 3)
miniBtn.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
miniBtn.BackgroundTransparency = 0.6
miniBtn.Text = "−"
miniBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
miniBtn.TextSize = 16
miniBtn.BorderSizePixel = 0
miniBtn.Parent = bg

-- ===== 创建功能按钮 =====
for i = 1, 4 do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 180, 0, 32)
    btn.Position = UDim2.new(0, 10, 0, 40 + (i-1) * 38)
    btn.BackgroundColor3 = Color3.fromRGB(45, 50, 65)
    btn.Text = buttonNames[i] .. " ⚪"
    btn.TextColor3 = Color3.fromRGB(200, 205, 215)
    btn.TextSize = 14
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.Gotham
    btn.Parent = bg

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    -- 保存状态
    buttonStatus[i] = false

    -- 点击切换
    btn.MouseButton1Click:Connect(function()
        local key = buttonKeys[i]
        features[key] = not features[key]
        buttonStatus[i] = features[key]

        -- 更新按钮外观
        if features[key] then
            btn.BackgroundColor3 = Color3.fromRGB(50, 180, 110)
            btn.Text = buttonNames[i] .. " 🟢"
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            btn.BackgroundColor3 = Color3.fromRGB(45, 50, 65)
            btn.Text = buttonNames[i] .. " ⚪"
            btn.TextColor3 = Color3.fromRGB(200, 205, 215)
        end

        updateStatus()
        print("[罗伯特斯] " .. buttonNames[i] .. " " .. (features[key] and "开启" or "关闭"))
    end)

    buttons[i] = btn
end

-- ===== 状态显示 =====
local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(0, 180, 0, 25)
statusText.Position = UDim2.new(0, 10, 0, 192)
statusText.BackgroundColor3 = Color3.fromRGB(30, 35, 50)
statusText.BackgroundTransparency = 0.5
statusText.Text = "● 就绪"
statusText.TextColor3 = Color3.fromRGB(150, 155, 170)
statusText.TextSize = 12
statusText.Font = Enum.Font.Gotham
statusText.Parent = bg

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 4)
statusCorner.Parent = statusText

function updateStatus()
    local count = 0
    for _, v in pairs(features) do if v then count = count + 1 end end
    if count > 0 then
        statusText.Text = "● " .. count .. " 个功能已开启"
        statusText.TextColor3 = Color3.fromRGB(60, 200, 120)
    else
        statusText.Text = "● 就绪"
        statusText.TextColor3 = Color3.fromRGB(150, 155, 170)
    end
end

-- ============================================
--  🖱️ 拖动 (用鼠标事件)
-- ============================================
local dragActive = false
local dragX = 0
local dragY = 0

bg.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        -- 检查是否点击了按钮 (按钮不触发拖动)
        local target = mouse.Target
        if target and (target:IsA("TextButton") or target.Parent:IsA("TextButton")) then
            return
        end
        dragActive = true
        dragX = input.Position.X - bg.AbsolutePosition.X
        dragY = input.Position.Y - bg.AbsolutePosition.Y
    end
end)

userInput.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragActive = false
    end
end)

runService.RenderStepped:Connect(function()
    if dragActive then
        local pos = userInput:GetMouseLocation()
        local newX = pos.X - dragX
        local newY = pos.Y - dragY
        newX = math.max(0, math.min(newX, screenGui.AbsoluteSize.X - 200))
        newY = math.max(0, math.min(newY, screenGui.AbsoluteSize.Y - 220))
        bg.Position = UDim2.new(0, newX, 0, newY)
    end
end)

-- ============================================
--  🟠 球体模式
-- ============================================
local ballMode = false
local ball = nil

function createBall()
    if ball then return end

    ball = Instance.new("TextButton")
    ball.Size = UDim2.new(0, 55, 0, 55)
    ball.Position = UDim2.new(0, bg.Position.X.Offset + 70, 0, bg.Position.Y.Offset + 80)
    ball.BackgroundColor3 = Color3.fromRGB(25, 30, 45)
    ball.BackgroundTransparency = 0.2
    ball.Text = "⚡"
    ball.TextColor3 = Color3.fromRGB(255, 215, 0)
    ball.TextSize = 28
    ball.BorderSizePixel = 0
    ball.Font = Enum.Font.GothamBold
    ball.Parent = screenGui

    local ballCorner = Instance.new("UICorner")
    ballCorner.CornerRadius = UDim.new(1, 0)
    ballCorner.Parent = ball

    -- 球体拖动
    local ballDrag = false
    local bX, bY = 0, 0

    ball.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            ballDrag = true
            bX = input.Position.X - ball.AbsolutePosition.X
            bY = input.Position.Y - ball.AbsolutePosition.Y
        end
    end)

    userInput.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            ballDrag = false
        end
    end)

    runService.RenderStepped:Connect(function()
        if ballDrag and ball then
            local pos = userInput:GetMouseLocation()
            local nx = pos.X - bX
            local ny = pos.Y - bY
            nx = math.max(0, math.min(nx, screenGui.AbsoluteSize.X - 55))
            ny = math.max(0, math.min(ny, screenGui.AbsoluteSize.Y - 55))
            ball.Position = UDim2.new(0, nx, 0, ny)
        end
    end)

    -- 点击球体恢复
    ball.MouseButton1Click:Connect(function()
        if ball then
            ball:Destroy()
            ball = nil
        end
        ballMode = false
        bg.Visible = true
    end)
end

-- ===== 缩小 =====
miniBtn.MouseButton1Click:Connect(function()
    if not ballMode then
        ballMode = true
        bg.Visible = false
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

if syn and syn.protect_gui then
    syn.protect_gui(screenGui)
end

print("✅ 启动成功!")
