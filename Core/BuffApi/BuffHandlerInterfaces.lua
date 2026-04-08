--- EmmyLua contracts shared by Vanilla and Nampower buff API handlers (same public methods; event arg shapes differ by backend).

---@class BuffSelfBuffHandler
---@field pipeline VanillaBuffPipeline|NampowerBuffPipeline
---@field new fun(): BuffSelfBuffHandler
---@field SelfBuffMessage fun(self, tracker: SelfBuffTracker, event: string, ...): BuffPipelineSelfBuffMessage|nil
---@field DurationedSelfBuffMessage fun(self, tracker: DurationedSelfBuffTracker, event: string, ...): BuffPipelineDurationedSelfBuffMessage|nil

---@class BuffDebuffHandler
---@field pipeline VanillaBuffPipeline|NampowerBuffPipeline
---@field new fun(): BuffDebuffHandler
---@field Message fun(self, tracker: DebuffTracker, now: number, event: string, ...): BuffPipelineDebuffMessage|nil

---@class BuffDotHandler
---@field pipeline VanillaBuffPipeline|NampowerBuffPipeline
---@field new fun(): BuffDotHandler
---@field Message fun(self, tracker: DotTracker, now: number, event: string, ...): BuffPipelineDotMessage|nil

---@class BuffWarlockDotHandler
---@field pipeline VanillaBuffPipeline|NampowerBuffPipeline
---@field new fun(): BuffWarlockDotHandler
---@field Message fun(self, tracker: WarlockDotTracker, now: number, target: string|nil, event: string, ...): BuffPipelineWarlockDotMessage|nil

---@class BuffEclipseHandler
---@field pipeline VanillaBuffPipeline|NampowerBuffPipeline
---@field new fun(): BuffEclipseHandler
---@field Message fun(self, tracker: EclipseTracker, event: string, ...): BuffPipelineEclipseMessage|nil

---@alias BuffEventAdapterSelfBuff BuffSelfBuffHandler
---@alias BuffEventAdapterDebuff BuffDebuffHandler
---@alias BuffEventAdapterDot BuffDotHandler
---@alias BuffEventAdapterWarlockDot BuffWarlockDotHandler
---@alias BuffEventAdapterEclipse BuffEclipseHandler
