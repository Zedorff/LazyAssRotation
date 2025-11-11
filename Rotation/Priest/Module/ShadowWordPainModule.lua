--- @alias ShadowWordPainTrackers { shadowWordPainTracker: ShadowWordPainTracker, castingTracker: CastingTracker }
--- @class ShadowWordPainModule : Module
--- @field trackers ShadowWordPainTrackers
--- @diagnostic disable: duplicate-set-field
ShadowWordPainModule = setmetatable({}, { __index = Module })
ShadowWordPainModule.__index = ShadowWordPainModule

--- @return ShadowWordPainModule
function ShadowWordPainModule.new()
    --- @type ShadowWordPainTrackers
    local trackers = {
        shadowWordPainTracker = ShadowWordPainTracker.new(),
        castingTracker = CastingTracker.GetInstance(),
    }
    --- @class ShadowWordPainModule
    return setmetatable(Module.new(Abilities.ShadowWordPain.name, trackers, "Interface\\Icons\\Spell_Shadow_ShadowWordPain"), ShadowWordPainModule)
end

function ShadowWordPainModule:run()
    Logging:Debug("Casting "..Abilities.ShadowWordPain.name)
    CastSpellByName(Abilities.ShadowWordPain.name)
end

--- @param context PriestModuleRunContext
function ShadowWordPainModule:getPriority(context)
    if self.enabled and Helpers:SpellReady(Abilities.ShadowWordPain.name) and self.trackers.shadowWordPainTracker:ShouldCast() and self.trackers.castingTracker:ShouldCast() then
        if context.mana >= context.swpCost then
            return 90;
        end
    else
        return -1;
    end
end