_G.Settings = {
    gameName = "[UPDATE 4 + LIMITED SUKUNA] Ijul Piece 2",
    Version = {
        [1] = "[Free Version]",
        [2] = "[Premium Version]",
    },
    SettingsFarm = {
        Distance = nil,
        SelectWeapon = nil,
    }
}

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Blobby Hub".." | ".._G.Settings.gameName.." | ".._G.Settings.Version[1],
    TabWidth = 160,
    Size = UDim2.fromOffset(480, 360),
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
    --[[SettingFarm]]
    local WeaponList = {}
    local function weaponListInsert()
        for i,v in pairs(game:GetService("Players").LocalPlayer.Backpack:GetDescendants())do
            if v:IsA("Tool") and v:FindFirstChild("localType") then
                table.insert(WeaponList,v.Name)
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
        Max = 10,
        Rounding = 0,
        Callback = function(Value)
            _G.Settings.SettingsFarm.Distance = Value
        end
    })
    local SelectWeapons = Tabs.pageSettingFarm:AddDropdown("SelectWeapon", {
        Title = "Select Weapon",
        Values = WeaponList,
        Multi = false,
        Default = _G.Settings.SettingsFarm.SelectWeapon ~= nil and _G.Settings.SettingsFarm.SelectWeapon or WeaponList[1],
    })
    local RefreshWeapon = Tabs.pageSettingFarm:AddButton({
        Title = "Refresh Weapon",
        Callback = function()
            weaponListRemove()
            weaponListInsert()
            SelectWeapons:SetValues(WeaponList)
            if #WeaponList > 0 then
                SelectWeapons:SetValue(WeaponList[#WeaponList])
            end
        end
    })
    local AutoFarm = Tabs.pageMain:AddToggle("AutoFarm", {Title = "AutoFarm", Default = false })

    SelectWeapons:OnChanged(function(Value)
        _G.Settings.SettingsFarm.SelectWeapon = Value
    end)
end
