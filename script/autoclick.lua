--==============================
-- SISTEMA DE GUI (Mouse Control)
--==============================
local GITHUB_REPO = "Mastermod"
local Owner = "Adrian75556435"

local UIS = game:GetService("UserInputService")

--== Carregar MouseModule ==--
local success, MouseModule = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/AdrainRazini/mastermod/refs/heads/main/module/data.lua"))()
end)

if not success or not MouseModule then
    warn("⚠ MouseModule não foi carregado (provavelmente Studio). Continuando em modo seguro.")
    MouseModule = nil
end

--== Variáveis ==--
local AllowMouseControl = false
local G2L = {}

--==============================
-- GUI
--==============================
G2L["ScreenGui"] = Instance.new("ScreenGui")
G2L["ScreenGui"].Name = "MouseController"
G2L["ScreenGui"].Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
G2L["ScreenGui"].ResetOnSpawn = false

-- Frame principal
G2L["MainFrame"] = Instance.new("Frame")
G2L["MainFrame"].Parent = G2L["ScreenGui"]
G2L["MainFrame"].Size = UDim2.new(0, 250, 0, 180)
G2L["MainFrame"].Position = UDim2.new(0.5, -125, 0.5, -90)
G2L["MainFrame"].BackgroundColor3 = Color3.fromRGB(30, 30, 30)
G2L["MainFrame"].BorderSizePixel = 0
G2L["MainFrame"].Active = true

-- Título
G2L["Title"] = Instance.new("TextLabel")
G2L["Title"].Parent = G2L["MainFrame"]
G2L["Title"].Size = UDim2.new(1, 0, 0, 30)
G2L["Title"].BackgroundTransparency = 1
G2L["Title"].Text = "Mouse Control"
G2L["Title"].TextColor3 = Color3.fromRGB(0, 170, 255)
G2L["Title"].TextScaled = true
G2L["Title"].Font = Enum.Font.GothamBold

-- Botão Toggle
G2L["ToggleBtn"] = Instance.new("TextButton")
G2L["ToggleBtn"].Parent = G2L["MainFrame"]
G2L["ToggleBtn"].Size = UDim2.new(0.9, 0, 0, 30)
G2L["ToggleBtn"].Position = UDim2.new(0.05, 0, 0.2, 0)
G2L["ToggleBtn"].BackgroundColor3 = Color3.fromRGB(70, 70, 70)
G2L["ToggleBtn"].Text = "Controle: OFF"
G2L["ToggleBtn"].TextColor3 = Color3.fromRGB(255, 0, 0)
G2L["ToggleBtn"].Font = Enum.Font.Gotham
G2L["ToggleBtn"].TextScaled = true
G2L["ToggleBtn"].BorderSizePixel = 0

-- Botão Mover Mouse
G2L["MoveBtn"] = Instance.new("TextButton")
G2L["MoveBtn"].Parent = G2L["MainFrame"]
G2L["MoveBtn"].Size = UDim2.new(0.9, 0, 0, 40)
G2L["MoveBtn"].Position = UDim2.new(0.05, 0, 0.45, 0)
G2L["MoveBtn"].BackgroundColor3 = Color3.fromRGB(50, 50, 50)
G2L["MoveBtn"].Text = "Mover Mouse (canto)"
G2L["MoveBtn"].TextColor3 = Color3.fromRGB(255, 255, 255)
G2L["MoveBtn"].Font = Enum.Font.Gotham
G2L["MoveBtn"].TextScaled = true
G2L["MoveBtn"].BorderSizePixel = 0

-- Botão Clique
G2L["ClickBtn"] = Instance.new("TextButton")
G2L["ClickBtn"].Parent = G2L["MainFrame"]
G2L["ClickBtn"].Size = UDim2.new(0.9, 0, 0, 40)
G2L["ClickBtn"].Position = UDim2.new(0.05, 0, 0.75, 0)
G2L["ClickBtn"].BackgroundColor3 = Color3.fromRGB(50, 50, 50)
G2L["ClickBtn"].Text = "Clique Simulado"
G2L["ClickBtn"].TextColor3 = Color3.fromRGB(255, 255, 255)
G2L["ClickBtn"].Font = Enum.Font.Gotham
G2L["ClickBtn"].TextScaled = true
G2L["ClickBtn"].BorderSizePixel = 0

