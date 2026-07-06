-- ============================================
--  罗伯特斯 · Roblox 脚本 (手机版)
--  功能: 自瞄 | 透视 | 飞行(加速) | 穿墙
--  支持: 触屏拖动 | 球体拖动 | 全部可用
-- ============================================

local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local userInput = game:GetService("UserInputService")
local touchService = game:GetService("TouchService")

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

-- ===== 加速 =====
local speedBoost = 1

-- ===== 创建 GUI =====
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- ===== 背景框 =====
local bg = Instance.new("TextLabel")
bg.Size = UDim2.new(0, 220, 0, 260)
bg.Position = UDim2.new(0.5, -110, 0.3, 0)
bg.BackgroundColor3 = Color3.fromRGB(18, 22, 32)
bg.BackgroundTransparency = 0.15
bg.Text = ""
bg.BorderSizePixel = 0
bg.Parent = screenGui

local bgCorner = Instance.new("UICorner")
bgCorner.CornerRadius = UDim.new(0, 12)
bgCorner.Parent = bg

-- ===== 标题 =====
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 220, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "⚡ 罗伯特斯"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.Parent = bg

-- ===== 关闭按钮 =====
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 34, 0, 34)
closeBtn.Position = UDim2.new(1, -40, 0, 3)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
closeBtn.BackgroundTransparency = 0.5
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 16
closeBtn.BorderSizePixel = 0
closeBtn.Parent = bg

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- ===== 缩小按钮 =====
local miniBtn = Instance.new("TextButton")
miniBtn.Size = UDim2.new(0, 34, 0, 34)
miniBtn.Position = UDim2.new(1, -78, 0, 3)
miniBtn.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
miniBtn.BackgroundTransparency = 0.5
miniBtn.Text = "−"
miniBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
miniBtn.TextSize = 18
miniBtn.BorderSizePixel = 0
miniBtn.Parent = bg

-- ============================================
--  功能按钮 (加大方便手机点击)
-- ============================================

local btnData = {
    {name = "🎯 自瞄", key = "aimbot"},
    {name = "👁 透视", key = "esp"},
    {name = "✈️ 飞行", key = "fly"},
    {name = "🧱 穿墙", key = "noclip"}
}

for i, data in ipairs(btnData) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 200, 0, 36)
    btn.Position = UDim2.new(0, 10, 0, 45 + (i-1) * 42)
    btn.BackgroundColor3 = Color3.fromRGB(45, 50, 65)
    btn.Text = data.name .. " ⚪"
    btn.TextColor3 = Color3.fromRGB(200, 205, 215)
    btn.TextSize = 15
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.Gotham
    btn.Parent = bg

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn

    local key = data.key

    btn.MouseButton1Click:Connect(function()
        features[key] = not features[key]

        if features[key] then
            btn.BackgroundColor3 = Color3.fromRGB(50, 180, 110)
            btn.Text = data.name .. " 🟢"
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            btn.BackgroundColor3 = Color3.fromRGB(45, 50, 65)
            btn.Text = data.name .. " ⚪"
            btn.TextColor3 = Color3.fromRGB(200, 205, 215)
        end

        updateStatus()
        print("[罗伯特斯] " .. data.name .. " " .. (features[key] and "开启" or "关闭"))
    end)
end

-- ===== 加速提示 =====
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0, 200, 0, 22)
speedLabel.Position = UDim2.new(0, 10, 0, 200)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "⚡ 长按屏幕加速飞行"
speedLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
speedLabel.TextSize = 12
speedLabel.Font = Enum.Font.Gotham
speedLabel.Parent = bg

-- ===== 状态显示 =====
local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(0, 200, 0, 28)
statusText.Position = UDim2.new(0, 10, 0, 224)
statusText.BackgroundColor3 = Color3.fromRGB(30, 35, 50)
statusText.BackgroundTransparency = 0.5
statusText.Text = "● 就绪"
statusText.TextColor3 = Color3.fromRGB(150, 155, 170)
statusText.TextSize = 13
statusText.Font = Enum.Font.Gotham
statusText.Parent = bg

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 6)
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
--  🖱️ 触屏拖动 (手机/电脑通用)
-- ============================================
local dragActive = false
local dragX = 0
local dragY = 0
local dragObject = nil  -- "bg" 或 "ball"

-- 背景拖动
bg.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local target = mouse.Target
        if target and (target:IsA("TextButton") or target.Parent:IsA("TextButton")) then
            return
        end
        dragActive = true
        dragObject = "bg"
        dragX = input.Position.X - bg.AbsolutePosition.X
        dragY = input.Position.Y - bg.AbsolutePosition.Y
    end
end)

userInput.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragActive = false
        dragObject = nil
    end
end)

runService.RenderStepped:Connect(function()
    if dragActive and dragObject == "bg" then
        local pos = userInput:GetMouseLocation()
        local newX = pos.X - dragX
        local newY = pos.Y - dragY
        newX = math.max(0, math.min(newX, screenGui.AbsoluteSize.X - 220))
        newY = math.max(0, math.min(newY, screenGui.AbsoluteSize.Y - 260))
        bg.Position = UDim2.new(0, newX, 0, newY)
    end
end)

-- ============================================
--  🟠 球体模式 (触屏可拖动)
-- ============================================
local ballMode = false
local ball = nil

