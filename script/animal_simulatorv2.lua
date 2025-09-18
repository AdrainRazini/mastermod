-- ==========================================
-- Integração GUI + MastermodModule
-- ==========================================

local Mastermod
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
		code_Mod = game:HttpGet("https://raw.githubusercontent.com/AdrainRazini/mastermod/refs/heads/main/module/MastermodModule.lua")
        Regui = loadstring(code)()
        Mastermod = loadstring(code_Mod)()
	end)

	if not ok then
		warn("Não foi possível carregar Mod_UI nem local nem remoto!", err)
	end
end

assert(Regui, "Regui não foi carregado!")


local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
local GuiName = "Mod_Animal_Simulator"..game.Players.LocalPlayer.Name

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

-- Janela principal
local Window = Regui.TabsWindow({
	Title = GuiName,
	Text = "Mod Menu",
	Size = UDim2.new(0, 350, 0, 250)
})

-- ==========================================
-- Aba Farm
-- ==========================================
local FarmTab = Regui.CreateTab(Window, {Name = "Farm"})
Regui.CreateLabel(FarmTab, {Text = "Configurações de Farm", Color = "White", Alignment = "Center"})

-- Auto Coins
Regui.CreateCheckboxe(FarmTab, {Text = "Auto Coins", Color = "Blue"}, function(state)
	Mastermod.AF.coins = state
	if state then Mastermod.StartAutoCoins() end
end)

-- Auto Dummies
Regui.CreateCheckboxe(FarmTab, {Text = "Auto Dummies", Color = "Blue"}, function(state)
	Mastermod.AF.dummies = state
	if state then Mastermod.StartAutoDummy("dummies", workspace.MAP.dummies) end
end)

-- Auto Bosses
Regui.CreateCheckboxe(FarmTab, {Text = "Auto Bosses", Color = "Blue"}, function(state)
	Mastermod.AF.bosses = state
	if state then Mastermod.StartAutoBosses() end
end)

-- Teleport Dummy
Regui.CreateCheckboxe(FarmTab, {Text = "TP Dummy", Color = "Blue"}, function(state)
	Mastermod.AF.tpDummy = state
end)

-- Teleport Dummy 5k
Regui.CreateCheckboxe(FarmTab, {Text = "TP Dummy 5k", Color = "Blue"}, function(state)
	Mastermod.AF.tpDummy5k = state
end)

-- Slider Float Timer
Regui.CreateSliderFloat(FarmTab, {Text = "Timer Float", Color = "Blue", Value = Mastermod.AF_Timer.Dummies_Speed, Minimum = 0.05, Maximum = 1}, function(val)
	Mastermod.AF_Timer.Dummies_Speed = val
end)

-- Slider Int Timer
Regui.CreateSliderInt(FarmTab, {Text = "Timer Int", Color = "Blue", Value = 1, Minimum = 0, Maximum = 100}, function(val)
	-- Aqui poderia controlar outro timer do módulo
end)

-- Selector Tipo de Ataque
Regui.CreateSliderOption(FarmTab, {Text = "Tipo de Ataque", Color = "White", Background = "Blue", Value = 1, Table = {"Melee", "Fire", "Aura"}}, function(val)
	Mastermod.PVP.AttackType = val
end)

-- ==========================================
-- Aba PvP
-- ==========================================
local PvPTab = Regui.CreateTab(Window, {Name = "PvP"})
Regui.CreateLabel(PvPTab, {Text = "Configurações PvP", Color = "White", Alignment = "Center"})

-- Kill Aura
Regui.CreateToggleboxe(PvPTab, {Text = "Kill Aura", Color = "Red"}, function(state)
	Mastermod.PVP.killAura = state
	if state then Mastermod.StartKillAura() end
end)

-- Auto Fireball
Regui.CreateToggleboxe(PvPTab, {Text = "Auto Fireball", Color = "Red"}, function(state)
	Mastermod.PVP.AutoFire = state
	if state then Mastermod.StartAutoFireball() end
end)

-- Selector Tipo de Ataque PvP
Regui.CreateSliderOption(PvPTab, {Text = "Tipo de Ataque", Color = "White", Background = "Red", Value = 1, Table = {"Melee", "Fireball", "Lightning"}}, function(val)
	Mastermod.PVP.AttackType = val
end)

-- ==========================================
-- Aba Configs + PainterPanel
-- ==========================================
local ConfigsTab = Regui.CreateTab(Window, {Name = "Configs"})
Regui.CreateLabel(ConfigsTab, {Text = "Configurações de UI", Color = "White", Alignment = "Center"})

Regui.CreatePainterPanel(ConfigsTab, {
	{name="Main_Frame", Obj=Window.Frame},
	{name="Top_Bar", Obj=Window.TopBar},
	{name="Tabs_Container", Obj=Window.Tabs},
	{name="Tab_Content", Obj=Window.TabContainer},
	{name="Top_Tabs_Bar", Obj=Window.TopTabs}
}, function(color, name, obj)
	print("Cor aplicada em:", name, color)
end)

-- Selector Instâncias UI
Regui.CreateSelectorOpitions(ConfigsTab, {
	Name = "Selecionar Instância",
	Alignment = "Center",
	Size_Frame = UDim2.new(1,-10,0,50),
	Frame_Max = 50,
	Options = {
		{name="Main_Frame", Obj=Window.Frame},
		{name="Top_Bar", Obj=Window.TopBar},
		{name="Tabs_Container", Obj=Window.Tabs},
		{name="Tab_Content", Obj=Window.TabContainer},
		{name="Top_Tabs_Bar", Obj=Window.TopTabs}
	},
	Type = "Instance"
}, function(val)
	print("Você escolheu:", val)
end)

-- ==========================================
-- Aba Readme / Credits
-- ==========================================
local ReadmeTab = Regui.CreateTab(Window, {Name = "Readme"})
Regui.CreditsUi(ReadmeTab, {Alignment="Center", Alignment_Texts="Left"}, function() end)
