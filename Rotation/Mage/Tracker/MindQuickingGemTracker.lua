--- @class MindQuickingGemTracker : CooldownTracker
--- @field mqgIsUp boolean
--- @diagnostic disable: duplicate-set-field
MindQuickingGemTracker = setmetatable({}, { __index = CooldownTracker })
MindQuickingGemTracker.__index = MindQuickingGemTracker

--- @return MindQuickingGemTracker
function MindQuickingGemTracker.new()
    --- @class MindQuickingGemTracker
    local self = CooldownTracker.new()
    setmetatable(self, MindQuickingGemTracker)
    self.arcanePowerIsUp = Helpers:HasBuff("player", "Spell_Nature_WispHeal")
    return self
end

function MindQuickingGemTracker:subscribe()
    CooldownTracker.subscribe(self)
    self.mqgIsUp = Helpers:HasBuff("player", "Spell_Nature_WispHeal")
end

--- @param event string
--- @param arg1 string
function MindQuickingGemTracker:onEvent(event, arg1)
    if event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" and string.find(arg1, ITEM_MQG) then
        Logging:Debug(ITEM_MQG.." is up")
        self.mqgIsUp = true
    elseif event == "CHAT_MSG_SPELL_AURA_GONE_SELF" and string.find(arg1, ITEM_MQG) then
        Logging:Debug(ITEM_MQG.." is down")
        self.mqgIsUp = false
    end 
end

--- @return boolean
function MindQuickingGemTracker:ShouldCast()
    return not self.mqgIsUp
end