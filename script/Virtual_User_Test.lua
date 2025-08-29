local VirtualUser = game:GetService("VirtualUser")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Simula movimento de mouse para o centro da tela
VirtualUser:Button1Down(Vector2.new(0,0))
wait(0.1)
VirtualUser:Button1Up(Vector2.new(0,0))

-- Isso é útil em scripts de auto AFK
LocalPlayer.Idled:Connect(function()
	VirtualUser:CaptureController()
	VirtualUser:ClickButton2(Vector2.new(0,0))
end)
