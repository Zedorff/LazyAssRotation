MLDps = MLDps or {}

--- @class LightningShieldTracker : CooldownTracker
--- @field shieldIsUp boolean
--- @diagnostic disable: duplicate-set-field
LightningShieldTracker = setmetatable({}, { __index = CooldownTracker })
LightningShieldTracker.__index = LightningShieldTracker

--- @return LightningShieldTracker
function LightningShieldTracker.new()
    --- @class LightningShieldTracker
    local self = setmetatable(CooldownTracker.new(), LightningShieldTracker)
    self.shieldIsUp = Helpers:HasBuff("player", "Spell_Nature_LightningShield")
    return self
end

function LightningShieldTracker:subscribe()
    CooldownTracker.subscribe(self)
    self.shieldIsUp = Helpers:HasBuff("player", "Spell_Nature_LightningShield")
end

--- @param event string
--- @param arg1 string
function LightningShieldTracker:onEvent(event, arg1)
    if event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" and string.find(arg1, ABILITY_LIGHTNING_SHIELD) then
        Logging:Debug("Lightning Shield is up")
        self.shieldIsUp = true
    elseif event == "CHAT_MSG_SPELL_AURA_GONE_SELF" and string.find(arg1, ABILITY_LIGHTNING_SHIELD) then
        Logging:Debug("Lightning Shield is down")
        self.shieldIsUp = false
    end 
end

--- @return boolean
function LightningShieldTracker:ShouldCast()
    return not self.shieldIsUp
end
