--- @alias ModulePrio { module: Module, prio: integer }

ClassRotationPerformer = {}

--- @param context ModuleRunContext
function ClassRotationPerformer:PerformRotation(context)
    local best = nil
    local bestPrio = -1

    for _, module in pairs(ModuleRegistry:GetEnabledModules()) do
        --- @cast module Module
        local prio = module:getPriority(context)

        if prio and prio > bestPrio then
            best = module
            bestPrio = prio
        end
    end

    if not best or bestPrio <= 0 then
        if LARShowRotationSpells then
            HotSwap_SetDraggableButtonIcon("Interface\\Icons\\INV_Misc_QuestionMark")
        end
        return
    end

    best:run()

    if LARShowRotationSpells then
        HotSwap_SetDraggableButtonIcon(best.iconPath)
    end
end