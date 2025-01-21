repeat wait() until game:IsLoaded() and game.Players and game.Players.LocalPlayer and game.Players.LocalPlayer.Character
getgenv().Settings = {
    SelectItemList = nil,
    SelectItemBossList = nil,
    AutoFarmChest = nil,
    AutoFarmChristmasSock = nil,
    AutoFarmChristmasGift = nil,
    AutoUse = nil,
    AutoDestroySelected = nil,
    AutoDestroySelectedReal = nil,
    AutoKillBoss = nil,
}

local FileName = tostring(game.Players.LocalPlayer.UserId).."_Settings.Blobby"
local BaseFolder = "BLOBBYHUB"
local SubFolder = "UUI"

function SaveSetting()
    local json
    local HttpService = game:GetService("HttpService")
    if writefile then
        json = HttpService:JSONEncode(getgenv().Settings)
        makefolder(BaseFolder)
        makefolder(BaseFolder.."\\"..SubFolder)
        writefile(BaseFolder.."\\"..SubFolder.."\\"..FileName, json)
    else
        error("ERROR: Can't save your settings")
    end
end

function LoadSetting()
    local HttpService = game:GetService("HttpService")
    if readfile and isfile and isfile(BaseFolder.."\\"..SubFolder.."\\"..FileName) then
        getgenv().Settings = HttpService:JSONDecode(readfile(BaseFolder.."\\"..SubFolder.."\\"..FileName))
        warn("Settings loaded successfully!")
    end
end
LoadSetting()
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Blobby Hub" .. " | ".."[2024 EVENT] Unfamiliar Universe Incident".." | ".."[Version Beta]",
    TabWidth = 160,
    Size =  UDim2.fromOffset(580, 460), --UDim2.fromOffset(480, 360), --default size (580, 460)
    Acrylic = false, -- การเบลออาจตรวจจับได้ การตั้งค่านี้เป็น false จะปิดการเบลอทั้งหมด
    Theme = "Rose", --Amethyst
    MinimizeKey = Enum.KeyCode.P
})

local Tabs = {
    --[[ Tabs --]]
    pageMain = Window:AddTab({ Title = "Main", Icon = "home" }),
    pageMiscellaneous = Window:AddTab({ Title = "Miscellaneous", Icon = "component" }),
    pageWebhook = Window:AddTab({ Title = "Webhooks", Icon = "globe" }),
}

