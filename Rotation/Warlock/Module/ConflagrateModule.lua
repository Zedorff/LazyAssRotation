--- @alias ConflagrateTrackers { immolateTracker: ImmolateTracker }
--- @class ConflagrateModule : Module
--- @field trackers ConflagrateTrackers
--- @diagnostic disable: duplicate-set-field
ConflagrateModule = setmetatable({}, { __index = Module })
ConflagrateModule.__index = ConflagrateModule

--- @return ConflagrateModule
function ConflagrateModule.new()
    --- @type ConflagrateTrackers
    local trackers = {
        immolateTracker = ImmolateTracker.new()
    }
    --- @class ConflagrateModule
    return setmetatable(Module.new(ABILITY_CONFLAGRATE, trackers, "Interface\\Icons\\Spell_Fire_Fireball"), ConflagrateModule)
end

function ConflagrateModule:run()
    Logging:Debug("Casting "..ABILITY_CONFLAGRATE)
    CastSpellByName(ABILITY_CONFLAGRATE)
end

--- @param context WarlockModuleRunContext
function ConflagrateModule:getPriority(context)
    if self.enabled and Helpers:SpellAlmostReady(ABILITY_CONFLAGRATE, 0.3) and not self.trackers.immolateTracker:ShouldCast() and context.mana > context.conflagrateCost then
        return 85;
    end
    return -1;
end
