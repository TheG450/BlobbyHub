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
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/TheBlobby999/BlobbyHub/main/JujutsuTycoon.lua"))()
local Part = game:GetService("Workspace")["Zednov's Tycoon Kit"].Tycoons["East School Kyoto"].Essentials.Giver

if firetouchinterest then
    firetouchinterest(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart, Part, 0)
    firetouchinterest(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart, Part, 1)
else
    warn("Missing firetouchinterest")
end
-------------------------------------------------------------------------------------------------------------------namecall
local namecall
namecall = hookmetamethod(game, '__namecall', function(self, ...)
    local args = {...}
    local method = getnamecallmethod()

    if not checkcaller() and method == 'FireServer' and self.Name == 'Skills' then
        if args[1] == "Combat" then
            args[2] = "M1"
        end
        task.wait(9e9)

        return namecall(self, unpack(args))
    end

    return namecall(self, ...)
end)

-------------------------------------------------------------------------------------------------------------------Old
-- Requiring the client item module which returns a table that contains the input function which is what we're going to be hooking onto
    local clientItemModule = require(game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem)

    -- Accessing the input function
    local inputFunc = clientItemModule.Input
    
    -- Hooking onto the input function and replacing it with our own function that contains a varag
    -- A varag is a variable argument its used to represent an infinite amount of arguments
    local old; old = hookfunction(inputFunc, function(...)
        -- Packing the varag into a table so we're able to index it
        local args = {...}
    
        -- Checking if the first arg of the input function is a table
        if type(args[1]) == "table" then
           
            -- Accessing the info table which contains gun properties, such as its recoil, spread, bullet speed and shot cooldown
            args[1].Info.ShootRecoil = 0
            args[1].Info.ShootSpread = 0
            args[1].Info.ProjectileSpeed = 99999999
            args[1].Info.ShootCooldown = 0
            args[1].Info.QuickShotCooldown = 0
        end
    
        -- Returning the original input function so we don't overwrite it which can cause the game to crash
        return old(...)
    end)


game:GetService("ReplicatedStorage").Assets.Remotes.Skills:FireServer("Skill",{["CharPos"] = game.Players.LocalPlayer.Character.HumanoidRootPart.Position,
["MouseHit"] = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame,
["MouseTarget"] = game.Workspace["Zednov's Tycoon Kit"].Tycoons["East School Kawasaki"],
["InputType"] = "Start"})
