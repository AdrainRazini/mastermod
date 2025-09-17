

--[[
| Categoria          | Nomes Comuns                                     |
|--------------------|--------------------------------------------------|
| Tabs/Abas          | Home, Settings, Profile, Dashboard, Account, Notifications, Messages, Reports, Tools, Help |
| Buttons/Botões     | Submit, Cancel, Save, Load, Edit, Delete, Apply, Next, Previous, Close, Back, Continue, Confirm, Reset |
| Input Fields       | Username, Password, Email, Search, First Name, Last Name, Address, Phone, Date, Comments, Description, Notes |
| Labels/Texto       | Welcome, Settings, Profile Information, Notifications, Status, Level, Score, Time, Health, XP |
| Checkboxes/Radios  | Enable Notifications, Remember Me, Auto Save, Dark Mode, Male, Female, Option 1, Option 2, Option 3 |
| Sliders/Ranges     | Volume, Brightness, Speed, Size, Zoom, Opacity, Timer, Intensity |
| Menus/Dropdowns    | File, Edit, View, Tools, Options, Help, Language, Theme, Sort By, Filter |
]]

local name = "Mod_Gui(Md)"

local UserInputService = game:GetService("UserInputService")

local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local chach = {
	Tabs_Dt = {"Home", "Settings", "Profile", "Dashboard", "Account", "Notifications", "Messages", "Reports", "Tools", "Help"},
	Buttons_Dt = {"Submit", "Cancel", "Save", "Load", "Edit", "Delete", "Apply", "Next", "Previous", "Close", "Back", "Continue", "Confirm", "Reset"},
	InputFields_Dt = {"Username", "Password", "Email", "Search", "First Name", "Last Name", "Address", "Phone", "Date", "Comments", "Description", "Notes"},
	Labels_Dt = {"Welcome", "Settings", "Profile Information", "Notifications", "Status", "Level", "Score", "Time", "Health", "XP"},
	Checkboxes_Dt = {"Enable Notifications", "Remember Me", "Auto Save", "Dark Mode", "Male", "Female", "Option 1", "Option 2", "Option 3"},
	Sliders_Dt = {"Volume", "Brightness", "Speed", "Size", "Zoom", "Opacity", "Timer", "Intensity"},
	Menus_Dt = {"File", "Edit", "View", "Tools", "Options", "Help", "Language", "Theme", "Sort By", "Filter"},
	Icons = {
		fa_bx_mastermods = "rbxassetid://102637810511338", -- Logo do meu mod
		fa_rr_toggle_left = "rbxassetid://118353432570896", -- Off
		fa_rr_toggle_right = "rbxassetid://136961682267523", -- On
		fa_rr_information = "rbxassetid://99073088081563", -- Info
		fa_bx_code_start = "rbxassetid://107895739450188", -- <>
		fa_bx_code_end = "rbxassetid://106185292775972", -- </>
		fa_bx_config = "rbxassetid://95026906912083", -- ●
		fa_bx_loader = "rbxassetid://123191542300310", -- loading
		fa_bx_right_arrow = "rbxassetid://138267430897185",
		fa_wifi = "rbxassetid://83115652782087",       -- Com sinal wifi
		fa_wifi_slash = "rbxassetid://127088833388231",-- Sem sinal wifi
		fa_globo = "rbxassetid://104127284918306",     -- Globo sem wifi
		fa_home = "rbxassetid://134964643389961",      -- Casa
		fa_ss_marker = "rbxassetid://140511701984982", -- Maps
		fa_rr_share = "rbxassetid://75121522932139",   -- Compartilhar
		fa_rr_paper_plane = "rbxassetid://86343306423033", -- Compartilhar mensagem
		fa_envelope = "rbxassetid://140037902554025",  -- Envelope
		fa_whatsapp = "rbxassetid://103713011606764",  -- Whatsapp
		fa_rr_angle_left = "rbxassetid://92686715496412", -- Setinha esquerda
		fa_rr_menu_burger = "rbxassetid://101116035332969", -- Menu 
		fa_rr_volume_off = "rbxassetid://88547367607829", -- Mute Volume
		fa_rr_volume_1 = "rbxassetid://105591625157012", -- Volume 1
		fa_rr_volume_2 = "rbxassetid://101278925511080", -- Volume 2
		fa_rr_volume_3 = "rbxassetid://131186960212119", -- Volume 3
		fa_bx_lock = "rbxassetid://105603939190175",     -- Cadeado fechado
		fa_bx_lock_open = "rbxassetid://82803128480451", -- Cadeado aberto
		fa_bx_no_signal = "rbxassetid://112204578443623",-- sem sinal
		fa_bx_pause_circle = "rbxassetid://90466836635901",
		fa_bx_play_circle = "rbxassetid://134697889090641",
		fa_bx_looped_on = "rbxassetid://70539440255889",
		fa_bx_looped_off = "rbxassetid://93825302122528",
		fa_roblox_logo = "rbxassetid://78469189558823", -- loading Roblox
	},
	Colors = {
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
	
}


-- Função para centralizar um Frame
function chach.center(frame)
	if frame and frame:IsA("GuiObject") then
		frame.AnchorPoint = Vector2.new(0.5, 0.5)
		frame.Position = UDim2.new(0.5, 0, 0.5, 0)
	end
end


-- Função utilitária para criar UI Corner Obs: Aplicar Ui nas frames
function chach.applyCorner(instance, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = radius or UDim.new(0, 6)
	corner.Parent = instance
end

-- Função para aplicar contorno neon via UIStroke
function chach.applyUIStroke(instance, colorName, thickness)
	thickness = thickness or 2
	local stroke = Instance.new("UIStroke")
	stroke.Parent = instance
	stroke.Thickness = thickness
	stroke.LineJoinMode = Enum.LineJoinMode.Round
	stroke.Transparency = 0
	-- Escolhe cor da paleta ou usa branco como fallback
	stroke.Color = chach.Colors[colorName] or Color3.new(1, 1, 1)
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
	stroke.Color = chach.Colors.White
	stroke.Parent = instance

	local gradient = Instance.new("UIGradient")
	gradient.Rotation = 0
	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0.0, chach.Colors[cor1]),
		ColorSequenceKeypoint.new(0.5, chach.Colors[cor2]),
		ColorSequenceKeypoint.new(1.0, chach.Colors[cor3])
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





function chach.applyAutoScrolling(instance, padding, alignment)
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


local UserInputService = game:GetService("UserInputService")

function chach.applyDraggable(frame, dragButton)
	local dragging, dragStart, startPos

	dragButton.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
		end
	end)

	dragButton.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)

	dragButton.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
