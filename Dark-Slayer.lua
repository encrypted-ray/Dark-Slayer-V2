-- DARK SLAYER V2 (MODERN UI + WINTER GACHA)
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
	TimerOn = false,
	TimeLeft = 0,
	-- Winter Gacha
	AutoWinter = false,
	StopMyth = false,
	CandyCost = 100
}

-- CLEANUP
if CoreGui:FindFirstChild("DarkSlayerModern") then
	CoreGui.DarkSlayerModern:Destroy()
end

-- GUI ROOT
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "DarkSlayerModern"
gui.ResetOnSpawn = false

-- MAIN FRAME
local main = Instance.new("Frame", gui)
main.Size = UDim2.fromScale(0.28, 0.52)
main.Position = UDim2.fromScale(0.36, 0.24)
main.BackgroundColor3 = Color3.fromRGB(18,18,18)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0,16)
local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(70,70,70)
stroke.Thickness = 1.5

-- TITLE
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,45)
title.BackgroundTransparency = 1
title.Text = "DARK SLAYER V2"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.new(1,1,1)

-- CONTAINER
local container = Instance.new("Frame", main)
container.Position = UDim2.fromOffset(10,50)
container.Size = UDim2.new(1,-20,1,-60)
container.BackgroundTransparency = 1
local list = Instance.new("UIListLayout", container)
list.Padding = UDim.new(0,8)

-- BUTTON CREATOR
local function Button(text, color)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1,0,0,38)
	b.BackgroundColor3 = color or Color3.fromRGB(30,30,30)
	b.Text = text
	b.Font = Enum.Font.GothamMedium
	b.TextSize = 14
	b.TextColor3 = Color3.new(1,1,1)
	b.AutoButtonColor = false
	b.BorderSizePixel = 0
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)
	b.Parent = container
	return b
end

-- MAIN BUTTONS
local espBtn     = Button("ESP : OFF", Color3.fromRGB(90,30,30))
local flyBtn     = Button("FLY : OFF")
local noclipBtn  = Button("NOCLIP : OFF")
local speedBtn   = Button("SPEED : OFF")
local jumpBtn    = Button("INF JUMP : OFF")
local freezeBtn  = Button("FREEZE : OFF", Color3.fromRGB(30,60,120))
local hopBtn     = Button("SERVER HOP", Color3.fromRGB(120,40,40))
local shutdown   = Button("SHUTDOWN", Color3.fromRGB(40,40,40))

-- TIMER
local timerLabel = Instance.new("TextLabel", container)
timerLabel.Size = UDim2.new(1,0,0,30)
timerLabel.BackgroundTransparency = 1
timerLabel.Text = "00:00"
timerLabel.Font = Enum.Font.GothamBold
timerLabel.TextSize = 16
timerLabel.TextColor3 = Color3.new(1,1,1)

local timeBox = Instance.new("TextBox", container)
timeBox.Size = UDim2.new(1,0,0,30)
timeBox.Text = "60"
timeBox.Font = Enum.Font.Gotham
timeBox.TextSize = 14
timeBox.BackgroundColor3 = Color3.fromRGB(25,25,25)
timeBox.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", timeBox)

local startBtn = Button("START TIMER", Color3.fromRGB(30,90,30))

-- BASES TELEPORT
local bases = {
	Vector3.new(-210,-11,-201), Vector3.new(-209,-11,-58), 
	Vector3.new(-209,-11,84), Vector3.new(179,-11,85), 
	Vector3.new(179,-11,-58), Vector3.new(180,-11,-201)
}
for i, pos in pairs(bases) do
	local b = Button("B"..i)
	b.MouseButton1Click:Connect(function() 
		if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
			lp.Character.HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0,5,0)) 
		end
	end)
end

-- ESP LOGIC
local Highlights = {}
local function ApplyESP(p)
	if p == lp then return end
	local function setup(char)
		if Highlights[p] then Highlights[p]:Destroy() end
		local h = Instance.new("Highlight")
		h.FillColor = Color3.fromRGB(255,70,70)
		h.OutlineColor = Color3.new(1,1,1)
		h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		h.Adornee = char
		h.Enabled = State.ESP
		h.Parent = char
		Highlights[p] = h
	end
	p.CharacterAdded:Connect(setup)
	if p.Character then setup(p.Character) end
end
for _,p in ipairs(Players:GetPlayers()) do ApplyESP(p) end
Players.PlayerAdded:Connect(ApplyESP)

-- LOOPS
RunService.Heartbeat:Connect(function(dt)
	if not lp.Character then return end
	local hrp = lp.Character:FindFirstChild("HumanoidRootPart")
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
		hrp.AssemblyLinearVelocity = Vector3.zero
		hrp.CFrame += dir * State.FlySpeed * dt
	end

	if State.Noclip then
		for _,v in ipairs(lp.Character:GetDescendants()) do
			if v:IsA("BasePart") then v.CanCollide = false end
		end
	end
end)

