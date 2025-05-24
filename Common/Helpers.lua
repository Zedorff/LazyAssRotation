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
--- @param buffName string
--- @return boolean
function Helpers:HasBuffName(unit, buffName)
    if not buffName or not unit then
        return false
    end

    local tooltip = MLDpsTooltip
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

--- @param unit string
--- @param debuffName string
--- @return boolean
function Helpers:HasDebuffName(unit, debuffName)
    if not buffName or not unit then
        return false
    end

    local tooltip = MLDpsTooltip
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
    MLDpsTooltip:SetOwner(UIParent, "ANCHOR_NONE");

    local spellID = Helpers:SpellId(spellName);
    if not spellID then
        Logging:Debug("Can't find " .. spellName .. " in book");
        return 0;
    end

    MLDpsTooltip:SetSpell(spellID, BOOKTYPE_SPELL);

    local lineCount = MLDpsTooltip:NumLines();

    for i = 1, lineCount do
        local leftText = getglobal("MLDpsTooltipTextLeft" .. i);

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
    MLDpsTooltip:SetOwner(UIParent, "ANCHOR_NONE")
    MLDpsTooltip:SetInventoryItem("player", 16) --- main hand

    for i = 1, MLDpsTooltip:NumLines() do
        local leftText = getglobal("MLDpsTooltipTextLeft" .. i)
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
--- @return boolean hit
--- @return boolean crit
--- @return boolean parry
--- @return boolean miss
function Helpers:ParseCombatEvent(spellName, line)
  local escaped = string.gsub(spellName, "(%p)", "%%%1")

  local critHitPattern = string.format("Your %s (crits|hits) (.+) for (%%d+).", escaped)
  local missPattern    = string.format("Your %s missed (.+).", escaped)
  local parryPattern   = string.format("Your %s was parried by (.+).", escaped)

  local _, _, hitType = strfind(line, critHitPattern)
  if hitType == "crits" then
    return true, true, false, false
  elseif hitType == "hits" then
    return true, false, false, false
  end

  if strfind(line, missPattern) then
    return false, false, false, true
  end

  if strfind(line, parryPattern) then
    return false, false, true, false
  end

  return false, false, false, false
end