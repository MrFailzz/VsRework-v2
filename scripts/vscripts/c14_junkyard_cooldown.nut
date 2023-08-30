Msg("Initiating Crescendo Cooldown\n");

DirectorOptions <-
{
	ProhibitBosses = true

	MobSpawnMinTime = 20
	MobSpawnMaxTime = 35
	MobMinSize = 10
	MobMaxSize = 25
	MobMaxPending = 10
	SustainPeakMinTime = 5
	SustainPeakMaxTime = 8
	IntensityRelaxThreshold = 0.9
	RelaxMinInterval = 10
	RelaxMaxInterval = 15
	RelaxMaxFlowTravel = 1000	
	BoomerLimit = 1
	SpitterLimit = 1
	SmokerLimit = 2
	HunterLimit = 2
	ChargerLimit = 1
	SpecialRespawnInterval = 45.0
	PreferredMobDirection = SPAWN_ANYWHERE
}

Director.ResetMobTimer()

//EntFire( "drop_button","AddOutput","OnPressed director:RunScriptCode:c14m1_junkyard_end():4:-1");
