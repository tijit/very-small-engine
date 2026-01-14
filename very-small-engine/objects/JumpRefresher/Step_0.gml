if (--timer <= 0) {
	image_alpha = 1;
	
	var plr = instance_place(x, y, Player);
	if (plr != noone) {
		if (!plr.dead) {
			plr.refreshJumps();
			timer = cooldown;
		}
	}
}
else {
	image_alpha = cooldownAlpha;
}
