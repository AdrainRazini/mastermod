--==============================
-- SISTEMA DE GUI (Mouse Control) - VERSÃO OTIMIZADA
--==============================
local GITHUB_REPO = "Mastermod"
local Owner = "Adrian75556435"

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
	warn("⚠ MouseModule não foi carregado (provavelmente Studio). Continuando em modo seguro.")
	MouseModule = {}
	MouseModule.getMause = {
		GetPosition = function() return Vector2.new(0,0) end,
		IsLocked = function() return false end,
		LockMouse = function() end,
		Click = function() end
	}
end

--== Ícones ==--
local icons = {
	fa_rr_toggle_left = "rbxassetid://118353432570896", -- Off
	fa_rr_toggle_right = "rbxassetid://136961682267523", -- On
	fa_rr_information = "rbxassetid://99073088081563", -- Info
	fa_bx_code_start = "rbxassetid://107895739450188", -- <>
	fa_bx_code_end = "rbxassetid://106185292775972", -- </>
	fa_bx_config = "rbxassetid://95026906912083", -- ●
	fa_bx_loader = "rbxassetid://123191542300310", -- loading
}

--== Variáveis ==--
local AllowMouseControl = false
local G2L = {}

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

local StarterGui = game:GetService("StarterGui")

function Notification(icon, text, time)
    -- Garante que só números do assetid serão usados
    local cleanIcon = tostring(icon):gsub("%D", "") -- remove tudo que não for número

    StarterGui:SetCore("SendNotification", { 
        Title = GITHUB_REPO;
        Text = text or "";
        Icon = "rbxthumb://type=Asset&id="..cleanIcon.."&w=150&h=150";
        Duration = time or 5;
    })
end

-- Exemplo de uso
Notification(icons.fa_bx_code_start, "Iniciando script...", 8)
Notification("abc95026906912083", "Teste com letras no id", 6)

-- Notificação inicial
StarterGui:SetCore("SendNotification", { 
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
			VirtualInputManager:SendMouseMoveEvent(newPos.X, newPos.Y, nil)
		end
		task.wait(delay)
	end
end

local function SafeClick(button)
	if not AllowMouseControl or not MouseModule then return end
	button = button or Enum.UserInputType.MouseButton1
	MouseModule.getMause.Click(true, button)
	task.wait(0.05)
	MouseModule.getMause.Click(false, button)
end

--==============================
-- EVENTOS
--==============================

-- Toggle controle
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

-- Mover mouse para canto
G2L["MoveBtn"].MouseButton1Click:Connect(function()
	if not AllowMouseControl or not MouseModule then return end
	local Camera = workspace.CurrentCamera
	local target = Vector2.new(Camera.ViewportSize.X - 100, Camera.ViewportSize.Y - 100)
	MoveMouseTo(target, 50, 0.01)
end)

-- Clique simulado
G2L["ClickBtn"].MouseButton1Click:Connect(function()
	SafeClick()
end)

-- Travar mouse no botão referência (centralizado)
local function getButtonCenter(button)
    local absPos = button.AbsolutePosition
    local absSize = button.AbsoluteSize
    return Vector2.new(absPos.X + absSize.X / 2, absPos.Y + absSize.Y / 2)
end

G2L["Referencia"].MouseButton1Click:Connect(function()
    if not AllowMouseControl or not MouseModule then return end
    local refPos = getButtonCenter(G2L["Referencia"])
    MouseModule.getMause.LockMouse(refPos)
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
			-- Suavização do movimento
			G2L["MainFrame"].Position = startPos:Lerp(
				UDim2.new(
					startPos.X.Scale, startPos.X.Offset + delta.X,
					startPos.Y.Scale, startPos.Y.Offset + delta.Y
				),
				0.2
			)
		end
	end)
end
