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
local map = Workspace:WaitForChild("MAP")
local dummiesFolder = map:WaitForChild("dummies")
local folder5k = map:FindFirstChild("5k_dummies")
local bossesList = { "ROCKY","Griffin","BOOSBEAR","BOSSDEER","CENTAUR","CRABBOSS","DragonGiraffe","LavaGorilla" }

-- FLAGS
local AF = { coins=false, bosses=false, dummies=false, dummies5k=false, tpDummy=false, tpDummy5k=false }
local AF_Timer = {Coins_Speed = 1, Bosses_Speed = 0.05, Dummies_Speed = 1, Dummies5k_Speed = 1}
local PVP = { killAura=false, AutoFire=false, AutoEletric=false, AutoAttack=false, AutoFlyAttack=false, AttackType="Melee" }
local maxRange = 100

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
            task.wait(0.05)
        end
    end)
end

local function farmBosses()
    task.spawn(function()
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

-- PVP LOOPS
local function PVP_Loop(kind)
    task.spawn(function()
        giveTool("Fireball","NewFireball")
        giveTool("FireballEletric","NewLightningball")
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

--maxRange


local ToggleBosses = Regui.CreateToggleboxe(FarmTab,{Text="Auto Bosses",Color="Red"},function(state)
    AF.bosses=state
    if state then farmBosses() end
end)


local SliderInt_Range = Regui.CreateSliderInt(PlayerTab, {Text = "Timer Int", Color = "Blue", Value = 100, Minimum = 100, Maximum = 500}, function(state)
maxRange = state
	print("Slider Int clicada! Estado:", maxRange)

end)
-- Exemplo de PVP
local ToggleKillAura = Regui.CreateToggleboxe(PlayerTab,{Text="Kill Aura",Color="Blue"},function(state)
    PVP.killAura=state
    if state then PVP_Loop("killAura") end
end)

local ToggleFireball = Regui.CreateToggleboxe(PlayerTab,{Text="Auto Fireball",Color="Yellow"},function(state)
    PVP.AutoFire=state
    if state then PVP_Loop("AutoFire") end
end)

local ToggleLightning = Regui.CreateToggleboxe(PlayerTab,{Text="Auto Lightning",Color="Cyan"},function(state)
    PVP.AutoEletric=state
    if state then PVP_Loop("AutoEletric") end
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
