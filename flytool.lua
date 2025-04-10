-- Variáveis globais
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local camera = game.Workspace.CurrentCamera
local primaryPart = character.PrimaryPart

-- Variáveis de controle de voo
local flying = false
local speed = 100
local flightBoost = 150

-- Criação de BodyVelocity e BodyGyro
local function createFlightMechanics()
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVelocity.Velocity = Vector3.new()
    bodyVelocity.P = 10000
    bodyVelocity.Parent = primaryPart

    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(4000, 4000, 4000)
    bodyGyro.CFrame = primaryPart.CFrame
    bodyGyro.P = 3000
    bodyGyro.Parent = primaryPart

    return bodyVelocity, bodyGyro
end

local bodyVelocity, bodyGyro = createFlightMechanics()

-- Função para aplicar movimento e estabilizar o voo
local function applyMovement()
    if flying then
        bodyVelocity.Velocity = camera.CFrame.LookVector * flightBoost
        bodyGyro.CFrame = CFrame.new(primaryPart.Position, primaryPart.Position + camera.CFrame.LookVector)
    end
end

-- Função para iniciar e parar o voo
local function toggleFlying()
    flying = not flying
    if flying then
        while flying do
            applyMovement()
            wait(0.1)
        end
    else
        stopFlying()
    end
end

-- Função para parar de voar
local function stopFlying()
    flying = false
    bodyVelocity.Velocity = Vector3.new()
    bodyGyro.CFrame = primaryPart.CFrame
end

-- Gerenciamento da ferramenta de voo
local function createFlightTool()
    local tool = Instance.new("Tool")
    tool.Name = "FlyingTool"
    tool.RequiresHandle = false
    tool.CanBeDropped = false
    tool.Parent = player.Backpack

    tool.Equipped:Connect(toggleFlying)
    tool.Unequipped:Connect(stopFlying)
end

-- Inicialização
createFlightTool()

-- Conectar eventos de aterrissagem e mudança de estado
humanoid.Landed:Connect(stopFlying)

humanoid.StateChanged:Connect(function(_, newState)
    if newState == Enum.HumanoidStateType.Freefall and flying then
        stopFlying()
    end
end)

print("Ferramenta de voo carregada. Equipe para voar.")