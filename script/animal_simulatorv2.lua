-- ==========================================
-- MastermodV2: Mod Menu
-- ==========================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
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

-- REMOTES
local attackRemote = ReplicatedStorage:WaitForChild("jdskhfsIIIllliiIIIdchgdIiIIIlIlIli")
local skillsRemote = ReplicatedStorage:WaitForChild("SkillsInRS"):WaitForChild("RemoteEvent")
local idmusicRemote = ReplicatedStorage:WaitForChild("Events"):WaitForChild("PLAYEvent")


-- FOLDERS
local map = Workspace:FindFirstChild("MAP")
if not map then
	map = Instance.new("Folder")
	map.Name = "MAP"
	map.Parent = Workspace
end

local dummiesFolder = map:FindFirstChild("dummies")
if not dummiesFolder then
	dummiesFolder = Instance.new("Folder")
	dummiesFolder.Name = "dummies"
	dummiesFolder.Parent = map
end

local folder5k = map:FindFirstChild("5k_dummies")
if not folder5k then
	folder5k = Instance.new("Folder")
	folder5k.Name = "5k_dummies"
	folder5k.Parent = map
end





local bossesList = { "ROCKY","Griffin","BOOSBEAR","BOSSDEER","CENTAUR","CRABBOSS","DragonGiraffe","LavaGorilla" }
-- Valor selecionado no selector
local selectedBoss = "All" -- padrão: todos
local selectedPlayerTp = "All"



-- FLAGS
local AF = { coins=false, bosses=false, dummies=false, dummies5k=false, tpDummy=false, tpDummy5k=false }
local AF_Timer = {Coins_Speed = 1, Bosses_Speed = 0.05, Dummies_Speed = 1, Dummies5k_Speed = 1}
local PVP = { killAura=false, AutoFire=false, AutoEletric=false, AutoFireIA=false, AutoEletricIA=false, AutoAttack=false, AutoFlyAttack=false, AttackType="Melee", AutoTp = false }
local PVP_Timer = {KillAura_Speed = 0.05, AutoFire_Speed = 0.05, AutoEletric_Speed = 0.05,AutoFireIA_Speed = 0.05, AutoEletricIA_Speed = 0.05, AutoAttack_Speed = 0.05, AutoFlyAttack_Speed = 0.05, AutoTp_Speed = 1}
local maxRange = 100



-- Buscar De Dados
-- UTILS
local function getCharacter()
	local c = player.Character or player.CharacterAdded:Wait()
	return c, c:WaitForChild("Humanoid"), c:WaitForChild("HumanoidRootPart")
end

local function getAliveHumanoid(model)
	local hum = model and model:FindFirstChildOfClass("Humanoid")
	if hum and hum.Health > 0 then 
		return hum 
	end
end

local function findDummy(folder)
	for _, d in ipairs(folder:GetChildren()) do
		local hum = getAliveHumanoid(d)
		if hum then 
			return d, hum 
		end
	end
end

-- Retorna apenas as subpastas dentro de um folder
local function getFolders(folder)
	local folders = {}
	for _, child in ipairs(folder:GetChildren()) do
		if child:IsA("Folder") then
			table.insert(folders, child)
		end
	end
	return folders
end

-- Retorna uma lista de jogadores vivos (com Humanoid válido)
local function getPlayers()
	local alivePlayers = {}
	for _, plr in ipairs(game.Players:GetPlayers()) do
		local char = plr.Character
		if char then
			local hum = getAliveHumanoid(char)
			if hum then
				table.insert(alivePlayers, {Player = plr, Character = char, Humanoid = hum})
			end
		end
	end

	return alivePlayers

end



-- pega só os nomes dos jogadores vivos
local function getPlayerNames()
	local names = {}
	for _, data in ipairs(getPlayers()) do
		table.insert(names, data.Player.Name)
	end
	return names
end




--===================================================--

-- AUTO FARM
local function autoCoins()
	task.spawn(function()
		while AF.coins do
			local events = ReplicatedStorage:FindFirstChild("Events")
			local coinEvent = events and events:FindFirstChild("CoinEvent")
			if coinEvent then coinEvent:FireServer() end
			task.wait(AF_Timer.Coins_Speed)
		end
	end)
end

local function attackLoop(flag, folder)
	task.spawn(function()
		while AF[flag] do
			local dummy, hum = findDummy(folder)
			if dummy and hum and dummy:FindFirstChild("HumanoidRootPart") then
				local pos = dummy.HumanoidRootPart.Position
				attackRemote:FireServer(hum, 2)
				skillsRemote:FireServer(pos, "NewFireball")
				skillsRemote:FireServer(pos, "NewLightningball")
			end
			task.wait(AF_Timer.Dummies_Speed)
		end
	end)
end

-- Função de farm boss 
local function farmBosses()
	while AF.bosses do
		local npcFolder = Workspace:FindFirstChild("NPC")
		if npcFolder then
			for _, name in ipairs(bossesList) do
				local boss = npcFolder:FindFirstChild(name)
				local hum = getAliveHumanoid(boss)
				if hum then attackRemote:FireServer(hum, 5) end
			end
		end
		task.wait(AF_Timer.Bosses_Speed)
	end
