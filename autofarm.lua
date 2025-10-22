local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Updated firesignal definition (from your working script)
local firesignal = firesignal or function(signal)
    if getconnections then
        local connections = getconnections(signal)
        if connections then
            for _, connection in pairs(connections) do
                if connection and connection.Function then
                    pcall(connection.Function)
                end
            end
        else
            warn("No connections found for the signal!")
        end
    else
        warn("Executor does not support getconnections/firesignal!")
    end
end

-- Find the CargoManager Button
local cargoButton = playerGui:FindFirstChild("PortGui") and
                    playerGui.PortGui:FindFirstChild("PortMainMenu") and
                    playerGui.PortGui.PortMainMenu:FindFirstChild("MenuButtons") and
                    playerGui.PortGui.PortMainMenu.MenuButtons:FindFirstChild("CargoManager") and
                    playerGui.PortGui.PortMainMenu.MenuButtons.CargoManager:FindFirstChild("Button")

-- Find the Load Button
local scrollingFrame = playerGui:FindFirstChild("PortGui") and
                       playerGui.PortGui:FindFirstChild("ContainerMenu") and
                       playerGui.PortGui.ContainerMenu:FindFirstChild("ScrollingFrame")
local loadButton = nil
if scrollingFrame and scrollingFrame:IsA("ScrollingFrame") then
    local children = scrollingFrame:GetChildren()
    if children[16] then
        local target = children[16]
        if target:IsA("TextButton") and target.Name == "Load" then
            loadButton = target
        elseif target:IsA("Frame") then
            loadButton = target:FindFirstChild("Load")
        end
    end
end

-- Click the CargoManager Button first
if cargoButton and cargoButton:IsA("TextButton") then
    firesignal(cargoButton.MouseButton1Click)
    print("Fired MouseButton1Click for " .. cargoButton:GetFullName())
else
    warn("TextButton not found at PlayerGui.PortGui.PortMainMenu.MenuButtons.CargoManager.Button")
end

-- Wait briefly to ensure the first click processes
wait(0.5)

-- Click the Load Button second
if loadButton and loadButton:IsA("TextButton") then
    firesignal(loadButton.MouseButton1Click)
    print("Fired MouseButton1Click for " .. loadButton:GetFullName())
else
    warn("TextButton 'Load' not found at PlayerGui.PortGui.ContainerMenu.ScrollingFrame[16]")
    -- Debug: List ScrollingFrame children
    if scrollingFrame then
        print("Listing ScrollingFrame children for debugging:")
        for i, child in ipairs(scrollingFrame:GetChildren()) do
            if child:IsA("TextButton") then
                print("Child " .. i .. ": TextButton named " .. child.Name)
            elseif child:IsA("Frame") then
                local loadBtn = child:FindFirstChild("Load")
                if loadBtn and loadBtn:IsA("TextButton") then
                    print("Child " .. i .. ": Frame contains TextButton named " .. loadBtn.Name)
                end
            end
        end
    end
end
