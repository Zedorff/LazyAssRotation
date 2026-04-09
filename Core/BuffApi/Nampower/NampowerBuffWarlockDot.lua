--- @class NampowerBuffWarlockDot : BuffWarlockDotHandler
--- @field pipeline NampowerBuffPipeline
NampowerBuffWarlockDot = {}
NampowerBuffWarlockDot.__index = NampowerBuffWarlockDot

--- @return NampowerBuffWarlockDot
function NampowerBuffWarlockDot.new()
    return setmetatable({ pipeline = NampowerBuffPipeline.new() }, NampowerBuffWarlockDot)
end

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
---@return BuffPipelineWarlockDotMessage|nil
function NampowerBuffWarlockDot:Message(tracker, now, target, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    if event == "AURA_CAST_ON_OTHER" then
        return self.pipeline:TryWarlockDotApply(tracker, arg1, arg2, arg3, arg4, arg7, arg8)
    end

    if event == "DEBUFF_REMOVED_OTHER" then
        return self.pipeline:TryWarlockDotRemove(arg1, tonumber(arg3), arg7, tracker)
    end

    if event == "UNIT_CASTEVENT" and arg1 == Helpers:GetUnitGUID("player") then
        if arg3 == "CHANNEL" and IsMatchingRank(Abilities.DarkHarvest, tonumber(arg4)) then
            return PipelineWarlockDotDhPending.new()
        end
    elseif event == "SPELLCAST_CHANNEL_START" and tracker.pendingChannel then
        return PipelineWarlockDotDhChannelStart.new(arg1)
    elseif event == "SPELLCAST_CHANNEL_STOP" or event == "SPELLCAST_INTERRUPTED" then
        if tracker.dhCasting then
            return PipelineWarlockDotDhChannelStop.new()
        end
    elseif event == "SPELL_MISS_SELF" then
        return PipelineWarlockDotSpellMiss.new(arg1, arg2, arg3, arg4)
    elseif BuffTrackerLifecycle.ClearsMobScopedStateOnRegen(event) then
        return PipelineWarlockDotClearData.new()
    end
    return nil
end
