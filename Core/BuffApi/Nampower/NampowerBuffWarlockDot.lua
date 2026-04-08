NampowerBuffWarlockDot = {}

--- @param tracker WarlockDotTracker
--- @param now number
--- @param target string|nil current target guid at event time
--- @param event string
--- @param arg1 unknown|nil `AURA_CAST_ON_OTHER`: spell id; `DEBUFF_REMOVED_OTHER`: mob guid; `UNIT_CASTEVENT`: caster guid; `SPELLCAST_CHANNEL_START`: channel duration (ms); `SPELL_MISS_SELF` (Nampower): caster guid
--- @param arg2 unknown|nil `AURA_CAST_ON_OTHER`: caster guid; `SPELL_MISS_SELF`: target guid
--- @param arg3 unknown|nil `AURA_CAST_ON_OTHER`: target guid; `DEBUFF_REMOVED_OTHER`: spell id; `UNIT_CASTEVENT`: subevent (`CAST`|`CHANNEL`); `SPELL_MISS_SELF`: spell id
--- @param arg4 unknown|nil `UNIT_CASTEVENT`: spell id; `SPELL_MISS_SELF`: miss type
--- @param arg7 unknown|nil `DEBUFF_REMOVED_OTHER`: removal reason (`2` = refresh)
--- @param arg8 unknown|nil `AURA_CAST_ON_OTHER`: duration (ms)
---@return BuffPipelineWarlockDotApplyMessage|BuffPipelineWarlockDotRemoveMessage|BuffPipelineWarlockDotDhPendingMessage|BuffPipelineWarlockDotDhChannelStartMessage|BuffPipelineWarlockDotDhChannelStopMessage|BuffPipelineWarlockDotSpellMissMessage|BuffPipelineWarlockDotClearDataMessage|nil
function NampowerBuffWarlockDot.Message(tracker, now, target, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    if event == "AURA_CAST_ON_OTHER" then
        local spellId = tonumber(arg1)
        local playerGuid = Helpers:GetUnitGUID("player")
        if arg2 == playerGuid and arg3 and spellId and IsMatchingRank(tracker.rankedAbility, spellId) then
            ---@type BuffPipelineWarlockDotApplyMessage
            local m = {
                t = "warlock_dot",
                kind = BuffPipelineKind.DEBUFF_APPLY,
                mobGuid = arg3,
                durationSec = NampowerBuffCommon.DurationSecFromAuraCast(arg8, Helpers:SpellDuration(tracker.rankedAbility.name)),
            }
            return m
        end
        return nil
    end

    if event == "DEBUFF_REMOVED_OTHER" then
        if NampowerBuffCommon.SkipRemovalForRefresh(arg7) then
            return nil
        end
        local spellId = tonumber(arg3)
        local mobGuid = arg1
        if not mobGuid or not spellId or not IsMatchingRank(tracker.rankedAbility, spellId) then
            return nil
        end
        ---@type BuffPipelineWarlockDotRemoveMessage
        local m = { t = "warlock_dot", kind = BuffPipelineKind.DEBUFF_REMOVE, mobGuid = mobGuid }
        return m
    end

    if event == "UNIT_CASTEVENT" and arg1 == Helpers:GetUnitGUID("player") then
        if arg3 == "CHANNEL" and IsMatchingRank(Abilities.DarkHarvest, tonumber(arg4)) then
            ---@type BuffPipelineWarlockDotDhPendingMessage
            local m = { t = "warlock_dot", kind = BuffPipelineKind.DH_PENDING_CHANNEL }
            return m
        end
    elseif event == "SPELLCAST_CHANNEL_START" and tracker.pendingChannel then
        ---@type BuffPipelineWarlockDotDhChannelStartMessage
        local m = { t = "warlock_dot", kind = BuffPipelineKind.DH_CHANNEL_START, channelDurationMs = arg1 }
        return m
    elseif event == "SPELLCAST_CHANNEL_STOP" or event == "SPELLCAST_INTERRUPTED" then
        if tracker.dhCasting then
            ---@type BuffPipelineWarlockDotDhChannelStopMessage
            local m = { t = "warlock_dot", kind = BuffPipelineKind.DH_CHANNEL_STOP }
            return m
        end
    elseif event == "SPELL_MISS_SELF" then
        ---@type BuffPipelineWarlockDotSpellMissMessage
        local m = { t = "warlock_dot", kind = BuffPipelineKind.DEBUFF_SPELL_MISS, casterGuid = arg1, targetGuid = arg2, spellId = arg3, missInfo = arg4 }
        return m
    elseif BuffTrackerLifecycle.ClearsMobScopedStateOnRegen(event) then
        ---@type BuffPipelineWarlockDotClearDataMessage
        local m = { t = "warlock_dot", kind = BuffPipelineKind.DEBUFF_CLEAR_DATA }
        return m
    end
    return nil
end
