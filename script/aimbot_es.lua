-- Check if a ScreenGui named "AimbotV2" already exists
local existingScreenGui = game.Players.LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("AimbotV2")

if existingScreenGui then
	return
end

game:GetService("StarterGui"):SetCore("SendNotification", { 
	Title = "Mastermod";
	Text = "AimBot V2";
	Icon = "rbxthumb://type=Asset&id=72684486485553&w=150&h=150",
	Duration = 16;
})

local player = game.Players.LocalPlayer
local players = game:GetService("Players")
local runService = game:GetService("RunService")
local camera = game.Workspace.CurrentCamera

local detectionRadius = 50
local lerpSpeed = 0.1
local aimEnabled = true
local targetEnemiesOnly = false
local includeNPCs = true

local screenGui
local dragging, dragInput, dragStart, startPos

function makeDraggable(frame)
	local userInputService = game:GetService("UserInputService")

	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	userInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)
end

function createUI()
	if screenGui then screenGui:Destroy() end

	screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
	screenGui.Name = "AimbotV2"
	screenGui.ResetOnSpawn = false

	local frame = Instance.new("Frame", screenGui)
	frame.Size = UDim2.new(0, 230, 0, 260)
	frame.Position = UDim2.new(0, 20, 0, 20)
	frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	frame.BackgroundTransparency = 0
	frame.BorderSizePixel = 0
	frame.ClipsDescendants = true

	local corner = Instance.new("UICorner", frame)
	corner.CornerRadius = UDim.new(0, 10)

	makeDraggable(frame)

	-- Title
	local title = Instance.new("TextLabel", frame)
	title.Size = UDim2.new(1, -30, 0, 30)
	title.Position = UDim2.new(0, 10, 0, 5)
	title.Text = "🎯 Aimbot V2"
	title.TextColor3 = Color3.new(1, 1, 1)
	title.BackgroundTransparency = 1
	title.Font = Enum.Font.SourceSansBold
	title.TextSize = 20
	title.TextXAlignment = Enum.TextXAlignment.Left
	
	-- Status dot
	local statusDot = Instance.new("Frame", title)
	statusDot.Size = UDim2.new(0, 10, 0, 10)
	statusDot.Position = UDim2.new(0, 0, 0.5, -5)
	title.TextXAlignment = Enum.TextXAlignment.Center

	statusDot.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- initial red
	statusDot.BorderSizePixel = 0

	local statusCorner = Instance.new("UICorner", statusDot)
	statusCorner.CornerRadius = UDim.new(1, 0)

	function updateStatusDotColor(target)
		if not aimEnabled then
			statusDot.BackgroundColor3 = Color3.fromRGB(255, 255, 0) -- Yellow (Disabled)
		elseif target then
			statusDot.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Green (Targeting)
		else
			statusDot.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Red (No target)
		end
	end

	-- Minimize button
	local minimizeBtn = Instance.new("TextButton", frame)
	minimizeBtn.Size = UDim2.new(0, 20, 0, 20)
	minimizeBtn.Position = UDim2.new(1, -25, 0, 5)
	minimizeBtn.Text = "-"
	minimizeBtn.TextColor3 = Color3.new(1,1,1)
	minimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	minimizeBtn.Font = Enum.Font.SourceSansBold
	minimizeBtn.TextSize = 18

	local contentVisible = true
	local function toggleContent()
		contentVisible = not contentVisible
		for _, obj in pairs(frame:GetChildren()) do
			if obj:IsA("GuiObject") and obj ~= title and obj ~= minimizeBtn and obj ~= corner then
				obj.Visible = contentVisible
			end
		end
		minimizeBtn.Text = contentVisible and "-" or "+"
		frame.Size = contentVisible and UDim2.new(0, 230, 0, 260) or UDim2.new(0, 230, 0, 35)
	end

	minimizeBtn.MouseButton1Click:Connect(toggleContent)

	-- Button creation function
	local y = 40
	local function createButton(text, callback)
		local btn = Instance.new("TextButton", frame)
		btn.Size = UDim2.new(1, -20, 0, 30)
		btn.Position = UDim2.new(0, 10, 0, y)
		btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
		btn.TextColor3 = Color3.new(1, 1, 1)
		btn.Text = text
		btn.Font = Enum.Font.SourceSans
		btn.TextSize = 16
		btn.MouseButton1Click:Connect(function()
			callback(btn)
		end)
		y = y + 35
		return btn
	end

	-- Toggle aim
	createButton("Disable Aim", function(btn)
		aimEnabled = not aimEnabled
		btn.Text = aimEnabled and "Disable Aim" or "Enable Aim"
	end)

	-- Detection radius input
	local distanceBox = Instance.new("TextBox", frame)
	distanceBox.Size = UDim2.new(1, -20, 0, 30)
	distanceBox.Position = UDim2.new(0, 10, 0, y)
	distanceBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	distanceBox.TextColor3 = Color3.new(1, 1, 1)
	distanceBox.Text = tostring(detectionRadius)
	distanceBox.Font = Enum.Font.SourceSans
	distanceBox.TextSize = 16
	distanceBox.ClearTextOnFocus = false
	distanceBox.FocusLost:Connect(function()
		local newVal = tonumber(distanceBox.Text)
		if newVal then
			detectionRadius = math.clamp(newVal, 10, 1000)
		end
	end)
	y = y + 35

	-- Toggle team targeting
	createButton("Target Everyone", function(btn)
		targetEnemiesOnly = not targetEnemiesOnly
		btn.Text = targetEnemiesOnly and "Target Enemies Only" or "Target Everyone"
	end)

	-- Toggle NPCs
	createButton("Target NPCs: Yes", function(btn)
		includeNPCs = not includeNPCs
		btn.Text = "Target NPCs: " .. (includeNPCs and "Yes" or "No")
	end)
