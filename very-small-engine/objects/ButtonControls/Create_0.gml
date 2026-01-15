event_inherited();

state = noone;
keyIndex = 0;

// need to know if button is awaiting input

getState = function() {
	var states = kb ? bind.keyboardStates : bind.gamepadStates;
	if (array_length(states) > ind) {
		state = noone;
	}
	else {
		state = states[ ind ];
	}
	return state;
};

updateText = function() {
	getState();
	if (state == noone) {
		text = "";
		return;
	}
	
	text = state.description;
};

onBindCancel = function() {
};

onBindDelete = function() {
};

onPress = function() {
	// tell __input__() to await next input (with kb true/false)
};

