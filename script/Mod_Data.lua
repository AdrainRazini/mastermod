local Regui
local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
local GuiName = "Mod_"..game.Players.LocalPlayer.Name

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



-- Evita múltiplas GUIs
if PlayerGui:FindFirstChild(GuiName) then
	Regui.Notifications(PlayerGui, {
		Title = "Alert",
		Text = "Neutralized Code",
		Icon = "fa_rr_information",
		Tempo = 10
	})
	return
end

local Window = Regui.TabsWindow({Title = GuiName, Text = "Mod Menu", Size = UDim2.new(0, 300, 0, 200)})

local FarmTab = Regui.CreateTab(Window, {Name = "Farm"})
local Label_Farme = Regui.CreateLabel(FarmTab, {Text = "Farm", Color = "White", Alignment = "Center"})

local Check_Farme = Regui.CreateCheckboxe(FarmTab, {Text = "Checkboxe", Color = "Blue"}, function(state)
	print("Checkbox clicada! Estado:", state)
end)

local Toggle_Farme = Regui.CreateToggleboxe(FarmTab, {Text = "Toggle", Color = "Blue"}, function(state)
	print("Toggle clicada! Estado:", state)
end)

local SliderFloat = Regui.CreateSliderFloat(FarmTab, {Text = "Timer Flaot", Color = "Blue", Value = 0.1, Minumum = 0, Maximum = 1}, function(state) end)

local SliderInt = Regui.CreateSliderInt(FarmTab, {Text = "Timer Int", Color = "Blue", Value = 1, Minumum = 0, Maximum = 100}, function(state) end)


-- Cria SubWindow 
local SubWin = Regui.SubTabsWindow(FarmTab, {
	Text = "Sub_Window",
	Table = {"Logs","Player","Main"},
	Color = "Blue"
})

-- Adiciona controles dentro de cada subtab
Regui.CreateSliderInt(SubWin["Logs"], {
	Text = "Delay Logs",
	Color = "Blue",
	Value = 5,
	Minimum = 0,
	Maximum = 20
}, function(val)  end)

Regui.CreateSliderInt(SubWin["Player"], {
	Text = "HP Regen",
	Color = "Green",
	Value = 50,
	Minimum = 0,
	Maximum = 100
}, function(val)  end)

Regui.CreateSliderInt(SubWin["Main"], {
	Text = "Auto Timer",
	Color = "Red",
	Value = 1,
	Minimum = 0,
	Maximum = 10
}, function(val)  end)


local Tab_F_Logs = Regui.CreateSubTab(FarmTab, { Text = "Alert", Table= {"Logs: Null", "Player: " .. game.Players.LocalPlayer.Name, "Main: Null"}, Color = "Blue"})
-- SubTab
local SliderInt = Regui.CreateSliderInt(Tab_F_Logs, {Text = "Timer Int", Color = "Blue", Value = 1, Minumum = 0, Maximum = 100}, function(state) end) 


local PlayerTab = Regui.CreateTab(Window, {Name = "Player"})

local GameTab = Regui.CreateTab(Window, {Name = "Game"})

local ToolsTab = Regui.CreateTab(Window, {Name = "Tools"})

local ReadmeTab = Regui.CreateTab(Window, {Name = "Readme"})

local Readme_Lb = Regui.CreateLabel(ReadmeTab, {
	Text = "\n• This UI library was created by @Adrian75556435 Thanks."
		.. "\n• Owner Of Script: @Adrian75556435"
		.. "\n• Script & Management By: @Adrian75556435",
	Color = "White",
	Alignment = "Left"
})


local Hello = Regui.Notifications(Window.Frame.Parent, {
	Title = "Alert",
	Text = "Hello " .. game.Players.LocalPlayer.Name,
	Icon = "fa_bx_config", -- pode passar assetid ou string
	Tempo = 10
}, function(val)
	print("Notificação enviada!", val)
end)


