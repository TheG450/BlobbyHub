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
        FarmMobState = nil,
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
        Default = 5,
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

    --[[Main]]---------------------------------------------------------------------------------------------------------------------
    local AutoCollect = Tabs.pageMain:AddToggle("AutoCollect", {Title = "AutoCollect", Default = false })
    local AutoTycoon = Tabs.pageMain:AddToggle("AutoTycoon", {Title = "AutoTycoon", Default = false })
    local AutoRebirth = Tabs.pageMain:AddToggle("AutoRebirth", {Title = "AutoRebirth", Default = false })

    -------------[[SCRIPTS]]---------------------------------------------------------------------------------------------------------------------
    AutoCollect:OnChanged(function()
        task.spawn(function()
            while wait() do
                if AutoCollect.Value then
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
                if AutoTycoon.Value then
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
end

Window:SelectTab(1)

Fluent:Notify({
    Title = "Blobby Hub",
    Content = "The script has been loaded.",
    Duration = 5
})