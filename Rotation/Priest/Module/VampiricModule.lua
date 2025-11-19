--- @alias VampiricTrackers { vampiricTracker: VampiricTracker }
--- @class VampiricModule : Module
--- @field trackers VampiricTrackers
--- @diagnostic disable: duplicate-set-field
VampiricModule = setmetatable({}, { __index = Module })
VampiricModule.__index = VampiricModule

--- @return VampiricModule
function VampiricModule.new()
    --- @type VampiricTrackers
    local trackers = {
        vampiricTracker = VampiricTracker.new(),
    }
    --- @class VampiricModule
    return setmetatable(Module.new(Abilities.VampiricEmbrace.name, trackers, "Interface\\Icons\\Spell_Shadow_UnsummonBuilding"), VampiricModule)
end

function VampiricModule:run()
    Logging:Debug("Casting "..Abilities.VampiricEmbrace.name)
    CastSpellByName(Abilities.VampiricEmbrace.name)
end

--- @param context PriestModuleRunContext
function VampiricModule:getPriority(context)
    if self.enabled and Helpers:SpellReady(Abilities.VampiricEmbrace.name) and self.trackers.vampiricTracker:ShouldCast() then
        if context.mana >= context.vampiricCost then
            return 99;
        end
    else
        return -1;
    end
end
