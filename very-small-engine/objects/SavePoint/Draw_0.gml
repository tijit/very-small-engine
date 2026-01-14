if (gravDir > 0) {
	draw_self();
}
else {
	draw_sprite_ext(sprite_index, -1, x, y+32, 1, -1, 0, image_blend, image_alpha);
}
