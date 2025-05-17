-- Helpers

Helpers = {}

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

function Helpers:SpellReady(spellname)
    local id = SpellId(spellname);
    if (id) then
        local start, duration = GetSpellCooldown(id, 0);
        if (start == 0 and duration == 0) then
            return true;
        end
    end
    return nil;
end

function Helpers:HasBuff(unit, texturename)
    local id = 1;
    while (UnitBuff(unit, id)) do
        local buffTexture = UnitBuff(unit, id);
        if (string.find(buffTexture, texturename)) then
            return true;
        end
        id = id + 1;
    end
    return nil;
end

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

function Helpers:ActiveStance()
    for i = 1, 3 do
        local _, _, active = GetShapeshiftFormInfo(i);
        if (active) then
            return i;
        end
    end
    return nil;
end

function ParseIntViaTooltip(spellName, intRegex)
    ThreatTooltip:SetOwner(UIParent, "ANCHOR_NONE");

    local spellID = SpellId(spellName);
    if not spellID then
        Common:Debug("Can't find " .. spellName .. " in book");
        return 0;
    end

    ThreatTooltip:SetSpell(spellID, BOOKTYPE_SPELL);

    local lineCount = ThreatTooltip:NumLines();

    for i = 1, lineCount do
        local leftText = getglobal("ThreatTooltipTextLeft" .. i);

        if leftText:GetText() then
            local _, _, int = string.find(leftText:GetText(), intRegex);
            if int then
                return tonumber(int);
            end
        end
    end

    return 0;
end

function Helpers:CastTime(spellName)
    return ParseIntViaTooltip(spellName, COOLDOWN_DESCRIPTION_REGEX)
end

function Helpers:RageCost(spellName)
    return ParseIntViaTooltip(spellName, RAGE_DESCRIPTION_REGEX)
end