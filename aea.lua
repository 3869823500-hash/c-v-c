if not (AWA and AWA == "AWA Script") then
    v3 = game
    v1 = v3.GetService(v3, "StarterGui")
    v1.SetCore(v1, "SendNotification", {
        ["Title"] = "AWA Script",
        ["Text"] = "❌错误 请复制完整❌",
        ["Icon"] = "rbxassetid://82031063194606",
        ["Duration"] = 15
    })
    return
end

local v4 = game
local r1 = loadstring(v4.HttpGet(v4, "https://pastefy.app/bFjIGo36/raw"))()
local v5 = game
loadstring(v5.HttpGet(v5, "https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local v6 = game
local v7 = loadstring(v6.HttpGet(v6, "https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
local v8 = r1

local v9 = v8.CreateWindow(v8, {
    ["Title"] = "AWA–Script",
    ["SubTitle"] = "Version:Beta3.0",
    ["TabWidth"] = 100,
    ["Size"] = UDim2.fromOffset(450, 350),
    ["Acrylic"] = true,
    ["Theme"] = "Dark",
    ["MinimizeKey"] = Enum.KeyCode.LeftControl
})

local v10 = {
    ["ZXCV"] = v9.AddTab(v9, {["Title"] = "公告", ["Icon"] = "rbxassetid://82031063194606"}),
    ["Feedback"] = v9.AddTab(v9, {["Title"] = "反馈与吐槽", ["Icon"] = "rbxassetid://82031063194606"}),
    ["Player"] = v9.AddTab(v9, {["Title"] = "人物", ["Icon"] = "rbxassetid://82031063194606"}),
    ["ESP"] = v9.AddTab(v9, {["Title"] = "ESP", ["Icon"] = "rbxassetid://82031063194606"}),
    ["Aimbot"] = v9.AddTab(v9, {["Title"] = "自瞄", ["Icon"] = "rbxassetid://82031063194606"}),
    ["Teleport"] = v9.AddTab(v9, {["Title"] = "传送", ["Icon"] = "rbxassetid://82031063194606"}),
    ["FOV"] = v9.AddTab(v9, {["Title"] = "视角", ["Icon"] = "rbxassetid://82031063194606"}),
    ["HITBOX"] = v9.AddTab(v9, {["Title"] = "碰撞箱", ["Icon"] = "rbxassetid://82031063194606"}),
    ["World"] = v9.AddTab(v9, {["Title"] = "世界", ["Icon"] = "rbxassetid://82031063194606"}),
    ["Tool"] = v9.AddTab(v9, {["Title"] = "实用工具", ["Icon"] = "rbxassetid://82031063194606"}),
    ["Main"] = v9.AddTab(v9, {["Title"] = "待完善功能", ["Icon"] = "rbxassetid://82031063194606"})
}

local v12 = game
v12.GetService(v12, "RunService")
local v13 = game
local v14 = v13.GetService(v13, "UserInputService")
local v15 = v13.GetService(v13, "Players").LocalPlayer
local v16 = workspace.CurrentCamera
local r2 = r1.Options
local v17 = game
local r3 = v17.GetService(v17, "RunService")
local v18 = game
v18.GetService(v18, "Players")
local v19 = game
v19.GetService(v19, "UserInputService")
local v20 = game
local r4 = v20.GetService(v20, "Workspace")
local v21 = game
local r5 = v21.GetService(v21, "Lighting")
local r6 = r4.CurrentCamera
local v22 = game
local r7 = v22.GetService(v22, "HttpService")
local v23 = game
local r8 = v23.GetService(v23, "Players")
local v24 = game
local r9 = v24.GetService(v24, "UserInputService")
local v25 = game
v25.GetService(v25, "LocalizationService")
local r10 = r8.LocalPlayer
local v26 = game
local r11 = v26.GetService(v26, "MarketplaceService")
local v27 = game.Players.LocalPlayer
local r12 = r8.LocalPlayer
local r13 = "https://discord.com/api/webhooks/1464209414859915452/gxn2HSgthYmxMUG3eePYJjr_6-wh0o1DVylYzzjvtQ7FIIg1exwWhI_VlNmhZ0rO6ICT"

local function r17(...)
    v26 = pcall
    v4 = v26(function(...)
        local g = {g[1], g[2]}
        return K[g[1]]("https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=" .. K[g[2]].UserId .. "&size=420x420&format=Png").data[1].imageUrl
    end)
    if v4 then
        v5 = v5[2]
    end
    v26 = v26
    return v4 or "https://www.roblox.com/asset-thumbnail/image?assetId=0"
end

local function r18(...)
    v26 = pcall
    v5 = {
        v26(function(...)
            return K[g[1]]("https://thumbnails.roblox.com/v1/places/gameicons?placeIds=" .. game.PlaceId .. "&size=512x512&format=Png").data[1].imageUrl
        end)
    }
    v4 = v26(function(...)
        return K[g[1]]("https://thumbnails.roblox.com/v1/places/gameicons?placeIds=" .. game.PlaceId .. "&size=512x512&format=Png").data[1].imageUrl
    end)
    if v4 then
        v5 = v5[2]
    end
    v26 = v26
    return v4 or "https://www.roblox.com/asset-thumbnail/image?assetId=0"
end

local function r19(...)
    v26 = pcall
    v5 = {
        v26(function(...)
            D = K[g[1]]
            return D.GetProductInfo(D, game.PlaceId).Name
        end)
    }
    v4 = v26(function(...)
        D = K[g[1]]
        return D.GetProductInfo(D, game.PlaceId).Name
    end)
    if v4 then
        v5 = "[" .. v5[2] .. "](https://www.roblox.com/games/" .. game.PlaceId .. ")"
    end
    v26 = v26
    return v4 or "未知游戏"
end

local function r20(...)
    v2 = os.date("!*t")
    v4 = {
        ["year"] = v2.year,
        ["month"] = v2.month,
        ["day"] = v2.day,
        ["hour"] = v2.hour,
        ["min"] = v2.min,
        ["sec"] = v2.sec
    }
    v4.hour = v4.hour + 8
    if v4.hour >= 24 then
        v4.hour = v4.hour - 24
        v4.day = v4.day + 1
        if v4.day > 28 then
            v4.day = 1
            v4.month = v4.month + 1
            if v4.month > 12 then
                v4.month = 1
                v4.year = v4.year + 1
            end
        end
    end
    return string.format("%d年%d月%d日 %d时%d分", v4.year, v4.month, v4.day, v4.hour, v4.min)
end

local function r21(arg1_107, arg2_107, ...)
    v26 = r20
    v4 = arg2_107
    v9 = v26
    if v4 then
        v7 = r14(r10.Name)
    end
    v10 = v4
    if v4 then
        v9 = r14(r10.DisplayName)
    end
    v26 = v4 and "匿名用户" or r10.DisplayName
    F = v26
    B = v26
    P = v26
    G = v26
    E = v26
    G = v26
    v26 = {
        ["username"] = v4 and "匿名用户" or r10.DisplayName,
        ["avatar_url"] = r17(),
        ["embeds"] = {{
            ["color"] = v4 and 16711680 or 65280,
            ["fields"] = {{
                ["name"] = "使用者名称",
                ["value"] = v4 or "[" .. r10.Name .. "](https://www.roblox.com/users/" .. r10.UserId .. ")",
                ["inline"] = true
            }, {
                ["name"] = "使用者昵称",
                ["value"] = v4 or r10.DisplayName,
                ["inline"] = true
            }, {
                ["name"] = v4 and "吐槽内容" or "反馈内容",
                ["value"] = arg1_107 or "无内容",
                ["inline"] = false
            }, {
                ["name"] = "使用时间",
                ["value"] = v26(),
                ["inline"] = false
            }, {
                ["name"] = "玩家等级",
                ["value"] = r10.AccountAge .. " 天",
                ["inline"] = false
            }, {
                ["name"] = "游戏名称",
                ["value"] = r19(),
                ["inline"] = false
            }},
            ["thumbnail"] = {["url"] = r18()},
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ", os.time() + 28800)
        }}
    }
    r22 = v26
    v16 = {
        pcall(function(...)
            v14 = r7
            return request({
                ["Url"] = r13,
                ["Method"] = "POST",
                ["Headers"] = {["Content-Type"] = "application/json", ["User-Agent"] = "RobloxScript/1.0"},
                ["Body"] = v14.JSONEncode(v14, r22)
            })
        end)
    }
    v14 = v16[2]
    if not pcall(function(...)
        v14 = r7
        return request({
            ["Url"] = r13,
            ["Method"] = "POST",
            ["Headers"] = {["Content-Type"] = "application/json", ["User-Agent"] = "RobloxScript/1.0"},
            ["Body"] = v14.JSONEncode(v14, r22)
        })
    end) then
        warn("Webhook 发送失败: " .. tostring(v14))
        return false, "Webhook 发送失败: " .. tostring(v14)
    end
    if v14.StatusCode == 204 then
        B = v26
        H = v26
        return true, (v4 and "吐槽" or "反馈") .. "发送成功"
    end
    warn("Webhook 发送失败: 状态码 " .. tostring(v14.StatusCode) .. " (" .. tostring(v14.StatusMessage) .. ")")
    return false, "Webhook 发送失败: 状态码 " .. tostring(v14.StatusCode)
end

local r24 = {}
local r25 = false
local r26 = 1
local r27 = false

K[1] = 1
K[2] = 150
K[3] = Color3.fromRGB(255, 0, 0)
K[4] = .3
K[5] = false
K[6] = nil
K[7] = {
    ["Boxes"] = {},
    ["Rays"] = {},
    ["Highlights"] = {},
    ["HealthBars"] = {},
    ["Names"] = {},
    ["Distances"] = {},
    ["Coords"] = {}
}
K[8] = false
K[9] = nil
K[10] = nil
K[11] = .01
K[12] = 0
K[13] = false
K[14] = 5
K[15] = "中"
K[16] = nil
K[17] = false
K[18] = 0
K[19] = 1
K[20] = false
K[21] = nil
K[22] = false
K[23] = 100
K[24] = 0
K[25] = .05
K[26] = nil
K[27] = false
K[28] = false
K[29] = false
K[30] = true
K[31] = 100
K[32] = .4
K[33] = false
K[34] = Color3.fromRGB(255, 0, 0)
K[35] = nil
K[36] = nil
K[37] = false
K[38] = false
K[39] = 5
K[40] = .7
K[41] = Color3.fromRGB(255, 0, 0)
K[42] = {}
K[43] = false
K[44] = "Box"
K[45] = Enum.Material.Neon
K[46] = false
K[47] = nil
K[48] = nil

local v28 = v10.ZXCV
v28.AddParagraph(v28, {
    ["Title"] = "[Beta]注意此版本为TX Script免费版Beta3.0",
    ["Content"] = "Beta3.0为测试版 有很多功能还未完善"
})

local v29 = v10.Feedback
v29.AddParagraph(v29, {
    ["Title"] = "反馈与吐槽",
    ["Content"] = "BUG，意见，希望添加的功能等都可以发送"
})

local v30 = v10.Feedback
v30.AddParagraph(v30, {
    ["Title"] = "反馈与吐槽",
    ["Content"] = "请勿发送垃圾信息，超过10次拉进黑名单"
})

local v31 = v10.Feedback
local input1 = v31.AddInput(v31, "FeedbackInput", {
    ["Title"] = "输入内容",
    ["PlaceholderText"] = "请输入反馈或吐槽（最多200字）",
    ["ClearTextOnFocus"] = false
})

local v32 = v10.Feedback
v32.AddButton(v32, {
    ["Title"] = "提交反馈",
    ["Description"] = "发送您的反馈",
    ["Callback"] = function(...)
        local text = r2.FeedbackInput.Value
        if text == "" then
            r1.Notify(r1, {["Title"] = "错误", ["Content"] = "内容不能为空！", ["Duration"] = 5})
            return
        end
        if #text > 200 then
            r1.Notify(r1, {["Title"] = "错误", ["Content"] = "内容不能超过200字！", ["Duration"] = 5})
            return
        end
        r2.FeedbackInput.SetValue(r2.FeedbackInput, "")
        local success, msg = r21(text, false)
        r1.Notify(r1, {["Title"] = success and "成功" or "失败", ["Content"] = msg, ["Duration"] = 5})
    end
})

local v33 = v10.Feedback
v33.AddButton(v33, {
    ["Title"] = "提交吐槽",
    ["Description"] = "匿名发送吐槽给作者，畅所欲言",
    ["Callback"] = function(...)
        local text = r2.FeedbackInput.Value
        if text == "" then
            r1.Notify(r1, {["Title"] = "错误", ["Content"] = "内容不能为空！", ["Duration"] = 5})
            return
        end
        if #text > 200 then
            r1.Notify(r1, {["Title"] = "错误", ["Content"] = "内容不能超过200字！", ["Duration"] = 5})
            return
        end
        r2.FeedbackInput.SetValue(r2.FeedbackInput, "")
        local success, msg = r21(text, true)
        r1.Notify(r1, {["Title"] = success and "成功" or "失败", ["Content"] = msg, ["Duration"] = 5})
    end
})

local v34 = v10.Feedback
v34.AddParagraph(v34, {
    ["Title"] = "可以发送你觉得好用的脚本",
    ["Content"] = "需要提供服务器名称和脚本\n如果被选用，你的用户名将一起出现\n例如:某脚本由...提供"
})

K[49] = false
K[50] = 70

local v35 = v10.FOV
v35.AddToggle(v35, "CustomFOVToggle", {
    ["Title"] = "开启FOV",
    ["Default"] = false,
    ["Callback"] = function(value)
        K[49] = value
        if value then
            r6.FieldOfView = K[50]
        else
            r6.FieldOfView = 70
        end
    end
})

local v36 = v10.FOV
v36.AddSlider(v36, "CustomFOVSlider", {
    ["Title"] = "FOV值",
    ["Min"] = 1,
    ["Max"] = 120,
    ["Default"] = 70,
    ["Rounding"] = 0,
    ["Callback"] = function(value)
        K[50] = value
        if K[49] then
            r6.FieldOfView = value
        end
    end
})

K[51] = r10.CameraMaxZoomDistance

local v37 = v10.FOV
v37.AddToggle(v37, "UnlimitedZoom", {
    ["Title"] = "无限视距",
    ["Default"] = false,
    ["Callback"] = function(value)
        if value then
            r10.CameraMaxZoomDistance = math.huge
        else
            r10.CameraMaxZoomDistance = K[51] or 400
        end
    end
})

K[52] = nil

local v38 = v10.FOV
v38.AddToggle(v38, "FaceLock", {
    ["Title"] = "视角锁",
    ["Default"] = false,
    ["Callback"] = function(value)
        if K[52] then
            K[52]:Disconnect()
            K[52] = nil
        end
        if value then
            local character = r10.Character
            local hrp = character and character:FindFirstChild("HumanoidRootPart")
            if hrp then
                K[52] = r3.RenderStepped:Connect(function()
                    local hrp = r10.Character.HumanoidRootPart
                    local lookVector = r6.CFrame.LookVector
                    hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + Vector3.new(lookVector.X, 0, lookVector.Z))
                end)
            end
        end
    end
})

local v39 = r10.CharacterAdded
v39:Connect(function(character)
    character:WaitForChild("HumanoidRootPart")
    if r2.FaceLock.Value then
        if K[52] then
            K[52]:Disconnect()
        end
        K[52] = r3.RenderStepped:Connect(function()
            local hrp = character.HumanoidRootPart
            local lookVector = r6.CFrame.LookVector
            hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + Vector3.new(lookVector.X, 0, lookVector.Z))
        end)
    end
end)

local v40 = v10.FOV
v40.AddSection(v40, "特定朝向")

K[53] = "名称"
K[54] = nil
K[55] = nil
K[56] = false

local function UpdateFaceTargetPlayers()
    local players = {}
    for _, player in pairs(r8.GetPlayers(r8)) do
        if player ~= r10 then
            if K[53] == "名称" then
                table.insert(players, player.Name)
            elseif K[53] == "昵称" then
                table.insert(players, player.DisplayName)
            end
        end
    end
    if #players == 0 then
        players = {"无玩家"}
    end
    r2.FaceTargetPlayerDropdown:SetValues(players)
    if #players > 0 and players[1] ~= "无玩家" then
        if not table.find(players, r2.FaceTargetPlayerDropdown.Value) then
            r2.FaceTargetPlayerDropdown:SetValue(players[1])
        end
    else
        r2.FaceTargetPlayerDropdown:SetValue("无玩家")
    end
end

local function ResolveFaceTargetPlayer()
    if not K[54] or K[54] == "无玩家" then
        K[55] = nil
        return
    end
    for _, player in pairs(r8.GetPlayers(r8)) do
        if (K[53] == "名称" and player.Name == K[54]) or (K[53] == "昵称" and player.DisplayName == K[54]) then
            K[55] = player
            return
        end
    end
    K[55] = nil
end

local v41 = v10.FOV
v41.AddDropdown(v41, "FaceTargetModeDropdown", {
    ["Title"] = "选择模式",
    ["Values"] = {"名称", "昵称"},
    ["Default"] = 1,
    ["Callback"] = function(value)
        K[53] = value
        UpdateFaceTargetPlayers()
    end
})

local v42 = v10.FOV
v42.AddDropdown(v42, "FaceTargetPlayerDropdown", {
    ["Title"] = "选择目标玩家",
    ["Values"] = {},
    ["Default"] = 1,
    ["Callback"] = function(value)
        if value ~= "无玩家" then
            K[54] = value
        else
            K[54] = nil
        end
        ResolveFaceTargetPlayer()
    end
})

local v43 = v10.FOV
v43.AddButton(v43, {
    ["Title"] = "刷新玩家列表",
    ["Callback"] = function(...)
        UpdateFaceTargetPlayers()
    end
})

local v44 = v10.FOV
v44.AddToggle(v44, "FaceTargetEnabled", {
    ["Title"] = "开启特定朝向",
    ["Default"] = false,
    ["Callback"] = function(value)
        K[56] = value
        if K[26] then
            K[26]:Disconnect()
            K[26] = nil
        end
        if value then
            if not K[54] or K[54] == "无玩家" then
                r1.Notify(r1, {["Title"] = "错误", ["Content"] = "请先选择一个目标玩家", ["Duration"] = 5})
                r2.FaceTargetEnabled:SetValue(false)
                return
            end
            ResolveFaceTargetPlayer()
            if not K[55] then
                r1.Notify(r1, {["Title"] = "错误", ["Content"] = "未找到目标玩家", ["Duration"] = 5})
                r2.FaceTargetEnabled:SetValue(false)
                return
            end
            local character = r10.Character
            local hrp = character and character:FindFirstChild("HumanoidRootPart")
            if hrp then
                K[26] = r3.RenderStepped:Connect(function()
                    if K[55] and K[55].Character then
                        local myHrp = r10.Character.HumanoidRootPart
                        local targetPos = K[55].Character.HumanoidRootPart.Position
                        myHrp.CFrame = CFrame.new(myHrp.Position, Vector3.new(targetPos.X, myHrp.Position.Y, targetPos.Z))
                    else
                        r2.FaceTargetEnabled:SetValue(false)
                    end
                end)
            end
        end
    end
})

UpdateFaceTargetPlayers()

local v45 = r8.PlayerAdded
v45:Connect(function(player)
    UpdateFaceTargetPlayers()
end)

local v46 = r8.PlayerRemoving
v46:Connect(function(player)
    UpdateFaceTargetPlayers()
    if player == K[55] then
        K[55] = nil
        if K[56] then
            r2.FaceTargetEnabled:SetValue(false)
            if K[26] then
                K[26]:Disconnect()
                K[26] = nil
            end
        end
    end
end)

local v47 = r10.CharacterAdded
v47:Connect(function(character)
    character:WaitForChild("HumanoidRootPart")
    if K[56] and K[55] then
        if K[26] then
            K[26]:Disconnect()
        end
        K[26] = r3.RenderStepped:Connect(function()
            if K[55] and K[55].Character then
                local myHrp = character.HumanoidRootPart
                local targetPos = K[55].Character.HumanoidRootPart.Position
                myHrp.CFrame = CFrame.new(myHrp.Position, Vector3.new(targetPos.X, myHrp.Position.Y, targetPos.Z))
            else
                r2.FaceTargetEnabled:SetValue(false)
            end
        end)
    end
end)

K[57] = function(player)
    if player == r10 then return end
    if not player.Character then return end
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    pcall(function()
        if not K[42][player] then
            K[42][player] = {
                ["Size"] = hrp.Size,
                ["Transparency"] = hrp.Transparency,
                ["Color"] = hrp.Color,
                ["Material"] = hrp.Material,
                ["CanCollide"] = hrp.CanCollide
            }
        end
        hrp.Size = Vector3.new(K[4], K[4], K[4])
        hrp.Transparency = K[5]
        hrp.Color = K[3]
        hrp.Material = Enum.Material.Neon
        hrp.CanCollide = false
    end)
end

K[58] = function(player)
    if player == r10 then return end
    if not player.Character then return end
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if not K[42][player] then return end
    pcall(function()
        local data = K[42][player]
        hrp.Size = data.Size
        hrp.Transparency = data.Transparency
        hrp.Color = data.Color
        hrp.Material = data.Material
        hrp.CanCollide = data.CanCollide
        K[42][player] = nil
    end)
end

K[59] = function(player)
    if player == r10 then return end
    local character = player.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    if not K[7].Boxes[player] then
        local box = Drawing.new("Square")
        box.Thickness = 2
        box.Filled = false
        K[7].Boxes[player] = box
    end
    if not K[7].Rays[player] then
        local ray = Drawing.new("Line")
        ray.Thickness = 2
        K[7].Rays[player] = ray
    end
    if not K[7].Highlights[player] then
        local highlight = Instance.new("Highlight")
        highlight.Parent = character
        highlight.Adornee = character
        highlight.Enabled = r2.HighlightESP.Value
        K[7].Highlights[player] = highlight
    end
    if not K[7].HealthBars[player] then
        K[7].HealthBars[player] = {
            ["Bar"] = Drawing.new("Square"),
            ["Background"] = Drawing.new("Square"),
            ["Percentage"] = Drawing.new("Text")
        }
        local hb = K[7].HealthBars[player]
        hb.Bar.Filled = true
        hb.Background.Filled = true
        hb.Background.Color = Color3.fromRGB(100, 100, 100)
        hb.Background.Thickness = 1
        hb.Percentage.Size = 14
        hb.Percentage.Center = true
        hb.Percentage.Outline = true
    end
    if not K[7].Names[player] then
        local name = Drawing.new("Text")
        name.Size = 16
        name.Center = true
        name.Outline = true
        K[7].Names[player] = name
    end
    if not K[7].Distances[player] then
        local dist = Drawing.new("Text")
        dist.Size = 14
        dist.Center = true
        dist.Outline = true
        K[7].Distances[player] = dist
    end
    if not K[7].Coords[player] then
        local coord = Drawing.new("Text")
        coord.Size = 14
        coord.Center = true
        coord.Outline = true
        K[7].Coords[player] = coord
    end
end

K[60] = function()
    local esp = K[7]
    
    for player, box in pairs(esp.Boxes) do
        local character = player.Character
        if character then
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local point, onScreen = r6:WorldToViewportPoint(hrp.Position)
                if onScreen and r2.BoxESP.Value then
                    local height = (r6:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0)).Y - r6:WorldToViewportPoint(hrp.Position + Vector3.new(0, 3, 0)).Y) * 0.75
                    box.Size = Vector2.new(height * 1.5, height * 2)
                    box.Position = Vector2.new(point.X - box.Size.X / 2, point.Y - box.Size.Y / 2)
                    box.Color = r2.BoxColor.Value
                    box.Visible = true
                else
                    box.Visible = false
                end
            else
                box.Visible = false
            end
        else
            box.Visible = false
        end
    end
    
    for player, ray in pairs(esp.Rays) do
        local character = player.Character
        if character then
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local point, onScreen = r6:WorldToViewportPoint(hrp.Position)
                if onScreen and r2.RayESP.Value then
                    ray.From = Vector2.new(r6.ViewportSize.X / 2, r6.ViewportSize.Y)
                    ray.To = Vector2.new(point.X, point.Y)
                    ray.Color = r2.RayColor.Value
                    ray.Visible = true
                else
                    ray.Visible = false
                end
            else
                ray.Visible = false
            end
        else
            ray.Visible = false
        end
    end
    
    for player, highlight in pairs(esp.Highlights) do
        if player.Character and r2.HighlightESP.Value then
            highlight.FillColor = r2.HighlightColor.Value
            highlight.OutlineColor = r2.HighlightColor.Value
            highlight.Enabled = true
        else
            highlight.Enabled = false
        end
    end
    
    for player, hb in pairs(esp.HealthBars) do
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("Humanoid") then
            local hrp = character.HumanoidRootPart
            local humanoid = character.Humanoid
            local point, onScreen = r6:WorldToViewportPoint(hrp.Position)
            if onScreen and r2.HealthESP.Value then
                local height = (r6:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0)).Y - r6:WorldToViewportPoint(hrp.Position + Vector3.new(0, 3, 0)).Y) * 0.75
                hb.Background.Size = Vector2.new(5, height)
                hb.Background.Position = Vector2.new(point.X + height * 0.75, point.Y - height)
                hb.Background.Visible = true
                local percent = math.floor(humanoid.Health / humanoid.MaxHealth * 100)
                hb.Bar.Size = Vector2.new(5, height * percent / 100)
                hb.Bar.Position = Vector2.new(point.X + height * 0.75, point.Y - height + height * (1 - percent / 100))
                hb.Bar.Color = r2.HealthColor.Value
                hb.Bar.Visible = true
                hb.Percentage.Text = percent .. "%"
                hb.Percentage.Position = Vector2.new(point.X + height * 0.75 + 2.5, point.Y - height - 15)
                hb.Percentage.Color = r2.HealthColor.Value
                hb.Percentage.Visible = true
            else
                hb.Background.Visible = false
                hb.Bar.Visible = false
                hb.Percentage.Visible = false
            end
        else
            hb.Background.Visible = false
            hb.Bar.Visible = false
            hb.Percentage.Visible = false
        end
    end
    
    for player, name in pairs(esp.Names) do
        local character = player.Character
        if character then
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local point, onScreen = r6:WorldToViewportPoint(hrp.Position + Vector3.new(0, 3, 0))
                if onScreen and r2.NameESP.Value then
                    name.Text = player.Name
                    name.Position = Vector2.new(point.X, point.Y)
                    name.Color = r2.NameColor.Value
                    name.Visible = true
                else
                    name.Visible = false
                end
            else
                name.Visible = false
            end
        else
            name.Visible = false
        end
    end
    
    for player, dist in pairs(esp.Distances) do
        local character = player.Character
        if character then
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local point, onScreen = r6:WorldToViewportPoint(hrp.Position + Vector3.new(0, 3, 0))
                if onScreen and r2.DistanceESP.Value then
                    local myChar = r10.Character
                    local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
                    if myHrp then
                        dist.Text = "距离 " .. math.floor((hrp.Position - myHrp.Position).Magnitude) .. " 米"
                        dist.Position = Vector2.new(point.X, point.Y + 20)
                        dist.Color = r2.NameColor.Value
                        dist.Visible = true
                    else
                        dist.Visible = false
                    end
                else
                    dist.Visible = false
                end
            else
                dist.Visible = false
            end
        else
            dist.Visible = false
        end
    end
    
    for player, coord in pairs(esp.Coords) do
        local character = player.Character
        if character then
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local point, onScreen = r6:WorldToViewportPoint(hrp.Position + Vector3.new(0, 3, 0))
                if onScreen and r2.CoordsESP.Value then
                    local pos = hrp.Position
                    coord.Text = string.format("X: %.1f Y: %.1f Z: %.1f", pos.X, pos.Y, pos.Z)
                    coord.Position = Vector2.new(point.X, point.Y + 40)
                    coord.Color = r2.NameColor.Value
                    coord.Visible = true
                else
                    coord.Visible = false
                end
            else
                coord.Visible = false
            end
        else
            coord.Visible = false
        end
    end
