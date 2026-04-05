--- @class ImmolateTracker : DotTracker
ImmolateTracker = setmetatable({}, { __index = DotTracker })
ImmolateTracker.__index = ImmolateTracker

--- @return ImmolateTracker
function ImmolateTracker.new()
    --- @class ImmolateTracker
    local self = DotTracker.new(Abilities.Immolate)
    setmetatable(self, ImmolateTracker)
    return self
end

--- @param event string
--- @param arg1 string
function ImmolateTracker:onEvent(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    DotTracker.onEvent(self, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    if event == "CHAT_MSG_SPELL_SELF_DAMAGE" then
        if string.find(arg1, Abilities.Conflagrate.name) then
            local hit, crit, _, _, _ = Helpers:ParseCombatEvent(Abilities.Conflagrate.name, arg1)
            if hit or crit then
                local target = Helpers:GetUnitGUID("target")
                local mobData = self:GetMobData(target)
                mobData.duration = mobData.duration - 3
            end
        end
    end
end
