Msg("Weapon tweaks loaded\n");

// Weapon damage tweaks
function AllowTakeDamage(damageTable)
{
	// Table values
	local damageDone = damageTable.DamageDone;
	local originalDamageDone = damageTable.DamageDone;
	local attacker = damageTable.Attacker;
	local victim = damageTable.Victim;
	local victimPlayer = null;
	local victimType = null;
	local weapon = damageTable.Weapon;
	local weaponClass = null;
	if (weapon != null) {weaponClass = weapon.GetClassname()}
	local damageType = damageTable.DamageType;
	local distance = null;

	// Modifiers
	local rangeMod = 1;
	local rangeModRegular = 1;
	local rangeModSniper = 1;

	// Weapon variables
	local distToMinDmg = 1500;
	local distToStartLoseDmg = 500;
	local maxDist = 8192;

	// Modify Attacker damage
	if (attacker.IsValid())
	{
		if (attacker.IsPlayer())
		{
			//Attack Specific Variables
			if (victim.IsValid())
			{
				victimPlayer = victim.IsPlayer();
				victimType = victim.GetClassname();
				distance = (attacker.GetOrigin(), victim.GetOrigin()).Length();
			}

			if (victimPlayer)
			{
				switch(weaponClass)
				{
					case "weapon_hunting_rifle":
						damageDone = 80;
						rangeMod = 0.97;
					break;
					case "weapon_sniper_military":
						damageDone = 80;
						rangeMod = 0.94;
					break;
					case "weapon_smg":
						rangeMod = 0.89;
						maxDist = 2500;
					break;
					case "weapon_pistol_magnum":
						rangeMod = 0.85;
						maxDist = 3500;
					break;
				}

				// Max distance before bullets do no damage
				if (distance > maxDist) {damageDone = 0}

				// Damage dropoff equations for weapons. Snipers have separate equation (not used currently)
				rangeModRegular = pow(rangeMod, distance / distToStartLoseDmg);
				//rangeModSniper = Clamp(0.5 + (1 - 0.5) * (distToMinDmg - distance) / (distToMinDmg - distToStartLoseDmg), 0.5, 1);

				// Final damage calculations
				damageDone = damageDone * rangeModRegular;
			}
		}
	}

	damageTable.DamageDone = damageDone;
	return true;
}

// Weapon reload tweaks
function WeaponReload(params)
{
	local player = GetPlayerFromUserID(params["userid"]);

	if (player != null)
	{
		if (player.IsPlayer())
		{
			if (player.IsSurvivor())
			{
				local weapon = player.GetActiveWeapon();
				local weaponClass = weapon.GetClassname();
				local weaponSequence = weapon.GetSequence();
				local baseReloadSpeed = weapon.GetSequenceDuration(weaponSequence);
				local reloadModifier = 1;

				switch(weaponClass)
				{
					case "weapon_sniper_military":
						reloadModifier = 0.9;
					break;
					case "weapon_rifle_ak47":
						reloadModifier = 0.9;
					break;
					case "weapon_rifle_sg552":
						reloadModifier = 1.1;
					break;
					case "weapon_smg_mp5":
						reloadModifier = 1.05;
					break;
				}

				local newReloadSpeed = baseReloadSpeed / reloadModifier;
				local oldNextAttack = NetProps.GetPropFloat(weapon, "m_flNextPrimaryAttack");
				local newNextAttack = oldNextAttack - baseReloadSpeed + newReloadSpeed;
				local playbackRate = baseReloadSpeed / newReloadSpeed;

				NetProps.SetPropFloat(weapon, "m_flNextPrimaryAttack", newNextAttack);
				NetProps.SetPropFloat(player, "m_flNextAttack", newNextAttack);
				NetProps.SetPropFloat(weapon, "m_flPlaybackRate", playbackRate);
			}
		}
	}
}

/*
function WeaponFirerate(params)
{
	local player = GetPlayerFromUserID(params["userid"]);

	if (player != null)
	{
		if (player.IsPlayer())
		{
			if (player.IsSurvivor())
			{
				local weapon = player.GetActiveWeapon();
				local weaponClass = weapon.GetClassname();
				local weaponClassExclude =
				[
					"weapon_molotov",
					"weapon_pipe_bomb",
					"weapon_vomitjar",
				];
				if (weaponClass in weaponClassExclude) {return}
				local weaponSequence = weapon.GetSequence();
				local baseFirerate = weapon.GetSequenceDuration(weaponSequence);
				local firerateModifier = GetFirerateModifier(player);

				switch(weaponClass)
				{
				}

				local newFirerate = baseFirerate / firerateModifier;
				local oldNextAttack = NetProps.GetPropFloat(weapon, "m_flNextPrimaryAttack");
				local newNextAttack = oldNextAttack - baseFirerate + newFirerate;
				local playbackRate = baseFirerate / newFirerate;

				NetProps.SetPropFloat(weapon, "m_flNextPrimaryAttack", newNextAttack);
				NetProps.SetPropFloat(player, "m_flNextAttack", newNextAttack);
				NetProps.SetPropFloat(weapon, "m_flPlaybackRate", playbackRate);
			}
		}
	}
}
*/