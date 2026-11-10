// functions for child objects to override
onTouch = undefined;

onJump = function(plr) {
	plr.doDoubleJump();
}

depth = engineSettings("depth_water");
