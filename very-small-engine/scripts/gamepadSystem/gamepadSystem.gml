enum GAMEPAD_TYPE {
	XBOX,
	PLAYSTATION,
}

// TODO: return something other than zero
function __get_active_gamepad(scan=false) {
	static dat = {
		"index" : -1,
	};
	if (scan || dat.index == -1) {
		/*
		var gpCount = gamepad_get_device_count();
			global.padType = GAMEPAD_TYPE.XBOX;
			pad = -1;
			for (var i = deviceInd; i < gpCount; i++) {
				var str = string_lower(gamepad_get_description(i));
				if (string_length(str) > 0) {
					var playstation = string_count("playstation", str) > 0 || string_count("dualshock", str) > 0;
					global.padType = playstation ? GAMEPAD_TYPE.PLAYSTATION : GAMEPAD_TYPE.XBOX;
					if (yes) pad = i;
					gamepad_set_axis_deadzone(i, gameSetting("deadzone"));
					break;
				}
			}
		*/
	}
	return dat.index;
}

function __get_gamepad_type() {
	// todo: get the correct one (fgu code)
	return GAMEPAD_TYPE.XBOX;
}

function __get_thumbstick(_stick="left", _dir="up") {
	static dat = {
		"left" :	new __thumbstick_state(gp_axislh, gp_axislv),
		"right" :	new __thumbstick_state(gp_axisrh, gp_axisrv),
	};
	
	return dat[$ _stick].binds[$ _dir];
}

function __thumbstick_state(_ax, _ay) constructor {
	static pad = __get_active_gamepad();
	
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
		if (pad != __get_active_gamepad()) {
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
}
