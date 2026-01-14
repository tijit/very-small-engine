// functions for child objects to override
onTouch = undefined;

onJump = function(plr) {
	if (plr.vspd > -JUMP2) {
		plr.doDoubleJump();
	}
}

depth = engineSettings("depth_water");
