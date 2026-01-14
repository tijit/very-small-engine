draw_self();

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_set_font(font);
draw_set_color(c_white);
draw_text_transformed(x, textY, text, textScale, textScale, 0);

drawReset();
