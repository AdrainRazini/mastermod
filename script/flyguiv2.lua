-- LocalScript em StarterPlayerScripts
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")




local icons = {
	fa_bx_mastermods = "rbxassetid://102637810511338", -- Logo do meu mod
	fa_rr_toggle_left = "rbxassetid://118353432570896", -- Off
	fa_rr_toggle_right = "rbxassetid://136961682267523", -- On
	fa_bx_low = "rbxassetid://94490690951735", -- Low(-)
	fa_bx_up = "rbxassetid://117619565987302", -- Up(+)
	fa_bx_arrow_up = "rbxassetid://109006220994206",
	fa_bx_arrow_low = "rbxassetid://88623811208601",
	fa_rr_information = "rbxassetid://99073088081563", -- Info
	fa_bx_code_start = "rbxassetid://107895739450188", -- <>
	fa_bx_code_end = "rbxassetid://106185292775972", -- </>
	fa_bx_config = "rbxassetid://95026906912083", -- ●
	fa_bx_loader = "rbxassetid://123191542300310", -- loading
}


--===============================================--
--============= Lista De Cores dat ===============--
--===============================================--

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

--===============================================--
--===============================================--


--================ Notificação ====================--
--=================================================--


local StarterGui = game:GetService("StarterGui")

function Notification(icon,Title, text, tempo)
	-- Garante que só números do assetid serão usados
	local cleanIcon = tostring(icon):gsub("%D", "") -- remove tudo que não for número

	StarterGui:SetCore("SendNotification", { 
		Title = Title ;
		Text = text or "";
		Icon = "rbxthumb://type=Asset&id="..cleanIcon.."&w=150&h=150";
		Duration = tempo or 5;
	})
end



--===============================================--
--===============================================--



--===============================================--
--============= Função De Estilos ===============--
--===============================================--

local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

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

-- Função para aplicar ajuste automático de CanvasSize em qualquer ScrollingFrame

local function applyAutoScrolling(instance, padding, alignment)
	-- Verifica se já existe um UIListLayout
	local layout = instance:FindFirstChildOfClass("UIListLayout")
	if not layout then
		layout = Instance.new("UIListLayout")
		layout.Parent = instance
		layout.SortOrder = Enum.SortOrder.LayoutOrder
	end

	-- Aplica padding se passado
	if padding then
		layout.Padding = padding
	end

	-- Aplica alinhamento opcional
	if alignment then
		layout.HorizontalAlignment = alignment or Enum.HorizontalAlignment.Left
	end

	-- Função de atualização
	local function updateCanvas()
		local contentSize = layout.AbsoluteContentSize
		local frameSizeY = instance.AbsoluteSize.Y

		instance.CanvasSize = UDim2.new(
			0, 0,
			0, math.max(contentSize.Y, frameSizeY) + 10 -- margem extra
		)
	end

	-- Conecta sinais
	layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
	instance:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateCanvas)

	-- Força atualização inicial
	updateCanvas()

	return layout
end



function applyDraggable (instance, Active, Draggable)
	instance.Active = Active
	instance.Draggable = Draggable
end

--===============================================--
--===============================================--

local G1L = {}

