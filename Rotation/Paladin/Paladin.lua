--- @class Paladin : ClassRotation
--- @field cache ManaCostCache
--- @diagnostic disable: duplicate-set-field
Paladin = setmetatable({}, { __index = ClassRotation })
Paladin.__index = Paladin

--- @return Paladin
function Paladin.new()
    --- @class Paladin
    local self = ClassRotation.new(ManaCostCache.new())
    setmetatable(self, Paladin)

    local specs = {
        SpecButtonInfo.new("Interface\\Icons\\INV_Sword_01", "Retrodin",
            MLDpsSelectedSpec == nil or MLDpsSelectedSpec.name == "Retrodin")
    }

    if not MLDpsSelectedSpec then
        MLDpsSelectedSpec = specs[1]
    end

    self:SelectSpec(MLDpsSelectedSpec)

    MLDps_CreateSpecButtons("TOP", specs)

    PaladinModuleRunContext.PreheatCache(self.cache)
    return self
end

function Paladin:execute()
    ClassRotationPerformer:PerformRotation(PaladinModuleRunContext.new(self.cache))
end

function Paladin:SelectSpec(spec)
    ClassRotation.SelectSpec(self, spec)
    if spec.name == "Retrodin" then
        self:EnableRetrodinSpec()
    end
end

function Paladin:EnableRetrodinSpec()
    ModuleRegistry:RegisterModule(ConsecrationModule.new())
    ModuleRegistry:RegisterModule(CrusaderStrikeModule.new())
    ModuleRegistry:RegisterModule(HolyStrikeModule.new())
    ModuleRegistry:RegisterModule(JudjementModule.new())
    ModuleRegistry:RegisterModule(RepentanceModule.new())
    ModuleRegistry:RegisterModule(SealOfCommandModule.new())
    ModuleRegistry:RegisterModule(SealOfCrusaderTargetModule.new())
    ModuleRegistry:RegisterModule(SealOfRighteousnessModule.new())
    ModuleRegistry:RegisterModule(SealOfWisdomTargetModule.new())
    ModuleRegistry:RegisterModule(ExcorcismModule.new())

    MLDps_CreateModuleButtons("RIGHT", Collection.map(ModuleRegistry:GetOrderedModules(), function(module)
        return ModuleButtonInfo.new(module.iconPath, module.name, module.enabled)
    end))
end
