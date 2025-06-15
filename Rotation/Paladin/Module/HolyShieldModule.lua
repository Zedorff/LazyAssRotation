--- @alias HolyShieldTrackers { holyShieldTracker: HolyShieldTracker }
--- @class HolyShieldModule : Module
--- @field trackers HolyShieldTrackers
--- @diagnostic disable: duplicate-set-field
HolyShieldModule = setmetatable({}, { __index = Module })
HolyShieldModule.__index = HolyShieldModule

--- @return HolyShieldModule
function HolyShieldModule.new()
    --- @type HolyShieldTrackers
    local trackers = {
        holyShieldTracker = HolyShieldTracker.new()
    }
    --- @class HolyShieldModule
    return setmetatable(Module.new(Abilities.HolyShield.name, trackers, "Interface\\Icons\\Spell_Holy_BlessingOfProtection"), HolyShieldModule)
end

function HolyShieldModule:run()
    Logging:Debug("Casting "..Abilities.HolyShield.name)
    CastSpellByName(Abilities.HolyShield.name)
end

--- @param context PaladinModuleRunContext
function HolyShieldModule:getPriority(context)
    local hasMana = context.mana > context.holyShieldCost
    if not self.enabled or not hasMana then
        return -1;
    end

    if self.trackers.holyShieldTracker:ShouldCast() and Helpers:SpellReady(Abilities.HolyShield.name) then
        return 95;
    end

    return -1;
end
