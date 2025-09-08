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





local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- 🖼️ Função utilitária para criar UI Corner Obs: Aplicar Ui nas frames
local function applyCorner(instance, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = radius or UDim.new(0, 6)
	corner.Parent = instance
end

-- Função para aplicar contorno neon via UIStroke
local function applyUIStroke(instance, colorName, thickness)
	thickness = thickness or 2
	local stroke = Instance.new("UIStroke")
	stroke.Parent = instance
	stroke.Thickness = thickness
	stroke.LineJoinMode = Enum.LineJoinMode.Round
	stroke.Transparency = 0
	-- Escolhe cor da paleta ou usa branco como fallback
	stroke.Color = colors[colorName] or Color3.new(1, 1, 1)
end

local function applyUIListLayout(instance, padding, sortOrder, alignment)
	local list = Instance.new("UIListLayout")
	list.Parent = instance

	-- Padding entre elementos (UDim ou padrão 0)
	list.Padding = padding or UDim.new(0, 0)

	-- Ordem dos elementos
	list.SortOrder = sortOrder or Enum.SortOrder.LayoutOrder 

	-- Alinhamento
	list.HorizontalAlignment = alignment or Enum.HorizontalAlignment.Center
end

-- Função para aplicar ajuste automático de CanvasSize em qualquer ScrollingFrame

local function applyAutoScrolling(instance, padding, alignment)
	-- Verifica se já existe um UIListLayout
	local layout = instance:FindFirstChildOfClass("UIListLayout")
	if not layout then
		layout = Instance.new("UIListLayout")
		layout.Parent = instance
		layout.SortOrder = Enum.SortOrder.LayoutOrder
	end

	-- Aplica padding se passado
	if padding then
		layout.Padding = padding
	end

	-- Aplica alinhamento opcional
	if alignment then
		layout.HorizontalAlignment = alignment or Enum.HorizontalAlignment.Left
	end

	-- Função de atualização
	local function updateCanvas()
		local contentSize = layout.AbsoluteContentSize
		local frameSizeY = instance.AbsoluteSize.Y

		instance.CanvasSize = UDim2.new(
			0, 0,
			0, math.max(contentSize.Y, frameSizeY) + 10 -- margem extra
		)
	end

	-- Conecta sinais
	layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
	instance:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateCanvas)

	-- Força atualização inicial
	updateCanvas()

	return layout
end



function applyDraggable (instance, Active, Draggable)
	instance.Active = Active
	instance.Draggable = Draggable
end



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

-- FIREBALL TOOL FUNCTION
local function giveFireball()
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
            skillsRemote:FireServer(pos, "NewLightningball")
        end
    end)
end

local PVP = { 
    killAura = true,
    AutoFire = true,
}

local maxRange = 100 -- distância máxima

-- Quando respawnar, garantir que tenha a Fireball
player.CharacterAdded:Connect(function()
    task.wait(1)
    if PVP.AutoFire then
        giveFireball()
    end
end)

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


-- Iniciar os loops
task.spawn(killAuraLoop)
task.spawn(AutoFireLoop)


-- FRAME DE CONTROLE
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 120)
frame.Position = UDim2.new(0.05, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0
frame.Parent = ReGui["Screen"]

applyDraggable(frame, true, true)
applyCorner(frame)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "⚔ Kill Aura"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Parent = frame

-- BOTÃO ON/OFF Kill Aura
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.9, 0, 0, 30)
toggleBtn.Position = UDim2.new(0.05, 0, 0.35, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 14
toggleBtn.Text = "Kill Aura: ON"
toggleBtn.Parent = frame
applyCorner(toggleBtn)

-- BOTÃO ON/OFF Auto Fire
local toggleBtn2 = Instance.new("TextButton")
toggleBtn2.Size = UDim2.new(0.9, 0, 0, 30)
toggleBtn2.Position = UDim2.new(0.05, 0, 0.65, 0) -- posição diferente
toggleBtn2.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleBtn2.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn2.Font = Enum.Font.GothamBold
toggleBtn2.TextSize = 14
toggleBtn2.Text = "Auto Fire: ON"
toggleBtn2.Parent = frame
applyCorner(toggleBtn2)

-- Conexões
toggleBtn.MouseButton1Click:Connect(function()
    PVP.killAura = not PVP.killAura
    toggleBtn.Text = "Kill Aura: " .. (PVP.killAura and "ON" or "OFF")
    if PVP.killAura then
        task.spawn(killAuraLoop)
    end
end)

toggleBtn2.MouseButton1Click:Connect(function()
    PVP.AutoFire = not PVP.AutoFire
    toggleBtn2.Text = "Auto Fire: " .. (PVP.AutoFire and "ON" or "OFF")
    if PVP.AutoFire then
        task.spawn(AutoFire)
    end
end)
