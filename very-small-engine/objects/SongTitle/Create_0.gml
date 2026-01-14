var title = getSongTitle();

if (string_length(title) == 0) {
	instance_destroy();
	exit;
}

text = $"currently playing  -  {title}";

w = string_width(text);

x = GAME_WIDTH - 8;
y = GAME_HEIGHT - 8;
