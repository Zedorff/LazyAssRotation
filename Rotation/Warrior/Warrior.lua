--- @class Warrior : ClassRotation
--- @field cache RageCostCache
--- @field spec WarriorSpec
--- @diagnostic disable: duplicate-set-field
Warrior = setmetatable({}, { __index = ClassRotation })
Warrior.__index = Warrior

--- @return Warrior
function Warrior.new()
    --- @class Warrior
    local instance = ClassRotation.new(RageCostCache.new())
    setmetatable(instance, Warrior)

    instance.spec = GetWarriorSpec()

    ModuleRegistry:RegisterModule(BattleShoutModule.new())
    ModuleRegistry:RegisterModule(ExecuteModule.new())
    ModuleRegistry:RegisterModule(HeroicStrikeModule.new())
    ModuleRegistry:RegisterModule(WhirlwindModule.new())
    ModuleRegistry:RegisterModule(OverpowerModule.new())
    instance:RegisterSpecDependantModules()
    WarriorModuleRunContext.PreheatCache(instance.cache)
    return instance
end

function Warrior:execute()
    ClassRotationPerformer:PerformRotation(WarriorModuleRunContext.new(self.cache, self.spec))
end

--- @return ClassRotation | nil
function Warrior:RegisterSpecDependantModules()
    if self.spec == WarriorSpec.ARMS then
        ModuleRegistry:RegisterModule(RendModule.new())
        ModuleRegistry:RegisterModule(SlamModule.new())
        ModuleRegistry:RegisterModule(MortalStrikeModule.new())
    elseif self.spec == WarriorSpec.FURY then
        ModuleRegistry:RegisterModule(BloodthirstModule.new())
        ModuleRegistry:RegisterModule(HamstringModule.new())
    end
end
