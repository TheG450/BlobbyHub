repeat wait() until game:IsLoaded() and game.Players and game.Players.LocalPlayer and game.Players.LocalPlayer.Character
getgenv().Settings = {
    Rod = nil,
    RealFinish = nil,
    FarmPosition = nil,
    Bait = nil,
    Event = nil,
    Sell = nil,
    Teleport = nil,
    FastShake = nil,
    Zone = nil,
    ZoneE = {},
    UseZone = nil,
    CageCount = nil,
}

local function CreateMobileUI()
    local blobbyGui = Instance.new("ScreenGui")
    blobbyGui.Name = "BlobbyGui"
    blobbyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    blobbyGui.Parent = game.Players.LocalPlayer.PlayerGui

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    mainFrame.BackgroundTransparency = 1
    mainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    mainFrame.BorderSizePixel = 0
    mainFrame.Position = UDim2.fromScale(0.0611, 0.255)
    mainFrame.Size = UDim2.fromScale(0.0547, 0.109)

    local oCButton = Instance.new("ImageButton")
    oCButton.Name = "OCButton"
    oCButton.Image = "rbxassetid://125742484700391"
    oCButton.AnchorPoint = Vector2.new(0.5, 0.5)
    oCButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    oCButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
    oCButton.BorderSizePixel = 0
    oCButton.Position = UDim2.fromScale(0.513, 0.487)
    oCButton.Size = UDim2.fromScale(1, 1)

    local uICorner = Instance.new("UICorner")
    uICorner.Name = "UICorner"
    uICorner.CornerRadius = UDim.new(1, 0)
    uICorner.Parent = oCButton

    local uIStroke = Instance.new("UIStroke")
    uIStroke.Name = "UIStroke"
    uIStroke.Thickness = 2
    uIStroke.Parent = oCButton

    oCButton.Parent = mainFrame

    local uIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
    uIAspectRatioConstraint.Name = "UIAspectRatioConstraint"
    uIAspectRatioConstraint.Parent = mainFrame

    mainFrame.Parent = blobbyGui

    return oCButton
end

local Device;
local oCButton

local Players = game:GetService("Players")
local function checkDevice()
    local player = Players.LocalPlayer
    if player then
        local UserInputService = game:GetService("UserInputService")
        
        if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
            oCButton = CreateMobileUI()
            Device = UDim2.fromOffset(480, 360)
        else
            Device = UDim2.fromOffset(580, 460)
        end
    end
end

checkDevice()


game:GetService("ReplicatedStorage").events.finishedloading:FireServer()
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Blobby Hub" .. " | ".."[🐟] Fisch".." | ".."[Free Version]",
    TabWidth = 160,
    Size =  Device, --UDim2.fromOffset(480, 360), --default size (580, 460)
    Acrylic = false, -- การเบลออาจตรวจจับได้ การตั้งค่านี้เป็น false จะปิดการเบลอทั้งหมด
    Theme = "Amethyst", --Amethyst
    MinimizeKey = Enum.KeyCode.LeftControl
})

if oCButton then
    oCButton.MouseButton1Click:Connect(function()
        local fluentUi = game:GetService("CoreGui"):FindFirstChild("ScreenGui") or game:GetService("CoreGui"):WaitForChild("ScreenGui", 5)
        for i,v in pairs(fluentUi:GetChildren()) do
            if v.Name == "Frame" and v:FindFirstChild("CanvasGroup") then
                local EN = not v.Visible
                v.Visible = EN
            end
        end
    end)
end

local Tabs = {
    --[[ Tabs --]]
    pageSetting = Window:AddTab({ Title = "Settings", Icon = "settings" }),
    pageMain = Window:AddTab({ Title = "Main", Icon = "home" }),
    pageEvent = Window:AddTab({ Title = "Event", Icon = "clock" }),
    pageMiscellaneous = Window:AddTab({ Title = "Miscellaneous", Icon = "component" }),
    pageTeleport = Window:AddTab({ Title = "Teleport", Icon = "map" })
}

