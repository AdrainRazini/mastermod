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
		local humanoid = npc:FindFirstChildOfClass("Humanoid")
		if humanoid and humanoid.Name == "NPC" then
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
G1L["ScreenGui"] = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
G1L["ScreenGui"].Name = NAME_MOD


-- Criar TextLabel de teste
G1L["test_lb"] = Instance.new("TextLabel")
G1L["test_lb"].Name = "TestLabel"
G1L["test_lb"].Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui") -- ou o Frame principal da sua GUI
G1L["test_lb"].Size = UDim2.new(0, 200, 0, 50)
G1L["test_lb"].Position = UDim2.new(0.5, -100, 0.1, 0) -- centralizado horizontalmente
G1L["test_lb"].BackgroundColor3 = Color3.fromRGB(30, 30, 30)
G1L["test_lb"].TextColor3 = Color3.fromRGB(255, 255, 255)
G1L["test_lb"].Font = Enum.Font.SourceSansBold
G1L["test_lb"].TextSize = 20
G1L["test_lb"].Text = "NPCs encontrados: 0"

local function atualizarNPCs()
	local nomes = {}
	for _, npc in ipairs(Npcs_List) do
		table.insert(nomes, npc.Name)
	end
	G1L["test_lb"].Text = "NPCs: " .. table.concat(nomes, ", ")
end

atualizarNPCs()
