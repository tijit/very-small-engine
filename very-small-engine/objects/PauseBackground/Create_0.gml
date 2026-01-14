depth = 1;

var spr = __pause_sprite();
spr = spr[$ "spr"];

if (spr == undefined || !sprite_exists(spr)) {
	instance_destroy();
	exit;
}

sprite_index = spr;
image_blend = merge_color(c_black, c_white, 0.1);

x = 0;
y = 0;
