

// WINDOW
function gmui_window_get(name) {
	var window = gmui_container_get(name, undefined);
	if (!window.initialized) {
		window.scrolling_enabled = false;
		window.use_scissor = false;
		window.use_surface = true;
		window.mask_enabled = true;
		window.z_interaction_enabled = true;
		window.title_handler = gmui_default_window_title_handler;
		window.border_handler = gmui_default_window_border_handler;
		window.z_interaction_enabled = true;
		window.content_container = gmui_container_get(name + "_content_container", window);
	};
	//window.background_draw_func = gmui_default_window_background_draw_call;
	return window;
};

function gmui_begin_window(name, x = -1, y = -1, width = -1, height = -1, flags = 0) {
	var gmui = global.gmui;
	var style = gmui.style;
	var input = gmui.input;
	
	// flags
	var has_title = (flags & gmui_window_flags.NO_TITLE_BAR) == 0;
	var has_close = (flags & gmui_window_flags.NO_CLOSE) == 0;
	var has_collapse = (flags & gmui_window_flags.NO_COLLAPSE) == 0;
	var can_move_with_mouse = (flags & gmui_window_flags.NO_MOVE_WITH_MOUSE) == 0;
	var has_scroll = (flags & gmui_window_flags.NO_SCROLL) == 0;
	var has_border = (flags & gmui_window_flags.NO_BORDERS) == 0;
	var has_border_resize = (flags & gmui_window_flags.NO_BORDER_RESIZE) == 0;
	var has_auto_resize_horizontal = (flags & gmui_window_flags.AUTO_RESIZE_HORIZONTAL) != 0;
	var has_auto_resize_vertical = (flags & gmui_window_flags.AUTO_RESIZE_VERTICAL) != 0;
	
	// calculate window pos and size
	var window = gmui_window_get(name);
	var wx = window.x;
	var wy = window.y;
	var ww = window.width;
	var wh = window.height;
	if (!window.initialized) {
		wx = x < 0 ? 0 : x;
		wy = y < 0 ? 0 : y;
		ww = max(width, style.window_min_width);
		wh = max(height, style.window_min_height);
		gmui_container_bring_to_front(window.name);
	};
	
	if (!window.is_enabled) { return false; };
	
	// start window
	if (!gmui_begin_container_plain(name, wx, wy, ww, wh)) { return false; };
	window = gmui.current_container;
	window.flags = flags;
	
	// window interaction
	var window_hovering = array_contains(input.hovered_container_array, window);
	if (!variable_struct_exists(window, "is_title_dragging")) { variable_struct_set(window, "is_title_dragging", false); };
	if (!variable_struct_exists(window, "_win_collapsed")) { variable_struct_set(window, "_win_collapsed", false); };
	if (!variable_struct_exists(window, "height_before_collapse")) { variable_struct_set(window, "height_before_collapse", 64); };
	if (!variable_struct_exists(window, "last_clicked_pos")) { variable_struct_set(window, "last_clicked_pos", [ -1, -1 ]); };
	if (!variable_struct_exists(window, "is_border_left_dragging")) { variable_struct_set(window, "is_border_left_dragging", false); };
	if (!variable_struct_exists(window, "is_border_right_dragging")) { variable_struct_set(window, "is_border_right_dragging", false); };
	if (!variable_struct_exists(window, "is_border_top_dragging")) { variable_struct_set(window, "is_border_top_dragging", false); };
	if (!variable_struct_exists(window, "is_border_bottom_dragging")) { variable_struct_set(window, "is_border_bottom_dragging", false); };
	
	if (window_hovering && input.m_pressed) { window.last_clicked_pos = [ input.m_x, input.m_y ]; };
	
	// background
	//gmui_add_rectangle(0, 0, window.width, window.height, false, style.window_title_color_idle, 1);
	
	// title bar
	window.title_handler(window);
	
	// border
	window.border_handler(window);
	
	// update inputs
	if (window.is_title_dragging) {
		window.x = input.m_x - window.dragging_diff_pos[0];
		window.y = input.m_y - window.dragging_diff_pos[1];
	}
	
	// window content container
	var window_border_width = has_border ? style.window_border_width : 0;
	window.context.cursor_x = window_border_width;
	window.context.cursor_y = has_title ? style.window_title_height : window_border_width;
	if (!gmui_begin_container(name + "_content_container", undefined, undefined, ww - window_border_width * 2, wh - (has_title ? style.window_title_height + window_border_width : window_border_width * 2))) { gmui_end_container_plain(); return false; };
	window.content_container = gmui.current_container;
	var content_container = window.content_container;
	content_container.use_scissor = true;
	content_container.scrolling_enabled = has_scroll;
	gmui.current_container = content_container;
	
	if (!window._win_collapsed) {
		return true;
	}
	else {
		gmui_end_window();
		return false;
	}
	
};

