--- @class RockbiterTracker : CooldownTracker
--- @field activeUntil integer
--- @diagnostic disable: duplicate-set-field
RockbiterTracker = setmetatable({}, { __index = CooldownTracker })
RockbiterTracker.__index = RockbiterTracker

--- @return RockbiterTracker 
function RockbiterTracker.new()
    --- @class RockbiterTracker
    local self = CooldownTracker.new()
    setmetatable(self, RockbiterTracker)
    self.activeUntil = 0
    self:CheckEnchant()
    return self
end

function RockbiterTracker:subscribe()
    CooldownTracker.subscribe(self)
    self:CheckEnchant()
end

--- @param event string
--- @param arg1 string
function RockbiterTracker:onEvent(event, arg1)
    if event ~= "UNIT_INVENTORY_CHANGED" or arg1 ~= "player" then
        return
    end

    self:CheckEnchant()
end

function RockbiterTracker:CheckEnchant()
    local hasEnchant, enchantTimeLeft = GetWeaponEnchantInfo()
    
    if not hasEnchant then
        self.activeUntil = 0
        return
    end

    if Helpers:HasMainWeaponEnchantTooltip("Rockbiter") then
        if GetTime() > self.activeUntil then
            Logging:Debug("Rockbiter is up")
            self.activeUntil = GetTime() + enchantTimeLeft
        end
    else
        self.activeUntil = 0
    end
end

--- @return boolean
function RockbiterTracker:ShouldCast()
    return GetTime() > self.activeUntil
end