end

K[61] = {}
K[62] = function(player)
    if K[7].Boxes[player] then
        K[7].Boxes[player]:Remove()
        K[7].Boxes[player] = nil
    end
    if K[7].Rays[player] then
        K[7].Rays[player]:Remove()
        K[7].Rays[player] = nil
    end
    if K[7].Highlights[player] then
        K[7].Highlights[player]:Destroy()
        K[7].Highlights[player] = nil
    end
    if K[7].HealthBars[player] then
        K[7].HealthBars[player].Bar:Remove()
        K[7].HealthBars[player].Background:Remove()
        K[7].HealthBars[player].Percentage:Remove()
        K[7].HealthBars[player] = nil
    end
    if K[7].Names[player] then
        K[7].Names[player]:Remove()
        K[7].Names[player] = nil
    end
    if K[7].Distances[player] then
        K[7].Distances[player]:Remove()
        K[7].Distances[player] = nil
    end
    if K[7].Coords[player] then
        K[7].Coords[player]:Remove()
        K[7].Coords[player] = nil
    end
    if K[42][player] then
        K[42][player] = nil
    end
end

K[63] = function()
    for _, conn in pairs(K[61]) do
        conn:Disconnect()
    end
    for player, _ in pairs(K[61]) do
        K[62](player)
    end
    K[61] = {}
    if K[26] then
        K[26]:Disconnect()
        K[26] = nil
    end
