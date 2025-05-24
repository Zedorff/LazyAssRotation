MLDps = MLDps or {}

--- @class WaterShieldTracker : CooldownTracker
--- @field shieldIsUp boolean
--- @diagnostic disable: duplicate-set-field
WaterShieldTracker = setmetatable({}, { __index = CooldownTracker })
WaterShieldTracker.__index = WaterShieldTracker

--- @return WaterShieldTracker
function WaterShieldTracker.new()
    --- @class WaterShieldTracker
    local self = CooldownTracker.new()
    setmetatable(self, WaterShieldTracker)
    self.shieldIsUp = Helpers:HasBuff("player", "Ability_Shaman_WaterShield")
    return self
end

function WaterShieldTracker:subscribe()
    CooldownTracker.subscribe(self)
    self.shieldIsUp = Helpers:HasBuff("player", "Ability_Shaman_WaterShield")
end

--- @param event string
--- @param arg1 string
function WaterShieldTracker:onEvent(event, arg1)
    if event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" and string.find(arg1, ABILITY_WATER_SHIELD) then
        Logging:Debug("Water Shield is up")
        self.shieldIsUp = true
    elseif event == "CHAT_MSG_SPELL_AURA_GONE_SELF" and string.find(arg1, ABILITY_WATER_SHIELD) then
        Logging:Debug("Water Shield is down")
        self.shieldIsUp = false
    end 
end

--- @return boolean
function WaterShieldTracker:isAvailable()
    return not self.shieldIsUp
end

--- @return number
function WaterShieldTracker:GetWhenAvailable()
    return 0;
end
