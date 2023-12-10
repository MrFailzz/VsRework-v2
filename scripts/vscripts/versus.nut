Msg("VERSUS++\n");

////////////////////////
// Globals
////////////////////////
firstTank <- true;

////////////////////////
// CVAR tweaks 
////////////////////////
// (gamemodes.txt)
Convars.SetValue("z_hunter_limit", 1);								// Normally set to 2 (presumably unintentionally?)
Convars.SetValue("z_smoker_limit", 1);								// Normally set to 2 (presumably unintentionally?)
Convars.SetValue("versus_tank_flow_team_variation", 0.0);
Convars.SetValue("versus_witch_flow_team_variation", 0.0);
Convars.SetValue("z_tank_damage_slow_min_range", -400);				// Minimizes the effective slowdown curve against the Tank
Convars.SetValue("z_witch_damage_per_kill_hit", 20);				// Increases Witch DMG vs incapped survivors
Convars.SetValue("z_witch_wander_personal_time", 7);				// Increases standing Witch aggro time
//Convars.SetValue("upgrade_laser_sight_spread_factor", 0.67);		// Decreases accuracy buff from Laser upgrade
//Convars.SetValue("z_pounce_damage_interrupt", 185);					// Increases DMG needed to kill a hunter that is midair
Convars.SetValue("z_jockey_control_variance", 0);					// Removes randomized control between survivor and jockey
Convars.SetValue("z_jockey_control_min", 0.68);						// Set jockey ride speed to be consistent
Convars.SetValue("z_jockey_control_max", 0.68);
Convars.SetValue("z_max_survivor_damage", 100);						// Max amount of DMG points that can be given for hitting survivors
Convars.SetValue("ammo_minigun_max", 30);

////////////////////////
// Stock functions
////////////////////////
function GetVectorDistance( vec1, vec2 )
{
	return sqrt( pow(vec1.x - vec2.x,2 ) + pow( vec1.y - vec2.y,2 ) + pow( vec1.z - vec2.z,2 ) );
}

function Update()
{
	for ( local player; ( player = Entities.FindByClassname( player, "player" ) ) != null; ) 
	{
		if ( player.IsValid() ) { UpdateStuckwarp( player ); } 
	}
}

