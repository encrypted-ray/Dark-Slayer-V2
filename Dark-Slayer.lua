-- KRAKEN HUB | SSS-TIER REDZ STYLE UI (SHORTER + GACHA LOGIC)

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
	ESP = false,
	Fly = false,
	Noclip = false,
	InfJump = false,

	-- Visuals
	Fullbright = false,
	NoFog = false,
	CustomFOV = false,

	-- Gacha
	AutoFruit = false,
	AutoWinter = false,
	GachaDelay = 2
}

----------------------------------------------------------------
-- CLEANUP
----------------------------------------------------------------
if CoreGui:FindFirstChild("KrakenHub") then
	CoreGui.KrakenHub:Destroy()
end

----------------------------------------------------------------
-- ROOT GUI
----------------------------------------------------------------
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "KrakenHub"
gui.ResetOnSpawn = false

----------------------------------------------------------------
-- MAIN FRAME (SHORTER HEIGHT)
----------------------------------------------------------------
local MAIN_W, MAIN_H = 560, 330
local TITLE_H, SIDE_W = 36, 120

local main = Instance.new("Frame", gui)
main.Size = UDim2.fromOffset(MAIN_W, MAIN_H)
main.Position = UDim2.fromScale(0.5,0.5)
main.AnchorPoint = Vector2.new(0.5,0.5)
main.BackgroundColor3 = Color3.fromRGB(16,16,16)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0,20)

local stroke = Instance.new("UIStroke", main)
stroke.Color = ACCENT
stroke.Thickness = 1

----------------------------------------------------------------
-- TITLE BAR
----------------------------------------------------------------
local titleBar = Instance.new("Frame", main)
titleBar.Size = UDim2.new(1,0,0,TITLE_H)
titleBar.BackgroundColor3 = Color3.fromRGB(22,22,22)
titleBar.BorderSizePixel = 0
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0,18)

local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(1,-80,1,0)
title.Position = UDim2.new(0,12,0,0)
title.BackgroundTransparency = 1
title.Text = "Kraken Hub"
title.Font = Enum.Font.GothamMedium
title.TextSize = 13
title.TextColor3 = ACCENT
title.TextXAlignment = Enum.TextXAlignment.Left

local close = Instance.new("TextButton", titleBar)
close.Size = UDim2.fromOffset(24,20)
close.Position = UDim2.new(1,-30,0.5,-10)
close.Text = "X"
close.Font = Enum.Font.GothamBold
close.TextSize = 14
close.TextColor3 = Color3.new(1,1,1)
close.BackgroundColor3 = Color3.fromRGB(90,40,40)
close.BorderSizePixel = 0
Instance.new("UICorner", close).CornerRadius = UDim.new(0,14)
close.MouseButton1Click:Connect(function() gui:Destroy() end)

----------------------------------------------------------------
-- SIDEBAR
----------------------------------------------------------------
local sidebar = Instance.new("Frame", main)
sidebar.Position = UDim2.new(0,0,0,TITLE_H)
sidebar.Size = UDim2.fromOffset(SIDE_W, MAIN_H - TITLE_H)
sidebar.BackgroundColor3 = Color3.fromRGB(22,22,22)
sidebar.BorderSizePixel = 0
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0,18)

local sideList = Instance.new("UIListLayout", sidebar)
sideList.Padding = UDim.new(0,5)
sideList.HorizontalAlignment = Enum.HorizontalAlignment.Center
sideList.VerticalAlignment = Enum.VerticalAlignment.Center

----------------------------------------------------------------
-- PAGES
----------------------------------------------------------------
local pages = Instance.new("Frame", main)
pages.Position = UDim2.new(0,SIDE_W,0,TITLE_H)
pages.Size = UDim2.new(1,-SIDE_W,1,-TITLE_H)
pages.BackgroundTransparency = 1

local Pages, Tabs = {}, {}

local function CreatePage(name)
	local s = Instance.new("ScrollingFrame", pages)
	s.Size = UDim2.fromScale(1,1)
	s.AutomaticCanvasSize = Enum.AutomaticSize.Y
	s.ScrollBarImageTransparency = 0.9
	s.BackgroundTransparency = 1
	s.Visible = false

	local pad = Instance.new("UIPadding", s)
	pad.PaddingTop = UDim.new(0,10)
	pad.PaddingLeft = UDim.new(0,10)
	pad.PaddingRight = UDim.new(0,10)
	pad.PaddingBottom = UDim.new(0,10)

	local list = Instance.new("UIListLayout", s)
	list.Padding = UDim.new(0,7)

	Pages[name] = s
	return s
end

local function CreateTab(name)
	local b = Instance.new("TextButton", sidebar)
	b.Size = UDim2.new(1,-14,0,30)
	b.Text = name
	b.Font = Enum.Font.Gotham
	b.TextSize = 12
	b.TextColor3 = Color3.fromRGB(230,230,230)
	b.BackgroundColor3 = Color3.fromRGB(30,30,30)
	b.BorderSizePixel = 0
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,16)

	b.MouseButton1Click:Connect(function()
		for _,p in pairs(Pages) do p.Visible = false end
		for _,t in pairs(Tabs) do t.BackgroundColor3 = Color3.fromRGB(30,30,30) end
		Pages[name].Visible = true
		b.BackgroundColor3 = ACCENT_DARK
	end)

	Tabs[name] = b
	return b