end

function findClosestPlayer()
	if not aimEnabled then return nil end

	local character = player.Character
	if not character then return nil end

	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hrp then return nil end

	local closestTarget = nil
	local closestDistance = detectionRadius

	-- Search players
	for _, p in ipairs(players:GetPlayers()) do
		if p ~= player and p.Character then
			if targetEnemiesOnly and p.Team == player.Team then continue end
			local head = p.Character:FindFirstChild("Head")
			local humanoid = p.Character:FindFirstChildOfClass("Humanoid")
			if head and humanoid and humanoid.Health > 0 then
				local distance = (hrp.Position - head.Position).Magnitude
				if distance < closestDistance then
					closestDistance = distance
					closestTarget = p
				end
			end
		end
	end

	-- Search NPCs
	if includeNPCs then
		for _, npc in ipairs(workspace:GetDescendants()) do
			if npc:IsA("Model") and not players:GetPlayerFromCharacter(npc) then
				local hum = npc:FindFirstChildOfClass("Humanoid")
				local head = npc:FindFirstChild("Head")
				if hum and head and hum.Health > 0 then
					local distance = (hrp.Position - head.Position).Magnitude
					if distance < closestDistance then
						closestDistance = distance
						closestTarget = { Character = npc }
					end
				end
			end
		end
	end

	return closestTarget
end

function aimAt(target)
	if not aimEnabled or not target or not target.Character then return end
	local head = target.Character:FindFirstChild("Head")
	if head then
		local targetPosition = head.Position
		local cameraLookAt = CFrame.new(camera.CFrame.Position, targetPosition)
		camera.CFrame = cameraLookAt:Lerp(camera.CFrame, lerpSpeed)
	end
end

-- Create UI and update when character respawns
local function setupUI()
	createUI()
end

player.CharacterAdded:Connect(setupUI)

if player.Character then
	setupUI()
end

runService.RenderStepped:Connect(function()
	local target = findClosestPlayer()
	aimAt(target)
	updateStatusDotColor(target)
end)
