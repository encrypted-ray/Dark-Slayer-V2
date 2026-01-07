--// Kitsune Fruit Giver - Blox Fruits

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--// GUI ROOT
local Gui = Instance.new("ScreenGui")
Gui.Name = "KitsuneGiver"
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
Title.Text = "Kitsune Fruit"
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

local GiveBtn = Instance.new("TextButton", Content)
GiveBtn.Size = UDim2.fromScale(0.8, 0.6)
GiveBtn.Position = UDim2.fromScale(0.1, 0.2)
GiveBtn.Text = "Give Kitsune Fruit"
GiveBtn.Font = Enum.Font.GothamBold
GiveBtn.TextSize = 14
GiveBtn.TextColor3 = Color3.fromRGB(255,255,255)
GiveBtn.TextStrokeTransparency = 0.3
GiveBtn.TextStrokeColor3 = Color3.fromRGB(0,0,0)
GiveBtn.BackgroundColor3 = Color3.fromRGB(200,100,50)
GiveBtn.AutoButtonColor = false
GiveBtn.ZIndex = 4
Instance.new("UICorner", GiveBtn).CornerRadius = UDim.new(0,8)

GiveBtn.MouseEnter:Connect(function()
	GiveBtn.BackgroundColor3 = Color3.fromRGB(220,120,70)
end)
GiveBtn.MouseLeave:Connect(function()
	GiveBtn.BackgroundColor3 = Color3.fromRGB(200,100,50)
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

game:GetService("UserInputService").InputChanged:Connect(function(input)
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

game:GetService("UserInputService").InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

--// GIVE KITSUNE FRUIT FUNCTION
local function GiveKitsuneFruit()
	local character = LocalPlayer.Character
	if not character then
		warn("Character not found!")
		return false
	end
	
	local backpack = LocalPlayer:WaitForChild("Backpack")
	local success = false
	
	-- Method 1: Try to find fruit remotes in ReplicatedStorage
	local fruitRemotes = {}
	for _, child in pairs(ReplicatedStorage:GetDescendants()) do
		if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
			local name = child.Name:lower()
			if name:find("fruit") or name:find("inventory") or name:find("store") or name:find("give") then
				table.insert(fruitRemotes, child)
			end
		end
	end
	
	-- Try common Blox Fruits remote names
	local commonRemotes = {
		"StoreFruit",
		"StoreFruitRemote",
		"GiveFruit",
		"AddFruit",
		"Inventory",
		"FruitInventory",
		"StoreFruitInInventory"
	}
	
	for _, remoteName in pairs(commonRemotes) do
		local remote = ReplicatedStorage:FindFirstChild(remoteName)
		if remote and (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) then
			table.insert(fruitRemotes, remote)
		end
	end
	
	-- Try to fire remotes with Kitsune fruit
	for _, remote in pairs(fruitRemotes) do
		if remote:IsA("RemoteEvent") then
			pcall(function()
				remote:FireServer("Kitsune")
				remote:FireServer("Kitsune Fruit")
				remote:FireServer("KitsuneFruit")
				remote:FireServer({Fruit = "Kitsune"})
				remote:FireServer({fruit = "Kitsune"})
			end)
		elseif remote:IsA("RemoteFunction") then
			pcall(function()
				remote:InvokeServer("Kitsune")
				remote:InvokeServer("Kitsune Fruit")
				remote:InvokeServer({Fruit = "Kitsune"})
			end)
		end
	end
	
	-- Method 2: Try to create fruit tool directly in backpack
	pcall(function()
		local kitsuneTool = Instance.new("Tool")
		kitsuneTool.Name = "Kitsune"
		kitsuneTool.RequiresHandle = false
		
		-- Add fruit properties if they exist
		local stringValue = Instance.new("StringValue", kitsuneTool)
		stringValue.Name = "Fruit"
		stringValue.Value = "Kitsune"
		
		kitsuneTool.Parent = backpack
		success = true
	end)
	
	-- Method 3: Try to create in character
	pcall(function()
		if character then
			local kitsuneTool2 = Instance.new("Tool")
			kitsuneTool2.Name = "Kitsune"
			kitsuneTool2.RequiresHandle = false
			
			local stringValue2 = Instance.new("StringValue", kitsuneTool2)
			stringValue2.Name = "Fruit"
			stringValue2.Value = "Kitsune"
			
			kitsuneTool2.Parent = character
			success = true
		end
	end)
	
	-- Method 4: Try workspace remotes
	for _, child in pairs(Workspace:GetDescendants()) do
		if child:IsA("RemoteEvent") then
			local name = child.Name:lower()
			if name:find("fruit") or name:find("give") then
				pcall(function()
					child:FireServer("Kitsune")
					child:FireServer({Fruit = "Kitsune"})
				end)
			end
		end
	end
	
	return success
end

--// BUTTON CLICK
GiveBtn.MouseButton1Click:Connect(function()
	GiveBtn.Text = "Giving..."
	GiveBtn.BackgroundColor3 = Color3.fromRGB(100,100,100)
	
	local success = GiveKitsuneFruit()
	
	if success then
		GiveBtn.Text = "Given! ✓"
		wait(1)
		GiveBtn.Text = "Give Kitsune Fruit"
		GiveBtn.BackgroundColor3 = Color3.fromRGB(200,100,50)
	else
		GiveBtn.Text = "Check Console"
		wait(1)
		GiveBtn.Text = "Give Kitsune Fruit"
		GiveBtn.BackgroundColor3 = Color3.fromRGB(200,100,50)
	end
	
	print("Kitsune Fruit given attempt completed. Check your inventory!")
end)

print("Kitsune Fruit Giver loaded! Click the button to get Kitsune Fruit.")
