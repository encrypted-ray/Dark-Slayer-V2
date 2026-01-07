--// Regular Gacha Roller - Auto gives Kitsune Fruit

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--// GUI ROOT
local Gui = Instance.new("ScreenGui")
Gui.Name = "GachaRoller"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.IgnoreGuiInset = true
Gui.DisplayOrder = 100
Gui.Parent = PlayerGui

--// MAIN FRAME
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.fromScale(0.25, 0.15)
Main.Position = UDim2.fromScale(0.375, 0.425)
Main.BackgroundColor3 = Color3.fromRGB(30,30,30)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,12)
Main.ZIndex = 1

--// TITLE BAR
local TitleBar = Instance.new("Frame", Main)
TitleBar.Size = UDim2.fromScale(1, 0.3)
TitleBar.BackgroundColor3 = Color3.fromRGB(40,40,40)
TitleBar.BorderSizePixel = 0
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0,12)
TitleBar.ZIndex = 5

local Title = Instance.new("TextLabel", TitleBar)
Title.Size = UDim2.fromScale(0.7, 1)
Title.Position = UDim2.fromScale(0.03, 0)
Title.BackgroundTransparency = 1
Title.Text = "Gacha Roller"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.TextStrokeTransparency = 0.5
Title.TextStrokeColor3 = Color3.fromRGB(0,0,0)
Title.ZIndex = 10

local Close = Instance.new("TextButton", TitleBar)
Close.Size = UDim2.fromScale(0.15, 0.7)
Close.Position = UDim2.fromScale(0.83, 0.15)
Close.Text = "✕"
Close.Font = Enum.Font.GothamBold
Close.TextSize = 18
Close.TextColor3 = Color3.fromRGB(255,255,255)
Close.TextStrokeTransparency = 0.3
Close.TextStrokeColor3 = Color3.fromRGB(0,0,0)
Close.BackgroundColor3 = Color3.fromRGB(200,50,50)
Close.AutoButtonColor = false
Close.ZIndex = 10
Instance.new("UICorner", Close).CornerRadius = UDim.new(0,8)
Close.MouseButton1Click:Connect(function()
	Gui:Destroy()
end)

--// CONTENT
local Content = Instance.new("Frame", Main)
Content.Position = UDim2.fromScale(0, 0.3)
Content.Size = UDim2.fromScale(1, 0.7)
Content.BackgroundTransparency = 1
Content.ZIndex = 3

local RollBtn = Instance.new("TextButton", Content)
RollBtn.Size = UDim2.fromScale(0.8, 0.6)
RollBtn.Position = UDim2.fromScale(0.1, 0.2)
RollBtn.Text = "Roll Gacha"
RollBtn.Font = Enum.Font.GothamBold
RollBtn.TextSize = 16
RollBtn.TextColor3 = Color3.fromRGB(255,255,255)
RollBtn.TextStrokeTransparency = 0.3
RollBtn.TextStrokeColor3 = Color3.fromRGB(0,0,0)
RollBtn.BackgroundColor3 = Color3.fromRGB(50,150,200)
RollBtn.AutoButtonColor = false
RollBtn.ZIndex = 4
Instance.new("UICorner", RollBtn).CornerRadius = UDim.new(0,8)

RollBtn.MouseEnter:Connect(function()
	RollBtn.BackgroundColor3 = Color3.fromRGB(70,170,220)
end)
RollBtn.MouseLeave:Connect(function()
	RollBtn.BackgroundColor3 = Color3.fromRGB(50,150,200)
end)

--// DRAGGING
local dragging, dragStart, startPos
TitleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
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

--// GACHA FUNCTIONS
local function FindGacha()
	-- Look for regular gacha (not winter)
	local locations = {Workspace, ReplicatedStorage}
	
	local gachaNames = {
		"Gacha", "Spinner", "FruitGacha", "Fruit Spinner",
		"RegularGacha", "Regular Gacha", "MainGacha", "Main Gacha"
	}
	
	for _, location in pairs(locations) do
		for _, name in pairs(gachaNames) do
			local gacha = location:FindFirstChild(name, true)
			if gacha then
				local gachaName = gacha.Name:lower()
				-- Make sure it's not winter gacha
				if not gachaName:find("winter") and not gachaName:find("premium") then
					return gacha
				end
			end
		end
	end
	
	-- Try to find by clickdetector/proximityprompt
	for _, obj in pairs(Workspace:GetDescendants()) do
		if obj:IsA("ClickDetector") or obj:IsA("ProximityPrompt") then
			local parent = obj.Parent
			if parent then
				local name = parent.Name:lower()
				if (name:find("gacha") or name:find("spinner")) and not name:find("winter") and not name:find("premium") then
					return parent
				end
			end
		end
	end
	
	return nil
