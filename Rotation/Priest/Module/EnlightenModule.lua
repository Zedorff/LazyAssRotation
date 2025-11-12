--- @alias EnlightenTrackers { enlightenTracker: EnlightenTracker }
--- @class EnlightenModule : Module
--- @field trackers EnlightenTrackers
--- @diagnostic disable: duplicate-set-field
EnlightenModule = setmetatable({}, { __index = Module })
EnlightenModule.__index = EnlightenModule
--- @return EnlightenModule
function EnlightenModule.new()
    --- @type EnlightenTrackers
    local trackers = {
        enlightenTracker = EnlightenTracker.new(),
    }
    --- @class EnlightenModule
    return setmetatable(Module.new(Abilities.Enlighten.name, trackers, "Interface\\Icons\\btnholyscriptures"), EnlightenModule)
end

function EnlightenModule:run()
    Logging:Debug("Casting "..Abilities.Enlighten.name)
    CastSpellByName(Abilities.Enlighten.name, true)
end

--- @param context PriestModuleRunContext
function EnlightenModule:getPriority(context)
    if self.enabled and Helpers:SpellReady(Abilities.Enlighten.name) and self.trackers.enlightenTracker:ShouldCast() and context.mana > context.enlightenCost then
        return 100;
    end
    return -1;
end
