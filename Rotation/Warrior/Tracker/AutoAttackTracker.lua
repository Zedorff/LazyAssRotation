--- @class AutoAttackTracker : CooldownTracker
--- @field lastMainHandAttack number
--- @field lastOffHandAttack number
--- @diagnostic disable: duplicate-set-field
AutoAttackTracker = setmetatable({}, { __index = CooldownTracker })
AutoAttackTracker.__index = AutoAttackTracker

--- @return AutoAttackTracker
function AutoAttackTracker.new()
    --- @class AutoAttackTracker
    local self = CooldownTracker.new()
    setmetatable(self, AutoAttackTracker)
    self.lastMainHandAttack = 0
    self.lastOffHandAttack = 0
    return self
end

--- @param event string
--- @param arg1 string
function AutoAttackTracker:onEvent(event, arg1, arg2, arg3)
    if event == "UNIT_CASTEVENT" and arg1 == ({ UnitExists("player") })[2] then
        if arg3 == "MAINHAND" then
            self.lastMainHandAttack = GetTime()
        elseif arg3 == "OFFHAND" then
            self.lastOffHandAttack = GetTime()
        end
    end
    if ((event == "CHAT_MSG_SPELL_SELF_DAMAGE" or event == "CHAT_MSG_SPELL_SELF_MISSES") and string.find(arg1, CHAT_HEROIC_STRIKE)) then
        self.lastMainHandAttack = GetTime()
    end
end

--- @return boolean
function AutoAttackTracker:ShouldCast()
    return true;
end

--- @return number
function AutoAttackTracker:GetNextSwingTime()
    local attackSpeed, _ = UnitAttackSpeed("player")
    local now = GetTime()
    local timeElapsed = now - self.lastMainHandAttack
    local timeRemaining = attackSpeed - timeElapsed

    if timeRemaining < 0 then
        return 0
    else
        return timeRemaining
    end
end
