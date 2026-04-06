NampowerBuffSelfBuff = {}

--- @param tracker SelfBuffTracker
--- @param event string
--- @param arg1 number|nil `AURA_CAST_ON_SELF`: spell id
--- @param arg3 string|nil `AURA_CAST_ON_SELF`: target unit guid; `BUFF_REMOVED_SELF`: spell id
--- @param arg7 unknown|nil `BUFF_REMOVED_SELF`: removal reason (`2` = refresh)
---@return BuffPipelineSelfBuffUpMessage|BuffPipelineSelfBuffDownMessage|nil
function NampowerBuffSelfBuff.SelfBuffMessage(tracker, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    if event == "AURA_CAST_ON_SELF" then
        local spellId = tonumber(arg1)
        local playerGuid = Helpers:GetUnitGUID("player")
        if spellId and playerGuid and arg3 == playerGuid and Helpers:MatchesSelfBuffSpell(spellId, tracker.buffTexture, tracker.abilityName) then
            ---@type BuffPipelineSelfBuffUpMessage
            local m = { t = "self_buff", kind = BuffPipelineKind.BUFF_UP }
            return m
        end
    elseif event == "BUFF_REMOVED_SELF" then
        if NampowerBuffCommon.SkipRemovalForRefresh(arg7) then
            return nil
        end
        local spellId = tonumber(arg3)
        if spellId and Helpers:MatchesSelfBuffSpell(spellId, tracker.buffTexture, tracker.abilityName) then
            ---@type BuffPipelineSelfBuffDownMessage
            local m = { t = "self_buff", kind = BuffPipelineKind.BUFF_DOWN }
            return m
        end
    end
    return nil
end

--- @param tracker DurationedSelfBuffTracker
--- @param event string
--- @param arg1 number|nil `AURA_CAST_ON_SELF`: spell id
--- @param arg3 string|nil `AURA_CAST_ON_SELF`: target unit guid; `BUFF_REMOVED_SELF`: spell id
--- @param arg7 unknown|nil `BUFF_REMOVED_SELF`: removal reason (`2` = refresh)
--- @param arg8 unknown|nil `AURA_CAST_ON_SELF`: duration (ms)
---@return BuffPipelineDurationedSelfBuffUpMessage|BuffPipelineDurationedSelfBuffDownMessage|nil
function NampowerBuffSelfBuff.DurationedSelfBuffMessage(tracker, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    if event == "AURA_CAST_ON_SELF" then
        local spellId = tonumber(arg1)
        local playerGuid = Helpers:GetUnitGUID("player")
        if spellId and playerGuid and arg3 == playerGuid and Helpers:MatchesSelfBuffSpell(spellId, tracker.buffTexture, tracker.abilityName) then
            local durSec = NampowerBuffCommon.DurationSecFromAuraCast(arg8, tracker.duration)
            ---@type BuffPipelineDurationedSelfBuffUpMessage
            local m = { t = "durationed_self_buff", kind = BuffPipelineKind.BUFF_UP, durationSec = durSec }
            return m
        end
    elseif event == "BUFF_REMOVED_SELF" then
        if NampowerBuffCommon.SkipRemovalForRefresh(arg7) then
            return nil
        end
        local spellId = tonumber(arg3)
        if spellId and Helpers:MatchesSelfBuffSpell(spellId, tracker.buffTexture, tracker.abilityName) then
            ---@type BuffPipelineDurationedSelfBuffDownMessage
            local m = { t = "durationed_self_buff", kind = BuffPipelineKind.BUFF_DOWN }
            return m
        end
    end
    return nil
end
