-- ============================================
--  罗伯特斯 · 超级精简版 (手机专用)
--  只有核心功能，没有任何UI
-- ============================================

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local runService = game:GetService("RunService")
local userInput = game:GetService("UserInputService")

-- ===== 等待角色 =====
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- ===== 功能变量 =====
local aimbotOn = false
local espOn = false
local flyOn = false
local noclipOn = false

-- ===== 打印提示 =====
print("⚡ 罗伯特斯已加载!")
print("输入: _G.aimbot = true 开启自瞄")
print("输入: _G.esp = true 开启透视")
print("输入: _G.fly = true 开启飞行")
print("输入: _G.noclip = true 开启穿墙")

-- ===== 控制台控制 =====
_G.aimbot = false
_G.esp = false
_G.fly = false
_G.noclip = false

-- ===== 监听变量变化 =====
local function updateFeatures()
    aimbotOn = _G.aimbot
    espOn = _G.esp
    flyOn = _G.fly
    noclipOn = _G.noclip
end

-- 每秒检测一次
game:GetService("RunService").Heartbeat:Connect(function()
    updateFeatures()
end)

-- ===== 自瞄 (鼠标右键) =====
mouse.Button2Down:Connect(function()
    if not aimbotOn then return end
    local target = nil
    local closest = 999
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
        hrp.CFrame = CFrame.new(hrp.Position, target.Character.HumanoidRootPart.Position)
        print("🎯 锁定: " .. target.Name)
    end
end)

-- ===== 透视 =====
local espBoxes = {}
runService.RenderStepped:Connect(function()
    if not espOn then
        for _, v in pairs(espBoxes) do
            pcall(function() v:Destroy() end)
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
                box.Color3 = Color3.fromRGB(255, 0, 0)
                box.Transparency = 0.4
                box.ZIndex = 10
                box.Parent = head
                table.insert(espBoxes, box)
            end
        end
    end
end)

-- ===== 飞行 (按空格) =====
local flyBody = nil
userInput.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Space and flyOn then
        if flyBody then
            flyBody:Destroy()
            flyBody = nil
            print("✈️ 飞行关闭")
        else
            flyBody = Instance.new("BodyVelocity")
            flyBody.MaxForce = Vector3.new(1, 1, 1) * 4000
            flyBody.Velocity = Vector3.new(0, 50, 0)
            flyBody.Parent = hrp
            print("✈️ 飞行开启")
        end
    end
end)

-- ===== 穿墙 =====
runService.Stepped:Connect(function()
    char = player.Character or player.CharacterAdded:Wait()
    if noclipOn then
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

print("✅ 加载完成! 在控制台输入 _G.aimbot = true 测试")
