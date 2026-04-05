VanillaBuffDot = {}

---@return BuffPipelineDotApplyMessage|BuffPipelineDotRemoveMessage|BuffPipelineDotResistLineMessage|BuffPipelineDotSpellMissMessage|BuffPipelineDotClearDataMessage|nil
function VanillaBuffDot.Message(tracker, now, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    local target = Helpers:GetUnitGUID("target")
    if event == "UNIT_CASTEVENT" and arg1 == Helpers:GetUnitGUID("player") and arg3 == "CAST" and IsMatchingRank(tracker.rankedAbility, tonumber(arg4)) then
        ---@type BuffPipelineDotApplyMessage
        local m = {
            t = "dot",
            kind = BuffPipelineKind.DEBUFF_APPLY,
            mobGuid = target,
            durationSec = Helpers:SpellDuration(tracker.rankedAbility.name),
        }
        return m
    elseif event == "CHAT_MSG_SPELL_SELF_DAMAGE" or event == "CHAT_MSG_COMBAT_SELF_MISSES" then
        ---@type BuffPipelineDotResistLineMessage
        local m = { t = "dot", kind = BuffPipelineKind.DEBUFF_RESIST_LINE, line = arg1 }
        return m
    elseif event == "CHAT_MSG_SPELL_AURA_GONE_OTHER" and arg1 then
        if not string.find(arg1, "fades from", 1, true) then
            return nil
        end
        if not string.find(arg1, tracker.rankedAbility.name, 1, true) then
            return nil
        end
        local targetName = UnitName("target")
        if not targetName or not string.find(arg1, targetName, 1, true) then
            return nil
        end
        local mobGuid = Helpers:GetUnitGUID("target")
        if not mobGuid then
            return nil
        end
        ---@type BuffPipelineDotRemoveMessage
        local m = { t = "dot", kind = BuffPipelineKind.DEBUFF_REMOVE, mobGuid = mobGuid }
        return m
    elseif event == "SPELL_MISS_SELF" then
        ---@type BuffPipelineDotSpellMissMessage
        local m = { t = "dot", kind = BuffPipelineKind.DEBUFF_SPELL_MISS, casterGuid = arg1, targetGuid = arg2, spellId = arg3, missInfo = arg4 }
        return m
    elseif BuffTrackerLifecycle.ClearsMobScopedStateOnRegen(event) then
        ---@type BuffPipelineDotClearDataMessage
        local m = { t = "dot", kind = BuffPipelineKind.DEBUFF_CLEAR_DATA }
        return m
    end
    return nil
end
