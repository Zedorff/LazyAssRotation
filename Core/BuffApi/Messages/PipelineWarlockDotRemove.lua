---@class PipelineWarlockDotRemove : BuffPipelineMessage
---@field t "warlock_dot"
---@field mobGuid string
PipelineWarlockDotRemove = {}
PipelineWarlockDotRemove.__index = PipelineWarlockDotRemove

---@param mobGuid string
---@return PipelineWarlockDotRemove
function PipelineWarlockDotRemove.new(mobGuid)
    local self = BuffPipelineMessage.new(BuffPipelineKind.DEBUFF_REMOVE)
    self.t = "warlock_dot"
    self.mobGuid = mobGuid
    return setmetatable(self, PipelineWarlockDotRemove)
end
