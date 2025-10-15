local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local Regui
local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
local GuiName = "Mod_Animal_Simulator"..game.Players.LocalPlayer.Name



-- Tenta carregar localmente
local success, module = pcall(function()
	return require(script.Parent:FindFirstChild("Mod_UI"))
end)

if success and module then
	Regui = module
else
	-- Tenta baixar remoto
	local HttpService = game:GetService("HttpService")
	local ok, err = pcall(function()
		local code = game:HttpGet("https://raw.githubusercontent.com/AdrainRazini/mastermod/refs/heads/main/module/dataGui.lua")
		Regui = loadstring(code)()
	end)

	if not ok then
		warn("Não foi possível carregar Mod_UI nem local nem remoto!", err)
	end
end

assert(Regui, "Regui não foi carregado!")


if PlayerGui:FindFirstChild(GuiName) then
	Regui.Notifications(PlayerGui, {Title="Alert", Text="Neutralized Code", Icon="fa_rr_information", Tempo=10})
	return
end


--====================================================================================================================--

local AF = {
	FarmOrb = false,
	FarmFastOrb = false,
	FarmOrbs = false,
	AutoRebirt = false,
	AutoHoops = false,
	Hoops_Pull = false,
	Hoops_Teleport = false,
	AutoDeleted = false,
	AutoDeleted_Sequence = false,
	AutoBuyPets = false
}

local AF_Timer = {
	FarmOrb_Timer = 0.1,
	FarmFastOrb_Timer = 0,
	FarmOrbs_Timer = 0.1,
	AutoRebirt_Timer = 1,
	AutoHoops_Timer = 0.01,
	AutoBuyPets_Timer = 1

}
local Val_Orb = "Red Orb"

--===================--
-- Fuctions Executes --
-- ⬇ ⬇ ⬇ ⬇ ⬇ ⬇ ⬇ ⬇
--===================--


--[[
function OpensEggs(Arg1, Arg2)
	
	local args = {
		[1] = Arg1 , -- "openCrystal"
		[2] = Arg2 , -- "Jungle Crystal"
	}
	game:GetService("ReplicatedStorage").rEvents.openCrystalRemote:InvokeServer(unpack(args))

end
]]


--===================--
-- Window Guis Tabs --
-- ⬇ ⬇ ⬇ ⬇ ⬇ ⬇ ⬇ ⬇
--===================--
-- GUI
Window = Regui.TabsWindow({Title=GuiName, Text="Legends Of Speed", Size=UDim2.new(0,300,0,200)})
FarmTab = Regui.CreateTab(Window,{Name="Farm"})
ShopTab = Regui.CreateTab(Window,{Name="Buy"})
GameTab = Regui.CreateTab(Window,{Name="Game"})
AfkTab = Regui.CreateTab(Window,{Name="Afk Mod"})
ConfigsTab = Regui.CreateTab(Window,{Name="Configs"})
ReadmeTab = Regui.CreateTab(Window,{Name="Readme"})

-- Especial Tab
local Credits = Regui.CreditsUi(ReadmeTab, { Alignment = "Center", Alignment_Texts = "Left"}, function() end)

--==================================================--
-- AUTO FARM DE ORBS (INDIVIDUAL + TODAS)
--==================================================--
-- Lista de Orbs disponíveis
local Orbs = {
	{name = "Red Orb", Obj = "Red Orb"},
	{name = "Orange Orb", Obj = "Orange Orb"},
	{name = "Blue Orb", Obj = "Blue Orb"},
	{name = "Yellow Orb", Obj = "Yellow Orb"},
	{name = "Diamond", Obj = "Gem"}
}

--==================================================--
-- SELECTOR + LABEL
--==================================================--

local Selector_Orbs = Regui.CreateSelectorOpitions(FarmTab, {
	Name = "Selecionar Orbs",
	Alignment = "Center",
	Size_Frame = UDim2.new(1, -10, 0, 80),
	Type = "Instance",
	Options = Orbs,
	Frame_Max = 80
}, function(selected)
	Val_Orb = selected.name or selected -- garante que pega o nome certo
	UpdateOrbLabel()
end)

