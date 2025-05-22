--- @class HamstringModule : Module
--- @diagnostic disable: duplicate-set-field
HamstringModule = setmetatable({}, { __index = Module })
HamstringModule.__index = HamstringModule

function HamstringModule.new()
    return setmetatable(Module.new(ABILITY_WHIRLWIND), HamstringModule)
end

function HamstringModule:run()
    Logging:Debug("Casting Hamstring")
    CastSpellByName(ABILITY_HAMSTRING)
end

function HamstringModule:getPriority()
    local activeStance = Helpers:ActiveStance()
    if self.enabled and activeStance == 3 then
        local rage = UnitMana("player");
        local spec = Helpers:GetWarriorSpec()
        if spec == WarriorSpec.ARMS then
            return -1;
        elseif spec == WarriorSpec.FURY then
            return self:GetFuryHamstringPriority(rage)
        else
            return -1;
        end
    else
        return -1;
    end
end

function HamstringModule:GetFuryHamstringPriority(rage)
   if Helpers:SpellReady(ABILITY_HAMSTRING) and rage >= 80 then
        return 10
    else
        return 0;
    end
end
