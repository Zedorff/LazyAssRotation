--- @class DotTracker : MobDotStateTracker
--- @field rankedAbility Ability
--- @field data table<string, table>
--- @field buffPipeline BuffEventPipeline
DotTracker = setmetatable({}, { __index = MobDotStateTracker })
DotTracker.__index = DotTracker

--- @param rankedAbility Ability
--- @return DotTracker
function DotTracker.new(rankedAbility)
    --- @class DotTracker
    local self = CooldownTracker.new()
    setmetatable(self, DotTracker)

    local buffPipeline = BuffApiFactory.GetInstance()
    self.rankedAbility = rankedAbility
    self.data    = {}
    self.buffPipeline = buffPipeline

    return self
end

function DotTracker:subscribe()
    self.data = {}
    CooldownTracker.subscribe(self)
end

--- @param event string
function DotTracker:onEvent(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    local now = GetTime()
    self.buffPipeline:ApplyDotEvent(self, now, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, function(msg)
        self:TryConsumeMobDotPipelineMessage(msg, now)
    end)
end
