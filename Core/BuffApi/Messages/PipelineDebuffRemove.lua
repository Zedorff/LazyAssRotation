---@class PipelineDebuffRemove : BuffPipelineMessage
---@field t "debuff"
---@field mobGuid string
PipelineDebuffRemove = {}
PipelineDebuffRemove.__index = PipelineDebuffRemove

---@param mobGuid string
---@return PipelineDebuffRemove
function PipelineDebuffRemove.new(mobGuid)
    local self = BuffPipelineMessage.new(BuffPipelineKind.DEBUFF_REMOVE)
    self.t = "debuff"
    self.mobGuid = mobGuid
    return setmetatable(self, PipelineDebuffRemove)
end
