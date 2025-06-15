--- @class ClawModule : Module
--- @diagnostic disable: duplicate-set-field
ClawModule = setmetatable({}, { __index = Module })
ClawModule.__index = ClawModule

--- @return ClawModule
function ClawModule.new()
    --- @class ClawModule
    return setmetatable(Module.new(Abilities.Claw.name, nil, "Interface\\Icons\\Ability_Druid_Rake"), ClawModule)
end

function ClawModule:run()
    Logging:Debug("Casting "..Abilities.Claw.name)
    CastSpellByName(Abilities.Claw.name)
end

--- @param context DruidModuleRunContext
function ClawModule:getPriority(context)
    if self.enabled then
        if context.energy > context.clawCost and context.cp < 5 then
            return 50;
        end
    end
    return -1;
end
