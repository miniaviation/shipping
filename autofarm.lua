local player = game:GetService("Players").LocalPlayer
local scrollingFrame = player.PlayerGui:FindFirstChild("PortGui") and 
                       player.PlayerGui.PortGui:FindFirstChild("ContainerMenu") and 
                       player.PlayerGui.PortGui.ContainerMenu:FindFirstChild("ScrollingFrame")

if scrollingFrame and scrollingFrame:IsA("ScrollingFrame") then
    -- Search for a TextButton named "Load" directly
    local loadButton = scrollingFrame:FindFirstChild("Load", true) -- Recursive search
    if loadButton and loadButton:IsA("TextButton") then
        loadButton:Activate()
        loadButton.MouseButton1Click:Fire()
        print("Clicked TextButton: " .. loadButton.Name)
    else
        warn("No TextButton named 'Load' found in ScrollingFrame")
    end
else
    warn("ScrollingFrame not found")
end
