--== Configura getgenv para controlar o mouse globalmente ==--
getgenv().MouseController = getgenv().MouseController or {}

-- Função global para mover o mouse
getgenv().MouseController.MoveMouseTo = function(position)
    local VIM = game:GetService("VirtualInputManager")
    
    -- Atualiza bolinha da GUI se existir
    if getgenv().MouseController.MouseDot then
        getgenv().MouseController.MouseDot.Position = position
    end

    -- Atualiza posição travada do mouse
    if getgenv().MouseController.Flags and getgenv().MouseController.Flags.Mouse_Locked then
        getgenv().MouseController.Flags.Mouse_Locked_Position = position
    end

    -- Envia evento para o executor
    VIM:SendMouseMoveEvent(position.X, position.Y, 0)
end

-- Exemplo de uso:
getgenv().MouseController.MoveMouseTo(Vector2.new(500, 300))
