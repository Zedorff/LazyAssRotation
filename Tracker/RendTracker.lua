MLDps = MLDps or {}

--- Tracks Rend uptime and handles T3 bonus interactions.
--- @class RendTracker : CooldownTracker
--- @field rendActiveUntil number
--- @field has4PieceT3 boolean
--- @field currentTargetName string | nil
--- @field pendingRendTarget string | nil
--- @field pendingRendApplyTime number | nil
RendTracker = setmetatable({}, { __index = CooldownTracker })
RendTracker.__index = RendTracker

local WARRIOR_T3_SET = {
    ["Dreadnaught Crown"] = true,
    ["Dreadnaught Pauldrons"] = true,
    ["Dreadnaught Chestplate"] = true,
    ["Dreadnaught Girdle"] = true,
    ["Dreadnaught Bindings"] = true,
    ["Dreadnaught Gloves"] = true,
    ["Dreadnaught Leggins"] = true,
    ["Dreadnaught Sabatons"] = true,
    ["Ring of the Dreadnaught"] = true
}

--- Constructs a new RendTracker and starts spell hook.
--- @return RendTracker
function RendTracker:new()
    local obj = {
        rendActiveUntil = 0,
        has4PieceT3 = false,
    }
    MLDps:StartHookingSpellCasts()
    return setmetatable(obj, self)
end

--- Handles all subscribed events.
--- @param event string
--- @vararg any
function RendTracker:onEvent(event, ...)
    local arg1 = unpack(arg)
    local now = GetTime()

    if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_EQUIPMENT_CHANGED" then
        self:CheckT3Bonus()

    elseif event == "PLAYER_TARGET_CHANGED" then
        self:ResetTracking()

    elseif event == "MLDPS_SPELL_CAST" and arg1 == "Rend" then
        self:StartPendingRend()

    elseif event == "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE" then
        self:CheckRendTick(arg1, now)

    elseif event == "CHAT_MSG_SPELL_SELF_DAMAGE" then
        self:HandleSelfDamage(arg1, now)

    elseif event == "CHAT_MSG_COMBAT_SELF_HITS" then
        self:HandleMeleeCrit(arg1, now)
    end
end

--- Resets all Rend tracking information when the target changes.
function RendTracker:ResetTracking()
    self.currentTargetName = UnitName("target") or nil
    self.rendActiveUntil = 0
    self.pendingRendTarget = nil
    self.pendingRendApplyTime = nil
    Logging:Log("Target changed or lost. Reset rend tracking.")
end

--- Starts tracking pending Rend application after cast.
function RendTracker:StartPendingRend()
    self.pendingRendTarget = UnitName("target") or nil
    self.pendingRendApplyTime = GetTime()
    Logging:Log("Rend cast initiated on " .. (self.pendingRendTarget or "unknown target"))
end

--- Confirms Rend applied successfully via first tick message.
--- @param arg1 string
--- @param now number
function RendTracker:CheckRendTick(arg1, now)
    if arg1 and string.find(arg1, "from your Rend") then
        if self.pendingRendTarget and self.pendingRendApplyTime then
            local delay = now - self.pendingRendApplyTime
            if delay <= 5 then
                local remaining = 21.5 - delay
                self.rendActiveUntil = now + remaining
                Logging:Log(string.format("Rend confirmed by tick. Delay: %.1fs, Set duration to %.1fs", delay, remaining))
            end
            self.pendingRendTarget = nil
            self.pendingRendApplyTime = nil
        end
    end
end

--- Handles spell failure (dodge/parry) or crit refresh logic for T3 bonus.
--- @param arg1 string
--- @param now number
function RendTracker:HandleSelfDamage(arg1, now)
    if arg1 and string.find(arg1, "Your Rend was") and (string.find(arg1,"dodged") or string.find(arg1,"parried")) then
        self.rendActiveUntil = 0
        self.pendingRendTarget = nil
        self.pendingRendApplyTime = nil
        Logging:Log("Rend failed to apply (dodged or parried).")
    elseif arg1 and string.find(arg1, "Your") and string.find(arg1, "crits") and not self:isAvailable() and self.has4PieceT3 then
        self.rendActiveUntil = now + 21
        Logging:Log("Spell crit refreshed Rend (T3 4-piece).")
    end
end

--- Handles melee crits refreshing Rend with T3 bonus.
--- @param arg1 string
--- @param now number
function RendTracker:HandleMeleeCrit(arg1, now)
    if arg1 and string.find(arg1, "^You crit") and not self:isAvailable() and self.has4PieceT3 then
        self.rendActiveUntil = now + 21
        Logging:Log("Melee crit refreshed Rend (T3 4-piece).")
    end
end

--- Whether Rend is currently available for cast.
--- @return boolean
function RendTracker:isAvailable()
    return GetTime() > self.rendActiveUntil and Helpers:SpellReady(ABILITY_REND)
end

--- When Rend will be available again (either now or after current duration).
--- @return number
function RendTracker:GetWhenAvailable()
    return self.rendActiveUntil
end

--- Checks how many T3 items are equipped and sets internal 4-piece flag.
function RendTracker:CheckT3Bonus()
    local equippedCount = 0
    for slot = 1, 19 do
        local itemLink = GetInventoryItemLink("player", slot)
        if itemLink then
            local itemName = GetItemInfo(itemLink)
            if itemName and WARRIOR_T3_SET[itemName] then
                equippedCount = equippedCount + 1
            end
        end
    end
    local newHas4Piece = equippedCount >= 4
    if newHas4Piece ~= self.has4PieceT3 then
        self.has4PieceT3 = newHas4Piece
    end
end

--- Utility to check if a message indicates a crit.
--- @param msg string
--- @return boolean
function IsCritMessage(msg)
    return string.find(msg, " crit") or string.find(msg, "crits")
end
