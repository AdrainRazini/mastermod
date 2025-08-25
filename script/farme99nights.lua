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
	if npc:IsA("Model") and npc:FindFirstChild("Humanoid") then
		table.insert(Npcs_List, npc)
	end
end

-- Exibe nomes dos NPCs encontrados
for _, npc in ipairs(Npcs_List) do
	print("NPC encontrado:", npc.Name)
end

-- Lista de NPCs que precisam de "fix"
local Fix_Npcs = {"Bunny", "Wolf"}
--===============================================--
