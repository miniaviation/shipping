local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Firesignal definition
local firesignal = firesignal or function(signal)
    if getconnections then
        local connections = getconnections(signal)
        if connections then
            for _, connection in pairs(connections) do
                if connection and connection.Function then
                    pcall(connection.Function)
                end
            end
        end
    end
end

-- Click CargoManager Button
firesignal(playerGui.PortGui.PortMainMenu.MenuButtons.CargoManager.Button.MouseButton1Click)
wait(0.5)

-- Click Load Button
firesignal(playerGui.PortGui.ContainerMenu.ScrollingFrame:GetChildren()[16].Load.MouseButton1Click)
wait(0.5)

-- Click Back Button
firesignal(playerGui.PortGui.ContainerMenu.Back.MouseButton1Click)
wait(0.5)

-- Click Undock Button
firesignal(playerGui.PortGui.PortMainMenu.MenuButtons.Undock.Button.MouseButton1Click)
