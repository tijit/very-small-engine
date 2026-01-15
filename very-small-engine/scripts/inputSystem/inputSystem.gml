function inputAddBind(verb, key) {
	var dat = __input__();
	
	var b = dat.getBind(verb);
	
	if (!array_contains(dat.keys, key)) {
		//array_push(dat.binds[$ verb].buttons, key);
		array_push(dat.keys, key);
	}
	else {
		show_debug_message($"button already bound! {key}: {__keyboard_keynames(key)}");
		//throw "button already bound!";
	}
	b.addKeyboardBind(key);
}

function inputBindFindKey(key) {
	static dat = __input__();
	if (array_contains(dat.keys, key)) {
		for (var i = 0; i < array_length(dat.verbs); i++) {
			var bind = dat.binds[$ dat.verbs[i]];
			for (var j = 0; j < array_length(bind.keyboardStates); j++) {
				var state = bind.keyboardStates[j];
				if (state.ind == key) {
					return {
						"bind" : bind,
						"key_pos" : j,
					};
				}
			}
		}
	}
	return noone;
}

function inputDeleteBind(verb, key) {
}

function inputSwapBind(bind1, key1, bind2, key2) {
}

function gamepadBindFindButton(but) {
}

function gamepadDeleteBind(verb, but) {
}

function gamepadSwapBind(bind1, but1, bind2, but2) {
	
}

// automatically called by World
function inputUpdate() {
	static dat = __input__();
	static padIndex = dat.device;
	dat.gamepad_any = false;
	
	if (gameSettings("gamepad_enabled")) {
		if (padIndex != undefined) {
			if (!gamepad_is_connected(padIndex)) {
				padIndex = undefined;
			}
			else {
				__thumbstick_handler().update(padIndex);
			}
		}
		else {
			// by default, checks for a controller every one second
			// see engineSettings("gamepad_scan_time")
			var scan = __gamepad_scan();
			if (scan != undefined) {
				padIndex = scan.ind;
			}
		}
	}
	else {
		padIndex = undefined;
	}
	
	for (var i = 0; i < array_length(dat.verbs); i++) {
		var verb = dat.verbs[i];
		var b = dat.binds[$ verb];
		
		b.update(true, padIndex);
		
		//var verb = dat.verbs[i];
		//var bind = dat.binds[$ verb];
		
		//bind.pressed = false;
		//bind.released = false;
		//bind.held = false;
		
		//for (var j = 0; j < array_length(bind.buttons); j++) {
		//	var button = bind.buttons[j];
			
		//	if (keyboard_check(button)) {
		//		bind.held = true;
		//	}
		//	if (keyboard_check_pressed(button)) {
		//		bind.pressed = true;
		//	}
		//	if (keyboard_check_released(button)) {
		//		bind.released = true;
		//	}
		//}
	}
}

function InputBinding(_verb) constructor {
	verb = _verb;
	
	keyboardStates = [ ];
	gamepadStates = [ ];
	
	held = false;
	pressed = false;
	released = false;
	
	static addKeyboardBind = function(_ind) {
		var state = new __button_state_keyboard(_ind);
		array_push(keyboardStates, state);
	};
	
	static addGamepadBind = function(_ind) {
		var state = new __button_state_gamepad(_ind)
		array_push(gamepadStates, state);
	};
	
	static update = function(kb=true, device=undefined) {
		clear();
		
		if (kb) {
			updateList(keyboardStates);
		}
		
		if (device != undefined) {
			updateList(gamepadStates, device);
		}
	};
	
	static updateList = function(list, device=undefined) {
		var nstates = array_length(list);
		for (var i = 0; i < nstates; i++) {
			var next = list[i];
			
			next.update(device);
			
			held = next.held || held;
			pressed = next.pressed || pressed;
			released = next.released || released;
		}
	};
	
	static clear = function() {
		held = false;
		pressed = false;
		released = false;
	};
	
	static getHeld = function() {
		return held;
	};
	
	static getPressed = function() {
		return pressed;
	};
	
	static getReleased = function() {
		return released;
	};
}

function __button_state() constructor {
	held = false;
	pressed = false;
	released = false;
	
	description = "";
	
	static update = function(_device=undefined) {};
	
	static clear = function() {
		held = false;
		pressed = false;
		released = false;
	};
}

function __button_state_keyboard(_ind) : __button_state() constructor {
	ind = _ind;
	description = __keyboard_keynames(ind);
	
	static update = function(_device=undefined) {
		held = keyboard_check(ind);
		pressed = keyboard_check_pressed(ind);
		released = keyboard_check_released(ind);
	};
}

//function inputCheck(verb, type, device=0) {
//	static dat = __input__();
//	var result = dat.binds[$ verb];
//	if (result == undefined) return false;
//	//result = result[$ type];
//	//if (result == undefined) return false;
//	//return result;
//}

function __input__() {
	static dat = {
		"device" : undefined,
		
		"gamepad_any" : false,
		
		"awaiting_rebind" : false,
		
		// list of verbs (left, jump etc)
		"verbs" : [],
		// list of keyboard buttons
		"keys" : [],
		// list of gamepad buttons
		"padbuttons" : [],
		// data structure containing bind information
		"binds" : {},
		
		"getBind" : function(verb) {
			if (binds[$ verb] == undefined) {
				array_push(verbs, verb);
				binds[$ verb] = new InputBinding(verb);
			}
			return binds[$ verb];
		},
	};
	return dat;
}
