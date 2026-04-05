--- @class VanillaBuffApi : BuffApi
VanillaBuffApi = {}
VanillaBuffApi.__index = VanillaBuffApi
setmetatable(VanillaBuffApi, { __index = BuffApi })

--- @return VanillaBuffApi
function VanillaBuffApi.new()
    --- @type VanillaBuffApi
    return setmetatable({}, VanillaBuffApi)
end

--- @param tracker SelfBuffTracker
--- @param event string
function VanillaBuffApi:OnSelfBuffEvent(tracker, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    if event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" and string.find(arg1, tracker.abilityName) then
        Logging:Debug(tracker.abilityName .. " is up")
        tracker.buffUp = true
    elseif event == "CHAT_MSG_SPELL_AURA_GONE_SELF" and string.find(arg1, tracker.abilityName) then
        Logging:Debug(tracker.abilityName .. " is down")
        tracker.buffUp = false
    end
end

--- @param tracker DurationedSelfBuffTracker
--- @param event string
function VanillaBuffApi:OnDurationedSelfBuffEvent(tracker, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    if event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" and string.find(arg1, tracker.abilityName) then
        Logging:Debug(tracker.abilityName .. " is up")
        tracker.buffUp = true
        tracker.upUntil = GetTime() + tracker.duration
    elseif event == "CHAT_MSG_SPELL_AURA_GONE_SELF" and string.find(arg1, tracker.abilityName) then
        Logging:Debug(tracker.abilityName .. " is down")
        tracker.buffUp = false
        tracker.upUntil = nil
    end
end

--- @param tracker DebuffTracker
--- @param now number
--- @param event string
function VanillaBuffApi:OnDebuffTrackerEvent(tracker, now, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    if event == "UNIT_CASTEVENT" then
        tracker:OnUnitCastEvent(now, arg1, arg2, arg3, arg4, Helpers:DebuffDuration(tracker.ability.name))
    elseif event == "CHAT_MSG_SPELL_SELF_DAMAGE" or event == "CHAT_MSG_COMBAT_SELF_MISSES" then
        tracker:HandleResist(arg1)
    elseif event == "PLAYER_REGEN_ENABLED" then
        tracker.data = {}
    end
end

--- @param tracker DotTracker
--- @param now number
--- @param event string
function VanillaBuffApi:OnDotTrackerEvent(tracker, now, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    local target = Helpers:GetUnitGUID("target")
    if event == "UNIT_CASTEVENT" and arg1 == Helpers:GetUnitGUID("player") and arg3 == "CAST" and IsMatchingRank(tracker.rankedAbility, tonumber(arg4)) then
        tracker:ApplyDot(now, target, Helpers:SpellDuration(tracker.rankedAbility.name))
    elseif event == "CHAT_MSG_SPELL_SELF_DAMAGE" or event == "CHAT_MSG_COMBAT_SELF_MISSES" then
        tracker:HandleResist(arg1)
    elseif event == "PLAYER_REGEN_ENABLED" then
        tracker.data = {}
    end
end

--- @param tracker WarlockDotTracker
--- @param now number
--- @param target string|nil
--- @param event string
function VanillaBuffApi:OnWarlockDotTrackerEvent(tracker, now, target, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    if event == "UNIT_CASTEVENT" and arg1 == Helpers:GetUnitGUID("player") then
        if arg3 == "CAST" and IsMatchingRank(tracker.rankedAbility, tonumber(arg4)) then
            tracker:ApplyDot(now, target, Helpers:SpellDuration(tracker.rankedAbility.name))
        elseif arg3 == "CHANNEL" and IsMatchingRank(Abilities.DarkHarvest, tonumber(arg4)) then
            tracker.pendingChannel = true
        end
    elseif event == "SPELLCAST_CHANNEL_START" and tracker.pendingChannel then
        tracker.dhCasting = true
        tracker.pendingChannel = false
        tracker:StartDarkHarvest(target, now)
        Logging:Debug("Dark Harvest channel started (" .. (arg1 or 0) / 1000 .. "s)")
    elseif event == "SPELLCAST_CHANNEL_STOP" or event == "SPELLCAST_INTERRUPTED" then
        if tracker.dhCasting then
            tracker.dhCasting = false
            tracker.pendingChannel = false
            tracker:EndDarkHarvest(target, now)
            Logging:Debug("Dark Harvest channel stopped / interrupted")
        end
    elseif event == "PLAYER_DEAD" then
        tracker.pendingChannel = false
        tracker.dhCasting = false
    elseif event == "CHAT_MSG_SPELL_SELF_DAMAGE" or event == "CHAT_MSG_COMBAT_SELF_MISSES" then
        tracker:HandleResist(arg1)
    elseif event == "PLAYER_REGEN_ENABLED" then
        tracker.data = {}
    end
end
