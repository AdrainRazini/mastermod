--== CONFIG INICIAL ==--
getgenv().Settings = {
    ["Auto Click Keybind"] = "V",
    ["Lock Mouse Position Keybind"] = "B",
    ["Switch Button Keybind"] = "N",
    ["Increase Speed Keybind"] = "K",
    ["Decrease Speed Keybind"] = "L",
    ["Right Click"] = false,
    ["GUI"] = true,
    ["Delay"] = 0.05
}

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
local function Draw(obj, props)
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

-- Bolinha do mouse
local MouseDot = Draw("Circle", {
    Radius = 10,
    Color = Color3.fromRGB(0, 255, 0),
    Filled = true,
    Transparency = 1,
    Visible = true,
    Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
})

local dragging = false

-- Atualiza GUI de texto
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

--== Função para arrastar bolinha ==
UIS.InputBegan:Connect(function(input, GPE)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local mousePos = UIS:GetMouseLocation()
        local dist = (Vector2.new(mousePos.X, mousePos.Y) - MouseDot.Position).Magnitude
        if dist <= MouseDot.Radius then
            dragging = true
        end
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

RunService.RenderStepped:Connect(function()
    if dragging then
        local mousePos = UIS:GetMouseLocation()
        MouseDot.Position = Vector2.new(mousePos.X, mousePos.Y)
        if flags.Mouse_Locked then
            flags.Mouse_Locked_Position = MouseDot.Position
        end
    end
end)

--== Keybinds ==
UIS.InputBegan:Connect(function(inputObj, GPE)
    if not GPE then
        if inputObj.KeyCode == getKeycode(Settings["Auto Click Keybind"]) then
            flags.Auto_Clicking = not flags.Auto_Clicking
        end

        if inputObj.KeyCode == getKeycode(Settings["Lock Mouse Position Keybind"]) then
            flags.Mouse_Locked_Position = MouseDot.Position
            flags.Mouse_Locked = not flags.Mouse_Locked
        end

        if inputObj.KeyCode == getKeycode(Settings["Switch Button Keybind"]) then
            Settings["Right Click"] = not Settings["Right Click"]
        end

        if inputObj.KeyCode == getKeycode(Settings["Increase Speed Keybind"]) then
            Settings.Delay = math.max(0, Settings.Delay - 0.01)
        end

        if inputObj.KeyCode == getKeycode(Settings["Decrease Speed Keybind"]) then
            Settings.Delay = Settings.Delay + 0.01
        end

        UpdateGUI()
    end
end)

--== Loop principal ==
while true do
    Text.Visible = Settings.GUI
    MouseDot.Visible = Settings.GUI

    Text.Position = Vector2.new(Camera.ViewportSize.X - 180, Camera.ViewportSize.Y - 70)

    if flags.Auto_Clicking then
        for i = 1, 2 do
            local btn = Settings["Right Click"] and 1 or 0
            local pos = flags.Mouse_Locked and flags.Mouse_Locked_Position or UIS:GetMouseLocation()
            VIM:SendMouseButtonEvent(pos.X, pos.Y, btn, i == 1, nil, 0)
        end
    end

    if Settings.Delay <= 0 then
        RunService.RenderStepped:Wait()
    else
        TaskWait(Settings.Delay)
    end
end
