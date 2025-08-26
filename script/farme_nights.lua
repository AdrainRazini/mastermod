local GITHUB_REPO = "Mastermod"
local Owner = "Adrian75556435"
local NAME_MOD = "99 nights in the forest"

local VIM = game:GetService("VirtualInputManager")
local UIS = game:GetService("UserInputService")

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local player = Players.LocalPlayer
-- Estruturas principais
local G1L, G2L, G3L, G4L, G5L = {}, {}, {}, {}, {}

-- Módulos/categorias
local Farmes, Player, Lights, Games = {}, {}, {}, {}
local List_Mods = {Farmes, Player, Lights, Games}


local icons = {
	fa_bx_mastermods = "rbxassetid://102637810511338", -- Logo do meu mod
	fa_rr_toggle_left = "rbxassetid://118353432570896", -- Off
	fa_rr_toggle_right = "rbxassetid://136961682267523", -- On
	fa_rr_information = "rbxassetid://99073088081563", -- Info
	fa_bx_code_start = "rbxassetid://107895739450188", -- <>
	fa_bx_code_end = "rbxassetid://106185292775972", -- </>
	fa_bx_config = "rbxassetid://95026906912083", -- ●
	fa_bx_loader = "rbxassetid://123191542300310", -- loading
}


--============= Extração de Itens ===============--
local Itens_Workspace = Workspace:WaitForChild("Items")
local Itens_List = Itens_Workspace:GetChildren()
local Farmes_List = {}

for _, farm in ipairs(Itens_List) do
	if farm:IsA("Model") then
		table.insert(Farmes_List, farm)
	end
end
--===============================================--

--============= Extração de Npcs ===============--
local Characters = Workspace:WaitForChild("Characters")
local Characters_List = Characters:GetChildren()
local Npcs_List = {}

for _, npc in ipairs(Characters_List) do
	if npc:IsA("Model") then
		-- Procura qualquer Humanoid dentro do modelo
		local humanoid = npc:FindFirstChildOfClass("Humanoid")
		if humanoid then
			table.insert(Npcs_List, npc)
		end
	end
end

-- Exibe nomes dos NPCs encontrados
for _, npc in ipairs(Npcs_List) do
	print("NPC encontrado:", npc.Name)
end

-- Lista de NPCs que precisam de "fix"
local Fix_Npcs = {"Bunny", "Wolf"}


--===============================================--

-- GUI principal
G1L["ScreenGui"] = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
G1L["ScreenGui"].Name = NAME_MOD

-- Frame principal de módulos
G1L["Frame_Mod"] = Instance.new("ScrollingFrame", G1L["ScreenGui"])
G1L["Frame_Mod"].Size = UDim2.new(0.2, 0, 0.6, 0)
G1L["Frame_Mod"].Position = UDim2.new(0.7, 0, 0.2, 0)
G1L["Frame_Mod"].BackgroundColor3 = Color3.fromRGB(25, 25, 25)
G1L["Frame_Mod"].BorderSizePixel = 0
G1L["Frame_Mod"].Visible = true
G1L["Frame_Mod"].CanvasSize = UDim2.new(0, 0, 0, 0) -- inicial

-- Layout vertical para empilhar títulos
local modListLayout = Instance.new("UIListLayout", G1L["Frame_Mod"])
modListLayout.FillDirection = Enum.FillDirection.Vertical
modListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
modListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
modListLayout.SortOrder = Enum.SortOrder.LayoutOrder
modListLayout.Padding = UDim.new(0, 10) -- espaçamento entre títulos

-- Atualiza CanvasSize automaticamente
modListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    G1L["Frame_Mod"].CanvasSize = UDim2.new(0, 0, 0, modListLayout.AbsoluteContentSize.Y)
end)

