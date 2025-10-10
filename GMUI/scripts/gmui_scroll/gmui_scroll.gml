// Scrollbars, scrolling behavior
function gmui_handle_scrollbars(window) {
    var flags = window.flags;
    var style = global.gmui.style;
    
    // Check scrollbar conditions
    var has_vertical_scroll = (flags & gmui_window_flags.VERTICAL_SCROLL) != 0;
    var has_horizontal_scroll = (flags & gmui_window_flags.HORIZONTAL_SCROLL) != 0;
    var auto_scroll = (flags & gmui_window_flags.AUTO_SCROLL) != 0;
    var always_scrollbars = (flags & gmui_window_flags.ALWAYS_SCROLLBARS) != 0;
    var scroll_with_wheel = (flags & gmui_window_flags.SCROLL_WITH_MOUSE_WHEEL) != 0;
    
    var scrollbar_width = style.scrollbar_width;
    var content_area_width = window.width;
    var content_area_height = window.height - window.dc.title_bar_height;
    
    // Determine if scrollbars are needed
    var needs_vertical = has_vertical_scroll || (auto_scroll && window.content_height > content_area_height);
    var needs_horizontal = has_horizontal_scroll || (auto_scroll && window.content_width > content_area_width);
    
    var show_vertical = needs_vertical || (always_scrollbars && has_vertical_scroll);
    var show_horizontal = needs_horizontal || (always_scrollbars && has_horizontal_scroll);
    
    // Adjust content area for scrollbars
    content_area_width -= scrollbar_width;
	content_area_height -= scrollbar_width;
	//if (show_vertical) content_area_width -= scrollbar_width;
    //if (show_horizontal) content_area_height -= scrollbar_width;
    
    // Handle vertical scrollbar
    if (show_vertical) {
        gmui_draw_vertical_scrollbar(window, content_area_width, content_area_height);
    }
    
    // Handle horizontal scrollbar
    if (show_horizontal) {
        gmui_draw_horizontal_scrollbar(window, content_area_width, content_area_height);
    }
    
    // Handle mouse wheel scrolling
    if (scroll_with_wheel && gmui_is_mouse_over_window(window)) {
        var wheel_delta = mouse_wheel_down() - mouse_wheel_up();
        if (wheel_delta != 0) {
            window.scroll_y += wheel_delta * style.scroll_wheel_speed;
        }
    }
    
    // Clamp scroll positions
    var max_scroll_x = max(0, window.content_width - content_area_width);
    var max_scroll_y = max(0, window.content_height - content_area_height);
    
    window.scroll_x = clamp(window.scroll_x, 0, max_scroll_x);
    window.scroll_y = clamp(window.scroll_y, 0, max_scroll_y);
}

function gmui_draw_vertical_scrollbar(window, content_width, content_height) {
    var style = global.gmui.style;
    var scrollbar_width = style.scrollbar_width;
    
    // Calculate scrollbar position
    var scrollbar_x = (window.flags & gmui_window_flags.SCROLLBAR_LEFT) != 0 ? 0 : content_width;
    var scrollbar_y = window.dc.title_bar_height;
    var scrollbar_height = content_height;
    
    // Draw scrollbar background
    gmui_add_rect(scrollbar_x, scrollbar_y, scrollbar_width, scrollbar_height, 
                 style.scrollbar_background_color);
    
    // Calculate anchor size and position
    var max_scroll = max(0, window.content_height - content_height);
    var viewport_ratio = content_height / window.content_height;
    var anchor_height = max(style.scrollbar_min_anchor_size, scrollbar_height * viewport_ratio);
    
    var scroll_percent = (max_scroll > 0) ? window.scroll_y / max_scroll : 0;
    var anchor_y = scrollbar_y + (scrollbar_height - anchor_height) * scroll_percent;
    
    var anchor_bounds = [scrollbar_x, anchor_y, scrollbar_x + scrollbar_width, anchor_y + anchor_height];
    
    // Handle interaction
    var mouse_over_anchor = gmui_is_scrollbar_interacting(window, anchor_bounds);
	
    // Handle dragging
    if (mouse_over_anchor && global.gmui.mouse_clicked[0]) {
        window.scrollbar_dragging = true;
        window.scrollbar_drag_axis = 0; // vertical
        window.scrollbar_drag_offset = (global.gmui.mouse_pos[1] - window.y) - anchor_y;
    }
    
    if (window.scrollbar_dragging && window.scrollbar_drag_axis == 0) {
        if (global.gmui.mouse_down[0]) {
            var mouse_y_in_scrollbar = (global.gmui.mouse_pos[1] - window.y) - window.scrollbar_drag_offset;
            var normalized_y = (mouse_y_in_scrollbar - scrollbar_y) / (scrollbar_height - anchor_height);
            window.scroll_y = normalized_y * max_scroll;
        } else {
            window.scrollbar_dragging = false;
        }
    }
    
    // Draw anchor
    var anchor_color = style.scrollbar_anchor_color;
    if (window.scrollbar_dragging && window.scrollbar_drag_axis == 0) {
        anchor_color = style.scrollbar_anchor_active_color;
    } else if (mouse_over_anchor) {
        anchor_color = style.scrollbar_anchor_hover_color;
    }
    
    gmui_add_rect(scrollbar_x, anchor_y, scrollbar_width, anchor_height, anchor_color);
}