end


-- Criar a janela principal com abas
function chach.TabsWindow(list)
	local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = list.Title or "TabsWindow"
	screenGui.Parent = PlayerGui

	local frame = Instance.new("Frame")
	frame.Size = list.Size or UDim2.new(0, 400, 0, 300)
	frame.AnchorPoint = Vector2.new(0.5, 0.5) -- centralizado
	frame.Position = UDim2.new(0.5, 0, 0.5, 0)
	frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	frame.BackgroundTransparency = 0.2
	frame.Parent = screenGui
	
	

	-- Top bar (Título + Botão)
	local top_frame = Instance.new("Frame")
	top_frame.Size = UDim2.new(1, 0, 0, 30)
	top_frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	top_frame.Parent = frame
	chach.applyCorner(top_frame)
	
	local imput_btn = Instance.new("TextButton")
	imput_btn.Size = UDim2.new(1, 0, 1, 0)
	imput_btn.BackgroundTransparency = 1
	imput_btn.Text = ""
	imput_btn.Parent = top_frame

	-- Aplicar drag de verdade
	chach.applyDraggable(frame, imput_btn)

	
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -40, 1, 0) -- espaço para botão
	title.AnchorPoint = Vector2.new(0.5, 0.5)
	title.Position = UDim2.new(0.5, 0, 0.5, 0)
	title.Text = list.Text or "TabsWindow"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.BackgroundTransparency = 1
	title.Parent = top_frame

	local Btn_On_Off = Instance.new("ImageButton")
	Btn_On_Off.Image = chach.Icons.fa_bx_right_arrow
	Btn_On_Off.Size = UDim2.new(0, 20, 0, 20)
	Btn_On_Off.AnchorPoint = Vector2.new(0.5, 0.5)
	Btn_On_Off.BackgroundTransparency = 1
	Btn_On_Off.Position = UDim2.new(0.05, 0, 0.5, 0) 
	Btn_On_Off.Rotation = 90
	Btn_On_Off.Parent = top_frame
	chach.applyCorner(Btn_On_Off)

	-- Barra das abas (TopTabs) abaixo do TopBar
	local top_Tabs = Instance.new("ScrollingFrame")
	top_Tabs.Size = UDim2.new(1, 0, 0, 30)
	top_Tabs.Position = UDim2.new(0, 0, 0, 30)
	top_Tabs.BackgroundTransparency = 1
	top_Tabs.ScrollBarThickness = 6
	top_Tabs.HorizontalScrollBarInset = Enum.ScrollBarInset.Always
	top_Tabs.Parent = frame

	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Horizontal
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	layout.Parent = top_Tabs

	layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		top_Tabs.CanvasSize = UDim2.new(0, layout.AbsoluteContentSize.X + 10, 0, 0)
	end)

	-- Container para conteúdo das abas
	local tabContainer = Instance.new("Frame")
	tabContainer.Size = UDim2.new(1, 0, 1, -60)
	tabContainer.Position = UDim2.new(0, 0, 0, 60)
	tabContainer.BackgroundTransparency = 1
	tabContainer.Parent = frame

	local minimized = false
	Btn_On_Off.MouseButton1Click:Connect(function()
		minimized = not minimized
		frame.Size = minimized and UDim2.new(0, 200, 0, 30) or (list.Size or UDim2.new(0, 400, 0, 300))
		frame.BackgroundTransparency = minimized and 1 or 0.2
		top_Tabs.Visible = not minimized
		tabContainer.Visible = not minimized
		Btn_On_Off.Rotation = minimized and 0 or 90
	end)

	return {Frame = frame, TopBar = top_frame, TopTabs = top_Tabs, TabContainer = tabContainer, Tabs = {}}
