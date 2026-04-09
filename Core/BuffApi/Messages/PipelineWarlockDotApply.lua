---@class PipelineWarlockDotApply : BuffPipelineMessage
---@field mobGuid string|nil
---@field durationSec number
PipelineWarlockDotApply = {}
PipelineWarlockDotApply.__index = PipelineWarlockDotApply

---@param mobGuid string|nil
---@param durationSec number
---@return PipelineWarlockDotApply
function PipelineWarlockDotApply.new(mobGuid, durationSec)
    ---@type PipelineWarlockDotApply
    local self = {
        kind = BuffPipelineKind.DEBUFF_APPLY,
        t = "warlock_dot",
        mobGuid = mobGuid,
        durationSec = durationSec,
    }
    return setmetatable(self, PipelineWarlockDotApply)
end
