_G.A = true    -- สถานะเปิด/ปิดการทำงาน

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local hrp = Players.LocalPlayer.Character.HumanoidRootPart

-- ฟังก์ชันสำหรับการโจมตี NPC
task.spawn(function()
    while _G.A do
        task.wait(.05)
        pcall(function()
            if Players.LocalPlayer.Data.MeleeP.Value < 3100 then
                for i, v in pairs(game:GetService("Workspace").NPC.Halloween:GetChildren()) do
                    if v.Name == "Zombie Lv.300" and v.Humanoid.Health > 0 then
                        hrp.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 0, 10)
                        local ohInstance1 = Players.LocalPlayer
                        ReplicatedStorage.events.Skills.Melee.Combat:FireServer(ohInstance1)
                        wait(.5)
                    end
                end
            else
                for i, v in pairs(game:GetService("Workspace")["Tar And TrueKatana Update"]["Npc Mob"].Zone3:GetChildren()) do
                    if v.Name == "Tranquility Awakeing Villagers [Level 12200]" and v.Humanoid.Health > 0 then
                        hrp.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 0, 10)
                        local ohInstance1 = Players.LocalPlayer
                        ReplicatedStorage.events.Skills.Melee.Combat:FireServer(ohInstance1)
                    end
                end
            end
        end)
    end
end)

-- การจัดการส่วนประกอบของ HumanoidRootPart
local List = {
    "Climimbing",
    "Died",
    "GettingUp",
    "Swimming",
    "Jumping",
    "Landing",
    "Splash",
    "FreeFalling",
    "Running",
    "RootAttachment",
    "RootJoint"
}

local connection1
connection1 = RunService.Heartbeat:Connect(function()
    if not _G.A then
        connection1:Disconnect() -- หยุดเมื่อ _G.A เป็น false
        return
    end

    for i, v in pairs(hrp:GetChildren()) do
        if not table.find(List, v.Name) then
            v:Destroy()
        end
    end
end)

-- การเพิ่มแต้มใน MeleeP เมื่อค่าต่ำกว่า 12500
local connection2
connection2 = RunService.Heartbeat:Connect(function()
    if not _G.A then
        connection2:Disconnect() -- หยุดเมื่อ _G.A เป็น false
        return
    end

    if Players.LocalPlayer.Data.MeleeP.Value < 12500 then
        ReplicatedStorage.StatSystem.Points:FireServer("Melee")
    end
end)
