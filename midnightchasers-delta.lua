local Enabled = true
local Player = game:GetService("Players").LocalPlayer
local CarName = Player.Name .. "'s Car"

local targetPosition = Vector3.new(3260, -15, 1015)

function StartRaceBot()
    spawn(function()
        print("Race Bot Started")
        
        while Enabled do
            local playerNearby = false
            
            for _, otherPlayer in ipairs(game:GetService("Players"):GetPlayers()) do
                if otherPlayer ~= Player and otherPlayer.Character then
                    local humanoidRootPart = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if humanoidRootPart then
                        local distanceToTarget = (humanoidRootPart.Position - targetPosition).Magnitude
                        if distanceToTarget <= 20 then
                            playerNearby = true
                            print("Player detected: " .. otherPlayer.Name)
                            break
                        end
                    end
                end
            end
            
            if playerNearby then
                local car = workspace:FindFirstChild(CarName)
                if car and car.PrimaryPart then
                    car:SetPrimaryPartCFrame(CFrame.new(targetPosition))
                    print("Car teleported")
                    
                    wait(25)
                    
                    if Enabled then
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.F, false, game)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.F, false, game)
                        print("F pressed")
                        
                        wait(5)
                        
                        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                            if car:FindFirstChild("DriveSeat") then
                                Player.Character.HumanoidRootPart.CFrame = car.DriveSeat.CFrame
                                print("At DriveSeat")
                                
                                wait(0.1)
                                Player.Character.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame * CFrame.new(-1, 0, 0)
                                
                                wait(0.1)
                                Player.Character.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame * CFrame.new(1, 0, 0)
                                
                                wait(1)
                                
                                car:SetPrimaryPartCFrame(CFrame.new(targetPosition))
                                print("Back to target")
                            end
                        end
                    end
                end
            end
            
            wait(0.5)
        end
    end)
end

StartRaceBot()
