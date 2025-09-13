
-- URL da API do GitHub para listar os scripts
local GITHUB_USER = "AdrainRazini"
local GITHUB_REPO = "Mastermod"
local GITHUB_REPO_NAME = "Mastermod"
local Owner = "Adrian75556435"
local SCRIPTS_FOLDER_URL = "https://api.github.com/repos/" .. GITHUB_USER .. "/" .. GITHUB_REPO .. "/contents/script"
local IMG_ICON = "rbxassetid://117585506735209"
local NAME_MOD_MENU = "ModMenuGui"

-- SERVICES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer

-- ReGui
local ReGui = loadstring(game:HttpGet("https://raw.githubusercontent.com/".. GITHUB_USER .."/".. GITHUB_REPO .."/refs/heads/main/module/dataUi.lua"))()   --loadstring(game:HttpGet("https://raw.githubusercontent.com/depthso/Dear-ReGui/refs/heads/main/ReGui.lua"))()
local PrefabsId = "rbxassetid://71968920594655"

ReGui:Init({
    Prefabs = game:GetService("InsertService"):LoadLocalAsset(PrefabsId)
})

local Window = ReGui:TabsWindow({
    Title = "Animal Simulator",
    Size = UDim2.new(0, 400, 0, 400),
}):Center()

-- REMOTES
local attackRemote = ReplicatedStorage:WaitForChild("jdskhfsIIIllliiIIIdchgdIiIIIlIlIli")
local skillsRemote = ReplicatedStorage:WaitForChild("SkillsInRS"):WaitForChild("RemoteEvent")

-- FOLDERS
local map = Workspace:WaitForChild("MAP")
local dummiesFolder = map:WaitForChild("dummies")
local folder5k = map:FindFirstChild("5k_dummies")
local bossesList = { "ROCKY","Griffin","BOOSBEAR","BOSSDEER","CENTAUR","CRABBOSS","DragonGiraffe","LavaGorilla" }

-- FLAGS
local AF = { coins=false, bosses=false, dummies=false, dummies5k=false, tpDummy=false, tpDummy5k=false }
local AF_Timer = {Coins_Speed = 1, Bosses_Speed = 0.05, Dummies_Speed = 1, Dummies5k_Speed = 1}
local PVP = { 
	killAura = true,
	AutoFire = true,
	AutoEletric = true,
}


-- UTILS
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

-- AUTO FARM FUNCTIONS
local function autoCoins()
    while AF.coins do
        local events = ReplicatedStorage:FindFirstChild("Events")
        local coinEvent = events and events:FindFirstChild("CoinEvent")
        if coinEvent then coinEvent:FireServer() end
        task.wait(1)
    end
end

local function attackLoop(flag, folder)
    while AF[flag] do
        local dummy, hum = findDummy(folder)
        if dummy and hum and dummy:FindFirstChild("HumanoidRootPart") then
            local pos = dummy.HumanoidRootPart.Position
            attackRemote:FireServer(hum, 2)
            skillsRemote:FireServer(pos, "NewFireball")
            skillsRemote:FireServer(pos, "NewLightningball")
        end
        task.wait(0.05)
    end
end

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
        task.wait(1)
    end
end



-- FIREBALL TOOL FUNCTION
local function giveFireball()
	-- evita duplicação
	if player.Backpack:FindFirstChild("Fireball") or player.Character:FindFirstChild("Fireball") then
		return
	end

	local tool = Instance.new("Tool")
	tool.Name = "Fireball"
	tool.RequiresHandle = false
	tool.CanBeDropped = false
	tool.ManualActivationOnly = false
	tool.Parent = player:FindFirstChildOfClass("Backpack") or player.Backpack

	local mouse = player:GetMouse()
	tool.Activated:Connect(function()
		if skillsRemote then
			local pos = mouse.Hit.Position
			skillsRemote:FireServer(pos, "NewFireball")
		end
	end)
end


-- FIREBALL ELETRIC TOOL FUNCTION
local function giveFireballEletric()
	-- evita duplicação
	if player.Backpack:FindFirstChild("FireballEletric") or player.Character:FindFirstChild("FireballEletric") then
		return
	end

	local tool = Instance.new("Tool")
	tool.Name = "FireballEletric"
	tool.RequiresHandle = false
	tool.CanBeDropped = false
	tool.ManualActivationOnly = false
	tool.Parent = player:FindFirstChildOfClass("Backpack") or player.Backpack

	local mouse = player:GetMouse()
	tool.Activated:Connect(function()
		if skillsRemote then
			local pos = mouse.Hit.Position
			skillsRemote:FireServer(pos, "NewLightningball")
		end
	end)
