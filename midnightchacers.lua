local Enabled = true
local Player = game:GetService("Players").LocalPlayer
local CarName = Player.Name .. "'s Car"
local playerCar = workspace[CarName]

local targetCFrame = CFrame.new(3260, -15, 1015)

function teleportCar(cframe)
    if playerCar and playerCar.PrimaryPart then
        playerCar:SetPrimaryPartCFrame(cframe)
        print("BOT: Car teleported to target position")
    else
        print("BOT: ERROR - Car or PrimaryPart not found")
    end
end

function StartRaceBot()
    spawn(function()
        print("BOT: Starting race bot...")
        print("BOT: Player: " .. Player.Name)
        print("BOT: Car name: " .. CarName)
        print("BOT: Target position: " .. tostring(targetCFrame.Position))
        
        while Enabled do
            local playerNearby = false
            
            local players = game:GetService("Players"):GetPlayers()
            print("BOT: Checking " .. #players .. " players in game")
            
            for _, otherPlayer in pairs(players) do
                if otherPlayer ~= Player and otherPlayer.Character then
                    local humanoidRootPart = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if humanoidRootPart and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                        local distance = (humanoidRootPart.Position - Player.Character.HumanoidRootPart.Position).Magnitude
                        print("BOT: Distance to " .. otherPlayer.Name .. ": " .. math.floor(distance) .. " studs")
                        
                        if distance <= 20 then
                            playerNearby = true
                            print("BOT: Player detected nearby: " .. otherPlayer.Name .. " (" .. math.floor(distance) .. " studs)")
                            break
                        end
                    end
                end
            end
            
            if playerNearby and Enabled then
                print("BOT: Nearby player detected, teleporting car...")
                teleportCar(targetCFrame)
                
                print("BOT: Waiting 25 seconds...")
                wait(25)
                
                if Enabled then
                    print("BOT: Sending F key...")
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.F, false, game)
                    game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.F, false, game)
                    print("BOT: F key pressed")
                    
                    print("BOT: Waiting 5 seconds...")
                    wait(5)
                    
                    if Enabled and playerCar and playerCar:FindFirstChild("DriveSeat") then
                        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                            Player.Character.HumanoidRootPart.CFrame = playerCar.DriveSeat.CFrame
                            print("BOT: Teleported to car DriveSeat")

                            print("BOT: Moving left 1 stud...")
                            wait(0.1)
                            Player.Character.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame * CFrame.new(-1, 0, 0)
                            
                            print("BOT: Moving right 1 stud...")
                            wait(0.1)
                            Player.Character.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame * CFrame.new(1, 0, 0)
                            
                            print("BOT: Sending SPACE key for 3.5 seconds...")
                            game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                            wait(3.5)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                            print("BOT: SPACE key released")
                            
                            print("BOT: Sending S key for 2 seconds...")
                            game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.S, false, game)
                            wait(2)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.S, false, game)
                            print("BOT: S key released")
                            
                            print("BOT: Waiting 1 second...")
                            wait(1)
                            
                            print("BOT: Teleporting back to target position...")
                            teleportCar(targetCFrame)
                        else
                            print("BOT: ERROR - Character or HumanoidRootPart not found for teleport")
                        end
                    else
                        print("BOT: ERROR - Car or DriveSeat not found")
                    end
                end
            else
                print("BOT: No nearby players detected, checking again in 0.5 seconds...")
                wait(0.5)
            end
        end
    end)
end

print("BOT: Script loaded successfully! Starting automatically...")
print("BOT: Enabled: " .. tostring(Enabled))
StartRaceBot()
