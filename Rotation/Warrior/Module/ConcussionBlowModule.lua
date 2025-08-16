--- @class ConcussionBlowModule : Module
--- @diagnostic disable: duplicate-set-field
ConcussionBlowModule = setmetatable({}, { __index = Module })
ConcussionBlowModule.__index = ConcussionBlowModule

--- @return ConcussionBlowModule
function ConcussionBlowModule.new()
    --- @class ConcussionBlowModule
    return setmetatable(Module.new(Abilities.ConcussionBlow.name, nil, "Interface\\Icons\\Ability_ThunderBolt"), ConcussionBlowModule);
end

function ConcussionBlowModule:run()
    Logging:Debug("Casting "..Abilities.ConcussionBlow.name)
    CastSpellByName(Abilities.ConcussionBlow.name)
end

function ConcussionBlowModule:getPriority()
    if self.enabled then
        if Helpers:SpellReady(Abilities.ConcussionBlow.name) then
            return 90;
        end
    end
    return -1;
end
