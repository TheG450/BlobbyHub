repeat wait() until game:IsLoaded() and game.Players and game.Players.LocalPlayer and game.Players.LocalPlayer.Character
if game.PlaceId ~= 117856377735280 then
    game.Players.LocalPlayer:Kick("Wrong Map")
    return
end
for i,v in pairs(game:GetService("Workspace"):GetChildren()) do
    if v.Name == "InvisibleWalls" then
        v:Destroy()
    end
end
getgenv().Settings = {
    Speed = nil,
    DeliveryPoint = nil,
    DeliveryPointExtra = nil,
    AutoFarm = nil,
    BlackScreen = nil,
}
local AntiSpam = false

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Blobby Hub" .. " | ".."Build a Car to Kill Zombies",
    SubTitle = "by GZE450#6591",
    TabWidth = 160,
    Size =  UDim2.fromOffset(480, 360), --UDim2.fromOffset(480, 360), --default size (580, 460)
    Acrylic = false, -- การเบลออาจตรวจจับได้ การตั้งค่านี้เป็น false จะปิดการเบลอทั้งหมด
    Theme = "Amethyst", --Amethyst
    MinimizeKey = Enum.KeyCode.P
})

local Tabs = {
    --[[ Tabs --]]
    --pageSetting = Window:AddTab({ Title = "Settings", Icon = "settings" }),
    pageMain = Window:AddTab({ Title = "Main", Icon = "home" }),
}

