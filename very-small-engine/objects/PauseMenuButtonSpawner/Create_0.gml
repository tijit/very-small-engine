buttonWidth = 400;
buttonHeight = 32;
pad = 32;

x = (GAME_WIDTH - buttonWidth) div 2;
y = pad * 2.5;
//x1 = GAME_WIDTH - x;

var buttonList = [
	ButtonResumeGame,
	ButtonMasterVolume,
	ButtonResetGame,
	ButtonQuitGame,
];

for (var i = 0; i < array_length(buttonList); i++) {
	instance_create_depth(x, y, 0, buttonList[i], {
		"width" : buttonWidth,
		"height" : buttonHeight,
	});
	y += buttonHeight + pad;
}


instance_destroy();
