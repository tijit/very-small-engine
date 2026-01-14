enum GAMEPAD_TYPE {
	XBOX,
	PLAYSTATION,
}

function __thumbstick_state(_pad, _ax, _ay, _name) constructor {
	pad = _pad;
	ax = _ax;
	ay = _ay;
	name = _name;
	
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
