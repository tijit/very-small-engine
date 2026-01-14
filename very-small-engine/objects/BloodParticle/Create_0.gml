speed = lerp(3, 6, random(1));
direction = floor(random(360) / 5) * 5;
gravity = GRAV/2;

image_angle = random(360);
image_xscale = choose(-1,1);

timer = lerp(-25, 50, random(1));
bounced = false;

mask_index = maskNothing;

sprite_index = sprBlood;
image_index = floor(random(sprite_get_number(sprite_index)));
