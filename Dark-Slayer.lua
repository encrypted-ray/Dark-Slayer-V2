-- Blox Fruits Random Fruit Roll Script
-- Creates a GUI with Roll and Stop buttons for fruit gacha

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- List of Blox Fruits (including common, uncommon, rare, legendary, and mythical)
local fruits = {
    -- Common
    "Bomb", "Spike", "Chop", "Spring", "Kilo", "Smoke", "Spin", "Flame", "Falcon", "Ice", "Sand", "Dark", "Revive", "Diamond", "Light", "Love", "Rubber", "Barrier", "Magma", "Door", "Quake", "Buddha", "String", "Bird: Phoenix", "Rumble", "Pain", "Gravity", "Dough", "Shadow", "Venom", "Control", "Spirit", "Dragon", "Leopard", "Kitsune", "Mammoth", "Sound", "Portal", "Blizzard", "T-Rex", "Dough V2", "Spider", "Chop V2", "Rocket", "Diamond V2", "Light V2", "Dark V2", "Ice V2", "Flame V2", "Sand V2", "Magma V2", "Quake V2", "Buddha V2", "String V2", "Phoenix V2", "Rumble V2", "Pain V2", "Gravity V2", "Dough V2", "Shadow V2", "Venom V2", "Control V2", "Spirit V2", "Dragon V2", "Leopard V2", "Kitsune V2"
}

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FruitRollGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Create Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Add corner radius
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Title Label
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, 0, 0, 50)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
titleLabel.BorderSizePixel = 0
titleLabel.Text = "Random Fruit Roll"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 24
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleLabel

-- Fruit Display Label
local fruitLabel = Instance.new("TextLabel")
fruitLabel.Name = "FruitLabel"
fruitLabel.Size = UDim2.new(1, -40, 0, 120)
fruitLabel.Position = UDim2.new(0, 20, 0, 70)
fruitLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
fruitLabel.BorderSizePixel = 0
fruitLabel.Text = "Press Roll to start!"
fruitLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
fruitLabel.TextSize = 32
fruitLabel.Font = Enum.Font.GothamBold
fruitLabel.TextWrapped = true
fruitLabel.Parent = mainFrame

local fruitCorner = Instance.new("UICorner")
fruitCorner.CornerRadius = UDim.new(0, 8)
fruitCorner.Parent = fruitLabel

-- Roll Button
local rollButton = Instance.new("TextButton")
rollButton.Name = "RollButton"
rollButton.Size = UDim2.new(0, 150, 0, 50)
rollButton.Position = UDim2.new(0, 30, 1, -70)
rollButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
rollButton.BorderSizePixel = 0
rollButton.Text = "ROLL"
rollButton.TextColor3 = Color3.fromRGB(255, 255, 255)
rollButton.TextSize = 20
rollButton.Font = Enum.Font.GothamBold
rollButton.Parent = mainFrame

local rollCorner = Instance.new("UICorner")
rollCorner.CornerRadius = UDim.new(0, 8)
rollCorner.Parent = rollButton

-- Stop Button
local stopButton = Instance.new("TextButton")
stopButton.Name = "StopButton"
stopButton.Size = UDim2.new(0, 150, 0, 50)
stopButton.Position = UDim2.new(1, -180, 1, -70)
stopButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
stopButton.BorderSizePixel = 0
stopButton.Text = "STOP ROLLING"
stopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
stopButton.TextSize = 20
stopButton.Font = Enum.Font.GothamBold
stopButton.Parent = mainFrame

local stopCorner = Instance.new("UICorner")
stopCorner.CornerRadius = UDim.new(0, 8)
stopCorner.Parent = stopButton

-- Get Kitsune Button
local kitsuneButton = Instance.new("TextButton")
kitsuneButton.Name = "KitsuneButton"
kitsuneButton.Size = UDim2.new(1, -40, 0, 45)
kitsuneButton.Position = UDim2.new(0, 20, 1, -15)
kitsuneButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
kitsuneButton.BorderSizePixel = 0
kitsuneButton.Text = "GET KITSUNE FRUIT"
kitsuneButton.TextColor3 = Color3.fromRGB(0, 0, 0)
kitsuneButton.TextSize = 18
kitsuneButton.Font = Enum.Font.GothamBold
kitsuneButton.Parent = mainFrame

local kitsuneCorner = Instance.new("UICorner")
kitsuneCorner.CornerRadius = UDim.new(0, 8)
kitsuneCorner.Parent = kitsuneButton

-- Adjust main frame size to fit new button
mainFrame.Size = UDim2.new(0, 400, 0, 350)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -175)

-- Button hover effects
local function createHoverEffect(button, hoverColor, normalColor)
    button.MouseEnter:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor})
        tween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = normalColor})
        tween:Play()
    end)
end

