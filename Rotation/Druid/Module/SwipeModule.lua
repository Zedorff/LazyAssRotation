--- @class SwipeModule : Module
--- @diagnostic disable: duplicate-set-field
SwipeModule = setmetatable({}, { __index = Module })
SwipeModule.__index = SwipeModule

--- @return SwipeModule
function SwipeModule.new()
    --- @class SwipeModule
    return setmetatable(Module.new(Abilities.Swipe.name, trackers, "Interface\\Icons\\INV_Misc_MonsterClaw_03"), SwipeModule)
end

function SwipeModule:run()
    Logging:Debug("Casting "..Abilities.Swipe.name)
    CastSpellByName(Abilities.Swipe.name)
end

--- @param context DruidModuleRunContext
function SwipeModule:getPriority(context)
    if self.enabled and Helpers:SpellReady(Abilities.Swipe.name) then
        if context.rage >= context.maulCost + context.savageBiteCost + context.swipeCost then
            return 80;
        end
    end
    return -1;
end
