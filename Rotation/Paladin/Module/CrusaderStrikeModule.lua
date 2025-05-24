--- @class CrusaderStrikeModule : Module
--- @field zealTracker CrusaderStrikeTracker
--- @diagnostic disable: duplicate-set-field
CrusaderStrikeModule = setmetatable({}, { __index = Module })
CrusaderStrikeModule.__index = CrusaderStrikeModule

--- @return CrusaderStrikeModule
function CrusaderStrikeModule.new()
    --- @class CrusaderStrikeModule
    local self = Module.new(ABILITY_CRUSADER_STRIKE)
    setmetatable(self, CrusaderStrikeModule)

    self.zealTracker = CrusaderStrikeTracker.new()

    if self.enabled then
        self.zealTracker:subscribe()
    end

    return self
end

function CrusaderStrikeModule:enable()
    Module.enable(self)
    self.zealTracker:subscribe()
end

function CrusaderStrikeModule:disable()
    Module.disable(self)
    self.zealTracker:unsubscribe()
end

function CrusaderStrikeModule:run()
    Logging:Debug("Casting " .. ABILITY_CRUSADER_STRIKE)
    CastSpellByName(ABILITY_CRUSADER_STRIKE)
end

--- @param context PaladinModuleRunContext
function CrusaderStrikeModule:getPriority(context)
    if self.enabled and context.mana > context.crusaderCost and self.zealTracker:ShouldCast() and Helpers:SpellReady(ABILITY_CRUSADER_STRIKE) then
        return 70;
    end
    return -1;
end
