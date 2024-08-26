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
        Title = "Distance Farm",
        Default = 1,
        Min = 0,
        Max = 1000,
        Rounding = 0,
        Callback = function(Value)
            _G.Settings.SettingsFarm.Distance = Value
        end
    })
    local Dropdown = Tabs.pageSettingFarm:AddDropdown("SelectWeapon", {
        Title = "Select Weapon",
        Values = WeaponList,
        Multi = false,
    })
    local RefreshWeapon = Tabs.pageSettingFarm:AddButton({
        Title = "Refresh Weapon",
        Callback = function()
            weaponListRemove()
            weaponListInsert()
        end
    })
    local AutoFarm = Tabs.Main:AddToggle("AutoFarm", {Title = "AutoFarm", Default = false })
end