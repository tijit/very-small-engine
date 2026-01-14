xsgn = 0;
if (sprite_index > 0) {
	var str = sprite_get_name(sprite_index);
	var right = string_last_pos("R", str);
	var left = string_last_pos("L", str);
	xsgn = sign(left - right);
}

// function to override in child objects
// if the vine has special effects

onTouch = undefined;
onJump = undefined;
