local p = game:GetService("Players").LocalPlayer
local pg = p:WaitForChild("PlayerGui")

-- Firesignal definition
local firesignal = firesignal or function(signal)
    if getconnections then
        for _, conn in pairs(getconnections(signal)) do
            if conn.Function then pcall(conn.Function) end
        end
    end
end

-- Find and click DockingRequest TextButton
local docking = pg:WaitForChild("ShipControlGui"):WaitForChild("Menus"):WaitForChild("DockingRequest")
for _, child in pairs(docking:GetChildren()) do
    if child:IsA("TextButton") then
        firesignal(child.MouseButton1Click)
        break
    end
end

wait(10)

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


