Msg("Initiating Crescendo Cooldown\n");

DirectorOptions <-
{
	ProhibitBosses = true

	AlwaysAllowWanderers = true
	NumReservedWanderers = 10
	MobSpawnMinTime = 8
	MobSpawnMaxTime = 12
	MobMinSize = 10
	MobMaxSize = 15
	MobMaxPending = 15
	SustainPeakMinTime = 3
	SustainPeakMaxTime = 5
	IntensityRelaxThreshold = 0.95
	RelaxMinInterval = 6
	RelaxMaxInterval = 10
	RelaxMaxFlowTravel = 400
	BoomerLimit = 1
	SpitterLimit = 1
	SmokerLimit = 2
	HunterLimit = 2
	ChargerLimit = 1
	SpecialRespawnInterval = 20.0
	PreferredMobDirection = SPAWN_FAR_AWAY_FROM_SURVIVORS
}