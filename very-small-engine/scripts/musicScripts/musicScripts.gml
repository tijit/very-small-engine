#macro MUSIC_DIRECTORY "mus"

/// usage: trackName is a string, which is either 
/// - a filename taken from MUSIC_DIRECTORY, eg for "mus\\guyrock.ogg" call playMusic("guyrock")
/// - the name of a sound asset
/// usually just called from a MusicPlayer instance
function playMusic(trackName, oldFadeOutTime=1.5, newFadeInTime=0.1, loopSong=true) {
	var states = __music_states();
	var current = states.current;
	var old = states.old;
	
	if (current.name == trackName) {
		return;
	}
	
	//instance_destroy(SongTitle);
	
	var cleanupOld = true;
	
	if (old.name == trackName) {
		states.current = old;
		states.old = current;
		cleanupOld = false;
	}
	
	if (cleanupOld) {
		old.onDelete();
		delete old;
		
		states.old = current;
		states.old.fadeOut(oldFadeOutTime);
		
		var next = new MusicState(trackName);
		states.current = next;
		if (!next.empty) {
			next.play(loopSong, newFadeInTime);
			//displaySongTitle(trackName);
		}
	}
	else {
		old.fadeIn(newFadeInTime);
		current.fadeOut(oldFadeOutTime);
	}
}

function getSongTitle() {
	// custom track names
	static names = {
		"guyrock" : "guy rock!",
		"menu" : "super mario land - stage music 2",
	};
	
	var mus = getCurrentMusicState();
	return names[$ mus.name] ?? mus.name;
}

function toggleMusic(mute = !gameSettings("music_muted")) {
	gameSettings("music_muted", mute);
	with (getCurrentMusicState()) {
		dim(1, 0.1);
	}
	saveSettingsToFile();
}

/*
some additional functions, useful for avoidance sync and such
*/

function getMusicPosition() {
	with (getCurrentMusicState()) {
		return getPosition();
	}
	return 0;
}

function setMusicPosition(t) {
	with (getCurrentMusicState()) {
		setPosition(t);
	}
}

function getMusicSpeed() {
	with (getCurrentMusicState()) {
		return getPitch();
	}
	return 1;
}

function setMusicSpeed(_pitch) {
	with (getCurrentMusicState()) {
		setPitch(_pitch);
	}
}

