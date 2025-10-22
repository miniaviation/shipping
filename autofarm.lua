-- Get the player and the button
local player = game:GetService("Players").LocalPlayer
local button = player.PlayerGui.PortGui.PortMainMenu.MenuButtons.CargoManager.Button

-- Check if the button exists
if button then
    -- Fire the click event
    button:Activate()
else
    warn("Button not found at the specified path")
end
