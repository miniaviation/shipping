-- Get the player
local player = game:GetService("Players").LocalPlayer
local cargoManager = player.PlayerGui:FindFirstChild("PortGui") and 
                     player.PlayerGui.PortGui:FindFirstChild("PortMainMenu") and 
                     player.PlayerGui.PortMainMenu:FindFirstChild("MenuButtons") and 
                     player.PlayerGui.PortMainMenu.MenuButtons:FindFirstChild("CargoManager")

-- Check if CargoManager Frame exists
if cargoManager and cargoManager:IsA("Frame") then
    -- Try to find a TextButton named "Button" (from your original path)
    local button = cargoManager:FindFirstChild("Button")
    
    if button and button:IsA("TextButton") then
        -- Simulate a click
        button:Activate()
        button.MouseButton1Click:Fire()
        print("Clicked TextButton: " .. button.Name)
    else
        -- If "Button" isn't found, check all children for any TextButton
        local foundButton = false
        for _, child in pairs(cargoManager:GetChildren()) do
            if child:IsA("TextButton") then
                child:Activate()
                child.MouseButton1Click:Fire()
                print("Clicked TextButton: " .. child.Name)
                foundButton = true
            end
        end
        if not foundButton then
            warn("No TextButton found under CargoManager Frame")
        end
    end
else
    warn("CargoManager Frame not found at path: PlayerGui.PortGui.PortMainMenu.MenuButtons.CargoManager")
end
