function killPlayer() {
	if (engineSettings("god_mode")) return;
	with (Player) {
		if (!dead) {
			dead = true;
			
			incrementDeaths();
			if (engineSettings("death_updates_save")) {
				writeGameState();
			}
			
			audio_play_sound(sndDeath, 0, false);
			//playMusic("gameover");
			instance_create_depth(x, y, depth, PlayerDeathEffect);
			instance_create_depth(0, 0, 0, GameOver);
		}
	}
}

/// checks if a block is at (x,y)
/// only returns true for platforms if u are above them, relative to your gravDir
function checkCollision(xx, yy, inst = id) {
	with (inst) {
		if (place_meeting(xx, yy, BlockParent)) {
			return true;
		}
		if (gravDir > 0) {
			with (PlatformParent) {
				if (other.bbox_bottom <= bbox_top && place_meeting(x - (xx - other.x), y - (yy - other.y), other)) {
					return true;
				}
			}
		}
		else {
			with (PlatformParent) {
				if (other.bbox_top >= bbox_bottom && place_meeting(x - (xx - other.x), y - (yy - other.y), other)) {
					return true;
				}
			}
		}
	}
	return false;
}

function handleWater() {
	inWater = false;
	
	var list = getAllCollisions(x, y, WaterParent);
	var n = ds_list_size(list);
	if (n > 0) {
		inWater = true;
		
		capVspd(FLOAT_SPEED);
		
		var jumpPressed = ( inputPressed("jump") );//&& vspd > -JUMP1 );
		
		// jump in water
		for (var i = 0; i < n; i++) {
			var w = list[| i];
			
			if (jumpPressed && w.onJump != undefined) {
				w.onJump(id);
			}
		}
		
		// iterate over again for onTouch() to refresh double jump
		for (var i = 0; i < n; i++) {
			var w = list[| i];
			
			if (w.onTouch != undefined) {
				w.onTouch(id);
			}
		}
	}
}

function handleVines() {
	onVine = false;
	
	var list = getAllCollisions(x+facing, y, VineParent);
	getAllCollisions(x-facing, y, VineParent, false);
	var n = ds_list_size(list);
	if (n > 0) {
		onVine = true;
		
		vspd = FLOAT_SPEED;
		
		var leftpress = inputPressed("left");
		var rightpress = inputPressed("right");
		var jumpheld = inputHeld("jump");
		var makerjump = engineSettings("maker_vines") && inputPressed("jump");
		var vineJump = false;
		var v;
		for (var i = 0; i < n; i++) {
			v = list[| i];
			
			if (v.onTouch != undefined) {
				v.onTouch(id);
			}
			
			if (v.xsgn != 0) {
				facing = v.xsgn;
			}
			
			if ((jumpheld && leftpress || makerjump) && (v.xsgn <= 0 && bbox_right <= v.bbox_left)) {
				moveX(-15);
				vineJump = true;
				break;
			}
			else if ((jumpheld && rightpress || makerjump) && (v.xsgn >= 0 && bbox_left >= v.bbox_right)) {
				moveX(15);
				vineJump = true;
				break;
			}
		}
		if (vineJump) {
			vspd = -JUMP_VINE;
			onVine = false;
			audio_play_sound(sndVine, 0, false);
			if (v.onJump != undefined) {
				v.onJump(id);
			}
		}
	}
}
