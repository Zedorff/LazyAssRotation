--- @class SealOfWisdomTargetTracker : CooldownTracker
--- @field appliedOnTarget boolean
--- @diagnostic disable: duplicate-set-field
SealOfWisdomTargetTracker = setmetatable({}, { __index = CooldownTracker })
SealOfWisdomTargetTracker.__index = SealOfWisdomTargetTracker

--- @return SealOfWisdomTargetTracker
function SealOfWisdomTargetTracker.new()
    --- @class SealOfWisdomTargetTracker
    local self = CooldownTracker.new()
    setmetatable(self, SealOfWisdomTargetTracker)
    self.appliedOnTarget = Helpers:HasDebuff("target", "Spell_Holy_RighteousnessAura")
    return self
end

function SealOfWisdomTargetTracker:subscribe()
    CooldownTracker.subscribe(self)
    self.appliedOnTarget = Helpers:HasDebuff("target", "Spell_Holy_RighteousnessAura")
end

--- @param event string
--- @param arg1 string
function SealOfWisdomTargetTracker:onEvent(event, arg1)
    if event == "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE" and string.find(arg1, "Judgement of Wisdom") then
        Logging:Debug("Seal Of Wisdom is on target")
        self.appliedOnTarget = true
    elseif event == "CHAT_MSG_SPELL_AURA_GONE_OTHER" and string.find(arg1, "Judgement of Wisdom") then
        local target = UnitName("target")
        if target and string.find(arg1, target) then
            Logging:Debug("Seal Of Wisdom is not on target")
            self.appliedOnTarget = false
        end
    elseif event == "PLAYER_TARGET_CHANGED" then
        self.appliedOnTarget = Helpers:HasDebuff("target", "Spell_Holy_RighteousnessAura")
    end 
end

--- @return boolean
function SealOfWisdomTargetTracker:ShouldCast()
    return not self.appliedOnTarget
end
