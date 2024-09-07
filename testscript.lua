local workspace = game:GetService("Workspace")
local player = game.Players.LocalPlayer
local character = player.Character

for _, v in pairs(workspace.Npcs["DarkPiratesBoss"]:GetDescendants()) do
    if v:IsA("Humanoid") then
        if v.Health > 0 then
            for _, Target in pairs(workspace.Npcs["DarkPiratesBoss"]:GetChildren()) do
                if Target.Name == "HumanoidRootPart" then
                    character.HumanoidRootPart.CFrame = Target.CFrame
                end
            end
        end
        if v.Health < v.MaxHealth then
            v.Health = -899999999
        end
    end
end

local VirtualUserService = game:GetService("VirtualUser")
while wait(0.1) do
    VirtualUserService:CaptureController()
    VirtualUserService:ClickButton1(Vector2.new(0, 0))
end

-- loadstring(game:HttpGet("https://raw.githubusercontent.com/TheG450/BlobbyHub/main/JujutsuTycoon.lua"))()
local Part = game:GetService("Workspace")["Zednov's Tycoon Kit"].Tycoons["East School Kyoto"].Essentials.Giver

if firetouchinterest then
    firetouchinterest(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart, Part, 0)
    firetouchinterest(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart, Part, 1)
else
    warn("Missing firetouchinterest")
end


AutoCollect:OnChanged(function()
    task.spawn(function()
        while wait() do
            if AutoCollect.Value and game:GetService("Players").LocalPlayer.Character.Humanoid.Health > 0 then
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
            pcall(function()
                if AutoTycoon.Value and game:GetService("Players").LocalPlayer.Character.Humanoid.Health > 0 then
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
            end)
        end
    end)
end)
AutoRebirth:OnChanged(function()
    task.spawn(function()
        while wait(1) do
            if AutoRebirth.Value then
                game:GetService("ReplicatedStorage").Assets.Remotes.Rebirth:InvokeServer()
            end
        end
    end)
end)
AutoDropLoot:OnChanged(function()
    task.spawn(function()
        while wait() do
            pcall(function()
                if AutoDropLoot.Value and game:GetService("Players").LocalPlayer.Character.Humanoid.Health > 0 then
                    for i,v in pairs(game:GetService("Workspace"):GetChildren()) do
                        if string.find(v.Name, "Loot") and v:IsA("BasePart") and v:FindFirstChild("ProximityPrompt") then
                            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
                            fireproximityprompt(v.ProximityPrompt)
                        end
                    end
                end
            end)
        end
    end)
end)

AutoFarmMob:OnChanged(function()
    task.spawn(function()
        while wait() do
            pcall(function()
                if AutoFarmMob.Value and game:GetService("Players").LocalPlayer.Character.Humanoid.Health > 0 then
                    for i,v in pairs(game:GetService("Workspace").LivingBeings.NPCS:GetChildren()) do
                        if v.Name == _G.Settings.Main.SelectMob and v:IsA("Model") and v.Humanoid.Health > 0 then
                            for _, tool in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
                                if tool.Name == _G.Settings.SettingsFarm.SelectWeapon and tool:IsA("Tool") then
                                    game:GetService("Players").LocalPlayer.Character.Humanoid:EquipTool(tool)
                                end
                            end
                            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 0, _G.Settings.SettingsFarm.Distance)
                            game:GetService("ReplicatedStorage").Assets.Remotes.Skills:FireServer("Combat","M1")
                        end
                    end
                end
            end)
        end
    end)
end)
AutoFarmBoss:OnChanged(function()
    task.spawn(function()
        while wait() do
            pcall(function()
                if AutoFarmBoss.Value and game:GetService("Players").LocalPlayer.Character.Humanoid.Health > 0 then
                    for i, v in pairs(game:GetService("Workspace").LivingBeings.NPCS:GetChildren()) do
                        if table.find(_G.Settings.Main.SelectBoss, v.Name) and v:IsA("Model") and v.Humanoid.Health > 0 then
                            for _, tool in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
                                if tool.Name == _G.Settings.SettingsFarm.SelectWeapon and tool:IsA("Tool") then
                                    game:GetService("Players").LocalPlayer.Character.Humanoid:EquipTool(tool)
                                end
                            end
                            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 0, _G.Settings.SettingsFarm.Distance)
                            game:GetService("ReplicatedStorage").Assets.Remotes.Skills:FireServer("Combat","M1")
                        end
                    end
                end
            end)
        end
    end)
end)
