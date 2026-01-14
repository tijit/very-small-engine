event_inherited();

holdTime = 0;
holdTimeRequired = 75;
ticking = false;

onPress = function() {
	ticking = true;
};

onRelease = function() {
	holdTime = 0;
	ticking = false;
};
