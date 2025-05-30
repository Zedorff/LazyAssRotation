--- @class ShieldSlamModule : Module
--- @diagnostic disable: duplicate-set-field
ShieldSlamModule = setmetatable({}, { __index = Module })
ShieldSlamModule.__index = ShieldSlamModule

--- @return ShieldSlamModule
function ShieldSlamModule.new()
    --- @class ShieldSlamModule
    return setmetatable(Module.new(ABILITY_SHIELD_SLAM, nil, "Interface\\Icons\\INV_Shield_05"), ShieldSlamModule)
end

function ShieldSlamModule:run()
    Logging:Debug("Casting "..ABILITY_SHIELD_SLAM)
    CastSpellByName(ABILITY_SHIELD_SLAM)
end

--- @param context WarriorModuleRunContext
function ShieldSlamModule:getPriority(context)
    if self.enabled then
        if Helpers:SpellReady(ABILITY_SHIELD_SLAM) and context.rage >= context.shieldSlamCost then
            return 85;
        end
    end
    return -1;
end
