_G.Settings = {
    Version = "1.0",
}

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/TheG450/BlobbyHub/main/prototype.lua"))()

local Window = Fluent:CreateWindow({
    Title = "BlobbyHub " .. _G.Settings.Version,
    SubTitle = "by GZE450#6591",
    TabWidth = 160,
    Size = UDim2.fromOffset(480, 360), --default size (580, 460)
    Acrylic = true, -- การเบลออาจตรวจจับได้ การตั้งค่านี้เป็น false จะปิดการเบลอทั้งหมด
    Theme = "Amethyst",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Fluent มีไอคอน Lucide https://lucide.dev/icons/ สำหรับแท็บ ไอคอนเป็นตัวเลือก
local Tabs = {
    --[[ Tabs --]]
    Main = Window:AddTab({ Title = "Main", Icon = "house" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" }),
    Teleport = Window:AddTab({ Title = "Teleport", Icon = "map" })
}

local Options = Fluent.Options

do

    Tabs.Main:AddParagraph({
        Title = "Paragraph",
        Content = "This is a paragraph.\nSecond line!"
    })

    Tabs.Main:AddButton({
        Title = "Button",
        Description = "Very important button",
        Callback = function()
            Window:Dialog({
                Title = "Title",
                Content = "This is a dialog",
                Buttons = {
                    {
                        Title = "Confirm",
                        Callback = function()
                            print("Confirmed the dialog.")
                        end
                    },
                    {
                        Title = "Cancel",
                        Callback = function()
                            print("Cancelled the dialog.")
                        end
                    }
                }
            })
        end
    })

    local Toggle = Tabs.Main:AddToggle("MyToggle", {Title = "Toggle", Default = false })
    local AutoFarm = Tabs.Main:AddToggle("AutoFarm", {Title = "AutoFarm", Default = false })

    Toggle:OnChanged(function()
        task.spawn(function()
            while wait() do
                if Options.MyToggle.Value then
                    print("Toggle changed:", Options.MyToggle.Value)
                end
            end
        end)
    end)

    AutoFarm:OnChanged(function()
        task.spawn(function()
            while wait() do
                if Options.AutoFarm.Value then
                    print("Toggle Autofarm:", AutoFarm.Value)
                end
            end
        end)
    end)



    Options.MyToggle:SetValue(false)
    Options.AutoFarm:SetValue(false)

    local Slider = Tabs.Main:AddSlider("Slider", {
        Title = "Slider",
        Description = "This is a slider",
        Default = 2,
        Min = 0,
        Max = 5,
        Rounding = 1,
        Callback = function(Value)
            print("Slider was changed:", Value)
        end
    })

    Slider:OnChanged(function(Value)
        print("Slider changed:", Value)
    end)

    Slider:SetValue(3)

    local Dropdown = Tabs.Main:AddDropdown("Dropdown", {
        Title = "Dropdown",
        Values = {"one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven", "twelve", "thirteen", "fourteen"},
        Multi = false,
        Default = 1,
    })

    Dropdown:SetValue("four")

    Dropdown:OnChanged(function(Value)
        print("Dropdown changed:", Value)
    end)

    local MultiDropdown = Tabs.Main:AddDropdown("MultiDropdown", {
        Title = "Dropdown",
        Description = "You can select multiple values.",
        Values = {"one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven", "twelve", "thirteen", "fourteen"},
        Multi = true,
        Default = {"seven", "twelve"},
    })

    MultiDropdown:SetValue({
        three = true,
        five = true,
        seven = false
    })

    MultiDropdown:OnChanged(function(Value)
        local Values = {}
        for Value, State in next, Value do
            table.insert(Values, Value)
        end
        print("Mutlidropdown changed:", table.concat(Values, ", "))
    end)

    local Colorpicker = Tabs.Main:AddColorpicker("Colorpicker", {
        Title = "Colorpicker",
        Default = Color3.fromRGB(96, 205, 255)
    })

    Colorpicker:OnChanged(function()
        print("Colorpicker changed:", Colorpicker.Value)
    end)
    
    Colorpicker:SetValueRGB(Color3.fromRGB(0, 255, 140))

    local TColorpicker = Tabs.Main:AddColorpicker("TransparencyColorpicker", {
        Title = "Colorpicker",
        Description = "but you can change the transparency.",
        Transparency = 0,
        Default = Color3.fromRGB(96, 205, 255)
    })

    TColorpicker:OnChanged(function()
        print(
            "TColorpicker changed:", TColorpicker.Value,
            "Transparency:", TColorpicker.Transparency
        )
    end)

    local Keybind = Tabs.Main:AddKeybind("Keybind", {
        Title = "KeyBind",
        Mode = "Toggle", -- Always, Toggle, Hold
        Default = "LeftControl", -- String เป็นชื่อของคีย์ลัด (MB1, MB2 สำหรับปุ่มเมาส์)

        -- เกิดขึ้นเมื่อคลิกคีย์ลัด ค่าเป็น `true`/`false`
        Callback = function(Value)
            print("Keybind clicked!", Value)
        end,

        -- เกิดขึ้นเมื่อมีการเปลี่ยนแปลงคีย์ลัด `New` เป็น KeyCode Enum หรือ UserInputType Enum
        ChangedCallback = function(New)
            print("Keybind changed!", New)
        end
    })

    -- OnClick จะถูกเรียกใช้เมื่อคุณกดคีย์ลัดและโหมดเป็น Toggle
    -- มิฉะนั้น คุณจะต้องใช้ Keybind:GetState()
    Keybind:OnClick(function()
        print("Keybind clicked:", Keybind:GetState())
    end)

    Keybind:OnChanged(function()
        print("Keybind changed:", Keybind.Value)
    end)

    task.spawn(function()
        while true do
            wait(1)

            -- ตัวอย่างการตรวจสอบว่าคีย์ลัดถูกกดค้างไว้หรือไม่
            local state = Keybind:GetState()
            if state then
                print("Keybind is being held down")
            end

            if Fluent.Unloaded then break end
        end
    end)

    Keybind:SetValue("MB2", "Toggle") -- ตั้งค่าคีย์ลัดเป็น MB2 โหมดเป็น Hold

    local Input = Tabs.Main:AddInput("Input", {
        Title = "Input",
        Default = "Default",
        Placeholder = "Placeholder",
        Numeric = false, -- อนุญาตเฉพาะตัวเลขเท่านั้น
        Finished = false, -- เรียก callback เมื่อกด enter เท่านั้น
        Callback = function(Value)
            print("Input changed:", Value)
        end
    })

    Input:OnChanged(function()
        print("Input updated:", Input.Value)
    end)
end

-- ส่วนเสริม:
-- SaveManager (อนุญาตให้คุณมีระบบการกำหนดค่า)
-- InterfaceManager (อนุญาตให้คุณมีระบบการจัดการอินเตอร์เฟซ)

-- ส่งต่อไลบรารีไปยังผู้จัดการของเรา
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- ไม่สนใจคีย์ที่ใช้โดย ThemeManager
-- (เราไม่ต้องการให้การกำหนดค่าบันทึกธีมใช่ไหม?)
SaveManager:IgnoreThemeSettings()

-- คุณสามารถเพิ่มดัชนีขององค์ประกอบที่ตัวจัดการการบันทึกควรละเว้น
SaveManager:SetIgnoreIndexes({})

-- กรณีการใช้งานที่ทำแบบนี้:
-- สคริปต์ฮับสามารถมีธีมในโฟลเดอร์ระดับโลก
-- และการกำหนดค่าเกมในโฟลเดอร์แยกต่างหากต่อเกม
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("BlobbyHub/games")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

Fluent:Notify({
    Title = "Fluent",
    Content = "The script has been loaded.",
    Duration = 8
})
--[[    
Fluent:Notify({
    Title = "Notification",
    Content = "Script Is Lodded",
    SubContent = "SubContent",
    Duration = 5 -- ตั้งค่าเป็น nil เพื่อไม่ให้การแจ้งเตือนหายไป
})
]]

-- คุณสามารถใช้ SaveManager:LoadAutoloadConfig() เพื่อโหลดการกำหนดค่า
-- ที่ถูกทำเครื่องหมายว่าเป็นการกำหนดค่าอัตโนมัติ!
SaveManager:LoadAutoloadConfig()
