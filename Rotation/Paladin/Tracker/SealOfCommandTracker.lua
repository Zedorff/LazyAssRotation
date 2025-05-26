--- @class SealOfCommandTracker : CooldownTracker
--- @field socIsUp boolean
--- @diagnostic disable: duplicate-set-field
SealOfCommandTracker = setmetatable({}, { __index = CooldownTracker })
SealOfCommandTracker.__index = SealOfCommandTracker

--- @return SealOfCommandTracker
function SealOfCommandTracker.new()
    --- @class SealOfCommandTracker
    local self = CooldownTracker.new()
    setmetatable(self, SealOfCommandTracker)
    self.socIsUp = Helpers:HasBuff("player", "Ability_Warrior_InnerRage")
    return self
end

function SealOfCommandTracker:subscribe()
    CooldownTracker.subscribe(self)
    self.socIsUp = Helpers:HasBuff("player", "Ability_Warrior_InnerRage")
end

--- @param event string
--- @param arg1 string
function SealOfCommandTracker:onEvent(event, arg1)
    if event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" and string.find(arg1, ABILITY_SEAL_COMMAND) then
        Logging:Debug(ABILITY_SEAL_COMMAND.." is up")
        self.socIsUp = true
    elseif event == "CHAT_MSG_SPELL_AURA_GONE_SELF" and string.find(arg1, ABILITY_SEAL_COMMAND) then
        Logging:Debug(ABILITY_SEAL_COMMAND.." is down")
        self.socIsUp = false
    end
end

--- @return boolean
function SealOfCommandTracker:ShouldCast()
    return not self.socIsUp;
end
