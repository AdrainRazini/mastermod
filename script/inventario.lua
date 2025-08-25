--[[
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
]]


local player = game.Players.LocalPlayer
local NAME_GUI = "Inventory"

local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")


local Inventory = {}
local G1L = {}

local Icons = {
	fa_bx_rr_tool = "rbxassetid://138301219336409",
}


-- Criação da lista de cores 
local colors = {
	Main = Color3.fromRGB(20, 20, 20),
	Secondary = Color3.fromRGB(35, 35, 35),
	Accent = Color3.fromRGB(0, 170, 255),
	Text = Color3.fromRGB(255, 255, 255),
	Button = Color3.fromRGB(50, 50, 50),
	ButtonHover = Color3.fromRGB(70, 70, 70),
	Stroke = Color3.fromRGB(80, 80, 80),
	Red = Color3.fromRGB(255, 0, 0),
	Green = Color3.fromRGB(0, 255, 0),
	Blue = Color3.fromRGB(0, 0, 255),
	Yellow = Color3.fromRGB(255, 255, 0),
	Orange = Color3.fromRGB(255, 165, 0),
	Purple = Color3.fromRGB(128, 0, 128),
	Pink = Color3.fromRGB(255, 105, 180),
	White = Color3.fromRGB(255, 255, 255),
	Black = Color3.fromRGB(0, 0, 0),
	Gray = Color3.fromRGB(128, 128, 128),
	DarkGray = Color3.fromRGB(50, 50, 50),
	LightGray = Color3.fromRGB(200, 200, 200),
	Cyan = Color3.fromRGB(0, 255, 255),
	Magenta = Color3.fromRGB(255, 0, 255),
	Brown = Color3.fromRGB(139, 69, 19),
	Gold = Color3.fromRGB(255, 215, 0),
	Silver = Color3.fromRGB(192, 192, 192),
	Maroon = Color3.fromRGB(128, 0, 0),
	Navy = Color3.fromRGB(0, 0, 128),
	Lime = Color3.fromRGB(50, 205, 50),
	Olive = Color3.fromRGB(128, 128, 0),
	Teal = Color3.fromRGB(0, 128, 128),
	Aqua = Color3.fromRGB(0, 255, 170),
	Coral = Color3.fromRGB(255, 127, 80),
	Crimson = Color3.fromRGB(220, 20, 60),
	Indigo = Color3.fromRGB(75, 0, 130),
	Turquoise = Color3.fromRGB(64, 224, 208),
	Slate = Color3.fromRGB(112, 128, 144),
	Chocolate = Color3.fromRGB(210, 105, 30)
}


-- 🖼️ Função utilitária para criar UI Corner Obs: Aplicar Ui nas frames
local function applyCorner(instance, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = radius or UDim.new(0, 6)
	corner.Parent = instance
end

-- Função para aplicar contorno neon via UIStroke
local function applyUIStroke(instance, colorName, thickness)
	thickness = thickness or 2
	local stroke = Instance.new("UIStroke")
	stroke.Parent = instance
	stroke.Thickness = thickness
	stroke.LineJoinMode = Enum.LineJoinMode.Round
	stroke.Transparency = 0
	-- Escolhe cor da paleta ou usa branco como fallback
	stroke.Color = colors[colorName] or Color3.new(1, 1, 1)
end

local function applyUIListLayout(instance, padding, sortOrder, alignment)
	local list = Instance.new("UIListLayout")
	list.Parent = instance

	-- Padding entre elementos (UDim ou padrão 0)
	list.Padding = padding or UDim.new(0, 0)

	-- Ordem dos elementos
	list.SortOrder = sortOrder or Enum.SortOrder.LayoutOrder

	-- Alinhamento
	list.HorizontalAlignment = alignment or Enum.HorizontalAlignment.Center
end


local function applyRotatingGradientUIStroke(instance, cor1, cor2, cor3)
	cor1 = cor1 or "White"
	cor2 = cor2 or "White"
	cor3 = cor3 or "White"

	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 2
	stroke.Transparency = 0
	stroke.LineJoinMode = Enum.LineJoinMode.Round
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Color = colors.White
	stroke.Parent = instance

	local gradient = Instance.new("UIGradient")
	gradient.Rotation = 0
	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0.0, colors[cor1]),
		ColorSequenceKeypoint.new(0.5, colors[cor2]),
		ColorSequenceKeypoint.new(1.0, colors[cor3])
	})
	gradient.Parent = stroke

	-- Animação da rotação do gradiente
	local angle = 0
	RunService.RenderStepped:Connect(function()
		if not gradient.Parent then return end
		angle = (angle + 0.5) % 360
		gradient.Rotation = angle
	end)
