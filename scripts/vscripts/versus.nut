Msg("VERSUS++\n");

////////////////////////
// Globals
////////////////////////
baseShovePenalty <- [0, 0, 0, 0];

////////////////////////
// CVAR tweaks 
////////////////////////
// (gamemodes.txt)
Convars.SetValue("z_hunter_limit", 1);
Convars.SetValue("z_smoker_limit", 1);
Convars.SetValue("z_pounce_damage_interrupt", 185);
Convars.SetValue("z_max_stagger_duration", 4);
Convars.SetValue("z_max_survivor_damage", 100);
Convars.SetValue("z_jockey_control_variance", 0.35);
//Convars.SetValue("z_jockey_control_min", 0.68);
//Convars.SetValue("z_jockey_control_max", 0.68);
Convars.SetValue("versus_tank_flow_team_variation", 0.00);
Convars.SetValue("versus_witch_flow_team_variation", 0.00);
Convars.SetValue("z_tank_damage_slow_min_range", -400);
Convars.SetValue("z_witch_damage_per_kill_hit", 20);
Convars.SetValue("z_witch_wander_personal_time", 7);
Convars.SetValue("upgrade_laser_sight_spread_factor", 0.67);
Convars.SetValue("z_gun_swing_vs_min_penalty", 5);
Convars.SetValue("z_gun_swing_vs_max_penalty", 7);
Convars.SetValue("ammo_minigun_max", 60);

////////////////////////
// Stock functions
////////////////////////
function GetSurvivorID(player)
{
	switch(player.GetModelName())
	{
		case "models/survivors/survivor_gambler.mdl":
			return 0;
			break;
		case "models/survivors/survivor_producer.mdl":
			return 1;
			break;
		case "models/survivors/survivor_coach.mdl":
			return 2;
			break;
		case "models/survivors/survivor_mechanic.mdl":
			return 3;
			break;
		case "models/survivors/survivor_namvet.mdl":
			return 0;
			break;
		case "models/survivors/survivor_teenangst.mdl":
			return 1;
			break;
		case "models/survivors/survivor_manager.mdl":
			return 2;
			break;
		case "models/survivors/survivor_biker.mdl":
			return 3;
			break;
		default:
			return -1;
			break;
	}
}
::GetSurvivorID <- GetSurvivorID;

function GetVectorDistance(vec1, vec2)
{
	return sqrt(pow(vec1.x - vec2.x,2) + pow(vec1.y - vec2.y,2) + pow(vec1.z - vec2.z,2));
}
::zGetVectorDistance <- GetVectorDistance;

function Update()
{
	local player = null;
	while ((player = Entities.FindByClassname(player, "player")) != null)
	{
		if (player.IsValid())
		{
			if (player.IsSurvivor())
			{
				ApplyShovePenalties(player);
				UpdateShovePenalty(player);
				//UpdateScoring(player);
			}
		}
	}
}

////////////////////////
// Damage tweaks
////////////////////////
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
	if (weapon != null) weaponClass = weapon.GetClassname();
	local damageType = damageTable.DamageType;

	// Modifiers
	local sniperModifier = 0.90;
	local smgModifier = 0.90625;

	// Modify Attacker damage
	if (attacker.IsValid())
	{
		if (attacker.IsPlayer())
		{
			if (attacker.IsSurvivor())
			{
				//Attack Specific Variables
				if (victim.IsValid())
				{
					victimPlayer = victim.IsPlayer();
					victimType = victim.GetClassname();
				}

				if (victimPlayer)
				{
					// Modify autosniper DMG
                    if (weaponClass == "weapon_hunting_rifle" || weaponClass == "weapon_sniper_military")
                    {
                        if (victim.GetZombieType() == 8) damageDone = damageDone * sniperModifier;
                    }
					// Modify smg headshot DMG
					if (weaponClass == "weapon_smg_silenced")
					{
						if ((damageType & DMG_HEADSHOT) == DMG_HEADSHOT) damageDone = damageDone * smgModifier;
					}
				}
			}
		}
	}
	
	damageTable.DamageDone = damageDone;
	return true;
}

