--- @class NampowerBuffDebuff : BuffDebuffHandler
--- @field pipeline NampowerBuffPipeline
NampowerBuffDebuff = {}
NampowerBuffDebuff.__index = NampowerBuffDebuff

--- @return NampowerBuffDebuff
function NampowerBuffDebuff.new()
    return setmetatable({ pipeline = NampowerBuffPipeline.new() }, NampowerBuffDebuff)
end

--- @param tracker DebuffTracker
--- @param now number
--- @param event string
--- @param arg1 string|nil `AURA_CAST_ON_OTHER`: spell id; `DEBUFF_REMOVED_OTHER`: mob guid; `SPELL_MISS_SELF` (Nampower): caster guid
--- @param arg2 string|nil `AURA_CAST_ON_OTHER`: caster guid; `SPELL_MISS_SELF`: target guid
--- @param arg3 string|nil `AURA_CAST_ON_OTHER`: target guid; `DEBUFF_REMOVED_OTHER`: spell id; `SPELL_MISS_SELF`: spell id
--- @param arg4 unknown|nil `SPELL_MISS_SELF`: miss type
--- @param arg7 unknown|nil `DEBUFF_REMOVED_OTHER`: removal reason (`2` = refresh)
--- @param arg8 unknown|nil `AURA_CAST_ON_OTHER`: duration (ms)
---@return BuffPipelineDebuffMessage|nil
function NampowerBuffDebuff:Message(tracker, now, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    if event == "AURA_CAST_ON_OTHER" then
        return self.pipeline:TryDebuffApply(tracker, arg1, arg2, arg3, arg4, arg7, arg8)
    elseif event == "DEBUFF_REMOVED_OTHER" then
        return self.pipeline:TryDebuffRemove(arg1, tonumber(arg3), arg7, tracker)
    elseif event == "UNIT_CASTEVENT" then
        return nil
    elseif event == "SPELL_MISS_SELF" then
        return PipelineDebuffSpellMiss.new(arg1, arg2, arg3, arg4)
    elseif BuffTrackerLifecycle.ClearsMobScopedStateOnRegen(event) then
        return PipelineDebuffClearData.new()
    end
    return nil
end
