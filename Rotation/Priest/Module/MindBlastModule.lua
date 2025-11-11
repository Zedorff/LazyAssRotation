--- @alias MindBlastTrackers { castingTracker: CastingTracker }
--- @class MindBlastModule : Module
--- @diagnostic disable: duplicate-set-field
MindBlastModule = setmetatable({}, { __index = Module })
MindBlastModule.__index = MindBlastModule

--- @return MindBlastModule
function MindBlastModule.new()
    --- @type MindBlastTrackers
    local trackers = {
        castingTracker = CastingTracker.GetInstance(),
    }
    --- @class MindBlastModule
    return setmetatable(Module.new(Abilities.MindBlast.name, trackers, "Interface\\Icons\\Spell_Shadow_ShadowWordDominate"), MindBlastModule)
end

function MindBlastModule:run()
    Logging:Debug("Casting "..Abilities.MindBlast.name)
    CastSpellByName(Abilities.MindBlast.name)
end

--- @param context PriestModuleRunContext
function MindBlastModule:getPriority(context)
    if self.enabled and Helpers:SpellReady(Abilities.MindBlast.name) and self.trackers.castingTracker:ShouldCast() then
        if context.mana >= context.mindBlastCost then
            return 80;
        end
    else
        return -1;
    end
end