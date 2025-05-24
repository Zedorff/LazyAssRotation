--- @enum WarriorSpec
WarriorSpec = {
    ARMS = 1,
    FURY = 2,
    PROT = 3
}

--- @return WarriorSpec
function GetWarriorSpec()
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