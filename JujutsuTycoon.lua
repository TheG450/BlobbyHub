repeat wait() until game:IsLoaded() and game.Players and game.Players.LocalPlayer and game.Players.LocalPlayer.Character
_G.Settings = {
    gameName = "[TEN SHADOWS + UPD] Jujutsu Tycoon",
    Version = {
        [1] = "[Free Version]",
        [2] = "[Premium Version]",
    },
    SettingsFarm = {
        Distance = nil,
        SelectWeapon = nil,
    },
    Main = {
        SelectMob = nil,
        SelectBoss = nil,
    },
    Shop = {
        SelectTechnique = nil,
        SelectSword = nil,
    },
    Teleport = {
        SelectIsland = nil,
        SelectNPC = nil,
    }
}

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Blobby Hub".." | ".._G.Settings.gameName.." | ".._G.Settings.Version[1],
    TabWidth = 160,
    Size = UDim2.fromOffset(480, 380),
    Acrylic = false,
    Theme = "Amethyst",
    MinimizeKey = Enum.KeyCode.LeftControl
})


local Tabs = {
    --[[ Tabs --]]
    pageSettingFarm = Window:AddTab({ Title = "Settings Farm", Icon = "settings" }),
    pageMain = Window:AddTab({ Title = "Main", Icon = "home" }),
    pageShop = Window:AddTab({ Title = "Shop", Icon = "shopping-cart" }),
    pageTeleport = Window:AddTab({ Title = "Teleport", Icon = "map" })
}

