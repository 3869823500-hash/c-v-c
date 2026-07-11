-- 放在StarterGui下的本地脚本
local player = game:GetService("Players").LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "ControlUI"
gui.Parent = player:WaitForChild("PlayerGui")

-- 主面板
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 140)
frame.Position = UDim2.new(0.5, -110, 0.5, -70)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 0
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = frame

local stroke = Instance.new("UIStroke")
stroke.Thickness = 1.5
stroke.Color = Color3.fromRGB(150, 150, 255)
stroke.Transparency = 0.4
stroke.Parent = frame

-- 标题
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.2, 0)
title.Position = UDim2.new(0, 0, 0.02, 0)
title.BackgroundTransparency = 1
title.Text = "控制系统"
title.TextColor3 = Color3.fromRGB(220, 220, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Pare
