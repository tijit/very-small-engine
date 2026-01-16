event_inherited();

state = noone;

waiting = false;

getState = function() {
	var states = kb ? bind.keyboardStates : bind.gamepadStates;
	if (keyPos < array_length(states)) {
		state = states[ keyPos ];
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

onBindDelete = function() {
	getState();
	if (state != noone) __input_delete_key(state.ind, kb);
	updateText();
};

onPress = function() {
	waiting = true;
	getState();
	__input__().awaiting_rebind = true;
	__input__().awaiting_kb = kb;
	__input__().awaiting_verb = bind.verb;
	if (state != noone) {
		__input__().awaiting_old_key = kb ? state.ind : state.ind;
	}
	else {
		__input__().awaiting_old_key = -1;
	}
	updateText();
};
