// Utility functions, state management
function gmui_is_mouse_over_window(window) {
    var mx = global.gmui.mouse_pos[0];
    var my = global.gmui.mouse_pos[1];
    var result = ((mx >= window.x && mx <= window.x + window.width &&
            my >= window.y && my <= window.y + window.height)) && global.gmui.hovering_window == window;
	return result;
}

// Utility function: Check if point is in rectangle
function gmui_is_point_in_rect(point_x, point_y, rect) {
    return (point_x >= rect[0] && point_x <= rect[2] &&
            point_y >= rect[1] && point_y <= rect[3]);
}

// Draw title bar with close button
function gmui_draw_title_bar(window, title) {
    var style = global.gmui.style;
    var flags = window.flags;
    
    // Title bar background
    var title_bar_color = style.title_bar_color;
    if (window.title_bar_hovered) title_bar_color = style.title_bar_hover_color;
    if (window.title_bar_active) title_bar_color = style.title_bar_active_color;
    
    gmui_add_rect(0, 0, window.width, style.title_bar_height, title_bar_color);
    
    // Title text
    var text_size = gmui_calc_text_size(title);
    var text_x = style.title_padding[0];
    var text_y = (style.title_bar_height - text_size[1]) / 2;
    
    // Handle text alignment
    if (style.title_text_align == "center") {
        text_x = (window.width - text_size[0]) / 2;
    } else if (style.title_text_align == "right") {
        text_x = window.width - text_size[0] - style.title_padding[0];
    }
    
    gmui_add_text(text_x, text_y, title, style.title_text_color);
    
    // Close button if not disabled
    var has_close_button = (flags & gmui_window_flags.NO_CLOSE) == 0;
    if (has_close_button) {
        gmui_draw_title_bar_close_button(window);
    }
	
	// Resize
	var can_resize = (flags & gmui_window_flags.NO_RESIZE) == 0;
	if (can_resize) {
		gmui_draw_window_resize(window);
	}
}

// Draw resize triangle
function gmui_draw_window_resize(window) {
	var origin_x = window.width;
	var origin_y = window.height;
	var size = 16;
	var col = global.gmui.style.border_color;
	var thickness = 4;
	
	gmui_add_line(origin_x, origin_y, origin_x, origin_y - size, col, thickness);
	gmui_add_line(origin_x, origin_y, origin_x - size, origin_y, col, thickness);
	gmui_add_line(origin_x - size, origin_y, origin_x, origin_y - size, col, thickness);
}

// Draw close button in title bar
function gmui_draw_title_bar_close_button(window) {
    var style = global.gmui.style;
    var close_size = style.close_button_size;
    var close_padding = 4;
    
    var close_x = window.width - close_size - close_padding;
    var close_y = (style.title_bar_height - close_size) / 2;
    var close_bounds = [close_x, close_y, close_x + close_size, close_y + close_size];
    
    // Check close button interaction
    var mouse_over_close = gmui_is_mouse_over_window(window) && 
                          gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, 
                                              global.gmui.mouse_pos[1] - window.y, close_bounds) && !global.gmui.is_hovering_element;
    
    var close_color = style.close_button_color;
    if (mouse_over_close) {
		global.gmui.is_hovering_element = true;
        if (global.gmui.mouse_down[0]) {
            close_color = style.close_button_active_color;
        } else {
            close_color = style.close_button_hover_color;
        }
        
        // Close window on click
        if (global.gmui.mouse_released[0]) {
            window.open = false;
        }
    }
    
    // Draw close button (X symbol)
    var cross_thickness = 2;
    var cross_padding = 4;
    
    // Draw background circle/rect
    gmui_add_rect(close_x, close_y, close_size, close_size, make_color_rgb(0, 0, 0));
    
    // Draw X symbol
    gmui_add_line(close_x + cross_padding, close_y + cross_padding, 
                 close_x + close_size - cross_padding, close_y + close_size - cross_padding, 
                 close_color, cross_thickness);
    gmui_add_line(close_x + close_size - cross_padding, close_y + cross_padding, 
                 close_x + cross_padding, close_y + close_size - cross_padding, 
                 close_color, cross_thickness);
}

