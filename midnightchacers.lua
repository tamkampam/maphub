local Enabled = true
local Player = game:GetService("Players").LocalPlayer
local CarName = Player.Name .. "'s Car"
local playerCar = workspace[CarName]

local targetPosition1 = Vector3.new(3260, -15, 1015)
local targetPosition2 = Vector3.new(3344, -15, 971)
local targetCFrame1 = CFrame.new(targetPosition1)
local targetCFrame2 = CFrame.new(targetPosition2)

local lastPrintTime = 0
local printCooldown = 120

function teleportCar(cframe)
    if playerCar and playerCar.PrimaryPart then
        playerCar:SetPrimaryPartCFrame(cframe)
        print("BOT: Car teleported to position: " .. tostring(cframe.Position))
        return true
    else
        print("BOT: ERROR - Car or PrimaryPart not found")
        return false
    end
end

function isCarAtPosition(position)
    if playerCar and playerCar.PrimaryPart then
        local carPosition = playerCar.PrimaryPart.Position
        local distance = (carPosition - position).Magnitude
        return distance <= 20
    end
    return false
end

function ensureCarTeleport(targetCFrame, targetPosition)
    local attempts = 0
    local maxAttempts = 5
    
    while not isCarAtPosition(targetPosition) and attempts < maxAttempts and Enabled do
        attempts += 1
        print("BOT: Teleport failed, retrying attempt " .. attempts .. "...")
        teleportCar(targetCFrame)
        wait(1)
    end
    
    if isCarAtPosition(targetPosition) then
        print("BOT: Car successfully teleported to target position")
        return true
    else
        print("BOT: ERROR - Failed to teleport car after " .. attempts .. " attempts")
        return false
    end
end

function checkPlayersNearTarget()
    local playersNearTarget = false
    local currentTime = tick()
    
    local players = game:GetService("Players"):GetPlayers()
    
    for _, otherPlayer in pairs(players) do
        if otherPlayer ~= Player and otherPlayer.Character then
            local humanoidRootPart = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local playerPosition = humanoidRootPart.Position
                local distanceToTarget = (playerPosition - targetPosition1).Magnitude
                
                if distanceToTarget <= 20 then
                    playersNearTarget = true
                    if currentTime - lastPrintTime >= printCooldown then
                        print("BOT: Player detected near target: " .. otherPlayer.Name .. " (" .. math.floor(distanceToTarget) .. " studs from target)")
                        lastPrintTime = currentTime
                    end
                    break
                end
            end
        end
    end
    
    return playersNearTarget
end

function StartRaceBot()
    spawn(function()
        print("BOT: Starting race bot...")
        print("BOT: Player: " .. Player.Name)
        print("BOT: Car name: " .. CarName)
        print("BOT: Primary target position: " .. tostring(targetPosition1))
        print("BOT: Secondary target position: " .. tostring(targetPosition2))
        
        ensureCarTeleport(targetCFrame2, targetPosition2)
        
        while Enabled do
            local playersNearTarget = checkPlayersNearTarget()
            
            if playersNearTarget and Enabled then
                print("BOT: Player detected near primary target, teleporting to position 1...")
                
                if ensureCarTeleport(targetCFrame1, targetPosition1) then
                    print("BOT: Starting 40-second process...")
                    
                    wait(25)
                    
                    if Enabled then
                        print("BOT: Sending F key...")
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.F, false, game)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.F, false, game)
                        
                        wait(5)
                        
                        if Enabled and playerCar and playerCar:FindFirstChild("DriveSeat") then
                            if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                                Player.Character.HumanoidRootPart.CFrame = playerCar.DriveSeat.CFrame

                                wait(0.1)
                                Player.Character.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame * CFrame.new(-1, 0, 0)
                                
                                wait(0.1)
                                Player.Character.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame * CFrame.new(1, 0, 0)
                                
                                game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                                game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                                
                                game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.S, false, game)
                                wait(2)
                                game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.S, false, game)
                                
                                game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                                wait(3.5)
                                game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                                
                                wait(1)
                                
                                print("BOT: Process completed, teleporting to secondary position...")
                                ensureCarTeleport(targetCFrame2, targetPosition2)
                            end
                        end
                    end
                end
            else
                if not isCarAtPosition(targetPosition2) then
                    ensureCarTeleport(targetCFrame2, targetPosition2)
                end
                wait(2)
            end
        end
    end)
end

print("BOT: Script loaded successfully! Starting automatically...")
print("BOT: Enabled: " .. tostring(Enabled))
StartRaceBot()
