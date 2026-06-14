

// Misc
function gmui_calculate_text_size(text, font = undefined) {
	var size = undefined;
	if (font == undefined) {
		size = [ string_width(text), string_height(text) ];
	}
	else {
		var old_font = draw_get_font();
		draw_set_font(font);
		size = [ string_width(text), string_height(text) ];
		draw_set_font(old_font);
	};
	return size;
};

function gmui_resolve_font(widget, font) {
	var gmui = global.gmui;
    switch (widget.type) {
	case "text":					if (font == -5) { return gmui.style.font; } else if (font == undefined)	{ return gmui.style.font_text					?? gmui.style.font;	}	else { return font; };
	case "button":					if (font == -5) { return gmui.style.font; } else if (font == undefined)	{ return gmui.style.font_button					?? gmui.style.font;	}	else { return font; };
	case "checkbox":				if (font == -5) { return gmui.style.font; } else if (font == undefined)	{ return gmui.style.font_checkbox				?? gmui.style.font;	}	else { return font; };
	case "textbox":					if (font == -5) { return gmui.style.font; } else if (font == undefined)	{ return gmui.style.font_textbox				?? gmui.style.font;	}	else { return font; };
	case "collapsing_header":		if (font == -5) { return gmui.style.font; } else if (font == undefined)	{ return gmui.style.font_collapsing_header		?? gmui.style.font;	}	else { return font; };
	case "tab_item":				if (font == -5) { return gmui.style.font; } else if (font == undefined)	{ return gmui.style.font_tab_item				?? gmui.style.font;	}	else { return font; };
	case "selectable":				if (font == -5) { return gmui.style.font; } else if (font == undefined)	{ return gmui.style.font_selectable				?? gmui.style.font;	}	else { return font; };
	case "separator":				if (font == -5) { return gmui.style.font; } else if (font == undefined)	{ return gmui.style.font_separator				?? gmui.style.font;	}	else { return font; };
	case "label":					if (font == -5) { return gmui.style.font; } else if (font == undefined)	{ return gmui.style.font_label					?? gmui.style.font;	}	else { return font; };
	case "progress_bar":			if (font == -5) { return gmui.style.font; } else if (font == undefined)	{ return gmui.style.font_progress_bar			?? gmui.style.font;	}	else { return font; };
	case "progress_circular":		if (font == -5) { return gmui.style.font; } else if (font == undefined)	{ return gmui.style.font_progress_circular		?? gmui.style.font;	}	else { return font; };
	case "tooltip":					if (font == -5) { return gmui.style.font; } else if (font == undefined)	{ return gmui.style.font_tooltip				?? gmui.style.font;	}	else { return font; };
	case "image_button":			if (font == -5) { return gmui.style.font; } else if (font == undefined)	{ return gmui.style.font_image_button			?? gmui.style.font;	}	else { return font; };
	case "toggle":					if (font == -5) { return gmui.style.font; } else if (font == undefined)	{ return gmui.style.font_toggle					?? gmui.style.font;	}	else { return font; };
	case "radio":					if (font == -5) { return gmui.style.font; } else if (font == undefined)	{ return gmui.style.font_radio					?? gmui.style.font;	}	else { return font; };
	case "combo":					if (font == -5) { return gmui.style.font; } else if (font == undefined)	{ return gmui.style.font_combo					?? gmui.style.font;	}	else { return font; };
	case "list_box":				if (font == -5) { return gmui.style.font; } else if (font == undefined)	{ return gmui.style.font_list_box				?? gmui.style.font;	}	else { return font; };
	case "tree_node":				if (font == -5) { return gmui.style.font; } else if (font == undefined)	{ return gmui.style.font_tree					?? gmui.style.font;	}	else { return font; };
	case "tree_leaf":				if (font == -5) { return gmui.style.font; } else if (font == undefined)	{ return gmui.style.font_tree					?? gmui.style.font;	}	else { return font; };
	case "date_picker":				if (font == -5) { return gmui.style.font; } else if (font == undefined)	{ return gmui.style.font_date_picker			?? gmui.style.font;	}	else { return font; };
	case "color_picker":			if (font == -5) { return gmui.style.font; } else if (font == undefined)	{ return gmui.style.font_color_picker			?? gmui.style.font;	}	else { return font; };
	case "window_title":			if (font == -5) { return gmui.style.font; } else if (font == undefined)	{ return gmui.style.font_window_title			?? gmui.style.font;	}	else { return font; };
	case "context_menu":			if (font == -5) { return gmui.style.font; } else if (font == undefined)	{ return gmui.style.font_context_menu			?? gmui.style.font;	}	else { return font; };
	case "toast":					if (font == -5) { return gmui.style.font; } else if (font == undefined)	{ return gmui.style.font_toast					?? gmui.style.font;	}	else { return font; };
	case "drag_textbox":			if (font == -5) { return gmui.style.font; } else if (font == undefined)	{ return gmui.style.font_drag_textbox			?? gmui.style.font;	}	else { return font; };
	case "plot_lines":				if (font == -5) { return gmui.style.font; } else if (font == undefined)	{ return gmui.style.font_plot					?? gmui.style.font;	}	else { return font; };
	case "plot_bars":				if (font == -5) { return gmui.style.font; } else if (font == undefined)	{ return gmui.style.font_plot					?? gmui.style.font;	}	else { return font; };
	case "plot_histogram":			if (font == -5) { return gmui.style.font; } else if (font == undefined)	{ return gmui.style.font_plot					?? gmui.style.font;	}	else { return font; };
	case "plot_scatter":			if (font == -5) { return gmui.style.font; } else if (font == undefined)	{ return gmui.style.font_plot					?? gmui.style.font;	}	else { return font; };
	case "plot_stem":				if (font == -5) { return gmui.style.font; } else if (font == undefined)	{ return gmui.style.font_plot					?? gmui.style.font;	}	else { return font; };
	case "plot_stair":				if (font == -5) { return gmui.style.font; } else if (font == undefined)	{ return gmui.style.font_plot					?? gmui.style.font;	}	else { return font; };
	case "plot_area":				if (font == -5) { return gmui.style.font; } else if (font == undefined)	{ return gmui.style.font_plot					?? gmui.style.font;	}	else { return font; };
	case "plot_stacked_bars":		if (font == -5) { return gmui.style.font; } else if (font == undefined)	{ return gmui.style.font_plot					?? gmui.style.font;	}	else { return font; };
	case "plot_grouped_bars":		if (font == -5) { return gmui.style.font; } else if (font == undefined)	{ return gmui.style.font_plot					?? gmui.style.font;	}	else { return font; };
	case "plot_heatmap":			if (font == -5) { return gmui.style.font; } else if (font == undefined)	{ return gmui.style.font_plot					?? gmui.style.font;	}	else { return font; };
	case "plot_radar":				if (font == -5) { return gmui.style.font; } else if (font == undefined)	{ return gmui.style.font_plot					?? gmui.style.font;	}	else { return font; };
	case "plot_box":				if (font == -5) { return gmui.style.font; } else if (font == undefined)	{ return gmui.style.font_plot					?? gmui.style.font;	}	else { return font; };
	case "plot_funnel":				if (font == -5) { return gmui.style.font; } else if (font == undefined)	{ return gmui.style.font_plot					?? gmui.style.font;	}	else { return font; };
	case "plot_waterfall":			if (font == -5) { return gmui.style.font; } else if (font == undefined)	{ return gmui.style.font_plot					?? gmui.style.font;	}	else { return font; };
	case "plot_bubble":				if (font == -5) { return gmui.style.font; } else if (font == undefined)	{ return gmui.style.font_plot					?? gmui.style.font;	}	else { return font; };
	case "plot_gantt":				if (font == -5) { return gmui.style.font; } else if (font == undefined)	{ return gmui.style.font_plot					?? gmui.style.font;	}	else { return font; };
	case "plot_error_bars":			if (font == -5) { return gmui.style.font; } else if (font == undefined)	{ return gmui.style.font_plot					?? gmui.style.font;	}	else { return font; };
	case "plot_gauge":				if (font == -5) { return gmui.style.font; } else if (font == undefined)	{ return gmui.style.font_plot					?? gmui.style.font;	}	else { return font; };
	case "plot_table":				if (font == -5) { return gmui.style.font; } else if (font == undefined)	{ return gmui.style.font_plot					?? gmui.style.font;	}	else { return font; };
	case "knob":					if (font == -5) { return gmui.style.font; } else if (font == undefined)	{ return gmui.style.font_knob					?? gmui.style.font;	}	else { return font; };
	case "multiselect":				if (font == -5) { return gmui.style.font; } else if (font == undefined)	{ return gmui.style.font_multiselect			?? gmui.style.font;	}	else { return font; };
	case "kv_list":					if (font == -5) { return gmui.style.font; } else if (font == undefined)	{ return gmui.style.font_kv_list				?? gmui.style.font;	}	else { return font; };
	default:						return -1;
	};
};

