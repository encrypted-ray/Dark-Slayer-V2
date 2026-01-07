-- Blox Fruits: Give Mythical Fruit Button
-- This script creates a GUI button that gives the player a random mythical fruit

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MythicalFruitGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Create main frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 200, 0, 60)
mainFrame.Position = UDim2.new(0.5, -100, 0, 20)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Add corner radius
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- Add stroke
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(100, 50, 200)
stroke.Thickness = 2
stroke.Parent = mainFrame

-- Create button
local button = Instance.new("TextButton")
button.Name = "GiveMythicalFruitButton"
button.Size = UDim2.new(1, -10, 1, -10)
button.Position = UDim2.new(0, 5, 0, 5)
button.BackgroundColor3 = Color3.fromRGB(100, 50, 200)
button.Text = "Give Mythical Fruit"
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextSize = 16
button.Font = Enum.Font.GothamBold
button.BorderSizePixel = 0
button.Parent = mainFrame

-- Add button corner
local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 6)
buttonCorner.Parent = button

-- Button hover effect
button.MouseEnter:Connect(function()
    local tween = TweenService:Create(button, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(120, 70, 220)
    })
    tween:Play()
end)

button.MouseLeave:Connect(function()
    local tween = TweenService:Create(button, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(100, 50, 200)
    })
    tween:Play()
end)

-- List of mythical fruits in Blox Fruits
local mythicalFruits = {
    "Dough",
    "Shadow",
    "Control",
    "Venom",
    "Spirit",
    "Dragon",
    "Leopard",
    "Kitsune",
    "T-Rex",
    "Mammoth"
}

-- Function to find and use the fruit store remote
local function giveMythicalFruit()
    local success = false
    local fruitGiven = mythicalFruits[math.random(1, #mythicalFruits)]
    
    -- Try to find the fruit store remote
    local function tryGiveFruit()
        -- Method 1: Try ReplicatedStorage remotes
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            local storeFruit = remotes:FindFirstChild("StoreFruit") or remotes:FindFirstChild("PurchaseFruit") or remotes:FindFirstChild("BuyFruit")
            if storeFruit then
                storeFruit:FireServer(fruitGiven)
                success = true
                return
            end
        end
        
        -- Method 2: Try direct remote in ReplicatedStorage
        local directRemote = ReplicatedStorage:FindFirstChild("StoreFruit") or 
                           ReplicatedStorage:FindFirstChild("PurchaseFruit") or
                           ReplicatedStorage:FindFirstChild("BuyFruit")
        if directRemote then
            directRemote:FireServer(fruitGiven)
            success = true
            return
        end
        
        -- Method 3: Try _G functions (common in executors)
        if _G.StoreFruit then
            _G.StoreFruit(fruitGiven)
            success = true
            return
        end
        
        -- Method 4: Try to find in workspace
        local wsRemotes = workspace:FindFirstChild("Remotes")
        if wsRemotes then
            local storeFruit = wsRemotes:FindFirstChild("StoreFruit") or wsRemotes:FindFirstChild("PurchaseFruit")
            if storeFruit then
                storeFruit:FireServer(fruitGiven)
                success = true
                return
            end
        end
        
        -- Method 5: Try to use game's fruit module if available
        local modules = ReplicatedStorage:FindFirstChild("Modules")
        if modules then
            local fruitModule = modules:FindFirstChild("Fruit") or modules:FindFirstChild("FruitStore")
            if fruitModule then
                local fruitModuleScript = require(fruitModule)
                if fruitModuleScript and fruitModuleScript.StoreFruit then
                    fruitModuleScript.StoreFruit(fruitGiven)
                    success = true
                    return
                end
            end
        end
    end
    
    -- Try to give the fruit
    pcall(tryGiveFruit)
    
    -- Update button text based on result
    if success then
        button.Text = "Fruit Given: " .. fruitGiven
        wait(2)
        button.Text = "Give Mythical Fruit"
    else
        -- If direct method fails, try to add to inventory directly
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        
        -- Try to find player data
        local function tryDirectInventory()
            -- Check if there's a player data folder
            local playerData = player:FindFirstChild("PlayerData") or player:FindFirstChild("Data")
            if playerData then
                local fruits = playerData:FindFirstChild("Fruits") or playerData:FindFirstChild("Inventory")
                if fruits then
                    -- Try to add fruit to inventory
                    local fruitValue = Instance.new("StringValue")
                    fruitValue.Name = fruitGiven
                    fruitValue.Value = fruitGiven
                    fruitValue.Parent = fruits
                    success = true
                end
            end
        end
        
        pcall(tryDirectInventory)
        
        if success then
            button.Text = "Fruit Added: " .. fruitGiven
            wait(2)
            button.Text = "Give Mythical Fruit"
        else
            button.Text = "Failed - Check Console"
            warn("Could not find fruit store remote. Fruit: " .. fruitGiven)
            wait(2)
            button.Text = "Give Mythical Fruit"
        end
    end
end

-- Connect button click
button.MouseButton1Click:Connect(function()
    button.Text = "Giving Fruit..."
    button.Active = false
    
    giveMythicalFruit()
    
    wait(0.5)
    button.Active = true
end)

print("Mythical Fruit GUI loaded! Click the button to get a random mythical fruit.")
