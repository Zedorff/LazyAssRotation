---@class PipelineDotApply : BuffPipelineMessage
---@field t "dot"
---@field mobGuid string|nil
---@field durationSec number
PipelineDotApply = {}
PipelineDotApply.__index = PipelineDotApply

---@param mobGuid string|nil
---@param durationSec number
---@return PipelineDotApply
function PipelineDotApply.new(mobGuid, durationSec)
    local self = BuffPipelineMessage.new(BuffPipelineKind.DEBUFF_APPLY)
    self.t = "dot"
    self.mobGuid = mobGuid
    self.durationSec = durationSec
    return setmetatable(self, PipelineDotApply)
end