-- TIMER LOOP
task.spawn(function()
	while task.wait(1) do
		if State.TimerOn and State.TimeLeft > 0 then
			State.TimeLeft -= 1
			timerLabel.Text = string.format("%02d:%02d", math.floor(State.TimeLeft/60), State.TimeLeft%60)
		end
	end
end)

-- BUTTON LOGIC
espBtn.MouseButton1Click:Connect(function()
	State.ESP = not State.ESP
	espBtn.Text = "ESP : " .. (State.ESP and "ON" or "OFF")
	for _,h in pairs(Highlights) do if h then h.Enabled = State.ESP end end
end)
flyBtn.MouseButton1Click:Connect(function()
	State.Fly = not State.Fly
	flyBtn.Text = "FLY : " .. (State.Fly and "ON" or "OFF")
	local hum = lp.Character:FindFirstChildOfClass("Humanoid")
	if hum then hum.PlatformStand = State.Fly end
end)
noclipBtn.MouseButton1Click:Connect(function()
	State.Noclip = not State.Noclip
	noclipBtn.Text = "NOCLIP : " .. (State.Noclip and "ON" or "OFF")
end)
speedBtn.MouseButton1Click:Connect(function()
	local hum = lp.Character:FindFirstChildOfClass("Humanoid")
	if not hum then return end
	hum.WalkSpeed = hum.WalkSpeed == 16 and 100 or 16
	speedBtn.Text = "SPEED : " .. (hum.WalkSpeed > 16 and "ON" or "OFF")
end)
jumpBtn.MouseButton1Click:Connect(function()
	State.InfJump = not State.InfJump
	jumpBtn.Text = "INF JUMP : " .. (State.InfJump and "ON" or "OFF")
end)
UIS.JumpRequest:Connect(function()
	if State.InfJump then
		local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
		if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
	end
end)
freezeBtn.MouseButton1Click:Connect(function()
	State.Frozen = not State.Frozen
	State.FrozenCFrame = State.Frozen and lp.Character.HumanoidRootPart.CFrame or nil
	freezeBtn.Text = "FREEZE : " .. (State.Frozen and "ON" or "OFF")
end)
startBtn.MouseButton1Click:Connect(function()
	State.TimeLeft = tonumber(timeBox.Text) or 0
	State.TimerOn = not State.TimerOn
	startBtn.Text = State.TimerOn and "STOP TIMER" or "START TIMER"
end)
hopBtn.MouseButton1Click:Connect(function()
	local url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?limit=100"
	local data = HttpService:JSONDecode(game:HttpGet(url)).data
	for _,v in pairs(data) do
		if v.playing < v.maxPlayers and v.id ~= game.JobId then
			TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id)
			break
		end
	end
end)
shutdown.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

-- ===== WINTER GACHA CATEGORY =====
local gachaLabel = Instance.new("TextLabel", container)
gachaLabel.Text = "❄ WINTER GACHA"
gachaLabel.Font = Enum.Font.GothamBold
gachaLabel.TextSize = 16
gachaLabel.TextColor3 = Color3.fromRGB(180,180,255)
gachaLabel.BackgroundTransparency = 1
gachaLabel.Size = UDim2.new(1,0,0,30)

local autoGachaBtn = Button("AUTO-ROLL: OFF", Color3.fromRGB(25,100,200))
local stopMythBtn  = Button("STOP ON MYTHICAL: OFF", Color3.fromRGB(25,80,180))

autoGachaBtn.MouseButton1Click:Connect(function()
	State.AutoWinter = not State.AutoWinter
	autoGachaBtn.Text = "AUTO-ROLL: "..(State.AutoWinter and "ON" or "OFF")
end)
stopMythBtn.MouseButton1Click:Connect(function()
	State.StopMyth = not State.StopMyth
	stopMythBtn.Text = "STOP ON MYTHICAL: "..(State.StopMyth and "ON" or "OFF")
end)

-- WINTER GACHA LOOP
task.spawn(function()
	while task.wait(1) do
		if State.AutoWinter then
			-- trigger gacha roll
			pcall(function()
				ReplicatedStorage.Remotes.RollWinterGacha:FireServer(State.CandyCost)
			end)

			-- wait for server result
			local result = ReplicatedStorage.Remotes.GachaResult.OnClientEvent:Wait()

			-- check for mythical
			if State.StopMyth and result.Rarity == "Mythical" then
				State.AutoWinter = false
				autoGachaBtn.Text = "AUTO-ROLL: OFF"
				break
			end
		end
	end
end)
