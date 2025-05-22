Helpers = {}

--- @class WarriorSpec
WarriorSpec = {
    ARMS = 1,
    FURY = 2,
    PROT = 3
}

--- @param spellname string
--- @return number
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
    return nil;
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
    return nil;
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

--- @return number | nil
function Helpers:ActiveStance()
    for i = 1, 3 do
        local _, _, active = GetShapeshiftFormInfo(i);
        if (active) then
            return i;
        end
    end
    return nil;
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

--- @return integer
function Helpers:GetWarriorSpec()
    local _, _, arms = GetTalentTabInfo(1)
    local _, _, fury = GetTalentTabInfo(2)
    local _, _, prot = GetTalentTabInfo(3)

    if arms >= fury and arms >= prot then
        return WarriorSpec.ARMS
    elseif fury >= arms and fury >= prot then
        return WarriorSpec.FURY
    else
        return WarriorSpec.PROT
    end
end