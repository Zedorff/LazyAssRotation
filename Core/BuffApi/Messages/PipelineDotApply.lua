---@class PipelineDotApply : BuffPipelineMessage
---@field mobGuid string|nil
---@field durationSec number
PipelineDotApply = {}
PipelineDotApply.__index = PipelineDotApply

---@param mobGuid string|nil
---@param durationSec number
---@return PipelineDotApply
function PipelineDotApply.new(mobGuid, durationSec)
    ---@type PipelineDotApply
    local self = {
        kind = BuffPipelineKind.DEBUFF_APPLY,
        t = "dot",
        mobGuid = mobGuid,
        durationSec = durationSec,
    }
    return setmetatable(self, PipelineDotApply)
end
