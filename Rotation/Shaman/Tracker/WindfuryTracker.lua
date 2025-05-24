--- @class WindfuryTracker : CooldownTracker
--- @field activeUntil integer
--- @diagnostic disable: duplicate-set-field
WindfuryTracker = setmetatable({}, { __index = CooldownTracker })
WindfuryTracker.__index = WindfuryTracker

function WindfuryTracker.new()
    local instance = {
        activeUntil = 0
    }

    setmetatable(instance, WindfuryTracker)

    instance:CheckEnchant()
    return instance
end

function WindfuryTracker:subscribe()
    CooldownTracker.subscribe(self)
    self:CheckEnchant()
end

--- @param event string
--- @param arg1 string
function WindfuryTracker:onEvent(event, arg1)
    if event ~= "UNIT_INVENTORY_CHANGED" or arg1 ~= "player" then
        return
    end

    self:CheckEnchant()
end

function WindfuryTracker:CheckEnchant()
    local hasEnchant, enchantTimeLeft = GetWeaponEnchantInfo()
    
    if not hasEnchant then
        self.activeUntil = 0
        return
    end

    if Helpers:HasMainWeaponEnchantTooltip("Windfury") then
        if GetTime() > self.activeUntil then
            Logging:Debug("Windfury is up")
            self.activeUntil = GetTime() + enchantTimeLeft
        end
    else
        self.activeUntil = 0
    end
end

--- @return boolean
function WindfuryTracker:isAvailable()
    return GetTime() > self.activeUntil
end

--- @return number
function WindfuryTracker:GetWhenAvailable()
    return self.activeUntil;
end
