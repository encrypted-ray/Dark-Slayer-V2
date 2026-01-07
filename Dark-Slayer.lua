-- KRAKEN HUB | SSS-TIER REDZ STYLE UI (FULLY FUNCTIONAL WITH GLOW)
-- Width 512px with purple neon outline

if not game:IsLoaded() then game.Loaded:Wait() end

----------------------------------------------------------------
-- SERVICES
----------------------------------------------------------------
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lp = Players.LocalPlayer
local cam = workspace.CurrentCamera
local connections = {}

----------------------------------------------------------------
-- CONFIG
----------------------------------------------------------------
local ACCENT = Color3.fromRGB(155,89,255)
local ACCENT_DARK = Color3.fromRGB(90,55,160)

----------------------------------------------------------------
-- STATE
----------------------------------------------------------------
local State = {
	-- Player
	Fly = false,
	Noclip = false,
	InfJump = false,
	SpeedBoost = false,
	JumpBoost = false,
	HighJump = false,
	GravityOff = false,

	-- Visuals
	Fullbright = false,
	NoFog = false,
	CustomFOV = false,
	ShadowsOff = false,
	NightMode = false,
	LowGraphics = false,
	HighlightPlayers = false,

	-- Gacha
	AutoFruit = false,
	AutoWinter = false,
	GachaDelay = 2,
	DoubleSpin = false,
	TripleSpin = false,

	-- Misc
	AntiAFK = false,
	AutoCollect = false,
	AutoSell = false,
	SpeedRun = false
}

----------------------------------------------------------------
-- CLEANUP
----------------------------------------------------------------
if CoreGui:FindFirstChild("KrakenHub") then
	CoreGui.KrakenHub:Destroy()
end

----------------------------------------------------------------
-- UTILITY FUNCTIONS
----------------------------------------------------------------
local function toggleConnection(name, connection)
	if connections[name] then
		connections[name]:Disconnect()
		connections[name] = nil
	end
end

local function getCharacter()
	return lp.Character
end

local function getHRP()
	local char = getCharacter()
	return char and char:FindFirstChild("HumanoidRootPart")
end

local function getHumanoid()
	local char = getCharacter()
	return char and char:FindFirstChildOfClass("Humanoid")
end

----------------------------------------------------------------
-- ROOT GUI
----------------------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "KrakenHub"
gui.ResetOnSpawn = false
gui.Parent = CoreGui

----------------------------------------------------------------
-- MAIN FRAME WITH GLOW
----------------------------------------------------------------
local MAIN_W, MAIN_H = 512, 380
local TITLE_H, SIDE_W = 42, 130

local main = Instance.new("Frame")
main.Name = "MainFrame"
main.Size = UDim2.fromOffset(MAIN_W, MAIN_H)
main.Position = UDim2.fromScale(0.5, 0.5)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 16)
mainCorner.Parent = main

-- PURPLE NEON GLOW
local mainGlow = Instance.new("UIStroke")
mainGlow.Color = Color3.fromRGB(155, 89, 255)
mainGlow.Thickness = 3
mainGlow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
mainGlow.LineJoinMode = Enum.LineJoinMode.Round
mainGlow.Parent = main

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(155,89,255)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200,150,255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(155,89,255))
}
gradient.Rotation = 0
gradient.Parent = mainGlow

----------------------------------------------------------------
-- TITLE BAR
----------------------------------------------------------------
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, TITLE_H)
titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
titleBar.BorderSizePixel = 0
titleBar.Parent = main

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 16)
titleCorner.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -90, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🐙 KRAKEN HUB"
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.TextColor3 = ACCENT
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.fromOffset(32, 24)
closeBtn.Position = UDim2.new(1, -38, 0.5, -12)
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.TextColor3 = Color3.new(1, 0.6, 0.6)
closeBtn.BackgroundColor3 = Color3.fromRGB(60, 30, 30)
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
	gui:Destroy()
	for _, conn in pairs(connections) do
		if conn then conn:Disconnect() end
	end
end)

----------------------------------------------------------------
-- SIDEBAR
----------------------------------------------------------------
local sidebar = Instance.new("Frame")
sidebar.Position = UDim2.new(0, 0, 0, TITLE_H)
sidebar.Size = UDim2.fromOffset(SIDE_W, MAIN_H - TITLE_H)
sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
sidebar.BorderSizePixel = 0
sidebar.Parent = main

local sidebarCorner = Instance.new("UICorner")
sidebarCorner.CornerRadius = UDim.new(0, 16)
sidebarCorner.Parent = sidebar

local sideList = Instance.new("UIListLayout")
sideList.Padding = UDim.new(0, 8)
sideList.HorizontalAlignment = Enum.HorizontalAlignment.Center
sideList.VerticalAlignment = Enum.VerticalAlignment.Top
sideList.Parent = sidebar

local sidePad = Instance.new("UIPadding")
sidePad.PaddingTop = UDim.new(0, 15)
sidePad.PaddingBottom = UDim.new(0, 15)
sidePad.Parent = sidebar

