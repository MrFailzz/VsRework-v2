Msg("VERSUS++\n");

IncludeScript("versus/cvartweaks");
IncludeScript("versus/weapontweaks");
IncludeScript("versus/molotovtweaks");
IncludeScript("versus/stuckwarpfix");
IncludeScript("versus/tankannounce");
IncludeScript("versus/falltweaks");
IncludeScript("versus/nocssnipers");
IncludeScript("versus/misctweaks");

////////////////////////
// Stock functions
////////////////////////

// Math function to clamp result to not go below or above the min and max values
function Clamp(x, minVal, maxVal)
{
	if (x > minVal) {return minVal}
	if (x < maxVal) {return maxVal}
}

function Update()
{
	for (local player; (player = Entities.FindByClassname(player, "player")) != null;)
	{
		if (player.IsValid())
		{
			UpdateStuckwarp(player);
			UpdateTankHint();
		}
	}
}

////////////////////////
// Game events
////////////////////////

function OnGameEvent_round_start(params)
{
	TankHintSpawn(params);
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

function OnGameEvent_player_hurt_concise(params)
{
	NoDefibOnFalling(params);
}

function OnGameEvent_weapon_reload(params)
{
	WeaponReload(params);
}