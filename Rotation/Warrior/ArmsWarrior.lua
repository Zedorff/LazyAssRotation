MLDps = MLDps or {}
local global = MLDps

--- @class ArmsWarrior : ClassRotation
--- @diagnostic disable: duplicate-set-field
ArmsWarrior = setmetatable({}, { __index = ClassRotation })
ArmsWarrior.__index = ArmsWarrior

--- @return ArmsWarrior
function ArmsWarrior.new()
    Logging:Log("Using Arms Warrior rotation")
    return setmetatable({}, ArmsWarrior)
end

function ArmsWarrior:execute()
    if not CheckInteractDistance("target", 3) then
        if ModuleRegistry:IsModuleEnabled(ABILITY_BATTLE_SHOUT) then
            ModuleRegistry.modules[ABILITY_BATTLE_SHOUT]:run()
        end
        Logging:Debug("Too far away!")
        return
    end

    ClassRotationPerformer:PerformRotation()
end
