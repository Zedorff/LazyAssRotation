BuffApiFactory = {}

local instance

--- @return BuffEventPipeline
function BuffApiFactory.GetInstance()
    if instance then
        return instance
    end
    if Helpers:HasNampowerAuraCastEvents() then
        Helpers:EnsureNampowerAuraCastEventsEnabled()
        instance = BuffEventPipeline.new(NampowerBuffEventAdapter.new())
    else
        instance = BuffEventPipeline.new(VanillaBuffEventAdapter.new())
    end
    return instance
end