function gmui_begin_scissor(x, y, w, h) {
	var gmui = global.gmui;
	
	var previous_scissor = ds_stack_top(gmui.scissor_stack) ?? {
		x: 0,
		y: 0,
		w: surface_get_width(application_surface),
		h: surface_get_height(application_surface)
	};
	
	var prev_right = previous_scissor.x + previous_scissor.w;
	var prev_bottom = previous_scissor.y + previous_scissor.h;
	
	var curr_right = x + w;
	var curr_bottom = y + h;
	
	var final_x = max(x, previous_scissor.x);
	var final_y = max(y, previous_scissor.y);
	var final_right = min(curr_right, prev_right);
	var final_bottom = min(curr_bottom, prev_bottom);
	
	var final_w = max(0, final_right - final_x);
	var final_h = max(0, final_bottom - final_y);
	
	var final_scissor = {
		x: final_x,
		y: final_y,
		w: final_w,
		h: final_h
	};
	
	ds_stack_push(gmui.scissor_stack, final_scissor);
	
	gpu_set_scissor(
		final_scissor.x,
		final_scissor.y,
		final_scissor.w,
		final_scissor.h
	);
}

function gmui_push_scissor_isolated(x, y, w, h) {
    var gmui = global.gmui;
    
    var final_scissor = { x: x, y: y, w: w, h: h };
    ds_stack_push(gmui.scissor_stack, final_scissor);
    
    gpu_set_scissor(x, y, w, h);
}

