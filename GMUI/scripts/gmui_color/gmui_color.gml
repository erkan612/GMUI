function gmui_color_button(color_rgba, size = -1) {
    if (!global.gmui.initialized || !global.gmui.current_window) return false;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
	
	var arr_rgba = gmui_color_rgba_to_array(color_rgba);
    
    // Calculate button size
    var button_size = size > 0 ? size : style.color_button_size;
    
    // Calculate button bounds
    var button_x = dc.cursor_x;
    var button_y = dc.cursor_y;
    var button_bounds = [button_x, button_y, button_x + button_size, button_y + button_size];
    
    // Check for mouse interaction
    var mouse_over = gmui_is_mouse_over_window(window) && 
                     gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, 
                                         global.gmui.mouse_pos[1] - window.y, 
                                         button_bounds) && !global.gmui.is_hovering_element;
    
    var clicked = false;
    var is_active = false;
    
    if (mouse_over && window.active) {
        global.gmui.is_hovering_element = true;
        if (global.gmui.mouse_down[0]) {
            is_active = true;
        }
        if (global.gmui.mouse_released[0]) {
            clicked = true;
        }
    }
    
    // Draw checkerboard background for transparency
    gmui_draw_checkerboard_shader(button_x, button_y, button_size, button_size);
    
    // Draw color
    gmui_add_rect_alpha(button_x, button_y, button_size, button_size, make_color_rgb(arr_rgba[0], arr_rgba[1], arr_rgba[2]), arr_rgba[3] / 255);
    
    // Draw border based on state
    var border_color = style.color_button_border_color;
    if (is_active) {
        border_color = style.color_button_active_border_color;
    } else if (mouse_over) {
        border_color = style.color_button_hover_border_color;
    }
    
    if (style.color_button_border_size > 0) {
        gmui_add_rect_outline(button_x, button_y, button_size, button_size, 
                            border_color, style.color_button_border_size);
    }
    
    // Update cursor position
    dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x += button_size + style.item_spacing[0];
    dc.line_height = max(dc.line_height, button_size);
    
    gmui_new_line();
    
    return clicked && window.active;
}

function gmui_color_picker_open(rgba) {
    if (!global.gmui.initialized || !global.gmui.current_window) return rgba;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
	
	var color_id = "color_" + string(dc.cursor_x) + "_" + string(dc.cursor_y);
	
    var color_array = gmui_color_rgba_to_array(rgba);
	
	window.active_color_picker = color_id;
	window.color_picker_value = color_array;
	
	// Convert RGB to HSV for the picker
	var hsv = gmui_rgba_to_hsva(color_array[0], color_array[1], color_array[2], 255);
	window.color_picker_hue = hsv[0];
	window.color_picker_saturation = hsv[1];
	window.color_picker_brightness = hsv[2];
	window.color_picker_alpha = color_array[3];
};

function gmui_color_button_4(label, rgba) {
    if (!global.gmui.initialized || !global.gmui.current_window) return rgba;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
    
    // Create a unique ID for this color editor
    var color_edit_id = "color_edit_4_" + string(dc.cursor_x) + "_" + string(dc.cursor_y);
    
    // Convert color to array
    var color_array = gmui_color_rgba_to_array(rgba);
    
    // If this color editor has an active picker, use the picker's value
    if (window.active_color_picker == color_edit_id) {
        color_array = window.color_picker_value;
        rgba = gmui_array_to_color_rgba(color_array);
    }
    
    // Draw label
	if (label != "") {gmui_text(label); gmui_same_line();};
    
    // Draw color preview button
    var preview_clicked = gmui_color_button(rgba, style.color_button_size);
    
    // If color button clicked, open color picker
    if (preview_clicked) {
        window.active_color_picker = color_edit_id;
        window.color_picker_value = color_array;
        
        // Convert RGB to HSV for the picker
        var hsv = gmui_rgba_to_hsva(color_array[0], color_array[1], color_array[2], 255);
        window.color_picker_hue = hsv[0];
        window.color_picker_saturation = hsv[1];
        window.color_picker_brightness = hsv[2];
        window.color_picker_alpha = color_array[3];
    }
    
    // Convert back to color
    var new_color = gmui_array_to_color_rgba(color_array);
    
    // Update picker value if input fields changed
    if (window.active_color_picker == color_edit_id && new_color != rgba) {
        var new_array = gmui_color_rgba_to_array(new_color);
        window.color_picker_value = new_array;
        
        // Update HSV for picker
        var hsv = gmui_rgba_to_hsva(new_array[0], new_array[1], new_array[2], 255);
        window.color_picker_hue = hsv[0];
        window.color_picker_saturation = hsv[1];
        window.color_picker_brightness = hsv[2];
        window.color_picker_alpha = new_array[3];
    }
    
    gmui_new_line();
    
    return new_color;
}

