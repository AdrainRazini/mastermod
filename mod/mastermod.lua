local player = game.Players.LocalPlayer
local userInputService = game:GetService("UserInputService")

-- Criação da interface gráfica
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")  -- Adiciona o ScreenGui ao PlayerGui
screenGui.Enabled = true  -- Garantir que o ScreenGui esteja visível

-- Criação do menu
local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, 300, 0, 400)  -- Tamanho do menu
menuFrame.Position = UDim2.new(0.5, -150, 0.5, -200)  -- Posição do menu no centro da tela
menuFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)  -- Cor de fundo
menuFrame.Parent = screenGui

-- Título do menu
local titleFrame = Instance.new("Frame")
titleFrame.Size = UDim2.new(1, 0, 0, 50)
titleFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
titleFrame.Parent = menuFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0.9, 0, 1, 0)
titleLabel.Text = "MASTERMOD"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 24
titleLabel.BackgroundTransparency = 1  -- Sem fundo
titleLabel.Parent = titleFrame

-- Botão de minimizar/restaurar
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0.1, 0, 1, 0)
minimizeButton.Position = UDim2.new(0.9, 0, 0, 0)
minimizeButton.Text = "⬜"
minimizeButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
minimizeButton.BorderSizePixel = 0
minimizeButton.Font = Enum.Font.SourceSans
minimizeButton.TextSize = 20
minimizeButton.Parent = titleFrame

-- Criar um ScrollingFrame para os botões
local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, 0, 1, -60)  -- Ajusta para abaixo do título
scrollingFrame.Position = UDim2.new(0, 0, 0, 50)
scrollingFrame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
scrollingFrame.ScrollBarThickness = 10
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)  -- Inicialize o CanvasSize com zero
scrollingFrame.Parent = menuFrame

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Padding = UDim.new(0, 10)
uiListLayout.Parent = scrollingFrame

local dragging, dragStart, startPos

local function updatePosition(input)
    local delta = input.Position - dragStart
    menuFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

menuFrame.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
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

userInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updatePosition(input)
    end
end)

-- Função para criar botões no menu
local function createButton(name, activateCallback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 50)
    button.Text = name
    button.TextColor3 = Color3.new(1, 1, 1)
    button.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    button.BorderSizePixel = 0
    button.Font = Enum.Font.SourceSans
    button.TextSize = 20
    button.Parent = scrollingFrame

    button.MouseButton1Click:Connect(function()
        activateCallback()
        button.BackgroundColor3 = Color3.new(0.5, 1, 0.5)
        wait(0.5)
        button.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    end)

    -- Atualiza o CanvasSize para garantir rolagem
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, scrollingFrame.UIListLayout.AbsoluteContentSize.Y)
end

-- Criando alguns botões de exemplo
createButton("INVENTÁRIO", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AdrainRazini/mastermod/refs/heads/main/inventario.lua"))()
end)

createButton("Clone item", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AdrainRazini/mastermod/refs/heads/main/CloneItem"))()
end)

createButton("DELETAR", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AdrainRazini/mastermod/refs/heads/main/Deletar"))()
end)

createButton("Ativar guis", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AdrainRazini/mastermod/refs/heads/main/Ativargui"))()
end)

createButton("AUTO FARME MOEDAS", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AdrainRazini/mastermod/refs/heads/main/Moedasfarme"))()
end)
createButton("AUTO FARME PRESENTES", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AdrainRazini/mastermod/refs/heads/main/Farmegift"))()
end)

createButton("Lock Camera", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AdrainRazini/mastermod/refs/heads/main/Lockcamera"))()
end)

createButton("Lock Air", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AdrainRazini/mastermod/refs/heads/main/Parar"))()
end)

createButton("Coordenadas", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AdrainRazini/mastermod/refs/heads/main/Local"))()
end)

createButton("Tp coordenadas", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AdrainRazini/mastermod/refs/heads/main/Tpcordenadas"))()
end)

createButton("Hitboxtool", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AdrainRazini/mastermod/refs/heads/main/Hitboxtool"))()
end)

createButton("Hitboxtoolv2", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AdrainRazini/mastermod/refs/heads/main/Hitbooxv2"))()
end)

createButton("Block air tool", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AdrainRazini/mastermod/refs/heads/main/Blockar"))()
end)

createButton("Dash", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AdrainRazini/mastermod/refs/heads/main/flytoov2"))()
end)

createButton("Fly tool", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AdrainRazini/mastermod/refs/heads/main/flytool.lua"))()
end)

createButton("Jump tool", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AdrainRazini/mastermod/refs/heads/main/jumptool.lua"))()
end)

createButton("Aimbot all", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AdrainRazini/mastermod/refs/heads/main/Aimbotall"))()
end)

createButton("Aimbot team", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AdrainRazini/mastermod/refs/heads/main/Aimbotteam"))()
end)

createButton("Speed Boost tool", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AdrainRazini/mastermod/refs/heads/main/speedtool.lua"))()
end)
createButton("Teleport tool", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AdrainRazini/mastermod/refs/heads/main/teleporttool.lua"))()
end)

createButton("Tp Players", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AdrainRazini/mastermod/refs/heads/main/TPPLAYERS"))()
end)

createButton("TpV2", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AdrainRazini/mastermod/refs/heads/main/Tptoolv2"))()
end)

createButton("Tpv3", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AdrainRazini/mastermod/refs/heads/main/Tpv3"))()
end)

createButton("Visor Objetos", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AdrainRazini/mastermod/refs/heads/main/Visorname"))()
end)

createButton("Ultra Visor", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AdrainRazini/mastermod/refs/heads/main/ULTRAVISOR"))()
end)

createButton("Linhas", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AdrainRazini/mastermod/refs/heads/main/Linhas"))()
end)

createButton("Auto", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AdrainRazini/mastermod/refs/heads/main/Automovimento"))()
end)

createButton("EM BREVE", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AdrainRazini/mastermod/refs/heads/main/EMBREVE"))()
end)




-- Função para alternar entre minimizar e restaurar o menu
local function toggleMenu()
    if menuFrame.Size.Y.Offset > 60 then
        menuFrame.Size = UDim2.new(0, 150, 0, 60) -- Minimiza
        scrollingFrame.Visible = false -- Oculta o ScrollingFrame
        minimizeButton.Text = "🟥" -- Muda o ícone
    else
        menuFrame.Size = UDim2.new(0, 300, 0, 400) -- Restaura
        scrollingFrame.Visible = true -- Mostra o ScrollingFrame
         minimizeButton.Text = "🟩" -- Muda o ícone
    end
end

-- Chama a função de minimizar/restaurar ao clicar no botão
minimizeButton.MouseButton1Click:Connect(toggleMenu)

-- Alternar visibilidade com a tecla 'M'
userInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if not gameProcessedEvent and input.KeyCode == Enum.KeyCode.M then
        toggleMenu() -- Chama a função diretamente
    end
end)
