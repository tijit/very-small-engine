// this should be the last thing called before the application surface is rendered
// scale this up smoothly
//gpu_set_tex_filter(global.filterScaledWindow);

if (gameResetting) {
	draw_clear(c_black);
	exit;
}

var window_width = window_get_width();
var window_height = window_get_height();

gpu_set_blendenable(false);

var surf = application_surface;

if (window_width mod GAME_WIDTH != 0 || window_height mod GAME_HEIGHT != 0) {
    var aspect_ratio = window_width / window_height;
    var aspect_ratio_ratio = aspect_ratio / (GAME_WIDTH/GAME_HEIGHT);
    
    gpu_set_texfilter(true);
    shader_set(shPxUpscale);
    
    if (aspect_ratio_ratio < 1) {
        var canvas_height = window_width*GAME_HEIGHT/GAME_WIDTH;
        var vert_out_pixels = (window_height - canvas_height) / 2;
        shader_set_uniform_f(u_texel, GAME_WIDTH/window_width, GAME_HEIGHT/canvas_height);
        draw_surface_stretched(surf, 0, vert_out_pixels, window_width, canvas_height);
    }
	else {
        var canvas_width = window_height*GAME_WIDTH/GAME_HEIGHT;
        var hor_out_pixels = (window_width - canvas_width) / 2;
        shader_set_uniform_f(u_texel, GAME_WIDTH/canvas_width, GAME_HEIGHT/window_height);
        draw_surface_stretched(surf, hor_out_pixels, 0, canvas_width, window_height);
    }
    
    shader_reset();
    gpu_set_texfilter(false);
}
else {
    draw_surface(surf,0,0);
}

gpu_set_blendenable(true);
