NampowerBuffSelfBuff = {}

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
    elseif event == "CHAT_MSG_SPELL_AURA_GONE_SELF" and arg1 and string.find(arg1, tracker.abilityName) then
        ---@type BuffPipelineSelfBuffDownMessage
        local m = { t = "self_buff", kind = BuffPipelineKind.BUFF_DOWN, via_chat = true }
        return m
    end
    return nil
end

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
    elseif event == "CHAT_MSG_SPELL_AURA_GONE_SELF" and arg1 and string.find(arg1, tracker.abilityName) then
        ---@type BuffPipelineDurationedSelfBuffDownMessage
        local m = { t = "durationed_self_buff", kind = BuffPipelineKind.BUFF_DOWN, via_chat = true }
        return m
    end
    return nil
end
