--- @class VanillaBuffDot : BuffDotHandler
--- @field pipeline VanillaBuffPipeline
VanillaBuffDot = {}
VanillaBuffDot.__index = VanillaBuffDot

--- @return VanillaBuffDot
function VanillaBuffDot.new()
    return setmetatable({ pipeline = VanillaBuffPipeline.new() }, VanillaBuffDot)
end

--- @param tracker DotTracker
--- @param now number
--- @param event string
--- @param arg1 string|nil `UNIT_CASTEVENT`: caster guid; `CHAT_MSG_SPELL_*` miss/resist lines: chat line; `CHAT_MSG_SPELL_AURA_GONE_OTHER`: chat line
--- @param arg2 string|nil
--- @param arg3 string|nil `UNIT_CASTEVENT`: subevent (`CAST`)
--- @param arg4 unknown|nil `UNIT_CASTEVENT`: spell id
---@return BuffPipelineDotMessage|nil
function VanillaBuffDot:Message(tracker, now, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    if event == "UNIT_CASTEVENT" then
        return self.pipeline:TryDotApply(tracker, arg1, arg2, arg3, arg4, arg7, arg8)
    elseif self.pipeline:IsSelfSpellResistEvent(event) then
        return PipelineDotResistLine.new(arg1)
    elseif event == "CHAT_MSG_SPELL_AURA_GONE_OTHER" then
        local mobGuid = self.pipeline:TryAuraGoneOtherMobGuid(arg1, tracker.rankedAbility.name)
        if not mobGuid then
            return nil
        end
        return PipelineDotRemove.new(mobGuid)
    elseif BuffTrackerLifecycle.ClearsMobScopedStateOnRegen(event) then
        return PipelineDotClearData.new()
    end
    return nil
end
