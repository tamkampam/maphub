local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/Revenant", true))()
local Flags = Library.Flags

local Window = Library:Window({
   Text = "MainTab"
})

local teleporting = false
local VIM = game:GetService("VirtualInputManager")

local checkpoints = {}
for i = 1, 40 do
    checkpoints[i] = workspace.Races.Race1.Checkpoints[tostring(i)]
end
checkpoints[41] = workspace.Races.Race1.Checkpoints.Finish

local function teleportCar(cframe)
    local playerCar = game.Workspace[game.Players.LocalPlayer.Name .. "'s Car"]
    if playerCar and playerCar.PrimaryPart then
        playerCar:SetPrimaryPartCFrame(cframe)
    end
end

local function pressKey(key)
    VIM:SendKeyEvent(true, key, false, nil)
    VIM:SendKeyEvent(false, key, false, nil)
end

local function holdKey(key, duration)
    VIM:SendKeyEvent(true, key, false, nil)
    wait(duration)
    VIM:SendKeyEvent(false, key, false, nil)
end

local Toggle = Window:Toggle({
   Text = "AutoTp",
   Flag = "AutoTpFlag",
   Callback = function(bool)
        teleporting = bool
        if bool then
            teleportCar(CFrame.new(3260, -15, 1015))
            wait(15)
            
            while teleporting do
                for i = 1, 41 do
                    if not teleporting then break end
                    teleportCar(checkpoints[i].CFrame)
                    holdKey(Enum.KeyCode.W, 1.75)
                end
                
                if teleporting then
                    holdKey(Enum.KeyCode.Space, 5)
                    teleportCar(CFrame.new(3260, -15, 1015))
                    wait(15)
                    pressKey(Enum.KeyCode.Space)
                    wait(0.5)
                end
            end
        end
   end
})
