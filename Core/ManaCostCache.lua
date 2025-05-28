--- @class ManaCostCache : ModuleRunCache
ManaCostCache = setmetatable({}, { __index = ModuleRunCache })
ManaCostCache.__index = ManaCostCache

--- @return ManaCostCache
function ManaCostCache.new()
    --- @type ManaCostCache
    return setmetatable(ModuleRunCache.new(), ManaCostCache)
end

--- @param identifier any
--- @return any
function ManaCostCache:Get(identifier)
    if self.cache[identifier] then
        return self.cache[identifier]
    end

    local cost = Helpers:ParseIntViaTooltip(identifier, MANA_DESCRIPTION_REGEX)
    self.cache[identifier] = cost
    return cost
end
