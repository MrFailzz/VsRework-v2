Msg("Initiating Crescendo Cooldown\n");

DirectorOptions <-
{
	ProhibitBosses = true

	CommonLimit = 20
	MobSpawnMinTime = 5
	MobSpawnMaxTime = 15
	MobMinSize = 5
	MobMaxSize = 10
	MobMaxPending = 10
	SustainPeakMinTime = 1
	SustainPeakMaxTime = 3
	IntensityRelaxThreshold = 0.90
	RelaxMinInterval = 5
	RelaxMaxInterval = 10
	RelaxMaxFlowTravel = 400
	BoomerLimit = 1
	SpitterLimit = 1
	SmokerLimit = 2
	HunterLimit = 2
	ChargerLimit = 1
	SpecialRespawnInterval = 20.0
	PreferredMobDirection = SPAWN_FAR_AWAY_FROM_SURVIVORS
	ZombieSpawnRange = 2000
}