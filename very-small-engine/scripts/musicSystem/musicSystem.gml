function MusicState(trackName="") constructor {
	name = trackName;
	inst = undefined;
	stream = undefined;
	isFile = false;
	empty = true;
	fileName = "";
	trackVolume = 1;
	currentVolume = 0;
	
	pitch = 1;
	
	pausedPosition = 0;
	isPaused = false;
	
	asset = asset_get_index(name);
	if (asset == -1) {
		fileName = $"{MUSIC_DIRECTORY}\\{name}.ogg";
		if (file_exists(fileName)) {
			isFile = true;
			stream = audio_create_stream(fileName);
			empty = false;
		}
		else {
			if (string_length(trackName) > 0) {
				show_debug_message($"music file missing: {fileName}");
			}
		}
	}
	else {
		// its a sound asset
		isFile = false;
		empty = false;
	}
	
	static play = function(loop=true, fadeTime=0.5) {
		if (empty) return;
		if (inst != undefined) {
			if (isPaused) {
				setPosition(pausedPosition);
				fadeIn(0.1);
			}
		}
		else {
			var soundid = isFile ? stream : asset;
			if (soundid != undefined) {
				inst = audio_play_sound(soundid, 1, loop);
				fadeIn(fadeTime, true);
			}
		}
	};
	
	static rewind = function() {
		pausedPosition = 0;
	};
	
	static fadeIn = function(duration, zeroFirst=false) {
		if (zeroFirst) {
			dim(0, 0);
		}
		dim(1, duration);
	};
	
	static fadeOut = function(duration) {
		dim(0, duration);
	};
	
	static getPitch = function() {
		return pitch;
	};
	
	static setPitch = function(_pitch) {
		if (inst != undefined && audio_is_playing(inst)) {
			pitch = _pitch;
			audio_sound_pitch(inst, _pitch);
		}
	};
	
	static dim = function(vol, duration) {
		currentVolume = vol;
		if (inst != undefined && !audio_is_playing(inst)) {
		}
		if (inst != undefined && audio_is_playing(inst)) {
			vol *= (gameSettings("music_volume"));
			vol *= trackVolume;
			if (gameSettings("music_muted")) {
				vol = 0;
			}
			audio_sound_gain(inst, vol, duration*1000);
		}
	};
	
	static pause = function(fadeTime=0.1) {
		pausedPosition = getPosition();
		fadeOut(fadeTime);
		isPaused = true;
	};
	
	static setPosition = function(t) {
		if (inst != undefined && audio_is_playing(inst)) {
			audio_sound_set_track_position(inst, t);
		}
	};
	
	static getPosition = function() {
		if (inst != undefined && audio_is_playing(inst)) {
			return audio_sound_get_track_position(inst);
		}
		return 0;
	};
	
	// call before deleting !! otherwise memory leak
	static onDelete = function() {
		if (inst != undefined) {
			audio_stop_sound(inst);
		}
		if (isFile && stream != undefined) {
			audio_destroy_stream(stream);
		}
		inst = undefined;
		stream = undefined;
	};
}

function getCurrentMusicState() {
	return (__music_states().current);
}

// mess with at your peril (memory leak's)
function __music_states() {
	static dat = {
		"current" : new MusicState(),
		"old" : new MusicState(),
	};
	return dat;
}

function __music_reset() {
	with (__music_states()) {
		current.onDelete();
		old.onDelete();
		
		delete current;
		delete old;
		
		current = new MusicState();
		old = new MusicState();
	}
}

function __master_sounds() {
	var vol = gameSettings("sound_volume");
	
	var i = 0; while (audio_exists(i)) {
		audio_sound_gain(i, vol, 0);
		i++;
	}
}