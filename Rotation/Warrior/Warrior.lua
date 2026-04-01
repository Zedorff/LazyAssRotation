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

    return self
end

function Warrior:execute()
    ClassRotationPerformer:PerformRotation(WarriorModuleRunContext.new(self.cache, self.spec))
end

function Warrior:Preheat()
    WarriorModuleRunContext.PreheatCache(self.cache)
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
    ModuleRegistry:RegisterGroup(1, function()
        ModuleRegistry:RegisterModule(BattleShoutModule.new())
        ModuleRegistry:RegisterModule(BloodthirstFuryModule.new())
        ModuleRegistry:RegisterModule(WhirlwindFuryModule.new())
        ModuleRegistry:RegisterModule(HeroicStrikeFuryModule.new())
        ModuleRegistry:RegisterModule(CleaveFuryModule.new())
    end)
    ModuleRegistry:RegisterGroup(2, "Rage dump", function()
        ModuleRegistry:RegisterModule(HamstringModule.new())
        ModuleRegistry:RegisterModule(SunderArmorFuryModule.new())
    end)
    ModuleRegistry:RegisterGroup(3, function()
        ModuleRegistry:RegisterModule(ExecuteModule.new())
    end)
end

function Warrior:EnableArmsSpec()
    ModuleRegistry:RegisterGroup(1, function()
        ModuleRegistry:RegisterModule(BattleShoutModule.new())
        ModuleRegistry:RegisterModule(SlamModule.new())
        ModuleRegistry:RegisterModule(BloodthirstArmsModule.new())
        ModuleRegistry:RegisterModule(MortalStrikeModule.new())
        ModuleRegistry:RegisterModule(WhirlwindArmsModule.new())
        ModuleRegistry:RegisterModule(RendModule.new())
        ModuleRegistry:RegisterModule(OverpowerModule.new())
        ModuleRegistry:RegisterModule(HeroicStrikeArmsModule.new())
        ModuleRegistry:RegisterModule(CleaveArmsModule.new())
    end)
    ModuleRegistry:RegisterGroup(2, "Rage dump", function()
        ModuleRegistry:RegisterModule(HamstringModule.new())
        ModuleRegistry:RegisterModule(SunderArmorArmsModule.new())
    end)
    ModuleRegistry:RegisterGroup(4, function()
        ModuleRegistry:RegisterModule(ExecuteModule.new())
    end)
end

function Warrior:EnableProtSpec()
    ModuleRegistry:RegisterModule(BattleShoutModule.new())
    ModuleRegistry:RegisterModule(ConcussionBlowModule.new())
    ModuleRegistry:RegisterModule(RevengeModule.new())
    ModuleRegistry:RegisterModule(BloodthirstProtModule.new())
    ModuleRegistry:RegisterModule(ShieldSlamModule.new())
    ModuleRegistry:RegisterModule(HeroicStrikeProtModule.new())
    ModuleRegistry:RegisterModule(CleaveProtModule.new())
    ModuleRegistry:RegisterModule(SunderArmorProtModule.new())
    ModuleRegistry:RegisterModule(ShieldBlockModule.new())
end
