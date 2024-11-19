repeat wait() until game:IsLoaded() and game.Players and game.Players.LocalPlayer and game.Players.LocalPlayer.Character
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

getgenv().Settings = {
    AutoFarmQuest = nil,
    SelectedQuest = nil,
    SelectMob = nil,
    AutoFarmMob = nil,
    SelectTeleport = nil,
    AutoFarmWanted = nil,
    AutoFarmDungeon = nil,
    AutoTrainBreathing = nil,
}

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Blobby Hub" .. " | ".."Slayer Online [Update 1]".." | ".."[Version 1.05.0]",
    TabWidth = 160,
    Size =  Device, --UDim2.fromOffset(480, 360), --default size (580, 460)
    Acrylic = false, -- การเบลออาจตรวจจับได้ การตั้งค่านี้เป็น false จะปิดการเบลอทั้งหมด
    Theme = "Amethyst", --Amethyst
    MinimizeKey = Enum.KeyCode.P
})

if oCButton then
    oCButton.MouseButton1Click:Connect(function()
        local fluentUi = game:GetService("CoreGui"):FindFirstChild("ScreenGui") or game:GetService("CoreGui"):WaitForChild("ScreenGui", 5)
        for i,v in pairs(fluentUi:GetChildren()) do
            if v.Name == "Frame" and v:FindFirstChild("CanvasGroup") then
                local EN = not v.Visible
                v.Visible = EN
                getgenv().Settings.HideGui = EN
                SaveSetting()
            end
        end
    end)
end

local Tabs = {
    --[[ Tabs --]]
    --pageSetting = Window:AddTab({ Title = "Settings", Icon = "settings" }),
    pageMain = Window:AddTab({ Title = "Main", Icon = "home" }),
    pageMiscellaneous = Window:AddTab({ Title = "Miscellaneous", Icon = "component" }),
    pageTeleport = Window:AddTab({ Title = "Teleport", Icon = "map" }),
    pageWebhook = Window:AddTab({ Title = "Webhooks", Icon = "globe" }),
}

