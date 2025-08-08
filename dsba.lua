local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local fusion = game:GetService("ReplicatedStorage"):WaitForChild("Fusion")

-- ===== TOOL MANAGEMENT =====
local function CopyTools()
    pcall(function()
        local backpack = Player:WaitForChild("Backpack")
        
        -- Copy EventCommand
        local eventCommand = Lighting:FindFirstChild("EventCommand")
        if eventCommand then
            local existing = backpack:FindFirstChild("EventCommand")
            if existing then existing:Destroy() end
            eventCommand:Clone().Parent = backpack
        end
        
        -- Copy LimitBreaker (clean version)
        local limitBreaker = Lighting:FindFirstChild("LimitBreaker")
        if limitBreaker then
            local existing = backpack:FindFirstChild("LimitBreaker")
            if existing then existing:Destroy() end
            local clone = limitBreaker:Clone()
            for _,v in pairs(clone:GetDescendants()) do
                if v:IsA("BasePart") or v:IsA("ParticleEmitter") or v:IsA("Sound") then
                    v:Destroy()
                end
            end
            clone.Parent = backpack
        end
    end)
end

-- ===== LIMITBREAKER SYSTEM =====
local function SetupLimitBreaker()
    local LimitBreaker = ReplicatedStorage:WaitForChild("LimitBreaker")
    local cooldown = false
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if input.KeyCode == Enum.KeyCode.K and not gameProcessed and not cooldown then
            cooldown = true
            LimitBreaker:FireServer()
            
            -- Set walkspeed after delay
            task.wait(0.5)
            if Player.Character and Player.Character:FindFirstChild("Humanoid") then
                Player.Character.Humanoid.WalkSpeed = 20
            end
            
            cooldown = false
        end
    end)
end

-- ===== INFINITE KI SYSTEM =====
local function SetMaxKi()
    pcall(function()
        Player.PlayerGui.Bars.Background.KiBar.Ki.Value = 1000000000000000
    end)
end

-- ===== PURE LIFE STEAL SYSTEM =====
local LifeStealActive = false
local LifeStealConnection = nil

local function ToggleLifeSteal()
    LifeStealActive = not LifeStealActive
    local LazerEvent2 = ReplicatedStorage:WaitForChild("LazerEvent2")
    
    if LifeStealActive then
        LifeStealConnection = RunService.Heartbeat:Connect(function()
            for _, target in ipairs(Players:GetPlayers()) do
                if target ~= Player and target.Character then
                    LazerEvent2:FireServer(target.Character)
                end
            end
        end)
    elseif LifeStealConnection then
        LifeStealConnection:Disconnect()
        LifeStealConnection = nil
    end
end

local function ActivateLifeSteal()
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if input.KeyCode == Enum.KeyCode.Y and not gameProcessed then
            ToggleLifeSteal()
        end
    end)
end

-- ===== LIGHTNING SYSTEM =====
local function ActivateLightning()
    local LightningStrikeEvent = ReplicatedStorage:WaitForChild("LightningStrikeEvent")
    local LightningTool = Lighting:WaitForChild("Lightning")
    local LightningScript = LightningTool:WaitForChild("LocalScript")
    local LightningBolt = LightningScript:WaitForChild("Lightning Bolt")
    local LightningStrike = LightningScript:WaitForChild("Lightning Strike")
    local cooldown = false
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if input.KeyCode == Enum.KeyCode.V and not gameProcessed and not cooldown then
            cooldown = true
            local mouse = Player:GetMouse()
            LightningStrikeEvent:FireServer(mouse.Hit)
            LightningBolt:Play()
            task.wait(0.25)
            LightningStrike:Play()
            task.delay(1.5, function() cooldown = false end)
        end
    end)
end

-- ===== TELEPORT SYSTEM =====
local function SetupTeleport()
    local character = Player.Character
    if not character then return end
    local humanoid = character:WaitForChild("Humanoid")
    local rootPart = character:WaitForChild("HumanoidRootPart")
    local head = character:WaitForChild("Head")
    local mouse = Player:GetMouse()
    local teleportSound = Instance.new("Sound")
    teleportSound.SoundId = "rbxassetid://153613030"
    teleportSound.Volume = 0.5
    teleportSound.Parent = head
    teleportSound.Name = "Teleport"
    local teleportReady = true

    local function findNearestPlayer(position)
        local closestPlayer = nil
        local closestDistance = 20
        for _, otherPlayer in ipairs(Players:GetPlayers()) do
            if otherPlayer ~= Player and otherPlayer.Character then
                local otherRoot = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
                if otherRoot then
                    local distance = (position - otherRoot.Position).Magnitude
                    if distance < closestDistance then
                        closestPlayer = otherPlayer
                        closestDistance = distance
                    end
                end
            end
        end
        return closestPlayer
    end

    mouse.KeyDown:Connect(function(key)
        if key == "r" and teleportReady then
            teleportReady = false
            local animation = Instance.new("Animation")
            animation.AnimationId = "rbxassetid://2717244406"
            humanoid:LoadAnimation(animation):Play()
            task.wait(0.5)
            local maxRange = 5000
            local targetPos = mouse.Hit.p
            if (rootPart.Position - targetPos).Magnitude <= maxRange then
                local adjustedPosition = targetPos + Vector3.new(0, 2.5, 0)
                local nearestPlayer = findNearestPlayer(adjustedPosition)
                if nearestPlayer then
                    local targetRoot = nearestPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if targetRoot then
                        rootPart.CFrame = CFrame.new(adjustedPosition,Vector3.new(targetRoot.Position.X,adjustedPosition.Y,targetRoot.Position.Z))
                    else
                        rootPart.CFrame = CFrame.new(adjustedPosition)
                    end
                else
                    rootPart.CFrame = CFrame.new(adjustedPosition)
                end
                teleportSound:Play()
            end
            task.delay(0.08, function() teleportReady = true end)
        end
    end)
end

-- ===== SMART IMMORTALITY SYSTEM =====
local function SmartImmortality()
    local RS = game:GetService("ReplicatedStorage")
    local giveHP = RS:WaitForChild("GiveHP")

    task.spawn(function()
        while task.wait(0.1) do
            local char = Player.Character
            if char then
                local hum = char:FindFirstChild("Humanoid")
                if hum and hum.Health < hum.MaxHealth then
                    local missing = hum.MaxHealth - hum.Health
                    giveHP:FireServer(missing) -- heal exactly the missing amount
                end
            end
        end
    end)
end

local function QuickFusion()
fusion:FireServer("some_value", 123, true)
end

-- ===== INITIAL SETUP =====
CopyTools()
SetupLimitBreaker()
ActivateLifeSteal()
ActivateLightning()

Player.CharacterAdded:Connect(function(character)
    task.wait(0.5)
    CopyTools()
    SetupTeleport()
end)

if Player.Character then
    task.spawn(function()
        task.wait(0.5)
        SetupTeleport()
    end)
end

-- Continuous KI update
task.spawn(function()
    while true do
        SetMaxKi()
        RunService.Heartbeat:Wait()
    end
end)