local Label_Orb = Regui.CreateLabel(FarmTab, {
	Text = "Orb Selecionada: " .. Val_Orb,
	Color = "White",
	Alignment = "Center"
})

function UpdateOrbLabel()
	Label_Orb.Text = "Orb Selecionada: " .. tostring(Val_Orb)
end

--==================================================--
-- FUNÇÕES DE FARM
-- ⬇ ⬇ ⬇ ⬇ ⬇ ⬇ ⬇ ⬇
--==================================================--

-- Farm apenas uma orb (a selecionada)
function FarmOrb()
	task.spawn(function()
		while AF.FarmOrb do
			local args = {
				[1] = "collectOrb",
				[2] = Val_Orb,
				[3] = "City"
			}
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer(unpack(args))
			task.wait(AF_Timer.FarmOrb_Timer)
		end
	end)
end

function FarmFastOrb()
	local batchSize = 100 -- quantos FireServer enviar por loop
	task.spawn(function()
		while AF.FarmFastOrb do
			for i = 1, batchSize do
				local args = {
					[1] = "collectOrb",
					[2] = Val_Orb,
					[3] = "City"
				}
				task.spawn(function()
					if AF.FarmFastOrb then
					game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer(unpack(args))	
					end
					
				end)
			end

			-- intervalo mínimo, pode até deixar 0
			task.wait(AF_Timer.FarmFastOrb_Timer)
		end
	end)
end






-- Farm todas as orbs da lista
function FarmAllOrbs()
	task.spawn(function()
		while AF.FarmOrbs do
			for _, orb in ipairs(Orbs) do
				local args = {
					[1] = "collectOrb",
					[2] = orb.Obj,
					[3] = "City"
				}
				game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer(unpack(args))
				task.wait(AF_Timer.FarmOrbs_Timer)
			end
		end
	end)
end





--===================--
-- Window Farm Tab   --
-- ⬇ ⬇ ⬇ ⬇ ⬇ ⬇ ⬇ ⬇
--===================--

-- 🔹 Toggle: Auto Orb (único)
local Toggle_Orb_AF = Regui.CreateToggleboxe(FarmTab, {
	Text = "Auto Orb (Selecionado)",
	Color = "Yellow"
}, function(state)
	AF.FarmOrb = state
	if state then
		Regui.NotificationPerson(Window.Frame.Parent, {
			Title = "AutoFarm",
			Text = "Coleta de orb iniciada: " .. Val_Orb,
			Icon = "fa_rr_paper_plane",
			Tempo = 5
		})
		FarmOrb()
	else
		Regui.NotificationPerson(Window.Frame.Parent, {
			Title = "AutoFarm",
			Text = "Auto Orbs (único) parado.",
			Icon = "fa_bx_config",
			Tempo = 5
		})
	end
end)

local Toggle_Orb2_AF = Regui.CreateToggleboxe(FarmTab, {
	Text = "Auto Orb ((Fast))",
	Color = "Yellow"
}, function(state)
	AF.FarmFastOrb = state
	if state then
		Regui.NotificationPerson(Window.Frame.Parent, {
			Title = "AutoFarm (Fast)",
			Text = "Coleta de orb iniciada: " .. Val_Orb,
			Icon = "fa_rr_paper_plane",
			Tempo = 5
		})
		FarmFastOrb()
	else
		Regui.NotificationPerson(Window.Frame.Parent, {
			Title = "AutoFarm",
			Text = "Auto Orbs (único) parado.",
			Icon = "fa_bx_config",
			Tempo = 5
		})
	end
end)