end

function chach.SubTabsWindow(Scroll, list)
	local text = list.Text or "SubWindow"
	local c = chach.Colors
	local color = c[list.Color] or Color3.fromRGB(255,255,255)
	local tabs = list.Table or {"Default"}

	-- Container principal
	local frame = Instance.new("Frame")
	frame.Size = list.Size or UDim2.new(1, -10, 0, 220)
	frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	frame.BackgroundTransparency = 0.1
	frame.BorderSizePixel = 0
	frame.Parent = Scroll
	chach.applyCorner(frame)

	-- Barra de título
	local top_frame = Instance.new("Frame")
	top_frame.Size = UDim2.new(1, 0, 0, 25)
	top_frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	top_frame.Parent = frame
	chach.applyCorner(top_frame)

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -30, 1, 0)
	title.Position = UDim2.new(0, 30, 0, 0)
	title.Text = text
	title.TextColor3 = color
	title.BackgroundTransparency = 1
	title.Font = Enum.Font.SourceSans
	title.TextSize = 18
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = top_frame

	-- Minimizar
	local Btn_On_Off = Instance.new("ImageButton")
	Btn_On_Off.Image = chach.Icons.fa_bx_right_arrow
	Btn_On_Off.Size = UDim2.new(0, 20, 0, 20)
	Btn_On_Off.AnchorPoint = Vector2.new(0.5, 0.5)
	Btn_On_Off.BackgroundTransparency = 1
	Btn_On_Off.Position = UDim2.new(0.05, 0, 0.5, 0) 
	Btn_On_Off.Rotation = 90
	Btn_On_Off.Parent = top_frame

	-- Aba de botões (mini-tabs)
	local tabBar = Instance.new("Frame")
	tabBar.Size = UDim2.new(1, -10, 0, 25)
	tabBar.Position = UDim2.new(0, 5, 0, 30)
	tabBar.BackgroundTransparency = 1
	tabBar.Parent = frame

	local tabLayout = Instance.new("UIListLayout")
	tabLayout.FillDirection = Enum.FillDirection.Horizontal
	tabLayout.Padding = UDim.new(0, 5)
	tabLayout.Parent = tabBar

	-- Conteúdos de cada tab
	local tabContents = {}

	-- Criar as mini-tabs
	local activeTab
	for _, tabName in ipairs(tabs) do
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(0, 80, 1, 0)
		btn.Text = tabName
		btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
		btn.TextColor3 = Color3.fromRGB(200,200,200)
		btn.Font = Enum.Font.SourceSans
		btn.TextSize = 16
		btn.AutoButtonColor = true
		btn.Parent = tabBar
		chach.applyCorner(btn)

		-- ScrollingFrame para essa tab
		local content = Instance.new("ScrollingFrame")
		content.Size = UDim2.new(1, -10, 1, -65)
		content.Position = UDim2.new(0, 5, 0, 60)
		content.BackgroundTransparency = 1
		content.ScrollBarThickness = 5
		content.Visible = false
		content.Parent = frame

		local layout = Instance.new("UIListLayout")
		layout.Padding = UDim.new(0, 5)
		layout.Parent = content

		layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			content.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
		end)

		tabContents[tabName] = content

		-- Evento de troca de tab
		btn.MouseButton1Click:Connect(function()
			if activeTab then
				tabContents[activeTab].Visible = false
			end
			activeTab = tabName
			content.Visible = true
		end)
	end

	-- Ativar a primeira tab por padrão
	if tabs[1] then
		activeTab = tabs[1]
		tabContents[activeTab].Visible = true
	end

	-- Minimizar todo o subwindow
	local minimized = false
	Btn_On_Off.MouseButton1Click:Connect(function()
		minimized = not minimized
		for _, content in pairs(tabContents) do
			content.Visible = not minimized and (activeTab and content == tabContents[activeTab])
		end
		tabBar.Visible = not minimized
		frame.Size = minimized and UDim2.new(1, -10, 0, 30) or (list.Size or UDim2.new(1, -10, 0, 220))
		Btn_On_Off.Rotation = minimized and 0 or 90
	end)

	return tabContents
