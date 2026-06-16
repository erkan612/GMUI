// CALLS
function gmui_add_call(type, params) {
	var gmui = global.gmui;
	var current_container = gmui.current_container;
	var calls_array = undefined;
	if (current_container == undefined) {
		calls_array = gmui.calls;
	}
	//else if (current_container.widget_flag && current_container.current_widget != undefined) {
	//	calls_array = current_container.current_widget.calls;
	//}
	else if (current_container.late_calls_enabled) {
		calls_array = current_container.late_calls;
	}
	else {
		calls_array = current_container.calls;
	};
	
	if (calls_array == undefined) { return; }; // this shouldnt happen
	
	array_push(calls_array, {
		type: type, 
		params: params
	});
};

function gmui_handle_call(call, origin_x = 0, origin_y = 0) {
	var params = call.params;
    
    if (!is_struct(params)) { return; };
	
	if (variable_struct_exists(params, "x"))  { params.x  += origin_x; };
	if (variable_struct_exists(params, "y"))  { params.y  += origin_y; };
	if (variable_struct_exists(params, "x1")) { params.x1 += origin_x; };
	if (variable_struct_exists(params, "y1")) { params.y1 += origin_y; };
	if (variable_struct_exists(params, "x2")) { params.x2 += origin_x; };
	if (variable_struct_exists(params, "y2")) { params.y2 += origin_y; };
	if (variable_struct_exists(params, "x3")) { params.x3 += origin_x; };
	if (variable_struct_exists(params, "y3")) { params.y3 += origin_y; };
	
	var _vc = global.gmui.visual_calls ?? gmui_get_default_visual_calls();
	
	switch (call.type) {
	// Misc Calls
	case "font_set": {
		_vc.draw_set_font(params.font);
	} break;

	case "halign_set": {
		_vc.draw_set_halign(params.halign);
	} break;

	case "valign_set": {
		_vc.draw_set_valign(params.valign);
	} break;

	case "primitive_type_set": {
		_vc.draw_primitive_begin(params.type);
	} break;
	
	case "primitive_end": {
		_vc.draw_primitive_end();
	} break;

	case "vertex": {
		_vc.draw_vertex(params.x, params.y);
	} break;

	case "vertex_color": {
		_vc.vertex_color(params.x, params.y, params.color, params.alpha);
	} break;

	case "scrolling_set_value": {
		_vc.scrolling_set_value(params.value);
	} break;

	case "scissor_begin": {
		_vc.scissor_begin(params.x, params.y, params.w, params.h);
	} break;

	case "scissor_isolated": {
		_vc.scissor_isolated(params.x, params.y, params.w, params.h);
	} break;

	case "scissor_end": {
		_vc.scissor_end();
	} break;
	
	// Draw Calls
	case "draw_text": {
		var old_color = draw_get_colour();
		var old_alpha = draw_get_alpha();
		draw_set_color(params.color);
		draw_set_alpha(params.alpha);
		if (params.font != undefined) {
			var old_font = draw_get_font();
			draw_set_font(params.font);
			gpu_set_colorwriteenable(true, true, true, false);
			_vc.draw_text(params.x, params.y, params.text, params.color, params.alpha, params.font);
			gpu_set_colorwriteenable(true, true, true, true);
			draw_set_font(old_font);
		}
		else {
			_vc.draw_text(params.x, params.y, params.text, params.color, params.alpha, params.font);
		};
		draw_set_colour(old_color);
		draw_set_alpha(old_alpha);
	} break;

	case "draw_rectangle": {
		var old_color = draw_get_colour();
		var old_alpha = draw_get_alpha();
		draw_set_color(params.color);
		draw_set_alpha(params.alpha);
		_vc.draw_rectangle(params.x1, params.y1, params.x2, params.y2, params.outline, params.color, params.alpha);
		draw_set_colour(old_color);
		draw_set_alpha(old_alpha);
	} break;

	case "draw_roundrect": {
		var old_color = draw_get_colour();
		var old_alpha = draw_get_alpha();
		draw_set_color(params.color);
	    draw_set_alpha(params.alpha);
	    _vc.draw_roundrect(params.x1, params.y1, params.x2, params.y2, params.outline, params.color, params.alpha, params.rounding);
		draw_set_colour(old_color);
		draw_set_alpha(old_alpha);
	} break;

	case "draw_line": {
		var old_color = draw_get_colour();
		var old_alpha = draw_get_alpha();
		draw_set_color(params.color);
		draw_set_alpha(params.alpha);
		_vc.draw_line(params.x1, params.y1, params.x2, params.y2, params.color, params.alpha);
		draw_set_colour(old_color);
		draw_set_alpha(old_alpha);
	} break;

	case "draw_line_width": {
		var old_color = draw_get_colour();
		var old_alpha = draw_get_alpha();
		draw_set_color(params.color);
		draw_set_alpha(params.alpha);
		_vc.draw_line_width(params.x1, params.y1, params.x2, params.y2, params.width, params.color, params.alpha);
		draw_set_colour(old_color);
		draw_set_alpha(old_alpha);
	} break;

	case "draw_circle": {
		var old_color = draw_get_colour();
		var old_alpha = draw_get_alpha();
		draw_set_color(params.color);
		draw_set_alpha(params.alpha);
		_vc.draw_circle(params.x, params.y, params.r, params.outline, params.color, params.alpha);
		draw_set_colour(old_color);
		draw_set_alpha(old_alpha);
	} break;

	case "draw_sprite": {
		var old_color = draw_get_colour();
		var old_alpha = draw_get_alpha();
		draw_set_color(params.color);
		draw_set_alpha(params.alpha);
		_vc.draw_sprite(params.sprite, params.subimg, params.x, params.y, params.color, params.alpha);
		draw_set_colour(old_color);
		draw_set_alpha(old_alpha);
	} break;

	case "draw_sprite_ext": {
		_vc.draw_sprite_ext(params.sprite, params.subimg, params.x, params.y, params.xscale, params.yscale, params.rot, params.color, params.alpha);
	} break;

	case "draw_surface": {
		var old_color = draw_get_colour();
		var old_alpha = draw_get_alpha();
		draw_set_color(params.color);
		draw_set_alpha(params.alpha);
		_vc.draw_surface(params.id, params.x, params.y, params.color, params.alpha);
		draw_set_colour(old_color);
		draw_set_alpha(old_alpha);
	} break;

	case "draw_surface_ext": {
		_vc.draw_surface_ext(params.id, params.x, params.y, params.xscale, params.yscale, params.rot, params.color, params.alpha);
	} break;
	
	case "draw_triangle": {
		var old_color = draw_get_colour();
		var old_alpha = draw_get_alpha();
	    draw_set_color(params.color);
	    draw_set_alpha(params.alpha);
		_vc.draw_triangle(params.x1, params.y1, params.x2, params.y2, params.x3, params.y3, params.color, params.alpha, params.outline);
		draw_set_colour(old_color);
		draw_set_alpha(old_alpha);
	} break;
	
	case "draw_shader_rect": {
	    _vc.draw_shader_rect(params.x1, params.y1, params.x2, params.y2, params.shader, params.uniforms);
	} break;
	
	case "draw_rect_expensive": {
		var old_color = draw_get_colour();
		var old_alpha = draw_get_alpha();
	    draw_set_color(params.color);
	    draw_set_alpha(params.alpha);
	    _vc.draw_rect_expensive(params.x1, params.y1, params.x2, params.y2, params.radius, params.direction, params.filled, params.segments);
		draw_set_colour(old_color);
		draw_set_alpha(old_alpha);
	} break;
	
	case "call_function": {
		_vc.call_function(params.func, params);
	} break;
	};
	
	if (variable_struct_exists(params, "x"))  { params.x  -= origin_x; };
	if (variable_struct_exists(params, "y"))  { params.y  -= origin_y; };
	if (variable_struct_exists(params, "x1")) { params.x1 -= origin_x; };
	if (variable_struct_exists(params, "y1")) { params.y1 -= origin_y; };
	if (variable_struct_exists(params, "x2")) { params.x2 -= origin_x; };
	if (variable_struct_exists(params, "y2")) { params.y2 -= origin_y; };
	if (variable_struct_exists(params, "x3")) { params.x3 -= origin_x; };
	if (variable_struct_exists(params, "y3")) { params.y3 -= origin_y; };
};

