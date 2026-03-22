--- @alias CurseOfAgonyTrackers { coaTracker: CurseOfAgonyTracker, castingTracker: CastingTracker }
--- @class CurseOfAgonyModule : Module
--- @field trackers CurseOfAgonyTrackers
--- @diagnostic disable: duplicate-set-field
CurseOfAgonyModule = setmetatable({}, { __index = Module })
CurseOfAgonyModule.__index = CurseOfAgonyModule

--- @return CurseOfAgonyModule
function CurseOfAgonyModule.new()
    --- @type CurseOfAgonyTrackers
    local trackers = {
        coaTracker = CurseOfAgonyTracker.GetInstance(),
        castingTracker = CastingTracker.GetInstance()
    }
    --- @class CurseOfAgonyModule
    local self = Module.new(Abilities.CoA.name, trackers, "Interface\\Icons\\Spell_Shadow_CurseOfSargeras")
    setmetatable(self, CurseOfAgonyModule)

    return self
end

function CurseOfAgonyModule:enable()
    Module.enable(self)
end

function CurseOfAgonyModule:run()
    _ = SpellStopCasting()
    Logging:Debug("Casting " .. Abilities.CoA.name)
    CastSpellByName(Abilities.CoA.name)
end

--- @param context WarlockModuleRunContext
function CurseOfAgonyModule:getPriority(context)
    if Helpers:ShouldSuppressRangedSpellForLOS() then return -1 end
    if self.enabled
        and Helpers:SpellReady(Abilities.CoA.name)
        and self.trackers.coaTracker:ShouldCast()
        and self.trackers.castingTracker:ShouldCast()
        and context.mana > context.coaCost then
        return 60;
    end
    return -1;
end
