event_inherited();

text = "sound volume";

buttonTemplateSlider("sound_volume", true, 0.1, 0, 1);

onChange = function() {
	masterAudio();
	audio_play_sound(sndShoot, 0, false);
};
