Msg("VERSUS++\n");

// AWP Tweaks
Convars.SetValue("ammo_minigun_max", 20);

// Scoring Tweaks
if (Director.GetMapNumber() == 0)
	Convars.SetValue("vs_tiebreak_bonus", 40);

else if (Director.GetMapNumber() == 1)
	Convars.SetValue("vs_tiebreak_bonus", 50);

else if (Director.GetMapNumber() == 2)
	Convars.SetValue("vs_tiebreak_bonus", 60);

else if (Director.GetMapNumber() == 3)
	Convars.SetValue("vs_tiebreak_bonus", 70);
	
else if (Director.GetMapNumber() == 4)
	Convars.SetValue("vs_tiebreak_bonus", 80);

// Reduce Autosniper DMG vs Tanks
function AllowTakeDamage(damageTable)
{
	//Table values
	local damageDone = damageTable.DamageDone;
	local attacker = damageTable.Attacker;
	local attackerPlayer = attacker.IsPlayer();
	local attackerType = attacker.GetClassname();
	local victim = damageTable.Victim;
	local victimPlayer = victim.IsPlayer();
	local victimType = victim.GetClassname();
	local inflictor = damageTable.Inflictor;
	local inflictorClass = null;
	if (inflictor.IsValid())
	{
		inflictorClass = inflictor.GetClassname();
	}
	local weapon = damageTable.Weapon;
	local weaponClass = null;
	if (weapon != null)
	{
		weaponClass = weapon.GetClassname();
	}
	local damageType = damageTable.DamageType;

	//Modifiers
	local damageModifier = 0.85;

	//Modify Attacker damage
	if (attacker.IsValid())
	{
		if (attacker.IsPlayer())
		{
			//Survivor dealing damage
			if (attacker.IsSurvivor())
			{
				//Snipers
				if (weaponClass == "weapon_hunting_rifle" || weaponClass == "weapon_sniper_military")
				{
                    if (victimPlayer == true)
                    {
                        if (victim.GetZombieType() == 8)
                        {
                            damageDone = damageDone * damageModifier;
                        }
                    }
				}
			}
		}
	}
	
	damageTable.DamageDone = damageDone;
	return true;
}

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


function OnGameEvent_player_left_safe_area(params)
{
	local ItemstoRemove_ModelPaths =
	[
		"models/w_models/weapons/w_sniper_awp.mdl",
	];

	// Remove regular AWP spawn
	foreach(modelpath in ItemstoRemove_ModelPaths)
	{
		local weapon_ent = null;
		while(weapon_ent = Entities.FindByModel(weapon_ent, modelpath))
		    weapon_ent.Kill();                
	}

	local ItemstoRemove_ModelPaths =
	[
        "models/w_models/weapons/w_grenade_launcher.mdl",
	];

	// Spawn AWP in T3 place
	foreach(modelpath in ItemstoRemove_ModelPaths)
	{
		local weapon_ent = null;
		while(weapon_ent = Entities.FindByModel(weapon_ent, modelpath))
            {
				// Create AWP
		    	local weapon_originX = weapon_ent.GetOrigin().x;
                local weapon_originY = weapon_ent.GetOrigin().y;
	            local weapon_originZ = weapon_ent.GetOrigin().z;
	            local weapon_angleX = weapon_ent.GetAngles().x;
	            local weapon_angleY = weapon_ent.GetAngles().y;
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

		    	weapon_ent.Kill();                
            }
	}
}
