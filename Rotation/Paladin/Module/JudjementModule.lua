--- @class JudjementModule : Module
--- @field judgTracker JudgementTracker
--- @diagnostic disable: duplicate-set-field
JudjementModule = setmetatable({}, { __index = Module })
JudjementModule.__index = JudjementModule

--- @return JudjementModule
function JudjementModule.new()
    --- @class JudjementModule
    local self = Module.new(ABILITY_JUDGEMENT)
    setmetatable(self, JudjementModule)

    self.judgTracker = JudgementTracker.new()

    if self.enabled then
        self.judgTracker:subscribe()
    end

    return self
end

function JudjementModule:enable()
    Module.enable(self)
    self.judgTracker:subscribe()
end

function JudjementModule:disable()
    Module.disable(self)
    self.judgTracker:unsubscribe()
end

function JudjementModule:run()
    Logging:Debug("Casting "..ABILITY_JUDGEMENT)
    CastSpellByName(ABILITY_JUDGEMENT)
end

--- @param context PaladinModuleRunContext
function JudjementModule:getPriority(context)
    if self.enabled and context.mana > context.judjementCost and Helpers:SpellReady(ABILITY_JUDGEMENT) and self.judgTracker:ShouldCast() then
        return 90;
    end
    return -1;
end
