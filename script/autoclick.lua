--==============================
-- SISTEMA DE GUI (Mouse Control) - VERSÃO ATUALIZADA
--==============================
local GITHUB_REPO = "Mastermod"
local Owner = "Adrian75556435"

local VIM = game:GetService("VirtualInputManager")
local UIS = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

--== Carregar MouseModule ==--
local success, MouseModule = pcall(function()
	return loadstring(game:HttpGet("https://raw.githubusercontent.com/AdrainRazini/mastermod/refs/heads/main/module/data.lua"))()
end)

if not success or not MouseModule then
	warn("⚠ MouseModule não foi carregado. Modo seguro ativado.")
	MouseModule = {}
	MouseModule.getMause = {
		GetPosition = function() return Vector2.new(0,0) end,
		IsLocked = function() return false end,
		LockMouse = function() end,
		UnlockMouse = function() end,
		Click = function() end,
		ClickUp = function() end,
		Scroll = function() end,
		Circle = function() end,
		Drag = function() end,
	}
end

--== Variáveis ==--
local AllowMouseControl = false
local G2L = {}
local lock_mouse = false

--==============================
-- GUI
--==============================
G2L["ScreenGui"] = Instance.new("ScreenGui")
G2L["ScreenGui"].Name = "MouseController"
G2L["ScreenGui"].Parent = LocalPlayer:WaitForChild("PlayerGui")
G2L["ScreenGui"].ResetOnSpawn = false

-- Frame principal
G2L["MainFrame"] = Instance.new("Frame")
G2L["MainFrame"].Parent = G2L["ScreenGui"]
G2L["MainFrame"].Size = UDim2.new(0, 250, 0, 350)
G2L["MainFrame"].Position = UDim2.new(0.5, -125, 0.5, -175)
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

-- Scroll frame para botões
G2L["ButtonScroll"] = Instance.new("ScrollingFrame")
G2L["ButtonScroll"].Parent = G2L["MainFrame"]
G2L["ButtonScroll"].Size = UDim2.new(1, -10, 1, -40)
G2L["ButtonScroll"].Position = UDim2.new(0, 5, 0, 35)
G2L["ButtonScroll"].BackgroundTransparency = 1
G2L["ButtonScroll"].BorderSizePixel = 0
G2L["ButtonScroll"].CanvasSize = UDim2.new(0, 0, 0, 400)
G2L["ButtonScroll"].ScrollBarThickness = 6

-- Função auxiliar para criar botões
local function CreateButton(name, text, yPos)
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.Parent = G2L["ButtonScroll"]
	btn.Size = UDim2.new(0.9, 0, 0, 40)
	btn.Position = UDim2.new(0.05, 0, 0, yPos)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.Gotham
	btn.TextScaled = true
	btn.BorderSizePixel = 0
	return btn
end

-- Criando botões
G2L["ToggleBtn"] = CreateButton("ToggleBtn", "Controle: OFF", 0)
G2L["MoveBtn"] = CreateButton("MoveBtn", "Mover Mouse (canto)", 50)
G2L["ClickBtn"] = CreateButton("ClickBtn", "Clique Simulado", 100)
G2L["Referencia_Btn"] = CreateButton("Referencia_Btn", "Lock Mouse Off", 150)
G2L["ScrollBtn"] = CreateButton("ScrollBtn", "Scroll Mouse", 200)
G2L["CircleBtn"] = CreateButton("CircleBtn", "Mouse Circle", 250)
G2L["DragBtn"] = CreateButton("DragBtn", "Arrastar Mouse", 300)

-- Ajuste da CanvasSize
G2L["ButtonScroll"].CanvasSize = UDim2.new(0, 0, 0, 350)

