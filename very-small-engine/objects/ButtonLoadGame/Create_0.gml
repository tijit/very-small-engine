event_inherited();

isnewgame = false;

state = __load_save_file(num);
if (state.time_sec == 0) isnewgame = true;

deathtime = "";

updateText = function() {
	text = $"File 0{num} - ";
	if (isnewgame) {
		text += "New Game";
	}
	else {
		deathtime = deathtimeToString(state);
		text += $"Continue - {deathtime}";
	}
};
updateText();

onPress = function() {
	if (!isnewgame) {
		loadSaveNum(num);
	}
	else {
		startNewGame(num);
	}
};
