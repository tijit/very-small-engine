if (gamePausing) exit;

if (instance_exists(CameraParent)) {
	with (CameraParent) {
		update(other.firstFrameOfRoom);
		__camera_set_position(x,y);
	}
}
else {
	cameraSnapToPlayer();
}

firstFrameOfRoom = false;
