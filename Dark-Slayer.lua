-- DARK SLAYER V2 — MODERN SIDEBAR UI + TITLE BAR + MINIMIZE BUBBLE
-- LOGIC PRESERVED | UI UPGRADE ONLY

if not game:IsLoaded() then game.Loaded:Wait() end

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lp = Players.LocalPlayer
repeat task.wait() until lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
local cam = workspace.CurrentCamera

-- =====================
-- STATE
-- =====================
local flying, infJump, nocliping, espEnabled, isFrozen = false,false,false,false,false
local flySpeed = 120
local frozenPos = nil
local timerOn, timeLeft = false, 0

-- =====================
-- COLORS
-- =====================
local C = {
    bg = Color3.fromRGB(15,15,18),
    panel = Color3.fromRGB(25,25,30),
    sidebar = Color3.fromRGB(20,20,24),
    accent = Color3.fromRGB(90,140,255),
    on = Color3.fromRGB(70,200,140),
    off = Color3.fromRGB(200,80,80)
}

-- =====================
-- CLEANUP
-- =====================
if CoreGui:FindFirstChild("DS_Modern") then
    CoreGui.DS_Modern:Destroy()
end

-- =====================
-- GUI ROOT
-- =====================
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "DS_Modern"

-- =====================
-- MAIN WINDOW
-- =====================
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 520, 0, 420)
main.Position = UDim2.new(0.5, -260, 0.5, -210)
main.BackgroundColor3 = C.bg
main.Active, main.Draggable = true, true
Instance.new("UICorner", main).CornerRadius = UDim.new(0,16)

-- =====================
-- TITLE BAR
-- =====================
local titleBar = Instance.new("Frame", main)
titleBar.Size = UDim2.new(1,0,0,40)
titleBar.BackgroundColor3 = C.panel

local title = Instance.new("TextLabel", titleBar)
title.Size = UDim2.new(1,-120,1,0)
title.Position = UDim2.new(0,12,0,0)
title.Text = "DARK SLAYER V2"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.new(1,1,1)
title.TextXAlignment = Left
title.BackgroundTransparency = 1

local function titleBtn(txt, x, color)
    local b = Instance.new("TextButton", titleBar)
    b.Size = UDim2.new(0,32,0,32)
    b.Position = UDim2.new(1,x,0.5,-16)
    b.Text = txt
    b.Font = Enum.Font.GothamBold
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = color
    Instance.new("UICorner", b).CornerRadius = UDim.new(1,0)
    return b
end

local minimizeBtn = titleBtn("–",-72,C.accent)
local closeBtn    = titleBtn("X",-36,C.off)

-- =====================
-- SIDEBAR
-- =====================
local sidebar = Instance.new("Frame", main)
sidebar.Position = UDim2.new(0,0,0,40)
sidebar.Size = UDim2.new(0,120,1,-40)
sidebar.BackgroundColor3 = C.sidebar

local pages = Instance.new("Folder", main)

local function createPage(name)
    local f = Instance.new("Frame", main)
    f.Name = name
    f.Position = UDim2.new(0,120,0,40)
    f.Size = UDim2.new(1,-120,1,-40)
    f.BackgroundTransparency = 1
    f.Visible = false
    return f
end

local function tabButton(text, y, page)
    local b = Instance.new("TextButton", sidebar)
    b.Size = UDim2.new(1,0,0,40)
    b.Position = UDim2.new(0,0,0,y)
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = C.sidebar
    b.MouseButton1Click:Connect(function()
        for _,p in ipairs(pages:GetChildren()) do p.Visible = false end
        page.Visible = true
    end)
end

-- =====================
-- PAGES
-- =====================
local visuals  = createPage("Visuals")
local movement = createPage("Movement")
local utility  = createPage("Utility")
local gacha    = createPage("Gacha")
visuals.Visible = true

visuals.Parent = pages
movement.Parent = pages
utility.Parent = pages
gacha.Parent = pages

tabButton("VISUALS",0,visuals)
tabButton("MOVE",40,movement)
tabButton("UTILITY",80,utility)
tabButton("GACHA",120,gacha)

-- =====================
-- UI HELPERS
-- =====================
local function btn(parent,text,y)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0,260,0,40)
    b.Position = UDim2.new(0,20,0,y)
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = C.panel
    Instance.new("UICorner", b)
    return b
end

-- =====================
-- VISUALS
-- =====================
local espBtn = btn(visuals,"ESP ✖",20)
espBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espBtn.Text = espEnabled and "ESP ✔" or "ESP ✖"
end)

-- =====================
-- MOVEMENT
-- =====================
local flyBtn = btn(movement,"FLY ✖",20)
flyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    flyBtn.Text = flying and "FLY ✔" or "FLY ✖"
end)

local noclipBtn = btn(movement,"NOCLIP ✖",70)
noclipBtn.MouseButton1Click:Connect(function()
    nocliping = not nocliping
    noclipBtn.Text = nocliping and "NOCLIP ✔" or "NOCLIP ✖"
end)

local jumpBtn = btn(movement,"INF JUMP ✖",120)
jumpBtn.MouseButton1Click:Connect(function()
    infJump = not infJump
    jumpBtn.Text = infJump and "INF JUMP ✔" or "INF JUMP ✖"
end)

-- =====================
-- GACHA
-- =====================
local rollBtn = btn(gacha,"ROLL WINTER GACHA",20)

-- =====================
-- MINIMIZE BUBBLE
-- =====================
local bubble = Instance.new("TextButton", gui)
bubble.Size = UDim2.new(0,60,0,60)
bubble.Position = UDim2.new(0.02,0,0.5,0)
bubble.Text = "DS"
bubble.Visible = false
bubble.BackgroundColor3 = C.accent
bubble.TextColor3 = Color3.new(1,1,1)
bubble.Font = Enum.Font.GothamBold
Instance.new("UICorner", bubble).CornerRadius = UDim.new(1,0)

minimizeBtn.MouseButton1Click:Connect(function()
    main.Visible = false
    bubble.Visible = true
end)

bubble.MouseButton1Click:Connect(function()
    main.Visible = true
    bubble.Visible = false
end)

-- =====================
-- FORCE CLOSE (HARD)
-- =====================
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- =====================
-- HEARTBEAT (UNCHANGED)
-- =====================
RunService.Heartbeat:Connect(function()
    local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if flying then
        hrp.Velocity = cam.CFrame.LookVector * flySpeed
    end

    for _,v in ipairs(lp.Character:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = not nocliping
        end
    end
end)

UIS.JumpRequest:Connect(function()
    if infJump then
        local h = lp.Character:FindFirstChild("Humanoid")
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- =====================
-- GACHA LOGIC (UNCHANGED)
-- =====================
local desiredRewards = {
    ["Galaxy Empyrean Kitsune"] = true,
    ["Ember Dragon"] = true
}

local rolling = false
local function roll()
    ReplicatedStorage.Remotes.CommF_:InvokeServer("Cousin","Buy")
end

ReplicatedStorage.Remotes.CommF_.OnClientInvoke = function(a,r)
    if a ~= "Cousin" or not r then return end
    if desiredRewards[r] then
        rolling = false
        return
    end
    if rolling then task.wait(0.6) roll() end
end

rollBtn.MouseButton1Click:Connect(function()
    rolling = not rolling
    if rolling then roll() end
end)
