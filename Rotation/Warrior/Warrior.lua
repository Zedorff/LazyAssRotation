--- @class Warrior : ClassRotation
--- @field proxyRotation ClassRotation | nil
--- @diagnostic disable: duplicate-set-field
Warrior = setmetatable({}, { __index = ClassRotation })
Warrior.__index = Warrior

--- @return Warrior
function Warrior.new()
    ModuleRegistry:RegisterModule(AutoAttackModule.new())
    ModuleRegistry:RegisterModule(BattleShoutModule.new())
    ModuleRegistry:RegisterModule(ExecuteModule.new())
    ModuleRegistry:RegisterModule(HeroicStrikeModule.new())
    ModuleRegistry:RegisterModule(WhirlwindModule.new())
    ModuleRegistry:RegisterModule(OverpowerModule.new())
    Warrior.RegisterSpecDependantModules()
    return setmetatable({}, Warrior)
end

function Warrior:execute()
    if not CheckInteractDistance("target", 3) then
        if ModuleRegistry:IsModuleEnabled(ABILITY_BATTLE_SHOUT) then
            ModuleRegistry.modules[ABILITY_BATTLE_SHOUT]:run()
        end
        Logging:Debug("Too far away!")
        return
    end

    ClassRotationPerformer:PerformRotation()
end

--- @return ClassRotation | nil
function Warrior.RegisterSpecDependantModules()
    local spec = Helpers:GetWarriorSpec()

    if spec == WarriorSpec.ARMS then
        ModuleRegistry:RegisterModule(RendModule.new())
        ModuleRegistry:RegisterModule(SlamModule.new())
        ModuleRegistry:RegisterModule(MortalStrikeModule.new())
    elseif spec == WarriorSpec.FURY then
        ModuleRegistry:RegisterModule(BloodthirstModule.new())
        ModuleRegistry:RegisterModule(HamstringModule.new())
    end
end
