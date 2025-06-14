--- @enum EclipseType
EclipseType = {
    ARCANE = 1,
    NATURE = 2
}

--- @class EclipseTracker : CooldownTracker
--- @field eclipsetype EclipseType | nil
--- @field eclipseUpUntill number
EclipseTracker = setmetatable({}, { __index = CooldownTracker })
EclipseTracker.__index = EclipseTracker

--- @type EclipseTracker | nil
local sharedInstance = nil

--- @return EclipseTracker
function EclipseTracker.GetInstance()
    if sharedInstance then
        return sharedInstance
    end

    --- @class EclipseTracker
    local self = CooldownTracker.new()
    setmetatable(self, EclipseTracker)

    self.eclipseUpUntill = 0

    EclipseTracker:CheckActiveEclipseType()

    sharedInstance = self

    return sharedInstance
end

function EclipseTracker:subscribe()
    CooldownTracker.subscribe(self)
    self.eclipseUpUntill = 0
    EclipseTracker:CheckActiveEclipseType()
end

function EclipseTracker:CheckActiveEclipseType()
    if Helpers:HasBuff("player", "Spell_Nature_WispSplode") then
        self.eclipsetype = EclipseType.ARCANE
    elseif Helpers:HasBuff("player", "Spell_Nature_AbolishMagic") then
        self.eclipsetype = EclipseType.NATURE
    else
        self.eclipsetype = nil
    end
end

--- @param event string
--- @param arg1 string
function EclipseTracker:onEvent(event, arg1)
    if event == "PLAYER_DEAD" then
        self.eclipseUpUntill = 0
        self.eclipsetype = nil
    elseif event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" then
        if string.find(arg1, "Arcane Eclipse") then
            self.eclipseUpUntill = GetTime() + 15
            self.eclipsetype = EclipseType.ARCANE
            Logging:Debug("Arcane Eclipse is up")
        elseif string.find(arg1, "Nature Eclipse") then
            self.eclipseUpUntill = GetTime() + 15
            self.eclipsetype = EclipseType.NATURE
            Logging:Debug("Nature Eclipse is up")
        end
    elseif event == "CHAT_MSG_SPELL_AURA_GONE_SELF" and string.find(arg1, "Eclipse") then
        Logging:Debug("Eclipse is down")
        self.eclipseUpUntill = 0
        self.eclipsetype = nil
    end
end

--- @return boolean
function EclipseTracker:ShouldCast()
    return false
end

--- @return EclipseType | nil
function EclipseTracker:GetEclipseType()
    return self.eclipsetype
end

--- @return number
function EclipseTracker:GetEclipseRemainingTime()
    return self.eclipseUpUntill - GetTime()
end
