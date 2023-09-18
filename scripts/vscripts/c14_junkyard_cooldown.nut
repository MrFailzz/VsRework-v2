Msg("Initiating Crescendo Cooldown\n");

DirectorOptions <-
{
	ProhibitBosses = true

	MobSpawnMinTime = 25
	MobSpawnMaxTime = 45
	MobMinSize = 10
	MobMaxSize = 25
	MobMaxPending = 30
	SustainPeakMinTime = 5
	SustainPeakMaxTime = 8
	IntensityRelaxThreshold = 0.9
	RelaxMinInterval = 15
	RelaxMaxInterval = 25
	RelaxMaxFlowTravel = 800	
	BoomerLimit = 1
	SpitterLimit = 1
	SmokerLimit = 2
	HunterLimit = 2
	ChargerLimit = 1
	SpecialRespawnInterval = 45.0
	PreferredMobDirection = SPAWN_ANYWHERE
}

Director.ResetMobTimer()