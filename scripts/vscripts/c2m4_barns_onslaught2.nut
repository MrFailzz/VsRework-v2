Msg("Initiating Onslaught\n");

DirectorOptions <-
{
	// This turns off tanks and witches.
	ProhibitBosses = false

	//LockTempo = true
	MobSpawnMinTime = 3
	MobSpawnMaxTime = 3
	MobMinSize = 30
	MobMaxSize = 30
	MobMaxPending = 30
	SustainPeakMinTime = 1
	SustainPeakMaxTime = 3
	IntensityRelaxThreshold = 0.99
	RelaxMinInterval = 1
	RelaxMaxInterval = 5
	RelaxMaxFlowTravel = 150
	SpecialRespawnInterval = 1.0
        SmokerLimit = 2
        JockeyLimit = 0
        BoomerLimit = 0
        HunterLimit = 2
        ChargerLimit = 1
	PreferredMobDirection = SPAWN_IN_FRONT_OF_SURVIVORS
	ZombieSpawnRange = 2000

	cooldownTimer = 25

	function RecalculateLimits()
	{
		// Decrease mob sizes as the event goes on, and then cycle it back to default settings
		if (MobMinSize > 17)
		{
			MobMinSize -= 1;
		}
		else if (MobMinSize > 10 && cooldownTimer <= 0)
		{
			MobMinSize = 10;
			MobSpawnMaxTime = 8;
			cooldownTimer = 15;
		}
		else if (MobMinSize <= 10 && cooldownTimer <= 0)
		{
			MobMinSize = 30;
			MobSpawnMaxTime = 5;
			cooldownTimer = 15;
		}

		cooldownTimer--;
	}
}

Director.ResetMobTimer()

function Update()
{
	DirectorOptions.RecalculateLimits();
}