// Checkboxes, sliders, textboxes, drag inputs
function gmui_checkbox(label, value) {
    if (!global.gmui.initialized || !global.gmui.current_window) return value;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
    
    // Calculate total size needed
    var text_size = gmui_calc_text_size(label);
    var total_width = text_size[0] + style.checkbox_spacing + style.checkbox_size;
    var total_height = max(style.checkbox_size, text_size[1]);
    
    // Check if checkbox fits on current line, otherwise move to new line
    if (dc.cursor_x + total_width > window.width - style.window_padding[0] && dc.cursor_x > dc.cursor_start_x) {
        gmui_new_line();
    }
    
    // Calculate label bounds (on the left)
    var label_x = dc.cursor_x;
    var label_y = dc.cursor_y + (total_height - text_size[1]) / 2;
    var label_bounds = [label_x, label_y, label_x + text_size[0], label_y + text_size[1]];
    
    // Calculate checkbox bounds (on the right)
    var checkbox_x = dc.cursor_x + text_size[0] + style.checkbox_spacing;
    var checkbox_y = dc.cursor_y + (total_height - style.checkbox_size) / 2;
    var checkbox_bounds = [checkbox_x, checkbox_y, checkbox_x + style.checkbox_size, checkbox_y + style.checkbox_size];
    
    // Calculate total interactive bounds (label + checkbox)
    var interactive_bounds = [
        label_x, 
        dc.cursor_y, 
        checkbox_x + style.checkbox_size, 
        dc.cursor_y + total_height
    ];
    
    // Check for mouse interaction
    var mouse_over = gmui_is_mouse_over_window(window) && 
                     gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, 
                                         global.gmui.mouse_pos[1] - window.y, 
                                         interactive_bounds) && !global.gmui.is_hovering_element;
    
    var toggled = false;
    var is_active = false;
    
    if (mouse_over && window.active) {
		global.gmui.is_hovering_element = true;
        if (global.gmui.mouse_down[0]) {
            is_active = true;
        }
        if (global.gmui.mouse_released[0]) {
            toggled = true;
            value = !value;
        }
    }
    
    // Draw checkbox based on state
    var bg_color, border_color, text_color;
    
    if (!window.active) {
        // Window not active - disabled state
        bg_color = style.checkbox_disabled_bg_color;
        border_color = style.checkbox_disabled_border_color;
        text_color = style.checkbox_text_disabled_color;
    } else if (is_active) {
        // Checkbox being pressed
        bg_color = style.checkbox_active_bg_color;
        border_color = style.checkbox_active_border_color;
        text_color = style.checkbox_text_color;
    } else if (mouse_over) {
        // Mouse hovering
        bg_color = style.checkbox_hover_bg_color;
        border_color = style.checkbox_hover_border_color;
        text_color = style.checkbox_text_color;
    } else {
        // Normal state
        bg_color = style.checkbox_bg_color;
        border_color = style.checkbox_border_color;
        text_color = style.checkbox_text_color;
    }
    
    // Draw label first (on the left)
    gmui_add_text(label_x, label_y, label, text_color);
    
    // Draw checkbox background (on the right)
    gmui_add_rect(checkbox_x, checkbox_y, style.checkbox_size, style.checkbox_size, bg_color);
    
    // Draw border
    if (style.checkbox_border_size > 0) {
        gmui_add_rect_outline(checkbox_x, checkbox_y, style.checkbox_size, style.checkbox_size, 
                            border_color, style.checkbox_border_size);
    }
    
    // Draw checkmark if checked
    if (value) {
        var check_padding = 3;
        var check_x1 = checkbox_x + check_padding;
        var check_y1 = checkbox_y + style.checkbox_size / 2;
        var check_x2 = checkbox_x + style.checkbox_size / 2 - 1;
        var check_y2 = checkbox_y + style.checkbox_size - check_padding;
        var check_x3 = checkbox_x + style.checkbox_size - check_padding;
        var check_y3 = checkbox_y + check_padding;
        
        // Draw checkmark lines
        gmui_add_line(check_x1, check_y1, check_x2, check_y2, style.checkbox_check_color, 2);
        gmui_add_line(check_x2, check_y2, check_x3, check_y3, style.checkbox_check_color, 2);
    }
    
    // Update cursor position
    dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x += total_width + style.item_spacing[0];
    dc.line_height = max(dc.line_height, total_height);
	
	gmui_new_line();
    
    return value;
}

function gmui_checkbox_disabled(label, value) {
    if (!global.gmui.initialized || !global.gmui.current_window) return value;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
    
    // Calculate total size needed
    var text_size = gmui_calc_text_size(label);
    var total_width = text_size[0] + style.checkbox_spacing + style.checkbox_size;
    var total_height = max(style.checkbox_size, text_size[1]);
    
    // Check if checkbox fits on current line
    if (dc.cursor_x + total_width > window.width - style.window_padding[0] && dc.cursor_x > dc.cursor_start_x) {
        gmui_new_line();
    }
    
    // Calculate positions (label on left, checkbox on right)
    var label_x = dc.cursor_x;
    var label_y = dc.cursor_y + (total_height - text_size[1]) / 2;
    var checkbox_x = dc.cursor_x + text_size[0] + style.checkbox_spacing;
    var checkbox_y = dc.cursor_y + (total_height - style.checkbox_size) / 2;
    
    // Draw disabled label first (on the left)
    gmui_add_text(label_x, label_y, label, style.checkbox_text_disabled_color);
    
    // Draw disabled checkbox (on the right)
    gmui_add_rect(checkbox_x, checkbox_y, style.checkbox_size, style.checkbox_size, 
                 style.checkbox_disabled_bg_color);
    
    if (style.checkbox_border_size > 0) {
        gmui_add_rect_outline(checkbox_x, checkbox_y, style.checkbox_size, style.checkbox_size, 
                            style.checkbox_disabled_border_color, style.checkbox_border_size);
    }
    
    // Draw checkmark if checked (disabled style)
    if (value) {
        var check_padding = 3;
        var check_x1 = checkbox_x + check_padding;
        var check_y1 = checkbox_y + style.checkbox_size / 2;
        var check_x2 = checkbox_x + style.checkbox_size / 2 - 1;
        var check_y2 = checkbox_y + style.checkbox_size - check_padding;
        var check_x3 = checkbox_x + style.checkbox_size - check_padding;
        var check_y3 = checkbox_y + check_padding;
        
        gmui_add_line(check_x1, check_y1, check_x2, check_y2, style.checkbox_text_disabled_color, 2);
        gmui_add_line(check_x2, check_y2, check_x3, check_y3, style.checkbox_text_disabled_color, 2);
    }
    
    // Update cursor position
    dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x += total_width + style.item_spacing[0];
    dc.line_height = max(dc.line_height, total_height);
	
	gmui_new_line();
    
    return value;
}

