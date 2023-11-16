Msg("Initiating Onslaught\n");

DirectorOptions <-
{
	// This turns off tanks and witches.
	ProhibitBosses = true

	PreferredMobDirection = SPAWN_IN_FRONT_OF_SURVIVORS
	MobSpawnMinTime = 1
	MobSpawnMaxTime = 2
	MobMaxPending = 30
	MobMinSize = 20
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

		if (Time - lastTime >= 5 && MobMinSize > 15) lastTime = Time, MobMinSize -= 1;
		if (Time - lastTime >= 10 && MobMinSize <= 15) MobMinSize -= 1;

	    if (MobMinSize <= 10) Director.EndScript();
	}
}

Director.ResetMobTimer()

function Update()
{
	DirectorOptions.RecalculateLimits();
}