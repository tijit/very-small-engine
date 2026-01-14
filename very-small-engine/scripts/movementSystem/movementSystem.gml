function moveX(amount=hspd, onCollide=undefined) {
	var xto = x;
	xRemainder += amount;
	var mv = rounded(xRemainder);
	if (mv != 0) {
		xRemainder -= mv;
		xto = x + mv;
		var sgn = sign(mv);
		repeat(abs(mv)) {
			if (!checkCollision(x+sgn, y)) {
				x += sgn;
			}
			else {
				if (onCollide != undefined) {
					onCollide();
				}
				break;
			}
		}
	}
	return xto;
}

function moveY(amount=vspd, onCollide=undefined) {
	var yto = y;
	yRemainder += amount;
	var mv = rounded(yRemainder);
	if (mv != 0) {
		yRemainder -= mv;
		yto = y + mv;
		var sgn = sign(mv);
		repeat(abs(mv)) {
			if (!checkCollision(x, y+sgn)) {
				y += sgn;
			}
			else {
				if (onCollide != undefined) {
					onCollide();
				}
				break;
			}
		}
	}
	return yto;
}

function moveBlock(dx, dy) {
	xRemainder += dx;
	yRemainder += dy;
	var mx = rounded(xRemainder);
	var my = rounded(yRemainder);
	
	if (mx != 0 || my!= 0) {
		var ridingList = [ ];
		with (Actor) {
			if (isRiding(other)) {
				array_push(ridingList, id);
			}
		}
		
		var box = getTempCollider();
		box.x = x;
		box.y = y;
		box.mask_index = (mask_index > -1) ? mask_index : sprite_index;
		box.image_xscale = image_xscale;
		box.image_yscale = image_yscale;
		
		var mask0 = mask_index;
		mask_index = maskNothing;
		
		if (mx != 0) {
			xRemainder -= mx;
			x += mx;
			box.x = x;
			if (mx > 0) { // RIGHT
				with (Actor) {
					if (place_meeting(x, y, box)) {
						// get pushed right
						moveX(box.bbox_right-bbox_left, squish);
					}
					else if (array_contains(ridingList, id)) {
						// get carried right
						moveX(mx);
					}
				}
			}
			else { // LEFT
				with (Actor) {
					if (place_meeting(x, y, box)) {
						// get pushed left
						moveX(box.bbox_left-bbox_right, squish);
					}
					else if (array_contains(ridingList, id)) {
						// get carried left
						moveX(mx);
					}
				}
			}
		}
		
		if (my != 0) {
			yRemainder -= my;
			y += my;
			box.y = y;
			if (my > 0) { // MOVE DOWN
				with (Actor) {
					if (place_meeting(x, y, box)) {
						// get pushed down
						moveY(box.bbox_bottom-bbox_top, squish);
					}
					else if (array_contains(ridingList, id)) {
						// get carried down
						moveY(my);
					}
				}
			}
			else { // MOVE UP
				with (Actor) {
					if (place_meeting(x, y, box)) {
						// get pushed up
						moveY(box.bbox_top-bbox_bottom, squish);
					}
					else if (array_contains(ridingList, id)) {
						// get carried up
						moveY(my);
					}
				}
			}
		}
		
		mask_index = mask0;
	}
}

/// this version only moves Actors that are riding on top
function movePlatform(dx, dy) {
	xRemainder += dx;
	yRemainder += dy;
	
	var mx = rounded(xRemainder);
	var my = rounded(yRemainder);
	
	if (mx != 0 || my!= 0) {
		var ridingList = [ ];
		with (Actor) {
			if (isRiding(other)) {
				array_push(ridingList, id);
			}
		}
		
		var box = getTempCollider();
		box.x = x;
		box.y = y;
		box.mask_index = (mask_index > -1) ? mask_index : sprite_index;
		box.image_xscale = image_xscale;
		box.image_yscale = image_yscale;
		
		var mask0 = mask_index;
		mask_index = maskNothing;
		
		// moving left and right: only move objects that are riding it
		if (mx != 0) {
			xRemainder -= mx;
			x += mx;
			box.x = x;
			with (Actor) {
				if (array_contains(ridingList, id)) {
					// get carried horizontally
					moveX(mx);
				}
			}
		}
		
		// moving up and down: only move riding objects OR objects that u push into
		if (my != 0) {
			yRemainder -= my;
			y += my;
			box.y = y;
			if (my > 0) { // MOVE DOWN
				with (Actor) {
					if (place_meeting(x, y, box) && !place_meeting(x, y+my, box)) {
						// get pushed down
						if (gravDir < 0) {
							moveY(box.bbox_bottom-bbox_top, squish);
						}
					}
					else if (array_contains(ridingList, id)) {
						// get carried down
						moveY(my);
					}
				}
			}
			else { // MOVE UP
				with (Actor) {
					if (place_meeting(x, y, box) && !place_meeting(x, y+my, box)) {
						// get pushed up
						if (gravDir > 0) {
							moveY(box.bbox_top-bbox_bottom, squish);
						}
					}
					else if (array_contains(ridingList, id)) {
						// get carried up
						moveY(my);
					}
				}
			}
		}
		
		mask_index = mask0;
	}
};

function blockMoveAndBounce(vs=vspd, hs=hspd) {
	var moveFunc = (object_is_ancestor(object_index, PlatformParent) ? movePlatform : moveBlock);
	if (!place_meeting(x+hspd, y+vspd, PlatformBouncer)) {
		moveFunc(hspd, vspd);
	}
	else {
		var steps = max(abs(hspd), abs(vspd));
		var dx = hspd / steps;
		var dy = vspd / steps;
		var xx = x; var yy = y;
		repeat(ceil(steps)) {
			if (place_meeting(xx+dx, yy, PlatformBouncer)) {
				hspd *= -1;
				break;
			}
			if (place_meeting(xx, yy+dy, PlatformBouncer)) {
				vspd *= -1;
				break;
			}
			if (place_meeting(xx+dx, yy+dy, PlatformBouncer)) {
				hspd *= -1;
				vspd *= -1;
				break;
			}
			xx += dx; yy += dy;
		}
		moveFunc(xx-x, yy-y);
	}
}

function getTempCollider() {
	with (TempHitbox) {
		return reset();
	}
	return instance_create_depth(0, 0, 0, TempHitbox).reset();
}

function __temp_collision_list() {
	static list = ds_list_create();
	return list;
}

function getAllCollisions(x0, y0, obj, clearList=true) {
	var list = __temp_collision_list();
	if (clearList) {
		ds_list_clear(list);
	}
	instance_place_list(x0, y0, obj, list, false);
	return list;
}
