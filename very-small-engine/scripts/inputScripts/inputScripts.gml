/// automatically called at game start. put default binds here
function inputInit() {
	if (loadControlsFromFile()) {
		return;
	}
	
	#region keyboard
	
	inputAddBind("left", vk_left);
	inputAddBind("right", vk_right);
	inputAddBind("jump", vk_shift);
	inputAddBind("shoot", ord("Z"));
	inputAddBind("die", ord("Q"));
	inputAddBind("retry", ord("R"));
	
	// more than one button can be set to the same verb
	inputAddBind("pause", vk_escape);
	inputAddBind("pause", ord("P"));
	
	inputAddBind("reset_game", vk_f2);
	inputAddBind("fullscreen", vk_f4);
	
	inputAddBind("music_mute", ord("M"));
	
	// put custom binds in here //
	// note: this code will not run if there is already a controls
	// file saved. for now, get around this by deleting the file
	// %localappdata%/game_name/controls
	
	//inputAddBind("special", ord("X"))
	//inputAddBind("quit", vk_escape);
	//inputAddBind("god_mode", ord("G"));
	//inputAddBind("teleport", vk_backspace);
	//inputAddBind("teleport_mouse", vk_tab);
	
	//
	
	#endregion
	
	#region gamepad
	// scan for pad once at start, so button names are
	// for the correct device (xbos or PS)
	__gamepad_scan();
	
	gamepadAddBind("left", gp_padl);
	gamepadAddBind("left", LSTICK_LEFT);
	gamepadAddBind("right", gp_padr);
	gamepadAddBind("right", LSTICK_RIGHT);
	
	gamepadAddBind("jump", gp_face1);
	
	gamepadAddBind("shoot", gp_face3);
	gamepadAddBind("shoot", gp_shoulderr);
	gamepadAddBind("shoot", gp_shoulderrb);
	
	gamepadAddBind("retry", gp_face4);
	
	gamepadAddBind("pause", gp_start);
	
	// custom controller pindings //
	
	//
	
	#endregion
}

function inputHeld(verb) {
	static dat = __input__();
	
	var b = dat.binds[$ verb];
	if (b == undefined) return false;
	
	return b.held;
}

function inputPressed(verb) {
	static dat = __input__();
	
	var b = dat.binds[$ verb];
	if (b == undefined) return false;
	
	return b.pressed;
}

function inputReleased(verb) {
	static dat = __input__();
	
	var b = dat.binds[$ verb];
	if (b == undefined) return false;
	
	return b.released;
}

function getMenuInput() {
	static dat = {
		"up" :					false,
		"down" :				false,
		"left" :				false,
		"right" :				false,
		"confirm" :				false,
		"confirm_released" :	false,
		"confirm_held" :		false,
		"back" :				false,
		"bind_cancel" :			false,
		"bind_delete" :			false,
	};
	
	dat.left = keyboard_check_pressed(vk_left);
	dat.right = keyboard_check_pressed(vk_right);
	dat.up = keyboard_check_pressed(vk_up);
	dat.down = keyboard_check_pressed(vk_down);
	
	dat.confirm = keyboard_check_pressed(vk_shift);
	dat.confirm_held = keyboard_check(vk_shift);
	dat.confirm_released = keyboard_check_released(vk_shift);
	dat.back = keyboard_check_pressed(ord("Z"));
	
	dat.bind_cancel = keyboard_check_pressed(vk_escape);
	dat.bind_delete = keyboard_check_pressed(vk_delete);
	
	if (gameSettings("gamepad_enabled")) {
		var device = __input__().device;
		if (device != undefined) {
			if (gamepad_button_check_pressed(device, gp_padl)
				|| getThumbstick(LSTICK_LEFT).pressed) dat.left = true;
			if (gamepad_button_check_pressed(device, gp_padr)
				|| getThumbstick(LSTICK_RIGHT).pressed) dat.right = true;
			if (gamepad_button_check_pressed(device, gp_padu)
				|| getThumbstick(LSTICK_UP).pressed) dat.up = true;
			if (gamepad_button_check_pressed(device, gp_padd)
				|| getThumbstick(LSTICK_DOWN).pressed) dat.down = true;
			
			if (gamepad_button_check_pressed(device, gp_face1)) dat.confirm = true;
			if (gamepad_button_check(device, gp_face1)) dat.confirm_held = true;
			if (gamepad_button_check_released(device, gp_face1)) dat.confirm_released = true;
			if (gamepad_button_check_pressed(device, gp_face2)) dat.back = true;
			
			if (gamepad_button_check_pressed(device, gp_start)) dat.bind_cancel = true;
			if (gamepad_button_check_pressed(device, gp_face3)) dat.bind_delete = true;
		}
	}
	
	return dat;
}