-- 🔹 Toggle: Auto Orbs All (todas)
local Toggle_Orbs_All_AF = Regui.CreateToggleboxe(FarmTab, {
	Text = "Auto Orbs (All)",
	Color = "Cyan"
}, function(state)
	AF.FarmOrbs = state
	if state then
		Regui.NotificationPerson(Window.Frame.Parent, {
			Title = "AutoFarm",
			Text = "Coleta automática de todas as orbes iniciada!",
			Icon = "fa_rr_paper_plane",
			Tempo = 5
		})
		FarmAllOrbs()
	else
		Regui.NotificationPerson(Window.Frame.Parent, {
			Title = "AutoFarm",
			Text = "Coleta automática de todas as orbes parada.",
			Icon = "fa_bx_config",
			Tempo = 5
		})
	end
end)

local Slider_Float_Obrs = Regui.CreateSliderFloat(FarmTab, {
	Text = "Velocidade de Coleta (Timer)",
	Color = "Blue",
	Value = 0.1,
	Minimum = 0,
	Maximum = 1
}, function(value)
	AF_Timer.FarmOrb_Timer = value
	AF_Timer.FarmOrbs_Timer = value
end)





function AutoRebirt()
	task.spawn(
		function()
			while AF.AutoRebirt do
				local args = {
					[1] = "rebirthRequest"
				}
				game:GetService("ReplicatedStorage").rEvents.rebirthEvent:FireServer(unpack(args))
				task.wait(1)
				if not AF.AutoRebirt then break end
			end
		end
	)
end
	
	
	

local Toglle_Auto_Rebirt = Regui.CreateToggleboxe(FarmTab,{
	Text = "Auto Rebirt",
	Color = "White"
}, function(state)
	
	AF.AutoRebirt = state
	
	if AF.AutoRebirt then
		Regui.NotificationPerson(Window.Frame.Parent, {
			Title = "AutoFarm",
			Text = "Auto Rebirt iniciado!",
			Icon = "fa_rr_paper_plane",
			Tempo = 5
		})
		AutoRebirt()
		end
end)


-- Retorna todos os objetos dentro de um folder com o nome específico
function GetObj(FolderName, ObjName)
	local results = {}
	local folder = game.Workspace:FindFirstChild(FolderName)
	if folder then
		for _, obj in ipairs(folder:GetChildren()) do
			if obj.Name == ObjName then
				table.insert(results, obj)
			end
		end
	else
		warn("❌ Pasta não encontrada:", FolderName)
	end
	return results
end

--==================================================--
-- 🔹 Puxar todos os Hoops até o jogador
--==================================================--
function PullAllHoops()
	task.spawn(function()
		local player = game.Players.LocalPlayer
		local char = player.Character
		local root = char and char:FindFirstChild("HumanoidRootPart")

		while AF.Hoops_Pull and root do
			local hoops = GetObj("Hoops", "Hoop")
			for _, hoop in ipairs(hoops) do
				if hoop:FindFirstChild("TouchInterest") or hoop:IsA("Model") then
					-- Move o hoop até o jogador
					if hoop:IsA("Model") and hoop:FindFirstChild("HumanoidRootPart") then
						hoop:FindFirstChild("HumanoidRootPart").CFrame = root.CFrame
					elseif hoop:IsA("BasePart") then
						hoop.CFrame = root.CFrame
					end
				end
			end
			task.wait(AF_Timer.AutoHoops_Timer)
		end
	end)
end

--==================================================--
-- 🔹 Teletransportar o jogador até cada Hoop
--==================================================--
function TeleportToHoops()
	task.spawn(function()
		local player = game.Players.LocalPlayer
		local char = player.Character
		local root = char and char:FindFirstChild("HumanoidRootPart")

		while AF.Hoops_Teleport and root do
			local hoops = GetObj("Hoops", "Hoop")
			for _, hoop in ipairs(hoops) do
				if hoop:IsA("Model") and hoop:FindFirstChild("HumanoidRootPart") then
					root.CFrame = hoop.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
				elseif hoop:IsA("BasePart") then
					root.CFrame = hoop.CFrame + Vector3.new(0, 3, 0)
				end
				task.wait(AF_Timer.AutoHoops_Timer)
			end
			task.wait(0.1)
		end
	end)
end



