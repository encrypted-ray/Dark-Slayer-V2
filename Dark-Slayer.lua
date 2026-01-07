-- DARK SLAYER V2 | REDZ HUB STYLE | FULLY FIXED

if not game:IsLoaded() then game.Loaded:Wait() end

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

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
	FlySpeed = 120,
	FrozenCFrame = nil,
	AutoWinter = false,
	StopMyth = false,
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
main.Size = isMobile and UDim2.fromOffset(380, 270) or UDim2.fromOffset(640, 400)
main.Position = UDim2.fromScale(0.5, 0.5)
main.AnchorPoint = Vector2.new(0.5, 0.5)
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
close.Size = UDim2.fromOffset(32,24)
close.Position = UDim2.new(1,-38,0.5,-12)
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
	scroll.ScrollBarImageTransparency = 0.6
	scroll.BackgroundTransparency = 1
	scroll.Visible = false

	local pad = Instance.new("UIPadding", scroll)
	pad.PaddingTop = UDim.new(0,12)
	pad.PaddingLeft = UDim.new(0,12)
	pad.PaddingRight = UDim.new(0,12)

	local list = Instance.new("UIListLayout", scroll)
	list.Padding = UDim.new(0,10)

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
		for n,p in pairs(Pages) do p.Visible = false end
		for _,t in pairs(Tabs) do t.BackgroundColor3 = Color3.fromRGB(30,30,30) end
		Pages[name].Visible = true
		b.BackgroundColor3 = Color3.fromRGB(45,45,45)
	end)

	Tabs[name] = b
	return b
end

local function ToggleButton(parent, label, color)
	local b = Instance.new("TextButton", parent)
	b.Size = UDim2.new(1,0,0,38)
	b.Text = label
	b.Font = Enum.Font.GothamMedium
	b.TextSize = 13
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = color or Color3.fromRGB(35,35,35)
	b.BorderSizePixel = 0
	Instance.new("UICorner", b)
	return b
end

----------------------------------------------------------------
-- CREATE PAGES & TABS
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
		h.FillColor = Color3.fromRGB(255,70,70)
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

local espBtn = ToggleButton(ESPPage,"ESP : OFF",Color3.fromRGB(120,40,40))
espBtn.MouseButton1Click:Connect(function()
	State.ESP = not State.ESP
	espBtn.Text = "ESP : "..(State.ESP and "ON" or "OFF")
	for _,h in pairs(Highlights) do if h then h.Enabled = State.ESP end end
end)

----------------------------------------------------------------
-- MOVEMENT
----------------------------------------------------------------
local flyBtn = ToggleButton(MovePage,"FLY : OFF")
local noclipBtn = ToggleButton(MovePage,"NOCLIP : OFF")
local jumpBtn = ToggleButton(MovePage,"INF JUMP : OFF")
local speedBtn = ToggleButton(MovePage,"SPEED : OFF")

flyBtn.MouseButton1Click:Connect(function()
	State.Fly = not State.Fly
	flyBtn.Text = "FLY : "..(State.Fly and "ON" or "OFF")
	lp.Character.Humanoid.PlatformStand = State.Fly
end)

noclipBtn.MouseButton1Click:Connect(function()
	State.Noclip = not State.Noclip
	noclipBtn.Text = "NOCLIP : "..(State.Noclip and "ON" or "OFF")
end)

jumpBtn.MouseButton1Click:Connect(function()
	State.InfJump = not State.InfJump
	jumpBtn.Text = "INF JUMP : "..(State.InfJump and "ON" or "OFF")
end)

speedBtn.MouseButton1Click:Connect(function()
	local hum = lp.Character.Humanoid
	hum.WalkSpeed = hum.WalkSpeed == 16 and 100 or 16
	speedBtn.Text = "SPEED : "..(hum.WalkSpeed > 16 and "ON" or "OFF")
end)

UIS.JumpRequest:Connect(function()
	if State.InfJump then
		lp.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

----------------------------------------------------------------
-- UTILITY
----------------------------------------------------------------
local freezeBtn = ToggleButton(UtilPage,"FREEZE : OFF",Color3.fromRGB(40,80,160))
local hopBtn = ToggleButton(UtilPage,"SERVER HOP",Color3.fromRGB(140,60,60))

freezeBtn.MouseButton1Click:Connect(function()
	State.Frozen = not State.Frozen
	State.FrozenCFrame = State.Frozen and lp.Character.HumanoidRootPart.CFrame or nil
	freezeBtn.Text = "FREEZE : "..(State.Frozen and "ON" or "OFF")
end)

hopBtn.MouseButton1Click:Connect(function()
	local url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?limit=100"
	local servers = HttpService:JSONDecode(game:HttpGet(url)).data
	for _,v in pairs(servers) do
		if v.playing < v.maxPlayers and v.id ~= game.JobId then
			TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id)
			break
		end
	end
end)

----------------------------------------------------------------
-- GACHA (SAFE)
----------------------------------------------------------------
local autoBtn = ToggleButton(GachaPage,"AUTO WINTER : OFF",Color3.fromRGB(30,110,210))
local mythBtn = ToggleButton(GachaPage,"STOP ON MYTH : OFF",Color3.fromRGB(30,90,190))

autoBtn.MouseButton1Click:Connect(function()
	State.AutoWinter = not State.AutoWinter
	autoBtn.Text = "AUTO WINTER : "..(State.AutoWinter and "ON" or "OFF")
end)

mythBtn.MouseButton1Click:Connect(function()
	State.StopMyth = not State.StopMyth
	mythBtn.Text = "STOP ON MYTH : "..(State.StopMyth and "ON" or "OFF")
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