function gmui_draw_horizontal_scrollbar(window, content_width, content_height) {
    var style = global.gmui.style;
    var scrollbar_height = style.scrollbar_width;
    
    // Calculate scrollbar position
    var scrollbar_x = 0;
    var scrollbar_y = (window.flags & gmui_window_flags.SCROLLBAR_TOP) != 0 ? 
        window.dc.title_bar_height : window.height - scrollbar_height;
    
    var scrollbar_width = content_width;
    
    // Draw scrollbar background
    gmui_add_rect(scrollbar_x, scrollbar_y, scrollbar_width, scrollbar_height, 
                 style.scrollbar_background_color);
    
    // Calculate anchor size and position
    var max_scroll = max(0, window.content_width - content_width);
    var viewport_ratio = content_width / window.content_width;
    var anchor_width = max(style.scrollbar_min_anchor_size, scrollbar_width * viewport_ratio);
    
    var scroll_percent = (max_scroll > 0) ? window.scroll_x / max_scroll : 0;
    var anchor_x = scrollbar_x + (scrollbar_width - anchor_width) * scroll_percent;
    
    var anchor_bounds = [anchor_x, scrollbar_y, anchor_x + anchor_width, scrollbar_y + scrollbar_height];
    
    // Handle interaction
    var mouse_over_anchor = gmui_is_scrollbar_interacting(window, anchor_bounds);
    
    // Handle dragging
    if (mouse_over_anchor && global.gmui.mouse_clicked[0]) {
        window.scrollbar_dragging = true;
        window.scrollbar_drag_axis = 1; // horizontal
        window.scrollbar_drag_offset = (global.gmui.mouse_pos[0] - window.x) - anchor_x;
    }
    
    if (window.scrollbar_dragging && window.scrollbar_drag_axis == 1) {
        if (global.gmui.mouse_down[0]) {
            var mouse_x_in_scrollbar = (global.gmui.mouse_pos[0] - window.x) - window.scrollbar_drag_offset;
            var normalized_x = (mouse_x_in_scrollbar - scrollbar_x) / (scrollbar_width - anchor_width);
            window.scroll_x = normalized_x * max_scroll;
        } else {
            window.scrollbar_dragging = false;
        }
    }
    
    // Draw anchor
    var anchor_color = style.scrollbar_anchor_color;
    if (window.scrollbar_dragging && window.scrollbar_drag_axis == 1) {
        anchor_color = style.scrollbar_anchor_active_color;
    } else if (mouse_over_anchor) {
        anchor_color = style.scrollbar_anchor_hover_color;
    }
    
    gmui_add_rect(anchor_x, scrollbar_y, anchor_width, scrollbar_height, anchor_color);
}

function gmui_is_scrollbar_interacting(window, bounds) {
    return gmui_is_mouse_over_window(window) && 
           gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, 
                               global.gmui.mouse_pos[1] - window.y, 
                               bounds);
}

function gmui_set_scroll_position(window_name, scroll_x, scroll_y) {
    if (!global.gmui.initialized) return false;
    
    var window = gmui_get_window(window_name);
    if (!window) return false;
    
    window.scroll_x = scroll_x;
    window.scroll_y = scroll_y;
    
    return true;
}

function gmui_get_scroll_position(window_name) {
    if (!global.gmui.initialized) return undefined;
    
    var window = gmui_get_window(window_name);
    if (!window) return undefined;
    
    return [window.scroll_x, window.scroll_y];
}

function gmui_scroll_to_bottom(window_name) {
    if (!global.gmui.initialized) return false;
    
    var window = gmui_get_window(window_name);
    if (!window) return false;
    
    var content_area_height = window.height - window.dc.title_bar_height;
    if ((window.flags & gmui_window_flags.HORIZONTAL_SCROLL) != 0) {
        content_area_height -= global.gmui.style.scrollbar_width;
    }
    
    window.scroll_y = max(0, window.content_height - content_area_height);
    
    return true;
}

function gmui_scroll_to_top(window_name) {
    if (!global.gmui.initialized) return false;
    
    var window = gmui_get_window(window_name);
    if (!window) return false;
    
    window.scroll_y = 0;
    
    return true;
}