end



-- Criar uma aba dentro da janela
function chach.CreateTab(window, list)
	local tabName = list.Name or "Tab"
	local container = window.TabContainer

	local tabFrame = Instance.new("Frame")
	tabFrame.Size = UDim2.new(1, 0, 1, 0)
	tabFrame.BackgroundTransparency = 1
	tabFrame.Visible = false
	tabFrame.Parent = container

	local scroll = Instance.new("ScrollingFrame")
	scroll.Size = UDim2.new(1, -15, 1, -20)
	scroll.Position = UDim2.new(0, 10, 0, 10)
	scroll.ScrollBarThickness = 5
	scroll.BackgroundTransparency = 1
	scroll.Parent = tabFrame

	chach.applyAutoScrolling(scroll)

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 80, 1, 0)
	btn.AnchorPoint = Vector2.new(0, 0) -- esquerda superior
	btn.Text = tabName
	btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Parent = window.TopTabs
	chach.applyCorner(btn)

	-- Salvar aba
	window.Tabs[tabName] = {Frame = tabFrame, Scroll = scroll, Button = btn}

	-- Mostrar a primeira aba automaticamente
	local anyVisible = false
	for _, t in pairs(window.Tabs) do
		if t.Frame.Visible then
			anyVisible = true
			break
		end
	end
	if not anyVisible then
		tabFrame.Visible = true
		btn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
	end

	local function updateButtons()
		for _, t in pairs(window.Tabs) do
			if t.Frame.Visible then
				t.Button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
			else
				t.Button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
			end
		end
	end

	btn.MouseButton1Click:Connect(function()
		for _, t in pairs(window.Tabs) do
			t.Frame.Visible = false
		end
		tabFrame.Visible = true
		updateButtons()
	end)

	return scroll
