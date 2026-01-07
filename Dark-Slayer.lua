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
Gui.Name = "KrakenHub"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.IgnoreGuiInset = true
Gui.Parent = PlayerGui

--// MAIN FRAME (redz Hub Style)
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.fromScale(0.5, 0.65)
Main.Position = UDim2.fromScale(0.25, 0.175)
Main.BackgroundColor3 = Color3.fromRGB(35,35,35)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
local MainCorner = Instance.new("UICorner", Main)
MainCorner.CornerRadius = UDim.new(0,8)
Main.ZIndex = 1

--// TITLE BAR (redz Hub Style)
local TitleBar = Instance.new("Frame", Main)
TitleBar.Size = UDim2.fromScale(1, 0.06)
TitleBar.BackgroundColor3 = Color3.fromRGB(40,40,40)
TitleBar.BorderSizePixel = 0
local TitleBarCorner = Instance.new("UICorner", TitleBar)
TitleBarCorner.CornerRadius = UDim.new(0,8)
TitleBar.ZIndex = 5

local Title = Instance.new("TextLabel", TitleBar)
Title.Size = UDim2.fromScale(0.6, 1)
Title.Position = UDim2.fromScale(0.02, 0)
Title.BackgroundTransparency = 1
Title.Text = "Kraken-Hub"
Title.Font = Enum.Font.Gotham
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.ZIndex = 10

--// WINDOW CONTROLS (redz Hub Style)
local MinimizeBtn = Instance.new("TextButton", TitleBar)
MinimizeBtn.Size = UDim2.fromScale(0.04, 0.7)
MinimizeBtn.Position = UDim2.fromScale(0.92, 0.15)
MinimizeBtn.Text = "—"
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 16
MinimizeBtn.TextColor3 = Color3.fromRGB(255,255,255)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.AutoButtonColor = false
MinimizeBtn.ZIndex = 10
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0,4)

local MaximizeBtn = Instance.new("TextButton", TitleBar)
MaximizeBtn.Size = UDim2.fromScale(0.04, 0.7)
MaximizeBtn.Position = UDim2.fromScale(0.94, 0.15)
MaximizeBtn.Text = "□"
MaximizeBtn.Font = Enum.Font.GothamBold
MaximizeBtn.TextSize = 14
MaximizeBtn.TextColor3 = Color3.fromRGB(255,255,255)
MaximizeBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
MaximizeBtn.BorderSizePixel = 0
MaximizeBtn.AutoButtonColor = false
MaximizeBtn.ZIndex = 10
Instance.new("UICorner", MaximizeBtn).CornerRadius = UDim.new(0,4)

local Close = Instance.new("TextButton", TitleBar)
Close.Size = UDim2.fromScale(0.04, 0.7)
Close.Position = UDim2.fromScale(0.96, 0.15)
Close.Text = "✕"
Close.Font = Enum.Font.GothamBold
Close.TextSize = 16
Close.TextColor3 = Color3.fromRGB(255,255,255)
Close.BackgroundColor3 = Color3.fromRGB(200,50,50)
Close.BorderSizePixel = 0
Close.AutoButtonColor = false
Close.ZIndex = 10
Instance.new("UICorner", Close).CornerRadius = UDim.new(0,4)

Close.MouseEnter:Connect(function()
	Close.BackgroundColor3 = Color3.fromRGB(255,80,80)
end)
Close.MouseLeave:Connect(function()
	Close.BackgroundColor3 = Color3.fromRGB(200,50,50)
end)
Close.MouseButton1Click:Connect(function()
	Gui:Destroy()
end)

MinimizeBtn.MouseEnter:Connect(function()
	MinimizeBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
end)
MinimizeBtn.MouseLeave:Connect(function()
	MinimizeBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
end)

MaximizeBtn.MouseEnter:Connect(function()
	MaximizeBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
end)
MaximizeBtn.MouseLeave:Connect(function()
	MaximizeBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
end)

