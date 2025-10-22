local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

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

-- Function to find the TextButton
local function findButton()
    local globalReplicated = ReplicatedStorage:FindFirstChild("GlobalReplicated")
    if globalReplicated then
        local storage = globalReplicated:FindFirstChild("Storage")
        if storage then
            local guis = storage:FindFirstChild("Guis")
            if guis then
                local portGui = guis:FindFirstChild("PortGui")
                if portGui then
                    local portMainMenu = portGui:FindFirstChild("PortMainMenu")
                    if portMainMenu then
                        local menuButtons = portMainMenu:FindFirstChild("MenuButtons")
                        if menuButtons then
                            local cargoManager = menuButtons:FindFirstChild("CargoManager")
                            if cargoManager then
                                local button = cargoManager:FindFirstChild("Button")
                                if button and button:IsA("TextButton") then
                                    return button
                                else
                                    warn("No TextButton named 'Button' found in CargoManager")
                                    -- Debug: List all TextButtons in CargoManager
                                    print("Listing children of CargoManager for debugging:")
                                    for _, child in ipairs(cargoManager:GetChildren()) do
                                        if child:IsA("TextButton") then
                                            print("Child: TextButton named " .. child.Name)
                                        end
                                    end
                                end
                            else
                                warn("CargoManager not found in MenuButtons")
                            end
                        else
                            warn("MenuButtons not found in PortMainMenu")
                        end
                    else
                        warn("PortMainMenu not found in PortGui")
                    end
                else
                    warn("PortGui not found in Guis")
                end
            else
                warn("Guis not found in Storage")
            end
        else
            warn("Storage not found in GlobalReplicated")
        end
    else
        warn("GlobalReplicated not found in ReplicatedStorage")
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
            warn("No TextButton found in CargoManager!")
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

-- Click the button
clickButton()
