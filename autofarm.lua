local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Updated firesignal definition (this works!)
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

-- Function to find the TextButton in DockingRequest (this works!)
local function findDockingButton()
    local dockingRequest = playerGui:WaitForChild("ShipControlGui"):WaitForChild("Menus"):WaitForChild("DockingRequest")
    for _, child in pairs(dockingRequest:GetChildren()) do
        if child:IsA("TextButton") then
            return child
        end
    end
    return nil
end

-- Function to find specific buttons by path
local function findSpecificButton(pathParts)
    local current = playerGui
    for _, part in pairs(pathParts) do
        current = current:WaitForChild(part)
    end
    return current
end

-- Function to initialize or refresh the docking button
local function initializeButton()
    if not currentButton or not currentButton.Parent then
        currentButton = findDockingButton()
        if currentButton then
            print("Initialized docking button: " .. currentButton:GetFullName())
            print("Current button name: " .. currentButton.Name)
        else
            warn("No TextButton found in DockingRequest!")
            return false
        end
    end
    return true
end

-- Function to fire any button's click signal
local function fireButtonClick(button, buttonName)
    if button and (button:IsA("TextButton") or button:IsA("ImageButton")) then
        firesignal(button.MouseButton1Click)
        print("Fired MouseButton1Click for " .. button:GetFullName() .. " (" .. buttonName .. ")")
        return true
    else
        warn("Button not found or invalid for " .. buttonName .. "!")
        return false
    end
end

-- Main sequence function
local function executeSequence()
    print("=== Starting Auto Sequence ===")
    
    -- Step 1: Fire docking button (immediate)
    if initializeButton() then
        fireButtonClick(currentButton, "Docking Button")
    else
        warn("Failed to initialize docking button - sequence aborted!")
        return
    end
    
    -- Step 2: Wait 5 seconds, then fire CargoManager button
    wait(5)
    print("--- 5 seconds passed, firing CargoManager ---")
    local cargoButton = findSpecificButton({"PortGui", "PortMainMenu", "MenuButtons", "CargoManager", "Button"})
    fireButtonClick(cargoButton, "CargoManager")
    
    -- Step 3: Wait 1 more second, then fire Load button
    wait(1)
    print("--- 1 second passed, firing Load ---")
    local loadButton = findSpecificButton({"PortGui", "BulkMenu", "ScrollingFrame", "ListItem", "Load"})
    fireButtonClick(loadButton, "Load")
    
    -- Step 4: Wait 10 more seconds, then fire CargoManager button again
    wait(10)
    print("--- 10 seconds passed, firing CargoManager again ---")
    local cargoButton2 = findSpecificButton({"PortGui", "PortMainMenu", "MenuButtons", "CargoManager", "Button"})
    fireButtonClick(cargoButton2, "CargoManager (2nd time)")
    
    print("=== Sequence Complete ===")
end

-- Run the sequence
executeS
