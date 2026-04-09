---@class PipelineDotResistLine : BuffPipelineMessage
---@field line string|nil
PipelineDotResistLine = {}
PipelineDotResistLine.__index = PipelineDotResistLine

---@param line string|nil
---@return PipelineDotResistLine
function PipelineDotResistLine.new(line)
    ---@type PipelineDotResistLine
    local self = {
        kind = BuffPipelineKind.DEBUFF_RESIST_LINE,
        t = "dot",
        line = line,
    }
    return setmetatable(self, PipelineDotResistLine)
end
