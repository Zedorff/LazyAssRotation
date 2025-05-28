--- @alias PowerShiftingTrackers { druidManaTracker: DruidManaTracker, energyTickTracker: EnergyTickTracker }
--- @class PowerShiftingModule : Module
--- @field trackers PowerShiftingTrackers
--- @diagnostic disable: duplicate-set-field
PowerShiftingModule = setmetatable({}, { __index = Module })
PowerShiftingModule.__index = PowerShiftingModule

--- @return PowerShiftingModule
function PowerShiftingModule.new()
    --- @type PowerShiftingTrackers
    local trackers = {
        druidManaTracker = DruidManaTracker.new(),
        energyTickTracker = EnergyTickTracker.new()
    }
    --- @class PowerShiftingModule
    return setmetatable(Module.new(MODULE_POWERSHIFTING, trackers, false), PowerShiftingModule)
end

function PowerShiftingModule:enable()
    Module.enable(self)
    ModuleRegistry:DisableModule(ABILITY_RIP)
    ModuleRegistry:DisableModule(ABILITY_RAKE)
    ModuleRegistry:DisableModule(ABILITY_CLAW)
    ModuleRegistry:DisableModule(ABILITY_TIGER_FURY)
end


function PowerShiftingModule:run()
    Logging:Debug("Casting "..ABILITY_CAT_FORM)
    CastSpellByName(ABILITY_CAT_FORM)
end

--- @param context DruidModuleRunContext
function PowerShiftingModule:getPriority(context)
    if self.enabled then
        local haveMana = self.trackers.druidManaTracker:GetDruidMana() > context.catFormCost
        local isDefaultForm = UnitPowerType("player") == 0
        if isDefaultForm then
            return 100;
        end

        if not isDefaultForm and haveMana and self.trackers.energyTickTracker:GetNextEnergyTick() < 1 and context.energy <= 27 and Helpers:SpellReady(ABILITY_CAT_FORM) then
            return 100;
        end
    end
    return -1;
end
