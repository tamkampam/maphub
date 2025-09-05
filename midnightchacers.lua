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
    local playersNear40Stud = false
    local playersNear20Stud = false
    local currentTime = tick()
    
    local players = game:GetService("Players"):GetPlayers()
    
    for _, otherPlayer in pairs(players) do
        if otherPlayer ~= Player and otherPlayer.Character then
            local humanoidRootPart = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local playerPosition = humanoidRootPart.Position
                local distanceToTarget = (playerPosition - targetPosition1).Magnitude
                
                if distanceToTarget <= 40 and not playersNear40Stud then
                    playersNear40Stud = true
                    if currentTime - lastPrintTime >= printCooldown then
                        print("BOT: Player detected within 40 studs: " .. otherPlayer.Name .. " (" .. math.floor(distanceToTarget) .. " studs)")
                        lastPrintTime = currentTime
                    end
                end
                
                if distanceToTarget <= 20 and not playersNear20Stud then
                    playersNear20Stud = true
                    if currentTime - lastPrintTime >= printCooldown then
                        print("BOT: Player detected within 20 studs: " .. otherPlayer.Name .. " (" .. math.floor(distanceToTarget) .. " studs)")
                        lastPrintTime = currentTime
                    end
                end
            end
        end
    end
    
    return playersNear40Stud, playersNear20Stud
end

function performKeyActions()
    print("BOT: Starting key sequence...")
    
    print("BOT: Pressing SPACE key once...")
    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Space, false, game)
    game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Space, false, game)
    wait(0.1)
    
    print("BOT: Holding S key for 2 seconds...")
    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.S, false, game)
    wait(2)
    game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.S, false, game)
    print("BOT: S key released")
    wait(0.1)
    
    print("BOT: Holding SPACE key for 3.5 seconds...")
    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Space, false, game)
    wait(3.5)
    game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Space, false, game)
    print("BOT: SPACE key released")
    
    print("BOT: Key sequence completed")
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
            local playersNear40Stud, playersNear20Stud = checkPlayersNearTarget()
            
            if playersNear40Stud and Enabled then
                print("BOT: Player detected within 40 studs, teleporting to position 1...")
                ensureCarTeleport(targetCFrame1, targetPosition1)
                
                if playersNear20Stud then
                    print("BOT: Player within 20 studs detected, starting 25-second process...")
                    wait(25)
                    
                    if Enabled then
                        print("BOT: Sending F key...")
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.F, false, game)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.F, false, game)
                        
                        print("BOT: Waiting 5 seconds...")
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
                                
                                performKeyActions()
                                
                                wait(1)
                                
                                print("BOT: Process completed, teleporting to secondary position...")
                                ensureCarTeleport(targetCFrame2, targetPosition2)
                            end
                        end
                    end
                else
                    print("BOT: Player within 40 studs but not within 20 studs, waiting...")
                    wait(2)
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
