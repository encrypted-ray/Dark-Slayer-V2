-- DARK SLAYER V2 | REDZ HUB STYLE | TOGGLE EDITION

if not game:IsLoaded() then game.Loaded:Wait() end

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local lp = Players.LocalPlayer
repeat task.wait() until lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
local cam = workspace.CurrentCamera

-- STATE
local State = {
	Fly = false,
	Noclip = false,
	InfJump = false,
	ESP = false,
	Frozen = false,
	AutoWinter = false,
	StopMyth = false,
	FlySpeed = 120,
	FrozenCFrame = nil,
	CandyCost = 100
}

-- CLEANUP
if CoreGui:FindFirstChild("DarkSlayerRedz") then
	CoreGui.DarkSlayerRedz:Destroy()
end

-- GUI ROOT
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "DarkSlayerRedz"
gui.ResetOnSpawn = false

local isMobile = UIS.TouchEnabled

-- MAIN FRAME
local main = Instance.new("Frame", gui)
main.Size = isMobile and UDim2.fromOffset(380,270) or UDim2.fromOffset(640,400)
main.Position = UDim2.fromScale(0.5,0.5)
main.AnchorPoint = Vector2.new(0.5,0.5)
main.BackgroundColor3 = Color3.fromRGB(16,16,16)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = not isMobile
Instance.new("UICorner", main).CornerRadius = UDim.new(0,14)

----------------------------------------------------------------
-- TITLE BAR
----------------------------------------------------------------
local titleBar = Instance.new("Frame", main)
titleBar.Size = UDim2.new(1,0,0,38)
titleBar.BackgroundColor3 = Color3.fromRGB(20,20,20)
titleBar.BorderSizePixel = 0

local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(1,-60,1,0)
title.Position = UDim2.new(0,12,0,0)
title.BackgroundTransparency = 1
title.Text = "DARK SLAYER V2"
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.TextColor3 = Color3.new(1,1,1)
title.TextXAlignment = Enum.TextXAlignment.Left

local close = Instance.new("TextButton", titleBar)
close.Size = UDim2.fromOffset(30,22)
close.Position = UDim2.new(1,-36,0.5,-11)
close.Text = "✕"
close.Font = Enum.Font.GothamBold
close.TextSize = 14
close.TextColor3 = Color3.fromRGB(255,90,90)
close.BackgroundColor3 = Color3.fromRGB(40,40,40)
close.BorderSizePixel = 0
Instance.new("UICorner", close)

close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

----------------------------------------------------------------
-- SIDEBAR
----------------------------------------------------------------
local sidebar = Instance.new("Frame", main)
sidebar.Position = UDim2.new(0,0,0,38)
sidebar.Size = UDim2.fromOffset(120, main.Size.Y.Offset - 38)
sidebar.BackgroundColor3 = Color3.fromRGB(22,22,22)
sidebar.BorderSizePixel = 0

local sideList = Instance.new("UIListLayout", sidebar)
sideList.Padding = UDim.new(0,6)
sideList.HorizontalAlignment = Enum.HorizontalAlignment.Center
sideList.VerticalAlignment = Enum.VerticalAlignment.Center

----------------------------------------------------------------
-- PAGES
----------------------------------------------------------------
local pages = Instance.new("Frame", main)
pages.Position = UDim2.fromOffset(120,38)
pages.Size = UDim2.new(1,-120,1,-38)
pages.BackgroundTransparency = 1

local Pages = {}
local Tabs = {}

local function CreatePage(name)
	local scroll = Instance.new("ScrollingFrame", pages)
	scroll.Size = UDim2.fromScale(1,1)
	scroll.CanvasSize = UDim2.new(0,0,0,0)
	scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scroll.ScrollBarImageTransparency = 0.7
	scroll.BackgroundTransparency = 1
	scroll.Visible = false

	local pad = Instance.new("UIPadding", scroll)
	pad.PaddingTop = UDim.new(0,12)
	pad.PaddingLeft = UDim.new(0,12)
	pad.PaddingRight = UDim.new(0,12)

	local list = Instance.new("UIListLayout", scroll)
	list.Padding = UDim.new(0,12)

	Pages[name] = scroll
	return scroll
end

local function CreateTab(name)
	local b = Instance.new("TextButton", sidebar)
	b.Size = UDim2.new(1,-16,0,36)
	b.Text = name
	b.Font = Enum.Font.GothamMedium
	b.TextSize = 13
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(30,30,30)
	b.BorderSizePixel = 0
	Instance.new("UICorner", b)

	b.MouseButton1Click:Connect(function()
		for _,p in pairs(Pages) do p.Visible = false end
		for _,t in pairs(Tabs) do t.BackgroundColor3 = Color3.fromRGB(30,30,30) end
		Pages[name].Visible = true
		b.BackgroundColor3 = Color3.fromRGB(45,45,45)
	end)

	Tabs[name] = b
	return b
end

