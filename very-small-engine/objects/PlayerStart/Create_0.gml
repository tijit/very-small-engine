spawnPlayer = function() {
	if (!instance_exists(Player)) {
		var plr = instance_create_depth(x+16, y+32-11, 0, Player);
		if (facing != 0) {
			plr.facing = sign(facing);
		}
		
		if (engineSettings("autosave")) {
			writeGameState();
		}
	}
	engineSettings("autosave", false);
};
spawnPlayer();
