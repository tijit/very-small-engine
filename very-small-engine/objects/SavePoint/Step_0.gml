if (--timer <= 0) {
	image_index = 0;
	
	var saved = false;
	
	if (inputPressed("shoot") && place_meeting(x, y, Player)) {
		saved = true;
	}
	
	if (place_meeting(x, y, PlayerBullet)) {
		saved = true;
	}
	
	if (saved) {
		with (Player) {
			if (sign(gravDir) != sign(other.gravDir)) {
				exit;
			}
		}
		image_index = 1;
		timer = cooldown;
		
		writeGameState();
	}
}
