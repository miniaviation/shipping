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

-- Variable to store the found button
local currentButton = nil

-- Function to find the TextButton
local function findButton()
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

-- Function to initialize or refresh the button
local function initializeButton()
    if not currentButton or not currentButton.Parent then
        currentButton = findButton()
        if currentButton then
            print("Initialized button: " .. currentButton:GetFullName())
            print("Current button name: " .. currentButton.Name)
        else
            warn("No TextButton named 'Load' found in ScrollingFrame!")
            -- Debug: List all TextButtons in ScrollingFrame
            local scrollingFrame = playerGui:FindFirstChild("PortGui") and 
                                  playerGui.PortGui.ContainerMenu:FindFirstChild("ScrollingFrame")
            if scrollingFrame then
                print("Listing children for debugging:")
                for i, child in ipairs(scrollingFrame:GetChildren()) do
                    if child:IsA("TextButton") then
                        print("Child " .. i .. ": TextButton named " .. child.Name)
                    elseif child:IsA("Frame") then
                        local loadButton = child:FindFirstChild("Load")
                        if loadButton and loadButton:IsA("TextButton") then
                            print("Child " .. i .. ": Frame contains TextButton named " .. loadButton.Name)
                        end
                    end
                end
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
            warn("Failed to find a valid TextButton named 'Load' after re-initialization!")
        end
    end
end

-- Initial setup
initializeButton()

-- Click the button
clickButton()
