--- @class Warrior : ClassRotation
--- @field proxyRotation ClassRotation | nil
--- @diagnostic disable: duplicate-set-field
Warrior = setmetatable({}, { __index = ClassRotation })
Warrior.__index = Warrior

--- @return Warrior
function Warrior.new()
    local table = {
        proxyRotation = Warrior:GetRotationBySpec()
    }
    return setmetatable(table, Warrior)
end

function Warrior:execute()
    self.proxyRotation:execute()
end

--- @return ClassRotation | nil
function Warrior:GetRotationBySpec()
    local spec = Helpers:GetWarriorSpec()

    if spec == WarriorSpec.ARMS then
        return ArmsWarrior.new()
    elseif spec == WarriorSpec.FURY then
        return FuryWarrior.new()
    else
        return nil
    end
end
