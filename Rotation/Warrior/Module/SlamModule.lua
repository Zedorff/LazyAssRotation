--- @class SlamModule : Module
--- @diagnostic disable: duplicate-set-field
SlamModule = setmetatable({}, { __index = Module })
SlamModule.__index = SlamModule


function SlamModule.new()
    local instance = Module.new(ABILITY_SLAM)
    setmetatable(instance, SlamModule)

    if instance.enabled then
        ModuleRegistry:EnableModule("AutoAttack")
    end

    return instance 
end

function SlamModule:enable()
    Module.enable(self)
    ModuleRegistry:EnableModule("AutoAttack")
end

function SlamModule:disable()
    Module.disable(self)
    ModuleRegistry:DisableModule("AutoAttack")
end

function SlamModule:run()
    Logging:Debug("Casting Slam")
    CastSpellByName(ABILITY_SLAM)
end

function SlamModule:getPriority()
    if self.enabled then
        if ModuleRegistry:IsModuleEnabled("AutoAttack") then
            local rage = UnitMana("player");
            local slamCastTime = Helpers:CastTime(ABILITY_SLAM)
            local slamCost = Helpers:RageCost(ABILITY_SLAM);
            local nextSwing = ModuleRegistry.modules["AutoAttack"]:GetNextSwingTime()
            if (nextSwing > slamCastTime) and Helpers:SpellReady(ABILITY_SLAM) and rage >= slamCost then
                return 100;
            else
                return -1;
            end
        else
            return -1;
        end
    else
        return -1;
    end
end