--// MINIMIZE BUTTON (Material Design Icon Button)
local Minimize = Instance.new("TextButton", TitleBar)
Minimize.Size = UDim2.fromScale(0.08, 0.6)
Minimize.Position = UDim2.fromScale(0.82, 0.2)
Minimize.Text = "—"
Minimize.Font = Enum.Font.Gotham
Minimize.TextSize = 20
Minimize.TextColor3 = Color3.fromRGB(255,255,255)
Minimize.BackgroundColor3 = Color3.fromRGB(0,0,0)
Minimize.BackgroundTransparency = 1
Minimize.BorderSizePixel = 0
Minimize.AutoButtonColor = false
Minimize.ZIndex = 10
local MinimizeCorner = Instance.new("UICorner", Minimize)
MinimizeCorner.CornerRadius = UDim.new(0,20)

-- Ripple effect
local MinimizeRipple = Instance.new("Frame", Minimize)
MinimizeRipple.Size = UDim2.fromScale(1,1)
MinimizeRipple.BackgroundColor3 = Color3.fromRGB(255,255,255)
MinimizeRipple.BackgroundTransparency = 0.9
MinimizeRipple.BorderSizePixel = 0
MinimizeRipple.ZIndex = 11
MinimizeRipple.Visible = false
Instance.new("UICorner", MinimizeRipple).CornerRadius = UDim.new(0,20)

Minimize.MouseEnter:Connect(function()
	Minimize.BackgroundTransparency = 0.8
end)
Minimize.MouseLeave:Connect(function()
	Minimize.BackgroundTransparency = 1
end)

local Minimized = false
local StoredSize = Main.Size
local StoredPosition = Main.Position