function gmui_checkbox_box(value, size = -1) {
    if (!global.gmui.initialized || !global.gmui.current_window) return value;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
    
    var checkbox_size = size > 0 ? size : style.checkbox_size;
    
    // Calculate checkbox bounds
    var checkbox_x = dc.cursor_x;
    var checkbox_y = dc.cursor_y;
    var checkbox_bounds = [checkbox_x, checkbox_y, checkbox_x + checkbox_size, checkbox_y + checkbox_size];
    
    // Check for mouse interaction
    var mouse_over = gmui_is_mouse_over_window(window) && 
                     gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, 
                                         global.gmui.mouse_pos[1] - window.y, 
                                         checkbox_bounds) && !global.gmui.is_hovering_element;
    
    var toggled = false;
    var is_active = false;
    
    if (mouse_over && window.active) {
		global.gmui.is_hovering_element = true;
        if (global.gmui.mouse_down[0]) {
            is_active = true;
        }
        if (global.gmui.mouse_released[0]) {
            toggled = true;
            value = !value;
        }
    }
    
    // Draw checkbox based on state
    var bg_color, border_color;
    
    if (!window.active) {
        bg_color = style.checkbox_disabled_bg_color;
        border_color = style.checkbox_disabled_border_color;
    } else if (is_active) {
        bg_color = style.checkbox_active_bg_color;
        border_color = style.checkbox_active_border_color;
    } else if (mouse_over) {
        bg_color = style.checkbox_hover_bg_color;
        border_color = style.checkbox_hover_border_color;
    } else {
        bg_color = style.checkbox_bg_color;
        border_color = style.checkbox_border_color;
    }
    
    // Draw checkbox
    gmui_add_rect(checkbox_x, checkbox_y, checkbox_size, checkbox_size, bg_color);
    
    if (style.checkbox_border_size > 0) {
        gmui_add_rect_outline(checkbox_x, checkbox_y, checkbox_size, checkbox_size, 
                            border_color, style.checkbox_border_size);
    }
    
    // Draw checkmark if checked
    if (value) {
        var check_padding = 3 * (checkbox_size / style.checkbox_size); // Scale padding with size
        var check_x1 = checkbox_x + check_padding;
        var check_y1 = checkbox_y + checkbox_size / 2;
        var check_x2 = checkbox_x + checkbox_size / 2 - 1;
        var check_y2 = checkbox_y + checkbox_size - check_padding;
        var check_x3 = checkbox_x + checkbox_size - check_padding;
        var check_y3 = checkbox_y + check_padding;
        
        var check_color = window.active ? style.checkbox_check_color : style.checkbox_text_disabled_color;
        var check_thickness = max(1, floor(2 * (checkbox_size / style.checkbox_size))); // Scale thickness
        
        gmui_add_line(check_x1, check_y1, check_x2, check_y2, check_color, check_thickness);
        gmui_add_line(check_x2, check_y2, check_x3, check_y3, check_color, check_thickness);
    }
    
    // Update cursor position
    dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x += checkbox_size + style.item_spacing[0];
    dc.line_height = max(dc.line_height, checkbox_size);
	
	gmui_new_line();
    
    return value;
}

