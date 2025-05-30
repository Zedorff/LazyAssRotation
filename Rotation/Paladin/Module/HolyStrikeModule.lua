--- @alias HolyStrikeTrackers { socTacker: SealOfCommandTracker, holyStrikeTracker: HolyStrikeTracker }
--- @class HolyStrikeModule : Module
--- @field trackers HolyStrikeTrackers
--- @diagnostic disable: duplicate-set-field
HolyStrikeModule = setmetatable({}, { __index = Module })
HolyStrikeModule.__index = HolyStrikeModule

--- @return HolyStrikeModule
function HolyStrikeModule.new()
    --- @type HolyStrikeTrackers
    local trackers = {
        socTacker = SealOfCommandTracker.new(),
        holyStrikeTracker = HolyStrikeTracker.new()
    }
    --- @class HolyStrikeModule
    return setmetatable(Module.new(ABILITY_HOLY_STRIKE, trackers, "Interface\\Icons\\INV_Sword_01"), HolyStrikeModule)
end

function HolyStrikeModule:run()
    Logging:Debug("Casting "..ABILITY_HOLY_STRIKE)
    CastSpellByName(ABILITY_HOLY_STRIKE)
end

--- @param context PaladinModuleRunContext
function HolyStrikeModule:getPriority(context)
    local hasMana = context.mana > context.holyStrikeCost
    if not self.enabled or not hasMana then
        return -1;
    end

    if not self.trackers.socTacker:ShouldCast() and self.trackers.holyStrikeTracker:ShouldCast() and Helpers:SpellReady(ABILITY_HOLY_STRIKE) then
        return 75;
    elseif Helpers:SpellReady(ABILITY_HOLY_STRIKE) then
        return 50;
    end

    return -1;
end
