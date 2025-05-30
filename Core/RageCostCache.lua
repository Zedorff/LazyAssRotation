--- @class RageCostCache : ModuleRunCache
RageCostCache = setmetatable({}, { __index = ModuleRunCache })
RageCostCache.__index = RageCostCache

--- @return RageCostCache
function RageCostCache.new()
    --- @type RageCostCache
    return setmetatable(ModuleRunCache.new(), RageCostCache)
end

--- @param identifier any
--- @return any
function RageCostCache:Get(identifier)
    if self.cache[identifier] then
        return self.cache[identifier]
    end

    local cost = Helpers:ParseIntViaTooltip(identifier, RAGE_DESCRIPTION_REGEX)
    self.cache[identifier] = cost
    return cost
end