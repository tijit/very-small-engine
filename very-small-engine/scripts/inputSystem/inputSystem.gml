/// for safety, this does not handle collisions or duplicate keys
/// delete old bind before adding new ones or use inputSwapBind(key1, key2)
function inputAddBind(verb, key) {
	var dat = __input__();
	
	var b = dat.getBind(verb);
	
	if (!array_contains(dat.keys, key)) {
		array_push(dat.keys, key);
		b.addKeyboardBind(key);
	}
	else {
		show_debug_message($"button already bound! {key}: {__keyboard_keynames(key)}");
	}
}

// automatically called by World
function inputUpdate() {
	static dat = __input__();
	static padIndex = dat.device;
	
	if (keyboard_check_pressed(vk_anykey)) {
		dat.last_input_keyboard = true;
	}
	else {
		if (dat.gamepad_any) dat.last_input_keyboard = false;
	}
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
	
	if (dat.awaiting_rebind) {
		if (getMenuInput().bind_cancel) {
			dat.awaiting_rebind = false;
			with (ButtonControls) {
				waiting = false;
				updateText();
			}
			return;
		}
		
		__input_await_rebind(padIndex);
		
		return;
	}
	
	for (var i = 0; i < array_length(dat.verbs); i++) {
		var verb = dat.verbs[i];
		var b = dat.binds[$ verb];
		
		b.update(true, padIndex);
	}
}

// functions for handling rebinds

function inputBindFindKey(key) {
	return __input_find_key(key, true);
}

function inputDeleteKey(key) {
	__input_delete_key(key, true);
}

function inputSwapKey(key1, key2) {
	__input_swap_key(key1, key2, true);
}

function gamepadBindFindButton(but) {
	return __input_find_key(but, false);
}

function gamepadDeleteButton(but) {
	__input_delete_key(but, false);
}

function gamepadSwapButton(but1, but2) {
	__input_swap_key(key1, key2, false);
}

function __input_find_key(keyOrButton, kb) {
	static dat = __input__();
	var arr = kb ? dat.keys : dat.padbuttons;
	if (array_contains(arr, keyOrButton)) {
		var verbs = dat.verbs;
		for (var i = 0; i < array_length(verbs); i++) {
			var bind = dat.binds[$ verbs[i]];
			var states = kb ? bind.keyboardStates : bind.gamepadStates;
			for (var j = 0; j < array_length(states); j++) {
				var next = states[j];
				if (next.ind == keyOrButton) {
					return {
						"verb" : verbs[i],
						"bind" : bind,
						"state" : next,
						"key_pos" : j,
					};
				}
			}
		}
	}
	return noone;
}

function __input_delete_key(keyOrButton, kb) {
	static dat = __input__();
	var keyInfo = __input_find_key(keyOrButton, kb);
	if (keyInfo != noone) {
		// delete key from array of all keys
		var arr = kb ? dat.keys : dat.padbuttons;
		var pos = array_get_index(arr, keyOrButton);
		array_delete(arr, pos, 1);
		// delete key from individual bind
		arr = kb ? keyInfo.bind.keyboardStates : keyInfo.bind.gamepadStates;
		array_delete(arr, keyInfo.key_pos, 1);
		
		
	}
}

function __input_swap_key(key1, key2, kb) {
	var info1 = __input_find_key(key1, kb);
	var info2 = __input_find_key(key2, kb);
	
	if (info1 != noone && info2 != noone) {
		__input_delete_key(key1, kb);
		__input_delete_key(key2, kb);
		
		if (kb) {
			inputAddBind(info1.verb, key2);
			inputAddBind(info2.verb, key1);
		}
		else {
			gamepadAddBind(info1.verb, key2);
			gamepadAddBind(info2.verb, key1);
		}
	}
	else show_debug_message($"trying to swap two keys when only one is bound!");
}

function __input_await_rebind(device) {
	var key = -1;
	var keyInvalid = false;
	var kb = __input__().awaiting_kb;
	if (kb) {
		if (keyboard_check_pressed(vk_anykey)) {
			key = keyboard_lastkey;
			if (string_length(__keyboard_keynames(key)) > 0) {
			}
			else {
				keyInvalid = true;
			}
		}
	}
	else {
		var buttons = __gamepad_buttons();
		for (var i = 0; i < array_length(buttons); i++) {
			var firstStickIndex = array_get_index(buttons, LSTICK_UP);
			if (i < firstStickIndex) {
				if (gamepad_button_check_pressed(device, buttons[i])) {
					key = buttons[i];
					break;
				}
			}
			else {
				if (getThumbstick(buttons[i]).pressed) {
					key = buttons[i];
					break;
				}
			}
		}
	}
	
	if (key != -1) {
		var old = __input__().awaiting_old_key;
		if (old == key) keyInvalid = true;
		if (!keyInvalid) {
			var swap = __input_find_key(key, kb);
			
			if (swap == noone) {
				if (old != -1) {
					__input_delete_key(old, kb);
				}
				if (kb) {
					inputAddBind(__input__().awaiting_verb, key);
				}
				else {
					gamepadAddBind(__input__().awaiting_verb, key);
				}
			}
			else {
				if (old != -1) {
					__input_swap_key(old, key, kb);
				}
				else {
					__input_delete_key(key, kb);
					if (kb) {
						inputAddBind(__input__().awaiting_verb, key);
					}
					else {
						gamepadAddBind(__input__().awaiting_verb, key);
					}
				}
			}
		}
		
		__input__().awaiting_rebind = false;
		__input__().awaiting_verb = "";
		__input__().awaiting_old_key = -1;
		
		show_debug_message("rebind script done");
		
		// update menu button display
		with (ButtonControls) {
			waiting = false;
			updateText();
		}
	}
}

// struct classes for handling state

/// contains all keyboard and gamepad binds for a verb
/// also contains the state of those inputs
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

/// parent class for keyboard and gamepad binds & state
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

/// singleton containing references to all input state
/// and bind information
function __input__() {
	static dat = {
		"device" : undefined,
		
		"gamepad_any" : false,
		
		"last_input_keyboard" : true,
		
		"awaiting_rebind" : false,
		"awaiting_verb" : "",
		"awaiting_kb" : true,
		"awaiting_old_key" : -1,
		
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



