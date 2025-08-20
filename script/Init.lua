--== CONFIG INICIAL ==--
local Settings = {
    ["Right Click"] = false,
    ["Delay"] = 0.05, -- 0 = ultra rápido (RenderStepped)
}

--== SCRIPT ==--
if getgenv()["AlreadyRunning"] then return else getgenv()["AlreadyRunning"] = true end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Flags do AutoClicker
local flags = {AutoClicking = false}

--== GUI ==
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoClickerGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 140)
Frame.Position = UDim2.new(1, -210, 1, -150)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BackgroundTransparency = 0.4
Frame.Parent = ScreenGui

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -10, 0, 60)
StatusLabel.Position = UDim2.new(0, 5, 0, 5)
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextColor3 = Color3.new(1,1,1)
StatusLabel.TextScaled = true
StatusLabel.TextWrapped = true
StatusLabel.Parent = Frame

local function UpdateStatus()
    StatusLabel.Text = string.format(
        "AutoClicking: %s\nButton: %s\nDelay: %.2f",
        flags.AutoClicking and "ON" or "OFF",
        Settings["Right Click"] and "RIGHT" or "LEFT",
        Settings.Delay
    )
end

UpdateStatus()

--== Botões de controle ==
local function CreateButton(text, pos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 90, 0, 30)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Text = text
    btn.Parent = Frame
    btn.MouseButton1Click:Connect(callback)
end

-- Toggle AutoClick
CreateButton("Toggle", UDim2.new(0, 5, 0, 70), function()
    flags.AutoClicking = not flags.AutoClicking
    UpdateStatus()
end)

-- Switch Button
CreateButton("Switch Btn", UDim2.new(0, 105, 0, 70), function()
    Settings["Right Click"] = not Settings["Right Click"]
    UpdateStatus()
end)

-- Increase Speed
CreateButton("Faster", UDim2.new(0, 5, 0, 105), function()
    Settings.Delay = math.max(0, Settings.Delay - 0.01)
    UpdateStatus()
end)

-- Decrease Speed
CreateButton("Slower", UDim2.new(0, 105, 0, 105), function()
    Settings.Delay = Settings.Delay + 0.01
    UpdateStatus()
end)

--== Loop principal (simulação de clique) ==
RunService.RenderStepped:Connect(function()
    if flags.AutoClicking then
        -- Aqui você dispara a ação desejada
        -- Exemplo: tocar em um Part clicável (substitua por sua lógica)
        local Mouse = LocalPlayer:GetMouse()
        local target = Mouse.Target
        if target then
            -- Simula clique
            if Settings["Right Click"] then
                target:FireServer("RightClick") -- ajuste conforme seu jogo
            else
                target:FireServer("LeftClick")  -- ajuste conforme seu jogo
            end
        end
    end
end)
