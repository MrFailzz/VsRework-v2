Msg("Misc tweaks loaded\n");

// CS Sniper FOV fix
function SniperScopeFix(params)
{
	local player = GetPlayerFromUserID(params.userid);
	local weapon = player.GetActiveWeapon();
	local weaponClass = null;
	if (weapon != null) {weaponClass = weapon.GetClassname()}

	if (weaponClass == "weapon_sniper_scout" || weaponClass == "weapon_sniper_awp")
	{
		// Fix AWP and Scout zoom FOV being inconsistent with other L4D snipers
		if (NetProps.GetPropInt(player, "m_iFOVStart") == 90) {NetProps.SetPropInt(player, "m_iFOV", 30)}
		if (NetProps.GetPropInt(player, "m_iFOVStart") == 30) {NetProps.SetPropInt(player, "m_iFOV", 0)}
	}
}

// AWP T3 Spawn
/*
function OnGameEvent_round_start(params)
{
	local weapon_awp = null;
	local weapon_launcher = null;

	// Remove AWP spawns
	while ( weapon_awp = Entities.FindByModel( weapon_awp, "models/w_models/weapons/w_sniper_awp.mdl" ) ) { weapon_awp.Kill(); }

	// Replace grenade launcher with AWP
	while ( weapon_launcher = Entities.FindByModel( weapon_launcher, "models/w_models/weapons/w_grenade_launcher.mdl" ) )
    {
		local weapon_origin = weapon_launcher.GetOrigin();
	    local weapon_angleX = weapon_launcher.GetAngles().x;
	    local weapon_angleY = weapon_launcher.GetAngles().y;
	    local weaponName = "AWP_spawn";

		// Remove Grenade Launcher spawns
		weapon_launcher.Kill();

	    local weaponSpawn = SpawnEntityFromTable( "weapon_sniper_awp",
	    {
		    targetname = weaponName,
		    origin = weapon_origin,
		    angles = Vector(weapon_angleX, weapon_angleY, 0),
		    solid = 0,
		    disableshadows = 1,
            ammo = 30,
	    } );
    }
}
*/