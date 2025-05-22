--- @class WhirlwindModule : Module
--- @diagnostic disable: duplicate-set-field
WhirlwindModule = setmetatable({}, { __index = Module })
WhirlwindModule.__index = WhirlwindModule

function WhirlwindModule.new()
    return setmetatable(Module.new(ABILITY_WHIRLWIND), WhirlwindModule)
end

function WhirlwindModule:run()
    Logging:Debug("Casting Whirlwind")
    CastSpellByName(ABILITY_WHIRLWIND)
end

function WhirlwindModule:getPriority()
    local activeStance = Helpers:ActiveStance()
    if self.enabled and activeStance == 3 then
        local rage = UnitMana("player");
        local spec = Helpers:GetWarriorSpec()
        if spec == WarriorSpec.ARMS then
            return self:GetArmsWhirlwindPriority(rage)
        elseif spec == WarriorSpec.FURY then
            return self:GetFuryWhirlwindPriority(rage)
        else
            return -1;
        end
    else
        return -1;
    end
end

function WhirlwindModule:GetArmsWhirlwindPriority(rage)
    local wwCost = Helpers:RageCost(ABILITY_WHIRLWIND)
    if Helpers:SpellReady(ABILITY_WHIRLWIND) and not Helpers:SpellReady(ABILITY_MORTAL_STRIKE) and rage >= wwCost then
        return 70
    else
        return -1;
    end
end

function WhirlwindModule:GetFuryWhirlwindPriority(rage)
    local wwCost = Helpers:RageCost(ABILITY_WHIRLWIND)
    if Helpers:SpellReady(ABILITY_WHIRLWIND) and not Helpers:SpellReady(ABILITY_BLOODTHIRST) and rage >= wwCost then
        return 70
    else
        return -1;
    end
end
