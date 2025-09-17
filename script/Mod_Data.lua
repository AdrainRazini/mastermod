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


local Test_ = {
	Button_Box = false,
	Toggle_Test = false,
	Int_Value = 0,
	Float_Value = 0,
	Type_Name = "Null"
	
}

local Window = Regui.TabsWindow({Title = GuiName, Text = "Mod Menu", Size = UDim2.new(0, 300, 0, 200)})

--[[ 


local function Notify(text, icon, tempo)
	Regui.NotificationPerson(Window.Frame.Parent, {
		Title = "Alert",
		Text = text,
		Icon = icon or "fa_rr_information",
		Tempo = tempo or 5,
		Casch = {}
	})
end

local function CreateSlider(tab, text, color, value, min, max, callback)
	return Regui.CreateSliderInt(tab, {Text=text, Color=color, Value=value, Minimum=min, Maximum=max}, callback)
end

local function CreateToggle(tab, text, color, callback)
	return Regui.CreateToggleboxe(tab, {Text=text, Color=color}, callback)
end


local Hello = Regui.Notifications(Window.Frame.Parent, {
	Title = "Alert",
	Text = "Hello " .. game.Players.LocalPlayer.Name,
	Icon = "fa_bx_config", -- pode passar assetid ou string
	Tempo = 10
}, function(val)
	print("Notificação enviada!", val)
end)


]]


local FarmTab = Regui.CreateTab(Window, {Name = "Example"})
local Label_Farme = Regui.CreateLabel(FarmTab, {Text = "Example", Color = "White", Alignment = "Center"})

local Check_Farme = Regui.CreateCheckboxe(FarmTab, {Text = "Checkboxe", Color = "Blue"}, function(state)
	Test_.Button_Box = state
	--print("Checkbox clicada! Estado:", Test_.Button_Box)
	
	if Test_.Button_Box  then
		-- Notificação se for Verdadeiro
		Regui.NotificationPerson(Window.Frame.Parent, {
			Title = "Alert",
			Text = "Checkbox clicada! Estado: " .. tostring(Test_.Button_Box),
			Icon = "fa_envelope",
			Tempo = 10,
			Casch = {},
			Sound = ""
		}, function()
			print("Notificação fechada!")
		end)
	end
	

end)

local Toggle_Farme = Regui.CreateToggleboxe(FarmTab, {Text = "Toggle", Color = "Blue"}, function(state)
	
	Test_.Toggle_Test = state
	--print("Toggle clicada! Estado:", Test_.Toggle_Test)
	
	if Test_.Toggle_Test  then
		-- Notificação se for Verdadeiro
		Regui.NotificationPerson(Window.Frame.Parent, {
			Title = "Alert",
			Text = "Toggle clicada! Estado: " .. tostring(Test_.Toggle_Test),
			Icon = "fa_envelope",
			Tempo = 10,
			Casch = {},
			Sound = ""
		}, function()
			print("Notificação fechada!")
		end)
	end
end)

-- Principais sliders

local SliderFloat = Regui.CreateSliderFloat(FarmTab, {Text = "Timer Flaot", Color = "Blue", Value = 0.1, Minimum = 0, Maximum = 1}, function(state)
	Test_.Float_Value = state
	print("Slider Float clicada! Estado:", Test_.Float_Value)
	
end)

local SliderInt = Regui.CreateSliderInt(FarmTab, {Text = "Timer Int", Color = "Blue", Value = 1, Minimum = 0, Maximum = 100}, function(state)
Test_.Int_Value = state
	print("Slider Int clicada! Estado:", Test_.Int_Value)

end)

local SliderOption = Regui.CreateSliderOption(FarmTab, {Text = "Timer Option", Color = "White", Background = "Blue" , Value = 1, Table = {"Melle","Fire","Aura"}}, function(state)
	Test_.Type_Name = state
	print("Slider Int clicada! Estado:", Test_.Type_Name)
end)


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
local SliderInt = Regui.CreateSliderInt(Tab_F_Logs, {Text = "Timer Int", Color = "Blue", Value = 1, Minimum = 0, Maximum = 100}, function(state) end) 

local PlayerTab = Regui.CreateTab(Window, {Name = "Player"})

local GameTab = Regui.CreateTab(Window, {Name = "Game"})

local ToolsTab = Regui.CreateTab(Window, {Name = "Tools"})

local ReadmeTab = Regui.CreateTab(Window, {Name = "Readme"})
--[[

local Readme_Lb = Regui.CreateLabel(ReadmeTab, {
	Text = "\n• This UI library was created by @Adrian75556435 Thanks."
		.. "\n• Owner Of Script: @Adrian75556435"
		.. "\n• Script & Management By: @Adrian75556435",
	Color = "White",
	Alignment = "Left"
})

]]

local Credits = Regui.CreditsUi(ReadmeTab, { Alignment = "Center", Alignment_Texts = "Left"}, function() end)



