_G.Settings = {
    gameName = "[UPDATE 4 + LIMITED SUKUNA] Ijul Piece 2",
    Version = {
        [1] = "[Free Version]",
        [2] = "[Premium Version]",
    },
}

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Blobby Hub".." | ".._G.Settings.gameName.." | ".._G.Settings.Version[1],
    TabWidth = 160,
    Size = UDim2.fromOffset(480, 360),
    Acrylic = false, -- การเบลออาจตรวจจับได้ การตั้งค่านี้เป็น false จะปิดการเบลอทั้งหมด
    Theme = "Amethyst",
    MinimizeKey = Enum.KeyCode.LeftControl -- ใช้เมื่อไม่มีคีย์ลัดในการย่อขนาด
})


local Tabs = {
    --[[ Tabs --]]
    pageSettingFarm = Window:AddTab({ Title = "Settings Farm", Icon = "settings" }),
    pageMain = Window:AddTab({ Title = "Main", Icon = "home" }),
    pageStats = Window:AddTab({ Title = "Stats", Icon = "bar-chart" }),
    pageTeleport = Window:AddTab({ Title = "Teleport", Icon = "map" })
}