local Toggle_Hoops_Pull = Regui.CreateToggleboxe(FarmTab, {
	Text = "Pull Hoops (Atrair até você)",
	Color = "Yellow"
}, function(state)
	AF.Hoops_Pull = state
	if state then
		Regui.NotificationPerson(Window.Frame.Parent, {
			Title = "AutoFarm",
			Text = "Puxando todos os Hoops até o jogador!",
			Icon = "fa_ss_marker",
			Tempo = 5
		})
		PullAllHoops()
	else
		Regui.NotificationPerson(Window.Frame.Parent, {
			Title = "AutoFarm",
			Text = "Parando de puxar Hoops.",
			Icon = "fa_ss_marker",
			Tempo = 5
		})
	end
end)

--  Teleportar o jogador para cada Hoop
local Toggle_Hoops_Teleport = Regui.CreateToggleboxe(FarmTab, {
	Text = "Teleport Hoops (Ir até cada um)",
	Color = "Cyan"
}, function(state)
	AF.Hoops_Teleport = state
	if state then
		Regui.NotificationPerson(Window.Frame.Parent, {
			Title = "AutoFarm",
			Text = "Teleportando para todos os Hoops!",
			Icon = "fa_rr_paper_plane",
			Tempo = 5
		})
		TeleportToHoops()
	else
		Regui.NotificationPerson(Window.Frame.Parent, {
			Title = "AutoFarm",
			Text = "Teleport automático parado.",
			Icon = "fa_ss_marker",
			Tempo = 5
		})
	end
end)

-- Timer dos Hoops
local Slider_Hoops_Timer = Regui.CreateSliderFloat(FarmTab, {
	Text = "Timer Hoops",
	Color = "Blue",
	Value = 0.1,
	Minimum = 0.01,
	Maximum = 1
}, function(value)
	AF_Timer.AutoHoops_Timer = value
end)


-- Pets Player

-- Cria SubWindow
local SubWin = Regui.SubTabsWindow(FarmTab, {
	Text = "Windon Pets",
	Table = {"Logs","Pets","Main"},
	Color = "Blue"
})

-- Espera a pasta petsFolder existir
local petsFolder = player:WaitForChild("petsFolder")

-------------------------------------------------
-- Monta lista de raridades (subpastas)
-------------------------------------------------
local list_pets = {
	{ name = "All", Obj = petsFolder } -- opção para ver todos
}



for _, folder in ipairs(petsFolder:GetChildren()) do
	if folder:IsA("Folder") then
		table.insert(list_pets, { name = folder.Name, Obj = folder })
	end
end

print("🐾 Pastas encontradas:")
for _, pet in ipairs(list_pets) do
	print("-", pet.name)
end

-------------------------------------------------
-- Função para criar os botões de pets
-------------------------------------------------
local function RenderPets(rarity)
	-- Limpa pets anteriores
	for _, obj in ipairs(SubWin["Pets"]:GetChildren()) do
		if obj:IsA("GuiObject") then
			obj:Destroy()
		end
	end

	local function createButton(petValue)
		local nome = petValue.Name
		local img = petValue.Value

		local button = Regui.CreateButton(SubWin["Pets"], {
			Text = nome,
			Color = "White",
			BGColor = "Button",
			TextSize = 16
		}, function()
			print("🐶 Pet selecionado:", nome)
			Regui.NotificationPerson(Window.Frame.Parent, {
				Title = "Pet: " .. nome,
				Text = "Imagem: " .. img,
				Icon = img,
				Tempo = 1.5
			})
		end)

		Regui.CreateImage(button, {
			Name = "Icon_" .. nome,
			Transparence = 1,
			Alignment = "Left",
			Id_Image = img,
			Size_Image = UDim2.new(0, 25, 0, 25)
		})
	end

	-- Se for "All", percorre todas as pastas
	if rarity == "All" then
		for _, folder in ipairs(petsFolder:GetChildren()) do
			if folder:IsA("Folder") then
				for _, petValue in ipairs(folder:GetChildren()) do
					if petValue:IsA("StringValue") then
						createButton(petValue)
					end
				end
			end
		end
	else
		-- Mostra apenas a raridade selecionada
		local selectedFolder = petsFolder:FindFirstChild(rarity)
		if selectedFolder then
			for _, petValue in ipairs(selectedFolder:GetChildren()) do
				if petValue:IsA("StringValue") then
					createButton(petValue)
				end
			end
		else
			warn("❌ Nenhuma pasta encontrada para a raridade:", rarity)
		end
	end
