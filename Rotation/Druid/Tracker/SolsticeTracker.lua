--- @enum SolsticeType
SolsticeType = {
    ARCANE = 1,
    NATURE = 2
}

--- @class SolsticeTracker : CooldownTracker
--- @field isNatureSolsticeUp boolean
--- @field isArcaneSolsticeUp boolean
SolsticeTracker = setmetatable({}, { __index = CooldownTracker })
SolsticeTracker.__index = SolsticeTracker

--- @type SolsticeTracker | nil
local sharedInstance = nil

--- @return SolsticeTracker
function SolsticeTracker.GetInstance()
    if sharedInstance then
        return sharedInstance
    end

    --- @class SolsticeTracker
    local self = CooldownTracker.new()
    setmetatable(self, SolsticeTracker)

    self:CheckSolstice()

    sharedInstance = self

    return sharedInstance
end

function SolsticeTracker:subscribe()
    CooldownTracker.subscribe(self)
    self:CheckSolstice()
end

function SolsticeTracker:CheckSolstice()
    if Helpers:HasDebuff("player", "Spell_Arcane_StarFire") then
        self.isArcaneSolsticeUp = true
    end
    if Helpers:HasDebuff("player", "Spell_Nature_AbolishMagic") then
        self.isNatureSolsticeUp = true
    end
end

--- @param event string
--- @param arg1 string
function SolsticeTracker:onEvent(event, arg1)
    if event == "PLAYER_DEAD" then
        self.buffUp = false
    elseif event == "CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE" then
        if string.find(arg1, "Arcane Solstice") then
            self.isArcaneSolsticeUp = true
            Logging:Debug("Arcane Solstice is up")
        elseif string.find(arg1, "Natural Solstice") then
            self.isNatureSolsticeUp = true
            Logging:Debug("Natural Solstice is up")
        end
    elseif event == "CHAT_MSG_SPELL_AURA_GONE_SELF" then
        if string.find(arg1, "Arcane Solstice") then
            self.isArcaneSolsticeUp = false
            Logging:Debug("Arcane Solstice is down")
        end
        if string.find(arg1, "Natural Solstice") then
            self.isNatureSolsticeUp = false
            Logging:Debug("Natural Solstice is down")
        end
    end
end

--- @return boolean
function SolsticeTracker:ShouldCast()
    return false
end

--- @param type SolsticeType
--- @return boolean
function SolsticeTracker:IsSolsticeTypeUp(type)
    if type == SolsticeType.ARCANE then
        return self.isArcaneSolsticeUp
    elseif type == SolsticeType.NATURE then
        return self.isNatureSolsticeUp
    end
    return false
end

--- @return boolean
function SolsticeTracker:IsAnySolsticeUp()
    return self.isArcaneSolsticeUp or self.isNatureSolsticeUp
end
