-- Get the player and the TextButton
local player = game:GetService("Players").LocalPlayer
local button = player.PlayerGui.PortGui.PortMainMenu.MenuButtons.CargoManager.Button

-- Check if the button exists and is a TextButton
if button and button:IsA("TextButton") then
    -- Simulate a click by firing the MouseButton1Click event
    button:Activate()
    -- Alternatively, you can directly trigger the click event
    button.MouseButton1Click:Fire()
else
    warn("TextButton not found at the specified path or is not a TextButton")
end
