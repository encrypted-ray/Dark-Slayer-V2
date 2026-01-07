-- DARK SLAYER VL V2 (PHONE UI EDITION)
-- FIXED + WINTER GACHA (TARGET-ONLY)

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
local flying = false
local infJump = false
local nocliping = false
local espEnabled = false
local isFrozen = false

local flySpeed = 120
local frozenPos = nil

local timerOn = false
local timeLeft = 0

-- CLEAN GUI
if CoreGui:FindFirstChild("DS_Phone_V1") then
    CoreGui.DS_Phone_V1:Destroy()
end

-- UI ROOT
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "DS_Phone_V1"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 280, 0, 560)
main.Position = UDim2.new(0.5, -140, 0.5, -280)
main.BackgroundColor3 = Color3.fromRGB(10,10,10)
main.Active, main.Draggable = true, true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 40)

local container = Instance.new("ScrollingFrame", main)
container.Size = UDim2.new(0.9, 0, 0.82, 0)
container.Position = UDim2.new(0.05, 0, 0.08, 0)
container.CanvasSize = UDim2.new(0, 0, 1.35, 0)
container.ScrollBarThickness = 0
container.BackgroundTransparency = 1

local function createBtn(text, pos, size, color)
    local b = Instance.new("TextButton", container)
    b.Size = size or UDim2.new(1, 0, 0, 40)
    b.Position = pos
    b.Text = text
    b.BackgroundColor3 = color or Color3.fromRGB(25,25,25)
    b.TextColor3 = Color3.new(1,1,1)
    b.TextScaled = true
    b.BorderSizePixel = 0
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    return b
end

-- BUTTONS
local espBtn     = createBtn("ESP: OFF",        UDim2.new(0,0,0,0), nil, Color3.fromRGB(70,0,0))
local noclipBtn  = createBtn("NOCLIP: OFF",     UDim2.new(0,0,0.08,0), UDim2.new(0.48,0,0,40))
local flyBtn     = createBtn("FLY: OFF",        UDim2.new(0.52,0,0.08,0), UDim2.new(0.48,0,0,40))
local speedBtn   = createBtn("SPEED: OFF",      UDim2.new(0,0,0.16,0), UDim2.new(0.48,0,0,40))
local jumpBtn    = createBtn("INF JUMP: OFF",   UDim2.new(0.52,0,0.16,0), UDim2.new(0.48,0,0,40))
local freezeBtn  = createBtn("FREEZE: OFF",     UDim2.new(0,0,0.24,0), nil, Color3.fromRGB(0,45,90))

local rollBtn    = createBtn("ROLL WINTER GACHA", UDim2.new(0,0,0.32,0), nil, Color3.fromRGB(160,0,0))

-- TIMER UI
local timerLabel = Instance.new("TextLabel", container)
timerLabel.Size = UDim2.new(1,0,0,40)
timerLabel.Position = UDim2.new(0,0,0.40,0)
timerLabel.Text = "00:00"
timerLabel.TextScaled = true
timerLabel.TextColor3 = Color3.new(1,1,1)
timerLabel.BackgroundTransparency = 1

local timeInput = Instance.new("TextBox", container)
timeInput.Size = UDim2.new(1,0,0,30)
timeInput.Position = UDim2.new(0,0,0.48,0)
timeInput.Text = "60"
timeInput.BackgroundColor3 = Color3.fromRGB(25,25,25)
timeInput.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", timeInput)

local startBtn = createBtn("START", UDim2.new(0,0,0.55,0), UDim2.new(0.48,0,0,35), Color3.fromRGB(0,70,0))
local resetBtn = createBtn("RESET", UDim2.new(0.52,0,0.55,0), UDim2.new(0.48,0,0,35), Color3.fromRGB(70,0,0))

-- ESP (LEAK-FREE)
local espConnections = {}

local function applyESP(player)
    if player == lp then return end

    local function setup(char)
        if char:FindFirstChild("DS_Highlight") then return end

        local hl = Instance.new("Highlight", char)
        hl.Name = "DS_Highlight"
        hl.FillColor = Color3.new(1,0,0)
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

        local head = char:WaitForChild("Head", 5)
        if not head then return end

        local bb = Instance.new("BillboardGui", head)
        bb.Name = "DS_Name"
        bb.Size = UDim2.new(0,200,0,40)
        bb.AlwaysOnTop = true
        bb.ExtentsOffset = Vector3.new(0,3,0)

        local lbl = Instance.new("TextLabel", bb)
        lbl.Size = UDim2.new(1,0,1,0)
        lbl.BackgroundTransparency = 1
        lbl.TextStrokeTransparency = 0
        lbl.TextColor3 = Color3.new(1,1,1)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 14
        lbl.Text = player.DisplayName

        espConnections[player] = RunService.RenderStepped:Connect(function()
            hl.Enabled = espEnabled
            bb.Enabled = espEnabled
        end)

        player.CharacterRemoving:Once(function()
            if espConnections[player] then
                espConnections[player]:Disconnect()
                espConnections[player] = nil
            end
        end)
    end

    player.CharacterAdded:Connect(setup)
    if player.Character then setup(player.Character) end