// Misc Calls
function gmui_add_font_set(font) {
	gmui_add_call("font_set", { font: font });
};

function gmui_add_halign_set(halign) {
	gmui_add_call("halign_set", { halign: halign });
};

function gmui_add_valign_set(valign) {
	gmui_add_call("valign_set", { valign: valign });
};

function gmui_add_primitive_type_set(type) {
	gmui_add_call("primitive_type_set", { type: type });
};

function gmui_add_call_function(func) {
    gmui_add_call("call_function", { func: func });
};

function gmui_add_primitive_end() {
	gmui_add_call("primitive_end", { });
};

function gmui_add_vertex(x, y) {
	gmui_add_call("vertex", { x: x, y: y });
};

function gmui_add_vertex_color(x, y, color, alpha = 1) {
	gmui_add_call("vertex_color", { x: x, y: y, color: color, alpha: alpha });
};

function gmui_add_scrolling_disable() {
	gmui_add_call("scrolling_set_value", { value: false });
};

function gmui_add_scrolling_enable() {
	gmui_add_call("scrolling_set_value", { value: true });
};

function gmui_add_scissor_begin(x, y = -1, w = -1, h = -1) {
	gmui_add_call("scissor_begin", { x: x, y: y, w: w, h: h });
};

function gmui_add_scissor_begin_isolated(x, y = -1, w = -1, h = -1) {
	gmui_add_call("scissor_isolated", { x: x, y: y, w: w, h: h });
};

