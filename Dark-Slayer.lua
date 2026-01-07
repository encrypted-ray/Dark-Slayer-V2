-- KRAKEN HUB | SSS-TIER REDZ STYLE UI (FULLY FUNCTIONAL + DS FEATURES)
if not game:IsLoaded() then game.Loaded:Wait() end

----------------------------------------------------------------
-- SERVICES
----------------------------------------------------------------
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")

local lp = Players.LocalPlayer
local cam = workspace.CurrentCamera
local connections = {}

----------------------------------------------------------------
-- CONFIG
----------------------------------------------------------------
local ACCENT = Color3.fromRGB(155,89,255)
local ACCENT_DARK = Color3.fromRGB(90,55,160)

----------------------------------------------------------------
-- STATE
----------------------------------------------------------------
local State = {
    -- Player
    Fly = false,
    Noclip = false,
    InfJump = false,
    SpeedBoost = false,
    JumpBoost = false,
    HighJump = false,
    GravityOff = false,
    Frozen = false,
    FrozenPos = nil,

    -- Visuals
    Fullbright = false,
    NoFog = false,
    CustomFOV = false,
    ShadowsOff = false,
    NightMode = false,
    LowGraphics = false,
    HighlightPlayers = false,

    -- Gacha
    AutoFruit = false,
    AutoWinter = false,
    GachaDelay = 2,
    DoubleSpin = false,
    TripleSpin = false,

    -- Misc
    AntiAFK = false,
    AutoCollect = false,
    AutoSell = false,
    SpeedRun = false
}

----------------------------------------------------------------
-- CLEANUP
----------------------------------------------------------------
if CoreGui:FindFirstChild("KrakenHub") then
    CoreGui.KrakenHub:Destroy()
end

----------------------------------------------------------------
-- UTILITY FUNCTIONS
----------------------------------------------------------------
local function toggleConnection(name, connection)
    if connections[name] then
        connections[name]:Disconnect()
        connections[name] = nil
    end
end

local function getCharacter()
    return lp.Character
end

local function getHRP()
    local char = getCharacter()
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function getHumanoid()
    local char = getCharacter()
    return char and char:FindFirstChildOfClass("Humanoid")
end

----------------------------------------------------------------
-- ROOT GUI
----------------------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "KrakenHub"
gui.ResetOnSpawn = false
gui.Parent = CoreGui

----------------------------------------------------------------
-- MAIN FRAME
----------------------------------------------------------------
local MAIN_W, MAIN_H = 520, 512
local TITLE_H, SIDE_W = 42, 130

local main = Instance.new("Frame")
main.Name = "MainFrame"
main.Size = UDim2.fromOffset(MAIN_W, MAIN_H)
main.Position = UDim2.fromScale(0.5, 0.5)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 16)
mainCorner.Parent = main

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = ACCENT
mainStroke.Thickness = 2
mainStroke.Parent = main

----------------------------------------------------------------
-- TITLE BAR
----------------------------------------------------------------
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, TITLE_H)
titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
titleBar.BorderSizePixel = 0
titleBar.Parent = main

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 16)
titleCorner.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -90, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🐙 KRAKEN HUB"
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.TextColor3 = ACCENT
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.fromOffset(32, 24)
closeBtn.Position = UDim2.new(1, -38, 0.5, -12)
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.TextColor3 = Color3.new(1, 0.6, 0.6)
closeBtn.BackgroundColor3 = Color3.fromRGB(60, 30, 30)
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
    for _, conn in pairs(connections) do
        if conn then conn:Disconnect() end
    end
end)

----------------------------------------------------------------
-- SIDEBAR
----------------------------------------------------------------
local sidebar = Instance.new("Frame")
sidebar.Position = UDim2.new(0, 0, 0, TITLE_H)
sidebar.Size = UDim2.fromOffset(SIDE_W, MAIN_H - TITLE_H)
sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
sidebar.BorderSizePixel = 0
sidebar.Parent = main

local sidebarCorner = Instance.new("UICorner")
sidebarCorner.CornerRadius = UDim.new(0, 16)
sidebarCorner.Parent = sidebar

local sideList = Instance.new("UIListLayout")
sideList.Padding = UDim.new(0, 8)
sideList.HorizontalAlignment = Enum.HorizontalAlignment.Center
sideList.VerticalAlignment = Enum.VerticalAlignment.Top
sideList.Parent = sidebar

local sidePad = Instance.new("UIPadding")
sidePad.PaddingTop = UDim.new(0, 15)
sidePad.PaddingBottom = UDim.new(0, 15)
sidePad.Parent = sidebar

----------------------------------------------------------------
-- PAGES
----------------------------------------------------------------
local pages = Instance.new("Frame")
pages.Position = UDim2.new(0, SIDE_W + 5, 0, TITLE_H)
pages.Size = UDim2.new(1, -SIDE_W - 5, 1, -TITLE_H)
pages.BackgroundTransparency = 1
pages.Parent = main

