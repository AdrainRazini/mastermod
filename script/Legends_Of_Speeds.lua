local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local Regui
local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
local GuiName = "Mod_Animal_Simulator"..game.Players.LocalPlayer.Name



-- Tenta carregar localmente
local success, module = pcall(function()
	return require(script.Parent:FindFirstChild("Mod_UI"))
end)

if success and module then
	Regui = module
else
	-- Tenta baixar remoto
	local HttpService = game:GetService("HttpService")
	local ok, err = pcall(function()
		local code = game:HttpGet("https://raw.githubusercontent.com/AdrainRazini/mastermod/refs/heads/main/module/dataGui.lua")
		Regui = loadstring(code)()
	end)

	if not ok then
		warn("Não foi possível carregar Mod_UI nem local nem remoto!", err)
	end
end

assert(Regui, "Regui não foi carregado!")


if PlayerGui:FindFirstChild(GuiName) then
	Regui.Notifications(PlayerGui, {Title="Alert", Text="Neutralized Code", Icon="fa_rr_information", Tempo=10})
	return
end


--====================================================================================================================--

local AF = { FarmOrb = false, FarmOrbs = false }
local AF_Timer = { FarmOrb_Timer = 0.1, FarmOrbs_Timer = 0.1}
local Val_Orb = "Red Orb"

--===================--
-- Fuctions Executes --
-- ⬇ ⬇ ⬇ ⬇ ⬇ ⬇ ⬇ ⬇
--===================--


function SellsPets(Arg1,Arg2)
	
	local args = {
		[1] = Arg1, -- sellPet
		[2] = game:GetService("Players").LocalPlayer.petsFolder.Epic:FindFirstChild(Arg2) -- "Divine Pegasus"
	}
	game:GetService("ReplicatedStorage").rEvents.sellPetEvent:FireServer(unpack(args))
	
end

function OpensEggs(Arg1, Arg2)
	
	local args = {
		[1] = Arg1 , -- "openCrystal"
		[2] = Arg2 , -- "Jungle Crystal"
	}
	game:GetService("ReplicatedStorage").rEvents.openCrystalRemote:InvokeServer(unpack(args))

end



--===================--
-- Window Guis Tabs --
-- ⬇ ⬇ ⬇ ⬇ ⬇ ⬇ ⬇ ⬇
--===================--
-- GUI
Window = Regui.TabsWindow({Title=GuiName, Text="Legends Of Speed", Size=UDim2.new(0,300,0,200)})
FarmTab = Regui.CreateTab(Window,{Name="Farm"})
ShopTab = Regui.CreateTab(Window,{Name="Buy"})
GameTab = Regui.CreateTab(Window,{Name="Game"})
AfkTab = Regui.CreateTab(Window,{Name="Afk Mod"})
ConfigsTab = Regui.CreateTab(Window,{Name="Configs"})
ReadmeTab = Regui.CreateTab(Window,{Name="Readme"})

-- Especial Tab
local Credits = Regui.CreditsUi(ReadmeTab, { Alignment = "Center", Alignment_Texts = "Left"}, function() end)

--==================================================--
-- AUTO FARM DE ORBS (INDIVIDUAL + TODAS)
--==================================================--
-- Lista de Orbs disponíveis
local Orbs = {
	{name = "Red Orb", Obj = "Red Orb"},
	{name = "Orange Orb", Obj = "Orange Orb"},
	{name = "Blue Orb", Obj = "Blue Orb"},
	{name = "Yellow Orb", Obj = "Yellow Orb"},
	{name = "Diamond", Obj = "Gem"}
}

--==================================================--
-- SELECTOR + LABEL
--==================================================--

local Selector_Orbs = Regui.CreateSelectorOpitions(FarmTab, {
	Name = "Selecionar Orbs",
	Alignment = "Center",
	Size_Frame = UDim2.new(1, -10, 0, 80),
	Type = "Instance",
	Options = Orbs,
	Frame_Max = 80
}, function(selected)
	Val_Orb = selected.name or selected -- garante que pega o nome certo
	UpdateOrbLabel()
end)

