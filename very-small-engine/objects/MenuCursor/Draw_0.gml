with (drawbox) {
	draw_sprite_ext(sprRect4, 0, x0, y0, (x1-x0)/4, (y1-y0)/4, 0, c_white, 1);
}

draw_set_halign(fa_left);
draw_set_valign(fa_bottom);
draw_text(4, GAME_HEIGHT-4, tooltip);

drawReset();