end

-- Função de farm fixa (com verificação do boss selecionado)
local function farmBossesFix()
	task.spawn(function()
		while AF.bosses do
			local npcFolder = Workspace:FindFirstChild("NPC")
			if npcFolder then
				for _, name in ipairs(bossesList) do
					-- Verifica se deve atacar esse boss
					if selectedBoss == "All" or selectedBoss == name then
						local boss = npcFolder:FindFirstChild(name)
						local hum = getAliveHumanoid(boss)
						if hum then
							attackRemote:FireServer(hum, 5)
						end
					end
				end
			end
			task.wait(AF_Timer.Bosses_Speed)
		end
	end)
end



local selectedPlayer = nil -- caso seja nil ou "All", usa todos os jogadores

local autoAttackIndex = 1 -- controla o ciclo 1-5

local function PVP_Loop(kind)
	task.spawn(function()
		while PVP[kind] do
			local _, _, hrp = getCharacter()
			local closest, shortest = nil, maxRange

			-- Determinar lista de alvos
			local targets = {}
			if selectedPlayer == nil or selectedPlayer == "All" then
				targets = Players:GetPlayers()
			else
				local plr = Players:FindFirstChild(selectedPlayer)
				if plr then
					table.insert(targets, plr)
				else
					selectedPlayer = "All"
					targets = Players:GetPlayers()
				end
			end

			-- Buscar jogador mais próximo
			for _, p in ipairs(targets) do
				if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
					local hum = p.Character:FindFirstChildOfClass("Humanoid")
					if hum and hum.Health > 0 then
						local dist = (p.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
						if dist < shortest then
							shortest = dist
							closest = p
						end
					end
				end
			end

			-- Atacar
			if closest then
				local hum = closest.Character:FindFirstChildOfClass("Humanoid")
				local hrpTarget = closest.Character:FindFirstChild("HumanoidRootPart")
				if hum and hrpTarget then
					if kind == "killAura" then
						pcall(function() attackRemote:FireServer(hum, 1) end)
					elseif kind == "AutoFire" then
						pcall(function() skillsRemote:FireServer(hrpTarget.Position, "NewFireball") end)
					elseif kind == "AutoEletric" then
						pcall(function() skillsRemote:FireServer(hrpTarget.Position, "NewLightningball") end)
					elseif kind == "AutoAttack" then
						pcall(function()
							attackRemote:FireServer(hum, autoAttackIndex)
							autoAttackIndex = autoAttackIndex + 1
							if autoAttackIndex > 5 then
								autoAttackIndex = 1
							end
						end)
					end
				end
			end

			-- Espera
			local waitTime = PVP_Timer[kind .. "_Speed"] or 0.3
			task.wait(waitTime)
		end
	end)
end


local function AutoTp_Loop()
	task.spawn(function()
		local index = 1
		while PVP.AutoTp do
			local _, _, hrp = getCharacter()
			if not hrp then
				task.wait(0.2)
				continue
			end

			-- Seleciona lista de alvos
			local targets = {}
			if selectedPlayerTp == nil or selectedPlayerTp == "All" then
				targets = Players:GetPlayers()
			else
				local plr = Players:FindFirstChild(selectedPlayerTp)
				if plr then
					table.insert(targets, plr)
				else
					-- Se o player sumiu, volta para All
					selectedPlayerTp = "All"
					targets = Players:GetPlayers()
				end
			end

			-- Remove o próprio player da lista
			for i = #targets, 1, -1 do
				if targets[i] == player or not (targets[i].Character and targets[i].Character:FindFirstChild("HumanoidRootPart")) then
					table.remove(targets, i)
				end
			end

			if #targets > 0 then
				-- Controla o índice sequencial
				if index > #targets then
					index = 1
				end

				local target = targets[index]
				index += 1

				-- Verifica se o alvo é válido
				if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
					local hum = target.Character:FindFirstChildOfClass("Humanoid")
					if hum and hum.Health > 0 then
						-- Teleporta até o alvo
						hrp.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 2, 0)
					end
				end
			end

			task.wait(PVP_Timer.AutoTp_Speed or 0.3)
		end
	end)
end


--  Tools
--====================================================================================================================--


-- TOOLS
local function giveTool(name, skill)
	if player.Backpack:FindFirstChild(name) or player.Character:FindFirstChild(name) then return end
	local tool = Instance.new("Tool")
	tool.Name = name
	tool.RequiresHandle = false
	tool.CanBeDropped = false
	tool.Parent = player.Backpack
	local mouse = player:GetMouse()
	tool.Activated:Connect(function()
		if skillsRemote then
			skillsRemote:FireServer(mouse.Hit.Position, skill)
		end
	end)
end


