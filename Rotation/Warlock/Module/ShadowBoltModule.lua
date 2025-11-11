--- @alias ShadowBoltTrackers { nighfallTracker: NightfallTracker }
--- @class ShadowBoltModule : Module
--- @field trackers ShadowBoltTrackers
--- @diagnostic disable: duplicate-set-field
ShadowBoltModule = setmetatable({}, { __index = Module })
ShadowBoltModule.__index = ShadowBoltModule

--- @return ShadowBoltModule
function ShadowBoltModule.new()
    --- @type ShadowBoltTrackers
    local trackers = {
        nighfallTracker = NightfallTracker.new(),
    }
    --- @class ShadowBoltModule
    return setmetatable(Module.new(Abilities.ShadowBolt.name, trackers, "Interface\\Icons\\Spell_Shadow_ShadowBolt"), ShadowBoltModule)
end

function ShadowBoltModule:run()
    Logging:Debug("Casting "..Abilities.ShadowBolt.name)
    CastSpellByName(Abilities.ShadowBolt.name)
end

--- @param context WarlockModuleRunContext
function ShadowBoltModule:getPriority(context)
    if self.enabled and Helpers:SpellReady(Abilities.ShadowBolt.name) and context.mana > context.sbCost then
        if self.trackers.nighfallTracker:ShouldCast() then
            return 100;
        else
            return 50;
        end
    end
    return -1;
end
