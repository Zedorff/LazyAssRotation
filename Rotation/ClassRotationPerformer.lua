ClassRotationPerformer = {}

function ClassRotationPerformer:PerformRotation()
    local highestPrio = -1
    local bestModule = nil

    local modules = ModuleRegistry:GetEnabledModules()
    for _, mod in pairs(modules) do
        local prio = mod.getPriority and mod:getPriority()
        if prio and prio > highestPrio then
            highestPrio = prio
            bestModule = mod
        end
    end

    if bestModule then
        bestModule:run()
    end
end