Msg("Stuckwarp fix loaded\n");

// Alternate stuckwarp functionality warp player to nearest nav tile
function UpdateStuckwarp(player)
{
	// Check if player has been stuck for ~2s
	local stuckTime = NetProps.GetPropInt(player, "m_StuckLast");
	if (stuckTime < 800) {return}
	local playerOrigin = player.GetOrigin();
	local navTable = {};
	local closestNav = null;
    local closestDistance = null;
	NavMesh.GetNavAreasInRadius(playerOrigin, 192, navTable);

	// Check if nearby navs exist
	foreach (area in navTable)
	{
		local navOrigin = area.GetCenter();
		local traceTableHeight =
		{
			start = navOrigin
			end = navOrigin + Vector(0, 0, 112)
			mask = TRACE_MASK_VISION
			ignore = player
		};

		// Check for player headroom and LOS
		// 72 units player height, but check for 92 units to be safe
		// Areas with displacements can be finnicky but these values have worked well
		if (!TraceLine(traceTableHeight)) {continue}
		local distanceLOS = (navOrigin - playerOrigin).Length();
		local distanceHeight = (navOrigin - traceTableHeight.pos).Length();
		if (distanceHeight >= 92 && area.IsVisible(playerOrigin + Vector(0, 0, 48)))
		{
			// Check if current nav is closer than the previously checked nav
			if (closestDistance == null || distanceLOS < closestDistance) {closestDistance = distanceLOS; closestNav = navOrigin}
		}
	}
	// Warp player to nearest nav that meets headroom and LOS reqs
	// Increase z axis by 8 to ensure players do not get stuck in displacements
    if (closestNav != null) {player.SetOrigin(closestNav + Vector(0, 0, 8))}
}