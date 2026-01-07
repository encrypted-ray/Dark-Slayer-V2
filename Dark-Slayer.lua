--// Modern Hub Skeleton (Conceptual)
--// Clean UI, tabs, modular systems

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--// States
local State = {
	AutoFarm = false,
	Teleport = false,
	Fly = false,
	CombatAssist = false,
	ESP = false
}

--// GUI Root
local Gui = Instance.new("ScreenGui", PlayerGui)
Gui.Name = "ModernHub"
Gui.ResetOnSpawn = false

--// Main Frame
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.fromScale(0.45, 0.55)
Main.Position = UDim2.fromScale(0.275, 0.225)
Main.BackgroundColor3 = Color3.fromRGB(18,18,18)
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,16)

--// Sidebar
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.fromScale(0.25,1)
Sidebar.BackgroundColor3 = Color3.fromRGB(22,22,22)
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0,16)

--// Content Area
local Content = Instance.new("Frame", Main)
Content.Position = UDim2.fromScale(0.25,0)
Content.Size = UDim2.fromScale(0.75,1)
Content.BackgroundTransparency = 1

--// Tabs
local Tabs = {}
local CurrentTab

local function CreateTab(name)
	local TabFrame = Instance.new("Frame", Content)
	TabFrame.Size = UDim2.fromScale(1,1)
	TabFrame.Visible = false
	TabFrame.BackgroundTransparency = 1

	Tabs[name] = TabFrame
	return TabFrame
end

local function SwitchTab(name)
	if CurrentTab then
		CurrentTab.Visible = false
	end
	CurrentTab = Tabs[name]
	CurrentTab.Visible = true
end

--// Sidebar Button
local function CreateTabButton(text, order, tabName)
	local btn = Instance.new("TextButton", Sidebar)
	btn.Size = UDim2.fromScale(0.9,0.08)
	btn.Position = UDim2.fromScale(0.05,0.05 + (order * 0.1))
	btn.Text = text
	btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
	btn.TextColor3 = Color3.fromRGB(220,220,220)
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)

	btn.MouseButton1Click:Connect(function()
		SwitchTab(tabName)
	end)
end

--// Toggle Component
local function CreateToggle(parent, text, posY, callback)
	local holder = Instance.new("Frame", parent)
	holder.Size = UDim2.fromScale(0.85,0.1)
	holder.Position = UDim2.fromScale(0.075,posY)
	holder.BackgroundColor3 = Color3.fromRGB(28,28,28)
	Instance.new("UICorner", holder).CornerRadius = UDim.new(0,10)

	local label = Instance.new("TextLabel", holder)
	label.Text = text
	label.Size = UDim2.fromScale(0.7,1)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(230,230,230)

	local toggle = Instance.new("TextButton", holder)
	toggle.Size = UDim2.fromScale(0.2,0.6)
	toggle.Position = UDim2.fromScale(0.75,0.2)
	toggle.Text = "OFF"
	toggle.BackgroundColor3 = Color3.fromRGB(50,50,50)
	Instance.new("UICorner", toggle).CornerRadius = UDim.new(1,0)

	toggle.MouseButton1Click:Connect(function()
		local state = callback()
		toggle.Text = state and "ON" or "OFF"
		toggle.BackgroundColor3 = state and Color3.fromRGB(90,180,90) or Color3.fromRGB(50,50,50)
	end)
end

--// Tabs Setup
local FarmTab = CreateTab("Farm")
local TravelTab = CreateTab("Travel")
local CombatTab = CreateTab("Combat")
local VisualTab = CreateTab("Visual")

CreateTabButton("Farming", 0, "Farm")
CreateTabButton("Teleport", 1, "Travel")
CreateTabButton("Combat", 2, "Combat")
CreateTabButton("ESP", 3, "Visual")

--// Toggles
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

--// Logic Loop (Conceptual)
RunService.Heartbeat:Connect(function()
	if State.AutoFarm then
		-- enemy scan + tween
	end
	if State.CombatAssist then
		-- nearest target bias
	end
	if State.ESP then
		-- highlights / billboards
	end
end)
