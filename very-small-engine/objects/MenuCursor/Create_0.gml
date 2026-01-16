x = room_width;
y = room_height;

depth = -1;

current = noone;

drawbox = {
	"x0" : 0,
	"y0" : 0,
	"x1" : 0,
	"y1" : 0,
};
pad = 8;

inputTimer = 0;
inputCooldown = engineSettings("menu_input_cooldown");
lastMoveDirection = 0;

lastInputWasKeyboard = __input__().last_input_keyboard;

tooltip = "";
updateTooltip = function() {
	var showControls = instance_exists(ButtonControls);
	var names = [];
	if (lastInputWasKeyboard) {
		names = [
			"arrow keys",
			"shift",
			"del",
			"esc",
			"back",
		];
	}
	else {
		var padType = __active_gamepad().type;
		var confInd = array_get_index(__gamepad_buttons(), gp_face1);
		var delInd = array_get_index(__gamepad_buttons(), gp_face3);
		var backInd = array_get_index(__gamepad_buttons(), gp_face2);
		names = [
			"dpad, L-Stick",
			__gamepad_butnames(confInd, padType),
			__gamepad_butnames(delInd, padType),
			"START",
			__gamepad_butnames(backInd, padType),
		];
	}
	
	tooltip = $"select - {names[0]}\nconfirm - {names[1]}\n";
	if (showControls) {
		tooltip += $"delete bind - {names[2]}\ncancel bind - {names[3]}\n";
	}
	tooltip += $"back - {names[4]}";
	//tooltip = "arrow keys, d-pad, LSTICK - select\nshift, (A), cross - confirm\n";
	//	tooltip += "delete, (X), square - delete bind\nescape, START - cancel bind\n";
	//tooltip += "z, (B), circle - back";
};
updateTooltip();

resetPosition = function() {
	if (!instance_exists(MenuParent)) {
		instance_destroy();
		return;
	}
	
	// find top-most left-most element
	with (MenuParent) {
		if (y < other.y) {
			other.x = x;
			other.y = y;
			other.current = id;
		}
		else if (y == other.y && x < other.x) {
			other.x = x;
			other.y = y;
			other.current = id;
		}
	}
};

resetPosition();

updateDrawbox = function(lerpFactor=1) {
	if (!instance_exists(current)) {
		resetPosition();
		return;
	}
	var xx0 = current.x - pad;
	var yy0 = current.y - pad;
	var xx1 = current.x + current.width + pad;
	var yy1 = current.y + current.height + pad;
	
	with (drawbox) {
		x0 = lerp(x0, xx0, lerpFactor);
		y0 = lerp(y0, yy0, lerpFactor);
		x1 = lerp(x1, xx1, lerpFactor);
		y1 = lerp(y1, yy1, lerpFactor);
	}
};
updateDrawbox(1);

/// it just works
/// dont even worry about it
scanForNextButton = function(dir) {
	if (!instance_exists(current)) {
		resetPosition();
		return noone;
	}
	
	lastMoveDirection = dir;
	
	var cx = current.x;
	var cy = current.y;
	var cw = current.width;
	var ch = current.height;
	
	x = cx
	y = cy
	
	var dx =  dcos(dir);
	var dy = -dsin(dir);
	
	var xscan = (abs(dx) > abs(dy)) ? true : false;
	var sgn = (xscan) ? sign(dx) : sign(dy);
	
	var ux = (1 + dx)/2;
	var uy = (1 + dy)/2;
	
	x += ux * cw;
	y += uy * ch;
	
	var vx = 1-ux;
	var vy = 1-uy;
	
	var candidates = [ ];
	var ncandidates = 0;
	
	with (MenuButtonParent) {
		// how far is the closest edge in direction (negative = screenwrap)
		var len = (xscan) ? sgn * (x + vx * width - other.x) : sgn * (y + vy * height - other.y);
		// how much overlap is there (perpendicular to direction)
		var overlap = (xscan) ? slineDist1D(y, y+height, cy, cy+ch) : slineDist1D(x, x+width, cx, cx+cw);
		array_push(candidates, {
			"inst" : id,
			"len" : len,
			"overlap" : overlap,
		});
		ncandidates++;
	}
	
	array_sort(candidates, function(a,b) {
		var sgn = 0;
		if (sign(a.overlap) == sign(b.overlap)) { // are both buttons overlapping (or not overlapping)
			sgn = sign(a.len - b.len);
			if (sgn == 0) sgn = sign(a.overlap - b.overlap);
		}
		else {
			sgn = sign(a.overlap - b.overlap);
			if (sgn == 0) sgn = sign(a.len - b.len);
		}
		return sgn;
	});
	
	// find first button in the direction of keypress
	for (var i = 0; i < ncandidates; i++) {
		if (candidates[i].len > 0) {
			return candidates[i].inst;
		}
	}
	// if no positive values, take first screenwrapped candidate
	return candidates[0].inst;
};
