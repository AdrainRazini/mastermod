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
--[[
local resetBtn = Instance.new("TextButton", G1L["ScreenGui"])
resetBtn.Name = "ResetCameraBtn"
resetBtn.Size = UDim2.new(0, 150, 0, 40)
resetBtn.Position = UDim2.new(0.05, 0, 0.75, 0)
resetBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
resetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
resetBtn.Font = Enum.Font.SourceSansBold
resetBtn.TextSize = 20
resetBtn.Text = "Voltar ao Player"

resetBtn.MouseButton1Click:Connect(function()
	local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
	if humanoid then
		workspace.CurrentCamera.CameraSubject = humanoid
		print("Câmera resetada para o player")
	end
end)
]]