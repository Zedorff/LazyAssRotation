--- @class VampiricTracker : DebuffTracker
--- @diagnostic disable: duplicate-set-field
VampiricTracker = setmetatable({}, { __index = DebuffTracker })
VampiricTracker.__index = VampiricTracker

--- @return VampiricTracker
function VampiricTracker.new()
    --- @class VampiricTracker
    local self = DebuffTracker.new(Abilities.VampiricEmbrace.name, "Spell_Shadow_UnsummonBuilding")
    setmetatable(self, VampiricTracker)
    return self
end

