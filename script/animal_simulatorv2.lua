-- ==========================================
-- MastermodV2: Verific Game
-- ==========================================
--[[
-- AutoExec: só roda no jogo ID 5712833750 (Animal Simulator)
if game.PlaceId ~= 5712833750 then
	return -- sai se não for o jogo certo
end
]]



-- ==========================================
-- MastermodV2: Mod Menu + Simulator
-- ==========================================

local ModInfo = {
	Name = "Animal Simulator",
	Version = "3.0.0", -- versão atual
	Date = "2025-09-23",
	Notes = "Nil"
}


-- ==========================================
-- Animal Simulator :)
-- ==========================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local Regui
local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
local GuiName = "Mod_Animal_Simulator_" .. game.Players.LocalPlayer.Name

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





local bossesList = {"Griffin","BOSSBEAR","BOSSDEER","CENTAUR","CRABBOSS","DragonGiraffe","LavaGorilla" }
-- Valor selecionado no selector

local selectedBoss = "All" -- padrão: todos

local ModtpDummy = "Foco"

local selectedPlayerTp = "All"
-- Função principal de farm bosses (cobre ALL e específicos)
local selectedIndexes = {} -- [] = todos, {1,3} = apenas bosses específicos

local selectedPlayer = nil -- caso seja nil ou "All", usa todos os jogadores

local autoAttackIndex = 1 -- controla o ciclo 1-5

-- FLAGS
local AF = { coins=false, bosses=false, afkmod = false, dummies=false, dummies5k=false, tpDummy=false, tpDummy5k=false }
local AF_Timer = {Coins_Speed = 1, Bosses_Speed = 0.05, Dummies_Speed = 1, DummiesTp_Speed = 1}
local PVP = { killAura=false, AutoFire=false, AutoEletric=false, AutoFireIA=false, AutoEletricIA=false, AutoAttack=false, AutoFlyAttack=false, AttackType="Melee", AutoTp = false }
local PVP_Timer = {KillAura_Speed = 0.05, AutoFire_Speed = 0.05, AutoEletric_Speed = 0.05,AutoFireIA_Speed = 0.05, AutoEletricIA_Speed = 0.05, AutoAttack_Speed = 0.05, AutoFlyAttack_Speed = 0.05, AutoTp_Speed = 1}

local maxRange = 100


--=============================================--
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

-- PVP + Dummy


-- Controle Indexs separado para cada pasta
local tpIndexes = {
	dummiesFolder = { index = 1, lastHit = 0 },
	folder5k = { index = 1, lastHit = 0 }
}
local hitCooldown = 0.5 -- tempo entre troca no modo Indexs

