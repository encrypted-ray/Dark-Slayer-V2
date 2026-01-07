-- KRAKEN HUB | REDZ-STYLE UI (FULL + ROUNDED + NAME ESP)

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

local lp = Players.LocalPlayer
repeat task.wait() until lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
local cam = workspace.CurrentCamera

----------------------------------------------------------------
-- ACCENT + RADIUS
----------------------------------------------------------------
local ACCENT = Color3.fromRGB(155, 89, 255)
local ACCENT_DARK = Color3.fromRGB(90, 55, 160)

local R_MAIN = 18
local R_SECTION = 16
local R_BUTTON = 14
local R_TOGGLE = 16
local R_PILL = 999

----------------------------------------------------------------
-- STATE
----------------------------------------------------------------
local State = {
	ESP = false,
	Fly = false,
	Noclip = false,
	InfJump = false,
	Minimized = false
}

----------------------------------------------------------------
-- CLEANUP
----------------------------------------------------------------
if CoreGui:FindFirstChild("KrakenHub") then
	CoreGui.KrakenHub:Destroy()
end

----------------------------------------------------------------
-- GUI ROOT
----------------------------------------------------------------
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "KrakenHub"
gui.ResetOnSpawn = false

----------------------------------------------------------------
-- MAIN FRAME
----------------------------------------------------------------
local MAIN_SIZE = Vector2.new(640,400)
local TITLE_HEIGHT = 38

local main = Instance.new("Frame", gui)
main.Size = UDim2.fromOffset(MAIN_SIZE.X, MAIN_SIZE.Y)
main.Position = UDim2.fromScale(0.5,0.5)
main.AnchorPoint = Vector2.new(0.5,0.5)
main.BackgroundColor3 = Color3.fromRGB(18,18,18)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0,R_MAIN)

local stroke = Instance.new("UIStroke", main)
stroke.Color = ACCENT
stroke.Thickness = 1

----------------------------------------------------------------
-- TITLE BAR
----------------------------------------------------------------
local titleBar = Instance.new("Frame", main)
titleBar.Size = UDim2.new(1,0,0,TITLE_HEIGHT)
titleBar.BackgroundColor3 = Color3.fromRGB(22,22,22)
titleBar.BorderSizePixel = 0
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0,R_SECTION)

local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(1,-90,1,0)
title.Position = UDim2.new(0,12,0,0)
title.BackgroundTransparency = 1
title.Text = "Kraken Hub"
title.Font = Enum.Font.GothamMedium
title.TextSize = 13
title.TextColor3 = ACCENT
title.TextXAlignment = Enum.TextXAlignment.Left

local function TitleBtn(txt,x)
	local b = Instance.new("TextButton", titleBar)
	b.Size = UDim2.fromOffset(26,22)
	b.Position = UDim2.new(1,x,0.5,-11)
	b.Text = txt
	b.Font = Enum.Font.GothamBold
	b.TextSize = 15
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(35,35,35)
	b.BorderSizePixel = 0
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,R_BUTTON)
	return b
end

local minimize = TitleBtn("-", -64)
local close = TitleBtn("X", -34)
close.BackgroundColor3 = Color3.fromRGB(90,40,40)

close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

----------------------------------------------------------------
-- SIDEBAR
----------------------------------------------------------------
local sidebar = Instance.new("Frame", main)
sidebar.Position = UDim2.new(0,0,0,TITLE_HEIGHT)
sidebar.Size = UDim2.fromOffset(130, MAIN_SIZE.Y - TITLE_HEIGHT)
sidebar.BackgroundColor3 = Color3.fromRGB(22,22,22)
sidebar.BorderSizePixel = 0
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0,R_SECTION)

local sideList = Instance.new("UIListLayout", sidebar)
sideList.Padding = UDim.new(0,6)
sideList.HorizontalAlignment = Enum.HorizontalAlignment.Center
sideList.VerticalAlignment = Enum.VerticalAlignment.Center

----------------------------------------------------------------
-- PAGES
----------------------------------------------------------------
local pages = Instance.new("Frame", main)
pages.Position = UDim2.fromOffset(130, TITLE_HEIGHT)
pages.Size = UDim2.new(1,-130,1,-TITLE_HEIGHT)
pages.BackgroundTransparency = 1

local Pages, Tabs = {}, {}

local function CreatePage(name)
	local s = Instance.new("ScrollingFrame", pages)
	s.Size = UDim2.fromScale(1,1)
	s.AutomaticCanvasSize = Enum.AutomaticSize.Y
	s.ScrollBarImageTransparency = 0.8
	s.BackgroundTransparency = 1
	s.Visible = false

	local pad = Instance.new("UIPadding", s)
	pad.PaddingTop = UDim.new(0,12)
	pad.PaddingLeft = UDim.new(0,12)
	pad.PaddingRight = UDim.new(0,12)

	local list = Instance.new("UIListLayout", s)
	list.Padding = UDim.new(0,10)

	Pages[name] = s
	return s
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
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,R_BUTTON)

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
-- REDZ STYLE TABS
----------------------------------------------------------------
local MainPage     = CreatePage("Main")
local PlayerPage   = CreatePage("Player")
local TeleportPage = CreatePage("Teleport")
local VisualsPage  = CreatePage("Visuals")
local GachaPage    = CreatePage("Gacha")
local MiscPage     = CreatePage("Misc")
local UIPage       = CreatePage("UI Settings")