Minimize.MouseButton1Click:Connect(function()
	-- Ripple animation
	MinimizeRipple.Visible = true
	MinimizeRipple.Size = UDim2.fromScale(0,0)
	MinimizeRipple.Position = UDim2.fromScale(0.5,0.5)
	MinimizeRipple.AnchorPoint = Vector2.new(0.5,0.5)
	TweenService:Create(MinimizeRipple, TweenInfo.new(0.3), {Size = UDim2.fromScale(2,2), BackgroundTransparency = 1}):Play()
	wait(0.3)
	MinimizeRipple.Visible = false
	
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

--// SIDEBAR (redz Hub Style - Left Panel)
local Sidebar = Instance.new("Frame", Main)
Sidebar.Position = UDim2.fromScale(0, 0.06)
Sidebar.Size = UDim2.fromScale(0.25, 0.94)
Sidebar.BackgroundColor3 = Color3.fromRGB(30,30,30)
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 3

--// CONTENT (redz Hub Style - Right Panel)
local Content = Instance.new("ScrollingFrame", Main)
Content.Position = UDim2.fromScale(0.25, 0.06)
Content.Size = UDim2.fromScale(0.75, 0.94)
Content.BackgroundColor3 = Color3.fromRGB(35,35,35)
Content.BorderSizePixel = 0
Content.ZIndex = 3
Content.CanvasSize = UDim2.new(0, 0, 0, 0)
Content.ScrollBarThickness = 6
Content.ScrollBarImageColor3 = Color3.fromRGB(100,150,255)
Content.BorderSizePixel = 0

local ContentLayout = Instance.new("UIListLayout", Content)
ContentLayout.Padding = UDim.new(0, 10)
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder

--// TABS
local Tabs = {}
local CurrentTab
local function CreateTab(name)
	local tab = Instance.new("Frame", Content)
	tab.Size = UDim2.fromScale(1,0)
	tab.Visible = false
	tab.BackgroundTransparency = 1
	tab.LayoutOrder = 0
	Tabs[name] = tab
	return tab
end

local function SwitchTab(name)
	if CurrentTab then CurrentTab.Visible = false end
	CurrentTab = Tabs[name]
	CurrentTab.Visible = true
	CurrentTab.Size = UDim2.fromScale(1,0)
	
	-- Update content canvas size
	local totalHeight = 0
	for _, child in pairs(CurrentTab:GetChildren()) do
		if child:IsA("Frame") and child.LayoutOrder then
			totalHeight = totalHeight + child.Size.Y.Scale + 0.02
		end
	end
	Content.CanvasSize = UDim2.new(0, 0, 0, totalHeight * 1000)
end

local SelectedButton = nil
local function CreateTabButton(text, order, tabName)
	local btn = Instance.new("TextButton", Sidebar)
	btn.Size = UDim2.fromScale(0.95, 0.045)
	btn.Position = UDim2.fromScale(0.025, 0.02 + (order * 0.05))
	btn.Text = text
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 13
	btn.TextColor3 = Color3.fromRGB(200,200,200)
	btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
	btn.BackgroundTransparency = 1
	btn.BorderSizePixel = 0
	btn.AutoButtonColor = false
	btn.ZIndex = 5
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.Padding = UDim.new(0, 10)
	
	-- Hover effects
	btn.MouseEnter:Connect(function()
		if btn ~= SelectedButton then
			btn.BackgroundTransparency = 0.9
			btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
		end
	end)
	btn.MouseLeave:Connect(function()
		if btn ~= SelectedButton then
			btn.BackgroundTransparency = 1
		end
	end)
	
	btn.MouseButton1Click:Connect(function()
		-- Update selected button
		if SelectedButton then
			SelectedButton.BackgroundTransparency = 1
			SelectedButton.TextColor3 = Color3.fromRGB(200,200,200)
		end
		SelectedButton = btn
		btn.BackgroundTransparency = 0
		btn.BackgroundColor3 = Color3.fromRGB(100,150,255)
		btn.TextColor3 = Color3.fromRGB(255,255,255)
		SwitchTab(tabName)
	end)
	
	-- Set first button (SERVER) as selected
	if order == 0 then
		SelectedButton = btn
		btn.BackgroundTransparency = 0
		btn.BackgroundColor3 = Color3.fromRGB(100,150,255)
		btn.TextColor3 = Color3.fromRGB(255,255,255)
	end
end

--// SECTION HEADER
local function CreateSection(parent, title, layoutOrder)
	local section = Instance.new("Frame", parent)
	section.Size = UDim2.fromScale(0.95, 0)
	section.Position = UDim2.fromScale(0.025, 0)
	section.BackgroundTransparency = 1
	section.LayoutOrder = layoutOrder
	
	local sectionTitle = Instance.new("TextLabel", section)
	sectionTitle.Size = UDim2.fromScale(1, 0.06)
	sectionTitle.Position = UDim2.fromScale(0, 0)
	sectionTitle.BackgroundTransparency = 1
	sectionTitle.Text = title
	sectionTitle.Font = Enum.Font.GothamBold
	sectionTitle.TextSize = 15
	sectionTitle.TextColor3 = Color3.fromRGB(255,255,255)
	sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
	sectionTitle.ZIndex = 4
	
	return section
end

--// TOGGLES (redz Hub Style)
local function CreateToggle(parent, text, description, layoutOrder, callback)
	local holder = Instance.new("Frame", parent)
	holder.Size = UDim2.fromScale(0.95, 0)
	holder.Position = UDim2.fromScale(0.025, 0)
	holder.BackgroundTransparency = 1
	holder.LayoutOrder = layoutOrder
	holder.ZIndex = 4

	local labelContainer = Instance.new("Frame", holder)
	labelContainer.Size = UDim2.fromScale(0.85, 1)
	labelContainer.Position = UDim2.fromScale(0, 0)
	labelContainer.BackgroundTransparency = 1
	
	local label = Instance.new("TextLabel", labelContainer)
	label.Size = UDim2.fromScale(1, 0.5)
	label.Position = UDim2.fromScale(0, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.Font = Enum.Font.Gotham
	label.TextSize = 14
	label.TextColor3 = Color3.fromRGB(255,255,255)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.ZIndex = 6
	
	local desc = Instance.new("TextLabel", labelContainer)
	desc.Size = UDim2.fromScale(1, 0.5)
	desc.Position = UDim2.fromScale(0, 0.5)
	desc.BackgroundTransparency = 1
	desc.Text = description
	desc.Font = Enum.Font.Gotham
	desc.TextSize = 12
	desc.TextColor3 = Color3.fromRGB(180,180,180)
	desc.TextXAlignment = Enum.TextXAlignment.Left
	desc.TextWrapped = true
	desc.ZIndex = 6

	-- Blue Switch (redz Hub Style)
	local switchTrack = Instance.new("Frame", holder)
	switchTrack.Size = UDim2.fromScale(0.08, 0.04)
	switchTrack.Position = UDim2.fromScale(0.9, 0.48)
	switchTrack.BackgroundColor3 = Color3.fromRGB(117,117,117)
	switchTrack.BorderSizePixel = 0
	switchTrack.ZIndex = 6
	local switchTrackCorner = Instance.new("UICorner", switchTrack)
	switchTrackCorner.CornerRadius = UDim.new(0,10)
	
	local switchThumb = Instance.new("Frame", switchTrack)
	switchThumb.Size = UDim2.fromScale(0.45, 1.2)
	switchThumb.Position = UDim2.fromScale(0.05, -0.1)
	switchThumb.BackgroundColor3 = Color3.fromRGB(250,250,250)
	switchThumb.BorderSizePixel = 0
	switchThumb.ZIndex = 7
	local switchThumbCorner = Instance.new("UICorner", switchThumb)
	switchThumbCorner.CornerRadius = UDim.new(0,10)
	
	local switchButton = Instance.new("TextButton", holder)
	switchButton.Size = UDim2.fromScale(0.08, 0.04)
	switchButton.Position = UDim2.fromScale(0.9, 0.48)
	switchButton.BackgroundTransparency = 1
	switchButton.Text = ""
	switchButton.ZIndex = 8
	switchButton.AutoButtonColor = false

	local isOn = false
	switchButton.MouseButton1Click:Connect(function()
		isOn = not isOn
		local state = callback()
		isOn = state
		
		if isOn then
			TweenService:Create(switchTrack, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100,150,255)}):Play()
			TweenService:Create(switchThumb, TweenInfo.new(0.2), {Position = UDim2.fromScale(0.5, -0.1), BackgroundColor3 = Color3.fromRGB(255,255,255)}):Play()
		else
			TweenService:Create(switchTrack, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(117,117,117)}):Play()
			TweenService:Create(switchThumb, TweenInfo.new(0.2), {Position = UDim2.fromScale(0.05, -0.1), BackgroundColor3 = Color3.fromRGB(250,250,250)}):Play()
		end
	end)
	
	-- Auto-size holder based on description
	holder.Size = UDim2.new(0.95, 0, 0, math.max(50, desc.TextBounds.Y + 30))
	labelContainer.Size = UDim2.new(0.85, 0, 1, 0)
	
	return holder
