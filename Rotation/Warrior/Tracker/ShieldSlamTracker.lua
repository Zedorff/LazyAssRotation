--- @class ShieldSlamTracker : CooldownTracker
--- @field shieldSlamIsUp boolean
--- @field shieldSlamUpUntill number
--- @diagnostic disable: duplicate-set-field
ShieldSlamTracker = setmetatable({}, { __index = CooldownTracker })
ShieldSlamTracker.__index = ShieldSlamTracker

--- @return ShieldSlamTracker
function ShieldSlamTracker.new()
    --- @class ShieldSlamTracker
    local self = CooldownTracker.new()
    setmetatable(self, ShieldSlamTracker)
    self.shieldSlamUpUntill = 0
    self.shieldSlamIsUp = Helpers:HasBuff("player", "Ability_Warrior_ShieldMastery")
    return self
end

function ShieldSlamTracker:subscribe()
    CooldownTracker.subscribe(self)
    self.shieldSlamUpUntill = 0
    self.shieldSlamIsUp = Helpers:HasBuff("player", "Ability_Warrior_ShieldMastery")
end

--- @param event string
--- @param arg1 string
function ShieldSlamTracker:onEvent(event, arg1)
    if event == "PLAYER_DEAD" then
        self.shieldSlamIsUp = false
        self.shieldSlamUpUntill = GetTime()
    elseif event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" and string.find(arg1, "Improved Shield Slam") then
        Logging:Debug("Improved Shield Slam is up")
        self.shieldSlamIsUp = true
    elseif event == "CHAT_MSG_SPELL_AURA_GONE_SELF" and string.find(arg1, "Improved Shield Slam") then
        Logging:Debug("Improved Shield Slam is down")
        self.shieldSlamIsUp = false
        self.shieldSlamUpUntill = GetTime() + 0.5
    end
end

--- @return boolean
function ShieldSlamTracker:ShouldCast()
    return self.shieldSlamUpUntill < GetTime() and not self.shieldSlamIsUp
end