end



local PVP = { 
	killAura = true,
	AutoFire = true,
	AutoEletric = true,
}



local maxRange = 100 -- distância máxima em studs (pode alterar)
-- PVP FUNCTIONS
-- ⚔ Kill Aura
local function killAuraLoop()
	while task.wait(0.1) do
		if not PVP.killAura then continue end
		local _, _, hrp = getCharacter()
		local closest, shortest = nil, maxRange

		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				local dist = (p.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
				if dist < shortest then
					shortest = dist
					closest = p
				end
			end
		end

		if closest and attackRemote then
			local hum = closest.Character:FindFirstChildOfClass("Humanoid")
			if hum and hum.Health > 0 then
				pcall(function()
					attackRemote:FireServer(hum, 1)
				end)
			end
		end
	end
end


-- 🔥 AutoFire Fireball
local function AutoFireLoop()
	giveFireball()
	while task.wait(0.3) do
		if not PVP.AutoFire then continue end
		local _, _, hrp = getCharacter()
		local closest, shortest = nil, maxRange

		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				local hum = p.Character:FindFirstChildOfClass("Humanoid")
				if hum and hum.Health > 0 then -- ✅ só ataca se estiver vivo
					local dist = (p.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
					if dist < shortest then
						shortest = dist
						closest = p
					end
				end
			end
		end

		if closest and closest.Character then
			local hum = closest.Character:FindFirstChildOfClass("Humanoid")
			local hrpTarget = closest.Character:FindFirstChild("HumanoidRootPart")

			if hum and hum.Health > 0 and hrpTarget then -- ✅ garante que está vivo
				local pos = hrpTarget.Position
				pcall(function()
					skillsRemote:FireServer(pos, "NewFireball")
				end)
			end
		end
	end
end

-- 🔥 AutoEletric Lightningball
local function AutoEletricLoop()
	giveFireballEletric()
	while task.wait(0.3) do
		if not PVP.AutoEletric then continue end
		local _, _, hrp = getCharacter()
		local closest, shortest = nil, maxRange

		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				local hum = p.Character:FindFirstChildOfClass("Humanoid")
				if hum and hum.Health > 0 then -- ✅ só ataca se estiver vivo
					local dist = (p.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
					if dist < shortest then
						shortest = dist
						closest = p
					end
				end
			end
		end

		if closest and closest.Character then
			local hum = closest.Character:FindFirstChildOfClass("Humanoid")
			local hrpTarget = closest.Character:FindFirstChild("HumanoidRootPart")

			if hum and hum.Health > 0 and hrpTarget then -- ✅ garante que está vivo
				local pos = hrpTarget.Position
				pcall(function()
					skillsRemote:FireServer(pos, "NewLightningball")
				end)
			end
		end
	end
end


-- Quando respawnar, garantir que tenha a Fireball
player.CharacterAdded:Connect(function()
	task.wait(1)
	if PVP.AutoFire then
		giveFireball()
	end
	if PVP.AutoEletric then
		giveFireballEletric()
	end
end)



--======================================================================================--
-- UI: FARM TAB
local FarmTab = Window:CreateTab({ Name = "Farm" })

FarmTab:Checkbox({ Value=false, Label="Auto Coins", Callback=function(self, Value)
    AF.coins = Value
    if Value then task.spawn(autoCoins) end
end})

FarmTab:Checkbox({ Value=false, Label="Auto Dummy", Callback=function(self, Value)
    AF.dummies = Value
    if Value then task.spawn(function() attackLoop("dummies", dummiesFolder) end) end
end})

FarmTab:Checkbox({ Value=false, Label="Auto Dummy 5k", Callback=function(self, Value)
    AF.dummies5k = Value
    if Value then task.spawn(function() attackLoop("dummies5k", folder5k) end) end
end})

FarmTab:Checkbox({ Value=false, Label="Auto Bosses", Callback=function(self, Value)
    AF.bosses = Value
    if Value then task.spawn(farmBosses) end
end})

FarmTab:Checkbox({ Value=false, Label="TP to Dummy", Callback=function(self, Value)
    AF.tpDummy = Value
end})

FarmTab:Checkbox({ Value=false, Label="TP to Dummy 5k", Callback=function(self, Value)
    AF.tpDummy5k = Value
end})

-- 🔹 Tabs internas
local Header_Farm = FarmTab:CollapsingHeader({ Title = "Opções Avançadas" })
Header_Farm:Label({ Text = "Config extra aqui..." })

local Sub_Farm_Tabs = FarmTab:TabSelector()
local Tab_Farm_1 = Sub_Farm_Tabs:CreateTab({ Name = "Logs" })
Tab_Farm_1:Label({ Text = "Aqui ficam os logs do Do Farme..." })
local Tab_Farm_2 = Sub_Farm_Tabs:CreateTab({ Name = "Config" })
Tab_Farm_2:Label({ Text = "Aqui ficam configs adicionais..." })

--========================================================================================--

--======================================================================================--

-- UI: PVP TAB
local PvpTab = Window:CreateTab({ Name = "PVP" })

-- Kill Aura
PvpTab:Checkbox({
    Value = false,
    Label = "Kill Aura",
    Callback = function(self, Value)
        PVP.killAura = Value
        if Value then task.spawn(killAuraLoop) end
    end
})

-- Auto Fireball
PvpTab:Checkbox({
    Value = false,
    Label = "Auto Fireball",
    Callback = function(self, Value)
        PVP.AutoFire = Value
        if Value then task.spawn(AutoFireLoop) end
    end
})

-- Auto Lightningball
PvpTab:Checkbox({
    Value = false,
    Label = "Auto Lightningball",
    Callback = function(self, Value)
        PVP.AutoEletric = Value
        if Value then task.spawn(AutoEletricLoop) end
    end
})

-- Slider de Range
PvpTab:SliderInt({
    Label = "Distância máxima",
    Value = 100,
    Minimum = 10,
    Maximum = 200,
    Callback = function(self, Value)
        maxRange = Value
        print("Novo range de ataque:", Value)
    end
})

PvpTab:Label({ Text = "Configurações de combate em PvP" })


--[[
-- UI: PVP TAB
local PvPTab = Window:CreateTab({ Name = "PvP" })

PvPTab:Checkbox({ Value=false, Label="Kill Aura", Callback=function(self, Value)
    PVP.killAura = Value
    if Value then task.spawn(killAuraLoop) end
end})
]]
--========================================================================================--
-- UI: TROLL TAB
local TrollTab = Window:CreateTab({ Name = "Troll" })
TrollTab:Label({ Text = "Coming Soon..." })
TrollTab:Button({ Label="Test Button", Callback=function()
    print("You pressed the Troll button!")
end})
--========================================================================================--
-- UI: SKIN / EVENTS TAB
local SkinEventsTab = Window:CreateTab({ Name = "Skin / Events" })
SkinEventsTab:Label({ Text = "Coming Soon..." })
--========================================================================================--
-- UI: MISCELLANEOUS TAB
local MiscTab = Window:CreateTab({ Name = "Miscellaneous" })
MiscTab:Label({ Text = "Miscellaneous Options" })
MiscTab:Button({
    Label = "Free Fire",
    Callback = function()
        local tool = Instance.new("Tool")
        tool.Name = "Fireball"
        tool.RequiresHandle = false
        tool.CanBeDropped = false
        tool.ManualActivationOnly = false
        tool.Parent = player:FindFirstChildOfClass("Backpack") or player.Backpack

        local mouse = player:GetMouse()
        local function shoot()
            if tool and skillsRemote then
                local pos = mouse.Hit.Position
                skillsRemote:FireServer(pos, "NewFireball")
            end
        end

        tool.Activated:Connect(shoot)
    end
})
--========================================================================================--
-- UI: WEBHOOK TAB
local WebhookTab = Window:CreateTab({ Name = "Webhook" })
WebhookTab:Label({ Text = "Coming Soon..." })
--========================================================================================--

-- 🔹 Texto
WebhookTab:Label({ Text = "Exemplo de Widgets - Showcase" })

-- 🔹 Botões
local BtnRow = WebhookTab:Row()
BtnRow:Button({ Text = "Botão Padrão", Callback = function() print("Botão clicado!") end })
BtnRow:SmallButton({ Text = "Botão Pequeno" })

-- 🔹 Checkbox e Radio
WebhookTab:Checkbox({ Label = "Ativar Webhook?", Value = false })
local RadioRow = WebhookTab:Row()
RadioRow:Radiobox({ Label = "Opção A" })
RadioRow:Radiobox({ Label = "Opção B" })

-- 🔹 Input
WebhookTab:InputText({ Label = "Webhook URL", Placeholder = "cole aqui..." })
WebhookTab:InputInt({ Label = "Quantidade", Value = 10, Minimum = 1, Maximum = 100 })

-- 🔹 Sliders
WebhookTab:SliderInt({ Label = "Mensagens", Value = 5, Minimum = 1, Maximum = 50 })
WebhookTab:SliderFloat({ Label = "Velocidade", Value = 0.5, Minimum = 0, Maximum = 1 })

-- 🔹 Drag
WebhookTab:DragInt({ Label = "Drag Numérico", Value = 10, Minimum = 0, Maximum = 100 })
WebhookTab:DragFloat({ Label = "Drag Decimal", Value = 0.1, Minimum = 0, Maximum = 1 })

-- 🔹 Enum / Progresso
WebhookTab:SliderEnum({ Label = "Tipo de Log", Items = { "Erro", "Aviso", "Info" }, Value = 2 })
WebhookTab:SliderProgress({ Label = "Progresso", Value = 25, Minimum = 0, Maximum = 100 })

-- 🔹 Keybind
WebhookTab:Keybind({
    Label = "Atalho Webhook",
    IniFlag = "WebhookKeybind",
    KeyBlacklist = { Enum.UserInputType.MouseButton1 }
})

-- 🔹 Cor e CFrame
WebhookTab:InputColor3({ Label = "Cor de Destaque", Value = Color3.fromRGB(255, 0, 0) })
WebhookTab:InputCFrame({ Label = "Posição Teste", Value = CFrame.new(0, 5, 0) })

-- 🔹 Mídia
WebhookTab:Image({ Image = "rbxassetid://1122334455", Size = UDim2.fromOffset(100, 100) })
local Video = WebhookTab:VideoPlayer({
    Video = 5608327482, Looped = true, Size = UDim2.fromOffset(200, 120)
})
Video:Play()

-- 🔹 Texto com bullets
WebhookTab:BulletText({ Rows = { "Mensagem 1", "Mensagem 2", "Mensagem 3" } })
WebhookTab:Bullet():Label({ Text = "Bullet + Label" })
WebhookTab:Bullet():SmallButton({ Text = "Bullet + Botão" })

-- 🔹 Gráficos
WebhookTab:PlotHistogram({ Points = {0.1, 0.5, 0.9, 0.3, 0.7} })
WebhookTab:Button({
    Text = "Novo Gráfico",
    Callback = function()
        local pts = {}
        for i = 1, math.random(5, 10) do
            table.insert(pts, math.random())
        end
        WebhookTab:PlotHistogram({ Points = pts })
    end
})

-- 🔹 Headers e Árvores
local Header = WebhookTab:CollapsingHeader({ Title = "Opções Avançadas" })
Header:Label({ Text = "Config extra aqui..." })

local Node = WebhookTab:TreeNode({ Title = "Webhook Debug" })
Node:Label({ Text = "Detalhes técnicos" })
Node:SmallButton({ Text = "Reiniciar" })

-- 🔹 Tabs internas
local SubTabs = WebhookTab:TabSelector()
local Tab1 = SubTabs:CreateTab({ Name = "Logs" })
Tab1:Label({ Text = "Aqui ficam os logs do webhook..." })
local Tab2 = SubTabs:CreateTab({ Name = "Config" })
Tab2:Label({ Text = "Aqui ficam configs adicionais..." })


--========================================================================================--
-- UI: SETTINGS TAB
local SettingsTab = Window:CreateTab({ Name = "Settings" })
SettingsTab:Label({ Text = "Coming Soon..." })
--========================================================================================--
-- UI: SCRIPT TAB
local ScriptTab = Window:CreateTab({ Name = "Script" })
ScriptTab:Label({ Text = "Coming Soon..." })
--========================================================================================--
-- UI: READ ME TAB
local ReadMeTab = Window:CreateTab({ Name = "Read Me" })
ReadMeTab:Label({
    Text = "• This UI library was created by depso. Thanks.\n• Owner Of Script: Solin\n• Script & Management By: @Adrian75556435"
})
--========================================================================================--
-- SAFE CHECK & UNIFIED TP
RunService.RenderStepped:Connect(function()
    local _, _, hrp = getCharacter()
    local targetDummy
    if AF.tpDummy5k and folder5k then
        targetDummy = findDummy(folder5k)
    elseif AF.tpDummy then
        targetDummy = findDummy(dummiesFolder)
    end
    if targetDummy and targetDummy[1]:FindFirstChild("HumanoidRootPart") then
        hrp.CFrame = targetDummy[1].HumanoidRootPart.CFrame + Vector3.new(0,0,4)
    end
end)
--========================================================================================--