-- TOOLS AUTO-ALVO
local function giveToolAuto(name, skill)
	if player.Backpack:FindFirstChild(name) or player.Character:FindFirstChild(name) then return end

	local tool = Instance.new("Tool")
	tool.Name = name
	tool.RequiresHandle = false
	tool.CanBeDropped = false
	tool.Parent = player.Backpack

	local mouse = player:GetMouse()
	local maxRange = 200 -- alcance para buscar jogadores

	tool.Activated:Connect(function()
		if not skillsRemote then return end

		local character = player.Character
		if not character then return end
		local hrp = character:FindFirstChild("HumanoidRootPart")
		if not hrp then return end

		local closestPlayer = nil
		local shortestDist = maxRange

		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				local hrpTarget = p.Character.HumanoidRootPart
				local dist = (hrp.Position - hrpTarget.Position).Magnitude
				if dist < shortestDist then
					shortestDist = dist
					closestPlayer = p
				end
			end
		end

		-- Se encontrou jogador perto, mira nele
		if closestPlayer and closestPlayer.Character then
			skillsRemote:FireServer(closestPlayer.Character.HumanoidRootPart.Position, skill)
		else
			-- Senão, usa posição do mouse
			skillsRemote:FireServer(mouse.Hit.Position, skill)
		end
	end)
end



-- TOOLS
local function giveToolFake(name, skill)
	if player.Backpack:FindFirstChild(name) or player.Character:FindFirstChild(name) then return end

	local tool = Instance.new("Tool")
	tool.Name = name
	tool.RequiresHandle = false
	tool.CanBeDropped = false
	tool.Parent = player.Backpack

	local mouse = player:GetMouse()
	local rot
	local connection

	tool.Equipped:Connect(function()
		local char = player.Character or player.CharacterAdded:Wait()
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if hrp then
			-- Cria o "Rot" não ancorado
			rot = Instance.new("Part")
			rot.Name = "HumanoidRootPart"
			rot.Size = Vector3.new(1,1,1)
			rot.Anchored = false -- desancorado
			rot.CanCollide = false
			rot.Color = Color3.fromRGB(0, 0, 255)
			rot.Position = hrp.Position + hrp.CFrame.RightVector * 3
			rot.Parent = hrp.Parent


			-- Conecta para mover o rot junto do jogador
			connection = RunService.Heartbeat:Connect(function()
				if hrp and rot then
					local targetPos = hrp.Position + hrp.CFrame.RightVector * 3
					-- Move suavemente
					rot.Velocity = (targetPos - rot.Position) * 10
				end
			end)
		end
	end)

	tool.Unequipped:Connect(function()
		if connection then
			connection:Disconnect()
		end
		if rot then
			rot:Destroy()
		end
	end)

	tool.Activated:Connect(function()
		if skillsRemote then
			skillsRemote:FireServer(mouse.Hit.Position, skill)
		end
	end)
end





--====================================================================================================================--


-- GUI
local Window = Regui.TabsWindow({Title=GuiName, Text="Animal Simulator", Size=UDim2.new(0,300,0,200)})
local FarmTab = Regui.CreateTab(Window,{Name="Farm"})
local PlayerTab = Regui.CreateTab(Window,{Name="PVP Player"})
local GameTab = Regui.CreateTab(Window,{Name="Game"})
local MusicTab = Regui.CreateTab(Window,{Name="Music Player"})
local ConfigsTab = Regui.CreateTab(Window,{Name="Configs"})
local ReadmeTab = Regui.CreateTab(Window,{Name="Readme"})
--=============-
local Credits = Regui.CreditsUi(ReadmeTab, { Alignment = "Center", Alignment_Texts = "Left"}, function() end)
local MemeDog = Regui.CreateImage(ReadmeTab, {Name = "Meme (Dog)", Transparence = 1, Alignment = "Center", Id_Image = "rbxassetid://90426210033947", Size_Image = UDim2.new(0, 50, 0, 50)  })
--=============-


local Label_Farme_AF = Regui.CreateLabel(FarmTab, {Text = "Farme", Color = "White", Alignment = "Center"})
-- Exemplo de Toggle
local ToggleCoins = Regui.CreateToggleboxe(FarmTab,{Text="Auto Coins",Color="Yellow"},function(state)
	AF.coins=state
	if state then autoCoins() end
end)

local SliderFloat_Coins = Regui.CreateSliderFloat(FarmTab, {Text = "Timer Auto Coins", Color = "Yellow", Value = 0.1, Minimum = 0, Maximum = 1}, function(state)
	AF_Timer.Coins_Speed = state
	print("Slider Float clicada! Estado:", AF_Timer.Coins_Speed)

end) 


-- Selector de boss
local selectorFrame = Regui.CreateSelectorOpitions(FarmTab, {
	Name = "Selector Boss",
	Options = {"All", unpack(bossesList)}, -- cria lista: All + bosses
	Type = "String",
	Size_Frame = UDim2.new(1, -20, 0, 100)
}, function(val)
	print("Npc Boss selecionado:", val)
	selectedBoss = val
end)




-- Toggle de Auto Boss
local ToggleBosses = Regui.CreateToggleboxe(FarmTab,{Text="Auto Bosses",Color="Red"},function(state)
	AF.bosses = state
	if state then 
		if selectedBoss == "All" then
			farmBosses() 
		else
			farmBossesFix(selectedBoss)
		end
	end
end)

local SliderFloat_Boosses = Regui.CreateSliderFloat(FarmTab, {Text = "Timer Bosses", Color = "Blue", Value = 0.1, Minimum = 0, Maximum = 1}, function(state)
	AF_Timer.Bosses_Speed = state
	print("Slider Float clicada! Estado:", AF_Timer.Bosses_Speed)

end) 




