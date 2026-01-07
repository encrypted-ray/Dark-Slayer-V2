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
    local debugInfo = {}
    
    print("=== Attempting to give fruit: " .. fruitGiven .. " ===")
    
    -- Try to find the fruit store remote
    local function tryGiveFruit()
        -- Method 1: Try ReplicatedStorage remotes folder
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes then
            print("Found Remotes folder in ReplicatedStorage")
            -- List all remotes for debugging
            for _, child in pairs(remotes:GetChildren()) do
                if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                    table.insert(debugInfo, "Remote: " .. child.Name)
                    -- Try common fruit-related names
                    if string.find(child.Name:lower(), "fruit") or 
                       string.find(child.Name:lower(), "store") or
                       string.find(child.Name:lower(), "purchase") or
                       string.find(child.Name:lower(), "buy") or
                       string.find(child.Name:lower(), "inventory") then
                        print("Trying remote: " .. child.Name)
                        pcall(function()
                            child:FireServer(fruitGiven)
                            success = true
                        end)
                        if success then return end
                    end
                end
            end
        end
        
        -- Method 2: Search all of ReplicatedStorage for remotes
        print("Searching ReplicatedStorage for remotes...")
        for _, child in pairs(ReplicatedStorage:GetDescendants()) do
            if (child:IsA("RemoteEvent") or child:IsA("RemoteFunction")) and 
               (string.find(child.Name:lower(), "fruit") or 
                string.find(child.Name:lower(), "store") or
                string.find(child.Name:lower(), "purchase") or
                string.find(child.Name:lower(), "buy") or
                string.find(child.Name:lower(), "inventory")) then
                print("Found potential remote: " .. child:GetFullName())
                pcall(function()
                    child:FireServer(fruitGiven)
                    success = true
                end)
                if success then return end
            end
        end
        
        -- Method 3: Try _G functions (common in executors)
        if _G.StoreFruit then
            print("Found _G.StoreFruit")
            pcall(function()
                _G.StoreFruit(fruitGiven)
                success = true
            end)
            if success then return end
        end
        
        -- Method 4: Try getgenv (common executor function)
        if getgenv and getgenv().StoreFruit then
            print("Found getgenv().StoreFruit")
            pcall(function()
                getgenv().StoreFruit(fruitGiven)
                success = true
            end)
            if success then return end
        end
        
        -- Method 5: Try to find in workspace
        local wsRemotes = workspace:FindFirstChild("Remotes")
        if wsRemotes then
            print("Found Remotes in Workspace")
            for _, child in pairs(wsRemotes:GetChildren()) do
                if (child:IsA("RemoteEvent") or child:IsA("RemoteFunction")) and
                   (string.find(child.Name:lower(), "fruit") or 
                    string.find(child.Name:lower(), "store")) then
                    print("Trying workspace remote: " .. child.Name)
                    pcall(function()
                        child:FireServer(fruitGiven)
                        success = true
                    end)
                    if success then return end
                end
            end
        end
        
        -- Method 6: Try to use game's fruit module if available
        local modules = ReplicatedStorage:FindFirstChild("Modules")
        if modules then
            print("Found Modules folder")
            for _, module in pairs(modules:GetChildren()) do
                if module:IsA("ModuleScript") and 
                   (string.find(module.Name:lower(), "fruit") or 
                    string.find(module.Name:lower(), "store") or
                    string.find(module.Name:lower(), "inventory")) then
                    print("Trying module: " .. module.Name)
                    pcall(function()
                        local moduleScript = require(module)
                        if moduleScript.StoreFruit then
                            moduleScript.StoreFruit(fruitGiven)
                            success = true
                        elseif moduleScript.PurchaseFruit then
                            moduleScript.PurchaseFruit(fruitGiven)
                            success = true
                        elseif moduleScript.BuyFruit then
                            moduleScript.BuyFruit(fruitGiven)
                            success = true
                        end
                    end)
                    if success then return end
                end
            end
        end
        
        -- Method 7: Try to find and use player data directly
        print("Trying direct inventory manipulation...")
        local playerData = player:FindFirstChild("PlayerData") or 
                          player:FindFirstChild("Data") or
                          player:FindFirstChild("_stats") or
                          player:FindFirstChild("Stats")
        
        if playerData then
            print("Found player data: " .. playerData.Name)
            -- Try to find inventory/fruits folder
            for _, child in pairs(playerData:GetDescendants()) do
                if string.find(child.Name:lower(), "fruit") or 
                   string.find(child.Name:lower(), "inventory") or
                   string.find(child.Name:lower(), "bag") then
                    print("Found potential inventory: " .. child:GetFullName())
                    pcall(function()
                        if child:IsA("Folder") then
                            local fruitValue = Instance.new("StringValue")
                            fruitValue.Name = fruitGiven
                            fruitValue.Value = fruitGiven
                            fruitValue.Parent = child
                            success = true
                        elseif child:IsA("Configuration") then
                            local fruitValue = Instance.new("StringValue")
                            fruitValue.Name = fruitGiven
                            fruitValue.Value = fruitGiven
                            fruitValue.Parent = child
                            success = true
                        end
                    end)
                    if success then return end
                end
            end
        end
        
        -- Method 8: Try common Blox Fruits executor methods
        -- Check for executor-specific functions
        local executorFunctions = {
            "StoreFruit", "BuyFruit", "PurchaseFruit", "GiveFruit",
            "AddFruit", "GetFruit", "EquipFruit"
        }
        
        for _, funcName in pairs(executorFunctions) do
            if _G[funcName] then
                print("Found _G." .. funcName)
                pcall(function()
                    _G[funcName](fruitGiven)
                    success = true
                end)
                if success then return end
            end
            
            if getgenv and getgenv()[funcName] then
                print("Found getgenv()." .. funcName)
                pcall(function()
                    getgenv()[funcName](fruitGiven)
                    success = true
                end)
                if success then return end
            end
        end
        
        -- Method 9: Try hooking into game's purchase system
        print("Trying to hook into purchase system...")
        local purchaseRemotes = {
            "PurchaseFruit", "BuyFruit", "StoreFruit", "FruitStore",
            "FruitPurchase", "BuyItem", "PurchaseItem"
        }
        
        for _, remoteName in pairs(purchaseRemotes) do
            local remote = ReplicatedStorage:FindFirstChild(remoteName, true)
            if remote and (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) then
                print("Found purchase remote: " .. remote:GetFullName())
                pcall(function()
                    if remote:IsA("RemoteEvent") then
                        remote:FireServer(fruitGiven)
                    else
                        remote:InvokeServer(fruitGiven)
                    end
                    success = true
                end)
                if success then return end
            end
        end
    end
    
    -- Try to give the fruit
    local success, err = pcall(tryGiveFruit)
    
    if not success then
        print("Error in tryGiveFruit: " .. tostring(err))
    end
    
    -- Print debug info
    print("=== Debug Info ===")
    for _, info in pairs(debugInfo) do
        print(info)
    end
    print("=== End Debug Info ===")
    
    -- Update button text based on result
    if success then
        button.Text = "Fruit Given: " .. fruitGiven
        print("SUCCESS: Fruit given!")
        wait(2)
        button.Text = "Give Mythical Fruit"
    else
        button.Text = "Failed - Check Console"
        print("FAILED: Could not give fruit. Check console for details.")
        print("Fruit attempted: " .. fruitGiven)
        wait(2)
        button.Text = "Give Mythical Fruit"
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

-- Function to scan and list all remotes (for debugging)
local function scanRemotes()
    print("\n=== SCANNING FOR REMOTES ===")
    local remoteCount = 0
    
    -- Scan ReplicatedStorage
    for _, child in pairs(ReplicatedStorage:GetDescendants()) do
        if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
            remoteCount = remoteCount + 1
            if string.find(child.Name:lower(), "fruit") or 
               string.find(child.Name:lower(), "store") or
               string.find(child.Name:lower(), "purchase") or
               string.find(child.Name:lower(), "buy") or
               string.find(child.Name:lower(), "inventory") then
                print(">>> FOUND POTENTIAL: " .. child:GetFullName())
            end
        end
    end
    
    print("Total remotes found in ReplicatedStorage: " .. remoteCount)
    print("=== END SCAN ===\n")
end

-- Run scan on load
spawn(function()
    wait(2) -- Wait for game to load
    scanRemotes()
end)

print("Mythical Fruit GUI loaded! Click the button to get a random mythical fruit.")
print("Check console for remote scan results in 2 seconds...")
