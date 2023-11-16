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
		// Decrease mob sizes the longer the event goes on with a min cap  
	    local Time = Time();

		if (Time - lastTime >= 5 && MobMinSize > 20) lastTime = Time, MobMinSize -= 1;
		if (Time - lastTime >= 15 && MobMinSize <= 20) MobMinSize -= 1;

	    if (MobMinSize <= 10) MobMinSize = 10;
	}
}

Director.ResetMobTimer()
Director.PlayMegaMobWarningSounds()

function Update()
{
	DirectorOptions.RecalculateLimits();
}