-- Get the player
local player = game:GetService("Players").LocalPlayer
local scrollingFrame = player.PlayerGui:FindFirstChild("PortGui") and 
                      player.PlayerGui.PortGui:FindFirstChild("ContainerMenu") and 
                      player.PlayerGui.PortGui.ContainerMenu:FindFirstChild("ScrollingFrame")

-- Check if ScrollingFrame exists
if scrollingFrame and scrollingFrame:IsA("ScrollingFrame") then
    -- Get all children of ScrollingFrame
    local children = scrollingFrame:GetChildren()
    
    -- Check if the 16th child exists (Lua uses 1-based indexing)
    if children[16] then
        local target = children[16]
        
        -- Check if the 16th child is a Frame or TextButton
        if target:IsA("TextButton") and target.Name == "Load" then
            -- Click the TextButton directly
            target:Activate()
            target.MouseButton1Click:Fire()
            print("Clicked TextButton: " .. target.Name)
        elseif target:IsA("Frame") then
            -- Look for a TextButton named "Load" inside the Frame
            local loadButton = target:FindFirstChild("Load")
            if loadButton and loadButton:IsA("TextButton") then
                loadButton:Activate()
                loadButton.MouseButton1Click:Fire()
                print("Clicked TextButton: " .. loadButton.Name)
            else
                warn("No TextButton named 'Load' found in Frame: " .. target.Name)
            end
        else
            warn("16th child is not a TextButton or Frame, it is: " .. target.ClassName)
        end
    else
        warn("No 16th child found in ScrollingFrame (only " .. #children .. " children exist)")
    end
else
    warn("ScrollingFrame not found at path: PlayerGui.PortGui.ContainerMenu.ScrollingFrame")
end
