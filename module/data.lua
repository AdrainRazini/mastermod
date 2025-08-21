-- module.lua
local config = {}

--== Cores ==--
config.colors = {
    Main = Color3.fromRGB(20, 20, 20),
    Secondary = Color3.fromRGB(35, 35, 35),
    Accent = Color3.fromRGB(0, 170, 255),
    Text = Color3.fromRGB(255, 255, 255),
    Button = Color3.fromRGB(50, 50, 50),
    ButtonHover = Color3.fromRGB(70, 70, 70),
    Stroke = Color3.fromRGB(80, 80, 80),
    Highlight = Color3.fromRGB(0, 255, 0)
    -- ... (demais cores como você já colocou)
}

--== Ícones ==--
config.icons = {
    fa_rr_toggle_left = "rbxassetid://118353432570896",
    fa_rr_toggle_right = "rbxassetid://136961682267523",
    fa_rr_information = "rbxassetid://99073088081563",
    fa_bx_code_start = "rbxassetid://107895739450188",
    fa_bx_code_end = "rbxassetid://106185292775972",
    fa_bx_config = "rbxassetid://95026906912083",
    fa_bx_loader = "rbxassetid://123191542300310"
}

--== Espaço para funções relacionadas ao mouse ==--
config.getMause = {}

--== Função global para mover o mouse usando executor ==--
getgenv().MouseController = getgenv().MouseController or {}
getgenv().MouseController.Flags = getgenv().MouseController.Flags or {
    Mouse_Locked = true,
    Mouse_Locked_Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X/2, workspace.CurrentCamera.ViewportSize.Y/2)
}
getgenv().MouseController.MouseDot = getgenv().MouseController.MouseDot or nil

getgenv().MouseController.MoveMouseTo = function(position)
    local VIM = game:GetService("VirtualInputManager")

    -- Atualiza bolinha da GUI se existir
    if getgenv().MouseController.MouseDot then
        getgenv().MouseController.MouseDot.Position = position
    end

    -- Atualiza posição travada do mouse
    if getgenv().MouseController.Flags.Mouse_Locked then
        getgenv().MouseController.Flags.Mouse_Locked_Position = position
    end

    -- Envia evento para o executor
    VIM:SendMouseMoveEvent(position.X, position.Y, 0)
end

-- Exemplo de uso dentro do módulo (opcional)
-- getgenv().MouseController.MoveMouseTo(Vector2.new(500, 300))

-- Retorna a tabela para outros scripts
return config
