event_inherited();

text = "mute music";

buttonTemplateToggle("music_muted", "on", "off");

onChange = function() {
	toggleMusic(gameSettings(option));
};
