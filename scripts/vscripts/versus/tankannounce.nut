Msg("Tank announcer loaded\n");

// Global to track if a Tank fight has already started
firstTank <- true;

// Tank announcement message using Director Hints
function TankAnnounceSpawn(params)
{
	if (firstTank)
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
		// Show instructor hint to prepare for the Tank
		// Prevent hint from firing again until tank is killed
		EntFire("env_tank_hint", "ShowHint");
		firstTank = false;
	}
	// Reduce SI respawn while tank is up
	Convars.SetValue("z_ghost_delay_min", 14);
}

function TankAnnounceKilled(params)
{
	// If tank dies set firstTank to false so the hint can fire again
	firstTank = true;

	// Reset SI respawn while tank dies
	Convars.SetValue("z_ghost_delay_min", 20);
}