-- DARK SLAYER V2 | REDZ HUB STYLE | MOBILE FIXED

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
local gui = Instance.new("ScreenGui")
gui.Name = "DarkSlayerRedz"
gui.ResetOnSpawn = false
gui.Parent = CoreGui

local isMobile = UIS.TouchEnabled

-- MAIN FRAME (MOBILE SAFE)
local main = Instance.new("Frame", gui)
main.Size = isMobile and UDim2.fromOffset(360, 260) or UDim2.fromOffset(620, 380)
main.Position = UDim2.fromScale(0.5, 0.5)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(16,16,16)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = not isMobile
Instance.new("UICorner", main).CornerRadius = UDim.new(0,14)

-- TITLE BAR
local titleBar = Instance.new("Frame", main)
titleBar.Size = UDim2.new(1,0,0,36)
titleBar.BackgroundColor3 = Color3.fromRGB(20,20,20)
titleBar.BorderSizePixel = 0

local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(1,-40,1,0)
title.Position = UDim2.new(0,10,0,0)
title.BackgroundTransparency = 1
title.Text = "DARK SLAYER V2"
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.TextColor3 = Color3.new(1,1,1)
title.TextXAlignment = Enum.TextXAlignment.Left

local close = Instance.new("TextButton", titleBar)
close.Size = UDim2.fromOffset(28,22)
close.Position = UDim2.new(1,-32,0.5,-11)
close.Text = "✕"
close.Font = Enum.Font.GothamBold
close.TextSize = 14
close.TextColor3 = Color3.fromRGB(255,90,90)
close.BackgroundColor3 = Color3.fromRGB(35,35,35)
close.BorderSizePixel = 0
Instance.new("UICorner", close)

close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

-- SIDEBAR
local sidebar = Instance.new("Frame", main)
sidebar.Position = UDim2.new(0,0,0,36)
sidebar.Size = UDim2.fromOffset(110, main.Size.Y.Offset - 36)
sidebar.BackgroundColor3 = Color3.fromRGB(22,22,22)
sidebar.BorderSizePixel = 0

local sidePad = Instance.new("UIPadding", sidebar)
sidePad.PaddingTop = UDim.new(0,6)

local sideList = Instance.new("UIListLayout", sidebar)
sideList.Padding = UDim.new(0,6)
sideList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- CONTENT HOLDER
local pages = Instance.new("Frame", main)
pages.Position = UDim2.fromOffset(110, 36)
pages.Size = UDim2.new(1,-110,1,-36)
pages.BackgroundTransparency = 1

-- PAGE SYSTEM
local Pages = {}

local function CreatePage(name)
	local scroll = Instance.new("ScrollingFrame", pages)
	scroll.Size = UDim2.fromScale(1,1)
	scroll.CanvasSize = UDim2.new(0,0,0,0)
	scroll.ScrollBarImageTransparency = 0.6
	scroll.Visible = false
	scroll.BackgroundTransparency = 1
	scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

	local pad = Instance.new("UIPadding", scroll)
	pad.PaddingTop = UDim.new(0,10)
	pad.PaddingLeft = UDim.new(0,10)
	pad.PaddingRight = UDim.new(0,10)

	local list = Instance.new("UIListLayout", scroll)
	list.Padding = UDim.new(0,8)

	Pages[name] = scroll
	return scroll
end

local function CreateTab(name)
	local b = Instance.new("TextButton", sidebar)
	b.Size = UDim2.new(1,-12,0,34)
	b.Text = name
	b.Font = Enum.Font.GothamMedium
	b.TextSize = 13
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(30,30,30)
	b.BorderSizePixel = 0
	Instance.new("UICorner", b)

	b.MouseButton1Click:Connect(function()
		for _,p in pairs(Pages) do p.Visible = false end
		Pages[name].Visible = true
	end)
end

local function PageButton(parent, text, color)
	local b = Instance.new("TextButton", parent)
	b.Size = UDim2.new(1,0,0,34)
	b.Text = text
	b.Font = Enum.Font.GothamMedium
	b.TextSize = 13
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = color or Color3.fromRGB(32,32,32)
	b.BorderSizePixel = 0
	Instance.new("UICorner", b)
	return b
end

-- CREATE PAGES + TABS
local ESPPage = CreatePage("ESP")
local MovePage = CreatePage("Movement")
local UtilPage = CreatePage("Utility")
local GachaPage = CreatePage("Gacha")

CreateTab("ESP")
CreateTab("Movement")
CreateTab("Utility")
CreateTab("Gacha")

ESPPage.Visible = true

-- ESP
local espBtn = PageButton(ESPPage,"ESP : OFF",Color3.fromRGB(90,30,30))
espBtn.MouseButton1Click:Connect(function()
	State.ESP = not State.ESP
	espBtn.Text = "ESP : "..(State.ESP and "ON" or "OFF")
end)

-- MOVEMENT
local flyBtn = PageButton(MovePage,"FLY : OFF")
local noclipBtn = PageButton(MovePage,"NOCLIP : OFF")
local jumpBtn = PageButton(MovePage,"INF JUMP : OFF")
local speedBtn = PageButton(MovePage,"SPEED : OFF")

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

-- UTILITY
local freezeBtn = PageButton(UtilPage,"FREEZE : OFF",Color3.fromRGB(30,60,120))
local hopBtn = PageButton(UtilPage,"SERVER HOP",Color3.fromRGB(120,40,40))

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

-- GACHA
local autoBtn = PageButton(GachaPage,"AUTO WINTER : OFF",Color3.fromRGB(25,100,200))
local mythBtn = PageButton(GachaPage,"STOP ON MYTH : OFF",Color3.fromRGB(25,80,180))

autoBtn.MouseButton1Click:Connect(function()
	State.AutoWinter = not State.AutoWinter
	autoBtn.Text = "AUTO WINTER : "..(State.AutoWinter and "ON" or "OFF")
end)

mythBtn.MouseButton1Click:Connect(function()
	State.StopMyth = not State.StopMyth
	mythBtn.Text = "STOP ON MYTH : "..(State.StopMyth and "ON" or "OFF")
end)

-- CORE LOOPS
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

-- WINTER GACHA LOOP
task.spawn(function()
	while task.wait(1) do
		if State.AutoWinter then
			pcall(function()
				ReplicatedStorage.Remotes.RollWinterGacha:FireServer(State.CandyCost)
			end)
			local result = ReplicatedStorage.Remotes.GachaResult.OnClientEvent:Wait()
			if State.StopMyth and result.Rarity == "Mythical" then
				State.AutoWinter = false
				autoBtn.Text = "AUTO WINTER : OFF"
			end
		end
	end
end)
