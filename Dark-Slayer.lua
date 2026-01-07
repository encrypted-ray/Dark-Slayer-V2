--// Modern Hub – Full Script with Minimize

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--// STATE
local State = {
	AutoFarm = false,
	Teleport = false,
	CombatAssist = false,
	ESP = false
}

--// GUI ROOT
local Gui = Instance.new("ScreenGui")
Gui.Name = "ModernHub"
Gui.ResetOnSpawn = false
Gui.Parent = PlayerGui

--// MAIN FRAME
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.fromScale(0.45, 0.55)
Main.Position = UDim2.fromScale(0.275, 0.225)
Main.BackgroundColor3 = Color3.fromRGB(18,18,18)
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,16)
Main.ZIndex = 1

--// TITLE BAR
local TitleBar = Instance.new("Frame", Main)
TitleBar.Size = UDim2.fromScale(1, 0.08)
TitleBar.BackgroundColor3 = Color3.fromRGB(24,24,24)
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0,16)
TitleBar.ZIndex = 5

local Title = Instance.new("TextLabel", TitleBar)
Title.Size = UDim2.fromScale(0.7, 1)
Title.Position = UDim2.fromScale(0.03, 0)
Title.BackgroundTransparency = 1
Title.Text = "Modern Hub"
Title.Font = Enum.Font.GothamSemibold
Title.TextSize = 16
Title.TextXAlignment = Left
Title.TextColor3 = Color3.fromRGB(235,235,235)

--// CLOSE BUTTON
local Close = Instance.new("TextButton", TitleBar)
Close.Size = UDim2.fromScale(0.08, 0.6)
Close.Position = UDim2.fromScale(0.9, 0.2)
Close.Text = "✕"
Close.Font = Enum.Font.GothamBold
Close.TextSize = 18
Close.TextColor3 = Color3.fromRGB(255,255,255)
Close.BackgroundColor3 = Color3.fromRGB(160,60,60)
Close.AutoButtonColor = false
Instance.new("UICorner", Close).CornerRadius = UDim.new(1,0)
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
Minimize.BackgroundColor3 = Color3.fromRGB(70,70,70)
Minimize.AutoButtonColor = false
Instance.new("UICorner", Minimize).CornerRadius = UDim.new(1,0)

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
Sidebar.BackgroundColor3 = Color3.fromRGB(22,22,22)
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0,16)
Sidebar.ZIndex = 2

--// CONTENT
local Content = Instance.new("Frame", Main)
Content.Position = UDim2.fromScale(0.25, 0.08)
Content.Size = UDim2.fromScale(0.75, 0.92)
Content.BackgroundTransparency = 1
Content.ZIndex = 2

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

local function CreateTabButton(text, order, tabName)
	local btn = Instance.new("TextButton", Sidebar)
	btn.Size = UDim2.fromScale(0.9, 0.08)
	btn.Position = UDim2.fromScale(0.05, 0.05 + (order * 0.1))
	btn.Text = text
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.TextColor3 = Color3.fromRGB(230,230,230)
	btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)
	btn.MouseButton1Click:Connect(function()
		SwitchTab(tabName)
	end)
end

--// TOGGLES
local function CreateToggle(parent, text, posY, callback)
	local holder = Instance.new("Frame", parent)
	holder.Size = UDim2.fromScale(0.85,0.12)
	holder.Position = UDim2.fromScale(0.075, posY)
	holder.BackgroundColor3 = Color3.fromRGB(28,28,28)
	Instance.new("UICorner", holder).CornerRadius = UDim.new(0,10)

	local label = Instance.new("TextLabel", holder)
	label.Size = UDim2.fromScale(0.7,1)
	label.BackgroundTransparency = 1
	label.Text = text
	label.Font = Enum.Font.Gotham
	label.TextSize = 14
	label.TextColor3 = Color3.fromRGB(235,235,235)

	local toggle = Instance.new("TextButton", holder)
	toggle.Size = UDim2.fromScale(0.2,0.6)
	toggle.Position = UDim2.fromScale(0.75,0.2)
	toggle.Text = "OFF"
	toggle.Font = Enum.Font.GothamBold
	toggle.TextSize = 12
	toggle.BackgroundColor3 = Color3.fromRGB(50,50,50)
	Instance.new("UICorner", toggle).CornerRadius = UDim.new(1,0)

	toggle.MouseButton1Click:Connect(function()
		local state = callback()
		toggle.Text = state and "ON" or "OFF"
		toggle.BackgroundColor3 = state and Color3.fromRGB(90,180,90) or Color3.fromRGB(50,50,50)
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
	return State.ESP
end)

SwitchTab("Farm")

--// MAIN LOOP (CONCEPTUAL PLACEHOLDER)
RunService.Heartbeat:Connect(function()
	if State.AutoFarm then
		-- autofarm logic
	end
	if State.CombatAssist then
		-- aim assist logic
	end
	if State.ESP then
		-- esp logic
	end
end)
