local runService = game:GetService("RunService")
local lighting = game:GetService("Lighting")
local players = game:GetService("Players")
local workspace = game:GetService("Workspace")

runService:Set3dRenderingEnabled(false)

if setfpscap then
    setfpscap(15)
end

local function destroyDebugGUIs(player)
    local containers = {player:WaitForChild("PlayerGui"), lighting, workspace}
    for _, container in ipairs(containers) do
        for _, gui in ipairs(container:GetDescendants()) do
            if gui:IsA("ScreenGui") or gui:IsA("SurfaceGui") or gui:IsA("BillboardGui") then
                pcall(function() gui:Destroy() end)
                task.wait()
            end
        end
    end
end

if players.LocalPlayer then
    destroyDebugGUIs(players.LocalPlayer)
    
    local playerGui = players.LocalPlayer:WaitForChild("PlayerGui")
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
