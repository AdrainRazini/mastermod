local player = game.Players.LocalPlayer
local userInputService = game:GetService("UserInputService")

-- Criação da interface gráfica
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local menuFrame = Instance.new("Frame", screenGui)
menuFrame.Size = UDim2.new(0, 300, 0, 400)
menuFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
menuFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
menuFrame.BorderSizePixel = 0
menuFrame.Visible = true

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

-- Variáveis para controle do menu
local isMinimized = false
local currentPage = 1
local buttonsPerPage = 4
local buttons = {}

-- Função para minimizar o menu
local function minimizeMenu()
    isMinimized = true
    menuFrame.Size = UDim2.new(0, 50, 0, 50)
    menuFrame.Position = UDim2.new(1, -50, 0, 0)
    for _, button in pairs(buttons) do
        button.Visible = false
    end
end

-- Função para expandir o menu
local function expandMenu()
    isMinimized = false
    menuFrame.Size = UDim2.new(0, 300, 0, 400)
    menuFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
    for _, button in pairs(buttons) do
        button.Visible = true
    end
    updateButtonVisibility() -- Atualiza a visibilidade dos botões ao expandir
end

minimizeButton.MouseButton1Click:Connect(function()
    if isMinimized then
        expandMenu()
    else
        minimizeMenu()
    end
end)

-- Função para arrastar o menu
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

userInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updatePosition(input)
    end
end)

-- Layout para os botões
local uiListLayout = Instance.new("UIListLayout", menuFrame)
uiListLayout.Padding = UDim.new(0, 10) -- Espaçamento entre os botões

-- Função para criar botões no menu
local function createButton(name, activateCallback)
    local button = Instance.new("TextButton", menuFrame)
    button.Size = UDim2.new(1, -20, 0, 50)
    button.Text = name
    button.TextColor3 = Color3.new(1, 1, 1)
    button.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    button.BorderSizePixel = 0
    button.Font = Enum.Font.SourceSans
    button.TextSize = 20

    button.MouseButton1Click:Connect(function()
        activateCallback() -- Chama a lógica para ativar a função
        button.BackgroundColor3 = Color3.new(0.5, 1, 0.5) -- Muda a cor do botão quando clicado
        wait(0.5)
        button.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3) -- Retorna à cor original
    end)

    -- Adiciona o botão à tabela para controle de visibilidade
    table.insert(buttons, button)
end
createButton("INVENTÁRIO", function()
    loadstring(game:HttpGet(""))()
end)
-- Funções de ativação para os botões
createButton("Fly tool", function()
    loadstring(game:HttpGet(""))()
end)

createButton("Speed Boost tool", function()
    loadstring(game:HttpGet(""))()
end)

createButton("Teleport tool", function()
    loadstring(game:HttpGet(""))()
end)

createButton("Jump tool", function()
    loadstring(game:HttpGet(""))()
end)

createButton("EM BREVE", function()
    loadstring(game:HttpGet(""))()
end)

createButton("EM BREVE", function()
    loadstring(game:HttpGet(""))()
end)

createButton("EM BREVE", function()
    loadstring(game:HttpGet(""))()
end)


-- Função para controlar páginas
local function updateButtonVisibility()
    local totalButtons = #buttons
    local startIndex = (currentPage - 1) * buttonsPerPage + 1
    local endIndex = math.min(startIndex + buttonsPerPage - 1, totalButtons)

    for i, button in ipairs(buttons) do
        button.Visible = (i >= startIndex and i <= endIndex)
    end

    -- Atualiza a visibilidade dos botões de navegação
    prevButton.Visible = currentPage > 1
    nextButton.Visible = currentPage < math.ceil(totalButtons / buttonsPerPage)
end

-- Botões de navegação
local prevButton = Instance.new("TextButton", menuFrame)
prevButton.Size = UDim2.new(0.5, -10, 0, 50)
prevButton.Position = UDim2.new(0, 0, 1, -60)
prevButton.Text = "Anterior"
prevButton.TextColor3 = Color3.new(1, 1, 1)
prevButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
prevButton.Font = Enum.Font.SourceSans
prevButton.TextSize = 20

local nextButton = Instance.new("TextButton", menuFrame)
nextButton.Size = UDim2.new(0.5, -10, 0, 50)
nextButton.Position = UDim2.new(0.5, 10, 1, -60)
nextButton.Text = "Próximo"
nextButton.TextColor3 = Color3.new(1, 1, 1)
nextButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
nextButton.Font = Enum.Font.SourceSans
nextButton.TextSize = 20

prevButton.MouseButton1Click:Connect(function()
    if currentPage > 1 then
        currentPage = currentPage - 1
        updateButtonVisibility()
    end
end)

nextButton.MouseButton1Click:Connect(function()
    if currentPage < math.ceil(#buttons / buttonsPerPage) then
        currentPage = currentPage + 1
        updateButtonVisibility()
    end
end)

updateButtonVisibility() -- Chama a função na inicialização

-- Manipulação de eventos para atualizar a visibilidade ao adicionar ou remover botões
for _, button in pairs(buttons) do
    button.Changed:Connect(function()
        updateButtonVisibility()
    end)
end