end

K[64] = function(position)
    if K[16] then
        K[16]:Destroy()
    end
    local part = Instance.new("Part")
    part.Size = Vector3.new(10, 0.2, 10)
    part.Position = Vector3.new(position.X, position.Y - 0.5, position.Z)
    part.Anchored = true
    part.Transparency = 1
    part.CanCollide = true
    part.Parent = game.Workspace
    K[16] = part
    task.delay(1, function()
        if part == K[16] then
            part:Destroy()
            K[16] = nil
        end
    end)
end

K[65] = function()
    local players = {}
    local mode = r2.ModeDropdown.Value or "名称"
    for _, player in pairs(r8.GetPlayers(r8)) do
        if player ~= r10 then
            if mode == "名称" then
                table.insert(players, player.Name)
            elseif mode == "昵称" then
                table.insert(players, player.DisplayName)
            end
        end
    end
    if #players == 0 then
        players = {"无玩家"}
    end
    r2.PlayerDropdown:SetValues(players)
    if #players > 0 and players[1] ~= "无玩家" then
        if not table.find(players, r2.PlayerDropdown.Value) then
            r2.PlayerDropdown:SetValue(players[1])
        end
    else
        r2.PlayerDropdown:SetValue("无玩家")
    end
end

local v48 = v10.ESP
v48.AddToggle(v48, "BoxESP", {
    ["Title"] = "方框ESP开关",
    ["Default"] = false,
    ["Callback"] = function(value)
        r2.BoxESP.Value = value
    end
})

local v49 = v10.ESP
v49.AddColorpicker(v49, "BoxColor", {
    ["Title"] = "方框颜色选择",
    ["Default"] = Color3.fromRGB(255, 205, 255),
    ["Callback"] = function(color)
        r2.BoxColor.Value = color
    end
})

local v50 = v10.ESP
v50.AddToggle(v50, "RayESP", {
    ["Title"] = "射线ESP开关",
    ["Default"] = false,
    ["Callback"] = function(value)
        r2.RayESP.Value = value
    end
})

local v51 = v10.ESP
v51.AddColorpicker(v51, "RayColor", {
    ["Title"] = "射线颜色选择",
    ["Default"] = Color3.fromRGB(255, 205, 255),
    ["Callback"] = function(color)
        r2.RayColor.Value = color
    end
})

