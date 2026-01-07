--// Winter Gacha Auto Roll Script
-- Stops at Premium Spinner Box, then Ember Dragon

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--// STATE
local State = {
	Rolling = false,
	TargetIndex = 1, -- 1 = Premium Spinner Box, 2 = Ember Dragon
}

--// GUI ROOT
local Gui = Instance.new("ScreenGui")
Gui.Name = "GachaRoller"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui

--// MAIN FRAME
local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.fromScale(0.3, 0.2)
Main.Position = UDim2.fromScale(0.35, 0.4)
Main.BackgroundColor3 = Color3.fromRGB(30,30,30)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,12)
Main.ZIndex = 1

--// TITLE BAR
local TitleBar = Instance.new("Frame", Main)
TitleBar.Size = UDim2.fromScale(1, 0.25)
TitleBar.BackgroundColor3 = Color3.fromRGB(40,40,40)
TitleBar.BorderSizePixel = 0
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0,12)
TitleBar.ZIndex = 5

local Title = Instance.new("TextLabel", TitleBar)
Title.Size = UDim2.fromScale(0.7, 1)
Title.Position = UDim2.fromScale(0.03, 0)
Title.BackgroundTransparency = 1
Title.Text = "Winter Gacha Roller"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.ZIndex = 10

local Close = Instance.new("TextButton", TitleBar)
Close.Size = UDim2.fromScale(0.15, 0.7)
Close.Position = UDim2.fromScale(0.83, 0.15)
Close.Text = "✕"
Close.Font = Enum.Font.GothamBold
Close.TextSize = 18
Close.TextColor3 = Color3.fromRGB(255,255,255)
Close.BackgroundColor3 = Color3.fromRGB(200,50,50)
Close.AutoButtonColor = false
Close.ZIndex = 10
Instance.new("UICorner", Close).CornerRadius = UDim.new(0,8)
Close.MouseButton1Click:Connect(function()
	Gui:Destroy()
end)

--// CONTENT
local Content = Instance.new("Frame", Main)
Content.Position = UDim2.fromScale(0, 0.25)
Content.Size = UDim2.fromScale(1, 0.75)
Content.BackgroundTransparency = 1
Content.ZIndex = 3

local StatusLabel = Instance.new("TextLabel", Content)
StatusLabel.Size = UDim2.fromScale(0.9, 0.3)
StatusLabel.Position = UDim2.fromScale(0.05, 0.1)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Ready"
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 14
StatusLabel.TextColor3 = Color3.fromRGB(200,200,200)
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.ZIndex = 4

local ToggleBtn = Instance.new("TextButton", Content)
ToggleBtn.Size = UDim2.fromScale(0.4, 0.35)
ToggleBtn.Position = UDim2.fromScale(0.05, 0.5)
ToggleBtn.Text = "Start Rolling"
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 14
ToggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(50,200,100)
ToggleBtn.AutoButtonColor = false
ToggleBtn.ZIndex = 4
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0,8)

