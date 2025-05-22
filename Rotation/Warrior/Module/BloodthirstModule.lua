--- @class BloodthirstModule : Module
--- @diagnostic disable: duplicate-set-field
BloodthirstModule = setmetatable({}, { __index = Module })
BloodthirstModule.__index = BloodthirstModule


function BloodthirstModule.new()
    return setmetatable(Module.new(ABILITY_BLOODTHIRST), BloodthirstModule)
end

function BloodthirstModule:run()
    Logging:Debug("Casting Bloodthirst")
    CastSpellByName(ABILITY_BLOODTHIRST)
end

function BloodthirstModule:getPriority()
    if self.enabled then
        local rage = UnitMana("player");
        local bsCost = Helpers:RageCost(ABILITY_BLOODTHIRST)
        if Helpers:SpellReady(ABILITY_BLOODTHIRST) and rage >= bsCost then
            return 90;
        else
            return -1;
        end
    else
        return -1;
    end
end