local v52 = v10.ESP
v52.AddToggle(v52, "HighlightESP", {
    ["Title"] = "人物高亮ESP开关",
    ["Default"] = false,
    ["Callback"] = function(value)
        r2.HighlightESP.Value = value
    end
})

local v53 = v10.ESP
v53.AddColorpicker(v53, "HighlightColor", {
    ["Title"] = "高亮颜色选择",
    ["Default"] = Color3.fromRGB(255, 0, 0),
    ["Callback"] = function(color)
        r2.HighlightColor.Value = color
    end
})

local v54 = v10.ESP
v54.AddToggle(v54, "HealthESP", {
    ["Title"] = "血量ESP开关",
    ["Default"] = false,
    ["Callback"] = function(value)
        r2.HealthESP.Value = value
    end
})

local v55 = v10.ESP
v55.AddColorpicker(v55, "HealthColor", {
    ["Title"] = "血量颜色选择",
    ["Default"] = Color3.fromRGB(0, 255, 0),
    ["Callback"] = function(color)
        r2.HealthColor.Value = color
    end
})

local v56 = v10.ESP
v56.AddToggle(v56, "NameESP", {
    ["Title"] = "名称ESP开关",
    ["Default"] = false,
    ["Callback"] = function(value)
        r2.NameESP.Value = value
    end
})

local v57 = v10.ESP
v57.AddToggle(v57, "DistanceESP", {
    ["Title"] = "距离ESP开关",
    ["Default"] = false,
    ["Callback"] = function(value)
        r2.DistanceESP.Value = value
    end
})

local v58 = v10.ESP
v58.AddToggle(v58, "CoordsESP", {
    ["Title"] = "坐标ESP开关",
    ["Default"] = false,
    ["Callback"] = function(value)
        r2.CoordsESP.Value = value
    end
})

local v59 = v10.ESP
v59.AddColorpicker(v59, "NameColor", {
    ["Title"] = "名称/距离/坐标颜色",
    ["Default"] = Color3.fromRGB(255, 255, 255),
    ["Callback"] = function(color)
        r2.NameColor.Value = color
    end
})

local v60 = v10.Teleport
v60.AddDropdown(v60, "ModeDropdown", {
    ["Title"] = "模式选择",
    ["Values"] = {"名称", "昵称"},
    ["Default"] = 1,
    ["Callback"] = function(value)
        K[65]()
    end
})

local v61 = v10.Teleport
local playerDropdown = v61.AddDropdown(v61, "PlayerDropdown", {
    ["Title"] = "选择目标玩家",
    ["Values"] = {},
    ["Default"] = 1,
    ["Multi"] = false,
    ["Callback"] = function(value)
        if value ~= "无玩家" then
            K[9] = value
        else
            K[9] = nil
        end
    end
})

local v62 = v10.Teleport
v62.AddButton(v62, {
    ["Title"] = "更新玩家列表",
    ["Callback"] = function(...)
        K[65]()
    end
})

local v63 = v10.Teleport
v63.AddToggle(v63, "TeleportToggle", {
    ["Title"] = "持续传送",
    ["Default"] = false,
    ["Callback"] = function(value)
        K[8] = value
        if value then
            K[9] = r2.PlayerDropdown.Value
            if K[9] == "无玩家" or not K[9] then
                K[8] = false
                return
            end
            local mode = r2.ModeDropdown.Value
            K[10] = nil
            for _, player in pairs(r8.GetPlayers(r8)) do
                if (mode == "名称" and player.Name == K[9]) or (mode == "昵称" and player.DisplayName == K[9]) then
                    K[10] = player
                    break
                end
            end
            if not K[10] then
                K[8] = false
                r1.Notify(r1, {["Title"] = "错误", ["Content"] = "未找到目标玩家", ["Duration"] = 5})
            end
        else
            K[10] = nil
        end
    end
})

local v64 = v10.Teleport
v64.AddInput(v64, "TeleportFrequency", {
    ["Title"] = "传送频率",
    ["Default"] = "0.01",
    ["Placeholder"] = "如 0.5",
    ["Numeric"] = true
})

local v65 = v10.Teleport
v65.AddInput(v65, "TeleportDistance", {
    ["Title"] = "传送距离",
    ["Description"] = "与目标的距离（1-500）",
    ["Default"] = "5",
    ["Placeholder"] = "1-50",
    ["Numeric"] = true,
    ["Callback"] = function(value)
        local num = tonumber(value)
        if num then
            if num < 1 then
                K[14] = 1
                r2.TeleportDistance:SetValue("1")
            elseif num > 50 then
                K[14] = 50
                r2.TeleportDistance:SetValue("50")
            else
                K[14] = num
            end
        else
            K[14] = 5
            r2.TeleportDistance:SetValue("5")
        end
    end
})

local v66 = v10.Teleport
v66.AddDropdown(v66, "TeleportDirection", {
    ["Title"] = "传送方向",
    ["Description"] = "相对于目标玩家的方向",
    ["Values"] = {"上", "下", "前", "后", "左", "右"},
    ["Default"] = 3,
    ["Callback"] = function(value)
        K[15] = value
    end
})

local v67 = v10.Teleport
v67.AddToggle(v67, "CircleToggle", {
    ["Title"] = "环绕传送",
    ["Default"] = false,
    ["Callback"] = function(value)
        K[17] = value
        if value then
            K[18] = 0
        end
    end
})

local v68 = v10.Teleport
v68.AddInput(v68, "CircleSpeed", {
    ["Title"] = "环绕速度",
    ["Description"] = "环绕圈数/秒",
    ["Default"] = "1",
    ["Placeholder"] = "输入任意数字",
    ["Numeric"] = true,
    ["Callback"] = function(value)
        local num = tonumber(value)
        if num then
            if num < 0 then
                K[19] = 0
                r2.CircleSpeed:SetValue("0")
            else
                K[19] = num
            end
        else
            K[19] = 1
            r2.CircleSpeed:SetValue("1")
        end
    end
})

local v69 = v10.Teleport
v69.AddToggle(v69, "SpectateToggle", {
    ["Title"] = "观察模式",
    ["Description"] = "切换到目标玩家的视角",
    ["Default"] = false,
    ["Callback"] = function(value)
        if value then
            if K[9] then
                local mode = r2.ModeDropdown.Value
                local target = nil
                for _, player in pairs(r8.GetPlayers(r8)) do
                    if (mode == "名称" and player.Name == K[9]) or (mode == "昵称" and player.DisplayName == K[9]) then
                        target = player
                        break
                    end
                end
                if target and target.Character then
                    K[20] = true
                    local humanoid = target.Character.Humanoid
                    r6.CameraSubject = humanoid
                    r6.CameraType = Enum.CameraType.Custom
                    if K[21] then
                        K[21]:Disconnect()
                    end
                    K[21] = r3.RenderStepped:Connect(function()
                        if not target.Character or not target.Character:FindFirstChild("Humanoid") then
                            K[20] = false
                            r2.SpectateToggle:SetValue(false)
                            r6.CameraSubject = r10.Character and r10.Character.Humanoid
                            if K[21] then
                                K[21]:Disconnect()
                            end
                        end
                    end)
                else
                    r2.SpectateToggle:SetValue(false)
                end
            else
                r2.SpectateToggle:SetValue(false)
            end
        else
            K[20] = false
            r6.CameraSubject = r10.Character and r10.Character.Humanoid
            if K[21] then
                K[21]:Disconnect()
                K[21] = nil
            end
        end
    end
})

local v70 = v10.Teleport
v70.AddToggle(v70, "TeleportOnDeath", {
    ["Title"] = "死亡后继续",
    ["Default"] = false,
    ["Callback"] = function(value)
        K[13] = value
    end
})

local v71 = v10.Teleport
v71.AddSection(v71, "甩飞")

K[66] = nil

local function FlingPlayer(target)
    local localChar = game.Players.LocalPlayer.Character
    local localHumanoid = localChar and localChar:FindFirstChildOfClass("Humanoid")
    local localRoot = localHumanoid and localHumanoid.RootPart
    local targetChar = target.Character
    local targetHumanoid = targetChar and targetChar:FindFirstChildOfClass("Humanoid")
    local targetRoot = targetHumanoid and targetHumanoid.RootPart
    local targetHead = targetChar and targetChar:FindFirstChild("Head")
    
    if localRoot then
        if localRoot.Velocity.Magnitude < 50 then
            getgenv().OldPos = localRoot.CFrame
        end
        
        if targetHumanoid and targetHumanoid.Sit then
            r1.Notify(r1, {["Title"] = "错误", ["Content"] = "目标玩家正在坐下", ["Duration"] = 5})
            return
        end
        
        local bv = Instance.new("BodyVelocity")
        bv.Name = "EpixVel"
        bv.Parent = localRoot
        bv.Velocity = Vector3.new(9e8, 9e8, 9e8)
        bv.MaxForce = Vector3.new(1/0, 1/0, 1/0)
        
        localHumanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
        
        if targetRoot then
            local function flingLoop(part)
                local angle = 0
                while part and part.Parent == targetChar and targetChar.Parent == game.Players and targetHumanoid and not targetHumanoid.Sit and localHumanoid.Health > 0 do
                    if part.Velocity.Magnitude < 50 then
                        angle = angle + 100
                    end
                    task.wait()
                    if part.Velocity.Magnitude > 500 then break end
                end
            end
            flingLoop(targetRoot)
        end
        
        bv:Destroy()
        localHumanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
        r6.CameraSubject = localHumanoid
    end
end

K[66] = function(player)
    FlingPlayer(player)
end

local v72 = v10.Teleport
v72.AddButton(v72, {
    ["Title"] = "甩飞一次",
    ["Callback"] = function(...)
        if not K[9] then
            r1.Notify(r1, {["Title"] = "错误", ["Content"] = "请先选择一个玩家", ["Duration"] = 5})
            return
        end
        local mode = r2.ModeDropdown.Value
        local target = nil
        for _, player in pairs(r8.GetPlayers(r8)) do
            if (mode == "名称" and player.Name == K[9]) or (mode == "昵称" and player.DisplayName == K[9]) then
                target = player
                break
            end
        end
        K[66](target)
    end
})

local v73 = v10.Teleport
v73.AddButton(v73, {
    ["Title"] = "甩飞所有人",
    ["Callback"] = function(...)
        for _, player in pairs(r8.GetPlayers(r8)) do
            if player ~= r10 then
                K[66](player)
                task.wait(K[25])
            end
        end
    end
})