function gmui_end_scissor() {
	var gmui = global.gmui;
	
	ds_stack_pop(gmui.scissor_stack);
	
	var current_scissor = ds_stack_top(gmui.scissor_stack);
	
	if (current_scissor == undefined) {
		gpu_set_scissor(
			0,
			0,
			surface_get_width(application_surface),
			surface_get_height(application_surface)
		);
		return;
	}
	
	gpu_set_scissor(
		current_scissor.x,
		current_scissor.y,
		current_scissor.w,
		current_scissor.h
	);
}

function _gmui_textbox_get_cursor_pos(_text, _click_x) {
    if (_click_x <= 0) return 0;
    var len = string_length(_text);
    if (len == 0) return 0;
    
    var total_w = string_width(_text);
    if (_click_x >= total_w) return len;
    
    var low = 0;
    var high = len;
    while (low < high) {
        var mid = (low + high + 1) div 2;
        var w = string_width(string_copy(_text, 1, mid));
        if (w <= _click_x) {
            low = mid;
        } else {
            high = mid - 1;
        }
    }
    return low;
};

function _gmui_lerp_color(c1, c2, t) {
    t = clamp(t, 0, 1);
    var r = lerp(color_get_red(c1), color_get_red(c2), t);
    var g = lerp(color_get_green(c1), color_get_green(c2), t);
    var b = lerp(color_get_blue(c1), color_get_blue(c2), t);
    return make_color_rgb(r, g, b);
};

function _gmui_draw_pie_slice(cx, cy, inner_radius, outer_radius, start_angle, end_angle, color) {
	var q = 48; //16;
    var segments = max(3, floor(abs(end_angle - start_angle) * q / (2 * pi)));
    var angle_step = (end_angle - start_angle) / segments;
    
    for (var i = 0; i < segments; i++) {
        var a1 = start_angle + i * angle_step;
        var a2 = start_angle + (i + 1) * angle_step;
        
        var x1 = cx + cos(a1) * outer_radius;
        var y1 = cy - sin(a1) * outer_radius;
        var x2 = cx + cos(a2) * outer_radius;
        var y2 = cy - sin(a2) * outer_radius;
        
        if (inner_radius > 0) {
            var x3 = cx + cos(a2) * inner_radius;
            var y3 = cy - sin(a2) * inner_radius;
            var x4 = cx + cos(a1) * inner_radius;
            var y4 = cy - sin(a1) * inner_radius;
            
            gmui_add_triangle(x1, y1, x2, y2, x3, y3, color);
            gmui_add_triangle(x1, y1, x3, y3, x4, y4, color);
        } else {
            gmui_add_triangle(cx, cy, x1, y1, x2, y2, color);
        }
    }
};

