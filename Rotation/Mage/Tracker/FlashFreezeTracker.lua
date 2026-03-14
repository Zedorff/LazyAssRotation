--- @class FlashFreezeTracker : SelfBuffTracker
--- @diagnostic disable: duplicate-set-field
FlashFreezeTracker = setmetatable({}, { __index = SelfBuffTracker })
FlashFreezeTracker.__index = FlashFreezeTracker

--- @return FlashFreezeTracker
function FlashFreezeTracker.new()
    --- @class FlashFreezeTracker
    local self = SelfBuffTracker.new(PASSIVE_FLASH_FREEZE, "Spell_Fire_FrostResistanceTotem")
    setmetatable(self, FlashFreezeTracker)
    return self
end

--- @return boolean
function FlashFreezeTracker:ShouldCast()
    return self.buffUp
end
