event_inherited();

updateWindowCaption();

dead = false;

depth = engineSettings("depth_player");

mask_index = maskPlayer;
sprite_index = sprPlayerIdle;

onGround = false;
doubleJumpMax = 1;
djumps = doubleJumpMax;

facing = 1; // xscale for drawing
gravDir = 1; // 1=down -1=up

inWater = false;
onVine = false;

#region movement helper methods

onBonk = function() {
	if (vspd > 0) onGround = true;
	vspd = 0;
};

checkGround = function() {
	onGround = (checkCollision(x, y+gravDir) && vspd >= 0);
	if (onGround) {
		refreshJumps();
	}
	return onGround;
};

doSingleJump = function() {
	audio_play_sound(sndJump1, 0, false);
	vspd = -JUMP1;
	refreshJumps();
};

doDoubleJump = function() {
	audio_play_sound(sndJump2, 0, false);
	djumps--; // TODO: if engineSettings("maker_vines") and on a vine dont eat double jump here
	vspd = -JUMP2;
};

refreshJumps = function(num=doubleJumpMax) {
	djumps = max(djumps, num);
};

squish = function() {
	killPlayer();
};

capVspd = function(cap) {
	if (vspd > cap) {
		vspd = cap;
	}
};

isRiding = function(inst) {
	if (place_meeting(x, y+gravDir, inst) && vspd >= 0) {
		if (!object_is_ancestor(inst.object_index, PlatformParent)) {
			return true;
		}
		else {
			return (!place_meeting(x, y, inst));
		}
	}
	return false;
};

#endregion
