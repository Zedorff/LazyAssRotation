--- @alias ChastiseTrackers { chastiseHasteTracker: ChastiseHasteTracker }
--- @class ChastiseModule : Module
--- @field trackers ChastiseTrackers
--- @diagnostic disable: duplicate-set-field
ChastiseModule = setmetatable({}, { __index = Module })
ChastiseModule.__index = ChastiseModule

--- @return ChastiseModule
function ChastiseModule.new()
    --- @type ChastiseTrackers
    local trackers = {
        chastiseHasteTracker = ChastiseHasteTracker.new(),
    }
    --- @class ChastiseModule
    return setmetatable(Module.new(Abilities.Chastise.name, trackers, "Interface\\Icons\\Spell_Holy_UnyieldingFaith"), ChastiseModule)
end

function ChastiseModule:run()
    Logging:Debug("Casting "..Abilities.Chastise.name)
    CastSpellByName(Abilities.Chastise.name, true)
end

--- @param context PriestModuleRunContext
function ChastiseModule:getPriority(context)
    if self.enabled and Helpers:SpellReady(Abilities.Chastise.name) and context.mana > context.chastiseCost and context.hpPercent > 80 then
        return 90;
    end
    return -1;
end
