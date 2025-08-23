local config = {}

--==============================
-- 🎨 Paleta de cores
--==============================
config.colors = {
	Main = Color3.fromRGB(20, 20, 20),
	Secondary = Color3.fromRGB(35, 35, 35),
	Accent = Color3.fromRGB(0, 170, 255),
	Text = Color3.fromRGB(255, 255, 255),
	Button = Color3.fromRGB(50, 50, 50),
	ButtonHover = Color3.fromRGB(70, 70, 70),
	Stroke = Color3.fromRGB(80, 80, 80),
	Highlight = Color3.fromRGB(0, 255, 0),
	HighlightOthers = Color3.fromRGB(255, 0, 0),

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

--==============================
-- 🖼 Ícones
--==============================
config.icons = {
		fa_bx_mastermods = "rbxassetid://102637810511338", -- Logo do meu mod
	fa_rr_toggle_left = "rbxassetid://118353432570896", -- Off
	fa_rr_toggle_right = "rbxassetid://136961682267523", -- On
	fa_rr_information = "rbxassetid://99073088081563", -- Info
	fa_bx_code_start = "rbxassetid://107895739450188", -- <>
	fa_bx_code_end = "rbxassetid://106185292775972", -- </>
	fa_bx_config = "rbxassetid://95026906912083", -- ●
	fa_bx_loader = "rbxassetid://123191542300310", -- loading
}

--==============================
-- 🖱 Sistema de Mouse
--==============================
config.getMause = {}

local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local GuiService = game:GetService("GuiService")

-- Estado interno
local MouseState = {
    Locked = false,
    LockedPosition = Vector2.new(0,0),
    RightClick = false
}

-- 📍 Posição atual
function config.getMause.GetPosition()
    return MouseState.Locked and MouseState.LockedPosition or UIS:GetMouseLocation()
end

-- 🔒 Função que retorna posição segura (PC ou Mobile)
local function getSafeMouseLocation()
    if UIS.TouchEnabled and not UIS.MouseEnabled then
        -- 📱 Se for celular, pega centro da tela
        local screenSize = workspace.CurrentCamera.ViewportSize
        return Vector2.new(screenSize.X/2, screenSize.Y/2)
    else
        -- 🖱 PC (mouse real)
        return UIS:GetMouseLocation()
    end
end

-- 🔒 Trava posição do mouse
function config.getMause.LockMouse(pos)
    MouseState.LockedPosition = pos or getSafeMouseLocation()
    MouseState.Locked = true
end

function config.getMause.UnlockMouse()
    MouseState.Locked = false
end

function config.getMause.IsLocked()
    return MouseState.Locked
end


-- ↔️ Alterna botão do mouse
function config.getMause.ToggleButton()
    MouseState.RightClick = not MouseState.RightClick
end

function config.getMause.IsRightClick()
    return MouseState.RightClick
end


-- 🖱 Clique (segurar/soltar manual)
function config.getMause.Click(isDown, rightClick)
    rightClick = (rightClick ~= nil) and rightClick or MouseState.RightClick
    local btn = rightClick and 1 or 0
    local pos = MouseState.Locked and MouseState.LockedPosition or UIS:GetMouseLocation()
    
    print("[Click] isDown:", isDown, "rightClick:", rightClick, "btn:", btn) -- DEBUG
    
    VIM:SendMouseButtonEvent(pos.X, pos.Y, btn, isDown, nil, 0)
end

-- 🖱 Clique simples (pressiona e solta automaticamente)
function config.getMause.ClickUp(rightClick, time)
    rightClick = (rightClick ~= nil) and rightClick or MouseState.RightClick
    local btn = rightClick and 1 or 0
    local pos = MouseState.Locked and MouseState.LockedPosition or UIS:GetMouseLocation()

    -- Debug
    print("[ClickUp] rightClick:", rightClick, "btn:", btn, "pos:", pos)

    -- Pressiona
    VIM:SendMouseButtonEvent(pos.X + 50, pos.Y - 20, btn, true, nil, 0)
    
    task.wait(time or 0.05)
    -- Solta
    VIM:SendMouseButtonEvent(pos.X + 50 , pos.Y - 20, btn, false, nil, 0)
 
end




-- ⬆️ Scroll do mouse
function config.getMause.Scroll(amount)
    amount = amount or 1
    VIM:SendMouseWheelEvent(amount, nil, 0)
end

-- 🖱 Clique duplo
function config.getMause.DoubleClick(rightClick, interval)
    rightClick = rightClick or MouseState.RightClick
    interval = interval or 0.1
    config.getMause.ClickUp(rightClick)
    task.wait(interval)
    config.getMause.ClickUp(rightClick)
end


-- ✋ Arrastar de uma posição a outra
function config.getMause.Drag(fromPos, toPos, steps, delay)
    steps = steps or 20
    delay = delay or 0.01
    config.getMause.MoveTo(fromPos, steps, delay)
    config.getMause.Click(true) -- segurar
    config.getMause.MoveTo(toPos, steps, delay)
    config.getMause.Click(false) -- soltar
end

-- 🔄 Balançar mouse (shake)
function config.getMause.Shake(intensity, times, delay)
    intensity = intensity or 5
    times = times or 10
    delay = delay or 0.02
    local pos = config.getMause.GetPosition()
    for i = 1, times do
        local offset = (i % 2 == 0) and intensity or -intensity
        VIM:SendMouseMoveEvent(pos.X + offset, pos.Y, nil)
        task.wait(delay)
        VIM:SendMouseMoveEvent(pos.X, pos.Y + offset, nil)
        task.wait(delay)
    end
end

-- 🔵 Mover em círculo
function config.getMause.Circle(radius, steps, delay)
    radius = radius or 50
    steps = steps or 36
    delay = delay or 0.02
    local center = config.getMause.GetPosition()
    for i = 0, 2 * math.pi, (2 * math.pi / steps) do
        local x = center.X + radius * math.cos(i)
        local y = center.Y + radius * math.sin(i)
        VIM:SendMouseMoveEvent(x, y, nil)
        task.wait(delay)
    end
end

-- 🔄 Mover suavemente até posição alvo
function config.getMause.MoveTo(targetPos, steps, delay)
    steps = steps or 20
    delay = delay or 0.01
    local startPos = config.getMause.GetPosition()
    local deltaX = (targetPos.X - startPos.X) / steps
    local deltaY = (targetPos.Y - startPos.Y) / steps
    for i = 1, steps do
        local newPos = Vector2.new(startPos.X + deltaX * i, startPos.Y + deltaY * i)
        if MouseState.Locked then
            config.getMause.LockMouse(newPos)
        else
            VIM:SendMouseMoveEvent(newPos.X, newPos.Y, nil)
        end
        task.wait(delay)
    end
end

-- ♻️ Resetar estado
function config.getMause.Reset()
    MouseState.Locked = false
    MouseState.LockedPosition = Vector2.new(0,0)
    MouseState.RightClick = false
end

--==============================
-- 🔑 Retorno
--==============================
return config
