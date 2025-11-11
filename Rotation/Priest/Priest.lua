--- @class Priest : ClassRotation
--- @field cache ManaCostCache
--- @field spec PriestSpec
--- @diagnostic disable: duplicate-set-field
Priest = setmetatable({}, { __index = ClassRotation })
Priest.__index = Priest

--- @return Priest
function Priest.new()
    --- @class Priest
    local self = ClassRotation.new(ManaCostCache.new())
    setmetatable(self, Priest)

    local specs = {
        SpecButtonInfo.new("Interface\\Icons\\Spell_Holy_HolySmite", "Smite", LARSelectedSpec == nil or LARSelectedSpec.name == "Smite"),
        SpecButtonInfo.new("Interface\\Icons\\Spell_Shadow_UnsummonBuilding", "Shadow", LARSelectedSpec == nil or LARSelectedSpec.name == "Shadow"),
    }

    if not LARSelectedSpec then
        LARSelectedSpec = specs[1]
    end

    self:SelectSpec(LARSelectedSpec)

    HotSwap_CreateSpecButtons(specs)

    PriestModuleRunContext.PreheatCache(self.cache)
    return self
end

function Priest:execute()
    ClassRotationPerformer:PerformRotation(PriestModuleRunContext.new(self.cache))
end

function Priest:Preheat()
    PriestModuleRunContext.PreheatCache(self.cache)
end

function Priest:SelectSpec(spec)
    ClassRotation.SelectSpec(self, spec)
    if spec.name == "Smite" then
        self.spec = PriestSpec.SMITE
        self:EnableSmiteSpec()
    elseif spec.name == "Shadow" then
        self.spec = PriestSpec.SHADOW
        self:EnableShadowSpec()
    end
    HotSwap_InvalidateModuleButtons()
end

function Priest:EnableSmiteSpec()
    ModuleRegistry:RegisterModule(InnerFireModule.new())
    ModuleRegistry:RegisterModule(HolyFireModule.new())
    ModuleRegistry:RegisterModule(SmiteModule.new())
end

function Priest:EnableShadowSpec()
    ModuleRegistry:RegisterModule(InnerFireModule.new())
    ModuleRegistry:RegisterModule(VampiricModule.new())
    ModuleRegistry:RegisterModule(ShadowWordPainModule.new())
    ModuleRegistry:RegisterModule(MindBlastModule.new())
    ModuleRegistry:RegisterModule(MindFlayModule.new())
end
