-- =========================
-- Módulo de Mouse Virtual
-- =========================
local VirtualMouse = {}

-- Serviços
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- GUI principal
local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VirtualMouseGui"
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Criar cursor
local cursor = Instance.new("ImageLabel")
cursor.Name = "VirtualCursor"
cursor.Size = UDim2.new(0, 32, 0, 32)
cursor.Image = "rbxassetid://3926305904" -- ícone de cursor
cursor.ImageRectSize = Vector2.new(36, 36)
cursor.ImageRectOffset = Vector2.new(204, 204)
cursor.BackgroundTransparency = 1
cursor.Parent = screenGui

-- Posição inicial
local currentX, currentY = 300, 300
cursor.Position = UDim2.fromOffset(currentX, currentY)

-- =========================
-- Funções do Mouse Virtual
-- =========================

-- Move instantâneo
function VirtualMouse.SetPos(x, y)
	currentX, currentY = x, y
	cursor.Position = UDim2.fromOffset(x, y)
end

-- Movimento suave
function VirtualMouse.SmoothMove(x2, y2, steps, delay)
	local dx = (x2 - currentX) / steps
	local dy = (y2 - currentY) / steps
	for i = 1, steps do
		currentX = currentX + dx
		currentY = currentY + dy
		cursor.Position = UDim2.fromOffset(currentX, currentY)
		RunService.RenderStepped:Wait()
		wait(delay or 0.01)
	end
end

-- Detecta GUI sob o cursor
local function detectGuiClick(x, y)
	local guis = player.PlayerGui:GetGuiObjectsAtPosition(x, y)
	for _, gui in ipairs(guis) do
		if gui:IsA("GuiButton") then
			gui:Activate() -- simula clique real
		end
	end
end

-- Clique simulado (efeito visual + clique real)
function VirtualMouse.Click()
	-- efeito visual
	local clickEffect = Instance.new("Frame")
	clickEffect.Size = UDim2.new(0, 40, 0, 40)
	clickEffect.Position = cursor.Position
	clickEffect.AnchorPoint = Vector2.new(0.5, 0.5)
	clickEffect.BackgroundTransparency = 0.5
	clickEffect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	clickEffect.Parent = screenGui

	local corner = Instance.new("UICorner", clickEffect)
	corner.CornerRadius = UDim.new(1, 0)

	local tween = TweenService:Create(clickEffect, TweenInfo.new(0.3), {
		Size = UDim2.new(0, 60, 0, 60),
		BackgroundTransparency = 1
	})
	tween:Play()
	tween.Completed:Connect(function()
		clickEffect:Destroy()
	end)

	-- clique em botões reais
	detectGuiClick(currentX, currentY)
end

-- =========================
-- Exemplo de uso (loop quadrado)
-- =========================
task.spawn(function()
	while true do
		VirtualMouse.SmoothMove(600, 300, 50, 0.01)
		wait(0.5)
		VirtualMouse.Click()

		VirtualMouse.SmoothMove(600, 500, 50, 0.01)
		wait(0.5)
		VirtualMouse.Click()

		VirtualMouse.SmoothMove(300, 500, 50, 0.01)
		wait(0.5)
		VirtualMouse.Click()

		VirtualMouse.SmoothMove(300, 300, 50, 0.01)
		wait(0.5)
		VirtualMouse.Click()
	end
end)

return VirtualMouse
