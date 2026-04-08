---@class PipelineWarlockDotApply : BuffPipelineMessage
---@field t "warlock_dot"
---@field mobGuid string|nil
---@field durationSec number
PipelineWarlockDotApply = {}
PipelineWarlockDotApply.__index = PipelineWarlockDotApply

---@param mobGuid string|nil
---@param durationSec number
---@return PipelineWarlockDotApply
function PipelineWarlockDotApply.new(mobGuid, durationSec)
    local self = BuffPipelineMessage.new(BuffPipelineKind.DEBUFF_APPLY)
    self.t = "warlock_dot"
    self.mobGuid = mobGuid
    self.durationSec = durationSec
    return setmetatable(self, PipelineWarlockDotApply)
end
