Helpers = {}

--- @param unit string
--- @return string|nil
function Helpers:GetUnitGUID(unit)
    if type(GetUnitGUID) == "function" then
        local ok, guid = pcall(GetUnitGUID, unit)
        if ok and guid and guid ~= "" then
            return guid
        end
    end
    local exists, guid = UnitExists(unit)
    if exists and guid and guid ~= "" then
        return guid
    end
    return nil
end

--- @param unit string
--- @param field string
--- @return number|nil
function Helpers:_GetUnitFieldFallback(unit, field)
    local pt = UnitPowerType(unit)
    if field == "power1" then
        if pt == 0 then
            return UnitMana(unit)
        end
        return nil
    elseif field == "maxPower1" then
        if pt == 0 then
            return UnitManaMax(unit)
        end
        return nil
    elseif field == "power2" then
        if pt == 1 then
            return UnitMana(unit) * 10
        end
        return nil
    elseif field == "power4" then
        if pt == 3 then
            return UnitMana(unit)
        end
        return nil
    end
    return nil
end

--- @param unit string
--- @param field string
--- @return number|nil
function Helpers:GetUnitField(unit, field)
    if type(GetUnitField) == "function" then
        local ok, v = pcall(GetUnitField, unit, field)
        if ok and v ~= nil then
            return v
        end
    end
    return self:_GetUnitFieldFallback(unit, field)
end

--- Returns true if UnitXP_SP3 DLL is active. UnitXP provides distance, line of sight,
--- behind detection, and targeting helpers.
--- @return boolean
function Helpers:HasUnitXP()
    local success = pcall(UnitXP, "nop", "nop")
    return success
end

--- Uses UnitXP `behind`. If UnitXP is not available, returns false (use NotBehindTargetTracker fallback).
--- @param fromUnit string
--- @param toUnit string
--- @return boolean
function Helpers:IsBehindTarget(fromUnit, toUnit)
    if not self:HasUnitXP() then
        return false
    end
    local success, behind = pcall(UnitXP, "behind", fromUnit, toUnit)
    return success and behind
end

--- Uses UnitXP `inSight`. If UnitXP is not available, returns true (no LOS gating).
--- @param fromUnit string
--- @param toUnit string
--- @return boolean
function Helpers:IsInSight(fromUnit, toUnit)
    if not self:HasUnitXP() then
        return true
    end
    local success, inSight = pcall(UnitXP, "inSight", fromUnit, toUnit)
    return success and inSight
end

--- True if `toUnit` is within white-swing range of `fromUnit` (UnitXP `distanceBetween` + `"meleeAutoAttack"`).
--- Threshold is stricter than Whirlwind's ~8yd AoE so WW is not suggested at "almost in range" spacing.
--- Without UnitXP there is no reliable 5yd API on 1.12; returns true so behavior stays unchanged.
--- @param fromUnit string
--- @param toUnit string
--- @return boolean
function Helpers:IsInMeleeRange(fromUnit, toUnit)
    if not UnitExists(toUnit) then
        return false
    end
    if not self:HasUnitXP() then
        return true
    end
    local success, dist = pcall(UnitXP, "distanceBetween", fromUnit, toUnit, "meleeAutoAttack")
    if not success or type(dist) ~= "number" then
        return true
    end
    return dist <= 4.0
end

--- When UnitXP is active and there is a target, true if ranged spells should be skipped (no LOS).
--- Without UnitXP, returns false so rotation behaves as before.
--- @return boolean
function Helpers:ShouldSuppressRangedSpellForLOS()
    if not self:HasUnitXP() then
        return false
    end
    if not UnitExists("target") then
        return false
    end
    return not self:IsInSight("player", "target")
end

--- NamPower `GetUnitField("player", "power2")` returns rage in tenths; without NamPower, `GetUnitField`
--- fallback uses `UnitMana * 10` so this still yields whole rage after `floor(raw / 10)`.
--- @param raw number|nil
--- @return integer
function Helpers:RageFromUnitField(raw)
    if type(raw) ~= "number" then
        return 0
    end
    return math.floor(raw / 10)
end

--- @param spellname string
--- @return number | nil
function Helpers:SpellId(spellname)
    local id = 1;
    for i = 1, GetNumSpellTabs() do
        local _, _, _, numSpells = GetSpellTabInfo(i);
        for j = 1, numSpells do
            local spellName = GetSpellName(id, BOOKTYPE_SPELL);
            if (spellName == spellname) then
                return id;
            end
            id = id + 1;
        end
    end
    return nil;
