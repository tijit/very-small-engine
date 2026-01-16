function gamepadAddBind(verb, but) {
	var dat = __input__();
	
	var b = dat.getBind(verb);
	
	if (!array_contains(dat.padbuttons, but)) {
		array_push(dat.padbuttons, but);
		b.addGamepadBind(but);
	}
	else {
		show_debug_message($"button already bound! {but}: {__gamepad_butnames(but, __active_gamepad().type)}");
	}
}

function __button_state_gamepad(_ind) : __button_state() constructor {
	static firstStickIndex = array_get_index(__gamepad_buttons(), LSTICK_UP);
	ind = _ind;
	butInd = __gamepad_button_get_index(_ind);
	if (butInd == -1) {
		throw $"gamepad button invalid: {ind}!";
	}
	
	isStick = (butInd >= firstStickIndex);
	stick = (isStick) ? getThumbstick(ind) : undefined;
	
	description = __gamepad_butnames(butInd, __active_gamepad().type);
	
	static update = function(device) {
		if (!isStick) {
			held = gamepad_button_check(device, ind);
			pressed = gamepad_button_check_pressed(device, ind);
			released = gamepad_button_check_released(device, ind);
		}
		else {
			held = stick.held;
			pressed = stick.pressed;
			released = stick.released;
		}
		
		if (pressed) {
			__input__().gamepad_any = true;
		}
	};
}

function __gamepad_button_get_index(ind) {
	return array_get_index(__gamepad_buttons(), ind);
}

function __active_gamepad() {
	static dat = {
		"index" : -1,
		"type" : GAMEPAD_TYPE.XBOX,
	};
	return dat;
}

function __gamepad_get_type(ind) {
	var str = gamepad_get_description(ind);
	if (string_length(str) > 0) {
		str = string_lower(str);
		if (string_count("ps", str) > 0 || string_count("playstation", str) > 0 || string_count("dualshock", str) > 0) {
			return GAMEPAD_TYPE.PLAYSTATION;
		}
		return GAMEPAD_TYPE.XBOX;
	}
	return -1;
}

function __get_active_gamepad_type() {
	var dat = __active_gamepad();
	return dat.type;
}

function __gamepad_scan() {
	// ensure the first scan is always successful
	static lastScan = -(engineSettings("gamepad_scan_time") + 1);
	// make sure we havent scanned too recently
	if (current_time - lastScan > engineSettings("gamepad_scan_time")) {
		lastScan = current_time;
		var gpCount = gamepad_get_device_count();
		for (var i = 0; i < gpCount; i++) {
			var type = __gamepad_get_type(i);
			if (type > -1) {
				show_debug_message($"gamepad found: index {i} type {type==0 ? "xbox" : "playstation"}");
				// store and return data, set deadzone
				var dat = __active_gamepad();
				dat.index = i;
				dat.type = type;
				
				__input__().device = i;
				
				gamepad_set_axis_deadzone(i, gameSettings("deadzone"));
				
				return {
					"ind" : i,
					"type" : type,
				};
				
			}
		}
	}
	return undefined;
}

function getThumbstick(stickConst) {
	var stick = __thumbstick_handler().sticks[ stickConst - LSTICK_UP ];
	return stick;
}

function __thumbstick_handler() {
	static dat = (function() {
		var dat = {
			"sticks" : [],
			"update" : function(device) {
				for (var i = 0; i < 8; i++) {
					sticks[i].update(device);
				}
			},
		};
		dat.sticks[ LSTICK_UP		- LSTICK_UP ] = new __thumbstick_state(gp_axislv, -1);
		dat.sticks[ LSTICK_DOWN		- LSTICK_UP ] = new __thumbstick_state(gp_axislv, +1);
		dat.sticks[ LSTICK_LEFT		- LSTICK_UP ] = new __thumbstick_state(gp_axislh, -1);
		dat.sticks[ LSTICK_RIGHT	- LSTICK_UP ] = new __thumbstick_state(gp_axislh, +1);
									
		dat.sticks[ RSTICK_UP		- LSTICK_UP ] = new __thumbstick_state(gp_axisrv, -1);
		dat.sticks[ RSTICK_DOWN		- LSTICK_UP ] = new __thumbstick_state(gp_axisrv, +1);
		dat.sticks[ RSTICK_LEFT		- LSTICK_UP ] = new __thumbstick_state(gp_axisrh, -1);
		dat.sticks[ RSTICK_RIGHT	- LSTICK_UP ] = new __thumbstick_state(gp_axisrh, +1);
		
		return dat;
	})();
	return dat;
}

function __thumbstick_state(_axis, _sgn) constructor {
	axis = _axis;
	sgn = _sgn;
	
	held = false;
	pressed = false;
	released = false;
	
	static update = function(device) {
		if (device == undefined || device < 0) {
			held = false;
			pressed = false;
			released = false;
			return;
		}
		
		var on = (sgn * gamepad_axis_value(device, axis) > 0);
		
		if (on) {
			pressed = !held;
			released = false;
		}
		else {
			pressed = false;
			released = held;
		}
		held = on;
		
		if (pressed) {
			__input__().gamepad_any = true;
		}
	};
}
