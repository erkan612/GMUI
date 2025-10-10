// Text, labels, buttons
function gmui_text(text) {
    if (!global.gmui.initialized || !global.gmui.current_window) return false;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var size = gmui_calc_text_size(text);
    
    gmui_add_text(dc.cursor_x, dc.cursor_y, text, global.gmui.style.text_color);
    
	dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x += size[0] + global.gmui.style.item_spacing[0];
    dc.line_height = max(dc.line_height, size[1]);
	
	gmui_new_line();
	
    return false;
}

function gmui_text_disabled(text) {
    if (!global.gmui.initialized || !global.gmui.current_window) return false;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var size = gmui_calc_text_size(text);
    
    gmui_add_text(dc.cursor_x, dc.cursor_y, text, global.gmui.style.text_disabled_color);
    
	dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x += size[0] + global.gmui.style.item_spacing[0];
    dc.line_height = max(dc.line_height, size[1]);
	
	gmui_new_line();
	
    return false;
}

function gmui_label_text(label, text) {
    if (!global.gmui.initialized || !global.gmui.current_window) return false;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var label_size = gmui_calc_text_size(label + ": ");
    var text_size = gmui_calc_text_size(text);
    
    gmui_add_text(dc.cursor_x, dc.cursor_y, label + ": ", global.gmui.style.text_disabled_color);
    gmui_add_text(dc.cursor_x + label_size[0], dc.cursor_y, text, global.gmui.style.text_color);
    
	dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x += label_size[0] + text_size[0] + global.gmui.style.item_spacing[0];
    dc.line_height = max(dc.line_height, max(label_size[1], text_size[1]));
	
	gmui_new_line();
	
    return false;
}

function gmui_button(label, width = -1, height = -1) {
    if (!global.gmui.initialized || !global.gmui.current_window) return false;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
    
    // Calculate button size
    var text_size = gmui_calc_text_size(label);
    var button_width = max(style.button_min_size[0], text_size[0] + style.button_padding[0] * 2);
    var button_height = max(style.button_min_size[1], text_size[1] + style.button_padding[1] * 2);
    
    // Use custom size if provided
    if (width > 0) button_width = width;
    if (height > 0) button_height = height;
    
    // Check if button fits on current line, otherwise move to new line
    //if (dc.cursor_x + button_width > window.width - style.window_padding[0] && dc.cursor_x > dc.cursor_start_x) {
    //    gmui_new_line();
    //}
    
    // Calculate button bounds
    var button_x = dc.cursor_x;
    var button_y = dc.cursor_y;
    var button_bounds = [button_x, button_y, button_x + button_width, button_y + button_height];
    
    // Check for mouse interaction
    var mouse_over = gmui_is_mouse_over_window(window) && 
                     gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, global.gmui.mouse_pos[1] - window.y, button_bounds) && !global.gmui.is_hovering_element;
    
    var clicked = false;
    var is_active = false;
    
    if (mouse_over) {
		global.gmui.is_hovering_element = true;
        if (global.gmui.mouse_down[0]) {
            is_active = true;
        }
        if (global.gmui.mouse_released[0]) {
            clicked = true;
        }
    }
    
    // Draw button based on state
    var bg_color, border_color, text_color;
    
    if (!window.active) {
        // Window not active - disabled state
        bg_color = style.button_disabled_bg_color;
        border_color = style.button_disabled_border_color;
        text_color = style.button_disabled_text_color;
    } else if (is_active) {
        // Button being pressed
        bg_color = style.button_active_bg_color;
        border_color = style.button_active_border_color;
        text_color = style.button_text_color;
    } else if (mouse_over) {
        // Mouse hovering
        bg_color = style.button_hover_bg_color;
        border_color = style.button_hover_border_color;
        text_color = style.button_text_color;
    } else {
        // Normal state
        bg_color = style.button_bg_color;
        border_color = style.button_border_color;
        text_color = style.button_text_color;
    }
    
    // Draw button background
    gmui_add_rect(button_x, button_y, button_width, button_height, bg_color);
    
    // Draw border
    if (style.button_border_size > 0) {
        gmui_add_rect_outline(button_x, button_y, button_width, button_height, border_color, style.button_border_size);
    }
    
    // Draw text centered
    var text_x = button_x + (button_width - text_size[0]) / 2;
    var text_y = button_y + (button_height - text_size[1]) / 2;
    gmui_add_text(text_x, text_y, label, text_color);
    
    // Update cursor position
    dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x += button_width + style.item_spacing[0];
    dc.line_height = max(dc.line_height, button_height);
	
	gmui_new_line();
    
    return clicked && window.active;
}

function gmui_button_small(label) {
    return gmui_button(label, -1, 20);
}

function gmui_button_large(label) {
    return gmui_button(label, -1, 32);
}

function gmui_button_width(label, width) {
    return gmui_button(label, width, -1);
}

function gmui_button_disabled(label, width = -1, height = -1) {
    if (!global.gmui.initialized || !global.gmui.current_window) return false;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
    
    // Calculate button size (same as regular button)
    var text_size = gmui_calc_text_size(label);
    var button_width = max(style.button_min_size[0], text_size[0] + style.button_padding[0] * 2);
    var button_height = max(style.button_min_size[1], text_size[1] + style.button_padding[1] * 2);
    
    if (width > 0) button_width = width;
    if (height > 0) button_height = height;
    
    // Check if button fits on current line
    if (dc.cursor_x + button_width > window.width - style.window_padding[0] && dc.cursor_x > dc.cursor_start_x) {
        gmui_new_line();
    }
    
    var button_x = dc.cursor_x;
    var button_y = dc.cursor_y;
    
    // Draw disabled button
    gmui_add_rect(button_x, button_y, button_width, button_height, style.button_disabled_bg_color);
    
    if (style.button_border_size > 0) {
        gmui_add_rect_outline(button_x, button_y, button_width, button_height, style.button_disabled_border_color, style.button_border_size);
    }
    
    // Draw text centered
    var text_x = button_x + (button_width - text_size[0]) / 2;
    var text_y = button_y + (button_height - text_size[1]) / 2;
    gmui_add_text(text_x, text_y, label, style.button_disabled_text_color);
    
    // Update cursor position
    dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x += button_width + style.item_spacing[0];
    dc.line_height = max(dc.line_height, button_height);
	
	gmui_new_line();
    
    return false; // Disabled buttons never return true
}