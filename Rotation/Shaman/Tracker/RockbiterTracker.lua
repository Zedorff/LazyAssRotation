--- @class RockbiterTracker : CooldownTracker
--- @field activeUntil integer
--- @diagnostic disable: duplicate-set-field
RockbiterTracker = setmetatable({}, { __index = CooldownTracker })
RockbiterTracker.__index = RockbiterTracker

function RockbiterTracker.new()
    local instance = {
        activeUntil = 0
    }

    setmetatable(instance, RockbiterTracker)

    instance:CheckEnchant()
    return instance
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
            Logging:Debug("Windfury is up")
            self.activeUntil = GetTime() + enchantTimeLeft
        end
    else
        self.activeUntil = 0
    end
end

--- @return boolean
function RockbiterTracker:isAvailable()
    return GetTime() > self.activeUntil
end

--- @return number
function RockbiterTracker:GetWhenAvailable()
    return self.activeUntil;
end
