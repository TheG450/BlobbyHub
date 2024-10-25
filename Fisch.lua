repeat wait() until game:IsLoaded() and game.Players and game.Players.LocalPlayer and game.Players.LocalPlayer.Character
getgenv().Settings = {
    Rod = nil,
    RealFinish = nil,
}

game:GetService("ReplicatedStorage").events.finishedloading:FireServer()
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "BLOBBY HUB " .. "Fisch",
    TabWidth = 160,
    Size = UDim2.fromOffset(480, 360), --default size (580, 460)
    Acrylic = false, -- การเบลออาจตรวจจับได้ การตั้งค่านี้เป็น false จะปิดการเบลอทั้งหมด
    Theme = "Amethyst", --Amethyst
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    --[[ Tabs --]]
    pageSetting = Window:AddTab({ Title = "Settings", Icon = "settings" }),
    pageMain = Window:AddTab({ Title = "Main", Icon = "home" }),
    pageShop = Window:AddTab({ Title = "Shop", Icon = "shopping-cart" }),
    pageTeleport = Window:AddTab({ Title = "Teleport", Icon = "map" })
}

do
    --[[ MAIN ]]
    local RodList = {}
    local function GetRodList()
        for i,v in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
            if string.find(v.Name, "Rod") then
                table.insert(RodList, v.Name)
            end
        end
        for i,v in pairs(game:GetService("Players").LocalPlayer.Character:GetChildren()) do
            if string.find(v.Name, "Rod") and v.Name ~= "RodBodyModel" then
                table.insert(RodList, v.Name)
            end
        end
        table.insert(RodList, "Equipment Bag")
        table.insert(RodList, "Bestiary")
    end
    local function RodListRemove()
        if RodList ~= nil then
            for i = #RodList, 1, -1 do
                table.remove(RodList, i)
            end
        end
    end
    GetRodList()
    local SelectRod = Tabs.pageSetting:AddDropdown("SelectRod", {
        Title = "Select Rod",
        Values = RodList,
        Multi = false,
        Default = getgenv().Settings.Rod or RodList[1],
        Callback = function(Value)
            getgenv().Settings.Rod = Value
        end
    })
    local RefreshRod = Tabs.pageSetting:AddButton({
        Title = "Refresh Weapon",
        Callback = function()
            local currentSelection = SelectRod.Value
            
            RodListRemove()
            GetRodList()
            SelectRod:SetValues(RodList)
            
            if table.find(RodList, currentSelection) then
                SelectRod:SetValue(currentSelection)
            else
                SelectRod:SetValue(RodList[#RodList])
            end
        end
    })
    SelectRod:OnChanged(function(Value)
        getgenv().Settings.Rod = Value
    end)
    local InstantReel = Tabs.pageSetting:AddToggle("InstantReel", {Title = "Instant ReelFinish", Default = false })
    InstantReel:OnChanged(function(value)
        getgenv().Settings.RealFinish = value
    end)

    local AutoFishing = Tabs.pageMain:AddToggle("AutoFishing", {Title = "Auto Fishing", Default = false })


    --[[ SCRIPTS ]]
    AutoFishing:OnChanged(function()
        task.spawn(function()
            local over = game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("over")
            local plr = game:GetService("Players").LocalPlayer
            local character = plr.Character
            local humanoid = character:FindFirstChild("Humanoid")

            local casting = false
            over.ChildAdded:Connect(function()
                casting = false
            end)
            while AutoFishing.Value do
                wait(.1)
                character.HumanoidRootPart.Anchored = true
                if #over:GetChildren() > 2 then
                    return
                else
                    if not character:FindFirstChild(getgenv().Settings.Rod) then
                        for i,v in pairs(plr.Backpack:GetChildren()) do
                            if v.Name == getgenv().Settings.Rod and v:IsA("Tool") then
                                humanoid:EquipTool(v)
                            end
                        end
                    elseif character[getgenv().Settings.Rod].values.casted.Value == false and casting == false then
                        wait(1)
                        local ohNumber1 = 100
                        character[getgenv().Settings.Rod].events.cast:FireServer(ohNumber1)
                        casting = true
                        wait(1)
                    elseif character[getgenv().Settings.Rod].values.casted.Value == true and character[getgenv().Settings.Rod].values.bite.Value == false and character[getgenv().Settings.Rod]:FindFirstChild("bobber") and character[getgenv().Settings.Rod].values.bobberzone.Value ~= "" then
                        pcall(function()
                            if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("shakeui") then
                                game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("shakeui").Enabled = false
                                local button = game:GetService("Players").LocalPlayer.PlayerGui.shakeui.safezone.button
                                for i, v in pairs(getconnections(button.MouseButton1Click)) do
                                    v:Fire()
                                end
                            end
                        end)
                        wait(.5)
                    elseif character[getgenv().Settings.Rod].values.bite.Value == true and character[getgenv().Settings.Rod].values.casted.Value == true and character[getgenv().Settings.Rod]:FindFirstChild("bobber") and character[getgenv().Settings.Rod].values.bobberzone.Value ~= "" then
                        if getgenv().Settings.RealFinish == true then
                            wait(1)
                            game:GetService("ReplicatedStorage").events.reelfinished:FireServer(100, false)
                        else
                            if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("reel") then
                                game:GetService("Players").LocalPlayer.PlayerGui.reel.bar.playerbar.Size = UDim2.new(1, 0, 1, 0)
                            end
                        end
                        wait(1)
                    end
                end
            end
            character.HumanoidRootPart.Anchored = false
        end)
    end)
end

Window:SelectTab(1)

Fluent:Notify({
    Title = "BLOBBY HUB",
    Content = "The script has been loaded.",
    Duration = 8
})

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