function gmui_color_edit_4(label, rgba) {
    if (!global.gmui.initialized || !global.gmui.current_window) return rgba;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
    
    // Create a unique ID for this color editor
    var color_edit_id = "color_edit_4_" + string(dc.cursor_x) + "_" + string(dc.cursor_y);
    
    // Convert color to array
    var color_array = gmui_color_rgba_to_array(rgba);
    
    // If this color editor has an active picker, use the picker's value
    if (window.active_color_picker == color_edit_id) {
        color_array = window.color_picker_value;
        rgba = gmui_array_to_color_rgba(color_array);
    }
    
    // Draw label
	if (label != "") {gmui_text(label); gmui_same_line();};
    
    // Draw color preview button
    var preview_clicked = gmui_color_button(rgba, style.color_button_size);
    
    // If color button clicked, open color picker
    if (preview_clicked) {
        window.active_color_picker = color_edit_id;
        window.color_picker_value = color_array;
        
        // Convert RGB to HSV for the picker
        var hsv = gmui_rgba_to_hsva(color_array[0], color_array[1], color_array[2], 255);
        window.color_picker_hue = hsv[0];
        window.color_picker_saturation = hsv[1];
        window.color_picker_brightness = hsv[2];
        window.color_picker_alpha = color_array[3];
    }
    
    // Red channel
    gmui_same_line(); gmui_text("R:"); gmui_same_line();
    var new_r = gmui_input_int(color_array[0], 1, 0, 255, 60);
    color_array[0] = clamp(new_r, 0, 255);
    
    // Green channel
    gmui_same_line(); gmui_text("G:"); gmui_same_line();
    var new_g = gmui_input_int(color_array[1], 1, 0, 255, 60);
    color_array[1] = clamp(new_g, 0, 255);
    
    // Blue channel
    gmui_same_line(); gmui_text("B:"); gmui_same_line();
    var new_b = gmui_input_int(color_array[2], 1, 0, 255, 60);
    color_array[2] = clamp(new_b, 0, 255);
    
    // Alpha channel
    gmui_same_line(); gmui_text("A:"); gmui_same_line();
    var new_a = gmui_input_int(color_array[3], 1, 0, 255, 60);
    color_array[3] = clamp(new_a, 0, 255);
    
    // Convert back to color
    var new_color = gmui_array_to_color_rgba(color_array);
    
    // Update picker value if input fields changed
    if (window.active_color_picker == color_edit_id && new_color != rgba) {
        var new_array = gmui_color_rgba_to_array(new_color);
        window.color_picker_value = new_array;
        
        // Update HSV for picker
        var hsv = gmui_rgba_to_hsva(new_array[0], new_array[1], new_array[2], 255);
        window.color_picker_hue = hsv[0];
        window.color_picker_saturation = hsv[1];
        window.color_picker_brightness = hsv[2];
        window.color_picker_alpha = new_array[3];
    }
    
    gmui_new_line();
    
    return new_color;
}

