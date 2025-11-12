--- @alias HolyFireTrackers { holyFireTracker: HolyFireTracker, purifyingFlamesTracker: PurifyingFlamesTracker, castingTracker: CastingTracker }
--- @class HolyFireModule : Module
--- @field trackers HolyFireTrackers
--- @diagnostic disable: duplicate-set-field
HolyFireModule = setmetatable({}, { __index = Module })
HolyFireModule.__index = HolyFireModule

--- @return HolyFireModule
function HolyFireModule.new()
    --- @type HolyFireTrackers
    local trackers = {
        holyFireTracker = HolyFireTracker.new(),
        purifyingFlamesTracker = PurifyingFlamesTracker.new(),
        castingTracker = CastingTracker.GetInstance(),
    }
    --- @class HolyFireModule
    return setmetatable(Module.new(Abilities.HolyFire.name, trackers, "Interface\\Icons\\Spell_Holy_SearingLight"), HolyFireModule)
end

function HolyFireModule:run()
    Logging:Debug("Casting "..Abilities.HolyFire.name)
    CastSpellByName(Abilities.HolyFire.name)
end

--- @param context PriestModuleRunContext
function HolyFireModule:getPriority(context)
    if self.enabled and Helpers:SpellReady(Abilities.HolyFire.name) and self.trackers.castingTracker:ShouldCast() then
        if self.trackers.holyFireTracker:GetRemainingOnTarget() < (Helpers:CastTime(Abilities.Smite.name) + 0.1) and context.mana > context.holyFireCost then
            return 80;
        end
    end
    return -1;
end
