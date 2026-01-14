function pauseGame() {
	with (World) {
		
		gamePaused = true;
		gamePausing = false;
		
		instance_deactivate_all(true);
		
		__pause_write_screen();
		
		instance_create_depth(0, 0, 0, PauseBackground);
		instance_create_depth(0, 0, 0, PauseMenuButtonSpawner);
		instance_create_depth(0, 0, 0, SongTitle);
		
		if (engineSettings("pause_stops_music")) {
			getCurrentMusicState().pause();
		}
	}
}

function unpauseGame() {
	with (World) {
		saveSettingsToFile();
		
		gamePaused = false;
		
		instance_destroy(PauseBackground);
		instance_destroy(MenuButtonParent);
		instance_destroy(MenuCursor);
		instance_destroy(SongTitle);
		
		if (engineSettings("pause_stops_music")) {
			getCurrentMusicState().play();
		}
		
		instance_activate_all();
	}
}

function __pause_sprite() {
	static dat = {
		"spr" : undefined,
	};
	return dat;
}

function __pause_write_screen() {
	var dat = __pause_sprite();
	var spr = dat.spr;
	if (spr != undefined && sprite_exists(spr)) {
		sprite_delete(spr);
	}
	
	dat.spr = sprite_create_from_surface(application_surface, 0, 0, GAME_WIDTH, GAME_HEIGHT, false, false, 0, 0);
}
