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
