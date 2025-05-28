--- @class EnergyCostCache : ModuleRunCache
EnergyCostCache = setmetatable({}, { __index = ModuleRunCache })
EnergyCostCache.__index = EnergyCostCache

function EnergyCostCache.new()
    return setmetatable(ModuleRunCache.new(), EnergyCostCache)
end

--- @param identifier any
--- @return any
function EnergyCostCache:Get(identifier)
    if self.cache[identifier] then
        return self.cache[identifier]
    end

    local cost = Helpers:ParseIntViaTooltip(identifier, ENERGY_DESCRIPTION_REGEX)
    self.cache[identifier] = cost
    return cost
end