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
        SpecButtonInfo.new("Interface\\Icons\\Spell_Nature_Bloodlust", "Fury",  LARSelectedSpec == nil or LARSelectedSpec.name == "Fury"),
        SpecButtonInfo.new("Interface\\Icons\\Ability_Warrior_SavageBlow", "Arms", LARSelectedSpec and LARSelectedSpec.name == "Arms"),
        SpecButtonInfo.new("Interface\\Icons\\Ability_Warrior_DefensiveStance", "Prot", LARSelectedSpec and LARSelectedSpec.name == "Prot")
    }

    if not LARSelectedSpec then
        LARSelectedSpec = specs[1]
    end

    HotSwap_CreateSpecButtons(specs)

    self:SelectSpec(LARSelectedSpec)

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
    elseif spec.name == "Prot" then
        self.spec = WarriorSpec.PROT
        self:EnableProtSpec()
    end
    HotSwap_InvalidateModuleButtons()
end

function Warrior:EnableFurySpec()
    ModuleRegistry:RegisterModule(BattleShoutModule.new())
    ModuleRegistry:RegisterModule(BloodthirstModule.new())
    ModuleRegistry:RegisterModule(WhirlwindModule.new())
    ModuleRegistry:RegisterModule(HeroicStrikeModule.new())
    ModuleRegistry:RegisterModule(HamstringModule.new())
    ModuleRegistry:RegisterModule(ExecuteModule.new())
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
end

function Warrior:EnableProtSpec()
    ModuleRegistry:RegisterModule(BattleShoutModule.new())
    ModuleRegistry:RegisterModule(RevengeModule.new())
    ModuleRegistry:RegisterModule(ShieldSlamModule.new())
    ModuleRegistry:RegisterModule(HeroicStrikeModule.new())
    ModuleRegistry:RegisterModule(SunderArmorModule.new())
end