-- Frame rolável para listar NPCs
G1L["NpcFrame"] = Instance.new("ScrollingFrame", G1L["ScreenGui"])
G1L["NpcFrame"].Name = "NpcFrame"
G1L["NpcFrame"].Size = UDim2.new(0, 250, 0, 300)
G1L["NpcFrame"].Position = UDim2.new(0.05, 0, 0.1, 0)
G1L["NpcFrame"].BackgroundColor3 = Color3.fromRGB(25, 25, 25)
G1L["NpcFrame"].BorderSizePixel = 0
G1L["NpcFrame"].CanvasSize = UDim2.new(0, 0, 0, 0) -- ajustado dinamicamente
G1L["NpcFrame"].ScrollBarThickness = 6

-- Layout para organizar os NPCs em lista
local UIListLayout = Instance.new("UIListLayout", G1L["NpcFrame"])
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Função para criar um botão para cada NPC
local function criarNpcButton(npc)
	local btn = Instance.new("TextButton", G1L["NpcFrame"])
	btn.Name = npc.Name .. "_Btn"
	btn.Size = UDim2.new(1, 0, 0, 30)
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 18
	btn.Text = npc.Name

	btn.MouseButton1Click:Connect(function()
		local humanoidRoot = npc:FindFirstChild("HumanoidRootPart")
		if humanoidRoot then
			workspace.CurrentCamera.CameraSubject = humanoidRoot
			print("Focando em:", npc.Name)

			-- Cria botão flutuante na ScreenGui
			local floatingBtn = Instance.new("TextButton")
			floatingBtn.Size = UDim2.new(0, 120, 0, 40)
			floatingBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
			floatingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
			floatingBtn.Font = Enum.Font.SourceSansBold
			floatingBtn.TextSize = 14
			floatingBtn.Text = "Reset Camera ("..npc.Name..")"
			floatingBtn.Parent = G1L["ScreenGui"]

			-- Clique reseta a câmera
			floatingBtn.MouseButton1Click:Connect(function()
				local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
				if humanoid then
					workspace.CurrentCamera.CameraSubject = humanoid
					print("Câmera resetada para o player")
					floatingBtn:Destroy()
				end
			end)

			-- Atualiza posição do botão a cada frame
			local renderConn
			renderConn = game:GetService("RunService").RenderStepped:Connect(function()
				if humanoidRoot and floatingBtn.Parent then
					local cam = workspace.CurrentCamera
					local screenPos, onScreen = cam:WorldToViewportPoint(humanoidRoot.Position)
					if onScreen then
						floatingBtn.Position = UDim2.new(0, screenPos.X - floatingBtn.Size.X.Offset/2, 0, screenPos.Y - floatingBtn.Size.Y.Offset/2)
					else
						floatingBtn.Visible = false
					end
				else
					renderConn:Disconnect()
				end
			end)
		end
	end)
end


