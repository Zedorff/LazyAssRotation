--- @class ShieldSlamModule : Module
--- @diagnostic disable: duplicate-set-field
ShieldSlamModule = setmetatable({}, { __index = Module })
ShieldSlamModule.__index = ShieldSlamModule

--- @return ShieldSlamModule
function ShieldSlamModule.new()
    --- @class ShieldSlamModule
    return setmetatable(Module.new(Abilities.ShieldSlam.name, nil, "Interface\\Icons\\INV_Shield_05"), ShieldSlamModule)
end

function ShieldSlamModule:run()
    Logging:Debug("Casting "..Abilities.ShieldSlam.name)
    CastSpellByName(Abilities.ShieldSlam.name)
end

--- @param context WarriorModuleRunContext
function ShieldSlamModule:getPriority(context)
    if self.enabled then
        if Helpers:SpellReady(Abilities.ShieldSlam.name) and context.rage >= context.shieldSlamCost then
            return 85;
        end
    end
    return -1;
end
