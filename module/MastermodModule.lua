-- Mastermod Module
local Mastermods = {}

-- SERVICES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer

-- REMOTES
local attackRemote = ReplicatedStorage:WaitForChild("jdskhfsIIIllliiIIIdchgdIiIIIlIlIli")
local skillsRemote = ReplicatedStorage:WaitForChild("SkillsInRS"):WaitForChild("RemoteEvent")

-- FOLDERS
local map = Workspace:WaitForChild("MAP")
local dummiesFolder = map:WaitForChild("dummies")
local folder5k = map:FindFirstChild("5k_dummies")
local bossesList = { "ROCKY","Griffin","BOOSBEAR","BOSSDEER","CENTAUR","CRABBOSS","DragonGiraffe","LavaGorilla" }

-- FLAGS / TIMERS
local AF = { coins=false, bosses=false, dummies=false, dummies5k=false, tpDummy=false, tpDummy5k=false }
local AF_Timer = {Coins_Speed = 1, Bosses_Speed = 0.05, Dummies_Speed = 1, Dummies5k_Speed = 1}
local PVP = { killAura=false, AutoFire=false, AutoEletric=false, AutoAttack=false, AutoFlyAttack=false, AttackType="Melee" }

local maxRange = 100 -- distância máxima

--==========================================================================--
-- UTILS
function Mastermods.getCharacter()
    local c = player.Character or player.CharacterAdded:Wait()
    return c, c:WaitForChild("Humanoid"), c:WaitForChild("HumanoidRootPart")
end

function Mastermods.getAliveHumanoid(model)
    local hum = model and model:FindFirstChildOfClass("Humanoid")
    if hum and hum.Health > 0 then return hum end
end

function Mastermods.findDummy(folder)
    for _, d in ipairs(folder:GetChildren()) do
        local hum = Mastermods.getAliveHumanoid(d)
        if hum then return d, hum end
    end
end

--==========================================================================--
-- AUTO FARM FUNCTIONS
function Mastermods.autoCoins()
    while AF.coins do
        local events = ReplicatedStorage:FindFirstChild("Events")
        local coinEvent = events and events:FindFirstChild("CoinEvent")
        if coinEvent then coinEvent:FireServer() end
        task.wait(AF_Timer.Coins_Speed)
    end
end

function Mastermods.attackLoop(flag, folder)
    while AF[flag] do
        local dummy, hum = Mastermods.findDummy(folder)
        if dummy and hum and dummy:FindFirstChild("HumanoidRootPart") then
            local pos = dummy.HumanoidRootPart.Position
            attackRemote:FireServer(hum, 2)
            skillsRemote:FireServer(pos, "NewFireball")
            skillsRemote:FireServer(pos, "NewLightningball")
        end
        task.wait(0.05)
    end
end

function Mastermods.farmBosses()
    while AF.bosses do
        local npcFolder = Workspace:FindFirstChild("NPC")
        if npcFolder then
            for _, name in ipairs(bossesList) do
                local boss = npcFolder:FindFirstChild(name)
                local hum = Mastermods.getAliveHumanoid(boss)
                if hum then attackRemote:FireServer(hum, 5) end
            end
        end
        task.wait(1)
    end
end

function Mastermods.DoAttack(targetHum, targetHRP, event)
    if event == "Melee" then
        pcall(function() attackRemote:FireServer(targetHum, 1) end)
    elseif event == "Fireball" then
        pcall(function() skillsRemote:FireServer(targetHRP.Position, "NewFireball") end)
    elseif event == "Lightning" then
        pcall(function() skillsRemote:FireServer(targetHRP.Position, "NewLightningball") end)
    end
end

--==========================================================================--
-- FIREBALL / ELETRIC TOOLS
function Mastermods.giveFireball()
    if player.Backpack:FindFirstChild("Fireball") or player.Character:FindFirstChild("Fireball") then return end
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

function Mastermods.giveFireballEletric()
    if player.Backpack:FindFirstChild("FireballEletric") or player.Character:FindFirstChild("FireballEletric") then return end
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

