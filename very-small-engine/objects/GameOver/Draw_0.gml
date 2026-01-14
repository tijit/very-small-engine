drawOnHud(function() {
	draw_set_font(font);
	
	draw_set_color(c_black);
	var pad = 8;
	draw_rectangle(x - pad, y - pad, x + width + pad, y + height + pad, 0);
	
	draw_set_color(c_white);
	
	draw_text(x, y, text);

	drawReset();
});
