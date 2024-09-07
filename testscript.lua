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


while wait(0.1) do
    game:GetService("ReplicatedStorage").Events.Punch:FireServer(game:GetService("Players").LocalPlayer.LevelFolder.comboPunch)
end

local Codes = {
    "Fixed999",
    "UPDATE4.5",
    "Patched",
    "Family",
    "Optimized",
    "500KVISITS",
    "diegointhedark",
    "Sub2ink",
    "400KVISITS",
    "sleep",
    "lknkvgzc",
    "ktydrfhjklkhfhg",
    "1KPlaying",
    "Mupeng2",
    "50KVISITS",
    "UPDATE4",
    "25KVISITS",
    "HaoHaki",
    "Heian",
    "Sub2Arthur",
    "Sub2Sai",
    "Sub2FazzM",
    "Sub2YahikoDoidao"
}

for _, code in ipairs(Codes) do
    if code ~= "" then
        game:GetService("ReplicatedStorage").Events.RedeemCodes:FireServer(code)
        wait(0.5)
    end
end


