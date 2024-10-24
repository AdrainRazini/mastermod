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

-- Criar um ScrollingFrame
local scrollingFrame = Instance.new("ScrollingFrame", menuFrame)
scrollingFrame.Size = UDim2.new(1, 0, 1, -60)
scrollingFrame.Position = UDim2.new(0, 0, 0, 50)
scrollingFrame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
scrollingFrame.BorderSizePixel = 0
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingFrame.ScrollBarThickness = 10

local uiListLayout = Instance.new("UIListLayout", scrollingFrame)
uiListLayout.Padding = UDim.new(0, 10)

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

local buttons = {}

local function createButton(name, activateCallback, tooltipText)
    local button = Instance.new("TextButton", scrollingFrame)
    button.Size = UDim2.new(1, -20, 0, 50)
    button.Text = name
    button.TextColor3 = Color3.new(1, 1, 1)
    button.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    button.BorderSizePixel = 0
    button.Font = Enum.Font.SourceSans
    button.TextSize = 20

    -- Tooltip
    if tooltipText then
        local tooltip = Instance.new("TextLabel", menuFrame)
        tooltip.Size = UDim2.new(0, 200, 0, 30)
        tooltip.Text = tooltipText
        tooltip.TextColor3 = Color3.new(1, 1, 1)
        tooltip.BackgroundColor3 = Color3.new(0, 0, 0)
        tooltip.Position = UDim2.new(0.5, -100, 0.5, -220)
        tooltip.Visible = false

        button.MouseEnter:Connect(function()
            tooltip.Visible = true
        end)

        button.MouseLeave:Connect(function()
            tooltip.Visible = false
        end)
    end

    button.MouseButton1Click:Connect(function()
        activateCallback()
        button.BackgroundColor3 = Color3.new(0.5, 1, 0.5)
        wait(0.5)
        button.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    end)

    table.insert(buttons, button)

    local totalHeight = #buttons * (50 + uiListLayout.Padding.Offset)
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
end


-- Criando alguns botões de exemplo
createButton("INVENTÁRIO", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AdrainRazini/mastermod/refs/heads/main/inventario.lua"))()
end)

createButton("DELETAR", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AdrainRazini/mastermod/refs/heads/main/Deletar"))()
end)

createButton("Lock Camera", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AdrainRazini/mastermod/refs/heads/main/Lockcamera"))()
end)

createButton("Block air tool", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AdrainRazini/mastermod/refs/heads/main/Blockar"))()
end)

createButton("Aimbot all", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AdrainRazini/mastermod/refs/heads/main/Aimbotall"))()
end)

createButton("Aimbot team", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AdrainRazini/mastermod/refs/heads/main/Aimbotteam"))()
end)

createButton("Fly tool", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AdrainRazini/mastermod/refs/heads/main/flytool.lua"))()
end)

createButton("Fly toolv2", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AdrainRazini/mastermod/refs/heads/main/flytoov2"))()
end)

createButton("Speed Boost tool", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AdrainRazini/mastermod/refs/heads/main/speedtool.lua"))()
end)

createButton("Teleport tool", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AdrainRazini/mastermod/refs/heads/main/teleporttool.lua"))()
end)

createButton("Jump tool", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AdrainRazini/mastermod/refs/heads/main/jumptool.lua"))()
end)

createButton("Tp Players", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AdrainRazini/mastermod/refs/heads/main/TPPLAYERS"))()
end)

createButton("Visor Objetos", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AdrainRazini/mastermod/refs/heads/main/Visorname"))()
end)

createButton("Linhas", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AdrainRazini/mastermod/refs/heads/main/Linhas"))()
end)

createButton("Auto", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AdrainRazini/mastermod/refs/heads/main/Automovimento"))()
end)

createButton("TpV2", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AdrainRazini/mastermod/refs/heads/main/Tptoolv2"))()
end)

createButton("EM BREVE", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AdrainRazini/mastermod/refs/heads/main/EMBREVE"))()
end)

createButton("Ultra Visor", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AdrainRazini/mastermod/refs/heads/main/ULTRAVISOR"))()
end)



-- Botão para minimizar o menu
local minimizeButton = Instance.new("TextButton", screenGui)
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -40, 0, 10)
minimizeButton.Text = "⬜" -- Quadrado
minimizeButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
minimizeButton.BorderSizePixel = 0
minimizeButton.Font = Enum.Font.SourceSans
minimizeButton.TextSize = 20

minimizeButton.MouseButton1Click:Connect(function()
    if menuFrame.Size.Y.Offset > 60 then
        menuFrame.Size = UDim2.new(0, 300, 0, 60) -- Minimiza
        scrollingFrame.Visible = false -- Oculta o ScrollingFrame
        minimizeButton.Text = "⬛" -- Muda o ícone
    else
        menuFrame.Size = UDim2.new(0, 300, 0, 400) -- Restaura
        scrollingFrame.Visible = true -- Mostra o ScrollingFrame
        minimizeButton.Text = "⬜" -- Muda o ícone
    end
end)

-- Toggle visibility with 'M' key
userInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if not gameProcessedEvent and input.KeyCode == Enum.KeyCode.M then
        minimizeButton:Fire() -- Simula um clique no botão de minimizar
    end
end)
