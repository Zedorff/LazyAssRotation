--- @enum EclipseType
EclipseType = {
    ARCANE = 1,
    NATURE = 2
}

--- @class EclipseTracker : CooldownTracker
--- @field eclipsetype EclipseType | nil
--- @field eclipseUpUntill number
--- @field arcaneBuffTexture string
--- @field natureBuffTexture string
--- @field buffPipeline BuffEventPipeline
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
    self.arcaneBuffTexture = "Spell_Nature_WispSplode"
    self.natureBuffTexture = "Spell_Nature_AbolishMagic"
    self.buffPipeline = BuffApiFactory.GetInstance()

    self:CheckActiveEclipseType()

    sharedInstance = self

    return sharedInstance
end

function EclipseTracker:subscribe()
    CooldownTracker.subscribe(self)
    self.eclipseUpUntill = 0
    self:CheckActiveEclipseType()
end

function EclipseTracker:CheckActiveEclipseType()
    if Helpers:HasBuff("player", self.arcaneBuffTexture) then
        self.eclipsetype = EclipseType.ARCANE
    elseif Helpers:HasBuff("player", self.natureBuffTexture) then
        self.eclipsetype = EclipseType.NATURE
    else
        self.eclipsetype = nil
    end
end

--- @param event string
--- @param arg1 string
function EclipseTracker:onEvent(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    self.buffPipeline:ApplyEclipseEvent(self, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, function(msg)
        if not msg then
            return
        end
        if msg.kind == BuffPipelineKind.ECLIPSE_CLEAR then
            Logging:Debug(msg.via_chat and "Eclipse is down (chat)" or "Eclipse is down")
            self.eclipseUpUntill = 0
            self.eclipsetype = nil
            return
        end
        local dur = msg.durationSec or 15
        self.eclipseUpUntill = GetTime() + dur
        if msg.kind == BuffPipelineKind.ECLIPSE_ARCANE then
            self.eclipsetype = EclipseType.ARCANE
            Logging:Debug("Arcane Eclipse is up")
        elseif msg.kind == BuffPipelineKind.ECLIPSE_NATURE then
            self.eclipsetype = EclipseType.NATURE
            Logging:Debug("Nature Eclipse is up")
        end
    end)
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
    if not self.eclipsetype then
        return 0
    end
    local rem = self.eclipseUpUntill - GetTime()
    if rem < 0 then
        return 0
    end
    return rem
end
