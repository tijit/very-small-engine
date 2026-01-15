if (keyboard_check_pressed(vk_anykey) || __input__().gamepad_any) {
	room_goto(rMenuSaves);
	//room_goto(rButtonsTest);
	//startNewGame();
}
