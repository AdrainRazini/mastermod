local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
local frame = Instance.new("Frame")
local itemsList = Instance.new("ScrollingFrame")
local minimizeButton = Instance.new("TextButton")
local restoreButton = Instance.new("TextButton")

screenGui.Parent = player:WaitForChild("PlayerGui")
frame.Parent = screenGui
frame.Size = UDim2.new(0.4, 0, 0.6, 0)
frame.Position = UDim2.new(0.3, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.BorderSizePixel = 0
frame.Style = Enum.FrameStyle.RobloxRound

itemsList.Parent = frame
itemsList.Size = UDim2.new(1, 0, 0.8, 0)
itemsList.Position = UDim2.new(0, 0, 0, 0)
itemsList.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
itemsList.BorderSizePixel = 0
itemsList.CanvasSize = UDim2.new(0, 0, 2, 0)
itemsList.ScrollBarThickness = 10

minimizeButton.Parent = frame
minimizeButton.Size = UDim2.new(1, 0, 0.2, 0)
minimizeButton.Position = UDim2.new(0, 0, 0.8, 0)
minimizeButton.BackgroundColor3 = Color3.new(1, 0.8, 0)
minimizeButton.TextColor3 = Color3.new(1, 1, 1)
minimizeButton.Text = "Minimizar"
minimizeButton.BorderSizePixel = 0

restoreButton.Parent = screenGui
restoreButton.Size = UDim2.new(0.1, 0, 0.1, 0) -- Tamanho pequeno para simular um quadrado
restoreButton.Position = UDim2.new(0.45, 0, 0, 0) -- Centro em cima
restoreButton.BackgroundColor3 = Color3.new(0, 0.5, 0)
restoreButton.TextColor3 = Color3.new(1, 1, 1)
restoreButton.Text = "⬆️"  -- Ícone ou texto para restaurar
restoreButton.Visible = false -- Começa invisível

local function updateInventory()
    itemsList:ClearAllChildren()
    local yOffset = 0

    for _, item in ipairs(player.Backpack:GetChildren()) do
        local itemButton = Instance.new("TextButton")
        itemButton.Size = UDim2.new(1, -10, 0, 50)
        itemButton.Position = UDim2.new(0, 5, 0, yOffset)
        itemButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
        itemButton.TextColor3 = Color3.new(1, 1, 1)
        itemButton.Text = item.Name
        itemButton.BorderSizePixel = 0

        itemButton.MouseButton1Click:Connect(function()
            item.Parent = player.Character
            updateInventory()
        end)

        itemButton.Parent = itemsList
        yOffset = yOffset + 55
    end

    for _, item in ipairs(player.Character:GetChildren()) do
        if item:IsA("Tool") then
            local itemButton = Instance.new("TextButton")
            itemButton.Size = UDim2.new(1, -10, 0, 50)
            itemButton.Position = UDim2.new(0, 5, 0, yOffset)
            itemButton.BackgroundColor3 = Color3.new(0.2, 0.6, 0.2)
            itemButton.TextColor3 = Color3.new(1, 1, 1)
            itemButton.Text = item.Name .. " (Equipado)"
            itemButton.BorderSizePixel = 0

            itemButton.MouseButton1Click:Connect(function()
                item.Parent = player.Backpack
                updateInventory()
            end)

            itemButton.Parent = itemsList
            yOffset = yOffset + 55
        end
    end

    itemsList.CanvasSize = UDim2.new(0, 0, 0, yOffset)
end

local function minimizeGui()
    frame.Visible = false -- Oculta a GUI
    restoreButton.Visible = true -- Exibe o botão de restaurar
end

local function restoreGui()
    frame.Visible = true -- Exibe a GUI
    restoreButton.Visible = false -- Oculta o botão de restaurar
    updateInventory() -- Atualiza a lista
end

minimizeButton.MouseButton1Click:Connect(minimizeGui)
restoreButton.MouseButton1Click:Connect(restoreGui)

updateInventory()