--- @enum SolsticeType
SolsticeType = {
    ARCANE = 1,
    NATURE = 2
}

--- @class SolsticeTracker : CooldownTracker
--- @field solsticeType SolsticeType | nil
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
        self.solsticeType = EclipseType.ARCANE
    elseif Helpers:HasDebuff("player", "Spell_Nature_AbolishMagic") then
        self.solsticeType = EclipseType.NATURE
    else
        self.solsticeType = nil
    end
end

--- @param event string
--- @param arg1 string
function SolsticeTracker:onEvent(event, arg1)
    if event == "PLAYER_DEAD" then
        self.buffUp = false
    elseif event == "CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE" then
        if string.find(arg1, "Arcane Solstice") then
            self.solsticeType = SolsticeType.ARCANE
            Logging:Debug("Arcane Solstice is up")
        elseif string.find(arg1, "Natural Solstice") then
            self.solsticeType = SolsticeType.NATURE
            Logging:Debug("Natural Solstice is up")
        end
    elseif event == "CHAT_MSG_SPELL_AURA_GONE_SELF" and string.find(arg1, "Solstice") then
        Logging:Debug("Solstice is down")
        self.solsticeType = nil
    end
end

--- @return boolean
function SolsticeTracker:ShouldCast()
    return not self.solsticeType
end

--- @return SolsticeType
function SolsticeTracker:GetSolsticeType()
    return self.solsticeType
end
