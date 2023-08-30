Msg("Beginning crane panic event.\n")

DirectorOptions <-
{
	ProhibitBosses = true

	MobSpawnMinTime = 1
	MobSpawnMaxTime = 1
	MobMinSize = 60
	MobMaxSize = 60
	MobMaxPending = 30
	SustainPeakMinTime = 3
	SustainPeakMaxTime = 5
	IntensityRelaxThreshold = 1.1
	RelaxMinInterval = 5
	RelaxMaxInterval = 7
	RelaxMaxFlowTravel = 300
	SpecialRespawnInterval = 5.0
	PreferredMobDirection = SPAWN_ANYWHERE
}

Director.ResetMobTimer()
Director.PlayMegaMobWarningSounds()