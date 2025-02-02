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


local function velocityTeleport(destination)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")

    local bodyVelocity = Instance.new("BodyVelocity", hrp)
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9) -- ทำให้เคลื่อนที่ได้ทุกทิศทาง
    bodyVelocity.Velocity = (destination.Position - hrp.Position).unit * 50

    wait((destination.Position - hrp.Position).Magnitude / 50) -- คำนวณเวลาที่ควรใช้เดินทาง
    bodyVelocity:Destroy()
end

-- ทดสอบเคลื่อนที่แบบ Velocity
velocityTeleport(CFrame.new(500, 10, 500))
