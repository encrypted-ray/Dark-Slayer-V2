-- Blox Fruits Random Fruit Roll Script
-- Creates a GUI with Roll and Stop buttons for fruit gacha

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

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

-- Connect button events
rollButton.MouseButton1Click:Connect(startRoll)
stopButton.MouseButton1Click:Connect(stopRoll)

-- Optional: Keyboard shortcuts (R to roll, S to stop)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.R then
        startRoll()
    elseif input.KeyCode == Enum.KeyCode.S then
        stopRoll()
    end
end)

print("Fruit Roll GUI loaded! Press R to roll, S to stop, or use the buttons.")
