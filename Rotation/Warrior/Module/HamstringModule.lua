--- @class HamstringModule : Module
--- @diagnostic disable: duplicate-set-field
HamstringModule = setmetatable({}, { __index = Module })
HamstringModule.__index = HamstringModule

function HamstringModule.new()
    return setmetatable(Module.new(ABILITY_HAMSTRING), HamstringModule)
end

function HamstringModule:run()
    Logging:Debug("Casting Hamstring")
    CastSpellByName(ABILITY_HAMSTRING)
end

--- @param context WarriorModuleRunContext
function HamstringModule:getPriority(context)
    if self.enabled and context.stance == 3 then
        if context.spec == WarriorSpec.ARMS then
            return -1;
        elseif context.spec == WarriorSpec.FURY then
            return self:GetFuryHamstringPriority(context.rage)
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
        return -1;
    end
end
