local function TP(Target)
    local antifall;
    local TweenService = game:GetService("TweenService")
    local Distance = (Target.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    local Speed = 150

    local Tween = TweenService:Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(Distance/Speed, Enum.EasingStyle.Linear), {CFrame = Target})
    if game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("antifall") and game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChildOfClass("BodyVelocity") then
        Tween:Play()
        Tween.Completed:Connect(function()
        wait(.1)
            for i,v in pairs(game.Players.LocalPlayer.Character.HumanoidRootPart:GetChildren()) do
                if v.Name == "antifall" then
                    v:Destroy()
                    --game.Players.LocalPlayer.Character.Humanoid.PlatformStand = false
                end
            end
        end)
    else
        --game.Players.LocalPlayer.Character.Humanoid.PlatformStand = true
        antifall = Instance.new("BodyVelocity", game.Players.LocalPlayer.Character.HumanoidRootPart)
        antifall.Velocity = Vector3.new(0, 0, 0)
        antifall.MaxForce = Vector3.new(100000, 100000, 100000)
        antifall.P = 1250
        antifall.Name = "antifall"
    end
end