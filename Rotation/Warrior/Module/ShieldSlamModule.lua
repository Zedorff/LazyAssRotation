--- @alias ShieldSlamTrackers { offhandSlotTracker: OffHandSlotTracker }
--- @class ShieldSlamModule : Module
--- @field trackers ShieldSlamTrackers
--- @diagnostic disable: duplicate-set-field
ShieldSlamModule = setmetatable({}, { __index = Module })
ShieldSlamModule.__index = ShieldSlamModule

--- @return ShieldSlamModule
function ShieldSlamModule.new()
    --- @type ShieldSlamTrackers
    local trackers = {
        offhandSlotTracker = OffHandSlotTracker.GetInstance(),
    }
    --- @class ShieldSlamModule
    return setmetatable(Module.new(Abilities.ShieldSlam.name, trackers, "Interface\\Icons\\INV_Shield_05"), ShieldSlamModule)
end

function ShieldSlamModule:run()
    Logging:Debug("Casting "..Abilities.ShieldSlam.name)
    CastSpellByName(Abilities.ShieldSlam.name)
end

function ShieldSlamModule:enable()
    Module.enable(self)
    ModuleRegistry:DisableModule(Abilities.Bloodthirst.name)
end

--- @param context WarriorModuleRunContext
function ShieldSlamModule:getPriority(context)
    if self.enabled and self.trackers.offhandSlotTracker:isShieldEquipped() then
        if Helpers:SpellReady(Abilities.ShieldSlam.name) and context.rage >= context.shieldSlamCost then
            return 85;
        end
    end
    return -1;
end