end

function chach.CreateSubTab(Scroll, list)
	local text = list.Text or "SubTab"
	local tableItems = list.Table or {}
	local c = chach.Colors
	local color = c[list.Color] or Color3.fromRGB(255,255,255)

	-- Frame principal da SubTab
	local subFrame = Instance.new("Frame")
	subFrame.Size = UDim2.new(1, -10, 0, 30)
	subFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
	subFrame.BackgroundTransparency = 0.1
	subFrame.BorderSizePixel = 0
	subFrame.Parent = Scroll
	chach.applyCorner(subFrame)

	-- Botão de expandir/recolher
	local Btn_On_Off = Instance.new("ImageButton")
	Btn_On_Off.Image = chach.Icons.fa_bx_right_arrow
	Btn_On_Off.Size = UDim2.new(0, 20, 0, 20)
	Btn_On_Off.Position = UDim2.new(0, 5, 0.5, 0)
	Btn_On_Off.AnchorPoint = Vector2.new(0, 0.5)
	Btn_On_Off.BackgroundTransparency = 1
	Btn_On_Off.Rotation = 90
	Btn_On_Off.Parent = subFrame

	-- Título
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -30, 1, 0)
	label.Position = UDim2.new(0, 30, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.Font = Enum.Font.SourceSans
	label.TextSize = 18
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextColor3 = color
	label.Parent = subFrame

	-- Conteúdo (onde ficam os itens da subtab)
	local content = Instance.new("Frame")
	content.Size = UDim2.new(1, -20, 0, 0)
	content.Position = UDim2.new(0, 10, 0, 35)
	content.BackgroundTransparency = 1
	content.Visible = true
	content.Parent = Scroll

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 5)
	layout.Parent = content

	-- Se quiser, pode criar labels básicos
	for _, itemName in ipairs(tableItems) do
		local item = Instance.new("TextLabel")
		item.Size = UDim2.new(1, 0, 0, 25)
		item.BackgroundTransparency = 1
		item.Text = itemName
		item.TextColor3 = Color3.fromRGB(200,200,200)
		item.Font = Enum.Font.SourceSans
		item.TextSize = 16
		item.TextXAlignment = Enum.TextXAlignment.Left
		item.Parent = content
	end

	-- Atualizar tamanho automático
	layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		content.Size = UDim2.new(1, -20, 0, layout.AbsoluteContentSize.Y)
	end)

	-- Lógica de expandir/recolher
	local minimized = false
	Btn_On_Off.MouseButton1Click:Connect(function()
		minimized = not minimized
		content.Visible = not minimized
		Btn_On_Off.Rotation = minimized and 0 or 90
	end)

	-- 🔥 Retornar só o `content` para poder usar diretamente em Sliders, Checkbox etc.
	return content
end



function chach.CreateLabel(Scroll, list)
	local text = list.Text or "Label"
	local c = chach.Colors
	local color = c[list.Color] or Color3.fromRGB(255, 255, 255)

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 25)
	label.BackgroundTransparency = 1
	label.TextColor3 = color
	label.Text = text
	label.Font = Enum.Font.SourceSans
	label.TextSize = 18
	label.TextWrapped = true -- 🔥 permite quebra de linha
	label.TextXAlignment = Enum.TextXAlignment[list.Alignment] or Enum.TextXAlignment.Left
	label.TextYAlignment = Enum.TextYAlignment.Top -- garante alinhamento correto
	label.AutomaticSize = Enum.AutomaticSize.Y -- 🔥 ajusta altura automaticamente
	label.Parent = Scroll

	return label
