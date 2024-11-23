repeat wait() until game:IsLoaded() and game.Players and game.Players.LocalPlayer and game.Players.LocalPlayer.Character
getgenv().Settings = {
    Distance = nil,
    SelectWeapon = nil,
    SelectQuest = nil,
    AutoFarmQuest = nil
}


local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Blobby Hub" .. " | ".."[UPD] Fisch".." | ".."[Version 1.05.0]",
    TabWidth = 160,
    Size =  UDim2.fromOffset(580, 460), --UDim2.fromOffset(480, 360), --default size (580, 460)
    Acrylic = false, -- การเบลออาจตรวจจับได้ การตั้งค่านี้เป็น false จะปิดการเบลอทั้งหมด
    Theme = "Amethyst", --Amethyst
    MinimizeKey = Enum.KeyCode.P
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
    --[[SettingFarm]]---------------------------------------------------------------------------------------------------------------------
    local WeaponList = {}
    local function weaponListInsert()
        for i,v in pairs(game:GetService("Players").LocalPlayer.Backpack:GetDescendants())do
            if v:IsA("Tool") and v:FindFirstChild("Equip") then
                table.insert(WeaponList,v.Name)
            end
        end
        for i, v in pairs(game:GetService("Players").LocalPlayer.Character:GetDescendants()) do
            if v:IsA("Tool") and v:FindFirstChild("Equip") then
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
    local distanceSlider = Tabs.pageSetting:AddSlider("DistanceFarm", {
        Title = "Distance",
        Default = 6,
        Min = 0,
        Max = 10,
        Rounding = 0,
        Callback = function(Value)
            getgenv().Settings.Distance = Value
        end
    })
    local SelectWeapons = Tabs.pageSetting:AddDropdown("SelectWeapon", {
        Title = "Select Weapon",
        Values = WeaponList,
        Multi = false,
        Default = getgenv().Settings.SelectWeapon or "",
        Callback = function(Value)
            getgenv().Settings.SelectWeapon = Value
        end
    })
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

    distanceSlider:OnChanged(function(Value)
        getgenv().Settings.Distance = Value
    end)
    SelectWeapons:OnChanged(function(Value)
        getgenv().Settings.SelectWeapon = Value
    end)

    --[[Main]]---------------------------------------------------------------------------------------------------------------------
    local QuestList = {}
    local function QuestListInsert()
        for i,v in pairs(game:GetService("Workspace").NPC:GetChildren())do
            if v:IsA("Model") and v.Type.Value == "Quest" then
                table.insert(QuestList,v.Name)
            end
        end
    end
    QuestListInsert()
    local SelectQuest = Tabs.pageMain:AddDropdown("SelectQuest", {
        Title = "Select Quest",
        Values = QuestList,
        Multi = false,
        Default = getgenv().Settings.SelectQuest or "",
        Callback = function(Value)
            getgenv().Settings.SelectQuest = Value
        end
    })
    SelectQuest:OnChanged(function(Value)
        getgenv().Settings.SelectQuest = Value
    end)
    local AutoFarmQuest = Tabs.pageMain:AddToggle("AutoFarmQuest", {Title = "Auto Farm Quest", Default = getgenv().Settings.AutoFarmQuest or false })

    --[[SCRIPTS]]---------------------------------------------------------------------------------------------------------------------
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart", 5)
    local playerGui = player:FindFirstChild("PlayerGui")

    local function AcceptQuest()
        for i, v in pairs(playerGui:GetChildren()) do
            if v.Name == "Dialogue" and v:IsA("ScreenGui") then
                local frame = v:FindFirstChild("Frame")
                local list = frame:FindFirstChild("List")
                for _, button in pairs(list:GetChildren()) do
                    if button.Name == "Frame" and button:FindFirstChild("TextLabel") and button.TextLabel.Text == "Yes" then
                        local yesBtn = button:FindFirstChild("TextButton")
                        firesignal(yesBtn.MouseButton1Click)
                    end
                end
            end
        end
    end

    local function Attack()
        local VirtualUser = game:GetService("VirtualUser")
        VirtualUser:Button1Down(Vector2.new(9999, 9999))
        VirtualUser:Button1Up(Vector2.new(9999, 9999)) 
    end

    local function EquipWeapon(Tool)
        for i,v in pairs(player.Backpack:GetChildren()) do
            if v.Name == Tool and v:IsA("Tool") then
                character.Humanoid:EquipTool(v)
            end
        end
    end

    AutoFarmQuest:OnChanged(function()
        task.spawn(function()
            local TweenService  = game:GetService("TweenService")
            local noclipE = false
            local antifall = false
            
            local function noclip()
                for i, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                    if v:IsA("BasePart") and v.CanCollide == true then
                        v.CanCollide = false
                        game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                    end
                end
            end
            
            local function moveto(obj)
                local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - obj.Position).Magnitude
                local speed = 0
                if distance > 1000 then
                    speed = 500
                elseif distance > 400 and distance <=1000 then
                    speed = 600
                elseif distance <= 400 then
                    speed = 99999
                end
                local info = TweenInfo.new(distance/speed,Enum.EasingStyle.Linear)
                local tween = TweenService:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, info, {CFrame = obj})
            
                if not game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyVelocity") then
                    antifall = Instance.new("BodyVelocity", game.Players.LocalPlayer.Character.HumanoidRootPart)
                    antifall.Velocity = Vector3.new(0,0,0)
                    noclipE = game:GetService("RunService").Stepped:Connect(noclip)
                    tween:Play()
                end
                    
                tween.Completed:Connect(function()
                    Attack()
                    antifall:Destroy()
                    noclipE:Disconnect()
                end)
            end

            player.CharacterAdded:Connect(function(newCharacter)
                character = newCharacter
                HumanoidRootPart = newCharacter:WaitForChild("HumanoidRootPart")
            end)
        
            while AutoFarmQuest.Value do
                task.wait()
        
                local hasActiveQuest = false
                local Quest = nil
        
                pcall(function()
                    for _, Active in pairs(playerGui.QuestUi.List.List:GetChildren()) do
                        if Active:FindFirstChildOfClass("Frame") then
                            hasActiveQuest = true
                            Quest = tostring(Active.Name)
                            break
                        end
                    end
                end)
        
                if not hasActiveQuest then
                    for _, npc in pairs(game:GetService("Workspace").NPC:GetChildren()) do
                        if npc.Name == getgenv().Settings.SelectQuest and npc:FindFirstChild("Type") and npc.Type.Value == "Quest" then
                            local success, err = pcall(function()
                                --HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
                                moveto(npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3))
                                task.wait(0.1)
                                fireproximityprompt(npc.HumanoidRootPart.ProximityPrompt)
                                task.wait(0.1)
                                AcceptQuest()
                            end)
                            if not success then
                                warn("Error while accepting quest: " .. err)
                            else
                                task.wait(0.5)
                            end
                        end
                    end
                else
                    local Target = nil
                    for _, mob in pairs(game:GetService("Workspace").Lives:GetChildren()) do
                        if string.find(mob.Name, Quest) and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                            Target = mob
                            break
                        end
                    end
        
                    if Target then
                        local success, err = pcall(function()
                            if character and character.Humanoid.Health > 0 then
                                EquipWeapon(getgenv().Settings.SelectWeapon)
                                --HumanoidRootPart.CFrame = Target.HumanoidRootPart.CFrame * CFrame.new(0, 0, getgenv().Settings.Distance)
                                moveto(Target.HumanoidRootPart.CFrame * CFrame.new(0, 0, getgenv().Settings.Distance))
                            end
                        end)
                        if not success then
                            warn("Error while attacking: " .. err)
                        end
                    end
                end
            end
        end)          
    end)
end

Window:SelectTab(1)