function gmui_add_scissor_end() {
	gmui_add_call("scissor_end", { });
};

// Draw Calls
function gmui_add_text(text, x, y, color = c_white, alpha = 1, font = undefined) {
	gmui_add_call("draw_text", { x: x, y: y, text: text, color: color, alpha: alpha, font: font });
};

function gmui_add_rectangle(x1, y1, x2, y2, outline, color = c_white, alpha = 1) {
	gmui_add_call("draw_rectangle", { x1: x1, y1: y1, x2: x2, y2: y2, outline: outline, color: color, alpha: alpha });
};

function gmui_add_roundrect(x1, y1, x2, y2, outline, color = c_white, alpha = 1, rounding = -1) {
    gmui_add_call("draw_roundrect", { 
        x1: x1, y1: y1, x2: x2, y2: y2, 
        outline: outline, color: color, alpha: alpha, rounding: rounding 
    });
};

function gmui_add_line(x1, y1, x2, y2, color = c_white, alpha = 1) {
	gmui_add_call("draw_line", { x1: x1, y1: y1, x2: x2, y2: y2, color: color, alpha: alpha });
};

function gmui_add_line_width(x1, y1, x2, y2, width, color = c_white, alpha = 1) {
	gmui_add_call("draw_line_width", { x1: x1, y1: y1, x2: x2, y2: y2, width: width, color: color, alpha: alpha });
};

function gmui_add_circle(x, y, r, outline, color = c_white, alpha = 1) {
	gmui_add_call("draw_circle", { x: x, y: y, r: r, outline: outline, color: color, alpha: alpha });
};

function gmui_add_sprite(sprite, subimg, x, y, color = c_white, alpha = 1) {
	gmui_add_call("draw_sprite", { sprite: sprite, subimg: subimg, x: x, y: y, color: color, alpha: alpha });
};

function gmui_add_sprite_ext(sprite, subimg, x, y, xscale, yscale, rot, color, alpha) {
	gmui_add_call("draw_sprite_ext", { sprite: sprite, subimg: subimg, x: x, y: y, xscale: xscale, yscale: yscale, rot: rot, color: color, alpha: alpha });
};

function gmui_add_surface(id, x, y, color = c_white, alpha = 1) {
	gmui_add_call("draw_surface", { id: id, x: x, y: y, color: color, alpha: alpha });
};

function gmui_add_surface_ext(id, x, y, xscale, yscale, rot, color, alpha) {
	gmui_add_call("draw_surface_ext", { id: id, x: x, y: y, xscale: xscale, yscale: yscale, rot: rot, color: color, alpha: alpha });
};

function gmui_add_triangle(x1, y1, x2, y2, x3, y3, color = c_white, alpha = 1, outline = false) {
    gmui_add_call("draw_triangle", { x1: x1, y1: y1, x2: x2, y2: y2, x3: x3, y3: y3, color: color, alpha: alpha, outline: outline });
};

function gmui_add_shader_rect(x1, y1, x2, y2, shader, uniforms) {
    gmui_add_call("draw_shader_rect", {
        x1: x1, y1: y1, x2: x2, y2: y2,
        shader: shader,
        uniforms: uniforms
    });
};

function gmui_add_rect_expensive(x1, y1, x2, y2, color, direction, radius, filled = true, segments = -1, alpha = 1) {
    gmui_add_call("draw_rect_expensive", {
        x1: x1, y1: y1, x2: x2, y2: y2,
        color: color, alpha: alpha,
        direction: direction, radius: radius,
        filled: filled, segments: segments
    });
};