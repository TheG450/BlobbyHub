--[[
local function Move(Body, Target)
	path:ComputeAsync(Body.Position, Target.Position)
	if path.Status == Enum.PathStatus.Success then
		local wayPoints = path:GetWaypoints()
		for i = 1, #wayPoints do
			local point = wayPoints[i]
			humanoid:MoveTo(point.Position)
			local success = humanoid.MoveToFinished:Wait()
			if point.Action == Enum.PathWaypointAction.Jump then
				humanoid.WalkSpeed = 0
				wait(0.2)
				humanoid.WalkSpeed = 30
			end
			if not success then
				human.Jump = true
				human:MoveTo(point.Position)
				if not human.MoveToFinished:Wait() then
					break
				end
			end
		end
	end
end
]]
repeat wait() until game:IsLoaded() and game.Players and game.Players.LocalPlayer and game.Players.LocalPlayer.Character
getgenv().Settings = {
    InfStamina = nil,
    InfFlow = nil,
    InfPower = nil,
    Speedultiplier = nil,
    Flowultiplier = nil,
    Powerultiplier = nil,
    JumpMultiplier = nil,
    SpeedMultiple = nil,
    FlowMultiple = nil,
    PowerMultiple = nil,
    JumpMultiple = nil,
    LockAtBall = nil,
    SlideTackle = nil,
    ShowStaminaFlow = nil,
    Hitbox = nil,
    HitboxSize = nil,
}

local function CreateMobileUI()
    local blobbyGui = Instance.new("ScreenGui")
    blobbyGui.Name = "BlobbyGui"
    blobbyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    blobbyGui.Parent = game.Players.LocalPlayer.PlayerGui

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    mainFrame.BackgroundTransparency = 1
    mainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    mainFrame.BorderSizePixel = 0
    mainFrame.Position = UDim2.fromScale(0.0611, 0.255)
    mainFrame.Size = UDim2.fromScale(0.0547, 0.109)

    local oCButton = Instance.new("ImageButton")
    oCButton.Name = "OCButton"
    oCButton.Image = "rbxassetid://125742484700391"
    oCButton.AnchorPoint = Vector2.new(0.5, 0.5)
    oCButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    oCButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
    oCButton.BorderSizePixel = 0
    oCButton.Position = UDim2.fromScale(0.513, 0.487)
    oCButton.Size = UDim2.fromScale(1, 1)

    local uICorner = Instance.new("UICorner")
    uICorner.Name = "UICorner"
    uICorner.CornerRadius = UDim.new(1, 0)
    uICorner.Parent = oCButton

    local uIStroke = Instance.new("UIStroke")
    uIStroke.Name = "UIStroke"
    uIStroke.Thickness = 2
    uIStroke.Parent = oCButton

    oCButton.Parent = mainFrame

    local uIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
    uIAspectRatioConstraint.Name = "UIAspectRatioConstraint"
    uIAspectRatioConstraint.Parent = mainFrame

    mainFrame.Parent = blobbyGui

    return oCButton
end

local Device;
local oCButton

local Players = game:GetService("Players")
local function checkDevice()
    local player = Players.LocalPlayer
    if player then
        local UserInputService = game:GetService("UserInputService")
        
        if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
            oCButton = CreateMobileUI()
            Device = UDim2.fromOffset(480, 360)
        else
            Device = UDim2.fromOffset(580, 460)
        end
    end
end

checkDevice()
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Blobby Hub" .. " | ".."[UPDATE 2] Skillful",
    TabWidth = 160,
    Size =  Device, --UDim2.fromOffset(480, 360), --default size (580, 460)
    Acrylic = false, -- การเบลออาจตรวจจับได้ การตั้งค่านี้เป็น false จะปิดการเบลอทั้งหมด
    Theme = "Amethyst", --Amethyst
    MinimizeKey = Enum.KeyCode.P
})

