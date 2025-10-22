local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Updated firesignal definition (from your script)
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

-- Variables to store the buttons
local cargoButton = nil
local loadButton = nil

-- Function to find the CargoManager Button
local function findCargoButton()
    local cargoManager = playerGui:FindFirstChild("PortGui") and 
                         playerGui.PortGui:FindFirstChild("PortMainMenu") and 
                         playerGui.PortGui.PortMainMenu:FindFirstChild("MenuButtons") and 
                         playerGui.PortGui.PortMainMenu.MenuButtons:FindFirstChild("CargoManager")
    
    if cargoManager then
        local button = cargoManager:FindFirstChild("Button")
        if button and button:IsA("TextButton") then
            return button
        else
            warn("No TextButton named 'Button' found in CargoManager")
        end
    else
        warn("CargoManager not found at path: PlayerGui.PortGui.PortMainMenu.MenuButtons.CargoManager")
    end
    return nil
end

-- Function to find the Load Button
local function findLoadButton()
    local scrollingFrame = playerGui:FindFirstChild("PortGui") and 
                          playerGui.PortGui:FindFirstChild("ContainerMenu") and 
                          playerGui.PortGui.ContainerMenu:FindFirstChild("ScrollingFrame")
    
    if scrollingFrame and scrollingFrame:IsA("ScrollingFrame") then
        local children = scrollingFrame:GetChildren()
        
        -- Check if the 16th child exists
        if children[16] then
            local target = children[16]
            
            -- Case 1: 16th child is the TextButton named "Load"
            if target:IsA("TextButton") and target.Name == "Load" then
                return target
            -- Case 2: 16th child is a Frame containing the "Load" TextButton
            elseif target:IsA("Frame") then
                local loadButton = target:FindFirstChild("Load")
                if loadButton and loadButton:IsA("TextButton") then
                    return loadButton
                end
            end
            warn("16th child is not a TextButton named 'Load' or a Frame containing it. Class: " .. target.ClassName)
        else
            warn("No 16th child found in ScrollingFrame (only " .. #children .. " children exist)")
        end
    else
        warn("ScrollingFrame not found at path: PlayerGui.PortGui.ContainerMenu.ScrollingFrame")
    end
    return nil
end

-- Function to initialize or refresh the buttons
local function initializeButtons()
    -- Initialize Cargo Button
    if not cargoButton or not cargoButton.Parent then
        cargoButton = findCargoButton()
        if cargoButton then
            print("Initialized Cargo Button: " .. cargoButton:GetFullName())
        else
            warn("Failed to initialize Cargo Button!")
        end
    end
    
    -- Initialize Load Button
    if not loadButton or not loadButton.Parent then
        loadButton = findLoadButton()
        if loadButton then
            print("Initialized Load Button: " .. loadButton:GetFullName())
        else
            warn("Failed to initialize Load Button!")
            -- Debug: List all TextButtons in ScrollingFrame
            local scrollingFrame = playerGui:FindFirstChild("PortGui") and 
                                  playerGui.PortGui.ContainerMenu:FindFirstChild("ScrollingFrame")
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
    end
end

-- Function to click both buttons in sequence
local function clickButtons()
    initializeButtons()
    
    -- Click Cargo Button first
    if cargoButton and cargoButton:IsA("TextButton") then
        firesignal(cargoButton.MouseButton1Click)
        print("Fired MouseButton1Click for " .. cargoButton:GetFullName())
    else
        warn("Cargo Button is invalid! Re-initializing...")
        cargoButton = findCargoButton()
        if cargoButton then
            firesignal(cargoButton.MouseButton1Click)
            print("Fired MouseButton1Click for " .. cargoButton:GetFullName())
        else
            warn("Failed to find a valid TextButton at CargoManager.Button!")
        end
    end
    
    -- Wait briefly to ensure the first click processes
    wait(0.5)
    
    -- Click Load Button second
    if loadButton and loadButton:IsA("TextButton") then
        firesignal(loadButton.MouseButton1Click)
        print("Fired MouseButton1Click for " .. loadButton:GetFullName())
    else
        warn("Load Button is invalid! Re-initializing...")
        loadButton = findLoadButton()
        if loadButton then
            firesignal(loadButton.MouseButton1Click)
            print("Fired MouseButton1Click for " .. loadButton:GetFullName())
        else
            warn("Failed to find a valid TextButton named 'Load'!")
        end
    end
end

-- Initial setup and click
clickButtons()
