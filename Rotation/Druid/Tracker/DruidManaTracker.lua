--- @class DruidManaTracker : CooldownTracker
--- @field currentMana number
DruidManaTracker = setmetatable({}, { __index = CooldownTracker })
DruidManaTracker.__index = DruidManaTracker

--- @return DruidManaTracker
function DruidManaTracker.new()
    --- @class DruidManaTracker
    local self = CooldownTracker.new()
    setmetatable(self, DruidManaTracker)

    local druidMana = GetUnitField("player", "power1")
    if druidMana ~= nil then
        self.currentMana = druidMana
    else
        self.currentMana = UnitMana("player")
    end

    return self
end

--- @param event string
--- @param arg1 string
function DruidManaTracker:onEvent(event, arg1)
    if event == "UNIT_MANA" and arg1 == "player" then
        local druidMana = GetUnitField("player", "power1")
        if druidMana ~= nil then
            self.currentMana = druidMana
        end
    elseif event == "UPDATE_SHAPESHIFT_FORM" then
        local druidMana = GetUnitField("player", "power1")
        if druidMana ~= nil then
            self.currentMana = druidMana
        else
            self.currentMana = UnitMana("player")
        end
    end
end

--- @return boolean
function DruidManaTracker:ShouldCast()
    return false;
end

--- @return number
function DruidManaTracker:GetDruidMana()
    return self.currentMana
end
