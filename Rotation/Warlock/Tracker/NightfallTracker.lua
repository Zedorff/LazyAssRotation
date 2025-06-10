--- @class NightfallTracker : SelfBuffTracker
--- @diagnostic disable: duplicate-set-field
NightfallTracker = setmetatable({}, { __index = SelfBuffTracker })
NightfallTracker.__index = NightfallTracker

--- @return NightfallTracker
function NightfallTracker.new()
    --- @class NightfallTracker
    local self = SelfBuffTracker.new(PASSIVE_NIGHTFALL, "Spell_Shadow_Twilight")
    setmetatable(self, NightfallTracker)
    return self
end

--- @param event string
--- @param arg1 string
function NightfallTracker:onEvent(event, arg1)
    if event == "UNIT_CASTEVENT" and arg1 == ({ UnitExists("player") })[2] and arg3 == "CAST" and arg4 == 25307 then
        self.buffUp = false
    end
    SelfBuffTracker.onEvent(self, event, arg1)
end

--- @return boolean
function NightfallTracker:ShouldCast()
    return self.buffUp
end