local Pages = {}
local Tabs = {}

local function CreatePage(name)
    local frame = Instance.new("ScrollingFrame")
    frame.Name = name .. "Page"
    frame.Size = UDim2.fromScale(1, 1)
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    frame.ScrollBarThickness = 6
    frame.ScrollBarImageColor3 = ACCENT
    frame.ScrollingDirection = Enum.ScrollingDirection.Y
    frame.CanvasSize = UDim2.new(0, 0, 0, 0)
    frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    frame.Visible = false
    frame.Parent = pages

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 15)
    padding.PaddingLeft = UDim.new(0, 15)
    padding.PaddingRight = UDim.new(0, 15)
    padding.PaddingBottom = UDim.new(0, 20)
    padding.Parent = frame

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = frame

    Pages[name] = frame
    return frame
end

local function CreateTab(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 13
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Parent = sidebar

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 12)
    btnCorner.Parent = btn

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(45, 45, 45)
    btnStroke.Thickness = 1
    btnStroke.Parent = btn

    btn.MouseButton1Click:Connect(function()
        for pageName, page in pairs(Pages) do
            page.Visible = false
        end
        for tabName, tab in pairs(Tabs) do
            tab.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            tab.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        Pages[name].Visible = true
        btn.BackgroundColor3 = ACCENT_DARK
        btn.TextColor3 = Color3.new(1, 1, 1)
    end)

    Tabs[name] = btn
    return btn
end

----------------------------------------------------------------
-- CREATE PAGES & TABS
----------------------------------------------------------------
local pagesList = {"Main", "Player", "Visuals", "Gacha", "Misc"}
for _, pageName in ipairs(pagesList) do
    CreatePage(pageName)
    CreateTab(pageName)
end

Pages.Main.Visible = true
Tabs.Main.BackgroundColor3 = ACCENT_DARK
Tabs.Main.TextColor3 = Color3.new(1, 1, 1)

----------------------------------------------------------------
-- TOGGLE COMPONENT
----------------------------------------------------------------
local function CreateToggle(parent, text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 45)
    frame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    frame.BorderSizePixel = 0
    frame.LayoutOrder = #parent:GetChildren()
    frame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 14)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(40, 40, 40)
    stroke.Thickness = 1
    stroke.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -75, 1, 0)
    label.Position = UDim2.new(0, 18, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextColor3 = Color3.fromRGB(230, 230, 230)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextWrapped = true
    label.Parent = frame

    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.fromOffset(50, 24)
    toggleBg.Position = UDim2.new(1, -60, 0.5, -12)
    toggleBg.BackgroundColor3 = default and ACCENT or Color3.fromRGB(60, 60, 60)
    toggleBg.BorderSizePixel = 0
    toggleBg.Parent = frame

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 12)
    toggleCorner.Parent = toggleBg

    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(20, 20)
    knob.Position = default and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.BorderSizePixel = 0
    knob.Parent = toggleBg

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 10)
    knobCorner.Parent = knob

    local state = default
    local function updateToggle(value)
        state = value
        TweenService:Create(toggleBg, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {
            BackgroundColor3 = state and ACCENT or Color3.fromRGB(60, 60, 60)
        }):Play()
        TweenService:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {
            Position = state and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
        }):Play()
        if callback then callback(state) end
    end

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            updateToggle(not state)
        end
    end)

    toggleBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            updateToggle(not state)
        end
    end)

    updateToggle(default)
    return frame
end

----------------------------------------------------------------
-- PLAYER TOGGLES
----------------------------------------------------------------
local PlayerPage = Pages.Player

