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
    return setmetatable(Module.new(MODULE_POWERSHIFTING, trackers, "Interface\\Icons\\spell_reshift_2"), PowerShiftingModule)
end

function PowerShiftingModule:run()
    Logging:Debug("Casting "..Abilities.Reshift.name)
    CastSpellByName(Abilities.Reshift.name)
end

--- @param context DruidModuleRunContext
function PowerShiftingModule:getPriority(context)
    if self.enabled then
        local haveMana = self.trackers.druidManaTracker:GetDruidMana() > context.reshiftCost
        if haveMana and self.trackers.energyTickTracker:GetNextEnergyTick() < 1 and context.energy <= 27 and Helpers:SpellReady(Abilities.Reshift.name) then
            return 100;
        end
    end
    return -1;
end
