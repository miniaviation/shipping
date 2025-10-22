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
local function findButton(parentPath)
    local success, result = pcall(function()
        local parts = parentPath:split(".")
        local current = game
        for _, part in pairs(parts) do
            if part ~= "game" then
                current = current:WaitForChild(part)
            end
        end
        for _, child in pairs(current:GetChildren()) do
            if child:IsA("TextButton") then
                return child
            end
        end
        return nil
    end)
    if not success then
        warn("Failed to find button at path: " .. parentPath .. " | Error: " .. tostring(result))
        return nil
    end
    return result
end

-- Function to initialize or refresh the button
local function initializeButton(parentPath)
    if not currentButton or not currentButton.Parent then
        currentButton = findButton(parentPath)
        if currentButton then
            print("Initialized button: " .. currentButton:GetFullName())
            print("Current button name: " .. currentButton.Name)
        else
            warn("No TextButton found at " .. parentPath .. "!")
            print("Listing children for debugging:")
            local parent = game
            for part in parentPath:split(".") do
                if part ~= "game" then
                    parent = parent:WaitForChild(part)
                end
            end
            for _, child in pairs(parent:GetChildren()) do
                print("Child: " .. child.Name .. " | Class: " .. child.ClassName)
            end
        end
    end
end

-- Function to fire the click signal with error handling
local function fireClick(buttonPath)
    local button = findButton(buttonPath)
    if button and button:IsA("TextButton") then
        firesignal(button.MouseButton1Click)
        print("Fired MouseButton1Click for " .. button:GetFullName())
    else
        warn("Failed to fire click for " .. buttonPath .. " | Button not found or not a TextButton!")
    end
end

-- Main sequence function
local function executeSequence()
    -- Step 1: Initialize and fire the first button (ShipControlGui)
    initializeButton("game:GetService(\"Players\").LocalPlayer.PlayerGui.ShipControlGui.Menus.DockingRequest")
    if currentButton and currentButton:IsA("TextButton") then
        firesignal(currentButton.MouseButton1Click)
        print("Fired MouseButton1Click for " .. currentButton:GetFullName())
    else
        warn("Initial button invalid, sequence aborted!")
        return
    end

    -- Step 2: Fire CargoManager button after 5 seconds
    wait(5)
    fireClick("game:GetService(\"Players\").LocalPlayer.PlayerGui.PortGui.PortMainMenu.MenuButtons.CargoManager.Button")

    -- Step 3: Fire Load button after 1 more second (6 seconds total)
    wait(1)
    fireClick("game:GetService(\"Players\").LocalPlayer.PlayerGui.PortGui.BulkMenu.ScrollingFrame.ListItem.Load")

    -- Step 4: Fire CargoManager button again after 10 more seconds (16 seconds total)
    wait(10)
    fireClick("game:GetService(\"Players\").LocalPlayer.PlayerGui.PortGui.PortMainMenu.MenuButtons.CargoManager.Button")
end

-- Run the sequence
executeSequence()
