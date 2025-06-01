Helpers = {}

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

--- @deprecated Use `HasBuff` instead
--- @param unit string
--- @param buffName string
--- @return boolean
function Helpers:HasBuffName(unit, buffName)
    if not buffName or not unit then
        return false
    end

    local tooltip = LAR_GameTooltip
    local text = getglobal(tooltip:GetName().."TextLeft1")
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
    local text = getglobal(tooltip:GetName().."TextLeft1")
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

    local spellID = Helpers:SpellId(spellName);
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