function gmui_slider(label, value, min_value, max_value, width = -1) {
    if (!global.gmui.initialized || !global.gmui.current_window) return value;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
    
    // Calculate sizes
    var text_size = gmui_calc_text_size(label);
    var slider_width = (width > 0) ? width : 100; // Default width if not specified
    var slider_height = max(style.slider_track_height, style.slider_handle_height);
    
    // Total width needed (text + spacing + slider)
    var total_width = text_size[0] + style.slider_spacing + slider_width;
    var total_height = max(text_size[1], slider_height);
    
    // Check if slider fits on current line
    if (dc.cursor_x + total_width > window.width - style.window_padding[0] && dc.cursor_x > dc.cursor_start_x) {
        gmui_new_line();
    }
    
    // Calculate slider bounds
    var slider_x = dc.cursor_x + text_size[0] + style.slider_spacing;
    var slider_y = dc.cursor_y;
    
    // Calculate track bounds
    var track_y = slider_y + (total_height - style.slider_track_height) / 2;
    var track_bounds = [slider_x, track_y, slider_x + slider_width, track_y + style.slider_track_height];
    
    // Calculate normalized value position
    var normalized_value = (value - min_value) / (max_value - min_value);
    normalized_value = clamp(normalized_value, 0, 1);
    
    // Calculate handle position
    var handle_x = slider_x + (slider_width - style.slider_handle_width) * normalized_value;
    var handle_y = track_y + (style.slider_track_height - style.slider_handle_height) / 2;
    var handle_bounds = [handle_x, handle_y, handle_x + style.slider_handle_width, handle_y + style.slider_handle_height];
    
    // Create a unique ID for this slider using window position and cursor position
    var slider_id = "slider_" + string(window.x) + "_" + string(window.y) + "_" + string(dc.cursor_x) + "_" + string(dc.cursor_y);
    
    // Check for mouse interaction
    var mouse_over = gmui_is_mouse_over_window(window);
    var mouse_over_handle = mouse_over && gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, global.gmui.mouse_pos[1] - window.y, handle_bounds) && !global.gmui.is_hovering_element;
    var mouse_over_track = mouse_over && gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, global.gmui.mouse_pos[1] - window.y, track_bounds) && !global.gmui.is_hovering_element;
    
    var value_changed = false;
    var is_active = false;
    var is_dragging = false;
    
    // Check if this is the active slider being dragged
    if (global.gmui.active_slider == slider_id && global.gmui.mouse_down[0]) {
        is_dragging = true;
        is_active = true;
    }
    
    if ((mouse_over_handle || mouse_over_track) && window.active) {
		global.gmui.is_hovering_element = true;
        if (global.gmui.mouse_clicked[0]) {
            // Start dragging this slider
            global.gmui.active_slider = slider_id;
            is_dragging = true;
            is_active = true;
        }
    }
    
    // If we're dragging, update the value based on mouse position
    if (is_dragging) {
        var mouse_x_in_slider = (global.gmui.mouse_pos[0] - window.x - slider_x) - style.slider_handle_width / 2;
        var new_normalized = clamp(mouse_x_in_slider / (slider_width - style.slider_handle_width), 0, 1);
        var new_value = min_value + new_normalized * (max_value - min_value);
        
        // Only update if value actually changed
        if (abs(new_value - value) > 0.001) {
            value = new_value;
            value_changed = true;
        }
        
        // Update handle position for visual feedback during drag
        normalized_value = (value - min_value) / (max_value - min_value);
        normalized_value = clamp(normalized_value, 0, 1);
        handle_x = slider_x + (slider_width - style.slider_handle_width) * normalized_value;
        handle_bounds = [handle_x, handle_y, handle_x + style.slider_handle_width, handle_y + style.slider_handle_height];
    }
    
    // Stop dragging when mouse is released
    if (global.gmui.mouse_released[0] && global.gmui.active_slider == slider_id) {
        global.gmui.active_slider = undefined;
    }
    
    // Draw label
    var text_color = window.active ? style.slider_text_color : style.slider_text_disabled_color;
    var text_y = dc.cursor_y + (total_height - text_size[1]) / 2;
    gmui_add_text(dc.cursor_x, text_y, label, text_color);
    
    // Draw track background
    var track_bg_color = window.active ? style.slider_track_bg_color : make_color_rgb(50, 50, 50);
    gmui_add_rect(track_bounds[0], track_bounds[1], slider_width, style.slider_track_height, track_bg_color);
    
    // Draw track fill
    if (window.active) {
        var fill_width = (handle_x - slider_x) + style.slider_handle_width / 2;
        gmui_add_rect(track_bounds[0], track_bounds[1], fill_width, style.slider_track_height, style.slider_track_fill_color);
    }
    
    // Draw track border
    if (style.slider_track_border_size > 0) {
        var track_border_color = window.active ? style.slider_track_border_color : make_color_rgb(70, 70, 70);
        gmui_add_rect_outline(track_bounds[0], track_bounds[1], slider_width, style.slider_track_height, track_border_color, style.slider_track_border_size);
    }
    
    // Draw handle based on state
    var handle_bg_color, handle_border_color;
    
    if (!window.active) {
        handle_bg_color = style.slider_handle_disabled_bg_color;
        handle_border_color = style.slider_handle_disabled_border_color;
    } else if (is_dragging) {
        handle_bg_color = style.slider_handle_active_bg_color;
        handle_border_color = style.slider_handle_active_border_color;
    } else if (mouse_over_handle) {
        handle_bg_color = style.slider_handle_hover_bg_color;
        handle_border_color = style.slider_handle_hover_border_color;
    } else {
        handle_bg_color = style.slider_handle_bg_color;
        handle_border_color = style.slider_handle_border_color;
    }
    
    // Draw handle
    gmui_add_rect(handle_x, handle_y, style.slider_handle_width, style.slider_handle_height, handle_bg_color);
    
    if (style.slider_handle_border_size > 0) {
        gmui_add_rect_outline(handle_x, handle_y, style.slider_handle_width, style.slider_handle_height, handle_border_color, style.slider_handle_border_size);
    }
    
    // Update cursor position
    dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x += total_width + style.item_spacing[0];
    dc.line_height = max(dc.line_height, total_height);
    
    gmui_new_line();
    
    return value;
}

// Disabled slider element
function gmui_slider_disabled(label, value, min_value, max_value, width = -1) {
    if (!global.gmui.initialized || !global.gmui.current_window) return value;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
    
    // Calculate sizes
    var text_size = gmui_calc_text_size(label);
    var slider_width = (width > 0) ? width : 100;
    var slider_height = max(style.slider_track_height, style.slider_handle_height);
    
    // Total width needed (text + spacing + slider)
    var total_width = text_size[0] + style.slider_spacing + slider_width;
    var total_height = max(text_size[1], slider_height);
    
    // Check if slider fits on current line
    if (dc.cursor_x + total_width > window.width - style.window_padding[0] && dc.cursor_x > dc.cursor_start_x) {
        gmui_new_line();
    }
    
    var slider_x = dc.cursor_x + text_size[0] + style.slider_spacing;
    var slider_y = dc.cursor_y;
    
    // Calculate track bounds
    var track_y = slider_y + (total_height - style.slider_track_height) / 2;
    
    // Calculate normalized value position
    var normalized_value = (value - min_value) / (max_value - min_value);
    normalized_value = clamp(normalized_value, 0, 1);
    
    // Calculate handle position
    var handle_x = slider_x + (slider_width - style.slider_handle_width) * normalized_value;
    var handle_y = track_y + (style.slider_track_height - style.slider_handle_height) / 2;
    
    // Draw label
    var text_y = dc.cursor_y + (total_height - text_size[1]) / 2;
    gmui_add_text(dc.cursor_x, text_y, label, style.slider_text_disabled_color);
    
    // Draw disabled track background
    gmui_add_rect(slider_x, track_y, slider_width, style.slider_track_height, make_color_rgb(50, 50, 50));
    
    // Draw disabled track fill (partial)
    var fill_width = (handle_x - slider_x) + style.slider_handle_width / 2;
    gmui_add_rect(slider_x, track_y, fill_width, style.slider_track_height, make_color_rgb(80, 80, 80));
    
    // Draw track border
    if (style.slider_track_border_size > 0) {
        gmui_add_rect_outline(slider_x, track_y, slider_width, style.slider_track_height, make_color_rgb(70, 70, 70), style.slider_track_border_size);
    }
    
    // Draw disabled handle
    gmui_add_rect(handle_x, handle_y, style.slider_handle_width, style.slider_handle_height, style.slider_handle_disabled_bg_color);
    
    if (style.slider_handle_border_size > 0) {
        gmui_add_rect_outline(handle_x, handle_y, style.slider_handle_width, style.slider_handle_height, style.slider_handle_disabled_border_color, style.slider_handle_border_size);
    }
    
    // Update cursor position
    dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x += total_width + style.item_spacing[0];
    dc.line_height = max(dc.line_height, total_height);
    
    gmui_new_line();
    
    return value;
}

