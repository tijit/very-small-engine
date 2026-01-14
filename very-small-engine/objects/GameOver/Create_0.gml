depth = -99;

text = engineSettings("gameover_text");
font = engineSettings("gameover_font");

var temp = draw_get_font();
draw_set_font(font);
width = string_width(text);
height = string_height(text);
draw_set_font(temp);

x = (GAME_WIDTH - width) div 2;
y = (GAME_HEIGHT - width) div 2;
