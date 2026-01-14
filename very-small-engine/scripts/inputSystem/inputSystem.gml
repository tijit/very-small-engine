function inputAddBind(verb, key) {
	var dat = __input__();
	// TODO: check if key is already being used
	if (dat.binds[$ verb] == undefined) {
		array_push(dat.verbs, verb);
		dat.binds[$ verb] = {
			"buttons" : [ ],
			"held" : false,
			"pressed" : false,
			"released" : false,
			"description" : __keyboard_keynames(key),
		};
	}
	if (!array_contains(dat.keys, key)) {
		array_push(dat.binds[$ verb].buttons, key);
		array_push(dat.keys, key);
	}
	else {
		show_debug_message($"button already bound! {key}");
		//throw "button already bound!";
	}
}

function __button_state() constructor {
	held = false;
	pressed = false;
	released = false;
	description = "";
	
	static update = function() {};
}

function __button_state_keyboard(_ind) : __button_state() constructor {
	ind = _ind;
	description = __keyboard_keynames(ind);
	
	static update = function() {
		held = keyboard_check(ind);
		pressed = keyboard_check_pressed(ind);
		released = keyboard_check_released(ind);
	};
}

function __button_state_gamepad(_ind) : __button_state() constructor {
	static stickIndex = array_get_index(__gamepad_buttons(), LSTICK_UP);
	ind = _ind;
	butInd = array_get_index(__gamepad_buttons(), _ind);
	if (butInd == -1) {
		throw $"gamepad button invalid: {ind}!";
	}
	
	isStick = (butInd >= stickIndex);
	
	description = __gamepad_butnames(butInd);
	
	static update = function() {
		if (!isStick) {
			held = gamepad_button_check(0, ind);
			pressed = gamepad_button_check_pressed(0, ind);
			released = gamepad_button_check_released(0, ind);
		}
		else {
			// the rest of the fucking owl
		}
	};
	
}




//function gamepadAddBindButton(verb, button) {
//	if (button > gp_padr) {
		
//	}
//}

/// stick: 0 left, 1 right
/// dir: 0,1,2,3 (right, up left, down)
//function gamepadAddBindStick(verb, stick, dir) {
//}

function inputFindKey(key) {
}

function inputCheck(verb, type, device=0) {
	static dat = __input__();
	var result = dat.binds[$ verb];
	if (result == undefined) return false;
	result = result[$ type];
	if (result == undefined) return false;
	return result;
}

function __input__() {
	static dat = {
		"device" : 0,
		
		// list of verbs (left, jump etc)
		"verbs" : [],
		// list of keyboard buttons
		"keys" : [],
		// list of gamepad buttons
		"padbuttons" : [],
		// data structure containing bind information
		/*
		 * binds[$ verb] : {
		 * 		buttons : array[] of keyboard buttons
		 * 		held : true/false
		 * 		pressed : true/false
		 * 		released : true/false
		 * }
		*/
		"binds" : {},
	};
	return dat;
}

// automatically called by World
function inputUpdate() {
	var dat = __input__();
	
	for (var i = 0; i < array_length(dat.verbs); i++) {
		var verb = dat.verbs[i];
		var bind = dat.binds[$ verb];
		
		bind.pressed = false;
		bind.released = false;
		bind.held = false;
		
		for (var j = 0; j < array_length(bind.buttons); j++) {
			var button = bind.buttons[j];
			
			if (keyboard_check(button)) {
				bind.held = true;
			}
			if (keyboard_check_pressed(button)) {
				bind.pressed = true;
			}
			if (keyboard_check_released(button)) {
				bind.released = true;
			}
		}
	}
}