function gmui_color_picker() {
    if (!global.gmui.initialized || !global.gmui.current_window) return false;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
    
    // If no color picker is active for this window, return
    if (window.active_color_picker == undefined) return false;
    
    // Calculate picker position (centered in window)
    var picker_width = style.color_picker_width;
    var picker_height = style.color_picker_height + style.color_picker_hue_height + 
                       style.color_picker_alpha_height + 0/*style.color_picker_preview_size*/ + 
                       style.color_picker_padding * 4;
    
    var picker_x = 0;
    var picker_y = 0;
    
    // Draw color picker background
    gmui_add_rect(picker_x, picker_y, picker_width, picker_height, style.background_color);
    
    // Draw border
    if (style.color_picker_border_size > 0) {
        gmui_add_rect_outline(picker_x, picker_y, picker_width, picker_height, 
                            style.color_picker_border_color, style.color_picker_border_size);
    }
    
    var current_y = picker_y + style.color_picker_padding;
    
    // Draw saturation/brightness area USING SHADER
    var sb_width = picker_width - style.color_picker_padding * 2;
    var sb_height = style.color_picker_height;
    var sb_x = picker_x + style.color_picker_padding;
    var sb_y = current_y;
    
    gmui_draw_saturation_brightness_shader(sb_x, sb_y, sb_width, sb_height, window.color_picker_hue);
    
    // Draw saturation/brightness cursor
    var cursor_x = sb_x + window.color_picker_saturation * sb_width;
    var cursor_y = sb_y + (1 - window.color_picker_brightness) * sb_height;
    
    // Draw crosshair cursor
    gmui_add_rect_outline(cursor_x - 5, cursor_y, 11, 1, make_color_rgb(255, 255, 255), 1);
    gmui_add_rect_outline(cursor_x, cursor_y - 5, 1, 11, make_color_rgb(255, 255, 255), 1);
    gmui_add_rect_outline(cursor_x - 5, cursor_y, 11, 1, make_color_rgb(0, 0, 0), 1);
    gmui_add_rect_outline(cursor_x, cursor_y - 5, 1, 11, make_color_rgb(0, 0, 0), 1);
    
    current_y += sb_height + style.color_picker_padding;
    
    // Draw hue bar USING SHADER
    var hue_x = sb_x;
    var hue_y = current_y;
    var hue_width = sb_width;
    var hue_height = style.color_picker_hue_height;
    
    gmui_draw_hue_bar_shader(hue_x, hue_y, hue_width, hue_height);
    
    // Draw hue cursor
    var hue_cursor_x = hue_x + window.color_picker_hue * hue_width;
    gmui_add_rect_outline(hue_cursor_x - 2, hue_y - 2, 5, hue_height + 4, make_color_rgb(255, 255, 255), 2);
    
    current_y += hue_height + style.color_picker_padding;
    
    // Draw alpha bar USING SHADER
    var alpha_x = sb_x;
    var alpha_y = current_y;
    var alpha_width = sb_width;
    var alpha_height = style.color_picker_alpha_height;
    
    // Draw checkerboard background
    gmui_draw_checkerboard_shader(alpha_x, alpha_y, alpha_width, alpha_height);
    
    // Draw alpha gradient USING SHADER
    var current_rgb = gmui_hsva_to_rgba(window.color_picker_hue, window.color_picker_saturation, window.color_picker_brightness, 255);
    gmui_draw_alpha_bar_shader(alpha_x, alpha_y, alpha_width, alpha_height, current_rgb);
    
    // Draw alpha cursor
    var alpha_cursor_x = alpha_x + window.color_picker_alpha / 255 * alpha_width;
    gmui_add_rect_outline(alpha_cursor_x - 2, alpha_y - 2, 5, alpha_height + 4, make_color_rgb(255, 255, 255), 2);
    
    current_y += alpha_height + style.color_picker_padding;
    
    // Calculate current RGB color from HSV
    var new_rgb = gmui_hsva_to_rgba(window.color_picker_hue, window.color_picker_saturation, window.color_picker_brightness, 255);
    var new_color = gmui_array_to_color_rgba([new_rgb[0], new_rgb[1], new_rgb[2], window.color_picker_alpha]);
    
    // Update the window's color picker value
    window.color_picker_value = [new_rgb[0], new_rgb[1], new_rgb[2], window.color_picker_alpha];
    
    var color_changed = false;
    
    // Handle interaction
    var mouse_over_picker = gmui_is_mouse_over_window(window) && 
                           gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, 
                                               global.gmui.mouse_pos[1] - window.y, 
                                               [picker_x, picker_y, picker_x + picker_width, picker_y + picker_height]);
    
    // Check for clicks outside picker to close it
    if (global.gmui.mouse_clicked[0] && !mouse_over_picker) {
        window.active_color_picker = undefined;
		global.gmui.to_delete_color_picker = true;
    }
    
    // Handle dragging in color areas
    if (mouse_over_picker && global.gmui.mouse_clicked[0]) {
        var _mouse_x = global.gmui.mouse_pos[0] - window.x;
        var _mouse_y = global.gmui.mouse_pos[1] - window.y;
        
        // Check if clicking in saturation/brightness area
        if (gmui_is_point_in_rect(_mouse_x, _mouse_y, [sb_x, sb_y, sb_x + sb_width, sb_y + sb_height])) {
            window.color_picker_dragging = true;
            window.color_picker_drag_type = 2;
            
            var local_x = clamp((_mouse_x - sb_x) / sb_width, 0, 1);
            var local_y = clamp((_mouse_y - sb_y) / sb_height, 0, 1);
            
            window.color_picker_saturation = local_x;
            window.color_picker_brightness = 1 - local_y;
            color_changed = true;
        }
        // Check if clicking in hue bar
        else if (gmui_is_point_in_rect(_mouse_x, _mouse_y, [hue_x, hue_y, hue_x + hue_width, hue_y + hue_height])) {
            window.color_picker_dragging = true;
            window.color_picker_drag_type = 1;
            
            var local_x = clamp((_mouse_x - hue_x) / hue_width, 0, 1);
            window.color_picker_hue = local_x;
            color_changed = true;
        }
        // Check if clicking in alpha bar
        else if (gmui_is_point_in_rect(_mouse_x, _mouse_y, [alpha_x, alpha_y, alpha_x + alpha_width, alpha_y + alpha_height])) {
            window.color_picker_dragging = true;
            window.color_picker_drag_type = 3;
            
            var local_x = clamp((_mouse_x - alpha_x) / alpha_width * 255, 0, 255);
            window.color_picker_alpha = local_x;
            color_changed = true;
        }
    }
    
    // Handle dragging updates
    if (window.color_picker_dragging && global.gmui.mouse_down[0]) {
        var _mouse_x = global.gmui.mouse_pos[0] - window.x;
        var _mouse_y = global.gmui.mouse_pos[1] - window.y;
        
        switch (window.color_picker_drag_type) {
            case 1: // Hue
                var local_x = clamp((_mouse_x - hue_x) / hue_width, 0, 1);
                window.color_picker_hue = local_x;
                color_changed = true;
                break;
                
            case 2: // Saturation/Brightness
                var local_x = clamp((_mouse_x - sb_x) / sb_width, 0, 1);
                var local_y = clamp((_mouse_y - sb_y) / sb_height, 0, 1);
                
                window.color_picker_saturation = local_x;
                window.color_picker_brightness = 1 - local_y;
                color_changed = true;
                break;
                
            case 3: // Alpha
                var local_x = clamp((_mouse_x - alpha_x) / alpha_width * 255, 0, 255);
                window.color_picker_alpha = local_x;
                color_changed = true;
                break;
        }
    } else {
        window.color_picker_dragging = false;
        window.color_picker_drag_type = 0;
    }
    
    return color_changed;
}