do
    --[[SettingFarm]]---------------------------------------------------------------------------------------------------------------------
    local WeaponList = {}
    local function weaponListInsert()
        for i,v in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren())do
            if v:IsA("Tool") then
                table.insert(WeaponList,v.Name)
            end
        end
        for i, v in pairs(game:GetService("Players").LocalPlayer.Character:GetChildren()) do
            if v:IsA("Tool") then
                table.insert(WeaponList, v.Name)
            end
        end
    end
    local function weaponListRemove()
        if WeaponList ~= nil then
            for i = #WeaponList, 1, -1 do
                table.remove(WeaponList, i)
            end
        end
    end
    weaponListInsert()
    local distanceSlider = Tabs.pageSettingFarm:AddSlider("DistanceFarm", {
        Title = "Distance",
        Default = 4,
        Min = 0,
        Max = 20,
        Rounding = 0,
        Callback = function(Value)
            _G.Settings.SettingsFarm.Distance = Value
        end
    })
    local SelectWeapons = Tabs.pageSettingFarm:AddDropdown("SelectWeapon", {
        Title = "Select Weapon",
        Values = WeaponList,
        Multi = false,
        Default =  _G.Settings.SettingsFarm.SelectWeapon or WeaponList[1]
    })
    local RefreshWeapon = Tabs.pageSettingFarm:AddButton({
        Title = "Refresh Weapon",
        Callback = function()
            local currentSelection = SelectWeapons.Value
            
            weaponListRemove()
            weaponListInsert()
            SelectWeapons:SetValues(WeaponList)
            
            if table.find(WeaponList, currentSelection) then
                SelectWeapons:SetValue(currentSelection)
            else
                SelectWeapons:SetValue(WeaponList[#WeaponList])
            end
        end
    })

    distanceSlider:OnChanged(function(Value)
        _G.Settings.SettingsFarm.Distance = Value
    end)
    SelectWeapons:OnChanged(function(Value)
        _G.Settings.SettingsFarm.SelectWeapon = Value
    end)

    --[[Main]]---------------------------------------------------------------------------------------------------------------------
    local TycoonTitle = Tabs.pageMain:AddSection("Tycoon")
    local AutoCollect = Tabs.pageMain:AddToggle("AutoCollect", {Title = "AutoCollect", Default = false })
    local AutoTycoon = Tabs.pageMain:AddToggle("AutoTycoon", {Title = "AutoTycoon", Default = false })
    local AutoRebirth = Tabs.pageMain:AddToggle("AutoRebirth", {Title = "AutoRebirth", Default = false })
    local AutoDropLoot = Tabs.pageMain:AddToggle("AutoDropLoot", {Title = "AutoDropLoot", Default = false })
    local MobTitle = Tabs.pageMain:AddSection("Mobs")
    local SelectMob = Tabs.pageMain:AddDropdown("SelectMob", {
        Title = "SelectMob",
        Values = {"Student", "Q Mercenary"},
        Multi = false,
        Default = _G.Settings.Main.SelectMob or "Student",
        Callback = function(Value)
            _G.Settings.Main.SelectMob = Value
        end
    })
    SelectMob:OnChanged(function(Value)
        _G.Settings.Main.SelectMob = Value
    end)
    local AutoFarmMob = Tabs.pageMain:AddToggle("AutoFarmMob", {Title = "AutoFarmMob", Default = false })
    local BossTitle = Tabs.pageMain:AddSection("Boss")
    local SelectBoss = Tabs.pageMain:AddDropdown("SelectBoss", {
        Title = "SelectBoss",
        Values = {"Idatoru", "Shoso", "Urayme", "Volcano", "Kojo"},
        Multi = true,
        Default = {},
    })
    SelectBoss:OnChanged(function(Value)
        local Values = {}
        for Value, State in next, Value do
            table.insert(Values, Value)
        end
        _G.Settings.Main.SelectBoss = Values
    end)
    local AutoFarmBoss = Tabs.pageMain:AddToggle("AutoFarmBoss", {Title = "AutoFarmBoss", Default = false })

    --[[Shop]]---------------------------------------------------------------------------------------------------------------------
    local TechniqueTitle = Tabs.pageShop:AddSection("Techniques")
    local SelectTechnique = Tabs.pageShop:AddDropdown("SelectTechnique", {
        Title = "Select Technique",
        Description = "All items Locked Technique can be purchased except with Gamepass.",
        Values = {"Lava Bees", "Blood Cyclone", "Divergent Fist", "Cursed Speech:Twist", "Boogie Woogie", "Supernova", "Moon Dregs", "Triple Wood", "Cursed Speech:Stop", "Bird Strike", "Clones", "Basic RCT", "Piranha Fury", "Crimson Bind", "Cursed Speech:Explode", "Energy Beam", "Piercing Blood", "Axe Kick", "Ice Spikes", "Collapse", "Aqua Beam", "Black Flash", "Roots", "Triple Kicks", "Energy Vortex", "Flower Field", "Advanced RCT", "Molten Palm", "Blood Strike", "Nue", "Lapse Blue", "Reversal Red", "Serpent", "Ice Barrage", "Tidal Wave", "Ice Age", "Volcano Mine", "Cursed Flower", "Max Elephant", "Max Red", "Max Blue", "Max Meteor", "Summon", "Hollow Purple"},
        Multi = false,
        Default = _G.Settings.Shop.SelectTechnique or "",
        Callback = function(Value)
            _G.Settings.Shop.SelectTechnique = Value
        end
    })
    SelectMob:OnChanged(function(Value)
        _G.Settings.Shop.SelectTechnique = Value
    end)
    local BuyTechnique = Tabs.pageShop:AddButton({
        Title = "BuyTechnique",
        Callback = function()
            game:GetService("ReplicatedStorage").Assets.Remotes.Shops:FireServer("Purchase",{["Name"] = _G.Settings.Shop.SelectTechnique,["Type"] = "Abilities"})
        end
    })
    local SwordTitle = Tabs.pageShop:AddSection("Swords")
    local SelectSword = Tabs.pageShop:AddDropdown("SelectSword", {
        Title = "Select Sword",
        Description = "All items Locked Sword can be purchased except with Gamepass.",
        Values = {"Knife", "Cursed Bow", "Revolver", "Katana", "Cursed Hammer", "Broom", "Slaughter Demon", "Golden Hilt", "Cursed Guitar", "Eternal Chain", "BattleAxe", "Inverted Spear", "Split Soul Katana"},
        Multi = false,
        Default = _G.Settings.Shop.SelectSword or "",
        Callback = function(Value)
            _G.Settings.Shop.SelectSword = Value
        end
    })
    SelectSword:OnChanged(function(Value)
        _G.Settings.Shop.SelectSword = Value
    end)
    local BuySword = Tabs.pageShop:AddButton({
        Title = "BuySword",
        Callback = function()
            game:GetService("ReplicatedStorage").Assets.Remotes.Shops:FireServer("Purchase",{["Name"] = _G.Settings.Shop.SelectSword,["Type"] = "Swords"})
        end
    })

    -------------[[SCRIPTS]]---------------------------------------------------------------------------------------------------------------------
    -- Cache frequently accessed services
    local players = game:GetService("Players")
    local replicatedStorage = game:GetService("ReplicatedStorage")
    local workspace = game:GetService("Workspace")
    local localPlayer = players.LocalPlayer
    local humanoidRootPart = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")

    -- Function to handle repetitive tool equipping
    local function equipWeapon()
        for _, tool in pairs(localPlayer.Backpack:GetChildren()) do
            if tool.Name == _G.Settings.SettingsFarm.SelectWeapon and tool:IsA("Tool") then
                localPlayer.Character.Humanoid:EquipTool(tool)
            end
        end
    end

    -- Reduce wait time for AutoCollect and cache the collect object
    local collect = workspace["Zednov's Tycoon Kit"].Tycoons[tostring(localPlayer.Team)].Essentials.Giver
    AutoCollect:OnChanged(function()
        task.spawn(function()
            while AutoCollect.Value do
                if humanoidRootPart and localPlayer.Character.Humanoid.Health > 0 then
                    firetouchinterest(humanoidRootPart, collect, 0)
                    firetouchinterest(humanoidRootPart, collect, 1)
                    wait(5)
                else
                    break
                end
            end
        end)
    end)

    -- Optimize AutoTycoon by checking conditions only once per loop
    AutoTycoon:OnChanged(function()
        task.spawn(function()
            while AutoTycoon.Value do
                pcall(function()
                    if localPlayer.Character and localPlayer.Character.Humanoid.Health > 0 then
                        local buttons = workspace["Zednov's Tycoon Kit"].Tycoons[tostring(localPlayer.Team)].Buttons
                        local cashValue = convertValue(localPlayer.leaderstats.Cash.Value)
                        for _, button in pairs(buttons:GetDescendants()) do
                            if button:IsA("Model") and button.Price.Value <= cashValue and not button:FindFirstChild("Gamepass") and button.Head.Transparency == 0 then
                                firetouchinterest(humanoidRootPart, button.Head, 0)
                                firetouchinterest(humanoidRootPart, button.Head, 1)
                            end
                        end
                    end
                end)
                wait(1) -- Adjusted the wait to 1 second to avoid constant iterations
            end
        end)
    end)

    -- Avoid repeating fireproximityprompt calls unless necessary
    AutoDropLoot:OnChanged(function()
        task.spawn(function()
            while AutoDropLoot.Value do
                pcall(function()
                    if localPlayer.Character and localPlayer.Character.Humanoid.Health > 0 then
                        for _, loot in pairs(workspace:GetChildren()) do
                            if loot:IsA("BasePart") and string.find(loot.Name, "Loot") and loot:FindFirstChild("ProximityPrompt") then
                                humanoidRootPart.CFrame = loot.CFrame
                                fireproximityprompt(loot.ProximityPrompt)
                            end
                        end
                    end
                end)
                wait(0.1) -- Slight wait to avoid spamming
            end
        end)
    end)

    -- Optimize AutoFarmMob by checking health and tool conditions only when necessary
    AutoFarmMob:OnChanged(function()
        task.spawn(function()
            while AutoFarmMob.Value do
                pcall(function()
                    if localPlayer.Character and localPlayer.Character.Humanoid.Health > 0 then
                        for _, mob in pairs(workspace.LivingBeings.NPCS:GetChildren()) do
                            if mob.Name == _G.Settings.Main.SelectMob and mob:IsA("Model") and mob.Humanoid.Health > 0 then
                                equipWeapon() -- Equip weapon if necessary
                                humanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 0, _G.Settings.SettingsFarm.Distance)
                                replicatedStorage.Assets.Remotes.Skills:FireServer("Combat", "M1")
                            end
                        end
                    end
                end)
                wait(0.1) -- Adjust wait time between actions
            end
        end)
    end)

    -- Optimize AutoFarmBoss
    AutoFarmBoss:OnChanged(function()
        task.spawn(function()
            while AutoFarmBoss.Value do
                pcall(function()
                    if localPlayer.Character and localPlayer.Character.Humanoid.Health > 0 then
                        for _, boss in pairs(workspace.LivingBeings.NPCS:GetChildren()) do
                            if table.find(_G.Settings.Main.SelectBoss, boss.Name) and boss:IsA("Model") and boss.Humanoid.Health > 0 then
                                equipWeapon() -- Equip weapon if necessary
                                humanoidRootPart.CFrame = boss.HumanoidRootPart.CFrame * CFrame.new(0, 0, _G.Settings.SettingsFarm.Distance)
                                replicatedStorage.Assets.Remotes.Skills:FireServer("Combat", "M1")
                            end
                        end
                    end
                end)
                wait(0.1) -- Reduce wait time between actions
            end
        end)
    end)
end

Window:SelectTab(1)

Fluent:Notify({
    Title = "Blobby Hub",
    Content = "The script has been loaded.",
    Duration = 5
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

--game:GetService("ReplicatedStorage").Assets.Remotes.RedeemCode:InvokeServer("Quest")
