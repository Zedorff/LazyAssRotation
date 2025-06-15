--- @alias JudjementTrackers { judgTracker: JudgementTracker }
--- @class JudjementModule : Module
--- @field trackers JudjementTrackers
--- @diagnostic disable: duplicate-set-field
JudjementModule = setmetatable({}, { __index = Module })
JudjementModule.__index = JudjementModule

--- @return JudjementModule
function JudjementModule.new()
    --- @type JudjementTrackers
    local trackers = {
        judgTracker = JudgementTracker.new()
    }
    --- @class JudjementModule
    return setmetatable(Module.new(Abilities.Judgement.name, trackers, "Interface\\Icons\\Spell_Holy_RighteousFury"), JudjementModule)
end

function JudjementModule:run()
    Logging:Debug("Casting "..Abilities.Judgement.name)
    CastSpellByName(Abilities.Judgement.name)
end

--- @param context PaladinModuleRunContext
function JudjementModule:getPriority(context)
    if self.enabled and context.remainingManaPercents > 15 and Helpers:SpellReady(Abilities.Judgement.name) and self.trackers.judgTracker:ShouldCast() then
        return 90;
    end
    return -1;
end
