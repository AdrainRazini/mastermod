local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")
local GuiName = "Mod_Animal_Simulator_BoxMusic_" .. player.Name






-- URLs da API
local API_URL = "https://animal-simulator-server.vercel.app/api/musics"
local API_URL_Obj = "https://animal-simulator-server.vercel.app/api/musics_obj"
local API_URL_Obj_Lua = "https://animal-simulator-server.vercel.app/api/musics_obj_lua"

-- Função genérica para buscar de qualquer endpoint
local function GetFromAPI(url)
	local success, result = pcall(function()
		local response = game:HttpGet(url)
		return HttpService:JSONDecode(response)
	end)

	if success then
		print("✅ Dados carregados da API:", url, "Total:", #result)
		return result
	else
		warn("⚠️ Erro ao buscar dados da API:", url, result)
		return {}
	end
end

local function GetObjFromAPI(url)
	local success, result = pcall(function()
		local response = game:HttpGet(url)
		local data = HttpService:JSONDecode(response)

		-- Garante que cada item tenha chaves Name e Obj no formato correto
		local list = {}
		for _, item in pairs(data) do
			table.insert(list, {
				Name = tostring(item.Name),
				Obj = tostring(item.Obj)
			})
		end

		return list
	end)

	if success then
		print("✅ Dados carregados da API:", url, "Total:", #result)
		return result
	else
		warn("⚠️ Erro ao buscar dados da API:", url, result)
		return {}
	end
end

-- 🔹 Busca as duas listas
local Listaid = GetFromAPI(API_URL)
local listMusics = {}



local success, result = pcall(function()
	local response = game:HttpGet(API_URL_Obj_Lua)
	task.wait(0.5)
	return loadstring(response)() 
end)

if success and type(result) == "table" then
	listMusics = result
	print("✅ Músicas carregadas da API:", #listMusics)
else
	warn("⚠️ Falha ao carregar músicas da API, usando lista padrão.")
	listMusics = {
		{name = "Nill", Obj = 0},
	}
end



-- Carrega o módulo Regui
local Regui
-- 1️⃣ Tenta carregar localmente
local success, module = pcall(function()
	return require(script.Parent:FindFirstChild("Mod_UI"))
end)

if success and module then
	Regui = module
	print("[✅ Mod Loader] Carregado localmente com sucesso!")
else
	-- 2️⃣ Tenta baixar remoto
	local ok, code
	local urls = {
		"https://raw.githubusercontent.com/AdrainRazini/mastermod/refs/heads/main/module/dataGui.lua",
		"https://animal-simulator-server.vercel.app/lua/DataGui.lua"
	}

	for _, url in ipairs(urls) do
		local okHttp, result = pcall(function()
			return game:HttpGet(url)
		end)
		if okHttp and result and result ~= "" then
			code = result
			print("[🌐 Mod Loader] Código baixado de: " .. url)
			break
		else
			warn("[⚠️ Mod Loader] Falha ao baixar de:", url)
		end
	end

	-- 3️⃣ Executa o código remoto se baixado
	if code then
		local okLoad, result = pcall(function()
			return loadstring(code)() 
		end)
		if okLoad and result then
			Regui = result
			print("[✅ Mod Loader] Módulo remoto carregado com sucesso!")
		else
			warn("[❌ Mod Loader] Erro ao executar código remoto:", result)
		end
	else
		warn("[❌ Mod Loader] Nenhuma das fontes pôde ser carregada.")
	end
end

assert(Regui, "Regui não foi carregado!")



-- Impede duplicação da GUI
if PlayerGui:FindFirstChild(GuiName) then
	Regui.Notifications(PlayerGui, {Title="Alert", Text="Neutralized Code", Icon="fa_rr_information", Tempo=10})
	return
end

-- Configuração de som via evento remoto
local playEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("PLAYEvent")

-- Índice da faixa atual
local currentIndex = 1
local isPlaying = false
local Loading = false

--==========================--
-- GUI PRINCIPAL
--==========================--
local GL1 = {}
local Data_Icon = Regui.Icons

GL1["Scren"] = Instance.new("ScreenGui")
GL1["Scren"].Parent = PlayerGui
GL1["Scren"].Name = GuiName

GL1["frame"] = Instance.new("Frame")
GL1["frame"].Parent = GL1["Scren"]
GL1["frame"].Size = UDim2.new(0, 360, 0, 150)
GL1["frame"].Position = UDim2.new(0.5, -180, 0.8, -65)
GL1["frame"].BackgroundColor3 = Color3.fromRGB(35, 35, 35)
GL1["frame"].BorderSizePixel = 0
GL1["frame"].BackgroundTransparency = 0.1

-- Cantos arredondados
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = GL1["frame"]

-- Sombras suaves
local shadow = Instance.new("ImageLabel")
shadow.Parent = GL1["frame"]
shadow.ZIndex = -1
shadow.Image = "rbxassetid://1316045217"
shadow.ImageTransparency = 0.6
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10,10,118,118)
shadow.Size = UDim2.new(1, 20, 1, 20)
shadow.Position = UDim2.new(0, -10, 0, -10)
shadow.BackgroundTransparency = 1

-- ==========================
-- 🔝 Top Bar
-- ==========================
GL1["TopBar"] = Instance.new("Frame")
GL1["TopBar"].Parent = GL1["frame"]
GL1["TopBar"].Size = UDim2.new(1, 0, 0, 28)
GL1["TopBar"].BackgroundColor3 = Color3.fromRGB(25, 25, 25)
GL1["TopBar"].BorderSizePixel = 0

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 10)
topCorner.Parent = GL1["TopBar"]

GL1["TopBar_Label"] = Instance.new("TextLabel")
GL1["TopBar_Label"].Parent = GL1["TopBar"]
GL1["TopBar_Label"].Size = UDim2.new(1, -60, 1, 0)
GL1["TopBar_Label"].Position = UDim2.new(0, 10, 0, 0)
GL1["TopBar_Label"].BackgroundTransparency = 1
GL1["TopBar_Label"].Text = "🎵 Player Music"
GL1["TopBar_Label"].TextColor3 = Color3.fromRGB(255, 255, 255)
GL1["TopBar_Label"].TextXAlignment = Enum.TextXAlignment.Left
GL1["TopBar_Label"].Font = Enum.Font.GothamBold
GL1["TopBar_Label"].TextScaled = true

-- Botão de minimizar
GL1["MinimizeBtn"] = Instance.new("TextButton")
GL1["MinimizeBtn"].Parent = GL1["TopBar"]
GL1["MinimizeBtn"].Size = UDim2.new(0, 25, 1, 0)
GL1["MinimizeBtn"].Position = UDim2.new(1, -25, 0, 0)
GL1["MinimizeBtn"].BackgroundColor3 = Color3.fromRGB(220, 60, 60)
GL1["MinimizeBtn"].Text = "-"
GL1["MinimizeBtn"].TextColor3 = Color3.fromRGB(255,255,255)
GL1["MinimizeBtn"].TextScaled = true
GL1["MinimizeBtn"].Font = Enum.Font.GothamBold

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 6)
btnCorner.Parent = GL1["MinimizeBtn"]

