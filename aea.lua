-- ==================================================
-- Yu UI V5 - 缩小成球加载UI
-- ==================================================

local Library = {}
Library.__index = Library

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- ===== GUI 创建 =====
local Gui = Instance.new("ScreenGui")
Gui.Name = "YuUI_V5"
Gui.ResetOnSpawn = false
Gui.Parent = player:WaitForChild("PlayerGui")

-- ===== 工具函数 =====
local function Create(class, props, parent)
    local obj = Instance.new(class)
    for i, v in pairs(props or {}) do
        obj[i] = v
    end
    obj.Parent = parent
    return obj
end

local function Round(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = obj
end

-- ==================================================
-- 球体加载UI
-- ==================================================

local BallUI = {}
BallUI.__index = BallUI

function BallUI:New()
    local self = setmetatable({}, BallUI)
    
    -- ===== 状态变量 =====
    self.IsExpanded = false
    self.IsAnimating = false
    self.BallSize = 60
    self.WindowSize = 500
    self.ExpandedSize = 400
    self.CurrentState = "ball" -- "ball" or "window"
    
    -- ===== 主容器 =====
    self.Main = Create("Frame", {
        Size = UDim2.new(0, self.BallSize, 0, self.BallSize),
        Position = UDim2.new(0.5, -self.BallSize/2, 0.5, -self.BallSize/2),
        BackgroundColor3 = Color3.fromRGB(18, 18, 18),
        BorderSizePixel = 0,
        ClipsDescendants = true
    }, Gui)
    Round(self.Main, self.BallSize/2)
    
    -- ===== 彩虹边框（球体也保留） =====
    local Stroke = Instance.new("UIStroke")
    Stroke.Thickness = 2
    Stroke.Parent = self.Main
    
    task.spawn(function()
        local h = 0
        while self.Main.Parent do
            h = h + 0.01
            Stroke.Color = Color3.fromHSV(h % 1, 1, 1)
            task.wait()
        end
    end)
    
    -- ===== 加载动画圆圈 =====
    self.LoadingRing = Create("Frame", {
        Size = UDim2.new(0, self.BallSize - 10, 0, self.BallSize - 10),
        Position = UDim2.new(0.5, -(self.BallSize - 10)/2, 0.5, -(self.BallSize - 10)/2),
        BackgroundTransparency = 1,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    }, self.Main)
    
    -- 环形加载条
    self.Ring = Create("ImageLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Image = "rbxassetid://1234567890", -- 占位，实际使用圆形图片
        ImageColor3 = Color3.fromRGB(100, 150, 255),
        ImageTransparency = 0
    }, self.LoadingRing)
    
    -- 由于没有合适的环形图片，我们创建一个弧形
    self.Ring:Destroy()
    self.Ring = Create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1
    }, self.LoadingRing)
    
    -- 创建环形（使用多个小方块组成环）
    self.RingSegments = {}
    local segmentCount = 20
    for i = 1, segmentCount do
        local seg = Create("Frame", {
            Size = UDim2.new(0, 4, 0, 8),
            BackgroundColor3 = Color3.fromRGB(100, 150, 255),
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, -2, 0, 0)
        }, self.Ring)
        Round(seg, 2)
        
        local angle = (i / segmentCount) * math.pi * 2
        local radius = (self.BallSize - 10) / 2 - 4
        seg.Position = UDim2.new(0.5, math.sin(angle) * radius - 2, 0.5, math.cos(angle) * radius - 4)
        
        table.insert(self.RingSegments, seg)
    end
    
    -- ===== 加载文字 =====
    self.LoadingText = Create("TextLabel", {
        Size = UDim2.new(0, 100, 0, 20),
        Position = UDim2.new(0.5, -50, 0.5, 20),
        BackgroundTransparency = 1,
        Text = "加载中...",
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextTransparency = 1
    }, self.Main)
    
    -- ===== 窗口内容（隐藏） =====
    self.WindowContent = Create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Visible = false
    }, self.Main)
    
    -- 标题栏
    self.TitleBar = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1
    }, self.WindowContent)
    
    self.TitleText = Create("TextLabel", {
        Size = UDim2.new(1, -60, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = "Yu UI V5",
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left
    }, self.TitleBar)
    
    -- 关闭按钮
    self.CloseBtn = Create("TextButton", {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -40, 0, 5),
        BackgroundColor3 = Color3.fromRGB(200, 50, 50),
        Text = "✕",
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        Visible = false
    }, self.TitleBar)
    Round(self.CloseBtn, 8)
    
    self.CloseBtn.MouseButton1Click:Connect(function()
        self:CollapseToBall()
    end)
    
    -- 内容区域
    self.ContentArea = Create("ScrollingFrame", {
        Size = UDim2.new(1, -20, 1, -50),
        Position = UDim2.new(0, 10, 0, 45),
        BackgroundTransparency = 1,
        CanvasSize = UDim2.new()
    }, self.WindowContent)
    
    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.Padding = UDim.new(0, 8)
    ContentLayout.Parent = self.ContentArea
    
    ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.ContentArea.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
    end)
    
    -- ===== 拖拽功能 =====
    local drag = false
    local start, pos
    
    self.TitleBar.InputBegan:Connect(function(i)
        if self.IsExpanded and (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) then
            drag = true
            start = i.Position
            pos = self.Main.Position
        end
    end)
    
    UIS.InputChanged:Connect(function(i)
        if drag then
            local d = i.Position - start
            self.Main.Position = UDim2.new(
                pos.X.Scale, pos.X.Offset + d.X,
                pos.Y.Scale, pos.Y.Offset + d.Y
            )
        end
    end)
    
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            drag = false
        end
    end)
    
    -- ===== 点击球体展开 =====
    self.Main.InputBegan:Connect(function(input)
        if not self.IsExpanded and not self.IsAnimating and input.UserInputType == Enum.UserInputType.MouseButton1 then
            self:ExpandToWindow()
        end
    end)
    
    -- ===== 动画循环 =====
    self:StartLoadingAnimation()
    
    return self
