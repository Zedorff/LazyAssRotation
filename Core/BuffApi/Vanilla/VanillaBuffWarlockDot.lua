--- @class VanillaBuffWarlockDot : BuffWarlockDotHandler
--- @field pipeline VanillaBuffPipeline
VanillaBuffWarlockDot = {}
VanillaBuffWarlockDot.__index = VanillaBuffWarlockDot

--- @return VanillaBuffWarlockDot
function VanillaBuffWarlockDot.new()
    return setmetatable({ pipeline = VanillaBuffPipeline.new() }, VanillaBuffWarlockDot)
end

--- @param tracker WarlockDotTracker
--- @param now number
--- @param target string|nil current target guid at event time
--- @param event string
--- @param arg1 unknown|nil `UNIT_CASTEVENT`: caster guid; `SPELLCAST_CHANNEL_START`: channel duration (ms); `CHAT_MSG_SPELL_*` miss/resist lines: chat line; `CHAT_MSG_SPELL_AURA_GONE_OTHER`: chat line
--- @param arg2 unknown|nil
--- @param arg3 unknown|nil `UNIT_CASTEVENT`: subevent (`CAST`|`CHANNEL`)
--- @param arg4 unknown|nil `UNIT_CASTEVENT`: spell id
---@return BuffPipelineWarlockDotMessage|nil
function VanillaBuffWarlockDot:Message(tracker, now, target, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    if event == "UNIT_CASTEVENT" and arg1 == Helpers:GetUnitGUID("player") then
        if arg3 == "CAST" and IsMatchingRank(tracker.rankedAbility, tonumber(arg4)) then
            return PipelineWarlockDotApply.new(target, Helpers:SpellDuration(tracker.rankedAbility.name))
        elseif arg3 == "CHANNEL" and IsMatchingRank(Abilities.DarkHarvest, tonumber(arg4)) then
            return PipelineWarlockDotDhPending.new()
        end
    elseif event == "SPELLCAST_CHANNEL_START" and tracker.pendingChannel then
        return PipelineWarlockDotDhChannelStart.new(arg1)
    elseif event == "SPELLCAST_CHANNEL_STOP" or event == "SPELLCAST_INTERRUPTED" then
        if tracker.dhCasting then
            return PipelineWarlockDotDhChannelStop.new()
        end
    elseif self.pipeline:IsSelfSpellResistEvent(event) then
        return PipelineWarlockDotResistLine.new(arg1)
    elseif event == "CHAT_MSG_SPELL_AURA_GONE_OTHER" then
        local mobGuid = self.pipeline:TryAuraGoneOtherMobGuid(arg1, tracker.rankedAbility.name)
        if not mobGuid then
            return nil
        end
        return PipelineWarlockDotRemove.new(mobGuid)
    elseif BuffTrackerLifecycle.ClearsMobScopedStateOnRegen(event) then
        return PipelineWarlockDotClearData.new()
    end
    return nil
end
