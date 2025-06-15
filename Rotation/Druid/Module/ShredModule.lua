--- @alias ShredTrackers { clearCastingTracker: ClearcastingTracker, notBehindTargetTracker: NotBehindTargetTracker }
--- @class ShredModule : Module
--- @field trackers ShredTrackers
--- @diagnostic disable: duplicate-set-field
ShredModule = setmetatable({}, { __index = Module })
ShredModule.__index = ShredModule

--- @return ShredModule
function ShredModule.new()
    --- @type ShredTrackers
    local trackers = {
        clearCastingTracker = ClearcastingTracker.GetInstance(),
        notBehindTargetTracker = NotBehindTargetTracker.new()
    }
    --- @class ShredModule
    return setmetatable(Module.new(Abilities.Shred.name, trackers, "Interface\\Icons\\Spell_Shadow_VampiricAura"), ShredModule)
end

function ShredModule:run()
    Logging:Debug("Casting "..Abilities.Shred.name)
    CastSpellByName(Abilities.Shred.name)
end

--- @param context DruidModuleRunContext
function ShredModule:getPriority(context)
    if self.enabled and Helpers:SpellReady(Abilities.Shred.name) then
        if self.trackers.notBehindTargetTracker:GetLastAttemptTime() < 0.2 then
            return -1;
        end

        if self.trackers.clearCastingTracker:ShouldCast() then
            return 110;
        end
        local hasEnergy = context.energy >= context.shredCost;
        local psEnabled = ModuleRegistry:IsModuleEnabled(MODULE_POWERSHIFTING)
        if psEnabled and context.cp == 5 and context.energy >= 55 then
            return 91;
        elseif psEnabled and hasEnergy and context.cp < 5 then
            return 83;
        end
    end
    return -1;
end
