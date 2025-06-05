--- @class PummelModule : Module
--- @diagnostic disable: duplicate-set-field
PummelModule = setmetatable({}, { __index = Module })
PummelModule.__index = PummelModule

--- @class PummelModule
function PummelModule.new()
    --- @class PummelModule
    return setmetatable(Module.new(ABILITY_PUMMEL, nil, "Interface\\Icons\\INV_Gauntlets_04"), PummelModule)
end

function PummelModule:run()
    Logging:Debug("Casting "..ABILITY_PUMMEL)
    CastSpellByName(ABILITY_PUMMEL)
end

--- @param context WarriorModuleRunContext
function PummelModule:getPriority(context)
    if self.enabled and context.stance ~= 2 then
        if Helpers:SpellReady(ABILITY_PUMMEL) and context.rage >= 90 then
            return 20
        else
            return -1;
        end
    end
    return -1;
end
