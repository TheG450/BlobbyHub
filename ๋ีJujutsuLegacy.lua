-- [[ Services ]] --
local Players = game:GetService("Players")

-- [[ Variables ]] --
local Plr = Players.LocalPlayer
local Char = Plr.Character or Plr.CharacterAdded:Wait()
local Humanoid = Char:WaitForChild("Humanoid")
local HRP = Char:WaitForChild("HumanoidRootPart")

-- [[ Special Variables ]] --
getgenv().farmtoggle = nil
getgenv().selectednpc = nil
getgenv().selectedenemy = nil
getgenv().skilltoggle = nil
getgenv().skillkeybind = nil
getgenv().leveltoggle = nil

-- [[ Tables ]] --
local NPCList = {}
for i, v in pairs(workspace.Npc:GetChildren()) do
    table.insert(NPCList, v.Name)
end

local enemyList = {}
for i, v in pairs(workspace.Enemies:GetChildren()) do
    table.insert(enemyList, v.Name)
end

-- [[ Functions ]] --
function convertPercentageToDecimal(inputString)
    local percentageString = string.match(inputString, "(%d*%.?%d+)%%")
    local percentageNumber = tonumber(percentageString)
    local decimal = percentageNumber / 100
    return decimal
end

function extractName(inputString)
    local namePart = string.match(inputString, "(.-)%s%d*%.?%d+%%")
    return namePart
end

-- [[ GUI ]] --
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local MainWindow = Rayfield:CreateWindow({
    Name = "JJL GUI",
    LoadingTitle = "Jujutsu Legacy GUI",
    LoadingSubtitle = "by Kirbles",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil, 
        FileName = "AssertEquals"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink", 
        RememberJoins = true 
    },
    KeySystem = false, 
    KeySettings = {
        Title = "Untitled",
        Subtitle = "Key System",
        Note = "No method of obtaining the key is provided",
        FileName = "Key",
        SaveKey = true, 
        GrabKeyFromSite = false, 
        Key = {"Hello"} 
    }
})

local FarmTab = MainWindow:CreateTab("Farm", 4483362458) -- Title, Image
FarmTab:CreateSection("Mobs")

FarmTab:CreateDropdown({
    Name = "Teleport to NPC",
    Options = NPCList,
    CurrentOption = {"None"},
    MultipleOptions = false,
    Flag = "Dropdown1", 
    Callback = function(Option)
        getgenv().selectednpc = Option[1]
        if workspace.Npc:FindFirstChild(Option[1]):FindFirstChild("HumanoidRootPart") then
            HRP.CFrame = workspace.Npc:FindFirstChild(Option[1]).HumanoidRootPart.CFrame
        elseif not workspace.Npc:FindFirstChild(Option[1]):FindFirstChild("HumanoidRootPart") then
            HRP.Position = workspace.Npc:FindFirstChild(Option[1]).WorldPivot.Position
        end
    end,
})

FarmTab:CreateDropdown({
    Name = "Enemies",
    Options = enemyList,
    CurrentOption = {"None"},
    MultipleOptions = false,
    Flag = "Dropdown1", 
    Callback = function(Option)
        getgenv().selectedenemy = Option[1]
    end,
})

FarmTab:CreateToggle({
    Name = "Loop TP",
    CurrentValue = false,
    Flag = "Toggle1", 
    Callback = function(Value)
        if Value then
            getgenv().farmtoggle = true
        else
            getgenv().farmtoggle = false
        end
        while getgenv().farmtoggle do
            task.wait()
            if getgenv().selectedenemy then
                local enemy = workspace.Enemies:FindFirstChild(getgenv().selectedenemy)
                if enemy then
                    local hrp = enemy:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local underPosition = hrp.CFrame * CFrame.new(0, -10, 0)
                        HRP.CFrame = underPosition
                    else
                        local anyPart = enemy:FindFirstChildWhichIsA("BasePart")
                        if anyPart then
                            local behindPosition = anyPart.CFrame * CFrame.new(0, 0, 10)
                            HRP.CFrame = behindPosition
                        end
                    end
                end
            end
        end
    end,
})

FarmTab:CreateSection("Other")

