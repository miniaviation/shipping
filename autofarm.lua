-- Get the player
local player = game:GetService("Players").LocalPlayer
local buttonPath = player.PlayerGui:FindFirstChild("PortGui") and 
                  player.PlayerGui.PortGui:FindFirstChild("PortMainMenu") and 
                  player.PlayerGui.PortGui.PortMainMenu:FindFirstChild("MenuButtons") and 
                  player.PlayerGui.PortGui.PortMainMenu.MenuButtons:FindFirstChild("CargoManager") and 
                  player.PlayerGui.PortGui.PortMainMenu.MenuButtons.CargoManager:FindFirstChild("Button")

-- Check if the button exists
if buttonPath then
    if buttonPath:IsA("TextButton") then
        -- Simulate a click
        buttonPath:Activate() -- Primary method for TextButton
        buttonPath.MouseButton1Click:Fire() -- Fallback for custom click events
        print("TextButton clicked successfully")
    else
        warn("Found object is not a TextButton")
    end
else
    warn("TextButton not found at path: PlayerGui.PortGui.PortMainMenu.MenuButtons.CargoManager.Button")
end
