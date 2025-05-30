--- @class ClawModule : Module
--- @diagnostic disable: duplicate-set-field
ClawModule = setmetatable({}, { __index = Module })
ClawModule.__index = ClawModule

--- @return ClawModule
function ClawModule.new()
    --- @class ClawModule
    return setmetatable(Module.new(ABILITY_CLAW, nil, "Interface\\Icons\\Ability_Druid_Rake"), ClawModule)
end

function ClawModule:run()
    Logging:Debug("Casting "..ABILITY_CLAW)
    CastSpellByName(ABILITY_CLAW)
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
