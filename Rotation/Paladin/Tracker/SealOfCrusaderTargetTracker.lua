--- @class SealOfCrusaderTargetTracker : CooldownTracker
--- @field socrIsUp boolean
--- @diagnostic disable: duplicate-set-field
SealOfCrusaderTargetTracker = setmetatable({}, { __index = CooldownTracker })
SealOfCrusaderTargetTracker.__index = SealOfCrusaderTargetTracker

--- @return SealOfCrusaderTargetTracker
function SealOfCrusaderTargetTracker.new()
    --- @class SealOfCrusaderTargetTracker
    local self = CooldownTracker.new()
    setmetatable(self, SealOfCrusaderTargetTracker)
    self.socrIsUp = Helpers:HasDebuff("target", "Spell_Holy_HolySmite")
    return self
end

function SealOfCrusaderTargetTracker:subscribe()
    CooldownTracker.subscribe(self)
    self.socrIsUp = Helpers:HasDebuff("target", "Spell_Holy_HolySmite")
end

--- @param event string
--- @param arg1 string
function SealOfCrusaderTargetTracker:onEvent(event, arg1)
    if event == "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE" and string.find(arg1, "Judgement of the Crusader") then
        Logging:Debug(ABILITY_SEAL_CRUSADER.." is on target")
        self.socrIsUp = true
    elseif event == "CHAT_MSG_SPELL_AURA_GONE_OTHER" and string.find(arg1, "Judgement of the Crusader") then
        local target = UnitName("target")
        if target and string.find(arg1, target) then
            Logging:Debug(ABILITY_SEAL_CRUSADER.." is not on target")
            self.socrIsUp = false
        end
    elseif event == "PLAYER_TARGET_CHANGED" then
        self.socrIsUp = Helpers:HasDebuff("target", "Spell_Holy_HolySmite")
    end 
end

--- @return boolean
function SealOfCrusaderTargetTracker:ShouldCast()
    return not self.socrIsUp
end
