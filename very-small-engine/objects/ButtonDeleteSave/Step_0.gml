event_inherited();

if (ticking) {
	holdTime++;
	if (holdTime >= holdTimeRequired) {
		ticking = false;
		holdTime = 0;
		with (ButtonLoadGame) {
			if (num == other.num) {
				isnewgame = true;
				updateText();
			}
		}
	}
}
