--- @class ShieldBlockTracker : CooldownTracker
--- @field shieldBlockIsUp boolean
--- @diagnostic disable: duplicate-set-field
ShieldBlockTracker = setmetatable({}, { __index = CooldownTracker })
ShieldBlockTracker.__index = ShieldBlockTracker

--- @return ShieldBlockTracker
function ShieldBlockTracker.new()
    --- @class ShieldBlockTracker
    local self = CooldownTracker.new()
    setmetatable(self, ShieldBlockTracker)
    self.shieldBlockIsUp = Helpers:HasBuff("player", "Ability_Defend")
    return self
end

function ShieldBlockTracker:subscribe()
    CooldownTracker.subscribe(self)
    self.shieldBlockIsUp = Helpers:HasBuff("player", "Ability_Defend")
end

--- @param event string
--- @param arg1 string
function ShieldBlockTracker:onEvent(event, arg1)
    if event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" and string.find(arg1, ABILITY_SHIELD_BLOCK) then
        Logging:Debug(ABILITY_SHIELD_BLOCK.." is up")
        self.shieldBlockIsUp = true
    elseif event == "CHAT_MSG_SPELL_AURA_GONE_SELF" and string.find(arg1, ABILITY_SHIELD_BLOCK) then
        Logging:Debug(ABILITY_SHIELD_BLOCK.." is down")
        self.shieldBlockIsUp = false
    end 
end

--- @return boolean
function ShieldBlockTracker:ShouldCast()
    return not self.shieldBlockIsUp
end
