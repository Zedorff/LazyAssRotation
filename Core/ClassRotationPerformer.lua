--- @alias ModulePrio { module: Module, prio: integer }

ClassRotationPerformer = {}

--- @param context ModuleRunContext
function ClassRotationPerformer:PerformRotation(context)
    local best = nil
    local bestPrio = -1
    local toRun = {}

    for _, module in pairs(ModuleRegistry:GetEnabledModules()) do
        --- @cast module Module
        local prio = module:getPriority(context)
        local isMulti = module:isMultiCastAllowed()

        if prio and prio > bestPrio then
            best = module
            bestPrio = prio
        end

        if prio and prio > 0 and isMulti then
            table.insert(toRun, { module = module, prio = prio })
        end
    end

    if not best or bestPrio <= 0 then
        if LARShowRotationSpells then
            HotSwap_SetDraggableButtonIcon("Interface\\Icons\\INV_Misc_QuestionMark")
        end
        return
    end

    -- First run the best module
    best:run()

    -- Then run allowed multicast modules that aren't the best
    for _, entry in ipairs(toRun) do
        if entry.module ~= best then
            entry.module:run()
        end
    end

    if LARShowRotationSpells then
        HotSwap_SetDraggableButtonIcon(best.iconPath)
    end
end