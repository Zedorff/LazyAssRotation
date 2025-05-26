--- @class SealOfRighteousnessTracker : CooldownTracker
--- @field sorIsUp boolean
--- @diagnostic disable: duplicate-set-field
SealOfRighteousnessTracker = setmetatable({}, { __index = CooldownTracker })
SealOfRighteousnessTracker.__index = SealOfRighteousnessTracker

--- @return SealOfRighteousnessTracker
function SealOfRighteousnessTracker.new()
    --- @class SealOfRighteousnessTracker
    local self = CooldownTracker.new()
    setmetatable(self, SealOfRighteousnessTracker)
    self.sorIsUp = Helpers:HasBuff("player", "Ability_ThunderBolt")
    return self
end

function SealOfRighteousnessTracker:subscribe()
    CooldownTracker.subscribe(self)
    self.sorIsUp = Helpers:HasBuff("player", "Ability_ThunderBolt")
end

--- @param event string
--- @param arg1 string
function SealOfRighteousnessTracker:onEvent(event, arg1)
    if event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" and string.find(arg1, ABILITY_SEAL_RIGHTEOUSNESS) then
        Logging:Debug(ABILITY_SEAL_RIGHTEOUSNESS.." is up")
        self.sorIsUp = true
    elseif event == "CHAT_MSG_SPELL_AURA_GONE_SELF" and string.find(arg1, ABILITY_SEAL_RIGHTEOUSNESS) then
        Logging:Debug(ABILITY_SEAL_RIGHTEOUSNESS.." is down")
        self.sorIsUp = false
    end 
end

--- @return boolean
function SealOfRighteousnessTracker:ShouldCast()
    return not self.sorIsUp
end
