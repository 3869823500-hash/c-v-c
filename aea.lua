D
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
                local point
