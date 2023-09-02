Msg("Beginning crane panic event.\n")

DirectorOptions <-
{
	ProhibitBosses = true

	MobSpawnMinTime = 20
	MobSpawnMaxTime = 20
	MobMinSize = 80
	MobMaxSize = 80
	MobMaxPending = 50
	SustainPeakMinTime = 3
	SustainPeakMaxTime = 5
	IntensityRelaxThreshold = 1.1
	RelaxMinInterval = 5
	RelaxMaxInterval = 7
	RelaxMaxFlowTravel = 300
	SpecialRespawnInterval = 5.0
	PreferredMobDirection = SPAWN_ANYWHERE
	ZombieSpawnRange = 2000
}

Director.ResetMobTimer()
Director.PlayMegaMobWarningSounds()