Msg("Damage tweaks loaded\n");

// Weapon damage rebalance
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
	local dmgMod = 1;

	// Modify Attacker damage
	if (attacker.IsValid())
	{
		if (attacker.IsPlayer())
		{
			//if (!attacker.IsSurvivor()) {return true}

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
					case "weapon_rifle_ak47":
						dmgMod = 0.935;
					break;
					case "weapon_hunting_rifle":
					case "weapon_sniper_military":
						rangeMod = pow(0.97, distance / 500);
					break;
				}

				//if (victim.GetZombieType() == 8) {damageDone = damageDone * rangeMod * tankMod}
				damageDone = damageDone * rangeMod * dmgMod;
			}
		}
	}

	damageTable.DamageDone = damageDone;
	return true;
}