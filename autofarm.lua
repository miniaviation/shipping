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

-- Function to find the TextButton in DockingRequest
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

-- Function to fire the click signal for the docking button
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

-- Function to handle the sequence of button clicks
local function executeButtonSequence()
    -- Step 1: Click the docking button
    clickButton()
    
    -- Step 2: Wait 5 seconds and click CargoManager.Button
    task.wait(10)
    local cargoButton1 = playerGui:WaitForChild("PortGui"):WaitForChild("PortMainMenu"):WaitForChild("MenuButtons"):WaitForChild("CargoManager"):WaitForChild("Button")
    if cargoButton1 and cargoButton1:IsA("TextButton") then
        firesignal(cargoButton1.MouseButton1Click)
        print("Fired MouseButton1Click for " .. cargoButton1:GetFullName())
    else
        warn("CargoManager.Button not found or not a TextButton!")
    end
    
    -- Step 3: Wait 1 second and click ListItem.Load
    task.wait(1)
    local loadButton = playerGui:WaitForChild("PortGui"):WaitForChild("BulkMenu"):WaitForChild("ScrollingFrame"):WaitForChild("ListItem"):WaitForChild("Load")
    if loadButton and loadButton:IsA("TextButton") then
        firesignal(loadButton.MouseButton1Click)
        print("Fired MouseButton1Click for " .. loadButton:GetFullName())
    else
        warn("ListItem.Load not found or not a TextButton!")
    end
    
    -- Step 4: Wait 10 seconds and click CargoManager.Button again
    task.wait(10)
    local cargoButton2 = playerGui:WaitForChild("PortGui"):WaitForChild("PortMainMenu"):WaitForChild("MenuButtons"):WaitForChild("CargoManager"):WaitForChild("Button")
    if cargoButton2 and cargoButton2:IsA("TextButton") then
        firesignal(cargoButton2.MouseButton1Click)
        print("Fired MouseButton1Click for " .. cargoButton2:GetFullName())
    else
        warn("CargoManager.Button (second click) not found or not a TextButton!")
    end
end

-- Initial setup
initializeButton()

-- Execute the sequence
executeButtonSequence()

