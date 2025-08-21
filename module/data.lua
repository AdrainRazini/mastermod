
local config = {}

-- Criação da lista de cores 
config.colors = {
	Main = Color3.fromRGB(20, 20, 20),
	Secondary = Color3.fromRGB(35, 35, 35),
	Accent = Color3.fromRGB(0, 170, 255),
	Text = Color3.fromRGB(255, 255, 255),
	Button = Color3.fromRGB(50, 50, 50),
	ButtonHover = Color3.fromRGB(70, 70, 70),
	Stroke = Color3.fromRGB(80, 80, 80),
	Highlight = Color3.fromRGB(0, 255, 0),
	HighlightOthers = Color3.fromRGB(255, 0, 0), -- cor para outros jogadores
	Red = Color3.fromRGB(255, 0, 0),
	Green = Color3.fromRGB(0, 255, 0),
	Blue = Color3.fromRGB(0, 0, 255),
	Yellow = Color3.fromRGB(255, 255, 0),
	Orange = Color3.fromRGB(255, 165, 0),
	Purple = Color3.fromRGB(128, 0, 128),
	Pink = Color3.fromRGB(255, 105, 180),
	White = Color3.fromRGB(255, 255, 255),
	Black = Color3.fromRGB(0, 0, 0),
	Gray = Color3.fromRGB(128, 128, 128),
	DarkGray = Color3.fromRGB(50, 50, 50),
	LightGray = Color3.fromRGB(200, 200, 200),
	Cyan = Color3.fromRGB(0, 255, 255),
	Magenta = Color3.fromRGB(255, 0, 255),
	Brown = Color3.fromRGB(139, 69, 19),
	Gold = Color3.fromRGB(255, 215, 0),
	Silver = Color3.fromRGB(192, 192, 192),
	Maroon = Color3.fromRGB(128, 0, 0),
	Navy = Color3.fromRGB(0, 0, 128),
	Lime = Color3.fromRGB(50, 205, 50),
	Olive = Color3.fromRGB(128, 128, 0),
	Teal = Color3.fromRGB(0, 128, 128),
	Aqua = Color3.fromRGB(0, 255, 170),
	Coral = Color3.fromRGB(255, 127, 80),
	Crimson = Color3.fromRGB(220, 20, 60),
	Indigo = Color3.fromRGB(75, 0, 130),
	Turquoise = Color3.fromRGB(64, 224, 208),
	Slate = Color3.fromRGB(112, 128, 144),
	Chocolate = Color3.fromRGB(210, 105, 30)
}

-- Ícones
config.icons = {
	-- Ícone do sistema (rr)
	fa_rr_toggle_left = "rbxassetid://118353432570896", -- Off
	fa_rr_toggle_right = "rbxassetid://136961682267523", -- On
	fa_rr_information = "rbxassetid://99073088081563", -- Informações

	-- Ícone normal (bx)
	fa_bx_code_start = "rbxassetid://107895739450188", -- <>
	fa_bx_code_end = "rbxassetid://106185292775972", -- </>
	fa_bx_config = "rbxassetid://95026906912083", -- ●
	fa_bx_loader = "rbxassetid://123191542300310", -- loading
}


-- getgenv 


config.getMause = {}

local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")

-- Estado interno
local MouseState = {
    Locked = false,
    LockedPosition = Vector2.new(0,0),
    RightClick = false
}

-- Trava posição do mouse
function config.getMause.LockMouse(pos)
    MouseState.LockedPosition = pos or UIS:GetMouseLocation()
    MouseState.Locked = true
end

function config.getMause.UnlockMouse()
    MouseState.Locked = false
end

function config.getMause.IsLocked()
    return MouseState.Locked
end

-- Alterna botão do mouse
function config.getMause.ToggleButton()
    MouseState.RightClick = not MouseState.RightClick
end

function config.getMause.IsRightClick()
    return MouseState.RightClick
end

-- Envia clique do mouse
function config.getMause.Click(isDown)
    local btn = MouseState.RightClick and 1 or 0
    local pos = MouseState.Locked and MouseState.LockedPosition or UIS:GetMouseLocation()
    VIM:SendMouseButtonEvent(pos.X, pos.Y, btn, isDown, nil, 0)
end

-- Retorna posição atual
function config.getMause.GetPosition()
    return MouseState.Locked and MouseState.LockedPosition or UIS:GetMouseLocation()
end

-- Move o mouse suavemente até uma posição alvo
function config.getMause.MoveTo(targetPos, steps, delay)
    steps = steps or 20        -- número de passos
    delay = delay or 0.01      -- intervalo entre passos
    local startPos = config.getMause.GetPosition()
    local deltaX = (targetPos.X - startPos.X) / steps
    local deltaY = (targetPos.Y - startPos.Y) / steps

    for i = 1, steps do
        local newPos = Vector2.new(startPos.X + deltaX * i, startPos.Y + deltaY * i)
        if MouseState.Locked then
            config.getMause.LockMouse(newPos)
        else
            VIM:SendMouseMoveEvent(newPos.X, newPos.Y, nil) -- movimento real
        end
        task.wait(delay)
    end
end

-- 🔑 Retorna a tabela para ser usada em outros scripts
return config