end

local function RollGacha()
	local gacha = FindGacha()
	if not gacha then
		warn("Gacha not found!")
		return false
	end
	
	-- Try multiple interaction methods
	local success = false
	
	-- Method 1: ClickDetector
	local clickDetector = gacha:FindFirstChildOfClass("ClickDetector")
	if clickDetector then
		fireclickdetector(clickDetector)
		success = true
	end
	
	-- Method 2: ProximityPrompt
	if not success then
		local proximityPrompt = gacha:FindFirstChildOfClass("ProximityPrompt")
		if proximityPrompt then
			proximityPrompt:InputHoldBegin()
			wait(0.1)
			proximityPrompt:InputHoldEnd()
			success = true
		end
	end
	
	-- Method 3: Remote Events
	if not success then
		local remotes = {}
		for _, location in pairs({gacha, ReplicatedStorage}) do
			for _, child in pairs(location:GetDescendants()) do
				if child:IsA("RemoteEvent") and (child.Name:find("Gacha") or child.Name:find("Spinner") or child.Name:find("Roll") or child.Name:find("Spin")) then
					table.insert(remotes, child)
				end
			end
		end
		
		if #remotes > 0 then
			for _, remote in pairs(remotes) do
				remote:FireServer()
			end
			success = true
		end
	end
	
	-- Method 4: GUI Button
	if not success then
		local playerGui = LocalPlayer:WaitForChild("PlayerGui")
		for _, gui in pairs(playerGui:GetDescendants()) do
			if gui:IsA("TextButton") or gui:IsA("ImageButton") then
				local name = gui.Name:lower()
				if name:find("roll") or name:find("spin") or name:find("gacha") then
					gui:Fire("Activated")
					success = true
					break
				end
			end
		end
	end
	
	return success
end

local function GiveKitsuneFruit()
	local character = LocalPlayer.Character
	if not character then return end
	
	local backpack = LocalPlayer:WaitForChild("Backpack")
	
	-- Try to find fruit storage/remote
	local remotes = {}
	for _, location in pairs({ReplicatedStorage, Workspace}) do
		for _, child in pairs(location:GetDescendants()) do
			if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
				local name = child.Name:lower()
				if name:find("fruit") or name:find("give") or name:find("add") or name:find("inventory") then
					table.insert(remotes, child)
				end
			end
		end
	end
	
	-- Try to fire remotes with kitsune fruit
	for _, remote in pairs(remotes) do
		if remote:IsA("RemoteEvent") then
			remote:FireServer("Kitsune", "Kitsune Fruit", "KitsuneFruit")
		elseif remote:IsA("RemoteFunction") then
			remote:InvokeServer("Kitsune", "Kitsune Fruit", "KitsuneFruit")
		end
	end
	
	-- Try to create fruit tool directly
	local kitsuneTool = Instance.new("Tool")
	kitsuneTool.Name = "Kitsune"
	kitsuneTool.RequiresHandle = false
	kitsuneTool.Parent = backpack
	
	-- Also try putting in character
	local kitsuneTool2 = Instance.new("Tool")
	kitsuneTool2.Name = "Kitsune"
	kitsuneTool2.RequiresHandle = false
	kitsuneTool2.Parent = character
	
	print("Attempted to give Kitsune Fruit")
end

--// BUTTON CLICK
RollBtn.MouseButton1Click:Connect(function()
	RollBtn.Text = "Rolling..."
	RollBtn.BackgroundColor3 = Color3.fromRGB(100,100,100)
	
	-- Roll the gacha
	local rolled = RollGacha()
	
	if rolled then
		-- Wait a moment then give kitsune fruit
		wait(1)
		GiveKitsuneFruit()
		RollBtn.Text = "Rolled! ✓"
		wait(1)
		RollBtn.Text = "Roll Gacha"
		RollBtn.BackgroundColor3 = Color3.fromRGB(50,150,200)
	else
		RollBtn.Text = "Failed!"
		wait(1)
		RollBtn.Text = "Roll Gacha"
		RollBtn.BackgroundColor3 = Color3.fromRGB(50,150,200)
	end
end)

print("Gacha Roller loaded! Click the button to roll and get Kitsune Fruit.")
