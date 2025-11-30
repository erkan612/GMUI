gmui_render();

surface_set_target(surfaceView);
draw_clear_alpha(c_white, 0);

draw_set_colour(c_dkgray);
var gridSize = 32;
for (var i = 0; i <= surface_get_width(surfaceView); i += gridSize) {
	draw_line(i, 0, i, surface_get_height(surfaceView));
};
for (var i = 0; i <= surface_get_height(surfaceView); i += gridSize) {
	draw_line(0, i, surface_get_width(surfaceView), i);
};
draw_set_colour(c_white);

for (var i = 0; i < array_length(objects); i++) {
    var object = objects[i];
	
	switch (object.type) {
	case "Box": {
		draw_rectangle(object.x, object.y, object.x + object.width, object.y + object.height, false);
	} break;
	case "Circle": {
		draw_ellipse(object.x, object.y, object.x + object.width, object.y + object.height, false);
	} break;
	};
}

surface_reset_target();