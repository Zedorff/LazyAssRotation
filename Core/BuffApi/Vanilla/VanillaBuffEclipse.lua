VanillaBuffEclipse = {}

--- @param tracker EclipseTracker
--- @param event string
--- @param arg1 string|nil `CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS`: chat line; `CHAT_MSG_SPELL_AURA_GONE_SELF`: chat line
---@return BuffPipelineEclipseArcaneMessage|BuffPipelineEclipseNatureMessage|BuffPipelineEclipseClearMessage|nil
function VanillaBuffEclipse.Message(tracker, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    if event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" then
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
        local m = { t = "eclipse", kind = BuffPipelineKind.ECLIPSE_CLEAR }
        return m
    end
    return nil
end
