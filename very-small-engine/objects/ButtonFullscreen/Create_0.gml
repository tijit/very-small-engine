event_inherited();

text = "fullscreen";

buttonTemplateToggle("fullscreen", "on", "off");

onChange = function() {
	updateDisplay();
};
