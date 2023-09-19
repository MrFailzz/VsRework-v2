Msg("Initiating Crescendo Cooldown\n");

DirectorOptions <-
{
	ProhibitBosses = true

	CommonLimit = 20
	MobSpawnMinTime = 8
	MobSpawnMaxTime = 10
	MobMinSize = 10
	MobMaxSize = 15
	MobMaxPending = 20
	SustainPeakMinTime = 3
	SustainPeakMaxTime = 5
	IntensityRelaxThreshold = 1.1
	RelaxMinInterval = 6
	RelaxMaxInterval = 10
	RelaxMaxFlowTravel = 600	
	BoomerLimit = 1
	SpitterLimit = 1
	SmokerLimit = 2
	HunterLimit = 2
	ChargerLimit = 1
	SpecialRespawnInterval = 20.0
	PreferredMobDirection = SPAWN_ANYWHERE
}

Director.ResetMobTimer()