CreateTab("Main")
CreateTab("Player")
CreateTab("Teleport")
CreateTab("Visuals")
CreateTab("Gacha")
CreateTab("Misc")
CreateTab("UI Settings")

Pages["Main"].Visible = true
Tabs["Main"].BackgroundColor3 = ACCENT_DARK

----------------------------------------------------------------
-- TOGGLE
----------------------------------------------------------------
local function CreateToggle(parent,text,default,callback)
	local h = Instance.new("Frame", parent)
	h.Size = UDim2.new(1,0,0,38)
	h.BackgroundColor3 = Color3.fromRGB(28,28,28)
	h.BorderSizePixel = 0
	Instance.new("UICorner", h).CornerRadius = UDim.new(0,R_TOGGLE)

	local l = Instance.new("TextLabel", h)
	l.Size = UDim2.new(1,-60,1,0)
	l.Position = UDim2.new(0,10,0,0)
	l.BackgroundTransparency = 1
	l.Text = text
	l.Font = Enum.Font.Gotham
	l.TextSize = 12
	l.TextColor3 = Color3.fromRGB(230,230,230)
	l.TextXAlignment = Enum.TextXAlignment.Left

	local bg = Instance.new("Frame", h)
	bg.Size = UDim2.fromOffset(36,18)
	bg.Position = UDim2.new(1,-48,0.5,-9)
	bg.BackgroundColor3 = default and ACCENT or Color3.fromRGB(70,70,70)
	bg.BorderSizePixel = 0
	Instance.new("UICorner", bg).CornerRadius = UDim.new(0,R_PILL)

	local k = Instance.new("Frame", bg)
	k.Size = UDim2.fromOffset(14,14)
	k.Position = default and UDim2.new(1,-16,0.5,-7) or UDim2.new(0,2,0.5,-7)
	k.BackgroundColor3 = Color3.new(1,1,1)
	k.BorderSizePixel = 0
	Instance.new("UICorner", k).CornerRadius = UDim.new(0,R_PILL)

	local state = default
	local function Set(v)
		state = v
		TweenService:Create(bg,TweenInfo.new(0.18),{
			BackgroundColor3 = state and ACCENT or Color3.fromRGB(70,70,70)
		}):Play()
		TweenService:Create(k,TweenInfo.new(0.18),{
			Position = state and UDim2.new(1,-16,0.5,-7) or UDim2.new(0,2,0.5,-7)
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
-- PLAYER ESP + NAME
----------------------------------------------------------------
local ESP = {}

local function AddESP(plr)
	if plr == lp then return end
	local function attach(char)
		if ESP[plr] then ESP[plr]:Destroy() end
		local h = Instance.new("Highlight", workspace)
		h.Adornee = char
		h.FillColor = ACCENT
		h.OutlineColor = Color3.new(1,1,1)
		h.Enabled = State.ESP
		ESP[plr] = h

		local head = char:WaitForChild("Head",5)
		if head then
			local bill = Instance.new("BillboardGui", head)
			bill.Size = UDim2.fromOffset(120,20)
			bill.StudsOffset = Vector3.new(0,2.6,0)
			bill.AlwaysOnTop = true
			bill.Enabled = State.ESP

			local t = Instance.new("TextLabel", bill)
			t.Size = UDim2.fromScale(1,1)
			t.BackgroundTransparency = 1
			t.Text = plr.DisplayName
			t.Font = Enum.Font.GothamBold
			t.TextSize = 12
			t.TextColor3 = Color3.new(1,1,1)
			t.TextStrokeTransparency = 0.2
		end
	end
	plr.CharacterAdded:Connect(attach)
	if plr.Character then attach(plr.Character) end
end

for _,p in ipairs(Players:GetPlayers()) do AddESP(p) end
Players.PlayerAdded:Connect(AddESP)

CreateToggle(PlayerPage,"Player ESP",false,function(v)
	State.ESP = v
	for _,h in pairs(ESP) do if h then h.Enabled = v end end
end)

----------------------------------------------------------------
-- MOVEMENT
----------------------------------------------------------------
CreateToggle(PlayerPage,"Fly",false,function(v)
	State.Fly = v
	lp.Character.Humanoid.PlatformStand = v
end)

CreateToggle(PlayerPage,"Noclip",false,function(v)
	State.Noclip = v
end)

CreateToggle(PlayerPage,"Infinite Jump",false,function(v)
	State.InfJump = v
end)

UIS.JumpRequest:Connect(function()
	if State.InfJump then
		lp.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
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
		hrp.CFrame += dir * 120 * dt
	end

	if State.Noclip then
		for _,v in ipairs(lp.Character:GetDescendants()) do
			if v:IsA("BasePart") then v.CanCollide = false end
		end
	end
end)
