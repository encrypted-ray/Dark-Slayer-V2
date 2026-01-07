--// Modern Hub – Full Script with Minimize

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Camera = Workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

--// STATE
local State = {
	AutoFarm = false,
	Teleport = false,
	CombatAssist = false,
	ESP = false
}

--// ESP STORAGE
local ESPObjects = {}
local ESPHighlights = {}
local ESPConnections = {}

--// GUI ROOT
local Gui = Instance.new("ScreenGui")
Gui.Name = "ModernHub"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.IgnoreGuiInset = true
Gui.Parent = PlayerGui

--// MAIN FRAME
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.fromScale(0.45, 0.55)
Main.Position = UDim2.fromScale(0.275, 0.225)
Main.BackgroundColor3 = Color3.fromRGB(15,15,15)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
local MainCorner = Instance.new("UICorner", Main)
MainCorner.CornerRadius = UDim.new(0,12)
Main.ZIndex = 1

-- Gradient effect
local UIGradient = Instance.new("UIGradient", Main)
UIGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(25,25,25)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(15,15,15))
})
UIGradient.Rotation = 45

--// TITLE BAR
local TitleBar = Instance.new("Frame", Main)
TitleBar.Size = UDim2.fromScale(1, 0.08)
TitleBar.BackgroundColor3 = Color3.fromRGB(20,20,20)
TitleBar.BorderSizePixel = 0
local TitleBarCorner = Instance.new("UICorner", TitleBar)
TitleBarCorner.CornerRadius = UDim.new(0,12)
TitleBar.ZIndex = 5

-- Title bar gradient
local TitleGradient = Instance.new("UIGradient", TitleBar)
TitleGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 0, 0)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 0, 0))
})
TitleGradient.Transparency = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 0.7),
	NumberSequenceKeypoint.new(1, 0.9)
})

local Title = Instance.new("TextLabel", TitleBar)
Title.Size = UDim2.fromScale(0.7, 1)
Title.Position = UDim2.fromScale(0.03, 0)
Title.BackgroundTransparency = 1
Title.Text = "Redz Hub"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.ZIndex = 10
Title.TextStrokeTransparency = 0.3
Title.TextStrokeColor3 = Color3.fromRGB(200,0,0)

--// CLOSE BUTTON
local Close = Instance.new("TextButton", TitleBar)
Close.Size = UDim2.fromScale(0.08, 0.6)
Close.Position = UDim2.fromScale(0.9, 0.2)
Close.Text = "✕"
Close.Font = Enum.Font.GothamBold
Close.TextSize = 18
Close.TextColor3 = Color3.fromRGB(255,255,255)
Close.BackgroundColor3 = Color3.fromRGB(200,0,0)
Close.BorderSizePixel = 0
Close.AutoButtonColor = false
Close.ZIndex = 10
Close.TextStrokeTransparency = 0.3
Close.TextStrokeColor3 = Color3.fromRGB(0,0,0)
Instance.new("UICorner", Close).CornerRadius = UDim.new(0,8)
Close.MouseEnter:Connect(function()
	Close.BackgroundColor3 = Color3.fromRGB(255,50,50)
end)
Close.MouseLeave:Connect(function()
	Close.BackgroundColor3 = Color3.fromRGB(200,0,0)
end)
Close.MouseButton1Click:Connect(function()
	Gui:Destroy()
end)

--// MINIMIZE BUTTON
local Minimize = Instance.new("TextButton", TitleBar)
Minimize.Size = UDim2.fromScale(0.08, 0.6)
Minimize.Position = UDim2.fromScale(0.82, 0.2)
Minimize.Text = "—"
Minimize.Font = Enum.Font.GothamBold
Minimize.TextSize = 20
Minimize.TextColor3 = Color3.fromRGB(255,255,255)
Minimize.BackgroundColor3 = Color3.fromRGB(40,40,40)
Minimize.BorderSizePixel = 0
Minimize.AutoButtonColor = false
Minimize.ZIndex = 10
Minimize.TextStrokeTransparency = 0.3
Minimize.TextStrokeColor3 = Color3.fromRGB(0,0,0)
Instance.new("UICorner", Minimize).CornerRadius = UDim.new(0,8)
Minimize.MouseEnter:Connect(function()
	Minimize.BackgroundColor3 = Color3.fromRGB(60,60,60)
end)
Minimize.MouseLeave:Connect(function()
	Minimize.BackgroundColor3 = Color3.fromRGB(40,40,40)
end)

