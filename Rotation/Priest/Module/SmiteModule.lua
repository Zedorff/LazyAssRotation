--- @alias SmiteTrackers { castingTracker: CastingTracker }
--- @class SmiteModule : Module
--- @diagnostic disable: duplicate-set-field
SmiteModule = setmetatable({}, { __index = Module })
SmiteModule.__index = SmiteModule

--- @return SmiteModule
function SmiteModule.new()
    --- @type SmiteTrackers
    local trackers = {
        castingTracker = CastingTracker.GetInstance(),
    }
    --- @class SmiteModule
    return setmetatable(Module.new(Abilities.Smite.name, trackers, "Interface\\Icons\\Spell_Holy_HolySmite"), SmiteModule)
end

function SmiteModule:run()
    Logging:Debug("Casting "..Abilities.Smite.name)
    CastSpellByName(Abilities.Smite.name)
end

--- @param context PriestModuleRunContext
function SmiteModule:getPriority(context)
    if self.enabled and Helpers:SpellReady(Abilities.Smite.name) and self.trackers.castingTracker:ShouldCast() and context.mana > context.smiteCost then
        return 50;
    end
    return -1;
end