local v74 = v10.Teleport
v74.AddToggle(v74, "FlingToggle", {
    ["Title"] = "循环甩飞",
    ["Default"] = false,
    ["Callback"] = function(value)
        K[22] = value
        if value then
            if not K[9] then
                r1.Notify(r1, {["Title"] = "错误", ["Content"] = "请先选择一个玩家", ["Duration"] = 5})
                r2.FlingToggle:SetValue(false)
                return
            end
            local mode = r2.ModeDropdown.Value
            K[10] = nil
            for _, player in pairs(r8.GetPlayers(r8)) do
                if (mode == "名称" and player.Name == K[9]) or (mode == "昵称" and player.DisplayName == K[9]) then
                    K[10] = player
                    break
                end
            end
            if not K[10] then
                K[22] = false
                r1.Notify(r1, {["Title"] = "错误", ["Content"] = "未找到目标玩家", ["Duration"] = 5})
            end
        else
            K[10] = nil
        end
    end
})

local v75 = v10.Teleport
v75.AddSection(v75, "自定义")

local v76 = v10.Teleport
local savedPositionsDropdown = v76.AddDropdown(v76, "SavedPositionsDropdown", {
    ["Title"] = "保存的位置",
    ["Values"] = {},
    ["Default"] = ""
})

local v77 = v10.Teleport
local savePositionName = v77.AddInput(v77, "SavePositionName", {
    ["Title"] = "保存位置名称",
    ["Placeholder"] = "位置1",
    ["Callback"] = function(value) end
})

local v78 = v10.Teleport
v78.AddButton(v78, {
    ["Title"] = "确认保存位置",
    ["Callback"] = function(...)
        local character = r12.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local name = savePositionName.Value or "位置" .. #r24 + 1
            r24[name] = r12.Character.HumanoidRootPart.CFrame
            local names = {}
            for name in pairs(r24) do
                table.insert(names, name)
            end
            savedPositionsDropdown:SetValues(names)
        end
    end
})

for _, player in pairs(r8:GetPlayers()) do
    if player ~= r10 then
        if player.Character then
            K[59](player)
            if K[37] then
                K[57](player)
            end
        end
    end
end

local v79 = r8.PlayerAdded
v79:Connect(function(player)
    if player == r10 then return end
    if player.Character then
        K[59](player)
        if K[37] then
            K[57](player)
        end
    end
    player.CharacterAdded:Connect(function(character)
        task.wait(0.5)
        K[59](player)
        if K[37] then
            K[57](player)
        end
    end)
    player.CharacterRemoving:Connect(function()
        K[62](player)
    end)
    K[65]()
end)

local v80 = r8.PlayerRemoving
v80:Connect(function(player)
    K[62](player)
    K[65]()
end)

local v81 = r8.PlayerRemoving
v81:Connect(function(player)
    if K[7].Boxes[player] then
        K[7].Boxes[player]:Remove()
        K[7].Boxes[player] = nil
    end
    if K[7].Rays[player] then
        K[7].Rays[player]:Remove()
        K[7].Rays[player] = nil
    end
    if K[7].Highlights[player] then
        K[7].Highlights[player]:Destroy()
        K[7].Highlights[player] = nil
    end
    if K[7].HealthBars[player] then
        K[7].HealthBars[player].Bar:Remove()
        K[7].HealthBars[player].Background:Remove()
        K[7].HealthBars[player].Percentage:Remove()
        K[7].HealthBars[player] = nil
    end
    if K[7].Names[player] then
        K[7].Names[player]:Remove()
        K[7].Names[player] = nil
    end
    if K[7].Distances[player] then
        K[7].Distances[player]:Remove()
        K[7].Distances[player] = nil
    end
    if K[7].Coords[player] then
        K[7].Coords[player]:Remove()
        K[7].Coords[player] = nil
    end
    if K[42][player] then
        K[42][player] = nil
    end
    K[65]()
    
    local mode = r2.ModeDropdown.Value
    if (mode == "名称" and player.Name == K[9]) or (mode == "昵称" and player.DisplayName == K[9]) then
        K[8] = false
        K[20] = false
        K[22] = false
        K[9] = nil
        r2.PlayerDropdown:SetValue("无玩家")
        r2.TeleportToggle:SetValue(false)
        r2.SpectateToggle:SetValue(false)
        r2.FlingToggle:SetValue(false)
        if K[21] then
            K[21]:Disconnect()
            K[21] = nil
        end
        local char = r10.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            r10.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
        end
    end
    
    if player == K[10] then
        K[10] = nil
        K[8] = false
        K[22] = false
        K[20] = false
        r2.TeleportToggle:SetValue(false)
        r2.FlingToggle:SetValue(false)
        r2.SpectateToggle:SetValue(false)
        if K[21] then
            K[21]:Disconnect()
            K[21] = nil
        end
        local char = r10.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            r10.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
        end
    end
end)

local v82 = r3
v82:BindToRenderStep("MainLoop", Enum.RenderPriority.Camera.Value + 1, function()
    K[60]()
    
    if K[8] and K[10] then
        if tick() - K[12] >= K[11] then
            if K[10].Character and K[10].Character:FindFirstChild("HumanoidRootPart") then
                local targetCFrame = K[10].Character.HumanoidRootPart.CFrame
                if K[17] then
                    K[18] = K[18] + math.pi * 2 * K[19] * K[11]
                    if K[18] >= math.pi * 2 then
                        K[18] = K[18] - math.pi * 2
                    end
                    local circlePos = K[10].Character.HumanoidRootPart.Position + Vector3.new(math.cos(K[18]) * K[14], 0, math.sin(K[18]) * K[14])
                    if r10.Character and r10.Character:FindFirstChild("HumanoidRootPart") then
                        r10.Character.HumanoidRootPart.CFrame = CFrame.new(circlePos)
                    end
                else
                    if r10.Character and r10.Character:FindFirstChild("HumanoidRootPart") then
                        r10.Character.HumanoidRootPart.CFrame = targetCFrame + Vector3.new(0, 0, K[14])
                    end
                end
                K[12] = tick()
            else
                if not r10.Character or not r10.Character:FindFirstChild("HumanoidRootPart") then
                    if not K[13] then
                        K[8] = false
                        r2.TeleportToggle:SetValue(false)
                    end
                end
            end
        end
    end
    
    if K[22] and K[10] then
        if tick() - K[24] >= K[25] then
            if K[10].Character and K[10].Character:FindFirstChild("HumanoidRootPart") then
                local myHrp = r10.Character.HumanoidRootPart
                local targetPos = K[10].Character.HumanoidRootPart.Position
                local direction = (targetPos - myHrp.Position).Unit
                myHrp.CFrame = CFrame.new(targetPos - direction * 10)
                myHrp.Velocity = direction * K[23]
                task.delay(0.1, function()
                    if K[22] and r10.Character then
                        r10.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                    end
                end)
                K[24] = tick()
            end
        end
    end
end)

K[67] = function(value)
    pcall(function()
        if value then
            local light = Instance.new("PointLight", r12.Character.Head)
            light.Name = "txnb"
            light.Range = K[2]
            light.Brightness = K[1]
            light.Color = K[3]
        else
            local char = r12.Character
            if char then
                local light = char.Head:FindFirstChild("txnb")
                if light then
                    light:Destroy()
                end
            end
        end
    end)
end

K[68] = function(value)
    pcall(function()
        K[1] = tonumber(value) or 1
        local char = r12.Character
        if char then
            local light = char.Head:FindFirstChild("txnb")
            if light then
                light.Brightness = K[1]
            end
        end
    end)
end

local v83 = v10.World
v83:AddToggle("SelfGlow", {
    ["Title"] = "自身发光",
    ["Default"] = false,
    ["Callback"] = K[67]
})

local v84 = v10.World
v84:AddInput("LightBrightness", {
    ["Title"] = "光照亮度",
    ["Default"] = "1",
    ["Numeric"] = true,
    ["Callback"] = K[68]
})

local v85 = v10.World
v85:AddInput("LightRange", {
    ["Title"] = "光照范围",
    ["Default"] = "150",
    ["Numeric"] = true,
    ["Callback"] = function(value)
        pcall(function()
            K[2] = tonumber(value) or 150
            local char = r12.Character
            if char then
                local light = char.Head:FindFirstChild("txnb")
                if light then
                    light.Range = K[2]
                end
            end
        end)
    end
})

local v86 = v10.World
v86:AddColorpicker("LightColor", {
    ["Title"] = "光照颜色",
    ["Default"] = Color3.fromRGB(255, 255, 255),
    ["Callback"] = function(color)
        pcall(function()
            K[3] = color
            local char = r12.Character
            if char then
                local light = char.Head:FindFirstChild("txnb")
                if light then
                    light.Color = K[3]
                end
            end
        end)
    end
})

local v87 = v10.World
v87:AddSection("")

local v88 = v10.World
v88:AddToggle("MuteSounds", {
    ["Title"] = "静音模式",
    ["Default"] = false,
    ["Callback"] = function(value)
        r25 = value
        for _, sound in ipairs(game:GetDescendants()) do
            if sound:IsA("Sound") then
                if value then
                    sound.Volume = 0
                    if not sound:GetAttribute("OriginalVolume") then
                        sound:SetAttribute("OriginalVolume", sound.Volume)
                    end
                else
                    sound.Volume = (sound:GetAttribute("OriginalVolume") or 0.5) * r26
                end
            end
        end
    end
})

local v89 = v10.World
v89:AddInput("SoundBoost", {
    ["Title"] = "环境音效增强",
    ["Description"] = "炸麦",
    ["Default"] = "1",
    ["Numeric"] = true,
    ["Callback"] = function(value)
        r26 = tonumber(value) or 1
        if not r25 then
            for _, sound in pairs(game:GetDescendants()) do
                if sound:IsA("Sound") then
                    sound.Volume = (sound:GetAttribute("OriginalVolume") or 0.5) * r26
                end
            end
        end
    end
})

local v90 = v10.World
v90:AddSection("")

local v91 = v10.World
v91:AddToggle("FullBrightToggle", {
    ["Title"] = "全图照明",
    ["Description"] = "夜视",
    ["Default"] = false,
    ["Callback"] = function(value)
        r27 = value
        if value then
            r5.Brightness = 5
            r5.FogEnd = 1000000
            r5.GlobalShadows = false
        else
            r5.Brightness = 2
            r5.FogEnd = 100000
            r5.GlobalShadows = true
        end
    end
})

K[69] = false
K[70] = 50
K[71] = "WalkSpeed"
K[72] = nil
K[73] = nil
K[74] = nil

local function SaveOriginalWalkSpeed()
    pcall(function()
        local char = r10.Character
        if char and char:FindFirstChild("Humanoid") then
            if not K[72] then
                K[72] = r10.Character.Humanoid.WalkSpeed
            end
        end
    end)
end

local function ResetWalkSpeed()
    if K[74] then
        K[74]:Disconnect()
        K[74] = nil
    end
    pcall(function()
        local char = r10.Character
        if char and char:FindFirstChild("Humanoid") then
            if K[72] then
                r10.Character.Humanoid.WalkSpeed = K[72]
            end
        end
    end)
