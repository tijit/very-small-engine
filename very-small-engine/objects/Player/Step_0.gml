if (dead) {
	mask_index = maskNothing;
	visible = false;
	exit;
}

if (inputHeld("teleport_mouse")) {
	x = rounded(mouse_x);
	y = rounded(mouse_y);
	hspd = 0;
	vspd = -GRAV;
	refreshJumps();
}

checkGround();

#region horizontal input

hspd = 0;

if (inputHeld("right")) {
	hspd = RUN_SPEED;
	facing = 1;
}
else if (inputHeld("left")) {
	hspd = -RUN_SPEED;
	facing = -1;
}

#endregion

#region vertical input

if (inputPressed("jump") && !(onVine && engineSettings("maker_vines")) ) {
	if (onGround || place_meeting(x, y, PlatformParent)) {
		doSingleJump();
	}
	else if (djumps > 0 || engineSettings("infinite_jump")) {
		doDoubleJump();
	}
}

if (inputReleased("jump")) {
	if (vspd < 0) {
		vspd *= VJUMP;
	}
}

#endregion

#region movement

handleWater(); // put cursor over function and press 'F1' to see how this works
handleVines();

capVspd(FALL_SPEED);

vspd += GRAV;

var snap = noone; // snap to platform?

var xto = moveX(hspd);
if (vspd < 0) snap = instance_place(x, y, Snapform);
moveY(gravDir * vspd, onBonk);
if (snap != noone && !place_meeting(x, y, Snapform)) { vspd *= -1; moveY(gravDir * vspd, onBonk); }
if (x != xto) {
	moveX(xto-x); // comment out this line for free vstrings all the time
}

#endregion

#region animation

if (onGround) {
	if (hspd != 0) {
		sprite_index = sprPlayerRun;
	}
	else {
		sprite_index = sprPlayerIdle;
	}
}
else {
	if (vspd < 0) {
		sprite_index = sprPlayerJump;
	}
	else {
		sprite_index = sprPlayerFall;
	}
}

if (onVine) {
	sprite_index = sprPlayerVine;
}

#endregion

#region very small gun

if (inputPressed("shoot")) {
	if (instance_number(PlayerBullet) < GUN_BULLET_CAP) {
		audio_play_sound(sndShoot, 0, false);
		instance_create_depth(x, y, 0, PlayerBullet, {
			hspd : facing * GUN_BULLET_SPEED,
			vspd : 0,
		});
	}
}

#endregion

#region death conditions

if (place_meeting(x, y, Killer)) {
	killPlayer();
}

if (y > room_height && engineSettings("die_below_floor")) {
	killPlayer();
}

if (y < 0 && engineSettings("die_above_ceiling")) {
	killPlayer();
}

#endregion
