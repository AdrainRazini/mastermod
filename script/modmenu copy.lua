local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))

-- Frame principal do menu
local menuFrame = Instance.new("Frame", screenGui)
menuFrame.Size = UDim2.new(0, 300, 0, 400)
menuFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
menuFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
menuFrame.BorderSizePixel = 0

-- Título do menu
local titleLabel = Instance.new("TextLabel", menuFrame)
titleLabel.Size = UDim2.new(1, 0, 0, 50)
titleLabel.Text = "Mod Menu"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 24

-- Botão de minimizar
local minimizeButton = Instance.new("TextButton", menuFrame)
minimizeButton.Size = UDim2.new(0, 50, 0, 50)
minimizeButton.Position = UDim2.new(1, -50, 0, 0)
minimizeButton.Text = "_"
minimizeButton.TextColor3 = Color3.new(1, 1, 1)
minimizeButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
minimizeButton.Font = Enum.Font.SourceSansBold
minimizeButton.TextSize = 20

local isMinimized = false
local buttons = {}

local function minimizeMenu()
    isMinimized = true
    menuFrame.Size = UDim2.new(0, 50, 0, 50)
    menuFrame.Position = UDim2.new(1, -50, 0, 0)

    for _, button in pairs(buttons) do
        button.Visible = false
    end
end

local function expandMenu()
    isMinimized = false
    menuFrame.Size = UDim2.new(0, 300, 0, 400)
    menuFrame.Position = UDim2.new(0.5, -150, 0.5, -200)

    for _, button in pairs(buttons) do
        button.Visible = true
    end
end

minimizeButton.MouseButton1Click:Connect(function()
    if isMinimized then
        expandMenu()
    else
        minimizeMenu()
    end
end)

-- Função para arrastar
local dragging
local dragStart
local startPos

local function updatePosition(input)
    local delta = input.Position - dragStart
    menuFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

menuFrame.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not isMinimized then
        dragging = true
        dragStart = input.Position
        startPos = menuFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updatePosition(input)
    end
end)

-- Função para criar botões no menu
local function createButton(name, position, callback)
    local button = Instance.new("TextButton", menuFrame)
    button.Size = UDim2.new(1, -20, 0, 50)
    button.Position = position
    button.Text = name
    button.TextColor3 = Color3.new(1, 1, 1)
    button.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    button.BorderSizePixel = 0
    button.Font = Enum.Font.SourceSans
    button.TextSize = 20

    local isActive = false

    button.MouseButton1Click:Connect(function()
        isActive = not isActive
        if isActive then
            button.BackgroundColor3 = Color3.new(0, 1, 0) -- Verde quando ativado
            callback() -- Chama a lógica para ativar a função
        else
            button.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3) -- Cor original quando desativado
            -- Lógica para desativar a função (se necessário)
        end
    end)

    -- Adiciona o botão à tabela para controle de visibilidade
    table.insert(buttons, button)
end

-- Exemplo de botões
createButton("Fly", UDim2.new(0, 10, 0, 60), function()
    local player = game.Players.LocalPlayer
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")

local flying = false
local speed = 50 -- Velocidade de voo
local bodyGyro, bodyVelocity

local function toggleFly()
    if flying then
        flying = false
        if bodyGyro then bodyGyro:Destroy() end
        if bodyVelocity then bodyVelocity:Destroy() end
    else
        flying = true
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

        bodyGyro = Instance.new("BodyGyro", humanoidRootPart)
        bodyVelocity = Instance.new("BodyVelocity", humanoidRootPart)

        bodyGyro.MaxTorque = Vector3.new(4000, 4000, 4000)
        bodyGyro.P = 3000
        bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)

        runService.Heartbeat:Connect(function()
            if flying then
                local cameraCFrame = workspace.CurrentCamera.CFrame
                bodyGyro.CFrame = CFrame.new(humanoidRootPart.Position, cameraCFrame.Position)

                -- Movimentação para frente, para cima e para baixo
                bodyVelocity.Velocity = (cameraCFrame.LookVector * speed) + Vector3.new(0, 0, 0)
            end
        end)
    end
end

-- Detecta o pulo do jogador
userInputService.JumpRequest:Connect(function()
    if not flying then
        toggleFly()
    end
end)

-- Detecta o toque no chão
local function onTouchGround(hit)
    if hit:IsA("BasePart") and hit.Parent:FindFirstChild("Humanoid") then
        if flying then
            toggleFly()
        end
    end
end

-- Adiciona controle de subida e descida
userInputService.InputBegan:Connect(function(input)
    if flying then
        if input.UserInputType == Enum.UserInputType.Keyboard then
            if input.KeyCode == Enum.KeyCode.Space then
                bodyVelocity.Velocity = bodyVelocity.Velocity + Vector3.new(0, speed, 0) -- Subir
            elseif input.KeyCode == Enum.KeyCode.LeftShift then
                bodyVelocity.Velocity = bodyVelocity.Velocity - Vector3.new(0, speed, 0) -- Descer
            end
        end
    end
end)

local character = player.Character or player.CharacterAdded:Wait()
character.HumanoidRootPart.Touched:Connect(onTouchGround)

-- Adicione um botão ao seu menu para ativar o voo
createButton("Fly", UDim2.new(0, 10, 0, 60), toggleFly)

end)

createButton("Speed Boost", UDim2.new(0, 10, 0, 120), function()
    -- Script para Aumentar a Velocidade do Jogador

local player = game.Players.LocalPlayer

-- Função para definir a velocidade
function setSpeed(speed)
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")

    humanoid.WalkSpeed = speed
end

-- Aumenta a velocidade para 50 (padrão é 16)
setSpeed(50)

-- Para redefinir a velocidade para o padrão, use:
-- setSpeed(16)

end)

createButton("Teleport", UDim2.new(0, 10, 0, 180), function()
    -- Lógica para teleportar
end)

createButton("Invincible", UDim2.new(0, 10, 0, 240), function()
    -- Lógica para invencibilidade
end)

createButton("High Jump", UDim2.new(0, 10, 0, 300), function()
    -- Lógica para pulo alto
end)

createButton("Reset", UDim2.new(0, 10, 0, 360), function()
    -- Lógica para resetar status
end)