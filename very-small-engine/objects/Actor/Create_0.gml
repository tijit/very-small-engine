/// parent for player and other objects that are pushed around by moving blocks

hspd = 0;
vspd = 0;
xRemainder = 0;
yRemainder = 0;

gravDir = 1;

// default behav for when a block pushes an Actor into wall
squish = function() {
	// instance_destroy();
};

// am i riding this block
isRiding = function(inst) {
	// if (place_meeting(x,y+gravSgn,inst) && vspd >= 0) return true;
	return false
};
