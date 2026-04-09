BuffTrackerLifecycle = {}

function BuffTrackerLifecycle.IsPlayerDeath(event)
    return event == "PLAYER_DEAD"
end

function BuffTrackerLifecycle.ClearsMobScopedStateOnRegen(event)
    return event == "PLAYER_REGEN_ENABLED"
end

function BuffTrackerLifecycle.SelfBuffSyntheticDeathMessage()
    return PipelineSelfBuffDown.new()
end

function BuffTrackerLifecycle.DurationedSelfBuffSyntheticDeathMessage()
    return PipelineDurationedSelfBuffDown.new()
end

function BuffTrackerLifecycle.EclipseSyntheticDeathMessage()
    return PipelineEclipseClear.new()
end

function BuffTrackerLifecycle.DebuffSyntheticDeathMessage()
    return PipelineDebuffClearData.new()
end

function BuffTrackerLifecycle.DotSyntheticDeathMessage()
    return PipelineDotClearData.new()
end

function BuffTrackerLifecycle.WarlockDotSyntheticDeathMessage()
    return PipelineWarlockDotClearData.new()
end
