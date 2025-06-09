--- @class DebuffTracker : CooldownTracker
--- @field abilityName string
--- @field debuffTexture string
--- @field debuffUp boolean
--- @diagnostic disable: duplicate-set-field
DebuffTracker = setmetatable({}, { __index = CooldownTracker })
DebuffTracker.__index = DebuffTracker

--- @return DebuffTracker
function DebuffTracker.new(abilityName, debuffTexture)
    --- @class DebuffTracker
    local self = CooldownTracker.new()
    setmetatable(self, DebuffTracker)
    self.abilityName = abilityName
    self.debuffTexture = debuffTexture
    self.debuffUp = Helpers:HasDebuff("target", self.debuffTexture)
    return self
end

function DebuffTracker:subscribe()
    CooldownTracker.subscribe(self)
    self.debuffUp = Helpers:HasDebuff("target", self.debuffTexture)
end

--- @param event string
--- @param arg1 string
function DebuffTracker:onEvent(event, arg1)
    if event == "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE" and string.find(arg1, self.abilityName) then
        Logging:Debug(self.abilityName.." is on target")
        self.debuffUp = true
    elseif event == "CHAT_MSG_SPELL_AURA_GONE_OTHER" and string.find(arg1, self.abilityName) then
        local target = UnitName("target")
        if target and string.find(arg1, target) then
            Logging:Debug(self.abilityName.." is not on target")
            self.debuffUp = false
        end
    elseif event == "PLAYER_TARGET_CHANGED" then
        self.debuffUp = Helpers:HasDebuff("target", self.debuffTexture)
    end
end

--- @return boolean
function DebuffTracker:ShouldCast()
    return not self.debuffUp
end
