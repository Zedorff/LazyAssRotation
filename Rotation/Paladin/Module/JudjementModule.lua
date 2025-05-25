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
    return setmetatable(Module.new(ABILITY_JUDGEMENT, trackers), JudjementModule)
end

function JudjementModule:run()
    Logging:Debug("Casting "..ABILITY_JUDGEMENT)
    CastSpellByName(ABILITY_JUDGEMENT)
end

--- @param context PaladinModuleRunContext
function JudjementModule:getPriority(context)
    if self.enabled and context.remainingManaPercents > 15 and Helpers:SpellReady(ABILITY_JUDGEMENT) and self.trackers.judgTracker:ShouldCast() then
        return 90;
    end
    return -1;
end
