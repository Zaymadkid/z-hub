--[[
    Z HUB - UNIVERSAL V22 (AUTO-UPDATE EDITION)
    UI: Mr.Alegator (Preserved)
    Logic: Zay's 7-Hour Key System + Auto-Update
]]

-- // 1. Z HUB SETTINGS // --
getgenv().KeyConfig = {
    Owner = "big bro",
    Website = "https://yourname.github.io/z-hub",
    Discord = "https://discord.gg/YourServer"
}

-- // 2. AUTO-UPDATE SYSTEM // --
getgenv().ZHubVersion = "1.0.0"

local function CheckUpdates()
    local ok, remote = pcall(function()
        return loadstring(game:HttpGet('https://raw.githubusercontent.com/Zaymadkid/z-hub/main/version.lua'))()
    end)
    
    if ok and remote and remote.Version ~= getgenv().ZHubVersion then
        game.StarterGui:SetCore("SendNotification", {
            Title = "Z HUB UPDATE",
            Text = "Updating to " .. remote.Version .. "...",
            Duration = 3
        })
        task.wait(2)
        loadstring(game:HttpGet('https://raw.githubusercontent.com/Zaymadkid/z-hub/main/zhub-v22-ui.lua'))()
        return true
    end
    return false
end

if CheckUpdates() then return end

-- // 3. KEY GENERATION LOGIC // --
local function GetValidKey()
    local Date = os.date("!*t") 
    local Block = math.floor(Date.hour / 7)
    return "ZKEY" .. Date.day .. Block
end

-- // 4. THE CHEAT LOADER (Runs after success) // --
local function LoadZHub()
    game.StarterGui:SetCore("SendNotification", {
        Title = "Z HUB V22",
        Text = "Access Granted. Loading Fortress...",
        Duration = 5
    })

    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera
    
    getgenv().Config = {
        Camlock = { State = false, Prediction = 0.1768521, Smoothing = 0.5, Target = nil },
        Hitbox = { Enabled = false, Size = 10 },
        Visuals = { FOV = false, FOVSize = 100 }
    }

    loadstring(game:HttpGet('https://raw.githubusercontent.com/StepBroFurious/Script/main/HydraHubUi.lua'))()
    print("Z HUB LOADED")
end

-- ========================================
-- UI CODE
-- ========================================

local Services = {
    Players = game:GetService("Players"),
    TweenService = game:GetService("TweenService"),
    UserInputService = game:GetService("UserInputService"),
    RunService = game:GetService("RunService")
}

local Player = Services.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local Config = { MaxKeyLength = 50, AnimationSpeed = 0.4, ParticleCount = 60, ParticleSpeed = 60 }

local Colors = {
    Background = Color3.fromRGB(18, 18, 22), Surface = Color3.fromRGB(25, 25, 30),
    Primary = Color3.fromRGB(255, 0, 0),
    Secondary = Color3.fromRGB(35, 35, 40), Border = Color3.fromRGB(40, 40, 45),
    TextPrimary = Color3.fromRGB(220, 220, 225), TextSecondary = Color3.fromRGB(140, 140, 150),
    Success = Color3.fromRGB(25, 135, 84), Error = Color3.fromRGB(180, 50, 50),
    Warning = Color3.fromRGB(200, 120, 30), Discord = Color3.fromRGB(60, 70, 180),
    GetKey = Color3.fromRGB(40, 140, 100), HoverPrimary = Color3.fromRGB(200, 0, 0),
    HoverDiscord = Color3.fromRGB(50, 60, 160), HoverGetKey = Color3.fromRGB(30, 120, 80),
    NeonWhite = Color3.fromRGB(255, 255, 255), NeonGlow = Color3.fromRGB(255, 200, 200)
}

local State = { IsLoading = false, Particles = {}, Animations = {}, IsDestroyed = false, MousePosition = {X = 0, Y = 0}, FocusStates = { InputFocused = false, ButtonHovered = {}, AnimationsActive = true } }
local UI = {}

local function CreateMainGUI()
    local screenGui = Instance.new("ScreenGui"); screenGui.Name = "ZHub_Auth"; screenGui.ResetOnSpawn = false; screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; screenGui.IgnoreGuiInset = true; screenGui.DisplayOrder = 100; screenGui.Parent = PlayerGui; UI.ScreenGui = screenGui; return screenGui
end

local function CreateBackdrop(parent) 
    local b = Instance.new("Frame"); b.Size = UDim2.new(1,0,1,0); b.BackgroundColor3 = Color3.new(0,0,0); b.BackgroundTransparency = 0.1; b.Parent = parent; UI.Backdrop = b; return b 
