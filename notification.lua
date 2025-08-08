-- IceMinisterq notification lib but with tweaks to fix noticing gui
function NotificationLibrary:Load()
    library = game:GetObjects("rbxassetid://15133757123")[1]
    templateFolder = library.Templates
    canvas = library.list
    library.Name = LibraryName

    -- Set canvas to bottom-right of screen
    canvas.AnchorPoint = Vector2.new(1, 1)  -- bottom right
    canvas.Position = UDim2.new(1, -20, 1, -20)  -- 20px from bottom-right corner
    canvas.Parent = CoreGui
end

function NotificationLibrary:SendNotification(Mode, Text, Duration)
    local libaryCore = CoreGui:FindFirstChild(LibraryName)
    if not libaryCore then
        NotificationLibrary:Load()
    else
        library = libaryCore
        templateFolder = library.Templates
        canvas = library.list
    end
    if templateFolder:FindFirstChild(Mode) then
        task.spawn(function()
            local success, err = pcall(function()
                local Notification = templateFolder:WaitForChild(Mode):Clone()
                local filler = Notification.Filler
                local bar = Notification.bar
                Notification.Header.Text = Text
                
                Notification.Visible = true
                Notification.Parent = canvas

                -- Anchor notification to right, so it expands leftwards
                Notification.AnchorPoint = Vector2.new(1, 0)
                Notification.Position = UDim2.new(1, 0, 0, 0)

                Notification.Size = UDim2.new(0, 0, 0.087, 0) -- start from zero width at right edge
                filler.Size = UDim2.new(1, 0, 1, 0)

                local T1 = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local T2 = TweenInfo.new(Duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                local T3 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

                TweenService:Create(Notification, T1, {Size = UDim2.new(1, 0, 0.087, 0)}):Play()
                task.wait(0.2)
                TweenService:Create(filler, T3, {Size = UDim2.new(0.011, 0, 1, 0)}):Play()

                TweenService:Create(bar, T2, {Size = UDim2.new(1, 0, 0.05, 0)}):Play()

                task.wait(Duration)

                TweenService:Create(filler, T1, {Size = UDim2.new(1, 0, 1, 0)}):Play()
                task.wait(0.25)
                TweenService:Create(Notification, T3, {Size = UDim2.new(0, 0, 0.087, 0)}):Play()
                task.wait(0.25)
                Notification:Destroy()
            end)
            if not success then
                warn("There was an error while trying to create an notification!")
                warn(err)
            end
        end)
    else
        warn("Invalid theme applyed")
    end
end
