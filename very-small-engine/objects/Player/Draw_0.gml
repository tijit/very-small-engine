var drawY = y;
if (gravDir < 0) drawY += 1;

draw_sprite_ext(sprite_index, -1, x, drawY, facing, gravDir, 0, image_blend, image_alpha);
