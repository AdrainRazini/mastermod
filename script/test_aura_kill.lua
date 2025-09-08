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
local ReGui = loadstring(game:HttpGet("https://raw.githubusercontent.com/".. GITHUB_USER .."/".. GITHUB_REPO .."/refs/heads/main/module/dataUi.lua"))()
local PrefabsId = "rbxassetid://71968920594655"

-- REMOTES
local attackRemote = ReplicatedStorage:WaitForChild("jdskhfsIIIllliiIIIdchgdIiIIIlIlIli")
local skillsRemote = ReplicatedStorage:WaitForChild("SkillsInRS"):WaitForChild("RemoteEvent")

local PVP = { killAura=true }


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


-- PVP FUNCTIONS
local function killAuraLoop()
    local maxRange = 100 -- distância máxima em studs (pode alterar)
    while PVP.killAura do
        local _, _, hrp = getCharacter()
        local closest = nil
        local shortest = maxRange -- só considera players dentro do alcance

        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (p.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                if dist < shortest then
                    shortest = dist
                    closest = p
                end
            end
        end

        if closest then
            local hum = closest.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                attackRemote:FireServer(hum, 1)
            end
        end

        task.wait(0.1)
    end
end

task.spawn(killAuraLoop)