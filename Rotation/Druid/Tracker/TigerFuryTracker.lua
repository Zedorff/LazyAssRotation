--- @class TigerFuryTracker : CooldownTracker
--- @field tigerFuryIsIp boolean
--- @diagnostic disable: duplicate-set-field
TigerFuryTracker = setmetatable({}, { __index = CooldownTracker })
TigerFuryTracker.__index = TigerFuryTracker

--- @return TigerFuryTracker
function TigerFuryTracker.new()
    --- @class TigerFuryTracker
    local self = CooldownTracker.new()
    setmetatable(self, TigerFuryTracker)
    self.tigerFuryIsIp = Helpers:HasBuff("player", "Ability_GhoulFrenzy")
    return self
end

function TigerFuryTracker:subscribe()
    CooldownTracker.subscribe(self)
    self.tigerFuryIsIp = Helpers:HasBuff("player", "Ability_GhoulFrenzy")
end

--- @param event string
--- @param arg1 string
function TigerFuryTracker:onEvent(event, arg1)
    if event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" and string.find(arg1, "Blood Frenzy") then
        Logging:Debug(ABILITY_TIGER_FURY.." is up")
        self.tigerFuryIsIp = true
    elseif event == "CHAT_MSG_SPELL_AURA_GONE_SELF" and string.find(arg1, "Blood Frenzy") then
        Logging:Debug(ABILITY_TIGER_FURY.." is down")
        self.tigerFuryIsIp = false
    end 
end

--- @return boolean
function TigerFuryTracker:ShouldCast()
    return not self.tigerFuryIsIp
end
