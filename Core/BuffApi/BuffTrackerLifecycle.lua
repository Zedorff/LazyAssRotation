BuffTrackerLifecycle = {}

function BuffTrackerLifecycle.IsPlayerDeath(event)
    return event == "PLAYER_DEAD"
end

function BuffTrackerLifecycle.ClearsMobScopedStateOnRegen(event)
    return event == "PLAYER_REGEN_ENABLED"
end

function BuffTrackerLifecycle.SelfBuffSyntheticDeathMessage()
    return { t = "self_buff", kind = BuffPipelineKind.BUFF_DOWN }
end

function BuffTrackerLifecycle.DurationedSelfBuffSyntheticDeathMessage()
    return { t = "durationed_self_buff", kind = BuffPipelineKind.BUFF_DOWN }
end

function BuffTrackerLifecycle.EclipseSyntheticDeathMessage()
    return { t = "eclipse", kind = BuffPipelineKind.ECLIPSE_CLEAR }
end

function BuffTrackerLifecycle.DebuffSyntheticDeathMessage()
    return { t = "debuff", kind = BuffPipelineKind.DEBUFF_CLEAR_DATA }
end

function BuffTrackerLifecycle.DotSyntheticDeathMessage()
    return { t = "dot", kind = BuffPipelineKind.DEBUFF_CLEAR_DATA }
end

function BuffTrackerLifecycle.WarlockDotSyntheticDeathMessage()
    return { t = "warlock_dot", kind = BuffPipelineKind.DEBUFF_CLEAR_DATA }
end