function createBall()
    if ball then return end

    ball = Instance.new("TextButton")
    ball.Size = UDim2.new(0, 65, 0, 65)
    ball.Position = UDim2.new(0.5, -32, 0.4, 0)
    ball.BackgroundColor3 = Color3.fromRGB(25, 30, 45)
    ball.BackgroundTransparency = 0.2
    ball.Text = "⚡"
    ball.TextColor3 = Color3.fromRGB(255, 215, 0)
    ball.TextSize = 32
    ball.BorderSizePixel = 0
    ball.Font = Enum.Font.GothamBold
    ball.Parent = screenGui

    local ballCorner = Instance.new("UICorner")
    ballCorner.CornerRadius = UDim.new(1, 0)
    ballCorner.Parent = ball

    -- ===== 球体拖动 (触屏) =====
    local ballDrag = false
    local bX, bY = 0, 0

    ball.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            ballDrag = true
            bX = input.Position.X - ball.AbsolutePosition.X
            bY = input.Position.Y - ball.AbsolutePosition.Y
            print("[罗伯特斯] 球体拖动开始")
        end
    end)

    runService.RenderStepped:Connect(function()
        if ballDrag and ball then
            local pos = userInput:GetMouseLocation()
            local nx = pos.X - bX
            local ny = pos.Y - bY
            nx = math.max(0, math.min(nx, screenGui.AbsoluteSize.X - 65))
            ny = math.max(0, math.min(ny, screenGui.AbsoluteSize.Y - 65))
            ball.Position = UDim2.new(0, nx, 0, ny)
        end
    end)

    userInput.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            ballDrag = false
        end
    end)

    -- ===== 点击球体恢复 =====
    ball.MouseButton1Click:Connect(function()
        if ball then
            ball:Destroy()
            ball = nil
        end
        ballMode = false
        bg.Visible = true
        print("[罗伯特斯] 恢复窗口")
    end)
end

-- ===== 缩小 =====
miniBtn.MouseButton1Click:Connect(function()
    if not ballMode then
        ballMode = true
        bg.Visible = false
        createBall()
        print("[罗伯特斯] 缩成球体")
    end
end)

-- ============================================
--  🔫 自瞄 (触屏点击屏幕)
-- ============================================
-- 手机用点击屏幕自瞄
userInput.TouchTap:Connect(function(input, chat)
    if chat then return end
    if not features.aimbot then return end
    
    local target = nil
    local closest = math.huge

    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local pos = v.Character.HumanoidRootPart.Position
            local dist = (pos - hrp.Position).magnitude
            if dist < closest and dist < 250 then
                closest = dist
                target = v
            end
        end
    end

    if target and target.Character then
        local targetHrp = target.Character.HumanoidRootPart
        hrp.CFrame = CFrame.new(hrp.Position, targetHrp.Position)
        print("[罗伯特斯] 🎯 自瞄锁定: " .. target.Name)
    end
end)

-- 电脑用鼠标右键
local mouse = player:GetMouse()
if mouse then
    mouse.Button2Down:Connect(function()
        if not features.aimbot then return end
        
        local target = nil
        local closest = math.huge

        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local pos = v.Character.HumanoidRootPart.Position
                local dist = (pos - hrp.Position).magnitude
                if dist < closest and dist < 250 then
                    closest = dist
                    target = v
                end
            end
        end

        if target and target.Character then
            local targetHrp = target.Character.HumanoidRootPart
            hrp.CFrame = CFrame.new(hrp.Position, targetHrp.Position)
            print("[罗伯特斯] 🎯 自瞄锁定: " .. target.Name)
        end
    end)
end

-- ============================================
--  👁 透视
-- ============================================
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
                box.Color3 = Color3.fromRGB(255, 50, 50)
                box.Transparency = 0.35
                box.ZIndex = 10
                box.Parent = head
                table.insert(espBoxes, box)
            end
        end
    end
end)

-- ============================================
--  ✈️ 飞行 (手机长按加速)
-- ============================================
local flying = false
local flyBV = nil
local isHolding = false

-- 飞行开关 (点击飞行按钮后按屏幕)
userInput.InputBegan:Connect(function(input, chat)
    if chat then return end
    
    -- 空格飞行 (电脑)
    if input.KeyCode == Enum.KeyCode.Space and features.fly then
        toggleFly()
    end
    
    -- 触屏长按加速 (手机)
    if input.UserInputType == Enum.UserInputType.Touch and features.fly then
        isHolding = true
        speedBoost = 2
        if flyBV then
            flyBV.Velocity = Vector3.new(0, 80, 0)
        end
    end
end)

userInput.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        isHolding = false
        speedBoost = 1
        if flyBV then
            flyBV.Velocity = Vector3.new(0, 50, 0)
        end
    end
end)

function toggleFly()
    flying = not flying
    if flying then
        flyBV = Instance.new("BodyVelocity")
        flyBV.MaxForce = Vector3.new(1, 1, 1) * 4000
        flyBV.Velocity = Vector3.new(0, 50, 0)
        flyBV.Parent = hrp
        print("[罗伯特斯] ✈️ 飞行开启")
    else
        if flyBV then flyBV:Destroy() end
        print("[罗伯特斯] ✈️ 飞行关闭")
    end
end

-- ============================================
--  🧱 穿墙
-- ============================================
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

-- ============================================
--  控制台
-- ============================================
print("⚡ 罗伯特斯手机版已加载!")
print("功能: 自瞄(点击屏幕) 透视 飞行(长按加速) 穿墙")
print("操作: 点击开关切换功能")
_G.features = features

if syn and syn.protect_gui then
    syn.protect_gui(screenGui)
end

print("✅ 启动成功!")
