--- @class ClassRotation
--- @field cache ModuleRunCache
--- @field preheated boolean
ClassRotation = {}
ClassRotation.__index = ClassRotation

--- @param cache ModuleRunCache
--- @return ClassRotation
function ClassRotation.new(cache)
    local obj = {
        cache = cache,
        preheated = false
    }
    return setmetatable(obj, ClassRotation)
end

function ClassRotation:execute()
    error("execute() not implemented")
end

function ClassRotation:clear()
    self.cache:Clear()
end

function ClassRotation:PreheatData()
    if not self.preheated then
        self:Preheat()
    end
end

function ClassRotation:Preheat()
    error("Preheat() not implemented")
end

--- @param spec SpecButtonInfo
function ClassRotation:SelectSpec(spec)
    LARSelectedSpec = spec
    HotSwap_SetDraggableButtonIcon(spec.icon)
    Core:ForceUnhook()
    ModuleRegistry:ClearRegistry()
    self.preheated = false
    self.cache:Clear()
end