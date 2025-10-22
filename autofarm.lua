local firesignal = firesignal or function(signal)
    if getconnections then
        for _, conn in pairs(getconnections(signal)) do
            if conn.Function then pcall(conn.Function) end
        end
    end
end

local p = game:GetService("Players").LocalPlayer
local pg = p.PlayerGui

-- 1. CargoManager Button
firesignal(pg.PortGui.PortMainMenu.MenuButtons.CargoManager.Button.MouseButton1Click)

wait(0.5)

-- 2. Load Button (16th child in ScrollingFrame)
firesignal(pg.PortGui.ContainerMenu.ScrollingFrame:GetChildren()[16].Load.MouseButton1Click)

wait(3)

-- 3. Back Button
firesignal(pg.PortGui.ContainerMenu.Back.MouseButton1Click)

wait(0.5)

-- 4. Undock Button
firesignal(pg.PortGui.PortMainMenu.MenuButtons.Undock.Button.MouseButton1Click)
