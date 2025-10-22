local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Updated firesignal definition with fallback
local firesignal = firesignal or function(signal)
    if getconnections then
        local connections = getconnections(signal)
        if connections then
            for _, connection in pairs(connections) do
                if connection and connection.Function then
                    local success, err = pcall(connection.Function)
                    if not success then
                        warn("Failed to call connection.Function: " .. tostring(err))
                    end
                end
            end
            return true
        else
            warn("No connections found for the signal!")
        end
    else
        warn("Executor does not support getconnections/firesignal!")
    end
    return false
end

-- Function to find the TextButton with error handling
local function findButton(parentPath)
    local success, result = pcall(function()
        local parts = parentPath:split(".")
        local current = game
        for _, part in pairs(parts) do
            if part ~= "game" and part ~= "GetService(\"Players\")" and part ~= "LocalPlayer" then
                current = current:WaitForChild(part, 5) -- Wait up to 5 seconds
            end
        end
        for _, child in pairs(current:GetChildren()) do
            if child:IsA("TextButton") or child:IsA("ImageButton") then -- Broaden to ImageButton
                return child
            end
        end
        return nil
    end)
    if not success then
        warn("Error finding button at " .. parentPath .. ": " .. tostring(result))
    end
    return result
end

-- Function to fire the click signal with fallback
local function fireClick(buttonPath, attemptNumber)
    local button = findButton(buttonPath)
    if button then
        print("Found button at " .. button:GetFullName() .. " | Class: " .. button.ClassName)
        local success = firesignal(button.MouseButton1Click)
        if not success then
            -- Fallback to VirtualInputManager
            local x = button.AbsolutePosition.X + button.AbsoluteSize.X / 2
            local y = button.AbsolutePosition.Y + button.AbsoluteSize.Y / 2
            local VirtualInputManager = game:GetService("VirtualInputManager")
            pcall(function()
                VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
                wait(0.1)
                VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
            end)
            print("Falled back to VirtualInputManager click at X = " .. x .. ", Y = " .. y)
        else
            print("Successfully fired MouseButton1Click for " .. button:GetFullName())
        end
    else
        warn("Button not found at " .. buttonPath .. " (Attempt " .. attemptNumber .. ")")
        print("Listing children of parent for debugging:")
        local parent = game
        for part in buttonPath:split(".") do
            if part ~= "game" and part ~= "GetService(\"Players\")" and part ~= "LocalPlayer" then
                parent = parent:FindFirstChild(part)
                if parent then break end
            end
        end
        if parent then
            for _, child in pairs(parent:GetChildren()) do
                print("Child: " .. child.Name .. " | Class: " .. child.ClassName)
            end
        end
    end
end

-- Main sequence function
local function executeSequence()
    -- Step 1: Initialize and fire the first button (ShipControlGui)
    local initialPath = "game:GetService(\"Players\").LocalPlayer.PlayerGui.ShipControlGui.Menus.DockingRequest"
    local currentButton = findButton(initialPath)
    if currentButton and (currentButton:IsA("TextButton") or currentButton:IsA("ImageButton")) then
        print("Initialized button: " .. currentButton:GetFullName())
        print("Current button name: " .. currentButton.Name)
        local success = firesignal(currentButton.MouseButton1Click)
        if not success then
            local x = currentButton.AbsolutePosition.X + currentButton.AbsoluteSize.X / 2
            local y = currentButton.AbsolutePosition.Y + currentButton.AbsoluteSize.Y / 2
            local VirtualInputManager = game:GetService("VirtualInputManager")
            pcall(function()
                VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
                wait(0.1)
                VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
            detailed)
            print("Falled back to VirtualInputManager click at X = " .. x .. ", Y = " .. y)
        else
            print("Fired MouseButton1Click for " .. currentButton:GetFullName())
        end
    else
        warn("Initial button not found at " .. initialPath .. "!")
        print("Listing children for debugging:")
        local parent = game
        for part in initialPath:split(".") do
            if part ~= "game" and part ~= "GetService(\"Players\")" and part ~= "LocalPlayer" then
                parent = parent:FindFirstChild(part)
                if parent then break end
            end
        end
        if parent then
            for _, child in pairs(parent:GetChildren()) do
                print("Child: " .. child.Name .. " | Class: " .. child.ClassName)
            end
        }
        return
    end

    -- Step 2: Fire CargoManager button after 5 seconds
    wait(5)
    fireClick("game:GetService(\"Players\").LocalPlayer.PlayerGui.PortGui.PortMainMenu.MenuButtons.CargoManager.Button", 1)

    -- Step 3: Fire Load button after 1 more second (6 seconds total)
    wait(1)
    fireClick("game:GetService(\"Players\").LocalPlayer.PlayerGui.PortGui.BulkMenu.ScrollingFrame.ListItem.Load", 2)

    -- Step 4: Fire CargoManager button again after 10 more seconds (16 seconds total)
    wait(10)
    fireClick("game:GetService(\"Players\").LocalPlayer.PlayerGui.PortGui.PortMainMenu.MenuButtons.CargoManager.Button", 3)
end

-- Run the sequence
executeSequence()
