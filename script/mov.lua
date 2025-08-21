
-- URL da API do GitHub para listar os scripts
local GITHUB_USER = "AdrainRazini"
local GITHUB_REPO = "Mastermod"
local GITHUB_REPO_NAME = "Mastermod"
local Owner = "Adrian75556435"
local SCRIPTS_FOLDER_URL = "https://api.github.com/repos/" .. GITHUB_USER .. "/" .. GITHUB_REPO .. "/contents/script"
local IMG_ICON = "rbxassetid://117585506735209"
local NAME_MOD_MENU = "ModMenuGui"

local Module

-- 1. Tenta carregar pelo GitHub (só funciona em executor com HttpGet habilitado)
pcall(function()
	Module = loadstring(game:HttpGet("https://raw.githubusercontent.com/".. GITHUB_USER .."/".. GITHUB_REPO .."/refs/heads/main/module/data.lua"))()
end)


-- Função para "pegar" a posição atual do mouse e definir como posição travada
getgenv().MouseController.GetMousePosition = function()
    local UIS = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")

    -- Flag para esperar o clique
    local clicked = false
    local position = Vector2.new(0,0)

    -- Conecta InputBegan para capturar clique do mouse
    local conn
    conn = UIS.InputBegan:Connect(function(input, GPE)
        if not GPE and input.UserInputType == Enum.UserInputType.MouseButton1 then
            position = UIS:GetMouseLocation()
            clicked = true
        end
    end)

    -- Espera até o clique acontecer
    while not clicked do
        RunService.RenderStepped:Wait()
    end

    -- Desconecta o evento
    conn:Disconnect()

    -- Atualiza posição travada e bolinha da GUI
    if getgenv().MouseController.Flags then
        getgenv().MouseController.Flags.Mouse_Locked_Position = position
    end
    if getgenv().MouseController.MouseDot then
        getgenv().MouseController.MouseDot.Position = position
    end

    return position
end

-- Exemplo de uso:
local mousePos = getgenv().MouseController.GetMousePosition()
print("Mouse definido em:", mousePos)

-- Depois pode mover o mouse com:
getgenv().MouseController.MoveMouseTo(mousePos)
