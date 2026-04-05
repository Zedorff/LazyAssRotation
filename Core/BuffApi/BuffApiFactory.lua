BuffApiFactory = {}

local instance

--- @return BuffApi|NampowerBuffApi|VanillaBuffApi
function BuffApiFactory.GetInstance()
    if instance then
        return instance
    end
    if Helpers:HasNampowerAuraCastEvents() then
        Helpers:EnsureNampowerAuraCastEventsEnabled()
        instance = NampowerBuffApi.new()
    else
        instance = VanillaBuffApi.new()
    end
    return instance
end