local Minimized = false
local StoredSize = Main.Size
local StoredPosition = Main.Position

Minimize.MouseButton1Click:Connect(function()
	Minimized = not Minimized
	if Minimized then
		StoredSize = Main.Size
		StoredPosition = Main.Position

		Sidebar.Visible = false
		Content.Visible = false

		Main:TweenSize(UDim2.fromScale(0.45, 0.08),
			Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
		Minimize.Text = "+"
	else
		Sidebar.Visible = true
		Content.Visible = true
		Main:TweenSize(StoredSize, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
		Main.Position = StoredPosition
		Minimize.Text = "—"
	end
end)

--// DRAGGING
local dragging, dragStart, startPos
TitleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 and not Minimized then
		dragging = true
		dragStart = input.Position
		startPos = Main.Position
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		Main.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

--// SIDEBAR
local Sidebar = Instance.new("Frame", Main)
Sidebar.Position = UDim2.fromScale(0, 0.08)
Sidebar.Size = UDim2.fromScale(0.25, 0.92)
Sidebar.BackgroundColor3 = Color3.fromRGB(18,18,18)
Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0,12)
Sidebar.ZIndex = 3

--// CONTENT
local Content = Instance.new("Frame", Main)
Content.Position = UDim2.fromScale(0.25, 0.08)
Content.Size = UDim2.fromScale(0.75, 0.92)
Content.BackgroundTransparency = 1
Content.ZIndex = 3

--// TABS
local Tabs = {}
local CurrentTab
local function CreateTab(name)
	local tab = Instance.new("Frame", Content)
	tab.Size = UDim2.fromScale(1,1)
	tab.Visible = false
	tab.BackgroundTransparency = 1
	Tabs[name] = tab
	return tab
end

local function SwitchTab(name)
	if CurrentTab then CurrentTab.Visible = false end
	CurrentTab = Tabs[name]
	CurrentTab.Visible = true
end

local SelectedButton = nil
local function CreateTabButton(text, order, tabName)
	local btn = Instance.new("TextButton", Sidebar)
	btn.Size = UDim2.fromScale(0.9, 0.08)
	btn.Position = UDim2.fromScale(0.05, 0.05 + (order * 0.1))
	btn.Text = text
	btn.Font = Enum.Font.GothamSemibold
	btn.TextSize = 14
	btn.TextColor3 = Color3.fromRGB(200,200,200)
	btn.BackgroundColor3 = Color3.fromRGB(25,25,25)
	btn.BorderSizePixel = 0
	btn.AutoButtonColor = false
	btn.ZIndex = 5
	btn.TextStrokeTransparency = 0.5
	btn.TextStrokeColor3 = Color3.fromRGB(0,0,0)
	local btnCorner = Instance.new("UICorner", btn)
	btnCorner.CornerRadius = UDim.new(0,8)
	
	-- Hover effects
	btn.MouseEnter:Connect(function()
		if btn ~= SelectedButton then
			btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
		end
	end)
	btn.MouseLeave:Connect(function()
		if btn ~= SelectedButton then
			btn.BackgroundColor3 = Color3.fromRGB(25,25,25)
		end
	end)
	
	btn.MouseButton1Click:Connect(function()
		-- Update selected button
		if SelectedButton then
			SelectedButton.BackgroundColor3 = Color3.fromRGB(25,25,25)
			SelectedButton.TextColor3 = Color3.fromRGB(200,200,200)
		end
		SelectedButton = btn
		btn.BackgroundColor3 = Color3.fromRGB(200,0,0)
		btn.TextColor3 = Color3.fromRGB(255,255,255)
		SwitchTab(tabName)
	end)
	
	-- Set first button as selected
	if order == 0 then
		SelectedButton = btn
		btn.BackgroundColor3 = Color3.fromRGB(200,0,0)
		btn.TextColor3 = Color3.fromRGB(255,255,255)
	end
end

--// TOGGLES
local function CreateToggle(parent, text, posY, callback)
	local holder = Instance.new("Frame", parent)
	holder.Size = UDim2.fromScale(0.85,0.12)
	holder.Position = UDim2.fromScale(0.075, posY)
	holder.BackgroundColor3 = Color3.fromRGB(25,25,25)
	holder.BorderSizePixel = 0
	holder.ZIndex = 4
	local holderCorner = Instance.new("UICorner", holder)
	holderCorner.CornerRadius = UDim.new(0,8)

	local label = Instance.new("TextLabel", holder)
	label.Size = UDim2.fromScale(0.7,1)
	label.Position = UDim2.fromScale(0.05, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.Font = Enum.Font.GothamSemibold
	label.TextSize = 14
	label.TextColor3 = Color3.fromRGB(240,240,240)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.ZIndex = 6
	label.TextStrokeTransparency = 0.4
	label.TextStrokeColor3 = Color3.fromRGB(0,0,0)

	local toggle = Instance.new("TextButton", holder)
	toggle.Size = UDim2.fromScale(0.2,0.6)
	toggle.Position = UDim2.fromScale(0.75,0.2)
	toggle.Text = "OFF"
	toggle.Font = Enum.Font.GothamBold
	toggle.TextSize = 11
	toggle.TextColor3 = Color3.fromRGB(255,255,255)
	toggle.BackgroundColor3 = Color3.fromRGB(40,40,40)
	toggle.BorderSizePixel = 0
	toggle.AutoButtonColor = false
	toggle.ZIndex = 6
	toggle.TextStrokeTransparency = 0.3
	toggle.TextStrokeColor3 = Color3.fromRGB(0,0,0)
	local toggleCorner = Instance.new("UICorner", toggle)
	toggleCorner.CornerRadius = UDim.new(0,6)

	toggle.MouseButton1Click:Connect(function()
		local state = callback()
		toggle.Text = state and "ON" or "OFF"
		if state then
			toggle.BackgroundColor3 = Color3.fromRGB(0,200,0)
			toggle.TextColor3 = Color3.fromRGB(255,255,255)
		else
			toggle.BackgroundColor3 = Color3.fromRGB(40,40,40)
			toggle.TextColor3 = Color3.fromRGB(200,200,200)
		end
	end)
end

--// TAB SETUP
local FarmTab = CreateTab("Farm")
local TravelTab = CreateTab("Travel")
local CombatTab = CreateTab("Combat")
local VisualTab = CreateTab("Visual")

CreateTabButton("Farming", 0, "Farm")
CreateTabButton("Teleport", 1, "Travel")
CreateTabButton("Combat", 2, "Combat")
CreateTabButton("ESP", 3, "Visual")

--// TAB TOGGLES
CreateToggle(FarmTab, "Auto Farm Enemies", 0.1, function()
	State.AutoFarm = not State.AutoFarm
	return State.AutoFarm
end)

CreateToggle(TravelTab, "Island Teleport", 0.1, function()
	State.Teleport = not State.Teleport
	return State.Teleport
end)

CreateToggle(CombatTab, "Aim Assist", 0.1, function()
	State.CombatAssist = not State.CombatAssist
	return State.CombatAssist
end)

CreateToggle(VisualTab, "ESP Overlay", 0.1, function()
	State.ESP = not State.ESP
	if State.ESP then
		-- Create ESP for all existing players when enabled
		for _, player in pairs(Players:GetPlayers()) do
			if player ~= LocalPlayer and player.Character then
				wait(0.1)
				CreateESP(player)
			end
		end
	else
		-- Remove all ESP when disabled
		for player, _ in pairs(ESPObjects) do
			RemoveESP(player)
		end
	end
	return State.ESP
end)

SwitchTab("Farm")

--// UTILITY FUNCTIONS
local function GetClosestEnemy()
	local closest = nil
	local closestDistance = math.huge
	local playerPos = HumanoidRootPart.Position
	
	-- Check all characters/models in workspace
	for _, v in pairs(Workspace:GetDescendants()) do
		if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") then
			local humanoid = v.Humanoid
			local rootPart = v.HumanoidRootPart
			
			-- Exclude player's character and dead enemies
			if v ~= Character and humanoid.Health > 0 then
				-- Check if it's a player or NPC
				local isPlayer = Players:GetPlayerFromCharacter(v)
				if not isPlayer or isPlayer ~= LocalPlayer then
					local distance = (rootPart.Position - playerPos).Magnitude
					if distance < closestDistance and distance < 200 then
						closestDistance = distance
						closest = v
					end
				end
			end
		end
	end
	
	return closest
end

local function TeleportToPosition(position)
	if HumanoidRootPart then
		HumanoidRootPart.CFrame = CFrame.new(position)
	end
end

local function GetIslands()
	local islands = {}
	-- Search for islands in various common locations
	for _, v in pairs(Workspace:GetChildren()) do
		if v:IsA("BasePart") and (v.Name:find("Island") or v.Name:find("Spawn") or v.Name:find("Location") or v.Name:find("Teleport")) then
			table.insert(islands, v)
		elseif v:IsA("Model") then
			-- Check model names
			if v.Name:find("Island") or v.Name:find("Spawn") or v.Name:find("Location") then
				local rootPart = v:FindFirstChild("HumanoidRootPart") or v:FindFirstChild("PrimaryPart") or v:FindFirstChildOfClass("BasePart")
				if rootPart then
					table.insert(islands, rootPart)
				end
			end
		end
	end
	return islands
end

--// ESP FUNCTIONS
local function CreateESP(player)
	if not player or not player.Character then return end
	local character = player.Character
	if ESPObjects[player] then return end
	
	-- Create Highlight for visual outline
	local highlight = Instance.new("Highlight")
	highlight.Name = "ESP_Highlight"
	highlight.FillTransparency = 0.5
	highlight.FillColor = Color3.fromRGB(200, 0, 0)
	highlight.OutlineTransparency = 0
	highlight.OutlineColor = Color3.fromRGB(255, 50, 50)
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	highlight.Parent = character
	ESPHighlights[player] = highlight
	
	-- Create BillboardGui for name display
	local head = character:FindFirstChild("Head")
	if not head then return end
	
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "ESP_Name"
	billboard.Size = UDim2.new(0, 200, 0, 50)
	billboard.StudsOffset = Vector3.new(0, 3.5, 0)
	billboard.AlwaysOnTop = true
	billboard.MaxDistance = math.huge -- Show regardless of distance
	billboard.Adornee = head
	billboard.Parent = head
	
	-- Name label
	local nameLabel = Instance.new("TextLabel", billboard)
	nameLabel.Size = UDim2.new(1, 0, 0.6, 0)
	nameLabel.Position = UDim2.new(0, 0, 0, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = player.Name
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameLabel.TextSize = 16
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextStrokeTransparency = 0.3
	nameLabel.TextStrokeColor3 = Color3.fromRGB(200, 0, 0)
	
	-- Health label
	local healthLabel = Instance.new("TextLabel", billboard)
	healthLabel.Size = UDim2.new(1, 0, 0.4, 0)
	healthLabel.Position = UDim2.new(0, 0, 0.6, 0)
	healthLabel.BackgroundTransparency = 1
	healthLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
	healthLabel.TextSize = 12
	healthLabel.Font = Enum.Font.Gotham
	healthLabel.TextStrokeTransparency = 0.3
	healthLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	
	-- Update health display
	local humanoid = character:FindFirstChild("Humanoid")
	if humanoid then
		local function updateHealth()
			local health = math.floor(humanoid.Health)
			local maxHealth = math.floor(humanoid.MaxHealth)
			healthLabel.Text = "HP: " .. health .. "/" .. maxHealth
			
			-- Change color based on health percentage
			local healthPercent = humanoid.Health / humanoid.MaxHealth
			if healthPercent > 0.6 then
				healthLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
			elseif healthPercent > 0.3 then
				healthLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
			else
				healthLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
			end
		end
		
		updateHealth()
		local healthConnection = humanoid.HealthChanged:Connect(updateHealth)
		table.insert(ESPConnections, healthConnection)
	end
	
	ESPObjects[player] = billboard
end

local function RemoveESP(player)
	if ESPObjects[player] then
		ESPObjects[player]:Destroy()
		ESPObjects[player] = nil
	end
	if ESPHighlights[player] then
		ESPHighlights[player]:Destroy()
		ESPHighlights[player] = nil
	end
end

local function UpdateESP()
	if not State.ESP then 
		-- Clean up all ESP when disabled
		for player, _ in pairs(ESPObjects) do
			RemoveESP(player)
		end
		return 
	end
	
	-- Create ESP for all players
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			CreateESP(player)
		end
	end
	
	-- Clean up ESP for players who left
	for player, _ in pairs(ESPObjects) do
		if not player.Parent or not player.Character or not player.Character:FindFirstChild("Head") then
			RemoveESP(player)
		end
	end
end

-- Handle new players joining
Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		if State.ESP then
			wait(0.5) -- Wait for character to fully load
			CreateESP(player)
		end
	end)
end)

-- Handle character respawns
for _, player in pairs(Players:GetPlayers()) do
	if player ~= LocalPlayer then
		player.CharacterAdded:Connect(function(character)
			if State.ESP then
				wait(0.5)
				CreateESP(player)
			end
		end)
	end
end

-- Handle players leaving
Players.PlayerRemoving:Connect(function(player)
	RemoveESP(player)
end)

--// AIM ASSIST FUNCTION
local function AimAssist()
	if not State.CombatAssist or not Camera then return end
	
	local target = GetClosestEnemy()
	if target and target:FindFirstChild("HumanoidRootPart") then
		local targetPosition = target.HumanoidRootPart.Position
		local cameraPosition = Camera.CFrame.Position
		
		-- Smooth aim assist (not instant lock)
		local currentCFrame = Camera.CFrame
		local targetCFrame = CFrame.lookAt(cameraPosition, targetPosition)
		local newCFrame = currentCFrame:Lerp(targetCFrame, 0.3)
		
		Camera.CFrame = newCFrame
	end
end

--// AUTO FARM FUNCTION
local function AutoFarm()
	if not State.AutoFarm or not Character or not HumanoidRootPart or not Humanoid then return end
	
	local target = GetClosestEnemy()
	if target and target:FindFirstChild("HumanoidRootPart") then
		local targetPosition = target.HumanoidRootPart.Position
		local playerPosition = HumanoidRootPart.Position
		local distance = (targetPosition - playerPosition).Magnitude
		
		if distance > 5 then
			Humanoid:MoveTo(targetPosition)
		else
			-- Attack logic - try to find and use weapon/attack
			if Character:FindFirstChildOfClass("Tool") then
				local tool = Character:FindFirstChildOfClass("Tool")
				-- Try different attack methods
				if tool:FindFirstChild("Activate") then
					tool.Activate:Fire()
				elseif tool:FindFirstChild("RemoteEvent") then
					tool.RemoteEvent:FireServer("Attack")
				elseif tool:FindFirstChild("Click") then
					tool.Click:Fire()
				end
			end
			
			-- Face the target
			HumanoidRootPart.CFrame = CFrame.lookAt(playerPosition, targetPosition)
		end
	end
end

--// TELEPORT FUNCTION
local lastTeleportState = false
local function TeleportToIsland()
	if not State.Teleport or not HumanoidRootPart then 
		lastTeleportState = false
		return 
	end
	
	-- Only teleport once when toggled on
	if lastTeleportState == State.Teleport then return end
	lastTeleportState = true
	
	local islands = GetIslands()
	if #islands > 0 then
		local closestIsland = nil
		local closestDistance = math.huge
		local playerPos = HumanoidRootPart.Position
		
		for _, island in pairs(islands) do
			if island and island.Parent then
				local distance = (island.Position - playerPos).Magnitude
				if distance < closestDistance then
					closestDistance = distance
					closestIsland = island
				end
			end
		end
		
		if closestIsland then
			TeleportToPosition(closestIsland.Position + Vector3.new(0, 5, 0))
		end
	end
end

--// CHARACTER RESPAWN HANDLER
LocalPlayer.CharacterAdded:Connect(function(newCharacter)
	Character = newCharacter
	HumanoidRootPart = newCharacter:WaitForChild("HumanoidRootPart")
	Humanoid = newCharacter:WaitForChild("Humanoid")
end)

--// MAIN LOOP
RunService.Heartbeat:Connect(function()
	if State.AutoFarm then
		AutoFarm()
	end
	
	if State.CombatAssist then
		AimAssist()
	end
	
	-- Update ESP every frame
	UpdateESP()
	
	-- Teleport when enabled
	TeleportToIsland()
end)

--// CLEANUP ON SCRIPT REMOVAL
game:GetService("Players").PlayerRemoving:Connect(function(player)
	if player == LocalPlayer then
		for target, _ in pairs(ESPObjects) do
			RemoveESP(target)
		end
		for _, conn in pairs(ESPConnections) do
			conn:Disconnect()
		end
	end
end)
