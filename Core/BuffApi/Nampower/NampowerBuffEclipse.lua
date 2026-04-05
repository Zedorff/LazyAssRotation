NampowerBuffEclipse = {}

---@return BuffPipelineEclipseArcaneMessage|BuffPipelineEclipseNatureMessage|BuffPipelineEclipseClearMessage|nil
function NampowerBuffEclipse.Message(tracker, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    if event == "AURA_CAST_ON_SELF" then
        local spellId = tonumber(arg1)
        local playerGuid = Helpers:GetUnitGUID("player")
        if spellId and playerGuid and arg3 == playerGuid then
            local durSec = NampowerBuffCommon.DurationSecFromAuraCast(arg8, 15)
            if Helpers:MatchesSelfBuffSpell(spellId, tracker.arcaneBuffTexture, "Arcane Eclipse") then
                ---@type BuffPipelineEclipseArcaneMessage
                local m = { t = "eclipse", kind = BuffPipelineKind.ECLIPSE_ARCANE, durationSec = durSec }
                return m
            elseif Helpers:MatchesSelfBuffSpell(spellId, tracker.natureBuffTexture, "Nature Eclipse") then
                ---@type BuffPipelineEclipseNatureMessage
                local m = { t = "eclipse", kind = BuffPipelineKind.ECLIPSE_NATURE, durationSec = durSec }
                return m
            end
        end
    elseif event == "BUFF_REMOVED_SELF" then
        if NampowerBuffCommon.SkipRemovalForRefresh(arg7) then
            return nil
        end
        local spellId = tonumber(arg3)
        if spellId and (
            Helpers:MatchesSelfBuffSpell(spellId, tracker.arcaneBuffTexture, "Arcane Eclipse")
            or Helpers:MatchesSelfBuffSpell(spellId, tracker.natureBuffTexture, "Nature Eclipse")
        ) then
            ---@type BuffPipelineEclipseClearMessage
            local m = { t = "eclipse", kind = BuffPipelineKind.ECLIPSE_CLEAR }
            return m
        end
    elseif event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" then
        if arg1 and string.find(arg1, "Arcane Eclipse") then
            ---@type BuffPipelineEclipseArcaneMessage
            local m = { t = "eclipse", kind = BuffPipelineKind.ECLIPSE_ARCANE, durationSec = 15 }
            return m
        elseif arg1 and string.find(arg1, "Nature Eclipse") then
            ---@type BuffPipelineEclipseNatureMessage
            local m = { t = "eclipse", kind = BuffPipelineKind.ECLIPSE_NATURE, durationSec = 15 }
            return m
        end
    elseif event == "CHAT_MSG_SPELL_AURA_GONE_SELF" and arg1 and string.find(arg1, "Eclipse") then
        ---@type BuffPipelineEclipseClearMessage
        local m = { t = "eclipse", kind = BuffPipelineKind.ECLIPSE_CLEAR, via_chat = true }
        return m
    end
    return nil
end
