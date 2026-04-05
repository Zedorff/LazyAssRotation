--- @class NampowerBuffApi : BuffApi
NampowerBuffApi = {}
NampowerBuffApi.__index = NampowerBuffApi
setmetatable(NampowerBuffApi, { __index = BuffApi })

--- @return NampowerBuffApi
function NampowerBuffApi.new()
    --- @type NampowerBuffApi
    return setmetatable({}, NampowerBuffApi)
end

--- @param tracker SelfBuffTracker
--- @param event string
function NampowerBuffApi:OnSelfBuffEvent(tracker, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    if event == "AURA_CAST_ON_SELF" then
        local spellId = tonumber(arg1)
        local playerGuid = Helpers:GetUnitGUID("player")
        if spellId and playerGuid and arg3 == playerGuid and Helpers:MatchesSelfBuffSpell(spellId, tracker.buffTexture, tracker.abilityName) then
            Logging:Debug(tracker.abilityName .. " is up")
            tracker.buffUp = true
        end
    elseif event == "BUFF_REMOVED_SELF" then
        if arg7 == 2 then
            return
        end
        local spellId = tonumber(arg3)
        if spellId and Helpers:MatchesSelfBuffSpell(spellId, tracker.buffTexture, tracker.abilityName) then
            Logging:Debug(tracker.abilityName .. " is down")
            tracker.buffUp = false
        end
    elseif event == "CHAT_MSG_SPELL_AURA_GONE_SELF" and arg1 and string.find(arg1, tracker.abilityName) then
        Logging:Debug(tracker.abilityName .. " is down (chat)")
        tracker.buffUp = false
    end
end

--- @param tracker DurationedSelfBuffTracker
--- @param event string
function NampowerBuffApi:OnDurationedSelfBuffEvent(tracker, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    if event == "AURA_CAST_ON_SELF" then
        local spellId = tonumber(arg1)
        local playerGuid = Helpers:GetUnitGUID("player")
        if spellId and playerGuid and arg3 == playerGuid and Helpers:MatchesSelfBuffSpell(spellId, tracker.buffTexture, tracker.abilityName) then
            Logging:Debug(tracker.abilityName .. " is up")
            tracker.buffUp = true
            local durSec = Helpers:DurationFromAuraCastMs(arg8) or tracker.duration
            tracker.upUntil = GetTime() + durSec
        end
    elseif event == "BUFF_REMOVED_SELF" then
        if arg7 == 2 then
            return
        end
        local spellId = tonumber(arg3)
        if spellId and Helpers:MatchesSelfBuffSpell(spellId, tracker.buffTexture, tracker.abilityName) then
            Logging:Debug(tracker.abilityName .. " is down")
            tracker.buffUp = false
            tracker.upUntil = nil
        end
    elseif event == "CHAT_MSG_SPELL_AURA_GONE_SELF" and arg1 and string.find(arg1, tracker.abilityName) then
        Logging:Debug(tracker.abilityName .. " is down (chat)")
        tracker.buffUp = false
        tracker.upUntil = nil
    end
end

--- @param tracker DebuffTracker
--- @param now number
--- @param event string
function NampowerBuffApi:OnDebuffTrackerEvent(tracker, now, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    if event == "AURA_CAST_ON_OTHER" then
        local spellId = tonumber(arg1)
        local playerGuid = Helpers:GetUnitGUID("player")
        if not playerGuid or not spellId or not arg3 then
            return
        end
        if (not tracker.isSharedDebuff) and (arg2 ~= playerGuid) then
            return
        end
        if not IsMatchingRank(tracker.ability, spellId) then
            return
        end
        tracker:ApplyDebuff(now, arg3,
            Helpers:DurationFromAuraCastMs(arg8) or Helpers:DebuffDuration(tracker.ability.name))
    elseif event == "DEBUFF_REMOVED_OTHER" then
        if arg7 == 2 then
            return
        end
        local spellId = tonumber(arg3)
        local mobGuid = arg1
        if not mobGuid or not spellId or not IsMatchingRank(tracker.ability, spellId) then
            return
        end
        tracker:ClearDebuff(mobGuid)
    elseif event == "UNIT_CASTEVENT" then
        return
    elseif event == "CHAT_MSG_SPELL_SELF_DAMAGE" or event == "CHAT_MSG_COMBAT_SELF_MISSES" then
        tracker:HandleResist(arg1)
    elseif event == "PLAYER_REGEN_ENABLED" then
        tracker.data = {}
    end
end

--- @param tracker DotTracker
--- @param now number
--- @param event string
function NampowerBuffApi:OnDotTrackerEvent(tracker, now, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    if event == "AURA_CAST_ON_OTHER" then
        local spellId = tonumber(arg1)
        local playerGuid = Helpers:GetUnitGUID("player")
        local target = Helpers:GetUnitGUID("target")
        if playerGuid and arg2 == playerGuid and spellId and IsMatchingRank(tracker.rankedAbility, spellId) then
            tracker:ApplyDot(now, arg3 or target,
                Helpers:DurationFromAuraCastMs(arg8) or Helpers:SpellDuration(tracker.rankedAbility.name))
        end
    elseif event == "DEBUFF_REMOVED_OTHER" then
        if arg7 == 2 then
            return
        end
        local spellId = tonumber(arg3)
        local mobGuid = arg1
        if not mobGuid or not spellId or not IsMatchingRank(tracker.rankedAbility, spellId) then
            return
        end
        tracker.data[mobGuid] = nil
        Logging:Debug(tracker.rankedAbility.name .. " faded on " .. tostring(mobGuid))
    elseif event == "UNIT_CASTEVENT" then
        return
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
function NampowerBuffApi:OnWarlockDotTrackerEvent(tracker, now, target, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
    if event == "AURA_CAST_ON_OTHER" then
        local spellId = tonumber(arg1)
        local playerGuid = Helpers:GetUnitGUID("player")
        if playerGuid and arg2 == playerGuid and arg3 and spellId and IsMatchingRank(tracker.rankedAbility, spellId) then
            tracker:ApplyDot(now, arg3,
                Helpers:DurationFromAuraCastMs(arg8) or Helpers:SpellDuration(tracker.rankedAbility.name))
        end
        return
    end

    if event == "DEBUFF_REMOVED_OTHER" then
        if arg7 == 2 then
            return
        end
        local spellId = tonumber(arg3)
        local mobGuid = arg1
        if not mobGuid or not spellId or not IsMatchingRank(tracker.rankedAbility, spellId) then
            return
        end
        tracker.data[mobGuid] = nil
        Logging:Debug(tracker.rankedAbility.name .. " faded on " .. tostring(mobGuid))
        return
    end

    if event == "UNIT_CASTEVENT" and arg1 == Helpers:GetUnitGUID("player") then
        if arg3 == "CHANNEL" and IsMatchingRank(Abilities.DarkHarvest, tonumber(arg4)) then
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