end

local function ApplyWalkSpeed()
    if not r10.Character or not r10.Character:FindFirstChild("HumanoidRootPart") or not r10.Character:FindFirstChild("Humanoid") then
        return
    end
    local humanoid = r10.Character.Humanoid
    local hrp = r10.Character.HumanoidRootPart
    SaveOriginalWalkSpeed()
    
    if K[74] then
        K[74]:Disconnect()
    end
    
    if K[71] == "WalkSpeed" then
        humanoid.WalkSpeed = K[70]
    elseif K[71] == "Vector" then
        K[74] = r3.Heartbeat:Connect(function()
            if humanoid.MoveDirection.Magnitude > 0 then
                local vel = humanoid.MoveDirection * K[70] * 3.6
                hrp.Velocity = Vector3.new(vel.X, hrp.Velocity.Y, vel.Z)
            else
                hrp.Velocity = Vector3.new(0, hrp.Velocity.Y, 0)
            end
        end)
    elseif K[71] == "CFrame" then
        K[74] = r3.Heartbeat:Connect(function(deltaTime)
            if humanoid.MoveDirection.Magnitude > 0 then
                hrp.CFrame = hrp.CFrame + humanoid.MoveDirection * K[70] * deltaTime * 60
            end
        end)
    elseif K[71] == "TP" then
        K[74] = r3.Heartbeat:Connect(function(deltaTime)
            if humanoid.MoveDirection.Magnitude > 0 then
                hrp.CFrame = hrp.CFrame + humanoid.MoveDirection * K[70] * deltaTime * 55
            end
        end)
    end
end

local v92 = v10.Player
v92:AddSection("玩家加速")

local v93 = v10.Player
v93:AddToggle("SpeedEnabled", {
    ["Title"] = "开启加速",
    ["Default"] = false,
    ["Callback"] = function(value)
        K[69] = value
        if value then
            ApplyWalkSpeed()
        else
            ResetWalkSpeed()
        end
    end
})

local v94 = v10.Player
v94:AddInput("SpeedValue", {
    ["Title"] = "加速速度",
    ["Default"] = "50",
    ["Numeric"] = true,
    ["Callback"] = function(value)
        local num = tonumber(value)
        if num then
            K[70] = num
            if K[69] and K[71] == "WalkSpeed" then
                pcall(function()
                    local char = r10.Character
                    if char and char:FindFirstChild("Humanoid") then
                        r10.Character.Humanoid.WalkSpeed = num
                    end
                end)
            end
        end
    end
})

local v95 = v10.Player
v95:AddDropdown("SpeedMode", {
    ["Title"] = "加速模式",
    ["Values"] = {"WalkSpeed", "Vector", "CFrame", "TP"},
    ["Default"] = "WalkSpeed",
    ["Callback"] = function(value)
        K[71] = value
        if K[69] then
            ResetWalkSpeed()
            ApplyWalkSpeed()
        end
    end
})

local v96 = r10.CharacterAdded
v96:Connect(function(character)
    K[72] = nil
    character:WaitForChild("Humanoid", 10)
    character:WaitForChild("HumanoidRootPart", 10)
    SaveOriginalWalkSpeed()
    if K[69] then
        task.wait(0.5)
        ApplyWalkSpeed()
    else
        pcall(function()
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid and K[72] then
                character.Humanoid.WalkSpeed = K[72]
            end
        end)
    end
end)

if r10.Character then
    SaveOriginalWalkSpeed()
end

local v97 = v10.Player
v97:AddSection("玩家跳跃")

K[75] = false
K[76] = 50
K[77] = "JumpPower"
K[78] = nil
K[79] = nil
K[80] = nil

local function SaveOriginalJumpPower()
    pcall(function()
        local char = r10.Character
        if char and char:FindFirstChild("Humanoid") then
            if not K[78] then
                K[78] = r10.Character.Humanoid.JumpPower
            end
        end
    end)
end

local function ResetJumpPower()
    if K[80] then
        K[80]:Disconnect()
        K[80] = nil
    end
    pcall(function()
        local char = r10.Character
        if char and char:FindFirstChild("Humanoid") then
            if K[78] then
                r10.Character.Humanoid.JumpPower = K[78]
            end
        end
    end)
end

local function ApplyJumpPower()
    if not r10.Character or not r10.Character:FindFirstChild("HumanoidRootPart") or not r10.Character:FindFirstChild("Humanoid") then
        return
    end
    local humanoid = r10.Character.Humanoid
    local hrp = r10.Character.HumanoidRootPart
    SaveOriginalJumpPower()
    
    if K[80] then
        K[80]:Disconnect()
    end
    
    if K[77] == "JumpPower" then
        humanoid.JumpPower = K[76]
    elseif K[77] == "Vector" then
        K[80] = r9.JumpRequest:Connect(function()
            local state = humanoid:GetState()
            if state == Enum.HumanoidStateType.Freefall or state == Enum.HumanoidStateType.Jumping then
                hrp.Velocity = Vector3.new(hrp.Velocity.X, K[76], hrp.Velocity.Z)
            end
        end)
    elseif K[77] == "CFrame" then
        K[80] = r9.JumpRequest:Connect(function()
            local state = humanoid:GetState()
            if state == Enum.HumanoidStateType.Freefall or state == Enum.HumanoidStateType.Jumping then
                hrp.CFrame = hrp.CFrame + Vector3.new(0, K[76], 0)
            end
        end)
    elseif K[77] == "Impulse" then
        K[80] = r9.JumpRequest:Connect(function()
            local state = humanoid:GetState()
            if state == Enum.HumanoidStateType.Freefall or state == Enum.HumanoidStateType.Jumping then
                hrp:ApplyImpulse(Vector3.new(0, humanoid.Mass * K[76], 0))
            end
        end)
    end
end

local v98 = v10.Player
v98:AddToggle("JumpEnabled", {
    ["Title"] = "开启跳跃增强",
    ["Default"] = false,
    ["Callback"] = function(value)
        K[75] = value
        if value then
            ApplyJumpPower()
        else
            ResetJumpPower()
        end
    end
})

local v99 = v10.Player
v99:AddInput("JumpValue", {
    ["Title"] = "跳跃高度",
    ["Default"] = "50",
    ["Numeric"] = true,
    ["Callback"] = function(value)
        local num = tonumber(value)
        if num then
            K[76] = num
            if K[75] and K[77] == "JumpPower" then
                pcall(function()
                    local char = r10.Character
                    if char and char:FindFirstChild("Humanoid") then
                        r10.Character.Humanoid.JumpPower = num
                    end
                end)
            end
        end
    end
})

local v100 = v10.Player
v100:AddDropdown("JumpMode", {
    ["Title"] = "跳跃模式",
    ["Values"] = {"JumpPower", "Vector", "CFrame", "Impulse"},
    ["Default"] = "JumpPower",
    ["Callback"] = function(value)
        K[77] = value
        if K[75] then
            ResetJumpPower()
            ApplyJumpPower()
        end
    end
})

K[81] = false
K[82] = nil

local v101 = v10.Player
v101:AddToggle("InfiniteJump", {
    ["Title"] = "无限跳跃",
    ["Default"] = false,
    ["Callback"] = function(value)
        K[81] = value
        if K[82] then
            K[82]:Disconnect()
            K[82] = nil
        end
        if value then
            K[82] = r9.JumpRequest:Connect(function()
                pcall(function()
                    local char = r10.Character
                    if char and char:FindFirstChild("Humanoid") then
                        r10.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end)
            end)
        end
    end
})

K[83] = false
K[84] = nil

local v102 = v10.Player
v102:AddToggle("AutoJump", {
    ["Title"] = "自动跳跃",
    ["Default"] = false,
    ["Callback"] = function(value)
        K[83] = value
        if K[84] then
            K[84]:Disconnect()
            K[84] = nil
        end
        if value then
            K[84] = r3.Heartbeat:Connect(function()
                pcall(function()
                    local char = r10.Character
                    if char and char:FindFirstChild("Humanoid") then
                        r10.Character.Humanoid.Jump = true
                    end
                end)
            end)
        end
    end
})

local v103 = r10.CharacterAdded
v103:Connect(function(character)
    K[78] = nil
    character:WaitForChild("Humanoid", 10)
    character:WaitForChild("HumanoidRootPart", 10)
    SaveOriginalJumpPower()
    if K[75] then
        task.wait(0.5)
        ApplyJumpPower()
    else
        pcall(function()
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid and K[78] then
                character.Humanoid.JumpPower = K[78]
            end
        end)
    end
end)

if r10.Character then
    SaveOriginalJumpPower()
end

local fovFrame = Instance.new("Frame")
fovFrame.Name = "TX_AimbotFOV"
fovFrame.Parent = Za[42]
fovFrame.AnchorPoint = Vector2.new(0.5, 0.5)
fovFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
fovFrame.Size = UDim2.new(0, K[31] * 2, 0, K[31] * 2)
fovFrame.BackgroundTransparency = 1
fovFrame.Visible = false

local fovStroke = Instance.new("UIStroke", fovFrame)
fovStroke.Thickness = 2
fovStroke.Color = K[34]

local fovCorner = Instance.new("UICorner", fovFrame)
fovCorner.CornerRadius = UDim.new(1, 0)

K[85] = fovFrame
K[86] = fovStroke

local function FindClosestPlayerInFOV()
    local fovRadius = K[31]
    local closestPlayer = nil
    local closestDistance = fovRadius
    
    for _, player in ipairs(r8.GetPlayers(r8)) do
        if player ~= r10 then
            local character = player.Character
            local hrp = character and character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local point, onScreen = r6:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    if K[33] and player.Team == r10.Team then
                    else
                        local screenPos = Vector2.new(point.X, point.Y)
                        local center = Vector2.new(r6.ViewportSize.X / 2, r6.ViewportSize.Y / 2)
                        local distance = (screenPos - center).Magnitude
                        if distance <= fovRadius then
                            if K[34] then
                                local params = RaycastParams.new()
                                params.FilterDescendantsInstances = {r10.Character}
                                params.FilterType = Enum.RaycastFilterType.Blacklist
                                local ray = workspace:Raycast(r6.CFrame.Position, (hrp.Position - r6.CFrame.Position).Unit * 500, params)
                                if ray and ray.Instance:IsDescendantOf(player.Character) then
                                    if distance < closestDistance then
                                        closestDistance = distance
                                        closestPlayer = player
                                    end
                                end
                            else
                                if distance < closestDistance then
                                    closestDistance = distance
                                    closestPlayer = player
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return closestPlayer
end

