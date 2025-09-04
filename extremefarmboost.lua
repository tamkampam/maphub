local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

setfpscap(15)

if not Workspace:FindFirstChildOfClass("Terrain") then
    Instance.new("Terrain", Workspace)
end
Workspace.Terrain.WaterColor = Color3.fromRGB(128, 128, 128)
Workspace.Terrain.WaterReflectance = 0
Workspace.Terrain.WaterTransparency = 0
Workspace.Terrain.WaterWaveSize = 0
Workspace.Terrain.WaterWaveSpeed = 0

local function optimizePart(part)
    if part:IsA("BasePart") then
        part.Material = Enum.Material.SmoothPlastic
        part.Color = Color3.fromRGB(128, 128, 128)
        part.Reflectance = 0
        part.Transparency = 0
        
        if part:IsA("Part") or part:IsA("MeshPart") then
            part.BrickColor = BrickColor.new("Medium stone grey")
        end
        
        local surfaceAppearance = part:FindFirstChild("SurfaceAppearance")
        if surfaceAppearance then
            surfaceAppearance:Destroy()
        end
        
        for _, child in ipairs(part:GetChildren()) do
            if child:IsA("Decal") or child:IsA("Texture") then
                child:Destroy()
            end
        end
    end
end

local function optimizeModel(model)
    task.wait(2)
    
    for _, part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") then
            optimizePart(part)
        elseif part:IsA("ParticleEmitter") or part:IsA("Beam") or part:IsA("Trail") or part:IsA("Sparkles") then
            part:Destroy()
        elseif part:IsA("ShirtGraphic") then
            part:Destroy()
        elseif part:IsA("SpecialMesh") then
            part.TextureId = ""
        elseif part:IsA("Humanoid") then
            part:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            part:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        elseif part:IsA("PointLight") or part:IsA("SurfaceLight") or part:IsA("SpotLight") then
            part:Destroy()
        end
    end
end

local function optimizeCharacter(character)
    task.wait(2)
    
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            optimizePart(part)
        elseif part:IsA("ParticleEmitter") or part:IsA("Beam") or part:IsA("Trail") or part:IsA("Sparkles") then
            part:Destroy()
        elseif part:IsA("ShirtGraphic") then
            part:Destroy()
        elseif part:IsA("SpecialMesh") then
            part.TextureId = ""
        elseif part:IsA("Clothing") or part:IsA("Accessory") or part:IsA("Hat") then
            part:Destroy()
        elseif part:IsA("FaceInstance") then
            part:Destroy()
        elseif part:IsA("Humanoid") then
            part:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            part:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        elseif part:IsA("PointLight") or part:IsA("SurfaceLight") or part:IsA("SpotLight") then
            part:Destroy()
        end
    end
end

local function optimizeExistingObjects()
    for _, part in ipairs(Workspace:GetDescendants()) do
        if part:IsA("BasePart") then
            optimizePart(part)
        elseif part:IsA("Model") then
            task.spawn(function()
                optimizeModel(part)
            end)
        elseif part:IsA("ParticleEmitter") or part:IsA("Beam") or part:IsA("Trail") or part:IsA("Sparkles") then
            part:Destroy()
        elseif part:IsA("ShirtGraphic") then
            part:Destroy()
        elseif part:IsA("PointLight") or part:IsA("SurfaceLight") or part:IsA("SpotLight") then
            part:Destroy()
        end
    end
    
    for _, obj in ipairs(Workspace:GetChildren()) do
        if obj:IsA("Sky") or obj:IsA("PostEffect") or obj:IsA("Atmosphere") then
            obj:Destroy()
        end
    end
end

local function setupEnvironment()
    Lighting.Sky.SkyboxBk = "rbxassetid://0"
    Lighting.Sky.SkyboxDn = "rbxassetid://0"
    Lighting.Sky.SkyboxFt = "rbxassetid://0"
    Lighting.Sky.SkyboxLf = "rbxassetid://0"
    Lighting.Sky.SkyboxRt = "rbxassetid://0"
    Lighting.Sky.SkyboxUp = "rbxassetid://0"
    
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 50
    Lighting.FogStart = 0
    Lighting.Brightness = 1
    Lighting.Ambient = Color3.fromRGB(128, 128, 128)
    Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    Lighting.ColorShift_Bottom = Color3.fromRGB(128, 128, 128)
    Lighting.ColorShift_Top = Color3.fromRGB(128, 128, 128)
    Lighting.ExposureCompensation = 0
    
    for _, effect in ipairs(Lighting:GetChildren()) do
        if effect:IsA("PostEffect") or effect:IsA("Atmosphere") or effect:IsA("BloomEffect") or 
           effect:IsA("BlurEffect") or effect:IsA("ColorCorrectionEffect") or effect:IsA("SunRaysEffect") or
           effect:IsA("DepthOfFieldEffect") then
            effect:Destroy()
        end
    end
end

Workspace.CurrentCamera:SetRenderCFrame(CFrame.new())
Workspace.CurrentCamera:SetFieldOfView(70)
Workspace:SetRenderDistance(30)

settings().Rendering.QualityLevel = 1
settings().Rendering.MeshCacheSize = 0
settings().Rendering.EagerBulkExecution = false
settings().Rendering.EnableFRM = false
settings().Rendering.ReloadAssets = false

Workspace.Gravity = 196.2
settings().Physics.PhysicsEnvironmentalThrottle = 2
settings().Physics.ThrottleAdjustTime = 10
settings().Physics.AllowSleep = true

UserInputService.MouseIconEnabled = false

local function applyOptimizations()
    setupEnvironment()
    optimizeExistingObjects()
    
    Workspace.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("BasePart") then
            optimizePart(descendant)
        elseif descendant:IsA("Model") then
            task.spawn(function()
                optimizeModel(descendant)
            end)
        elseif descendant:IsA("ParticleEmitter") or descendant:IsA("Beam") or descendant:IsA("Trail") or descendant:IsA("Sparkles") then
            task.wait(0.1)
            descendant:Destroy()
        elseif descendant:IsA("PointLight") or descendant:IsA("SurfaceLight") or descendant:IsA("SpotLight") then
            descendant:Destroy()
        end
    end)
    
    if Players.LocalPlayer then
        local character = Players.LocalPlayer.Character
        if character then
            task.spawn(function()
                optimizeCharacter(character)
            end)
        end
        
        Players.LocalPlayer.CharacterAdded:Connect(function(char)
            task.spawn(function()
                optimizeCharacter(char)
            end)
        end)
    end
end

applyOptimizations()
