local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local teleportSpeed = 0.4 -- Işınlama hızı (saniye)
local loopEnabled = true

local function getValidTokens()
    local tokens = {}
    local tokensFolder = workspace:FindFirstChild("Tokens")
    
    if tokensFolder then
        -- Tüm BasePart'ları al
        for _, child in ipairs(tokensFolder:GetDescendants()) do
            if child:IsA("BasePart") then
                table.insert(tokens, child)
            end
        end
    end
    
    return tokens
end

local function teleportPlayer()
    if not player.Character then return end
    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    local tokens = getValidTokens()
    
    while loopEnabled and humanoidRootPart and humanoidRootPart.Parent do
        for _, token in ipairs(tokens) do
            if token and token.Parent then
                -- Direkt CFrame ataması
                humanoidRootPart.CFrame = token.CFrame
                
                -- Aşırı hızlı teleport için bekleme
                if teleportSpeed > 0 then
                    wait(teleportSpeed)
                end
            end
        end
    end
end

-- Kontrol tuşları (isteğe bağlı)
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.P then
        loopEnabled = not loopEnabled
        print("Teleport loop:", loopEnabled and "ENABLED" or "DISABLED")
        if loopEnabled then
            teleportPlayer()
        end
    end
end)

-- Başlat
teleportPlayer()