end

-- ===== 加载动画 =====
function BallUI:StartLoadingAnimation()
    task.spawn(function()
        local time = 0
        while self.Main.Parent do
            time = time + 0.02
            
            -- 旋转环
            for i, seg in ipairs(self.RingSegments) do
                local angle = (i / #self.RingSegments) * math.pi * 2 + time
                local radius = (self.BallSize - 10) / 2 - 4
                seg.Position = UDim2.new(0.5, math.sin(angle) * radius - 2, 0.5, math.cos(angle) * radius - 4)
                
                -- 透明度变化
                local alpha = 0.3 + 0.7 * (0.5 + 0.5 * math.sin(time * 2 + i * 0.5))
                seg.BackgroundTransparency = 1 - alpha
            end
            
            task.wait()
        end
    end)
end

-- ===== 展开为窗口 =====
function BallUI:ExpandToWindow()
    if self.IsAnimating or self.IsExpanded then return end
    self.IsAnimating = true
    
    -- 1. 改变形状（球→圆角矩形）
    local targetRadius = 12
    local targetSize = self.ExpandedSize
    local centerX = self.Main.Position.X.Offset + self.BallSize/2
    local centerY = self.Main.Position.Y.Offset + self.BallSize/2
    
    -- 计算新位置（居中）
    local newX = centerX - targetSize/2
    local newY = centerY - targetSize/2
    
    -- 动画
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    -- 大小变化
    local sizeTween = TweenService:Create(self.Main, tweenInfo, {
        Size = UDim2.new(0, targetSize, 0, targetSize)
    })
    
    -- 位置变化
    local posTween = TweenService:Create(self.Main, tweenInfo, {
        Position = UDim2.new(0.5, -targetSize/2, 0.5, -targetSize/2)
    })
    
    -- 圆角变化
    local corner = self.Main:FindFirstChild("UICorner")
    if corner then
        local cornerTween = TweenService:Create(corner, tweenInfo, {
            CornerRadius = UDim.new(0, targetRadius)
        })
        cornerTween:Play()
    end
    
    -- 隐藏加载元素
    local ringTween = TweenService:Create(self.LoadingRing, tweenInfo, {
        BackgroundTransparency = 1
    })
    
    local textTween = TweenService:Create(self.LoadingText, tweenInfo, {
        TextTransparency = 1
    })
    
    -- 显示窗口内容
    self.WindowContent.Visible = true
    self.WindowContent.BackgroundTransparency = 1
    local contentTween = TweenService:Create(self.WindowContent, tweenInfo, {
        BackgroundTransparency = 0
    })
    
    -- 执行动画
    ringTween:Play()
    textTween:Play()
    contentTween:Play()
    posTween:Play()
    sizeTween:Play()
    
    sizeTween.Completed:Connect(function()
        self.IsExpanded = true
        self.IsAnimating = false
        self.CurrentState = "window"
        self.CloseBtn.Visible = true
    end)
end

-- ===== 缩小为球 =====
function BallUI:CollapseToBall()
    if self.IsAnimating or not self.IsExpanded then return end
    self.IsAnimating = true
    self.CloseBtn.Visible = false
    
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    
    -- 隐藏窗口内容
    local contentTween = TweenService:Create(self.WindowContent, tweenInfo, {
        BackgroundTransparency = 1
    })
    
    -- 显示加载元素
    local ringTween = TweenService:Create(self.LoadingRing, tweenInfo, {
        BackgroundTransparency = 0
    })
    
    local textTween = TweenService:Create(self.LoadingText, tweenInfo, {
        TextTransparency = 0
    })
    
    -- 大小变化
    local sizeTween = TweenService:Create(self.Main, tweenInfo, {
        Size = UDim2.new(0, self.BallSize, 0, self.BallSize)
    })
    
    -- 位置变化（居中）
    local posTween = TweenService:Create(self.Main, tweenInfo, {
        Position = UDim2.new(0.5, -self.BallSize/2, 0.5, -self.BallSize/2)
    })
    
    -- 圆角变化
    local corner = self.Main:FindFirstChild("UICorner")
    if corner then
        local cornerTween = TweenService:Create(corner, tweenInfo, {
            CornerRadius = UDim.new(0, self.BallSize/2)
        })
        cornerTween:Play()
    end
    
    -- 执行动画
    contentTween:Play()
    ringTween:Play()
    textTween:Play()
    posTween:Play()
    sizeTween:Play()
    
    sizeTween.Completed:Connect(function()
        self.WindowContent.Visible = false
        self.IsExpanded = false
        self.IsAnimating = false
        self.CurrentState = "ball"
    end)
end

-- ===== 切换状态 =====
function BallUI:Toggle()
    if self.IsExpanded then
        self:CollapseToBall()
    else
        self:ExpandToWindow()
    end
end

-- ==================================================
-- 示例：创建球体UI
-- ==================================================

local UI = BallUI:New()

-- ===== 添加一些示例控件 =====
local function AddExampleControls()
    -- 添加标签
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 30)
    label.BackgroundTransparency = 1
    label.Text = "🎯 欢迎使用 Yu UI"
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.