local Check_Farme_dummies = Regui.CreateCheckboxe(FarmTab, {Text = "Auto dummies", Color = "Blue"}, function(state)
	AF.dummies = state
	--print("Checkbox clicada! Estado:", Test_.Button_Box)

	if AF.dummies  then
		attackLoop("dummies", dummiesFolder)
		-- Notificação se for Verdadeiro
		Regui.NotificationPerson(Window.Frame.Parent, {
			Title = "Alert: Farme dummies",
			Text = "Checkbox dummies! State: " .. tostring(AF.dummies),
			Icon = "fa_envelope",
			Tempo = 5,
			Casch = {},
			Sound = ""
		}, function()
			print("Notificação fechada!")
		end)
	end


end)

-- rbxassetid://93478350885441

local Check_Farme_dummies5k = Regui.CreateCheckboxe(FarmTab, {Text = "Auto dummies 5K", Color = "Blue"}, function(state)
	AF.dummies5k = state
	--print("Checkbox clicada! Estado:", Test_.Button_Box)

	if AF.dummies5k  then
		attackLoop("dummies5k", folder5k)
		-- Notificação se for Verdadeiro
		Regui.NotificationPerson(Window.Frame.Parent, {
			Title = "Alert: Farme dummies5k",
			Text = "Checkbox dummies5k! State: " .. tostring(AF.dummies5k),
			Icon = "fa_envelope",
			Tempo = 5,
			Casch = {},
			Sound = ""
		}, function()
			print("Notificação fechada!")
		end)
	end


end)


local SliderFloat_dummies = Regui.CreateSliderFloat(FarmTab, {Text = "Timer dummies", Color = "Blue", Value = 1, Minimum = 0, Maximum = 1}, function(state)
	AF_Timer.Dummies_Speed = state
	print("Slider Float clicada! Estado:", AF_Timer.Dummies_Speed)

end) 


local Check_Tp_dummies = Regui.CreateCheckboxe(FarmTab, {Text = "Tp + Auto dummies", Color = "White"}, function(state)
	AF.tpDummy = state
	--print("Checkbox clicada! Estado:", Test_.Button_Box)

	if AF.tpDummy  then
		attackLoop("tpDummy", dummiesFolder)
		-- Notificação se for Verdadeiro
		Regui.NotificationPerson(Window.Frame.Parent, {
			Title = "Alert: Tp dummies",
			Text = "Tp dummies! State: " .. tostring(AF.tpDummy),
			Icon = "fa_envelope",
			Tempo = 5,
			Casch = {},
			Sound = ""
		}, function()
			print("Notificação fechada!")
		end)
	end


end)


local Check_Tp_dummies5k = Regui.CreateCheckboxe(FarmTab, {Text = "Tp + Auto dummies 5K", Color = "White"}, function(state)
	AF.tpDummy5k = state
	--print("Checkbox clicada! Estado:", Test_.Button_Box)

	if AF.tpDummy5k  then
		attackLoop("tpDummy5k", folder5k)
		-- Notificação se for Verdadeiro
		Regui.NotificationPerson(Window.Frame.Parent, {
			Title = "Alert: Tp dummies5k",
			Text = "Tp dummies5k! State: " .. tostring(AF.tpDummy5k),
			Icon = "fa_envelope",
			Tempo = 5,
			Casch = {},
			Sound = ""
		}, function()
			print("Notificação fechada!")
		end)
	end


end)

local Ohyya = Regui.CreateImage(FarmTab, {Name = "Meme", Transparence = 1, Alignment = "Center", Id_Image = "rbxassetid://75961890646911", Size_Image = UDim2.new(0, 50, 0, 50)  })

--- TAB PLAYERS


local Label_Farme_PVP_Selector = Regui.CreateLabel(PlayerTab, {Text = "PVP Player", Color = "White", Alignment = "Center"})

-- Criação do selector de players
local selectorPlayer = Regui.CreateSelectorOpitions(PlayerTab, {
	Name = "Selecionar Alvo",
	Options = {"All", unpack(getPlayerNames())}, -- lista inicial de nomes
	Type = "String",
	Size_Frame = UDim2.new(1, -20, 0, 100)
}, function(val)
	print("Jogador selecionado:", val)
	selectedPlayer = val

	Regui.NotificationPerson(Window.Frame.Parent, {
		Title = "Alert: PVP Player",
		Text = "Auto Attack Player! State: " .. tostring(selectedPlayer),
		Icon = "rbxassetid://93478350885441",
		Tempo = 2,
		Casch = {},
		Sound = ""
	}, function()
		print("Notificação fechada!")
	end)		

end)


---=====================================================================================================================--

local Label_Farme_PVP_Aura = Regui.CreateLabel(PlayerTab, {Text = "PVP Player  Aura", Color = "White", Alignment = "Center"})
-- Exemplo de PVP
local ToggleKillAura = Regui.CreateToggleboxe(PlayerTab,{Text="Kill Aura",Color="Red"},function(state)
	PVP.killAura=state


	if state then PVP_Loop("killAura")

		Regui.NotificationPerson(Window.Frame.Parent, {
			Title = "Alert: Aura Kill",
			Text = "Aura Kill! State: " .. tostring(PVP.killAura),
			Icon = "rbxassetid://93478350885441",
			Tempo = 2,
			Casch = {},
			Sound = ""
		}, function()
			print("Notificação fechada!")
		end)	

	end
end)

