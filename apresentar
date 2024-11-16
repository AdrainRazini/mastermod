local player = game.Players.LocalPlayer
local gui

-- Função para criar o GUI
local function createGUI()
    -- Cria o ScreenGui
    gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))

    -- Cria o ImageLabel (imagem do jogador)
    local imageLabel = Instance.new("ImageLabel", gui)
    imageLabel.Size = UDim2.new(0, 100, 0, 100)
    imageLabel.Position = UDim2.new(0.5, -50, 0.3, -50)
    imageLabel.BackgroundTransparency = 1
    imageLabel.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=1393562880&width=420&height=420&format=png"

    -- Adiciona texto
    local textLabel = Instance.new("TextLabel", gui)
    textLabel.Size = UDim2.new(0, 400, 0, 50)
    textLabel.Position = UDim2.new(0.5, -200, 0.45, -25)
    textLabel.Text = "adrian75556435\nAdrianRazini"
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.BackgroundTransparency = 1
    textLabel.TextScaled = true
    textLabel.TextStrokeTransparency = 0.5

    -- Cria o Frame de loading
    local loadingFrame = Instance.new("Frame", gui)
    loadingFrame.Size = UDim2.new(0, 300, 0, 50)
    loadingFrame.Position = UDim2.new(0.5, -150, 0.7, -25)
    loadingFrame.BackgroundTransparency = 1

    -- Texto de loading
    local loadingLabel = Instance.new("TextLabel", loadingFrame)
    loadingLabel.Size = UDim2.new(1, 0, 1, 0)
    loadingLabel.Text = "Loading..."
    loadingLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    loadingLabel.BackgroundTransparency = 1
    loadingLabel.TextScaled = true

    -- Função para executar o script remoto
    local function executarScript()
        -- Substitua a URL pelo script que você quer carregar
        local scriptUrl = "https://raw.githubusercontent.com/AdrainRazini/mastermod/refs/heads/main/Mastermodv2"
        -- Executa o script remoto
        loadstring(game:HttpGet(scriptUrl))()
    end

    -- Função de animação de loading
    local function animateLoading()
        local points = 0
        while points < 3 do
            loadingLabel.Text = "Loading" .. string.rep(".", points)
            loadingLabel.TextTransparency = 0
            wait(0.5)
            points = points + 1
        end

        -- Executa o script remoto após o loading
        executarScript()

        -- Após executar o script, aguarda um pouco antes de fechar o GUI
        wait(1)
        gui:Destroy()  -- Fecha a GUI
    end

    -- Inicia a animação de loading
    animateLoading()
end

-- Recriar GUI ao respawn do jogador
player.CharacterAdded:Connect(function()
    -- Se houver uma GUI anterior, destrua-a
    if gui then
        gui:Destroy()
    end
    -- Cria uma nova GUI
    createGUI()
end)

-- Cria a GUI inicialmente
createGUI()
