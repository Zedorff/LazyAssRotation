NampowerBuffEclipse = {}

--- @param tracker EclipseTracker
--- @param event string
--- @param arg1 number|nil `AURA_CAST_ON_SELF`: spell id
--- @param arg3 string|nil `AURA_CAST_ON_SELF`: target unit guid; `BUFF_REMOVED_SELF`: spell id
--- @param arg7 unknown|nil `BUFF_REMOVED_SELF`: removal reason (`2` = refresh)
--- @param arg8 unknown|nil `AURA_CAST_ON_SELF`: duration (ms)
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
    end
    return nil
end
