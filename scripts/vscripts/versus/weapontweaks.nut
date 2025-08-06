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
	local adrenMod = 1;

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
						rangeMod = pow(0.98, distance / 500);
						if (distance > 8192) {damageDone = 0}
					break;
					case "weapon_sniper_military":
						damageDone = 65;
						rangeMod = pow(0.97, distance / 500);
						if (distance > 8192) {damageDone = 0}
					break;
					case "weapon_smg":
						rangeMod = pow(0.89, distance / 500);
						if (distance > 2500) {damageDone = 0}
					break;
				}

				// Halve damage when adrenaline is active
				if (victim.IsAdrenalineActive())
				{
					adrenMod = 0.67
					if (originalDamageDone >= 10) {NetProps.SetPropInt(victim, "m_bAdrenalineActive", 0)}
				}

				damageDone = damageDone * rangeMod * adrenMod;
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