--- @class MindQuickingGemTracker : SelfBuffTracker
--- @diagnostic disable: duplicate-set-field
MindQuickingGemTracker = setmetatable({}, { __index = SelfBuffTracker })
MindQuickingGemTracker.__index = MindQuickingGemTracker

--- @return MindQuickingGemTracker
function MindQuickingGemTracker.new()
    --- @class MindQuickingGemTracker
    local self = SelfBuffTracker.new(ITEM_MQG, "Spell_Nature_WispHeal")
    setmetatable(self, MindQuickingGemTracker)
    return self
end
