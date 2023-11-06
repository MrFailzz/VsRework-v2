Msg("VERSUS++ Extras\n");

/*
// CS Molotov
// Precache detonate snd
if (!IsSoundPrecached("weapons/molotov/molotov_detonate_swt_01.wav"))
	PrecacheSound("weapons/molotov/molotov_detonate_swt_01.wav");

function OnGameEvent_molotov_thrown(params)
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
                    //Explosion VFX
                    local molotov_origin = molotov_projectile.GetOrigin();
                    local explEnt = SpawnEntityFromTable("info_particle_system",
                    {
                        targetname = "explEnt",
                        origin = molotov_origin,
                        start_active = 1,
                        effect_name = "fire_large_01"
                    });

                    EmitSoundOn("weapons/molotov/molotov_detonate_swt_01.wav", molotov_projectile);
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


// Spawns
function OnGameEvent_round_start(params)
{
	local weapon_awp = null;
	local weapon_launcher = null;

	// Remove AWP spawns
	while(weapon_awp = Entities.FindByModel(weapon_awp, "models/w_models/weapons/w_sniper_awp.mdl"))
		weapon_awp.Kill();                

	// Replace grenade launcher with AWP
	while(weapon_launcher = Entities.FindByModel(weapon_launcher, "models/w_models/weapons/w_grenade_launcher.mdl"))
    {
		local weapon_originX = weapon_launcher.GetOrigin().x;
        local weapon_originY = weapon_launcher.GetOrigin().y;
	    local weapon_originZ = weapon_launcher.GetOrigin().z;
	    local weapon_angleX = weapon_launcher.GetAngles().x;
	    local weapon_angleY = weapon_launcher.GetAngles().y;
	    local weaponName = "AWP_spawn";
	    local weaponSpawn = SpawnEntityFromTable("weapon_sniper_awp",
	    {
		    targetname = weaponName,
		    origin = Vector(weapon_originX, weapon_originY, weapon_originZ),
		    angles = Vector(weapon_angleX, weapon_angleY, 0)
		    solid = 0,
		    disableshadows = 1,
            ammo = 20,
	    });

		// Remove grenade launcher spawns
		weapon_launcher.Kill();                
    }
}
*/