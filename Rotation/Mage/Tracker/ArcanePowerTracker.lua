--- @class ArcanePowerTracker : CooldownTracker
--- @field arcanePowerIsUp boolean
--- @diagnostic disable: duplicate-set-field
ArcanePowerTracker = setmetatable({}, { __index = CooldownTracker })
ArcanePowerTracker.__index = ArcanePowerTracker

--- @return ArcanePowerTracker
function ArcanePowerTracker.new()
    --- @class ArcanePowerTracker
    local self = CooldownTracker.new()
    setmetatable(self, ArcanePowerTracker)
    self.arcanePowerIsUp = Helpers:HasBuff("player", "Spell_Nature_Lightning")
    return self
end

function ArcanePowerTracker:subscribe()
    CooldownTracker.subscribe(self)
    self.arcanePowerIsUp = Helpers:HasBuff("player", "Spell_Nature_Lightning")
end

--- @param event string
--- @param arg1 string
function ArcanePowerTracker:onEvent(event, arg1)
    if event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" and string.find(arg1, ABILITY_ARCANE_POWER) then
        Logging:Debug(ABILITY_ARCANE_POWER.." is up")
        self.arcanePowerIsUp = true
    elseif event == "CHAT_MSG_SPELL_AURA_GONE_SELF" and string.find(arg1, ABILITY_ARCANE_POWER) then
        Logging:Debug(ABILITY_ARCANE_POWER.." is down")
        self.arcanePowerIsUp = false
    end 
end

--- @return boolean
function ArcanePowerTracker:ShouldCast()
    return not self.arcanePowerIsUp
end