end

-------------------------------------------------
-- Cria o seletor com atualização dinâmica
-------------------------------------------------
local Selected_Rare = "All"


local Selector_Rare = Regui.CreateSelectorOpitions(SubWin["Logs"], {
	Name = "Selecionar Raridade",
	Alignment = "Center",
	Size_Frame = UDim2.new(1, -10, 0, 80),
	Type = "Instance",
	Options = list_pets,
	Frame_Max = 80
}, function(selected)
	if selected then
		Selected_Rare = selected.name
		print("⭐ Raridade selecionada:", Selected_Rare)
		RenderPets(Selected_Rare)
	end
end)

-------------------------------------------------
-- Render inicial (mostrar todos os pets)
-------------------------------------------------
RenderPets("All")

local Sequencia_Rare = {"Basic", "Advanced", "Rare", "Epic", "Unique", "Omega"}

function SellsPets(Arg1, Arg2, Arg3)
	local player = game:GetService("Players").LocalPlayer
	local petToSell = player.petsFolder[Arg3]:FindFirstChild(Arg2)
	if petToSell then
		local args = {
			[1] = Arg1, -- "sellPet"
			[2] = petToSell
		}
		game:GetService("ReplicatedStorage").rEvents.sellPetEvent:FireServer(unpack(args))
	end
end

function AutoDelete(rarity, sequenceMode)
	local player = game.Players.LocalPlayer
	local petsFolder = player:WaitForChild("petsFolder")

	while (sequenceMode and AF.AutoDeleted_Sequence) or (not sequenceMode and AF.AutoDeleted) do
		local raritiesToDelete = {}

		if sequenceMode then
			-- Selected + Sequence: pega raridade selecionada e todas abaixo
			local selectedIndex
			for i, name in ipairs(Sequencia_Rare) do
				if name == rarity then
					selectedIndex = i
					break
				end
			end
			if selectedIndex then
				for i = 1, selectedIndex do
					table.insert(raritiesToDelete, Sequencia_Rare[i])
				end
			end
		else
			-- Apenas a raridade selecionada
			table.insert(raritiesToDelete, rarity)
		end

		for _, rareName in ipairs(raritiesToDelete) do
			local selectedFolder = petsFolder:FindFirstChild(rareName)
			if selectedFolder then
				for _, petValue in ipairs(selectedFolder:GetChildren()) do
					if petValue:IsA("StringValue") then
						SellsPets("sellPet", petValue.Name, rareName)
						Regui.NotificationPerson(Window.Frame.Parent, {
							Title = "AutoDelete",
							Text = "🌀 Deletando pet: " .. petValue.Name .. " (" .. rareName .. ")",
							Icon = petValue.Value,
							Tempo = 1
						})
					end
				end
			end
			task.wait(0.8)
		end

		task.wait(1.5)
	end
end

-- Toggle Selected + Sequence
local Toggle_Auto_Delete_Sequencial = Regui.CreateToggleboxe(SubWin["Main"], {
	Text = "Deletar por Raridade (Selected + Sequence)",
	Color = "Yellow"
}, function(state)
	local rarity = Selected_Rare

	AF.AutoDeleted_Sequence = (rarity ~= "All" and state) or false

	if state then
		Regui.NotificationPerson(Window.Frame.Parent, {
			Title = "AutoDelete",
			Text = "✅ AutoDelete ativado para Selected + Sequence: " .. rarity,
			Icon = "fa_ss_marker",
			Tempo = 4
		})
		spawn(function() AutoDelete(rarity, true) end)
	else
		Regui.NotificationPerson(Window.Frame.Parent, {
			Title = "AutoDelete",
			Text = "⏹ AutoDelete desativado (Selected + Sequence).",
			Icon = "fa_ss_marker",
			Tempo = 4
		})
	end
end)

