local player = game:GetService("Players").LocalPlayer
local button = player.PlayerGui.PortGui.PortMainMenu.MenuButtons.CargoManager.Button

if button then
    -- Alternative approach using MouseButton1Click
    local clickEvent = button.MouseButton1Click
    if clickEvent then
        clickEvent:Fire()
    else
        button:Activate()
    end
else
    warn("Button not found at the specified path")
end
