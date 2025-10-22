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

-- Variable to store the found docking button
local currentDockingButton = nil

-- Function to find the docking TextButton (called once or on refresh)
local function findDockingButton()
    local dockingRequest = playerGui:WaitForChild("ShipControlGui"):WaitForChild("Menus"):WaitForChild("DockingRequest")
    for _, child in pairs(dockingRequest:GetChildren()) do
        if child:IsA("TextButton") then
            return child
        end
    end
    return nil
end

-- Function to initialize or refresh the docking button
local function initializeDockingButton()
    if not currentDockingButton or not currentDockingButton.Parent then
        currentDockingButton = findDockingButton()
        if currentDockingButton then
            print("Initialized docking button: " .. currentDockingButton:GetFullName())
            print("Current docking button name: " .. currentDockingButton.Name)
        else
            warn("No TextButton found in DockingRequest!")
            print("Listing children for debugging:")
            local dockingRequest = playerGui:WaitForChild("ShipControlGui"):WaitForChild("Menus"):WaitForChild("DockingRequest")
            for _, child in pairs(dockingRequest:GetChildren()) do
                print("Child: " .. child.Name .. " | Class: " .. child.ClassName)
            end
        end
    end
end

-- Function to fire the docking button click signal
local function clickDockingButton()
    if not currentDockingButton then
        initializeDockingButton()
    end
    
    if currentDockingButton and currentDockingButton:IsA("TextButton") then
        firesignal(currentDockingButton.MouseButton1Click)
        print("Fired MouseButton1Click for docking button: " .. currentDockingButton:GetFullName())
    else
        warn("Docking button is invalid! Re-initializing...")
        initializeDockingButton()
        if currentDockingButton then
            firesignal(currentDockingButton.MouseButton1Click)
            print("Fired MouseButton1Click for docking button: " .. currentDockingButton:GetFullName())
        else
            warn("Failed to find a valid docking TextButton after re-initialization!")
        end
    end
end

-- Function to fire a specific button by path (with error handling)
local function fireSpecificButton(path)
    local success, button = pcall(function()
        local expr = path:gsub("game:GetService%(\"Players\"%).LocalPlayer%.PlayerGui", "playerGui")
        return loadstring("return " .. expr)()
    end)
    if success and button and (button:IsA("TextButton") or button:IsA("ImageButton")) then
        firesignal(button.MouseButton1Click)
        print("Fired MouseButton1Click for " .. button:GetFullName())
    else
        warn("Failed to find or fire button at path: " .. path)
        if not success then
            warn("Error: " .. tostring(button))
        elseif button then
            warn("Button class: " .. button.ClassName .. " (not clickable or invalid)")
        end
    end
end

-- Main sequence function
local function executeSequence()
    -- Initial setup for docking button
    initializeDockingButton()

    -- Step 1: Fire docking button immediately
    clickDockingButton()

    -- Step 2: After 5 seconds, fire CargoManager.Button
    task.delay(5, function()
        fireSpecificButton('game:GetService("Players").LocalPlayer.PlayerGui.PortGui.PortMainMenu.MenuButtons.CargoManager.Button')
    end)

    -- Step 3: After another 1 second (total 6 seconds), fire Load
    task.delay(6, function()
        fireSpecificButton('game:GetService("Players").LocalPlayer.PlayerGui.PortGui.BulkMenu.ScrollingFrame.ListItem.Load')
    end)

    -- Step 4: After another 10 seconds (total 16 seconds), fire CargoManager.Button again
    task.delay(16, function()
        fireSpecificButton('game:GetService("Players").LocalPlayer.PlayerGui.PortGui.PortMainMenu.MenuButtons.CargoManager.Button')
    end)
end

-- Run the sequence
executeSequence()
