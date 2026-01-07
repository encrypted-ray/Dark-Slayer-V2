-- DARK SLAYER V2 | MODERN REDZ-STYLE UI (FIXED + POLISHED)

if not game:IsLoaded() then game.Loaded:Wait() end

----------------------------------------------------------------
-- SERVICES
----------------------------------------------------------------
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local lp = Players.LocalPlayer
repeat task.wait() until lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
local cam = workspace.CurrentCamera

----------------------------------------------------------------
-- STATE
----------------------------------------------------------------
local State = {
	ESP = false,
	Fly = false,
	Noclip = false,
	InfJump = false,

	-- Visuals
	Fullbright = false,
	NoFog = false,
	HideUI = false,
	FOV = false,

	-- Gacha
	AutoWinter = false,
	StopWinterMyth = false,
	AutoFruit = false,
	StopFruitMyth = false,

	FlySpeed = 120,
	Minimized = false
}

----------------------------------------------------------------
-- CLEANUP
----------------------------------------------------------------
if CoreGui:FindFirstChild("DarkSlayerModern") then
	CoreGui.DarkSlayerModern:Destroy()
end

----------------------------------------------------------------
-- GUI ROOT
----------------------------------------------------------------
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "DarkSlayerModern"
gui.ResetOnSpawn = false

local isMobile = UIS.TouchEnabled

----------------------------------------------------------------
-- MAIN FRAME
----------------------------------------------------------------
local MAIN_SIZE = isMobile and Vector2.new(360, 260) or Vector2.new(640, 400)
local TITLE_HEIGHT = 38

local main = Instance.new("Frame", gui)
main.Size = UDim2.fromOffset(MAIN_SIZE.X, MAIN_SIZE.Y)
main.Position = UDim2.fromScale(0.5, 0.5)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(18,18,18)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = not isMobile
Instance.new("UICorner", main).CornerRadius = UDim.new(0,14)

----------------------------------------------------------------
-- TITLE BAR
----------------------------------------------------------------
local titleBar = Instance.new("Frame", main)
titleBar.Size = UDim2.new(1,0,0,TITLE_HEIGHT)
titleBar.BackgroundColor3 = Color3.fromRGB(22,22,22)
titleBar.BorderSizePixel = 0

local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(1,-90,1,0)
title.Position = UDim2.new(0,12,0,0)
title.BackgroundTransparency = 1
title.Text = "Dark Slayer V2"
title.Font = Enum.Font.GothamMedium
title.TextSize = 13
title.TextColor3 = Color3.fromRGB(235,235,235)
title.TextXAlignment = Enum.TextXAlignment.Left

-- MINIMIZE
local minimize = Instance.new("TextButton", titleBar)
minimize.Size = UDim2.fromOffset(26,22)
minimize.Position = UDim2.new(1,-64,0.5,-11)
minimize.Text = "—"
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 14
minimize.TextColor3 = Color3.fromRGB(200,200,200)
minimize.BackgroundColor3 = Color3.fromRGB(35,35,35)
minimize.BorderSizePixel = 0
Instance.new("UICorner", minimize)

-- CLOSE
local close = Instance.new("TextButton", titleBar)
close.Size = UDim2.fromOffset(26,22)
close.Position = UDim2.new(1,-34,0.5,-11)
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

----------------------------------------------------------------
-- SIDEBAR
----------------------------------------------------------------
local sidebar = Instance.new("Frame", main)
sidebar.Position = UDim2.new(0,0,0,TITLE_HEIGHT)
sidebar.Size = UDim2.fromOffset(120, MAIN_SIZE.Y - TITLE_HEIGHT)
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
pages.Position = UDim2.fromOffset(120, TITLE_HEIGHT)
pages.Size = UDim2.new(1,-120,1,-TITLE_HEIGHT)
pages.BackgroundTransparency = 1

local Pages, Tabs = {}, {}

local function CreatePage(name)
	local scroll = Instance.new("ScrollingFrame", pages)
	scroll.Size = UDim2.fromScale(1,1)
	scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scroll.ScrollBarImageTransparency = 0.8
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
	b.Size = UDim2.new(1,-16,0,34)
	b.Text = name
	b.Font = Enum.Font.Gotham
	b.TextSize = 12
	b.TextColor3 = Color3.fromRGB(230,230,230)
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
-- MODERN TOGGLE
----------------------------------------------------------------
local function CreateToggle(parent, text, default, callback)
	local holder = Instance.new("Frame", parent)
	holder.Size = UDim2.new(1,0,0,38)
	holder.BackgroundColor3 = Color3.fromRGB(28,28,28)
	holder.BorderSizePixel = 0
	Instance.new("UICorner", holder)

	local label = Instance.new("TextLabel", holder)
	label.Size = UDim2.new(1,-60,1,0)
	label.Position = UDim2.new(0,10,0,0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.Font = Enum.Font.Gotham
	label.TextSize = 12
	label.TextColor3 = Color3.fromRGB(230,230,230)
	label.TextXAlignment = Enum.TextXAlignment.Left

	local bg = Instance.new("Frame", holder)
	bg.Size = UDim2.fromOffset(36,18)
	bg.Position = UDim2.new(1,-48,0.5,-9)
	bg.BackgroundColor3 = default and Color3.fromRGB(80,170,255) or Color3.fromRGB(70,70,70)
	bg.BorderSizePixel = 0
	Instance.new("UICorner", bg).CornerRadius = UDim.new(1,0)

	local knob = Instance.new("Frame", bg)
	knob.Size = UDim2.fromOffset(14,14)
	knob.Position = default and UDim2.new(1,-16,0.5,-7) or UDim2.new(0,2,0.5,-7)
	knob.BackgroundColor3 = Color3.new(1,1,1)
	knob.BorderSizePixel = 0
	Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)

	local state = default

	local function Set(v)
		state = v
		TweenService:Create(bg,TweenInfo.new(0.18),{
			BackgroundColor3 = state and Color3.fromRGB(80,170,255) or Color3.fromRGB(70,70,70)
		}):Play()
		TweenService:Create(knob,TweenInfo.new(0.18),{
			Position = state and UDim2.new(1,-16,0.5,-7) or UDim2.new(0,2,0.5,-7)
		}):Play()
		if callback then callback(state) end
	end

	holder.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			Set(not state)
		end
	end)

	Set(default)
