-- Acessa o jogador local
local player = game.Players.LocalPlayer

-- Cria uma nova ferramenta
local tool = Instance.new("Tool")
tool.Name = "Teleport"
tool.RequiresHandle = true

-- Cria o objeto Handle da ferramenta
local handle = Instance.new("Part")
handle.Name = "Handle"
handle.Size = Vector3.new(1, 5, 1)  -- Defina o tamanho da ferramenta
handle.Anchored = false
handle.CanCollide = false
handle.BrickColor = BrickColor.new("Bright red")  -- Defina a cor da ferramenta
handle.Parent = tool

-- Adiciona uma textura ao Handle
local texture = Instance.new("Decal")
texture.Texture = "rbxassetid://123456789"  -- Substitua pelo ID da sua textura
texture.Parent = handle

-- Cria o AnimationController para controlar animações
local animator = Instance.new("AnimationController")
animator.Name = "AnimationController"
animator.Parent = tool

-- Cria uma animação e define seu conteúdo
local animation = Instance.new("Animation")
animation.AnimationId = "rbxassetid://987654321"  -- Substitua pelo ID da sua animação
animation.Parent = animator

-- Variável para controlar o teleport
local teleporting = false

-- Função para teleportar o jogador
local function teleportTo(position)
    player.Character.HumanoidRootPart.CFrame = CFrame.new(position)
end

-- Configura a animação para ser tocada quando a ferramenta for ativada
tool.Activated:Connect(function()
    local animTrack = animator:LoadAnimation(animation)
    animTrack:Play()
end)

-- Função que escuta o evento de equipar a ferramenta
tool.Equipped:Connect(function()
    teleporting = true
    
    -- Conecta o evento de clique no Mouse para teleportar
    local mouse = player:GetMouse()
    mouse.Button1Down:Connect(function()
        if teleporting then
            teleportTo(mouse.Hit.Position)
        end
    end)
end)

-- Função que escuta o evento de desequipar a ferramenta
tool.Unequipped:Connect(function()
    teleporting = false
end)

-- Adiciona a ferramenta à mochila do jogador
tool.Parent = player.Backpack

-- Mensagem de confirmação
print("Ferramenta com textura e animação criada e adicionada à sua mochila!")