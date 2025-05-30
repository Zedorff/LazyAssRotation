--- @class Warrior : ClassRotation
--- @field cache RageCostCache
--- @field spec WarriorSpec
--- @diagnostic disable: duplicate-set-field
Warrior = setmetatable({}, { __index = ClassRotation })
Warrior.__index = Warrior

--- @return Warrior
function Warrior.new()
    --- @class Warrior
    local self = ClassRotation.new(RageCostCache.new())
    setmetatable(self, Warrior)

    local specs = {
        SpecButtonInfo.new("Interface\\Icons\\Spell_Nature_Bloodlust", "Fury",  MLDpsSelectedSpec == nil or MLDpsSelectedSpec.name == "Fury"),
        SpecButtonInfo.new("Interface\\Icons\\Ability_Warrior_SavageBlow", "Arms", MLDpsSelectedSpec and MLDpsSelectedSpec.name == "Arms")
    }

    if not MLDpsSelectedSpec then
        MLDpsSelectedSpec = specs[1]
    end

    MLDps_CreateSpecButtons("TOP", specs)

    self:SelectSpec(MLDpsSelectedSpec)

    WarriorModuleRunContext.PreheatCache(self.cache)
    return self
end

function Warrior:execute()
    ClassRotationPerformer:PerformRotation(WarriorModuleRunContext.new(self.cache, self.spec))
end

function Warrior:SelectSpec(spec)
    ClassRotation.SelectSpec(self, spec)
    if spec.name == "Fury" then
        self.spec = WarriorSpec.FURY
        self:EnableFurySpec()
    elseif spec.name == "Arms" then
        self.spec = WarriorSpec.ARMS
        self:EnableArmsSpec()
    end
end

function Warrior:EnableFurySpec()
    ModuleRegistry:RegisterModule(BattleShoutModule.new())
    ModuleRegistry:RegisterModule(BloodthirstModule.new())
    ModuleRegistry:RegisterModule(WhirlwindModule.new())
    ModuleRegistry:RegisterModule(HeroicStrikeModule.new())
    ModuleRegistry:RegisterModule(HamstringModule.new())
    ModuleRegistry:RegisterModule(ExecuteModule.new())

    MLDps_CreateModuleButtons("RIGHT", Collection.map(ModuleRegistry:GetOrderedModules(), function(module)
        return ModuleButtonInfo.new(module.iconPath, module.name, module.enabled)
    end))
end

function Warrior:EnableArmsSpec()
    ModuleRegistry:RegisterModule(BattleShoutModule.new())
    ModuleRegistry:RegisterModule(SlamModule.new())
    ModuleRegistry:RegisterModule(MortalStrikeModule.new())
    ModuleRegistry:RegisterModule(WhirlwindModule.new())
    ModuleRegistry:RegisterModule(RendModule.new())
    ModuleRegistry:RegisterModule(OverpowerModule.new())
    ModuleRegistry:RegisterModule(HeroicStrikeModule.new())
    ModuleRegistry:RegisterModule(ExecuteModule.new())

    MLDps_CreateModuleButtons("RIGHT", Collection.map(ModuleRegistry:GetOrderedModules(), function(module)
        return ModuleButtonInfo.new(module.iconPath, module.name, module.enabled)
    end))
end