do
    --[[ SETTINGS ]]--------------------------------------------------------
    local RodList = {}
    local function GetRodList()
        for i,v in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
            if string.find(v.Name, "Rod") then
                table.insert(RodList, v.Name)
            end
        end
        for i,v in pairs(game:GetService("Players").LocalPlayer.Character:GetChildren()) do
            if string.find(v.Name, "Rod") and v.Name ~= "RodBodyModel" then
                table.insert(RodList, v.Name)
            end
        end
        table.insert(RodList, "Equipment Bag")
        table.insert(RodList, "Bestiary")
    end
    local function RodListRemove()
        if RodList ~= nil then
            for i = #RodList, 1, -1 do
                table.remove(RodList, i)
            end
        end
    end
    GetRodList()
    local SelectRod = Tabs.pageSetting:AddDropdown("SelectRod", {
        Title = "Select Rod",
        Values = RodList,
        Multi = false,
        Default = getgenv().Settings.Rod or RodList[1],
        Callback = function(Value)
            getgenv().Settings.Rod = Value
        end
    })
    local RefreshRod = Tabs.pageSetting:AddButton({
        Title = "Refresh Rod",
        Callback = function()
            local currentSelection = SelectRod.Value
            
            RodListRemove()
            GetRodList()
            SelectRod:SetValues(RodList)
            
            if table.find(RodList, currentSelection) then
                SelectRod:SetValue(currentSelection)
            else
                SelectRod:SetValue(RodList[#RodList])
            end
        end
    })
    SelectRod:OnChanged(function(Value)
        getgenv().Settings.Rod = Value
    end)
    local InstantReel = Tabs.pageSetting:AddToggle("InstantReel", {Title = "Instant ReelFinish", Default = false })
    InstantReel:OnChanged(function(value)
        getgenv().Settings.RealFinish = value
    end)
    local FastShake = Tabs.pageSetting:AddToggle("FastShake", {Title = "Fast Shake", Default = false })
    FastShake:OnChanged(function(value)
        getgenv().Settings.FastShake = value
    end)
    local Zone = Tabs.pageSetting:AddSection("Zone")
    local HowToUse = Tabs.pageSetting:AddParagraph({
        Title = "How To Use Zone",
        Content = "1.Select Zone.\n2.Enable Select Zone.\n3.Enable Safe Mode.\n4.Enable Auto Fishing"
    })
    local ZoneList = {}
    local function zoneListInsert()
        local uniqueZone = {}
        for i, v in pairs(game:GetService("Workspace").zones.fishing:GetChildren()) do
            if v:IsA("BasePart") then
                if not uniqueZone[v.Name] then
                    table.insert(ZoneList, v.Name)
                    uniqueZone[v.Name] = true
                end
            end
        end
    end
    zoneListInsert()
    local SelectDefaultZone = Tabs.pageSetting:AddDropdown("SelectDefaultZone", {
        Title = "Select Default Zone",
        Values = ZoneList,
        Multi = false,
        Default = getgenv().Settings.Zone or "",
        Callback = function(Value)
            getgenv().Settings.Zone = Value
        end
    })
    local SelectEventZone = Tabs.pageSetting:AddDropdown("SelectEventZone", {
        Title = "Select Event Zone",
        Values = {"Isonade", "Moon Pool", "FischFright24", "Whale Shark", "Great White Shark", "Great Hammerhead Shark"},
        Multi = true,
        Default = getgenv().Settings.ZoneE,
    })
    SelectDefaultZone:OnChanged(function(Value)
        getgenv().Settings.Zone = Value
    end)
    SelectEventZone:OnChanged(function(Value)
        local Values = {}
        for Value, State in next, Value do
            table.insert(Values, Value)
        end
        getgenv().Settings.ZoneE = Values
    end)
    local UseZone = Tabs.pageSetting:AddToggle("UseZone", {Title = "Use Zone", Default = false })


    --[[ MAIN ]]--------------------------------------------------------
    local General = Tabs.pageMain:AddSection("General")
    local AutoFishing = Tabs.pageMain:AddToggle("AutoFishing", {Title = "Auto Fishing", Default = false })
    local SafeMode = Tabs.pageMain:AddToggle("SafeMode", {Title = "Safe Mode", Default = false })
    local SellAll = Tabs.pageMain:AddButton({
        Title = "Sell All",
        Description = "Sell All Fishs",
        Callback = function()
            task.spawn(function()
                if game:GetService("Workspace").world.npcs:FindFirstChild("Marc Merchant") then
                    game:GetService("Workspace").world.npcs["Marc Merchant"].merchant.sellall:InvokeServer()
                    return
                elseif game:GetService("Workspace").world.npcs:FindFirstChild("Matt Merchant") then
                    game:GetService("Workspace").world.npcs["Matt Merchant"].merchant.sellall:InvokeServer()
                    return
                elseif game:GetService("Workspace").world.npcs:FindFirstChild("Mike Merchant") then
                    game:GetService("Workspace").world.npcs["Mike Merchant"].merchant.sellall:InvokeServer()
                    return
                elseif game:GetService("Workspace").world.npcs:FindFirstChild("Max Merchant") then
                    game:GetService("Workspace").world.npcs["Max Merchant"].merchant.sellall:InvokeServer()
                    return
                else
                    Fluent:Notify({
                        Title = "WARNING",
                        Content = "Not Found Merchant Near",
                        Duration = 5
                    })
                end
            end)
        end
    })
    local Cage = Tabs.pageMain:AddSection("Cage")
    local InputCage = Tabs.pageMain:AddInput("InputCage", {
        Title = "Input Cage",
        Default = 1,
        Placeholder = "Number Of CrabCages Required",
        Numeric = true, -- Only allows numbers
        Finished = false, -- Only calls callback when you press enter
        Callback = function(Value)
            getgenv().Settings.CageCount = Value
        end
    })
    InputCage:OnChanged(function(value)
        getgenv().Settings.CageCount = value
    end)
    local CalculateMaxCages = Tabs.pageMain:AddButton({
        Title = "Calculate Max Cages",
        Callback = function()
            local MaxCages = game:GetService("ReplicatedStorage").playerstats[tostring(game.Players.LocalPlayer.Name)].Stats.coins.Value / 45
            InputCage:SetValue(tostring(MaxCages))
        end
    })
    local TeleportToDeepslate = Tabs.pageMain:AddButton({
        Title = "Teleport to Deepslate",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1655.48938, -213.679398, -2846.83496, 0.574203014, -1.61517448e-08, 0.81871295, -3.60255825e-08, 1, 4.49946995e-08, -0.81871295, -5.53307018e-08, 0.574203014)
        end
    })
    local AutoBuyCrabCage = Tabs.pageMain:AddToggle("AutoBuyCrabCage", {Title = "Auto Buy CrabCage", Default = false })
    local AutoDeployCage = Tabs.pageMain:AddToggle("AutoDeployCage", {Title = "Auto Deploy Cage", Default = false })
    local AutoCollectCage = Tabs.pageMain:AddToggle("AutoCollectCage", {Title = "Auto Collect Cage", Default = false })
    local Bait = Tabs.pageMain:AddSection("Bait")
    local AutoEquipBait = Tabs.pageMain:AddToggle("AutoEquipBait", {Title = "Auto Equip Bait", Default = false })
    local BaitList = {}
    local BaitEquiped = false
    local function GetBaitList()
        for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.hud.safezone.equipment.bait.scroll.safezone:GetChildren()) do
            if v:IsA("Frame") then
                table.insert(BaitList, v.Name)
            end
        end
        table.insert(BaitList, "None")
    end
    local function BaitListRemove()
        if BaitList ~= nil then
            for i = #BaitList, 1, -1 do
                table.remove(BaitList, i)
            end
        end
    end
    GetBaitList()
    local SelectBait = Tabs.pageMain:AddDropdown("SelectBait", {
        Title = "Select Bait",
        Values = BaitList,
        Multi = false,
        Default = getgenv().Settings.Bait or BaitList[1],
        Callback = function(Value)
            getgenv().Settings.Bait = Value
        end
    })
    SelectBait:OnChanged(function(Value)
        getgenv().Settings.Bait = Value
        BaitEquiped = false
    end)
    local RefreshBait = Tabs.pageMain:AddButton({
        Title = "Refresh Bait",
        Callback = function()
            local currentSelection = SelectBait.Value
            
            BaitListRemove()
            GetBaitList()
            SelectBait:SetValues(BaitList)
            
            if table.find(BaitList, currentSelection) then
                SelectBait:SetValue(currentSelection)
            else
                SelectBait:SetValue(BaitList[#BaitList])
            end
        end
    })
    local Position = Tabs.pageMain:AddSection("Position")
    local SavePosition = Tabs.pageMain:AddButton({
        Title = "Save Farm Position",
        Description = "Auto Fish Farm Position",
        Callback = function()
            Window:Dialog({
                Title = "Save Farm Position",
                Content = "Auto Fish Farm Position",
                Buttons = {
                    {
                        Title = "Confirm",
                        Callback = function()
                            getgenv().Settings.FarmPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                        end
                    },
                    {
                        Title = "Cancel",
                        Callback = function()
                            return
                        end
                    }
                }
            })
        end
    })
    local ResetPosition = Tabs.pageMain:AddButton({
        Title = "Reset Farm Position",
        Description = "Reset Farm Position",
        Callback = function()
            Window:Dialog({
                Title = "Reset Farm Position",
                Content = "Are You Sure To Reset Position?",
                Buttons = {
                    {
                        Title = "Confirm",
                        Callback = function()
                            getgenv().Settings.FarmPosition = nil
                        end
                    },
                    {
                        Title = "Cancel",
                        Callback = function()
                            return
                        end
                    }
                }
            })
        end
    })
    local TeleportPosition = Tabs.pageMain:AddButton({
        Title = "Teleport To Farm Position",
        Description = "Teleport To Farm Position",
        Callback = function()
            Window:Dialog({
                Title = "Teleport To Farm Position",
                Content = "Are You Sure To Teleport To Farm Position?",
                Buttons = {
                    {
                        Title = "Confirm",
                        Callback = function()
                            if getgenv().Settings.FarmPosition ~= nil then
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = getgenv().Settings.FarmPosition
                            end
                        end
                    },
                    {
                        Title = "Cancel",
                        Callback = function()
                            return
                        end
                    }
                }
            })
        end
    })
    local Code = Tabs.pageMain:AddSection("Code")
    local Redeem = Tabs.pageMain:AddButton({
        Title = "Redeem Codes",
        Description = "Redeem All Codes",
        Callback = function()
            local Codes = {
                "ThanksFor10Mil",
                "SorryforShutdown",
                "FischFright2024",
            }
            for _, code in ipairs(Codes) do
                game:GetService("ReplicatedStorage").events.runcode:FireServer(tostring(code))
                wait(1)
            end
        end
    })
    local Manual = Tabs.pageMain:AddSection("Manual")
    local AutoCatch = Tabs.pageMain:AddToggle("AutoCatch", {Title = "Auto Catch", Default = false })
    local AutoShake = Tabs.pageMain:AddToggle("AutoShake", {Title = "Auto Shake", Default = false })
    local AutoReel = Tabs.pageMain:AddToggle("AutoReel", {Title = "Auto Reel", Default = false })


    --[[ EVENT ]]--------------------------------------------------------
    local EventList = {}
    local function GetEventList()
        for i,v in pairs(game:GetService("Workspace").zones.fishing:GetDescendants()) do
            if v:FindFirstChild("POIHeader") then
                table.insert(EventList, tostring(v))
            end
        end
    end
    local function EventListRemove()
        if EventList ~= nil then
            for i = #EventList, 1, -1 do
                table.remove(EventList, i)
            end
        end
    end
    GetEventList()
    local SelectEvent = Tabs.pageEvent:AddDropdown("SelectEvent", {
        Title = "Select Event",
        Values = EventList,
        Multi = false,
        Default = getgenv().Settings.Event or EventList[1],
        Callback = function(Value)
            getgenv().Settings.Event = Value
        end
    })
    local RefreshEvent = Tabs.pageEvent:AddButton({
        Title = "Refresh Event",
        Callback = function()
            local currentSelection = SelectEvent.Value
            
            EventListRemove()
            GetEventList()
            SelectEvent:SetValues(EventList)
            
            if table.find(EventList, currentSelection) then
                SelectEvent:SetValue(currentSelection)
            else
                SelectEvent:SetValue(EventList[#EventList])
            end
        end
    })
    SelectEvent:OnChanged(function(Value)
        getgenv().Settings.Event = Value
    end)
    local TeleportEvent = Tabs.pageEvent:AddButton({
        Title = "Teleport To Selected Event",
        Description = "Teleport To Selected Event",
        Callback = function()
            if getgenv().Settings.Event ~= nil or getgenv().Settings.Event ~= "" then
                for i,v in pairs(game:GetService("Workspace").zones.fishing:GetDescendants()) do
                    if v:FindFirstChild("POIHeader") then
                        if v.Name == getgenv().Settings.Event then
                            local heightAboveWater = 40
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame * CFrame.new(0, heightAboveWater, 0)
                        end
                    end
                end
            else
                Fluent:Notify({
                    Title = "Warning",
                    Content = "Select Event Or Wait Event Spawn.",
                    Duration = 8
                })
            end
        end
    })
    local AutoIngredients = Tabs.pageEvent:AddToggle("AutoIngredients", {Title = "Auto Ingredients", Default = false })
    local AutoUseIngredients = Tabs.pageEvent:AddToggle("AutoUseIngredients", {Title = "Auto Use Ingredients", Default = false })

    --[[ MISCELLANEOUS ]]--------------------------------------------------------
    local BypassAfk = Tabs.pageMiscellaneous:AddButton({
        Title = "Disable AFK Title",
        Description = "Disable AFK Title (Bypass)",
        Callback = function()
            local Remote = game:GetService("ReplicatedStorage").events:WaitForChild("afk")
            local namecall
            namecall = hookmetamethod(game,"__namecall",function(self,...)
                local args = {...}
                local method = getnamecallmethod()
                if not checkcaller() and self == Remote and method == "FireServer" then
                    args[1] = false
                    return namecall(self,unpack(args))
                end
                return namecall(self,...)
            end)
        end
    })
    local Noclip = Tabs.pageMiscellaneous:AddToggle("Noclip", {Title = "Noclip", Default = false })
    local AntiDrowning = Tabs.pageMiscellaneous:AddToggle("AntiDrowning", {Title = "Anti Drowning", Default = false })
    local AutoDeleteFlags = Tabs.pageMiscellaneous:AddToggle("AutoDeleteFlags", {Title = "Auto Delete Flags", Default = false })
    local AutoDeleteCrabCage = Tabs.pageMiscellaneous:AddToggle("AutoDeleteCrabCage", {Title = "Auto Delete CrabCage", Default = false })
    local WalkOnWater = Tabs.pageMiscellaneous:AddToggle("WalkOnWater", {Title = "Walk On Water", Default = false })

    --[[ TELEPORT ]]--------------------------------------------------------
    local TeleportList = {}
    local function GetTeleportList()
        for i,v in pairs(game:GetService("Workspace").world.spawns.TpSpots:GetChildren()) do
            if v:IsA("BasePart") then
                table.insert(TeleportList, v.Name)
            end
        end
    end
    GetTeleportList()
    local SelectTeleport = Tabs.pageTeleport:AddDropdown("SelectTeleport", {
        Title = "Select Teleport",
        Values = TeleportList,
        Multi = false,
        Default = getgenv().Settings.Teleport or TeleportList[1],
        Callback = function(Value)
            getgenv().Settings.Teleport = Value
        end
    })
    SelectTeleport:OnChanged(function(Value)
        getgenv().Settings.Teleport = Value
    end)
    local TeleportIsland = Tabs.pageTeleport:AddButton({
        Title = "Teleport To Island",
        Description = "Teleport To Island",
        Callback = function()
            for i,v in pairs(game:GetService("Workspace").world.spawns.TpSpots:GetChildren()) do
                if v.Name == getgenv().Settings.Teleport and v:IsA("BasePart") then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame     
                end
            end
        end
    })

    --[[ SCRIPTS ]]--------------------------------------------------------
    AutoFishing:OnChanged(function()
        task.spawn(function()
            local GuiService = game:GetService('GuiService')
            local VirtualInputManager = game:GetService('VirtualInputManager')
            local over = game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("over")
            local plr = game:GetService("Players").LocalPlayer
            local character = plr.Character
            local humanoid = character:FindFirstChild("Humanoid")

            local plr = game:GetService("Players").LocalPlayer
            local character = plr.Character
            local Casted = false
            local Teleported = false

            local function getClosest(position, zoneNames)
                local closestPart = nil
                local shortestDistance = math.huge
                
                for _, zonePart in pairs(game:GetService("Workspace").zones.fishing:GetChildren()) do
                    if table.find(zoneNames, zonePart.Name) and zonePart:IsA("BasePart") then
                        local distance = (position - zonePart.Position).Magnitude
                        if distance < shortestDistance then
                            shortestDistance = distance
                            closestPart = zonePart
                        end
                    end
                end
                
                return closestPart
            end
            
            task.spawn(function()
                while AutoFishing.Value do
                    wait()
                    if getgenv().Settings.FarmPosition ~= nil and AutoFishing.Value and not SafeMode.Value then
                        character.HumanoidRootPart.CFrame = getgenv().Settings.FarmPosition
                        --Teleported = true
                        wait(2)
                    end
                end
            end)
            task.spawn(function()
                while AutoFishing.Value do
                    wait()
                    if SafeMode.Value and UseZone.Value then
                        local plr = game:GetService("Players").LocalPlayer
                        local character = plr.Character
                        for i,v in pairs(game:GetService("Workspace"):GetChildren()) do
                            if v.Name == "SafePlace"..tostring(plr.Name) then
                                character.HumanoidRootPart.CFrame = v.CFrame * CFrame.new(0, 3.5, 0)
                                wait(2)
                            end
                        end
                    end
                end
            end)
            task.spawn(function()
                while AutoFishing.Value do
                    wait()
                    if SafeMode.Value == false or UseZone.Value == false then
                        if not character:FindFirstChild(getgenv().Settings.Rod) then
                            for i,v in pairs(plr.Backpack:GetChildren()) do
                                if v.Name == getgenv().Settings.Rod and v:IsA("Tool") then
                                    character.Humanoid:EquipTool(v)
                                end
                            end
                        end
                        if character[getgenv().Settings.Rod].values.casted.Value == false and Casted == false then
                            pcall(function()
                                wait(1)
                                local ohNumber1 = 100
                                character[getgenv().Settings.Rod].events.reset:FireServer()
                                wait(.1)
                                character[getgenv().Settings.Rod].events.cast:FireServer(ohNumber1)
                                Casted = true
                                wait(1)
                            end)
                        elseif character[getgenv().Settings.Rod].values.bite.Value == true then
                            Casted = false
                        end
                        if character:FindFirstChildOfClass("Tool") then
                            if character[getgenv().Settings.Rod].values.casted.Value == true and character[getgenv().Settings.Rod].values.bite.Value == false and character[getgenv().Settings.Rod]:FindFirstChild("bobber") and character[getgenv().Settings.Rod].values.bobberzone.Value ~= "" then
                                pcall(function()
                                    local shakeui = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("shakeui") or game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("shakeui", 5)
                                    if shakeui then
                                        if getgenv().Settings.FastShake == true then
                                            local Button = game:GetService("Players").LocalPlayer.PlayerGui.shakeui.safezone.button:FindFirstChild("ripple")
        
                                            local X = Button.AbsolutePosition.X
                                            local Y = Button.AbsolutePosition.Y
                                            local XS = Button.AbsoluteSize.X
                                            local YS = Button.AbsoluteSize.Y
        
                                            VirtualInputManager:SendMouseButtonEvent(X + XS, Y + YS, 0, true, Button, 1)
                                            VirtualInputManager:SendMouseButtonEvent(X + XS, Y + YS, 0, false, Button, 1)
                                        else
                                            local button = game:GetService("Players").LocalPlayer.PlayerGui.shakeui.safezone:FindFirstChild("button") or game:GetService("Players").LocalPlayer.PlayerGui.shakeui.safezone:WaitForChild("button", 5)
                                            GuiService.SelectedObject = button
                                            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                                            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                                        end
                                    end
                                end)
                            else
                                task.wait()
                            end
                        end
                        if character:FindFirstChildOfClass("Tool") then
                            if character[getgenv().Settings.Rod].values.bite.Value == true and character[getgenv().Settings.Rod].values.casted.Value == true and character[getgenv().Settings.Rod]:FindFirstChild("bobber") and character[getgenv().Settings.Rod].values.bobberzone.Value ~= "" then
                                pcall(function()
                                    if getgenv().Settings.RealFinish == true then
                                        GuiService.SelectedObject = nil
                                        local fish = game:GetService("Players").LocalPlayer.PlayerGui.reel.bar:FindFirstChild("fish") or game:GetService("Players").LocalPlayer.PlayerGui.reel.bar:WaitForChild("fish", 5)
                                        local playerbar = game:GetService("Players").LocalPlayer.PlayerGui.reel.bar:FindFirstChild("playerbar") or game:GetService("Players").LocalPlayer.PlayerGui.reel.bar:WaitForChild("playerbar", 5)
                                        local function fireReelFinished()
                                            game:GetService("ReplicatedStorage").events.reelfinished:FireServer(100, true)
                                        end
                                        coroutine.wrap(function()
                                            fish:GetPropertyChangedSignal("Position"):Wait()
                                            fireReelFinished()
                                        end)()
                                        coroutine.wrap(function()
                                            playerbar:GetPropertyChangedSignal("Position"):Wait()
                                            fireReelFinished()
                                        end)()
                                    else
                                        if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("reel") then
                                            game:GetService("Players").LocalPlayer.PlayerGui.reel.bar.playerbar.Size = UDim2.new(1, 0, 1, 0)
                                        end
                                    end
                                    wait(.5)
                                end)
                            end
                        end
                    elseif SafeMode.Value == true and UseZone.Value == true then
                        if not character:FindFirstChild(getgenv().Settings.Rod) then
                            for i,v in pairs(plr.Backpack:GetChildren()) do
                                if v.Name == getgenv().Settings.Rod and v:IsA("Tool") then
                                    character.Humanoid:EquipTool(v)
                                end
                            end
                        end
                        if character[getgenv().Settings.Rod].values.casted.Value == false and Casted == false then
                            pcall(function()
                                wait(1)
                                local ohNumber1 = 100
                                character[getgenv().Settings.Rod].events.reset:FireServer()
                                wait(.1)
                                character[getgenv().Settings.Rod].events.cast:FireServer(ohNumber1)
                                Casted = true
                                wait(1)
                            end)
                        elseif character[getgenv().Settings.Rod].values.bite.Value == true then
                            Casted = false
                        end
                        if character:FindFirstChildOfClass("Tool") then
                            if character[getgenv().Settings.Rod].values.casted.Value == true and character[getgenv().Settings.Rod].values.bite.Value == false and character[getgenv().Settings.Rod]:FindFirstChild("bobber") and character[getgenv().Settings.Rod].values.bobberzone.Value ~= "" then
                                pcall(function()
                                    local shakeui = game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("shakeui")
                                    if shakeui then
                                        if getgenv().Settings.FastShake == true then
                                            local Button = game:GetService("Players").LocalPlayer.PlayerGui.shakeui.safezone.button:FindFirstChild("ripple")
        
                                            local X = Button.AbsolutePosition.X
                                            local Y = Button.AbsolutePosition.Y
                                            local XS = Button.AbsoluteSize.X
                                            local YS = Button.AbsoluteSize.Y
        
                                            VirtualInputManager:SendMouseButtonEvent(X + XS, Y + YS, 0, true, Button, 1)
                                            VirtualInputManager:SendMouseButtonEvent(X + XS, Y + YS, 0, false, Button, 1)
                                        else
                                            local button = game:GetService("Players").LocalPlayer.PlayerGui.shakeui.safezone:FindFirstChild("button") or game:GetService("Players").LocalPlayer.PlayerGui.shakeui.safezone:WaitForChild("button", 5)
                                            GuiService.SelectedObject = button
                                            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                                            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                                        end
                                        character.HumanoidRootPart.Anchored = true
                                    end
                                end)
                            else
                                wait()
                            end
                        end
                        if character:FindFirstChildOfClass("Tool") then
                            if character[getgenv().Settings.Rod].values.bite.Value == true and character[getgenv().Settings.Rod].values.casted.Value == true and character[getgenv().Settings.Rod]:FindFirstChild("bobber") and character[getgenv().Settings.Rod].values.bobberzone.Value ~= "" then
                                pcall(function()
                                    GuiService.SelectedObject = nil
                                    local fish = game:GetService("Players").LocalPlayer.PlayerGui.reel.bar:FindFirstChild("fish") or game:GetService("Players").LocalPlayer.PlayerGui.reel.bar:WaitForChild("fish", 5)
                                    local playerbar = game:GetService("Players").LocalPlayer.PlayerGui.reel.bar:FindFirstChild("playerbar") or game:GetService("Players").LocalPlayer.PlayerGui.reel.bar:WaitForChild("playerbar", 5)
                                    coroutine.wrap(function()
                                        playerbar.Position = fish.Position
                                    end)()
                                    -- local function fireReelFinished()
                                    --     game:GetService("ReplicatedStorage").events.reelfinished:FireServer(100, true)
                                    --     wait(.1)
                                    --     character.HumanoidRootPart.Anchored = false
                                    -- end
                                    -- coroutine.wrap(function()
                                    --     fish:GetPropertyChangedSignal("Position"):Wait()
                                    --     fireReelFinished()
                                    -- end)()
                                    -- coroutine.wrap(function()
                                    --     playerbar:GetPropertyChangedSignal("Position"):Wait()
                                    --     fireReelFinished()
                                    -- end)()
                                    if getgenv().Settings.RealFinish == true then
                                        playerbar:GetPropertyChangedSignal("Position"):Wait()
                                        game:GetService("ReplicatedStorage").events.reelfinished:FireServer(100, true)
                                    else
                                        playerbar:GetPropertyChangedSignal("Position"):Wait()
                                        game:GetService("ReplicatedStorage").events.reelfinished:FireServer(100, true)
                                    end
                                    coroutine.wrap(function()
                                        playerbar.Position = fish.Position
                                    end)()
                                    character.HumanoidRootPart.Anchored = false
                                    wait(.5)
                                end)
                            end
                        end
                    end
                end
                character.HumanoidRootPart.Anchored = false
                GuiService.SelectedObject = nil
            end)
        end)
    end)

    AutoEquipBait:OnChanged(function()
        task.spawn(function()
            while AutoEquipBait.Value do
                wait(.1)
                if not game:GetService("Players").LocalPlayer.PlayerGui.hud.safezone.backpack:FindFirstChild("bait") and BaitEquiped == false then
                    game:GetService("Players").LocalPlayer.PlayerGui.hud.safezone.equipment.bait.scroll.safezone.e:FireServer(getgenv().Settings.Bait)
                    BaitEquiped = true
                elseif game:GetService("Players").LocalPlayer.PlayerGui.hud.safezone.backpack:FindFirstChild("bait") and BaitEquiped == false then
                    for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.hud.safezone.backpack:GetDescendants()) do
                        if v.Name == "bait" and v:IsA("TextLabel") then
                            if not string.find(v.Text, getgenv().Settings.Bait) then
                                game:GetService("Players").LocalPlayer.PlayerGui.hud.safezone.equipment.bait.scroll.safezone.e:FireServer(getgenv().Settings.Bait)
                                BaitEquiped = true
                            elseif getgenv().Settings.Bait == "None" then
                                local ohString1 = "None"
                                game:GetService("Players").LocalPlayer.PlayerGui.hud.safezone.equipment.bait.scroll.safezone.e:FireServer(ohString1)
                                BaitEquiped = true
                            end
                        end
                    end
                end
            end
        end)
    end)

    AutoCatch:OnChanged(function()
        task.spawn(function()
            local GuiService = game:GetService('GuiService')
            local VirtualInputManager = game:GetService('VirtualInputManager')
            local plr = game:GetService("Players").LocalPlayer
            local character = plr.Character
            local Casted = false
            while AutoCatch.Value do
                wait()
                if not character:FindFirstChild(getgenv().Settings.Rod) then
                    for i,v in pairs(plr.Backpack:GetChildren()) do
                        if v.Name == getgenv().Settings.Rod and v:IsA("Tool") then
                            character.Humanoid:EquipTool(v)
                        end
                    end
                end
                if character[getgenv().Settings.Rod].values.casted.Value == false and Casted == false then
                    wait(1)
                    local ohNumber1 = 100
                    character[getgenv().Settings.Rod].events.reset:FireServer()
                    wait(.1)
                    character[getgenv().Settings.Rod].events.cast:FireServer(ohNumber1)
                    Casted = true
                    wait(1)
                elseif character[getgenv().Settings.Rod].values.bite.Value == true then
                    Casted = false
                end
            end
        end)
    end)

    AutoShake:OnChanged(function()
        task.spawn(function()
            local GuiService = game:GetService('GuiService')
            local VirtualInputManager = game:GetService('VirtualInputManager')
            local plr = game:GetService("Players").LocalPlayer
            local character = plr.Character
            while AutoShake.Value do
                wait()
                if character:FindFirstChildOfClass("Tool") then
                    if character[getgenv().Settings.Rod].values.casted.Value == true and character[getgenv().Settings.Rod].values.bite.Value == false and character[getgenv().Settings.Rod]:FindFirstChild("bobber") and character[getgenv().Settings.Rod].values.bobberzone.Value ~= "" then
                        pcall(function()
                            local shakeui = game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("shakeui")
                            if shakeui then
                                if getgenv().Settings.FastShake == true then
                                    local Button = game:GetService("Players").LocalPlayer.PlayerGui.shakeui.safezone.button:FindFirstChild("ripple")

                                    local X = Button.AbsolutePosition.X
                                    local Y = Button.AbsolutePosition.Y
                                    local XS = Button.AbsoluteSize.X
                                    local YS = Button.AbsoluteSize.Y

                                    VirtualInputManager:SendMouseButtonEvent(X + XS, Y + YS, 0, true, Button, 1)
                                    VirtualInputManager:SendMouseButtonEvent(X + XS, Y + YS, 0, false, Button, 1)
                                else
                                    local button = game:GetService("Players").LocalPlayer.PlayerGui.shakeui.safezone:FindFirstChild("button")
                                    GuiService.SelectedObject = button
                                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                                end
                            end
                        end)
                    else
                        task.wait()
                    end
                else
                    GuiService.SelectedObject = nil
                    wait(.1)
                end
            end
            GuiService.SelectedObject = nil
        end)
    end)

    AutoReel:OnChanged(function()
        task.spawn(function()
            while AutoReel.Value do
                wait()
                local GuiService = game:GetService('GuiService')
                local VirtualInputManager = game:GetService('VirtualInputManager')
                local plr = game:GetService("Players").LocalPlayer
                local character = plr.Character
                if character:FindFirstChildOfClass("Tool") then
                    if character[getgenv().Settings.Rod].values.bite.Value == true and character[getgenv().Settings.Rod].values.casted.Value == true and character[getgenv().Settings.Rod]:FindFirstChild("bobber") and character[getgenv().Settings.Rod].values.bobberzone.Value ~= "" then
                        pcall(function()
                            if getgenv().Settings.RealFinish == true then
                                local fish = game:GetService("Players").LocalPlayer.PlayerGui.reel.bar:WaitForChild("fish")
                                fish:GetPropertyChangedSignal('Position'):Wait()
                                game:GetService("ReplicatedStorage").events.reelfinished:FireServer(100, true)
                            else
                                if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("reel") then
                                    game:GetService("Players").LocalPlayer.PlayerGui.reel.bar.playerbar.Size = UDim2.new(1, 0, 1, 0)
                                end
                            end
                            wait(.5)
                        end)
                    end
                end
            end
        end)
    end)

    AutoIngredients:OnChanged(function()
        task.spawn(function()
            while AutoIngredients.Value do
                wait(.1)
                for i,v in pairs(game:GetService("Workspace").active:GetDescendants()) do
                    if v:FindFirstChild("PickupPrompt") then
                        for i2, v2 in pairs(v:GetChildren()) do
                            if v2:IsA("BasePart") then
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v2.CFrame
                                fireproximityprompt(v.PickupPrompt)
                                wait(.2)
                            end
                        end
                    end
                end
            end
        end)
    end)

    AutoUseIngredients:OnChanged(function()
        task.spawn(function()
            local plr = game.Players.LocalPlayer
            local character = plr.Character
            while AutoUseIngredients.Value do
                wait(.1)
                if plr.Backpack:FindFirstChild("Witches Ingredient") or character:FindFirstChild("Witches Ingredient") then
                    if not character:FindFirstChild("Witches Ingredient") then
                        for i,v in pairs(plr.Backpack:GetChildren()) do
                            if v.Name == "Witches Ingredient" and v:IsA("Tool") then
                                character.Humanoid:EquipTool(v)
                            end
                        end
                    else
                        for i,v in pairs(game:GetService("Workspace").world.map.halloween.witch.WitchesPot.AcidTop:GetChildren()) do
                            if v.Name == "Prompt" then
                                character.HumanoidRootPart.CFrame = CFrame.new(404.780884, 134.500015, 317.74054, 0.661333382, -3.8419202e-08, -0.750092089, 7.82599141e-09, 1, -4.43193748e-08, 0.750092089, 2.3439668e-08, 0.661333382)
                                fireproximityprompt(v)
                            end
                        end
                    end
                end
            end
        end)
    end)

    AntiDrowning:OnChanged(function()
        task.spawn(function()
            local working = false
            if AntiDrowning.Value then
                game:GetService("Players").LocalPlayer.Character.client.oxygen.Disabled = true
            else
                game:GetService("Players").LocalPlayer.Character.client.oxygen.Disabled = false
            end
        end)
    end)

    AutoDeleteFlags:OnChanged(function()
        task.spawn(function()
            while AutoDeleteFlags.Value do
                wait()
                local Flags = game:GetService("Workspace").active.flags:GetChildren()
                if #Flags > 0 then
                    for i,v in pairs(game:GetService("Workspace").active.flags:GetChildren()) do
                        v:Destroy()
                    end
                else
                    wait(.5)
                end
            end
        end)
    end)

    AutoDeleteCrabCage:OnChanged(function()
        task.spawn(function()
            while AutoDeleteCrabCage.Value do
                wait()
                for i,v in pairs(game:GetService("Workspace").active:GetDescendants()) do
                    if v.Name == "Cage" and v:IsA("Model") then
                        local Cages = v.Parent
                        Cages:Destroy()
                    end
                end
            end
        end)
    end)

    Noclip:OnChanged(function()
        task.spawn(function()
            local Players, RService = game:GetService("Players"), game:GetService("RunService");
            local LocalP, Mouse = Players.LocalPlayer, Players.LocalPlayer:GetMouse();
            local Rm, Index, NIndex, NCall, Caller = getrawmetatable(game), getrawmetatable(game).__index, getrawmetatable(game).__newindex, getrawmetatable(game).__namecall, checkcaller or is_protosmasher_caller

            setreadonly(Rm, false)

            Rm.__newindex = newcclosure(function(self, Meme, Value)
                if Caller() then return NIndex(self, Meme, Value) end 
                if tostring(self) == "HumanoidRootPart" or tostring(self) == "Torso" then 
                    if Meme == "CFrame" and self:IsDescendantOf(LocalP.Character) then 
                        return true
                    end
                end
                return NIndex(self, Meme, Value)
            end)
            setreadonly(Rm, true)

            RService.Stepped:Connect(function()
                if Noclip.Value == true and LocalP and LocalP.Character and LocalP.Character:FindFirstChild("Humanoid") then 
                    pcall(function()
                        LocalP.Character.Head.CanCollide = false 
                        LocalP.Character.Torso.CanCollide = false
                    end)
                elseif Noclip.Value == false and LocalP and LocalP.Character and LocalP.Character:FindFirstChild("Humanoid") then
                    pcall(function()
                        LocalP.Character.Head.CanCollide = true
                        LocalP.Character.Torso.CanCollide = true
                    end)
                end
            end)
        end)
    end)

    WalkOnWater:OnChanged(function()
        task.spawn(function()
            local workspace = game:GetService("Workspace")
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

            if not workspace:FindFirstChild("WATERWALKPART") then
                local float = Instance.new("Part")
                float.Transparency = 0.1
                float.Anchored = true
                float.Name = "WATERWALKPART"
                float.Parent = workspace
                float.Size = Vector3.new(25, 1, 25)
            end
            
            local waterLevelY = 127.5

                while WalkOnWater.Value do
                    wait()
                    local playerY = humanoidRootPart.Position.Y
                    for i,v in pairs(game:GetService("Workspace"):GetChildren()) do
                        if v.Name == "WATERWALKPART" and v:IsA("BasePart") then
                            if playerY <= waterLevelY + 2 and playerY >= waterLevelY - 2 then
                                v.CFrame = humanoidRootPart.CFrame + Vector3.new(0, -3.5, 0)
                            else
                            v.CFrame = v.CFrame
                        end
                    end
                end
            end
        end)
    end)

    SafeMode:OnChanged(function()
        task.spawn(function()
            local workspace = game:GetService("Workspace")
            local player = game:GetService("Players").LocalPlayer
            if SafeMode.Value then
                if not workspace:FindFirstChild("SafePlace"..tostring(player.Name)) then
                    local Safe = Instance.new("Part")
                    Safe.Anchored = true
                    Safe.Name = "SafePlace"..tostring(player.Name)
                    Safe.Parent = workspace
                    Safe.Size = Vector3.new(25, 1, 25)
                    Safe.Position = Vector3.new(471.196 + math.random(-50,50), 824.246, 324.262 + math.random(-50,50))
                else
                    return
                end
            end
        end)
    end)

    UseZone:OnChanged(function()
        task.spawn(function()
            local character = game.Players.LocalPlayer.Character
            local characterPosition = character.HumanoidRootPart.Position

            local function getClosest(position, zoneNames)
                local closestPart = nil
                local shortestDistance = math.huge
                
                for _, zonePart in pairs(game:GetService("Workspace").zones.fishing:GetChildren()) do
                    if table.find(zoneNames, zonePart.Name) and zonePart:IsA("BasePart") then
                        local distance = (position - zonePart.Position).Magnitude
                        if distance < shortestDistance then
                            shortestDistance = distance
                            closestPart = zonePart
                        end
                    end
                end
                
                return closestPart
            end

            while UseZone.Value do
                wait()
                if SafeMode.Value then
                    local Closest = getClosest(character.HumanoidRootPart.Position, {getgenv().Settings.Zone})
                    local ClosestEvent = getClosest(character.HumanoidRootPart.Position, getgenv().Settings.ZoneE)
                    
                    local rod = character:FindFirstChild(getgenv().Settings.Rod)
                    if rod then
                        local bobber = rod:FindFirstChild("bobber") or rod:WaitForChild("bobber", 5)
                        
                        if bobber then
                            if ClosestEvent ~= nil then
                                pcall(function()
                                    bobber.RopeConstraint.Length = math.huge
                                    bobber.CFrame = ClosestEvent.CFrame
                                    wait(0.5)
                                    bobber.Anchored = true
                                end)
                            elseif Closest ~= nil then
                                pcall(function()
                                    bobber.RopeConstraint.Length = math.huge
                                    bobber.CFrame = Closest.CFrame
                                    wait(0.5)
                                    bobber.Anchored = true
                                end)
                            end
                        end
                    end
                end
            end
            
        end)
    end)

    AutoBuyCrabCage:OnChanged(function()
        task.spawn(function()
            local TargetCage = tonumber(getgenv().Settings.CageCount)
            local CurrectCage = 0

            local function firePurchasePrompt()
                for _, v in pairs(game:GetService("Workspace").world.interactables["Crab Cage"]:GetChildren()) do
                    if v.Name == "Crab Cage" and v:FindFirstChild("purchaserompt") then
                        local Prompt = v:FindFirstChild("purchaserompt") or v:WaitForChild("purchaserompt", 5)
                        fireproximityprompt(Prompt)
                        wait(0.1)
                        
                        local confirm = game.Players.LocalPlayer.PlayerGui.over:FindFirstChild("prompt") or game.Players.LocalPlayer.PlayerGui.over:WaitForChild("prompt", 5)
                        if confirm and confirm.confirm then
                            for _, connection in pairs(getconnections(confirm.confirm.MouseButton1Click)) do
                                connection:Fire()
                            end
                        end
                    end
                end
            end
        
            -- Main loop
            while AutoBuyCrabCage.Value do
                wait()
                if CurrectCage >= TargetCage then
                    Fluent:Notify({
                        Title = "BLOBBY HUB",
                        Content = "Bought "..TargetCage.." Cages Done!.",
                        Duration = 5
                    })
                    AutoBuyCrabCage:SetValue(false)
                    wait(1)
                else
                    local Calculator = TargetCage * 45
                    if game:GetService("ReplicatedStorage").playerstats[tostring(game.Players.LocalPlayer.Name)].Stats.coins.Value >= Calculator then
                        pcall(function()
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(473.716766, 150.5, 233.30127, 0.94915241, 1.66443108e-08, -0.314816982, -2.53618833e-08, 1, -2.35946018e-08, 0.314816982, 3.03792227e-08, 0.94915241)
                            wait()
                            local CageShow = game:GetService("Workspace").world.interactables:FindFirstChild("Crab Cage") or game:GetService("Workspace").world.interactables:WaitForChild("Crab Cage", 5)
                            firePurchasePrompt()
                            CurrectCage = CurrectCage + 1
                        end)
                    else
                        Fluent:Notify({
                            Title = "BLOBBY HUB",
                            Content = "Your Dont have Coins For "..TargetCage.." Cages!.",
                            Duration = 5
                        })
                        AutoBuyCrabCage:SetValue(false)
                        break
                    end
                end
            end
        end)        
    end)

    AutoDeployCage:OnChanged(function()
        task.spawn(function()
            while AutoDeployCage.Value do
                wait()
                if game.Players.LocalPlayer.Character:FindFirstChild("Crab Cage") then
                    pcall(function()
                        local ohTable1 = {
                            ["CFrame"] = CFrame.new(335.498871, 126.5, 206.808578, 0.773450553, -1.46618362e-08, 0.633856595, 1.47070112e-09, 1, 2.13365627e-08, -0.633856595, -1.55705635e-08, 0.773450553)
                        }
                        game.Players.LocalPlayer.Character["Crab Cage"].Deploy:FireServer(ohTable1)
                    end)
                else
                    for i,v in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
                        if v.Name == "Crab Cage" and v:IsA("Tool") then
                            game.Players.LocalPlayer.Character.Humanoid:EquipTool(v)
                            wait(.1)
                        end
                    end
                end
            end
        end)
    end)

    AutoCollectCage:OnChanged(function()
        task.spawn(function()
            while AutoCollectCage.Value do
                local PlayerName = game.Players.LocalPlayer.Name
                pcall(function()
                    local PlayerName = game.Players.LocalPlayer.Name
                    for i,v in pairs(game:GetService("Workspace").active:GetChildren()) do
                        if v.Name == PlayerName and v:FindFirstChild("Prompt") then
                            local Prompt = v.Prompt
                            if Prompt.Enabled == true then
                                fireproximityprompt(Prompt)
                                wait(.1)
                            else
                                wait(.1)
                            end
                        end
                    end
                end)
            end
        end)
    end)
end

Fluent:Notify({
    Title = "BLOBBY HUB",
    Content = "The script has been loaded.",
    Duration = 8
})

--ANTI AFK
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

local mt = getrawmetatable(game)
setreadonly(mt, false)

local oldNamecall = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    
    if method == "FireServer" and self.Name == "reelfinished" then
        local A1 = args[1]
        if A1 < 1 then
            args[1] = 100
            args[2] = true
            return oldNamecall(self, unpack(args))
        end
    end
    return oldNamecall(self, ...)
end)

setreadonly(mt, true)

Window:SelectTab(1)