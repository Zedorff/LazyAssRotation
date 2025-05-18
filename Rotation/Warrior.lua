--- @class Warrior : ClassRotation
---@diagnostic disable: duplicate-set-field
Warrior = setmetatable({}, { __index = ClassRotation })
Warrior.__index = Warrior

--- @type ClassRotation | nil
local proxyRotation = nil

--- @param deps any
--- @return Warrior
function Warrior:new(deps)
    proxyRotation = Warrior:GetRotationBySpec(deps)
    return setmetatable({}, self)
end

function Warrior:execute()
    if proxyRotation then
        proxyRotation:execute()
    end
end

--- @param deps any
--- @return ClassRotation | nil
function Warrior:GetRotationBySpec(deps)
    local _, _, arms = GetTalentTabInfo(1)
    local _, _, fury = GetTalentTabInfo(2)
    local _, _, prot = GetTalentTabInfo(3)

    if arms >= fury and arms >= prot then
        return ArmsWarrior:new({
            autoAttackTracker = deps.autoAttackTracker,
            overpowerTracker = deps.overpowerTracker,
        })
    elseif fury >= arms and fury >= prot then
        return FuryWarrior:new()
    else
        return nil
    end
end