local ToggleAutoAttack = Regui.CreateToggleboxe(PlayerTab,{Text="Auto Attack",Color="Cyan"},function(state)
	PVP.AutoAttack=state
	if state then PVP_Loop("AutoAttack")

		Regui.NotificationPerson(Window.Frame.Parent, {
			Title = "Alert: Auto Attack",
			Text = "Auto Attack! State: " .. tostring(PVP.AutoAttack),
			Icon = "rbxassetid://93478350885441",
			Tempo = 2,
			Casch = {},
			Sound = ""
		}, function()
			print("Notificação fechada!")
		end)		

	end
end)




-- TIMER KillAura
local SliderInt_KillAura = Regui.CreateSliderFloat(PlayerTab, {
	Text = "Kill Aura Speed", 
	Color = "White", 
	Value = 0.3, Minimum = 0, Maximum = 1
}, function(state)
	PVP_Timer.KillAura_Speed = state
	print("KillAura Speed:", PVP_Timer.KillAura_Speed)
end)

--================================================================================================================================--
local Label_Farme_PVP_Info_Fire = Regui.CreateLabel(PlayerTab, {Text = "-------------------------------", Color = "White", Alignment = "Center"})
local Label_Farme_PVP_Fire = Regui.CreateLabel(PlayerTab, {Text = "PVP Player  Fire", Color = "White", Alignment = "Center"})

-- RANGE GLOBAL
local SliderInt_Range = Regui.CreateSliderInt(PlayerTab, {
	Text = "Max Range Fire", 
	Color = "Blue", 
	Value = 100, Minimum = 100, Maximum = 500
}, function(state)
	maxRange = state
	print("Range atualizado:", maxRange)
end)


local ToggleFireball = Regui.CreateToggleboxe(PlayerTab,{Text="Auto Fireball",Color="Yellow"},function(state)
	PVP.AutoFire=state
	if state then PVP_Loop("AutoFire")

		Regui.NotificationPerson(Window.Frame.Parent, {
			Title = "Alert: AutoFire",
			Text = "Auto Fire! State: " .. tostring(PVP.AutoFire),
			Icon = "rbxassetid://93478350885441",
			Tempo = 2,
			Casch = {},
			Sound = ""
		}, function()
			print("Notificação fechada!")
		end)		

	end
end)


-- TIMER AutoFire
local SliderInt_AutoFire = Regui.CreateSliderInt(PlayerTab, {
	Text = "AutoFire Speed", 
	Color = "Yellow", 
	Value = 0.3, Minimum = 0.05, Maximum = 1
}, function(state)
	PVP_Timer.AutoFire_Speed = state
	print("AutoFire Speed:", state)
end)


local ToggleLightning = Regui.CreateToggleboxe(PlayerTab,{Text="Auto Lightning",Color="Cyan"},function(state)
	PVP.AutoEletric=state
	if state then PVP_Loop("AutoEletric")

		Regui.NotificationPerson(Window.Frame.Parent, {
			Title = "Alert: Auto Eletric",
			Text = "Auto Eletric! State: " .. tostring(PVP.AutoEletric),
			Icon = "rbxassetid://93478350885441",
			Tempo = 2,
			Casch = {},
			Sound = ""
		}, function()
			print("Notificação fechada!")
		end)		


	end
end)

-- TIMER AutoEletric
local SliderInt_AutoEletric = Regui.CreateSliderInt(PlayerTab, {
	Text = "AutoLightning Speed", 
	Color = "Cyan", 
	Value = 0.3, Minimum = 0.05, Maximum = 1
}, function(state)
	PVP_Timer.AutoEletric_Speed = state
	print("AutoLightning Speed:", state)
end)


local Label_Farme_PVP_Info = Regui.CreateLabel(PlayerTab, {Text = "-------------------------------", Color = "White", Alignment = "Center"})
-- Em Breve ...
local Label_Farme_PVP_Teleport = Regui.CreateLabel(PlayerTab, {Text = "PVP Player Tp", Color = "Red", Alignment = "Center"})
-- Função de Auto TP Sequencial
-- Criação do selector de players
local selectorPlayerTp = Regui.CreateSelectorOpitions(PlayerTab, {
	Name = "Selecionar Alvo",
	Options = {"All", unpack(getPlayerNames())}, -- lista inicial de nomes
	Type = "String",
	Size_Frame = UDim2.new(1, -20, 0, 100)
}, function(val)
	print("Jogador selecionado:", val)
	selectedPlayerTp = val

	Regui.NotificationPerson(Window.Frame.Parent, {
		Title = "Alert",
		Text = "Auto Tp Player! State: " .. tostring(selectedPlayerTp),
		Icon = "rbxassetid://93478350885441",
		Tempo = 2,
		Casch = {},
		Sound = ""
	}, function()
		print("Notificação fechada!")
	end)		


end)