-- Fly
CreateToggle(PlayerPage, "✈️ Fly", false, function(enabled)
    State.Fly = enabled
    toggleConnection("fly")
    if enabled and getHRP() then
        connections.fly = RunService.Heartbeat:Connect(function(dt)
            local hrp = getHRP()
            if not hrp then return end
            
            local moveVector = Vector3.new()
            if UIS:IsKeyDown(Enum.KeyCode.W) then moveVector = moveVector + cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then moveVector = moveVector - cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then moveVector = moveVector - cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then moveVector = moveVector + cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then moveVector = moveVector + Vector3.new(0, 1, 0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then moveVector = moveVector - Vector3.new(0, 1, 0) end
            
            hrp.CFrame = hrp.CFrame + (moveVector.Unit * 100 * dt)
        end)
    end
end)

-- Noclip
CreateToggle(PlayerPage, "👻 Noclip", false, function(enabled)
    State.Noclip = enabled
    toggleConnection("noclip")
    if enabled then
        connections.noclip = RunService.Stepped:Connect(function()
            local char = getCharacter()
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end)

-- Infinite Jump
CreateToggle(PlayerPage, "📈 Infinite Jump", false, function(enabled)
    State.InfJump = enabled
    toggleConnection("infjump")
    if enabled then
        connections.infjump = UIS.JumpRequest:Connect(function()
            local humanoid = getHumanoid()
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end)

-- Speed Boost
CreateToggle(PlayerPage, "⚡ Speed Boost", false, function(enabled)
    State.SpeedBoost = enabled
    local humanoid = getHumanoid()
    if humanoid then
        humanoid.WalkSpeed = enabled and 100 or 16
    end
end)

-- High Jump
CreateToggle(PlayerPage, "🦘 High Jump", false, function(enabled)
    State.HighJump = enabled
    local humanoid = getHumanoid()
    if humanoid then
        humanoid.JumpPower = enabled and 150 or 50
    end
end)

-- Gravity Off
CreateToggle(PlayerPage, "🌙 Gravity Off", false, function(enabled)
    State.GravityOff = enabled
    workspace.Gravity = enabled and 0 or 196.2
end)

-- Freeze
CreateToggle(PlayerPage, "❄ Freeze", false, function(enabled)
    State.Frozen = enabled
    if enabled and getHRP() then
        State.FrozenPos = getHRP().CFrame
    else
        State.FrozenPos = nil
    end
end)

-- Teleport Bases
local bases = {
    Vector3.new(-210,-11,-201), Vector3.new(-209,-11,-58), 
    Vector3.new(-209,-11,84), Vector3.new(179,-11,85), 
    Vector3.new(179,-11,-58), Vector3.new(180,-11,-201)
}
for i, pos in pairs(bases) do
    CreateToggle(PlayerPage, "Base "..i, false, function(enabled)
        if enabled and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            lp.Character.HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0,5,0))
        end
    end)
end

----------------------------------------------------------------
-- VISUALS TOGGLES
----------------------------------------------------------------
local VisualsPage = Pages.Visuals

CreateToggle(VisualsPage, "💡 Fullbright", false, function(enabled)
    State.Fullbright = enabled
    if enabled then
        Lighting.Brightness = 3
        Lighting.ClockTime = 14
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    else
        Lighting.Brightness = 1
        Lighting.ClockTime = 12
        Lighting.Ambient = Color3.fromRGB(100, 100, 100)
    end
end)

CreateToggle(VisualsPage, "👁️ ESP", false, function(enabled)
    State.HighlightPlayers = enabled
    local function applyESP(p)
        if p == lp then return end
        local function setup(char)
            local h = char:FindFirstChild("Kraken_Highlight") or Instance.new("Highlight", char)
            h.Name = "Kraken_Highlight"
            h.FillColor = Color3.fromRGB(255, 0, 0)
            h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            h.Enabled = enabled
            h.Parent = char

            local head = char:WaitForChild("Head", 10)
            if head and not head:FindFirstChild("KrakenBill") then
                local bill = Instance.new("BillboardGui", head)
                bill.Name = "KrakenBill"
                bill.Size = UDim2.new(0, 200, 0, 50)
                bill.AlwaysOnTop = true
                bill.ExtentsOffset = Vector3.new(0, 3, 0)

                local lbl = Instance.new("TextLabel", bill)
                lbl.Size = UDim2.new(1, 0, 1, 0)
                lbl.BackgroundTransparency = 1
                lbl.TextColor3 = Color3.new(1, 1, 1)
                lbl.TextStrokeTransparency = 0
                lbl.Font = Enum.Font.GothamBold
                lbl.TextSize = 14
                lbl.Text = p.DisplayName
            end
        end
        p.CharacterAdded:Connect(setup)
        if p.Character then setup(p.Character) end
    end
    for _, p in pairs(Players:GetPlayers()) do applyESP(p) end
    Players.PlayerAdded:Connect(applyESP)
end)

----------------------------------------------------------------
-- HEARTBEAT LOOPS
----------------------------------------------------------------
RunService.Heartbeat:Connect(function(dt)
    local hrp = getHRP()
    if not hrp then return end

    -- Freeze
    if State.Frozen and State.FrozenPos then
        hrp.CFrame = State.FrozenPos
        hrp.Velocity = Vector3.new(0,0,0)
    end

    -- Fly
    if State.Fly then
        local moveVector = Vector3.new()
        if UIS:IsKeyDown(Enum.KeyCode.W) then moveVector = moveVector + cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then moveVector = moveVector - cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then moveVector = moveVector - cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then moveVector = moveVector + cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then moveVector = moveVector + Vector3.new(0, 1, 0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then moveVector = moveVector - Vector3.new(0, 1, 0) end
        if moveVector.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + moveVector.Unit * 100 * dt
        end
    end

    -- Noclip
    if State.Noclip then
        local char = getCharacter()
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)

----------------------------------------------------------------
-- JUMP REQUEST
----------------------------------------------------------------
UIS.JumpRequest:Connect(function()
    if State.InfJump then
        local humanoid = getHumanoid()
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)
