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
    DeployCage = nil,
    AutoCagePosition = {
        Position1 = nil,
        Position2 = nil,
        position3 = nil,
    },
    Totems = nil,
    AutoFishing = nil,
    AutoEquipBait = nil,
    SafeMode = nil,
    AutoNuke = nil,
    WebhookLink = nil,
    TravellingMerchant = nil,
}

local FileName = tostring(game.Players.LocalPlayer.UserId).."_Settings.Blobby"
local BaseFolder = "BLOBBYHUB"
local SubFolder = "Fisch"

function SaveSetting()
    local json
    local HttpService = game:GetService("HttpService")
    if writefile then
        json = HttpService:JSONEncode(getgenv().Settings)
        makefolder(BaseFolder)
        makefolder(BaseFolder.."\\"..SubFolder)
        writefile(BaseFolder.."\\"..SubFolder.."\\"..FileName, json)
    else
        warn("ERROR: Can't save your settings")
    end
end

function LoadSetting()
    local HttpService = game:GetService("HttpService")
    if readfile and isfile and isfile(BaseFolder.."\\"..SubFolder.."\\"..FileName) then
        getgenv().Settings = HttpService:JSONDecode(readfile(BaseFolder.."\\"..SubFolder.."\\"..FileName))
        print("Settings loaded successfully!")
    end
