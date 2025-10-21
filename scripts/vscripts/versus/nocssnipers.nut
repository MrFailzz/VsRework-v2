Msg("No CS Snipers loaded\n");

// Remove CS snipers
DirectorOptions <-
{
 	weaponsToConvert =
 	{
		weapon_sniper_awp = "weapon_sniper_military_spawn"
		weapon_sniper_scout = "weapon_hunting_rifle_spawn"
 	}

 	function ConvertWeaponSpawn(classname)
 	{
 		if (classname in weaponsToConvert)
 		{
 			return weaponsToConvert[classname];
		}
		return 0;
	}
}