Msg("Beginning crane panic event.\n")

DirectorOptions <-
{
	ProhibitBosses = true

	MobSpawnMinTime = 3
	MobSpawnMaxTime = 7
	MobMinSize = 15
	MobMaxSize = 20
	MobMaxPending = 50
	SustainPeakMinTime = 5
	SustainPeakMaxTime = 8
	IntensityRelaxThreshold = 1.1
	RelaxMinInterval = 10
	RelaxMaxInterval = 15
	RelaxMaxFlowTravel = 300
	BoomerLimit = 0
	SmokerLimit = 1
	HunterLimit = 1
	ChargerLimit = 1
	SpecialRespawnInterval = 10.0
	PreferredMobDirection = SPAWN_ANYWHERE
}

Director.ResetMobTimer()