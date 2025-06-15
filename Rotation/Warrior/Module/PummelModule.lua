--- @class PummelModule : Module
--- @diagnostic disable: duplicate-set-field
PummelModule = setmetatable({}, { __index = Module })
PummelModule.__index = PummelModule

--- @class PummelModule
function PummelModule.new()
    --- @class PummelModule
    return setmetatable(Module.new(Abilities.Pummel.name, nil, "Interface\\Icons\\INV_Gauntlets_04"), PummelModule)
end

function PummelModule:run()
    Logging:Debug("Casting "..Abilities.Pummel.name)
    CastSpellByName(Abilities.Pummel.name)
end

--- @param context WarriorModuleRunContext
function PummelModule:getPriority(context)
    if self.enabled and context.stance ~= 2 then
        if Helpers:SpellReady(Abilities.Pummel.name) and context.rage >= 90 then
            return 20
        else
            return -1;
        end
    end
    return -1;
end
