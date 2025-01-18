getgenv().AutoChest = true
getgenv().HopServer = true

local function queue_on_teleport()
    local queue_on_teleport = queue_on_teleport or syn.queue_on_teleport or fluxus.queue_on_teleport or function(...) return ... end

    game.Players.LocalPlayer.OnTeleport:Connect(function(state)
        if state ~= Enum.TeleportState.Started and state ~= Enum.TeleportState.InProgress then return end
        queue_on_teleport([[
            repeat task.wait() until game:IsLoaded()
            wait(2)
            --if getgenv().Executed then return end -- avoid multiple executions
            loadstring(game:HttpGet("https://raw.githubusercontent.com/TheG450/BlobbyHub/refs/heads/main/AutoChestFruitReborn.lua"))()
        ]])
    end)
end

local function HopServer()
    queue_on_teleport()

    local Player = game.Players.LocalPlayer    
    local Http = game:GetService("HttpService")
    local TPS = game:GetService("TeleportService")
    local Api = "https://games.roblox.com/v1/games/"

    local _place,_id = game.PlaceId, game.JobId
    -- Asc for lowest player count, Desc for highest player count
    local _servers = Api.._place.."/servers/Public?sortOrder=Asc&limit=10"
    function ListServers(cursor)
    local Raw = game:HttpGet(_servers .. ((cursor and "&cursor="..cursor) or ""))
    return Http:JSONDecode(Raw)
    end

    time_to_wait = 3 --seconds

    while wait(time_to_wait) do
    --freeze player before teleporting to prevent synapse crash?
    Player.Character.HumanoidRootPart.Anchored = true
    local Servers = ListServers()
    local Server = Servers.data[math.random(1,#Servers.data)]
    TPS:TeleportToPlaceInstance(_place, Server.id, Player)
    end
end

while getgenv().AutoChest do
    wait()
    for _,v in pairs(game:GetService("Workspace").Chest:GetChildren()) do
        if string.find(v.Name ,"Chest") and v:FindFirstChild("ProximityPrompt") and v:FindFirstChild("RootPart") then
            local character = game.Players.LocalPlayer.Character.HumanoidRootPart
            local ChestPart = v:FindFirstChild("RootPart") or v:WaitForChild("RootPart", 9e99)
            local ChestPrompt = v:FindFirstChild("ProximityPrompt") or v:WaitForChild("ProximityPrompt", 9e99)
            if ChestPart and ChestPart.Transparency >= 1 then
                if ChestPrompt and ChestPrompt.Enabled then
                    character.CFrame = ChestPart.CFrame
                    fireproximityprompt(ChestPrompt)
                end
            end
        else
            if getgenv().HopServer then
                HopServer()
            end
        end
    end
end