with (all) {
	if (id != other.id) {
		instance_destroy();
	}
}

depth = -9999;
u_texel = shader_get_uniform(shPxUpscale, "u_texel");

persistent = true;

firstRoom = rSplash;
if (engineSettings("skip_splash")) {
	firstRoom = rMenuSaves;
}

gamePaused = false;
gamePausing = false;

// used for cameras
firstFrameOfRoom = true;

gameResetting = false;

depth = -1000;

gameTimer = current_time;

room_goto(firstRoom);