-- Função genérica para atualizar selectors de players
local function updateSelector(selector, selectedVarName)
	task.spawn(function()
		while true do
			task.wait(10)

			local opts = {"All"}
			for _, name in ipairs(getPlayerNames()) do
				table.insert(opts, name)
			end

			-- Atualiza os botões do selector
			selector.Reset(opts)

			-- Recupera valor atual
			local current = _G[selectedVarName]

			-- Se o jogador selecionado não existir mais, muda para "All"
			local valid = false
			for _, name in ipairs(opts) do
				if name == current then
					valid = true
					break
				end
			end

			if not valid then
				_G[selectedVarName] = "All"
			end

			-- Atualiza o título do selector para refletir a escolha atual
			selector.SetName(_G[selectedVarName])
		end
	end)
end

-- Usa a função genérica para cada selector
updateSelector(selectorPlayer, "selectedPlayer")
updateSelector(selectorPlayerTp, "selectedPlayerTp")



-- Ativar o loop quando marcar o toggle


local AutoAttackTp = Regui.CreateToggleboxe(PlayerTab,{Text="Auto Tp",Color="Cyan"},function(state)
	PVP.AutoTp = state
	if state then
		AutoTp_Loop()

		Regui.NotificationPerson(Window.Frame.Parent, {
			Title = "Alert: Teleporte",
			Text = "Auto Tp! State: " .. tostring(PVP.AutoTp),
			Icon = "rbxassetid://93478350885441",
			Tempo = 2,
			Casch = {},
			Sound = ""
		}, function()
			print("Notificação fechada!")
		end)		



	end
end)
local SliderFloat_Tp = Regui.CreateSliderFloat(PlayerTab, {Text = "Timer Tp Players", Color = "Blue", Value = 0.05, Minimum = 0, Maximum = 1}, function(state)
	PVP_Timer.AutoTp_Speed = state
	print("Slider Float clicada! Estado:", PVP_Timer.AutoTp_Speed)

end) 

local Label_Farme_PVP_Info = Regui.CreateLabel(PlayerTab, {Text = "-------------------------------", Color = "White", Alignment = "Center"})

--=====================================================================================================================--
local Label_Farme_PVP_IA = Regui.CreateLabel(PlayerTab, {Text = "PVP Test IA", Color = "Red", Alignment = "Center"})

-- Guardar últimas posições para prever movimento
local lastPositions = {}
local TimerlastPositions = 0.1 -- padrão, pode mudar para 0.005

