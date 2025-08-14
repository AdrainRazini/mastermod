-- Criação da GUI
local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui", player.PlayerGui)

-- Criando a Frame de Controle
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 200, 0, 130)
frame.Position = UDim2.new(1, -220, 0, 120)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.Active = true
frame.Draggable = true

-- Criando o título da Frame
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 20)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "Controle de Dash"
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true

-- Criando o botão de minimizar
local minimizeButton = Instance.new("TextButton", frame)
minimizeButton.Size = UDim2.new(0, 20, 0, 20)
minimizeButton.Position = UDim2.new(1, -20, 0, 0)
minimizeButton.Text = "-"
minimizeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Criando um Slider para controle de velocidade
local slider = Instance.new("TextBox", frame)
slider.Size = UDim2.new(0, 180, 0, 30)
slider.Position = UDim2.new(0, 10, 0, 30)
slider.Text = "80" -- Velocidade inicial
slider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
slider.TextColor3 = Color3.fromRGB(0, 0, 0)

-- Criando o botão Dash dentro da frame
local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(0, 180, 0, 30)
button.Position = UDim2.new(0, 10, 0, 70)
button.Text = "Dash"
button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)

local minimized = false

-- Função para minimizar/maximizar a frame
local function toggleMinimize()
    minimized = not minimized
    if minimized then
        for _, child in pairs(frame:GetChildren()) do
            if child ~= title and child ~= minimizeButton then
                child.Visible = false
            end
        end
        frame.Size = UDim2.new(0, 200, 0, 20)
    else
        for _, child in pairs(frame:GetChildren()) do
            child.Visible = true
        end
        frame.Size = UDim2.new(0, 200, 0, 130)
    end
end
minimizeButton.MouseButton1Click:Connect(toggleMinimize)

local running = false

-- Função de impulso
local function startDash()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local dashSpeed = tonumber(slider.Text) or 80 -- Pega a velocidade do slider

    running = true
    while running do
        -- Direção da câmera
        local camera = workspace.CurrentCamera
        local direction = camera.CFrame.LookVector
        
        -- Aplicar velocidade constantemente
        humanoidRootPart.Velocity = direction * dashSpeed
        wait(0.1) -- Pequeno intervalo para manter a fluidez
    end
end

local function stopDash()
    running = false
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart then
        humanoidRootPart.Velocity = Vector3.new(0, 0, 0) -- Para parar o impulso
    end
end

-- Conectar eventos do botão
button.MouseButton1Down:Connect(startDash)
button.MouseButton1Up:Connect(stopDash)
