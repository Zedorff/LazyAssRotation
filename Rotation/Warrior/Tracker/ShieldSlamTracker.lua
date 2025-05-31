--- @class ShieldSlamTracker : CooldownTracker
--- @field shieldSlamIsUp boolean
--- @field shieldSlamCastAttempt number
--- @diagnostic disable: duplicate-set-field
ShieldSlamTracker = setmetatable({}, { __index = CooldownTracker })
ShieldSlamTracker.__index = ShieldSlamTracker

--- @return ShieldSlamTracker
function ShieldSlamTracker.new()
    --- @class ShieldSlamTracker
    local self = CooldownTracker.new()
    setmetatable(self, ShieldSlamTracker)
    self.shieldSlamIsUp = Helpers:HasBuff("player", "Ability_Warrior_ShieldMastery")
    return self
end

function ShieldSlamTracker:subscribe()
    Core:StartHookingSpellCasts()
    CooldownTracker.subscribe(self)
    self.shieldSlamCastAttempt = 0
    self.shieldSlamIsUp = Helpers:HasBuff("player", "Ability_Warrior_ShieldMastery")
end

function ShieldSlamTracker:unsubscribe()
    Core:StopHookingSpellCasts()
    CooldownTracker.unsubscribe(self)
end

--- @param event string
--- @param arg1 string
function ShieldSlamTracker:onEvent(event, arg1)
    if event == "LAR_SPELL_CAST" and arg1 == ABILITY_SHIELD_SLAM then
        self.shieldSlamCastAttempt = GetTime() + 0.5 --- grace period of 0.5 seconds
    elseif event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" and string.find(arg1, "Improved Shield Slam") then
        Logging:Debug("Improved Shield Slam is up")
        self.shieldSlamIsUp = true
    elseif event == "CHAT_MSG_SPELL_AURA_GONE_SELF" and string.find(arg1, "Improved Shield Slam") then
        Logging:Debug("Improved Shield Slam is down")
        self.shieldSlamIsUp = false
    end
end

--- @return boolean
function ShieldSlamTracker:ShouldCast()
    return self.shieldSlamCastAttempt < GetTime() and not self.shieldSlamIsUp
end
