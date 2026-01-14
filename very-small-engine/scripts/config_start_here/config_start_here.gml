#macro RUN_SPEED (3)
#macro FALL_SPEED (9)
#macro GRAV (0.4)
#macro VJUMP (0.45)
#macro JUMP1 (8.5)
#macro JUMP2 (7)
#macro JUMP_VINE (9)
// vines, water
#macro FLOAT_SPEED (2)

#macro GUN_BULLET_SPEED (16)
#macro GUN_BULLET_CAP (4)
#macro GUN_BULLET_LIFETIME (40)

#macro GAME_WIDTH (800)
#macro GAME_HEIGHT (608)

function __init__() {
	gml_pragma("global", "__init__()");
	
	application_surface_draw_enable(false);
	
	loadSettingsFromFile();
	
	inputInit(); // click inputInit() and press F1 to edit default controls
	inputUpdate();
	
	applySettings();
	
	//generateNewSave();
	
	updateWindowCaption();
	
	draw_set_font(engineSettings("default_font"));
}

// useful functions for teleporting to with F1:
// killPlayer()
// writeGameState([toFile=true])

// if a function starts with underscores eg __hello_cat()
// u dont want to edit it unless u know what ur doing

/// default engine settings
function engineSettings(key, write=undefined) {
	static dat = {
		// what text is displayed first in window caption
		"game_name" :			"very small engine",
		
		"menu_input_cooldown" :	5,
		
		// useful for stuff like avoidance
		"pause_stops_music" :	false,
		
		"skip_splash" :			false,
		"starting_room" :		rExample,
		"death_updates_save" :	true,
		
		// keep camera inside the room?
		"clamp_camera" :		true,
		
		"die_below_floor" :		true,
		"die_above_ceiling" :	false,
		
		// can u jump off a vine with shift without losing double jump
		"maker_vines" :			false,
		// can u jump many times
		"infinite_jump" :		false,
		// can u safely eat delicious fruit
		"god_mode" :			false,
		// save point cooldown (frames)
		"save_cooldown" :		50,
		// jump refresher cooldown default (frames)
		"refresher_cooldown" :	100,
		
		// which font is set at game start and on drawReset() call
		"default_font" :		fontDefault,
		
		"gameover_font" :		fontDefault,
		"gameover_text" :		"GAME OVER",
		
		"save_index" :			1,
		"auto_save" :			false,
		
		// convenient auto-draw depths
		"depth_water" :			-20,
		"depth_player" :		-10,
		"depth_platform" :		10,
		"depth_block" :			20,
		"depth_spike" :			30,
		
		// TODO:
		//"autofire" :			false,
		//"autofire_cooldown" :	1,
	};
	dat[$ key] = write ?? dat[$ key];
	return dat[$ key];
}

/// default game settings
/// these are saved and load to file
function defaultGameSettings() {
	var dat = {
		"master_volume" :		0.5,
		"music_volume" :		1,
		"sound_volume" :		1,
		
		"music_muted" :			false,
		
		"fullscreen" :			false,
		"vsync" :				false,
		
		"deadzone" :			0.5,
	};
	return dat;
}

function gameSettings(key, write=undefined) {
	static dat = __game_settings();
		
	dat[$ key] = write ?? dat[$ key];
	return dat[$ key];
}

function applySettings() {
	masterAudio();
	updateDisplay();
}

function masterAudio() {
	audio_set_master_gain(0, gameSettings("master_volume"));
	// update sounds
	__master_sounds();
	// update music volume
	var states = __music_states();
	states.current.dim(1,0);
	states.old.dim(1,0);
}

function updateDisplay() {
	var full = gameSettings("fullscreen");
	var vsync = gameSettings("vsync");
	window_set_fullscreen(full);
	display_reset(0, vsync);
}

function updateWindowCaption() {
	var str = engineSettings("game_name");
	var deathtime = __get_deathtime();
	
	if (deathtime.death > 0 || deathtime.time > 0 || instance_exists(Player)) {
		str = $"{str}  {deathtimeToString()}";
	}
	window_set_caption(str);
}


/// ALWAYS call this instead of game_restart()
function resetGame() {
	with (World) {
		engineSettings("autosave", false);
		gameResetting = true;
		// we need to activate everything and wait one frame
		instance_activate_all();
	}
}
