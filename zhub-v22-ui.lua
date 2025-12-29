--[[
    Z HUB - UNIVERSAL V22 (ULTIMATE UI EDITION)
    UI: Mr.Alegator (Heavily Modified)
    Logic: Z HUB Fortress System
]]

-- // 1. CONFIGURATION (EDIT THIS) // --
getgenv().Config = {
    OwnerKey = "big bro",
    Website = "https://yourname.github.io/z-hub", -- PUT YOUR WEBSITE LINK HERE
    Discord = "https://discord.gg/YourServer"
}

-- // 2. KEY GENERATION LOGIC (Synced with Website) // --
local function GetCurrentKey()
    local Date = os.date("!*t") -- UTC Time
    local Block = math.floor(Date.hour / 7)
    return "ZKEY" .. Date.day .. Block
end

-- // 3. THE SCRIPT TO LOAD (Z HUB V22) // --
local function LoadZHub()
    -- NOTIFICATION
    game.StarterGui:SetCore("SendNotification", {
        Title = "Z HUB V22",
        Text = "System Authenticated. Loading Fortress...",
        Duration = 5
    })

    -- [PASTE Z HUB V22 LOGIC HERE]
    -- For now, this is the loader stub. 
    -- When you obfuscate, you put the obfuscated code here.
    
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera
    
    -- Visuals Setup
    local FOVCircle = Drawing.new("Circle")
    FOVCircle.Visible = false
    
    -- Main Loop
    RunService.RenderStepped:Connect(function()
        -- This represents the script running
        FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    end)
    
    -- Load Menu
    loadstring(game:HttpGet('https://raw.githubusercontent.com/StepBroFurious/Script/main/HydraHubUi.lua'))()
    
    print("Z HUB LOADED")
end

-- ==================================================================
-- UI CODE (The Fancy Stuff you sent)
-- ==================================================================

local Services = {
    Players = game:GetService("Players"),
    TweenService = game:GetService("TweenService"),
    UserInputService = game:GetService("UserInputService"),
    RunService = game:GetService("RunService")
}

local Player = Services.Players.LocalPlayer
local PlayerGui = game:GetService("CoreGui") -- CHANGED TO COREGUI FOR SECURITY

local UIConfig = { MaxKeyLength = 50, AnimationSpeed = 0.4, ParticleCount = 60, ParticleSpeed = 60 }

local Colors = {
    Background = Color3.fromRGB(18, 18, 22), Surface = Color3.fromRGB(25, 25, 30),
    Primary = Color3.fromRGB(255, 0, 60), -- Z HUB RED
    Secondary = Color3.fromRGB(35, 35, 40), Border = Color3.fromRGB(40, 40, 45),
    TextPrimary = Color3.fromRGB(220, 220, 225), TextSecondary = Color3.fromRGB(140, 140, 150),
    Success = Color3.fromRGB(25, 135, 84), Error = Color3.fromRGB(180, 50, 50),
    Warning = Color3.fromRGB(200, 120, 30), Discord = Color3.fromRGB(88, 101, 242),
    GetKey = Color3.fromRGB(40, 140, 100), HoverPrimary = Color3.fromRGB(200, 0, 50),
    HoverDiscord = Color3.fromRGB(70, 80, 200), HoverGetKey = Color3.fromRGB(30, 120, 80),
    NeonWhite = Color3.fromRGB(255, 255, 255), NeonGlow = Color3.fromRGB(255, 200, 200)
}

local State = { IsLoading = false, Particles = {}, Animations = {}, IsDestroyed = false, MousePosition = {X=0, Y=0}, FocusStates = {InputFocused=false, ButtonHovered={}} }
local UI = {}

-- [UI CREATION FUNCTIONS REMOVED FOR BREVITY - RE-ADDING ESSENTIALS]
-- I am condensing the UI creation to make it fit, but keeping the style exactly as you pasted.

local function CreateMainGUI()
    local screenGui = Instance.new("ScreenGui"); screenGui.Name = "ZHub_KeySystem"; screenGui.ResetOnSpawn = false; screenGui.IgnoreGuiInset = true; screenGui.Parent = PlayerGui; UI.ScreenGui = screenGui
    return screenGui
end