-- Toggle Selected apenas
local Toggle_Auto_Delete = Regui.CreateToggleboxe(SubWin["Main"], {
	Text = "Deletar por Raridade (Selected)",
	Color = "Yellow"
}, function(state)
	local rarity = Selected_Rare

	AF.AutoDeleted = (rarity ~= "All" and state) or false

	if state then
		Regui.NotificationPerson(Window.Frame.Parent, {
			Title = "AutoDelete",
			Text = "✅ AutoDelete ativado para Selected: " .. rarity,
			Icon = "fa_ss_marker",
			Tempo = 4
		})
		spawn(function() AutoDelete(rarity, false) end)
	else
		Regui.NotificationPerson(Window.Frame.Parent, {
			Title = "AutoDelete",
			Text = "⏹ AutoDelete desativado (Selected).",
			Icon = "fa_ss_marker",
			Tempo = 4
		})
	end
end)



local button_R = Regui.CreateButton(SubWin["Logs"], {
	Text = "Reset",
	Color = "White",
	BGColor = "Button",
	TextSize = 16
}, function()
	AF.AutoDeleted = false
	Toggle_Auto_Delete.Set(AF.AutoDeleted)
	Selector_Rare.Opitions_Title.Text = "Raridade: " .. Selected_Rare
	RenderPets("All")
	Selected_Rare = "All"
end)




-- ShopTab

local Selected_Crysta = "All"

local List_Cristy = {
		{name = "Jungle Crystal", Obj = "Jungle Crystal"}
}

-- Função para abrir ovos
function OpensEggs(Arg1, Arg2)
	task.spawn(function()
		while AF.AutoBuyPets do
			local crystalName = Arg2 == "All" and List_Cristy[1].Obj or Arg2
			local args = {
				[1] = Arg1, -- "openCrystal"
				[2] = crystalName
			}
			game:GetService("ReplicatedStorage").rEvents.openCrystalRemote:InvokeServer(unpack(args))
			task.wait(AF_Timer.AutoBuyPets_Timer)
		end
	end)
end

-- Seletor de crysta
local Selector_Crysta = Regui.CreateSelectorOpitions(ShopTab, {
	Name = "Selecionar Crysta",
	Alignment = "Center",
	Size_Frame = UDim2.new(1, -10, 0, 80),
	Type = "Instance",
	Options = List_Cristy,
	Frame_Max = 80
}, function(selected)
	if selected then
		Selected_Crysta = selected
		UpdateCrystaLabel() -- atualiza imediatamente
	end
end)

-- Label de crysta selecionada
local Label_Crysta = Regui.CreateLabel(ShopTab, {
	Text = "Crysta Selecionada: " .. Selected_Crysta,
	Color = "White",
	Alignment = "Center"
})

-- Atualiza label dinamicamente
function UpdateCrystaLabel()
	Label_Crysta.Text = "Crysta Selecionada: " .. tostring(Selected_Crysta)
end

-- Toggle de compra
local Toggle_Buy_Crysta = Regui.CreateToggleboxe(ShopTab, {
	Text = "Buy Crysta (Selected)",
	Color = "Cyan"
}, function(state)
	AF.AutoBuyPets = state
	if state then
		Regui.NotificationPerson(Window.Frame.Parent, {
			Title = "Auto Buy",
			Text = "Buy Pet: " .. tostring(Selected_Crysta),
			Icon = "fa_rr_paper_plane",
			Tempo = 5
		})
		OpensEggs("openCrystal", Selected_Crysta)
	end
end)

-- Slider de tempo entre compras
local Slider_Buy_Pets_Timer = Regui.CreateSliderFloat(ShopTab, {
	Text = "Timer Auto Buy Pets",
	Color = "Blue",
	Value = 1,
	Minimum = 0.01,
	Maximum = 1
}, function(value)
	AF_Timer.AutoBuyPets_Timer = value
end)
