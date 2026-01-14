event_inherited();

text = "music volume";

buttonTemplateSlider("music_volume", true, 0.1, 0, 1);

onChange = function() {
	masterAudio();
};
