Msg("VERSUS++\n");

// CVAR tweaks (gamemodes.txt)
Convars.SetValue("upgrade_laser_sight_spread_factor", 0.75)
Convars.SetValue("z_max_survivor_damage", 100)
Convars.SetValue("z_jockey_control_variance", 0)
Convars.SetValue("z_jockey_control_min", 0.68)
Convars.SetValue("z_jockey_control_max", 0.68)
Convars.SetValue("versus_tank_flow_team_variation", 0.00)
Convars.SetValue("versus_witch_flow_team_variation", 0.00)
Convars.SetValue("z_tank_damage_slow_min_range", -600)
Convars.SetValue("z_witch_damage_per_kill_hit", 20)
Convars.SetValue("z_witch_wander_personal_time", 7)

// Scoring Tweaks
survivorBonus <- 25
Convars.SetValue("vs_survival_bonus", 25)
Convars.SetValue("vs_defib_penalty", 0)

// Reduce bonus when medkits used
function OnGameEvent_heal_success(params)
{
	Convars.SetValue("vs_survival_bonus", survivorBonus - 2);
	survivorBonus -= 2;

	// Do not let survival bonus go below 0
	if (Convars.GetFloat("vs_survival_bonus") < 0)
		Convars.SetValue("vs_survival_bonus", 0);
}

// Reduce bonus when defibs used
function OnGameEvent_defibrillator_used(params)
{
	Convars.SetValue("vs_survival_bonus", survivorBonus - 2);
	survivorBonus -= 2;
	
	// Do not let survival bonus go below 0
	if (Convars.GetFloat("vs_survival_bonus") < 0)
		Convars.SetValue("vs_survival_bonus", 0);
}

// Scale tiebreaker w/ distance pts
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

// Autosniper tweaks
function AllowTakeDamage(damageTable)
{
	// Table values
	local damageDone = damageTable.DamageDone;
	local originalDamageDone = damageTable.DamageDone;
	local attacker = damageTable.Attacker;
	local victim = damageTable.Victim;
	local attackerPlayer = null;
	local attackerClass = null;
	local attackerType = null;
	local victimPlayer = null;
	local victimType = null;
	local weapon = damageTable.Weapon;
	local weaponClass = null;
	if (weapon != null)
	{
		weaponClass = weapon.GetClassname();
	}
	local damageType = damageTable.DamageType;

	// Modifiers
	local damageModifier = 0.90;

	// Modify Attacker damage
	if (attacker.IsValid())
	{
		if (attacker.IsPlayer())
		{
			// Survivor dealing damage
			if (attacker.IsSurvivor())
			{
				// Modify autosniper DMG
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
*/

// AWP Tweaks
// Reserve Ammo
Convars.SetValue("ammo_minigun_max", 20);

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