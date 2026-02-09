function cameraX() {
	return camera_get_view_x(__get_camera().cam);
}

function cameraY() {
	return camera_get_view_y(__get_camera().cam);
}

function cameraSnapToPlayer() {
	var xx = 0;
	var yy = 0;
	with (Player) {
		xx = floor(x / GAME_WIDTH) * GAME_WIDTH;
		yy = floor(y / GAME_HEIGHT) * GAME_HEIGHT;
	}

	__camera_set_position(xx,yy);
}

function clampCameraX(_x) {
	return clamp(_x, 0, room_width-GAME_WIDTH);
}

function clampCameraY(_y) {
	return clamp(_y, 0, room_height-GAME_HEIGHT);
}

/// calls drawCode shifted by camera coords. useful for HUD elements or rendering to surfaces
function drawOnHud(drawCode) {
	matrix_set(matrix_world, matrix_build(cameraX(), cameraY(), 0, 0, 0, 0, 1, 1, 1));
	
	drawCode();
	
	matrix_set(matrix_world, matrix_build_identity());
}
