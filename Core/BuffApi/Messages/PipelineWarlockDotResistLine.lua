---@class PipelineWarlockDotResistLine : BuffPipelineMessage
---@field line string|nil
PipelineWarlockDotResistLine = {}
PipelineWarlockDotResistLine.__index = PipelineWarlockDotResistLine

---@param line string|nil
---@return PipelineWarlockDotResistLine
function PipelineWarlockDotResistLine.new(line)
    ---@type PipelineWarlockDotResistLine
    local self = {
        kind = BuffPipelineKind.DEBUFF_RESIST_LINE,
        t = "warlock_dot",
        line = line,
    }
    return setmetatable(self, PipelineWarlockDotResistLine)
end
