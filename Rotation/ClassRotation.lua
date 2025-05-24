--- @class ClassRotation
--- @field cache ModuleRunCache
ClassRotation = {}
ClassRotation.__index = ClassRotation

--- @param cache ModuleRunCache
--- @return ClassRotation
function ClassRotation.new(cache)
    local obj = {
        cache = cache
    }
    return setmetatable(obj, ClassRotation)
end

function ClassRotation:execute()
    error("execute() not implemented")
end

function ClassRotation:clear()
    self.cache:Clear()
end