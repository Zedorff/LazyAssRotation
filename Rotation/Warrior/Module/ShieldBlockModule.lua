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
    return setmetatable(Module.new(ABILITY_SHIELD_BLOCK, trackers, "Interface\\Icons\\Ability_Defend"), ShieldBlockModule)
end

function ShieldBlockModule:run()
    Logging:Debug("Casting "..ABILITY_SHIELD_BLOCK)
    CastSpellByName(ABILITY_SHIELD_BLOCK)
end

--- @param context WarriorModuleRunContext
function ShieldBlockModule:getPriority(context)
    if self.enabled and Helpers:SpellReady(ABILITY_SHIELD_BLOCK) then
        if self.trackers.shieldBlockTracker:ShouldCast() and self.trackers.shieldSlamTracker:ShouldCast() then
            return 84;
        end
    end
    return -1;
end