if oCButton then
    oCButton.MouseButton1Click:Connect(function()
        local fluentUi = game:GetService("CoreGui"):FindFirstChild("ScreenGui") or game:GetService("CoreGui"):WaitForChild("ScreenGui", 5)
        for i,v in pairs(fluentUi:GetChildren()) do
            if v.Name == "Frame" and v:FindFirstChild("CanvasGroup") then
                local EN = not v.Visible
                v.Visible = EN
                getgenv().Settings.HideGui = EN
                SaveSetting()
            end
        end
    end)
end

local Tabs = {
    --[[ Tabs --]]
    pageMain = Window:AddTab({ Title = "Main", Icon = "home" }),
    pageExtra = Window:AddTab({ Title = "Extra", Icon = "bar-chart" }),
    pageVirtual = Window:AddTab({ Title = "Virtual", Icon = "component" }),
}

do
    --[[ MAINS ]]--------------------------------------------------------
    local PlayerHooks = Tabs.pageMain:AddSection("Player Hooks")
    local InfStamina = Tabs.pageMain:AddToggle("InfStamina", {Title = "Infinity Stamina", Default = getgenv().Settings.InfStamina or false })
    local InfFlow = Tabs.pageMain:AddToggle("InfFlow", {Title = "Infinity Flow", Default = getgenv().Settings.InfFlow or false })
    local InfPower = Tabs.pageMain:AddToggle("InfPower", {Title = "Infinity Power", Default = getgenv().Settings.InfPower or false })
    local StatsMultiple = Tabs.pageMain:AddSection("Stats Multiplier")
    local SpeedMultiple = Tabs.pageMain:AddSlider("SpeedMultiple", {
        Title = "Speed Multiple",
        Default = 0,
        Min = 0,
        Max = 100,
        Rounding = 0,
        Callback = function(Value)
            getgenv().Settings.SpeedMultiple = Value
        end
    })
    SpeedMultiple:OnChanged(function(Value)
        getgenv().Settings.SpeedMultiple = Value
    end)
    local SpeedMultiplier = Tabs.pageMain:AddToggle("SpeedMultiplier", {Title = "Speed Multiplier", Default = getgenv().Settings.SpeedMultiplier or false })
    local FlowMultiple = Tabs.pageMain:AddSlider("FlowMultiple", {
        Title = "Flow Multiple",
        Default = 0,
        Min = 0,
        Max = 100,
        Rounding = 0,
        Callback = function(Value)
            getgenv().Settings.FlowMultiple = Value
        end
    })
    FlowMultiple:OnChanged(function(Value)
        getgenv().Settings.FlowMultiple = Value
    end)
    local FlowMultiplier = Tabs.pageMain:AddToggle("FlowMultiplier", {Title = "Flow Multiplier", Default = getgenv().Settings.FlowMMultiplier or false })
    local PowerMultiple = Tabs.pageMain:AddSlider("PowerMultiple", {
        Title = "Power Multiple",
        Default = 0,
        Min = 0,
        Max = 100,
        Rounding = 0,
        Callback = function(Value)
            getgenv().Settings.PowerMultiple = Value
        end
    })
    PowerMultiple:OnChanged(function(Value)
        getgenv().Settings.PowerMultiple = Value
    end)
    local PowerMultiplier = Tabs.pageMain:AddToggle("PowerMultiplier", {Title = "Power Multiplier", Default = getgenv().Settings.PowerMultiplier or false })
    local JumpMultiple = Tabs.pageMain:AddSlider("JumpMultiple", {
        Title = "Jump Multiple",
        Default = 0,
        Min = 0,
        Max = 100,
        Rounding = 0,
        Callback = function(Value)
            getgenv().Settings.JumpMultiple = Value
        end
    })
    JumpMultiple:OnChanged(function(Value)
        getgenv().Settings.JumpMultiple = Value
    end)
    local JumpMultiplier = Tabs.pageMain:AddToggle("JumpMultiplier", {Title = "Jump Multiplier", Default = getgenv().Settings.JumpMultiplier or false })

    --[[ VIRTUAL ]]--------------------------------------------------------
    local ShowStaminaFlow = Tabs.pageVirtual:AddToggle("ShowStaminaFlow", {Title = "Show Stamina, Flow", Default = getgenv().Settings.ShowStaminaFlow or false })
    local HitboxExpander = Tabs.pageVirtual:AddSection("HitboxExpander")
    local HitboxSize = Tabs.pageVirtual:AddSlider("HitboxSize", {
        Title = "Hitbox Size",
        Default = 20,
        Min = 0,
        Max = 100,
        Rounding = 0,
        Callback = function(Value)
            getgenv().Settings.HitboxSize = Value
        end
    })
    HitboxSize:OnChanged(function(Value)
        getgenv().Settings.HitboxSize = Value
    end)
    local Hitbox = Tabs.pageVirtual:AddToggle("Hitbox", {Title = "Hitbox", Default = getgenv().Settings.Hitbox or false })

    --[[ EXTRA ]]--------------------------------------------------------
    local Automatic = Tabs.pageExtra:AddSection("Automatic")
    local LockAtBall = Tabs.pageExtra:AddToggle("LockAtBall", {Title = "Lock At Ball", Default = getgenv().Settings.LockAtBall or false })
    local SlideTackle = Tabs.pageExtra:AddToggle("SlideTackle", {Title = "Slide Tackle", Default = getgenv().Settings.SlideTackle or false })
    local Dribble = Tabs.pageExtra:AddToggle("Dribble", {Title = "Dribble", Default = getgenv().Settings.Dribble or false })

    --[[ SCRIPTS ]]--------------------------------------------------------
    local RunService = game:GetService("RunService")
    local TweenService = game:GetService("TweenService")
    local players = game:GetService("Players")
    local player = players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart", 5)

    local allPlayerNames = {}

    local function AddPlayer(plr)
        if plr ~= player then
            table.insert(allPlayerNames, plr.Name)
        end
    end

    local function RemovePlayer(plr)
        local index = table.find(allPlayerNames, plr.Name)
        if index then
            table.remove(allPlayerNames, index)
        end
    end

    players.PlayerAdded:Connect(AddPlayer)
    players.PlayerRemoving:Connect(RemovePlayer)

    for _, v in ipairs(players:GetPlayers()) do
        AddPlayer(v)
    end

    local function CreateHealthBar(Target)
        local statusUI = Instance.new("BillboardGui")
        statusUI.Name = "StatusUI"
        statusUI.Active = true
        statusUI.ClipsDescendants = true
        statusUI.MaxDistance = 1e+09
        statusUI.Size = UDim2.fromScale(1, 4)
        statusUI.StudsOffset = Vector3.new(2.8, 0, 0)
        statusUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        statusUI.Parent = Target

        local fBH = Instance.new("Frame")
        fBH.Name = "FBH"
        fBH.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        fBH.BorderColor3 = Color3.fromRGB(0, 0, 0)
        fBH.BorderSizePixel = 0
        fBH.Rotation = 180
        fBH.Size = UDim2.fromScale(1, 1)

        local uICorner = Instance.new("UICorner")
        uICorner.Name = "UICorner"
        uICorner.CornerRadius = UDim.new(1, 0)
        uICorner.Parent = fBH

        local uIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
        uIAspectRatioConstraint.Name = "UIAspectRatioConstraint"
        uIAspectRatioConstraint.AspectRatio = 0.124
        uIAspectRatioConstraint.Parent = fBH

        local barH = Instance.new("Frame")
        barH.Name = "BarH"
        barH.BackgroundColor3 = Color3.fromRGB(42, 142, 209)
        barH.BorderColor3 = Color3.fromRGB(0, 0, 0)
        barH.BorderSizePixel = 0
        barH.Size = UDim2.fromScale(1, 1)

        local uICorner1 = Instance.new("UICorner")
        uICorner1.Name = "UICorner"
        uICorner1.CornerRadius = UDim.new(1, 0)
        uICorner1.Parent = barH

        barH.Parent = fBH

        local uIGradient = Instance.new("UIGradient")
        uIGradient.Name = "UIGradient"
        uIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(172, 163, 169)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(208, 197, 204)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(172, 163, 169)),
        })
        uIGradient.Parent = fBH

        fBH.Parent = statusUI

        local fBS = Instance.new("Frame")
        fBS.Name = "FBS"
        fBS.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        fBS.BorderColor3 = Color3.fromRGB(0, 0, 0)
        fBS.BorderSizePixel = 0
        fBS.Position = UDim2.fromScale(0.6, 0)
        fBS.Rotation = 180
        fBS.Size = UDim2.fromScale(1, 1)

        local uICorner2 = Instance.new("UICorner")
        uICorner2.Name = "UICorner"
        uICorner2.CornerRadius = UDim.new(1, 0)
        uICorner2.Parent = fBS

        local uIAspectRatioConstraint1 = Instance.new("UIAspectRatioConstraint")
        uIAspectRatioConstraint1.Name = "UIAspectRatioConstraint"
        uIAspectRatioConstraint1.AspectRatio = 0.124
        uIAspectRatioConstraint1.Parent = fBS

        local barS = Instance.new("Frame")
        barS.Name = "BarS"
        barS.BackgroundColor3 = Color3.fromRGB(171, 32, 209)
        barS.BorderColor3 = Color3.fromRGB(0, 0, 0)
        barS.BorderSizePixel = 0
        barS.Size = UDim2.fromScale(1, 1)

        local uICorner3 = Instance.new("UICorner")
        uICorner3.Name = "UICorner"
        uICorner3.CornerRadius = UDim.new(1, 0)
        uICorner3.Parent = barS

        barS.Parent = fBS

        local uIGradient1 = Instance.new("UIGradient")
        uIGradient1.Name = "UIGradient"
        uIGradient1.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(172, 163, 169)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(208, 197, 204)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(172, 163, 169)),
        })
        uIGradient1.Parent = fBS

        fBS.Parent = statusUI
    end

    local function UpdateStatusBars()
        for _, v in pairs(game:GetService("Workspace").Players:GetChildren()) do
            if table.find(allPlayerNames, v.Name) then
                local humanoidRootPart = v:FindFirstChild("HumanoidRootPart")
                local PlayerInfo = v:FindFirstChild("PlayerInfo")
                local stamina = PlayerInfo:FindFirstChild("Stamina")
                local flow = PlayerInfo:FindFirstChild("Flow")
    
                if humanoidRootPart then
                    local StatusUI = humanoidRootPart:FindFirstChild("StatusUI") or CreateHealthBar(humanoidRootPart)
                    
                    if StatusUI then
                        StatusUI.Enabled = ShowStaminaFlow.Value
    
                        if ShowStaminaFlow.Value then
                            local success, err = pcall(function()
                                local BarH = StatusUI:FindFirstChild("FBH"):FindFirstChild("BarH")
                                local FBS = StatusUI:FindFirstChild("FBS")
                                local BarS = FBS and FBS:FindFirstChild("BarS")
        
                                if stamina and BarH then
                                    local staminaRatio = stamina.Value / 100
                                    local goalH = {Size = UDim2.new(1, 0, staminaRatio, 0)}
                                    local tweenInfoH = TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
                                    TweenService:Create(BarH, tweenInfoH, goalH):Play()
                                end
        
                                if flow and BarS then
                                    FBS.Transparency, BarS.Transparency = 0, 0
                                    local armourRatio = flow.Value / 100
                                    local goalS = {Size = UDim2.new(1, 0, armourRatio, 0)}
                                    local tweenInfoS = TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
                                    TweenService:Create(BarS, tweenInfoS, goalS):Play()
                                end
                            end)
                            if not success then
                                warn("Error Message: "..err)
                            end
                        end
                    end
                end
            end
        end
    end

    InfStamina:OnChanged(function()
        task.spawn(function()
            player.CharacterAdded:Connect(function(newCharacter)
                character = newCharacter
            end)
    
            local value = character.PlayerInfo:FindFirstChild("Stamina") or character.PlayerInfo:WaitForChild("Stamina", 5)
            local mt = getrawmetatable(value)
            local Old = mt.__index
    
            setreadonly(mt, false)
            mt.__index = function(self, num)
                if InfStamina.Value and tostring(self) == tostring(value) and num == "Value" then
                    return 80
                end
                return Old(self, num)
            end
            setreadonly(mt, true)
        end)
    end)
    InfFlow:OnChanged(function()
        task.spawn(function()
            player.CharacterAdded:Connect(function(newCharacter)
                character = newCharacter
            end)
    
            local value = character.PlayerInfo:FindFirstChild("Flow") or character.PlayerInfo:WaitForChild("Flow", 5)
            local mt = getrawmetatable(value)
            local Old = mt.__index
    
            setreadonly(mt, false)
            mt.__index = function(self, num)
                if InfFlow.Value and tostring(self) == tostring(value) and num == "Value" then
                    return 100
                end
                return Old(self, num)
            end
            setreadonly(mt, true)
        end)
    end)
    InfPower:OnChanged(function()
        task.spawn(function()
            player.CharacterAdded:Connect(function(newCharacter)
                character = newCharacter
            end)
    
            local value = character.PlayerInfo:FindFirstChild("Power") or character.PlayerInfo:WaitForChild("Power", 5)
            local mt = getrawmetatable(value)
            local Old = mt.__index
    
            setreadonly(mt, false)
            mt.__index = function(self, num)
                if InfPower.Value and tostring(self) == tostring(value) and num == "Value" then
                    return 100
                end
                return Old(self, num)
            end
            setreadonly(mt, true)
        end)
    end)
    SpeedMultiplier:OnChanged(function()
        task.spawn(function()
            player.CharacterAdded:Connect(function(newCharacter)
                character = newCharacter
            end)
    
            local value = character.PlayerInfo:FindFirstChild("SpeedMultiplier") or character.PlayerInfo:WaitForChild("SpeedMultiplier", 5)
            local mt = getrawmetatable(value)
            local Old = mt.__index
    
            setreadonly(mt, false)
            mt.__index = function(self, num)
                if SpeedMultiplier.Value and tostring(self) == tostring(value) and num == "Value" then
                    return tonumber(getgenv().Settings.SpeedMultiple)
                end
                return Old(self, num)
            end
            setreadonly(mt, true)
        end)
    end)
    FlowMultiplier:OnChanged(function()
        task.spawn(function()
            player.CharacterAdded:Connect(function(newCharacter)
                character = newCharacter
            end)
    
            local value = character.PlayerInfo:FindFirstChild("FlowMultiplier") or character.PlayerInfo:WaitForChild("FlowMultiplier", 5)
            local mt = getrawmetatable(value)
            local Old = mt.__index
    
            setreadonly(mt, false)
            mt.__index = function(self, num)
                if FlowMultiplier.Value and tostring(self) == tostring(value) and num == "Value" then
                    return tonumber(getgenv().Settings.FlowMultiple)
                end
                return Old(self, num)
            end
            setreadonly(mt, true)
        end)
    end)
    PowerMultiplier:OnChanged(function()
        task.spawn(function()
            player.CharacterAdded:Connect(function(newCharacter)
                character = newCharacter
            end)
    
            local value = character.PlayerInfo:FindFirstChild("PowerMultiplier") or character.PlayerInfo:WaitForChild("PowerMultiplier", 5)
            local mt = getrawmetatable(value)
            local Old = mt.__index
    
            setreadonly(mt, false)
            mt.__index = function(self, num)
                if PowerMultiplier.Value and tostring(self) == tostring(value) and num == "Value" then
                    return tonumber(getgenv().Settings.PowerMultiple)
                end
                return Old(self, num)
            end
            setreadonly(mt, true)
        end)
    end)
    JumpMultiplier:OnChanged(function()
        task.spawn(function()
            player.CharacterAdded:Connect(function(newCharacter)
                character = newCharacter
            end)
    
            local value = character.PlayerInfo:FindFirstChild("JumpMultiplier") or character.PlayerInfo:WaitForChild("JumpMultiplier", 5)
            local mt = getrawmetatable(value)
            local Old = mt.__index
    
            setreadonly(mt, false)
            mt.__index = function(self, num)
                if JumpMultiplier.Value and tostring(self) == tostring(value) and num == "Value" then
                    return tonumber(getgenv().Settings.JumpMultiple)
                end
                return Old(self, num)
            end
            setreadonly(mt, true)
        end)
    end)
    LockAtBall:OnChanged(function()
        task.spawn(function()
            while LockAtBall.Value do
                task.wait()

                player.CharacterAdded:Connect(function(newCharacter)
                    character = newCharacter
                    humanoidRootPart = newCharacter:WaitForChild("HumanoidRootPart")
                end)

                for i,v in pairs(game:GetService("Workspace").Messi:GetChildren()) do
                    if string.find(v.Name, "ball") and v:IsA("Model") and not character.InstanceValue:FindFirstChild("Possession") then
                        local success, err = pcall(function()
                            local ball = v:FindFirstChild("HumanoidRootPart") or v:WaitForChild("HumanoidRootPart", 5)
                            humanoidRootPart.CFrame = CFrame.lookAt(humanoidRootPart.Position, ball.Position)
                        end)
                        if not success then
                            warn("Error Message: "..err)
                        end
                    end
                end
            end
        end)
    end)
    SlideTackle:OnChanged(function()
        task.spawn(function()
            while SlideTackle.Value do
                task.wait()

                player.CharacterAdded:Connect(function(newCharacter)
                    character = newCharacter
                    humanoidRootPart = newCharacter:WaitForChild("HumanoidRootPart")
                end)

                for i,v in pairs(game:GetService("Workspace").Messi:GetChildren()) do
                    if string.find(v.Name, "ball") and v:IsA("Model") and not character.InstanceValue:FindFirstChild("Possession") then
                        local success, err = pcall(function()
                            local ball = v:FindFirstChild("Football") or v:WaitForChild("Football", 5)
                            local distance = (humanoidRootPart.Position - ball.Position).Magnitude
                            if distance <= 10 then
                                local ohCFrame1 = ball.CFrame
                                game:GetService("ReplicatedStorage").Remotes.SlideTackle:FireServer(ohCFrame1)
                            end
                        end)
                        if not success then
                            warn("Error Message: "..err)
                        end
                    end
                end
            end
        end)
    end)
    Dribble:OnChanged(function()
        task.spawn(function()
            -- local function ClostestPlayer()
            --     local target = nil
            --     local range = math.huge
                
            --     for _, v in pairs(game.Players:GetPlayers()) do
            --         local TargetPlayer = v.Character:FindFirstChild("HumanoidRootPart")
            --         if TargetPlayer then
            --             local distance = (humanoidRootPart.Position - TargetPlayer.Position).Magnitude
            --             if distance < range then
            --                 range = distance
            --                 target = v
            --             end
            --         end
            --     end
            --     return target
            -- end
            player.CharacterAdded:Connect(function(newCharacter)
                character = newCharacter
                humanoidRootPart = newCharacter:WaitForChild("HumanoidRootPart")
            end)

            while Dribble.Value do
                task.wait()
                for _, v in pairs(game.Players:GetPlayers()) do
                    local TargetPlayer = v.Character:FindFirstChild("HumanoidRootPart")
                    if TargetPlayer then
                        local distance = (humanoidRootPart.Position - TargetPlayer.Position).Magnitude
                        if distance < 7 then
                            local ohCFrame1 = humanoidRootPart.CFrame
                            game:GetService("ReplicatedStorage").Remotes.Dribble:FireServer(ohCFrame1)
                        end
                    end
                end
            end
        end)
    end)
    Hitbox:OnChanged(function()
        task.spawn(function()
            while Hitbox.Value do
                task.wait()
                for i,v in pairs(game:GetService("Workspace").Messi:GetChildren()) do
                    if v.Name == "/e ball" and v:IsA("Model") then
                        pcall(function()
                            local Collider = v:FindFirstChild("Collider")
                            Collider.Size = Vector3.new(30, 30, 30)
                            Collider.Transparency = 0.75
                        end)
                    end
                end
            end
        end)
    end)

    RunService.Heartbeat:Connect(function()
        task.spawn(UpdateStatusBars)
    end)

end

Window:SelectTab(1)