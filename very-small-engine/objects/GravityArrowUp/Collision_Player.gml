with (other) {
	if (gravDir != other.gravDir) {
		vspd = 0;
		gravDir = other.gravDir;
		refreshJumps();
	}
}