--==========================================================================--
-- PVP FUNCTIONS
function Mastermods.killAuraLoop()
    while task.wait(0.1) do
        if not PVP.killAura then continue end
        local _, _, hrp = Mastermods.getCharacter()
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
    end
end

function Mastermods.AutoFireLoop()
    Mastermods.giveFireball()
    while task.wait(0.3) do
        if not PVP.AutoFire then continue end
        local _, _, hrp = Mastermods.getCharacter()
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
            local hum = closest.Character:FindFirstChildOfClass("Humanoid")
            local hrpTarget = closest.Character:FindFirstChild("HumanoidRootPart")
            if hum and hum.Health > 0 and hrpTarget then
                pcall(function() skillsRemote:FireServer(hrpTarget.Position, "NewFireball") end)
            end
        end
    end
end

function Mastermods.AutoEletricLoop()
    Mastermods.giveFireballEletric()
    while task.wait(0.3) do
        if not PVP.AutoEletric then continue end
        local _, _, hrp = Mastermods.getCharacter()
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
            local hum = closest.Character:FindFirstChildOfClass("Humanoid")
            local hrpTarget = closest.Character:FindFirstChild("HumanoidRootPart")
            if hum and hum.Health > 0 and hrpTarget then
                pcall(function() skillsRemote:FireServer(hrpTarget.Position, "NewLightningball") end)
            end
        end
    end
end

function Mastermods.AutoAttackLoop(fly)
    Mastermods.giveFireball()
    Mastermods.giveFireballEletric()
    local char, hum, hrp = Mastermods.getCharacter()
    if fly and hrp then hrp.Anchored = true end
    while (fly and PVP.AutoFlyAttack) or (not fly and PVP.AutoAttack) do
        local closest, shortest = nil, maxRange
        char, hum, hrp = Mastermods.getCharacter()
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local targetHum = p.Character:FindFirstChildOfClass("Humanoid")
                local targetHRP = p.Character:FindFirstChild("HumanoidRootPart")
                if targetHum and targetHum.Health > 0 then
                    local dist = (targetHRP.Position - hrp.Position).Magnitude
                    if dist < shortest then
                        shortest = dist
                        closest = {Humanoid = targetHum, HRP = targetHRP}
                    end
                end
            end
        end
        if closest then
            local targetHum = closest.Humanoid
            local targetHRP = closest.HRP
            if fly then hrp.CFrame = targetHRP.CFrame + Vector3.new(0,5,0) end
            if PVP.AttackType == "Melee" then
                pcall(function() attackRemote:FireServer(targetHum,1) end)
            elseif PVP.AttackType == "Fireball" then
                pcall(function() skillsRemote:FireServer(targetHRP.Position,"NewFireball") end)
            elseif PVP.AttackType == "Lightning" then
                pcall(function() skillsRemote:FireServer(targetHRP.Position,"NewLightningball") end)
            end
        end
        task.wait(0.2)
    end
    if fly and hrp then hrp.Anchored = false end
end

function Mastermods.AutoAttackPlayers()
    task.spawn(function() Mastermods.AutoAttackLoop(false) end)
end

function Mastermods.AutoAttackFlyPlayers()
    task.spawn(function() Mastermods.AutoAttackLoop(true) end)
end

--==========================================================================--
-- SAFE TP
RunService.RenderStepped:Connect(function()
    if AF.tpDummy then
        local dummy, hum = Mastermods.findDummy(dummiesFolder)
        if dummy and dummy:FindFirstChild("HumanoidRootPart") then
            local _, _, hrp = Mastermods.getCharacter()
            hrp.CFrame = dummy.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
        end
    end
    if AF.tpDummy5k then
        local dummy, hum = Mastermods.findDummy(folder5k)
        if dummy and dummy:FindFirstChild("HumanoidRootPart") then
            local _, _, hrp = Mastermods.getCharacter()
            hrp.CFrame = dummy.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
        end
    end
end)

return Mastermods