function  CreatGui ()


	G1L["ScreenGui"] = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
	G1L["ScreenGui"].Name = "FlyGui"

	G1L["Container_Mini"] = Instance.new("Frame", G1L["ScreenGui"])
	G1L["Container_Mini"].Name = "Container_Mini"
	G1L["Container_Mini"].Size = UDim2.new(0, 200, 0, 50)
	applyCorner(G1L["Container_Mini"])

	G1L["Right_Container"] = Instance.new("Frame", G1L["Container_Mini"])
	G1L["Right_Container"].Name = "Right_Container"
	G1L["Right_Container"].Size = UDim2.new(0, 25, 1, 0)
	G1L["Right_Container"].Position = UDim2.new(1, 0, 0, 0)

	applyUIListLayout(G1L["Right_Container"])

	G1L["Right_Container2"] = Instance.new("Frame", G1L["Container_Mini"])
	G1L["Right_Container2"].Name = "Right_Container_Speed"
	G1L["Right_Container2"].Size = UDim2.new(0, 25, 1, 0)
	G1L["Right_Container2"].Position = UDim2.new(1.15, 0, 0, 0)

	applyUIListLayout(G1L["Right_Container2"])

	G1L["Space_Btn"] = Instance.new("ImageButton", G1L["Right_Container"])
	G1L["Space_Btn"].Name = "Space_Btn"
	G1L["Space_Btn"].Size = UDim2.new(0, 25, 0, 25)
	G1L["Space_Btn"].Position = UDim2.new(0, 0, 0, 0)
	G1L["Space_Btn"].Image = icons.fa_bx_arrow_up

	G1L["Ctrl_Btn"] = Instance.new("ImageButton", G1L["Right_Container"])
	G1L["Ctrl_Btn"].Name = "Ctrl_Btn"
	G1L["Ctrl_Btn"].Size = UDim2.new(0, 25, 0, 25)
	G1L["Ctrl_Btn"].Position = UDim2.new(0, 0, 0, 0)
	G1L["Ctrl_Btn"].Image = icons.fa_bx_arrow_low

	applyCorner(G1L["Space_Btn"])
	applyCorner(G1L["Ctrl_Btn"])
	applyUIStroke(G1L["Space_Btn"], "Accent")
	applyUIStroke(G1L["Ctrl_Btn"], "Accent")



	G1L["Up_Btn"] = Instance.new("ImageButton", G1L["Right_Container2"])
	G1L["Up_Btn"].Name = "Up_Btn"
	G1L["Up_Btn"].Size = UDim2.new(0, 25, 0, 25)
	G1L["Up_Btn"].Position = UDim2.new(0, 0, 0, 0)
	G1L["Up_Btn"].Image = icons.fa_bx_up

	G1L["Low_Btn"] = Instance.new("ImageButton", G1L["Right_Container2"])
	G1L["Low_Btn"].Name = "Low_Btn"
	G1L["Low_Btn"].Size = UDim2.new(0, 25, 0, 25)
	G1L["Low_Btn"].Position = UDim2.new(0, 0, 0, 0)
	G1L["Low_Btn"].Image = icons.fa_bx_low

	applyCorner(G1L["Up_Btn"])
	applyCorner(G1L["Low_Btn"])
	applyUIStroke(G1L["Up_Btn"], "Accent")
	applyUIStroke(G1L["Low_Btn"], "Accent")

	applyRotatingGradientUIStroke(G1L["Container_Mini"], "Purple", "Indigo", "Aqua") -- Gradiente animado
	applyDraggable(G1L["Container_Mini"], true, true)


	G1L["Speed_Lb"] = Instance.new("TextLabel", G1L["Container_Mini"])
	G1L["Speed_Lb"].Size = UDim2.new(1, 0, 0, 25)
	G1L["Speed_Lb"].Position = UDim2.new(0, 0, -0.5, 0)
	G1L["Speed_Lb"].Text =  "By: @Adrian"


	applyRotatingGradientUIStroke(G1L["Speed_Lb"], "Purple", "Indigo", "Aqua") -- Gradiente animado

end

CreatGui()



