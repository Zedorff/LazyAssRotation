NampowerBuffDebuff = {}

--- @param tracker DebuffTracker
--- @param now number
--- @param event string
--- @param arg1 string|nil `AURA_CAST_ON_OTHER`: spell id; `DEBUFF_REMOVED_OTHER`: mob guid; `SPELL_MISS_SELF` (Nampower): caster guid
--- @param arg2 string|nil `AURA_CAST_ON_OTHER`: caster guid; `SPELL_MISS_SELF`: target guid
--- @param arg3 string|nil `AURA_CAST_ON_OTHER`: target guid; `DEBUFF_REMOVED_OTHER`: spell id; `SPELL_MISS_SELF`: spell id
--- @param arg4 unknown|nil `SPELL_MISS_SELF`: miss type
--- @param arg7 unknown|nil `DEBUFF_REMOVED_OTHER`: removal reason (`2` = refresh)
--- @param arg8 unknown|nil `AURA_CAST_ON_OTHER`: duration (ms)
---@return BuffPipelineDebuffApplyMessage|BuffPipelineDebuffRemoveMessage|BuffPipelineDebuffSpellMissMessage|BuffPipelineDebuffClearDataMessage|nil
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
    elseif BuffTrackerLifecycle.ClearsMobScopedStateOnRegen(event) then
        ---@type BuffPipelineDebuffClearDataMessage
        local m = { t = "debuff", kind = BuffPipelineKind.DEBUFF_CLEAR_DATA }
        return m
    end
    return nil
end
