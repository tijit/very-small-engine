verbs = [
	"jump",
	"shoot",
	"left",
	"right",
	
	"retry",
	"pause",
];

forbiddenKeys = [
	//vk_escape,
];

pad = 32;

x = pad;
y = pad;

w0 = room_width div 2 - x;
w1 = 96;

var dat = __input__();

var bindCount = 4;

for (var i = 0; i < array_length(verbs); i++) {
	var verb = verbs[i];
	var bind = dat.binds[$ verb];
	//var states = kb ? bind.keyboardStates : bind.gamepadStates;
	
	var xx = x;
	
	instance_create_depth(xx, y, 0, TextDrawer, {
		"text" : verb,
	});
	
	xx += w0 + pad;
	
	for (var j = 0; j < bindCount; j++) {
		instance_create_depth(xx, y, 0, ButtonControls, {
			"kb" :		kb,
			"bind" :	bind,
			"ind" :		j,
			"width" :	w1,
			"height" :	pad,
		});
	}
	
	y += pad * 2;
}

instance_destroy();