function gmui_end_window() {
	var gmui = global.gmui;
	var style = gmui.style;
	
	var container = gmui.current_container;
	var window = container.parent;
	var flags = window.flags;
	
	var has_title = (flags & gmui_window_flags.NO_TITLE_BAR) == 0;
	var has_border = (flags & gmui_window_flags.NO_BORDERS) == 0;
	var has_auto_resize_horizontal = (flags & gmui_window_flags.AUTO_RESIZE_HORIZONTAL) != 0;
	var has_auto_resize_vertical = (flags & gmui_window_flags.AUTO_RESIZE_VERTICAL) != 0;
	
	gmui_end_container();
	
	gmui_end_container_plain();
	
	if (has_auto_resize_horizontal) { 
	    var new_width = window.content_container.content_width;
	    if (has_border) new_width += style.window_border_width * 2;
	    gmui_container_set_width(window.name, new_width);
	};
	
	if (has_auto_resize_vertical) {
	    var new_height = window.content_container.content_height;
	    if (has_title) new_height += style.window_title_height;
	    if (has_border) new_height += style.window_border_width * 2;
	    gmui_container_set_height(window.name, new_height);
	};
};

function gmui_default_window_border_handler(window) {
	var gmui = global.gmui;
	var style = gmui.style;
	var input = gmui.input;
	
	var wx = window.x;
	var wy = window.y;
	var ww = window.width;
	var wh = window.height;
	var flags = window.flags;
	
	// flags
	var has_title = (flags & gmui_window_flags.NO_TITLE_BAR) == 0;
	var has_close = (flags & gmui_window_flags.NO_CLOSE) == 0;
	var has_collapse = (flags & gmui_window_flags.NO_COLLAPSE) == 0;
	var can_move_with_mouse = (flags & gmui_window_flags.NO_MOVE_WITH_MOUSE) == 0;
	var has_scroll = (flags & gmui_window_flags.NO_SCROLL) == 0;
	var has_border = (flags & gmui_window_flags.NO_BORDERS) == 0;
	var has_border_resize = (flags & gmui_window_flags.NO_BORDER_RESIZE) == 0;
	var has_auto_resize_horizontal = (flags & gmui_window_flags.AUTO_RESIZE_HORIZONTAL) != 0;
	var has_auto_resize_vertical = (flags & gmui_window_flags.AUTO_RESIZE_VERTICAL) != 0;
	
	var can_resize_horizontal = has_border && !has_auto_resize_horizontal;
	var can_resize_vertical = has_border && !has_auto_resize_vertical;
	
	// window interaction
	var window_hovering = array_contains(input.hovered_container_array, window);
	
	// borders
	if (has_border) {
		var border_width = style.window_border_width;
		gmui_add_rectangle(0, has_title ? style.window_title_height : border_width, border_width, window.height - border_width, false, style.window_title_color_idle);
		gmui_add_rectangle(window.width - border_width, has_title ? style.window_title_height : border_width, window.width, window.height - border_width, false, style.window_title_color_idle);
		gmui_add_rectangle(0, window.height - border_width, window.width, window.height, false, style.window_title_color_idle);
		if (!has_title) {
			gmui_add_rectangle(0, 0, window.width, border_width, false, style.window_title_color_idle);
		}
	}
	
	if (has_border && has_border_resize && !window._win_collapsed && input.active_widget_id == undefined && window.is_title_dragging == false) {
		var diff = 0;
		
		if (can_resize_horizontal) {
			var border_left_hovering = window_hovering && point_in_rectangle(input.m_x, input.m_y, 0, 0, wx + 4, wy + wh);
			var border_left_pressed = border_left_hovering && input.m_pressed; if (border_left_pressed) { window.is_border_left_dragging = true; window.dragging_diff_pos = [ input.m_x, input.m_y ]; };
			var border_left_holding = window.is_border_left_dragging;
			if (input.m_released) { window.is_border_left_dragging = false; };
			if (border_left_hovering || border_left_holding) {
				gmui_add_line(1, 0, 1, wh, border_left_holding ? style.color_accent_pressed : style.color_accent_hover, 1);
			}
			if (border_left_holding) {
				diff = input.m_x - window.dragging_diff_pos[0];
				var new_width = ww - diff;
				var new_pos = wx + diff;
				window.dragging_diff_pos = [ input.m_x, input.m_y ];
				gmui_container_set_pos(window.name, new_pos, wy, window.parent);
				gmui_container_set_size(window.name, new_width, wh, window.parent);
			}
		
			var border_right_hovering = window_hovering && point_in_rectangle(input.m_x, input.m_y, wx + ww - 4, wy, wx + ww, wy + wh);
			var border_right_pressed = border_right_hovering && input.m_pressed; if (border_right_pressed) { window.is_border_right_dragging = true; window.dragging_diff_pos = [ input.m_x, input.m_y ]; };
			var border_right_holding = window.is_border_right_dragging;
			if (input.m_released) { window.is_border_right_dragging = false; };
			if (border_right_hovering || border_right_holding) {
			    gmui_add_line(ww, 0, ww, wh, border_right_holding ? style.color_accent_pressed : style.color_accent_hover, 1);
			}
			if (border_right_holding) {
			    diff = input.m_x - window.dragging_diff_pos[0];
			    var new_width = ww + diff;
			    window.dragging_diff_pos = [ input.m_x, input.m_y ];
				show_debug_message($"resizing window: {window.name} into {new_width} from {window.width}");
			    gmui_container_set_size(window.name, new_width, wh, window.parent);
			}
		
			if (border_left_holding || border_right_holding) {
			    var new_width = ww + (border_left_holding ? -diff : diff);
			    new_width = max(style.window_min_width, new_width);
			    if (border_left_holding) {
			        var new_pos = wx + (ww - new_width);
			        gmui_container_set_pos(window.name, new_pos, wy, window.parent);
			    }
			    gmui_container_set_size(window.name, new_width, wh, window.parent);
			}
		}
		
		if (can_resize_vertical) {
			var border_top_hovering = window_hovering && point_in_rectangle(input.m_x, input.m_y, wx, wy, wx + ww, wy + 4);
			var border_top_pressed = border_top_hovering && input.m_pressed; if (border_top_pressed) { window.is_border_top_dragging = true; window.dragging_diff_pos = [ input.m_x, input.m_y ]; };
			var border_top_holding = window.is_border_top_dragging;
			if (input.m_released) { window.is_border_top_dragging = false; };
			if (border_top_hovering || border_top_holding) {
			    gmui_add_line(0, 1, ww, 1, border_top_holding ? style.color_accent_pressed : style.color_accent_hover, 1);
			}
			if (border_top_holding) {
			    diff = input.m_y - window.dragging_diff_pos[1];
			    var new_height = wh - diff;
			    var new_y = wy + diff;
			    window.dragging_diff_pos = [ input.m_x, input.m_y ];
			    gmui_container_set_pos(window.name, wx, new_y, window.parent);
			    gmui_container_set_size(window.name, ww, new_height, window.parent);
			}

			var border_bottom_hovering = window_hovering && point_in_rectangle(input.m_x, input.m_y, wx, wy + wh - 4, wx + ww, wy + wh);
			var border_bottom_pressed = border_bottom_hovering && input.m_pressed; if (border_bottom_pressed) { window.is_border_bottom_dragging = true; window.dragging_diff_pos = [ input.m_x, input.m_y ]; };
			var border_bottom_holding = window.is_border_bottom_dragging;
			if (input.m_released) { window.is_border_bottom_dragging = false; };
			if (border_bottom_hovering || border_bottom_holding) {
			    gmui_add_line(0, wh, ww, wh, border_bottom_holding ? style.color_accent_pressed : style.color_accent_hover, 1);
			}
			if (border_bottom_holding) {
			    diff = input.m_y - window.dragging_diff_pos[1];
			    var new_height = wh + diff;
			    window.dragging_diff_pos = [ input.m_x, input.m_y ];
			    gmui_container_set_size(window.name, ww, new_height, window.parent);
			}

			if (border_top_holding || border_bottom_holding) {
			    var new_height = wh + (border_top_holding ? -diff : diff);
			    new_height = max(style.window_min_height, new_height);
			    if (border_top_holding) {
			        var new_y = wy + (wh - new_height);
			        gmui_container_set_pos(window.name, wx, new_y, window.parent);
			    }
			    gmui_container_set_size(window.name, ww, new_height, window.parent);
			}
		}
	}
};