do
    --[[Main]]---------------------------------------------------------------------------------------------------------------------
    local SelectItemList = Tabs.pageMain:AddDropdown("SelectItemList", {
        Title = "Select Item List",
        Values = {"Anvil", "Oil Cup", "Blood Cup", "Acid Cup", "Light Cup", "Radioactive Cup", "Space Cup", "Eater Cup", "Golden Cup", "Dark Eye", "Drip Cup", "Pepci", "Unholy Cross", "Bacteria Cup", "Knight Helmet", "Lonely Pain Cup", "Cup Of Mankind", "Truly Oil Cup", "Knowledge Cup", "Internet Cup", "Tiredness Cup", "Tears Of Pain", "Unknown Mechanism", "True Sins Cup", "Madness Cup", "Mega Serum", "Organic Serum", "Forbidden Paranoid", "Core of The Unknown", "God's Excerpt", "Omniversal Core", "Omniversal Crystal", "Complex Soul", "Clockwork's Crown", "Titan Essence", "Death Blood", "Theothes Flesh", "Fallen Blood", "Ruler Head", "Seraphim Book", "Rebellion Sword", "AtomX", "The Truth", "FRESH ELDER FLESH", "Elder Blood", "Tyrant Crown", "Blessing Of Ares", "Cries Of A GOD", "Faith", "Foolish Cup", "Heavens Gate", "Archverse", "Cursed Essence", "Gemstone Solidifier", "Weak Hammer", "Mediocre Hammer", "Jolly Milk", "UnJolly Milk", "Saint Jolly Milk", "Stained UnJolly Milk", "Glacier Cup", "Epic Santa Present"},
        Multi = true,
        Default = getgenv().Settings.SelectItemList or {},
    })
    SelectItemList:OnChanged(function(Value)
        local Values = {}
        for Value, State in next, Value do
            table.insert(Values, Value)
        end
        getgenv().Settings.SelectItemList = Values
        SaveSetting()
    end)
    
    local SelectItemBossList = Tabs.pageMain:AddDropdown("SelectItemBossList", {
        Title = "Select Item Boss List",
        Values = {"Paper", "Kings Arm", "Warp Spiral", "Unknown Eye", "Warp Eater", "Omnius", "Nowhere Chicken Nuggets", "Ruler Will's", "Holy Awakener", "Ancient Sigil"},
        Multi = true,
        Default = getgenv().Settings.SelectItemBossList or {},
    })
    SelectItemBossList:OnChanged(function(Value)
        local Values = {}
        for Value, State in next, Value do
            table.insert(Values, Value)
        end
        getgenv().Settings.SelectItemBossList = Values
        SaveSetting()
    end)
    local AutoDestroySelected = Tabs.pageMain:AddToggle("AutoDestroySelected", {Title = "Auto Destroy Selected(Not Permanent)", Default = getgenv().Settings.AutoDestroySelected or false })
    local AutoDestroySelectedReal = Tabs.pageMain:AddToggle("AutoDestroySelectedReal", {Title = "Auto Destroy Selected(Permanent)", Default = getgenv().Settings.AutoDestroySelectedReal or false })
    local AutoFarmChest = Tabs.pageMain:AddToggle("AutoFarmChest", {Title = "Auto Farm Chest", Default = getgenv().Settings.AutoFarmChest or false })
    local AutoFarmChristmasSock = Tabs.pageMain:AddToggle("AutoFarmChristmasSock", {Title = "AutoFarm Christmas Sock", Default = getgenv().Settings.AutoFarmChristmasSock or false })
    local AutoFarmChristmasGift = Tabs.pageMain:AddToggle("AutoFarmChristmasGift", {Title = "AutoFarm Christmas Gift", Default = getgenv().Settings.AutoFarmChristmasGift or false })
    local AutoUse = Tabs.pageMain:AddToggle("AutoUse", {Title = "Auto Use", Default = getgenv().Settings.AutoUse or false })
    local AutoKillBoss = Tabs.pageMain:AddToggle("AutoKillBoss", {Title = "Auto Kill Boss", Default = getgenv().Settings.AutoKillBoss or false })

    --[[Main]]---------------------------------------------------------------------------------------------------------------------
    local CS1 = Tabs.pageMiscellaneous:AddSection("Comming Soon!!!")
    --[[Main]]---------------------------------------------------------------------------------------------------------------------
    local CS2 = Tabs.pageWebhook:AddSection("Comming Soon!!!")

    --[[SCRIPTS]]---------------------------------------------------------------------------------------------------------------------
    local function getHumanoidRootPart()
        local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
        return character:WaitForChild("HumanoidRootPart", 5)
    end

    AutoDestroySelected:OnChanged(function()
        task.spawn(function()
            getgenv().Settings.AutoDestroySelected = AutoDestroySelected.Value
            SaveSetting()
            while AutoDestroySelected.Value do
                wait()
                for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                    if (table.find(getgenv().Settings.SelectItemList, v.Name) or table.find(getgenv().Settings.SelectItemBossList, v.Name)) then
                        v:Destroy()
                    end
                end
            end
        end)
    end)
    AutoDestroySelectedReal:OnChanged(function()
        task.spawn(function()
            getgenv().Settings.AutoDestroySelectedReal = AutoDestroySelectedReal.Value
            SaveSetting()
            while AutoDestroySelectedReal.Value do
                wait()
                pcall(function()
                    for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                        if (table.find(getgenv().Settings.SelectItemList, v.Name) or table.find(getgenv().Settings.SelectItemBossList, v.Name)) and v:IsA("Tool") then
                            local player = game.Players.LocalPlayer
                            local character = player.Character or player.CharacterAdded:Wait()
                            local humanoid = character:WaitForChild("Humanoid")
                    
                            humanoid:EquipTool(v)
                    
                            task.wait(0.1)
                            humanoid:UnequipTools()
                            v.Parent = workspace
                    
                            if v.Handle then
                                v.Handle.CFrame = CFrame.new(0, 0, 0)
                                v:Destroy()
                            end
                        end
                    end
                end)
            end
        end)
        task.spawn(function()
            while AutoDestroySelectedReal.Value do
                wait()
                pcall(function()
                    for _, v in pairs(game:GetService("Workspace"):GetChildren()) do
                        if (table.find(getgenv().Settings.SelectItemList, v.Name) or table.find(getgenv().Settings.SelectItemBossList, v.Name)) and v:IsA("Tool") then
                            v:Destroy()
                            wait(.05)
                        end
                    end
                end)
            end
        end)
    end)
    AutoFarmChest:OnChanged(function()
        task.spawn(function()
            getgenv().Settings.AutoFarmChest = AutoFarmChest.Value
            SaveSetting()
            while AutoFarmChest.Value do
                wait()
                local HumanoidRootPart = getHumanoidRootPart()
                pcall(function()
                    for _, v in pairs(game:GetService("Workspace").chests:GetChildren()) do
                        if (string.find(v.Name, "Chest") or string.find(v.Name, "Crystal") or string.find(string.lower(v.Name), string.lower("Cursed")) or string.find(string.lower(v.Name), string.lower("Lucky"))) and v:FindFirstChild("ProximityPrompt") then
                            HumanoidRootPart.CFrame = v.CFrame
                            wait(0.1)
                            fireproximityprompt(v.ProximityPrompt)
                        else
                            for i, j in pairs(game:GetService("Workspace"):GetChildren()) do
                                if (string.find(j.Name, "Chest") or string.find(j.Name, "Crystal") or string.find(j.Name, "chest") or string.find(j.Name, "RulerHead") or string.find(j.Name, "ElderBody") or string.find(j.Name, "LordsBlade") or string.find(string.lower(v.Name), string.lower("Cursed")) or string.find(string.lower(v.Name), string.lower("Lucky"))) and j:FindFirstChild("ProximityPrompt") then
                                    HumanoidRootPart.CFrame = j.CFrame
                                    wait(0.1)
                                    fireproximityprompt(j.ProximityPrompt)
                                end
                            end
                        end
                    end
                end)
            end
        end)
    end)
    AutoFarmChristmasSock:OnChanged(function()
        task.spawn(function()
            getgenv().Settings.AutoFarmChristmasSock = AutoFarmChristmasSock.Value
            SaveSetting()
            while AutoFarmChristmasSock.Value do
                wait()
                local HumanoidRootPart = getHumanoidRootPart()
                pcall(function()
                    for _, v in pairs(game:GetService("Workspace").chests:GetChildren()) do
                        if string.find(v.Name, "Sock") and v:FindFirstChild("ProximityPrompt") then
                            HumanoidRootPart.CFrame = v.CFrame
                            wait(0.1)
                            fireproximityprompt(v.ProximityPrompt)
                        end
                    end
                end)
            end
        end)
    end)
    AutoFarmChristmasGift:OnChanged(function()
        task.spawn(function()
            getgenv().Settings.AutoFarmChristmasGift = AutoFarmChristmasGift.Value
            SaveSetting()
            while AutoFarmChristmasGift.Value do
                wait()
                local HumanoidRootPart = getHumanoidRootPart()
                pcall(function()
                    for _, v in pairs(game:GetService("Workspace"):GetChildren()) do
                        if string.find(v.Name, "ChristmasGift") and v:FindFirstChild("ProximityPrompt") then
                            HumanoidRootPart.CFrame = v.CFrame
                            wait(0.1)
                            fireproximityprompt(v.ProximityPrompt)
                        end
                    end
                end)
            end
        end)
    end)
    AutoUse:OnChanged(function()
        task.spawn(function()
            getgenv().Settings.AutoUse = AutoUse.Value
            SaveSetting()
            while AutoUse.Value do
                wait()
                pcall(function()
                    for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                        if (string.find(v.Name, "Chest") or string.find(v.Name, "Sock") or string.find(v.Name, "chest")) then
                            local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
                            local humanoid = character:FindFirstChild("Humanoid") or character:WaitForChild("Humanoid", 9e99)
                            if humanoid then
                                humanoid:EquipTool(v)
                                v:Activate()
                            end
                        end
                    end
                    for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                        if string.find(v.Name, "Gift") and v.used.Value == false then
                            local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
                            local humanoid = character:FindFirstChild("Humanoid") or character:WaitForChild("Humanoid", 9e99)
                            if humanoid then
                                humanoid:EquipTool(v)
                                wait(.1)
                                v:Activate()
                            end
                            wait(2)
                        end
                    end
                end)
            end
        end)
    end)
    AutoKillBoss:OnChanged(function()
        task.spawn(function()
            getgenv().Settings.AutoKillBoss = AutoKillBoss.Value
            SaveSetting()
            while AutoKillBoss.Value do
                wait()
                for i,v in pairs(game:GetService("Workspace")["boss's"]:GetDescendants()) do
                    if v:IsA("Model") and (v:FindFirstChild("die") or v:FindFirstChild("Follow")) and v.Humanoid.Health <= v.Humanoid.MaxHealth then
                        v.Humanoid.Health = 0
                    end
                end
                for i,v in pairs(game:GetService("Workspace"):GetDescendants()) do
                    if (v.Name == "God Paranoid" or v.Name == "The First Elder God") and v:FindFirstChild("die") and v.Humanoid.Health <= v.Humanoid.MaxHealth then
                        v.Humanoid.Health = 0
                    end
                end
            end
        end)
    end)
end

-- Anti AFK
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

--game:GetService("Workspace")["omni_portal1"].ProximityPrompt
--3149.29272, 47883.5195, 34478.6836, -0.337581515, -1.1924425e-08, 0.941296279, -3.97436928e-09, 1, 1.12427418e-08, -0.941296279, 5.42827693e-11, -0.337581515