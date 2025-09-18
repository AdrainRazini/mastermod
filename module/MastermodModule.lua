-- ModuleScript: MastermodModule
local Mastermod = {}

-- SERVICES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

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

--====================================================================--
-- FUNÇÕES DE AUTO FARM
--====================================================================--

function Mastermod.StartAutoCoins()
    task.spawn(function()
        while AF.coins do
            local events = ReplicatedStorage:FindFirstChild("Events")
            local coinEvent = events and events:FindFirstChild("CoinEvent")
            if coinEvent then coinEvent:FireServer() end
            task.wait(AF_Timer.Coins_Speed)
        end
    end)
end

function Mastermod.StartAutoDummy(flag, folder)
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

function Mastermod.StartAutoBosses()
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

--====================================================================--
-- FUNÇÕES DE PVP
--====================================================================--

function Mastermod.StartKillAura()
    task.spawn(function()
        while PVP.killAura do
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
                    pcall(function() attackRemote:FireServer(hum, 1) end)
                end
            end
            task.wait(0.1)
        end
    end)
end

function Mastermod.StartAutoFireball()
    task.spawn(function()
        while PVP.AutoFire do
            local _, _, hrp = getCharacter()
            local closest, shortest = nil, maxRange

            for _, p in ipairs(Players:GetPlayers()) do
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

            if closest and closest.Character then
                local hrpTarget = closest.Character:FindFirstChild("HumanoidRootPart")
                if hrpTarget then
                    pcall(function() skillsRemote:FireServer(hrpTarget.Position, "NewFireball") end)
                end
            end
            task.wait(0.3)
        end
    end)
end

--====================================================================--
-- TELEPORTS
--====================================================================--

RunService.RenderStepped:Connect(function()
    local _, _, hrp = getCharacter()
    if AF.tpDummy then
        local dummy, _ = findDummy(dummiesFolder)
        if dummy and dummy:FindFirstChild("HumanoidRootPart") then
            hrp.CFrame = dummy.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
        end
    end

    if AF.tpDummy5k then
        local dummy, _ = findDummy(folder5k)
        if dummy and dummy:FindFirstChild("HumanoidRootPart") then
            hrp.CFrame = dummy.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
        end
    end
end)

--====================================================================--
return Mastermod