end

-- Checkbox
function chach.CreateCheckboxe(Scroll, list, callback)
	local text = list.Text or "Checkbox"
	local color = chach.Colors[list.Color] or Color3.fromRGB(255,255,255)

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1,0,0,25)
	frame.BackgroundTransparency = 1
	frame.Parent = Scroll

	local box = Instance.new("Frame")
	box.Size = UDim2.new(0,20,0,20)
	box.Position = UDim2.new(0,5,0.5,0)
	box.AnchorPoint = Vector2.new(0,0.5)
	box.BackgroundColor3 = Color3.fromRGB(50,50,50)
	box.BorderSizePixel = 0
	box.Parent = frame
	chach.applyCorner(box)

	local check = Instance.new("TextLabel")
	check.Size = UDim2.new(1,0,1,0)
	check.BackgroundTransparency = 1
	check.Text = "✔"
	check.TextColor3 = Color3.fromRGB(0,170,255)
	check.Visible = false
	check.Font = Enum.Font.SourceSansBold
	check.TextSize = 18
	check.Parent = box

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1,-30,1,0)
	label.Position = UDim2.new(0,30,0,0)
	label.BackgroundTransparency = 1
	label.TextColor3 = color
	label.Text = text
	label.Font = Enum.Font.SourceSans
	label.TextSize = 18
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = frame

	local checked = false
	local function toggle()
		checked = not checked
		check.Visible = checked
		if callback then callback(checked) end
	end

	local function inputHandler(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			toggle()
		end
	end

	box.InputBegan:Connect(inputHandler)
	label.InputBegan:Connect(inputHandler)

	return {
		Frame = frame,
		Box = box,
		Label = label,
		Get = function() return checked end,
		Set = function(val)
			checked = val
			check.Visible = checked
		end
	}
end

-- Togglebox
function chach.CreateToggleboxe(Scroll, list, callback)
	local text = list.Text or "Toggle"
	local color = chach.Colors[list.Color] or Color3.fromRGB(255,255,255)

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1,0,0,25)
	frame.BackgroundTransparency = 1
	frame.Parent = Scroll

	local toggleIcon = Instance.new("ImageLabel")
	toggleIcon.Size = UDim2.new(0,20,0,20)
	toggleIcon.Position = UDim2.new(0,5,0.5,0)
	toggleIcon.AnchorPoint = Vector2.new(0,0.5)
	toggleIcon.BackgroundTransparency = 1
	toggleIcon.Image = chach.Icons.fa_rr_toggle_left
	toggleIcon.Parent = frame

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1,-30,1,0)
	label.Position = UDim2.new(0,30,0,0)
	label.BackgroundTransparency = 1
	label.TextColor3 = color
	label.Text = text
	label.Font = Enum.Font.SourceSans
	label.TextSize = 18
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = frame

	local toggled = false
	local function updateIcon()
		toggleIcon.Image = toggled and chach.Icons.fa_rr_toggle_right or chach.Icons.fa_rr_toggle_left
	end

	local function toggle()
		toggled = not toggled
		updateIcon()
		if callback then callback(toggled) end
	end

	local function inputHandler(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			toggle()
		end
	end

	toggleIcon.InputBegan:Connect(inputHandler)
	label.InputBegan:Connect(inputHandler)

	return {
		Frame = frame,
		Icon = toggleIcon,
		Label = label,
		Get = function() return toggled end,
		Set = function(val)
			toggled = val
			updateIcon()
		end
	}
end

-- Slider (Float)
function chach.CreateSliderFloat(Scroll, list, callback)
	local text = list.Text or "Slider"
	local color = chach.Colors[list.Color] or Color3.fromRGB(255,255,255)

	local min = list.Minimum or 0
	local max = list.Maximum or 1
	local value = list.Value or min

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1,0,0,45)
	frame.BackgroundTransparency = 1
	frame.Parent = Scroll

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1,0,0,20)
	label.BackgroundTransparency = 1
	label.TextColor3 = color
	label.Text = text .. ": " .. tostring(value)
	label.Font = Enum.Font.SourceSans
	label.TextSize = 18
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = frame

	local bar = Instance.new("Frame")
	bar.Size = UDim2.new(1,-20,0,8)
	bar.Position = UDim2.new(0,10,0,30)
	bar.BackgroundColor3 = Color3.fromRGB(60,60,60)
	bar.BorderSizePixel = 0
	bar.Parent = frame
	chach.applyCorner(bar)

	local fill = Instance.new("Frame")
	fill.Size = UDim2.new((value-min)/(max-min),0,1,0)
	fill.BackgroundColor3 = Color3.fromRGB(0,170,255)
	fill.BorderSizePixel = 0
	fill.Parent = bar
	chach.applyCorner(fill)

	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0,12,0,12)
	knob.Position = UDim2.new((value-min)/(max-min),0,0.5,0)
	knob.AnchorPoint = Vector2.new(0.5,0.5)
	knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
	knob.BorderSizePixel = 0
	knob.Parent = bar
	chach.applyCorner(knob)

	local uis = game:GetService("UserInputService")
	local dragging = false

	local function update(inputX)
		local relative = math.clamp((inputX - bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
		value = math.floor((min + (max-min)*relative)*100)/100
		fill.Size = UDim2.new(relative,0,1,0)
		knob.Position = UDim2.new(relative,0,0.5,0)
		label.Text = text .. ": " .. tostring(value)
		if callback then callback(value) end
	end

	local function dragStart(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
		end
	end

	local function dragEnd(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end

	local function dragMove(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			update(input.Position.X)
		end
	end

	knob.InputBegan:Connect(dragStart)
	uis.InputEnded:Connect(dragEnd)
	uis.InputChanged:Connect(dragMove)
	bar.InputBegan:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then update(input.Position.X) end end)

	return {
		Frame = frame,
		Label = label,
		Get = function() return value end,
		Set = function(val)
			value = math.clamp(val,min,max)
			local relative = (value-min)/(max-min)
			fill.Size = UDim2.new(relative,0,1,0)
			knob.Position = UDim2.new(relative,0,0.5,0)
			label.Text = text .. ": " .. tostring(value)
		end
	}
end

-- Slider (Int)
function chach.CreateSliderInt(Scroll, list, callback)
	local slider = chach.CreateSliderFloat(Scroll, list, function(v)
		if callback then callback(math.floor(v+0.5)) end
	end)
	return slider
end

function chach.Notifications(Gui, list, callback)
	local StarterGui = game:GetService("StarterGui")

	local title = list.Title or "Aviso"
	local text = list.Text or ""
	local tempo = list.Tempo or 5
	local dt_Icons = chach.Icons
	local icon = dt_Icons[list.Icon ]or ""

	-- Se for um assetid numérico, transforma em thumbnail
	local finalIcon = ""
	if icon ~= "" then
		local cleanIcon = tostring(icon):gsub("%D", "") -- mantém só números
		if cleanIcon ~= "" then
			finalIcon = "rbxthumb://type=Asset&id=" .. cleanIcon .. "&w=150&h=150"
		else
			-- pode ser que o dev passou já algo pronto (ex: rbxassetid://123)
			finalIcon = icon
		end
	end

	-- Mostra notificação
	StarterGui:SetCore("SendNotification", {
		Title = title,
		Text = text,
		Icon = finalIcon,
		Duration = tempo
	})

	-- Callback opcional
	if callback then
		callback(true)
	end
end



return chach
