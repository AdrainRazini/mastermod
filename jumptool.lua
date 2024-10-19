-- Ferramenta de Aumento de Salto
local tool = Instance.new("Tool")
tool.Name = "JumpBoostTool"
tool.RequiresHandle = true

local handle = Instance.new("Part")
handle.Name = "Handle"
handle.Size = Vector3.new(1, 5, 1)
handle.Anchored = false
handle.CanCollide = false
handle.BrickColor = BrickColor.new("Bright purple")
handle.Parent = tool

tool.Equipped:Connect(function()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")

    if humanoid then
        humanoid.JumpPower = 100  -- Aumenta o poder de salto
        print("Poder de salto aumentado!")
    end
end)

tool.Unequipped:Connect(function()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")

    if humanoid then
        humanoid.JumpPower = 50  -- Restaura o poder de salto padrão
        print("Poder de salto restaurado.")
    end
end)

tool.Parent = game.Players.LocalPlayer.Backpack
print("Ferramenta de Aumento de Salto criada!")