--- @class Paladin : ClassRotation
--- @field cache ManaCostCache
--- @field spec PaladinSpec
--- @diagnostic disable: duplicate-set-field
Paladin = setmetatable({}, { __index = ClassRotation })
Paladin.__index = Paladin

--- @return Paladin
function Paladin.new()
    --- @class Paladin
    local self = ClassRotation.new(ManaCostCache.new())
    setmetatable(self, Paladin)

    local specs = {
        SpecButtonInfo.new("Interface\\Icons\\INV_Sword_01", "Retrodin", LARSelectedSpec == nil or LARSelectedSpec.name == "Retrodin"),
        SpecButtonInfo.new("Interface\\Icons\\Spell_Holy_BlessingOfProtection", "Prot", LARSelectedSpec == nil or LARSelectedSpec.name == "Prot")
    }

    if not LARSelectedSpec then
        LARSelectedSpec = specs[1]
    end

    self:SelectSpec(LARSelectedSpec)

    HotSwap_CreateSpecButtons(specs)

    PaladinModuleRunContext.PreheatCache(self.cache)
    return self
end

function Paladin:execute()
    ClassRotationPerformer:PerformRotation(PaladinModuleRunContext.new(self.cache, self.spec))
end

function Paladin:Preheat()
    PaladinModuleRunContext.PreheatCache(self.cache)
end

function Paladin:SelectSpec(spec)
    ClassRotation.SelectSpec(self, spec)
    if spec.name == "Retrodin" then
        self.spec = PaladinSpec.RETRI
        self:EnableRetrodinSpec()
    elseif spec.name == "Prot" then
        self.spec = PaladinSpec.PROT
        self:EnableProtSpec()
    end
    HotSwap_InvalidateModuleButtons()
end

function Paladin:EnableRetrodinSpec()
    ModuleRegistry:RegisterModule(ConsecrationModule.new())
    ModuleRegistry:RegisterModule(CrusaderStrikeModule.new())
    ModuleRegistry:RegisterModule(HolyStrikeModule.new())
    ModuleRegistry:RegisterModule(JudjementModule.new())
    ModuleRegistry:RegisterModule(RepentanceModule.new())
    ModuleRegistry:RegisterModule(SealOfCommandModule.new())
    ModuleRegistry:RegisterModule(SealOfRighteousnessModule.new())
    ModuleRegistry:RegisterModule(SealOfCrusaderTargetModule.new())
    ModuleRegistry:RegisterModule(SealOfWisdomTargetModule.new())
    ModuleRegistry:RegisterModule(ExcorcismModule.new())
end

function Paladin:EnableProtSpec()
    ModuleRegistry:RegisterModule(HolyStrikeModule.new())
    ModuleRegistry:RegisterModule(JudjementModule.new())
    ModuleRegistry:RegisterModule(SealOfWisdomTargetModule.new())
    ModuleRegistry:RegisterModule(HolyShieldModule.new())
    ModuleRegistry:RegisterModule(RighteousFuryModule.new())
    ModuleRegistry:RegisterModule(SealOfRighteousnessModule.new())
    ModuleRegistry:RegisterModule(ExcorcismModule.new())
end