end

local function CreateContainer(parent) 
    local c = Instance.new("Frame"); c.Size = UDim2.new(0,420,0,600); c.Position = UDim2.new(0.5,-210,0.5,-300); c.BackgroundColor3 = Colors.Background; c.Parent = parent; Instance.new("UICorner",c).CornerRadius = UDim.new(0,20); local s = Instance.new("UIStroke",c); s.Color = Colors.Border; s.Transparency = 0.3; UI.Container = c; return c 
end

local function CreateHeader(parent) 
    local h = Instance.new("Frame"); h.Size = UDim2.new(1,0,0,100); h.BackgroundTransparency = 1; h.Parent = parent; local ic = Instance.new("Frame",h); ic.Size = UDim2.new(0,56,0,56); ic.Position = UDim2.new(0.5,-28,0,24); ic.BackgroundColor3 = Colors.Primary; Instance.new("UICorner",ic).CornerRadius = UDim.new(0,14); local img = Instance.new("ImageLabel",ic); img.Size = UDim2.new(0.8,0,0.8,0); img.Position = UDim2.new(0.1,0,0.1,0); img.Image = "rbxassetid://95233466475324"; img.BackgroundTransparency = 1; return h 
end

local function CreateContent(parent) 
    local c = Instance.new("Frame"); c.Size = UDim2.new(1,-64,0,440); c.Position = UDim2.new(0,32,0,120); c.BackgroundTransparency = 1; c.Parent = parent; local t = Instance.new("TextLabel",c); t.Text = "Z HUB LOGIN"; t.Size = UDim2.new(1,0,0,32); t.TextColor3 = Colors.TextPrimary; t.Font = Enum.Font.GothamBold; t.TextSize = 24; t.BackgroundTransparency = 1; local st = Instance.new("TextLabel",c); st.Text = "Authentication Required"; st.Size = UDim2.new(1,0,0,40); st.Position = UDim2.new(0,0,0,40); st.TextColor3 = Colors.TextSecondary; st.BackgroundTransparency = 1; UI.Content = c; return c 
end

local function CreateInputSection(parent)
    local s = Instance.new("Frame", parent); s.Size = UDim2.new(1,0,0,100); s.Position = UDim2.new(0,0,0,100); s.BackgroundTransparency = 1
    local ic = Instance.new("Frame", s); ic.Size = UDim2.new(1,0,0,52); ic.BackgroundColor3 = Colors.Surface; Instance.new("UICorner",ic).CornerRadius = UDim.new(0,12)
    local box = Instance.new("TextBox", ic); box.Size = UDim2.new(1,-24,1,0); box.Position = UDim2.new(0,12,0,0); box.BackgroundTransparency = 1; box.Text = ""; box.PlaceholderText = "Enter Key..."; box.TextColor3 = Colors.TextPrimary; box.Font = Enum.Font.Gotham; box.TextSize = 16; box.ClearTextOnFocus = false
    local cnt = Instance.new("TextLabel", s); cnt.Size = UDim2.new(0,80,0,20); cnt.Position = UDim2.new(1,-85,0,60); cnt.BackgroundTransparency = 1; cnt.Text = "0/50"; cnt.TextColor3 = Colors.TextSecondary; cnt.Font = Enum.Font.Gotham; cnt.TextSize = 12; cnt.TextXAlignment = Enum.TextXAlignment.Right
    UI.Input = { Container = ic, TextBox = box, Counter = cnt }; return s
end

local function CreateButtons(parent)
    local sub = Instance.new("TextButton", parent); sub.Size = UDim2.new(1,0,0,48); sub.Position = UDim2.new(0,0,0,200); sub.BackgroundColor3 = Colors.Primary; sub.Text = "VERIFY KEY"; sub.TextColor3 = Colors.TextPrimary; sub.Font = Enum.Font.GothamMedium; sub.TextSize = 16; Instance.new("UICorner",sub).CornerRadius = UDim.new(0,12)
    local btns = Instance.new("Frame", parent); btns.Size = UDim2.new(1,0,0,48); btns.Position = UDim2.new(0,0,0,260); btns.BackgroundTransparency = 1
    local get = Instance.new("TextButton", btns); get.Size = UDim2.new(0.48,0,1,0); get.BackgroundColor3 = Colors.GetKey; get.Text = "GET KEY"; get.TextColor3 = Colors.TextPrimary; get.Font = Enum.Font.GothamMedium; get.TextSize = 14; Instance.new("UICorner",get).CornerRadius = UDim.new(0,10)
    local disc = Instance.new("TextButton", btns); disc.Size = UDim2.new(0.48,0,1,0); disc.Position = UDim2.new(0.52,0,0,0); disc.BackgroundColor3 = Colors.Discord; disc.Text = "DISCORD"; disc.TextColor3 = Colors.TextPrimary; disc.Font = Enum.Font.GothamMedium; disc.TextSize = 14; Instance.new("UICorner",disc).CornerRadius = UDim.new(0,10)
    
    UI.Buttons = { Submit = sub, GetKey = get, Discord = disc }; return {sub, get, disc}
