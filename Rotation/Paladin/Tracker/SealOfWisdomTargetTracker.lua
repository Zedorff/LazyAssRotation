--- @class SealOfWisdomTracker : CooldownTracker
--- @field appliedOnTarget boolean
--- @diagnostic disable: duplicate-set-field
SealOfWisdomTracker = setmetatable({}, { __index = CooldownTracker })
SealOfWisdomTracker.__index = SealOfWisdomTracker

--- @return SealOfWisdomTracker
function SealOfWisdomTracker.new()
    --- @class SealOfWisdomTracker
    local self = CooldownTracker.new()
    setmetatable(self, SealOfWisdomTracker)
    self.appliedOnTarget = Helpers:HasDebuffName("target", "Judgement of Wisdom")
    return self
end

function SealOfWisdomTracker:subscribe()
    CooldownTracker.subscribe(self)
    self.appliedOnTarget = Helpers:HasDebuffName("target", "Judgement of Wisdom")
end

--- @param event string
--- @param arg1 string
function SealOfWisdomTracker:onEvent(event, arg1)
    if event == "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE" and string.find(arg1, "Judgement of Wisdom") then
        Logging:Debug("Seal Of Wisdom is up")
        self.appliedOnTarget = true
    elseif event == "CHAT_MSG_SPELL_AURA_GONE_OTHER" and string.find(arg1, "Judgement of Wisdom") then
        local target = UnitName("target")
        if target and string.find(arg1, target) then
            Logging:Debug("Seal Of Wisdom is down")
            self.appliedOnTarget = false
        end
    elseif event == "PLAYER_TARGET_CHANGED" then
        self.appliedOnTarget = Helpers:HasDebuffName("target", "Judgement of Wisdom")
    end 
end

--- @return boolean
function SealOfWisdomTracker:ShouldCast()
    return not self.appliedOnTarget
end
