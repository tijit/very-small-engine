updateDrawbox(0.5);

var lik = __input__().last_input_keyboard;
if (lik != lastInputWasKeyboard) {
	lastInputWasKeyboard = lik;
	updateTooltip();
}

/*
hardcoding menu input so u cant accidentally rebind it lol


*/

if (__input__().awaiting_rebind) {
	inputTimer = inputCooldown;
}

if (--inputTimer <= 0) {
	var keypressed = true;
	var next = noone;
	
	var in = getMenuInput();
	
	if (in.right) {
		if (current.onRight == undefined) {
			next = scanForNextButton(0);
		}
		else {
			current.onRight();
		}
	}
	else if (in.left) {
		if (current.onLeft == undefined) {
			next = scanForNextButton(180);
		}
		else {
			current.onLeft();
		}
	}
	else if (in.down) {
		next = scanForNextButton(270);
	}
	else if (in.up) {
		next = scanForNextButton(90);
	}
	else if (in.confirm) {
		with (current) {
			if (onPress != undefined) {
				onPress();
			}
		}
	}
	else if (in.back) {
		// back
		with (MenuParent) {
			if (onBack != undefined) {
				onBack();
			}
		}
	}
	else if (in.bind_cancel) {
		with (current) {
			if (onBindCancel != undefined) {
				onBindCancel();
			}
		}
	}
	else if (in.bind_delete) {
		with (current) {
			if (onBindDelete != undefined) {
				onBindDelete();
			}
		}
	}
	else {
		keypressed = false;
	}
	
	if (in.confirm_released) {
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