-- Botão lista lateral
GL1["MinimizeBtn_List"] = Instance.new("TextButton")
GL1["MinimizeBtn_List"].Parent = GL1["TopBar"]
GL1["MinimizeBtn_List"].Size = UDim2.new(0, 25, 1, 0)
GL1["MinimizeBtn_List"].Position = UDim2.new(1, -55, 0, 0)
GL1["MinimizeBtn_List"].BackgroundColor3 = Color3.fromRGB(70, 70, 200)
GL1["MinimizeBtn_List"].Text = "≡"
GL1["MinimizeBtn_List"].TextColor3 = Color3.fromRGB(255,255,255)
GL1["MinimizeBtn_List"].TextScaled = true
GL1["MinimizeBtn_List"].Font = Enum.Font.GothamBold

local btnCorner2 = Instance.new("UICorner")
btnCorner2.CornerRadius = UDim.new(0, 6)
btnCorner2.Parent = GL1["MinimizeBtn_List"]

-- ==========================
-- 🎵 Nome da música
-- ==========================
GL1["Name_id"] = Instance.new("TextLabel")
GL1["Name_id"].Parent = GL1["frame"]
GL1["Name_id"].Size = UDim2.new(1, -20, 0, 25)
GL1["Name_id"].Position = UDim2.new(0, 10, 0, 30)
GL1["Name_id"].BackgroundTransparency = 1
GL1["Name_id"].Text = "♪ Tocando: (nenhuma faixa)"
GL1["Name_id"].TextColor3 = Color3.fromRGB(255, 255, 255)
GL1["Name_id"].Font = Enum.Font.GothamSemibold
GL1["Name_id"].TextScaled = true
GL1["Name_id"].TextXAlignment = Enum.TextXAlignment.Left

