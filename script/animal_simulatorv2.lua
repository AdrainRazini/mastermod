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



-- FLAGS
local AF = { coins=false, bosses=false, dummies=false, dummies5k=false, tpDummy=false, tpDummy5k=false }
local AF_Timer = {Coins_Speed = 1, Bosses_Speed = 0.05, Dummies_Speed = 1, Dummies5k_Speed = 1}
local PVP = { killAura=false, AutoFire=false, AutoEletric=false, AutoAttack=false, AutoFlyAttack=false, AttackType="Melee" }
local PVP_Timer = {KillAura_Speed = 0.05, AutoFire_Speed = 0.05, AutoEletric_Speed = 0.05, AutoAttack_Speed = 0.05, AutoFlyAttack_Speed = 0.05}
local maxRange = 100


-- Buscar De Dados
-- UTILS
--[[

local function getCharacter()
	local c = player.Character or player.CharacterAdded:Wait()
	return c, c:WaitForChild("Humanoid"), c:WaitForChild("HumanoidRootPart")
end

local function getAliveHumanoid(model)
	local hum = model and model:FindFirstChildOfClass("Humanoid")
	if hum and hum.Health > 0 then return hum end
end

local function findDummy(folder)
	for _, d in ipairs(folder:GetChildren()) do
		local hum = getAliveHumanoid(d)
		if hum then return d, hum end
	end
end

]]
-------------------------

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





local selectedPlayer = nil -- caso seja nil ou "All", usa todos os jogadores

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
					end
				end
			end

			-- Espera de acordo com timer
			local waitTime = PVP_Timer[kind .. "_Speed"] or 0.3
			task.wait(waitTime)
		end
	end)
end

--[[
-- PVP LOOPS
local function PVP_Loop(kind)
	task.spawn(function()
		while PVP[kind] do
			local _, _, hrp = getCharacter()
			local closest, shortest = nil, maxRange
			for _, p in ipairs(Players:GetPlayers()) do
				if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
					local hum = p.Character:FindFirstChildOfClass("Humanoid")
					if hum and hum.Health>0 then
						local dist = (p.Character.HumanoidRootPart.Position-hrp.Position).Magnitude
						if dist<shortest then
							shortest=dist
							closest=p
						end
					end
				end
			end
			if closest then
				local hum = closest.Character:FindFirstChildOfClass("Humanoid")
				local hrpTarget = closest.Character:FindFirstChild("HumanoidRootPart")
				if hum and hrpTarget then
					if kind=="killAura" then
						pcall(function() attackRemote:FireServer(hum,1) end)
					elseif kind=="AutoFire" then
						pcall(function() skillsRemote:FireServer(hrpTarget.Position,"NewFireball") end)
					elseif kind=="AutoEletric" then
						pcall(function() skillsRemote:FireServer(hrpTarget.Position,"NewLightningball") end)
					end
				end
			end
			task.wait(0.3)
		end
	end)
end


]]



-- GUI
local Window = Regui.TabsWindow({Title=GuiName, Text="Animal Simulator", Size=UDim2.new(0,300,0,200)})
local FarmTab = Regui.CreateTab(Window,{Name="Farm"})
local PlayerTab = Regui.CreateTab(Window,{Name="Player"})
local GameTab = Regui.CreateTab(Window,{Name="Game"})
local ConfigsTab = Regui.CreateTab(Window,{Name="Configs"})
local ReadmeTab = Regui.CreateTab(Window,{Name="Readme"})
local Credits = Regui.CreditsUi(ReadmeTab, { Alignment = "Center", Alignment_Texts = "Left"}, function() end)

-- Exemplo de Toggle
local ToggleCoins = Regui.CreateToggleboxe(FarmTab,{Text="Auto Coins",Color="Blue"},function(state)
	AF.coins=state
	if state then autoCoins() end
end)

local SliderFloat_Coins = Regui.CreateSliderFloat(FarmTab, {Text = "Timer Flaot", Color = "Blue", Value = 0.1, Minimum = 0, Maximum = 1}, function(state)
	AF_Timer.Coins_Speed = state
	print("Slider Float clicada! Estado:", AF_Timer.Coins_Speed)

end) 


-- Selector de boss
local selectorFrame = Regui.CreateSelectorOpitions(FarmTab, {
	Name = "Selecionar Alvo Boss",
	Options = {"All", unpack(bossesList)}, -- cria lista: All + bosses
	Type = "String",
	Size_Frame = UDim2.new(1, -20, 0, 50)
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
			Title = "Alert",
			Text = "Checkbox dummies! Estado: " .. tostring(AF.dummies),
			Icon = "fa_envelope",
			Tempo = 10,
			Casch = {},
			Sound = ""
		}, function()
			print("Notificação fechada!")
		end)
	end


end)

local Check_Farme_dummies = Regui.CreateCheckboxe(FarmTab, {Text = "Auto dummies 5K", Color = "Blue"}, function(state)
	AF.dummies5k = state
	--print("Checkbox clicada! Estado:", Test_.Button_Box)

	if AF.dummies5k  then
		attackLoop("dummies5k", folder5k)
		-- Notificação se for Verdadeiro
		Regui.NotificationPerson(Window.Frame.Parent, {
			Title = "Alert",
			Text = "Checkbox dummies5k! Estado: " .. tostring(AF.dummies5k),
			Icon = "fa_envelope",
			Tempo = 10,
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



--- TAB PLAYERS

local Label_Farme = Regui.CreateLabel(PlayerTab, {Text = "PVP Player", Color = "Red", Alignment = "Center"})

-- RANGE GLOBAL
local SliderInt_Range = Regui.CreateSliderInt(PlayerTab, {
	Text = "Max Range", 
	Color = "Blue", 
	Value = 100, Minimum = 100, Maximum = 500
}, function(state)
	maxRange = state
	print("Range atualizado:", maxRange)
end)

-- Exemplo de PVP
local ToggleKillAura = Regui.CreateToggleboxe(PlayerTab,{Text="Kill Aura",Color="Blue"},function(state)
	PVP.killAura=state
	if state then PVP_Loop("killAura") end
end)


-- TIMER KillAura
local SliderInt_KillAura = Regui.CreateSliderInt(PlayerTab, {
	Text = "KillAura Speed", 
	Color = "Blue", 
	Value = 0.3, Minimum = 0.05, Maximum = 1
}, function(state)
	PVP_Timer.KillAura_Speed = state
	print("KillAura Speed:", state)
end)


local ToggleFireball = Regui.CreateToggleboxe(PlayerTab,{Text="Auto Fireball",Color="Yellow"},function(state)
	PVP.AutoFire=state
	if state then PVP_Loop("AutoFire") end
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
	if state then PVP_Loop("AutoEletric") end
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

-- Em Breve ...

local selectorPlayer = Regui.CreateSelectorOpitions(PlayerTab, {
	Name = "Selecionar Alvo",
	Options = {"All", unpack(getPlayerNames())}, -- lista de nomes
	Type = "String",
	Size_Frame = UDim2.new(1, -20, 0, 50)
}, function(val)

	print("Jogador: ", val)
	selectedPlayer = val

end)

task.spawn(function()
	wait(60)
	local opts = { "All" }
	for _, name in ipairs(getPlayerNames()) do
		table.insert(opts, name)
	end
	selectorPlayer.Reset(opts)
end)



--Game Tab



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
