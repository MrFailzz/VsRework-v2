Msg("VERSUS++\n");

IncludeScript("versus/cvartweaks");
IncludeScript("versus/damagetweaks");
IncludeScript("versus/molotovtweaks");
IncludeScript("versus/stuckwarpfix");
IncludeScript("versus/tankannounce");
IncludeScript("versus/misctweaks");

////////////////////////
// Stock functions
////////////////////////
function Update()
{
	for (local player; (player = Entities.FindByClassname(player, "player")) != null;)
	{
		if (player.IsValid())
		{
			UpdateStuckwarp(player)
		}
	}
}

function OnGameEvent_tank_spawn(params)
{
	TankAnnounceSpawn(params);
}

function OnGameEvent_tank_killed(params)
{
	TankAnnounceKilled(params);
}

function OnGameEvent_molotov_thrown(params)
{
	CSMolotov(params);
}

function OnGameEvent_weapon_zoom(params)
{
	SniperScopeFix(params);
}