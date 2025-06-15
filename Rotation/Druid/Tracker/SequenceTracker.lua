--- @class SequenceTracker : CooldownTracker
--- @field lastCastSpellId integer | nil
SequenceTracker = setmetatable({}, { __index = CooldownTracker })
SequenceTracker.__index = SequenceTracker

--- @type SequenceTracker | nil
local sharedInstance = nil

--- @return SequenceTracker
function SequenceTracker.GetInstance()
    if sharedInstance then
        return sharedInstance
    end

    --- @class SequenceTracker
    local self = CooldownTracker.new()
    setmetatable(self, SequenceTracker)

    self.lastCastSpellId = nil

    sharedInstance = self

    return sharedInstance
end

--- @param event string
--- @param arg1 string
function SequenceTracker:onEvent(event, arg1, arg2, arg3, arg4)
    if event == "UNIT_CASTEVENT" and arg1 == ({ UnitExists("player") })[2] and arg3 == "CAST" then
        self.lastCastSpellId = tonumber(arg4)
    end
end

--- @return boolean
function SequenceTracker:ShouldCast()
    return false
end

--- @return boolean
function SequenceTracker:IsLastCastWasStarfire()
    return self.lastCastSpellId == 25298
            or self.lastCastSpellId == 9876
            or self.lastCastSpellId == 9875
            or self.lastCastSpellId == 8951
            or self.lastCastSpellId == 8950
            or self.lastCastSpellId == 8949
            or self.lastCastSpellId == 2912
end

--- @return boolean
function SequenceTracker:IsLastCastWasWrath()
    return self.lastCastSpellId == 9912
            or self.lastCastSpellId == 8905
            or self.lastCastSpellId == 6780
            or self.lastCastSpellId == 5180
            or self.lastCastSpellId == 5179
            or self.lastCastSpellId == 5178
            or self.lastCastSpellId == 5177
            or self.lastCastSpellId == 5176
end