-- ==========================
-- 💿 Ícone do CD
-- ==========================
GL1["CD_Icon"] = Instance.new("ImageLabel")
GL1["CD_Icon"].Parent = GL1["frame"]
GL1["CD_Icon"].Size = UDim2.new(0, 90, 0, 90)
GL1["CD_Icon"].Position = UDim2.new(0, 15, 0.5, -15)
GL1["CD_Icon"].Image = "rbxassetid://70716433051234"
GL1["CD_Icon"].BackgroundTransparency = 1

-- ==========================
-- ▶️ Botões de controle
-- ==========================
GL1["Input_Angle_L"] = Instance.new("ImageButton")
GL1["Input_Angle_L"].Parent = GL1["frame"]
GL1["Input_Angle_L"].Size = UDim2.new(0, 45, 0, 45)
GL1["Input_Angle_L"].Position = UDim2.new(0, 100, 0.5, 10)
GL1["Input_Angle_L"].BackgroundTransparency = 1
GL1["Input_Angle_L"].Image = Data_Icon.fa_rr_angle_left

GL1["Input_Bnt"] = Instance.new("ImageButton")
GL1["Input_Bnt"].Parent = GL1["frame"]
GL1["Input_Bnt"].Size = UDim2.new(0, 45, 0, 45)
GL1["Input_Bnt"].Position = UDim2.new(0, 140, 0.5, 10)
GL1["Input_Bnt"].BackgroundTransparency = 1
GL1["Input_Bnt"].Image = Data_Icon.fa_bx_play_circle

GL1["Input_Angle_R"] = Instance.new("ImageButton")
GL1["Input_Angle_R"].Parent = GL1["frame"]
GL1["Input_Angle_R"].Size = UDim2.new(0, 45, 0, 45)
GL1["Input_Angle_R"].Position = UDim2.new(0, 180, 0.5, 10)
GL1["Input_Angle_R"].BackgroundTransparency = 1
GL1["Input_Angle_R"].Rotation = 180
GL1["Input_Angle_R"].Image = Data_Icon.fa_rr_angle_left

-- ==========================
-- 📜 Frame lateral (lista)
-- ==========================
GL1["frame_List"] = Instance.new("Frame")
GL1["frame_List"].Parent = GL1["frame"]
GL1["frame_List"].Size = UDim2.new(0, 160, 1, 0)
GL1["frame_List"].Position = UDim2.new(1, 8, 0, 0)
GL1["frame_List"].BackgroundColor3 = Color3.fromRGB(45, 45, 45)
GL1["frame_List"].BorderSizePixel = 0
GL1["frame_List"].Visible = false

local listCorner = Instance.new("UICorner")
listCorner.CornerRadius = UDim.new(0, 10)
listCorner.Parent = GL1["frame_List"]

GL1["Loading_Icon"] = Instance.new("ImageLabel")
GL1["Loading_Icon"].Parent = GL1["frame_List"]
GL1["Loading_Icon"].Size = UDim2.new(0, 80, 0, 80)
GL1["Loading_Icon"].AnchorPoint = Vector2.new(0.5, 0.5)
GL1["Loading_Icon"].Position = UDim2.new(0.5, 0, 0.5, 0)
GL1["Loading_Icon"].Image = Data_Icon.fa_bx_loader
GL1["Loading_Icon"].BackgroundTransparency = 1



--==========================--
-- FUNÇÕES PRINCIPAIS
--==========================--

local function playCurrentTrack(selectedObj)
	local id

	-- Se veio do seletor, use o ID dele
	if selectedObj then
		id = selectedObj
	else
		-- Caso contrário, use o índice atual
		id = Listaid[currentIndex]
	end

	if not id then return end

	-- Envia para o servidor tocar a música
	playEvent:FireServer(id)

	-- Busca informações da música no catálogo Roblox
	local success, info = pcall(function()
		return MarketplaceService:GetProductInfo(id)
	end)

	-- Atualiza o texto do rótulo
	if success and info and info.Name then
		GL1["Name_id"].Text = "♪ Tocando: " .. info.Name
	else
		GL1["Name_id"].Text = "♪ Tocando: Faixa " .. tostring(currentIndex)
	end

	isPlaying = true
	GL1["Input_Bnt"].Image = Data_Icon.fa_bx_pause_circle
end


local function pauseTrack()
	playEvent:FireServer("0") -- Envia sinal para parar o som
	GL1["Name_id"].Text = "⏸️ Pausado"
	isPlaying = false
	GL1["Input_Bnt"].Image = Data_Icon.fa_bx_play_circle
end


-- Clique Play/Pause
GL1["Input_Bnt"].MouseButton1Click:Connect(function()
	if isPlaying then
		pauseTrack()
	else
		playCurrentTrack()
	end
end)

