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

-- loadstring(game:HttpGet("https://raw.githubusercontent.com/TheG450/BlobbyHub/main/IjulPieceTwo.Lua"))()
local Part = game:GetService("Workspace")["Zednov's Tycoon Kit"].Tycoons["East School Kyoto"].Essentials.Giver

if firetouchinterest then
    firetouchinterest(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart, Part, 0)
    firetouchinterest(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart, Part, 1)
else
    warn("Missing firetouchinterest")
end

