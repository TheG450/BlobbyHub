repeat wait() until game:IsLoaded() and game.Players and game.Players.LocalPlayer and game.Players.LocalPlayer.Character
getgenv().Settings = {
    SelectWeaponType = nil,
    AutoBusoHaki = nil,
    SelecSkillKeys = nil,
    AutoSkills = nil,
    AutoFarmLevel = nil,
    SelectMobs = nil,
    AutoFarmMob = nil,
    SelecStats = nil,
    AutoStats = nil,
    JujutsuMission = nil,
    BleachMission = nil,
    SelectIsland = nil,
    AutoFarmBoss = nil,
}

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Blobby Hub" .. " | ".."Verse Piece".." | ".."[Version Beta]",
    SubTitle = "by Blobby",
    TabWidth = 160,
    Size =  UDim2.fromOffset(580, 460), --UDim2.fromOffset(480, 360), --default size (580, 460)
    Acrylic = false, -- การเบลออาจตรวจจับได้ การตั้งค่านี้เป็น false จะปิดการเบลอทั้งหมด
    Theme = "Rose", --Amethyst
    MinimizeKey = Enum.KeyCode.P
})

local Tabs = {
    --[[ Tabs --]]
    pageSetting = Window:AddTab({ Title = "Settings", Icon = "settings" }),
    pageMain = Window:AddTab({ Title = "Main", Icon = "home" }),
    pageExtra = Window:AddTab({ Title = "Extra", Icon = "bar-chart" }),
    pageTeleport = Window:AddTab({ Title = "Teleport", Icon = "map" }),
    pageMiscellaneous = Window:AddTab({ Title = "Miscellaneous", Icon = "component" }),
}