-- Função genérica para pegar o alvo dependendo do modo
local function getTarget(folder, mode)
	local dummies = folder:GetChildren()
	if #dummies == 0 then return end

	if mode == "Foco" then
		local dummy, hum = findDummy(folder)
		if dummy and hum then return dummy, hum end

	elseif mode == "Normal" then
		local dummy = dummies[math.random(1, #dummies)]
		local hum = getAliveHumanoid(dummy)
		if dummy and hum then return dummy, hum end
	end
end

local function attackLoop(flag, folder)
	task.spawn(function()
		while AF[flag] do
			local dummy, hum = getTarget(folder, ModtpDummy)
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

local function attackLoopTp(flag, folder)
	task.spawn(function()
		while AF[flag] do
			local dummy, hum = getTarget(folder, ModtpDummy)
			if dummy and hum and dummy:FindFirstChild("HumanoidRootPart") then
				local pos = dummy.HumanoidRootPart.Position
				attackRemote:FireServer(hum, 2)
				skillsRemote:FireServer(pos, "NewFireball")
				skillsRemote:FireServer(pos, "NewLightningball")
			end
			task.wait(AF_Timer.DummiesTp_Speed)
		end
	end)
end


-- AUTO FARM BOSSES
-- Função para mover a câmera do player ou do boss
function movCameraPlr(npc, followBoss)
	local cam = Workspace.CurrentCamera
	local char = player.Character

	if followBoss and AF.afkmod and npc and npc:FindFirstChild("Humanoid") then
		-- Câmera segue o boss
		cam.CameraSubject = npc.Humanoid
		cam.CameraType = Enum.CameraType.Custom
	else
		-- Câmera volta pro player
		if char and char:FindFirstChild("Humanoid") then
			cam.CameraSubject = char.Humanoid
			cam.CameraType = Enum.CameraType.Custom
		end
	end
end

-- AUTO FARM BOSSES Original
-- Função de farm boss
local function farmBossesNormal()
	while AF.bosses and ModBoss == "Normal" do 
		local npcFolder = Workspace:FindFirstChild("NPC") 
		if npcFolder then for _, name in ipairs(bossesList) do 
				local boss = npcFolder:FindFirstChild(name) 
				local hum = getAliveHumanoid(boss) 
				if hum then attackRemote:FireServer(hum, 5) 
				end 
			end 
		end
		task.wait(AF_Timer.Bosses_Speed) 
	end 
end


local function farmBosses()
	task.spawn(function()
		while AF.bosses do
			local npcFolder = Workspace:FindFirstChild("NPC")
			local bossFound = false

			if npcFolder then
				if selectedBoss == "All" then
					if ModBoss == "Foco" then
						-- Ataca só o primeiro boss vivo
						for _, name in ipairs(bossesList) do
							local boss = npcFolder:FindFirstChild(name)
							local hum = getAliveHumanoid(boss)
							if hum then
								bossFound = true
								repeat
									if not AF.bosses then break end
									attackRemote:FireServer(hum, 5)
									if AF.afkmod then movCameraPlr(boss, true) end
									task.wait(AF_Timer.Bosses_Speed)
								until hum.Health <= 0 or not hum.Parent
								break -- Foco = apenas 1 boss
							end
						end
					else
						-- Indexs → percorre os selecionados ou todos
						local indexes = #selectedIndexes > 0 and selectedIndexes or (function()
							local t = {}
							for i = 1, #bossesList do table.insert(t, i) end
							return t
						end)()

						for _, i in ipairs(indexes) do
							local name = bossesList[i]
							local boss = npcFolder:FindFirstChild(name)
							local hum = getAliveHumanoid(boss)
							if hum then
								bossFound = true
								attackRemote:FireServer(hum, 5)
								if AF.afkmod then movCameraPlr(boss, true) end
								task.wait(AF_Timer.Bosses_Speed) -- espera antes do próximo boss
							end
						end
					end
				else
					-- Caso boss específico
					local boss = npcFolder:FindFirstChild(selectedBoss)
					local hum = getAliveHumanoid(boss)
					if hum then
						bossFound = true
						attackRemote:FireServer(hum, 5)
						if AF.afkmod then movCameraPlr(boss, true) end
					end
				end
			end

			if not bossFound or not AF.afkmod then
				movCameraPlr(nil, false)
			end

			task.wait(AF_Timer.Bosses_Speed)
		end

		movCameraPlr(nil, false)
	end)
end





-- Função de farm fixa (com verificação do boss selecionado)
local function farmBossesFix()
	task.spawn(function()

		if not AF.afkmod then
			movCameraPlr(nil, false)
		end

		while AF.bosses do
			local npcFolder = Workspace:FindFirstChild("NPC")
			local bossFound = false

			if npcFolder then
				for _, name in ipairs(bossesList) do
					if selectedBoss == "All" or selectedBoss == name then
						local boss = npcFolder:FindFirstChild(name)
						local hum = getAliveHumanoid(boss)
						if hum then
							bossFound = true
							attackRemote:FireServer(hum, 5)

							if AF.afkmod then
								movCameraPlr(boss, true)
							end
						end
					end
				end
			end

			-- Se nenhum boss válido encontrado OU afkmod desligado, volta para player
			if not bossFound or not AF.afkmod then
				movCameraPlr(nil, false)
			end

			task.wait(AF_Timer.Bosses_Speed)
		end

		-- Saiu do loop => sempre volta a câmera para o player
		movCameraPlr(nil, false)
	end)
end


--===================================================--

--===================================================--

-- PVP LOOP Auras + PVP + Fire

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

-- PVP LOOP + PVP + Teleport

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

--===================--
-- Window Guis Tabs --
-- ⬇ ⬇ ⬇ ⬇ ⬇ ⬇ ⬇ ⬇
--===================--
-- GUI
Window = Regui.TabsWindow({Title=GuiName, Text="Animal Simulator", Size=UDim2.new(0, 350, 0, 250), Icon_btn = true})
FarmTab = Regui.CreateTab(Window,{Name="Farm"})
PlayerTab = Regui.CreateTab(Window,{Name="PVP Player"})
ToolsTab = Regui.CreateTab(Window,{Name="Tools"})
GameTab = Regui.CreateTab(Window,{Name="Game"})
MusicTab = Regui.CreateTab(Window,{Name="Music Player"})
AfkTab = Regui.CreateTab(Window,{Name="Afk Mod"})
ConfigsTab = Regui.CreateTab(Window,{Name="Configs"})
ReadmeTab = Regui.CreateTab(Window,{Name="Readme"})
ExplorerTab = Regui.CreateTab(Window,{Name="Explorer"})


-- Especial Tab
local Credits = Regui.CreditsUi(ReadmeTab, { Alignment = "Center", Alignment_Texts = "Left"}, function() end)
--===================--

Loading_Logo = Instance.new("VideoFrame")
Loading_Logo.Parent = Window.Frame
Loading_Logo.Size = UDim2.new(0, 350, 0, 250)
Loading_Logo.Video = "rbxassetid://90717497825963"
Loading_Logo.Playing = true
Loading_Logo.Volume = 0



local UpdateLog = Regui.CreateButton(ReadmeTab, {
	Text = "New Updates",
	Color = "White",
	BGColor = "Blue",
	TextSize = 16
	--, Size = UDim2.new(1, -10, 0, 30)
}, function()
	Regui.NewsWindow(PlayerGui, {text = "Update ...",TextSize = 5, size ="" }, function(val) end)
end)


MemeDog = Regui.CreateImage(ReadmeTab, {Name = "Meme (Dog)", Transparence = 1, Alignment = "Center", Id_Image = "rbxassetid://90426210033947", Size_Image = UDim2.new(0, 50, 0, 50)  })
MemePirata= Regui.CreateImage(ReadmeTab, {Name = "Meme (Cini)", Transparence = 1, Alignment = "Center", Id_Image = "rbxassetid://73362908559966", Size_Image = UDim2.new(0, 100, 0, 100)  })

--Regui.applyCorner(MemePirata)

--=============-

--=================================--
--=================================--

--===================--
-- Window Afk Tab
-- ⬇ ⬇ ⬇ ⬇ ⬇ ⬇ ⬇ ⬇
--===================--


-- GUI (Regui) Afk_Mod
local TeleportService = game:GetService("TeleportService")

-- FLAGS
local AntiAFK = false
local selectedTimer = 60

-- Timers
local Afk_Timer = 0
local Game_Timer = 0

local Teleports_Accumulated = 0

-- Função para enviar dados no teleport
function sendTeleportData()
	local player = game.Players.LocalPlayer
	Teleports_Accumulated += 1

	local data = {
		AF = AF,
		PVP = PVP,
		PVP_Timer = PVP_Timer,
		AF_Timer = AF_Timer,
		selectedTimer = selectedTimer,
		AntiAFK = AntiAFK,
		Teleports_Accumulated = Teleports_Accumulated,
		reload = true
	}

--[[
	local loader_url = "https://raw.githubusercontent.com/AdrainRazini/mastermod/refs/heads/main/script/animal_simulatorv2.lua"
	local payload = ("loadstring(game:HttpGet('%s'))()"):format(loader_url)

	-- compatibilidade com diferentes executores
	if syn and syn.queue_on_teleport then
		syn.queue_on_teleport(payload)
	elseif queue_on_teleport then
		queue_on_teleport(payload) -- KRNL / outros
	elseif fluxus and fluxus.queue_on_teleport then
		fluxus.queue_on_teleport(payload)
	else
		warn("executor não expõe queue_on_teleport — usar fallback (writefile)")
	end
]]

	local loader_url = "https://raw.githubusercontent.com/AdrainRazini/mastermod/refs/heads/main/script/animal_simulatorv2.lua"

	-- tenta baixar o código principal
	local success, response = pcall(function()
		return game:HttpGet(loader_url)
	end)

	-- se falhar, usa fallback
	if not success or not response or response == "" then
		print("Falha ao carregar URL principal, usando fallback...")
		response = game:HttpGet("https://animal-simulator-server.vercel.app/lua/mod_animal_simulator_v2.lua")
	end

	local payload = ("loadstring(%q)()"):format(response)

	-- compatibilidade com diferentes executores
	if syn and syn.queue_on_teleport then
		syn.queue_on_teleport(payload)
	elseif queue_on_teleport then
		queue_on_teleport(payload) -- KRNL / outros
	elseif fluxus and fluxus.queue_on_teleport then
		fluxus.queue_on_teleport(payload)
	else
		warn("executor não expõe queue_on_teleport — usando fallback (writefile)")
	end



	print("📤 Enviando dados no teleporte:", data)
	TeleportService:Teleport(game.PlaceId, player, data)
end

-- Função para receber dados após teleport (bloqueante)
function receiveTeleportData(timeout)
	timeout = timeout or 5
	local startTime = tick()

	repeat
		task.wait(0.1)
		local data = TeleportService:GetLocalPlayerTeleportData()
		if data and data.reload then
			if data.AF then AF = data.AF end
			if data.PVP then PVP = data.PVP end
			if data.PVP_Timer then PVP_Timer = data.PVP_Timer end
			if data.AF_Timer then AF_Timer = data.AF_Timer end
			if data.selectedTimer then selectedTimer = data.selectedTimer end
			if data.AntiAFK then AntiAFK = data.AntiAFK end
			if data.Teleports_Accumulated then
				Teleports_Accumulated = tonumber(data.Teleports_Accumulated) or Teleports_Accumulated
			end

			print("🔄 Dados recebidos após teleport. Teleports acumulados:", Teleports_Accumulated)

			return true
		end
	until tick() - startTime > timeout

	print("⚠️ Nenhum dado recebido após teleport (timeout).")
	return false
end

-- =================================
-- Espera até receber antes de continuar
-- =================================

print("⏳ Aguardando dados de teleport...")
local ok = receiveTeleportData(5) 
if not ok then
	print("⚠️ Continuando sem dados de teleport (vai usar valores padrão).")
end

wait(5)

Loading_Logo.Visible = false

-- Labels e UI
local Label_AFK_Info = Regui.CreateLabel(AfkTab, {
	Text = "AFK MOD (Beta Test)",
	Color = "White",
	Alignment = "Center"
})


local selectorTimer = Regui.CreateSelectorOpitions(AfkTab, {
	Name = "Selector Tempo",
	Options = {
		{name = "1 Min", Obj = 60 * 1},
		{name = "5 Min", Obj = 60 * 5},
		{name = "10 Min", Obj = 60 * 10},
		{name = "15 Min", Obj = 60 * 15},
		{name = "19 Min", Obj = 60 * 19},
	},
	Type = "Instance",
	Size_Frame = UDim2.new(1, -20, 0, 100)
}, function(val)
	print("Novo tempo selecionado:", val)
	selectedTimer = val
end)

local Label_Check_AintiAFK = Regui.CreateLabel(AfkTab, {
	Text = "--- Check  ---",
	Color = "White",
	Alignment = "Center"
})

local Check_AntiAFK = Regui.CreateCheckboxe(AfkTab, {
	Text = "Ativar AntiAFK",
	Color = "White"
}, function(state)
	AntiAFK = state

	if AntiAFK then
		Regui.NotificationPerson(Window.Frame.Parent, {
			Title = "Alert",
			Text = "AntiAFK ativado!",
			Icon = "fa_envelope",
			Tempo = 10,
			Casch = {},
			Sound = ""
		}, function()
			print("Notificação fechada!")
		end)
	end
end)

local Button_Forced_Teleport = Regui.CreateLabel(AfkTab, {
	Text = "--- Forced_Teleport  ---",
	Color = "White",
	Alignment = "Center"
})



-- Botão 
local Test_Teleport = Regui.CreateButton(AfkTab, {
	Text = "Teleport Gui",
	Color = "White",
	BGColor = "Green",
	TextSize = 16
}, function()
	print("Teleportando para a GUI...")
	-- Envia dados atuais e teleporta
	sendTeleportData()
end)


if AntiAFK then
	Check_AntiAFK.Set(AntiAFK)
end


local SubWin = Regui.SubTabsWindow(AfkTab, {
	Text = "Afk Player",
	Table = {"Logs", "Data"},
	Color = "Blue"
})

local LabelLogs_Timer_Afk_Selector = Regui.CreateLabel(SubWin["Logs"], {
	Text = "AFK Selector timer: 0",
	Color = "White",
	Alignment = "Center"
})

local LabelLogs_Timer_Afk_Acumulador = Regui.CreateLabel(SubWin["Logs"], {
	Text = "Loding...",
	Color = "White",
	Alignment = "Center"
})

local LabelLogs_Timer_Afk = Regui.CreateLabel(SubWin["Logs"], {
	Text = "AFK timer: 0",
	Color = "White",
	Alignment = "Center"
})

local LabelLogs_Timer_Game = Regui.CreateLabel(SubWin["Logs"], {
	Text = "Tempo de jogo: 0",
	Color = "White",
	Alignment = "Center"
})

-- Label para observação do tempo de jogo
local LabelLogs_Timer_Game_Observation = Regui.CreateLabel(SubWin["Logs"], {
	Text = "➡ Tempo total de jogo (não inclui tempo AFK)",
	Color = "White",
	Alignment = "Center"
})

function TimerClock(val)
	local hours = math.floor(val / 3600)
	local minutes = math.floor((val % 3600) / 60)
	local seconds = math.floor(val % 60)
	return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end




-- Update timers com formatação
function update_timers()

	LabelLogs_Timer_Afk_Selector.Text = "➡  Tempo: " .. TimerClock(selectedTimer)
	LabelLogs_Timer_Afk_Acumulador.Text = "Teleports: " .. Teleports_Accumulated
	LabelLogs_Timer_Afk.Text = "➡  AFK timer: " .. TimerClock(Afk_Timer)
	LabelLogs_Timer_Game.Text = "➡  Tempo de jogo: " .. TimerClock(Game_Timer)
	LabelLogs_Timer_Game_Observation.Text = "➡ Tempo AFK: " .. TimerClock(Afk_Timer) 
		.. "\n>= Tempo Escolhido: " .. TimerClock(selectedTimer) 
		.. "\n→ Teleporte + Data(Dados)"
end

local LabelData_Afk_Mod= Regui.CreateLabel(SubWin["Data"], {
	Text = "Loads...",
	Color = "White",
	Alignment = "Center"
})

-- Função para atualizar o label com todas as infos
function updateLabelData()
	local dataText = 
		"➡ AFK Mod:\n" ..
		"➡ Anti AFK: " .. tostring(AntiAFK) .. "\n" ..
		"➡ AF:\n" ..
		"  Coins: " .. tostring(AF.coins) .. "\n" ..
		"  Bosses: " .. tostring(AF.bosses) .. "\n" ..
		"  AfkMod: " .. tostring(AF.afkmod) .. "\n" ..
		"  Dummies: " .. tostring(AF.dummies) .. "\n" ..
		"  Dummies5k: " .. tostring(AF.dummies5k) .. "\n" ..
		"  TpDummy: " .. tostring(AF.tpDummy) .. "\n" ..
		"  TpDummy5k: " .. tostring(AF.tpDummy5k) .. "\n\n" ..

		"➡ AF_Timer:\n" ..
		"  Coins_Speed: " .. AF_Timer.Coins_Speed .. "\n" ..
		"  Bosses_Speed: " .. AF_Timer.Bosses_Speed .. "\n" ..
		"  Dummies_Speed: " .. AF_Timer.Dummies_Speed .. "\n" ..
		"  DummiesTp_Speed: " .. AF_Timer.DummiesTp_Speed .. "\n\n" ..

		"➡ PVP:\n" ..
		"  KillAura: " .. tostring(PVP.killAura) .. "\n" ..
		"  AutoFire: " .. tostring(PVP.AutoFire) .. "\n" ..
		"  AutoEletric: " .. tostring(PVP.AutoEletric) .. "\n" ..
		"  AutoAttackType: " .. tostring(PVP.AttackType) .. "\n\n" ..

		"➡ PVP_Timer:\n" ..
		"  KillAura_Speed: " .. PVP_Timer.KillAura_Speed .. "\n" ..
		"  AutoFire_Speed: " .. PVP_Timer.AutoFire_Speed .. "\n" ..
		"  AutoEletric_Speed: " .. PVP_Timer.AutoEletric_Speed

	LabelData_Afk_Mod.Text = dataText
end


-- Última vez que o player mexeu
local lastInputTime = tick()

UserInputService.InputBegan:Connect(function()
	lastInputTime = tick()
end)

UserInputService.InputChanged:Connect(function()
	lastInputTime = tick()
end)

-- Loop de contagem
task.spawn(function()
	while task.wait(1) do
		Game_Timer += 1  

		if AntiAFK then
			local idleTime = tick() - lastInputTime

			-- Só começa a contar o AFK depois de 60s parado
			if idleTime >= 60 then
				Afk_Timer += 1

				if Afk_Timer >= selectedTimer then
					Regui.NotificationPerson(Window.Frame.Parent, {
						Title = "AntiAFK",
						Text = "Você estava AFK por " .. TimerClock(Afk_Timer) .. ", teleportando...",
						Icon = "fa_envelope",
						Tempo = 8,
						Casch = {},
						Sound = ""
					})

					print("Anti-AFK ativado, teleportando...")
					sendTeleportData()

					Afk_Timer = 0
					lastInputTime = tick()
				end
			else
				Afk_Timer = 0 -- ainda não chegou em 60s, então não conta
			end
		end

		update_timers()
		updateLabelData()
	end
end)

--=================================--
local Memequeque = Regui.CreateImage(AfkTab, {Name = "Meme (??)", Transparence = 1, Alignment = "Center", Id_Image = "rbxassetid://88038371334980", Size_Image = UDim2.new(0, 75, 0, 75)  })
--============--



--===================--
-- Window Farm Tab   --
-- ⬇ ⬇ ⬇ ⬇ ⬇ ⬇ ⬇ ⬇
--===================--
-- Farm
local Label_Farme_AF = Regui.CreateLabel(FarmTab, {Text = "Farme", Color = "White", Alignment = "Center"})
-- Exemplo de Toggle
local ToggleCoins = Regui.CreateToggleboxe(FarmTab,{Text="Auto Coins",Color="Yellow"},function(state)
	AF.coins=state
	if AF.coins then autoCoins() end
end)




local SliderFloat_Coins = Regui.CreateSliderFloat(FarmTab, {Text = "Timer Auto Coins", Color = "Yellow", Value = 0.1, Minimum = 0, Maximum = 1}, function(state)
	AF_Timer.Coins_Speed = state
	print("Slider Float clicada! Estado:", AF_Timer.Coins_Speed)

end) 



local Label_Seletor_Info = Regui.CreateLabel(FarmTab, {Text = "Selector de boss", Color = "White", Alignment = "Center"})
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




local Label_Seletor_Info = Regui.CreateLabel(FarmTab, {Text = "Ativar Farm", Color = "White", Alignment = "Center"})
-- Toggle de Auto Boss
local ToggleBosses = Regui.CreateToggleboxe(FarmTab, {Text="Auto Bosses", Color="Red"}, function(state)
	AF.bosses = state  -- Armazena o estado do toggle

	if AF.bosses then 
		-- Se ativar → inicia farmBosses ou farmBossesNormal
		if selectedBoss == "All" then
			if ModBoss == "Normal" then
				farmBossesNormal()
			else
				farmBosses()
			end
		else
			farmBossesFix()
		end

	end
end)


-- Toggle de AFK Camera
local ToggleBosses_AFK = Regui.CreateToggleboxe(FarmTab, {Text="AFK Camera Bosses", Color="Red"}, function(state)
	AF.afkmod = state

	if AF.afkmod == false then
		-- Se desativar → restaura câmera normal
		game.Workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
		game.Workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character.Humanoid
		movCameraPlr(nil, false)
	end
end)

-- SliderOption para escolher o modo (afeta apenas farmBosses)
local BossOption_Bombox = Regui.CreateSliderOption(FarmTab, {
	Text = "Modo De Ataque",
	Color = "White",
	Background = "Blue",
	Value = 2,
	Table = {"Foco","Indexs", "Normal"}
}, function(state)
	ModBoss = state

end)

-- Timer dos bosses
local SliderFloat_Boosses = Regui.CreateSliderFloat(FarmTab, {
	Text = "Timer Bosses",
	Color = "Blue",
	Value = 0.1,
	Minimum = 0,
	Maximum = 1
}, function(state)
	AF_Timer.Bosses_Speed = state
	print("Timer atualizado:", AF_Timer.Bosses_Speed)
end)



local SliderFloat_dummies = Regui.CreateSliderFloat(FarmTab, {Text = "Timer dummies", Color = "Blue", Value = 1, Minimum = 0, Maximum = 1}, function(state)
	AF_Timer.Dummies_Speed = state
	print("Slider Float clicada! Estado:", AF_Timer.Dummies_Speed)

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

Check_Farme_dummies5k = Regui.CreateCheckboxe(FarmTab, {Text = "Auto dummies 5K", Color = "Blue"}, function(state)
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



SliderFloat_dummies_Tp = Regui.CreateSliderFloat(FarmTab, {Text = "Timer dummies + Tp", Color = "Blue", Value = 1, Minimum = 0, Maximum = 1}, function(state)
	AF_Timer.DummiesTp_Speed = state
	print("Slider Float clicada! Estado:", AF_Timer.DummiesTp_Speed)

end) 



Check_Tp_dummies = Regui.CreateCheckboxe(FarmTab, {Text = "Tp + Auto dummies", Color = "White"}, function(state)
	AF.tpDummy = state
	--print("Checkbox clicada! Estado:", Test_.Button_Box)

	if AF.tpDummy  then
		attackLoopTp("tpDummy", dummiesFolder)
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


Check_Tp_dummies5k = Regui.CreateCheckboxe(FarmTab, {Text = "Tp + Auto dummies 5K", Color = "White"}, function(state)
	AF.tpDummy5k = state
	--print("Checkbox clicada! Estado:", Test_.Button_Box)

	if AF.tpDummy5k  then
		attackLoopTp("tpDummy5k", folder5k)
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

-- SliderOption para escolher o modo (afeta apenas farmBosses)
DummyOption_Bombox = Regui.CreateSliderOption(FarmTab, {
	Text = "Modo De Ataque tpDummy ",
	Color = "White",
	Background = "Blue",
	Value = 1,
	Table = {"Foco", "Normal"}
}, function(state)
	ModtpDummy = state

end)


-- Safe TP

RunService.RenderStepped:Connect(function()
	local _,_,hrp = getCharacter()
	if not hrp then return end

	if AF.tpDummy then
		local dummy, hum = getTarget(dummiesFolder, ModtpDummy)
		if dummy and hum and dummy:FindFirstChild("HumanoidRootPart") then
			hrp.CFrame = dummy.HumanoidRootPart.CFrame + Vector3.new(0,5,0)
		end
	end

	if AF.tpDummy5k then
		local dummy, hum = getTarget(folder5k, ModtpDummy)
		if dummy and hum and dummy:FindFirstChild("HumanoidRootPart") then
			hrp.CFrame = dummy.HumanoidRootPart.CFrame + Vector3.new(0,5,0)
		end
	end

end)


local Label_Farme_Af_Info_Meme = Regui.CreateLabel(FarmTab, {Text = "-------------------------------", Color = "White", Alignment = "Center"})

local Ohyya = Regui.CreateImage(FarmTab, {Name = "Meme", Transparence = 1, Alignment = "Center", Id_Image = "rbxassetid://75961890646911", Size_Image = UDim2.new(0, 50, 0, 50)  })



--===================--
-- Window PVP Tab   --
-- ⬇ ⬇ ⬇ ⬇ ⬇ ⬇ ⬇ ⬇
--===================--

--- TAB PLAYERS

local Label_Farme_PVP_Selector = Regui.CreateLabel(PlayerTab, {Text = "PVP Player", Color = "White", Alignment = "Center"})

-- Criação do selector de players
local selectorPlayer = Regui.CreateSelectorOpitions(PlayerTab, {
	Name = "Selecionar Alvo",
	Options = {"All", unpack(getPlayerNames())}, -- lista inicial de nomes
	Type = "String",
	Size_Frame = UDim2.new(1, -10, 0, 100)
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
	Size_Frame = UDim2.new(1, -10, 0, 100)
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

--- Guardar últimas posições para prever movimento
local lastPositions = {}
local TimerlastPositions = 0.1 -- padrão, pode mudar para 0.005

function PredictPosition(targetRoot, projectileSpeed, iterations)
	iterations = iterations or 5
	local predictedPos = targetRoot.Position
	for i = 1, iterations do
		local distance = (predictedPos - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
		local travelTime = distance / projectileSpeed
		predictedPos = targetRoot.Position + targetRoot.Velocity * travelTime
	end
	return predictedPos
end 

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

						-- tenta predição, se falhar usa linear
						local predictedPos
						local success, result = pcall(PredictPosition, hrpTarget, projectileSpeed)
						if success and result then
							predictedPos = result
						else
							predictedPos = currentPos + (velocity * travelTime)
						end

						-- atualiza memória
						lastPositions[closest] = currentPos

						-- dispara skill
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



local ToggleFireballIA = Regui.CreateToggleboxe(PlayerTab,{Text="Auto Fireball IA",Color="Yellow"},function(state)
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
local Label_Farme_PVP_Info_Meme = Regui.CreateLabel(PlayerTab, {Text = "-------------------------------", Color = "White", Alignment = "Center"})

local MemeSucumba= Regui.CreateImage(PlayerTab, {Name = "Meme Suk", Transparence = 1, Alignment = "Center", Id_Image = "rbxassetid://93478350885441", Size_Image = UDim2.new(0, 100, 0, 100)  })

local MemeSos2= Regui.CreateImage(PlayerTab, {Name = "Meme (Cini)", Transparence = 1, Alignment = "Center", Id_Image = "rbxassetid://90615102202746", Size_Image = UDim2.new(0, 100, 0, 100)  })


--======================================================================--


--=====--
--===================--
-- Verific Function --
-- ⬇ ⬇ ⬇ ⬇ ⬇ ⬇ ⬇ ⬇
--===================--

function verific(toggle, val)
	if val then
		toggle.Set(val)
		--toggle.OnToggle()
	end
end

--=====--

--===================--
-- Verific Locals
-- ⬇ ⬇ ⬇ ⬇ ⬇ ⬇ ⬇ ⬇
--===================--
--=====--
-- AF Farmes
verific(ToggleCoins, AF.coins) 
verific(ToggleBosses, AF.bosses)
verific(Check_Farme_dummies, AF.dummies)
verific(Check_Farme_dummies5k, AF.dummies5k)
verific(Check_Tp_dummies, AF.tpDummy)
verific(Check_Tp_dummies5k, AF.tpDummy5k)
--=====--

--=====--
-- PVP: Player
verific(ToggleKillAura, PVP.killAura)
verific(ToggleAutoAttack, PVP.AutoAttack)
verific(ToggleFireball, PVP.AutoFire)
verific(ToggleLightning, PVP.AutoEletric)
verific(AutoAttackTp, PVP.AutoTp)
--=====--

--=====--
-- PVP: IA
verific(ToggleFireballIA, PVP.AutoFireIA)
verific(ToggleLightningIA, PVP.AutoEletricIA)
--=====--


--======================================================================--



--===================--
-- Window Tools Tab
-- ⬇ ⬇ ⬇ ⬇ ⬇ ⬇ ⬇ ⬇
--===================--

-- Título principal
local Label_Game_Info = Regui.CreateLabel(ToolsTab, {
	Text = "Get Tools",
	Color = "White",
	Alignment = "Center"
})


local Label_Fireball = Regui.CreateLabel(ToolsTab, {
	Text = "--- Fireball Tools ---",
	Color = "White",
	Alignment = "Center"
})

-- Botão para pegar a Fireball manual
local GiveAutoFire1 = Regui.CreateButton(ToolsTab, {
	Text = "Get Fireball Tool",
	Color = "White",
	BGColor = "Button",
	TextSize = 16
}, function()
	giveTool("Fireball", "NewFireball")
end)

local GiveAutoFire1_Icon = Regui.CreateImage(GiveAutoFire1, {
	Name = "FireballIcon",
	Transparence = 1,
	Alignment = "Left",
	Id_Image = "rbxassetid://120451378713427", 
	Size_Image = UDim2.new(0, 25, 0, 25)
})


-- Botão para pegar a Fireball automática
local GiveAutoFire3 = Regui.CreateButton(ToolsTab, {
	Text = "Get Auto Fireball Tool",
	Color = "White",
	BGColor = "Button",
	TextSize = 16
}, function()
	giveToolAuto("FireballAuto", "NewFireball")
end)

local GiveAutoFire3_Icon = Regui.CreateImage(GiveAutoFire3, {
	Name = "FireballAutoIcon",
	Transparence = 1,
	Alignment = "Left",
	Id_Image = "rbxassetid://120451378713427",
	Size_Image = UDim2.new(0, 25, 0, 25)
})


local Label_Lightning = Regui.CreateLabel(ToolsTab, {
	Text = "--- Lightning Tools ---",
	Color = "White",
	Alignment = "Center"
})



-- Botão para pegar a Lightning manual
local GiveAutoFire2 = Regui.CreateButton(ToolsTab, {
	Text = "Get Lightning Tool",
	Color = "White",
	BGColor = "Button",
	TextSize = 16
}, function()
	giveTool("FireballEletric", "NewLightningball")
end)

local GiveAutoFire2_Icon = Regui.CreateImage(GiveAutoFire2, {
	Name = "LightningIcon",
	Transparence = 1,
	Alignment = "Left",
	Id_Image = "rbxassetid://75399074142545", 
	Size_Image = UDim2.new(0, 25, 0, 25)
})


-- Botão para pegar a Lightning automática
local GiveAutoFire4 = Regui.CreateButton(ToolsTab, {
	Text = "Get Auto Lightning Tool",
	Color = "White",
	BGColor = "Button",
	TextSize = 16
}, function()
	giveToolAuto("LightningAuto", "NewLightningball")
end)

local GiveAutoFire4_Icon = Regui.CreateImage(GiveAutoFire4, {
	Name = "LightningAutoIcon",
	Transparence = 1,
	Alignment = "Left",
	Id_Image = "rbxassetid://75399074142545",
	Size_Image = UDim2.new(0, 25, 0, 25)
})


local Label_Teleport = Regui.CreateLabel(ToolsTab, {
	Text = "--- Teleport Tool ---",
	Color = "White",
	Alignment = "Center"
})

-- Botão para pegar a Tool de Teleporte
local GiveTeleportTool = Regui.CreateButton(ToolsTab, {
	Text = "Get Teleport Tool",
	Color = "White",
	BGColor = "Button",
	TextSize = 16
}, function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/AdrainRazini/mastermod/refs/heads/main/script/teleporttool.lua"))()
end)

local GiveTeleportTool_Icon = Regui.CreateImage(GiveTeleportTool, {
	Name = "TeleportIcon",
	Transparence = 1,
	Alignment = "Left",
	Id_Image = "rbxassetid://77789236265753", -- 🌀 Portal azul
	Size_Image = UDim2.new(0, 25, 0, 25)
})



local Label_Fly_Gui = Regui.CreateLabel(ToolsTab, {
	Text = "--- Fly Gui ---",
	Color = "White",
	Alignment = "Center"
})

-- Botão para pegar a Tool de Teleporte
local GiveFly_Gui = Regui.CreateButton(ToolsTab, {
	Text = "Get Fly Gui Tool",
	Color = "White",
	BGColor = "Button",
	TextSize = 16
}, function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/AdrainRazini/mastermod/refs/heads/main/script/flygui.lua"))()
end)

local GiveFly_Gui_Icon = Regui.CreateImage(GiveFly_Gui, {
	Name = "TeleportIcon",
	Transparence = 1,
	Alignment = "Left",
	Id_Image = "rbxassetid://83181120917208", 
	Size_Image = UDim2.new(0, 25, 0, 25)
})




local Label_Tools_Info_Meme = Regui.CreateLabel(ToolsTab, {
	Text = "-------------------------------",
	Color = "White",
	Alignment = "Center"
})

local Memedemonslayer = Regui.CreateImage(ToolsTab, {
	Name = "Meme (demon slayer)",
	Transparence = 1,
	Alignment = "Center",
	Id_Image = "rbxassetid://126174945491186",
	Size_Image = UDim2.new(0, 50, 0, 50)
})

---=======================================--



--===================--
-- Window Game Tab
-- ⬇ ⬇ ⬇ ⬇ ⬇ ⬇ ⬇ ⬇
--===================--



local Label_Game_Set_Clan_Invitation = Regui.CreateLabel(GameTab, {Text = "clan Event", Color = "White", Alignment = "Center"})

--=====--
local Reset_Timer = 10 
local Spaw_Timer = 5
local Invit_Spaw = false

local invitationEvent_upvr = game.ReplicatedStorage:WaitForChild("invitationEvent")
local invitationPlayer = "All"
-- Lista de jogadores
local playersList = {"All"}
for _, p in ipairs(game.Players:GetPlayers()) do
	table.insert(playersList, p.Name)
end


function SetInvit()
	local selectedName = invitationPlayer
	if selectedName == "All" then
		-- Envia convite para todos
		for _, p in ipairs(game.Players:GetPlayers()) do
			invitationEvent_upvr:FireServer({
				action = "invite_clan",
				oplr = p
			})
		end
	else
		-- Envia convite para jogador específico
		local targetPlayer = game.Players:FindFirstChild(selectedName)
		if targetPlayer then
			invitationEvent_upvr:FireServer({
				action = "invite_clan",
				oplr = targetPlayer
			})
		end
	end
end

-- Criação de Cla

-- Criação e gerenciamento de Clã

local clanEvent_upvr = game.ReplicatedStorage:WaitForChild("Events"):WaitForChild("ClanEvent")


local name_Cla = "nil"
local state_Cla = "nil"
local Icon_Cla = "120181810700514"

--===================================================--
-- Função de verificação ou feedback
function Verific_Cla()
	if name_Cla == "nil" or name_Cla == "" then
		Regui.NotificationPerson(Window.Frame.Parent, {
			Title = "Clan System",
			Text = "Please enter a valid clan name!",
			Color = "Red",
			Tempo = 2
		})
		return false
	end
	return true
end

Label_Game_Cla_I = Regui.CreateLabel(GameTab, {Text = "--- Icon Clan ---", Color = "White", Alignment = "Center"})
-- Caixa de texto para nome
local Input_Icon_Cla = Regui.CreateTextBox(GameTab, {
	Placeholder = "Icon Clan...",
	Color = "White",
	BGColor = "DarkGray",
	Size = UDim2.new(1, -10, 0, 30)
}, function(val)
	Icon_Cla = val
end)

Label_Game_Cla_N = Regui.CreateLabel(GameTab, {Text = "--- Name Clan ---", Color = "White", Alignment = "Center"})
-- Caixa de texto para nome
local Input_Text_Cla = Regui.CreateTextBox(GameTab, {
	Placeholder = "Name Clan...",
	Color = "White",
	BGColor = "DarkGray",
	Size = UDim2.new(1, -10, 0, 30)
}, function(val)
	name_Cla = val
end)


local SliderOption_Cla = Regui.CreateSliderOption(GameTab, {
	Text = "Clan Action",
	Color = "White",
	Background = "Blue",
	Value = 1,
	Table = {"Create", "Delete"}
}, function(state)
	state_Cla = state

	if state == "Create" then
		if not Verific_Cla() then return end

		clanEvent_upvr:FireServer({
			action = "create_clan",
			clanToCreate = name_Cla,
			ClanIcon = Icon_Cla -- você pode trocar por outro ID de imagem
		})

		Regui.NotificationPerson(Window.Frame.Parent, {
			Title = "Clan Created",
			Text = "Clan '" .. name_Cla .. "' successfully created!",
			Color = "Green",
			Tempo = 2
		})

	elseif state == "Delete" then
		clanEvent_upvr:FireServer({
			action = "leave_clan"
		})

		Regui.NotificationPerson(Window.Frame.Parent, {
			Title = "Clan Deleted",
			Text = "You have left your clan.",
			Color = "Red",
			Tempo = 2
		})
	end
end)

local Label_Game_Set_Clan_Invitation2 = Regui.CreateLabel(GameTab, {Text = "Clan Invitation", Color = "White", Alignment = "Center"})



local selectorPlayers_upvr = Regui.CreateSelectorOpitions(GameTab, {
	Name = "Selecionar Jogador",
	Options = playersList,
	Type = "string", -- ou "Instance" se quiser enviar o objeto Player
	Size_Frame = UDim2.new(1, -10, 0, 100)
}, function(selectedName)
	invitationPlayer = selectedName
	if Invit_Spaw then
		SetInvit()
	end

end)


local SetSpaw = Regui.CreateToggleboxe(GameTab,{Text="Auto Clan Invitation",Color="Cyan"},function(state)
	Invit_Spaw =state

	if state then
		Regui.NotificationPerson(Window.Frame.Parent, {
			Title = "Alert: " .. invitationPlayer,
			Text = "Auto Spaw State: " .. tostring(Invit_Spaw),
			Icon = "rbxassetid://93478350885441",
			Tempo = 2,
			Casch = {},
			Sound = ""
		}, function()
			print("Notificação fechada!")
		end)		
	end
end)


-- TIMER Auto Spaw
local SliderInt_Spaw = Regui.CreateSliderFloat(GameTab, {
	Text = "Spaw Timer", 
	Color = "Cyan", 
	Value = 1, Minimum = 0, Maximum = 1
}, function(state)
	Spaw_Timer = state
	print("Reset da lista de convites:", state)
end)


-- TIMER Auto Reset da lista de jogadores
local SliderInt_Reset_List = Regui.CreateSliderFloat(GameTab, {
	Text = "Reset List Clan Invitation", 
	Color = "Cyan", 
	Value = 10, Minimum = 10, Maximum = 60
}, function(state)
	Reset_Timer = state
	print("Reset da lista de convites:", state)
end)

-- reset da lista de jogadores a cada 10 segundos
task.spawn(function()
	while true do
		task.wait(Reset_Timer)
		selectorPlayers_upvr.Reset(playersList)
	end
end)
task.spawn(function()
	while true do
		task.wait(Spaw_Timer)
		if Invit_Spaw then
			SetInvit()
		end
	end
end)



--=== test 
local Label_Game_Set_Clan_Forced_Join = Regui.CreateLabel(GameTab, {Text = "Forced Join", Color = "White", Alignment = "Center"})


local teams_game = Workspace:FindFirstChild("Teams")
local forced_accept = nil


--==============================--
-- 🔹 Função para pegar todos os clãs como lista de strings
function getClans()
	local clans = {"Nill"} -- opção padrão
	if teams_game then
		for _, folder in pairs(teams_game:GetChildren()) do
			if folder:IsA("Folder") then
				table.insert(clans, folder.Name) -- só o nome como string
			end
		end
	end
	return clans
end

--==============================--
-- 🔹 Selector de clãs (string)
local selector_Clan_forced = Regui.CreateSelectorOpitions(GameTab, {
	Name = "Selecionar Clã",
	Options = getClans(),
	Type = "string", -- agora é string
	Size_Frame = UDim2.new(1, -10, 0, 100)
}, function(selectedName)
	forced_accept = selectedName
end)

--==============================--
-- 🔹 Slider de ação do clã (Join / Leave)
local SliderOption_Forced_Cla = Regui.CreateSliderOption(GameTab, {
	Text = "Clan Action",
	Color = "White",
	Background = "Blue",
	Value = 1,
	Table = {"Join", "Leave"}
}, function(state)
	if not forced_accept then return end

	if state == "Join" then

		invitationEvent_upvr:FireServer({
			teamIcon = "101534974401621",
			action = "accepted",
			teamName = forced_accept
		})

	elseif state == "Leave" then
		clanEvent_upvr:FireServer({
			action = "leave_clan"
		})

		Regui.NotificationPerson(Window.Frame.Parent, {
			Title = "Clan leave_clan",
			Text = "You have left your clan.",
			Color = "Red",
			Tempo = 2
		})
	end
end)

-- 🔹 Atualiza lista de clãs a cada 30s
task.spawn(function()
	while task.wait(30) do
		selector_Clan_forced.Reset(getClans())
	end
end)



--===========================================--

local Label_Game_Set = Regui.CreateLabel(GameTab, {Text = "-------------------------------", Color = "White", Alignment = "Center"})
local MemeCinemelayer= Regui.CreateImage(GameTab, {Name = "Meme (Cini)", Transparence = 1, Alignment = "Center", Id_Image = "rbxassetid://84478265118657", Size_Image = UDim2.new(0, 75, 0, 75)  })

--============================--

--===================--
-- Window Music Tab   
-- ⬇ ⬇ ⬇ ⬇ ⬇ ⬇ ⬇ ⬇
--===================--


local MarketplaceService = game:GetService("MarketplaceService")

local Label_Music_Info = Regui.CreateLabel(MusicTab, {Text = "Boombox", Color = "White", Alignment = "Center"})

local SetBombox= "Stop"
local IdBombox = "0"

function SetMusic()
	if SetBombox == "Play"  then
		idmusicRemote:FireServer(IdBombox)
	elseif SetBombox == "Stop" then
		idmusicRemote:FireServer("0")
	end
end

local Input_Text = Regui.CreateTextBox(MusicTab, {
	Placeholder = "ID Bombox",
	Color = "White", -- cor do texto
	BGColor = "DarkGray", -- cor de fundo
	Size = UDim2.new(1, -10, 0, 30)
}, function(val)
	print("ID digitado:", val) -- aqui você recebe o valor digitado
	IdBombox = val
end)

local SliderOption_Bombox = Regui.CreateSliderOption(MusicTab, {Text = "Music", Color = "White", Background = "Blue" , Value = 1, Table = {"Play","Stop"}}, function(state)
	SetBombox = state
	SetMusic()
	print("Slider Int clicada! Estado:", SetBombox)
end)

local Label_Game_Set_Music = Regui.CreateLabel(MusicTab, {Text = "-------------------------------", Color = "White", Alignment = "Center"})

-- Lista só com IDs (sem repetições)


Listaid = {
	91233243522140,
	116874163291138,
	114727662968481,
	98337901681441,
	102402883551679,
	122761529841977,
	87909146687252,
	127512475318182,
	119936139925486,
	105854178411388,
	87233041213837,
	121516877792091,
	85833437298815,
	94494416095572,   -- Ghost fight
	115656438192853,  -- A Engimatical Encounter
	96357207714662,   -- Stronger Twan ya chara
	107986977620509,  -- Asgore
	101378669026310,  -- The Skeletons Last Breath
	109606503605402,  -- Hammer of Justice
	112512564227744,
	104621031886653,
	83914052148279,
	117236780703437,
	81552567379452,
	123809083385992,
	112748273890049,
	137155874195108,
	106958630419629,
	72320758533508,
	127063071194532,
	139667113842953,
	90627119202018,
	118507373399694,
	93058983119992,
	92295159623916,  -- DJ Raimundo
	139218946376655, -- Rat Dance
	97567416166163,
	106732317934236,
	17647322226,     -- Kerosene
	132517043416676,
	15689448519,
	16190782786,
	1837006787,
	1837014531,
	131847084942844,
	95046091312570,
	111318048787674,
	93958751571254,
	120102995443063,
	120138115344262,
	104575671082804,
	131689610122547,
	13530439660,
	14366981664,
	16831107981,
	129112111571462,
	15689445424,
	15689450026,
	126713629899826,
	77766610441787,
	18841891575,
	120871403922972,
	95554192381753,
	126372814380356,
	123517126955383,
	105102042077619,
	92715012838361,
	84053362849165,
	75146085667327,
	86511617909610,
	16190783444,
	100697759026652,
	127868004681532,
	1839246711,
	103504594968244,
	80946196913756,
	93751275110337,
	109840843335222,
	110035574248336,
	104567749101480,
	18841888868,
	85075816659415,
	96028783423401,
	125200420795517,
	92446612272052,
	107683146338584,
	79953696595578,
	129212629624727,
	87554448466409,
	121489264497741, -- Adn 01
	70961757130479,
	97413868131214,
	93245387354226,
	72444649335619,
	1837111443,
	5410084802,
	103524199324615,
	127219133263020,
	100697759026652,
	120885023497936,
	5410082468,
	1836847994,
	71392021424658,
	86685635786943,
	76312991186384,
	81700399219236, -- Adn 2
	88339486019486, 
	96974354995715, 
	139693447546059, 
	131847084942844, 
	104828343009296,
	111564073986749, -- Adn 3
	85994915142182,
	99128910197696, -- Adn 4
	135690618125311,
	105633366460252,
	113324443761127,
	105423792227242,
	71956674693421, -- Adn 5
	120785124326826,
	126257401176561,
	132082397247824,
	78744747224727, -- Adn 6 
	77188110491285,
	87658459636001,
	108710061480904,
	123580060732562,
	104449595639237,
	97557092981429,
	74312901272425,
	75982342509801,
	75805949198978,
	113184121463834,
	122127808613347,
	110772573905578,
	1836654054,
	95554192381753,
	139834501955751,
	104596909675653,
	72811197789142,
	1836789357,
	1836654190,
	123229005251213,
}


-- Lista com nome e ID
local listMusics = {
	{name = "Stop", Obj = "0"},
	{name = "MONTAGEM PODER IV (SLOWED)", Obj = "91233243522140"},
	{name = "BRAZILIAN DRIFT MUSIC", Obj = "116874163291138"},
	{name = "Montagem Tomada", Obj = "114727662968481"},
	{name = "Mente ma", Obj = "98337901681441"},
	{name = "Red Chains", Obj = "102402883551679"},
	{name = "SHADOWS", Obj = "122761529841977"},
	{name = "Cool", Obj = "87909146687252"},
	{name = "BAD", Obj = "127512475318182"},
	{name = "BEM SOLTO BRAZIL!", Obj = "119936139925486"},
	{name = "AMOGUS.BABOBOI JUMPSTYLE", Obj = "105854178411388"},
	{name = "Winter", Obj = "87233041213837"},
	{name = "Montagem Primo", Obj = "121516877792091"},
	{name = "jumpstyle", Obj = "85833437298815"},
	{name = "Ghost Fight (Hard Bounce Flip)", Obj = "94494416095572"},
	{name = "A Engimatical Encounter", Obj = "115656438192853"},
	{name = "stronger than ya chara response", Obj = "96357207714662"},
	{name = "ASGORE", Obj = "107986977620509"},
	{name = "the skeletons last breath", Obj = "101378669026310"},
	{name = "Hammer of Justice", Obj = "109606503605402"},
	{name = "LIT!", Obj = "112512564227744"},
	{name = "Empina na onda (feito por keven)", Obj = "104621031886653"},
	{name = "MTG MIND GAME", Obj = "83914052148279"},
	{name = "The World Between Us", Obj = "117236780703437"},
	{name = "Toque Phonk", Obj = "81552567379452"},
	{name = "FUNK ALL THE TIME", Obj = "123809083385992"},
	{name = "No Era Amor", Obj = "112748273890049"},
	{name = "unleaked bypassed song", Obj = "137155874195108"},
	{name = "crazy-lol (XL & NGI)", Obj = "106958630419629"},
	{name = "SAD!", Obj = "72320758533508"},
	{name = "shawty", Obj = "127063071194532"},
	{name = "KATANAZ!", Obj = "139667113842953"},
	{name = "Montagem Mysterious", Obj = "90627119202018"},
	{name = "melodia de verão (tiktok edit)", Obj = "118507373399694"},
	{name = "MONTAGEM ECLIPSE ESTELAR", Obj = "93058983119992"},
	{name = "100℅ Forrozin De Vaquejada Tema Dj Raimundo Pedras", Obj = "92295159623916"},
	{name = "aw YEA", Obj = "139218946376655"},
	{name = "pisada XL 2", Obj = "97567416166163"},
	{name = "Fat Rat", Obj = "106732317934236"},
	{name = "Kerosene", Obj = "17647322226"},
	{name = "MONTAGEM ELECTRONICA - Mega slowed", Obj = "132517043416676"},
	{name = "Din1c - can you", Obj = "15689448519"},
	{name = "Lil Kuudere, sukoyomi - Alone", Obj = "16190782786"},
	{name = "You Ain't Hot Enough", Obj = "1837006787"},
	{name = "Tired Of You", Obj = "1837014531"},
	{name = "Embora", Obj = "131847084942844"},
	{name = "pai", Obj = "95046091312570"},
	{name = "PASSO BEM SOLTO SUBMUNDO", Obj = "111318048787674"},
	{name = "So clean", Obj = "93958751571254"},
	{name = "Stray", Obj = "120102995443063"},
	{name = "MONTAGEM BANDIDO 2.0", Obj = "120138115344262"},
	{name = "Tele", Obj = "104575671082804"},
	{name = "GATINHA", Obj = "131689610122547"},
	{name = "0to8,1xmxxd - stop posting about baller - sped up", Obj = "13530439660"},
	{name = "SAKU - GTA (Nightcore)", Obj = "14366981664"},
	{name = "Prismo - Solo", Obj = "16831107981"},
	{name = "MONTAGEM SUCESSO", Obj = "129112111571462"},
	{name = "Din1c - Dionic 2", Obj = "15689445424"},
	{name = "jugsta - skeletons", Obj = "15689450026"},
	{name = "MORTAL", Obj = "126713629899826"},
	{name = "Dopamine Rat", Obj = "77766610441787"},
	{name = "d3r, m1v, asteria - no escape", Obj = "18841891575"},
	{name = "CUTEMAKMAKFUNK (Slowed)", Obj = "120871403922972"},
	{name = "The Flames On Fire", Obj = "95554192381753"},
	{name = "edit", Obj = "126372814380356"},
	{name = "MONTAGEM SKY HIGH", Obj = "123517126955383"},
	{name = "RITMO SELVAGEM", Obj = "105102042077619"},
	{name = "OFFLINE", Obj = "92715012838361"},
	{name = "A última chance", Obj = "84053362849165"},
	{name = "bing", Obj = "75146085667327"},
	{name = "Cute cat music audio", Obj = "86511617909610"},
	{name = "nMisaki - Dubidubidu (Uptempo Remix)", Obj = "16190783444"},
	{name = "Schnuffel", Obj = "100697759026652"},
	{name = "FUNK DANCE OF EPHORIA LA LA!", Obj = "127868004681532"},
	{name = "Jumpstyle", Obj = "1839246711"},
	{name = "Dark Night", Obj = "103504594968244"},
	{name = "I need you", Obj = "80946196913756"},
	{name = "MOMENTS", Obj = "93751275110337"},
	{name = "Underworld", Obj = "109840843335222"},
	{name = "dark_mov", Obj = "110035574248336"},
	{name = "introduce", Obj = "104567749101480"},
	{name = "d3r - love bomb", Obj = "18841888868"},
	{name = "no feelinngs", Obj = "85075816659415"},
	{name = "Funk Sigcuro (Ultra Slowed)", Obj = "96028783423401"},
	{name = "tomagi mo tão Anime ver.", Obj = "125200420795517"},
	{name = "MTG ZUM ZUM ZUM VIRAL FUNK BH", Obj = "92446612272052"},
	{name = "Minha Estória (Musica Oficial)", Obj = "107683146338584"},
	{name = "Batidão na Aldeia (Musica Oficial)", Obj = "79953696595578"},
	{name = "Eu Duvido (Musica Oficial)", Obj = "129212629624727"},
	{name = "SOLDIER", Obj = "87554448466409"},
	{name = "my phone", Obj = "121489264497741"},
	{name = "MONTAGEM RENICHT CALAMITY [LOOP}", Obj = "70961757130479"},
	{name = "National Anthem of the U.S.S.R.", Obj = "97413868131214"},
	{name = "swurve swurving", Obj = "93245387354226"},
	{name = "CAR CRUSHERS 2 FUNK", Obj = "72444649335619"},
	{name = "For the Summer", Obj = "1837111443"},
	{name = "Pixel Terror & EMELINE - Chroma", Obj = "5410084802"},
	{name = "yoy799 she loves me", Obj = "103524199324615"},
	{name = "okay tyler", Obj = "127219133263020"},
	{name = "Schnuffel", Obj = "100697759026652"},
	{name = "WannaBeHer", Obj = "120885023497936"},
	{name = "Snavs - Us", Obj = "5410082468"},
	{name = "On Top Of The World", Obj = "1836847994"},
	{name = "UNFORESEEABLE", Obj = "71392021424658"},
	{name = "Auto toma", Obj = "86685635786943"},
	{name = "Pancadão", Obj = "76312991186384"},
	{name = "montagem Celestial", Obj = "81700399219236"},
	{name = "montagem pose", Obj = "88339486019486"}, 
    {name = "Seguuura", Obj = "96974354995715"}, 
	{name = "Fininha", Obj = "139693447546059"},
	{name = "Embora", Obj = "131847084942844"},
	{name = "montagem do silvio", Obj = "104828343009296"},
	{name = "lump lumps", Obj = "111564073986749"}, -- Adn 3
	{name = "505 timess", Obj = "85994915142182"}, 
	{name = "Mutilation 1.4", Obj = "99128910197696"}, -- Adn 4
    {name = "cinema", Obj = "135690618125311"}, 
    {name = "LOGOKIDS Prismz", Obj = "105633366460252"},
	{name = "out of legaue", Obj = "113324443761127"}, 
	{name = "klnoLOZ303", Obj = "105423792227242"}, 
	{name = "scary", Obj = "71956674693421"},
	{name = "Who's So Autonomous?", Obj = "120785124326826"},  
	{name = "MorningLight☆GrayArea☆ホームページタイマー", Obj = "126257401176561"},
	{name = "V2 daquela", Obj = "132082397247824"}, -- Adn 6
	{name = "Boss Fight!", Obj = "78744747224727"}, 
	{name = "I Know!", Obj = "77188110491285"}, 
	{name = "VITRIOL", Obj = "87658459636001"}, 
	{name = "//MACH:BREAKER", Obj = "108710061480904"},  
	{name = "AS ABOVE, SO BELOW", Obj = "123580060732562"}, 
	{name = "Black Knife", Obj = "104449595639237"},  
	{name = "DOOM ETERNAL", Obj = "97557092981429"},
	{name = "Cold Cannon", Obj = "74312901272425"},  
	{name = "Gothic Song", Obj = "75982342509801"}, 
	{name = "Forsaken Dominion", Obj = "75805949198978"}, 
	{name = "Remember the Soul", Obj = "113184121463834"}, 
	{name = "RAGE SYSTEM", Obj = "122127808613347"}, 
	{name = "D.A.D.", Obj = "110772573905578"},  
	{name = "She's So Dumb", Obj = "1836654054"}, 
	{name = "The Flames On Fire", Obj = "95554192381753"},
	{name = "HALLOWEEN FUNK", Obj = "139834501955751"}, 
	{name = "Phonk da Rua", Obj = "104596909675653"},  
	{name = "SAVAGE GHOST SLOWED Phonk (Super Slowed)", Obj = "72811197789142"}, 
	{name = "Wheels Of Madness", Obj = "1836789357"},  
	{name = "Never Grow Up", Obj = "1836654190"},  
	{name = "Smooth Time", Obj = "123229005251213"},
}




function getnamesbox(list)
	local newList = {}

	for _, id in ipairs(list) do
		local success, info = pcall(function()
			return MarketplaceService:GetProductInfo(id)
		end)

		if success and info then
			table.insert(newList, {name = info.Name, Obj = tostring(id)})
		else
			table.insert(newList, {name = "???", Obj = tostring(id)})
		end
	end

	return newList
end




-- Botão para pegar a Fireball manual
Music_Gui = Regui.CreateButton(MusicTab, {
	Text = "Music_Gui",
	Color = "White",
	BGColor = "Button",
	TextSize = 16
}, function()
	loadstring(game:HttpGet("https://animal-simulator-server.vercel.app/lua/Music_ids.lua"))() 
end)

-- 🔹 Selector de alvo no topo
local selectorMusics = Regui.CreateSelectorOpitions(MusicTab, {
	Name = "Selecionar Musica",
	Options = listMusics,
	Type = "Instance",
	Size_Frame = UDim2.new(1, -10, 0, 150)
}, function(selectedObj)
	print("Set: ", selectedObj)
	--Input_Text.SetVal(selectedObj)
	idmusicRemote:FireServer(selectedObj)
end)

local Visor = false
local ActiveBoards = {} -- armazenamento das GUIs criadas

-- Função que cria o visor sobre o player
local function CreateMusicBoard(player, sound)
	if ActiveBoards[player] then
		ActiveBoards[player]:Destroy()
		ActiveBoards[player] = nil
	end

	local info
	pcall(function()
		info = MarketplaceService:GetProductInfo(sound.SoundId:gsub("%D", ""), Enum.InfoType.Asset)
	end)

	if not info then return end

	-- Cria BillboardGui no Root
	local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if not root then return end

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "Boombox_Visor"
	billboard.Adornee = root
	billboard.Size = UDim2.new(0, 200, 0, 50)
	billboard.StudsOffset = Vector3.new(0, 4, 0)
	billboard.AlwaysOnTop = true
	billboard.Parent = root

	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundTransparency = 0.3
	textLabel.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
	textLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
	textLabel.Font = Enum.Font.GothamBold
	textLabel.TextScaled = true
	textLabel.Text = string.format("%s\nID: %s", info.Name, sound.SoundId:gsub("%D", ""))
	textLabel.Parent = billboard

	ActiveBoards[player] = billboard

	-- Se o som for removido, remove o visor
	sound.AncestryChanged:Connect(function(_, parent)
		if not parent and billboard then
			billboard:Destroy()
			ActiveBoards[player] = nil
		end
	end)
end

-- Função que monitora os players e cria/remover visores
function CreatGuiBoards()
	task.spawn(function()
		while Visor do
			for _, player in ipairs(Players:GetPlayers()) do
				local char = player.Character
				if char then
					local root = char:FindFirstChild("HumanoidRootPart")
					if root then
						local sound = root:FindFirstChildOfClass("Sound")
						if sound and sound.SoundId ~= "" then
							if not ActiveBoards[player] then
								CreateMusicBoard(player, sound)
							end
						else
							if ActiveBoards[player] then
								ActiveBoards[player]:Destroy()
								ActiveBoards[player] = nil
							end
						end
					end
				end
			end
			task.wait(0.5)
		end

		-- Se desativar, limpa tudo
		for _, gui in pairs(ActiveBoards) do
			gui:Destroy()
		end
		table.clear(ActiveBoards)
	end)
end

local Label_Music_Info_BT = Regui.CreateLabel(MusicTab, {Text = "---- Visor Id Boombox ----", Color = "White", Alignment = "Center"})

-- Toggle GUI
local Toggle_Visor_Ids = Regui.CreateToggleboxe(MusicTab, {Text="Visor Id Boombox", Color="Cyan"}, function(state)
	Visor = state

	if state then 
		Regui.NotificationPerson(Window.Frame.Parent, {
			Title = "Visor Id Boombox",
			Text = "Visor ativado: " .. tostring(Visor),
			Icon = "rbxassetid://93478350885441",
			Tempo = 2,
			Casch = {},
			Sound = ""
		}, function()
			print("Notificação fechada!")
		end)

		CreatGuiBoards()
	else
		-- Desativar visores
		for _, gui in pairs(ActiveBoards) do
			gui:Destroy()
		end
		table.clear(ActiveBoards)
	end
end)




--=======================--


-- Botão para pegar a Musica
-- Test De Salvamento do ID da musica

local Save_Id = "0"

-- Label que mostra info da música
local Label_Music_Info_Save = Regui.CreateLabel(MusicTab, {
	Text = "_Music_",
	Color = "White",
	Alignment = "Center"
})

-- Função segura para atualizar info da música
local function updateMusicInfo()
	if not Save_Id or Save_Id == "" then
		Label_Music_Info_Save.Text = "_Music_"
		return
	end

	local success, info = pcall(function()
		return MarketplaceService:GetProductInfo(Save_Id)
	end)

	if success and info then
		Label_Music_Info_Save.Text = info.Name or "_Music_"
	else
		Label_Music_Info_Save.Text = "ID inválido!"
	end
end

-- Input de ID
local Input_Text_Save = Regui.CreateTextBox(MusicTab, {
	Placeholder = "ID Bombox",
	Color = "White",
	BGColor = "DarkGray",
	Size = UDim2.new(1, -10, 0, 30)
}, function(val)
	Save_Id = val
	updateMusicInfo() -- Atualiza automaticamente ao digitar
end)

-- Botão de salvar
-- Função para verificar se um ID já existe na lista
local function idExists(list, id)
	for _, v in ipairs(list) do
		if v == id then
			return true
		end
	end
	return false
end

-- Botão de salvar
local MusicButton = Regui.CreateButton(MusicTab, {
	Text = "Save ID",
	Color = "White",
	BGColor = "Blue",
	TextSize = 16
}, function()
	if not Save_Id or Save_Id == "" then
		print("Nenhum ID para salvar")
		return
	end

	-- Tenta pegar info da música de forma segura
	local success, info = pcall(function()
		return MarketplaceService:GetProductInfo(Save_Id)
	end)

	if success and info then
		-- Verifica se o ID já existe
		if not idExists(Listaid, Save_Id) then
			table.insert(Listaid, Save_Id) -- adiciona na lista
			updateMusicInfo() -- atualiza label
			selectorMusics.Reset(getnamesbox(Listaid)) -- atualiza selector
			print("ID adicionado:", Save_Id)
		else
			-- ID já existe
			Regui.NotificationPerson(Window.Frame.Parent, {
				Title = "ID Existente",
				Text = "ID Music: " .. Save_Id,
				Icon = "fa_rr_paper_plane",
				Tempo = 5,
				Casch = {},
				Sound = ""
			}, function()
				print("Notificação fechada!")
			end)
		end
	else
		-- ID inválido
		print("ID inválido:", Save_Id)
		Regui.NotificationPerson(Window.Frame.Parent, {
			Title = "ID Inválido",
			Text = "ID Music: " .. Save_Id,
			Icon = "fa_rr_paper_plane",
			Tempo = 5,
			Casch = {},
			Sound = ""
		}, function()
			print("Notificação fechada!")
		end)
	end
end)


local Label_Mousic_Info_Meme = Regui.CreateLabel(MusicTab, {Text = "-------------------------------", Color = "White", Alignment = "Center"})
MemeBacon = Regui.CreateImage(MusicTab, {Name = "Meme (Noob anime)", Transparence = 1, Alignment = "Center", Id_Image = "rbxassetid://78869446287665", Size_Image = UDim2.new(0, 75, 0, 75)  })
--local MemeBombox = Regui.CreateImage(MusicTab, {Name = "Meme (Bombox)", Transparence = 1, Alignment = "Center", Id_Image = "rbxassetid://114187709278379", Size_Image = UDim2.new(0, 50, 0, 75)  })
-- 



--=================================--
--=================================--

--===================--
-- Window Configs Tab
-- ⬇ ⬇ ⬇ ⬇ ⬇ ⬇ ⬇ ⬇
--===================--




Size_Window_Choice = "Normal"

-- Função que ajusta o tamanho da janela
function Set_Size(Obj)
	if Size_Window_Choice == "Pequeno" then
		Obj.Size = UDim2.new(0, 300, 0, 200)
	elseif Size_Window_Choice == "Normal" then
		Obj.Size = UDim2.new(0, 350, 0, 250)
	elseif Size_Window_Choice == "Grande" then
		Obj.Size = UDim2.new(0, 400, 0, 300)
	end
end

-- SliderOption para escolher o tamanho da janela
local Slider_Size = Regui.CreateSliderOption(ConfigsTab, {
	Text = "Tamanho Da Janela",
	Color = "White",
	Background = "Blue",
	Value = 2, -- valor inicial
	Table = {"Pequeno", "Normal", "Grande"} -- opções
}, function(state)
	Size_Window_Choice = state -- atualiza a variável
	Set_Size(Window.Frame) -- aplica o tamanho na janela
end)



local Label_Music_Info_Paint = Regui.CreateLabel(ConfigsTab, {Text = "Pintura", Color = "White", Alignment = "Center"})
-- Configs Painter
Regui.CreatePainterPanel(ConfigsTab,{
	{name="Main_Frame", Obj=Window.Frame},
	{name="Top_Bar", Obj=Window.TopBar},
	{name="Tabs_Container", Obj=Window.Tabs}
},function(color,name,obj)
	print("Cor aplicada em:", name,color)
end)


local DeleteGui = Regui.CreateButton(ConfigsTab, {
	Text = "Delete GUI",
	Color = "White",
	BGColor = "Blue",
	TextSize = 16
}, function(val)
	print("Delete GUI")
	Regui.NotificationDialog(Window.Frame.Parent, {
		Title = "Deletar Gui !",
		Text = "Deseja Deletar agora?",
		Icon = "fa_envelope", -- qualquer ícone do seu dicionário
		Tempo = 0 -- 0 = só fecha no clique
	}, function(result)
		if result then
			-- Resetar todas as flags do AF
			for k, _ in pairs(AF) do
				AF[k] = false
			end

			-- Resetar todas as flags do PVP
			for k, _ in pairs(PVP) do
				if type(PVP[k]) == "boolean" then
					PVP[k] = false
				end
			end

			-- Resetar timers para 0 ou padrão
			for k, _ in pairs(AF_Timer) do
				AF_Timer[k] = 0
			end

			for k, _ in pairs(PVP_Timer) do
				PVP_Timer[k] = 0
			end

			-- Destruir GUI e script
			local Scren = Window.screenGui
			Scren:Destroy()
			script:Destroy()
		else
			-- Usuário cancelou ❌
		end
	end)
end)

Memeque = Regui.CreateImage(ConfigsTab, {Name = "Meme (?)", Transparence = 1, Alignment = "Center", Id_Image = "rbxassetid://136319203684781", Size_Image = UDim2.new(0, 75, 0, 75)  })



--===================--
-- Window Explorer Tab
-- ⬇ ⬇ ⬇ ⬇ ⬇ ⬇ ⬇ ⬇
--===================--

local Label_Explorer_Info = Regui.CreateLabel(ExplorerTab, {Text = "Explorer Game", Color = "White", Alignment = "Center"})

local Simple_Spy  = Regui.CreateButton(ExplorerTab, {
	Text = "Simple Spy",
	Color = "White",
	BGColor = "Blue",
	TextSize = 16
}, function()

	print("Delete GUI")
	Regui.NotificationDialog(Window.Frame.Parent, {
		Title = "Função Avançada!",
		Text = "Deseja Usar agora?",
		Icon = "fa_envelope", -- qualquer ícone do seu dicionário
		Tempo = 0 -- 0 = só fecha no clique
	}, function(result)
		if result then
			loadstring(game:HttpGet("https://github.com/exxtremestuffs/SimpleSpySource/raw/master/SimpleSpy.lua"))()
		else
			--print("Usuário recusou ❌")
		end
	end)


end)

--[[
local Simple_test  = Regui.CreateButton(ExplorerTab, {
	Text = "test Image",
	Color = "White",
	BGColor = "Blue",
	TextSize = 16
	--, Size = UDim2.new(1, -10, 0, 30)
}, function()

end)
-- rbxassetid://120451378713427
local Simple_Icon = Regui.CreateImage(Simple_test, {Name = "Meme", Transparence = 1, Alignment = "Left", Id_Image = "rbxassetid://84471807656657", Size_Image = UDim2.new(0, 25, 0, 25)  })

]]


Sub_Scroll_Icons = Regui.SubTabsWindow(ExplorerTab, {
	Text = "Afk Player",
	Table = {"Icons", "Data"},
	Color = "Blue"
})

GetIcons = Regui.Icons 

-- Reuso de variáveis
local button, icon

for nome, id in pairs(GetIcons) do
	task.wait(0.05) -- pequeno delay para evitar lag e sobrecarga

	button = Regui.CreateButton(Sub_Scroll_Icons["Icons"], {
		Text = nome,
		Color = "White",
		BGColor = "Button",
		TextSize = 16
	}, function()
		print("🔹 Ícone selecionado:", nome, id)
		Regui.NotificationPerson(Window.Frame.Parent, {
			Title = "Ícone: " .. nome,
			Text = "AssetID: " .. id,
			Icon = id,
			Tempo = 1
		})
	end)

	icon = Regui.CreateImage(button, {
		Name = "Icon_" .. nome,
		Transparence = 1,
		Alignment = "Left",
		Id_Image = id,
		Size_Image = UDim2.new(0, 25, 0, 25)
	})
end



MemeKira= Regui.CreateImage(ExplorerTab, {Name = "Meme (Ligth)", Transparence = 1, Alignment = "Center", Id_Image = "rbxassetid://84471807656657", Size_Image = UDim2.new(0, 50, 0, 50)  })



--===================--
-- Window Discord Tab
-- ⬇ ⬇ ⬇ ⬇ ⬇ ⬇ ⬇ ⬇
--===================--

-- ADN CLÃN TAB
DiscordTab = Regui.CreateTab(Window, {Name = "Discord"})

-- Ícone principal do clã
Discord_Icon = Regui.CreateImage(DiscordTab, {
	Name = "ADN_Icon",
	Transparence = 1,
	Alignment = "Center",
	Id_Image = "rbxassetid://120181810700514",
	Size_Image = UDim2.new(0, 70, 0, 70)
})
Regui.applyCorner(Discord_Icon)

-- Título principal
Label_Discord_Info = Regui.CreateLabel(DiscordTab, {
	Text = "💜 ADN • Discord Oficial",
	Color = "White",
	Alignment = "Center"
})
-- Link do Discord
local discordLink = "https://discord.gg/spCcTWFWBR"

-- Botão para copiar o link
Btn_Copy_Discord = Regui.CreateButton(DiscordTab, {
	Text = "📋 Copiar Link do Discord",
	Color = "White",
	BGColor = "Blue"
}, function()
	setclipboard(discordLink) -- Copia o link

	Regui.Notifications(game.Players.LocalPlayer.PlayerGui, {
		Title = "ADN Discord",
		Text = "📋 Link copiado para a área de transferência!",
		Icon = "fa_rr_copy",
		Tempo = 4
	})
end)


-- Botão para abrir o link
Btn_Open_Discord = Regui.CreateButton(DiscordTab, {
	Text = "🔗 Abrir Discord",
	Color = "White",
	BGColor = "Purple"
}, function()

	local sucesso = true

	pcall(function()
		-- Executores com suporte direto para abrir navegador
		if syn and syn.open_url then
			syn.open_url(discordLink)
			print("✅ Synapse URL disponível")
			sucesso = true
		elseif getgenv and getgenv().open_url then
			getgenv().open_url(discordLink)
			sucesso = true
		elseif openbrowser then
			openbrowser(discordLink)
			sucesso = true
		elseif fluxus and fluxus.open_browser then
			fluxus.open_browser(discordLink)
			print("✅ Fluxus URL disponível")
			sucesso = true
		elseif KRNL_LOADED and writefile then
			-- Alguns executores antigos não abrem, mas dá pra copiar
			if setclipboard then setclipboard(discordLink) end
			sucesso = false
		elseif setclipboard then
			setclipboard(discordLink)
			sucesso = false
			print("ℹ️ KRNL detectado — não suporta abrir navegador.")
		end
	end)

	

	if sucesso then
		Regui.Notifications(game.Players.LocalPlayer.PlayerGui, {
			Title = "ADN Discord",
			Text = "🌐 Link aberto no navegador!",
			Icon = "fa_rr_globe",
			Tempo = 4
		})
	else
		Regui.Notifications(game.Players.LocalPlayer.PlayerGui, {
			Title = "ADN Discord",
			Text = "📋 Link copiado! Cole no navegador para abrir.",
			Icon = "fa_rr_copy",
			Tempo = 4
		})
		
	end
end)