function gmui_textbox_get_cursor_pos_from_x(text, x) {
    var len = string_length(text);
    var current_width = 0;
    for (var i = 1; i <= len; i++) {
        var char = string_char_at(text, i);
        var char_width = string_width(char);
        if (current_width + char_width / 2 > x) {
            return i - 1;
        }
        current_width += char_width;
    }
    return len;
}

function gmui_textbox(text, placeholder = "", width = -1) {
    if (!global.gmui.initialized || !global.gmui.current_window) return text;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
    
    // Calculate textbox size
    var text_size = gmui_calc_text_size("W"); // Use 'W' as reference for height
    var textbox_height = text_size[1] + style.textbox_padding[1] * 2;
    var textbox_width = (width > 0) ? width : 200; // Default width
    
    // Check if textbox fits on current line
    if (dc.cursor_x + textbox_width > window.width - style.window_padding[0] && dc.cursor_x > dc.cursor_start_x) {
        gmui_new_line();
    }
    
    // Calculate textbox bounds
    var textbox_x = dc.cursor_x;
    var textbox_y = dc.cursor_y;
    var textbox_bounds = [textbox_x, textbox_y, textbox_x + textbox_width, textbox_y + textbox_height];
    
    // Create a unique ID for this textbox
    var textbox_id = "textbox_" + string(window.x) + "_" + string(window.y) + "_" + string(dc.cursor_x) + "_" + string(dc.cursor_y);
	global.gmui.textbox_id = textbox_id;
    
    // Check for mouse interaction
	var mouse_over = gmui_is_mouse_over_window(window) && 
	                 gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, 
	                                     global.gmui.mouse_pos[1] - window.y, 
	                                     textbox_bounds) && !global.gmui.is_hovering_element;

	var clicked = false;
	var changed = false;
	var is_focused = (global.gmui.active_textbox != undefined && global.gmui.active_textbox.id == textbox_id);

	if (mouse_over && window.active) {
		global.gmui.is_hovering_element = true;
	    // Handle mouse press to set cursor position
	    if (global.gmui.mouse_clicked[0]) {
	        clicked = true;
        
	        // Set focus to this textbox
	        global.gmui.active_textbox = {
	            id: textbox_id,
	            text: text,
	            cursor_pos: string_length(text),
	            selection_start: 0,
	            selection_length: 0,
	            changed: false,
	            drag_start_pos: 0,  // Add this for drag tracking
				is_digit_only: false, 
				is_integer_only: false
	        };
	        is_focused = true;
        
	        // Set cursor position based on click
	        var click_x = global.gmui.mouse_pos[0] - window.x - (textbox_x + style.textbox_padding[0]);
	        textbox_set_cursor_from_click(global.gmui.active_textbox, click_x);
        
	        // Reset selection on click
	        global.gmui.active_textbox.selection_start = global.gmui.active_textbox.cursor_pos;
	        global.gmui.active_textbox.selection_length = 0;
	        global.gmui.active_textbox.drag_start_pos = global.gmui.active_textbox.cursor_pos;
	    }
    
	    // Handle text selection with mouse drag
	    if (is_focused && global.gmui.mouse_down[0]) {
	        var drag_x = global.gmui.mouse_pos[0] - window.x - (textbox_x + style.textbox_padding[0]);
        
	        // Only start dragging after initial click
	        if (global.gmui.mouse_down[0] && !global.gmui.mouse_clicked[0]) {
	            textbox_handle_mouse_drag(global.gmui.active_textbox, drag_x);
	        }
	    }
	}

	// Handle focus loss when clicking outside
	if (global.gmui.mouse_clicked[0] && !mouse_over && is_focused) {
	    global.gmui.active_textbox = undefined;
	    is_focused = false;
	}
    
    // Update text if this textbox is focused and changed
    if (is_focused) {
        if (global.gmui.active_textbox.changed) {
            text = global.gmui.active_textbox.text;
            changed = true;
        }
    }
    
    // Draw textbox background
    var bg_color = style.textbox_bg_color;
    var border_color = is_focused ? style.textbox_focused_border_color : style.textbox_border_color;
    
    gmui_add_rect(textbox_x, textbox_y, textbox_width, textbox_height, bg_color);
    
    // Draw border
    if (style.textbox_border_size > 0) {
        gmui_add_rect_outline(textbox_x, textbox_y, textbox_width, textbox_height, 
                            border_color, style.textbox_border_size);
    }
    
    // Create a surface for text clipping
    var text_surface = -1;
    var text_area_width = textbox_width - style.textbox_padding[0] * 2;
    
    if (surface_exists(window.surface)) {
        text_surface = surface_create(text_area_width, text_size[1]);
        if (surface_exists(text_surface)) {
            surface_set_target(text_surface);
            draw_clear_alpha(c_black, 0);
			var oldBlendMode = gpu_get_blendmode();
			gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_one, bm_inv_src_alpha);
			
			draw_set_color(global.gmui.style.textbox_bg_color);
			draw_rectangle(0, 0, textbox_width, textbox_height, false); // neccessary for text and background blending
            
            var old_font = draw_get_font();
            draw_set_font(global.gmui.font);
            
            // Draw text or placeholder
            if (text == "" && placeholder != "" && !is_focused) {
                draw_set_color(style.textbox_placeholder_color);
                draw_text(0, 0, placeholder);
            } else if (text != "" || is_focused) {
                // Handle text display with cursor and selection
                var display_text = text;
                
                // Draw selection if any
                if (is_focused && global.gmui.active_textbox.selection_length > 0) {
                    var sel_start = global.gmui.active_textbox.selection_start;
                    var sel_length = global.gmui.active_textbox.selection_length;
                    
                    var prefix_text = string_copy(display_text, 1, sel_start);
                    var selected_text = string_copy(display_text, sel_start + 1, sel_length);
                    
                    var prefix_width = string_width(prefix_text);
                    var selected_width = string_width(selected_text);
                    
                    draw_set_color(style.textbox_selection_color);
                    draw_rectangle(prefix_width, 0, prefix_width + selected_width, text_size[1], false);
                }
                
                // Draw text
                draw_set_color(style.textbox_text_color);
                draw_text(0, 0, display_text);
                
                // Draw cursor if focused
                if (is_focused && global.gmui.textbox_cursor_visible) {
                    var cursor_prefix = string_copy(display_text, 1, global.gmui.active_textbox.cursor_pos);
                    var cursor_x = string_width(cursor_prefix);
                    
                    draw_set_color(style.textbox_cursor_color);
                    //draw_rectangle(cursor_x, 0, cursor_x + style.textbox_cursor_width, text_size[1], false);
					draw_set_alpha((sin(current_time / 200) * 0.5 + 0.5) * 0.8 + 0.2);
					draw_line_width(cursor_x, 0, cursor_x, text_size[1], style.textbox_cursor_width);
					draw_set_alpha(1);
                }
            }
            
			gpu_set_blendmode(oldBlendMode);
            draw_set_font(old_font);
            surface_reset_target();
        }
    }
    
    // Draw the text surface
    if (surface_exists(text_surface)) {
        // Add surface to draw list
        array_push(window.draw_list, {
            type: "surface",
            surface: text_surface,
            x: textbox_x + style.textbox_padding[0],
            y: textbox_y + style.textbox_padding[1]
        });
    }
    
    // Update cursor position
    dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x += textbox_width + style.item_spacing[0];
    dc.line_height = max(dc.line_height, textbox_height);
    
    gmui_new_line();
    
    return text;
}

