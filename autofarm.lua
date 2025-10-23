local firesignal = firesignal or function(signal)
    if getconnections then
        for _, conn in pairs(getconnections(signal)) do
            if conn.Function then pcall(conn.Function) end
        end
    end
end

local p  = game:GetService("Players").LocalPlayer
local pg = p.PlayerGui

-- 1. DockingRequest – first TextButton in the menu
local docking = pg:WaitForChild("ShipControlGui"):WaitForChild("Menus"):WaitForChild("DockingRequest")
for _, btn in pairs(docking:GetChildren()) do
    if btn:IsA("TextButton") then
        firesignal(btn.MouseButton1Click)
        break
    end
end

wait(15)

-- 2. CargoManager Button
firesignal(playerGui.PortGui.PortMainMenu.MenuButtons.CargoManager.Button.MouseButton1Click)

wait(0.5)

-- 3. Load Button (16th child in ScrollingFrame)
firesignal(playerGui.PortGui.ContainerMenu.ScrollingFrame:GetChildren()[16].Load.MouseButton1Click)

wait(15)

-- 4. Back Button
firesignal(playerGui.PortGui.ContainerMenu.Back.MouseButton1Click)

wait(0.5)

-- 5. Undock Button
firesignal(playerGui.PortGui.PortMainMenu.MenuButtons.Undock.Button.MouseButton1Click)


