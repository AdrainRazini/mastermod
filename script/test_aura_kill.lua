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

-- REMOTES
local attackRemote = ReplicatedStorage:WaitForChild("jdskhfsIIIllliiIIIdchgdIiIIIlIlIli")
local skillsRemote = ReplicatedStorage:WaitForChild("SkillsInRS"):WaitForChild("RemoteEvent")

ReGui = {}
ReGui["Screen"] = Instance.new("ScreenGui")
ReGui["Screen"].Name = NAME_MOD_MENU
ReGui["Screen"].Parent = game:GetService("CoreGui")

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

local PVP = { killAura = true }
local maxRange = 100 -- distância máxima em studs

local function killAuraLoop()
    while PVP.killAura do
        local _, _, hrp = getCharacter()
        local closest = nil
        local shortest = maxRange

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

        task.wait(0.1) -- delay do aura
    end
end

task.spawn(killAuraLoop)

-- FRAME DE CONTROLE
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 120)
frame.Position = UDim2.new(0.05, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0
frame.Parent = ReGui["Screen"]

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "⚔ Kill Aura"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Parent = frame

-- BOTÃO ON/OFF
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.9, 0, 0, 30)
toggleBtn.Position = UDim2.new(0.05, 0, 0.35, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 14
toggleBtn.Text = "Kill Aura: ON"
toggleBtn.Parent = frame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = toggleBtn

toggleBtn.MouseButton1Click:Connect(function()
    PVP.killAura = not PVP.killAura
    toggleBtn.Text = "Kill Aura: " .. (PVP.killAura and "ON" or "OFF")
    if PVP.killAura then
        task.spawn(killAuraLoop)
    end
end)

-- SLIDER DE DISTÂNCIA
local sliderBack = Instance.new("Frame")
sliderBack.Size = UDim2.new(0.9, 0, 0, 20)
sliderBack.Position = UDim2.new(0.05, 0, 0.75, 0)
sliderBack.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
sliderBack.BorderSizePixel = 0
sliderBack.Parent = frame

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(0, 6)
sliderCorner.Parent = sliderBack

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(0.5, 0, 1, 0) -- metade preenchida (50 studs iniciais)
sliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
sliderFill.BorderSizePixel = 0
sliderFill.Parent = sliderBack

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(0, 6)
fillCorner.Parent = sliderFill

local sliderLabel = Instance.new("TextLabel")
sliderLabel.Size = UDim2.new(1, 0, 0, 20)
sliderLabel.Position = UDim2.new(0, 0, 1.1, 0)
sliderLabel.BackgroundTransparency = 1
sliderLabel.Text = "Range: 50"
sliderLabel.Font = Enum.Font.Gotham
sliderLabel.TextSize = 14
sliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
sliderLabel.Parent = frame

-- Drag do Slider
local UserInputService = game:GetService("UserInputService")
local dragging = false

sliderBack.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local relX = math.clamp((input.Position.X - sliderBack.AbsolutePosition.X) / sliderBack.AbsoluteSize.X, 0, 1)
        sliderFill.Size = UDim2.new(relX, 0, 1, 0)
        maxRange = math.floor(relX * 200) -- range de 0 a 200 studs
        sliderLabel.Text = "Range: " .. maxRange
    end
end)