function gmui_default_window_title_handler(window) {
	var gmui = global.gmui;
	var style = gmui.style;
	var input = gmui.input;
	
	var wx = window.x;
	var wy = window.y;
	var ww = window.width;
	var wh = window.height;
	var flags = window.flags;
	
	// flags
	var has_title = (flags & gmui_window_flags.NO_TITLE_BAR) == 0;
	var has_close = (flags & gmui_window_flags.NO_CLOSE) == 0;
	var has_collapse = (flags & gmui_window_flags.NO_COLLAPSE) == 0;
	var can_move_with_mouse = (flags & gmui_window_flags.NO_MOVE_WITH_MOUSE) == 0;
	var has_scroll = (flags & gmui_window_flags.NO_SCROLL) == 0;
	var has_border = (flags & gmui_window_flags.NO_BORDERS) == 0;
	var has_border_resize = (flags & gmui_window_flags.NO_BORDER_RESIZE) == 0;
	
	// window interaction
	var window_hovering = array_contains(input.hovered_container_array, window);
	
	// bar
	var close_padding = 4;
	var close_size = 16;
	var close_x = ww - close_size - close_padding;
	var close_y = (style.window_title_height - close_size) / 2;
	
	var collapse_size = 16;
	var collapse_x = 4;
	var collapse_y = (style.window_title_height - collapse_size) / 2;
	
	// title
	if (has_title) {
		var title_height = style.window_title_height;
		var title_text_color = style.window_title_text_color;
		var title_font = style.font_window_title == undefined ? style.font_text : style.font_window_title;
		var title_color_idle = style.window_title_color_idle;
		var title_color_hover = style.window_title_hover_color;
		var title_color_active = style.window_title_active_color;
		var title_text_pos = has_collapse ? 24 : 4;
		var title_text = window.name;
		var title_text_size = gmui_calculate_text_size(title_text);
		
		var title_hovering = 
			window_hovering 
			&& (point_in_rectangle(input.m_x, input.m_y, wx, wy, wx + ww, wy + title_height) // title
			&& (has_close ? !point_in_rectangle(input.m_x, input.m_y, wx + close_x, wy + close_y, wx + close_x + close_size, wy + close_y + close_size) : true) // !close
			&& (has_collapse ? !point_in_rectangle(input.m_x, input.m_y, wx + collapse_x, wy + collapse_y, wx + collapse_x + collapse_size, wy + collapse_y + collapse_size) : true)) // !collapse
			// !border resize
			&& (has_border ? !point_in_rectangle(input.m_x, input.m_y, wx, wy, wx + 4, wy + wh) : true) // left
			&& (has_border ? !point_in_rectangle(input.m_x, input.m_y, wx + ww - 4, wy, wx + ww, wy + wh) : true) // right
			&& (has_border ? !point_in_rectangle(input.m_x, input.m_y, wx, wy, wx + ww, wy + 4) : true); // top
		var title_pressed = title_hovering && input.m_pressed; if (title_pressed) { window.is_title_dragging = true; window.dragging_diff_pos = [ input.m_x - wx, input.m_y - wy ]; };
		var title_holding = window.is_title_dragging;
		
		if (input.m_released) { window.is_title_dragging = false; };
	
		var title_color = title_color_idle;
		if (title_hovering) { title_color = title_color_hover; };
		if (title_holding) { title_color = title_color_active; };
		gmui_add_rectangle(0, 0, ww, title_height, false, title_color, 1);
	
		gmui_add_text(title_text, title_text_pos, (title_height - title_text_size[1]) / 2, style.window_title_text_color, 1);
	}
	
	// close button
	if (has_close) {
		var close_hover = window_hovering && point_in_rectangle(input.m_x, input.m_y, wx + close_x, wy + close_y, wx + close_x + close_size, wy + close_y + close_size);
		var close_active = close_hover && input.m_held && point_in_rectangle(window.last_clicked_pos[0], window.last_clicked_pos[1], wx + close_x, wy + close_y, wx + close_x + close_size, wy + close_y + close_size);
		var close_clicked = close_hover && input.m_released && point_in_rectangle(window.last_clicked_pos[0], window.last_clicked_pos[1], wx + close_x, wy + close_y, wx + close_x + close_size, wy + close_y + close_size);
		var close_bg_color = style.window_close_button_color_bg;
		var cross_pad = 4;
		
		if (close_hover && input.m_pressed) { window.is_title_dragging = false; };
		if (close_clicked) {
		    window.is_enabled = false;
			return false;
		}
		
		var close_color = style.window_close_button_color_idle;
		if (close_hover) close_color = style.window_close_button_hover_color;
		if (close_active) close_color = style.window_close_button_active_color;
		
		gmui_add_roundrect(close_x, close_y, close_x + close_size, close_y + close_size, false, close_bg_color, 1, 0);
		gmui_add_line_width(close_x + cross_pad, close_y + cross_pad, close_x + close_size - cross_pad, close_y + close_size - cross_pad, 2, close_color, 1);
		gmui_add_line_width(close_x + close_size - cross_pad, close_y + cross_pad, close_x + cross_pad, close_y + close_size - cross_pad, 2, close_color, 1);
	}
	
	// collapse button
	if (has_collapse) {
		var collapse_hover = window_hovering && point_in_rectangle(input.m_x, input.m_y, wx + collapse_x, wy + collapse_y, wx + collapse_x + collapse_size, wy + collapse_y + collapse_size);
		var collapse_clicked = collapse_hover && input.m_released && point_in_rectangle(window.last_clicked_pos[0], window.last_clicked_pos[1], wx + collapse_x, wy + collapse_y, wx + collapse_x + collapse_size, wy + collapse_y + collapse_size);
	
		if (collapse_hover && input.m_pressed) { window.is_title_dragging = false; };
		if (collapse_clicked) {
			window._win_collapsed = !window._win_collapsed;
			if (window._win_collapsed) {
				window.height_before_collapse = window.height;
				window.height = style.window_title_height;
			}
			else {
				window.height = window.height_before_collapse;
			}
		}
		var collapse_color = style.window_collapse_button_color_idle;
		if (collapse_hover) collapse_color = style.window_collapse_button_hover_color;
		var arrow_cx = collapse_x + 8;
		var arrow_cy = collapse_y + 8;
		var arrow_size = style.window_collapse_button_size;
		if (!window._win_collapsed) {
		    gmui_add_triangle(arrow_cx - arrow_size, arrow_cy - arrow_size / 2,
		                      arrow_cx + arrow_size, arrow_cy - arrow_size / 2,
		                      arrow_cx, arrow_cy + arrow_size / 2,
		                      collapse_color);
		} else {
		    gmui_add_triangle(arrow_cx - arrow_size / 2, arrow_cy - arrow_size,
		                      arrow_cx + arrow_size / 2, arrow_cy,
		                      arrow_cx - arrow_size / 2, arrow_cy + arrow_size,
		                      collapse_color);
		}
	}
};

function gmui_center_window(name) {
    var window = gmui_container_get(name, undefined);
    if (window != undefined) {
        var sw = surface_get_width(application_surface);
        var sh = surface_get_height(application_surface);
        window.x = (sw - window.width) / 2;
        window.y = (sh - window.height) / 2;
    }
};

function gmui_window_toggle(name) {
    var window = gmui_container_get(name, undefined);
    if (window != undefined) {
        window.is_enabled = !window.is_enabled;
    }
    return window.is_enabled;
};

function gmui_window_is_open(name) {
    var window = gmui_container_get(name, undefined);
    return window != undefined && window.is_enabled;
};

function gmui_window_change_name(window, new_name) {
	if (!ds_map_exists(global.gmui.containers, window.name)) { return; };
	ds_map_delete(global.gmui.containers, window.name);
	window.name = new_name;
	global.gmui.containers[? new_name] = window;
};