function gmui_textbox_id() {
	return global.gmui.textbox_id;
};

function textbox_set_cursor_from_click(textbox, click_x) {
    var text = textbox.text;
    var len = string_length(text);
    
    if (len == 0 || click_x <= 0) {
        textbox.cursor_pos = 0;
        return;
    }
    
    var total_width = string_width(text);
    if (click_x >= total_width) {
        textbox.cursor_pos = len;
        return;
    }
    
    var low = 0;
    var high = len;
    var best_pos = len;
    var best_dist = abs(click_x - total_width);
    
    while (low <= high) {
        var mid = (low + high) div 2;
        var prefix = string_copy(text, 1, mid);
        var width = string_width(prefix);
        var dist = abs(click_x - width);
        
        if (dist < best_dist) {
            best_dist = dist;
            best_pos = mid;
        }
        
        if (width < click_x) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
    }
    
    textbox.cursor_pos = best_pos;
}

function textbox_handle_mouse_drag(textbox, drag_x) {
    var text = textbox.text;
    var len = string_length(text);
    
    if (drag_x <= 0) {
        textbox.cursor_pos = 0;
    }
    else if (drag_x >= string_width(text)) {
        textbox.cursor_pos = len;
    }
    else {
        var current_width = 0;
        for (var i = 1; i <= len; i++) {
            var char = string_char_at(text, i);
            var char_width = string_width(char);
            
            if (drag_x >= current_width && drag_x <= current_width + char_width) {
                if (drag_x <= current_width + char_width / 2) {
                    textbox.cursor_pos = i - 1;
                } else {
                    textbox.cursor_pos = i;
                }
                break;
            }
            current_width += char_width;
        }
    }
    
    if (textbox.cursor_pos < textbox.drag_start_pos) {
        textbox.selection_start = textbox.cursor_pos;
        textbox.selection_length = textbox.drag_start_pos - textbox.cursor_pos;
    } else {
        textbox.selection_start = textbox.drag_start_pos;
        textbox.selection_length = textbox.cursor_pos - textbox.drag_start_pos;
    }
}

function gmui_is_any_textbox_focused() {
    if (!global.gmui.initialized) return false;
    return global.gmui.active_textbox != undefined;
}

function gmui_get_focused_textbox_id() {
    if (!global.gmui.initialized || global.gmui.active_textbox == undefined) return undefined;
    return global.gmui.active_textbox.id;
}

function gmui_is_textbox_focused(textbox_id) {
    if (!global.gmui.initialized || global.gmui.active_textbox == undefined) return false;
    return global.gmui.active_textbox.id == textbox_id;
}

function gmui_get_focused_textbox_text() {
    if (!global.gmui.initialized || global.gmui.active_textbox == undefined) return "";
    return global.gmui.active_textbox.text;
}

function gmui_clear_textbox_focus() {
    if (!global.gmui.initialized) return;
    global.gmui.active_textbox = undefined;
}