end

----------------------------------------------------------------
-- TABS
----------------------------------------------------------------
local MainPage     = CreatePage("Main")
local PlayerPage   = CreatePage("Player")
local TeleportPage = CreatePage("Teleport")
local VisualsPage  = CreatePage("Visuals")
local GachaPage    = CreatePage("Gacha")
local MiscPage     = CreatePage("Misc")
local UIPage       = CreatePage("UI Settings")

for _,n in ipairs({
	"Main","Player","Teleport","Visuals","Gacha","Misc","UI Settings"
}) do CreateTab(n) end

Pages.Main.Visible = true
Tabs.Main.BackgroundColor3 = ACCENT_DARK

----------------------------------------------------------------
-- TOGGLE
----------------------------------------------------------------
local function CreateToggle(parent,text,default,callback)
	local h = Instance.new("Frame", parent)
	h.Size = UDim2.new(1,0,0,34)
	h.BackgroundColor3 = Color3.fromRGB(26,26,26)
	h.BorderSizePixel = 0
	Instance.new("UICorner", h).CornerRadius = UDim.new(0,16)

	local l = Instance.new("TextLabel", h)
	l.Size = UDim2.new(1,-70,1,0)
	l.Position = UDim2.new(0,10,0,0)
	l.BackgroundTransparency = 1
	l.Text = text
	l.Font = Enum.Font.Gotham
	l.TextSize = 12
	l.TextColor3 = Color3.fromRGB(230,230,230)
	l.TextXAlignment = Enum.TextXAlignment.Left

	local bg = Instance.new("Frame", h)
	bg.Size = UDim2.fromOffset(34,16)
	bg.Position = UDim2.new(1,-44,0.5,-8)
	bg.BackgroundColor3 = default and ACCENT or Color3.fromRGB(70,70,70)
	bg.BorderSizePixel = 0
	Instance.new("UICorner", bg).CornerRadius = UDim.new(1,0)

	local k = Instance.new("Frame", bg)
	k.Size = UDim2.fromOffset(12,12)
	k.Position = default and UDim2.new(1,-14,0.5,-6) or UDim2.new(0,2,0.5,-6)
	k.BackgroundColor3 = Color3.new(1,1,1)
	k.BorderSizePixel = 0
	Instance.new("UICorner", k).CornerRadius = UDim.new(1,0)

	local state = default
	local function Set(v)
		state = v
		TweenService:Create(bg,TweenInfo.new(0.15),{
			BackgroundColor3 = state and ACCENT or Color3.fromRGB(70,70,70)
		}):Play()
		TweenService:Create(k,TweenInfo.new(0.15),{
			Position = state and UDim2.new(1,-14,0.5,-6) or UDim2.new(0,2,0.5,-6)
		}):Play()
		if callback then callback(state) end
	end

	h.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			Set(not state)
		end
	end)

	Set(default)
end

----------------------------------------------------------------
-- PLAYER
----------------------------------------------------------------
CreateToggle(PlayerPage,"Fly",false,function(v) State.Fly = v end)
CreateToggle(PlayerPage,"Noclip",false,function(v) State.Noclip = v end)
CreateToggle(PlayerPage,"Infinite Jump",false,function(v) State.InfJump = v end)

----------------------------------------------------------------
-- VISUALS
----------------------------------------------------------------
CreateToggle(VisualsPage,"Fullbright",false,function(v)
	State.Fullbright = v
	Lighting.Brightness = v and 3 or 1
	Lighting.ClockTime = v and 14 or 12
end)

CreateToggle(VisualsPage,"Remove Fog",false,function(v)
	Lighting.FogEnd = v and 100000 or 1000
end)

CreateToggle(VisualsPage,"Custom FOV",false,function(v)
	cam.FieldOfView = v and 90 or 70
end)

----------------------------------------------------------------
-- GACHA (WORKING LOOP)
----------------------------------------------------------------
local FruitRemote = ReplicatedStorage:FindFirstChild("FruitSpin", true)
local WinterRemote = ReplicatedStorage:FindFirstChild("WinterSpin", true)

task.spawn(function()
	while task.wait(State.GachaDelay) do
		if State.AutoFruit and FruitRemote then
			pcall(function() FruitRemote:FireServer() end)
		end
		if State.AutoWinter and WinterRemote then
			pcall(function() WinterRemote:FireServer() end)
		end
	end
end)

CreateToggle(GachaPage,"Auto Fruit Spin",false,function(v)
	State.AutoFruit = v
end)

CreateToggle(GachaPage,"Auto Winter Spin",false,function(v)
	State.AutoWinter = v
end)

----------------------------------------------------------------
-- CORE LOOP
----------------------------------------------------------------
UIS.JumpRequest:Connect(function()
	if State.InfJump then
		lp.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

RunService.Heartbeat:Connect(function(dt)
	local char = lp.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	if State.Fly then
		local d = Vector3.zero
		if UIS:IsKeyDown(Enum.KeyCode.W) then d += cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then d -= cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then d -= cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then d += cam.CFrame.RightVector end
		hrp.CFrame += d * 110 * dt
	end

	if State.Noclip then
		for _,v in ipairs(char:GetDescendants()) do
			if v:IsA("BasePart") then v.CanCollide = false end
		end
	end
end)
