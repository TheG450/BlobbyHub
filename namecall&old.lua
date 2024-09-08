--[[namecall]]
local namecall
namecall = hookmetamethod(game, '__namecall', function(self, ...)
    local args = {...}
    local method = getnamecallmethod()

    -- ตรวจสอบว่าการเรียกใช้คือ FireServer และเกี่ยวข้องกับ "Skills"
    if not checkcaller() and method == 'FireServer' and self.Name == 'Skills' then
        if args[1] == "Combat" and args[2] == "M1" then
            -- ลบ Cooldown โดยทำให้เรียกใช้งานได้ทันที
            return namecall(self, unpack(args))  -- เรียก FireServer ทันที
        end
    end

    return namecall(self, ...)
end)


--[[old]]
-- บันทึกฟังก์ชัน FireServer เดิม
local oldFireServer = game:GetService("ReplicatedStorage").Assets.Remotes.Skills.FireServer

-- Hook ฟังก์ชัน FireServer
hookfunction(oldFireServer, function(self, ...)
    local args = {...}
    
    -- ตรวจสอบว่าเป็นการเรียกใช้ Combat M1
    if args[1] == "Combat" and args[2] == "M1" then
        -- ลบ cooldown โดยการเรียกใช้งานได้ทันที
        return oldFireServer(self, unpack(args))  -- เรียก FireServer ทันที
    end
    
    -- คืนค่าเดิมของ FireServer
    return oldFireServer(self, unpack(args))
end)