local function UpdateSinglePlayerList()
    local players = {}
    local mode = r2.SingleModeDropdown.Value or "名称"
    for _, player in pairs(r8.GetPlayers(r8)) do
        if player ~= r10 then
            if mode == "名称" then
                table.insert(players, player.Name)
            elseif mode == "昵称" then
                table.insert(players, player.DisplayName)
            end
        end
    end
    if #players == 0 then
        players = {"无玩家"}
    end
    r2.SinglePlayerDropdown:SetValues(players)
    if #players > 0 and players[1] ~= "无玩家" then
        if not table.find(players, r2.SinglePlayerDropdown.Value) then
            r2.SinglePlayerDropdown:SetValue(players[1])
        end
    else
        r2.SinglePlayerDropdown:SetValue("无玩家")
    end
end

local function ResolveSingleTarget()
    if not K[36] or K[36] == "无玩家" then
        K[35] = nil
        return
    end
    local mode = r2.SingleModeDropdown.Value or "名称"
    for _, player in pairs(r8.GetPlayers(r8)) do
        if (mode == "名称" and player.Name == K[36]) or (mode == "昵称" and player.DisplayName == K[36]) then
            K[35] = player
            return
        end
    end
    K[35] = nil
end

local v105 = r3.RenderStepped
v105:Connect(function()
    if K[38] then
        K[86].Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
    else
        if K[86].Color ~= K[34] then
            K[86].Color = K[34]
        end
    end
    
    if K[29] then
        local target = FindClosestPlayerInFOV()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local currentCFrame = r6.CFrame
            r6.CFrame = currentCFrame:Lerp(CFrame.new(currentCFrame.Position, target.Character.HumanoidRootPart.Position), K[32])
        end
    elseif K[30] then
        ResolveSingleTarget()
        local target = K[35]
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local currentCFrame = r6.CFrame
            r6.CFrame = currentCFrame:Lerp(CFrame.new(currentCFrame.Position, target.Character.HumanoidRootPart.Position), K[32])
        end
    end
end)

local v106 = v10.Aimbot
v106:AddToggle("GlobalAimbotEnabled", {
    ["Title"] = "FOV自瞄",
    ["Default"] = false,
    ["Callback"] = function(value)
        K[29] = value
        K[85].Visible = value
        if value then
            K[30] = false
            r2.SingleAimbotEnabled:SetValue(false)
            r1.Notify(r1, {["Title"] = "无法同时开启两个自瞄模式", ["Content"] = "已自动关闭单一玩家自瞄", ["Duration"] = 4})
        end
    end
})

local v107 = v10.Aimbot
v107:AddToggle("AimbotTeamCheck", {
    ["Title"] = "队伍检查",
    ["Description"] = "小部分服务器会误判",
    ["Default"] = false,
    ["Callback"] = function(value)
        K[33] = value
    end
})

local v108 = v10.Aimbot
v108:AddToggle("AimbotWallCheck", {
    ["Title"] = "墙壁检查",
    ["Default"] = true,
    ["Callback"] = function(value)
        K[34] = value
    end
})

local v109 = v10.Aimbot
v109:AddSlider("AimbotFOVRadius", {
    ["Title"] = "FOV 范围",
    ["Min"] = 1,
    ["Max"] = 500,
    ["Default"] = 150,
    ["Rounding"] = 2,
    ["Callback"] = function(value)
        K[31] = value
        K[85].Size = UDim2.new(0, value * 2, 0, value * 2)
    end
})

local v110 = v10.Aimbot
v110:AddSlider("AimbotSmoothness", {
    ["Title"] = "自瞄平滑度",
    ["Min"] = 0.05,
    ["Max"] = 1,
    ["Default"] = 0.4,
    ["Rounding"] = 2,
    ["Callback"] = function(value)
        K[32] = value
    end
})

local v111 = v10.Aimbot
v111:AddToggle("AimbotRainbowFOV", {
    ["Title"] = "FOV 彩虹模式",
    ["Default"] = false,
    ["Callback"] = function(value)
        K[38] = value
    end
})

local v112 = v10.Aimbot
v112:AddColorpicker("AimbotFOVColor", {
    ["Title"] = "FOV 颜色",
    ["Default"] = Color3.fromRGB(255, 0, 0),
    ["Callback"] = function(color)
        K[34] = color
        if not K[38] then
            K[86].Color = color
        end
    end
})

local v113 = v10.Aimbot
v113:AddParagraph({
    ["Title"] = "平滑度解释",
    ["Content"] = "调高是强锁自瞄\n调低是半锁自瞄"
})

local v114 = v10.Aimbot
v114:AddSection("指定玩家自瞄")

local v115 = v10.Aimbot
v115:AddDropdown("SingleModeDropdown", {
    ["Title"] = "选择模式",
    ["Values"] = {"名称", "昵称"},
    ["Default"] = 1,
    ["Callback"] = function(value)
        K[83] = value
        UpdateSinglePlayerList()
    end
})

local v116 = v10.Aimbot
v116:AddDropdown("SinglePlayerDropdown", {
    ["Title"] = "选择目标玩家",
    ["Values"] = {},
    ["Default"] = 1,
    ["Callback"] = function(value)
        if value ~= "无玩家" then
            K[36] = value
        else
            K[36] = nil
        end
        ResolveSingleTarget()
    end
})

local v117 = v10.Aimbot
v117:AddButton({
    ["Title"] = "刷新玩家列表",
    ["Callback"] = function(...)
        UpdateSinglePlayerList()
    end
})

local v118 = v10.Aimbot
v118:AddToggle("SingleAimbotEnabled", {
    ["Title"] = "开启指定玩家自瞄",
    ["Default"] = false,
    ["Callback"] = function(value)
        K[30] = value
        if value then
            if K[36] == nil or K[36] == "无玩家" then
                r1.Notify(r1, {["Title"] = "错误", ["Content"] = "请先选择一个目标玩家", ["Duration"] = 5})
                K[30] = false
                r2.SingleAimbotEnabled:SetValue(false)
                return
            end
            if K[29] then
                K[29] = false
                r2.GlobalAimbotEnabled:SetValue(false)
                K[85].Visible = false
                r1.Notify(r1, {["Title"] = "提示", ["Content"] = "无法同时开启两个自瞄模式\n已自动关闭另一个", ["Duration"] = 4})
            end
        end
    end
})

K[87] = 1

K[88] = function(player)
    if player == r10 then return end
    if K[43] and player.Team == r10.Team then return end
    if K[46] and player ~= K[48] then return end
    if not player.Character then return end
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    pcall(function()
        if not K[42][player] then
            K[42][player] = {
                ["Size"] = hrp.Size,
                ["Transparency"] = hrp.Transparency,
                ["Color"] = hrp.Color,
                ["Material"] = hrp.Material,
                ["CanCollide"] = hrp.CanCollide,
                ["Shape"] = hrp.Shape or Enum.PartType.Block
            }
        end
        hrp.Size = Vector3.new(K[39], K[39], K[39])
        hrp.Transparency = K[40]
        hrp.Color = K[41]
        hrp.Material = K[45]
        hrp.CanCollide = false
        hrp.Shape = K[44] == "Capsule" and Enum.PartType.Cylinder or Enum.PartType.Block
    end)
end

K[89] = function(player)
    if player == r10 then return end
    if not player.Character then return end
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if not K[42][player] then return end
    pcall(function()
        local data = K[42][player]
        hrp.Size = data.Size
        hrp.Transparency = data.Transparency
        hrp.Color = data.Color
        hrp.Material = data.Material
        hrp.CanCollide = data.CanCollide
        hrp.Shape = data.Shape
        K[42][player] = nil
    end)
end

local v119 = v10.HITBOX
v119:AddSection("Hitbox")

local v120 = v10.HITBOX
v120:AddToggle("HitboxToggle", {
    ["Title"] = "开启碰撞箱修改",
    ["Default"] = false,
    ["Callback"] = function(value)
        K[37] = value
        if value then
            for _, player in pairs(r8.GetPlayers(r8)) do
                if player ~= r10 and player.Character then
                    K[88](player)
                end
            end
        else
            for _, player in pairs(r8.GetPlayers(r8)) do
                if player ~= r10 then
                    K[89](player)
                end
            end
        end
    end
})

local v121 = v10.HITBOX
v121:AddToggle("HitboxTeamCheck", {
    ["Title"] = "队伍检查(小部分服务器会误判)",
    ["Default"] = false,
    ["Callback"] = function(value)
        K[43] = value
        if K[37] then
            for _, player in pairs(r8.GetPlayers(r8)) do
                if player ~= r10 then
                    K[89](player)
                    K[88](player)
                end
            end
        end
    end
})

local v122 = v10.HITBOX
v122:AddInput("HitboxSize", {
    ["Title"] = "碰撞箱大小",
    ["Default"] = "5",
    ["Numeric"] = true,
    ["Callback"] = function(value)
        local num = tonumber(value)
        if num and num > 0 then
            K[39] = num
            if K[37] then
                for _, player in pairs(r8.GetPlayers(r8)) do
                    if player ~= r10 and player.Character then
                        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            hrp.Size = Vector3.new(num, num, num)
                        end
                    end
                end
            end
        end
    end
})

local v123 = v10.HITBOX
v123:AddSlider("HitboxTransparency", {
    ["Title"] = "透明度",
    ["Min"] = 0,
    ["Max"] = 1,
    ["Default"] = 0.7,
    ["Rounding"] = 2,
    ["Callback"] = function(value)
        K[40] = value
        if K[37] then
            for _, player in pairs(r8.GetPlayers(r8)) do
                if player ~= r10 and player.Character then
                    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.Transparency = value
                    end
                end
            end
        end
    end
})

local v124 = v10.HITBOX
v124:AddColorpicker("HitboxColor", {
    ["Title"] = "颜色",
    ["Default"] = Color3.fromRGB(255, 0, 0),
    ["Callback"] = function(color)
        K[41] = color
        if K[37] then
            for _, player in pairs(r8.GetPlayers(r8)) do
                if player ~= r10 and player.Character then
                    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.Color = color
                    end
                end
            end
        end
    end
})

local v125 = v10.HITBOX
v125:AddDropdown("HitboxShape", {
    ["Title"] = "形状",
    ["Values"] = {"Box", "Capsule"},
    ["Default"] = "Box",
    ["Callback"] = function(value)
        K[44] = value
        if K[37] then
            for _, player in pairs(r8.GetPlayers(r8)) do
                if player ~= r10 and player.Character then
                    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.Shape = value == "Capsule" and Enum.PartType.Cylinder or Enum.PartType.Block
                    end
                end
            end
        end
    end
})

local v126 = v10.HITBOX
v126:AddDropdown("HitboxMaterial", {
    ["Title"] = "材质",
    ["Values"] = {"Neon", "ForceField", "SmoothPlastic", "Glass"},
    ["Default"] = "Neon",
    ["Callback"] = function(value)
        K[45] = Enum.Material[value]
        if K[37] then
            for _, player in pairs(r8.GetPlayers(r8)) do
                if player ~= r10 and player.Character then
                    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.Material = K[45]
                    end
                end
            end
        end
    end
})

