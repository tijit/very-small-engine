event_inherited();

if (ticking) {
	var tween = clamp(holdTime / holdTimeRequired, 0, 1);
	draw_sprite_ext(sprPixel, 0, x, y, rounded(tween * width), height, 0, #550000, tween);
}
