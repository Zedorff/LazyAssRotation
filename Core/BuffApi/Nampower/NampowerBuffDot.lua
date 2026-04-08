NampowerBuffDot = {}

--- @param tracker DotTracker
--- @param now number
--- @param event string
--- @param arg1 string|nil `AURA_CAST_ON_OTHER`: spell id; `DEBUFF_REMOVED_OTHER`: mob guid; `SPELL_MISS_SELF` (Nampower): caster guid
--- @param arg2 string|nil `AURA_CAST_ON_OTHER`: caster guid; `SPELL_MISS_SELF`: target guid
--- @param arg3 string|nil `AURA_CAST_ON_OTHER`: target guid; `DEBUFF_REMOVED_OTHER`: spell id; `SPELL_MISS_SELF`: spell id
--- @param arg4 unknown|nil `SPELL_MISS_SELF`: miss type
--- @param arg7 unknown|nil `DEBUFF_REMOVED_OTHER`: removal reason (`2` = refresh)
--- @param arg8 unknown|nil `AURA_CAST_ON_OTHER`: duration (ms)
---@return BuffPipelineDotApplyMessage|BuffPipelineDotRemoveMessage|BuffPipelineDotSpellMissMessage|BuffPipelineDotClearDataMessage|nil
function NampowerBuffDot.Message(tracker, now, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    if event == "AURA_CAST_ON_OTHER" then
        local spellId = tonumber(arg1)
        local playerGuid = Helpers:GetUnitGUID("player")
        if arg2 == playerGuid and arg3 and spellId and IsMatchingRank(tracker.rankedAbility, spellId) then
            ---@type BuffPipelineDotApplyMessage
            local m = {
                t = "dot",
                kind = BuffPipelineKind.DEBUFF_APPLY,
                mobGuid = arg3,
                durationSec = NampowerBuffCommon.DurationSecFromAuraCast(arg8, Helpers:SpellDuration(tracker.rankedAbility.name)),
            }
            return m
        end
        return nil
    elseif event == "DEBUFF_REMOVED_OTHER" then
        if NampowerBuffCommon.SkipRemovalForRefresh(arg7) then
            return nil
        end
        local spellId = tonumber(arg3)
        local mobGuid = arg1
        if not mobGuid or not spellId or not IsMatchingRank(tracker.rankedAbility, spellId) then
            return nil
        end
        ---@type BuffPipelineDotRemoveMessage
        local m = { t = "dot", kind = BuffPipelineKind.DEBUFF_REMOVE, mobGuid = mobGuid }
        return m
    elseif event == "UNIT_CASTEVENT" then
        return nil
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