function gmui_input_float(value, step = 1, min_value = -1000000, max_value = 1000000, width = -1, placeholder = "") {
    if (!global.gmui.initialized || !global.gmui.current_window) return value;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
    
    // Calculate textbox size
    var text_size = gmui_calc_text_size("0"); // Use '0' as reference for height
    var textbox_height = text_size[1] + style.drag_textbox_padding[1] * 2;
    var textbox_width = (width > 0) ? width : 120; // Default width
    
    // Check if textbox fits on current line
    if (dc.cursor_x + textbox_width > window.width - style.window_padding[0] && dc.cursor_x > dc.cursor_start_x) {
        gmui_new_line();
    }
    
    // Calculate textbox bounds
    var textbox_x = dc.cursor_x;
    var textbox_y = dc.cursor_y;
    var textbox_bounds = [textbox_x, textbox_y, textbox_x + textbox_width, textbox_y + textbox_height];
    
    // Calculate drag hotzone (right side of textbox)
    var drag_hotzone_x = textbox_x + textbox_width - style.drag_textbox_drag_hotzone_width;
    var drag_hotzone_bounds = [drag_hotzone_x, textbox_y, textbox_x + textbox_width, textbox_y + textbox_height];
    
    // Create a unique ID for this drag textbox
    var drag_textbox_id = "drag_textbox_" + string(window.x) + "_" + string(window.y) + "_" + string(dc.cursor_x) + "_" + string(dc.cursor_y);
    global.gmui.drag_textbox_id = drag_textbox_id;
    
    // Convert value to string for display/editing
    var value_string = string(value);
    
    // Check for mouse interaction
    var mouse_over = gmui_is_mouse_over_window(window) && 
                     gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, 
                                         global.gmui.mouse_pos[1] - window.y, 
                                         textbox_bounds) && !global.gmui.is_hovering_element;

    var mouse_over_drag_zone = gmui_is_mouse_over_window(window) && 
                               gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, 
                                                   global.gmui.mouse_pos[1] - window.y, 
                                                   drag_hotzone_bounds) && !global.gmui.is_hovering_element;

    var clicked = false;
    var is_focused = (global.gmui.active_textbox != undefined && global.gmui.active_textbox.id == drag_textbox_id);
    var is_dragging = (global.gmui.active_drag_textbox == drag_textbox_id);
    var value_changed = false;

    if (mouse_over && window.active) {
        global.gmui.is_hovering_element = true;
        
        // Handle mouse press
        if (global.gmui.mouse_clicked[0]) {
            clicked = true;
            
            if (mouse_over_drag_zone) {
                // Start dragging
                global.gmui.active_drag_textbox = drag_textbox_id;
                global.gmui.drag_textbox_start_value = value;
                global.gmui.drag_textbox_start_mouse_x = global.gmui.mouse_pos[0];
                is_dragging = true;
                
                // Defocus textbox if it was focused
                if (is_focused) {
                    global.gmui.active_textbox = undefined;
                    is_focused = false;
                }
            } else {
                // Set focus to this textbox for editing
                global.gmui.active_textbox = {
                    id: drag_textbox_id,
                    text: value_string,
                    cursor_pos: string_length(value_string),
                    selection_start: 0,
                    selection_length: 0,
                    changed: false,
                    drag_start_pos: 0,
                    is_digit_only: true, // Flag to indicate digit-only input
					is_integer_only: false
                };
                is_focused = true;
                
                // Set cursor position based on click
                var click_x = global.gmui.mouse_pos[0] - window.x - (textbox_x + style.drag_textbox_padding[0]);
                textbox_set_cursor_from_click(global.gmui.active_textbox, click_x);
                
                // Reset selection on click
                global.gmui.active_textbox.selection_start = global.gmui.active_textbox.cursor_pos;
                global.gmui.active_textbox.selection_length = 0;
                global.gmui.active_textbox.drag_start_pos = global.gmui.active_textbox.cursor_pos;
            }
        }
        
        // Handle text selection with mouse drag (only when focused and not in drag zone)
        if (is_focused && global.gmui.mouse_down[0] && !mouse_over_drag_zone) {
            var drag_x = global.gmui.mouse_pos[0] - window.x - (textbox_x + style.drag_textbox_padding[0]);
            
            // Only start dragging after initial click
            if (global.gmui.mouse_down[0] && !global.gmui.mouse_clicked[0]) {
                textbox_handle_mouse_drag(global.gmui.active_textbox, drag_x);
            }
        }
    }

    // Handle focus loss when clicking outside
    if (global.gmui.mouse_clicked[0] && !mouse_over && is_focused) {
        global.gmui.active_textbox = undefined;
        is_focused = false;
    }
    
    // Handle dragging
    if (is_dragging && global.gmui.mouse_down[0]) {
        var mouse_delta_x = global.gmui.mouse_pos[0] - global.gmui.drag_textbox_start_mouse_x;
        var value_delta = mouse_delta_x * style.drag_textbox_drag_sensitivity * step;
        
        var new_value = global.gmui.drag_textbox_start_value + value_delta;
        
        // Apply step snapping
        if (step != 0) {
            new_value = (new_value / step) * step; // round
        }
        
        // Clamp to min/max
        new_value = clamp(new_value, min_value, max_value);
        
        if (new_value != value) {
            value = new_value;
            value_string = string(value);
            value_changed = true;
        }
        
        // Update cursor to show dragging
        window_set_cursor(cr_size_we);
    } else if (is_dragging && global.gmui.mouse_released[0]) {
        // Stop dragging
        global.gmui.active_drag_textbox = undefined;
        is_dragging = false;
    }
    
    // Update value if this textbox is focused and changed
    if (is_focused) {
        if (global.gmui.active_textbox.changed) {
            // Filter to only allow digits, minus sign, and decimal point
            var filtered_text = "";
            var has_decimal = false;
            var has_minus = false;
            
            for (var i = 1; i <= string_length(global.gmui.active_textbox.text); i++) {
                var char = string_char_at(global.gmui.active_textbox.text, i);
                var byte = string_byte_at(char, 1);
                
                if (byte >= 48 && byte <= 57) { // 0-9
                    filtered_text += char;
                } else if (char == "-" && !has_minus && i == 1) { // Minus sign only at start
                    filtered_text += char;
                    has_minus = true;
                } else if (char == "." && !has_decimal) { // Decimal point only once
                    filtered_text += char;
                    has_decimal = true;
                }
            }
            
            global.gmui.active_textbox.text = filtered_text;
            global.gmui.active_textbox.changed = false;
            
            // Convert back to number if not empty
            if (filtered_text != "" && filtered_text != "-" && filtered_text != ".") {
                var new_num = real(filtered_text);
                if (new_num != value) {
                    value = clamp(new_num, min_value, max_value);
                    value_string = string(value);
                    value_changed = true;
                }
            }
        }
    }
    
    // Draw textbox background
    var bg_color = style.drag_textbox_bg_color;
    var border_color = is_focused ? style.drag_textbox_focused_border_color : 
                      (is_dragging ? style.drag_textbox_drag_color : style.drag_textbox_border_color);
    
    // Highlight drag zone on hover
    if (mouse_over_drag_zone && !is_focused && !is_dragging) {
        bg_color = make_color_rgb(60, 60, 60);
    }
    
    gmui_add_rect(textbox_x, textbox_y, textbox_width, textbox_height, bg_color);
    
    // Draw border
    if (style.drag_textbox_border_size > 0) {
        gmui_add_rect_outline(textbox_x, textbox_y, textbox_width, textbox_height, 
                            border_color, style.drag_textbox_border_size);
    }
    
    // Draw drag zone indicator (vertical line or dots)
    if (!is_focused) {
        var indicator_x = drag_hotzone_x;
        var indicator_color = is_dragging ? style.drag_textbox_drag_color : 
                             (mouse_over_drag_zone ? make_color_rgb(150, 150, 150) : make_color_rgb(100, 100, 100));
        
        // Draw vertical line
        gmui_add_line(indicator_x, textbox_y + 4, indicator_x, textbox_y + textbox_height - 4, 
                     indicator_color, 1);
        
        // Draw dots to indicate drag area
        var dot_spacing = 3;
        var dot_y = textbox_y + (textbox_height / 2) - 3;
        for (var i = 0; i < 3; i++) {
            gmui_add_rect(indicator_x + 2, dot_y + i * dot_spacing, 1, 1, indicator_color);
        }
    }
    
    // Create a surface for text clipping
    var text_surface = -1;
    var text_area_width = textbox_width - style.drag_textbox_padding[0] * 2 - style.drag_textbox_drag_hotzone_width;
    
    if (surface_exists(window.surface)) {
        text_surface = surface_create(text_area_width, text_size[1]);
        if (surface_exists(text_surface)) {
            surface_set_target(text_surface);
            draw_clear_alpha(c_black, 0);
            var oldBlendMode = gpu_get_blendmode();
            gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_one, bm_inv_src_alpha);
            
            draw_set_color(style.drag_textbox_bg_color);
            draw_rectangle(0, 0, textbox_width, textbox_height, false);
            
            var old_font = draw_get_font();
            draw_set_font(global.gmui.font);
            
            // Draw text or placeholder
            if (value_string == "" && placeholder != "" && !is_focused) {
                draw_set_color(style.drag_textbox_placeholder_color);
                draw_text(0, 0, placeholder);
            } else if (value_string != "" || is_focused) {
                // Handle text display with cursor and selection
                var display_text = is_focused ? global.gmui.active_textbox.text : value_string;
                
                // Draw selection if any
                if (is_focused && global.gmui.active_textbox.selection_length > 0) {
                    var sel_start = global.gmui.active_textbox.selection_start;
                    var sel_length = global.gmui.active_textbox.selection_length;
                    
                    var prefix_text = string_copy(display_text, 1, sel_start);
                    var selected_text = string_copy(display_text, sel_start + 1, sel_length);
                    
                    var prefix_width = string_width(prefix_text);
                    var selected_width = string_width(selected_text);
                    
                    draw_set_color(style.drag_textbox_selection_color);
                    draw_rectangle(prefix_width, 0, prefix_width + selected_width, text_size[1], false);
                }
                
                // Draw text
                draw_set_color(style.drag_textbox_text_color);
                draw_text(0, 0, display_text);
                
                // Draw cursor if focused
                if (is_focused && global.gmui.textbox_cursor_visible) {
                    var cursor_prefix = string_copy(display_text, 1, global.gmui.active_textbox.cursor_pos);
                    var cursor_x = string_width(cursor_prefix);
                    
                    draw_set_color(style.drag_textbox_cursor_color);
                    draw_set_alpha((sin(current_time / 200) * 0.5 + 0.5) * 0.3 + 0.7);
                    draw_line_width(cursor_x, 0, cursor_x, text_size[1], style.drag_textbox_cursor_width);
                    draw_set_alpha(1);
                }
            }
            
            gpu_set_blendmode(oldBlendMode);
            draw_set_font(old_font);
            surface_reset_target();
        }
    }
    
    // Draw the text surface
    if (surface_exists(text_surface)) {
        array_push(window.draw_list, {
            type: "surface",
            surface: text_surface,
            x: textbox_x + style.drag_textbox_padding[0],
            y: textbox_y + style.drag_textbox_padding[1]
        });
    }
    
    // Update cursor position
    dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x += textbox_width + style.item_spacing[0];
    dc.line_height = max(dc.line_height, textbox_height);
    
    gmui_new_line();
    
    return value;
}

