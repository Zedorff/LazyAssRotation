--- @class RakeTracker : CooldownTracker
--- @field rakeIsUp boolean
--- @diagnostic disable: duplicate-set-field
RakeTracker = setmetatable({}, { __index = CooldownTracker })
RakeTracker.__index = RakeTracker

--- @return RakeTracker
function RakeTracker.new()
    --- @class RakeTracker
    local self = CooldownTracker.new()
    setmetatable(self, RakeTracker)
    self.rakeIsUp = Helpers:HasDebuff("target", "Ability_Druid_Rake")
    return self
end

function RakeTracker:subscribe()
    CooldownTracker.subscribe(self)
    self.rakeIsUp = Helpers:HasDebuff("target", "Ability_Druid_Rake")
end

--- @param event string
--- @param arg1 string
function RakeTracker:onEvent(event, arg1)
    if event == "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE" and string.find(arg1, ABILITY_RAKE) then
        Logging:Debug(ABILITY_RAKE.." is up")
        self.rakeIsUp = true
    elseif event == "CHAT_MSG_SPELL_AURA_GONE_OTHER" and string.find(arg1, ABILITY_RAKE) then
        Logging:Debug(ABILITY_RAKE.." is down")
        self.rakeIsUp = false
    elseif event == "PLAYER_TARGET_CHANGED" then
        self.rakeIsUp = Helpers:HasDebuff("target", "Ability_Druid_Rake")
    end 
end

--- @return boolean
function RakeTracker:ShouldCast()
    return not self.rakeIsUp
end
