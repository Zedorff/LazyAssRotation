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
function NightfallTracker:onEvent(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    if event == "UNIT_CASTEVENT" then
        if arg1 == Helpers:GetUnitGUID("player") and arg3 == "CAST" and arg4 == 25307 then
            self.buffUp = false
        end
    end
    SelfBuffTracker.onEvent(self, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
end

--- @return boolean
function NightfallTracker:ShouldCast()
    return self.buffUp
end
