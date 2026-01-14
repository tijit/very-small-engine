/// automatically called at game start. put default binds here
function inputInit() {
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
}

function inputHeld(verb) {
	return inputCheck(verb, "held");
}

function inputPressed(verb) {
	return inputCheck(verb, "pressed");
}

function inputReleased(verb) {
	return inputCheck(verb, "released");
}