local v127 = v10.HITBOX
v127:AddSection("特定玩家")

local v128 = v10.HITBOX
v128:AddToggle("HitboxTargetSpecific", {
    ["Title"] = "针对特定玩家",
    ["Default"] = false,
    ["Callback"] = function(value)
        K[46] = value
        if value then
            if not K[47] or not K[48] then
                r1.Notify(r1, {["Title"] = "提示", ["Content"] = "请先选择一位玩家", ["Duration"] = 5})
                r2.HitboxTargetSpecific:SetValue(false)
                return
            end
            if K[37] then
                for _, player in pairs(r8.GetPlayers(r8)) do
                    if player ~= r10 then
                        K[89](player)
                    end
                end
                for _, player in pairs(r8.GetPlayers(r8)) do
                    if player ~= r10 then
                        K[88](player)
                    end
                end
            end
        end
    end
})

K[90] = "名称"

local function UpdateHitboxPlayerList()
    local players = {}
    for _, player in pairs(r8.GetPlayers(r8)) do
        if player ~= r10 then
            if K[90] == "名称" then
                table.insert(players, player.Name)
            else
                table.insert(players, player.DisplayName)
            end
        end
    end
    r2.HitboxPlayerDropdown:SetValues(players)
end

local v129 = v10.HITBOX
v129:AddDropdown("HitboxModeDropdown", {
    ["Title"] = "选择模式",
    ["Values"] = {"名称", "昵称"},
    ["Default"] = 1,
    ["Callback"] = function(value)
        K[90] = value
        UpdateHitboxPlayerList()
    end
})

local v130 = v10.HITBOX
v130:AddDropdown("HitboxPlayerDropdown", {
    ["Title"] = "选择目标玩家",
    ["Values"] = {},
    ["Default"] = 1,
    ["Callback"] = function(value)
        if value == "无玩家" then
            K[47] = nil
            K[48] = nil
            if K[46] then
                r2.HitboxTargetSpecific:SetValue(false)
            end
            return
        end
        K[47] = value
        K[48] = nil
        for _, player in pairs(r8.GetPlayers(r8)) do
            if (K[90] == "名称" and player.Name == value) or (K[90] == "昵称" and player.DisplayName == value) then
                K[48] = player
                break
            end
        end
        if K[37] and K[46] then
            for _, player in pairs(r8.GetPlayers(r8)) do
                if player ~= r10 then
                    K[89](player)
                end
            end
            if K[48] then
                K[88](K[48])
            end
        end
    end
})

local v131 = v10.HITBOX
v131:AddButton({
    ["Title"] = "刷新玩家列表",
    ["Callback"] = UpdateHitboxPlayerList
})

local v132 = r8.PlayerAdded
v132:Connect(function(player)
    if player == r10 then return end
    player.CharacterAdded:Connect(function()
        task.wait(0.5)
        if K[37] then
            K[88](player)
        end
    end)
    if player.Character then
        task.wait(0.5)
        if K[37] then
            K[88](player)
        end
    end
    player.CharacterRemoving:Connect(function()
        K[89](player)
    end)
    UpdateHitboxPlayerList()
end)

local v133 = r8.PlayerRemoving
v133:Connect(function(player)
    K[89](player)
    UpdateHitboxPlayerList()
    if K[46] and player == K[48] then
        K[48] = nil
        K[47] = nil
        r2.HitboxTargetSpecific:SetValue(false)
        r1.Notify(r1, {["Title"] = "提示", ["Content"] = "目标玩家已离开，已自动关闭 针对特定玩家 模式", ["Duration"] = 6})
    end
end)

UpdateSinglePlayerList()
UpdateHitboxPlayerList()

local v134 = r8.PlayerAdded
v134:Connect(function()
    UpdateSinglePlayerList()
end)

local v135 = r8.PlayerRemoving
v135:Connect(function()
    UpdateSinglePlayerList()
end)

local v136 = v10.Tool
v136:AddButton({
    ["Title"] = "飞行",
    ["Callback"] = function(...)
        loadstring(game:HttpGet("https://raw.githubusercontent.com/JsYb666/Item/refs/heads/main/Fly"))()
    end
})

local v137 = v10.Tool
v137:AddButton({
    ["Title"] = "Delta键盘",
    ["Callback"] = function(...)
        loadstring(game:HttpGet("https://raw.githubusercontent.com/JsYb666/Item/refs/heads/main/delta%20keyboard.lua"))()
    end
})

local v138 = v10.Tool
v138:AddButton({
    ["Title"] = "功能道具",
    ["Callback"] = function(...)
        loadstring(game:HttpGet("https://cdn.wearedevs.net/scripts/BTools.txt"))()
    end
})

local v139 = v10.Tool
v139:AddButton({
    ["Title"] = "死亡笔记",
    ["Callback"] = function(...)
        loadstring(game:HttpGet("https://raw.githubusercontent.com/dingding123hhh/tt/main/%E6%AD%BB%E4%BA%A1%E7%AC%94%E8%AE%B0%20(1).txt"))()
    end
})

local v140 = v10.Tool
v140:AddButton({
    ["Title"] = "IY指令",
    ["Callback"] = function(...)
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source", true))()
    end
})

local v141 = v10.Tool
v141:AddButton({
    ["Title"] = "踏空",
    ["Callback"] = function(...)
        loadstring(game:HttpGet("https://raw.githubusercontent.com/GhostPlayer352/Test4/main/Float"))()
    end
})

local v142 = v10.Tool
v142:AddButton({
    ["Title"] = "删材质",
    ["Callback"] = function(...)
        loadstring(game:HttpGet("https://scriptblox.com/raw/Universal-Script-FpsBoost-9260"))()
    end
})

local v143 = v10.Tool
v143:AddButton({
    ["Title"] = "点击传送工具",
    ["Callback"] = function(...)
        local player = game.Players.LocalPlayer
        local mouse = player:GetMouse()
        local tool = Instance.new("Tool")
        tool.RequiresHandle = false
        tool.Name = "[FE] TELEPORT TOOL"
        tool.Activated:Connect(function()
            local pos = mouse.Hit + Vector3.new(0, 2.5, 0)
            player.Character.HumanoidRootPart.CFrame = CFrame.new(pos.X, pos.Y, pos.Z)
        end)
        tool.Parent = player.Backpack
    end
})

local v144 = v10.Tool
v144:AddButton({
    ["Title"] = "飞车",
    ["Callback"] = function(...)
        loadstring(game:HttpGet("https://pastebin.com/raw/equFq67v"))()
    end
})

local v145 = v10.Tool
v145:AddButton({
    ["Title"] = "阿尔宙斯子追",
    ["Callback"] = function(...)
        loadstring(game:HttpGet("https://raw.githubusercontent.com/JsYb666/Item/refs/heads/main/Arceus%E5%AD%90%E8%BF%BD"))()
    end
})

local v146 = v10.Tool
v146:AddButton({
    ["Title"] = "撸管R15",
    ["Callback"] = function(...)
        loadstring(game:HttpGet("https://pastefy.app/YZoglOyJ/raw"))()
    end
})

local v147 = v10.Tool
v147:AddButton({
    ["Title"] = "撸管R6",
    ["Callback"] = function(...)
        loadstring(game:HttpGet("https://pastefy.app/wa3v2Vgm/raw"))()
    end
})

K[91] = false

K[92] = function(value)
    for _, prompt in ipairs(workspace:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") then
            if value then
                if not K[93][prompt] then
                    K[93][prompt] = {["HoldDuration"] = prompt.HoldDuration}
                end
                prompt.HoldDuration = 0
            else
                if K[93][prompt] then
                    prompt.HoldDuration = K[93][prompt].HoldDuration
                end
            end
        end
    end
end

local function FireAllProximityPrompts()
    for _, prompt in ipairs(workspace:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") then
            fireproximityprompt(prompt)
        end
    end
    r1.Notify(r1, {["Title"] = "Proximity", ["Content"] = "已触发所有 Proximity Prompts", ["Duration"] = 5})
end

K[94] = function(value)
    for _, detector in ipairs(workspace:GetDescendants()) do
        if detector:IsA("ClickDetector") then
            if value then
                if not K[95][detector] then
                    K[95][detector] = {["MaxActivationDistance"] = detector.MaxActivationDistance}
                end
                detector.MaxActivationDistance = math.huge
            else
                if K[95][detector] then
                    detector.MaxActivationDistance = K[95][detector].MaxActivationDistance
                end
            end
        end
    end
end

local function FireAllClickDetectors()
    for _, detector in ipairs(workspace:GetDescendants()) do
        if detector:IsA("ClickDetector") then
            fireclickdetector(detector)
        end
    end
    r1.Notify(r1, {["Title"] = "Click", ["Content"] = "已触发所有 Click Detectors", ["Duration"] = 5})
end

local function GetAllTouchableParts()
    local parts = {}
    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and part.CanTouch then
            table.insert(parts, part)
        end
    end
    return parts
end

local function FireAllTouchInterests()
    local character = r10.Character
    if character then
        local rootPart = character:FindFirstChildWhichIsA("BasePart")
        if rootPart then
            for _, part in ipairs(GetAllTouchableParts()) do
                if part ~= rootPart then
                    firetouchinterest(rootPart, part, 0)
                    task.wait(0.01)
                    firetouchinterest(rootPart, part, 1)
                end
            end
        end
    end
    r1.Notify(r1, {["Title"] = "Touch", ["Content"] = "已触发所有 Touch Interests", ["Duration"] = 5})
end

K[93] = {}
K[95] = {}

local v148 = v10.Main
v148:AddToggle("ProxInstant", {
    ["Title"] = "Proximity全图互动",
    ["Description"] = "瞬时互动",
    ["Default"] = false,
    ["Callback"] = K[92]
})

local v149 = v10.Main
v149:AddButton({
    ["Title"] = "触发所有 Proximity Prompts",
    ["Description"] = "触发所有 Proximity Prompts",
    ["Callback"] = FireAllProximityPrompts
})

local v150 = v10.Main
v150:AddButton({
    ["Title"] = "Click全图互动",
    ["Description"] = "触发所有 Click Detectors",
    ["Callback"] = FireAllClickDetectors
})

local v151 = v10.Main
v151:AddButton({
    ["Title"] = "Touch全图互动",
    ["Description"] = "触发所有 Touch Interests",
    ["Callback"] = FireAllTouchInterests
})

local function ResetAllInteractions()
    K[92](false)
    K[94](false)
    K[93] = {}
    K[95] = {}
end
