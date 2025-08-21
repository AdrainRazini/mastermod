
-- URL da API do GitHub para listar os scripts
local GITHUB_USER = "AdrainRazini"
local GITHUB_REPO = "Mastermod"
local GITHUB_REPO_NAME = "Mastermod"
local Owner = "Adrian75556435"
local SCRIPTS_FOLDER_URL = "https://api.github.com/repos/" .. GITHUB_USER .. "/" .. GITHUB_REPO .. "/contents/script"
local IMG_ICON = "rbxassetid://117585506735209"
local NAME_MOD_MENU = "ModMenuGui"

-- Tenta carregar o módulo do GitHub
local success, MouseModule = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/".. GITHUB_USER .."/".. GITHUB_REPO .."/refs/heads/main/module/MouseModule.lua"))()
end)

if not success or not MouseModule then
    warn("Falha ao carregar MouseModule")
    return
end

-- Travar mouse
MouseModule.getMause.LockMouse() 

-- Soltar mouse
MouseModule.getMause.UnlockMouse()

-- Alternar botão esquerdo/direito
MouseModule.getMause.ToggleButton()

-- Clique simulado
MouseModule.getMause.Click(true)  -- down
MouseModule.getMause.Click(false) -- up

-- Pegar posição atual
local pos = MouseModule.getMause.GetPosition()
print(pos.X, pos.Y)

-- Função para mover o mouse suavemente até uma posição
local function MoveMouseTo(targetPos, steps)
    steps = steps or 20  -- quantos passos para interpolar
    local startPos = MouseModule.getMause.GetPosition()
    local deltaX = (targetPos.X - startPos.X) / steps
    local deltaY = (targetPos.Y - startPos.Y) / steps

    for i = 1, steps do
        local newPos = Vector2.new(startPos.X + deltaX * i, startPos.Y + deltaY * i)
        -- Atualiza posição travada do mouse (se estiver usando LockMouse)
        if MouseModule.getMause.IsLocked() then
            MouseModule.getMause.LockMouse(newPos)
        else
            -- Envia evento de clique falso apenas para atualizar posição do VIM
            local btn = MouseModule.getMause.IsRightClick() and 1 or 0
            game:GetService("VirtualInputManager"):SendMouseButtonEvent(newPos.X, newPos.Y, btn, false, nil, 0)
        end
        task.wait(0.01) -- delay entre passos
    end
end

-- Exemplo de uso: mover o mouse para o canto inferior direito da tela
local Camera = workspace.CurrentCamera
local target = Vector2.new(Camera.ViewportSize.X - 100, Camera.ViewportSize.Y - 100)
MoveMouseTo(target, 50)
