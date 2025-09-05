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
        print("BOT: Teleport failed, retrying attempt " .. attempts .. "...")
        teleportCar(targetCFrame)
        wait(1)
    end
    
    if isCarAtTargetPosition() then
        print("BOT: Car successfully teleported to target position")
        return true
    else
        print("BOT: ERROR - Failed to teleport car after " .. attempts .. " attempts")
        return false
    end
end

function StartRaceBot()
    spawn(function()
        print("BOT: Starting race bot...")
        print("BOT: Player: " .. Player.Name)
        print("BOT: Car name: " .. CarName)
        print("BOT: Target position: " .. tostring(targetPosition))
        
        while Enabled do
            local playerNearby = false
            
            local players = game:GetService("Players"):GetPlayers()
            print("BOT: Checking " .. #players .. " players near target position")
            
            for _, otherPlayer in pairs(players) do
                if otherPlayer ~= Player and otherPlayer.Character then
                    local humanoidRootPart = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if humanoidRootPart then
                        local playerPosition = humanoidRootPart.Position
                        local distanceToTarget = (playerPosition - targetPosition).Magnitude
                        
                        print("BOT: " .. otherPlayer.Name .. " - Distance to target: " .. math.floor(distanceToTarget) .. " studs")
                        
                        if distanceToTarget <= 20 then
                            playerNearby = true
                            print("BOT: Player detected near target: " .. otherPlayer.Name .. " (" .. math.floor(distanceToTarget) .. " studs from target)")
                            break
                        end
                    end
                end
            end
            
            if playerNearby and Enabled then
                print("BOT: Player detected near target position, teleporting car...")
                
                if ensureCarTeleport() then
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
                                
                                print("BOT: Waiting 1 second...")
                                wait(1)
                                
                                print("BOT: Teleporting back to target position...")
                                ensureCarTeleport()
                            else
                                print("BOT: ERROR - Character or HumanoidRootPart not found for teleport")
                            end
                        else
                            print("BOT: ERROR - Car or DriveSeat not found")
                        end
                    end
                end
            else
                print("BOT: No players detected near target position, checking again in 0.5 seconds...")
                wait(0.5)
            end
        end
    end)
end

print("BOT: Script loaded successfully! Starting automatically...")
print("BOT: Enabled: " .. tostring(Enabled))
StartRaceBot()
