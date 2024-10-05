Msg("Beginning crane panic event.\n")

DirectorOptions <-
{
	ProhibitBosses = true

	MobSpawnMinTime = 1
	MobSpawnMaxTime = 3
	MobMinSize = 11
	MobMaxSize = 18
	MobMaxPending = 10
	SustainPeakMinTime = 1
	SustainPeakMaxTime = 3
	IntensityRelaxThreshold = 1.1
	RelaxMinInterval = 3
	RelaxMaxInterval = 5
	RelaxMaxFlowTravel = 200
	BoomerLimit = 0
	SmokerLimit = 1
	HunterLimit = 1
	ChargerLimit = 1
	SpecialRespawnInterval = 5.0
	PreferredMobDirection = SPAWN_NO_PREFERENCE
	ZombieSpawnRange = 1600
}

Director.ResetMobTimer()