event_inherited();

text = "vsync";

buttonTemplateToggle("vsync", "on", "off");

onChange = function() {
	updateDisplay();
};