do
    --[[ SETTINGS ]]--------------------------------------------------------

    --[[ MAIN ]]--------------------------------------------------------
    local General = Tabs.pageMain:AddSection("Farm Quest")
    local QuestList = {}
    local function GetQuestList()
        for i,v in pairs(game:GetService("Workspace").IgnoreList.Quests:GetChildren()) do
            if v:IsA("Model") then
                table.insert(QuestList, v.Name)
            end
        end
    end
    local function QuestListRemove()
        if QuestList ~= nil then
            for i = #QuestList, 1, -1 do
                table.remove(QuestList, i)
            end
        end
    end
    GetQuestList()
    local SelectQuest = Tabs.pageMain:AddDropdown("SelectQuest", {
        Title = "Select Quest",
        Values = QuestList,
        Multi = false,
        Default = getgenv().Settings.SelectedQuest or "",
        Callback = function(Value)
            getgenv().Settings.SelectedQuest = Value
        end
    })
    local RefreshQuest = Tabs.pageMain:AddButton({
        Title = "Refresh Quest",
        Callback = function()
            local currentSelection = SelectQuest.Value
            
            QuestListRemove()
            GetQuestList()
            SelectQuest:SetValues(QuestList)
            
            if table.find(QuestList, currentSelection) then
                SelectQuest:SetValue(currentSelection)
            else
                SelectQuest:SetValue(QuestList[#QuestList])
            end
        end
    })
    SelectQuest:OnChanged(function(Value)
        getgenv().Settings.SelectedQuest = Value
    end)
    local AutoFarmQuest = Tabs.pageMain:AddToggle("AutoFarmQuest", {Title = "Auto Farm Quest", Default = getgenv().Settings.AutoFarmQuest or false })
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
    local FarmMobTitle = Tabs.pageMain:AddSection("Farm Mob")
    local SelectMobs = Tabs.pageMain:AddDropdown("SelectMob", {
        Title = "Select Mob",
        Values = MobList,
        Multi = false,
        Default = getgenv().Settings.SelectMob or "",
        Callback = function(Value)
            getgenv().Settings.SelectMob = Value
        end
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
    SelectMobs:OnChanged(function(Value)
        getgenv().Settings.SelectMob = Value
    end)
    local AutoFarmMob = Tabs.pageMain:AddToggle("AutoFarmMob", {Title = "Auto Farm Mob", Default = getgenv().Settings.AutoFarmMob or false })
    local FarmWantedTitle = Tabs.pageMain:AddSection("Farm Wanted")
    local AutoFarmWanted = Tabs.pageMain:AddToggle("AutoFarmWanted", {Title = "Auto Farm Wanted", Default = getgenv().Settings.AutoFarmWanted or false })
    local FarmDungeonTitle = Tabs.pageMain:AddSection("Farm Dungeon")
    local AutoFarmDungeon = Tabs.pageMain:AddToggle("AutoFarmDungeon", {Title = "Auto Farm Dungeon", Default = getgenv().Settings.AutoFarmDungeon or false })

    --[[ TELEPORT ]]--------------------------------------------------------
    local SelectTeleport = Tabs.pageTeleport:AddDropdown("SelectMob", {
        Title = "Select Mob",
        Values = {"Fukushima Village", "Buttlefly Village", "Mount Natagumo", "Kumotori Village", "Mount Kumotori Peak", "Cave", "Final Selection", "Water Trainer House"},
        Multi = false,
        Default = getgenv().Settings.SelectTeleport or "Fukushima Village",
        Callback = function(Value)
            getgenv().Settings.SelectTeleport = Value
        end
    })
    SelectTeleport:OnChanged(function(Value)
        getgenv().Settings.SelectTeleport = Value
    end)
    local teleportLocations = {
        ["Fukushima Village"] = CFrame.new(122.1, 28.2513, -1990.81),
        ["Buttlefly Village"] = CFrame.new(-1312.36, 39.5513, -2884.04),
        ["Mount Natagumo"] = CFrame.new(972.63, 22.7158, -2632.73),
        ["Kumotori Village"] = CFrame.new(1756.23, 7.96011, -4661.25),
        ["Mount Kumotori Peak"] = CFrame.new(231.065, 212.896, -3856.38),
        ["Cave"] = CFrame.new(1488.1, 7.60565, -5290.35),
        ["Final Selection"] = CFrame.new(-1558.73, 6.35564, -5119.1),
        ["Water Trainer House"] = CFrame.new(-1813.07, 154.078, -1497.25)
    }
    local Teleport = Tabs.pageTeleport:AddButton({
        Title = "Teleport",
        Callback = function()
            local character = game.Players.LocalPlayer.Character
            local selectedLocation = getgenv().Settings.SelectTeleport

            local antifall = nil

            if antifall then
                antifall:Destroy()
                antifall = nil
            end

            if teleportLocations[selectedLocation] then
                if not character.HumanoidRootPart:FindFirstChild("BodyVelocity") then
                    antifall = Instance.new("BodyVelocity", character.HumanoidRootPart)
                    antifall.Velocity = Vector3.new(0, 0, 0)
                end
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = teleportLocations[selectedLocation]
                wait(1)
                if antifall then
                    antifall:Destroy()
                    antifall = nil
                end
            end
        end
    })
    local TeleportToTrack = Tabs.pageTeleport:AddButton({
        Title = "Teleport To Track",
        Callback = function()
            local character = game.Players.LocalPlayer.Character
            local HumanoidRootPart = character:WaitForChild("HumanoidRootPart")

            local antifall = nil

            if antifall then
                antifall:Destroy()
                antifall = nil
            end

            for _, tracker in ipairs(game:GetService("Workspace").IgnoreList.Tracker:GetChildren()) do
                if tracker.Name == "Track" and tracker:IsA("BasePart") then
                    if not character.HumanoidRootPart:FindFirstChild("BodyVelocity") then
                        antifall = Instance.new("BodyVelocity", character.HumanoidRootPart)
                        antifall.Velocity = Vector3.new(0, 0, 0)
                    end
                    HumanoidRootPart.CFrame = tracker.CFrame
                    wait(1)
                end
            end
            if antifall then
                antifall:Destroy()
                antifall = nil
            end
        end
    })

    --[[ Miscellaneous ]]--------------------------------------------------------
    local AutoTrainBreathing = Tabs.pageMiscellaneous:AddToggle("AutoTrainBreathing", {Title = "Auto Train Breathing", Default = getgenv().Settings.AutoTrainBreathing or false })
    local InfBreath = Tabs.pageMiscellaneous:AddButton({
        Title = "Inf Breath",
        Callback = function()
            game:GetService("ReplicatedStorage").ReplicatedStorage.Remotes.Misc:FireServer("Melee", "Breath")
        end
    })


    --[[ SCRIPTS ]]--------------------------------------------------------
    AutoFarmQuest:OnChanged(function()
        task.spawn(function()
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            if AutoFarmQuest.Value then
                local VirtualInputManager = game:GetService("VirtualInputManager")
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.R, false, nil)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.R, false, nil)
            end

            while AutoFarmQuest.Value do
                wait()
                local weaponEquip = character:GetAttribute("WeaponEquipped")
                local Attacking = character:GetAttribute("Attacking")
                if weaponEquip == true then
                    for i,v in pairs(game:GetService("Workspace").IgnoreList.Quests:GetChildren()) do
                        if v.Name == getgenv().Settings.SelectedQuest and v:IsA("Model") then
                            local NPCHumanoid = v.HumanoidRootPart
                            local Prompt = NPCHumanoid:FindFirstChildOfClass("ProximityPrompt")
                            
                            if player.PlayerGui.Interface.QuestProgress.Visible == true then
                                if player.PlayerGui.Interface.QuestProgress.QuestName.Text == "Benjen Help" then
                                    for i,v in pairs(game:GetService("Workspace").IgnoreList.QuestUtilities:GetChildren()) do
                                        if v.Name == tostring(player.Name).."Logs" and character.Humanoid.Health > 0  then
                                            local woodLog = v:FindFirstChild("WoodLog")
                                            character.HumanoidRootPart.CFrame = woodLog.WoodLog.CFrame
                                            fireproximityprompt(woodLog.WoodLog.ProximityPrompt)
                                        end
                                    end
                                elseif player.PlayerGui.Interface.QuestProgress.QuestName.Text == "Theon Help" then
                                    for i,v in pairs(game:GetService("Workspace").Npcs:GetDescendants()) do
                                        if v.Name == "Mountain_Boar" and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and character.Humanoid.Health > 0 then
                                            character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 0, 8)
                                            game:GetService("VirtualUser"):Button1Down(Vector2.new(9999,9999))
                                            game:GetService("VirtualUser"):Button1Up(Vector2.new(9999,9999))
                                        end
                                    end
                                end
                            else
                                character.HumanoidRootPart.CFrame = NPCHumanoid.CFrame * CFrame.new(0, 0, 5)
                                fireproximityprompt(Prompt)
                                if player.PlayerGui.Interface.Dialog.Visible == true then
                                    local VirtualInputManager = game:GetService("VirtualInputManager")
                                    local Dialog = player.PlayerGui.Interface:FindFirstChild("Dialog")

                                    if Dialog and Dialog.Visible == true then
                                        for i, v in pairs(Dialog:GetChildren()) do
                                            if v.Name == "Accept" and v:IsA("TextButton") then
                                                local buttonX = v.AbsolutePosition.X + v.AbsoluteSize.X / 2
                                                local buttonY = v.AbsolutePosition.Y + v.AbsoluteSize.Y / 2
                                                local offsetX = buttonX + 50
                                                local offsetY = buttonY + 50
                                                
                                                VirtualInputManager:SendMouseButtonEvent(offsetX, offsetY, 0, true, nil, 0)
                                                wait(0.05)
                                                VirtualInputManager:SendMouseButtonEvent(offsetX, offsetY, 0, false, nil, 0)
                                                
                                                VirtualInputManager:SendMouseButtonEvent(buttonX, buttonY, 0, true, nil, 0)
                                                wait(0.05)
                                                VirtualInputManager:SendMouseButtonEvent(buttonX, buttonY, 0, false, nil, 0)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                elseif weaponEquip == false then
                    local VirtualInputManager = game:GetService("VirtualInputManager")
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.R, false, nil)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.R, false, nil)
                end
            end
        end)
    end)

    AutoFarmMob:OnChanged(function()
        task.spawn(function()
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            
            local VirtualInputManager = game:GetService("VirtualInputManager")
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local Workspace = game:GetService("Workspace")
            local VirtualUser = game:GetService("VirtualUser")
        
            local targetMob = nil
            local lastPosition = nil
            local antifall = nil

            if AutoFarmQuest.Value then
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.R, false, nil)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.R, false, nil)
                if not character.HumanoidRootPart:FindFirstChild("BodyVelocity") then
                    antifall = Instance.new("BodyVelocity", character.HumanoidRootPart)
                    antifall.Velocity = Vector3.new(0, 0, 0)
                end
            else
                if antifall then
                    antifall:Destroy()
                    antifall = nil
                end
            end
        
            while AutoFarmMob.Value do
                task.wait()

                local weaponEquip = character:GetAttribute("WeaponEquipped")
                local health = character:FindFirstChild("Humanoid") and character.Humanoid.Health or 0

                pcall(function()
                    if character.Humanoid.Health > 0 then
                        if weaponEquip then
                            if targetMob and targetMob:FindFirstChild("Humanoid") and targetMob.Humanoid.Health > 0 then
                                local mobCFrame = targetMob.HumanoidRootPart.CFrame
                                local isAttacking = targetMob:GetAttribute("Attacking")
                                local isBlocking = targetMob:GetAttribute("Blocking")
                            
                                local maxHealth = character.Humanoid.MaxHealth
                                local currentHealth = character.Humanoid.Health
    
                                if currentHealth > (maxHealth * 0.05) then
                                    if isAttacking then
                                        character.HumanoidRootPart.CFrame = mobCFrame * CFrame.new(0, 15, 0) * CFrame.Angles(-1.5, 0, 0)
                                    else
                                        character.HumanoidRootPart.CFrame = mobCFrame * CFrame.new(0, 6, 0) * CFrame.Angles(-1.5, 0, 0)
                                        if not isBlocking then
                                            VirtualUser:Button1Down(Vector2.new(9999, 9999))
                                            VirtualUser:Button1Up(Vector2.new(9999, 9999))
                                        end
                                    end
                                else
                                    repeat
                                        task.wait(0.5)
                                        currentHealth = character.Humanoid.Health
                                    until currentHealth >= (maxHealth * 0.5)
                                end
    
                            else
                                for _, mob in ipairs(Workspace.Npcs:GetChildren()) do
                                    if mob.Name == getgenv().Settings.SelectMob and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                                        targetMob = mob
                                        break
                                    end
                                end
                            end                        
                        else
                            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.R, false, nil)
                            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.R, false, nil)
                        end
                    end
                end)
            end
        end)        
    end)

    AutoFarmWanted:OnChanged(function()
        task.spawn(function()
            local VirtualUser = game:GetService("VirtualUser")
            local VirtualInputManager = game:GetService("VirtualInputManager")
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local HumanoidRootPart = character:WaitForChild("HumanoidRootPart")

            local antifall = nil

            if AutoFarmWanted.Value then
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.R, false, nil)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.R, false, nil)
                if not character.HumanoidRootPart:FindFirstChild("BodyVelocity") then
                    antifall = Instance.new("BodyVelocity", character.HumanoidRootPart)
                    antifall.Velocity = Vector3.new(0, 0, 0)
                end
            else
                if antifall then
                    antifall:Destroy()
                    antifall = nil
                end
                for i,v in pairs(character.HumanoidRootPart:GetChildren()) do
                    if v.Name == "BodyVelocity" then
                        v:Destroy()
                    end
                end
            end
    
            while AutoFarmWanted.Value do
                task.wait()
                local weaponEquip = character:GetAttribute("WeaponEquipped")
                local questProgress = player.PlayerGui.Interface:FindFirstChild("QuestProgress")
                pcall(function()
                    if character.Humanoid.Health > 0 then
                        if weaponEquip then
                            if questProgress and questProgress.Visible then
                                local Text = questProgress.QuestDescription.Text
                                local targetName = string.gsub(Text, "^Defeat ", "") -- ลบคำว่า "Defeat "
                                targetName = string.gsub(targetName, " ", "_") -- แทนที่ช่องว่างด้วย "_"
                                targetName = string.gsub(targetName, "s$", "") -- ลบตัว "s" ที่อยู่ท้ายคำ
                
                                local targetMob = nil
                                for _, mob in ipairs(game:GetService("Workspace").Npcs:GetChildren()) do
                                    if mob.Name == targetName and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                                        targetMob = mob
                                        break
                                    end
                                end
                
                                if targetMob then
                                    local isAttacking = targetMob:GetAttribute("Attacking")
                                    local isBlocking = targetMob:GetAttribute("Blocking")
                
                                    if isAttacking then
                                        HumanoidRootPart.CFrame = targetMob.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0) * CFrame.Angles(-1.5, 0, 0)
                                    else
                                        HumanoidRootPart.CFrame = targetMob.HumanoidRootPart.CFrame * CFrame.new(0, 6, 0) * CFrame.Angles(-1.5, 0, 0)
                                        if not isBlocking then
                                            VirtualUser:Button1Down(Vector2.new(9999, 9999))
                                            VirtualUser:Button1Up(Vector2.new(9999, 9999))
                                        end
                                    end
                                else
                                    for _, tracker in ipairs(game:GetService("Workspace").IgnoreList.Tracker:GetChildren()) do
                                        if tracker.Name == "Track" and tracker:IsA("BasePart") then
                                            HumanoidRootPart.CFrame = tracker.CFrame
                                            break
                                        end
                                    end
                                end
                            else
                                AutoFarmWanted:SetValue(false)
                                Fluent:Notify({
                                    Title = "BLOBBY HUB",
                                    Content = "Please Get Wanted Quest Before Use.",
                                    Duration = 5
                                })
                                task.wait(0.5)
                            end
                        else
                            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.R, false, nil)
                            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.R, false, nil)    
                        end
                    else
                        wait()
                    end
                end)
            end
        end)
    end)

    AutoFarmDungeon:OnChanged(function()
        task.spawn(function()
            local VirtualUser = game:GetService("VirtualUser")
            local VirtualInputManager = game:GetService("VirtualInputManager")
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local HumanoidRootPart = character:WaitForChild("HumanoidRootPart")
            local antifall = nil

            local function toggleAntiFall(enable)
                if enable then
                    if not HumanoidRootPart:FindFirstChild("BodyVelocity") then
                        antifall = Instance.new("BodyVelocity", HumanoidRootPart)
                        antifall.Velocity = Vector3.zero
                        antifall.MaxForce = Vector3.new(1e6, 1e6, 1e6)
                    end
                elseif antifall then
                    antifall:Destroy()
                    antifall = nil
                    for i,v in pairs(character.HumanoidRootPart:GetChildren()) do
                        if v.Name == "BodyVelocity" then
                            v:Destroy()
                        end
                    end
                end
            end

            local function equipWeapon()
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.R, false, nil)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.R, false, nil)
            end

            if AutoFarmDungeon.Value then
                equipWeapon()
                toggleAntiFall(true)
            else
                toggleAntiFall(false)
            end

            while AutoFarmDungeon.Value do
                task.wait()

                local weaponEquipped = character:GetAttribute("WeaponEquipped")
                local isStunned = character:GetAttribute("Stunned")
                local questProgress = player.PlayerGui.Interface:FindFirstChild("QuestProgress")

                if weaponEquipped then
                    if game.PlaceId == 107410502434648 then
                        local targetMob = nil
                        for _, mob in ipairs(game.Workspace.Npcs:GetChildren()) do
                            if mob:IsA("Model") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                                targetMob = mob
                                break
                            else
                                HumanoidRootPart.CFrame = CFrame.new(184, 114, -1983)
                            end
                        end

                        pcall(function()
                            if targetMob then
                                local maxHealth = character.Humanoid.MaxHealth
                                local currentHealth = character.Humanoid.Health
    
                                if currentHealth > (maxHealth * 0.1) then
                                    if not isStunned then
                                        local isAttacking = targetMob:GetAttribute("Attacking")
                                        local isBlocking = targetMob:GetAttribute("Blocking")
        
                                        local heightOffset = isAttacking and 20 or 7
                                        HumanoidRootPart.CFrame = targetMob.HumanoidRootPart.CFrame 
                                            * CFrame.new(0, heightOffset, 0) 
                                            * CFrame.Angles(-1.5, 0, 0)
        
                                        if not isBlocking then
                                            VirtualUser:Button1Down(Vector2.new(9999, 9999))
                                            VirtualUser:Button1Up(Vector2.new(9999, 9999))
                                        end
                                    end
                                else
                                    repeat
                                        HumanoidRootPart.CFrame = CFrame.new(184, 114, -1983)
                                        task.wait(0.5)
                                        currentHealth = character.Humanoid.Health
                                    until currentHealth >= (maxHealth * 0.5)
                                end
                            else
                                task.wait()
                            end
                        end)
                    elseif game.PlaceId == 19001778364 then
                        local Text = questProgress.QuestDescription.Text
                        local targetName = string.gsub(Text, "^Defeat ", "") -- ลบคำว่า "Defeat "
                        targetName = string.gsub(targetName, " ", "_") -- แทนที่ช่องว่างด้วย "_"
                        targetName = string.gsub(targetName, "s$", "") -- ลบตัว "s" ที่อยู่ท้ายคำ
                        
                        for _, barrel in pairs(game:GetService("Workspace").IgnoreList.QuestUtilities:GetChildren()) do
                            if barrel.Name == player.Name.."Barrels" and character.Humanoid.Health > 0 then
                                pcall(function()
                                    for _, subItem in pairs(barrel:GetChildren()) do
                                        if subItem.Name == "BlueLilliesBarrel" and subItem:IsA("Model") and v:FindFirstChild("Part") then
                                            local part = subItem:FindFirstChild("Part")
                                            local union = subItem:FindFirstChild("Union")
                                            local prompt = union and union:FindFirstChild("Attachment") and union.Attachment:FindFirstChild("ProximityPrompt")
                        
                                            if part and prompt then
                                                HumanoidRootPart.CFrame = part.CFrame * CFrame.new(0, 0, 3.5)
                                                task.wait(0.5)
                                                fireproximityprompt(prompt)
                                                task.wait(0.5)
                                            end
                                        end
                                    end
                                end)

                                for _, tracker in pairs(game:GetService("Workspace").IgnoreList.Tracker:GetChildren()) do
                                    if tracker.Name == "Track" and tracker:IsA("BasePart") then
                                        HumanoidRootPart.CFrame = tracker.CFrame
                                        task.wait(0.5)
                                    end
                                end
                            end
                        end                        
                    else
                        AutoFarmDungeon:SetValue(false)
                        Fluent:Notify({
                            Title = "BLOBBY HUB",
                            Content = "Please Join Dungeon Before Use.",
                            Duration = 5
                        })
                        task.wait(0.5)
                    end
                else
                    equipWeapon()
                end
            end
        end)
    end)

    AutoTrainBreathing:OnChanged(function()
        task.spawn(function()
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
        
            while AutoTrainBreathing.Value do
                task.wait()
                local hasGourd = false
        
                for _, v in pairs(character:GetChildren()) do
                    if string.find(v.Name, "Gourd") and v:IsA("Model") then
                        hasGourd = true
                        break
                    end
                end
        
                if hasGourd then
                    local success, err = pcall(function()
                        game:GetService("ReplicatedStorage").ReplicatedStorage.Remotes.Training:FireServer()
                    end)
                    if not success then
                        warn("Failed to fire RemoteEvent:", err)
                    end
                else
                    AutoTrainBreathing:SetValue(false)
                    Fluent:Notify({
                        Title = "BLOBBY HUB",
                        Content = "Please Buy Gourd Before Use.",
                        Duration = 5
                    })
                    break
                end
            end
        end)           
    end)
end

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