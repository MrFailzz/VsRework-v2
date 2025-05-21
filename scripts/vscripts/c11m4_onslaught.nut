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

	cooldownTimer = 25

	function RecalculateLimits()
	{
		// Decrease mob sizes as the event goes on, and then cycle it back to default settings
		if (MobMinSize > 20)
		{
			MobMinSize -= 1;
		}
		else if (MobMinSize > 10 && cooldownTimer <= 0)
		{
			MobMinSize = 10;
			MobSpawnMaxTime = 12;
			cooldownTimer = 15;
		}
		else if (MobMinSize <= 10 && cooldownTimer <= 0)
		{
			MobMinSize = 25;
			MobSpawnMaxTime = 8;
			cooldownTimer = 15;
		}

		cooldownTimer--;
	}
}

Director.ResetMobTimer()
Director.PlayMegaMobWarningSounds()

function Update()
{
	DirectorOptions.RecalculateLimits();
}