function writeGameState(toFile=true, savePosition=true) {
	// dont save if player is dead or non-existent
	with (Player) {
		if (!dead && savePosition) {
			saveSetValue("player_x", x);
			saveSetValue("player_y", y);
			saveSetValue("player_facing", facing);
			saveSetValue("room_name", room_get_name(room));
			saveSetValue("grav_dir", gravDir);
			
			// example of another way:
			//var dat = __save_current();
			//dat.set({
			//	"player_x" :		x,
			//	"player_y" :		y,
			//	"player_facing" :	facing,
			//	"room_name" :		room_get_name(room),
			//	"grav_dir" :		gravDir,
			//});
		}
	}
	
	__save_write(toFile);
}

function loadGameState() {
	instance_destroy(Player);
	
	var dat = __save_current();
	
	var plr;
	// if position is undefined, the PlayerStart object will spawn Player
	var xpos = dat.get("player_x");
	var ypos = dat.get("player_y");
	if (xpos != undefined && ypos != undefined) {
		plr = instance_create_depth(xpos, ypos, 0, Player);
		plr.persistent = true;
		
		plr.gravDir = (dat.get("grav_dir") >= 0) ? 1 : -1;
		plr.facing = (dat.get("player_facing") >= 0) ? 1 : -1;
	}
	
	var roomTo = asset_get_index(dat.get("room_name"));
	
	// custom load data here?
	
	room_goto(roomTo);
}

/// if a value hasnt been defined this returns 0
function saveGetValue(name) {
	var state = __save_current();
	return state.get(name);
}

/// eg saveSetValue("boss_1", true), saveSetValue("game_clear", true)
function saveSetValue(name, val) {
	var state = __save_current();
	state.setValue(name, val);
}

function loadSaveNum(num, fromFile=false) {
	num = floor(num);
	engineSettings("save_index", num);
	
	if (fromFile) {
		__load_save_file(num);
	}
	
	__save_current(generateNewSave().set(__savegame_get(num)));
	loadGameState();
}

function generateNewSave() {
	static defaultSaveData = {
		"room_name" :		room_get_name(engineSettings("starting_room")),
		"grav_dir" :		1,
		"double_jumps" :	1,
		
		"deaths" :			0,
		"time_sec" :		0,
		"time_ms" :			0,
	};
	
	return (new GameState()).set(defaultSaveData);
}

function startNewGame(num) {
	num = floor(num);
	engineSettings("save_index", num);
	
	var state = generateNewSave();
	__save_current(state);
	
	applySettings();
	
	loadGameState();
}