-- Botão anterior
GL1["Input_Angle_L"].MouseButton1Click:Connect(function()
	currentIndex -= 1
	if currentIndex < 1 then
		currentIndex = #Listaid
	end
	playCurrentTrack()
end)

-- Botão próxima
GL1["Input_Angle_R"].MouseButton1Click:Connect(function()
	currentIndex += 1
	if currentIndex > #Listaid then
		currentIndex = 1
	end
	playCurrentTrack()
end)


local isMinimized = false
local isMinimized_L = true

-- Minimizar o player inteiro
-- Minimizar o player inteiro
GL1["MinimizeBtn"].MouseButton1Click:Connect(function()
	isMinimized = not isMinimized
	GL1["CD_Icon"].Visible = not isMinimized
	GL1["Input_Angle_L"].Visible = not isMinimized
	GL1["Input_Bnt"].Visible = not isMinimized
	GL1["Input_Angle_R"].Visible = not isMinimized
	GL1["Name_id"].Visible = not isMinimized

	if isMinimized then
		GL1["frame"]:TweenSize(UDim2.new(0, 360, 0, 28), "Out", "Sine", 0.25, true)
	else
		GL1["frame"]:TweenSize(UDim2.new(0, 360, 0, 150), "Out", "Sine", 0.25, true)
	end
end)

-- Minimizar apenas a lista lateral
GL1["MinimizeBtn_List"].MouseButton1Click:Connect(function()
	isMinimized_L = not isMinimized_L

if isMinimized_L then
		GL1["frame_List"]:TweenSize(UDim2.new(0, 25, 1, 0), "Out", "Sine", 0.25, true)
	else
		GL1["frame_List"]:TweenSize(UDim2.new(0, 180, 0, 150), "Out", "Sine", 0.25, true)
	end
	
	GL1["frame_List"].Visible = not isMinimized_L
end)

--==========================--
-- EFEITOS VISUAIS
--==========================--
Regui.applyCorner(GL1["frame"])
Regui.applyDraggable(GL1["frame"], GL1["frame"])

-- Hover
local function applyHover(button)
	button.MouseEnter:Connect(function()
		button.ImageTransparency = 0.2
	end)
	button.MouseLeave:Connect(function()
		button.ImageTransparency = 0
	end)
end

applyHover(GL1["Input_Bnt"])
applyHover(GL1["Input_Angle_L"])
applyHover(GL1["Input_Angle_R"])

-- Rotação do CD
RunService.RenderStepped:Connect(function(dt)
	-- Rotação do CD
	if isPlaying then
		GL1["CD_Icon"].Rotation = (GL1["CD_Icon"].Rotation + dt * 60) % 360
	end

	-- Rotação do Loading
	if Loading then
		GL1["Loading_Icon"].Visible = true
		GL1["Loading_Icon"].Rotation = (GL1["Loading_Icon"].Rotation + dt * 120) % 360 -- você pode deixar mais rápido que o CD
		GL1["frame_List"].Transparency = 1
	else
		GL1["Loading_Icon"].Visible = false
	end
end)


-- Função para criar a lista de nomes
function getnamesbox(list)
	local existingIds = {}

	-- Marca todos os IDs já existentes em listMusics
	for _, music in ipairs(listMusics) do
		existingIds[music.Obj] = true
	end

	-- Processa novos IDs, evitando duplicatas
	for _, id in ipairs(list) do
		if not existingIds[tostring(id)] then
			local success, info = pcall(function()
				return MarketplaceService:GetProductInfo(id)
			end)

			local newMusic = {}
			if success and info then
				newMusic = {name = info.Name, Obj = tostring(id)}
			else
				newMusic = {name = "???", Obj = tostring(id)}
			end

			table.insert(listMusics, newMusic)        -- adiciona direto na lista principal
			existingIds[tostring(id)] = true          -- marca como existente
		end
	end

	return listMusics -- retorna a lista atualizada
end

-- Preenche a lista
local Lista_N
task.spawn(function()
	Loading = true
	Lista_N = getnamesbox(Listaid)

	-- Agora que a lista está pronta, cria o seletor
	local selectorMusics = Regui.CreateSelectorOpitions(GL1["frame_List"], {
		Name = "Selecionar Música",
		Options = Lista_N,
		Type = "Instance",
		Size_Frame = UDim2.new(1, 0, 0, 150)
	}, function(selectedObj)
		playCurrentTrack(selectedObj)
	end)
	Loading = false
end)
