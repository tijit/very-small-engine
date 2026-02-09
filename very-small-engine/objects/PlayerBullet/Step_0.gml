x += hspd;
y += vspd;

////
// if you want to do special collisions with triggers etc, this is the place - before wall collisions
var temp = image_xscale;

image_xscale = 2 * hspd / sprite_width;
var list = getAllCollisions(x - hspd div 2, y, BulletCollider);
var nlist = ds_list_size(list);
if (nlist > 0) hit = true;
for (var i = 0; i < nlist; i++) {
	var next = list[| i];
	with (next) {
		if (onCollide != undefined) {
			onCollide(other.id);
		}
	}
}

image_xscale = temp;

////

if (place_meeting(x, y, BlockParent)) {
	hit = true;
}

if (hit) {
	instance_destroy();
	exit;
}

if (--timer <= 0) {
	instance_destroy();
	exit;
}