ToggleBtn.MouseButton1Click:Connect(function()
	State.Rolling = not State.Rolling
	if State.Rolling then
		ToggleBtn.Text = "Stop Rolling"
		ToggleBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
		StatusLabel.Text = "Status: Rolling..."
	else
		ToggleBtn.Text = "Start Rolling"
		ToggleBtn.BackgroundColor3 = Color3.fromRGB(50,200,100)
		StatusLabel.Text = "Status: Stopped"
	end
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

--// GACHA ROLLING FUNCTION
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function FindGacha()
	-- Look for winter gacha in workspace and other locations
	local locations = {Workspace, ReplicatedStorage, game:GetService("StarterGui")}
	
	-- Common names for gacha
	local gachaNames = {
		"WinterGacha", "Winter Gacha", "WinterGachaModel",
		"Gacha", "Spinner", "PremiumSpinner", "Premium Spinner",
		"WinterSpinner", "Winter Spinner"
	}
	
	for _, location in pairs(locations) do
		for _, name in pairs(gachaNames) do
			local gacha = location:FindFirstChild(name, true)
			if gacha then
				return gacha
			end
		end
	end
	
	-- Try to find by looking for spinner/clickdetector with winter/gacha keywords
	for _, obj in pairs(Workspace:GetDescendants()) do
		if obj:IsA("ClickDetector") or obj:IsA("ProximityPrompt") then
			local parent = obj.Parent
			if parent then
				local name = parent.Name:lower()
				if name:find("gacha") or name:find("spinner") or name:find("winter") then
					return parent
				end
			end
		end
	end
	
	return nil
end

local function RollGacha()
	if not State.Rolling then return end
	
	local gacha = FindGacha()
	if not gacha then
		StatusLabel.Text = "Status: Gacha not found! Look for it in game."
		return false
	end
	
	-- Try multiple interaction methods
	local success = false
	
	-- Method 1: ClickDetector
	local clickDetector = gacha:FindFirstChildOfClass("ClickDetector")
	if clickDetector then
		fireclickdetector(clickDetector)
		StatusLabel.Text = "Status: Clicked gacha"
		success = true
	end
	
	-- Method 2: ProximityPrompt
	if not success then
		local proximityPrompt = gacha:FindFirstChildOfClass("ProximityPrompt")
		if proximityPrompt then
			proximityPrompt:InputHoldBegin()
			wait(0.1)
			proximityPrompt:InputHoldEnd()
			StatusLabel.Text = "Status: Triggered prompt"
			success = true
		end
	end
	
	-- Method 3: Remote Events (check ReplicatedStorage too)
	if not success then
		local remotes = {}
		for _, location in pairs({gacha, ReplicatedStorage}) do
			for _, child in pairs(location:GetDescendants()) do
				if child:IsA("RemoteEvent") and (child.Name:find("Gacha") or child.Name:find("Spinner") or child.Name:find("Roll")) then
					table.insert(remotes, child)
				end
			end
		end
		
		if #remotes > 0 then
			for _, remote in pairs(remotes) do
				remote:FireServer()
			end
			StatusLabel.Text = "Status: Fired remote"
			success = true
		end
	end
	
	-- Method 4: Try to find and click GUI button
	if not success then
		local playerGui = LocalPlayer:WaitForChild("PlayerGui")
		for _, gui in pairs(playerGui:GetDescendants()) do
			if gui:IsA("TextButton") or gui:IsA("ImageButton") then
				local name = gui.Name:lower()
				if name:find("roll") or name:find("spin") or name:find("gacha") then
					gui:Fire("Activated")
					StatusLabel.Text = "Status: Clicked GUI button"
					success = true
					break
				end
			end
		end
	end
	
	if not success then
		StatusLabel.Text = "Status: Could not interact with gacha"
	end
	
	return success
end

local function CheckCurrentItem()
	-- Check PlayerGui for current gacha item display
	local playerGui = LocalPlayer:WaitForChild("PlayerGui")
	
	local targetNames = {
		[1] = {"premium", "spinner", "box"},
		[2] = {"ember", "dragon"}
	}
	
	local currentTarget = targetNames[State.TargetIndex]
	if not currentTarget then return false end
	
	-- Look in GUI for text showing current item
	for _, gui in pairs(playerGui:GetDescendants()) do
		if gui:IsA("TextLabel") or gui:IsA("TextButton") then
			local text = gui.Text:lower()
			local allMatch = true
			for _, targetWord in pairs(currentTarget) do
				if not text:find(targetWord:lower()) then
					allMatch = false
					break
				end
			end
			if allMatch and text ~= "" then
				return true
			end
		end
	end
	
	-- Also check workspace for highlighted parts
	for _, obj in pairs(Workspace:GetDescendants()) do
		if obj:IsA("Part") or obj:IsA("MeshPart") then
			local name = obj.Name:lower()
			local allMatch = true
			for _, targetWord in pairs(currentTarget) do
				if not name:find(targetWord:lower()) then
					allMatch = false
					break
				end
			end
			if allMatch then
				-- Check if highlighted (bright material or low transparency)
				if obj.Material ~= Enum.Material.SmoothPlastic or obj.Transparency < 0.5 then
					return true
				end
			end
		end
	end
	
	return false
end

--// MAIN LOOP
local lastRollTime = 0
local checkingTarget = false

RunService.Heartbeat:Connect(function()
	if State.Rolling and not checkingTarget then
		local currentTime = tick()
		
		-- Roll every 3 seconds (give time for spinner to stop)
		if currentTime - lastRollTime > 3 then
			RollGacha()
			lastRollTime = currentTime
			
			-- Wait a bit then check if we're at target
			checkingTarget = true
			spawn(function()
				wait(2) -- Wait for spinner to potentially stop
				
				if CheckCurrentItem() then
					-- We hit the target!
					local targetNames = {
						[1] = "Premium Spinner Box",
						[2] = "Ember Dragon"
					}
					StatusLabel.Text = "Status: Got " .. (targetNames[State.TargetIndex] or "Target") .. "!"
					
					-- Move to next target
					State.TargetIndex = State.TargetIndex + 1
					if State.TargetIndex > 2 then
						State.TargetIndex = 1 -- Loop back
					end
					
					-- Auto continue after 1 second
					wait(1)
					if State.Rolling then
						StatusLabel.Text = "Status: Rolling for next target..."
					end
				else
					StatusLabel.Text = "Status: Rolling... (not at target yet)"
				end
				
				checkingTarget = false
			end)
		end
	end
end)

print("Winter Gacha Roller loaded! Open the GUI to start.")