end

--- @param spellName string
--- @return number|nil
function Helpers:SpellIdMaxRank(spellName)
    -- Walk each spell-tab in reverse so we hit higher-rank versions first.
    local numTabs = GetNumSpellTabs()
    for tab = numTabs, 1, -1 do
        local _, _, offset, numSpells = GetSpellTabInfo(tab)
        -- scan that tab bottom-up
        for i = offset + numSpells, offset + 1, -1 do
            local name = GetSpellName(i, BOOKTYPE_SPELL)
            if name == spellName then
                return i
            end
        end
    end
    return nil
end

--- @param spellname string
--- @return boolean
function Helpers:SpellReady(spellname)
    local id = Helpers:SpellId(spellname);
    if (id) then
        local start, duration = GetSpellCooldown(id, 0);
        if (start == 0 and duration == 0) then
            return true;
        end
    end
    return false;
end

--- @param spellname string
--- @param delta number
--- @return boolean
function Helpers:SpellAlmostReady(spellname, delta)
    local id = Helpers:SpellId(spellname)
    if id then
        local start, duration = GetSpellCooldown(id, 0)
        if start == 0 and duration == 0 then
            return true
        end
        local remaining = (start + duration) - GetTime()
        return remaining <= delta
    end
    return false
end

--- @param spellname string
--- @return number
function Helpers:SpellNotReadyFor(spellname)
    local id = Helpers:SpellId(spellname)
    if id then
        local start, duration = GetSpellCooldown(id, 0)
        if start == 0 and duration == 0 then
            return 0
        end
        return (start + duration) - GetTime()
    end
    return 0
end

--- @return boolean
function Helpers:HasNampowerAuraCastEvents()
    return GetCVar and GetCVar("NP_EnableAuraCastEvents") ~= nil
end

--- @return boolean
function Helpers:EnsureNampowerAuraCastEventsEnabled()
    if not self:HasNampowerAuraCastEvents() then
        return false
    end
    if GetCVar("NP_EnableAuraCastEvents") ~= "1" then
        SetCVar("NP_EnableAuraCastEvents", "1")
    end
    return true
end

--- @param spellId number
--- @return string|nil
function Helpers:SpellIconBySpellId(spellId)
    if not spellId or spellId == 0 then
        return nil
    end
    if type(GetSpellRecField) == "function" then
        local ok, icon = pcall(GetSpellRecField, spellId, "icon")
        if ok and type(icon) == "string" then
            return icon
        end
    end
    if type(GetSpellInfo) == "function" then
        local ok, _, _, icon = pcall(GetSpellInfo, spellId)
        if ok and type(icon) == "string" then
            return icon
        end
    end
    return nil
end

--- @param spellId number
--- @param texture string|nil
--- @param abilityName string|nil
--- @return boolean
function Helpers:MatchesSelfBuffSpell(spellId, texture, abilityName)
    spellId = tonumber(spellId)
    if not spellId then
        return false
    end
    if abilityName and type(GetSpellRecField) == "function" then
        local ok, name = pcall(GetSpellRecField, spellId, "name")
        if ok and name and string.find(name, abilityName) then
            return true
        end
    end
    if texture then
        local icon = self:SpellIconBySpellId(spellId)
        if icon and string.find(icon, texture) then
            return true
        end
    end
    return false
end

--- @deprecated Use `HasBuff` instead
--- @param unit string
--- @param buffName string
--- @return boolean
function Helpers:HasBuffName(unit, buffName)
    if not buffName or not unit then
        return false
    end

    local tooltip = LAR_GameTooltip
    local text = getglobal(tooltip:GetName() .. "TextLeft1")
    local targetName = string.gsub(buffName, "_", " ") -- only once, before loop

    for i = 1, 32 do
        tooltip:SetOwner(UIParent, "ANCHOR_NONE")
        tooltip:SetUnitBuff(unit, i)
        local name = text:GetText()
        tooltip:Hide()

        if name and string.find(name, targetName, 1, true) then -- true = plain text match
            return true
        end
    end

    return false
end