do
    --[[ SETTINGS ]]--------------------------------------------------------
    local Settings = Tabs.pageSetting:AddSection("Settings")
    local WeaponType = {"Combat", "Sword", "Fruit"}
    local SelectWeaponType = Tabs.pageSetting:AddDropdown("SelectWeaponType", {
        Title = "Select Weapon Type",
        Values = WeaponType,
        Multi = false,
        Default = getgenv().Settings.SelectWeaponType or "",
        Callback = function(Value)
            getgenv().Settings.SelectWeaponType = Value
        end
    })
    SelectWeaponType:OnChanged(function(Value)
        getgenv().Settings.SelectWeaponType = Value
    end)
    local AutoBusoHaki = Tabs.pageSetting:AddToggle("AutoBusoHaki", {Title = "Auto Buso Haki", Default = getgenv().Settings.AutoBusoHaki or false })
    local Skills = Tabs.pageSetting:AddSection("Skills")
    local SkillKeys = {"Z", "X", "C", "V", "F"}
    local SelecSkillKeys = Tabs.pageSetting:AddDropdown("SelecSkillKeys", {
        Title = "Select Weapon Type",
        Values = SkillKeys,
        Multi = true,
        Default = getgenv().Settings.SelecSkillKeys or {},
    })
    SelecSkillKeys:OnChanged(function(Value)
        local Values = {}
        for Value, State in next, Value do
            table.insert(Values, Value)
        end
        getgenv().Settings.SelecSkillKeys = Values
    end)
    local AutoSkills = Tabs.pageSetting:AddToggle("AutoSkills", {Title = "Auto Skills", Default = getgenv().Settings.AutoSkills or false })
    local Stats = Tabs.pageSetting:AddSection("Stats")
    local StatsList = {"Strength", "Defense", "Sword", "Special"}
    local SelecStats = Tabs.pageSetting:AddDropdown("SelecStats", {
        Title = "Select Stats",
        Values = StatsList,
        Multi = true,
        Default = getgenv().Settings.SelecStats or {},
    })
    SelecStats:OnChanged(function(Value)
        local Values = {}
        for Value, State in next, Value do
            table.insert(Values, Value)
        end
        getgenv().Settings.SelecStats = Values
    end)
    local AutoStats = Tabs.pageSetting:AddToggle("AutoStats", {Title = "Auto Stats", Default = getgenv().Settings.AutoStats or false })

    --[[ MAIN ]]--------------------------------------------------------
    local Levels = Tabs.pageMain:AddSection("Levels")
    local AutoFarmLevel = Tabs.pageMain:AddToggle("AutoFarmLevel", {Title = "Auto Farm Level", Default = getgenv().Settings.AutoFarmLevel or false })
    local Mobs = Tabs.pageMain:AddSection("Mobs")
    local MobList = {}
    local function mobListInsert()
        local uniqueMobs = {}
        local playerNames = {}
    
        for _, player in pairs(game.Players:GetPlayers()) do
            playerNames[player.Name] = true
        end
    
        for i, v in pairs(game:GetService("Workspace").Main:GetDescendants()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") then
                if not playerNames[v.Name] and not uniqueMobs[v.Name] then
                    table.insert(MobList, v.Name)
                    uniqueMobs[v.Name] = true
                end
            end
        end

        -- สมมติว่า 'Main' เป็น Child ของ Workspace
        -- local Main = workspace:FindFirstChild("Main")

        -- if Main then
        --     local npcTable = {}

        --     -- ฟังก์ชันสำหรับค้นหา NPC ภายในโฟลเดอร์ย่อย
        --     local function collectNPCs(folder)
        --         for _, child in ipairs(folder:GetChildren()) do
        --             if child:IsA("Model") then
        --                 table.insert(npcTable, child) -- เพิ่ม Model เข้า Table
        --             elseif child:IsA("Folder") then
        --                 collectNPCs(child) -- ค้นหาต่อในโฟลเดอร์ย่อย
        --             end
        --         end
        --     end

        --     -- เรียกฟังก์ชัน collectNPCs กับโฟลเดอร์ Main
        --     collectNPCs(Main)

        --     -- ตรวจสอบ NPC ที่เก็บใน Table
        --     print("NPCs collected:")
        --     for _, npc in ipairs(npcTable) do
        --         print(npc.Name)
        --     end
        -- else
        --     warn("Main folder not found in Workspace!")
        -- end

    end
    
    local function mobListRemove()
        if MobList ~= nil then
            for i = #MobList, 1, -1 do
                table.remove(MobList, i)
            end
        end
    end
    mobListInsert()
    local SelectMobs = Tabs.pageMain:AddDropdown("SelectMobs", {
        Title = "Select Mob",
        Values = MobList,
        Multi = false,
        Default = getgenv().Settings.SelectMobs or "",
        Callback = function(Value)
            getgenv().Settings.SelectMobs = Value
        end
    })
    SelectMobs:OnChanged(function(Value)
        getgenv().Settings.SelectMobs = Value
    end)
    local RefreshMob = Tabs.pageMain:AddButton({
        Title = "Refresh List",
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
    local AutoFarmMob = Tabs.pageMain:AddToggle("AutoFarmMob", {Title = "Auto Farm Mob", Default = getgenv().Settings.AutoFarmMob or false })
    local Boss = Tabs.pageMain:AddSection("Boss")
    local AutoFarmBoss = Tabs.pageMain:AddToggle("AutoFarmBoss", {Title = "Auto Farm Boss", Default = getgenv().Settings.AutoFarmBoss or false })

    --[[ EXTRA ]]--------------------------------------------------------
    local Mission = Tabs.pageExtra:AddSection("Mission")
    local JujutsuMission = Tabs.pageExtra:AddToggle("JujutsuMission", {Title = "Jujutsu Mission", Default = getgenv().Settings.JujutsuMission or false })
    local BleachMission = Tabs.pageExtra:AddToggle("BleachMission", {Title = "Bleach Mission", Default = getgenv().Settings.BleachMission or false })

    --[[ TELEPORT ]]--------------------------------------------------------
    local Island = Tabs.pageTeleport:AddSection("Island")
    local IslandList = {}
    local function GetIslandList()
        for i,v in pairs(game:GetService("Workspace").Spawn:GetChildren()) do
            if v:IsA("BasePart") then
                table.insert(IslandList, v.Name)
            end
        end
    end
    GetIslandList()
    local SelectIsland = Tabs.pageTeleport:AddDropdown("SelectIsland", {
        Title = "Select Island",
        Values = IslandList,
        Multi = false,
        Default = getgenv().Settings.SelectIsland or "",
        Callback = function(Value)
            getgenv().Settings.SelectIsland = Value
        end
    })
    SelectIsland:OnChanged(function(Value)
        getgenv().Settings.SelectIsland = Value
    end)
    local Teleport = Tabs.pageTeleport:AddButton({
        Title = "Teleport",
        Callback = function()
            for i,v in pairs(game:GetService("Workspace").Spawn:GetChildren()) do
                if v:IsA("BasePart") and v.Name == tostring(getgenv().Settings.SelectIsland) then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
                end
            end
        end
    })
    local NPC = Tabs.pageTeleport:AddSection("NPC")
    local NPCList = {}
    local function GetNPCList()
        for i,v in pairs(game:GetService("Workspace").Npc:GetDescendants()) do
            if v:IsA("Model") then
                table.insert(NPCList, v.Name)
            end
        end
    end
    local function NPCListRemove()
        if QuestList ~= nil then
            for i = #QuestList, 1, -1 do
                table.remove(QuestList, i)
            end
        end
    end
    GetNPCList()
    local SelectNPC = Tabs.pageTeleport:AddDropdown("SelectNPC", {
        Title = "Select NPC",
        Values = NPCList,
        Multi = false,
        Default = getgenv().Settings.SelectNPC or "",
        Callback = function(Value)
            getgenv().Settings.SelectNPC = Value
        end
    })
    SelectNPC:OnChanged(function(Value)
        getgenv().Settings.SelectNPC = Value
    end)
    local RefreshNPC = Tabs.pageTeleport:AddButton({
        Title = "Refresh List",
        Callback = function()
            local currentSelection = SelectNPC.Value
            
            NPCListRemove()
            GetNPCList()
            SelectNPC:SetValues(NPCList)
            
            if table.find(NPCList, currentSelection) then
                SelectNPC:SetValue(currentSelection)
            else
                SelectNPC:SetValue(NPCList[#NPCList])
            end
        end
    })
    local TeleportNPC = Tabs.pageTeleport:AddButton({
        Title = "Teleport",
        Callback = function()
            for i,v in pairs(game:GetService("Workspace").Npc:GetChildren()) do
                if v:IsA("Model") and v.Name == tostring(getgenv().Settings.SelectNPC) then
                    if v:IsA("BasePart") then
                        game.Players.LocalPlayer.Characters.HumanoidRootPart.CFrame = v.CFrame
                    end
                end
            end
        end
    })

    --[[ Miscellaneous ]]--------------------------------------------------------
    local CS = Tabs.pageMiscellaneous:AddSection("Comming Soon!!!")

    --[[ SCRIPTS ]]--------------------------------------------------------
    local function checkQuest(Lvl)
        local Details = {
            QuestNumber,
            QuestName,
            MobName,
            IslandName,
            Type
        }
        if Lvl > 0 and Lvl <= 50 then
            Details.QuestNumber = 1
            Details.QuestName = "Quest 1"
            Details.MobName = "Bandit [Lv.5]"
            Details.IslandName = "Starter"
            Details.Type = "Bandits"
        elseif Lvl > 50 and Lvl <= 100 then
            Details.QuestNumber = 2
            Details.QuestName = "Quest 2"
            Details.MobName = "Bandit Leader [Lv.50]"
            Details.IslandName = "Starter"
            Details.Type = "Bandit Leader"
        elseif Lvl > 100 and Lvl <= 200 then
            Details.QuestNumber = 3
            Details.QuestName = "Quest 3"
            Details.MobName = "Monkey [Lv.100]"
            Details.IslandName = "Jungle"
            Details.Type = "Monkey"
        elseif Lvl > 200 and Lvl <= 300 then
            Details.QuestNumber = 4
            Details.QuestName = "Quest 4"
            Details.MobName = "Monkey King [Lv.150]"
            Details.IslandName = "Jungle"
            Details.Type = "Monkey King"
        elseif Lvl > 300 and Lvl <= 450 then
            Details.QuestNumber = 5
            Details.QuestName = "Quest 5"
            Details.MobName = "Snow Bandit [Lv.300]"
            Details.IslandName = "Snow"
            Details.Type = "Snow Bandit"
        elseif Lvl > 450 and Lvl <= 600 then
            Details.QuestNumber = 6
            Details.QuestName = "Quest  6"
            Details.MobName = "Snow Bandit Leader [Lv.450]"
            Details.IslandName = "Snow"
            Details.Type = "Snow Bandit Leader"
        elseif Lvl > 600 and Lvl <= 1100 then
            Details.QuestNumber = 7
            Details.QuestName = "Quest 7"
            Details.MobName = "Desert Thief [Lv.1000]"
            Details.IslandName = "Desert"
            Details.Type = "Desert Thief"
        elseif Lvl > 1100 and Lvl <= 1500 then
            Details.QuestNumber = 8
            Details.QuestName = "Quest 8"
            Details.MobName = "Desert King [Lv.1500]"
            Details.IslandName = "Desert"
            Details.Type = "Desert King"
        elseif Lvl > 1500 and Lvl <= 2250 then
            Details.QuestNumber = 9
            Details.QuestName = "Quest 9"
            Details.MobName = "Marine Soldier [Lv.2000]"
            Details.IslandName = "Shells"
            Details.Type = "Marine Soldier"
        elseif Lvl > 2250 and Lvl <= 3000 then
            Details.QuestNumber = 10
            Details.QuestName = "Quest 10"
            Details.MobName = "Dark Adventure [Lv.2500]"
            Details.IslandName = "Shells"
            Details.Type = "Dark Adventure"
        elseif Lvl > 3000 and Lvl <= 4000 then
            Details.QuestNumber = 11
            Details.QuestName = "Quest 11"
            Details.MobName = "Sorceror Student [Lv.3500]"
            Details.IslandName = "Hidden"
            Details.Type = "Sorceror Student"
        elseif Lvl > 4000 and Lvl <= 5000 then
            Details.QuestNumber = 12
            Details.QuestName = "Quest 12"
            Details.MobName = "Sorceror Teacher [Lv.4500]"
            Details.IslandName = "Hidden"
            Details.Type = "Sorceror Teacher"
        elseif Lvl > 5000 and Lvl <= 6250 then
            Details.QuestNumber = 13
            Details.QuestName = "Quest 13"
            Details.MobName = "Frost Soldier [Lv.6000]"
            Details.IslandName = "Frost"
            Details.Type = "Frost Soldier"
        elseif Lvl > 6250  then
            Details.QuestNumber = 14
            Details.QuestName = "Quest 14"
            Details.MobName = "Frost King [Lv.7500]"
            Details.IslandName = "Frost"
            Details.Type = "Frost King"
        end

        return Details
    end

    local function getHumanoidRootPart()
        local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
        return character:WaitForChild("HumanoidRootPart", 9e99)
    end

    local function Attack()
        local VirtualUser = game:GetService("VirtualUser")
        VirtualUser:Button1Down(Vector2.new(9999, 9999))
        VirtualUser:Button1Up(Vector2.new(9999, 9999)) 
    end

    local function EquipTool(type)
        for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
            if v:IsA("Tool") and v:FindFirstChild(tostring(type)) then
                game.Players.LocalPlayer.Character.Humanoid:EquipTool(v)
            end
        end
    end

    local GuiService = game:GetService("GuiService")
    local VirtualInputManager = game:GetService("VirtualInputManager")
    local antifall
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local HumanoidRootPart = getHumanoidRootPart()
    AutoFarmLevel:OnChanged(function()
        task.spawn(function()
            player.CharacterAdded:Connect(function(newCharacter)
                character = newCharacter
                HumanoidRootPart = newCharacter:WaitForChild("HumanoidRootPart", 9e99)
            end)

            while AutoFarmLevel.Value do
                wait()
                local Levels = game:GetService("Players").LocalPlayer.PlayerData.Levels.Value
                local Details = checkQuest(Levels)
                local Active = game:GetService("Players").LocalPlayer.QuestData1:FindFirstChild("Active") or game:GetService("Players").LocalPlayer.QuestData1:WaitForChild("Active", 5)

                function BringMonster(TargetCFrame)
                    -- for i,v in pairs(game:GetService("Workspace").Main[Details.IslandName][Details.Type]:GetChildren()) do
                    --     if v.Name == Details.MobName then
                    --         if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                    --             if (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < tonumber(150) then
                    --                 v.HumanoidRootPart.CFrame = TargetCFrame
                    --                 v.Humanoid.WalkSpeed = 0
                    --                 v.Humanoid.JumpPower = 0
                    --                 v.HumanoidRootPart.CanCollide = false
                    --                 --v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                    --                 v.HumanoidRootPart.Transparency = 1
                    --                 if v.Humanoid:FindFirstChild("Animator") then
                    --                     v.Humanoid.Animator:Destroy()
                    --                 end
                    --                 sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
                    --             end
                    --         end
                    --     end
                    -- end
                    for i,v in pairs(game:GetService("Workspace").Main[Details.IslandName][Details.Type]:GetChildren()) do
                        for x,y in pairs(game:GetService("Workspace").Main[Details.IslandName][Details.Type]:GetChildren()) do
                            if v.Name == Details.MobName then
                                if y.Name == Details.MobName then
                                    v.HumanoidRootPart.CFrame = y.HumanoidRootPart.CFrame
                                    --v.HumanoidRootPart.CanCollide = false
                                    -- v.Humanoid.PlatformStand = true
                                    -- y.Humanoid.PlatformStand = true
                                    y.HumanoidRootPart.CanCollide = false
                                    v.Humanoid.WalkSpeed = 0
                                    y.Humanoid.WalkSpeed = 0
                                    v.Humanoid.JumpPower = 0
                                    y.Humanoid.JumpPower = 0
                                    if sethiddenproperty then
                                        sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
                                    end
                                end
                            end
                        end
                    end
                end

                local Success, Err = pcall(function()
                    if HumanoidRootPart:FindFirstChild("antifall") and HumanoidRootPart:FindFirstChildOfClass("BodyVelocity") then
                        for _, tool in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
                            if tool:IsA("Tool") and tool:FindFirstChild(getgenv().Settings.SelectWeaponType) then
                                if game:GetService("Players").LocalPlayer.QuestData1.Quest.Value == Details.QuestNumber then
                                    for i,v in pairs(game:GetService("Workspace").Main[Details.IslandName][Details.Type]:GetChildren()) do
                                        if Active.Value then
                                            if v.Name == Details.MobName and v.Humanoid.Health > 0 then
                                                repeat
                                                    wait()
                                                    HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 7, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                                                    game.Players.LocalPlayer.Character.Humanoid.PlatformStand = true
                                                    --HumanoidRootPart.CFrame = TargetHumanoidRootPart.CFrame * CFrame.new(0, 0, 7)
                                                    BringMonster(v.HumanoidRootPart.CFrame)
                                                    Attack()
                                                    task.spawn(function()
                                                        pcall(function()
                                                            for i,v in pairs(game:GetService("Workspace").Main[Details.IslandName][Details.Type]:GetDescendants()) do
                                                                if v.Name == Details.MobName and v.Humanoid.Health < (v.Humanoid.MaxHealth * 0.9) then
                                                                    v.Humanoid.Health = 0
                                                                    v.Humanoid.RigType = "R15"
                                                                end
                                                            end
                                                        end)
                                                    end)
                                                until v.Humanoid.Health <= 0
                                            else
                                                for j,k in pairs(game:GetService("Workspace").Npc.Quest:GetChildren()) do
                                                    if k.Name == Details.QuestName and k:FindFirstChild("ProximityPrompt") then
                                                        HumanoidRootPart.CFrame = k.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0)
                                                    end
                                                end
                                            end
                                        else
                                            for p, Quest in pairs(game:GetService("Workspace").Npc.Quest:GetChildren()) do
                                                if Quest.Name == Details.QuestName and Quest:FindFirstChild("ProximityPrompt") then
                                                    HumanoidRootPart.CFrame = Quest.HumanoidRootPart.CFrame * CFrame.new(0, 3.5, 0)
                                                    task.wait(.1)
                                                    Quest.ProximityPrompt.HoldDuration = 0
                                                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                                                    task.wait(.55)
                                                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                                                end
                                            end
                                        end
                                    end
                                else
                                    for i,v in ipairs(game:GetService("Players").LocalPlayer.PlayerGui.Quest.Frame:GetChildren()) do
                                        if string.find(v.Name, "QuestData") and v:FindFirstChild("Bar") then
                                            local Bar = v:FindFirstChild("Bar") or v:WaitForChild("Bar", 9e99)
                                            local Cancel = Bar:FindFirstChild("Cancel") or Bar:WaitForChild("Cancel", 9e99)
            
                                            if v then
                                                if Bar then
                                                    if Cancel then
                                                        GuiService.SelectedObject = Cancel
                                                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                                                        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                                                    end
                                                end
                                            end
                                            task.wait(.5)
                                            GuiService.SelectedObject = nil
                                        else
                                            for i,v in pairs(game:GetService("Workspace").Npc.Quest:GetChildren()) do
                                                if v.Name == Details.QuestName and v:FindFirstChild("ProximityPrompt") then
                                                    HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 3.5, 0)
                                                    task.wait(.1)
                                                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                                                    task.wait(.55)
                                                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                                                end
                                            end
                                        end
                                    end
                                end
                            else
                                EquipTool(getgenv().Settings.SelectWeaponType)
                            end
                        end
                    else
                        antifall = Instance.new("BodyVelocity", game.Players.LocalPlayer.Character.HumanoidRootPart)
                        antifall.Velocity = Vector3.new(0, 0, 0)
                        antifall.MaxForce = Vector3.new(100000, 100000, 100000)
                        antifall.P = 1250
                        antifall.Name = "antifall"
                    end
                end)
                if not Success then
                    warn("Error: "..Err)
                end
                -- task.spawn(function()
                --     pcall(function()
                --         for i,v in pairs(game:GetService("Workspace").Main[Details.IslandName][Details.Type]:GetDescendants()) do
                --             if v.Name == Details.MobName and v.Humanoid.Health < (v.Humanoid.MaxHealth * 0.9) then
                --                 v.Humanoid.Health = 0
                --                 v.Humanoid.RigType = "R15"
                --             end
                --         end
                --     end)
                -- end)
            end
            if not AutoFarmLevel.Value then
                pcall(function()
                    for i,v in pairs(game.Players.LocalPlayer.Character.HumanoidRootPart:GetChildren()) do
                        if v.Name == "antifall" or v:IsA("BodyVelocity") then
                            task.wait(.1)
                            v:Destroy()
                            antifall = nil
                            game.Players.LocalPlayer.Character.Humanoid.PlatformStand = false
                        end
                    end
                end)
            end
        end)
    end)

    AutoStats:OnChanged(function()
        task.spawn(function()
            while AutoStats.Value do
                task.wait()
                for i,v in ipairs(getgenv().Settings.SelecStats) do
                    pcall(function()
                        local Event = game:GetService("Players").LocalPlayer.PlayerGui.HUD.Stats.Iinv.Setting:FindFirstChild("Event") or game:GetService("Players").LocalPlayer.PlayerGui.HUD.Stats.Iinv.Setting:WaitForChild("Event", 9e99)
                        Event:FireServer(v, "1")
                    end)
                end
            end
        end)
    end)

    AutoBusoHaki:OnChanged(function()
        task.spawn(function()
            player.CharacterAdded:Connect(function(newCharacter)
                character = newCharacter
                HumanoidRootPart = newCharacter:WaitForChild("HumanoidRootPart", 9e99)
            end)
            if AutoBusoHaki.Value then
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.T, false, game)
                task.wait(0.1)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.T, false, game)
            end

            character.ChildRemoved:Connect(function(item)
                if item.Name == "HakiActive" and AutoBusoHaki.Value then
                    task.wait(0.5)
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.T, false, game)
                    task.wait(0.1)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.T, false, game)
                end
            end)
        end)
    end)    

    AutoFarmBoss:OnChanged(function()
        task.spawn(function()
            player.CharacterAdded:Connect(function(newCharacter)
                character = newCharacter
                HumanoidRootPart = newCharacter:WaitForChild("HumanoidRootPart", 9e99)
            end)

            while AutoFarmBoss.Value do
                wait()
                pcall(function()
                    if HumanoidRootPart:FindFirstChild("antifall") and HumanoidRootPart:FindFirstChildOfClass("BodyVelocity") then
                        for _, tool in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
                            if tool:IsA("Tool") and tool:FindFirstChild(getgenv().Settings.SelectWeaponType) then
                                for i,v in pairs(game:GetService("Workspace").Main.RaidBoss:GetChildren()) do
                                    if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") then
                                        local UI = v.HumanoidRootPart:FindFirstChild("UI") or v.HumanoidRootPart:WaitForChild("UI")
                                        if UI.Enabled == true then
                                            if v.Humanoid.Health > 0 then
                                                repeat wait()
                                                    HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 7, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                                                    game.Players.LocalPlayer.Character.Humanoid.PlatformStand = true
                                                    --HumanoidRootPart.CFrame = TargetHumanoidRootPart.CFrame * CFrame.new(0, 0, 7)
                                                    Attack()
                                                    task.spawn(function()
                                                        pcall(function()
                                                            for _,Kill in pairs(game:GetService("Workspace").Main.RaidBoss:GetDescendants()) do
                                                                if Kill:IsA("Model") and Kill.Humanoid.Health < (Kill.Humanoid.MaxHealth * 0.9) then
                                                                    Kill.Humanoid.Health = 0
                                                                    Kill.Humanoid.RigType = "R15"
                                                                end
                                                            end
                                                        end)
                                                    end)
                                                until v.Humanoid.Health <= 0
                                            else
                                                HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 12, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                                            end
                                        end
                                    else
                                        for j,k in pairs(game:GetService("Workspace").Main.Boss:GetChildren()) do
                                            if k:IsA("Model") and k:FindFirstChild("HumanoidRootPart") and k:FindFirstChild("Humanoid") then
                                                local UI = k.HumanoidRootPart:FindFirstChild("UI") or k.HumanoidRootPart:WaitForChild("UI")
                                                if UI.Enabled == true then
                                                    if k.Humanoid.Health > 0 then
                                                        repeat wait()
                                                            HumanoidRootPart.CFrame = k.HumanoidRootPart.CFrame * CFrame.new(0, 7, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                                                            game.Players.LocalPlayer.Character.Humanoid.PlatformStand = true
                                                            --HumanoidRootPart.CFrame = TargetHumanoidRootPart.CFrame * CFrame.new(0, 0, 7)
                                                            Attack()
                                                            task.spawn(function()
                                                                pcall(function()
                                                                    for _,Kill in pairs(game:GetService("Workspace").Main.Boss:GetDescendants()) do
                                                                        if Kill:IsA("Model") and Kill.Humanoid.Health < (Kill.Humanoid.MaxHealth * 0.9) then
                                                                            Kill.Humanoid.Health = 0
                                                                            Kill.Humanoid.RigType = "R15"
                                                                        end
                                                                    end
                                                                end)
                                                            end)
                                                        until k.Humanoid.Health <= 0
                                                    else
                                                        HumanoidRootPart.CFrame = k.HumanoidRootPart.CFrame * CFrame.new(0, 12, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                                                    end
                                                end
                                            end
                                        end
                                    end

                                end
                            else
                                EquipTool(getgenv().Settings.SelectWeaponType)
                            end
                        end
                    else
                        antifall = Instance.new("BodyVelocity", game.Players.LocalPlayer.Character.HumanoidRootPart)
                        antifall.Velocity = Vector3.new(0, 0, 0)
                        antifall.MaxForce = Vector3.new(100000, 100000, 100000)
                        antifall.P = 1250
                        antifall.Name = "antifall"
                    end
                end)
            end
            if not AutoFarmBoss.Value then
                pcall(function()
                    for i,v in pairs(game.Players.LocalPlayer.Character.HumanoidRootPart:GetChildren()) do
                        if v.Name == "antifall" or v:IsA("BodyVelocity") then
                            task.wait(.1)
                            v:Destroy()
                            antifall = nil
                            game.Players.LocalPlayer.Character.Humanoid.PlatformStand = false
                        end
                    end
                end)
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