end

----------------------------------------------------------------
-- PAGES
----------------------------------------------------------------
local Visuals = CreatePage("Visuals")
local Movement = CreatePage("Movement")
local Gacha = CreatePage("Gacha")

CreateTab("Visuals")
CreateTab("Movement")
CreateTab("Gacha")

Pages.Visuals.Visible = true
Tabs.Visuals.BackgroundColor3 = Color3.fromRGB(45,45,45)

----------------------------------------------------------------
-- VISUALS (FIXED ESP)
----------------------------------------------------------------
local Highlights = {}

local function ApplyESP(player)
	if player == lp then return end

	local function attach(char)
		if Highlights[player] then Highlights[player]:Destroy() end
		local h = Instance.new("Highlight")
		h.Adornee = char
		h.FillColor = Color3.fromRGB(255,80,80)
		h.OutlineColor = Color3.new(1,1,1)
		h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		h.Enabled = State.ESP
		h.Parent = workspace
		Highlights[player] = h
	end

	player.CharacterAdded:Connect(attach)
	if player.Character then attach(player.Character) end
end

for _,p in ipairs(Players:GetPlayers()) do ApplyESP(p) end
Players.PlayerAdded:Connect(ApplyESP)

CreateToggle(Visuals,"Player ESP",false,function(v)
	State.ESP = v
	for _,h in pairs(Highlights) do
		if h then h.Enabled = v end
	end
end)

CreateToggle(Visuals,"Fullbright",false,function(v)
	State.Fullbright = v
	Lighting.Brightness = v and 3 or 1
	Lighting.ClockTime = v and 14 or 12
end)

CreateToggle(Visuals,"Remove Fog",false,function(v)
	State.NoFog = v
	Lighting.FogEnd = v and 100000 or 1000
end)

CreateToggle(Visuals,"Custom FOV",false,function(v)
	State.FOV = v
	cam.FieldOfView = v and 90 or 70
end)

CreateToggle(Visuals,"Hide Roblox UI",false,function(v)
	State.HideUI = v
	pcall(function()
		for _,ui in pairs(Enum.CoreGuiType:GetEnumItems()) do
			CoreGui:SetCoreGuiEnabled(ui, not v)
		end
	end)
end)

----------------------------------------------------------------
-- MOVEMENT
----------------------------------------------------------------
CreateToggle(Movement,"Fly",false,function(v)
	State.Fly = v
	lp.Character.Humanoid.PlatformStand = v
end)

CreateToggle(Movement,"Noclip",false,function(v)
	State.Noclip = v
end)

CreateToggle(Movement,"Infinite Jump",false,function(v)
	State.InfJump = v
end)

UIS.JumpRequest:Connect(function()
	if State.InfJump then
		lp.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

----------------------------------------------------------------
-- GACHA (LOGIC KEPT CLEAN)
----------------------------------------------------------------
CreateToggle(Gacha,"Auto Winter Gacha",false,function(v)
	State.AutoWinter = v
end)

CreateToggle(Gacha,"Auto Fruit Spin",false,function(v)
	State.AutoFruit = v
end)

----------------------------------------------------------------
-- MINIMIZE ANIMATION
----------------------------------------------------------------
minimize.MouseButton1Click:Connect(function()
	State.Minimized = not State.Minimized
	local goal = State.Minimized
		and UDim2.fromOffset(MAIN_SIZE.X, TITLE_HEIGHT)
		or UDim2.fromOffset(MAIN_SIZE.X, MAIN_SIZE.Y)

	TweenService:Create(main,TweenInfo.new(0.25,Enum.EasingStyle.Quad),{
		Size = goal
	}):Play()

	sidebar.Visible = not State.Minimized
	pages.Visible = not State.Minimized
end)

----------------------------------------------------------------
-- CORE LOOP
----------------------------------------------------------------
RunService.Heartbeat:Connect(function(dt)
	local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

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
