--- @class ImmolateTracker : CooldownTracker
--- @field immolateUpUntill number
--- @diagnostic disable: duplicate-set-field
ImmolateTracker = setmetatable({}, { __index = CooldownTracker })
ImmolateTracker.__index = ImmolateTracker

local IMMOLATE_DURATION = 15

--- @return ImmolateTracker
function ImmolateTracker.new()
    --- @class ImmolateTracker
    local self = CooldownTracker.new()
    setmetatable(self, ImmolateTracker)
    self.immolateUpUntill = 0
    return self
end

function ImmolateTracker:subscribe()
    CooldownTracker.subscribe(self)
    self.immolateUpUntill = 0
end

--- @param event string
--- @param arg1 string
function ImmolateTracker:onEvent(event, arg1)
    if event == "CHAT_MSG_SPELL_SELF_DAMAGE" then
        if string.find(arg1, ABILITY_IMMOLATE) then
            local hit, crit, _, _, _ = Helpers:ParseCombatEvent(ABILITY_IMMOLATE, arg1)
            if hit or crit then
                Logging:Debug(ABILITY_IMMOLATE .. " is up")
                self.immolateUpUntill = GetTime() + IMMOLATE_DURATION
            end
        elseif string.find(arg1, ABILITY_CONFLAGRATE) then
            local hit, crit, _, _, _ = Helpers:ParseCombatEvent(ABILITY_CONFLAGRATE, arg1)
            if hit or crit then
                self.immolateUpUntill = self.immolateUpUntill - 3
            end
        end
    elseif event == "PLAYER_TARGET_CHANGED" then
        self.immolateUpUntill = 0
    end
end

--- @return boolean
function ImmolateTracker:ShouldCast()
    return self.immolateUpUntill < GetTime()
end
