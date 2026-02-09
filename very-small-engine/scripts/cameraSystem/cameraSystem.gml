function __get_camera() {
	static cam = (function() {
		
		var c = camera_create();
		camera_set_view_size(c, GAME_WIDTH, GAME_HEIGHT);
		camera_set_view_pos(c, 0, 0);
		
		return {
			"cam" : c,
			"x" : 0,
			"y" : 0,
			"zero" : false,
		};
	})();
	return cam;
}

function __camera_set_position(xx, yy) {
	var dat = __get_camera();
	
	var mv = __camera_can_move();
	
	if (mv == true) {
		dat.x = xx;
		dat.y = yy;
	}
	
	if (engineSettings("clamp_camera")) {
		dat.x = clampCameraX(dat.x);
		dat.y = clampCameraY(dat.y);
	}
	
	if (mv != undefined) {
		camera_set_view_pos(dat.cam, dat.x, dat.y);
	}
	else {
		camera_set_view_pos(dat.cam, 0, 0);
	}
}

function __camera_can_move() {
	with (Player) {
		if (dead) {
			return false;
		}
		return true;
	}
	return undefined;
}
