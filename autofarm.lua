local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Updated firesignal definition
local firesignal = firesignal or function(signal)
    if getconnections then
        local connections = getconnections(signal)
        if connections then
            for _, connection in pairs(connections) do
                if connection and connection.Function then
                    pcall(connection.Function) -- Safely call the connected function
                end
            end
        else
            warn("No connections found for the signal!")
        end
    else
        warn("Executor does not support getconnections/firesignal!")
    end
end

-- Variable to store the found button
local currentButton = nil

-- Function to find the TextButton (called once or on refresh)
local function findButton()
    local dockingRequest = playerGui:WaitForChild("ShipControlGui"):WaitForChild("Menus"):WaitForChild("DockingRequest")
    for _, child in pairs(dockingRequest:GetChildren()) do
        if child:IsA("TextButton") then
            return child
        end
    end
    return nil
end

-- Function to initialize or refresh the button
local function initializeButton()
    if not currentButton or not currentButton.Parent then
        currentButton = findButton()
        if currentButton then
            print("Initialized button: " .. currentButton:GetFullName())
            print("Current button name: " .. currentButton.Name)
        else
            warn("No TextButton found in DockingRequest!")
            print("Listing children for debugging:")
            for _, child in pairs(dockingRequest:GetChildren()) do
                print("Child: " .. child.Name .. " | Class: " .. child.ClassName)
            end
        end
    end
end

-- Function to fire the click signal
local function clickButton()
    if not currentButton then
        initializeButton()
    end
    
    if currentButton and currentButton:IsA("TextButton") then
        firesignal(currentButton.MouseButton1Click)
        print("Fired MouseButton1Click for " .. currentButton:GetFullName())
    else
        warn("Current button is invalid! Re-initializing...")
        initializeButton()
        if currentButton then
            firesignal(currentButton.MouseButton1Click)
            print("Fired MouseButton1Click for " .. currentButton:GetFullName())
        else
            warn("Failed to find a valid TextButton after re-initialization!")
        end
    end
end

-- Initial setup
initializeButton()

-- Example: Call clickButton whenever you want to fire the signal
clickButton()
wait(15)

-- Click CargoManager Button
firesignal(pg.PortGui.PortMainMenu.MenuButtons.CargoManager.Button.MouseButton1Click)

wait(0.5)

-- Click Load Button (16th child)
firesignal(pg.PortGui.ContainerMenu.ScrollingFrame:GetChildren()[16].Load.MouseButton1Click)

wait(30)

-- Click Back Button
firesignal(pg.PortGui.ContainerMenu.Back.MouseButton1Click)

wait(0.5)

-- Click Undock Button
firesignal(pg.PortGui.PortMainMenu.MenuButtons.Undock.Button.MouseButton1Click)




