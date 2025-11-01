Msg("Tank announcer loaded\n");

// Globals to track the number of Tanks alive, and if the hint has been shown
numTankAlive <- 0;
bHintShown <- false;

// Spawn tank announcement hint at the start of the round
function TankHintSpawn(params)
{
	local env_tank_hint = SpawnEntityFromTable("env_instructor_hint",
	{
		targetname = "env_tank_hint",
		hint_static = 1,
		hint_timeout = 7.5,
		hint_range = 0,
		hint_nooffscreen = 0,
		hint_icon_onscreen = "zombie_team_tank",
		hint_icon_offscreen = "zombie_team_tank",
		hint_binding = "",
		hint_forcecaption = 1,
		hint_color = "255 255 255",
		hint_caption = "Get ready to fight the Tank!"
	});
}

function UpdateTankHint()
{
	// Show the hint once the Tank becomes aggro and prevent it from showing again in the same fight
	// This behaves similar to the music where if a second tank spawns while one is already up it will not restart the music until all tanks are dead
	if (Director.IsTankInPlay() && bHintShown == false)
	{
		EntFire("env_tank_hint", "ShowHint");
		bHintShown = true;
	}
}

function TankAnnounceSpawn(params)
{
	numTankAlive += 1;
}

function TankAnnounceKilled(params)
{
	numTankAlive -= 1;

	// If all tanks died make it possible to fire hint again
	if (numTankAlive == 0) {bHintShown = false}
}