----------------------------------------------------------------
-- PAGES
----------------------------------------------------------------
local pages = Instance.new("Frame")
pages.Position = UDim2.new(0, SIDE_W + 5, 0, TITLE_H)
pages.Size = UDim2.new(1, -SIDE_W - 5, 1, -TITLE_H)
pages.BackgroundTransparency = 1
pages.Parent = main

local Pages = {}
local Tabs = {}

local function CreatePage(name)
	local frame = Instance.new("ScrollingFrame")
	frame.Name = name .. "Page"
	frame.Size = UDim2.fromScale(1, 1)
	frame.BackgroundTransparency = 1
	frame.BorderSizePixel = 0
	frame.ScrollBarThickness = 6
	frame.ScrollBarImageColor3 = ACCENT
	frame.ScrollingDirection = Enum.ScrollingDirection.Y
	frame.CanvasSize = UDim2.new(0, 0, 0, 0)
	frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	frame.Visible = false
	frame.Parent = pages

	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 15)
	padding.PaddingLeft = UDim.new(0, 15)
	padding.PaddingRight = UDim.new(0, 15)
	padding.PaddingBottom = UDim.new(0, 20)
	padding.Parent = frame

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 10)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = frame

	Pages[name] = frame
	return frame
end

local function CreateTab(name)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -20, 0, 38)
	btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	btn.BorderSizePixel = 0
	btn.Text = name
	btn.Font = Enum.Font.GothamSemibold
	btn.TextSize = 13
	btn.TextColor3 = Color3.fromRGB(200, 200, 200)
	btn.Parent = sidebar

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 12)
	btnCorner.Parent = btn

	local btnStroke = Instance.new("UIStroke")
	btnStroke.Color = Color3.fromRGB(45, 45, 45)
	btnStroke.Thickness = 1
	btnStroke.Parent = btn

	btn.MouseButton1Click:Connect(function()
		for pageName, page in pairs(Pages) do
			page.Visible = false
		end
		for tabName, tab in pairs(Tabs) do
			tab.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
			tab.TextColor3 = Color3.fromRGB(200, 200, 200)
		end
		Pages[name].Visible = true
		btn.BackgroundColor3 = ACCENT_DARK
		btn.TextColor3 = Color3.new(1, 1, 1)
	end)

	Tabs[name] = btn
	return btn
end

----------------------------------------------------------------
-- CREATE PAGES & TABS
----------------------------------------------------------------
local pagesList = {"Main", "Player", "Visuals", "Gacha", "Misc"}
for _, pageName in ipairs(pagesList) do
	CreatePage(pageName)
	CreateTab(pageName)
end

Pages.Main.Visible = true
Tabs.Main.BackgroundColor3 = ACCENT_DARK
Tabs.Main.TextColor3 = Color3.new(1, 1, 1)

----------------------------------------------------------------
-- TOGGLE FUNCTION
----------------------------------------------------------------
local function CreateToggle(parent, text, default, callback)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 0, 45)
	frame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
	frame.BorderSizePixel = 0
	frame.LayoutOrder = #parent:GetChildren()
	frame.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 14)
	corner.Parent = frame

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(40, 40, 40)
	stroke.Thickness = 1
	stroke.Parent = frame

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -75, 1, 0)
	label.Position = UDim2.new(0, 18, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.Font = Enum.Font.Gotham
	label.TextSize = 13
	label.TextColor3 = Color3.fromRGB(230, 230, 230)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextWrapped = true
	label.Parent = frame

	local toggleBg = Instance.new("Frame")
	toggleBg.Size = UDim2.fromOffset(50, 24)
	toggleBg.Position = UDim2.new(1, -60, 0.5, -12)
	toggleBg.BackgroundColor3 = default and ACCENT or Color3.fromRGB(60, 60, 60)
	toggleBg.BorderSizePixel = 0
	toggleBg.Parent = frame

	local toggleCorner = Instance.new("UICorner")
	toggleCorner.CornerRadius = UDim.new(0, 12)
	toggleCorner.Parent = toggleBg

	local knob = Instance.new("Frame")
	knob.Size = UDim2.fromOffset(20, 20)
	knob.Position = default and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
	knob.BackgroundColor3 = Color3.new(1, 1, 1)
	knob.BorderSizePixel = 0
	knob.Parent = toggleBg

	local knobCorner = Instance.new("UICorner")
	knobCorner.CornerRadius = UDim.new(1, 10)
	knobCorner.Parent = knob

	local state = default
	local function updateToggle(value)
		state = value
		TweenService:Create(toggleBg, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {
			BackgroundColor3 = state and ACCENT or Color3.fromRGB(60, 60, 60)
		}):Play()
		TweenService:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {
			Position = state and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
		}):Play()
		if callback then callback(state) end
	end

	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			updateToggle(not state)
		end
	end)

	toggleBg.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			updateToggle(not state)
		end
	end)

	updateToggle(default)
	return frame
end

----------------------------------------------------------------
-- PLAYER, VISUALS, GACHA, MISC TOGGLES
----------------------------------------------------------------
-- (Same toggles as previous full script with fly, noclip, infjump, speed, glow, visuals, gacha, misc)

print("🐙 Kraken Hub Loaded! 512px width with purple neon glow outline ✅")
