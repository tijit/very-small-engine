if (--timer <= 0) {
	if (!bounced) {
		mask_index = -1;
		if (place_meeting(x, y, BlockParent)) {
			if (vspeed > 0) vspeed = -vspeed/2;
			else hspeed = -hspeed;
			
			bounced = true;
			gravity = GRAV;
		}
	}
	else {
		mask_index = maskNothing;
	}
}