function _gmui_draw_arc(cx, cy, inner_radius, outer_radius, start_angle, end_angle, color, segments) {
    var angle_step = (end_angle - start_angle) / segments;
    
    for (var i = 0; i < segments; i++) {
        var a1 = start_angle + i * angle_step;
        var a2 = start_angle + (i + 1) * angle_step;
        
        var x1 = cx + cos(a1) * outer_radius;
        var y1 = cy - sin(a1) * outer_radius;
        var x2 = cx + cos(a2) * outer_radius;
        var y2 = cy - sin(a2) * outer_radius;
        var x3 = cx + cos(a2) * inner_radius;
        var y3 = cy - sin(a2) * inner_radius;
        var x4 = cx + cos(a1) * inner_radius;
        var y4 = cy - sin(a1) * inner_radius;
        
        gmui_add_triangle(x1, y1, x2, y2, x3, y3, color);
        gmui_add_triangle(x1, y1, x3, y3, x4, y4, color);
    }
};

function _gmui_array_sort_ascending(arr) {
    array_sort(arr, function(a, b) { return a - b; });
};

function _gmui_quartiles(values) {
    var count = array_length(values);
    if (count == 0) return [0, 0, 0, 0, 0];
    
    var sorted = [];
    for (var i = 0; i < count; i++) array_push(sorted, values[i]);
    _gmui_array_sort_ascending(sorted);
    
    var min_val = sorted[0];
    var max_val = sorted[count - 1];
    
    var _median = count % 2 == 0 ? (sorted[count div 2 - 1] + sorted[count div 2]) / 2 : sorted[count div 2];
    
    var half = count div 2;
    var q1 = half % 2 == 0 ? (sorted[half div 2 - 1] + sorted[half div 2]) / 2 : sorted[half div 2];
    var q3 = half % 2 == 0 ? (sorted[count - half div 2 - 1] + sorted[count - half div 2]) / 2 : sorted[count - half div 2 - 1];
    
    var iqr = q3 - q1;
    var whisker_low = q1 - 1.5 * iqr;
    var whisker_high = q3 + 1.5 * iqr;
    
    var actual_low = max_val;
    var actual_high = min_val;
    var outliers = [];
    
    for (var i = 0; i < count; i++) {
        if (sorted[i] >= whisker_low && sorted[i] < actual_low) actual_low = sorted[i];
        if (sorted[i] <= whisker_high && sorted[i] > actual_high) actual_high = sorted[i];
        if (sorted[i] < whisker_low || sorted[i] > whisker_high) {
            array_push(outliers, sorted[i]);
        }
    }
    
    if (actual_low > q1) actual_low = q1;
    if (actual_high < q3) actual_high = q3;
    
    return [actual_low, q1, _median, q3, actual_high, outliers];
};

function gmui_hsv_to_rgb(h, s, v) {
    h = frac(h) * 6;
    var i = floor(h);
    var f = h - i;
    var p = v * (1 - s);
    var q = v * (1 - s * f);
    var t = v * (1 - s * (1 - f));
    
    var r, g, b;
    switch (i) {
        case 0: r = v; g = t; b = p; break;
        case 1: r = q; g = v; b = p; break;
        case 2: r = p; g = v; b = t; break;
        case 3: r = p; g = q; b = v; break;
        case 4: r = t; g = p; b = v; break;
        default: r = v; g = p; b = q; break;
    }
    
    return [clamp(r * 255, 0, 255), clamp(g * 255, 0, 255), clamp(b * 255, 0, 255)];
};

function gmui_rgb_to_hsv(r, g, b) {
    var rf = r / 255, gf = g / 255, bf = b / 255;
    var maxc = max(rf, max(gf, bf));
    var minc = min(rf, min(gf, bf));
    var delta = maxc - minc;
    
    var h = 0, s = 0, v = maxc;
    
    if (delta != 0) {
        s = delta / maxc;
        if (maxc == rf) h = ((gf - bf) / delta) % 6;
        else if (maxc == gf) h = ((bf - rf) / delta) + 2;
        else h = ((rf - gf) / delta) + 4;
        h /= 6;
        if (h < 0) h += 1;
    }
    
    return [h, s, v];
};

