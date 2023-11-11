Msg("Initiating Crescendo Event.\n")

DirectorOptions <-
{
	ProhibitBosses = true

	MobSpawnMinTime = 1
	MobSpawnMaxTime = 3
	MobMinSize = 10
	MobMaxSize = 20
	MobMaxPending = 10
	SustainPeakMinTime = 1
	SustainPeakMaxTime = 3
	IntensityRelaxThreshold = 1.1
	RelaxMinInterval = 3
	RelaxMaxInterval = 5
	RelaxMaxFlowTravel = 200
	SpecialRespawnInterval = 10.0
	PreferredMobDirection = SPAWN_FAR_AWAY_FROM_SURVIVORS
	ZombieSpawnRange = 2000
}

Director.ResetMobTimer()