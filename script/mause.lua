--[[
getgenv().Settings = {
    ["Auto Click Keybind"] = "V", -- Use an UpperCase letter or KeyCode Enum. Ex: Enum.KeyCode.Semicolon
    ["Lock Mouse Position Keybind"] = "B",
    ["Right Click"] = false,
    ["GUI"] = true, -- A drawing gui that tells you what is going on with the autoclicker.
    ["Delay"] = 0 -- 0 for RenderStepped, other numbers go to regular wait timings.
}
loadstring(game:HttpGet("https://raw.githubusercontent.com/BimbusCoder/Script/main/Auto%20Clicker.lua"))()
]]



--== CONFIG INICIAL ==--
getgenv().Settings = {
    ["Auto Click Keybind"] = "V", -- liga/desliga
    ["Lock Mouse Position Keybind"] = "B", -- trava posição do mouse
    ["Switch Button Keybind"] = "N", -- troca entre esquerdo/direito
    ["Increase Speed Keybind"] = "K", -- diminui o delay (mais rápido)
    ["Decrease Speed Keybind"] = "L", -- aumenta o delay (mais lento)
    ["Right Click"] = false,
    ["GUI"] = true,
    ["Delay"] = 0.05 -- 0 = ultra rápido (RenderStepped)
}

--== SCRIPT ==--
if getgenv()["Already Running"] then return else getgenv()["Already Running"] = true end

local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local flags = {Auto_Clicking = false, Mouse_Locked = false}
local TaskWait = task.wait

-- converter bind
local getKeycode = function(bind)
    return (pcall(function() return Enum.KeyCode[bind] end) and Enum.KeyCode[bind] or bind)
end

-- função Drawing
local Draw = function(obj, props)
    local NewObj = Drawing.new(obj)
    for i, v in next, props do
        NewObj[i] = v
    end
    return NewObj
end

-- GUI de status
local Text = Draw("Text", {
    Size = 18,
    Outline = true,
    OutlineColor = Color3.fromRGB(255, 255, 255),
    Color = Color3.fromRGB(0, 0, 0),
    Text = "",
    Visible = true,
})

local function UpdateGUI()
    Text.Text = string.format(
        "Auto Clicking : %s\nMouse Locked : %s\nButton : %s\nDelay : %.2f",
        tostring(flags.Auto_Clicking):upper(),
        tostring(flags.Mouse_Locked):upper(),
        Settings["Right Click"] and "RIGHT" or "LEFT",
        Settings.Delay
    )
end

UpdateGUI()

--== Keybinds ==--
UIS.InputBegan:Connect(function(inputObj, GPE)
    if (not GPE) then
        -- Toggle AutoClick
        if (inputObj.KeyCode == getKeycode(Settings["Auto Click Keybind"])) then
            flags.Auto_Clicking = not flags.Auto_Clicking
        end

        -- Lock mouse
        if (inputObj.KeyCode == getKeycode(Settings["Lock Mouse Position Keybind"])) then
            local Mouse = UIS:GetMouseLocation()
            flags.Mouse_Locked_Position = Vector2.new(Mouse.X, Mouse.Y)
            flags.Mouse_Locked = not flags.Mouse_Locked
        end

        -- Switch button (Left/Right)
        if (inputObj.KeyCode == getKeycode(Settings["Switch Button Keybind"])) then
            Settings["Right Click"] = not Settings["Right Click"]
        end

        -- Increase speed (menos delay)
        if (inputObj.KeyCode == getKeycode(Settings["Increase Speed Keybind"])) then
            Settings.Delay = math.max(0, Settings.Delay - 0.01)
        end

        -- Decrease speed (mais delay)
        if (inputObj.KeyCode == getKeycode(Settings["Decrease Speed Keybind"])) then
            Settings.Delay = Settings.Delay + 0.01
        end

        UpdateGUI()
    end
end)

--== Loop principal ==--
while true do
    Text.Visible = Settings.GUI
    Text.Position = Vector2.new(Camera.ViewportSize.X - 180, Camera.ViewportSize.Y - 70)

    if (flags.Auto_Clicking) then
        for i = 1, 2 do
            local btn = Settings["Right Click"] and 1 or 0
            if (flags.Mouse_Locked) then
                VIM:SendMouseButtonEvent(flags.Mouse_Locked_Position.X, flags.Mouse_Locked_Position.Y, btn, i == 1, nil, 0)
            else
                local Mouse = UIS:GetMouseLocation()
                VIM:SendMouseButtonEvent(Mouse.X, Mouse.Y, btn, i == 1, nil, 0)
            end
        end
    end

    if (Settings.Delay <= 0) then
        RunService.RenderStepped:Wait()
    else
        TaskWait(Settings.Delay)
    end
end