function gmui_make_color_rgba(r, g, b, a) {
    r = clamp(r, 0, 255);
    g = clamp(g, 0, 255);
    b = clamp(b, 0, 255);
    a = clamp(a, 0, 255);
    
    return (r) | (g << 8) | (b << 16) | (a << 24);
}

function gmui_color_rgba_get_red(color) {
    return color & 255;
}

function gmui_color_rgba_get_green(color) {
    return (color >> 8) & 255;
}

function gmui_color_rgba_get_blue(color) {
    return (color >> 16) & 255;
}

function gmui_color_rgba_get_alpha(color) {
    return (color >> 24) & 255;
}

function gmui_color_rgb_to_rgba(color, alpha = 255) {
    return gmui_make_color_rgba(
        color_get_red(color),
        color_get_green(color),
        color_get_blue(color),
        alpha
    );
}

function gmui_color_rgba_to_rgb(color) {
    return make_color_rgb(
        gmui_color_rgba_get_red(color),
        gmui_color_rgba_get_green(color),
        gmui_color_rgba_get_blue(color)
    );
}

function gmui_color_rgba_to_array(color) {
    return [
        gmui_color_rgba_get_red(color),
        gmui_color_rgba_get_green(color),
        gmui_color_rgba_get_blue(color),
        gmui_color_rgba_get_alpha(color)
    ];
}

function gmui_color_rgb_to_array(color) {
    return [
        color_get_red(color),
        color_get_green(color),
        color_get_blue(color)
    ];
}

function gmui_color_rgba_from_array(arr) {
    return gmui_make_color_rgba(arr[0], arr[1], arr[2], arr[3]);
}

function gmui_color_lighten(color, factor) {
    var r = clamp(gmui_color_rgba_get_red(color) * factor, 0, 255);
    var g = clamp(gmui_color_rgba_get_green(color) * factor, 0, 255);
    var b = clamp(gmui_color_rgba_get_blue(color) * factor, 0, 255);
    var a = gmui_color_rgba_get_alpha(color);
    return gmui_make_color_rgba(r, g, b, a);
};

function gmui_color_darken(color, factor) {
    return gmui_color_lighten(color, factor);
};

function gmui_color_lerp(color1, color2, t) {
    t = clamp(t, 0, 1);
    var a1 = gmui_color_rgba_to_array(color1);
    var a2 = gmui_color_rgba_to_array(color2);
    return gmui_make_color_rgba(
        lerp(a1[0], a2[0], t),
        lerp(a1[1], a2[1], t),
        lerp(a1[2], a2[2], t),
        lerp(a1[3], a2[3], t)
    );
};

function gmui_color_set_alpha(color, alpha) {
    return (clamp(alpha, 0, 255) << 24) | (color & 0xFFFFFF);
};

function gmui_color_get_alpha_rgb(color) {
    return 255;
};

function _gmui_lerp_color_gradient(gradient, t) {
    t = clamp(t, 0, 1);
    var stops = array_length(gradient);
    if (stops == 1) return gradient[0];
    
    var segment = t * (stops - 1);
    var index = floor(segment);
    var _frac = segment - index;
    
    if (index >= stops - 1) return gradient[stops - 1];
    
    return _gmui_lerp_color(gradient[index], gradient[index + 1], _frac);
};

