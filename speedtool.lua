-- Acessa o jogador local
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Cria uma nova ferramenta
local tool = Instance.new("Tool")
tool.Name = "velocidade"
tool.TextureId = "rbxassetid://110030373197906"
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

-- Configura a animação para ser tocada quando a ferramenta for ativada
local animTrack

tool.Equipped:Connect(function()
    -- Aumenta a velocidade
    character.Humanoid.WalkSpeed = 50  -- 16 é a velocidade padrão, então 16 * 5 = 80
    animTrack = animator:LoadAnimation(animation)
    animTrack:Play()
end)

tool.Unequipped:Connect(function()
    -- Restaura a velocidade
    character.Humanoid.WalkSpeed = 16  -- Restaura a velocidade padrão
    if animTrack then
        animTrack:Stop()
    end
end)

-- Adiciona a ferramenta à mochila do jogador
tool.Parent = player.Backpack

-- Mensagem de confirmação
print("Ferramenta com textura e animação criada e adicionada à sua mochila!")