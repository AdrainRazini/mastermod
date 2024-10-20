local player = game.Players.LocalPlayer

local tool = Instance.new("Tool")
tool.Name = "Teleport"
tool.RequiresHandle = true

local handle = Instance.new("Part")
handle.Name = "Handle"
handle.Size = Vector3.new(1, 5, 1)
handle.Anchored = false
handle.CanCollide = false
handle.BrickColor = BrickColor.new("Bright red")
handle.Parent = tool

local texture = Instance.new("Decal")
texture.Texture = "rbxassetid://123456789"  -- Substitua pelo ID da sua textura
texture.Parent = handle

local animator = Instance.new("AnimationController")
animator.Name = "AnimationController"
animator.Parent = tool

local animation = Instance.new("Animation")
animation.AnimationId = "rbxassetid://987654321"  -- Substitua pelo ID da sua animação
animation.Parent = animator

-- Adicionando o som
local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://5066021887"  -- ID do som que você deseja tocar
sound.Parent = handle

local teleporting = false

local function teleportTo(position)
    sound:Play()  -- Toca o som quando o jogador se teleporta
    player.Character.HumanoidRootPart.CFrame = CFrame.new(position)
end

tool.Activated:Connect(function()
    local animTrack = animator:LoadAnimation(animation)
    animTrack:Play()
end)

tool.Equipped:Connect(function()
    teleporting = true
    local mouse = player:GetMouse()

    mouse.Button1Down:Connect(function()
        if teleporting then
            teleportTo(mouse.Hit.Position)
        end
    end)
end)

tool.Unequipped:Connect(function()
    teleporting = false
end)

tool.Parent = player.Backpack

print("Ferramenta com textura, animação e som criada e adicionada à sua mochila!")