end


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
LoadSetting()
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Blobby Hub" .. " | ".."[UPD] Fisch".." | ".."[Version 1.05.0]",
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
    pageExtra = Window:AddTab({ Title = "Extra", Icon = "bar-chart" }),
    pageEvent = Window:AddTab({ Title = "Event", Icon = "clock" }),
    pageItem = Window:AddTab({ Title = "Item", Icon = "shopping-cart" }),
    pageMiscellaneous = Window:AddTab({ Title = "Miscellaneous", Icon = "component" }),
    pageTeleport = Window:AddTab({ Title = "Teleport", Icon = "map" }),
    pageWebhook = Window:AddTab({ Title = "Webhooks", Icon = "globe" }),
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
            SaveSetting()
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
        SaveSetting()
    end)
    local InstantReel = Tabs.pageSetting:AddToggle("InstantReel", {Title = "Instant ReelFinish", Default = getgenv().Settings.RealFinish or true})
    InstantReel:OnChanged(function(value)
        getgenv().Settings.RealFinish = value
        SaveSetting()
    end)
    local FastShake = Tabs.pageSetting:AddToggle("FastShake", {Title = "Fast Shake", Default = getgenv().Settings.FastShake or true })
    FastShake:OnChanged(function(value)
        getgenv().Settings.FastShake = value
        SaveSetting()
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
            SaveSetting()
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
        SaveSetting()
    end)
    SelectEventZone:OnChanged(function(Value)
        local Values = {}
        for Value, State in next, Value do
            table.insert(Values, Value)
        end
        getgenv().Settings.ZoneE = Values
        SaveSetting()
    end)
    local UseZone = Tabs.pageSetting:AddToggle("UseZone", {Title = "Use Zone", Default = getgenv().Settings.UseZone or false })


    --[[ MAIN ]]--------------------------------------------------------
    local General = Tabs.pageMain:AddSection("General")
    local AutoFishing = Tabs.pageMain:AddToggle("AutoFishing", {Title = "Auto Fishing", Default = getgenv().Settings.AutoFishing or false })
    local AutoNuke = Tabs.pageMain:AddToggle("AutoNuke", {Title = "Auto Nuke MiniGame", Default = getgenv().Settings.AutoNuke or true })
    local SafeMode = Tabs.pageMain:AddToggle("SafeMode", {Title = "Safe Mode", Default = getgenv().Settings.SafeMode or false })
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
    local Bait = Tabs.pageMain:AddSection("Bait")
    local AutoEquipBait = Tabs.pageMain:AddToggle("AutoEquipBait", {Title = "Auto Equip Bait", Default = getgenv().Settings.AutoEquipBait or false })
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
            SaveSetting()
        end
    })
    SelectBait:OnChanged(function(Value)
        getgenv().Settings.Bait = Value
        BaitEquiped = false
        SaveSetting()
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
                            SaveSetting()
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
                            SaveSetting()
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

    --[[ EXTRA]]--------------------------------------------------------
    local Cage = Tabs.pageExtra:AddSection("Cage (Manual)")
    local InputCage = Tabs.pageExtra:AddInput("InputCage", {
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
    local AutoBuyCrabCage = Tabs.pageExtra:AddToggle("AutoBuyCrabCage", {Title = "Auto Buy CrabCage", Default = false })
    local InputDCage = Tabs.pageExtra:AddInput("InputDCage", {
        Title = "Input Deploy Cage",
        Default = 1,
        Placeholder = "Number To Deploy",
        Numeric = true,
        Finished = false,
        Callback = function(Value)
            getgenv().Settings.DeployCage = Value
        end
    })
    InputDCage:OnChanged(function(value)
        getgenv().Settings.DeployCage = value
    end)
    local DeployCageButton = Tabs.pageExtra:AddButton({
        Title = "Deply Cage(Manual)",
        Callback = function()
            for i=1, tonumber(getgenv().Settings.DeployCage) do
                pcall(function()
                    local ohTable1 = {
                        ["CFrame"] = CFrame.new(335.498871, 126.5, 206.808578, 0.773450553, -1.46618362e-08, 0.633856595, 1.47070112e-09, 1, 2.13365627e-08, -0.633856595, -1.55705635e-08, 0.773450553)
                    }
                    game.Players.LocalPlayer.Character["Crab Cage"].Deploy:FireServer(ohTable1)
                end)
            end
        end
    })
    local AutoDeployCage = Tabs.pageExtra:AddToggle("AutoDeployCage", {Title = "Auto Deploy Cage", Default = false })
    local AutoCollectCage = Tabs.pageExtra:AddToggle("AutoCollectCage", {Title = "Auto Collect Cage", Default = false })
    local CalculateMaxCages = Tabs.pageExtra:AddButton({
        Title = "Calculate Max Cages",
        Callback = function()
            local coins = game:GetService("ReplicatedStorage").playerstats[tostring(game.Players.LocalPlayer.Name)].Stats.coins.Value
            local MaxCages = math.floor(coins / 45)
            InputCage:SetValue(tostring(MaxCages))
        end
    })
    local TeleportToDeepslate = Tabs.pageExtra:AddButton({
        Title = "Teleport to Deepslate",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1655.48938, -213.679398, -2846.83496, 0.574203014, -1.61517448e-08, 0.81871295, -3.60255825e-08, 1, 4.49946995e-08, -0.81871295, -5.53307018e-08, 0.574203014)
        end
    })
    local BuyLuck = Tabs.pageExtra:AddButton({
        Title = "Buy Luck",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-930.627136, 223.783569, -988.325378, 0.950611174, 7.35006767e-09, -0.310384303, -2.37664355e-09, 1, 1.64016143e-08, 0.310384303, -1.48538852e-08, 0.950611174)
            wait(2)
            game.Workspace.world.npcs.Merlin.Merlin.luck:InvokeServer()
        end
    })
    local CageAutoTitle = Tabs.pageExtra:AddSection("Cage (Automatic)")
    local AutoFarmCages = Tabs.pageExtra:AddToggle("AutoFarmCages", {Title = "Auto Farm Cages", Default = false })
    local SavePosition1 = Tabs.pageExtra:AddButton({
        Title = "Save Farm Position1",
        Description = "Auto Cage Farm Position1",
        Callback = function()
            getgenv().Settings.AutoCagePosition.Position1 = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
            SaveSetting()
        end
    })
    local SavePosition2 = Tabs.pageExtra:AddButton({
        Title = "Save Farm Position2",
        Description = "Auto Cage Farm Position2",
        Callback = function()
            getgenv().Settings.AutoCagePosition.Position2 = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
            SaveSetting()
        end
    })
    local SavePosition3 = Tabs.pageExtra:AddButton({
        Title = "Save Farm Position3",
        Description = "Auto Cage Farm Position3",
        Callback = function()
            getgenv().Settings.AutoCagePosition.Position3 = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
            SaveSetting()
        end
    })
    local ResetPosition = Tabs.pageExtra:AddButton({
        Title = "Reset Farm Positions",
        Description = "Reset Farm Positions",
        Callback = function()
            Window:Dialog({
                Title = "Reset Farm Positions",
                Content = "Are You Sure To Reset All Positions?",
                Buttons = {
                    {
                        Title = "Confirm",
                        Callback = function()
                            getgenv().Settings.AutoCagePosition.Position1 = nil
                            getgenv().Settings.AutoCagePosition.Position2 = nil
                            getgenv().Settings.AutoCagePosition.Position3 = nil
                            SaveSetting()
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
            SaveSetting()
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
        SaveSetting()
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
    local Teasure = Tabs.pageEvent:AddSection("Teasure")
    local TeleportToTeasure = Tabs.pageEvent:AddButton({
        Title = "Teleport To Teasure",
        Callback = function()
            for i, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui:GetChildren()) do
                if v.Name == "Treasure Map" then
                    if v.Enabled == true then
                        local Coordination = v.Main:FindFirstChild("CoordinatesLabel") or v:WaitForChild("CoordinatesLabel", 5)
                        local TreasurePosition = Coordination.Text
                
                        local x, y, z = TreasurePosition:match("X%s*([%d%.%-?]+),%s*Y%s*([%d%.%-?]+),%s*Z%s*([%d%.%-?]+)")
                
                        if x and y and z and not (x:find("?") or y:find("?") or z:find("?")) then
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(tonumber(x), tonumber(y), tonumber(z))
                        else
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2825.10229, 214.454575, 1517.53162, -0.411731094, -6.56982877e-08, 0.911305368, -7.25599421e-08, 1, 3.93096613e-08, -0.911305368, -4.99392563e-08, -0.411731094)
                            wait(.5)
                            Fluent:Notify({
                                Title = "BLOBBY HUB",
                                Content = "Fix Your TeasureMap",
                                Duration = 3
                            })
                        end
                    else
                        Fluent:Notify({
                            Title = "BLOBBY HUB",
                            Content = "Equip Your TeasureMap",
                            Duration = 3
                        })
                    end
                end
            end            
        end
    })


    --[[ ITEM ]]--------------------------------------------------------
    local SelectTotem = Tabs.pageItem:AddDropdown("SelectTotem", {
        Title = "Select Totem",
        Values = {"Sundial Totem","Smokescreen Totem","Tempest Totem","Windset Totem","Aurora Totem"},
        Multi = false,
        Default = getgenv().Settings.Totems or "",
        Callback = function(Value)
            getgenv().Settings.Totems = Value
        end
    })

    local tpTotem = Tabs.pageItem:AddButton({
    Title = "Teleport To Totem",
    Callback = function()
        local TotemsPosition = {
            ["Sundial Totem"] = CFrame.new(-1149.45581, 134.532166, -1077.27539, -0.945118904, 0, -0.326726705, 0, 1, 0, 0.326726705, 0, -0.945118904),
            ["Smokescreen Totem"] = CFrame.new(2791.71216, 137.350662, -629.452271, -0.998513579, 0.0327778272, 0.0435543507, 0.0298345778, 0.997334361, -0.0665888488, -0.0456208885, -0.0651904196, -0.996829748),
            ["Tempest Totem"] = CFrame.new(36.4309044, 133.031143, 1946.11145, 0.602275848, 0, 0.798288047, 0, 1, 0, -0.798288047, 0, 0.602275848),
            ["Windset Totem"] = CFrame.new(2851.60229, 178.119919, 2703.0332, -0.369645119, 3.03834677e-05, 0.929172993, 0.141992167, 0.988256574, 0.0564552285, -0.918259621, 0.152803689, -0.365308523),
            ["Aurora Totem"] = CFrame.new(-1813.20496, -139.332184, -3280.39941, 0.671925902, -0.222812086, -0.70630753, 0.0369239748, 0.962564886, -0.268524557, 0.739697337, 0.154348925, 0.654999435)
        }
        local selectedTotem = getgenv().Settings.Totems
        local totemCFrame = TotemsPosition[selectedTotem]

        if totemCFrame then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = totemCFrame
        end
    end
    })

    local BuyLuck = Tabs.pageItem:AddButton({
        Title = "Buy Luck",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-930.627136, 223.783569, -988.325378, 0.950611174, 7.35006767e-09, -0.310384303, -2.37664355e-09, 1, 1.64016143e-08, 0.310384303, -1.48538852e-08, 0.950611174)
            wait(2)
            game.Workspace.world.npcs.Merlin.Merlin.luck:InvokeServer()
        end
    })

    local BuyRelics = Tabs.pageItem:AddButton({
        Title = "Buy Relics",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-930.627136, 223.783569, -988.325378, 0.950611174, 7.35006767e-09, -0.310384303, -2.37664355e-09, 1, 1.64016143e-08, 0.310384303, -1.48538852e-08, 0.950611174)
            wait(2)
            game.Workspace.world.npcs.Merlin.Merlin.power:InvokeServer()
        end
    })
    
    

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
    local LowGraphic = Tabs.pageMiscellaneous:AddButton({
        Title = "Low Graphic",
        Callback = function()
            _G.Settings = {
                Players = {
                    ["Ignore Me"] = true,
                    ["Ignore Others"] = true
                },
                Meshes = {
                    Destroy = true,
                    LowDetail = true
                },
                Images = {
                    Invisible = true,
                    LowDetail = true,
                    Destroy = true,
                },
                ["No Particles"] = true,
                ["No Camera Effects"] = true,
                ["No Explosions"] = true,
                ["No Clothes"] = true,
                ["Low Water Graphics"] = true,
                ["No Shadows"] = true,
                ["Low Rendering"] = true,
                ["Low Quality Parts"] = true
            }
            loadstring(game:HttpGet("https://raw.githubusercontent.com/CasperFlyModz/discord.gg-rips/main/FPSBooster.lua"))()
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

    --[[ WEBHOOKS ]]--------------------------------------------------------
    local WebhookLink = Tabs.pageWebhook:AddInput("WebhookLink", {
        Title = "Webhook Link",
        Default = getgenv().Settings.WebhookLink or "",
        Placeholder = "Webhook Link",
        Numeric = false,
        Finished = false,
        Callback = function(Value)
            getgenv().Settings.WebhookLink = Value
            SaveSetting()
        end
    })
    WebhookLink:OnChanged(function(Value)
        getgenv().Settings.WebhookLink = Value
        SaveSetting()
    end)
    local SendTravellingMerchant = Tabs.pageWebhook:AddToggle("MerchantBoat", {Title = "Merchant Boat", Default = getgenv().Settings.TravellingMerchant or false })

    --[[ SCRIPTS ]]--------------------------------------------------------
    AutoFishing:OnChanged(function()
        task.spawn(function()
            getgenv().Settings.AutoFishing = AutoFishing.Value
            SaveSetting()
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
            getgenv().Settings.AutoEquipBait = AutoEquipBait.Value
            SaveSetting()
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
            getgenv().Settings.SafeMode = SafeMode.Value
            SaveSetting()
            local workspace = game:GetService("Workspace")
            local player = game:GetService("Players").LocalPlayer
            if SafeMode.Value then
                if not workspace:FindFirstChild("SafePlace"..tostring(player.Name)) then
                    local Safe = Instance.new("Part")
                    Safe.Anchored = true
                    Safe.Name = "SafePlace"..tostring(player.Name)
                    Safe.Parent = workspace
                    Safe.Size = Vector3.new(25, 1, 25)
                    Safe.Position = Vector3.new(-416.428 + math.random(-50,50), -324.906, 532.835 + math.random(-50,50))
                else
                    return
                end
            end
        end)
    end)

    UseZone:OnChanged(function()
        task.spawn(function()
            getgenv().Settings.UseZone = UseZone.Value
            SaveSetting()
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
                coroutine.wrap(function()
                    pcall(function()
                        for i,v in pairs(game:GetService("Workspace").active:GetChildren()) do
                            if v.Name == tostring(game.Players.LocalPlayer.Name) and v:FindFirstChild("Prompt") then
                                local CageB = v:FindFirstChild("Cage") or v:WaitForChild("Cage", 5)
                                local blocker = v:FindFirstChild("blocker") or v:WaitForChild("blocker", 5)
                                local handle = v:FindFirstChild("handle") or v:WaitForChild("handle", 5)
                                CageB:Destroy()
                                blocker:Destroy()
                                handle:Destroy()
                            end
                        end
                    end)
                end)()
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
                wait()
                pcall(function()
                    local PlayerName = game.Players.LocalPlayer.Name
                    for i,v in pairs(game:GetService("Workspace").active:GetChildren()) do
                        if v.Name == PlayerName and v:FindFirstChild("Prompt") then
                            local Prompt = v:FindFirstChild("Prompt") or v:WaitForChild("Prompt", 5)
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

    AutoNuke:OnChanged(function()
        task.spawn(function()
            getgenv().Settings.AutoNuke = AutoNuke.Value
            SaveSetting()
            local Player = game:GetService("Players").LocalPlayer
            local NukeMinigame = Player.PlayerGui:FindFirstChild("NukeMinigame")
            while AutoNuke.Value do
                wait()

                if NukeMinigame then
                    if NukeMinigame.Enabled == true then
                        local Pointer = NukeMinigame.Center.Marker.Pointer
                        local LeftButton = NukeMinigame.Center.Left
                        local RightButton = NukeMinigame.Center.Right

                        local function pressButton(button)
                            local X = button.AbsolutePosition.X
                            local Y = button.AbsolutePosition.Y
                            local XS = button.AbsoluteSize.X
                            local YS = button.AbsoluteSize.Y

                            game:GetService("VirtualInputManager"):SendMouseButtonEvent(X + XS / 2, Y + YS / 2, 0, true, button, 1)
                            game:GetService("VirtualInputManager"):SendMouseButtonEvent(X + XS / 2, Y + YS / 2, 0, false, button, 1)
                        end

                        local rotation = Pointer.Rotation

                        if rotation > 40 then
                            pressButton(LeftButton)
                        elseif rotation < -40 then
                            pressButton(RightButton)
                        end
                    else
                        wait()
                    end
                end
            end
        end)
    end)

    SendTravellingMerchant:OnChanged(function()
        task.spawn(function()
            getgenv().Settings.TravellingMerchant = SendTravellingMerchant.Value
            SaveSetting()
            local HttpService = game:GetService("HttpService")
            local active = game:GetService("Workspace"):FindFirstChild("active")
            local webhookSent = false

            local function DiscordHook(Link, Tags, Zone, Item1, Item2, Item3)
                local url = Link
                local data = {
                    ["content"] = "",
                    ["embeds"] = {
                        {
                            ["title"] = "***Game: Fisch***",
                            ["description"] = Tags.."\n\n".."**Username:** " .."||"..game.Players.LocalPlayer.Name.."||".."\n"
                                                .."**Travelling Merchant At: **"..Zone.."\n"
                                                .."**Item 1: **"..tostring(Item1).."\n"
                                                .."**Item 2: **"..tostring(Item2).."\n"
                                                .."**Item 3: **"..tostring(Item3).."\n\n"
                                                .."```".."\n"
                                                .."game:GetService"..'('..'"'.."TeleportService"..'"'..')'..":TeleportToPlaceInstance"..'('..tostring(game.PlaceId)..", "..'"'..tostring(game.JobId)..'"'..", ".."game.Players.LocalPlayer"..")".."\n"
                                                .."```".."",
                            ["type"] = "rich",
                            ["color"] = tonumber(0x9966CC),
                            ["image"] = {
                                ["url"] = "http://www.roblox.com/Thumbs/Avatar.ashx?x=150&y=150&Format=Png&username=" ..
                                    tostring(game:GetService("Players").LocalPlayer.Name)
                            }
                        }
                    }
                }
                local newdata = HttpService:JSONEncode(data)
                local headers = {
                    ["content-type"] = "application/json"
                }
                request = http_request or request or HttpPost or syn.request
                local HOOK = {Url = url, Body = newdata, Method = "POST", Headers = headers}
                request(HOOK)
            end

            if active then
                active.ChildAdded:Connect(function(child)
                    if SendTravellingMerchant.Value then
                        if child.Name == "Merchant Boat" and child:IsA("Model") and not webhookSent then
                            webhookSent = true
                            local Items
                            local filteredItems = {}

                            task.wait(5)
                            for i = 1, 10 do
                                Items = child:GetChildren()
                                if #Items > 0 then break end
                                wait(0.5)
                            end

                            for _, item in pairs(Items) do
                                if item.Name ~= "Boat" and item.Name ~= "1" and item.Name ~= "2" and item.Name ~= "3" then
                                    table.insert(filteredItems, item.Name)
                                end
                            end

                            local Item1 = filteredItems[1] or "N/A"
                            local Item2 = filteredItems[2] or "N/A"
                            local Item3 = filteredItems[3] or "N/A"
                            DiscordHook(
                                tostring(getgenv().Settings.WebhookLink),
                                "@everyone",
                                tostring(game.Players.LocalPlayer.Character.zone.Value),
                                Item1,
                                Item2,
                                Item3
                            )
                        end
                    end
                end)

                active.ChildRemoved:Connect(function(child)
                    if child.Name == "Merchant Boat" then
                        webhookSent = false
                    end
                end)
            end
        end)
    end)

    AutoFarmCages:OnChanged(function()
        task.spawn(function()
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local zone = character:FindFirstChild("zone") or character:WaitForChild("zone", 5)
            local Collected = false
        
            local function CheckCages()
                -- Check player's backpack for Crab Cage tools and validate their stack size
                for _, tool in pairs(player.Backpack:GetChildren()) do
                    if string.find(tool.Name, "Crab Cage") and tool:IsA("Tool") then
                        local toolName = tostring(tool.Name)
                        for _, inventoryItem in pairs(game:GetService("ReplicatedStorage").playerstats[tostring(player.Name)].Inventory:GetChildren()) do
                            if string.find(inventoryItem.Name, toolName) then
                                local stack = inventoryItem:FindFirstChild("Stack") or inventoryItem:WaitForChild("Stack", 5)
                                if stack and stack.Value < 1000 then
                                    return false
                                end
                            end
                        end
                    else
                        for i2,v2 in pairs(character:GetChildren()) do
                            if string.find(v2.Name, "Crab Cage") and tool:IsA("Tool") then
                                return true
                            else
                                return false
                            end
                        end
                    end
                end
                return true
            end
        
            local function Deploy(position)
                pcall(function()
                    local deployData = {
                        ["CFrame"] = position
                    }
                    game.Players.LocalPlayer.Character["Crab Cage"].Deploy:FireServer(deployData)
                end)
            end
        
            local function HandleCrabCages()
                local itemsCollected = 0
                local maxItems = 1000
            
                for _, cage in pairs(game:GetService("Workspace").world.interactables["Crab Cage"]:GetChildren()) do
                    if cage.Name == "Crab Cage" and cage:FindFirstChild("purchaserompt") then
                        local prompt = cage:FindFirstChild("purchaserompt") or cage:WaitForChild("purchaserompt", 5)
                        while itemsCollected < maxItems do
                            fireproximityprompt(prompt)
                            task.wait(0.1) -- รอระหว่างการโต้ตอบ
                            local confirm = game.Players.LocalPlayer.PlayerGui.over:FindFirstChild("prompt") or game.Players.LocalPlayer.PlayerGui.over:WaitForChild("prompt", 5)
                            if confirm and confirm.confirm then
                                for _, connection in pairs(getconnections(confirm.confirm.MouseButton1Click)) do
                                    connection:Fire()
                                    itemsCollected = itemsCollected + 1
                                    if itemsCollected >= maxItems then
                                        break
                                    end
                                end
                            end
                        end
                        if itemsCollected >= maxItems then
                            break
                        end
                    end
                end
            
                if itemsCollected >= maxItems then
                    Collected = true
                else
                    Collected = false
                end
            end            
        
            local function InteractWithActivePrompt()
                local PlayerName = game.Players.LocalPlayer.Name
                local foundObject = false -- ตัวแปรตรวจสอบสถานะ
            
                for _, obj in pairs(game:GetService("Workspace").active:GetChildren()) do
                    if obj.Name == PlayerName and obj:FindFirstChild("Prompt") then
                        foundObject = true
                        local object = obj
                        local Prompt = obj.Prompt
                        while object and object:FindFirstChild("Prompt") do
                            fireproximityprompt(Prompt)
                            task.wait(0.1)
                        end
                    else
                        foundObject = false
                    end
                end
            
                if not foundObject then
                    Collected = false
                end
            end
            
        
            while AutoFarmCages.Value do
                task.wait()
                if zone.Value and zone.Value.Name == "Desolate Deep" then
                    local player = game.Players.LocalPlayer
                    local workspaceActive = game:GetService("Workspace"):FindFirstChild("active")

                    if workspaceActive then
                        local found = false

                        for _, child in pairs(workspaceActive:GetChildren()) do
                            if child.Name == player.Name and child:FindFirstChild("Prompt") then
                                print("Found: " .. child.Name)
                                found = true
                                break
                            end
                        end

                        if not found then
                            print("Not Found")
                        end
                    end

                else
                    character.HumanoidRootPart.CFrame = CFrame.new(-1651.90564, -213.679443, -2842.21362)
                    AutoFarmCages:SetValue(false)
                    Fluent:Notify({
                        Title = "BLOBBY HUB",
                        Content = "Save Your Positions",
                        Duration = 5
                    })
                    task.wait(5)
                end
            end
        end)
        task.spawn(function()
            while AutoFarmCages.Value do
                wait()
                pcall(function()
                    for _, v in pairs(game:GetService("Workspace").active:GetChildren()) do
                        if v.Name == tostring(game.Players.LocalPlayer.Name) and v:FindFirstChild("Prompt") then
                            local CageB = v:FindFirstChild("Cage")
                            local blocker = v:FindFirstChild("blocker")
                            local handle = v:FindFirstChild("handle")
                            if CageB then
                                pcall(function()
                                    --CageB:Destroy()
                                end)
                            end
                            if blocker then
                                pcall(function()
                                   --blocker:Destroy()
                                end)
                            end
                            if handle then
                                pcall(function()
                                    --handle:Destroy()
                                end)
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