--- @alias ShieldBlockTrackers { shieldBlockTracker: ShieldBlockTracker, shieldSlamTracker: ShieldSlamTracker }
--- @class ShieldBlockModule : Module
--- @field trackers ShieldBlockTrackers
--- @diagnostic disable: duplicate-set-field
ShieldBlockModule = setmetatable({}, { __index = Module })
ShieldBlockModule.__index = ShieldBlockModule

--- @return ShieldBlockModule
function ShieldBlockModule.new()
    --- @type ShieldBlockTrackers
    local trackers = {
        shieldBlockTracker = ShieldBlockTracker.new(),
        shieldSlamTracker = ShieldSlamTracker.new()
    }
    --- @class ShieldBlockModule
    return setmetatable(Module.new(Abilities.ShieldBlock.name, trackers, "Interface\\Icons\\Ability_Defend"), ShieldBlockModule)
end

function ShieldBlockModule:run()
    Logging:Debug("Casting "..Abilities.ShieldBlock.name)
    CastSpellByName(Abilities.ShieldBlock.name)
end

--- @param context WarriorModuleRunContext
function ShieldBlockModule:getPriority(context)
    if self.enabled and not Helpers:SpellReady(Abilities.ShieldSlam.name) and Helpers:SpellReady(Abilities.ShieldBlock.name) then
        if self.trackers.shieldBlockTracker:ShouldCast() and self.trackers.shieldSlamTracker:ShouldCast() then
            return 84;
        end
    end
    return -1;
end
