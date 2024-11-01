repeat wait() until game:IsLoaded() and game.Players and game.Players.LocalPlayer and game.Players.LocalPlayer.Character

getgenv().Settings = {
  SelectedBlackList = {},
}

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Blobby Hub" .. " | ".."Beady City".." | ".."[Free Version]",
    TabWidth = 160,
    Size =  UDim2.fromOffset(480, 360),
    Acrylic = false,
    Theme = "Amethyst",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    --[[ Tabs --]]
    pageMain = Window:AddTab({ Title = "Main", Icon = "home" }),
    pageMiscellaneous = Window:AddTab({ Title = "Miscellaneous", Icon = "component" }),
}

do
  --[[MAIN]]---------------------------------------------------------
  local BlackList = {}
  local function GetPlayerList()
    for i,v in pairs(game.Players:GetChildren()) do
      if v.Name ~= game.Players.LocalPlayer.Name then
        table.insert(BlackList, v.Name)
      end
    end
  end
  local function RemovePlayerList()
    if BlackList ~= nil then
      for i = #BlackList, 1, -1 do
          table.remove(BlackList, i)
      end
    end
  end
  GetPlayerList()
  local SelectBlackList = Tabs.pageMain:AddDropdown("SelectEventZone", {
      Title = "Select Black List",
      Values = BlackList,
      Multi = true,
      Default = getgenv().Settings.SelectedBlackList,
  })
  local RefreshRod = Tabs.pageMain:AddButton({
      Title = "Refresh List",
      Callback = function()
          local currentSelection = SelectBlackList.Value

          RemovePlayerList()
          GetPlayerList()
          SelectBlackList:SetValues(BlackList)
          
          local retainedSelection = {}

          for _, selected in pairs(currentSelection) do
              if table.find(BlackList, selected) then
                  table.insert(retainedSelection, selected)
              end
          end

          if #retainedSelection > 0 then
              SelectBlackList:SetValue(retainedSelection)
          else
              SelectBlackList:SetValue({BlackList[#BlackList]})
          end
      end
  })
  SelectBlackList:OnChanged(function(Value)
      local Values = {}
      for Value, State in next, Value do
          table.insert(Values, Value)
      end
      getgenv().Settings.SelectedBlackList = Values
  end)
  local ESP = Tabs.pageMain:AddToggle("ESP", {Title = "ESP", Default = false })
  local ShowHS = Tabs.pageMain:AddToggle("ShowHS", {Title = "ShowHS", Default = false })
  local AutoArmorT = Tabs.pageMain:AddToggle("AutoArmorT", {Title = "AutoArmor(Training)", Default = false })
  local AutoArmor = Tabs.pageMain:AddToggle("AutoArmor", {Title = "AutoArmor(Real)", Default = false })
  local GotoClub = Tabs.pageMain:AddButton({
    Title = "Goto Club",
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(3103.40796, 4.45183325, 459.063568, -0.471748948, -3.39322028e-08, 0.881732941, -7.67310411e-08, 1, -2.56946864e-09, -0.881732941, -6.8868431e-08, -0.471748948)
    end
  })
  local GotoToilet = Tabs.pageMain:AddButton({
    Title = "Goto Toilet",
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(416.633087, 4.44164419, -823.257507, 0.692703128, -4.09313827e-09, 0.721222818, 4.84560347e-09, 1, 1.02128395e-09, -0.721222818, 2.78731349e-09, 0.692703128)
    end
  })



  --[[SCRIPTS]]--------------------------------------------------------
  AutoArmorT:OnChanged(function()
    task.spawn(function()
      while AutoArmor.Value do
          wait()
          local hasBodyVest = false
          
          for _, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
              if v.Name == "Body Vest" then
                  hasBodyVest = true
                  break
              end
          end

          if not hasBodyVest then
              game:GetService("Lighting").Sky.Optimized:FireServer("BodyArmor(T)", "", "")
              wait(1)
          end
      end
    end)
  end)
  AutoArmor:OnChanged(function()
    task.spawn(function()
      while AutoArmor.Value do
          wait()
          local hasBodyVest = false
          
          for _, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
              if v.Name == "Body Vest" then
                  hasBodyVest = true
                  break
              end
          end

          if not hasBodyVest then
              game:GetService("Lighting").Sky.Optimized:FireServer("BodyArmor", "", "")
              wait(1)
          end
      end
    end)
  end)

  ---------------------------------------------------------------------
  local function CreateESP(Target, PlayerName)
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "BillboardGui"
    billboardGui.Active = true
    billboardGui.AlwaysOnTop = true
    billboardGui.ClipsDescendants = true
    billboardGui.LightInfluence = 1
    billboardGui.Size = UDim2.fromScale(4.5, 8)
    billboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    billboardGui.Parent = Target

    local border = Instance.new("TextLabel")
    border.Name = "Border"
    border.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
    border.RichText = true
    border.Text = ""
    border.TextColor3 = Color3.fromRGB(0, 0, 0)
    border.TextScaled = true
    border.TextSize = 14
    border.TextTransparency = 1
    border.TextWrapped = true
    border.AnchorPoint = Vector2.new(0.5, 0.5)
    border.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    border.BackgroundTransparency = 1
    border.BorderColor3 = Color3.fromRGB(0, 0, 0)
    border.BorderSizePixel = 10
    border.Position = UDim2.fromScale(0.5, 0.5)
    border.Size = UDim2.fromScale(0.9, 0.8)

    local uIStroke = Instance.new("UIStroke")
    uIStroke.Name = "UIStroke"
    uIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    uIStroke.Color = Color3.fromRGB(255, 255, 255)
    uIStroke.Thickness = 3
    uIStroke.Parent = border

    border.Parent = billboardGui

    local nAME = Instance.new("TextLabel")
    nAME.Name = "NAME"
    nAME.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json")
    nAME.Text = tostring(PlayerName)
    nAME.TextColor3 = Color3.fromRGB(255, 255, 255)
    nAME.TextScaled = true
    nAME.TextSize = 14
    nAME.TextWrapped = true
    nAME.AnchorPoint = Vector2.new(0.5, 0.5)
    nAME.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    nAME.BackgroundTransparency = 1
    nAME.BorderColor3 = Color3.fromRGB(255, 255, 255)
    nAME.BorderSizePixel = 10
    nAME.Position = UDim2.fromScale(0.5, 0.05)
    nAME.Size = UDim2.fromScale(1, 0.06)
    nAME.Parent = billboardGui
  end
  local function CreateHealthBar(Target)
    local statusUI = Instance.new("BillboardGui")
    statusUI.Name = "StatusUI"
    statusUI.Active = true
    statusUI.AlwaysOnTop = true
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
    barH.BackgroundColor3 = Color3.fromRGB(48, 207, 24)
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
      ColorSequenceKeypoint.new(0, Color3.fromRGB(154, 7, 7)),
      ColorSequenceKeypoint.new(0.5, Color3.fromRGB(218, 10, 10)),
      ColorSequenceKeypoint.new(1, Color3.fromRGB(154, 7, 7)),
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
    barS.BackgroundColor3 = Color3.fromRGB(42, 142, 209)
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

  local TweenService = game:GetService("TweenService")
  local RunService = game:GetService("RunService")
  local players = game:GetService("Players")
  local plr = players.LocalPlayer

  local allPlayerNames = {}

  local function AddPlayer(player)
      if player ~= plr then
          table.insert(allPlayerNames, player.Name)
      end
  end

  local function RemovePlayer(player)
      local index = table.find(allPlayerNames, player.Name)
      if index then
          table.remove(allPlayerNames, index)
      end
  end

  players.PlayerAdded:Connect(AddPlayer)
  players.PlayerRemoving:Connect(RemovePlayer)

  for _, player in ipairs(players:GetPlayers()) do
      AddPlayer(player)
  end

  local function UpdateStatusBars()
    for _, v in pairs(game.Workspace:GetChildren()) do
        if table.find(allPlayerNames, v.Name) then
            local humanoidRootPart = v:FindFirstChild("HumanoidRootPart")
            local humanoid = v:FindFirstChild("Humanoid")
            local BodyArmour = v:FindFirstChild("BodyArmor")

            if humanoidRootPart then
                local StatusUI = humanoidRootPart:FindFirstChild("StatusUI") or CreateHealthBar(humanoidRootPart)
                
                if StatusUI then
                    -- ถ้าผู้เล่นอยู่ใน BlackList จะปิด StatusUI
                    if table.find(getgenv().Settings.SelectedBlackList, v.Name) then
                        StatusUI.Enabled = false
                    else
                        -- ถ้าไม่ได้อยู่ใน BlackList จะเปิด StatusUI ตามค่า ShowHS.Value
                        StatusUI.Enabled = ShowHS.Value

                        if ShowHS.Value then
                            local BarH = StatusUI:FindFirstChild("FBH"):FindFirstChild("BarH")
                            local FBS = StatusUI:FindFirstChild("FBS")
                            local BarS = FBS and FBS:FindFirstChild("BarS")

                            if humanoid and BarH then
                                local healthRatio = humanoid.Health / humanoid.MaxHealth
                                local goalH = {Size = UDim2.new(1, 0, healthRatio, 0)}
                                local tweenInfoH = TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
                                TweenService:Create(BarH, tweenInfoH, goalH):Play()
                            end

                            if BodyArmour and BarS then
                                FBS.Transparency, BarS.Transparency = 0, 0
                                local armourRatio = BodyArmour.Value / 100
                                local goalS = {Size = UDim2.new(1, 0, armourRatio, 0)}
                                local tweenInfoS = TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
                                TweenService:Create(BarS, tweenInfoS, goalS):Play()
                            elseif BarS then
                                FBS.Transparency, BarS.Transparency = 1, 1
                            end
                        end
                    end
                end
            end
        end
    end
  end

  local function UpdateESP()
    for _, v in pairs(game.Workspace:GetChildren()) do
        if table.find(allPlayerNames, v.Name) then
            local ESPUI = v:FindFirstChild("BillboardGui") or CreateESP(v, v.Name)

            if ESPUI then
                if table.find(getgenv().Settings.SelectedBlackList, v.Name) then
                    ESPUI.Enabled = false
                else
                    ESPUI.Enabled = ESP.Value
                end
            end
        end
    end
end


  RunService.Heartbeat:Connect(function()
      task.spawn(UpdateStatusBars)
      task.spawn(UpdateESP)
  end)
end

--------------------------------------------------------
-- local mt = getrawmetatable(game)
-- setreadonly(mt, false)

-- local oldNamecall = mt.__namecall

-- mt.__namecall = newcclosure(function(self, ...)
--     local args = {...}
--     local method = getnamecallmethod()
    
--     if method == "FireServer" and self.Name == "." then
--       args[1] = game.Workspace.tooj1239.Humanoid
--       args[2] = "Hit"
--       return oldNamecall(self, unpack(args))
--     end
--     return oldNamecall(self, ...)
-- end)

-- setreadonly(mt, true)
--------------------------------------------------------
-- local mt = getrawmetatable(game)
-- setreadonly(mt, false)

-- local oldNamecall = mt.__namecall

-- mt.__namecall = newcclosure(function(self, ...)
--     local args = {...}
--     local method = getnamecallmethod()
    
--     if method == "FireServer" and self.Name == "RemoteEvent" then
--       return oldNamecall(self, unpack(args))
--     end
--     print("Not Work")
--     return oldNamecall(self, ...)
-- end)

-- setreadonly(mt, true)


-- _G.A = true
-- while _G.A == true do
--     wait()
--     local plr = game:GetService("Players").LocalPlayer
--     if not plr.Character:FindFirstChild("Basket") then
--         game:GetService("Lighting").Sky.Optimized:FireServer("Basket", "", "")
--         wait(.1)
--     else
--         for i,v in pairs(game:GetService("Workspace").JOB.JOB.SCRIPT.MangoJOB:GetChildren()) do
--             if v.Name == "Mango" and v.Transparency == 0 and plr.ItemGame.Mango.Value < 30 then
--                 plr.Character.HumanoidRootPart.CFrame = v.CFrame
--                 wait(.1)
--                 game:GetService("ReplicatedStorage").Remote.Main:FireServer("FarmItemGame")
--             elseif plr.ItemGame.Mango.Value == 30 then
--                 for i,v in pairs(game:GetService("Workspace"):GetChildren()) do
--                     if v.Name == "Stove" and v:FindFirstChild("MangoPackProcess") then
--                         local Process = v:FindFirstChild("MangoPackProcess") or v:WaitForChild("MangoPackProcess", 5)
--                         plr.Character.HumanoidRootPart.CFrame = Process.CFrame
--                         fireproximityprompt(Process.Prompt)
--                     end
--                 end
--             end
--         end    
--     end
-- end