local Label_Orb = Regui.CreateLabel(FarmTab, {
	Text = "Orb Selecionada: " .. Val_Orb,
	Color = "White",
	Alignment = "Center"
})

function UpdateOrbLabel()
	Label_Orb.Text = "Orb Selecionada: " .. tostring(Val_Orb)
end

--==================================================--
-- FUNÇÕES DE FARM
-- ⬇ ⬇ ⬇ ⬇ ⬇ ⬇ ⬇ ⬇
--==================================================--

-- Farm apenas uma orb (a selecionada)
function FarmOrb()
	task.spawn(function()
		while AF.FarmOrb do
			local args = {
				[1] = "collectOrb",
				[2] = Val_Orb,
				[3] = "City"
			}
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer(unpack(args))
			task.wait(AF_Timer.FarmOrb_Timer)
		end
	end)
end

-- Farm todas as orbs da lista
function FarmAllOrbs()
	task.spawn(function()
		while AF.FarmOrbs do
			for _, orb in ipairs(Orbs) do
				local args = {
					[1] = "collectOrb",
					[2] = orb.Obj,
					[3] = "City"
				}
				game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer(unpack(args))
				task.wait(AF_Timer.FarmOrbs_Timer)
			end
		end
	end)
end





--===================--
-- Window Farm Tab   --
-- ⬇ ⬇ ⬇ ⬇ ⬇ ⬇ ⬇ ⬇
--===================--

-- 🔹 Toggle: Auto Orb (único)
local Toggle_Orb_AF = Regui.CreateToggleboxe(FarmTab, {
	Text = "Auto Orb (Selecionado)",
	Color = "Yellow"
}, function(state)
	AF.FarmOrb = state
	if state then
		Regui.NotificationPerson(Window.Frame.Parent, {
			Title = "AutoFarm",
			Text = "Coleta de orb iniciada: " .. Val_Orb,
			Icon = "fa_rr_paper_plane",
			Tempo = 5
		})
		FarmOrb()
	else
		Regui.NotificationPerson(Window.Frame.Parent, {
			Title = "AutoFarm",
			Text = "Auto Orbs (único) parado.",
			Icon = "fa_rr_stop_circle",
			Tempo = 5
		})
	end
end)

-- 🔹 Toggle: Auto Orbs All (todas)
local Toggle_Orbs_All_AF = Regui.CreateToggleboxe(FarmTab, {
	Text = "Auto Orbs (All)",
	Color = "Cyan"
}, function(state)
	AF.FarmOrbs = state
	if state then
		Regui.NotificationPerson(Window.Frame.Parent, {
			Title = "AutoFarm",
			Text = "Coleta automática de todas as orbes iniciada!",
			Icon = "fa_rr_paper_plane",
			Tempo = 5
		})
		FarmAllOrbs()
	else
		Regui.NotificationPerson(Window.Frame.Parent, {
			Title = "AutoFarm",
			Text = "Coleta automática de todas as orbes parada.",
			Icon = "fa_rr_stop_circle",
			Tempo = 5
		})
	end
end)

local Slider_Float_Obrs = Regui.CreateSliderFloat(FarmTab, {
	Text = "Velocidade de Coleta (Timer)",
	Color = "Blue",
	Value = 0.1,
	Minimum = 0.01,
	Maximum = 1
}, function(value)
	AF_Timer.FarmOrb_Timer = value
	AF_Timer.FarmOrbs_Timer = value
end)


local AF_Togle = Regui.CreateLabel()


function AutoRebirt(Arg1)
	local args = {
[1] = "rebirthRequest"

	}

	game:GetService("ReplicatedStorage").rEvents.rebirthEvent:FireServer(unpack(args))
end

