_G.Settings = {
    gameName = "[UPDATE 4 + LIMITED SUKUNA] Ijul Piece 2",
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
        FarmMobState = nil,
    },
    Stats = {
        Points = nil,
        StrenghtTogglt = nil,
        DurabilityToggle = nil,
        SwordToggle = nil,
        DevilFruitToggle = nil,
        SpecialToggle = nil,
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
    pageStats = Window:AddTab({ Title = "Stats", Icon = "bar-chart" }),
    pageTeleport = Window:AddTab({ Title = "Teleport", Icon = "map" })
}

do
    --[[SettingFarm]]---------------------------------------------------------------------------------------------------------------------
    local WeaponList = {}
    local function weaponListInsert()
        for i,v in pairs(game:GetService("Players").LocalPlayer.Backpack:GetDescendants())do
            if v:IsA("Tool") and v:FindFirstChild("localType") then
                table.insert(WeaponList,v.Name)
            end
        end
        for i, v in pairs(game:GetService("Players").LocalPlayer.Character:GetDescendants()) do
            if v:IsA("Tool") and v:FindFirstChild("localType") then
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

    --[[Main]]----------------------------------------------------------------------------------------------------------------------
    local MobList = {}
    local function mobListInsert()
        local uniqueMobs = {}
        
        for i, v in pairs(game:GetService("Workspace").Npcs:GetChildren()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") then
                if not uniqueMobs[v.Name] then
                    table.insert(MobList, v.Name)
                    uniqueMobs[v.Name] = true
                end
            end
        end
    end
    local function mobListRemove()
        if MobList ~= nil then
            for i = #MobList, 1, -1 do
                table.remove(MobList, i)
            end
        end
    end
    mobListInsert()
    local FarmMobTitle = Tabs.pageMain:AddSection("FarmMob") --Section FarmMob
    local SelectMobs = Tabs.pageMain:AddDropdown("SelectMob", {
        Title = "Select Mob",
        Values = MobList,
        Multi = false,
    })
    local RefreshMob = Tabs.pageMain:AddButton({
        Title = "Refresh Mob",
        Callback = function()
            local currentSelection = SelectMobs.Value
            
            mobListRemove()
            mobListInsert()
            SelectMobs:SetValues(MobList)
            
            if table.find(MobList, currentSelection) then
                SelectMobs:SetValue(currentSelection)
            else
                SelectMobs:SetValue(MobList[#MobList])
            end
        end
    })
    local FarmMob = Tabs.pageMain:AddToggle("FarmMob", {Title = "FarmMob", Default = false })

    local FarmBossTitle = Tabs.pageMain:AddSection("FarmBoss [Wait Update]") --Section FarmBoss

    SelectMobs:OnChanged(function(Value)
        _G.Settings.Main.SelectMob = Value
    end)
    --[[Stats]]----------------------------------------------------------------------------------------------------------------------
    local pointSlider = Tabs.pageStats:AddSlider("Point", {
        Title = "Point",
        Default = 1,
        Min = 1,
        Max = 1000,
        Rounding = 0,
        Callback = function(Value)
            _G.Settings.Stats.Points = Value
        end
    })
    local UpStrenght = Tabs.pageStats:AddToggle("UpStrenght", {Title = "UpStrenght", Default = false })
    local UpDurability = Tabs.pageStats:AddToggle("UpDurability", {Title = "UpDurability", Default = false })
    local UpSword = Tabs.pageStats:AddToggle("UpSword", {Title = "UpSword", Default = false })
    local UpDevilFruit = Tabs.pageStats:AddToggle("UpDevilFruit", {Title = "UpDevilFruit", Default = false })
    local UpSpecial = Tabs.pageStats:AddToggle("UpSpecial", {Title = "UpSpecial", Default = false })

    --[[Teleport]]----------------------------------------------------------------------------------------------------------------------
    local npcList = {}
    local islandList = {}
    local function npcListInsert()
        local uniqueMobs = {}

        for i,v in pairs(game:GetService("Workspace").Map.NPC:GetChildren())do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") then
                if not uniqueMobs[v.Name] then
                    table.insert(npcList,v.Name)
                    uniqueMobs[v.Name] = true
                end
            end
        end
    end
    local function npcListRemove()
        if npcList ~= nil then
            for i = #npcList, 1, -1 do
                table.remove(npcList, i)
            end
        end
    end
    local function islandListInsert()
        for i,v in pairs(game:GetService("Workspace").Map.SpawnLocation:GetChildren())do
            if v:IsA("BasePart") then
                table.insert(islandList,v.Name)
            end
        end
    end
    npcListInsert()
    islandListInsert()
    local IslandTitle = Tabs.pageTeleport:AddSection("Island") --Section Island
    local SelectIsland = Tabs.pageTeleport:AddDropdown("SelectIsland", {
        Title = "Select Island",
        Values = islandList,
        Multi = false
    })
    local Teleport = Tabs.pageTeleport:AddButton({
        Title = "Teleport",
        Callback = function()
            print(_G.Settings.Teleport.SelectIsland)
        end
    })
    SelectIsland:OnChanged(function(Value)
        _G.Settings.Teleport.SelectIsland = Value
    end)

    local NPCTitle = Tabs.pageTeleport:AddSection("Island") --Section NPC
    local SelectNPC = Tabs.pageTeleport:AddDropdown("SelectNPC", {
        Title = "Select NPC",
        Values = npcList,
        Multi = false
    })
    local RefreshNPC = Tabs.pageTeleport:AddButton({
        Title = "Refresh NPC",
        Callback = function()
            local currentSelection = SelectNPC.Value
            
            npcListRemove()
            npcListInsert()
            SelectNPC:SetValues(npcList)
            
            if table.find(npcList, currentSelection) then
                SelectNPC:SetValue(currentSelection)
            else
                SelectNPC:SetValue(npcList[#npcList])
            end
        end
    })
    local TeleportToNPC = Tabs.pageTeleport:AddButton({
        Title = "Teleport To NPC",
        Callback = function()
            print(_G.Settings.Teleport.SelectNPC)
        end
    })

    SelectNPC:OnChanged(function(Value)
        _G.Settings.Teleport.SelectNPC = Value
    end)

    -------------[[Set Value]]-------------------------------------------------------------------------------------------------------------------
    SelectWeapons:SetValue(_G.Settings.SettingsFarm.SelectWeapon ~= nil and _G.Settings.SettingsFarm.SelectWeapon or WeaponList[1])

    -------------[[SCRIPTS]]---------------------------------------------------------------------------------------------------------------------
    FarmMob:OnChanged(function()
        _G.Settings.Main.FarmMobState = FarmMob.Value
        
        task.spawn(function()
            local players = game:GetService("Players")
            local workspace = game:GetService("Workspace")
            local localPlayer = players.LocalPlayer
            local playerCharacter = localPlayer.Character
            local playerHumanoid = playerCharacter and playerCharacter:FindFirstChild("Humanoid")
            local VirtualUserService = game:GetService("VirtualUser")
    
            while FarmMob.Value do
                wait()
                if playerHumanoid and playerHumanoid.Health > 0 then
                    for _, v in pairs(workspace.Npcs[_G.Settings.Main.SelectMob]:GetDescendants()) do
                        if v:IsA("Humanoid") then
                            v.WalkSpeed = 0
                            v.JumpPower = 0
                            if v.Health < v.MaxHealth then
                                v.Health = -899999999
                            end
                            if v.Health > 0 then
                                for _, tool in pairs(localPlayer.Backpack:GetChildren()) do
                                    if tool.Name == _G.Settings.SettingsFarm.SelectWeapon and tool:IsA("Tool") then
                                        playerHumanoid:EquipTool(tool)
                                        VirtualUserService:CaptureController()
                                        VirtualUserService:ClickButton1(Vector2.new(0, 0))
                                    end
                                end
                                for _, Target in pairs(workspace.Npcs[_G.Settings.Main.SelectMob]:GetChildren()) do
                                    if Target.Name == "HumanoidRootPart" then
                                        playerCharacter.HumanoidRootPart.CFrame = Target.CFrame * CFrame.new(0, 0, _G.Settings.SettingsFarm.Distance)
                                    end
                                end
                            end
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