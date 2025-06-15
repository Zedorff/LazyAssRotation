--- @alias SavageBiteTrackers { clearcastingTracker: ClearcastingTracker }
--- @class SavageBiteModule : Module
--- @field trackers SavageBiteTrackers
--- @diagnostic disable: duplicate-set-field
SavageBiteModule = setmetatable({}, { __index = Module })
SavageBiteModule.__index = SavageBiteModule

--- @return SavageBiteModule
function SavageBiteModule.new()
    --- @type SavageBiteTrackers
    local trackers = {
        clearcastingTracker = ClearcastingTracker.GetInstance()
    }
    --- @class SavageBiteModule
    return setmetatable(Module.new(Abilities.SavageBite.name, trackers, "Interface\\Icons\\Ability_Racial_Cannibalize"), SavageBiteModule)
end

function SavageBiteModule:run()
    Logging:Debug("Casting "..Abilities.SavageBite.name)
    CastSpellByName(Abilities.SavageBite.name)
end

--- @param context DruidModuleRunContext
function SavageBiteModule:getPriority(context)
    if self.enabled and Helpers:SpellReady(Abilities.SavageBite.name) then
        if self.trackers.clearcastingTracker:ShouldCast() then
            return 95;
        elseif context.rage >= context.maulCost + context.savageBiteCost then
            return 95;
        end
    end
    return -1;
end
