-- 俄亥俄州 - 完整UI版本
-- 直接复制到控制台运行

local function OhioWithUI()
    -- 基础安全检查
    if not game:IsLoaded() then game.Loaded:Wait() end
    
    -- 创建UI界面
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "OhioUI"
    screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    
    -- 主框架
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 400, 0, 500)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    
    -- 圆角
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    -- 标题
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    title.Text = "Ohio 俄亥俄州"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 20
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.BorderSizePixel = 0
    title.Parent = mainFrame
    
    -- 滚动框架
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, 0, 1, -40)
    scrollFrame.Position = UDim2.new(0, 0, 0, 40)
    scrollFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    scrollFrame.BackgroundTransparency = 0.1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.ScrollBarThickness = 6
    scrollFrame.Parent = mainFrame
    
    local uiList = Instance.new("UIListLayout")
    uiList.Padding = UDim.new(0, 5)
    uiList.SortOrder = Enum.SortOrder.LayoutOrder
    uiList.Parent = scrollFrame
    
    -- 开关类
    local function createToggle(parent, text, defaultValue, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -20, 0, 35)
        frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        frame.BorderSizePixel = 0
        frame.Parent = parent
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Font = Enum.Font.Gotham
        label.Parent = frame
        
        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Size = UDim2.new(0, 50, 0, 25)
        toggleBtn.Position = UDim2.new(1, -60, 0.5, -12.5)
        toggleBtn.BackgroundColor3 = defaultValue and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(150, 150, 150)
        toggleBtn.Text = defaultValue and "开" or "关"
        toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggleBtn.TextSize = 12
        toggleBtn.Font = Enum.Font.GothamBold
        toggleBtn.BorderSizePixel = 0
        toggleBtn.Parent = frame
        
        local state = defaultValue
        toggleBtn.MouseButton1Click:Connect(function()
            state = not state
            toggleBtn.BackgroundColor3 = state and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(150, 150, 150)
            toggleBtn.Text = state and "开" or "关"
            if callback then callback(state) end
        end)
        
        return function() return state end
    end
    
    -- 按钮类
    local function createButton(parent, text, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -20, 0, 35)
        frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        frame.BorderSizePixel = 0
        frame.Parent = parent
        
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -20, 1, -5)
        btn.Position = UDim2.new(0, 10, 0, 2.5)
        btn.BackgroundColor3 = Color3.fromRGB(60, 60, 200)
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 14
        btn.Font = Enum.Font.GothamBold
        btn.BorderSizePixel = 0
        btn.Parent = frame
        
        btn.MouseButton1Click:Connect(callback)
    end
    
    -- 滑块类
    local function createSlider(parent, text, min, max, default, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -20, 0, 50)
        frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        frame.BorderSizePixel = 0
        frame.Parent = parent
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 20)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = text .. ": " .. tostring(default)
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Font = Enum.Font.Gotham
        label.Parent = frame
        
        local slider = Instance.new("TextButton")
        slider.Size = UDim2.new(0.8, 0, 0, 5)
        slider.Position = UDim2.new(0.1, 0, 0.6, 0)
        slider.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        slider.BorderSizePixel = 0
        slider.AutoButtonColor = false
        slider.Parent = frame
        
        local handle = Instance.new("TextButton")
        handle.Size = UDim2.new(0, 15, 0, 15)
        handle.Position = UDim2.new((default - min) / (max - min), -7.5, 0.5, -7.5)
        handle.BackgroundColor3 = Color3.fromRGB(60, 60, 200)
        handle.BorderSizePixel = 0
        handle.AutoButtonColor = false
        handle.Parent = slider
        
        local currentValue = default
        local dragging = false
        
        local function updateSlider(mouseX)
            local relX = math.clamp((mouseX - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
            currentValue = math.floor(min + (max - min) * relX + 0.5)
            handle.Position = UDim2.new(relX, -7.5, 0.5, -7.5)
            label.Text = text .. ": " .. tostring(currentValue)
            if callback then callback(currentValue) end
        end
        
        slider.MouseButton1Down:Connect(function()
            dragging = true
            local connection
            connection = game:GetService("UserInputService").InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
                    updateSlider(input.Position.X)
                end
            end)
            game:GetService("UserInputService").InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                    connection:Disconnect()
                end
            end)
        end)
    end
    
    -- 创建UI元素
    local config = {
        FromATM = true,
        FromBank = false,
        AutoVest = true,
        AutoHealth = true,
        AutoKZ = false,
        AutoBX = false,
        AutoZBD = false,
        AutoSell = false,
        AutoRemove = false,
        AutoUse = false,
        AutoXYWP = false,
        AutoXYBS = false,
        AutoPTBS = false,
        AutoMoney = false,
        AutoBlock = false,
        AutoMoss = false,
        AutoCard = false,
        AutoBalloon = false,
        AntiDoll = true,
        AntiAdmin = false,
        CallPhone = false,
        AutoCuff = false,
    }
    
    -- ATM
    createToggle(scrollFrame, "自动摧毁ATM", config.FromATM, function(state)
        config.FromATM = state
    end)
    
    -- 银行
    createToggle(scrollFrame, "自动偷盗银行", config.FromBank, function(state)
        config.FromBank = state
    end)
    
    -- 护甲
    createToggle(scrollFrame, "自动护甲", config.AutoVest, function(state)
        config.AutoVest = state
    end)
    
    -- 回血
    createToggle(scrollFrame, "自动回血", config.AutoHealth, function(state)
        config.AutoHealth = state
    end)
    
    -- 口罩
    createToggle(scrollFrame, "自动口罩", config.AutoKZ, function(state)
        config.AutoKZ = state
    end)
    
    -- 开保险
    createToggle(scrollFrame, "自动开保险", config.AutoBX, function(state)
        config.AutoBX = state
    end)
    
    -- 珠宝店
    createToggle(scrollFrame, "自动珠宝店", config.AutoZBD, function(state)
        config.AutoZBD = state
    end)
    
    -- 售卖
    createToggle(scrollFrame, "自动售卖", config.AutoSell, function(state)
        config.AutoSell = state
    end)
    
    -- 移除垃圾
    createToggle(scrollFrame, "自动移除垃圾", config.AutoRemove, function(state)
        config.AutoRemove = state
    end)
    
    -- 使用消耗品
    createToggle(scrollFrame, "自动使用消耗品", config.AutoUse, function(state)
        config.AutoUse = state
    end)
    
    -- 稀有物品
    createToggle(scrollFrame, "自动寻找稀有物品", config.AutoXYWP, function(state)
        config.AutoXYWP = state
    end)
    
    -- 稀有宝石
    createToggle(scrollFrame, "自动寻找稀有宝石", config.AutoXYBS, function(state)
        config.AutoXYBS = state
    end)
    
    -- 普通宝石
    createToggle(scrollFrame, "自动寻找普通宝石", config.AutoPTBS, function(state)
        config.AutoPTBS = state
    end)
    
    -- 印钞机
    createToggle(scrollFrame, "自动寻找印钞机", config.AutoMoney, function(state)
        config.AutoMoney = state
    end)
    
    -- 幸运方块
    createToggle(scrollFrame, "自动寻找幸运方块", config.AutoBlock, function(state)
        config.AutoBlock = state
    end)
    
    -- 礼物
    createToggle(scrollFrame, "自动寻找礼物", config.AutoMoss, function(state)
        config.AutoMoss = state
    end)
    
    -- 红卡
    createToggle(scrollFrame, "自动寻找红卡", config.AutoCard, function(state)
        config.AutoCard = state
    end)
    
    -- 反布娃娃
    createToggle(scrollFrame, "反布娃娃", config.AntiDoll, function(state)
        config.AntiDoll = state
    end)
    
    -- 反管理员
    createToggle(scrollFrame, "反管理员", config.AntiAdmin, function(state)
        config.AntiAdmin = state
    end)
    
    -- 关闭按钮
    createButton(scrollFrame, "关闭UI", function()
        screenGui:Destroy()
        print("UI已关闭")
    end)
    
    -- 更新画布大小
    uiList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, uiList.AbsoluteContentSize.Y + 20)
    end)
    
    print("UI已创建，可以在游戏内调整设置")
    
    -- ====== 功能实现 ======
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local Workspace = game:GetService("Workspace")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local TweenService = game:GetService("TweenService")
    
    local localPlayer = Players.LocalPlayer
    local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")
    
    local devv = require(ReplicatedStorage:WaitForChild("devv"))
    local Signal = devv.client.Helpers.remotes.Signal
    local FireServer = Signal.FireServer
    local InvokeServer = Signal.InvokeServer
    local Inventory = devv.load("v3item").inventory
    local items = Inventory.items
    
    local function GetGuid(name)
        for _, v in pairs(items) do
            if v.name == name then
                return v.guid
            end
        end
        return nil
    end
    
    local function Teleport(cframe)
        local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(rootPart, tweenInfo, {CFrame = cframe})
        tween:Play()
        tween.Completed:Wait()
    end
    
    -- 物品缓存
    local itemMap = {}
    local function updateItemCache()
        local itemPickup = Workspace:FindFirstChild("Game")
        if itemPickup then
            itemPickup = itemPickup:FindFirstChild("Entities")
            if itemPickup then
                itemPickup = itemPickup:FindFirstChild("ItemPickup")
                if itemPickup then
                    itemMap = {}
                    for _, model in pairs(itemPickup:GetChildren()) do
                        for _, v in pairs(model:GetDescendants()) do
                            if (v:IsA("MeshPart") or v:IsA("Part")) and v:FindFirstChildOfClass("ProximityPrompt") then
                                local prompt = v:FindFirstChildOfClass("ProximityPrompt")
                                if prompt and prompt.ObjectText then
                                    itemMap[prompt.ObjectText] = {
                                        part = v,
                                        prompt = prompt
                                    }
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    updateItemCache()
    
    local function Autoitem(itemName)
        local itemData = itemMap[itemName]
        if itemData then
            pcall(function()
                rootPart.CFrame = itemData.part.CFrame * CFrame.new(0, 2, 0)
                task.wait(0.1)
                itemData.prompt.RequiresLineOfSight = false
                itemData.prompt.HoldDuration = 0
                fireproximityprompt(itemData.prompt)
            end)
            return true
        end
        return false
    end
    
    -- ATM摧毁
    RunService.Heartbeat:Connect(function()
        if not config.FromATM then return end
        
        local atms = Workspace:FindFirstChild("ATMs")
        if not atms then return end
        
        local hrp = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        local nearestATM, shortestDist = nil, math.huge
        for _, v in pairs(atms:GetChildren()) do
            if v:IsA("Model") and (v:GetAttribute("health") or 0) > 0 then
                local d = (hrp.Position - v:GetPivot().Position).Magnitude
                if d < shortestDist then
                    shortestDist = d
                    nearestATM = v
                end
            end
        end
        
        if nearestATM then
            local off = Vector3.new(0, -3, 0)
            local rot = CFrame.Angles(1.57079632679, 0, 0)
            hrp.CFrame = (nearestATM:GetPivot() + off) * rot
            task.wait(0.2)
            nearestATM:SetAttribute("health", 0)
            nearestATM:SetAttribute("isDestroyed", true)
            task.wait(1)
        end
    end)
    
    -- 银行偷盗
    local NextThrow = 0
    RunService.Heartbeat:Connect(function()
        if not config.FromBank then return end
        
        local Robbery = Workspace:FindFirstChild("BankRobbery")
        if not Robbery then return end
        
        local Vault = Robbery:FindFirstChild("VaultDoor")
        if not Vault then return end
        
        local VPos = Vault:IsA("Model") and Vault:GetPivot().Position or Vault.Position
        local vaultTarget = Vector3.new(1123.70703125, 13.76093578338623, -353.52301025390625)
        
        if (VPos - vaultTarget).Magnitude < 0.5 then
            if tick() < NextThrow then return end
            NextThrow = tick() + 5
            
            rootPart.CFrame = CFrame.new(1123.54749, 8.31286526, -364.052216)
            
            local TNTGuid = GetGuid('TNT')
            if not TNTGuid then
                InvokeServer("attemptPurchase", "TNT")
                return
            end
            
            local vaultPos = Vector3.new(1123.70703125, 13.76093578338623, -353.52301025390625)
            local direction = (vaultPos - rootPart.Position).Unit
            
            FireServer("equip", TNTGuid)
            FireServer("throwItem", TNTGuid, direction, Vector3.new(1124.0853271484, 5.3128666877747, -357.68710327148))
            FireServer("removeItem", TNTGuid)
        else
            local Cash = Robbery:FindFirstChild("BankCash")
            if Cash then
                local Main = Cash:FindFirstChild("Main")
                if Main then
                    local Att = Main:FindFirstChild("Attachment")
                    if Att then
                        local Prompt = Att:FindFirstChild("ProximityPrompt")
                        if Prompt and Prompt.Enabled then
                            rootPart.CFrame = CFrame.new(1110.40369, 2, -325.485962)
                            FireServer("stealBankCash")
                        end
                    end
                end
            end
        end
    end)
    
    -- 自动拾取现金
    RunService.Heartbeat:Connect(function()
        local cashBundles = Workspace:FindFirstChild("Game")
        if cashBundles then
            cashBundles = cashBundles:FindFirstChild("Entities")
            if cashBundles then
                cashBundles = cashBundles:FindFirstChild("CashBundle")
                if cashBundles then
                    for _, descendant in pairs(cashBundles:GetDescendants()) do
                        if descendant:IsA("ClickDetector") and descendant.Parent then
                            local detectorPos = descendant.Parent:GetPivot().Position
                            local distance = (rootPart.Position - detectorPos).Magnitude
                            if distance <= 20 then
                                fireclickdetector(descendant)
                            end
                        end
                    end
                end
            end
        end
    end)
    
    -- 主要功能循环
    RunService.Heartbeat:Connect(function()
        -- 自动护甲
        if config.AutoVest then
            local veid = GetGuid('Light Vest')
            if not veid then
                InvokeServer('attemptPurchase', 'Light Vest')
                return
            end
            for i, v in next, items do
                if v.subtype == "vest" then
                    local armor = localPlayer:GetAttribute('armor')
                    if armor == nil or armor <= 0 then
                        FireServer("equip", v.guid)
                        FireServer("useConsumable", v.guid)
                        FireServer("removeItem", v.guid)
                    end
                    break
                end
            end
        end
        
        -- 自动回血
        if config.AutoHealth then
            local bdid = GetGuid('Bandage')
            if not bdid then
                InvokeServer('attemptPurchase', 'Bandage')
                return
            end
            for i, v in next, items do
                if v.name == 'Bandage' then
                    local humanoid = character:FindFirstChild("Humanoid")
                    if humanoid and humanoid.Health ~= 0 and humanoid.Health < humanoid.MaxHealth then
                        FireServer("equip", v.guid)
                        FireServer("useConsumable", v.guid)
                        FireServer("removeItem", v.guid)
                    end
                    break
                end
            end
        end
        
        -- 自动口罩
        if config.AutoKZ then
            local Mask = character:FindFirstChild("Black Bandana")
            if not Mask then
                local kzid = GetGuid('Black Bandana')
                if not kzid then
                    InvokeServer('attemptPurchase', 'Black Bandana')
                else
                    FireServer("equip", kzid)
                    FireServer("wearMask", kzid)
                end
            end
        end
        
        -- 自动开保险
        if config.AutoBX then
            local veid = GetGuid('Lockpick')
            if not veid then
                InvokeServer('attemptPurchase', 'Lockpick')
                return
            end
            local chestTypes = {"SmallChest", "LargeChest", "SmallSafe", "MediumSafe", "LargeSafe", "JewelSafe", "GoldJewelSafe"}
            for _, chestType in pairs(chestTypes) do
                local chestFolder = Workspace:FindFirstChild("Game")
                if chestFolder then
                    chestFolder = chestFolder:FindFirstChild("Entities")
                    if chestFolder then
                        chestFolder = chestFolder:FindFirstChild(chestType)
                        if chestFolder then
                            for _, chest in pairs(chestFolder:GetChildren()) do
                                if chest.PrimaryPart then
                                    local prompt = chest:FindFirstChild("ProximityPrompt", true)
                                    if prompt and prompt.Enabled then
                                        Teleport(chest.PrimaryPart.CFrame * CFrame.new(0, 3, 0))
                                        fireproximityprompt(prompt)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        
        -- 自动珠宝店
        if config.AutoZBD then
            local cases = Workspace:FindFirstChild("GemRobbery")
            if cases then
                cases = cases:FindFirstChild("JewelryCases")
                if cases then
                    for _, descendant in pairs(cases:GetDescendants()) do
                        if descendant:IsA("ProximityPrompt") and descendant.ActionText == "Steal" and descendant.Enabled == true then
                            descendant.HoldDuration = 0
                            Teleport(CFrame.new(descendant.Parent.Position + Vector3.new(0, 0, 0)))
                            fireproximityprompt(descendant)
                        end
                    end
                end
            end
        end
        
        -- 自动售卖
        if config.AutoSell then
            for i, v in pairs(items) do
                if (v.type == "Holdable" and v.subtype == "gem" and v.sellPrice < 5000) or (v.subtype == "valuable") or (v.type == "Gun" and v.cost < 3999 and v.name ~= "Raygun") then
                    FireServer("equip", v.guid)
                    FireServer("sellItem", v.guid)
                end
            end
        end
        
        -- 自动移除垃圾
        if config.AutoRemove then
            for i, v in pairs(items) do
                if (v.type == "Consumable" and v.subtype == "food" and v.name ~= "Bandage") or (v.type == "Throwable" and v.cost < 500 and v.name ~= "Ninja Star" and v.name ~= "Tomahawk") or (v.type == "Melee" and v.cost > 100) then
                    FireServer("removeItem", v.guid)
                end
            end
        end
        
        -- 自动使用消耗品
        if config.AutoUse then
            for i, v in pairs(items) do
                if v.type == "Consumable" and v.subtype ~= "vest" and v.subtype ~= "food" and v.name ~= "Lockpick" then
                    FireServer("equip", v.guid)
                    FireServer("useConsumable", v.guid)
                    FireServer("removeItem", v.guid)
                end
            end
        end
        
        -- 自动寻找稀有物品
        if config.AutoXYWP then
            Autoitem("Blue Candy Cane")
            Autoitem("Suitcase Nuke")
            Autoitem("Nuke Launcher")
            Autoitem("Easter Basket")
            Autoitem("Gold Cup")
            Autoitem("Gold Crown")
            Autoitem("Treasure Map")
            Autoitem("Spectral Scythe")
        end
        
        -- 自动寻找稀有宝石
        if config.AutoXYBS then
            Autoitem("Diamond")
            Autoitem("Void Gem")
            Autoitem("Dark Matter Gem")
            Autoitem("Rollie")
            Autoitem("Gold Crown")
            Autoitem("Gold Cup")
            Autoitem("Pearl Necklace")
        end
        
        -- 自动寻找普通宝石
        if config.AutoPTBS then
            Autoitem("Amethyst")
            Autoitem("Sapphire")
            Autoitem("Emerald")
            Autoitem("Topaz")
            Autoitem("Ruby")
        end
        
        -- 自动寻找印钞机
        if config.AutoMoney then
            Autoitem("Money Printer")
        end
        
        -- 自动寻找幸运方块
        if config.AutoBlock then
            Autoitem("Green Lucky Block")
            Autoitem("Orange Lucky Block")
            Autoitem("Purple Lucky Block")
        end
        
        -- 自动寻找礼物
        if config.AutoMoss then
            Autoitem("Medium Present")
            Autoitem("Large Present")
        end
        
        -- 自动寻找红卡
        if config.AutoCard then
            local red = false
            for i, v in next, items do
                if v.name == "Military Armory Keycard" then
                    red = true
                    break
                end
            end
            if not red then
                Autoitem("Military Armory Keycard")
            end
        end
        
        -- 自动寻找气球
        if config.AutoBalloon then
            for _, v in pairs(ReplicatedStorage.devv.shared.Indicies.v3items.bin.Holdable:GetChildren()) do
                if v:IsA("ModuleScript") then
                    local itemData = require(v)
                    if itemData.holdableType == "Balloon" and itemData.name ~= 'Balloon' then
                        Autoitem(v.Name)
                    end
                end
            end
        end
        
        -- 自动口罩
        if config.AutoKZ then
            local Mask = character:FindFirstChild("Black Bandana")
            if not Mask then
                local kzid = GetGuid('Black Bandana')
                if not kzid then
                    InvokeServer('attemptPurchase', 'Black Bandana')
                else
                    FireServer("equip", kzid)
                    FireServer("wearMask", kzid)
                end
            end
        end
    end)
    
    -- 反布娃娃
    RunService.Heartbeat:Connect(function()
        if config.AntiDoll then
            local isRagdolled = localPlayer:GetAttribute("isRagdoll")
            if isRagdolled then
                FireServer("setRagdoll", false)
                local client = devv.load("ClientReplicator")
                client.Set(localPlayer, "ragdolled", false)
                localPlayer:SetAttribute("isRagdoll", false)
            end
        end
    end)
    
    -- 反管理员
    RunService.Heartbeat:Connect(function()
        if config.AntiAdmin then
            for _, player in pairs(Players:GetPlayers()) do
                if player:GetAttribute("clanId") == "6557c057b60ffcc7226f532c" and player ~= localPlayer then
                    localPlayer:Kick('[Anti Admin] Admin UserName = '.. player.Name)
                    break
                end
            end
        end
    end)
    
    print("俄亥俄州脚本已启动！")
end

-- 执行
pcall(OhioWithUI)
