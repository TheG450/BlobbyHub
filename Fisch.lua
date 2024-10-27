repeat wait() until game:IsLoaded() and game.Players and game.Players.LocalPlayer and game.Players.LocalPlayer.Character
getgenv().Settings = {
    Rod = nil,
    RealFinish = nil,
    FarmPosition = nil,
    Bait = nil,
    Event = nil,
    Sell = nil,
}

game:GetService("ReplicatedStorage").events.finishedloading:FireServer()
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "BLOBBY HUB " .. "Fisch",
    TabWidth = 160,
    Size = UDim2.fromOffset(480, 360), --default size (580, 460)
    Acrylic = false, -- การเบลออาจตรวจจับได้ การตั้งค่านี้เป็น false จะปิดการเบลอทั้งหมด
    Theme = "Amethyst", --Amethyst
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    --[[ Tabs --]]
    pageSetting = Window:AddTab({ Title = "Settings", Icon = "settings" }),
    pageMain = Window:AddTab({ Title = "Main", Icon = "home" }),
    pageEvent = Window:AddTab({ Title = "Event", Icon = "clock" }),
    pageMiscellaneous = Window:AddTab({ Title = "Miscellaneous", Icon = "component" }),
    pageShop = Window:AddTab({ Title = "Shop", Icon = "shopping-cart" }),
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

    --[[ MAIN ]]--------------------------------------------------------
    local General = Tabs.pageMain:AddSection("General")
    local AutoFishing = Tabs.pageMain:AddToggle("AutoFishing", {Title = "Auto Fishing", Default = false })
    local SellList = {}
    local function GetSellList()
        for i,v in pairs(game:GetService("ReplicatedStorage").resources.items.fish:GetChildren()) do
            if v:IsA("Folder") then
                table.insert(SellList, v.Name)
            end
        end
    end
    GetSellList()
    local SelectSell = Tabs.pageMain:AddDropdown("SelectSell", {
        Title = "Select Sell",
        Values = SellList,
        Multi = false,
        Default = getgenv().Settings.Sell or SellList[1],
        Callback = function(Value)
            getgenv().Settings.Sell = Value
        end
    })
    SelectSell:OnChanged(function(Value)
        getgenv().Settings.Sell = Value
    end)
    local AutoSelectSelled = Tabs.pageMain:AddToggle("AutoSelectSell", {Title = "Auto Selected Sell", Default = false })
    local SellAll = Tabs.pageMain:AddButton({
        Title = "Sell All",
        Description = "Sell All Fishs",
        Callback = function()
            game:GetService("Workspace").world.npcs["Marc Merchant"].merchant.sellall:InvokeServer()
        end
    })
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
    local AntiDrowning = Tabs.pageMiscellaneous:AddToggle("AntiDrowning", {Title = "Anti Drowning", Default = false })


    --[[ SCRIPTS ]]--------------------------------------------------------
    AutoFishing:OnChanged(function()
        task.spawn(function()
            local GuiService = game:GetService('GuiService')
            local VirtualInputManager = game:GetService('VirtualInputManager')
            local over = game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("over")
            local plr = game:GetService("Players").LocalPlayer
            local character = plr.Character
            local humanoid = character:FindFirstChild("Humanoid")

            local Casted = false
            local Teleported = false
            over.ChildAdded:Connect(function()
                wait(.1)
                Casted = false
            end)
            plr.Backpack.ChildAdded:Connect(function()
                Casted = false
            end)
            while AutoFishing.Value do
                wait(.1)
                pcall(function()
                    if getgenv().Settings.FarmPosition ~= nil and not Teleported then
                        character.HumanoidRootPart.CFrame = getgenv().Settings.FarmPosition
                        Teleported = true
                        wait(.5)
                    end
                    character.HumanoidRootPart.Anchored = true
                    if not character:FindFirstChild(getgenv().Settings.Rod) then
                        for i,v in pairs(plr.Backpack:GetChildren()) do
                            if v.Name == getgenv().Settings.Rod and v:IsA("Tool") then
                                humanoid:EquipTool(v)
                            end
                        end
                    elseif character[getgenv().Settings.Rod].values.casted.Value == false and Casted == false then
                        pcall(function()
                            wait(1)
                            local ohNumber1 = 100
                            character[getgenv().Settings.Rod].events.reset:FireServer()
                            wait(.1)
                            character[getgenv().Settings.Rod].events.cast:FireServer(ohNumber1)
                            Casted = true
                            wait(1)
                        end)
                    elseif character[getgenv().Settings.Rod].values.casted.Value == true and character[getgenv().Settings.Rod].values.bite.Value == false and character[getgenv().Settings.Rod]:FindFirstChild("bobber") and character[getgenv().Settings.Rod].values.bobberzone.Value ~= "" then
                        pcall(function()
                            local shakeui = game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("shakeui")
                            if shakeui then
                                local button = game:GetService("Players").LocalPlayer.PlayerGui.shakeui.safezone:FindFirstChild("button")
                                GuiService.SelectedObject = button
                                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                                wait(.2)
                            end
                        end)
                    elseif character[getgenv().Settings.Rod].values.bite.Value == true and character[getgenv().Settings.Rod].values.casted.Value == true and character[getgenv().Settings.Rod]:FindFirstChild("bobber") and character[getgenv().Settings.Rod].values.bobberzone.Value ~= "" then
                        pcall(function()
                            if getgenv().Settings.RealFinish == true then
                                local fish = game:GetService("Players").LocalPlayer.PlayerGui.reel.bar:WaitForChild("fish")
                                local playerbar = game:GetService("Players").LocalPlayer.PlayerGui.reel.bar:WaitForChild("playerbar")
                                local function onPositionChanged()
                                    game:GetService("ReplicatedStorage").events.reelfinished:FireServer(100, true)
                                end
                                fish:GetPropertyChangedSignal('Position'):Connect(onPositionChanged)
                                playerbar:GetPropertyChangedSignal('Position'):Connect(onPositionChanged)
                            else
                                if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("reel") then
                                    game:GetService("Players").LocalPlayer.PlayerGui.reel.bar.playerbar.Size = UDim2.new(1, 0, 1, 0)
                                end
                            end
                            wait(.1)
                        end)
                    end
                end)
            end
            Teleported = false
            Casted = false
            GuiService.SelectedObject = nil
            character.HumanoidRootPart.Anchored = false
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
            while AutoShake.Value do
                wait()
                local GuiService = game:GetService('GuiService')
                local VirtualInputManager = game:GetService('VirtualInputManager')
                local plr = game:GetService("Players").LocalPlayer
                local character = plr.Character
                if character:FindFirstChildOfClass("Tool") then
                    if character[getgenv().Settings.Rod].values.casted.Value == true and character[getgenv().Settings.Rod].values.bite.Value == false and character[getgenv().Settings.Rod]:FindFirstChild("bobber") and character[getgenv().Settings.Rod].values.bobberzone.Value ~= "" then
                        pcall(function()
                            local shakeui = game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("shakeui")
                            if shakeui then
                                local button = game:GetService("Players").LocalPlayer.PlayerGui.shakeui.safezone:FindFirstChild("button")
                                GuiService.SelectedObject = button
                                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                            end
                        end)
                    else
                        task.wait()
                    end
                else
                    GuiService.SelectedObject = nil
                end
            end
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
                                local TweenService = game:GetService("TweenService")

                                local player = game.Players.LocalPlayer
                                local targetPosition = v2.Position

                                local tweenInfo = TweenInfo.new(
                                    1, -- Time in seconds
                                    Enum.EasingStyle.Quad, -- Easing style (you can try others like Linear, Sine, etc.)
                                    Enum.EasingDirection.Out, -- Easing direction (Out makes it smooth at the end)
                                    0, -- Repeat count (0 means no repeat)
                                    false, -- Reverse (false means it won't go back and forth)
                                    0 -- Delay time before tween starts
                                )

                                local goal = {}
                                goal.Position = targetPosition

                                local tween = TweenService:Create(player.Character.HumanoidRootPart, tweenInfo, goal)
                                tween:Play()
                                tween.Completed:Connect(function()
                                    fireproximityprompt(v.PickupPrompt)
                                end)
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
            while AntiDrowning.Value do
                wait(.1)
                if working == false then
                    game:GetService("Players").LocalPlayer.Character.client.oxygen.Disabled = AntiDrowning.Value
                    working = true
                else
                    return
                end
            end
            working = false
        end)
    end)

    AutoSelectSelled:OnChanged(function()
        task.spawn(function()
            local plr = game:GetService("Players").LocalPlayer
            local character = plr.Character or plr.CharacterAdded:Wait()
            local humanoid = character:WaitForChild("Humanoid")
            local backpack = plr:WaitForChild("Backpack")
            
            while AutoSelectSelled.Value do
                wait(0.1)
                for _, item in pairs(backpack:GetChildren()) do
                    if SelectSell.Value[item.Name] then
                        humanoid:EquipTool(item)
                        game:GetService("Workspace").world.npcs["Marc Merchant"].merchant.sell:InvokeServer()
                    end
                end
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

Window:SelectTab(1)