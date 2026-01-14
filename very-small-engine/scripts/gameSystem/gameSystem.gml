function GameState() constructor {
	static set = function(dat) {
		structCopy(self, dat);
		return self;
	};
	static setValue = function(key, val) {
		self[$ key] = val;
	};
	static get = function(key) {
		return self[$ key] ?? 0;
	};
}

function incrementDeaths(n=1) {
	var dat = __save_current();
	dat.deaths += n;
	updateWindowCaption();
}

function __get_deathtime(dat=__save_current()) {
	return {
		"death" : dat.deaths,
		"time" : dat.time_sec,
	};
}

function deathtimeToString(dat=__save_current()) {
	var deathtime = __get_deathtime(dat);
	return $"death: {deathtime.death}  {secondsToString(deathtime.time)}";
}

function __update_game_time() {
	static t = current_time;
	var updateCaption = false;
	
	var dt = 0;
	with (Player) {
		dt = current_time - t;
	}
	
	var dat = __save_current();
	
	with (dat) {
		var ms = time_ms + dt;
		var seconds = floor(ms / 1000);
		if (seconds > 0) {
			ms -= seconds * 1000;
			updateCaption = true;
		}
		time_ms = ms;
		time_sec += seconds;
	}
	
	if (updateCaption) {
		updateWindowCaption();
	}
	
	t = current_time;
}

function secondsToString(t) {
	t = floor(t);
	
	var seconds = t % 60;
	var minutes = floor(t / 60);
	
	var szero = (seconds < 10) ? "0" : "";
	var mzero = (minutes < 10) ? "0" : "";
	
	t = minutes;
	
	minutes = t % 60;
	var hours = floor(t / 60);
	
	return $"{hours}:{mzero}{minutes}:{szero}{seconds}";
}

function __savegame_states() {
	static dat = {
		"save1" :		generateNewSave(),
		"save2" :		generateNewSave(),
		"save3" :		generateNewSave(),
		"current" :		generateNewSave(),
	};
	return dat;
}

function __save_write(toFile=true) {
	var dat = __save_current();
	
	//var name = dat.name;
	var num = engineSettings("save_index");
	var sav = __save_get_filename(num);
	var states = __savegame_states();
	states[$ sav].set(dat);
	
	if (toFile) {
		structSaveToFile(sav, dat);
	}
}

function __load_save_file(num) {
	var sav = __save_get_filename(floor(num));
	var state = generateNewSave();
	var exists = file_exists(sav);
	if (exists) {
		var f = structLoadFromFile(sav);
		structCopy(state, f);
	}
	var states = __savegame_states();
	states[$ sav] = state;
	return state;
}

function __save_get_filename(num) {
	num = floor(num);
	return $"save{num}";
}

function __savegame_get(num=engineSettings("save_index")) {
	var states = __savegame_states();
	return states[$ __save_get_filename(num)];
}

function __save_current(_write=undefined) {
	static states = __savegame_states();
	states.current = _write ?? states.current;
	return states.current;
}

#macro SETTINGS_FILENAME "cfg"

function __game_settings() {
	static dat = (function() {
		var d = {};
		structCopy(d, defaultGameSettings());
		return d;
	})();
	return dat;
}

function saveSettingsToFile() {
	structSaveToFile(SETTINGS_FILENAME, __game_settings());
}

function loadSettingsFromFile() {
	if (file_exists(SETTINGS_FILENAME)) {
		var f = structLoadFromFile(SETTINGS_FILENAME);
		structCopy(__game_settings(), f);
		delete f;
	}
}

//function PlayerSaveState(plr) constructor {
//	x = plr.x;
//	y = plr.y;
//	roomName = room_get_name(room);
//}