// directional rounded rectangle
function _gmui_draw_rounded_rectangle_directional(x1, y1, x2, y2, radius, direction, filled, segments) {
    var _x1 = min(x1, x2);
    var _y1 = min(y1, y2);
    var _x2 = max(x1, x2);
    var _y2 = max(y1, y2);
    
    var w = _x2 - _x1;
    var h = _y2 - _y1;
    var r = min(radius, w * 0.5);
    r = min(r, h * 0.5);
    
    var tl = (direction & 1) != 0;  // TOP_LEFT
    var tr = (direction & 2) != 0;  // TOP_RIGHT
    var br = (direction & 4) != 0;  // BOTTOM_RIGHT
    var bl = (direction & 8) != 0;  // BOTTOM_LEFT
    
    var seg = segments;
    if (seg <= 0) seg = max(8, ceil(r / 2));
    
    if (filled) {
        draw_rectangle(_x1 + (tl || bl ? r : 0), _y1 + (tl || tr ? r : 0), _x2 - (tr || br ? r : 0), _y2 - (bl || br ? r : 0), false);
        
        draw_rectangle(_x1 + (tl ? r : 0), _y1, _x2 - (tr ? r : 0), _y1 + r, false); // top
        draw_rectangle(_x1 + (bl ? r : 0), _y2 - r, _x2 - (br ? r : 0), _y2, false); // bottom
        draw_rectangle(_x1, _y1 + (tl ? r : 0), _x1 + r, _y2 - (bl ? r : 0), false); // left
        draw_rectangle(_x2 - r, _y1 + (tr ? r : 0), _x2, _y2 - (br ? r : 0), false); // right
        
        var step = 90 / seg;
        if (tl) {
            draw_primitive_begin(pr_trianglefan);
            draw_vertex(_x1 + r, _y1 + r);
            for (var a = 180; a <= 270; a += step) {
                var rad = degtorad(a);
                draw_vertex(_x1 + r + cos(rad) * r, _y1 + r + sin(rad) * r);
            }
            draw_primitive_end();
        }
        if (tr) {
            draw_primitive_begin(pr_trianglefan);
            draw_vertex(_x2 - r, _y1 + r);
            for (var a = 270; a <= 360; a += step) {
                var rad = degtorad(a);
                draw_vertex(_x2 - r + cos(rad) * r, _y1 + r + sin(rad) * r);
            }
            draw_primitive_end();
        }
        if (br) {
            draw_primitive_begin(pr_trianglefan);
            draw_vertex(_x2 - r, _y2 - r);
            for (var a = 0; a <= 90; a += step) {
                var rad = degtorad(a);
                draw_vertex(_x2 - r + cos(rad) * r, _y2 - r + sin(rad) * r);
            }
            draw_primitive_end();
        }
        if (bl) {
            draw_primitive_begin(pr_trianglefan);
            draw_vertex(_x1 + r, _y2 - r);
            for (var a = 90; a <= 180; a += step) {
                var rad = degtorad(a);
                draw_vertex(_x1 + r + cos(rad) * r, _y2 - r + sin(rad) * r);
            }
            draw_primitive_end();
        }
        return;
    }
    
    draw_primitive_begin(pr_linestrip);
    if (tl) {
        draw_vertex(_x1 + r, _y1);
        for (var a = 180; a <= 270; a += 90 / seg) {
            var rad = degtorad(a);
            draw_vertex(_x1 + r + cos(rad) * r, _y1 + r + sin(rad) * r);
        }
    } else {
        draw_vertex(_x1, _y1);
    }
    
    if (tr) {
        draw_vertex(_x2 - r, _y1);
        for (var a = 270; a <= 360; a += 90 / seg) {
            var rad = degtorad(a);
            draw_vertex(_x2 - r + cos(rad) * r, _y1 + r + sin(rad) * r);
        }
    } else {
        draw_vertex(_x2, _y1);
    }
    
    if (br) {
        draw_vertex(_x2, _y2 - r);
        for (var a = 0; a <= 90; a += 90 / seg) {
            var rad = degtorad(a);
            draw_vertex(_x2 - r + cos(rad) * r, _y2 - r + sin(rad) * r);
        }
    } else {
        draw_vertex(_x2, _y2);
    }
    
    if (bl) {
        draw_vertex(_x1 + r, _y2);
        for (var a = 90; a <= 180; a += 90 / seg) {
            var rad = degtorad(a);
            draw_vertex(_x1 + r + cos(rad) * r, _y2 - r + sin(rad) * r);
        }
    } else {
        draw_vertex(_x1, _y2);
    }
    
    draw_vertex(_x1, _y1 + (tl ? r : 0));
    draw_primitive_end();
};

function _gmui_format_float(val, dec = 4) {
    var text = string_format(val, 1, dec);
    while (string_length(text) > 1 && string_char_at(text, string_length(text)) == "0" && string_pos(".", text) > 0) {
        text = string_copy(text, 1, string_length(text) - 1);
    }
    if (string_char_at(text, string_length(text)) == ".") text = string_copy(text, 1, string_length(text) - 1);
    return text;
};

function gmui_get_available_width() {
    var gmui = global.gmui;
    var style = gmui.style;
	var container = gmui.current_container;
	
	if (container == undefined) { return -1; }
	
	return container.width - style.container_padding_h * 2 - container.context.indent_level - (container.context.new_line_requested ? 0 : container.context.cursor_x - style.element_spacing_h);
};

