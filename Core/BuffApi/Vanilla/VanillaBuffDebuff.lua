VanillaBuffDebuff = {}

--- @param tracker DebuffTracker
--- @param now number
--- @param event string
--- @param arg1 string|nil `UNIT_CASTEVENT`: caster guid; `CHAT_MSG_SPELL_*` miss/resist lines: chat line; `CHAT_MSG_SPELL_AURA_GONE_OTHER`: chat line
--- @param arg2 string|nil `UNIT_CASTEVENT`: mob guid
--- @param arg3 string|nil `UNIT_CASTEVENT`: subevent (`CAST`)
--- @param arg4 unknown|nil `UNIT_CASTEVENT`: spell id
---@return BuffPipelineDebuffApplyMessage|BuffPipelineDebuffRemoveMessage|BuffPipelineDebuffResistLineMessage|BuffPipelineDebuffClearDataMessage|nil
function VanillaBuffDebuff.Message(tracker, now, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    if event == "UNIT_CASTEVENT" then
        if arg3 ~= "CAST" then
            return nil
        end
        local spellId = tonumber(arg4)
        if not spellId or not IsMatchingRank(tracker.ability, spellId) then
            return nil
        end
        local playerGuid = Helpers:GetUnitGUID("player")
        local casterGuid = arg1
        if (not tracker.isSharedDebuff) and (casterGuid ~= playerGuid) then
            return nil
        end
        local mobGuid = arg2 or Helpers:GetUnitGUID("target")
        if not mobGuid then
            return nil
        end
        ---@type BuffPipelineDebuffApplyMessage
        local m = {
            t = "debuff",
            kind = BuffPipelineKind.DEBUFF_APPLY,
            mobGuid = mobGuid,
            durationSec = Helpers:DebuffDuration(tracker.ability.name),
        }
        return m
    elseif event == "CHAT_MSG_SPELL_SELF_DAMAGE" or event == "CHAT_MSG_COMBAT_SELF_MISSES" or event == "CHAT_MSG_SPELL_SELF_MISSES" then
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
