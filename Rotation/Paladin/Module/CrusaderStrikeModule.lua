--- @alias CrusaderStrikeTrackers { zealTracker: CrusaderStrikeTracker }
--- @class CrusaderStrikeModule : Module
--- @field trackers CrusaderStrikeTrackers
--- @diagnostic disable: duplicate-set-field
CrusaderStrikeModule = setmetatable({}, { __index = Module })
CrusaderStrikeModule.__index = CrusaderStrikeModule

--- @return CrusaderStrikeModule
function CrusaderStrikeModule.new()
    --- @type CrusaderStrikeTrackers
    local trackers = {
        zealTracker = CrusaderStrikeTracker.new()
    }
    --- @class CrusaderStrikeModule
    return setmetatable(Module.new(Abilities.CrusaderStrike.name, trackers, "Interface\\Icons\\Spell_Holy_CrusaderStrike"), CrusaderStrikeModule)
end

function CrusaderStrikeModule:run()
    Logging:Debug("Casting " .. Abilities.CrusaderStrike.name)
    CastSpellByName(Abilities.CrusaderStrike.name)
end

--- @param context PaladinModuleRunContext
function CrusaderStrikeModule:getPriority(context)
    if self.enabled and context.mana > context.crusaderCost and self.trackers.zealTracker:ShouldCast() and Helpers:SpellReady(Abilities.CrusaderStrike.name) then
        return 70;
    end
    return -1;
end
