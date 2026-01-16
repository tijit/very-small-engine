event_inherited();

state = noone;
keyIndex = 0;

waiting = false;

getState = function() {
	var states = kb ? bind.keyboardStates : bind.gamepadStates;
	if (ind < array_length(states)) {
		state = states[ ind ];
	}
	else {
		state = noone;
	}
	return state;
};

updateText = function() {
	if (waiting) {
		text = $"<press {kb ? "key" : "button"}>";
		return;
	}
	getState();
	if (state == noone) {
		text = "";
		return;
	}
	
	text = state.description;
};
updateText();

onBindCancel = function() {
	waiting = false;
	updateText();
};

onBindDelete = function() {
	__input_delete_key(state.ind, kb);
	updateText();
};

onPress = function() {
	// tell __input__() to await next input (with kb true/false)
	waiting = true;
	getState();
	__input__().awaiting_rebind = true;
	__input__().awaiting_kb = kb;
	__input__().awaiting_verb = bind.verb;
	if (state != noone) {
		__input__().awaiting_old_key = kb ? state.ind : state.butInd;
	}
	else {
		__input__().awaiting_old_key = -1;
	}
	updateText();
};
