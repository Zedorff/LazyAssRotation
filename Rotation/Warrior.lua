--- @class Warrior : ClassRotation
--- @field proxyRotation ClassRotation | nil
--- @diagnostic disable: duplicate-set-field
Warrior = setmetatable({}, { __index = ClassRotation })
Warrior.__index = Warrior

--- @param deps any
--- @return Warrior
function Warrior:new()
    local table = {
        proxyRotation = Warrior:GetRotationBySpec()
    }
    return setmetatable(table, self)
end

function Warrior:execute()
    self.proxyRotation:execute()
end

--- @param deps any
--- @return ClassRotation | nil
function Warrior:GetRotationBySpec()
    local _, _, arms = GetTalentTabInfo(1)
    local _, _, fury = GetTalentTabInfo(2)
    local _, _, prot = GetTalentTabInfo(3)

    if arms >= fury and arms >= prot then
        return ArmsWarrior:new()
    elseif fury >= arms and fury >= prot then
        return FuryWarrior:new()
    else
        return nil
    end
end