-- Botão Referência
G2L["Referencia"] = Instance.new("TextButton")
G2L["Referencia"].Parent = G2L["ScreenGui"]
G2L["Referencia"].Size = UDim2.new(0, 10, 0, 10)
G2L["Referencia"].Position = UDim2.new(0.5, 0, 0.5, 0)
G2L["Referencia"].BackgroundColor3 = Color3.fromRGB(249, 249, 249)
G2L["Referencia"].Text = "."
G2L["Referencia"].TextColor3 = Color3.fromRGB(255, 0, 0)
G2L["Referencia"].Font = Enum.Font.Gotham
G2L["Referencia"].TextScaled = true
G2L["Referencia"].BorderSizePixel = 1
Instance.new("UICorner").Parent = G2L["Referencia"]

-- Notificação
game:GetService("StarterGui"):SetCore("SendNotification", { 
	Title = GITHUB_REPO;
	Text = Owner;
	Icon = "rbxthumb://type=Asset&id=102637810511338&w=150&h=150";
	Duration = 12;
})

--==============================
-- FUNÇÕES
--==============================
local function MoveMouseTo(targetPos, steps, delay)
	if not AllowMouseControl or not MouseModule then return end
	steps = steps or 20
	delay = delay or 0.01

	local startPos = MouseModule.getMause.GetPosition()
	local deltaX = (targetPos.X - startPos.X) / steps
	local deltaY = (targetPos.Y - startPos.Y) / steps

	for i = 1, steps do
		local newPos = Vector2.new(startPos.X + deltaX * i, startPos.Y + deltaY * i)
		if MouseModule.getMause.IsLocked() then
			MouseModule.getMause.LockMouse(newPos)
		else
			game:GetService("VirtualInputManager"):SendMouseMoveEvent(newPos.X, newPos.Y, nil)
		end
		task.wait(delay)
	end
end

local function SafeClick()
	if not AllowMouseControl or not MouseModule then return end
	MouseModule.getMause.Click(true)
	task.wait(0.05)
	MouseModule.getMause.Click(false)
end

--==============================
-- EVENTOS
--==============================

-- Toggle
G2L["ToggleBtn"].MouseButton1Click:Connect(function()
	AllowMouseControl = not AllowMouseControl
	if AllowMouseControl then
		G2L["ToggleBtn"].Text = "Controle: ON"
		G2L["ToggleBtn"].TextColor3 = Color3.fromRGB(0, 255, 0)
		G2L["ToggleBtn"].BackgroundColor3 = Color3.fromRGB(40, 100, 40)
	else
		G2L["ToggleBtn"].Text = "Controle: OFF"
		G2L["ToggleBtn"].TextColor3 = Color3.fromRGB(255, 0, 0)
		G2L["ToggleBtn"].BackgroundColor3 = Color3.fromRGB(100, 40, 40)
	end
end)

-- Mover mouse
G2L["MoveBtn"].MouseButton1Click:Connect(function()
	if not AllowMouseControl or not MouseModule then return end
	local Camera = workspace.CurrentCamera
	local target = Vector2.new(Camera.ViewportSize.X - 100, Camera.ViewportSize.Y - 100)
	MoveMouseTo(target, 50, 0.01)
end)

-- Clique
G2L["ClickBtn"].MouseButton1Click:Connect(SafeClick)

-- Travar no botão referência
G2L["Referencia"].MouseButton1Click:Connect(function()
	if not AllowMouseControl or not MouseModule then return end
	local refPos = G2L["Referencia"].AbsolutePosition
	MouseModule.getMause.LockMouse(Vector2.new(refPos.X, refPos.Y))
end)

--==============================
-- DRAG & DROP
--==============================
do
	local dragging, dragInput, dragStart, startPos

	G2L["MainFrame"].InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 
			or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = G2L["MainFrame"].Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	G2L["MainFrame"].InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement 
			or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			G2L["MainFrame"].Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)
end
