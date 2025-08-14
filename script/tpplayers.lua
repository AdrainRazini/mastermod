local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

player.CharacterAdded:Connect(function(newCharacter)
	character = newCharacter
end)

-- GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0.3, 0, 0.5, 0)
mainFrame.Position = UDim2.new(0.7, 0, 0.1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

-- Cabeçalho para arrastar
local dragFrame = Instance.new("Frame")
dragFrame.Size = UDim2.new(1, 0, 0, 30)
dragFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
dragFrame.BorderSizePixel = 0
dragFrame.Parent = mainFrame
Instance.new("UICorner", dragFrame).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "Teleportar para jogador"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.Gotham
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = dragFrame

-- Botão minimizar
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 30, 0, 24)
minimizeButton.Position = UDim2.new(1, -35, 0.1, 0)
minimizeButton.Text = "−"
minimizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextSize = 18
minimizeButton.BorderSizePixel = 0
minimizeButton.AutoButtonColor = false
minimizeButton.Parent = dragFrame
Instance.new("UICorner", minimizeButton).CornerRadius = UDim.new(0, 6)

-- Área de rolagem para lista
local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, 0, 1, -30)
scrollingFrame.Position = UDim2.new(0, 0, 0, 30)
scrollingFrame.ScrollBarThickness = 6
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingFrame.Parent = mainFrame

local uiListLayout = Instance.new("UIListLayout", scrollingFrame)
uiListLayout.Padding = UDim.new(0, 4)
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Botão sequência
local seqButton = Instance.new("TextButton")
seqButton.Size = UDim2.new(1, -10, 0, 40)
seqButton.Position = UDim2.new(0, 5, 0, 5)
seqButton.BackgroundColor3 = Color3.fromRGB(75, 35, 35)
seqButton.Text = "Teleportar em sequência"
seqButton.Font = Enum.Font.GothamBold
seqButton.TextSize = 14
seqButton.TextColor3 = Color3.new(1, 1, 1)
seqButton.BorderSizePixel = 0
seqButton.AutoButtonColor = false
seqButton.Parent = scrollingFrame
Instance.new("UICorner", seqButton).CornerRadius = UDim.new(0, 6)

seqButton.MouseEnter:Connect(function()
	seqButton.BackgroundColor3 = Color3.fromRGB(95, 45, 45)
end)
seqButton.MouseLeave:Connect(function()
	seqButton.BackgroundColor3 = Color3.fromRGB(75, 35, 35)
end)

-- Variáveis de controle
local isMinimized = false
local dragging = false
local dragStart, startPos
local isSeqActive = false

-- Função arrastar
local function iniciarArraste(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
	end
end

local function atualizarArraste(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end

local function finalizarArraste(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end

dragFrame.InputBegan:Connect(iniciarArraste)
UserInputService.InputChanged:Connect(atualizarArraste)
UserInputService.InputEnded:Connect(finalizarArraste)

-- Minimizar/restaurar
minimizeButton.MouseButton1Click:Connect(function()
	isMinimized = not isMinimized
	scrollingFrame.Visible = not isMinimized
	minimizeButton.Text = isMinimized and "+" or "−"
	mainFrame.Size = isMinimized and UDim2.new(0.15, 0, 0, 30) or UDim2.new(0.3, 0, 0.5, 0)
end)

-- Função teleporte
local function teleportarPara(jogadorAlvo)
	if jogadorAlvo and jogadorAlvo.Character then
		local root = jogadorAlvo.Character:FindFirstChild("HumanoidRootPart")
		local myRoot = character and character:FindFirstChild("HumanoidRootPart")
		if root and myRoot then
			myRoot.CFrame = CFrame.new(root.Position + Vector3.new(0, 3, 0))
		end
	end
end

-- Atualizar lista
local function atualizarListaDeJogadores()
	for _, v in ipairs(scrollingFrame:GetChildren()) do
		if v:IsA("TextButton") and v ~= seqButton then
			v:Destroy()
		end
	end
	for _, jogador in ipairs(Players:GetPlayers()) do
		if jogador ~= player then
			local button = Instance.new("TextButton")
			button.Size = UDim2.new(1, -10, 0, 40)
			button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
			button.Text = jogador.Name
			button.Font = Enum.Font.Gotham
			button.TextSize = 14
			button.TextColor3 = Color3.new(1, 1, 1)
			button.BorderSizePixel = 0
			button.AutoButtonColor = false
			Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)

			button.MouseEnter:Connect(function()
				button.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
			end)
			button.MouseLeave:Connect(function()
				button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
			end)

			button.MouseButton1Click:Connect(function()
				teleportarPara(jogador)
			end)

			button.Parent = scrollingFrame
		end
	end
	scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y)
end

-- Botão sequência
seqButton.MouseButton1Click:Connect(function()
	isSeqActive = not isSeqActive
	seqButton.Text = isSeqActive and "⏹ Parar sequência" or "Teleportar em sequência"

	if isSeqActive then
		task.spawn(function()
			while isSeqActive do
				for _, alvo in ipairs(Players:GetPlayers()) do
					if not isSeqActive then break end
					if alvo ~= player then
						pcall(function()
							teleportarPara(alvo)
						end)
						task.wait(1.5)
					end
				end
			end
		end)
	end
end)

-- Atualiza quando entra/sai player
Players.PlayerAdded:Connect(atualizarListaDeJogadores)
Players.PlayerRemoving:Connect(atualizarListaDeJogadores)

-- Primeira atualização
atualizarListaDeJogadores()