end

for _, p in ipairs(Players:GetPlayers()) do applyESP(p) end
Players.PlayerAdded:Connect(applyESP)

-- HEARTBEAT LOOP
RunService.Heartbeat:Connect(function()
    if not lp.Character then return end
    local hrp = lp.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- FREEZE
    if isFrozen and frozenPos then
        hrp.CFrame = frozenPos
        hrp.Velocity = Vector3.zero
    end

    -- FLY
    if flying then
        hrp.Velocity = cam.CFrame.LookVector * flySpeed
    end

    -- NOCLIP (PROPER REVERT)
    for _, v in ipairs(lp.Character:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = not nocliping
        end
    end

    -- TIMER
    if timerOn and timeLeft > 0 then
        timeLeft -= 1
        if timeLeft <= 0 then timerOn = false end
        timerLabel.Text = string.format("%02d:%02d", math.floor(timeLeft/60), timeLeft % 60)
    end
end)

-- TOGGLES
espBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espBtn.Text = "ESP: " .. (espEnabled and "ON" or "OFF")
end)

noclipBtn.MouseButton1Click:Connect(function()
    nocliping = not nocliping
    noclipBtn.Text = "NOCLIP: " .. (nocliping and "ON" or "OFF")
end)

flyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    flyBtn.Text = "FLY: " .. (flying and "ON" or "OFF")
end)

speedBtn.MouseButton1Click:Connect(function()
    local h = lp.Character and lp.Character:FindFirstChild("Humanoid")
    if h then
        h.WalkSpeed = (h.WalkSpeed == 16 and 100 or 16)
        speedBtn.Text = "SPEED: " .. (h.WalkSpeed > 20 and "ON" or "OFF")
    end
end)

jumpBtn.MouseButton1Click:Connect(function()
    infJump = not infJump
    jumpBtn.Text = "INF JUMP: " .. (infJump and "ON" or "OFF")
end)

freezeBtn.MouseButton1Click:Connect(function()
    isFrozen = not isFrozen
    frozenPos = isFrozen and lp.Character.HumanoidRootPart.CFrame or nil
    freezeBtn.Text = "FREEZE: " .. (isFrozen and "ON" or "OFF")
end)

-- INF JUMP (THROTTLED)
local lastJump = 0
UIS.JumpRequest:Connect(function()
    if infJump and tick() - lastJump > 0.25 then
        lastJump = tick()
        local h = lp.Character and lp.Character:FindFirstChild("Humanoid")
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- TIMER BUTTONS
startBtn.MouseButton1Click:Connect(function()
    if not timerOn then
        timeLeft = tonumber(timeInput.Text) or 0
        timerOn = true
        startBtn.Text = "STOP"
    else
        timerOn = false
        startBtn.Text = "START"
    end
end)

resetBtn.MouseButton1Click:Connect(function()
    timerOn = false
    timeLeft = 0
    timerLabel.Text = "00:00"
end)

-- ===============================
-- WINTER GACHA (TARGET ONLY)
-- ===============================

-- YOU ONLY WANT THESE
local desiredRewards = {
    ["Galaxy Empyrean Kitsune"] = true,
    ["Ember Dragon"] = true,
}

local rolling = false
local rollCount = 0

local function rollWinterGacha()
    ReplicatedStorage.Remotes.CommF_:InvokeServer("Cousin", "Buy")
end

ReplicatedStorage.Remotes.CommF_.OnClientInvoke = function(action, reward)
    if action ~= "Cousin" or not reward then return end

    rollCount += 1
    warn("🎲 Roll #" .. rollCount .. " → " .. reward)

    if desiredRewards[reward] then
        rolling = false
        warn("🔥 TARGET OBTAINED:", reward, "after", rollCount, "rolls")
        return
    end

    if rolling then
        task.wait(0.6)
        rollWinterGacha()
    end
end

rollBtn.MouseButton1Click:Connect(function()
    if rolling then
        rolling = false
        return
    end
    rollCount = 0
    rolling = true
    rollWinterGacha()
end)