end

local function CreateStatus(parent)
    local s = Instance.new("TextLabel", parent); s.Size = UDim2.new(1,0,0,60); s.Position = UDim2.new(0,0,0,330); s.BackgroundTransparency = 1; s.Text = ""; s.TextColor3 = Colors.Error; s.TextSize = 14; s.Font = Enum.Font.Gotham; UI.Status = s; return s
end

local function CreateParticleContainer(parent) 
    local c = Instance.new("Frame", parent); c.Size = UDim2.new(1,0,1,0); c.BackgroundTransparency = 1; UI.ParticleContainer = c; return c 
end

local function CreateParticle()
    if not UI.ParticleContainer or State.IsDestroyed then return end
    local p = Instance.new("Frame", UI.ParticleContainer); p.Size = UDim2.new(0,math.random(5,15),0,math.random(5,15)); p.Position = UDim2.new(math.random(),0,1.1,0); p.BackgroundColor3 = Colors.NeonWhite; p.BackgroundTransparency = 0.6; Instance.new("UICorner",p).CornerRadius = UDim.new(1,0)
    Services.TweenService:Create(p, TweenInfo.new(math.random(3,6), Enum.EasingStyle.Linear), {Position = UDim2.new(p.Position.X.Scale + (math.random()-0.5)*0.5, 0, -0.1, 0), BackgroundTransparency = 1}):Play()
    game.Debris:AddItem(p, 6)
end

local function ConnectEvents()
    task.spawn(function() while not State.IsDestroyed do CreateParticle(); task.wait(0.2) end end)

    UI.Input.TextBox:GetPropertyChangedSignal("Text"):Connect(function()
        UI.Input.Counter.Text = #UI.Input.TextBox.Text .. "/" .. Config.MaxKeyLength
    end)

    UI.Buttons.Submit.MouseButton1Click:Connect(function()
        if State.IsLoading then return end
        
        local Key = UI.Input.TextBox.Text
        local ValidKey = GetValidKey()
        local OwnerKey = getgenv().KeyConfig.Owner
        
        State.IsLoading = true
        UI.Buttons.Submit.Text = "VERIFYING..."
        UI.Status.Text = "Checking Database..."
        UI.Status.TextColor3 = Colors.TextSecondary
        
        task.wait(1.5)
        
        if Key == ValidKey or Key == OwnerKey then
            UI.Status.Text = "ACCESS GRANTED"
            UI.Status.TextColor3 = Colors.Success
            task.wait(1)
            
            State.IsDestroyed = true
            UI.ScreenGui:Destroy()
            LoadZHub()
        else
            UI.Status.Text = "INVALID KEY - KICKING..."
            UI.Status.TextColor3 = Colors.Error
            task.wait(1)
            Player:Kick("Z HUB SECURITY: Invalid Key. Get a key from the website.")
        end
        
        State.IsLoading = false
        UI.Buttons.Submit.Text = "VERIFY KEY"
    end)

    UI.Buttons.GetKey.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(getgenv().KeyConfig.Website)
            UI.Status.Text = "Website Link Copied!"
            UI.Status.TextColor3 = Colors.Success
        end
    end)

    UI.Buttons.Discord.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(getgenv().KeyConfig.Discord)
            UI.Status.Text = "Discord Invite Copied!"
            UI.Status.TextColor3 = Colors.Discord
        end
    end)
end

local function Initialize()
    local screenGui = CreateMainGUI()
    local backdrop = CreateBackdrop(screenGui)
    CreateParticleContainer(backdrop)
    local container = CreateContainer(screenGui)
    CreateHeader(container)
    local content = CreateContent(container)
    CreateInputSection(content)
    CreateButtons(content)
    CreateStatus(content)
    
    ConnectEvents()
    
    container.Size = UDim2.new(0,0,0,0)
    Services.TweenService:Create(container, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Size = UDim2.new(0,420,0,600)}):Play()
end

Initialize()
