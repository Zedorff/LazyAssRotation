---@class PipelineWarlockDotRemove : BuffPipelineMessage
---@field mobGuid string
PipelineWarlockDotRemove = {}
PipelineWarlockDotRemove.__index = PipelineWarlockDotRemove

---@param mobGuid string
---@return PipelineWarlockDotRemove
function PipelineWarlockDotRemove.new(mobGuid)
    ---@type PipelineWarlockDotRemove
    local self = {
        kind = BuffPipelineKind.DEBUFF_REMOVE,
        t = "warlock_dot",
        mobGuid = mobGuid,
    }
    return setmetatable(self, PipelineWarlockDotRemove)
end
