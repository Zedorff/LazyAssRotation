--- @class ModuleRunCache
--- @field cache table
ModuleRunCache = {}
ModuleRunCache.__index = ModuleRunCache

function ModuleRunCache.new()
    local instance = {
        cache = {},
    }

    return setmetatable(instance, ModuleRunCache)
end

--- @param identifier any
--- @return any
function ModuleRunCache:Get(identifier)
    error("(Get) not implemented")
end

function ModuleRunCache:Clear()
    for k in pairs(self.cache) do
        self.cache[k] = nil
    end
end