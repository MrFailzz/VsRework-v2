Msg("Initiating Crescendo Event.\n")

DirectorOptions <-
{
	ProhibitBosses = true

	MobSpawnMinTime = 2
	MobSpawnMaxTime = 6
	MobMinSize = 11
	MobMaxSize = 18
	MobMaxPending = 11
	SustainPeakMinTime = 1
	SustainPeakMaxTime = 3
	IntensityRelaxThreshold = 1.1
	RelaxMinInterval = 3
	RelaxMaxInterval = 5
	RelaxMaxFlowTravel = 200
	SpecialRespawnInterval = 15.0
	PreferredMobDirection = SPAWN_NO_PREFERENCE
	ZombieSpawnRange = 1600
}

Director.ResetMobTimer()