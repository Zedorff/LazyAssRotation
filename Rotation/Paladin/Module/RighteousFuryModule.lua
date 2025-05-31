--- @alias RighteousFuryTrackers { rightneousFuryTracker: RighteousFuryTracker }
--- @class RighteousFuryModule : Module
--- @field trackers RighteousFuryTrackers
--- @diagnostic disable: duplicate-set-field
RighteousFuryModule = setmetatable({}, { __index = Module })
RighteousFuryModule.__index = RighteousFuryModule

--- @return RighteousFuryModule
function RighteousFuryModule.new()
    --- @type RighteousFuryTrackers
    local trackers = {
        rightneousFuryTracker = RighteousFuryTracker.new()
    }
    --- @class RighteousFuryModule
    return setmetatable(Module.new(ABILITY_RIGHTEOUS_FURY, trackers, "Interface\\Icons\\Spell_Holy_SealOfFury"), RighteousFuryModule)
end

function RighteousFuryModule:run()
    Logging:Debug("Casting "..ABILITY_RIGHTEOUS_FURY)
    CastSpellByName(ABILITY_RIGHTEOUS_FURY)
end

--- @param context PaladinModuleRunContext
function RighteousFuryModule:getPriority(context)
    if not self.enabled then
        return -1;
    end

    if self.trackers.rightneousFuryTracker:ShouldCast() then
        return 100;
    end

    return -1;
end
