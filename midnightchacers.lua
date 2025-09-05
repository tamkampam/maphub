local Enabled = true
local Player = game:GetService("Players").LocalPlayer
local CarName = Player.Name .. "'s Car"
local playerCar = workspace[CarName]

local targetCFrame = CFrame.new(3260, -15, 1015)
local targetPosition = Vector3.new(3260, -15, 1015)

function teleportCar(cframe)
    if playerCar and playerCar.PrimaryPart then
        playerCar:SetPrimaryPartCFrame(cframe)
        print("BOT: Car teleported to target position")
        return true
    else
        print("BOT: ERROR - Car or PrimaryPart not found")
        return false
    end
end

function isCarAtTargetPosition()
    if playerCar and playerCar.PrimaryPart then
        local carPosition = playerCar.PrimaryPart.Position
        local distance = (carPosition - targetPosition).Magnitude
        return distance <= 20
    end
    return false
end

function ensureCarTeleport()
    local attempts = 0
    local maxAttempts = 5
    
    while not isCarAtTargetPosition() and attempts < maxAttempts and Enabled do
        attempts += 1
        print("BOT: Teleport failed, retrying attempt " .. attempts)
        teleportCar(targetCFrame)
        wait(1)
    end
    
    return isCarAtTargetPosition()
end

function StartRaceBot()
    spawn(function()
        print("BOT: Starting race bot...")
        
        while Enabled do
            local playerNearby = false
            
            local players = game:GetService("Players"):GetPlayers()
            
            for _, otherPlayer in pairs(players) do
                if otherPlayer ~= Player and otherPlayer.Character then
                    local humanoidRootPart = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if humanoidRootPart then
                        local playerPosition = humanoidRootPart.Position
                        local distanceToTarget = (playerPosition - targetPosition).Magnitude
                        
                        if distanceToTarget <= 20 then
                            playerNearby = true
                            print("BOT: Player detected near target: " .. otherPlayer.Name)
                            break
                        end
                    end
                end
            end
            
            if playerNearby and Enabled then
                print("BOT: Teleporting car to target...")
                
                if ensureCarTeleport() then
                    print("BOT: Waiting 25 seconds")
                    wait(25)
                    
                    if Enabled then
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.F, false, game)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.F, false, game)
                        print("BOT: F key pressed")
                        
                        wait(5)
                        
                        if Enabled and playerCar and playerCar:FindFirstChild("DriveSeat") then
                            if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                                Player.Character.HumanoidRootPart.CFrame = playerCar.DriveSeat.CFrame
                                print("BOT: Teleported to car DriveSeat")

                                wait(0.1)
                                Player.Character.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame * CFrame.new(-1, 0, 0)
                                print("BOT: Moved left 1 stud")
                                
                                wait(0.1)
                                Player.Character.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame * CFrame.new(1, 0, 0)
                                print("BOT: Moved right 1 stud")
                                
                                wait(1)
                                
                                print("BOT: Teleporting back to target")
                                ensureCarTeleport()
                            end
                        end
                    end
                end
            else
                wait(0.5)
            end
        end
    end)
end

print("BOT: Script loaded successfully!")
StartRaceBot()