----------------------------------------------------------------
-- TOGGLE CREATOR (REDZ STYLE)
----------------------------------------------------------------
local function CreateToggle(parent, text, default, callback)
	local holder = Instance.new("Frame", parent)
	holder.Size = UDim2.new(1,0,0,42)
	holder.BackgroundColor3 = Color3.fromRGB(30,30,30)
	holder.BorderSizePixel = 0
	Instance.new("UICorner", holder)

	local label = Instance.new("TextLabel", holder)
	label.Size = UDim2.new(1,-60,1,0)
	label.Position = UDim2.new(0,12,0,0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.Font = Enum.Font.GothamMedium
	label.TextSize = 13
	label.TextColor3 = Color3.new(1,1,1)
	label.TextXAlignment = Enum.TextXAlignment.Left

	local toggleBg = Instance.new("Frame", holder)
	toggleBg.Size = UDim2.fromOffset(40,20)
	toggleBg.Position = UDim2.new(1,-52,0.5,-10)
	toggleBg.BackgroundColor3 = default and Color3.fromRGB(60,160,255) or Color3.fromRGB(60,60,60)
	toggleBg.BorderSizePixel = 0
	Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(1,0)

	local knob = Instance.new("Frame", toggleBg)
	knob.Size = UDim2.fromOffset(16,16)
	knob.Position = default and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8)
	knob.BackgroundColor3 = Color3.new(1,1,1)
	knob.BorderSizePixel = 0
	Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)

	local state = default

	local function Set(val)
		state = val
		TweenService:Create(toggleBg,TweenInfo.new(0.2),{
			BackgroundColor3 = state and Color3.fromRGB(60,160,255) or Color3.fromRGB(60,60,60)
		}):Play()
		TweenService:Create(knob,TweenInfo.new(0.2),{
			Position = state and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8)
		}):Play()
		if callback then callback(state) end
	end

	holder.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			Set(not state)
		end
	end)

	return Set
end

----------------------------------------------------------------
-- CREATE PAGES
----------------------------------------------------------------
local ESPPage = CreatePage("ESP")
local MovePage = CreatePage("Movement")
local UtilPage = CreatePage("Utility")
local GachaPage = CreatePage("Gacha")

CreateTab("ESP")
CreateTab("Movement")
CreateTab("Utility")
CreateTab("Gacha")

Pages.ESP.Visible = true
Tabs.ESP.BackgroundColor3 = Color3.fromRGB(45,45,45)

----------------------------------------------------------------
-- ESP (REAL)
----------------------------------------------------------------
local Highlights = {}

local function ApplyESP(player)
	if player == lp then return end
	local function onChar(char)
		if Highlights[player] then Highlights[player]:Destroy() end
		local h = Instance.new("Highlight")
		h.FillColor = Color3.fromRGB(255,80,80)
		h.OutlineColor = Color3.new(1,1,1)
		h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		h.Enabled = State.ESP
		h.Adornee = char
		h.Parent = char
		Highlights[player] = h
	end
	player.CharacterAdded:Connect(onChar)
	if player.Character then onChar(player.Character) end
end

for _,p in ipairs(Players:GetPlayers()) do ApplyESP(p) end
Players.PlayerAdded:Connect(ApplyESP)

CreateToggle(ESPPage,"Player ESP",false,function(v)
	State.ESP = v
	for _,h in pairs(Highlights) do if h then h.Enabled = v end end
end)

----------------------------------------------------------------
-- MOVEMENT
----------------------------------------------------------------
CreateToggle(MovePage,"Fly",false,function(v)
	State.Fly = v
	lp.Character.Humanoid.PlatformStand = v
end)

CreateToggle(MovePage,"Noclip",false,function(v)
	State.Noclip = v
end)

CreateToggle(MovePage,"Infinite Jump",false,function(v)
	State.InfJump = v
end)

CreateToggle(MovePage,"Speed Boost",false,function(v)
	lp.Character.Humanoid.WalkSpeed = v and 100 or 16
end)

UIS.JumpRequest:Connect(function()
	if State.InfJump then
		lp.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

----------------------------------------------------------------
-- UTILITY
----------------------------------------------------------------
CreateToggle(UtilPage,"Freeze Character",false,function(v)
	State.Frozen = v
	State.FrozenCFrame = v and lp.Character.HumanoidRootPart.CFrame or nil
end)

----------------------------------------------------------------
-- GACHA
----------------------------------------------------------------
CreateToggle(GachaPage,"Auto Winter Gacha",false,function(v)
	State.AutoWinter = v
end)

CreateToggle(GachaPage,"Stop On Mythic",false,function(v)
	State.StopMyth = v
end)

task.spawn(function()
	while task.wait(1) do
		if State.AutoWinter then
			pcall(function()
				ReplicatedStorage.Remotes.RollWinterGacha:FireServer(State.CandyCost)
			end)
		end
	end
end)

----------------------------------------------------------------
-- CORE LOOPS
----------------------------------------------------------------
RunService.Heartbeat:Connect(function(dt)
	local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	if State.Frozen and State.FrozenCFrame then
		hrp.CFrame = State.FrozenCFrame
		hrp.AssemblyLinearVelocity = Vector3.zero
	end

	if State.Fly then
		local dir = Vector3.zero
		if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
		hrp.CFrame += dir * State.FlySpeed * dt
	end

	if State.Noclip then
		for _,v in ipairs(lp.Character:GetDescendants()) do
			if v:IsA("BasePart") then v.CanCollide = false end
		end
	end
end)
