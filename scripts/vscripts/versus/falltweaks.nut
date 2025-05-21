Msg("Fall tweaks loaded\n");

function NoDefibOnFalling(params)
{
	local damageDone = params.dmg_health;
	local victim = GetPlayerFromUserID(params.userid);
	local victimHealth = victim.GetHealth();

	// Check if player is in a hanging state
	local isHanging = NetProps.GetPropInt(victim, "m_isHangingFromLedge");

	// If a survivor is hanging from a ledge and dies from another source of damage force them into falling state
	if (isHanging == 1 && victimHealth - damageDone <= 0) {NetProps.SetPropInt(victim, "m_isFallingFromLedge", 1)}

	// If player takes dies from fall damage prevent them from being defibbed
	if (params.type == 32 && victimHealth - damageDone <= 0) {NetProps.SetPropInt(victim, "m_isFallingFromLedge", 1)}
}