function Create_Titles(Parent, Name, Text, Observacao, Retorno)
	local container_titles = Instance.new("Frame", G1L["Container_Mini"])
	container_titles.Name = Name
	container_titles.Size = UDim2.new(0.95, 0, 0, 60)
	container_titles.BackgroundTransparency = 1

	-- Layout horizontal
	local ly = Instance.new("UIListLayout", container_titles)
	ly.FillDirection = Enum.FillDirection.Horizontal
	ly.HorizontalAlignment = Enum.HorizontalAlignment.Left
	ly.VerticalAlignment = Enum.VerticalAlignment.Center
	ly.SortOrder = Enum.SortOrder.LayoutOrder
	ly.Padding = UDim.new(0, 10)

	-- Padding interno
	local padding = Instance.new("UIPadding", container_titles)
	padding.PaddingLeft = UDim.new(0, 5)
	padding.PaddingRight = UDim.new(0, 5)

	-- Container para texto (título + observação)
	local textContainer = Instance.new("Frame", container_titles)
	textContainer.Size = UDim2.new(1, -60, 1, 0) -- ocupa espaço, menos área do botão
	textContainer.BackgroundTransparency = 1
	textContainer.AutomaticSize = Enum.AutomaticSize.Y

	local verticalLy = Instance.new("UIListLayout", textContainer)
	verticalLy.FillDirection = Enum.FillDirection.Vertical
	verticalLy.HorizontalAlignment = Enum.HorizontalAlignment.Left
	verticalLy.VerticalAlignment = Enum.VerticalAlignment.Top
	verticalLy.SortOrder = Enum.SortOrder.LayoutOrder
	verticalLy.Padding = UDim.new(0, 2)

	-- Label do título
	local title_mod_Lb = Instance.new("TextLabel", textContainer)
	title_mod_Lb.BackgroundTransparency = 1
	title_mod_Lb.Text = Text
	title_mod_Lb.Size = UDim2.new(1, 0, 0, 0)
	title_mod_Lb.TextColor3 = Color3.fromRGB(255, 255, 255)
	title_mod_Lb.Font = Enum.Font.SourceSansBold
	title_mod_Lb.TextSize = 18
	title_mod_Lb.TextXAlignment = Enum.TextXAlignment.Left
	title_mod_Lb.AutomaticSize = Enum.AutomaticSize.Y

	-- Observação
	local Obs = Instance.new("TextLabel", textContainer)
	Obs.BackgroundTransparency = 1
	Obs.Text = Observacao
	Obs.Size = UDim2.new(1, 0, 0, 0)
	Obs.TextColor3 = Color3.fromRGB(200, 200, 200)
	Obs.Font = Enum.Font.SourceSans
	Obs.TextSize = 14
	Obs.TextXAlignment = Enum.TextXAlignment.Left
	Obs.AutomaticSize = Enum.AutomaticSize.Y

	-- Toggle button (fixo à direita)
	local toggle_btn = Instance.new("ImageButton", container_titles)
	toggle_btn.Size = UDim2.new(0, 50, 0, 30)
	toggle_btn.AnchorPoint = Vector2.new(1, 0.5)
	toggle_btn.Position = UDim2.new(1, -5, 0.5, 0)
	toggle_btn.Image = icons.fa_rr_toggle_left
	toggle_btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	toggle_btn.BackgroundTransparency = 0.15

	Instance.new("UICorner", toggle_btn).CornerRadius = UDim.new(0.5, 0)

	-- Lógica do toggle com animação
	local toggled = false
	toggle_btn.MouseButton1Click:Connect(function()
		toggled = not toggled

		local goal = {}
		if toggled then
			toggle_btn.Image = icons.fa_rr_toggle_right
			goal.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
		else
			toggle_btn.Image = icons.fa_rr_toggle_left
			goal.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		end

		TweenService:Create(toggle_btn, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), goal):Play()

		if Retorno then
			Retorno(toggled)
		end
	end)
end


-- Variáveis globais do Fly
local flyBodyVelocity
local flyJumpConn
local flyRenderConn
local flyInputConn
local flyMobile
local joystickVector = Vector2.new(0,0)
local touchConn
local joystick
local flySpeed = 50

-- Tabela para armazenar o estado das teclas
local moveInput = {W=false, A=false, S=false, D=false, Space=false, Ctrl=false}

-- Botão de subir → aumenta 10
G1L["Up_Btn"].MouseButton1Click:Connect(function()
	flySpeed = flySpeed + 10
	G1L["Speed_Lb"].Text ="Speed: "..flySpeed
end)


-- Botão de descer → diminui 10, nunca menor que 10
G1L["Low_Btn"].MouseButton1Click:Connect(function()
	flySpeed = math.max(10, flySpeed - 10)
	G1L["Speed_Lb"].Text ="Speed: "..flySpeed
end)


G1L["Space_Btn"].MouseButton1Down:Connect(function()
	moveInput.Space = true
	wait(0.5)
	moveInput.Space = false
end)

G1L["Ctrl_Btn"].MouseButton1Up:Connect(function()
	moveInput.Ctrl = true
	wait(0.5)
	moveInput.Ctrl = false
end)


