--- @alias MindFlayTrackers { castingTracker: CastingTracker }
--- @class MindFlayModule : Module
--- @field trackers MindFlayTrackers
--- @diagnostic disable: duplicate-set-field
MindFlayModule = setmetatable({}, { __index = Module })
MindFlayModule.__index = MindFlayModule

--- @return MindFlayModule
function MindFlayModule.new()
    --- @type MindFlayTrackers
    local trackers = {
        castingTracker = CastingTracker.GetInstance(),
    }
    --- @class MindFlayModule
    return setmetatable(Module.new(Abilities.MindFlay.name, trackers, "Interface\\Icons\\Spell_Shadow_SiphonMana"), MindFlayModule)
end

function MindFlayModule:run()
    Logging:Debug("Casting "..Abilities.MindFlay.name)
    CastSpellByName(Abilities.MindFlay.name)
end

--- @param context PriestModuleRunContext
function MindFlayModule:getPriority(context)
    if self.enabled and Helpers:SpellReady(Abilities.MindFlay.name) and self.trackers.castingTracker:ShouldCast() then
        if context.mana >= context.mindFlayCost then
            return 70;
        end
    else
        return -1;
    end
end