function gmui_draw_hue_bar_shader(x, y, w, h) {
    gmui_add_shader_rect(x, y, w, h, gmui_shader_hue, []);
}

function gmui_draw_saturation_brightness_shader(x, y, w, h, hue) {
    gmui_add_shader_rect(x, y, w, h, gmui_shader_saturation_brightness, [
        { type: "float", name: "u_hue", value: hue }
    ]);
}

function gmui_draw_alpha_bar_shader(x, y, w, h, rgb_color) {
    gmui_add_shader_rect(x, y, w, h, gmui_shader_alpha_gradient, [
        { type: "vec3", name: "u_color", value: [rgb_color[0] / 255, rgb_color[1] / 255, rgb_color[2] / 255] }
    ]);
}

function gmui_draw_checkerboard_shader(x, y, w, h) {
    gmui_add_shader_rect(x, y, w, h, gmui_shader_checkerboard, [
        { type: "vec2", name: "u_size", value: [w, h] }
    ]);
}

function gmui_draw_hue_bar(x, y, width, height) {
    var segment_width = width / 6;
    
    // Red to Yellow
    for (var i = 0; i < segment_width; i++) {
        var ratio = i / segment_width;
        var color = make_color_rgb(255, round(255 * ratio), 0);
        gmui_add_rect(x + i, y, 1, height, color);
    }
    
    // Yellow to Green
    for (var i = 0; i < segment_width; i++) {
        var ratio = i / segment_width;
        var color = make_color_rgb(round(255 * (1 - ratio)), 255, 0);
        gmui_add_rect(x + segment_width + i, y, 1, height, color);
    }
    
    // Green to Cyan
    for (var i = 0; i < segment_width; i++) {
        var ratio = i / segment_width;
        var color = make_color_rgb(0, 255, round(255 * ratio));
        gmui_add_rect(x + segment_width * 2 + i, y, 1, height, color);
    }
    
    // Cyan to Blue
    for (var i = 0; i < segment_width; i++) {
        var ratio = i / segment_width;
        var color = make_color_rgb(0, round(255 * (1 - ratio)), 255);
        gmui_add_rect(x + segment_width * 3 + i, y, 1, height, color);
    }
    
    // Blue to Magenta
    for (var i = 0; i < segment_width; i++) {
        var ratio = i / segment_width;
        var color = make_color_rgb(round(255 * ratio), 0, 255);
        gmui_add_rect(x + segment_width * 4 + i, y, 1, height, color);
    }
    
    // Magenta to Red
    for (var i = 0; i < segment_width; i++) {
        var ratio = i / segment_width;
        var color = make_color_rgb(255, 0, round(255 * (1 - ratio)));
        gmui_add_rect(x + segment_width * 5 + i, y, 1, height, color);
    }
}

