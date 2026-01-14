function drawReset() {
	draw_set_font(engineSettings("default_font"));
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	
	draw_set_color(c_white);
	draw_set_alpha(1);
	gpu_set_blendmode(bm_normal);
}
