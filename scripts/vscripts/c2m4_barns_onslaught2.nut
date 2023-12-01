Msg("Initiating Onslaught\n");

DirectorOptions <-
{
	// This turns off tanks and witches.
	ProhibitBosses = false
	
	//LockTempo = true
	MobSpawnMinTime = 5
	MobSpawnMaxTime = 5
	MobMinSize = 30
	MobMaxSize = 30
	MobMaxPending = 30
	SustainPeakMinTime = 1
	SustainPeakMaxTime = 3
	IntensityRelaxThreshold = 0.95
	RelaxMinInterval = 1
	RelaxMaxInterval = 5
	RelaxMaxFlowTravel = 200
	SpecialRespawnInterval = 1.0
        SmokerLimit = 2
        JockeyLimit = 0
        BoomerLimit = 0
        HunterLimit = 2
        ChargerLimit = 1
	PreferredMobDirection = SPAWN_IN_FRONT_OF_SURVIVORS
	ZombieSpawnRange = 2000

	lastTime = 0

	function RecalculateLimits()
	{
		// Decrease mob sizes the longer the event goes on with a min cap  
	    local Time = Time();

		if (MobMinSize > 20) lastTime = Time, MobMinSize -= 1;
		if (Time - lastTime >= 10 && MobMinSize <= 20) MobMinSize -= 2;

	    if (MobMinSize <= 10) MobMinSize = 10, MobSpawnMinTime = 12, MobSpawnMaxTime = 12;
	}
}

Director.ResetMobTimer()

function Update()
{
	DirectorOptions.RecalculateLimits();
}