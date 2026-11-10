#region death conditions

if (place_meeting(x, y, Killer)) {
	killPlayer();
}

if (y > room_height && engineSettings("die_below_floor")) {
	killPlayer();
}

if (y < 0 && engineSettings("die_above_ceiling")) {
	killPlayer();
}

#endregion