// Handle window dragging and resizing
function gmui_handle_window_interaction(window) {
    var style = global.gmui.style;
    var flags = window.flags;
    var has_title_bar = (flags & gmui_window_flags.NO_TITLE_BAR) == 0;
    var can_move = (flags & gmui_window_flags.NO_MOVE) == 0;
    var can_resize = (flags & gmui_window_flags.NO_RESIZE) == 0;
    
    var mouse_x_in_window = global.gmui.mouse_pos[0] - window.x;
    var mouse_y_in_window = global.gmui.mouse_pos[1] - window.y;
    var mouse_over_window = gmui_is_mouse_over_window(window);
    
    // Reset hover states
    window.title_bar_hovered = false;
    
    // Check title bar hover
    if (has_title_bar && mouse_over_window && mouse_y_in_window <= style.title_bar_height && !global.gmui.is_hovering_element) {
        global.gmui.is_hovering_element = true;
		window.title_bar_hovered = true;
    }
    
    // Handle dragging
    if (can_move && has_title_bar && window.title_bar_hovered) {
        if (global.gmui.mouse_clicked[0]) {
            window.is_dragging = true;
            window.drag_offset_x = mouse_x_in_window;
            window.drag_offset_y = mouse_y_in_window;
            window.title_bar_active = true;
            
            // Double click detection for maximize/restore
			if ((flags & gmui_window_flags.NO_COLLAPSE) == 0) {
	            var ct = current_time;
	            if (ct - window.last_click_time < 300) { // 300ms double click
	                // Toggle between original size and maximized
	                if (window.width == window.initial_width && window.height == window.initial_height) { // goes to collapse
	                    // Maximize (simplified - use room size or screen size)
	                    //window.width = room_width - 20;
	                    //window.height = room_height - 20;
	                    //window.x = 10;
	                    //window.y = 10;
					
						window.height = 30;
	                } else { // goes to uncollapsed
	                    // Restore to initial size
	                    window.x = window.initial_x;
	                    window.y = window.initial_y;
	                    window.width = window.initial_width;
	                    window.height = window.initial_height;
	                }
	                gmui_create_surface(window);
	            }
	            window.last_click_time = ct;
			}
        }
    }
    
    // Handle dragging movement
    if (window.is_dragging && global.gmui.mouse_down[0]) {
        window.x = global.gmui.mouse_pos[0] - window.drag_offset_x;
        window.y = global.gmui.mouse_pos[1] - window.drag_offset_y;
        window.surface_dirty = true; // Mark as dirty since position changed
    } else {
        window.is_dragging = false;
        window.title_bar_active = false;
    }
    
    // Handle resizing
    if (can_resize && mouse_over_window) {
        var resize_margin = 4;
        var near_right = mouse_x_in_window >= window.width - resize_margin;
        var near_bottom = mouse_y_in_window >= window.height - resize_margin;
        
        if ((near_right && near_bottom) && global.gmui.mouse_clicked[0]) {
            window.is_resizing = true;
        }
		
		if (near_right && near_bottom && !global.gmui.is_hovering_element) {
			global.gmui.is_hovering_element = true;
			window_set_cursor(cr_size_nwse);
		}
    }
    
    // Handle resizing movement
    if (window.is_resizing && global.gmui.mouse_down[0]) {
        var new_width = max(global.gmui.style.window_min_size[0], mouse_x_in_window);
        var new_height = max(global.gmui.style.window_min_size[1], mouse_y_in_window);
        
        if (new_width != window.width || new_height != window.height) {
            window.width = new_width;
            window.height = new_height;
            gmui_create_surface(window); // Recreate surface with new size
        }
		
		window_set_cursor(cr_size_nwse);
    } else {
        window.is_resizing = false;
    }
	
	// Handle Scrollbar to make sure elements dont overlap over mouse
	var has_scrollbar_vertical = (window.flags & gmui_window_flags.VERTICAL_SCROLL) != 0 || (window.flags & gmui_window_flags.AUTO_SCROLL) != 0;
	var has_scrollbar_horizontal = (window.flags & gmui_window_flags.HORIZONTAL_SCROLLBAR) != 0 || (window.flags & gmui_window_flags.AUTO_SCROLL) != 0;
	
	if (has_scrollbar_vertical) {
		var content_width = window.width - style.scrollbar_width;
		var content_height = window.height - window.dc.title_bar_height - style.scrollbar_width;
		var _x = (window.flags & gmui_window_flags.SCROLLBAR_LEFT) != 0 ? 0 : content_width;
		var _y = window.dc.title_bar_height;
		var _width = style.scrollbar_width;
		var _height = content_height;
		
		var anchor_bounds = [_x, _y, _x + _width, _y + _height];
		var mouse_over_anchor = gmui_is_scrollbar_interacting(window, anchor_bounds);
		if (mouse_over_anchor && !global.gmui.is_hovering_element) {
			global.gmui.is_hovering_element = true;
		};
	};
	
	if (has_scrollbar_horizontal) {
		var content_width = window.width - style.scrollbar_width;
		var content_height = window.height - window.dc.title_bar_height - style.scrollbar_width;
		var _x = 0
		var _y = (window.flags & gmui_window_flags.SCROLLBAR_TOP) != 0 ? window.dc.title_bar_height : content_height;
		var _width = content_width;
		var _height = style.scrollbar_width;
		
		var anchor_bounds = [_x, _y, _x + _width, _y + _height];
		var mouse_over_anchor = gmui_is_scrollbar_interacting(window, anchor_bounds);
		if (mouse_over_anchor && !global.gmui.is_hovering_element) {
			global.gmui.is_hovering_element = true;
		};
	};
}

function gmui_add_scissor(x, y, w, h) {
    if (!global.gmui.initialized || !global.gmui.current_window) return;
    array_push(global.gmui.current_window.draw_list, {
        type: "scissor", x: x, y: y, width: w, height: h
    });
}

function gmui_add_scissor_reset() {
    if (!global.gmui.initialized || !global.gmui.current_window) return;
    array_push(global.gmui.current_window.draw_list, {
        type: "scissor_reset"
    });
}

function gmui_begin_scissor(x, y, w, h) {
    gmui_add_scissor(x, y, w, h);
	return true;
}

function gmui_end_scissor() {
    gmui_add_scissor_reset();
}

function gmui_scissor_group(x, y, w, h, func) {
    gmui_begin_scissor(x, y, w, h);
    func();
    gmui_end_scissor();
}