--- @alias OverpowertTrackers { overpowerTracker: OverpowerTracker }
--- @class OverpowerModule : Module
--- @field trackers OverpowertTrackers
--- @diagnostic disable: duplicate-set-field
OverpowerModule = setmetatable({}, { __index = Module })
OverpowerModule.__index = OverpowerModule

--- @return OverpowerModule
function OverpowerModule.new()
    --- @type OverpowertTrackers
    local trackers = {
        overpowerTracker = OverpowerTracker.new()
    }
    --- @class OverpowerModule
    return setmetatable(Module.new(Abilities.Overpower.name, trackers, "Interface\\Icons\\Ability_MeleeDamage"), OverpowerModule)
end

function OverpowerModule:run()
    Logging:Debug("Casting "..Abilities.Overpower.name)
    CastSpellByName(Abilities.Overpower.name)
end

--- @param context WarriorModuleRunContext
function OverpowerModule:getPriority(context)
    if self.enabled and context.stance == 1 then
        if self.trackers.overpowerTracker:ShouldCast() and Helpers:SpellReady(Abilities.Overpower.name) and context.rage >= 5 then
            return 90
        else
            return -1;
        end
    end
end
