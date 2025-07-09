local player = game.Players.LocalPlayer
local chestFolder = workspace:FindFirstChild("ChestFolder") or workspace:FindFirstChild("chestfolder")

if not chestFolder then
	warn("Pasta ChestFolder ou chestfolder não encontrada!")
	return
end

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "ChestTeleportGui"
gui.ResetOnSpawn = false

-- Frame principal
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 320, 0, 380)
frame.Position = UDim2.new(0, 100, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

-- Barra de título
local titleBar = Instance.new("Frame", frame)
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
titleBar.BorderSizePixel = 0
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(1, -90, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Teleporte para Baús"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left

local minimizeBtn = Instance.new("TextButton", titleBar)
minimizeBtn.Size = UDim2.new(0, 40, 1, 0)
minimizeBtn.Position = UDim2.new(1, -45, 0, 0)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
minimizeBtn.Text = "-"
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 24
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 6)

local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	for _, child in ipairs(frame:GetChildren()) do
		if child ~= titleBar and child:IsA("GuiObject") then
			child.Visible = not minimized
		end
	end
	if minimized then
		frame.Size = UDim2.new(0, 320, 0, 30)
		minimizeBtn.Text = "+"
	else
		frame.Size = UDim2.new(0, 320, 0, 380)
		minimizeBtn.Text = "-"
	end
end)

-- Label e TextBox para controle do tempo
local timeLabel = Instance.new("TextLabel", frame)
timeLabel.Size = UDim2.new(0, 150, 0, 25)
timeLabel.Position = UDim2.new(0, 10, 0, 30)
timeLabel.BackgroundTransparency = 1
timeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
timeLabel.Text = "Intervalo (segundos):"
timeLabel.Font = Enum.Font.Gotham
timeLabel.TextSize = 14
timeLabel.TextXAlignment = Enum.TextXAlignment.Left

local timeBox = Instance.new("TextBox", frame)
timeBox.Size = UDim2.new(0, 80, 0, 25)
timeBox.Position = UDim2.new(0, 170, 0, 30)
timeBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
timeBox.TextColor3 = Color3.fromRGB(255, 255, 255)
timeBox.Text = "10" -- valor padrão 10 segundos
timeBox.Font = Enum.Font.Gotham
timeBox.TextSize = 14
timeBox.ClearTextOnFocus = false
Instance.new("UICorner", timeBox).CornerRadius = UDim.new(0, 6)

-- ScrollFrame para lista
local scrollFrame = Instance.new("ScrollingFrame", frame)
scrollFrame.Size = UDim2.new(1, -20, 0, 280)
scrollFrame.Position = UDim2.new(0, 10, 0, 60)
scrollFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 6
Instance.new("UICorner", scrollFrame).CornerRadius = UDim.new(0, 6)

local listLayout = Instance.new("UIListLayout", scrollFrame)
listLayout.Padding = UDim.new(0, 6)
listLayout.SortOrder = Enum.SortOrder.Name

local function atualizarCanvas()
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
end
listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(atualizarCanvas)

local chestModels = {} -- lista dos baús atualizados
local selectedModel = nil

local function limparLista()
	for _, child in pairs(scrollFrame:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end
end

local function atualizarListaModelos()
	limparLista()
	chestModels = {}
	for _, modelo in pairs(chestFolder:GetChildren()) do
		if modelo:IsA("Model") and modelo.PrimaryPart then
			table.insert(chestModels, modelo)

			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1, 0, 0, 40)
			btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			btn.TextColor3 = Color3.fromRGB(255, 255, 255)
			btn.Font = Enum.Font.Gotham
			btn.TextSize = 16
			btn.Text = modelo.Name
			btn.Parent = scrollFrame
			Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

			btn.MouseButton1Click:Connect(function()
				if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
					player.Character:SetPrimaryPartCFrame(modelo.PrimaryPart.CFrame + Vector3.new(0, 5, 0))
					selectedModel = modelo
				end
			end)
		end
	end
	atualizarCanvas()
end

-- Atualiza a lista sempre que um baú é adicionado ou removido
chestFolder.ChildAdded:Connect(atualizarListaModelos)
chestFolder.ChildRemoved:Connect(atualizarListaModelos)
atualizarListaModelos()

-- Botão para ativar/desativar auto teleport
local autoTeleportActive = false
local autoTeleportBtn = Instance.new("TextButton", frame)
autoTeleportBtn.Size = UDim2.new(0, 150, 0, 40)
autoTeleportBtn.Position = UDim2.new(0.5, -75, 1, -50)
autoTeleportBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
autoTeleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoTeleportBtn.Font = Enum.Font.GothamBold
autoTeleportBtn.TextSize = 18
autoTeleportBtn.Text = "Auto Teleport OFF"

local currentIndex = 1
local timer = 0
local TELEPORT_INTERVAL = tonumber(timeBox.Text) or 10

autoTeleportBtn.MouseButton1Click:Connect(function()
	autoTeleportActive = not autoTeleportActive
	if autoTeleportActive then
		autoTeleportBtn.Text = "Auto Teleport ON"
		timer = 0 -- reset timer ao ativar
	else
		autoTeleportBtn.Text = "Auto Teleport OFF"
	end
end)

-- Atualiza o tempo de intervalo quando o usuário muda o valor
timeBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		local val = tonumber(timeBox.Text)
		if val and val >= 1 then
			TELEPORT_INTERVAL = val
			timer = 0 -- reset timer para aplicar o novo intervalo imediatamente
			timeBox.Text = tostring(val)
		else
			-- Valor inválido, volta para o valor atual
			timeBox.Text = tostring(TELEPORT_INTERVAL)
		end
	end
end)

local RunService = game:GetService("RunService")

RunService.Heartbeat:Connect(function(dt)
	if autoTeleportActive and #chestModels > 0 and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		timer = timer + dt
		if timer >= TELEPORT_INTERVAL then
			if currentIndex > #chestModels then
				currentIndex = 1
			end

			local model = chestModels[currentIndex]
			if model and model.PrimaryPart then
				player.Character:SetPrimaryPartCFrame(model.PrimaryPart.CFrame + Vector3.new(0, 5, 0))
				selectedModel = model
			end

			currentIndex = currentIndex + 1
			timer = 0
		end
	end
end)