end

--// TAB SETUP
local ServerTab = CreateTab("Server")
local FarmTab = CreateTab("Farm")
local CombatTab = CreateTab("Combat")
local SeaEventsTab = CreateTab("SeaEvents")
local TravelTab = CreateTab("Travel")
local VisualTab = CreateTab("Visual")
local MiscTab = CreateTab("Misc")

CreateTabButton("SERVER", 0, "Server")
CreateTabButton("FARMING", 1, "Farm")
CreateTabButton("COMBAT", 2, "Combat")
CreateTabButton("SEA EVENTS", 3, "SeaEvents")
CreateTabButton("TELEPORT", 4, "Travel")
CreateTabButton("ESP", 5, "Visual")
CreateTabButton("MISC", 6, "Misc")

--// TAB CONTENT (redz Hub Style)
-- Farm Tab
local FarmSection = CreateSection(FarmTab, "Farm", 1)
CreateToggle(FarmSection, "Auto Farm Enemies", "Automatically farms enemies for you.", 1, function()
	State.AutoFarm = not State.AutoFarm
	return State.AutoFarm
end)

-- Travel Tab
local TravelSection = CreateSection(TravelTab, "Teleport", 1)
CreateToggle(TravelSection, "Island Teleport", "Teleports to the closest island automatically.", 1, function()
	State.Teleport = not State.Teleport
	return State.Teleport
end)

