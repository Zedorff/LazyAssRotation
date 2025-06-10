--- @alias ImmolateTrackers { immolateTracker: ImmolateTracker }
--- @class ImmolateModule : Module
--- @field trackers ImmolateTrackers
--- @diagnostic disable: duplicate-set-field
ImmolateModule = setmetatable({}, { __index = Module })
ImmolateModule.__index = ImmolateModule

--- @return ImmolateModule
function ImmolateModule.new()
    --- @type ImmolateTrackers
    local trackers = {
        immolateTracker = ImmolateTracker.new()
    }
    --- @class ImmolateModule
    return setmetatable(Module.new(ABILITY_IMMOLATE, trackers, "Interface\\Icons\\Spell_Fire_Immolation"), ImmolateModule)
end

function ImmolateModule:run()
    Logging:Debug("Casting "..ABILITY_IMMOLATE)
    CastSpellByName(ABILITY_IMMOLATE)
end

--- @param context WarlockModuleRunContext
function ImmolateModule:getPriority(context)
    if self.enabled and Helpers:SpellReady(ABILITY_IMMOLATE) then
        if self.trackers.immolateTracker:ShouldCast() and context.mana > context.immolateCost then
            return 80;
        end
    end
    return -1;
end
