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
        Angle = nil,
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
    local SelectAngle = Tabs.pageSettingFarm:AddDropdown("SelectAngle", {
        Title = "Select Angle",
        Values = {"Above", "Under", "Behide"},
        Multi = false,
        Default =  _G.Settings.SettingsFarm.Angle or "Above"
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
    SelectAngle:OnChanged(function(Value)
        _G.Settings.SettingsFarm.Angle = Value
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
        Title = "SelectTechnique",
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
    local SwordTitle = Tabs.pageShop:AddSection("Swords")

    -------------[[SCRIPTS]]---------------------------------------------------------------------------------------------------------------------
    --ANTI AFK
    task.spawn(function()
        while wait() do
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
    AutoCollect:OnChanged(function()
        task.spawn(function()
            while wait() do
                if AutoCollect.Value and game:GetService("Players").LocalPlayer.Character.Humanoid.Health > 0 then
                    local Collect = game:GetService("Workspace")["Zednov's Tycoon Kit"].Tycoons[tostring(game:GetService("Players").LocalPlayer.Team)].Essentials.Giver

                    if firetouchinterest then
                        firetouchinterest(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart, Collect, 0)
                        firetouchinterest(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart, Collect, 1)
                    end
                    wait(5)
                end
            end
        end)
    end)
    local function convertValue(valueStr)
        local number = tonumber(string.match(valueStr, "%d+%.?%d*"))
        if string.find(valueStr, "K") then
            return number * 1000
        elseif string.find(valueStr, "M") then
            return number * 1000000
        else
            return number
        end
    end
    AutoTycoon:OnChanged(function()
        task.spawn(function()
            while wait() do
                if AutoTycoon.Value and game:GetService("Players").LocalPlayer.Character.Humanoid.Health > 0 then
                    local Buttons = game:GetService("Workspace")["Zednov's Tycoon Kit"].Tycoons[tostring(game:GetService("Players").LocalPlayer.Team)].Buttons
                    for i,v in pairs(Buttons:GetDescendants()) do
                        local cashValueStr = game:GetService("Players").LocalPlayer.leaderstats.Cash.Value
                        local cashValue = convertValue(cashValueStr)

                        if v:IsA("Model") and v.Price.Value <= cashValue and not v:FindFirstChild("Gamepass") and v.Head.Transparency == 0 then
                            local Target = v.Head
                            if firetouchinterest then
                                firetouchinterest(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart, Target, 0)
                                firetouchinterest(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart, Target, 1)
                            end
                        end
                    end
                end
            end
        end)
    end)
    AutoRebirth:OnChanged(function()
        task.spawn(function()
            while wait(1) do
                if AutoRebirth.Value then
                    game:GetService("ReplicatedStorage").Assets.Remotes.Rebirth:InvokeServer()
                end
            end
        end)
    end)
    AutoDropLoot:OnChanged(function()
        task.spawn(function()
            while wait() do
                if AutoDropLoot.Value and game:GetService("Players").LocalPlayer.Character.Humanoid.Health > 0 then
                    for i,v in pairs(game:GetService("Workspace"):GetChildren()) do
                        if string.find(v.Name, "Loot") and v:IsA("BasePart") and v:FindFirstChild("ProximityPrompt") then
                            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
                            fireproximityprompt(v.ProximityPrompt)
                        end
                    end
                end
            end
        end)
    end)

    AutoFarmMob:OnChanged(function()
        task.spawn(function()
            while wait() do
                if AutoFarmMob.Value and game:GetService("Players").LocalPlayer.Character.Humanoid.Health > 0 then
                    for i,v in pairs(game:GetService("Workspace").LivingBeings.NPCS:GetChildren()) do
                        if v.Name == _G.Settings.Main.SelectMob and v:IsA("Model") and v.Humanoid.Health > 0 then
                            for _, tool in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
                                if tool.Name == _G.Settings.SettingsFarm.SelectWeapon and tool:IsA("Tool") then
                                    game:GetService("Players").LocalPlayer.Character.Humanoid:EquipTool(tool)
                                end
                            end
                            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 0, _G.Settings.SettingsFarm.Distance)
                            game:GetService("ReplicatedStorage").Assets.Remotes.Skills:FireServer("Combat","M1")
                        end
                    end
                end
            end
        end)
    end)
    AutoFarmBoss:OnChanged(function()
        task.spawn(function()
            while wait() do
                if AutoFarmBoss.Value and game:GetService("Players").LocalPlayer.Character.Humanoid.Health > 0 then
                    for i, v in pairs(game:GetService("Workspace").LivingBeings.NPCS:GetChildren()) do
                        if table.find(_G.Settings.Main.SelectBoss, v.Name) and v:IsA("Model") and v.Humanoid.Health > 0 then
                            for _, tool in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
                                if tool.Name == _G.Settings.SettingsFarm.SelectWeapon and tool:IsA("Tool") then
                                    game:GetService("Players").LocalPlayer.Character.Humanoid:EquipTool(tool)
                                end
                            end
                            if _G.Settings.SettingsFarm.Angle == "Above" then
                                game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, _G.Settings.SettingsFarm.Distance, 0) * CFrame.Angles(-1.5,0,0)
                            elseif _G.Settings.SettingsFarm.Angle == "Under" then
                                game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, -_G.Settings.SettingsFarm.Distance, 0) * CFrame.Angles(1.5,0,0)
                            elseif _G.Settings.SettingsFarm.Angle == "Behide" then
                                game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 0, _G.Settings.SettingsFarm.Distance) * CFrame.Angles(0,0,0)
                            end
                            game:GetService("ReplicatedStorage").Assets.Remotes.Skills:FireServer("Combat","M1")
                        end
                    end
                end
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

--game:GetService("ReplicatedStorage").Assets.Remotes.RedeemCode:InvokeServer("Quest")
--game:GetService("ReplicatedStorage").Assets.Remotes.Shops:FireServer("Purchase",{["Name"] = "Hollow Purple",["Type"] = "Abilities"})
--game:GetService("ReplicatedStorage").Assets.Remotes.Shops:FireServer("Purchase",{["Name"] = "Katana",["Type"] = "Swords"})
