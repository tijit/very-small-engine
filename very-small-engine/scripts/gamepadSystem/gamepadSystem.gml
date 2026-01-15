enum GAMEPAD_TYPE {
	XBOX,
	PLAYSTATION,
}

function __active_gamepad() {
	static dat = {
		"index" : -1,
		"type" : GAMEPAD_TYPE.XBOX,
	};
	return dat;
}

function __gamepad_determine_type(ind) {
	var str = gamepad_get_description(i);
	if (string_length(str) > 0) {
		str = string_lower(str);
		if (string_count("playstation", str) > 0 || string_count("dualshock", str) > 0) {
			return GAMEPAD_TYPE.PLAYSTATION;
		}
		return GAMEPAD_TYPE.XBOX;
	}
	return -1;
}

function __get_active_gamepad_index(scan=false) {
	static lastScan = current_time;
	var dat = __active_gamepad();
	if ((scan || dat.index == -1) && (current_time - lastScan > 1000)) {
		lastScan = current_time;
		var gpCount = gamepad_get_device_count();
		for (var i = 0; i < gpCount; i++) {
			var type = __gamepad_determine_type(i);
			if (type > -1) {
				dat.index = i;
				dat.type = type;
				
				gamepad_set_axis_deadzone(i, gameSettings("deadzone"));
				
				break;
			}
		}
		
	}
	return dat.index;
}

function __get_active_gamepad_type() {
	var dat = __active_gamepad();
	return dat.type;
}

function __get_thumbstick(_stick=0) {
	static dat = {
		"left" :	new __thumbstick_state(gp_axislh, gp_axislv),
		"right" :	new __thumbstick_state(gp_axisrh, gp_axisrv),
	};
	
	return (_stick==0) ? dat.left : dat.right;
}

function __thumbstick_update_device() {
	__get_thumbstick(0).updatePadIndex();
	__get_thumbstick(1).updatePadIndex();
}

function __thumbstick_state(_ax, _ay) constructor {
	static pad = -1;
	
	ax = _ax;
	ay = _ay;
	
	buttons = [
		"up",
		"down",
		"left",
		"right"
	];
	
	binds = {};
	
	for (var i = 0; i < array_length(buttons); i++) {
		binds[$ buttons[i]] = {
			"held" : false,
			"pressed" : false,
			"released" : false,
		};
	}
	
	static update = function() {
		if (pad != __get_active_gamepad().index) {
			return;
		}
		
		var ux = gamepad_axis_value(pad, ax);
		var uy = gamepad_axis_value(pad, ay);
		
		updateDirection(binds.left, ux < 0);
		updateDirection(binds.right, ux > 0);
		updateDirection(binds.up, uy < 0);
		updateDirection(binds.down, uy > 0);
	};
	
	static updateDirection = function(bind, on) {
		if (on) {
			bind.pressed = !bind.held;
			bind.released = false;
		}
		else {
			bind.pressed = false;
			bind.released = bind.held;
		}
		bind.held = on;
	};
	
	static updatePadIndex = function() {
		pad = __get_active_gamepad_index();
	};
}
