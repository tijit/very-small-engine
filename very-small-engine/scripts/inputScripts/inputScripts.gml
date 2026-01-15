/// automatically called at game start. put default binds here
function inputInit() {
	
	#region keyboard
	
	inputAddBind("left", vk_left);
	inputAddBind("right", vk_right);
	inputAddBind("jump", vk_shift);
	inputAddBind("shoot", ord("Z"));
	inputAddBind("die", ord("Q"));
	inputAddBind("retry", ord("R"));
	
	// more than one button can be set to the same verb
	inputAddBind("pause", ord("P"));
	inputAddBind("pause", vk_escape);
	
	inputAddBind("reset_game", vk_f2);
	inputAddBind("fullscreen", vk_f4);
	
	inputAddBind("music_mute", ord("M"));
	
	// put custom binds in here //
	
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
	gamepadAddBind("left", LSTICK_RIGHT);
	
	gamepadAddBind("jump", gp_face1);
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