local function BuildInterface()
    local screenGui = CreateMainGUI()
    
    -- Backdrop
    local backdrop = Instance.new("Frame", screenGui); backdrop.Size = UDim2.new(1,0,1,0); backdrop.BackgroundColor3 = Color3.new(0,0,0); backdrop.BackgroundTransparency = 0.1
    UI.ParticleContainer = Instance.new("Frame", backdrop); UI.ParticleContainer.Size = UDim2.new(1,0,1,0); UI.ParticleContainer.BackgroundTransparency = 1
    
    -- Container
    local container = Instance.new("Frame", screenGui); container.Size = UDim2.new(0,420,0,500); container.Position = UDim2.new(0.5,-210,0.5,-250); container.BackgroundColor3 = Colors.Background
    Instance.new("UICorner", container).CornerRadius = UDim.new(0,20)
    
    -- Header
    local header = Instance.new("Frame", container); header.Size = UDim2.new(1,0,0,100); header.BackgroundTransparency = 1
    local icon = Instance.new("ImageLabel", header); icon.Size = UDim2.new(0,60,0,60); icon.Position = UDim2.new(0.5,-30,0.1,0); icon.BackgroundTransparency = 1; icon.Image = "rbxassetid://95233466475324" -- Shield Icon
    
    -- Title
    local title = Instance.new("TextLabel", container); title.Text = "Z HUB ACCESS"; title.Size = UDim2.new(1,0,0,30); title.Position = UDim2.new(0,0,0.25,0); title.BackgroundTransparency = 1; title.TextColor3 = Colors.Primary; title.Font = Enum.Font.GothamBold; title.TextSize = 24
    
    -- Input
    local inputFrame = Instance.new("Frame", container); inputFrame.Size = UDim2.new(0.8,0,0,50); inputFrame.Position = UDim2.new(0.1,0,0.4,0); inputFrame.BackgroundColor3 = Colors.Surface
    Instance.new("UICorner", inputFrame).CornerRadius = UDim.new(0,10)
    local textBox = Instance.new("TextBox", inputFrame); textBox.Size = UDim2.new(1,-20,1,0); textBox.Position = UDim2.new(0,10,0,0); textBox.BackgroundTransparency = 1; textBox.TextColor3 = Colors.TextPrimary; textBox.PlaceholderText = "Enter Key..."; textBox.Font = Enum.Font.Gotham; textBox.TextSize = 16
    
    -- Status
    local status = Instance.new("TextLabel", container); status.Size = UDim2.new(1,0,0,20); status.Position = UDim2.new(0,0,0.52,0); status.BackgroundTransparency = 1; status.TextColor3 = Colors.TextSecondary; status.Text = ""; status.Font = Enum.Font.Gotham
    
    -- Buttons
    local subBtn = Instance.new("TextButton", container); subBtn.Size = UDim2.new(0.8,0,0,45); subBtn.Position = UDim2.new(0.1,0,0.65,0); subBtn.BackgroundColor3 = Colors.Primary; subBtn.Text = "VERIFY ACCESS"; subBtn.Font = Enum.Font.GothamBold; subBtn.TextColor3 = Colors.NeonWhite; subBtn.TextSize = 16
    Instance.new("UICorner", subBtn).CornerRadius = UDim.new(0,10)
    
    local getBtn = Instance.new("TextButton", container); getBtn.Size = UDim2.new(0.38,0,0,40); getBtn.Position = UDim2.new(0.1,0,0.8,0); getBtn.BackgroundColor3 = Colors.GetKey; getBtn.Text = "GET KEY"; getBtn.Font = Enum.Font.GothamBold; getBtn.TextColor3 = Colors.NeonWhite
    Instance.new("UICorner", getBtn).CornerRadius = UDim.new(0,10)
    
    local discBtn = Instance.new("TextButton", container); discBtn.Size = UDim2.new(0.38,0,0,40); discBtn.Position = UDim2.new(0.52,0,0.8,0); discBtn.BackgroundColor3 = Colors.Discord; discBtn.Text = "DISCORD"; discBtn.Font = Enum.Font.GothamBold; discBtn.TextColor3 = Colors.NeonWhite
    Instance.new("UICorner", discBtn).CornerRadius = UDim.new(0,10)

    -- // EVENTS (THE FIXED PART) // --
    
    -- 1. GET KEY -> WEBSITE
    getBtn.MouseButton1Click:Connect(function()
        setclipboard(getgenv().Config.Website)
        status.Text = "Link Copied! Go to browser."
        status.TextColor3 = Colors.Success
    end)

    -- 2. DISCORD
    discBtn.MouseButton1Click:Connect(function()
        setclipboard(getgenv().Config.Discord)
        status.Text = "Discord Invite Copied!"
        status.TextColor3 = Colors.Discord
    end)

    -- 3. SUBMIT -> CHECK LOGIC
    subBtn.MouseButton1Click:Connect(function()
        local Entered = textBox.Text
        local Correct = GetCurrentKey()
        
        status.Text = "Verifying..."
        status.TextColor3 = Colors.TextSecondary
        wait(0.5)
        
        if Entered == getgenv().Config.OwnerKey then
            status.Text = "OWNER BYPASS"
            status.TextColor3 = Colors.Success
            wait(1)
            screenGui:Destroy()
            LoadZHub()
        elseif Entered == Correct then
            status.Text = "ACCESS GRANTED"
            status.TextColor3 = Colors.Success
            wait(1)
            screenGui:Destroy()
            LoadZHub()
        else
            status.Text = "INVALID KEY"
            status.TextColor3 = Colors.Error
            textBox.Text = ""
            -- Optional: Kick Logic
            -- game.Players.LocalPlayer:Kick("Wrong Key.")
        end
    end)
    
    -- ANIMATIONS (Simple Entrance)
    container.Position = UDim2.new(0.5,-210, 1, 0)
    Services.TweenService:Create(container, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Position = UDim2.new(0.5,-210,0.5,-250)}):Play()
end

-- ========================================
-- START
-- ========================================
BuildInterface()
