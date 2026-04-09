---@class PipelineWarlockDotSpellMiss : BuffPipelineMessage
---@field casterGuid string|nil
---@field targetGuid string|nil
---@field spellId string|number|nil
---@field missInfo string|number|nil
PipelineWarlockDotSpellMiss = {}
PipelineWarlockDotSpellMiss.__index = PipelineWarlockDotSpellMiss

---@param casterGuid string|nil
---@param targetGuid string|nil
---@param spellId string|number|nil
---@param missInfo string|number|nil
---@return PipelineWarlockDotSpellMiss
function PipelineWarlockDotSpellMiss.new(casterGuid, targetGuid, spellId, missInfo)
    ---@type PipelineWarlockDotSpellMiss
    local self = {
        kind = BuffPipelineKind.DEBUFF_SPELL_MISS,
        t = "warlock_dot",
        casterGuid = casterGuid,
        targetGuid = targetGuid,
        spellId = spellId,
        missInfo = missInfo,
    }
    return setmetatable(self, PipelineWarlockDotSpellMiss)
end
