updateDrawbox(0.5);

/*
hardcoding menu input so u cant accidentally rebind it lol


*/

if (--inputTimer <= 0) {
	var keypressed = true;
	var next = noone;
	
	if (keyboard_check_pressed(vk_right)) {
		if (current.onRight == undefined) {
			next = scanForNextButton(0);
		}
		else {
			current.onRight();
		}
	}
	else if (keyboard_check_pressed(vk_left)) {
		if (current.onLeft == undefined) {
			next = scanForNextButton(180);
		}
		else {
			current.onLeft();
		}
	}
	else if (keyboard_check_pressed(vk_down)) {
		next = scanForNextButton(270);
	}
	else if (keyboard_check_pressed(vk_up)) {
		next = scanForNextButton(90);
	}
	else if (keyboard_check_pressed(vk_shift)) {
		with (current) {
			if (onPress != undefined) {
				onPress();
			}
		}
	}
	else if (keyboard_check_pressed(ord("Z"))) {
		// back
		with (MenuParent) {
			if (onBack != undefined) {
				onBack();
			}
		}
	}
	else {
		keypressed = false;
	}
	
	if (keyboard_check_released(vk_shift)) {
		with (current) {
			if (onRelease != undefined) {
				onRelease();
			}
		}
	}
	
	if (keypressed) {
		inputTimer = inputCooldown;
		
		if (next != noone) {
			if (next == current) {
				//var ux = -dcos(lastMoveDirection) * current.width;
				//var uy =  dsin(lastMoveDirection) * current.height;
				var ux =  dcos(lastMoveDirection) * 32;
				var uy = -dsin(lastMoveDirection) * 32;
				
				with (drawbox) {
					x0 += ux;
					x1 += ux;
					y0 += uy;
					y1 += uy;
				}
			}
			else {
				with (current) {
					if (onRelease != undefined) {
						onRelease();
					}
				}
				current = next;
			}
		}
	}
}