////////////////////////
// Damage tweaks
////////////////////////
function AllowTakeDamage( damageTable )
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
	if ( weapon != null ) { weaponClass = weapon.GetClassname(); }
	local damageType = damageTable.DamageType;
	local distance = null;
	local rangeMod = null;

	// Modifiers
	local sniperBaseDmg = 80;
	local sniperRangeMod = 0.97;
	local sniperTankMod = 0.875;
	local ak47TankMod = 0.935;

	// Modify Attacker damage
	if ( attacker.IsValid() )
	{
		if ( attacker.IsPlayer() )
		{
			if ( attacker.IsSurvivor() )
			{
				//Attack Specific Variables
				if ( victim.IsValid() )
				{
					victimPlayer = victim.IsPlayer();
					victimType = victim.GetClassname();
					distance = GetVectorDistance( attacker.GetOrigin(), victim.GetOrigin() );
				}

				if ( victimPlayer )
				{
					switch( weaponClass )
					{
						case "weapon_rifle_ak47":
							if ( victim.GetZombieType() == 8 ) { damageDone = damageDone * ak47TankMod; }
						break;
						case "weapon_hunting_rifle":
						case "weapon_sniper_military":
							rangeMod = pow( sniperRangeMod, distance / 500 );

                       	 	if ( victim.GetZombieType() == 8 ) { damageDone = sniperBaseDmg * rangeMod * sniperTankMod; }
							else { damageDone = damageDone * rangeMod; }
						break;
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
function PlayerHurt( params )
{
	local player = GetPlayerFromUserID( params.userid );
	local attacker = GetPlayerFromUserID( params.attacker );
	if ( player.IsValid() ) 
	{
		if ( player.GetZombieType() != 8 ) 
		{ 
			if ( "type" in params ) 
			{
				// Remove slowdown when infected (not the Tank) are hit by DMG_BULLET
				if ( params.type == 2 ) 
				{
					local distance = GetVectorDistance( attacker.GetOrigin(), player.GetOrigin() );
					local oldVelMod = NetProps.GetPropFloat( player, "m_flVelocityModifier" );
					local newVelMod = pow( 0.9, distance / 500 );
					if ( distance < 500 && oldVelMod != newVelMod ) { NetProps.SetPropFloat(player, "m_flVelocityModifier", newVelMod); }
					else { NetProps.SetPropFloat( player, "m_flVelocityModifier", 1.0 ); } 
				} 
			} 
		} 
	}
}

////////////////////////
// Improve Stuckwarp
////////////////////////
function UpdateStuckwarp( player ) 
{
	// Check if player has been stuck for ~2s
	local stuckTime = NetProps.GetPropInt( player, "m_StuckLast" );
	if ( stuckTime < 800 ) { return }
	local playerOrigin = player.GetOrigin();
	local navTable = {};
	local closestNav = null;
    local closestDistance = null;
	NavMesh.GetNavAreasInRadius( playerOrigin, 192, navTable );

	// Check if nearby navs exist
	foreach ( area in navTable ) 
	{
		local navOrigin = area.GetCenter();
		local traceTableHeight = 
		{
			start = navOrigin
			end = navOrigin + Vector( 0, 0, 92 )
			mask = TRACE_MASK_VISION
			ignore = player 
		};

		// Check for player headroom and LOS
		// 72 units player height, but check for 92 units to be safe
		// Areas with displacements can be finnicky but these values have worked well
		if ( !TraceLine( traceTableHeight ) ) { continue }
		local distanceLOS = ( navOrigin - playerOrigin ).Length(); 
		local distanceHeight = ( navOrigin - traceTableHeight.pos ).Length();
		if ( distanceHeight == 92 && area.IsVisible( playerOrigin + Vector( 0, 0 , 48 ) ) ) 
		{
			// Check if current nav is closer than the previously checked nav
			if ( closestDistance == null || distanceLOS < closestDistance ) { closestDistance = distanceLOS; closestNav = navOrigin; } 
		}
	}
	// Warp player to nearest nav that meets headroom and LOS reqs
	// Increase z axis by 8 to ensure players do not get stuck in displacements
    if ( closestNav != null ) { player.SetOrigin( Vector( closestNav.x, closestNav.y, closestNav.z + 8 ) ); } 
}

////////////////////////
// Tank Announce
////////////////////////
function OnGameEvent_tank_spawn( params )
{
	if ( firstTank ) 
	{
		local env_tank_hint = SpawnEntityFromTable( "env_instructor_hint", 
		{
			targetname = "env_tank_hint",
			hint_static = 1,
			hint_timeout = 7.5,
			hint_range = 0,
			hint_nooffscreen = 0,
			hint_icon_onscreen = "zombie_team_tank",
			hint_icon_offscreen = "zombie_team_tank",
			hint_binding = "",
			hint_forcecaption = 1,
			hint_color = "255 255 255",
			hint_caption = "Get ready to fight the Tank!" 
		} );
		// Show instructor hint to prepare for the Tank
		// Prevent hint from firing again until tank is killed
		EntFire( "env_tank_hint", "ShowHint" ); firstTank = false; 
	}
}

function OnGameEvent_tank_killed( params )
{
	// If tank dies set firstTank to false so the hint can fire again
	firstTank = true;
}

////////////////////////
// CS Sniper Zoom
////////////////////////
function OnGameEvent_weapon_zoom( params )
{
	local player = GetPlayerFromUserID(params.userid);
	local weapon = player.GetActiveWeapon();
	local weaponClass = null;
	if ( weapon != null ) { weaponClass = weapon.GetClassname(); }

	if ( weaponClass == "weapon_sniper_scout" || weaponClass == "weapon_sniper_awp" ) 
	{
		// Fix AWP and Scout having zoom FOV that is inconsistent with other L4D snipers
		if ( NetProps.GetPropInt( player, "m_iFOVStart" ) == 90) { NetProps.SetPropInt(player, "m_iFOV", 30); }
		if ( NetProps.GetPropInt( player, "m_iFOVStart" ) == 30) { NetProps.SetPropInt(player, "m_iFOV", 0); } 
	}
}

////////////////////////
// AWP T3 Spawn
////////////////////////
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