--- @deprecated Use `HasDebuff` instead
--- @param unit string
--- @param debuffName string
--- @return boolean
function Helpers:HasDebuffName(unit, debuffName)
    if not buffName or not unit then
        return false
    end

    local tooltip = LAR_GameTooltip
    local text = getglobal(tooltip:GetName() .. "TextLeft1")
    local targetName = string.gsub(debuffName, "_", " ") -- only once, before loop

    for i = 1, 32 do
        tooltip:SetOwner(UIParent, "ANCHOR_NONE")
        tooltip:SetUnitDebuff(unit, i)
        local name = text:GetText()
        tooltip:Hide()

        if name and string.find(name, targetName, 1, true) then -- true = plain text match
            return true
        end
    end

    return false
end

--- @param unit string
--- @param textureSubstring string
--- @return integer
function Helpers:GetBuffStackCount(unit, textureSubstring)
    for i = 1, 32 do
        local texture, stacks = UnitBuff(unit, i)
        if not texture then break end

        if string.find(texture, textureSubstring) then
            return tonumber(stacks or 1)
        end
    end
    return 0
end

--- @return number
function Helpers:ActiveStance()
    for i = 1, 3 do
        local _, _, active = GetShapeshiftFormInfo(i);
        if (active) then
            return i;
        end
    end
    return 1; --- falback to battle
end

--- @param spellName string
--- @param intRegex string
--- @return number
function Helpers:ParseIntViaTooltip(spellName, intRegex)
    LAR_GameTooltip:SetOwner(UIParent, "ANCHOR_NONE");

    local spellID = Helpers:SpellIdMaxRank(spellName);
    if not spellID then
        Logging:Debug("Can't find " .. spellName .. " in book");
        return 0;
    end

    --- @diagnostic disable-next-line: param-type-mismatch
    LAR_GameTooltip:SetSpell(spellID, BOOKTYPE_SPELL);

    local lineCount = LAR_GameTooltip:NumLines();

    for i = 1, lineCount do
        local leftText = getglobal("LAR_GameTooltipTextLeft" .. i);

        if leftText:GetText() then
            local _, _, int = string.find(leftText:GetText(), intRegex);
            if int then
                return tonumber(int);
            end
        end
    end

    return 0;
end

--- @param spellName string
--- @return number|nil, string|nil
function Helpers:ParseDebuffIntViaTooltip(spellName)
    LAR_GameTooltip:SetOwner(UIParent, "ANCHOR_NONE");
    local spellID = Helpers:SpellIdMaxRank(spellName);
    if not spellID then
        Logging:Debug("Can't find " .. spellName .. " in book");
        return nil, nil;
    end
    --- @diagnostic disable-next-line: param-type-mismatch
    LAR_GameTooltip:SetSpell(spellID, BOOKTYPE_SPELL);
    local lineCount = LAR_GameTooltip:NumLines();
        for i = 1, lineCount do
            local leftText = getglobal("LAR_GameTooltipTextLeft" .. i);
            if leftText and leftText:GetText() then
                local line = string.lower(leftText:GetText())
                -- Try to match 'min' first
                local _, _, value = string.find(line, DEBUFF_DURATION_MIN_REGEX)
                if value then
                    return tonumber(value), "min"
                end
                -- Try to match 'sec' if 'min' not found
                local _, _, value2 = string.find(line, DEBUFF_DURATION_SEC_REGEX)
                if value2 then
                    return tonumber(value2), "sec"
                end
            end
        end
    return nil, nil;
end

--- @param enchantName string
--- @return boolean
function Helpers:HasMainWeaponEnchantTooltip(enchantName)
    LAR_GameTooltip:SetOwner(UIParent, "ANCHOR_NONE")
    --- @diagnostic disable-next-line: discard-returns
    LAR_GameTooltip:SetInventoryItem("player", 16) --- main hand

    for i = 1, LAR_GameTooltip:NumLines() do
        local leftText = getglobal("LAR_GameTooltipTextLeft" .. i)
        if leftText then
            local text = leftText:GetText()
            if text and string.find(text, enchantName) then
                return true
            end
        end
    end

    return false
end

--- @param spellName string
--- @return number
function Helpers:CastTime(spellName)
    return Helpers:ParseIntViaTooltip(spellName, COOLDOWN_DESCRIPTION_REGEX)
end

--- @param spellName string
--- @return number
function Helpers:RageCost(spellName)
    return Helpers:ParseIntViaTooltip(spellName, RAGE_DESCRIPTION_REGEX)