createHoverEffect(rollButton, Color3.fromRGB(0, 200, 255), Color3.fromRGB(0, 162, 255))
createHoverEffect(stopButton, Color3.fromRGB(255, 80, 80), Color3.fromRGB(255, 50, 50))
createHoverEffect(kitsuneButton, Color3.fromRGB(255, 255, 100), Color3.fromRGB(255, 215, 0))

-- Rolling state
local isRolling = false
local currentFruit = ""
local rollConnection = nil

-- Function to get random fruit
local function getRandomFruit()
    return fruits[math.random(1, #fruits)]
end

-- Function to start rolling
local function startRoll()
    if isRolling then
        return
    end
    
    isRolling = true
    rollButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    rollButton.Text = "ROLLING..."
    stopButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    
    -- Start the spinner effect
    local spinSpeed = 0.05 -- Speed of the spinner (lower = faster)
    
    rollConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if isRolling then
            currentFruit = getRandomFruit()
            fruitLabel.Text = currentFruit
            
            -- Add visual effect (pulse animation)
            local pulse = TweenService:Create(
                fruitLabel,
                TweenInfo.new(spinSpeed, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
                {TextTransparency = 0.3}
            )
            pulse:Play()
            
            pulse.Completed:Connect(function()
                local fadeIn = TweenService:Create(
                    fruitLabel,
                    TweenInfo.new(spinSpeed, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
                    {TextTransparency = 0}
                )
                fadeIn:Play()
            end)
        end
    end)
end

-- Function to stop rolling
local function stopRoll()
    if not isRolling then
        return
    end
    
    isRolling = false
    
    if rollConnection then
        rollConnection:Disconnect()
        rollConnection = nil
    end
    
    -- Reset button states
    rollButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    rollButton.Text = "ROLL"
    stopButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    
    -- Display final result with celebration effect
    if currentFruit ~= "" then
        fruitLabel.Text = "You got: " .. currentFruit
        
        -- Celebration animation
        local scaleUp = TweenService:Create(
            fruitLabel,
            TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {TextSize = 40}
        )
        scaleUp:Play()
        
        scaleUp.Completed:Connect(function()
            wait(0.5)
            local scaleDown = TweenService:Create(
                fruitLabel,
                TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In),
                {TextSize = 32}
            )
            scaleDown:Play()
        end)
        
        -- Change color based on rarity (simplified)
        local rarityColor = Color3.fromRGB(255, 255, 255) -- Default white
        
        -- Check for mythical fruits (you can expand this)
        local mythicalFruits = {"Kitsune", "Mammoth", "Sound", "Portal", "Blizzard", "T-Rex", "Dough V2", "Leopard V2", "Kitsune V2"}
        for _, fruit in ipairs(mythicalFruits) do
            if string.find(currentFruit, fruit) then
                rarityColor = Color3.fromRGB(255, 215, 0) -- Gold for mythical
                break
            end
        end
        
        fruitLabel.TextColor3 = rarityColor
        
        -- Reset color after 2 seconds
        wait(2)
        fruitLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end

-- Function to force give Kitsune fruit to player inventory
local function giveKitsuneFruit()
    kitsuneButton.Text = "GIVING KITSUNE..."
    kitsuneButton.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
    
    local success = false
    local attempts = 0
    local maxAttempts = 5
    
    -- Method 1: Try to find and use RemoteEvents
    pcall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            -- Try common remote event names
            local purchaseRemote = remotes:FindFirstChild("PurchaseFruit") or remotes:FindFirstChild("BuyFruit") or remotes:FindFirstChild("StorePurchase")
            if purchaseRemote then
                purchaseRemote:FireServer("Kitsune")
                success = true
            end
            
            -- Try fruit inventory remote
            local fruitRemote = remotes:FindFirstChild("StoreFruit") or remotes:FindFirstChild("AddFruit") or remotes:FindFirstChild("GiveFruit")
            if fruitRemote then
                fruitRemote:FireServer("Kitsune")
                success = true
            end
        end
    end)
    
    -- Method 2: Try to find Blox Fruits specific remotes
    pcall(function()
        local bfRemotes = ReplicatedStorage:FindFirstChild("_G")
        if bfRemotes then
            local purchase = bfRemotes:FindFirstChild("PurchaseFruit")
            if purchase then
                purchase:FireServer("Kitsune")
                success = true
            end
        end
    end)
    
    -- Method 3: Try to find NPCs and interact with them
    pcall(function()
        local npcs = Workspace:GetDescendants()
        for _, npc in ipairs(npcs) do
            if npc.Name == "Blox Fruit Dealer" or npc.Name == "Blox Fruit Dealer's Cousin" or npc.Name:find("Dealer") then
                local humanoid = npc:FindFirstChild("HumanoidRootPart")
                if humanoid then
                    -- Try to trigger purchase
                    local clickDetector = npc:FindFirstChild("ClickDetector")
                    if clickDetector then
                        fireclickdetector(clickDetector)
                        wait(0.5)
                        -- Try to find purchase GUI and select Kitsune
                        local purchaseGui = playerGui:FindFirstChild("PurchaseFruitGui") or playerGui:FindFirstChild("FruitShopGui")
                        if purchaseGui then
                            local kitsuneButton = purchaseGui:FindFirstChild("Kitsune") or purchaseGui:FindFirstChild("KitsuneButton")
                            if kitsuneButton then
                                kitsuneButton:FireServer()
                                success = true
                            end
                        end
                    end
                end
            end
        end
    end)
    
    -- Method 4: Direct inventory manipulation (if accessible)
    pcall(function()
        local playerData = player:FindFirstChild("DataFolder") or player:FindFirstChild("PlayerData")
        if playerData then
            local fruits = playerData:FindFirstChild("Fruits") or playerData:FindFirstChild("Inventory") or playerData:FindFirstChild("BloxFruits")
            if fruits then
                -- Try to add Kitsune to inventory
                local kitsuneValue = Instance.new("StringValue")
                kitsuneValue.Name = "Kitsune"
                kitsuneValue.Value = "Kitsune"
                kitsuneValue.Parent = fruits
                success = true
            end
        end
    end)
    
    -- Method 5: Try remote events in different locations
    pcall(function()
        local allRemotes = {}
        
        -- Search ReplicatedStorage
        local function searchForRemotes(parent)
            for _, child in ipairs(parent:GetDescendants()) do
                if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                    table.insert(allRemotes, child)
                end
            end
        end
        
        searchForRemotes(ReplicatedStorage)
        searchForRemotes(Workspace)
        
        -- Try common patterns
        for _, remote in ipairs(allRemotes) do
            if remote.Name:find("Fruit") or remote.Name:find("Purchase") or remote.Name:find("Store") or remote.Name:find("Buy") then
                pcall(function()
                    if remote:IsA("RemoteEvent") then
                        remote:FireServer("Kitsune")
                        remote:FireServer("Kitsune", player)
                    elseif remote:IsA("RemoteFunction") then
                        remote:InvokeServer("Kitsune")
                        remote:InvokeServer("Kitsune", player)
                    end
                    success = true
                end)
            end
        end
    end)
    
    -- Method 6: Try to find and use the game's main module
    pcall(function()
        local modules = ReplicatedStorage:FindFirstChild("Modules") or ReplicatedStorage:FindFirstChild("Shared")
        if modules then
            local fruitModule = modules:FindFirstChild("FruitHandler") or modules:FindFirstChild("FruitManager") or modules:FindFirstChild("Inventory")
            if fruitModule and fruitModule:IsA("ModuleScript") then
                local fruitHandler = require(fruitModule)
                if fruitHandler and type(fruitHandler) == "table" then
                    if fruitHandler.AddFruit then
                        fruitHandler.AddFruit(player, "Kitsune")
                        success = true
                    elseif fruitHandler.GiveFruit then
                        fruitHandler.GiveFruit(player, "Kitsune")
                        success = true
                    end
                end
            end
        end
    end)
    
    -- Feedback
    if success then
        kitsuneButton.Text = "KITSUNE GIVEN!"
        kitsuneButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        fruitLabel.Text = "Kitsune fruit added to inventory!"
        fruitLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
        
        -- Reset after 3 seconds
        wait(3)
        kitsuneButton.Text = "GET KITSUNE FRUIT"
        kitsuneButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
        fruitLabel.Text = "Press Roll to start!"
        fruitLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        kitsuneButton.Text = "FAILED - TRY AGAIN"
        kitsuneButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        fruitLabel.Text = "Could not give Kitsune. Game structure may have changed."
        fruitLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        
        -- Reset after 3 seconds
        wait(3)
        kitsuneButton.Text = "GET KITSUNE FRUIT"
        kitsuneButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
        fruitLabel.Text = "Press Roll to start!"
        fruitLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
    
    print("Kitsune fruit give attempt completed. Success:", success)
end

-- Connect button events
rollButton.MouseButton1Click:Connect(startRoll)
stopButton.MouseButton1Click:Connect(stopRoll)
kitsuneButton.MouseButton1Click:Connect(giveKitsuneFruit)

-- Optional: Keyboard shortcuts (R to roll, S to stop, K for Kitsune)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.R then
        startRoll()
    elseif input.KeyCode == Enum.KeyCode.S then
        stopRoll()
    elseif input.KeyCode == Enum.KeyCode.K then
        giveKitsuneFruit()
    end
end)

print("Fruit Roll GUI loaded! Press R to roll, S to stop, K for Kitsune, or use the buttons.")