-- Referência
G2L["Referencia"] = Instance.new("Frame")
G2L["Referencia"].Parent = G2L["ScreenGui"]
G2L["Referencia"].Size = UDim2.new(0, 0, 0, 0)
G2L["Referencia"].Position = UDim2.new(0.55, 0, 0.45, 0)
G2L["Referencia"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
--[[
Instance.new("UICorner").Parent = G2L["Referencia"]
Instance.new("UIStroke").Parent = G2L["Referencia"]
]]

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
			VirtualInputManager:SendMouseMoveEvent(newPos.X, newPos.Y, nil)
		end
		task.wait(delay)
	end
end

local function SafeClickUp(rightClick, duration)
	if not AllowMouseControl or not MouseModule then return end
	rightClick = rightClick or MouseModule.getMause.IsRightClick()
	duration = duration or 0.05
	--MouseModule.getMause.ClickUp(rightClick, duration)
local btn = rightClick and 1 or 0
    local pos = MouseState.Locked and MouseState.LockedPosition or UIS:GetMouseLocation()

    -- Debug
    print("[ClickUp] rightClick:", rightClick, "btn:", btn, "pos:", pos)

    -- Pressiona
    VIM:SendMouseButtonEvent(pos.X, pos.Y, btn, true, nil, 0)
    task.wait(time or 0.05)
    -- Solta
    VIM:SendMouseButtonEvent(pos.X, pos.Y, btn, false, nil, 0)

end

-- Função para pegar o centro real de qualquer botão/frame
local function getButtonCenter(button)
	-- Posição do canto superior esquerdo
	local absPos = button.AbsolutePosition
	local absSize = button.AbsoluteSize
	local anchor = button.AnchorPoint or Vector2.new(0,0)

	-- Fórmula universal (compensa automaticamente o AnchorPoint)
	return absPos + (absSize * anchor)
end

--==============================
-- EVENTOS
--==============================
G2L["ToggleBtn"].MouseButton1Click:Connect(function()
	AllowMouseControl = not AllowMouseControl
	if AllowMouseControl then
		G2L["ToggleBtn"].Text = "Controle: ON"
		G2L["ToggleBtn"].TextColor3 = Color3.fromRGB(0,255,0)
		G2L["ToggleBtn"].BackgroundColor3 = Color3.fromRGB(40,100,40)
	else
		G2L["ToggleBtn"].Text = "Controle: OFF"
		G2L["ToggleBtn"].TextColor3 = Color3.fromRGB(255,0,0)
		G2L["ToggleBtn"].BackgroundColor3 = Color3.fromRGB(100,40,40)
	end
end)

G2L["MoveBtn"].MouseButton1Click:Connect(function()
	if not AllowMouseControl then return end
	local Camera = workspace.CurrentCamera
	local target = Vector2.new(Camera.ViewportSize.X - 100, Camera.ViewportSize.Y - 100)
	MoveMouseTo(target, 50, 0.01)
end)

G2L["ClickBtn"].MouseButton1Click:Connect(function()
	SafeClickUp(false, 0.5) --esquerda
	--SafeClickUp(true, 0.5) --direita
end)

-- Evento do botão para travar/destravar
G2L["Referencia_Btn"].MouseButton1Click:Connect(function()
	if not AllowMouseControl then return end
	local refPos = getButtonCenter(G2L["Referencia"])
	local mause = MouseModule.getMause

	if not lock_mouse then
		mause.LockMouse(refPos)
		print("Centro da Referencia:", "X =", refPos.X, "Y =", refPos.Y)
		lock_mouse = true
		G2L["Referencia_Btn"].Text = "Lock: ON"
		G2L["Referencia_Btn"].TextColor3 = Color3.fromRGB(0,255,0)
		G2L["Referencia_Btn"].BackgroundColor3 = Color3.fromRGB(40,100,40)
	else
		mause.UnlockMouse()
		lock_mouse = false
		G2L["Referencia_Btn"].Text = "Lock: OFF"
		G2L["Referencia_Btn"].TextColor3 = Color3.fromRGB(255,0,0)
		G2L["Referencia_Btn"].BackgroundColor3 = Color3.fromRGB(100,40,40)
	end
end)

G2L["ScrollBtn"].MouseButton1Click:Connect(function()
	if not AllowMouseControl then return end
	MouseModule.getMause.Scroll(3)
end)

G2L["CircleBtn"].MouseButton1Click:Connect(function()
	if not AllowMouseControl then return end
	MouseModule.getMause.Circle(50,36,0.01)
end)

G2L["DragBtn"].MouseButton1Click:Connect(function()
	if not AllowMouseControl then return end
	local startPos = Vector2.new(100,100)
	local endPos = Vector2.new(400,300)
	MouseModule.getMause.Drag(startPos,endPos,50,0.01)
end)

--==============================
-- DRAG & DROP DA GUI
--==============================
do
	local dragging, dragInput, dragStart, startPos
	G2L["MainFrame"].InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			G2L["MainFrame"].Position = startPos:Lerp(
				UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y),
				0.2
			)
		end
	end)
end
