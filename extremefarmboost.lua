local runService = game:GetService("RunService")
local lighting = game:GetService("Lighting")
local players = game:GetService("Players")
local workspace = game:GetService("Workspace")

runService:Set3dRenderingEnabled(false)

lighting.GlobalShadows = false
lighting.Outlines = false
lighting.Ambient = Color3.new(0, 0, 0)
lighting.Brightness = 0
lighting.FogEnd = 0
lighting.FogStart = 0

workspace.Retargeting = "Disabled"
workspace.StreamingEnabled = false

for _, object in ipairs(workspace:GetDescendants()) do
    if object:IsA("BasePart") or object:IsA("Model") or object:IsA("MeshPart") then
        object:Destroy()
    end
end

for _, effect in ipairs(lighting:GetChildren()) do
    if effect:IsA("PostEffect") or effect:IsA("Atmosphere") or effect:IsA("BloomEffect") then
        effect:Destroy()
    end
end

if players.LocalPlayer then
    local playerGui = players.LocalPlayer:WaitForChild("PlayerGui")
    
    for _, gui in ipairs(playerGui:GetChildren()) do
        if gui:IsA("ScreenGui") then
            gui:Destroy()
        end
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "BlackScreen"
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = playerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
end

local wall = Instance.new("Part")
wall.Size = Vector3.new(10000, 10000, 10000)
wall.Position = Vector3.new(0, 0, 0)
wall.Anchored = true
wall.Transparency = 0
wall.Color = Color3.new(0, 0, 0)
wall.Material = Enum.Material.SmoothPlastic
wall.CanCollide = false
wall.Parent = workspace

if setfpscap then
    setfpscap(15)
end

workspace.DescendantAdded:Connect(function(descendant)
    if descendant:IsA("BasePart") or descendant:IsA("Model") or descendant:IsA("MeshPart") then
        descendant:Destroy()
    end
end)

if players.LocalPlayer then
    players.LocalPlayer.CharacterAdded:Connect(function(character)
        character:WaitForChild("HumanoidRootPart")
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
            end
        end
    end)
end