-- Função para atualizar lista de NPCs
local function atualizarNPCs()
	-- limpa botões antigos
	for _, child in ipairs(G1L["NpcFrame"]:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end

	-- cria botões para cada NPC
	for _, npc in ipairs(Npcs_List) do
		criarNpcButton(npc)
	end

	-- ajusta tamanho da rolagem
	G1L["NpcFrame"].CanvasSize = UDim2.new(0, 0, 0, #Npcs_List * 35)
end

-- chamada inicial
atualizarNPCs()

-- Função para verificar e adicionar NPC
local function addNpc(npc)
	if npc:IsA("Model") then
		local humanoid = npc:FindFirstChildOfClass("Humanoid")
		if humanoid and humanoid.Name == "NPC" then
			table.insert(Npcs_List, npc)
			atualizarNPCs()
			print("NPC adicionado:", npc.Name)
		end
	end
end

-- Função para remover NPC da lista
local function removeNpc(npc)
	for i, v in ipairs(Npcs_List) do
		if v == npc then
			table.remove(Npcs_List, i)
			atualizarNPCs()
			print("NPC removido:", npc.Name)
			break
		end
	end
end

-- Inicial: pega todos os que já existem
for _, npc in ipairs(Characters:GetChildren()) do
	addNpc(npc)
end

-- Eventos: acompanha mudanças em tempo real
Characters.ChildAdded:Connect(addNpc)
Characters.ChildRemoved:Connect(removeNpc)


-- =====================================
-- Botão para resetar câmera ao Player
-- =====================================


function Create_Titles(Name, Text, Retorno)
	local container_titles = Instance.new("Frame", G1L["Frame_Mod"])
	container_titles.Size = UDim2.new(0.9, 0, 0, 60)
	container_titles.BackgroundTransparency = 1

	-- Layout horizontal para título+observação e toggle
	local ly = Instance.new("UIListLayout", container_titles)
	ly.FillDirection = Enum.FillDirection.Horizontal
	ly.HorizontalAlignment = Enum.HorizontalAlignment.Left
	ly.VerticalAlignment = Enum.VerticalAlignment.Center
	ly.SortOrder = Enum.SortOrder.LayoutOrder
	ly.Padding = UDim.new(0.05, 0)

	-- Frame vertical para título e observação
	local textContainer = Instance.new("Frame", container_titles)
	textContainer.Size = UDim2.new(0.7, 0, 1, 0)
	textContainer.BackgroundTransparency = 1

	local verticalLy = Instance.new("UIListLayout", textContainer)
	verticalLy.FillDirection = Enum.FillDirection.Vertical
	verticalLy.HorizontalAlignment = Enum.HorizontalAlignment.Left
	verticalLy.VerticalAlignment = Enum.VerticalAlignment.Top
	verticalLy.SortOrder = Enum.SortOrder.LayoutOrder
	verticalLy.Padding = UDim.new(0, 2)

	-- Label do título
	local title_mod_Lb = Instance.new("TextLabel", textContainer)
	title_mod_Lb.Size = UDim2.new(1, 0, 0.6, 0)
	title_mod_Lb.BackgroundTransparency = 1
	title_mod_Lb.Text = Text
	title_mod_Lb.TextColor3 = Color3.fromRGB(255, 255, 255)
	title_mod_Lb.Font = Enum.Font.SourceSansBold
	title_mod_Lb.TextSize = 18
	title_mod_Lb.TextXAlignment = Enum.TextXAlignment.Left

	-- Observação abaixo do título
	local Obs = Instance.new("TextLabel", textContainer)
	Obs.Size = UDim2.new(1, 0, 0.4, 0)
	Obs.BackgroundTransparency = 1
	Obs.Text = "Text"
	Obs.Selectable = true
	Obs.TextColor3 = Color3.fromRGB(200, 200, 200)
	Obs.Font = Enum.Font.SourceSans
	Obs.TextSize = 14
	Obs.TextXAlignment = Enum.TextXAlignment.Left

	-- Toggle button à direita
	local toggle_btn = Instance.new("ImageButton", container_titles)
	toggle_btn.Size = UDim2.new(0.2, 0, 0.6, 0)
	toggle_btn.AnchorPoint = Vector2.new(0, 0.5)
	toggle_btn.Position = UDim2.new(0.8, 0, 0.5, 0)
	toggle_btn.Image = icons.fa_rr_toggle_left
	toggle_btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	toggle_btn.BackgroundTransparency = 0.85

	local toggled = false
	toggle_btn.MouseButton1Click:Connect(function()
		toggled = not toggled
		if toggled then
			toggle_btn.Image = icons.fa_rr_toggle_right
			toggle_btn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
		else
			toggle_btn.Image = icons.fa_rr_toggle_left
			toggle_btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		end

		if Retorno then
			Retorno(toggled)
		end
	end)
end


Create_Titles("Modelo", "Modelo", function(estado)
	if estado then
		print("Modelo ligado!")
	else
		print("Modelo desligado!")
	end
end)

Create_Titles("FlyMod", "Ativar Fly", function(estado)
	if estado then
		print("Fly ligado!")
	else
		print("Fly desligado!")
	end
end)

Create_Titles("Auto", "Ativar Auto Madeira", function(estado)
	if estado then
		print(" Auto Madeira ligado!")
	else
		print(" Auto Madeira desligado!")
	end
end)