function gmui_draw_saturation_brightness_area(x, y, width, height, hue) {
    // Draw saturation/brightness gradient
    for (var sy = 0; sy < height; sy++) {
        var brightness = 1 - (sy / height);
        
        for (var sx = 0; sx < width; sx++) {
            var saturation = sx / width;
            var rgb = gmui_hsva_to_rgba(hue, saturation, brightness, 255);
            var color = make_color_rgb(
                round(rgb[0] * 255),
                round(rgb[1] * 255),
                round(rgb[2] * 255)
            );
            gmui_add_rect(x + sx, y + sy, 1, 1, color);
        }
    }
}

function gmui_draw_alpha_bar(x, y, width, height, rgb_color) {
    // Draw checkerboard background for transparency
    var checker_size = 4;
    for (var i = 0; i < width; i += checker_size * 2) {
        for (var j = 0; j < height; j += checker_size * 2) {
            // Draw checkerboard pattern
            gmui_add_rect(x + i, y + j, checker_size, checker_size, make_color_rgb(120, 120, 120));
            gmui_add_rect(x + i + checker_size, y + j + checker_size, checker_size, checker_size, make_color_rgb(120, 120, 120));
            gmui_add_rect(x + i + checker_size, y + j, checker_size, checker_size, make_color_rgb(80, 80, 80));
            gmui_add_rect(x + i, y + j + checker_size, checker_size, checker_size, make_color_rgb(80, 80, 80));
        }
    }
    
    // Draw alpha gradient
    for (var i = 0; i < width; i++) {
        var alpha = i / width;
        var color = gmui_make_color_rgba(
            round(rgb_color[0] * 255),
            round(rgb_color[1] * 255),
            round(rgb_color[2] * 255),
            round(alpha * 255)
        );
        gmui_add_rect(x + i, y, 1, height, color);
    }
}