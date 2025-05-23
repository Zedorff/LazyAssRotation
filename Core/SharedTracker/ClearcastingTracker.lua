MLDps = MLDps or {}

--- @class ClearcastingTracker : CooldownTracker
--- @field buffIsUp boolean
--- @diagnostic disable: duplicate-set-field
ClearcastingTracker = setmetatable({}, { __index = CooldownTracker })
ClearcastingTracker.__index = ClearcastingTracker

function ClearcastingTracker.new()
    local obj = {
        buffIsUp = Helpers:HasBuff("player", "Spell_Nature_Lightning")
    }

    return setmetatable(obj, ClearcastingTracker)
end

function ClearcastingTracker:subscribe()
    CooldownTracker.subscribe(self)
    self.buffIsUp = Helpers:HasBuff("player", "Spell_Nature_Lightning")
end

--- @param event string
--- @param arg1 string
function ClearcastingTracker:onEvent(event, arg1)
    if event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" and string.find(arg1, PASSIVE_CLEARCASTING) then
        Logging:Debug("Clearcasting is up")
        self.buffIsUp = true
    elseif event == "CHAT_MSG_SPELL_AURA_GONE_SELF" and string.find(arg1, PASSIVE_CLEARCASTING) then
        Logging:Debug("Clearcasting is down")
        self.buffIsUp = false
    end 
end

--- @return boolean
function ClearcastingTracker:isAvailable()
    return self.buffIsUp
end

--- @return number
function ClearcastingTracker:GetWhenAvailable()
    return 0;
end
