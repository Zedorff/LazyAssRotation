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
    return setmetatable(Module.new(Abilities.HolyStrike.name, trackers, "Interface\\Icons\\INV_Sword_01"), HolyStrikeModule)
end

function HolyStrikeModule:run()
    Logging:Debug("Casting "..Abilities.HolyStrike.name)
    CastSpellByName(Abilities.HolyStrike.name)
end

--- @param context PaladinModuleRunContext
function HolyStrikeModule:getPriority(context)
    if not self.enabled or context.mana < context.holyStrikeCost or not Helpers:SpellReady(Abilities.HolyStrike.name) then
        return -1;
    end

    if context.spec == PaladinSpec.RETRI then
        return self:GetRetriPriority()
    elseif context.spec == PaladinSpec.PROT then
        return self:GetProtPriority()
    end

    return -1;
end

function HolyStrikeModule:GetRetriPriority()
    if not self.trackers.socTacker:ShouldCast() and self.trackers.holyStrikeTracker:ShouldCast() then
        return 75;
    else
        return 50;
    end
end

function HolyStrikeModule:GetProtPriority()
    return 90;
end
