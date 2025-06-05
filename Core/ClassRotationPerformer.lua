ClassRotationPerformer = {}

--- @param context ModuleRunContext
function ClassRotationPerformer:PerformRotation(context)
    local highestPrio = -1
    --- @type Module
    local bestModule = nil

    local modules = ModuleRegistry:GetEnabledModules()
    for _, mod in pairs(modules) do
        --- @cast mod Module
        local prio = mod.getPriority and mod:getPriority(context)
        if prio and prio > highestPrio then
            highestPrio = prio
            bestModule = mod
        end
    end

    if bestModule then
        bestModule:run()
        if LARShowRotationSpells then
            HotSwap_SetDraggableButtonIcon(bestModule.iconPath)
        end
    else
        if LARShowRotationSpells then
            HotSwap_SetDraggableButtonIcon("Interface\\Icons\\INV_Misc_QuestionMark")
        end
    end
end