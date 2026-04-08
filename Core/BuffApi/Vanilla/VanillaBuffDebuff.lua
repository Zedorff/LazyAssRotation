--- @class VanillaBuffDebuff : BuffDebuffHandler
--- @field pipeline VanillaBuffPipeline
VanillaBuffDebuff = {}
VanillaBuffDebuff.__index = VanillaBuffDebuff

--- @return VanillaBuffDebuff
function VanillaBuffDebuff.new()
    return setmetatable({ pipeline = VanillaBuffPipeline.new() }, VanillaBuffDebuff)
end

--- @param tracker DebuffTracker
--- @param now number
--- @param event string
--- @param arg1 string|nil `UNIT_CASTEVENT`: caster guid; `CHAT_MSG_SPELL_*` miss/resist lines: chat line; `CHAT_MSG_SPELL_AURA_GONE_OTHER`: chat line
--- @param arg2 string|nil `UNIT_CASTEVENT`: mob guid
--- @param arg3 string|nil `UNIT_CASTEVENT`: subevent (`CAST`)
--- @param arg4 unknown|nil `UNIT_CASTEVENT`: spell id
---@return BuffPipelineDebuffMessage|nil
function VanillaBuffDebuff:Message(tracker, now, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    if event == "UNIT_CASTEVENT" then
        return self.pipeline:TryDebuffApply(tracker, arg1, arg2, arg3, arg4, arg7, arg8)
    elseif self.pipeline:IsSelfSpellResistEvent(event) then
        return PipelineDebuffResistLine.new(arg1)
    elseif event == "CHAT_MSG_SPELL_AURA_GONE_OTHER" then
        local mobGuid = self.pipeline:TryAuraGoneOtherMobGuid(arg1, tracker.ability.name)
        if not mobGuid then
            return nil
        end
        return PipelineDebuffRemove.new(mobGuid)
    elseif BuffTrackerLifecycle.ClearsMobScopedStateOnRegen(event) then
        return PipelineDebuffClearData.new()
    end
    return nil
end