FarmTab:CreateToggle({
    Name = "Auto Skill",
    CurrentValue = false,
    Flag = "Toggle1", 
    Callback = function(Value)
        if Value then
            getgenv().skilltoggle = true
        else
            getgenv().skilltoggle = false
        end
        while getgenv().skilltoggle do
            task.wait()
            if getgenv().skillkeybind == "Z" then
                game:GetService("ReplicatedStorage"):WaitForChild("CharacterEvents"):WaitForChild(game.Players.LocalPlayer.Technique.Value):WaitForChild("ZMove"):FireServer()
            elseif getgenv().skillkeybind == "X" then
                game:GetService("ReplicatedStorage"):WaitForChild("CharacterEvents"):WaitForChild(game.Players.LocalPlayer.Technique.Value):WaitForChild("XMove"):FireServer()
            elseif getgenv().skillkeybind == "C" then
                game:GetService("ReplicatedStorage"):WaitForChild("CharacterEvents"):WaitForChild(game.Players.LocalPlayer.Technique.Value):WaitForChild("CMove"):FireServer()
            elseif getgenv().skillkeybind == "V" then
                game:GetService("ReplicatedStorage"):WaitForChild("CharacterEvents"):WaitForChild(game.Players.LocalPlayer.Technique.Value):WaitForChild("VMove"):FireServer()
            end
        end
    end,
})

FarmTab:CreateDropdown({
    Name = "Select Skill",
    Options = {"Z", "X", "C", "V"},
    CurrentOption = {"None"},
    MultipleOptions = false,
    Flag = "Dropdown1", 
    Callback = function(Option)
        if Option[1] == "Z" then
            getgenv().skillkeybind = Option[1]
        elseif Option[1] == "X" then
            getgenv().skillkeybind = Option[1]
        elseif Option[1] == "C" then
            getgenv().skillkeybind = Option[1]
        elseif Option[1] == "V" then
            getgenv().skillkeybind = Option[1]
        end
    end,
})

FarmTab:CreateToggle({
    Name = "Spoof Level (Used to bypass level requirements on Quests)",
    CurrentValue = false,
    Flag = "Toggle1", 
    Callback = function(Value)
        if Value then
            getgenv().leveltoggle = true
        else
            getgenv().leveltoggle = false
        end
        while getgenv().leveltoggle do
            task.wait()
            game:GetService("Players").LocalPlayer.Stats.Level.Value = 2500
        end
    end,
})

local MiscTab = MainWindow:CreateTab("Misc.", 4483362458)
MiscTab:CreateSection("Spins (You need AT LEAST 1 spin in the specified category to use the following)")

MiscTab:CreateDropdown({
    Name = "Technique",
    Options = {"Binding Vow 25%", "Heavenly Restriction 15%", "Blood Manipulation 15%", "Disaster Flames 10%", "Divergent Fist 10%", "Missal Fists 10%", "Boogie Woogie 5%", "Cursed Speech 5%", "Star Rage 5%", "Disaster Tides 5%", "Rika 1%", "Jackpot 1%", "Infinity 1%", "Deadly Sentencing 1%", "Anti Gravity 1%", "Idle Transfiguration 1%", "Ten Shadows 0.05%", "Curse Manipulation 0.05%"},
    CurrentOption = {"None"},
    MultipleOptions = false,
    Flag = "Dropdown1", 
    Callback = function(Option)
        game:GetService("ReplicatedStorage"):WaitForChild("SetTechnique"):FireServer(game.Players.LocalPlayer.Technique.Value, extractName(Option[1]), 1, convertPercentageToDecimal(Option[1]))
        game:GetService("Players").LocalPlayer.Character.Humanoid.Health = 0
    end,
})

MiscTab:CreateDropdown({
    Name = "Race",
    Options = {"Human 65%", "Death Painting 15%" ,"Cursed Spirit 10%", "Angel 1%", "Fallen Angel 0.1%"},
    CurrentOption = {"None"},
    MultipleOptions = false,
    Flag = "Dropdown1", 
    Callback = function(Option)
        game:GetService("ReplicatedStorage"):WaitForChild("SetRace"):FireServer(game.Players.LocalPlayer.RaceStat.RaceUSE.Value, extractName(Option[1]), 1, convertPercentageToDecimal(Option[1]))
    end,
})

MiscTab:CreateDropdown({
    Name = "Clan",
    Options = {"Itadori 35%", "All 35%", "Nanami 10%", "Geto 5%", "Kamo 5%", "Okkotsu 1%", "Fushiguro 1%", "Gojo 1%", "Zenin 1%", "Rejected Zenin 0.5%", "Ryomen 0.1%"},
    CurrentOption = {"None"},
    MultipleOptions = false,
    Flag = "Dropdown1", 
    Callback = function(Option)
        if Option[1] == "None" then return end
        game:GetService("ReplicatedStorage"):WaitForChild("SetClan"):FireServer(game.Players.LocalPlayer.RaceStat.RaceUSE.Value, extractName(Option[1]), 1, convertPercentageToDecimal(Option[1]))
    end,
})
-- Made by: Kirbles