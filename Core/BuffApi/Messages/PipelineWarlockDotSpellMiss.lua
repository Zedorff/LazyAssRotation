---@class PipelineWarlockDotSpellMiss : BuffPipelineMessage
---@field t "warlock_dot"
---@field casterGuid string|nil
---@field targetGuid string|nil
---@field spellId string|number|nil
---@field missInfo string|number|nil
PipelineWarlockDotSpellMiss = {}
PipelineWarlockDotSpellMiss.__index = PipelineWarlockDotSpellMiss

---@return PipelineWarlockDotSpellMiss
function PipelineWarlockDotSpellMiss.new(casterGuid, targetGuid, spellId, missInfo)
    local self = BuffPipelineMessage.new(BuffPipelineKind.DEBUFF_SPELL_MISS)
    self.t = "warlock_dot"
    self.casterGuid = casterGuid
    self.targetGuid = targetGuid
    self.spellId = spellId
    self.missInfo = missInfo
    return setmetatable(self, PipelineWarlockDotSpellMiss)
end
