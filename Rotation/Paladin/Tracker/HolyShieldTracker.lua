--- @class HolyShieldTracker : CooldownTracker
--- @field shieldIsUp boolean
--- @diagnostic disable: duplicate-set-field
HolyShieldTracker = setmetatable({}, { __index = CooldownTracker })
HolyShieldTracker.__index = HolyShieldTracker

--- @return HolyShieldTracker
function HolyShieldTracker.new()
    --- @class HolyShieldTracker
    local self = CooldownTracker.new()
    setmetatable(self, HolyShieldTracker)
    self.shieldIsUp = Helpers:HasBuff("player", "Spell_Holy_BlessingOfProtection")
    return self
end

function HolyShieldTracker:subscribe()
    CooldownTracker.subscribe(self)
    self.shieldIsUp = Helpers:HasBuff("player", "Spell_Holy_BlessingOfProtection")
end

--- @param event string
--- @param arg1 string
function HolyShieldTracker:onEvent(event, arg1)
    if event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" and string.find(arg1, ABILITY_HOLY_SHIELD) then
        Logging:Debug(ABILITY_HOLY_SHIELD.." is up")
        self.shieldIsUp = true
    elseif event == "CHAT_MSG_SPELL_AURA_GONE_SELF" and string.find(arg1, ABILITY_HOLY_SHIELD) then
        Logging:Debug(ABILITY_HOLY_SHIELD.." is down")
        self.shieldIsUp = false
    end
end

--- @return boolean
function HolyShieldTracker:ShouldCast()
    return not self.shieldIsUp;
end
