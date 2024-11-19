getgenv().Settings = {
    AutoFarmMob = nil,
    Weapon = nil,
    Mob = nil,
    Position = nil,
}

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

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Blobby Hub" .. " | ".."AOPG".." | ".."[Version 0.1]",
    TabWidth = 160,
    Size =  Device, --UDim2.fromOffset(480, 360), --default size (580, 460)
    Acrylic = false, -- การเบลออาจตรวจจับได้ การตั้งค่านี้เป็น false จะปิดการเบลอทั้งหมด
    Theme = "Amethyst", --Amethyst
    MinimizeKey = Enum.KeyCode.LeftControl
})

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
    local SelectWeapons = Tabs.pageSetting:AddDropdown("SelectWeapon", {
        Title = "Select Weapon",
        Values = WeaponList,
        Multi = false,
        Default = getgenv().Settings.Weapon or "",
        Callback = function(Value)
            getgenv().Settings.Weapon = Value
        end
    })
    SelectWeapons:OnChanged(function(Value)
        getgenv().Settings.Weapon = Value
    end)
    local RefreshWeapon = Tabs.pageSetting:AddButton({
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
    
    local SelectPosition = Tabs.pageSetting:AddDropdown("SelectPosition", {
        Title = "Select Position",
        Values = {"Over", "Under", "Behide", "Font"},
        Multi = false,
        Default = getgenv().Settings.Position or "",
        Callback = function(Value)
            getgenv().Settings.Position = Value
        end
    })
    SelectPosition:OnChanged(function(value)
        getgenv().Settings.Position = value
    end)

    
    --[[ MAIN ]]--------------------------------------------------------
    local MobList = {}
    local function mobListInsert()
        local uniqueMobs = {}
        
        for i, v in pairs(game:GetService("Workspace").Entities:GetChildren()) do
            if v:IsA("Model") and v:FindFirstChild("Data") then
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
    local FarmMobTitle = Tabs.pageMain:AddSection("FarmMob")
    local SelectMobs = Tabs.pageMain:AddDropdown("SelectMob", {
        Title = "Select Mob",
        Values = MobList,
        Multi = false,
        Default = getgenv().Settings.Mob or "",
        Callback = function(Value)
            getgenv().Settings.Mob = Value
        end
    })
    SelectMobs:OnChanged(function(value)
        getgenv().Settings.Mob = value
    end)
    
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

    local AutoFarm = Tabs.pageMain:AddToggle("AutoFarmMob", {Title = "Auto Farm Mob", Default = getgenv().Settings.AutoFarmMob or false })
    

    --[[ SCRIPTS ]]--------------------------------------------------------
    AutoFarm:OnChanged(function()
        task.spawn(function()
            local Player = game.Players.LocalPlayer
            local Character = Player.Character
            local noclipE = false
            local antifall = false
    
            local function AttackMelee(Target)
                local ohString1 = "Fighting Style"
                local ohString2 = "MouseButton1"
                local ohCFrame3 = Target
                local ohInstance4 = game.Workspace
                local ohNumber5 = 5
                game:GetService("ReplicatedStorage").Remotes.requestAbility:FireServer(ohString1, ohString2, ohCFrame3, ohInstance4, ohNumber5)
            end
            local function noclip()
                for i, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                    if v:IsA("BasePart") and v.CanCollide == true then
                        v.CanCollide = false
                        game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                    end
                end
            end
            local function tween(Target)
                Distance = (Target.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if Distance <= 200 then
                    Speed = 150
                elseif Distance >= 400 then
                    Speed = 250
                end
                if not game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyVelocity") then
                    antifall = Instance.new("BodyVelocity", game.Players.LocalPlayer.Character.HumanoidRootPart)
                    antifall.Velocity = Vector3.new(0,0,0)
                    noclipE = game:GetService("RunService").Stepped:Connect(noclip)
                    game:GetService("TweenService"):Create(
                    game.Players.LocalPlayer.Character.HumanoidRootPart,
                    TweenInfo.new(Distance/Speed, Enum.EasingStyle.Linear),
                    {CFrame = Target}
                ):Play()
                end
            end

            while AutoFarm.Value do
                wait()
                if not Character:FindFirstChildOfClass("Tool") then
                    for i, v in pairs(Player.Backpack:GetChildren()) do
                        if v.Name == getgenv().Settings.Weapon and v:IsA("Tool") then
                            local humanoid = Character:FindFirstChild("Humanoid") or Character:WaitForChild("Humanoid", 5)
                            humanoid:EquipTool(v)
                        end
                    end
                else
                    local currentTarget
                    for i, v in pairs(game:GetService("Workspace").Entities:GetChildren()) do
                        if v.Name == getgenv().Settings.Mob and v:FindFirstChild("Data") and v.Humanoid.Health > 0 then
                            currentTarget = v
                            break
                        end
                    end
            
                    if currentTarget then
                        while currentTarget and currentTarget.Humanoid.Health > 0 and AutoFarm.Value do
                            wait()
                            pcall(function()
                                if getgenv().Settings.Position == "Over" then
                                    tween(currentTarget.HumanoidRootPart.CFrame * CFrame.new(0, 8, 0) * CFrame.Angles(-1.5, 0, 0))
                                    AttackMelee(currentTarget.HumanoidRootPart.CFrame)
                                elseif getgenv().Settings.Position == "Under" then
                                    tween(currentTarget.HumanoidRootPart.CFrame * CFrame.new(0, -8, 0) * CFrame.Angles(1.5, 0, 0))
                                    AttackMelee(currentTarget.HumanoidRootPart.CFrame)
                                elseif getgenv().Settings.Position == "Behide" then
                                    tween(currentTarget.HumanoidRootPart.CFrame * CFrame.new(0, 0, 8) * CFrame.Angles(0, 0, 0))
                                    AttackMelee(currentTarget.HumanoidRootPart.CFrame)
                                elseif getgenv().Settings.Position == "Font" then
                                    tween(currentTarget.HumanoidRootPart.CFrame * CFrame.new(0, 0, -8) * CFrame.Angles(0, 0, 0))
                                    AttackMelee(currentTarget.HumanoidRootPart.CFrame)
                                end
                            end)
                        end
                    end
                end
            end            
        end)
    end)    

end

Window:SelectTab(1)