end


local function CreateGui()
	-- Limpa GUI antiga
	if G1L["ScreenGui"] then
		G1L["ScreenGui"]:Destroy()
	end

	-- GUI principal
	G1L["ScreenGui"] = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
	G1L["ScreenGui"].Name = NAME_GUI

	-- Frame principal
	G1L["Frame"] = Instance.new("Frame", G1L["ScreenGui"])
	G1L["Frame"].Size = UDim2.new(0.4, 0, 0.6, 0)
	G1L["Frame"].Position = UDim2.new(0.3, 0, 0.2, 0)
	G1L["Frame"].BackgroundColor3 = colors.Main
	G1L["Frame"].BorderSizePixel = 0
	applyCorner(G1L["Frame"], UDim.new(0, 12))         -- Cantos arredondados
	applyRotatingGradientUIStroke(G1L["Frame"], "Red", "Yellow", "Orange") -- Gradiente animado

	-- ScrollingFrame
	G1L["ItemsList"] = Instance.new("ScrollingFrame", G1L["Frame"])
	G1L["ItemsList"].Size = UDim2.new(1, 0, 0.8, 0)
	G1L["ItemsList"].BackgroundColor3 = colors.DarkGray
	G1L["ItemsList"].BorderSizePixel = 0
	G1L["ItemsList"].CanvasSize = UDim2.new(0, 0, 2, 0)
	G1L["ItemsList"].ScrollBarThickness = 10
	applyUIListLayout(G1L["ItemsList"], UDim.new(0, 5)) -- Espaçamento entre itens
	applyCorner(G1L["ItemsList"], UDim.new(0, 5))

	-- Botão minimizar
	G1L["MinimizeButton"] = Instance.new("TextButton", G1L["Frame"])
	G1L["MinimizeButton"].Size = UDim2.new(1, 0, 0.2, 0)
	G1L["MinimizeButton"].Position = UDim2.new(0, 0, 0.8, 0)
	G1L["MinimizeButton"].Text = "Minimizar"
	G1L["MinimizeButton"].BackgroundColor3 = colors.Orange
	G1L["MinimizeButton"].TextColor3 = colors.White
	G1L["MinimizeButton"].BorderSizePixel = 0
	applyCorner(G1L["MinimizeButton"], UDim.new(0, 6))
	

	-- Botão restaurar
	G1L["RestoreButton"] = Instance.new("ImageButton", G1L["ScreenGui"])
	G1L["RestoreButton"].Size = UDim2.new(0, 25, 0, 25)
	G1L["RestoreButton"].Position = UDim2.new(0.5, 0, 0, 0)
	G1L["RestoreButton"].Image = Icons.fa_bx_rr_tool
	G1L["RestoreButton"].BackgroundColor3 = colors.Orange
	G1L["RestoreButton"].BorderSizePixel = 0
	G1L["RestoreButton"].Active = true
	G1L["RestoreButton"].Draggable = true
	applyRotatingGradientUIStroke(G1L["RestoreButton"], "Red", "Yellow", "Orange") -- Gradiente animado

	
	
	applyCorner(G1L["RestoreButton"], UDim.new(0, 6))
	applyUIStroke(G1L["RestoreButton"], "Accent", 2)
	G1L["RestoreButton"].Visible = false

	-- Eventos
	G1L["MinimizeButton"].MouseButton1Click:Connect(function()
		G1L["Frame"].Visible = false
		G1L["RestoreButton"].Visible = true
	end)

	G1L["RestoreButton"].MouseButton1Click:Connect(function()
		G1L["Frame"].Visible = true
		G1L["RestoreButton"].Visible = false
	end)
end

-- Cria a GUI
CreateGui()


local function updateInventory()
	G1L["ItemsList"] :ClearAllChildren()
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

		itemButton.Parent = G1L["ItemsList"]
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

			itemButton.Parent = G1L["ItemsList"]
			yOffset = yOffset + 55
		end
	end

	G1L["ItemsList"].CanvasSize = UDim2.new(0, 0, 0, yOffset)
end

updateInventory()