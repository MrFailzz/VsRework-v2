Msg("Initiating Onslaught\n");

DirectorOptions <-
{
	// This turns off tanks and witches.
	ProhibitBosses = true

	PreferredMobDirection = SPAWN_IN_FRONT_OF_SURVIVORS
	MobSpawnMinTime = 8
	MobSpawnMaxTime = 8
	MobMaxPending = 30
	MobMinSize = 25
	MobMaxSize = 30
	SustainPeakMinTime = 1
	SustainPeakMaxTime = 3
	IntensityRelaxThreshold = 0.90
	RelaxMinInterval = 1
	RelaxMaxInterval = 5
	RelaxMaxFlowTravel = 200

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
			MobSpawnMinTime = 12;
			MobSpawnMaxTime = 12;
			lastTime = currentTime;
		}
		else if (MobMinSize <= 10 && currentTime - lastTime >= 25)
		{
			MobMinSize = 25;
			MobSpawnMinTime = 8;
			MobSpawnMaxTime = 8;
			lastTime = currentTime;
		}
	}
}

Director.ResetMobTimer()
Director.PlayMegaMobWarningSounds()

function Update()
{
	DirectorOptions.RecalculateLimits();
}