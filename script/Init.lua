--== CONFIG INICIAL ==--
getgenv().Settings = {
    ["Auto Click Keybind"] = "V",
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
local TaskWait = task.wait

-- Estados iniciais
local flags = {
    Auto_Clicking = false,
    Mouse_Locked = true, -- lock ativo por padrão
    Mouse_Locked_Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
}

-- Função para converter bind
local getKeycode = function(bind)
    return (pcall(function() return Enum.KeyCode[bind] end) and Enum.KeyCode[bind] or bind)
end

-- Função Drawing
local function Draw(obj, props)
    local NewObj = Drawing.new(obj)
    for i, v in next, props do
        NewObj[i] = v
    end
    return NewObj
end

--== GUI ==--
-- Painel de fundo
local Panel = Draw("Square", {
    Size = Vector2.new(160, 100),
    Color = Color3.fromRGB(50, 50, 50),
    Filled = true,
    Transparency = 0.5,
    Visible = true,
})

-- Texto de status
local Text = Draw("Text", {
    Size = 16,
    Outline = true,
    OutlineColor = Color3.fromRGB(0,0,0),
    Color = Color3.fromRGB(255,255,255),
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
    Position = flags.Mouse_Locked_Position
})

-- Atualiza a GUI de texto
local function UpdateGUI()
    Text.Text = string.format(
        "AutoClick: %s\nMouse Locked: %s\nButton: %s\nDelay: %.2f",
        tostring(flags.Auto_Clicking):upper(),
        tostring(flags.Mouse_Locked):upper(),
        Settings["Right Click"] and "RIGHT" or "LEFT",
        Settings.Delay
    )
end

UpdateGUI()

-- Move painel e texto
local function UpdateGUIPosition()
    Panel.Position = Vector2.new(Camera.ViewportSize.X - Panel.Size.X - 20, 20)
    Text.Position = Panel.Position + Vector2.new(10, 10)
end

UpdateGUIPosition()

--== Arrastar bolinha ==
local dragging = false

UIS.InputBegan:Connect(function(input)
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

--== Keybinds ==--
UIS.InputBegan:Connect(function(input, GPE)
    if not GPE then
        if input.KeyCode == getKeycode(Settings["Auto Click Keybind"]) then
            flags.Auto_Clicking = not flags.Auto_Clicking
        end

        if input.KeyCode == getKeycode(Settings["Switch Button Keybind"]) then
            Settings["Right Click"] = not Settings["Right Click"]
        end

        if input.KeyCode == getKeycode(Settings["Increase Speed Keybind"]) then
            Settings.Delay = math.max(0, Settings.Delay - 0.01)
        end

        if input.KeyCode == getKeycode(Settings["Decrease Speed Keybind"]) then
            Settings.Delay = Settings.Delay + 0.01
        end

        UpdateGUI()
    end
end)

--== Controle GUI interativa ==
UIS.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local mousePos = UIS:GetMouseLocation()
        -- Clicar na GUI para mudar estados
        if mousePos.X >= Panel.Position.X and mousePos.X <= Panel.Position.X + Panel.Size.X and
           mousePos.Y >= Panel.Position.Y and mousePos.Y <= Panel.Position.Y + Panel.Size.Y then
            -- Clique dentro do painel
            local relativeY = mousePos.Y - Panel.Position.Y
            if relativeY < 25 then
                flags.Auto_Clicking = not flags.Auto_Clicking
            elseif relativeY < 50 then
                flags.Mouse_Locked = not flags.Mouse_Locked
            elseif relativeY < 75 then
                Settings["Right Click"] = not Settings["Right Click"]
            else
                -- nada
            end
            UpdateGUI()
        end
    end
end)

--== Loop principal ==
while true do
    Text.Visible = Settings.GUI
    Panel.Visible = Settings.GUI
    MouseDot.Visible = Settings.GUI

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
