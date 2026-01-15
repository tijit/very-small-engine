if (gameResetting) {
	with (all) {
		if (id != other.id) {
			persistent = false;
		}
	}
	
	playMusic("");
	
	__save_current(generateNewSave());
	
	// everything shuold get cleaned up
	// but i still destroy the player here, so the window caption updates correctly
	instance_destroy(Player);
	
	updateWindowCaption();
	
	gameResetting = false;
	gamePaused = false;
	gamePausing = false;
	room_goto(firstRoom);
	exit;
}

__update_game_time();

if (instance_exists(MenuParent) && !instance_exists(MenuCursor)) {
	instance_create_depth(0, 0, 0, MenuCursor);
}

inputUpdate();

if (inputPressed("reset_game")) {
	resetGame();
	exit;
}

if (inputPressed("quit")) {
	game_end();
	exit;
}

if (inputPressed("retry")) {
	if (!instance_exists(MenuCursor)) {
		loadGameState();
	}
	exit;
}

if (inputPressed("pause")) {
	if (!gamePaused) {
		if (instance_exists(Player)) {
			gamePausing = true;
		}
	}
	else {
		unpauseGame();
	}
	exit;
}

if (inputPressed("music_mute")) {
	toggleMusic();
	with (ButtonMute) {
		updateText();
	}
	exit;
}

if (inputPressed("fullscreen")) {
	gameSettings("fullscreen", !gameSettings("fullscreen"));
	with (ButtonFullscreen) {
		updateText();
	}
	updateDisplay();
}

if (inputPressed("god_mode")) {
	engineSettings("god_mode", !engineSettings("god_mode"));
}