////////////////////////
// Slowdown Rework
////////////////////////
function PlayerHurt(params)
{
	local player = GetPlayerFromUserID(params.userid);
	local attacker = GetPlayerFromUserID(params.attacker);

	if (player.IsValid())
	{
		if (player.GetZombieType() != 8)
		{
			if ("type" in params)
			{
				// DMG_BULLET
				if (params.type == 2)
				{
					NetProps.SetPropFloat(player, "m_flVelocityModifier", 1.0);

					// Daroot Tank slowdown reverse engineered
					local rangeMod = 1.0;
					local distance = GetVectorDistance(attacker.GetOrigin(), player.GetOrigin())
					local minRange = 200
					local maxRange = 400
					if (distance > maxRange) rangeMod = 0.0;
					else if (distance > minRange) rangeMod = 1.0 - (distance - minRange) / (maxRange - minRange);

					if (rangeMod > 0.0 && rangeMod <= 1.0) rangeMod = (1.0 - rangeMod) * 0.3 + 0.7;
					if (rangeMod < NetProps.GetPropFloat(player, "m_flVelocityModifier")) NetProps.SetPropFloat(player, "m_flVelocityModifier", rangeMod);
				}
			}
		}
	}
}

////////////////////////
// Shove Rework
////////////////////////
function ApplyShovePenalties(player)
{
	local survivorID = GetSurvivorID(player);
	local weaponClass = "";
	local weapon = player.GetActiveWeapon();
	local shovePenalty = 0;

	if (weapon != null)
	{
		if (weapon.IsValid())
		{
			weaponClass = weapon.GetClassname();

			switch(weaponClass)
			{
				case "weapon_pistol_magnum":
				case "weapon_smg":
				case "weapon_smg_silenced":
					shovePenalty += 1;
				break;
				case "weapon_melee":
				case "weapon_shotgun_chrome":
				case "weapon_pumpshotgun":
				case "weapon_sniper_scout":
				case "weapon_rifle":
				case "weapon_rifle_sg552":
				case "weapon_rifle_desert":
					shovePenalty += 2;
				break;

				case "weapon_rifle_ak47":
				case "weapon_hunting_rifle":
					shovePenalty += 3;
				break;
				case "weapon_autoshotgun":
				case "weapon_shotgun_spas":
				case "weapon_sniper_military":
				case "weapon_sniper_awp":
					shovePenalty += 4;
				break;
				default:
					shovePenalty = 0;
				break;
			}
		}
	}

	// Weapons now have unique "stamina" in regards to shoving
	baseShovePenalty[survivorID] = shovePenalty;
}

function UpdateShovePenalty(player)
{
	local survivorID = GetSurvivorID(player);
	local shovePenalty = NetProps.GetPropInt(player, "m_iShovePenalty");

	if (shovePenalty < baseShovePenalty[survivorID]) NetProps.SetPropInt(player, "m_iShovePenalty", baseShovePenalty[survivorID]);
}

////////////////////////
// Tank Announce
////////////////////////
function OnGameEvent_tank_spawn(params)
{
	local env_tank_hint = SpawnEntityFromTable("env_instructor_hint",
	{
		targetname = "env_tank_hint",
		hint_static = 1,
		hint_timeout = 10,
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
	EntFire("env_tank_hint", "ShowHint")
}

////////////////////////
// CS Sniper Zoom
////////////////////////
function OnGameEvent_weapon_zoom(params)
{
	local player = GetPlayerFromUserID(params.userid);
	local weapon = player.GetActiveWeapon();
	local weaponClass = null;
	if (weapon != null) weaponClass = weapon.GetClassname();

	if (weaponClass == "weapon_sniper_scout")
	{
		if (NetProps.GetPropInt(player, "m_iFOVStart") == 90) NetProps.SetPropInt(player, "m_iFOV", 30);
		if (NetProps.GetPropInt(player, "m_iFOVStart") == 30) NetProps.SetPropInt(player, "m_iFOV", 0);
	}
	if (weaponClass == "weapon_sniper_awp")
	{
		if (NetProps.GetPropInt(player, "m_iFOVStart") == 90) NetProps.SetPropInt(player, "m_iFOV", 45);
		if (NetProps.GetPropInt(player, "m_iFOVStart") == 45) NetProps.SetPropInt(player, "m_iFOV", 25);
		if (NetProps.GetPropInt(player, "m_iFOVStart") == 25) NetProps.SetPropInt(player, "m_iFOV", 0);
	}
}