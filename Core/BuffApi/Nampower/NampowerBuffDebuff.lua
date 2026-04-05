NampowerBuffDebuff = {}

---@return BuffPipelineDebuffApplyMessage|BuffPipelineDebuffRemoveMessage|BuffPipelineDebuffResistLineMessage|BuffPipelineDebuffSpellMissMessage|BuffPipelineDebuffClearDataMessage|nil
function NampowerBuffDebuff.Message(tracker, now, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    if event == "AURA_CAST_ON_OTHER" then
        local spellId = tonumber(arg1)
        local playerGuid = Helpers:GetUnitGUID("player")
        if not playerGuid or not spellId or not arg3 then
            return nil
        end
        if (not tracker.isSharedDebuff) and (arg2 ~= playerGuid) then
            return nil
        end
        if not IsMatchingRank(tracker.ability, spellId) then
            return nil
        end
        ---@type BuffPipelineDebuffApplyMessage
        local m = {
            t = "debuff",
            kind = BuffPipelineKind.DEBUFF_APPLY,
            mobGuid = arg3,
            durationSec = NampowerBuffCommon.DurationSecFromAuraCast(arg8, Helpers:DebuffDuration(tracker.ability.name)),
        }
        return m
    elseif event == "DEBUFF_REMOVED_OTHER" then
        if NampowerBuffCommon.SkipRemovalForRefresh(arg7) then
            return nil
        end
        local spellId = tonumber(arg3)
        local mobGuid = arg1
        if not mobGuid or not spellId or not IsMatchingRank(tracker.ability, spellId) then
            return nil
        end
        ---@type BuffPipelineDebuffRemoveMessage
        local m = { t = "debuff", kind = BuffPipelineKind.DEBUFF_REMOVE, mobGuid = mobGuid }
        return m
    elseif event == "UNIT_CASTEVENT" then
        return nil
    elseif event == "SPELL_MISS_SELF" then
        ---@type BuffPipelineDebuffSpellMissMessage
        local m = { t = "debuff", kind = BuffPipelineKind.DEBUFF_SPELL_MISS, casterGuid = arg1, targetGuid = arg2, spellId = arg3, missInfo = arg4 }
        return m
    elseif event == "CHAT_MSG_SPELL_SELF_DAMAGE" or event == "CHAT_MSG_COMBAT_SELF_MISSES" then
        ---@type BuffPipelineDebuffResistLineMessage
        local m = { t = "debuff", kind = BuffPipelineKind.DEBUFF_RESIST_LINE, line = arg1 }
        return m
    elseif event == "CHAT_MSG_SPELL_AURA_GONE_OTHER" and arg1 then
        if not string.find(arg1, "fades from", 1, true) then
            return nil
        end
        if not string.find(arg1, tracker.ability.name, 1, true) then
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
        ---@type BuffPipelineDebuffRemoveMessage
        local m = { t = "debuff", kind = BuffPipelineKind.DEBUFF_REMOVE, mobGuid = mobGuid }
        return m
    elseif BuffTrackerLifecycle.ClearsMobScopedStateOnRegen(event) then
        ---@type BuffPipelineDebuffClearDataMessage
        local m = { t = "debuff", kind = BuffPipelineKind.DEBUFF_CLEAR_DATA }
        return m
    end
    return nil
end