function gmui_input_int(value, step = 1, min_value = -1000000, max_value = 1000000, width = -1, placeholder = "") {
    if (!global.gmui.initialized || !global.gmui.current_window) return value;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
    
    // Calculate textbox size
    var text_size = gmui_calc_text_size("0");
    var textbox_height = text_size[1] + style.drag_textbox_padding[1] * 2;
    var textbox_width = (width > 0) ? width : 120;
    
    //if (dc.cursor_x + textbox_width > window.width - style.window_padding[0] && dc.cursor_x > dc.cursor_start_x) {
    //    gmui_new_line();
    //}
    
    var textbox_x = dc.cursor_x;
    var textbox_y = dc.cursor_y;
    var textbox_bounds = [textbox_x, textbox_y, textbox_x + textbox_width, textbox_y + textbox_height];
    
    var drag_hotzone_x = textbox_x + textbox_width - style.drag_textbox_drag_hotzone_width;
    var drag_hotzone_bounds = [drag_hotzone_x, textbox_y, textbox_x + textbox_width, textbox_y + textbox_height];
    
    var drag_textbox_id = "drag_int_" + string(window.x) + "_" + string(window.y) + "_" + string(dc.cursor_x) + "_" + string(dc.cursor_y);
    global.gmui.drag_textbox_id = drag_textbox_id;
    
    var value_string = string(floor(value)); // Ensure integer
    
    var mouse_over = gmui_is_mouse_over_window(window) && 
                     gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, 
                                         global.gmui.mouse_pos[1] - window.y, 
                                         textbox_bounds) && !global.gmui.is_hovering_element;

    var mouse_over_drag_zone = gmui_is_mouse_over_window(window) && 
                               gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, 
                                                   global.gmui.mouse_pos[1] - window.y, 
                                                   drag_hotzone_bounds) && !global.gmui.is_hovering_element;

    var clicked = false;
    var is_focused = (global.gmui.active_textbox != undefined && global.gmui.active_textbox.id == drag_textbox_id);
    var is_dragging = (global.gmui.active_drag_textbox == drag_textbox_id);
    var value_changed = false;

    if (mouse_over && window.active) {
        global.gmui.is_hovering_element = true;
        
        if (global.gmui.mouse_clicked[0]) {
            clicked = true;
            
            if (mouse_over_drag_zone) {
                global.gmui.active_drag_textbox = drag_textbox_id;
                global.gmui.drag_textbox_start_value = value;
                global.gmui.drag_textbox_start_mouse_x = global.gmui.mouse_pos[0];
                is_dragging = true;
                
                if (is_focused) {
                    global.gmui.active_textbox = undefined;
                    is_focused = false;
                }
            } else {
                global.gmui.active_textbox = {
                    id: drag_textbox_id,
                    text: value_string,
                    cursor_pos: string_length(value_string),
                    selection_start: 0,
                    selection_length: 0,
                    changed: false,
                    drag_start_pos: 0,
                    is_digit_only: true,
                    is_integer_only: true // Additional flag for integer-only
                };
                is_focused = true;
                
                var click_x = global.gmui.mouse_pos[0] - window.x - (textbox_x + style.drag_textbox_padding[0]);
                textbox_set_cursor_from_click(global.gmui.active_textbox, click_x);
                
                global.gmui.active_textbox.selection_start = global.gmui.active_textbox.cursor_pos;
                global.gmui.active_textbox.selection_length = 0;
                global.gmui.active_textbox.drag_start_pos = global.gmui.active_textbox.cursor_pos;
            }
        }
        
        if (is_focused && global.gmui.mouse_down[0] && !mouse_over_drag_zone) {
            var drag_x = global.gmui.mouse_pos[0] - window.x - (textbox_x + style.drag_textbox_padding[0]);
            
            if (global.gmui.mouse_down[0] && !global.gmui.mouse_clicked[0]) {
                textbox_handle_mouse_drag(global.gmui.active_textbox, drag_x);
            }
        }
    }

    if (global.gmui.mouse_clicked[0] && !mouse_over && is_focused) {
        global.gmui.active_textbox = undefined;
        is_focused = false;
    }
    
    if (is_dragging && global.gmui.mouse_down[0]) {
        var mouse_delta_x = global.gmui.mouse_pos[0] - global.gmui.drag_textbox_start_mouse_x;
        var value_delta = round(mouse_delta_x * style.drag_textbox_drag_sensitivity * step);
        
        var new_value = global.gmui.drag_textbox_start_value + value_delta;
        new_value = clamp(new_value, min_value, max_value);
        
        if (new_value != value) {
            value = new_value;
            value_string = string(value);
            value_changed = true;
        }
        
        window_set_cursor(cr_size_we);
    } else if (is_dragging && global.gmui.mouse_released[0]) {
        global.gmui.active_drag_textbox = undefined;
        is_dragging = false;
    }
    
    if (is_focused) {
        if (global.gmui.active_textbox.changed) {
            // Filter to only allow digits and minus sign (no decimals for integers)
            var filtered_text = "";
            var has_minus = false;
            
            for (var i = 1; i <= string_length(global.gmui.active_textbox.text); i++) {
                var char = string_char_at(global.gmui.active_textbox.text, i);
                var byte = string_byte_at(char, 1);
                
                if (byte >= 48 && byte <= 57) { // 0-9
                    filtered_text += char;
                } else if (char == "-" && !has_minus && i == 1) { // Minus sign only at start
                    filtered_text += char;
                    has_minus = true;
                }
            }
            
            global.gmui.active_textbox.text = filtered_text;
            global.gmui.active_textbox.changed = false;
            
            if (filtered_text != "" && filtered_text != "-") {
                var new_num = real(filtered_text);
                if (floor(new_num) != value) {
                    value = clamp(floor(new_num), min_value, max_value);
                    value_string = string(value);
                    value_changed = true;
                }
            }
        }
    }
    
    var bg_color = style.drag_textbox_bg_color;
    var border_color = is_focused ? style.drag_textbox_focused_border_color : 
                      (is_dragging ? style.drag_textbox_drag_color : style.drag_textbox_border_color);
    
    if (mouse_over_drag_zone && !is_focused && !is_dragging) {
        bg_color = make_color_rgb(60, 60, 60);
    }
    
    gmui_add_rect(textbox_x, textbox_y, textbox_width, textbox_height, bg_color);
    
    if (style.drag_textbox_border_size > 0) {
        gmui_add_rect_outline(textbox_x, textbox_y, textbox_width, textbox_height, 
                            border_color, style.drag_textbox_border_size);
    }
    
    if (!is_focused) {
        var indicator_x = drag_hotzone_x;
        var indicator_color = is_dragging ? style.drag_textbox_drag_color : 
                             (mouse_over_drag_zone ? make_color_rgb(150, 150, 150) : make_color_rgb(100, 100, 100));
        
        gmui_add_line(indicator_x, textbox_y + 4, indicator_x, textbox_y + textbox_height - 4, 
                     indicator_color, 1);
        
        var dot_spacing = 3;
        var dot_y = textbox_y + (textbox_height / 2) - 3;
        for (var i = 0; i < 3; i++) {
            gmui_add_rect(indicator_x + 2, dot_y + i * dot_spacing, 1, 1, indicator_color);
        }
    }
    
    var text_surface = -1;
    var text_area_width = textbox_width - style.drag_textbox_padding[0] * 2 - style.drag_textbox_drag_hotzone_width;
    
    if (surface_exists(window.surface)) {
        text_surface = surface_create(text_area_width, text_size[1]);
        if (surface_exists(text_surface)) {
            surface_set_target(text_surface);
            draw_clear_alpha(c_black, 0);
            var oldBlendMode = gpu_get_blendmode();
            gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_one, bm_inv_src_alpha);
            
            draw_set_color(style.drag_textbox_bg_color);
            draw_rectangle(0, 0, textbox_width, textbox_height, false);
            
            var old_font = draw_get_font();
            draw_set_font(global.gmui.font);
            
            if (value_string == "" && placeholder != "" && !is_focused) {
                draw_set_color(style.drag_textbox_placeholder_color);
                draw_text(0, 0, placeholder);
            } else if (value_string != "" || is_focused) {
                var display_text = is_focused ? global.gmui.active_textbox.text : value_string;
                
                if (is_focused && global.gmui.active_textbox.selection_length > 0) {
                    var sel_start = global.gmui.active_textbox.selection_start;
                    var sel_length = global.gmui.active_textbox.selection_length;
                    
                    var prefix_text = string_copy(display_text, 1, sel_start);
                    var selected_text = string_copy(display_text, sel_start + 1, sel_length);
                    
                    var prefix_width = string_width(prefix_text);
                    var selected_width = string_width(selected_text);
                    
                    draw_set_color(style.drag_textbox_selection_color);
                    draw_rectangle(prefix_width, 0, prefix_width + selected_width, text_size[1], false);
                }
                
                draw_set_color(style.drag_textbox_text_color);
                draw_text(0, 0, display_text);
                
                if (is_focused && global.gmui.textbox_cursor_visible) {
                    var cursor_prefix = string_copy(display_text, 1, global.gmui.active_textbox.cursor_pos);
                    var cursor_x = string_width(cursor_prefix);
                    
                    draw_set_color(style.drag_textbox_cursor_color);
                    draw_set_alpha((sin(current_time / 200) * 0.5 + 0.5) * 0.3 + 0.7);
                    draw_line_width(cursor_x, 0, cursor_x, text_size[1], style.drag_textbox_cursor_width);
                    draw_set_alpha(1);
                }
            }
            
            gpu_set_blendmode(oldBlendMode);
            draw_set_font(old_font);
            surface_reset_target();
        }
    }
    
    if (surface_exists(text_surface)) {
        array_push(window.draw_list, {
            type: "surface",
            surface: text_surface,
            x: textbox_x + style.drag_textbox_padding[0],
            y: textbox_y + style.drag_textbox_padding[1]
        });
    }
    
    dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x += textbox_width + style.item_spacing[0];
    dc.line_height = max(dc.line_height, textbox_height);
    
    gmui_new_line();
    
    return value;
}