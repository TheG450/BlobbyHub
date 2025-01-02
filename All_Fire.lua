-- Fires a click environment action to a clickable part
fireclickdetector(game.Workspace.Regen.ClickDetecter)

-- Fires the prompt environment action (It works differently with other exploits)
fireproximityprompt(game.Workspace.ProximityPrompt) -- fires it
fireproximityprompt(game.Workspace.ProximityPrompt, 0, 100) --  0 sets the cooldown of the proximity to 0 and the 100 is how many times it'll get fired.
Other exploits
fireproximityprompt(game.Workspace.ProximityPrompt, 100)  100 is how many times it'll get fired.

-- Some exploits will crash due to the part not having a touch interest
-- (The Touch interest/block), (Where it'll send it off to)
firetouchinterest(workspace.ShopPads.CargoStatiaGasStation, game.Players.LocalPlayer.Character.HumanoidRootPart)

-- Presses a key (C). Must be in capital letters
game:GetService('VirtualInputManager'):SendKeyEvent(true, 'C', false, yes)

-- (click key) change ClickButton1 to ClickButton2 for right click
game:GetService("VirtualUser"):ClickButton1(Vector2.new(0, 0))

-- Fire signal, used for RBXScriptSignals, for example able to click a gui button. Fire signal isn't really supported in a few executors(Solara)
example: firesignal(PathOfTheButton[MouseButton1Click])

-- queue_on_teleport is a confusing function to use that allows you to rejoin a game and automatically execute a script without needing the script to be in the auto execute folder.

* This function is useful for auto farming, especially if you get disconnected.
* You need to use quotation marks or brackets to wrap the code you want to execute.
* It's recommended to use loadstring instead of the actual code
* if you use loadstring put this code inside  (if not game:IsLoaded() then game.Loaded:Wait() end) . It's very important as it avoids crashing

Example: queue_on_teleport([[loadstring(game:HttpGet('https://raw.githubusercontent.com/something'))()]])
