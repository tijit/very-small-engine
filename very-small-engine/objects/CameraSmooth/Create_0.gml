event_inherited();

lerpFactor = 1/5;

update = function(instant=false) {
	var xto = x;
	var yto = y;
	with (Player) {
		if (!dead) {
			xto = x - GAME_WIDTH / 2;
			yto = y - GAME_HEIGHT / 2;
		}
	}
	
	if (instant) {
		x = xto;
		y = yto;
	}
	else {
		x = lerp(x, xto, lerpFactor);
		y = lerp(y, yto, lerpFactor);
	}
};
