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
    local fruitGiven = mythicalFruits[math.random(1, #mythicalFruits)]
    local success = false
    
    warn("=== Attempting to give fruit: " .. fruitGiven .. " ===")
    
    -- Method 1: Try the actual Blox Fruits StoreFruit remote (most common)
    local function tryStoreFruit()
        -- Common Blox Fruits remote paths
        local remotePaths = {
            "Remotes/CommF_/StoreFruit",
            "Remotes/CommF_/PurchaseFruit",
            "Remotes/CommF_/BuyFruit",
            "Remotes/StoreFruit",
            "Remotes/PurchaseFruit",
            "Remotes/BuyFruit",
            "CommF_/StoreFruit",
            "CommF_/PurchaseFruit",
            "StoreFruit",
            "PurchaseFruit"
        }
        
        for _, path in pairs(remotePaths) do
            local remote = ReplicatedStorage:FindFirstChild(path, true)
            if remote and (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) then
                warn("Found remote: " .. remote:GetFullName())
                local result = pcall(function()
                    if remote:IsA("RemoteEvent") then
                        -- Try different parameter combinations
                        remote:FireServer(fruitGiven)
                        wait(0.1)
                        remote:FireServer(fruitGiven, "Mythical")
                        wait(0.1)
                        remote:FireServer({fruitGiven, "Mythical"})
                    else
                        remote:InvokeServer(fruitGiven)
                        wait(0.1)
                        remote:InvokeServer(fruitGiven, "Mythical")
                    end
                    success = true
                end)
                if success then return true end
            end
        end
        return false
    end
    
    -- Method 2: Direct inventory manipulation via player data
    local function tryDirectInventory()
        -- Wait for player data to load
        local playerData = nil
        for i = 1, 10 do
            playerData = player:FindFirstChild("_stats") or 
                        player:FindFirstChild("Data") or
                        player:FindFirstChild("PlayerData")
            if playerData then break end
            wait(0.5)
        end
        
        if not playerData then
            warn("Could not find player data")
            return false
        end
        
        warn("Found player data: " .. playerData.Name)
        
        -- Look for fruit inventory
        local fruitInventory = nil
        for _, child in pairs(playerData:GetDescendants()) do
            if child.Name == "FruitInventory" or 
               child.Name == "Fruits" or 
               child.Name == "Inventory" or
               (string.find(child.Name:lower(), "fruit") and child:IsA("Folder")) then
                fruitInventory = child
                warn("Found fruit inventory: " .. child:GetFullName())
                break
            end
        end
        
        if fruitInventory then
            -- Check if fruit already exists
            local existingFruit = fruitInventory:FindFirstChild(fruitGiven)
            if existingFruit then
                warn("Fruit already exists in inventory")
                success = true
                return true
            end
            
            -- Add fruit to inventory
            local fruitValue = Instance.new("StringValue")
            fruitValue.Name = fruitGiven
            fruitValue.Value = fruitGiven
            fruitValue.Parent = fruitInventory
            warn("Added fruit to inventory: " .. fruitGiven)
            success = true
            return true
        end
        
        -- Try adding to _stats directly
        if playerData.Name == "_stats" then
            local fruitValue = Instance.new("StringValue")
            fruitValue.Name = fruitGiven
            fruitValue.Value = fruitGiven
            fruitValue.Parent = playerData
            warn("Added fruit to _stats: " .. fruitGiven)
            success = true
            return true
        end
        
        return false
    end
    
    -- Method 3: Try using the game's modules
    local function tryModuleMethod()
        local modules = ReplicatedStorage:FindFirstChild("Modules")
        if not modules then return false end
        
        -- Look for fruit-related modules
        local fruitModules = {
            "FruitStore",
            "Fruit",
            "Inventory",
            "Store"
        }
        
        for _, moduleName in pairs(fruitModules) do
            local module = modules:FindFirstChild(moduleName)
            if module and module:IsA("ModuleScript") then
                local success, moduleScript = pcall(function()
                    return require(module)
                end)
                
                if success and moduleScript then
                    -- Try different function names
                    local funcs = {"StoreFruit", "PurchaseFruit", "BuyFruit", "AddFruit", "GiveFruit"}
                    for _, funcName in pairs(funcs) do
                        if moduleScript[funcName] then
                            warn("Found function: " .. moduleName .. "." .. funcName)
                            pcall(function()
                                moduleScript[funcName](fruitGiven)
                                success = true
                            end)
                            if success then return true end
                        end
                    end
                end
            end
        end
        return false
    end
    
    -- Method 4: Try CommF_ folder (common in Blox Fruits)
    local function tryCommF()
        local commF = ReplicatedStorage:FindFirstChild("Remotes") and 
                     ReplicatedStorage.Remotes:FindFirstChild("CommF_")
        if not commF then
            commF = ReplicatedStorage:FindFirstChild("CommF_")
        end
        
        if commF then
            warn("Found CommF_ folder")
            for _, remote in pairs(commF:GetChildren()) do
                if (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) and
                   (string.find(remote.Name:lower(), "fruit") or 
                    string.find(remote.Name:lower(), "store") or
                    string.find(remote.Name:lower(), "purchase") or
                    string.find(remote.Name:lower(), "buy")) then
                    warn("Trying CommF_ remote: " .. remote.Name)
                    pcall(function()
                        if remote:IsA("RemoteEvent") then
                            remote:FireServer(fruitGiven)
                            wait(0.1)
                            remote:FireServer(fruitGiven, "Mythical")
                            wait(0.1)
                            remote:FireServer({fruitGiven, "Mythical"})
                        else
                            remote:InvokeServer(fruitGiven)
                            wait(0.1)
                            remote:InvokeServer(fruitGiven, "Mythical")
                        end
                        success = true
                    end)
                    if success then return true end
                end
            end
        end
        return false
    end
    
    -- Method 5: Try all remotes in Remotes folder
    local function tryAllRemotes()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if not remotes then return false end
        
        warn("Scanning all remotes in Remotes folder...")
        for _, remote in pairs(remotes:GetDescendants()) do
            if (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) and
               (string.find(remote.Name:lower(), "fruit") or 
                string.find(remote.Name:lower(), "store") or
                string.find(remote.Name:lower(), "purchase") or
                string.find(remote.Name:lower(), "buy")) then
                warn("Trying remote: " .. remote:GetFullName())
                pcall(function()
                    if remote:IsA("RemoteEvent") then
                        remote:FireServer(fruitGiven)
                        wait(0.1)
                        remote:FireServer(fruitGiven, "Mythical")
                        wait(0.1)
                        remote:FireServer({fruitGiven})
                    else
                        remote:InvokeServer(fruitGiven)
                        wait(0.1)
                        remote:InvokeServer(fruitGiven, "Mythical")
                    end
                    success = true
                end)
                if success then return true end
            end
        end
        return false
    end
    
    -- Try all methods
    if tryStoreFruit() then
        button.Text = "Fruit Given: " .. fruitGiven
        warn("SUCCESS: Fruit given via remote!")
        wait(2)
        button.Text = "Give Mythical Fruit"
        return
    end
    
    if tryCommF() then
        button.Text = "Fruit Given: " .. fruitGiven
        warn("SUCCESS: Fruit given via CommF_!")
        wait(2)
        button.Text = "Give Mythical Fruit"
        return
    end
    
    if tryDirectInventory() then
        button.Text = "Fruit Added: " .. fruitGiven
        warn("SUCCESS: Fruit added to inventory!")
        wait(2)
        button.Text = "Give Mythical Fruit"
        return
    end
    
    if tryModuleMethod() then
        button.Text = "Fruit Given: " .. fruitGiven
        warn("SUCCESS: Fruit given via module!")
        wait(2)
        button.Text = "Give Mythical Fruit"
        return
    end
    
    if tryAllRemotes() then
        button.Text = "Fruit Given: " .. fruitGiven
        warn("SUCCESS: Fruit given via remote scan!")
        wait(2)
        button.Text = "Give Mythical Fruit"
        return
    end
    
    -- Failed
    button.Text = "Failed - Check Console"
    warn("FAILED: Could not give fruit. Tried all methods.")
    warn("Fruit attempted: " .. fruitGiven)
    wait(2)
    button.Text = "Give Mythical Fruit"
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
    warn("\n=== SCANNING FOR REMOTES ===")
    local remoteCount = 0
    local fruitRemotes = {}
    
    -- Scan ReplicatedStorage
    for _, child in pairs(ReplicatedStorage:GetDescendants()) do
        if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
            remoteCount = remoteCount + 1
            local nameLower = child.Name:lower()
            if string.find(nameLower, "fruit") or 
               string.find(nameLower, "store") or
               string.find(nameLower, "purchase") or
               string.find(nameLower, "buy") or
               string.find(nameLower, "inventory") or
               string.find(nameLower, "comm") then
                table.insert(fruitRemotes, child:GetFullName())
                warn(">>> POTENTIAL: " .. child:GetFullName() .. " (" .. child.ClassName .. ")")
            end
        end
    end
    
    warn("Total remotes found: " .. remoteCount)
    warn("Fruit-related remotes found: " .. #fruitRemotes)
    warn("=== END SCAN ===\n")
    
    -- Also check player data structure
    wait(1)
    warn("=== CHECKING PLAYER DATA ===")
    local playerData = player:FindFirstChild("_stats") or 
                      player:FindFirstChild("Data") or
                      player:FindFirstChild("PlayerData")
    if playerData then
        warn("Found player data: " .. playerData:GetFullName())
        for _, child in pairs(playerData:GetDescendants()) do
            if string.find(child.Name:lower(), "fruit") or 
               string.find(child.Name:lower(), "inventory") then
                warn(">>> Found: " .. child:GetFullName() .. " (" .. child.ClassName .. ")")
            end
        end
    else
        warn("No player data found yet")
    end
    warn("=== END PLAYER DATA CHECK ===\n")
end

-- Run scan on load
spawn(function()
    wait(3) -- Wait for game to load
    scanRemotes()
end)

warn("Mythical Fruit GUI loaded! Click the button to get a random mythical fruit.")
warn("Check console (warnings) for remote scan results in 3 seconds...")