-- Criação do título e funcionalidade do Fly
Create_Titles("Mastermods", "FlyMod", "FlyMod", "Power to fly on the map", function(estado)
	local player = game.Players.LocalPlayer
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoidRoot = character:WaitForChild("HumanoidRootPart")
	local humanoid = character:WaitForChild("Humanoid")
	local uis = game:GetService("UserInputService")
	local cam = workspace.CurrentCamera

	-- Atualiza label ao ativar
	G1L["Speed_Lb"].Text = "Speed: "..flySpeed

	if estado then
		print("Fly ligado!")

		-- Cria joystick apenas se ainda não existir
		local uis = game:GetService("UserInputService")

		if uis.TouchEnabled and not flyMobile then
			-- Cria joystick visual
			local joystickFrame = Instance.new("Frame", G1L["ScreenGui"])
			joystickFrame.Size = UDim2.new(0, 100, 0, 100)
			joystickFrame.Position = UDim2.new(0.1, 0, 0.5, 0)
			joystickFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
			joystickFrame.Visible = true
			applyCorner(joystickFrame, UDim.new(0, 50))

			local joystickFrame_D = Instance.new("Frame", joystickFrame)
			joystickFrame_D.Size = UDim2.new(0.2, 0, 0.2, 0)
			joystickFrame_D.Position = UDim2.new(0.4,0,0.4,0)
			joystickFrame_D.BackgroundColor3 = Color3.new(0.6,0.6,0.6)
			joystickFrame_D.Visible = true
			applyDraggable(joystickFrame_D, true, true)
			applyCorner(joystickFrame_D, UDim.new(0, 50))

			flyMobile = joystickFrame
			joystick = joystickFrame

			-- Conexão do toque para mover joystick

			-- Quando o toque terminar, centraliza o joystick
			uis.TouchEnded:Connect(function(touch)
				joystickVector = Vector2.new(0,0)
				if flyMobile then
					local joystickFrame_D = flyMobile:FindFirstChildOfClass("Frame") -- seu ponto arrastável
					if joystickFrame_D then
						joystickFrame_D.Position = UDim2.new(0.4, 0, 0.4, 0) -- posição central original
					end
				end
			end)


			touchConn = uis.TouchMoved:Connect(function(touch)
				-- Verifica se o toque está na metade esquerda da tela
				if touch.Position.X > workspace.CurrentCamera.ViewportSize.X / 2 then
					return  -- ignora toques na metade direita
				end

				-- Posição relativa ao centro do joystick
				local localPos = Vector2.new(
					touch.Position.X - (joystickFrame.AbsolutePosition.X + joystickFrame.AbsoluteSize.X/2),
					touch.Position.Y - (joystickFrame.AbsolutePosition.Y + joystickFrame.AbsoluteSize.Y/2)
				)

				-- Limita para não sair do raio do frame
				local maxRadius = joystickFrame.AbsoluteSize.X / 2
				if localPos.Magnitude > maxRadius then
					localPos = localPos.Unit * maxRadius
				end

				-- Atualiza joystickVector normalizado (-1 a 1)
				joystickVector = Vector2.new(
					localPos.X / maxRadius,
					localPos.Y / maxRadius
				)

				-- Atualiza a posição visual do ponto arrastável
				joystickFrame_D.Position = UDim2.new(
					0.5 + joystickVector.X * 0.5 - joystickFrame_D.Size.X.Offset / joystickFrame.AbsoluteSize.X,
					0,
					0.5 + joystickVector.Y * 0.5 - joystickFrame_D.Size.Y.Offset / joystickFrame.AbsoluteSize.Y,
					0
				)
			end)


		end


		-- Cria BodyVelocity
		if not flyBodyVelocity or not flyBodyVelocity.Parent then
			flyBodyVelocity = Instance.new("BodyVelocity")
			flyBodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
			flyBodyVelocity.Velocity = Vector3.new(0,0,0)
			flyBodyVelocity.P = 1250
			flyBodyVelocity.Parent = humanoidRoot
		end

		flyRenderConn = game:GetService("RunService").RenderStepped:Connect(function()
			local dir = Vector3.new(0,0,0)

			if flyMobile then
				-- Mobile monta dir no mesmo formato do PC (X,Z) e altura (Y)
				local vertical = (moveInput.Space and 1 or 0) - (moveInput.Ctrl and 1 or 0)
				dir = Vector3.new(
					joystickVector.X,   -- esquerda/direita
					vertical,           -- altura
					-joystickVector.Y   -- frente/trás
				)
			else
				-- Usa teclado
				dir = Vector3.new(
					(moveInput.D and 1 or 0) - (moveInput.A and 1 or 0),
					(moveInput.Space and 1 or 0) - (moveInput.Ctrl and 1 or 0),
					(moveInput.W and 1 or 0) - (moveInput.S and 1 or 0)
				)
			end

			if dir.Magnitude > 0 then
				dir = dir.Unit
			end

			if flyBodyVelocity then
				local lookVector = cam.CFrame.LookVector
				local rightVector = cam.CFrame.RightVector
				local upVector = Vector3.new(0,1,0)
				flyBodyVelocity.Velocity = (lookVector*dir.Z + rightVector*dir.X + upVector*dir.Y) * flySpeed
			end
		end)




		-- Impulso ao pular
		flyJumpConn = humanoid.Jumping:Connect(function()
			local impulse = cam.CFrame.LookVector * flySpeed
			humanoidRoot.Velocity = humanoidRoot.Velocity + impulse
		end)

		-- Input do jogador (PC) e Mobile
		flyInputConn = uis.InputBegan:Connect(function(input, processed)
			if processed then return end
			if input.UserInputType == Enum.UserInputType.Keyboard then
				if moveInput[input.KeyCode.Name] ~= nil then
					moveInput[input.KeyCode.Name] = true
				end

			elseif input.UserInputType == Enum.UserInputType.Touch then
				-- Mobile simples: move na direção que o personagem olha
				-- Pega a direção da câmera
				local camLook = cam.CFrame.LookVector
				local camRight = cam.CFrame.RightVector

				-- Normaliza para manter apenas a direção
				local dir = Vector3.new(camLook.X, 0, camLook.Z).Unit

				-- Aplica para frente/tras baseado na orientação
				moveInput.W = false    -- sempre mover pra frente no look da câmera
				moveInput.S = false
				moveInput.A = false
				moveInput.D = false

			end
		end)

		uis.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.Keyboard then
				if moveInput[input.KeyCode.Name] ~= nil then
					moveInput[input.KeyCode.Name] = false
				end
			end
		end)

	else
		print("Fly desligado!")
		G1L["Speed_Lb"].Text =  "By: @Adrian"
		
		-- Desconecta tudo e destrói o BodyVelocity
		if flyBodyVelocity then
			flyBodyVelocity:Destroy()
			flyBodyVelocity = nil
		end
		if flyRenderConn then
			flyRenderConn:Disconnect()
			flyRenderConn = nil
		end
		if flyJumpConn then
			flyJumpConn:Disconnect()
			flyJumpConn = nil
		end
		if flyInputConn then
			flyInputConn:Disconnect()
			flyInputConn = nil
		end
		if joystick then
			joystick:Destroy()
			joystick = nil
			flyMobile = nil
		end
	end
end)

-- Conecta evento de morte do humanoid para limpar tudo
local function setupFlyDeathCleanup(character)
	local humanoid = character:WaitForChild("Humanoid")
	humanoid.Died:Connect(function()
		if flyBodyVelocity then
			flyBodyVelocity:Destroy()
			flyBodyVelocity = nil
		end
		if flyRenderConn then
			flyRenderConn:Disconnect()
			flyRenderConn = nil
		end
		if flyJumpConn then
			flyJumpConn:Disconnect()
			flyJumpConn = nil
		end
		if flyInputConn then
			flyInputConn:Disconnect()
			flyInputConn = nil
		end
		if joystick then
			joystick:Destroy()
			joystick = nil
			flyMobile = nil
		end
	end)
end

-- Ao carregar o personagem
player.CharacterAdded:Connect(function(char)
	G1L:Destroy()
	CreatGui()
	setupFlyDeathCleanup(char) -- Limpa conexões ao morrer
	if flyBodyVelocity then
		flyBodyVelocity.Parent = char:WaitForChild("HumanoidRootPart")
	end
end)

-- Caso já tenha personagem
if player.Character then
	setupFlyDeathCleanup(player.Character)
end

