--- @class ClawModule : Module
--- @diagnostic disable: duplicate-set-field
ClawModule = setmetatable({}, { __index = Module })
ClawModule.__index = ClawModule

--- @return ClawModule
function ClawModule.new()
    --- @class ClawModule
    return setmetatable(Module.new(ABILITY_CLAW, {}), ClawModule)
end

function ClawModule:run()
    Logging:Debug("Casting "..ABILITY_CLAW)
    CastSpellByName(ABILITY_CLAW)
end

function ClawModule:enable()
    Module.enable(self)
    ModuleRegistry:DisableModule(MODULE_POWERSHIFTING)
    ModuleRegistry:EnableModule(ABILITY_RIP)
    ModuleRegistry:EnableModule(ABILITY_RAKE)
    ModuleRegistry:EnableModule(ABILITY_TIGER_FURY)
end

--- @param context DruidModuleRunContext
function ClawModule:getPriority(context)
    if self.enabled then
        if context.energy > context.clawCost and context.cp < 5 then
            return 85;
        end
    end
    return -1;
end
