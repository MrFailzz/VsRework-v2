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
		// Decrease mob sizes as the event goes on, and then cycle it back to default settings 
	    local currentTime = Time();

		if (MobMinSize > 20)
		{
			MobMinSize -= 1;
			lastTime = currentTime;
		}	
		else if (MobMinSize > 10 && currentTime - lastTime >= 15) 
		{
			MobMinSize = 10;
			MobSpawnMinTime = 8;
			MobSpawnMaxTime = 8;
			lastTime = currentTime;
		}
		else if (MobMinSize <= 10 && currentTime - lastTime >= 25)
		{
			MobMinSize = 30;
			MobSpawnMinTime = 5;
			MobSpawnMaxTime = 5;
			lastTime = currentTime;
		}
	}
}

Director.ResetMobTimer()

function Update()
{
	DirectorOptions.RecalculateLimits();
}