end

function Helpers:DurationFromAuraCastMs(durationMs)
    if type(durationMs) == "number" and durationMs > 0 then
        return durationMs / 1000
    end
    return nil
end

--- @param spellName string
--- @return number
function Helpers:SpellDuration(spellName)
    return Helpers:ParseIntViaTooltip(spellName, DURATION_DESCRIPTION_REGEX)
end

--- @param spellName string
--- @return number
function Helpers:DebuffDuration(spellName)
    local value, unit = Helpers:ParseDebuffIntViaTooltip(spellName)
    if not value then return 0 end
    if unit == "min" then
        return value * 60
    end
    return value
end

--- @return boolean
function Helpers:ShouldUseExecute()
    local targetHealth = UnitHealth("target")
    local targetHealthMax = UnitHealthMax("target")

    if targetHealthMax == 0 then return false end
    local healthPercent = (targetHealth / targetHealthMax) * 100
    if healthPercent >= 20 then return false end

    return true
end

--- @param obj any
--- @param class any
function Helpers:isInstanceOf(obj, class)
    local mt = getmetatable(obj)
    while mt do
        if mt == class then return true end
        mt = getmetatable(mt)
    end
    return false
end

--- @param spellName string
--- @param line string
--- @return boolean hit, boolean crit, boolean parry, boolean miss, boolean dodge
function Helpers:ParseCombatEvent(spellName, line)
    local escapedSpell = string.gsub(spellName, "([%(%)%.%%%+%-%*%?%[%^%$])", "%%%1")

    -- Match hit or crit
    if string.find(line, "^Your " .. escapedSpell .. " hits .+ for %d+") then
        return true, false, false, false, false
    elseif string.find(line, "^Your " .. escapedSpell .. " crits .+ for %d+") then
        return true, true, false, false, false
    end

    -- Match parry
    if string.find(line, "^Your " .. escapedSpell .. " was parried by .+") then
        return false, false, true, false, false
    end

    -- Match dodge
    if string.find(line, "^Your " .. escapedSpell .. " was dodged by .+") then
        return false, false, false, false, true
    end

    -- Match miss
    if string.find(line, "^Your " .. escapedSpell .. " missed .+") then
        return false, false, false, true, false
    end

    return false, false, false, false, false
end

--- @param unit string
--- @param texturename string
--- @return boolean
function Helpers:HasBuff(unit, texturename)
    local id = 1;
    while (UnitBuff(unit, id)) do
        local buffTexture = UnitBuff(unit, id);
        if (string.find(buffTexture, texturename)) then
            return true;
        end
        id = id + 1;
    end
    return false;
end

--- @param unit string
--- @param texturename string
--- @return boolean
function Helpers:HasDebuff(unit, texturename)
    local id = 1
    local debuffTexture = UnitDebuff(unit, id)
    while debuffTexture do
        if string.find(debuffTexture, texturename) then
            return true
        end
        id = id + 1
        debuffTexture = UnitDebuff(unit, id)
    end
    return false
end

--- @param talentName string
--- @return number|nil
function Helpers:PointsInTalent(talentName)
    local numTabs = GetNumTalentTabs()
    for tab = 1, numTabs do
        local numTalents = GetNumTalents(tab)
        for index = 1, numTalents do
            local name, _, _, _, currentRank, _ = GetTalentInfo(tab, index)
            if name == talentName then
                return currentRank
            end
        end
    end
    return 0
end

--- @return boolean
function Helpers:isShieldEquipped()
    LAR_GameTooltip:SetOwner(UIParent, "ANCHOR_NONE");

    local slotId = GetInventorySlotInfo(SECONDARY_SLOT_ID);
    local hasItem = LAR_GameTooltip:SetInventoryItem("player", slotId);
    if not hasItem then
        return false;
    end

    local lines = LAR_GameTooltip:NumLines();
    for i = 1, lines do
        local label = getglobal("LAR_GameTooltipTextLeft" .. i);
        if label:GetText() then
            if label:GetText() == SHIELD_SLOT_TYPE then
                return true;
            end
        end

        label = getglobal("LAR_GameTooltipTextRight" .. i);
        if label:GetText() then
            if label:GetText() == SHIELD_SLOT_TYPE then
                return true;
            end
        end
    end
    return false;
end
