--- @class IceBarrierTracker : SelfBuffTracker
--- @diagnostic disable: duplicate-set-field
IceBarrierTracker = setmetatable({}, { __index = SelfBuffTracker })
IceBarrierTracker.__index = IceBarrierTracker

--- @return IceBarrierTracker
function IceBarrierTracker.new()
    --- @class IceBarrierTracker
    local self = SelfBuffTracker.new(Abilities.IceBarrier.name, "Spell_Ice_Lament")
    setmetatable(self, IceBarrierTracker)
    return self
end