local function PVP_LoopIA(kind)
	task.spawn(function()
		local accumulatedTime = 0
		local lastTick = tick()

		while PVP[kind] do
			local now = tick()
			local delta = now - lastTick
			lastTick = now
			accumulatedTime = accumulatedTime + delta

			-- Atualiza posição apenas se passou o timer definido
			if accumulatedTime >= TimerlastPositions then
				accumulatedTime = 0 -- reset

				local _, _, hrp = getCharacter()
				if not hrp then task.wait() continue end

				local closest, shortest = nil, maxRange

				-- Determinar lista de alvos
				local targets = {}
				if selectedPlayer == nil or selectedPlayer == "All" then
					targets = Players:GetPlayers()
				else
					local plr = Players:FindFirstChild(selectedPlayer)
					if plr then
						table.insert(targets, plr)
					else
						selectedPlayer = "All"
						targets = Players:GetPlayers()
					end
				end

				-- Buscar jogador mais próximo
				for _, p in ipairs(targets) do
					if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
						local hum = p.Character:FindFirstChildOfClass("Humanoid")
						if hum and hum.Health > 0 then
							local dist = (p.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
							if dist < shortest then
								shortest = dist
								closest = p
							end
						end
					end
				end

				-- Atacar com previsão 3D
				if closest then
					local hum = closest.Character:FindFirstChildOfClass("Humanoid")
					local hrpTarget = closest.Character:FindFirstChild("HumanoidRootPart")
					if hum and hrpTarget then
						local currentPos = hrpTarget.Position
						local lastPos = lastPositions[closest] or currentPos
						local deltaTime = PVP_Timer[kind .. "_Speed"] or 0.3
						local velocity = (currentPos - lastPos) / deltaTime
						local distance = (currentPos - hrp.Position).Magnitude
						local projectileSpeed = 80
						local travelTime = distance / projectileSpeed
						local predictedPos = currentPos + (velocity * travelTime)

						lastPositions[closest] = currentPos

						if kind == "AutoFireIA" then
							pcall(function() skillsRemote:FireServer(predictedPos, "NewFireball") end)
						elseif kind == "AutoEletricIA" then
							pcall(function() skillsRemote:FireServer(predictedPos, "NewLightningball") end)
						end
					end
				end
			end

			task.wait(0.001) -- wait mínimo para evitar travar o Roblox
		end
	end)
end



local ToggleFireball = Regui.CreateToggleboxe(PlayerTab,{Text="Auto Fireball IA",Color="Yellow"},function(state)
	PVP.AutoFireIA=state
	if state then PVP_LoopIA("AutoFireIA")

		Regui.NotificationPerson(Window.Frame.Parent, {
			Title = "Alert: AutoFireIA",
			Text = "Auto Fire! State: " .. tostring(PVP.AutoFireIA),
			Icon = "rbxassetid://93478350885441",
			Tempo = 2,
			Casch = {},
			Sound = ""
		}, function()
			print("Notificação fechada!")
		end)		

	end
end)


-- TIMER AutoFire
local SliderInt_AutoFire_IA = Regui.CreateSliderFloat(PlayerTab, {
	Text = "AutoFire Speed IA", 
	Color = "Yellow", 
	Value = 0.3, Minimum = 0.05, Maximum = 1
}, function(state)
	PVP_Timer.AutoFireIA_Speed = state
	print("AutoFire Speed:", state)
end)


local ToggleLightningIA = Regui.CreateToggleboxe(PlayerTab,{Text="Auto Lightning IA",Color="Cyan"},function(state)
	PVP.AutoEletricIA=state
	if state then PVP_LoopIA("AutoEletricIA")

		Regui.NotificationPerson(Window.Frame.Parent, {
			Title = "Alert: Auto Eletric IA",
			Text = "Auto Eletric! State: " .. tostring(PVP.AutoEletricIA),
			Icon = "rbxassetid://93478350885441",
			Tempo = 2,
			Casch = {},
			Sound = ""
		}, function()
			print("Notificação fechada!")
		end)		


	end
end)

-- TIMER AutoEletric
local SliderInt_AutoEletricIA = Regui.CreateSliderFloat(PlayerTab, {
	Text = "AutoLightning IA Speed", 
	Color = "Cyan", 
	Value = 0.3, Minimum = 0.05, Maximum = 1
}, function(state)
	PVP_Timer.AutoEletricIA_Speed = state
	print("AutoLightningIA Speed:", state)
end)

local MemeSucumba= Regui.CreateImage(PlayerTab, {Name = "Meme Suk", Transparence = 1, Alignment = "Center", Id_Image = "rbxassetid://93478350885441", Size_Image = UDim2.new(0, 50, 0, 50)  })

--======================================================================--


--Game Tab
-- Game Tab
local Label_Game_Set_Clan_Invitation = Regui.CreateLabel(GameTab, {
	Text = "Clan Invitation",
	Color = "White",
	Alignment = "Center"
})

local Reset_Timer = 10
local Spaw = false
local invitationEvent_Player = "All"

local invitationEvent_upvr = game.ReplicatedStorage:WaitForChild("invitationEvent")

-- monta lista atual de players
local function getPlayersList()
	local list = {"All"}
	for _, p in ipairs(game.Players:GetPlayers()) do
		table.insert(list, p.Name)
	end
	return list
end

-- cria seletor (callback atualiza invitationEvent_Player)
local selectorPlayers_upvr = Regui.CreateSelectorOpitions(GameTab, {
	Name = "Selecionar Jogador",
	Options = getPlayersList(),
	Type = "string",
	Size_Frame = UDim2.new(1, -20, 0, 100)
}, function(selectedName)
	invitationEvent_Player = selectedName or "All"
end)

-- Função segura para resetar/atualizar o selector (compatível com variações de API)
local function safeResetSelector(obj, newList)
	if not obj then return end
	-- tenta chamar como método: obj:Reset(newList)
	if type(obj.Reset) == "function" then
		local ok = pcall(obj.Reset, obj, newList)
		if not ok then
			-- tenta como função sem self
			pcall(obj.Reset, newList)
		end
		return
	end
	-- alternativas comuns (se a lib usar outro nome)
	if type(obj.SetOptions) == "function" then
		pcall(obj.SetOptions, obj, newList)
		return
	end
	if type(obj.UpdateOptions) == "function" then
		pcall(obj.UpdateOptions, obj, newList)
		return
	end
end

-- atualiza automaticamente quando players entram/saem
game.Players.PlayerAdded:Connect(function()
	safeResetSelector(selectorPlayers_upvr, getPlayersList())
end)
game.Players.PlayerRemoving:Connect(function()
	safeResetSelector(selectorPlayers_upvr, getPlayersList())
end)

-- função que envia convites (usa invitationEvent_Player)
local function sendInvitesTo(name)
	if name == "All" then
		for _, p in ipairs(game.Players:GetPlayers()) do
			pcall(function()
				invitationEvent_upvr:FireServer({
					action = "invite_clan",
					oplr = p
				})
			end)
		end
	else
		local target = game.Players:FindFirstChild(name)
		if target then
			pcall(function()
				invitationEvent_upvr:FireServer({
					action = "invite_clan",
					oplr = target
				})
			end)
		end
	end
end

-- controla apenas uma thread de spawn automática (evita múltiplos loops)
local autoSpawnThread = nil
local function startAutoSpawnLoop()
	if autoSpawnThread then return end -- já rodando
	autoSpawnThread = task.spawn(function()
		-- envia imediato ao ligar
		sendInvitesTo(invitationEvent_Player)

		while Spaw do
			-- aguarda em pequenos passos para continuar responsivo ao desligar
			local waited = 0
			while waited < Reset_Timer and Spaw do
				waited = waited + (task.wait(0.1) or 0.1)
			end
			if not Spaw then break end
			sendInvitesTo(invitationEvent_Player)
		end

		autoSpawnThread = nil
	end)
end

-- Toggle Auto Spaw
local Spaw_Player = Regui.CreateToggleboxe(GameTab, {Text="Auto Spaw: ", Color="Cyan"}, function(state)
	Spaw = state
	if state then
		Regui.NotificationPerson(Window.Frame.Parent, {
			Title = "Spaw: "..invitationEvent_Player ,
			Text = "Auto Spaw: " .. tostring(state),
			Icon = "rbxassetid://93478350885441",
			Tempo = 2,
			Casch = {},
			Sound = ""
		}, function() end)

		startAutoSpawnLoop()
	else
		-- desligando: a thread verá Spaw=false e terminará
		print("Auto Spaw desativado")
	end
end)

-- Slider para controlar tempo de reset da lista
local SliderInt_upvr = Regui.CreateSliderInt(GameTab, {
	Text = "Reset List Clan Invitation",
	Color = "Cyan",
	Value = Reset_Timer, Minimum = 5, Maximum = 60
}, function(state)
	Reset_Timer = state
	print("Novo tempo de reset:", state)
end)


--===========================================--

local Label_Game_Set = Regui.CreateLabel(GameTab, {Text = "-------------------------------", Color = "White", Alignment = "Center"})

local Label_Game_Info = Regui.CreateLabel(GameTab, {Text = "Get Tools", Color = "White", Alignment = "Center"})
-- Botão para pegar a Fireball manual
local GiveAutoFire1 = Regui.CreateButton(GameTab, {
	Text = "Get Fireball Tool",
	Color = "White",
	BGColor = "Blue",
	TextSize = 16
}, function()
	giveTool("Fireball", "NewFireball")
end)

-- Botão para pegar a Lightning manual
local GiveAutoFire2 = Regui.CreateButton(GameTab, {
	Text = "Get Lightning Tool",
	Color = "White",
	BGColor = "Blue",
	TextSize = 16
}, function()
	giveTool("FireballEletric", "NewLightningball")
end)

-- Botão para pegar a Fireball automática
local GiveAutoFire3 = Regui.CreateButton(GameTab, {
	Text = "Get Auto Fireball Tool",
	Color = "White",
	BGColor = "Green",
	TextSize = 16
}, function()
	giveToolAuto("FireballAuto", "NewFireball")
end)

-- Botão para pegar a Lightning automática
local GiveAutoFire4 = Regui.CreateButton(GameTab, {
	Text = "Get Auto Lightning Tool",
	Color = "White",
	BGColor = "Green",
	TextSize = 16
}, function()
	giveToolAuto("LightningAuto", "NewLightningball")
end)

-- Botão para pegar a Lightning automática
local GiveAutoFire5 = Regui.CreateButton(GameTab, {
	Text = "Get Fake Tool",
	Color = "White",
	BGColor = "Green",
	TextSize = 16
}, function()
	giveToolFake("FakePoss", "NewLightningball")
end)

local Memedemonslayer= Regui.CreateImage(GameTab, {Name = "Meme (demon slayer)", Transparence = 1, Alignment = "Center", Id_Image = "rbxassetid://126174945491186", Size_Image = UDim2.new(0, 50, 0, 50)  })

---=======================================--

-- Music Tab
local listMusics = {
	{name = "Nill", Obj = "0"},
	{name = "Hip Hop", Obj = "106732317934236"},
	{name = "Kerosene", Obj = "17647322226"},
	{name = "Crystal Castle", Obj = "5950527670"}
}
-- 🔹 Selector de alvo no topo
local selectorMusics = Regui.CreateSelectorOpitions(MusicTab, {
	Name = "Selecionar Alvo",
	Options = listMusics,
	Type = "Instance",
	Size_Frame = UDim2.new(1, -20, 0, 100)
}, function(selectedObj)
	print("Set: ", selectedObj)
	idmusicRemote:FireServer(selectedObj)
end)

-- Botão para pegar a Musica
local MusicButton = Regui.CreateButton(MusicTab, {
	Text = "Playe: Music Test",
	Color = "White",
	BGColor = "Blue",
	TextSize = 16
}, function()
	idmusicRemote:FireServer("106732317934236")
end)




-- Configs Painter
Regui.CreatePainterPanel(ConfigsTab,{
	{name="Main_Frame", Obj=Window.Frame},
	{name="Top_Bar", Obj=Window.TopBar},
	{name="Tabs_Container", Obj=Window.Tabs}
},function(color,name,obj)
	print("Cor aplicada em:", name,color)
end)

-- Safe TP
RunService.RenderStepped:Connect(function()
	if AF.tpDummy then
		local dummy,_=findDummy(dummiesFolder)
		if dummy and dummy:FindFirstChild("HumanoidRootPart") then
			local _,_,hrp=getCharacter()
			hrp.CFrame=dummy.HumanoidRootPart.CFrame+Vector3.new(0,5,0)
		end
	end
	if AF.tpDummy5k then
		local dummy,_=findDummy(folder5k)
		if dummy and dummy:FindFirstChild("HumanoidRootPart") then
			local _,_,hrp=getCharacter()
			hrp.CFrame=dummy.HumanoidRootPart.CFrame+Vector3.new(0,5,0)
		end
	end
end)


