--- @class ModuleRunContext
ModuleRunContext = {}
ModuleRunContext.__index = ModuleRunContext

--- @return ModuleRunContext
function ModuleRunContext.new()
    return setmetatable({}, ModuleRunContext)
end

--- @param cache ModuleRunCache
function ModuleRunContext.PreheatCache(cache)
    error("(PreheatCache) is not implemented")
end