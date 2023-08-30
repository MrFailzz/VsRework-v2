Msg("Beginning crane panic event.\n")

DirectorOptions <-
{
	ProhibitBosses = true

	MobSpawnMinTime = 3
	MobSpawnMaxTime = 7
	MobMinSize = 10
	MobMaxSize = 30
	MobMaxPending = 50
	SustainPeakMinTime = 3
	SustainPeakMaxTime = 5
	IntensityRelaxThreshold = 1.1
	RelaxMinInterval = 5
	RelaxMaxInterval = 7
	RelaxMaxFlowTravel = 300
	BoomerLimit = 0
	SmokerLimit = 1
	HunterLimit = 1
	ChargerLimit = 1
	SpecialRespawnInterval = 10.0
	PreferredMobDirection = SPAWN_ANYWHERE
	ZombieSpawnRange = 1500
}

Director.ResetMobTimer()