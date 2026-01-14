if (!other.dead) {
	if (autosave) {
		engineSettings("autosave", true);
	}
	instance_destroy(Player);
	room_goto(roomTo);
}