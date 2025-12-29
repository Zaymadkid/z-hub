--[[
    Z HUB - UNIVERSAL V22 (FORTRESS)
    Security: Anti-Tamper, GUI Watchdog, Honeypots
    Status: PRE-OBFUSCATION SOURCE
    
    [NOTICE]
    A Linkvertise/Monetization system is being prepared for V23.
]]

-- // 1. HONEYPOTS (Fake Data to trick dumpers) // --
getgenv().RealKey = "1234" -- FAKE! If they try this, they fail.
getgenv().AdminPass = "password" -- FAKE!

-- // 2. SECURITY CLOSURE // --
-- Wrapping everything in a function hides variables from 'getgenv' scanners
do
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local CoreGui = game:GetService("CoreGui")
    local LocalPlayer = Players.LocalPlayer
    
    local Authorized = false
    local ScriptLoaded = false
    
    -- // CONFIGURATION // --
    local OwnerKey = "big bro"
    local DiscordLink = "https://discord.gg/YourServer"
    
    -- Real Key Logic (Local variables are harder to scan)
    local function GetSecureKey()
        local Date = os.date("!*t") 
        local Block = math.floor(Date.hour / 7)
        return "ZKEY" .. Date.day .. Block
    end

    -- // 3. MAIN HUB LOADER // --
    local function LoadZHub()
        ScriptLoaded = true
        
        -- NOTIFICATION: COMING SOON
        game.StarterGui:SetCore("SendNotification", {
            Title = "Z HUB NEWS",
            Text = "Premium Key System coming soon! Support the dev.",
            Duration = 10
        })

        -- [[ PASTE Z HUB V21 LOGIC HERE ]] --
        local UserInputService = game:GetService("UserInputService")
        local Workspace = game:GetService("Workspace")
        local TeleportService = game:GetService("TeleportService")
        local Lighting = game:GetService("Lighting")
        local Camera = Workspace.CurrentCamera
        local Mouse = LocalPlayer:GetMouse()

        getgenv().Config = {
            Camlock = { State = false, Prediction = 0.1768521, Smoothing = 0.5, Target = nil },
            Hitbox = { Enabled = false, Size = 10 },
            Movement = { Noclip = false, InfJump = false, Fling = false },
            Visuals = { FOV = false, FOVSize = 100, Crosshair = false, Fullbright = false },
            System = { Notifications = false, MenuKey = Enum.KeyCode.RightControl }
        }

        local Sense = loadstring(game:HttpGet('https://sirius.menu/sense'))()
        Sense.teamSettings.enemy.enabled = false
        Sense.Load()

        -- // DRAWING OBJECTS // --
        local FOVCircle = Drawing.new("Circle")
        FOVCircle.Color = Color3.fromRGB(255, 255, 255); FOVCircle.Thickness = 1; FOVCircle.Transparency = 1; FOVCircle.NumSides = 60; FOVCircle.Radius = 100; FOVCircle.Visible = false; FOVCircle.Filled = false
        local CrosshairX = Drawing.new("Line"); local CrosshairY = Drawing.new("Line")
        CrosshairX.Color = Color3.fromRGB(0, 255, 0); CrosshairY.Color = Color3.fromRGB(0, 255, 0); CrosshairX.Thickness = 1; CrosshairY.Thickness = 1; CrosshairX.Transparency = 1; CrosshairY.Transparency = 1; CrosshairX.Visible = false; CrosshairY.Visible = false

        -- [LOOPS]
        RunService.RenderStepped:Connect(function()
            local Center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
            if getgenv().Config.Visuals.FOV then FOVCircle.Position = Center; FOVCircle.Radius = getgenv().Config.Visuals.FOVSize; FOVCircle.Visible = true else FOVCircle.Visible = false end
            if getgenv().Config.Visuals.Crosshair then
                local Size = 10
                CrosshairX.From = Vector2.new(Center.X - Size, Center.Y); CrosshairX.To = Vector2.new(Center.X + Size, Center.Y); CrosshairY.From = Vector2.new(Center.X, Center.Y - Size); CrosshairY.To = Vector2.new(Center.X, Center.Y + Size)
                CrosshairX.Visible = true; CrosshairY.Visible = true
            else CrosshairX.Visible = false; CrosshairY.Visible = false end
            
            if getgenv().Config.Visuals.Fullbright then
                Lighting.Brightness = 2; Lighting.ClockTime = 14; Lighting.FogEnd = 100000; Lighting.GlobalShadows = false; Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
            end
            
            -- Hitbox
            if getgenv().Config.Hitbox.Enabled then
                for _, Plr in pairs(Players:GetPlayers()) do
                    if Plr ~= LocalPlayer and Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart") then
                        local HRP = Plr.Character.HumanoidRootPart; HRP.Size = Vector3.new(getgenv().Config.Hitbox.Size, getgenv().Config.Hitbox.Size, getgenv().Config.Hitbox.Size); HRP.Transparency = 0.7; HRP.CanCollide = false
                    end
                end
            end
        end)
        
        -- [CAMLOCK]
        local function FindNearestEnemy()
            local Closest, ClosestPlayer = math.huge, nil
            local Center = Vector2.new(game.GuiService:GetScreenResolution().X/2, game.GuiService:GetScreenResolution().Y/2)
            local MaxDist = getgenv().Config.Visuals.FOV and getgenv().Config.Visuals.FOVSize or 5000
            for _, Plr in pairs(Players:GetPlayers()) do
                if Plr ~= LocalPlayer and Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart") and Plr.Character.Humanoid.Health > 0 then
                    local Pos, OnScreen = Camera:WorldToViewportPoint(Plr.Character.HumanoidRootPart.Position)
                    if OnScreen then
                        local Dist = (Center - Vector2.new(Pos.X, Pos.Y)).Magnitude
                        if Dist < Closest and Dist <= MaxDist then Closest = Dist; ClosestPlayer = Plr.Character.HumanoidRootPart end
                    end
                end
            end
            return ClosestPlayer
        end

        RunService.Heartbeat:Connect(function()
            local C = getgenv().Config.Camlock
            if C.State and C.Target and C.Target.Parent and C.Target.Parent.Humanoid.Health > 0 then
                local Goal = C.Target.Position + (C.Target.Velocity * C.Prediction)
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.p, Goal), C.Smoothing)
            else C.State = false; C.Target = nil end
        end)
        
        -- LOAD UI
        local UILib = loadstring(game:HttpGet('https://raw.githubusercontent.com/StepBroFurious/Script/main/HydraHubUi.lua'))()
        local Window = UILib.new("Z HUB | V22 [SECURE]", LocalPlayer.UserId, "User")
        
        local CatCombat = Window:Category("Combat", "http://www.roblox.com/asset/?id=8395747586")
        local SubAim = CatCombat:Button("Aiming", "http://www.roblox.com/asset/?id=8395747586")
        local SectCam = SubAim:Section("Camlock", "Left")
        
        SectCam:Keybind({Title="Camlock Toggle (Q)", Default=Enum.KeyCode.Q}, function()
            local C = getgenv().Config.Camlock
            C.State = not C.State
            if C.State then 
                C.Target = FindNearestEnemy()
                if C.Target then 
                    game.StarterGui:SetCore("SendNotification", {Title = "Z HUB", Text = "Locked: "..C.Target.Parent.Name, Duration = 1})
                end
            else C.Target = nil end
        end)
        SectCam:Textbox({Title="Prediction", Default="0.1768521"}, function(v) if tonumber(v) then getgenv().Config.Camlock.Prediction = tonumber(v) end end)

        local SectTrigger = SubAim:Section("Trigger Bot", "Left")
        SectTrigger:Button({Title="Load Trigger", ButtonName="Execute"}, function() loadstring(game:HttpGet("https://pastebin.com/raw/gwDh0myt"))() end)

        local SectRage = SubAim:Section("Rage", "Left")
        SectRage:Toggle({Title="Hitbox Expander", Default=false}, function(v) getgenv().Config.Hitbox.Enabled = v end)
        SectRage:Slider({Title="Size", Default=10, Min=2, Max=50}, function(v) getgenv().Config.Hitbox.Size = v end)
        
        local CatVis = Window:Category("Visuals", "http://www.roblox.com/asset/?id=8395621517")
        local SubVis = CatVis:Button("Overlays", "http://www.roblox.com/asset/?id=8395621517")
        local SectOverlay = SubVis:Section("Render", "Right")
        SectOverlay:Toggle({Title="Show FOV Circle", Default=false}, function(v) getgenv().Config.Visuals.FOV = v end)
        SectOverlay:Slider({Title="FOV Radius", Default=100, Min=50, Max=500}, function(v) getgenv().Config.Visuals.FOVSize = v end)
        SectOverlay:Toggle({Title="Custom Crosshair", Default=false}, function(v) getgenv().Config.Visuals.Crosshair = v end)
        SectOverlay:Toggle({Title="Fullbright", Default=false}, function(v) getgenv().Config.Visuals.Fullbright = v end)
        
        local SubUtil = Window:Category("Utility", "http://www.roblox.com/asset/?id=8395621517")
        local SectUtil = SubUtil:Button("Main", "http://www.roblox.com/asset/?id=8395621517")
        local SectSrv = SectUtil:Section("Server", "Left")
        SectSrv:Button({Title="Rejoin Server", ButtonName="Rejoin"}, function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end)
    end

    -- // 4. SECURE KEY GUI // --
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ZHub_Security"
    ScreenGui.Parent = CoreGui
    
    -- ANTI-TAMPER WATCHDOG
    -- If they delete the GUI without authorizing, they get kicked.
    ScreenGui.AncestryChanged:Connect(function()
        if not ScreenGui:IsDescendantOf(game) and not Authorized then
            LocalPlayer:Kick("Z HUB SECURITY: Do not delete the Key Menu.")
        end
    end)

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 320, 0, 200)
    Frame.Position = UDim2.new(0.5, -160, 0.5, -100)
    Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui
    
    local Line = Instance.new("Frame"); Line.Size = UDim2.new(1, 0, 0, 2); Line.BackgroundColor3 = Color3.fromRGB(255, 0, 0); Line.Parent = Frame
    local Title = Instance.new("TextLabel"); Title.Text = "Z HUB // SECURITY"; Title.Size = UDim2.new(1, 0, 0, 40); Title.BackgroundTransparency = 1; Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.Font = Enum.Font.Code; Title.TextSize = 20; Title.Parent = Frame

    local Input = Instance.new("TextBox"); Input.Size = UDim2.new(0.8, 0, 0.2, 0); Input.Position = UDim2.new(0.1, 0, 0.4, 0); Input.BackgroundColor3 = Color3.fromRGB(30, 30, 30); Input.TextColor3 = Color3.fromRGB(255, 255, 255); Input.PlaceholderText = "Enter Key..."; Input.Parent = Frame
    local Submit = Instance.new("TextButton"); Submit.Size = UDim2.new(0.35, 0, 0.2, 0); Submit.Position = UDim2.new(0.1, 0, 0.7, 0); Submit.BackgroundColor3 = Color3.fromRGB(200, 0, 0); Submit.Text = "LOGIN"; Submit.TextColor3 = Color3.fromRGB(255, 255, 255); Submit.Parent = Frame
    local GetKey = Instance.new("TextButton"); GetKey.Size = UDim2.new(0.35, 0, 0.2, 0); GetKey.Position = UDim2.new(0.55, 0, 0.7, 0); GetKey.BackgroundColor3 = Color3.fromRGB(50, 50, 50); GetKey.Text = "GET KEY"; GetKey.TextColor3 = Color3.fromRGB(255, 255, 255); GetKey.Parent = Frame

    GetKey.MouseButton1Click:Connect(function() setclipboard(DiscordLink); GetKey.Text = "COPIED"; wait(1); GetKey.Text = "GET KEY" end)

    Submit.MouseButton1Click:Connect(function()
        local Attempt = Input.Text
        local Correct = GetSecureKey()
        
        if Attempt == OwnerKey or Attempt == Correct then
            Authorized = true
            ScreenGui:Destroy()
            LoadZHub()
        else
            -- FAIL LOGIC: KICK PLAYER
            LocalPlayer:Kick("What are you doing? Lock in, that's not your key. 🫩✌️")
        end
    end)
end
