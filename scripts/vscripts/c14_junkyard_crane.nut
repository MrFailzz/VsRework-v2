Msg("Beginning crane panic event.\n")

DirectorOptions <-
{
	ProhibitBosses = true

	AlwaysAllowWanderers = true
	NumReservedWanderers = 10
	MobSpawnMinTime = 6
	MobSpawnMaxTime = 8
	MobMinSize = 15
	MobMaxSize = 20
	MobMaxPending = 20
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
	PreferredMobDirection = SPAWN_FAR_AWAY_FROM_SURVIVORS
}

Director.ResetMobTimer()