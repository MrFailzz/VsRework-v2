Msg("VERSUS++\n");

// CVAR tweaks (gamemodes.txt)
Convars.SetValue("z_hunter_limit", 1);
Convars.SetValue("z_smoker_limit", 1);
Convars.SetValue("z_pounce_damage_interrupt", 190);
Convars.SetValue("upgrade_laser_sight_spread_factor", 0.67);
Convars.SetValue("z_max_survivor_damage", 100);
Convars.SetValue("z_jockey_control_variance", 0.35);
//Convars.SetValue("z_jockey_control_min", 0.68);
//Convars.SetValue("z_jockey_control_max", 0.68);
Convars.SetValue("versus_tank_flow_team_variation", 0.00);
Convars.SetValue("versus_witch_flow_team_variation", 0.00);
Convars.SetValue("z_tank_damage_slow_min_range", -400);
Convars.SetValue("z_witch_damage_per_kill_hit", 20);
Convars.SetValue("z_witch_wander_personal_time", 7);
Convars.SetValue("z_gun_swing_vs_min_penalty", 5);
Convars.SetValue("z_gun_swing_vs_max_penalty", 7);
Convars.SetValue("ammo_minigun_max", 60);

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
	Convars.SetValue("vs_tiebreak_bonus", 20);

else if (Director.GetMapNumber() == 1)
	Convars.SetValue("vs_tiebreak_bonus", 25);

else if (Director.GetMapNumber() == 2)
	Convars.SetValue("vs_tiebreak_bonus", 30);

else if (Director.GetMapNumber() == 3)
	Convars.SetValue("vs_tiebreak_bonus", 35);
	
else if (Director.GetMapNumber() == 4)
	Convars.SetValue("vs_tiebreak_bonus", 40);

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
                    if (victimPlayer)
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

// Shove Rework
// Weapons now have unique "stamina" in regards to shoving
baseShovePenalty <- [0, 0, 0, 0];

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
			}
		}
	}
}

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

	baseShovePenalty[survivorID] = shovePenalty;
}

function UpdateShovePenalty(player)
{
	local survivorID = GetSurvivorID(player);
	local shovePenalty = NetProps.GetPropInt(player, "m_iShovePenalty");

	if (shovePenalty < baseShovePenalty[survivorID])
	{
		NetProps.SetPropInt(player, "m_iShovePenalty", baseShovePenalty[survivorID]);
	}
}