---@class PipelineDebuffApply : BuffPipelineMessage
---@field mobGuid string
---@field durationSec number
PipelineDebuffApply = {}
PipelineDebuffApply.__index = PipelineDebuffApply

---@param mobGuid string
---@param durationSec number
---@return PipelineDebuffApply
function PipelineDebuffApply.new(mobGuid, durationSec)
    ---@type PipelineDebuffApply
    local self = {
        kind = BuffPipelineKind.DEBUFF_APPLY,
        t = "debuff",
        mobGuid = mobGuid,
        durationSec = durationSec,
    }
    return setmetatable(self, PipelineDebuffApply)
end