do
    --[[ MAIN ]]--------------------------------------------------------
    local Main = Tabs.pageMain:AddSection("Main")
    local SelectDelivery = Tabs.pageMain:AddDropdown("SelectDelivery", {
        Title = "Select Delivery",
        Values = {"1", "2", "3", "4", "5", "6"},
        Multi = false,
        Default = getgenv().Settings.DeliveryPoint or "1",
        Callback = function(Value)
            getgenv().Settings.DeliveryPoint = Value
        end
    })
    SelectDelivery:OnChanged(function(Value)
        getgenv().Settings.DeliveryPoint = Value
    end)

    local TweenSpeed = Tabs.pageMain:AddSlider("TweenSpeed", {
        Title = "TweenSpeed",
        Default = 250,
        Min = 50,
        Max = 500,
        Rounding = 0,
        Callback = function(Value)
            getgenv().Settings.Speed = Value
        end
    })
    TweenSpeed:OnChanged(function(Value)
        getgenv().Settings.Speed = Value
    end)

    local TeleportToDelivery = Tabs.pageMain:AddButton({
        Title = "Teleport To Delivery",
        Callback = function()
            local function TP(Target)
                local antifall;
                local TweenService = game:GetService("TweenService")
                local Distance = (Target.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                local Speed = getgenv().Settings.Speed
            
                local Tween = TweenService:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(Distance/Speed), {CFrame = Target})
                if game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("antifall") and game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChildOfClass("BodyVelocity") then
                    local TweenHeight = TweenService:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(1), {CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,50,0)})
                    TweenHeight:Play()
                    TweenHeight.Completed:Connect(function()
                        Tween:Play()
                        Tween.Completed:Connect(function()
                            game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
                            repeat task.wait(.1) until game:GetService("Players").LocalPlayer.PlayerGui.MainGui.Deploy.Main.Deliver.Visible == true
                            task.wait(.5)
                            pcall(function()
                                game:GetService("ReplicatedStorage").RemoteEvents.DeliveryHandlerRemotes.DeliverItems:InvokeServer(getgenv().Settings.DeliveryPoint)
                            end)
                            task.wait(.5)
                            for i,v in pairs(game.Players.LocalPlayer.Character.HumanoidRootPart:GetChildren()) do
                                if v.Name == "antifall" then
                                    v:Destroy()
                                end
                            end
                            wait(2)
                            game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
                            game:GetService("ReplicatedStorage").Shared.DeployHandler.ReturnHome:FireServer()
                            AntiSpam = false
                        end)
                    end)
                else
                    antifall = Instance.new("BodyVelocity", game.Players.LocalPlayer.Character.HumanoidRootPart)
                    antifall.Velocity = Vector3.new(0, 0, 0)
                    antifall.MaxForce = Vector3.new(100000, 100000, 100000)
                    antifall.P = 4750 --1250
                    antifall.Name = "antifall"
                end
            end
            pcall(function()
                if not AntiSpam then
                    AntiSpam = true
                    local function TeleportPoint()
                        for x=1, 2 do
                            if getgenv().Settings.DeliveryPoint == "1" then
                                TP(CFrame.new(-15.5, 461, -1221.5))
                            elseif getgenv().Settings.DeliveryPoint == "2" then
                                TP(CFrame.new(-1018.5, 462.5, -1221.5))
                            elseif getgenv().Settings.DeliveryPoint == "3" then
                                TP(CFrame.new(-2121.5, 462.5, -2134.5))
                            elseif getgenv().Settings.DeliveryPoint == "4" then
                                TP(CFrame.new(-531.75, 462.5, -3354.5))
                            elseif getgenv().Settings.DeliveryPoint == "5" then
                                TP(CFrame.new(-310.5, 462.5, -5784.5))
                            elseif getgenv().Settings.DeliveryPoint == "6" then
                                TP(CFrame.new(-310.5, 462.5, -7339.5))
                            end
                        end
                    end
                    for i,v in pairs(game:GetService("Workspace").BuildZones:GetChildren()) do
                        if v.Name == "Zone" and v.Player.Value == game.Players.LocalPlayer then
                        local Vehicle = v:FindFirstChild("Vehicle") or v:WaitForChild("Vehicle", 9e99)
                        local Count = Vehicle:GetChildren()
                            if #Count == 1 then
                                local CarModel = Vehicle:FindFirstChild("CarModel")
                                for WheelsIndex, WheelsValue in pairs(CarModel:GetChildren()) do
                                    if WheelsValue.Name == "Wheels" and WheelsValue:IsA("Folder") then
                                        for WheelIndex, WheelValue in pairs(WheelsValue:GetChildren()) do
                                            if WheelValue:IsA("BasePart") then
                                                WheelValue:Destroy()
                                            end
                                        end
                                    end
                                end
                                TeleportPoint()
                            else
                                game:GetService("ReplicatedStorage").Shared.DeployHandler.AssembleCar:InvokeServer()
                                wait(1.5)
                                game:GetService("ReplicatedStorage").Shared.DeployHandler.DeployCar:FireServer()
                                wait(.5)
                                local CarModel = Vehicle:FindFirstChild("CarModel")
                                for WheelsIndex, WheelsValue in pairs(CarModel:GetChildren()) do
                                    if WheelsValue.Name == "Wheels" and WheelsValue:IsA("Folder") then
                                        for WheelIndex, WheelValue in pairs(WheelsValue:GetChildren()) do
                                            if WheelValue:IsA("BasePart") then
                                                WheelValue:Destroy()
                                            end
                                        end
                                    end
                                end
                                for BodyIndex, BodyValue in pairs(CarModel:GetChildren()) do
                                    if BodyValue.Name ~= "VehicleSeat" and BodyValue:IsA("Model") then
                                        BodyValue:Destroy()
                                    end
                                end
                                TeleportPoint()
                                
                            end
                        end
                    end
                else
                    Fluent:Notify({
                        Title = "BlobbyHub",
                        Content = "Wait Delivery Success :>",
                        Duration = 5
                    })
                end
            end)
        end
    })
    local Start = false
    local Spawn = false
    local AutoFarm = Tabs.pageMain:AddToggle("AutoFarm", {Title = "Auto Farm", Default = getgenv().Settings.AutoFarm or false })
    local BlackScreen = Tabs.pageMain:AddToggle("BlackScreen", {Title = "BlackScreen", Default = getgenv().Settings.BlackScreen or false })
    -- local FixBug = Tabs.pageMain:AddButton({
    --     Title = "FixBug",
    --     Callback = function()
    --         Spawn = false
    --         Start = false
    --     end
    -- })

    --[[ SCRIPTS ]]--------------------------------------------------------
    
    AutoFarm:OnChanged(function()
        task.spawn(function()
            local function Notify(Content, Duration)
                Fluent:Notify({
                    Title = "BlobbyHub",
                    Content = Content,
                    Duration = Duration
                })
            end
            local function TP(Target)
                local antifall;
                local TweenService = game:GetService("TweenService")
                local Distance = (Target.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                local Speed = getgenv().Settings.Speed
            
                local Tween = TweenService:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(Distance/Speed, Enum.EasingStyle.Linear), {CFrame = Target})
                if not AutoFarm.Value then
                    Tween:Cancel()
                end
                if game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("antifall") and game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChildOfClass("BodyVelocity") then
                    local TweenHeight = TweenService:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(1, Enum.EasingStyle.Linear), {CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,100,0)})
                    TweenHeight:Play()
                    TweenHeight.Completed:Connect(function()
                        Tween:Play()
                        Tween.Completed:Connect(function()
                            game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
                            repeat task.wait(.1) until game:GetService("Players").LocalPlayer.PlayerGui.MainGui.Deploy.Main:FindFirstChild("Deliver").Visible
                            task.wait(.5)
                            pcall(function()
                                game:GetService("ReplicatedStorage").RemoteEvents.DeliveryHandlerRemotes.DeliverItems:InvokeServer(getgenv().Settings.DeliveryPoint)
                            end)
                            task.wait(.5)
                            for i,v in pairs(game.Players.LocalPlayer.Character.HumanoidRootPart:GetChildren()) do
                                if v.Name == "antifall" then
                                    v:Destroy()
                                end
                            end
                            wait(1)
                            Notify("Delivery Success", 2)
                            game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
                            game:GetService("ReplicatedStorage").Shared.DeployHandler.ReturnHome:FireServer()
                            wait(2)
                            Spawn = false
                            Start = false
                        end)
                    end)
                else
                    antifall = Instance.new("BodyVelocity", game.Players.LocalPlayer.Character.HumanoidRootPart)
                    antifall.Velocity = Vector3.new(0, 0, 0)
                    antifall.MaxForce = Vector3.new(100000, 100000, 100000)
                    antifall.P = 1250 --1250
                    antifall.Name = "antifall"
                end
            end
            local function TeleportPoint()
                for x=1, 2 do
                    if getgenv().Settings.DeliveryPoint == "1" then
                        TP(CFrame.new(-15.5, 461, -1221.5))
                    elseif getgenv().Settings.DeliveryPoint == "2" then
                        TP(CFrame.new(-1018.5, 462.5, -1221.5))
                    elseif getgenv().Settings.DeliveryPoint == "3" then
                        TP(CFrame.new(-2121.5, 462.5, -2134.5))
                    elseif getgenv().Settings.DeliveryPoint == "4" then
                        TP(CFrame.new(-531.75, 462.5, -3354.5))
                    elseif getgenv().Settings.DeliveryPoint == "5" then
                        TP(CFrame.new(-310.5, 462.5, -5784.5))
                    elseif getgenv().Settings.DeliveryPoint == "6" then
                        TP(CFrame.new(-310.5, 462.5, -7339.5))
                    end
                end
            end
            spawn(function()
                pcall(function()
                    for i,v in pairs(game:GetService("Workspace"):GetChildren()) do
                        if v.Name == "Trees" or v.Name == "Towers" or v.Name == "DesertHouses" or v.Name == "IceSpikes" or v.Name == "Barricades" or v.Name == "Mountian" or v.Name == "Rocks" or v.Name == "Roadblocks" or v.Name == "IceRoadBlockers" or v.Name == "SnowHills" or v.Name == "BreakingPlatforms" or v.Name == "ForestHills" or v.Name == "ContainersOnRoad" or v.Name == "Containers" or v.Name == "CaveRocks" or v.Name == "IceBridge" or v.Name == "IceWall" or v.Name == "DesertRoadBlocker" then
                            v:Destroy()
                        end
                    end
                end)
            end)
            while AutoFarm.Value do
                wait()
                pcall(function()
                    for i,v in pairs(game:GetService("Workspace").BuildZones:GetChildren()) do
                        if v.Name == "Zone" and v.Player.Value == game.Players.LocalPlayer then
                        local Vehicle = v:FindFirstChild("Vehicle") or v:WaitForChild("Vehicle", 9e99)
                        local Count = Vehicle:GetChildren()
                            if #Count == 1 then
                                local CarModel = Vehicle:FindFirstChild("CarModel")
                                for CrateIndex, CrateValue in pairs(CarModel:GetChildren()) do
                                    if string.find(CrateValue.Name, "Crate") or string.find(CrateValue.Name, "FirstAidKit") or string.find(CrateValue.Name, "WheatPalette") then
                                        if not Start then
                                            Start = true
                                            for WheelsIndex, WheelsValue in pairs(CarModel:GetChildren()) do
                                                if WheelsValue.Name == "Wheels" and WheelsValue:IsA("Folder") then
                                                    for WheelIndex, WheelValue in pairs(WheelsValue:GetChildren()) do
                                                        if WheelValue:IsA("BasePart") then
                                                            WheelValue:Destroy()
                                                        end
                                                    end
                                                end
                                            end
                                            for BodyIndex, BodyValue in pairs(CarModel:GetChildren()) do
                                                if BodyValue.Name ~= "VehicleSeat" and BodyValue:IsA("Model") then
                                                    BodyValue:Destroy()
                                                end
                                            end
                                            TeleportPoint()
                                            Notify("Started Delivery", 2)
                                        end
                                    end
                                end
                            else
                                if not Spawn then
                                    Spawn = true
                                    game:GetService("ReplicatedStorage").Shared.DeployHandler.AssembleCar:InvokeServer()
                                    wait(1.5)
                                    Notify("Deploying Car", 2)
                                    game:GetService("ReplicatedStorage").Shared.DeployHandler.DeployCar:FireServer()
                                    wait(.5)
                                end
                            end
                        end
                    end
                end)
            end
        end)
    end)

    BlackScreen:OnChanged(function()
        task.spawn(function()
            local function CreateBlackScreen(At)
                local blackScreen = Instance.new("ScreenGui")
                blackScreen.Name = "BlackScreen"
                blackScreen.DisplayOrder = 1e+07
                blackScreen.IgnoreGuiInset = true
                blackScreen.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
                blackScreen.ResetOnSpawn = false
                blackScreen.Parent = At
        
                local frame = Instance.new("Frame")
                frame.Name = "Frame"
                frame.AnchorPoint = Vector2.new(0.5, 0.5)
                frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
                frame.BorderSizePixel = 0
                frame.Position = UDim2.fromScale(0.5, 0.5)
                frame.Size = UDim2.fromScale(1, 1)
                frame.ZIndex = 1e+07
                frame.Parent = blackScreen
            end
            if BlackScreen.Value then
                CreateBlackScreen(game:GetService("Players").LocalPlayer.PlayerGui)
            else
                for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui:GetChildren()) do
                    if v.Name == "BlackScreen" then
                        v:Destroy()
                    end
                end    
            end
        end)
    end)

end

-- Anti AFK
task.spawn(function()
    while wait(320) do
        pcall(function()
            local anti = game:GetService("VirtualUser")
            game:GetService("Players").LocalPlayer.Idled:connect(function()
                anti:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
                wait(1)
                anti:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
            end)
        end)
    end
end)

Window:SelectTab(1)

Fluent:Notify({
    Title = "BlobbyHub",
    Content = "Script Has Lodded. Have Fun :>",
    Duration = 5
})