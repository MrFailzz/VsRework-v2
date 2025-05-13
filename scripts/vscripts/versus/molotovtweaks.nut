Msg("Molotov balance tweaks loaded\n");

// Precache detonate snd
if (!IsSoundPrecached("weapons/molotov/molotov_detonate_swt_01.wav"))
	PrecacheSound("weapons/molotov/molotov_detonate_swt_01.wav");

// CS Molotov detonate after 3s of airtime
function CSMolotov(params)
{
	local player = GetPlayerFromUserID(params["userid"]);
	if (player.ValidateScriptScope())
	{
		local player_entityscript = player.GetScriptScope();
		player_entityscript["TickCount"] <- 0;
        player_entityscript["MolotovKill"] <- function()
		{
			if (player_entityscript["TickCount"] == 10)
			{
                local molotov_projectile = null;
                if ((molotov_projectile = Entities.FindByClassname(molotov_projectile, "molotov_projectile")) != null)
                {
					// Check how far molotov is from the ground
					local molotov_origin = molotov_projectile.GetOrigin();
					local traceTable =
					{
						start = molotov_origin
						end = molotov_origin + Vector(0, 0, -128)
						ignore = player
					};

					// If molotov is within 128 units do not continue to explode
					if (TraceLine(traceTable))
					{
						if (traceTable.hit) {return}
					}

                    // Explosion VFX
                    local explEnt = SpawnEntityFromTable("info_particle_system",
                    {
                        targetname = "explEnt",
                        origin = molotov_origin,
                        start_active = 1,
                        effect_name = "fire_large_01"
					});

					// Explosion SFX
					local players = null;
					while(players = Entities.FindByClassname(players, "player"))
					{
						EmitAmbientSoundOn("weapons/molotov/molotov_detonate_swt_01.wav", 0.5, 95, 100, players);
					}

					// Stop looping molotov sound before killing entity
					StopAmbientSoundOn("weapons/molotov/fire_loop_1.wav", molotov_projectile);
                    molotov_projectile.Kill();
				}
			}
            else if (player_entityscript["TickCount"] >= 11)
            {
                EntFire("explEnt", "Kill");
                return
			}
			player_entityscript["TickCount"]++;
			return
		}
        AddThinkToEnt(player, "MolotovKill");
	}
}