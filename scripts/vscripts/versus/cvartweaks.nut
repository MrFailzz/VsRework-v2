Msg("Convar tweaks loaded\n");

// Convar tweaks typically found in gamemodes.txt
Convars.SetValue("z_hunter_limit", 1);								// Normally set to 2 (presumably unintentionally?)
Convars.SetValue("z_smoker_limit", 1);								// Normally set to 2 (presumably unintentionally?)
Convars.SetValue("versus_tank_flow_team_variation", 0.0);
Convars.SetValue("versus_witch_flow_team_variation", 0.0);
Convars.SetValue("z_tank_damage_slow_min_range", -200);				// Minimizes the effective slowdown curve against the Tank
Convars.SetValue("z_witch_damage_per_kill_hit", 20);				// Increases Witch DMG vs incapped survivors
Convars.SetValue("z_witch_wander_personal_time", 7);				// Increases standing Witch aggro time
Convars.SetValue("upgrade_laser_sight_spread_factor", 0.67);		// Decreases accuracy buff from Laser upgrade
Convars.SetValue("adrenaline_run_speed", 240);						// Lower adrenaline player move speed
Convars.SetValue("z_pounce_damage_interrupt", 185);					// Increases DMG needed to kill a hunter that is midair
Convars.SetValue("z_jockey_control_variance", 0.0);					// Removes randomized control between survivor and jockey
Convars.SetValue("z_jockey_control_min", 0.68);						// Set jockey ride speed to be consistent
Convars.SetValue("z_jockey_control_max", 0.68);
Convars.SetValue("z_spit_interval", 15);
Convars.SetValue("z_vomit_interval", 12);
//Convars.SetValue("z_jockey_speed", 260);
//Convars.SetValue("versus_shove_hunter_fov_pouncing", 25);
//Convars.SetValue("versus_shove_jockey_fov_leaping", 25);
Convars.SetValue("vs_tiebreak_bonus", 20 + (Director.GetMapNumber() * 5));      // Scale tiebreaker amount with distance points