function gmui_default_background_draw_call(container, x1, y1, x2, y2) {
	var gmui = global.gmui;
	var style = gmui.style;
	
	var old_bg_color = draw_get_colour();
	draw_set_color(style.container_background_color);
	draw_roundrect_ext(x1, y1, x2, y2, style.container_rounding, style.container_rounding, false);
	draw_set_color(style.container_outline_color);
	draw_roundrect_ext(x1 + 1, y1 + 1, x2, y2, style.container_rounding, style.container_rounding, true);
	draw_set_color(old_bg_color);
};

function gmui_default_mask_draw_call(container, x1, y1, x2, y2) {
	var gmui = global.gmui;
	var style = gmui.style;
	
	var old_bg_color = draw_get_colour();
	var old_blend = gpu_get_blendmode();
	
	gpu_set_blendmode(bm_reverse_subtract);
	draw_set_color(c_white);
	draw_rectangle(x1, y1, x2, y2, false);
	draw_set_color(c_black);
	draw_roundrect_ext(x1, y1, x2, y2, style.container_rounding, style.container_rounding, false);
	draw_set_color(old_bg_color);
	gpu_set_blendmode(old_blend);
};

function _gmui_array_sum(arr, count) {
    var sum = 0;
    for (var i = 0; i < count; i++) sum += arr[i];
    return sum;
}

function gmui_get_layer_data(layer_enum) {
    var layers = global.gmui.z_layers;
    switch (layer_enum) {
        case 0: return layers.background;
        case 1: return layers.normal;
        case 2: return layers.modal_bg;
        case 3: return layers.popup;
    }
    return undefined;
};

function gmui_is_container_or_parent(container, hovered_container) {
    var current = hovered_container;
    while (current != undefined) {
        if (current == container) return true;
        current = current.parent;
    }
    return false;
}

function gmui_cursor_set(x, y) {
	if (global.gmui.current_container == undefined) { return; };
	global.gmui.current_container.context.cursor_x = x;
	global.gmui.current_container.context.cursor_y = y;
};

function gmui_cursor_set_x(x) {
	if (global.gmui.current_container == undefined) { return; };
	global.gmui.current_container.context.cursor_x = x;
};

function gmui_cursor_set_y(y) {
	if (global.gmui.current_container == undefined) { return; };
	global.gmui.current_container.context.cursor_y = y;
};

function gmui_cursor_get() {
	if (global.gmui.current_container == undefined) { return; };
	return {
		x: global.gmui.current_container.context.cursor_x,
		y: global.gmui.current_container.context.cursor_y,
	};
};

function gmui_cursor_get_x() {
	if (global.gmui.current_container == undefined) { return; };
	return global.gmui.current_container.context.cursor_x;
};

function gmui_cursor_get_y() {
	if (global.gmui.current_container == undefined) { return; };
	return global.gmui.current_container.context.cursor_y;
};

function gmui_if(condition, func) {
    if (condition) {
        func();
    }
};

function gmui_if_else(condition, if_func, else_func) {
    if (condition) {
        if_func();
    } else {
        else_func();
    }
};

function gmui_debug_window(name, x, y, width, height, func) {
    if (gmui_begin_window(name, x, y, width, height)) {
        func();
        gmui_end_window();
        return true;
    }
    return false;
};

function gmui_debug_text(value, label = "", font = undefined) {
    if (label != "") {
        gmui_text_label(label, string(value), font);
    } else {
        gmui_text(string(value), font);
    }
};

function gmui_debug_separator(font = undefined) {
    gmui_separator();
    gmui_text("--- DEBUG ---", font);
    gmui_separator();
};

function gmui_debug_separator1() {
	gmui_separator_text("--- DEBUG ---", font);
};

function gmui_cursor_get_line_height() {
    return global.gmui.current_container.context.line_height;
}

function gmui_cursor_set_line_height(height) {
    global.gmui.current_container.context.line_height = height;
}

function gmui_is_widget_hovering_at(widget, x, y) {
	return point_in_rectangle(x, y, widget.screen_x, widget.screen_y, widget.screen_x + widget.width, widget.screen_y + widget.height) && array_contains(global.gmui.input.hovered_container_array, widget.container);
};