-- Combat Tab
local CombatSection = CreateSection(CombatTab, "Combat", 1)
CreateToggle(CombatSection, "Aim Assist", "Helps you aim at enemies automatically.", 1, function()
	State.CombatAssist = not State.CombatAssist
	return State.CombatAssist
end)

-- Visual Tab
local VisualSection = CreateSection(VisualTab, "Visual", 1)
CreateToggle(VisualSection, "ESP Overlay", "Shows player names and highlights above their heads.", 1, function()
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

-- Sea Events Tab (placeholder for future features)
-- Add toggles/features here as needed

-- Misc Tab (placeholder for future features)
-- Add toggles/features here as needed

--// SERVER TAB UI
local SelectedPlayer = nil
local DropdownOpen = false

-- Dropdown container (right-aligned)
local DropdownContainer = Instance.new("Frame", ServerTab)
DropdownContainer.Size = UDim2.fromScale(0.4, 0.08)
DropdownContainer.Position = UDim2.fromScale(0.55, 0.05)
DropdownContainer.BackgroundColor3 = Color3.fromRGB(25,25,25)
DropdownContainer.BorderSizePixel = 0
DropdownContainer.ZIndex = 4
Instance.new("UICorner", DropdownContainer).CornerRadius = UDim.new(0,8)

local DropdownLabel = Instance.new("TextLabel", DropdownContainer)
DropdownLabel.Size = UDim2.fromScale(0.3, 1)
DropdownLabel.Position = UDim2.fromScale(0.02, 0)
DropdownLabel.BackgroundTransparency = 1
DropdownLabel.Text = "Player:"
DropdownLabel.Font = Enum.Font.GothamSemibold
DropdownLabel.TextSize = 14
DropdownLabel.TextColor3 = Color3.fromRGB(240,240,240)
DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
DropdownLabel.ZIndex = 5
DropdownLabel.TextStrokeTransparency = 0.4
DropdownLabel.TextStrokeColor3 = Color3.fromRGB(0,0,0)

local DropdownButton = Instance.new("TextButton", DropdownContainer)
DropdownButton.Size = UDim2.fromScale(0.65, 0.8)
DropdownButton.Position = UDim2.fromScale(0.33, 0.1)
DropdownButton.Text = "Select Player..."
DropdownButton.Font = Enum.Font.Gotham
DropdownButton.TextSize = 13
DropdownButton.TextColor3 = Color3.fromRGB(255,255,255)
DropdownButton.BackgroundColor3 = Color3.fromRGB(0,0,0)
DropdownButton.BackgroundTransparency = 1
DropdownButton.BorderSizePixel = 0
DropdownButton.AutoButtonColor = false
DropdownButton.ZIndex = 5
local DropdownButtonCorner = Instance.new("UICorner", DropdownButton)
DropdownButtonCorner.CornerRadius = UDim.new(0,8)

-- Dropdown list (hidden by default)
local DropdownList = Instance.new("ScrollingFrame", ServerSection)
DropdownList.Size = UDim2.fromScale(0.4, 0.3)
DropdownList.Position = UDim2.fromScale(0.55, 0.14)
DropdownList.BackgroundColor3 = Color3.fromRGB(45,45,45)
DropdownList.BorderSizePixel = 0
DropdownList.Visible = false
DropdownList.ZIndex = 6
DropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
DropdownList.ScrollBarThickness = 4
DropdownList.ScrollBarImageColor3 = Color3.fromRGB(100,150,255)
local DropdownListCorner = Instance.new("UICorner", DropdownList)
DropdownListCorner.CornerRadius = UDim.new(0,8)

local DropdownListLayout = Instance.new("UIListLayout", DropdownList)
DropdownListLayout.Padding = UDim.new(0, 2)
DropdownListLayout.SortOrder = Enum.SortOrder.Name

-- Player info output
local InfoContainer = Instance.new("ScrollingFrame", ServerSection)
InfoContainer.Size = UDim2.fromScale(0.9, 0.75)
InfoContainer.Position = UDim2.fromScale(0.05, 0.2)
InfoContainer.BackgroundColor3 = Color3.fromRGB(45,45,45)
InfoContainer.BorderSizePixel = 0
InfoContainer.ZIndex = 4
InfoContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
InfoContainer.ScrollBarThickness = 4
InfoContainer.ScrollBarImageColor3 = Color3.fromRGB(100,150,255)
local InfoContainerCorner = Instance.new("UICorner", InfoContainer)
InfoContainerCorner.CornerRadius = UDim.new(0,8)

local InfoLayout = Instance.new("UIListLayout", InfoContainer)
InfoLayout.Padding = UDim.new(0, 5)
InfoLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function UpdateDropdown()
	local players = Players:GetPlayers()
	table.sort(players, function(a, b) return a.Name < b.Name end)
	
	-- Clear existing buttons
	for _, child in pairs(DropdownList:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end
	
	-- Create buttons for each player
	for i, player in pairs(players) do
		local playerBtn = Instance.new("TextButton", DropdownList)
		playerBtn.Size = UDim2.new(1, -10, 0, 30)
		playerBtn.Position = UDim2.new(0, 5, 0, (i-1) * 32)
		playerBtn.Text = player.Name
		playerBtn.Font = Enum.Font.Gotham
		playerBtn.TextSize = 13
		playerBtn.TextColor3 = Color3.fromRGB(255,255,255)
		playerBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
		playerBtn.BackgroundTransparency = 1
		playerBtn.BorderSizePixel = 0
		playerBtn.AutoButtonColor = false
		playerBtn.ZIndex = 7
		local PlayerBtnCorner = Instance.new("UICorner", playerBtn)
		PlayerBtnCorner.CornerRadius = UDim.new(0,8)
		
		-- Ripple effect
		local playerRipple = Instance.new("Frame", playerBtn)
		playerRipple.Size = UDim2.fromScale(1,1)
		playerRipple.BackgroundColor3 = Color3.fromRGB(255,255,255)
		playerRipple.BackgroundTransparency = 0.9
		playerRipple.BorderSizePixel = 0
		playerRipple.ZIndex = 8
		playerRipple.Visible = false
		Instance.new("UICorner", playerRipple).CornerRadius = UDim.new(0,8)
		
		playerBtn.MouseEnter:Connect(function()
			playerBtn.BackgroundTransparency = 0.9
		end)
		playerBtn.MouseLeave:Connect(function()
			playerBtn.BackgroundTransparency = 1
		end)
		
		playerBtn.MouseButton1Click:Connect(function()
			-- Ripple animation
			playerRipple.Visible = true
			playerRipple.Size = UDim2.fromScale(0,0)
			playerRipple.Position = UDim2.fromScale(0.5,0.5)
			playerRipple.AnchorPoint = Vector2.new(0.5,0.5)
			TweenService:Create(playerRipple, TweenInfo.new(0.4), {Size = UDim2.fromScale(1,1), BackgroundTransparency = 1}):Play()
			wait(0.4)
			playerRipple.Visible = false
		
		playerBtn.MouseButton1Click:Connect(function()
			SelectedPlayer = player
			DropdownButton.Text = player.Name
			DropdownList.Visible = false
			DropdownOpen = false
			UpdatePlayerInfo(player)
		end)
	end
	
	DropdownList.CanvasSize = UDim2.new(0, 0, 0, #players * 32)
end

local function CreateInfoLabel(parent, text, value, layoutOrder)
	local holder = Instance.new("Frame", parent)
	holder.Size = UDim2.new(1, -20, 0, 30)
	holder.BackgroundTransparency = 1
	holder.LayoutOrder = layoutOrder
	
	local label = Instance.new("TextLabel", holder)
	label.Size = UDim2.fromScale(0.4, 1)
	label.Position = UDim2.fromScale(0, 0)
	label.BackgroundTransparency = 1
	label.Text = text .. ":"
	label.Font = Enum.Font.GothamSemibold
	label.TextSize = 13
	label.TextColor3 = Color3.fromRGB(200,200,200)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextStrokeTransparency = 0.4
	label.TextStrokeColor3 = Color3.fromRGB(0,0,0)
	
	local valueLabel = Instance.new("TextLabel", holder)
	valueLabel.Size = UDim2.fromScale(0.6, 1)
	valueLabel.Position = UDim2.fromScale(0.4, 0)
	valueLabel.BackgroundTransparency = 1
	valueLabel.Text = tostring(value)
	valueLabel.Font = Enum.Font.Gotham
	valueLabel.TextSize = 13
	valueLabel.TextColor3 = Color3.fromRGB(255,255,255)
	valueLabel.TextXAlignment = Enum.TextXAlignment.Left
	valueLabel.TextStrokeTransparency = 0.4
	valueLabel.TextStrokeColor3 = Color3.fromRGB(0,0,0)
	
	return holder, valueLabel
end

local InfoLabels = {}
function UpdatePlayerInfo(player)
	-- Clear existing info
	for _, label in pairs(InfoLabels) do
		label:Destroy()
	end
	InfoLabels = {}
	
	if not player then return end
	
	local layoutOrder = 1
	
	-- Player Name
	local nameHolder, nameValue = CreateInfoLabel(InfoContainer, "Player Name", player.Name, layoutOrder)
	table.insert(InfoLabels, nameHolder)
	layoutOrder = layoutOrder + 1
	
	-- User ID
	local idHolder, idValue = CreateInfoLabel(InfoContainer, "User ID", player.UserId, layoutOrder)
	table.insert(InfoLabels, idHolder)
	layoutOrder = layoutOrder + 1
	
	-- Account Age
	local accountAge = math.floor(player.AccountAge / 365)
	local ageHolder, ageValue = CreateInfoLabel(InfoContainer, "Account Age", accountAge .. " years", layoutOrder)
	table.insert(InfoLabels, ageHolder)
	layoutOrder = layoutOrder + 1
	
	-- Display Name
	local displayHolder, displayValue = CreateInfoLabel(InfoContainer, "Display Name", player.DisplayName, layoutOrder)
	table.insert(InfoLabels, displayHolder)
	layoutOrder = layoutOrder + 1
	
	-- Character Info
	if player.Character then
		local character = player.Character
		
		-- Health
		local humanoid = character:FindFirstChild("Humanoid")
		if humanoid then
			local healthHolder, healthValue = CreateInfoLabel(InfoContainer, "Health", math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth), layoutOrder)
			table.insert(InfoLabels, healthHolder)
			layoutOrder = layoutOrder + 1
			
			-- Update health in real-time
			humanoid.HealthChanged:Connect(function(health)
				healthValue.Text = math.floor(health) .. "/" .. math.floor(humanoid.MaxHealth)
			end)
		end
		
		-- Position
		local rootPart = character:FindFirstChild("HumanoidRootPart")
		if rootPart then
			local pos = rootPart.Position
			local posText = string.format("X: %.1f, Y: %.1f, Z: %.1f", pos.X, pos.Y, pos.Z)
			local posHolder, posValue = CreateInfoLabel(InfoContainer, "Position", posText, layoutOrder)
			table.insert(InfoLabels, posHolder)
			layoutOrder = layoutOrder + 1
			
			-- Update position in real-time
			RunService.Heartbeat:Connect(function()
				if rootPart and rootPart.Parent then
					local currentPos = rootPart.Position
					posValue.Text = string.format("X: %.1f, Y: %.1f, Z: %.1f", currentPos.X, currentPos.Y, currentPos.Z)
				end
			end)
		end
		
		-- Tools/Weapons
		local tools = {}
		for _, tool in pairs(character:GetChildren()) do
			if tool:IsA("Tool") then
				table.insert(tools, tool.Name)
			end
		end
		local toolsText = #tools > 0 and table.concat(tools, ", ") or "None"
		local toolsHolder, toolsValue = CreateInfoLabel(InfoContainer, "Tools", toolsText, layoutOrder)
		table.insert(InfoLabels, toolsHolder)
		layoutOrder = layoutOrder + 1
	else
		local noCharHolder, noCharValue = CreateInfoLabel(InfoContainer, "Character", "Not loaded", layoutOrder)
		table.insert(InfoLabels, noCharHolder)
		layoutOrder = layoutOrder + 1
	end
	
	-- Update canvas size
	InfoContainer.CanvasSize = UDim2.new(0, 0, 0, layoutOrder * 35)
end

-- Dropdown button functionality
DropdownButton.MouseEnter:Connect(function()
	DropdownButton.BackgroundTransparency = 0.9
end)
DropdownButton.MouseLeave:Connect(function()
	DropdownButton.BackgroundTransparency = 1
end)

DropdownButton.MouseButton1Click:Connect(function()
	DropdownOpen = not DropdownOpen
	DropdownList.Visible = DropdownOpen
	if DropdownOpen then
		UpdateDropdown()
	end
end)

-- Update dropdown when players join/leave
Players.PlayerAdded:Connect(function()
	if DropdownOpen then
		UpdateDropdown()
	end
end)

Players.PlayerRemoving:Connect(function(player)
	if SelectedPlayer == player then
		SelectedPlayer = nil
		DropdownButton.Text = "Select Player..."
		-- Clear info
		for _, label in pairs(InfoLabels) do
			label:Destroy()
		end
		InfoLabels = {}
	end
	if DropdownOpen then
		UpdateDropdown()
	end
end)

SwitchTab("Server")

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
	
	-- Create Highlight for visual outline (green/purple theme)
	local highlight = Instance.new("Highlight")
	highlight.Name = "ESP_Highlight"
	highlight.FillTransparency = 0.6
	highlight.FillColor = Color3.fromRGB(50, 200, 100)
	highlight.OutlineTransparency = 0
	highlight.OutlineColor = Color3.fromRGB(150, 50, 200)
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	highlight.Parent = character
	ESPHighlights[player] = highlight
	
	-- Create BillboardGui for name display
	local head = character:FindFirstChild("Head")
	if not head then return end
	
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "ESP_Name"
	billboard.Size = UDim2.new(0, 200, 0, 30)
	billboard.StudsOffset = Vector3.new(0, 3.5, 0)
	billboard.AlwaysOnTop = true
	billboard.MaxDistance = math.huge -- Show regardless of distance
	billboard.Adornee = head
	billboard.Parent = head
	
	-- Name label
	local nameLabel = Instance.new("TextLabel", billboard)
	nameLabel.Size = UDim2.new(1, 0, 1, 0)
	nameLabel.Position = UDim2.new(0, 0, 0, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = player.Name
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameLabel.TextSize = 16
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextStrokeTransparency = 0.3
	nameLabel.TextStrokeColor3 = Color3.fromRGB(150, 50, 200)
	
	-- Name gradient effect
	local nameGradient = Instance.new("UIGradient", nameLabel)
	nameGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 255, 150)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 100, 255))
	})
	
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
