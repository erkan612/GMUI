// Treeviews, collapsible headers, selectables
function gmui_selectable(label, selected, width = -1, height = -1) {
    if (!global.gmui.initialized || !global.gmui.current_window) return false;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
    
    // Calculate selectable size
    var text_size = gmui_calc_text_size(label);
    var selectable_width = max(text_size[0] + style.selectable_padding[0] * 2, width > 0 ? width : 0);
    var selectable_height = max(style.selectable_height, height > 0 ? height : 0);
    
    // Use custom size if provided, otherwise use text-based size
    if (width <= 0) selectable_width = text_size[0] + style.selectable_padding[0] * 2;
    if (height <= 0) selectable_height = style.selectable_height;
    
    // Check if selectable fits on current line
    //if (dc.cursor_x + selectable_width > window.width - style.window_padding[0] && dc.cursor_x > dc.cursor_start_x) {
    //    gmui_new_line();
    //}
    
    // Calculate selectable bounds
    var selectable_x = dc.cursor_x;
    var selectable_y = dc.cursor_y;
    var selectable_bounds = [selectable_x, selectable_y, selectable_x + selectable_width, selectable_y + selectable_height];
    
    // Check for mouse interaction
    var mouse_over = gmui_is_mouse_over_window(window) && 
                     gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, global.gmui.mouse_pos[1] - window.y, selectable_bounds) && !global.gmui.is_hovering_element;
    
    var clicked = false;
    var is_active = false;
    
    if (mouse_over && window.active && !global.gmui.is_hovering_element) {
		global.gmui.is_hovering_element = true;
        if (global.gmui.mouse_down[0]) {
            is_active = true;
            clicked = true;
        }
        //if (global.gmui.mouse_released[0]) {
        //    clicked = true;
        //}
    }
    
    // Draw selectable based on state and selection
    var bg_color, border_color, text_color;
    
    if (!window.active) {
        // Window not active - disabled state
        bg_color = style.selectable_disabled_bg_color;
        border_color = style.selectable_disabled_border_color;
        text_color = style.selectable_text_disabled_color;
    } else if (selected) {
        // Selected state
        if (is_active) {
            bg_color = style.selectable_active_bg_color;
            border_color = style.selectable_active_border_color;
        } else if (mouse_over) {
            bg_color = style.selectable_selected_hover_bg_color;
            border_color = style.selectable_selected_hover_border_color;
        } else {
            bg_color = style.selectable_selected_bg_color;
            border_color = style.selectable_selected_border_color;
        }
        text_color = style.selectable_text_selected_color;
    } else {
        // Not selected state
        if (is_active) {
            bg_color = style.selectable_active_bg_color;
            border_color = style.selectable_active_border_color;
        } else if (mouse_over) {
            bg_color = style.selectable_hover_bg_color;
            border_color = style.selectable_hover_border_color;
        } else {
            bg_color = style.selectable_bg_color;
            border_color = style.selectable_border_color;
        }
        text_color = style.selectable_text_color;
    }
    
    // Draw selectable background
    gmui_add_rect(selectable_x, selectable_y, selectable_width, selectable_height, bg_color);
    
    // Draw border
    if (style.selectable_border_size > 0) {
        gmui_add_rect_outline(selectable_x, selectable_y, selectable_width, selectable_height, border_color, style.selectable_border_size);
    }
    
    // Draw text centered
    var text_x = selectable_x + (selectable_width - text_size[0]) / 2;
    var text_y = selectable_y + (selectable_height - text_size[1]) / 2;
    gmui_add_text(text_x, text_y, label, text_color);
    
    // Update cursor position
    dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x += selectable_width + style.item_spacing[0];
    dc.line_height = max(dc.line_height, selectable_height);
    
    gmui_new_line();
    
    return clicked && window.active;
}

function gmui_selectable_disabled(label, selected, width = -1, height = -1) {
    if (!global.gmui.initialized || !global.gmui.current_window) return false;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
    
    // Calculate selectable size
    var text_size = gmui_calc_text_size(label);
    var selectable_width = max(text_size[0] + style.selectable_padding[0] * 2, width > 0 ? width : 0);
    var selectable_height = max(style.selectable_height, height > 0 ? height : 0);
    
    if (width <= 0) selectable_width = text_size[0] + style.selectable_padding[0] * 2;
    if (height <= 0) selectable_height = style.selectable_height;
    
    // Check if selectable fits on current line
    if (dc.cursor_x + selectable_width > window.width - style.window_padding[0] && dc.cursor_x > dc.cursor_start_x) {
        gmui_new_line();
    }
    
    var selectable_x = dc.cursor_x;
    var selectable_y = dc.cursor_y;
    
    // Draw disabled selectable
    var bg_color = style.selectable_disabled_bg_color;
    var border_color = style.selectable_disabled_border_color;
    var text_color = style.selectable_text_disabled_color;
    
    // If selected, use a darker version of selected color
    if (selected) {
        bg_color = make_color_rgb(40, 60, 120); // Darker blue for disabled selected
        text_color = make_color_rgb(180, 180, 180);
    }
    
    gmui_add_rect(selectable_x, selectable_y, selectable_width, selectable_height, bg_color);
    
    if (style.selectable_border_size > 0) {
        gmui_add_rect_outline(selectable_x, selectable_y, selectable_width, selectable_height, border_color, style.selectable_border_size);
    }
    
    // Draw text centered
    var text_x = selectable_x + (selectable_width - text_size[0]) / 2;
    var text_y = selectable_y + (selectable_height - text_size[1]) / 2;
    gmui_add_text(text_x, text_y, label, text_color);
    
    // Update cursor position
    dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x += selectable_width + style.item_spacing[0];
    dc.line_height = max(dc.line_height, selectable_height);
    
    gmui_new_line();
    
    return false; // Disabled selectables never return true
}

function gmui_selectable_small(label, selected) {
    return gmui_selectable(label, selected, -1, 20);
}

function gmui_selectable_large(label, selected) {
    return gmui_selectable(label, selected, -1, 32);
}

function gmui_selectable_width(label, selected, width) {
    return gmui_selectable(label, selected, width, -1);
}

function gmui_treeview_node_id(window, path_array) {
    var _id = window.name + "_";
    for (var i = 0; i < array_length(path_array); i++) {
        _id += string(path_array[i]) + "/";
    }
    return _id;
}

function gmui_treeview_is_node_open(window, path_array) {
    var node_id = gmui_treeview_node_id(window, path_array);
    return ds_map_exists(global.gmui.treeview_open_nodes, node_id) && global.gmui.treeview_open_nodes[? node_id];
}

function gmui_treeview_toggle_node(window, path_array) {
    var node_id = gmui_treeview_node_id(window, path_array);
    if (ds_map_exists(global.gmui.treeview_open_nodes, node_id)) {
        global.gmui.treeview_open_nodes[? node_id] = !global.gmui.treeview_open_nodes[? node_id];
    } else {
        ds_map_add(global.gmui.treeview_open_nodes, node_id, true);
    }
}

function gmui_treeview_set_node_open(window, path_array, open) {
    var node_id = gmui_treeview_node_id(window, path_array);
    if (ds_map_exists(global.gmui.treeview_open_nodes, node_id)) {
        global.gmui.treeview_open_nodes[? node_id] = open;
    } else {
        ds_map_add(global.gmui.treeview_open_nodes, node_id, open);
    }
}

function gmui_treeview_push(window, path_array) {
    array_push(window.treeview_stack, path_array);
}

function gmui_treeview_pop(window) {
    if (array_length(window.treeview_stack) > 0) {
        array_pop(window.treeview_stack);
    }
}

function gmui_treeview_get_depth(window) {
    return array_length(window.treeview_stack);
}

function gmui_treeview_get_current_path(window) {
    if (array_length(window.treeview_stack) == 0) return [];
    
    var current = window.treeview_stack[array_length(window.treeview_stack) - 1];
    var path = [];
    for (var i = 0; i < array_length(current); i++) {
        array_push(path, current[i]);
    }
    return path;
}

function gmui_tree_node(label, selected = false, leaf = false) {
    if (!global.gmui.initialized || !global.gmui.current_window) return [false, false, false];
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
    
    // Get current treeview context
    var current_path = gmui_treeview_get_current_path();
    var node_id = gmui_treeview_node_id(current_path);
    var is_open = gmui_treeview_is_node_open(current_path);
    var _depth = gmui_treeview_get_depth();
    
    // Calculate indent
    var indent = _depth * style.treeview_indent;
    var item_height = style.treeview_item_height;
    
    // Calculate node bounds
    var node_x = dc.cursor_x + indent;
    var node_y = dc.cursor_y;
    var node_width = window.width - style.window_padding[0] * 2 - indent;
    var node_bounds = [node_x, node_y, node_x + node_width, node_y + item_height];
    
    // Check for mouse interaction
    var mouse_over = gmui_is_mouse_over_window(window) && 
                     gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, 
                                         global.gmui.mouse_pos[1] - window.y, 
                                         node_bounds) && !global.gmui.is_hovering_element;
    
    var clicked = false;
    var is_active = false;
    var arrow_clicked = false;
    
    if (mouse_over && window.active && !global.gmui.is_hovering_element) {
		global.gmui.is_hovering_element = true;
        if (global.gmui.mouse_down[0]) {
            is_active = true;
        }
        if (global.gmui.mouse_released[0]) {
            clicked = true;
            
            // Check if click was on arrow (for non-leaf nodes)
            if (!leaf) {
                var arrow_x = node_x + style.treeview_indent - style.treeview_arrow_size - 4;
                var arrow_y = node_y + (item_height - style.treeview_arrow_size) / 2;
                var arrow_bounds = [arrow_x, arrow_y, arrow_x + style.treeview_arrow_size, arrow_y + style.treeview_arrow_size];
                
                if (gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, 
                                        global.gmui.mouse_pos[1] - window.y, 
                                        arrow_bounds)) {
                    arrow_clicked = true;
                    gmui_treeview_toggle_node(current_path);
                    is_open = !is_open;
                }
            }
        }
    }
    
    // Draw node background based on state
    var bg_color, text_color;
    
    if (!window.active) {
        bg_color = style.treeview_bg_color;
        text_color = style.treeview_text_disabled_color;
    } else if (selected) {
        if (is_active) {
            bg_color = style.treeview_active_bg_color;
        } else if (mouse_over) {
            bg_color = style.treeview_selected_hover_bg_color;
        } else {
            bg_color = style.treeview_selected_bg_color;
        }
        text_color = style.treeview_text_selected_color;
    } else {
        if (is_active) {
            bg_color = style.treeview_active_bg_color;
        } else if (mouse_over) {
            bg_color = style.treeview_hover_bg_color;
        } else {
            bg_color = style.treeview_bg_color;
        }
        text_color = style.treeview_text_color;
    }
    
    // Draw node background
    gmui_add_rect(node_x, node_y, node_width, item_height, bg_color);
    
    // Draw arrow for non-leaf nodes
    if (!leaf) {
        var arrow_x = node_x + style.treeview_indent - style.treeview_arrow_size - 4;
        var arrow_y = node_y + (item_height - style.treeview_arrow_size) / 2;
        
        var arrow_color = style.treeview_arrow_color;
        if (mouse_over && window.active) {
            if (is_active) {
                arrow_color = style.treeview_arrow_active_color;
            } else {
                arrow_color = style.treeview_arrow_hover_color;
            }
        }
        
        // Draw arrow (triangle)
        if (is_open) {
            // Down arrow
            var arrow_points = [
                [arrow_x, arrow_y],
                [arrow_x + style.treeview_arrow_size, arrow_y],
                [arrow_x + style.treeview_arrow_size / 2, arrow_y + style.treeview_arrow_size]
            ];
        } else {
            // Right arrow
            var arrow_points = [
                [arrow_x, arrow_y],
                [arrow_x + style.treeview_arrow_size, arrow_y + style.treeview_arrow_size / 2],
                [arrow_x, arrow_y + style.treeview_arrow_size]
            ];
        }
        
        // Draw filled triangle
        gmui_add_triangle(arrow_points[0][0], arrow_points[0][1],
                         arrow_points[1][0], arrow_points[1][1],
                         arrow_points[2][0], arrow_points[2][1],
                         arrow_color);
    }
    
    // Draw label
    var text_size = gmui_calc_text_size(label);
    var text_x = node_x + style.treeview_indent;
    var text_y = node_y + (item_height - text_size[1]) / 2;
    gmui_add_text(text_x, text_y, label, text_color);
    
    // Update cursor position
    dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x = dc.cursor_start_x;
    dc.cursor_y += item_height;
    dc.line_height = max(dc.line_height, item_height);
    
    return [is_open, clicked && !arrow_clicked, selected];
}

function gmui_tree_node_begin(label, selected = false) {
    if (!global.gmui.initialized || !global.gmui.current_window) return false;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
    
    // Get current treeview context
    var current_path = gmui_treeview_get_current_path(window);
    var is_open = gmui_treeview_is_node_open(window, current_path);
    var _depth = gmui_treeview_get_depth(window);
    
    // Calculate indent
    var indent = _depth * style.treeview_indent;
    var item_height = style.treeview_item_height;
    
    // Calculate node bounds
    var node_x = dc.cursor_x + indent;
    var node_y = dc.cursor_y;
    var node_width = window.width - style.window_padding[0] * 2 - indent;
    var node_bounds = [node_x, node_y, node_x + node_width, node_y + item_height];
    
    // Check for mouse interaction
    var mouse_over = gmui_is_mouse_over_window(window) && 
                     gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, 
                                         global.gmui.mouse_pos[1] - window.y, 
                                         node_bounds) && !global.gmui.is_hovering_element;
    
    var clicked = false;
    var is_active = false;
    var arrow_clicked = false;
    
    if (mouse_over && window.active) {
		global.gmui.is_hovering_element = true;
        if (global.gmui.mouse_down[0]) {
            is_active = true;
        }
        if (global.gmui.mouse_released[0]) {
            clicked = true;
            
            // Check if click was on arrow
            var arrow_x = node_x + style.treeview_indent - style.treeview_arrow_size - 4;
            var arrow_y = node_y + (item_height - style.treeview_arrow_size) / 2;
            var arrow_bounds = [arrow_x, arrow_y, arrow_x + style.treeview_arrow_size, arrow_y + style.treeview_arrow_size];
            
            if (gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, 
                                    global.gmui.mouse_pos[1] - window.y, 
                                    arrow_bounds)) {
                arrow_clicked = true;
                gmui_treeview_toggle_node(window, current_path);
                is_open = !is_open;
            }
        }
    }
    
    // Draw node background based on state
    var bg_color, text_color;
    
    if (!window.active) {
        bg_color = style.treeview_bg_color;
        text_color = style.treeview_text_disabled_color;
    } else if (selected) {
        if (is_active) {
            bg_color = style.treeview_active_bg_color;
        } else if (mouse_over) {
            bg_color = style.treeview_selected_hover_bg_color;
        } else {
            bg_color = style.treeview_selected_bg_color;
        }
        text_color = style.treeview_text_selected_color;
    } else {
        if (is_active) {
            bg_color = style.treeview_active_bg_color;
        } else if (mouse_over) {
            bg_color = style.treeview_hover_bg_color;
        } else {
            bg_color = style.treeview_bg_color;
        }
        text_color = style.treeview_text_color;
    }
    
    // Draw node background
    gmui_add_rect(node_x, node_y, node_width, item_height, bg_color);
    
    // Draw arrow
    var arrow_x = node_x + style.treeview_indent - style.treeview_arrow_size - 4;
    var arrow_y = node_y + (item_height - style.treeview_arrow_size) / 2;
    
    var arrow_color = style.treeview_arrow_color;
    if (mouse_over && window.active) {
        if (is_active) {
            arrow_color = style.treeview_arrow_active_color;
        } else {
            arrow_color = style.treeview_arrow_hover_color;
        }
    }
    
    // Draw arrow (triangle)
    if (is_open) {
        // Down arrow
        var arrow_points = [
            [arrow_x, arrow_y],
            [arrow_x + style.treeview_arrow_size, arrow_y],
            [arrow_x + style.treeview_arrow_size / 2, arrow_y + style.treeview_arrow_size]
        ];
    } else {
        // Right arrow
        var arrow_points = [
            [arrow_x, arrow_y],
            [arrow_x + style.treeview_arrow_size, arrow_y + style.treeview_arrow_size / 2],
            [arrow_x, arrow_y + style.treeview_arrow_size]
        ];
    }
    
    // Draw filled triangle
    gmui_add_triangle(arrow_points[0][0], arrow_points[0][1],
                     arrow_points[1][0], arrow_points[1][1],
                     arrow_points[2][0], arrow_points[2][1],
                     arrow_color);
    
    // Draw label
    var text_size = gmui_calc_text_size(label);
    var text_x = node_x + style.treeview_indent;
    var text_y = node_y + (item_height - text_size[1]) / 2;
    gmui_add_text(text_x, text_y, label, text_color);
    
    // Update cursor position
    dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x = dc.cursor_start_x;
    dc.cursor_y += item_height + style.treeview_spacing;
    dc.line_height = max(dc.line_height, item_height);
    
    // Push new context for children
    var new_path = [];
    for (var i = 0; i < array_length(current_path); i++) {
        array_push(new_path, current_path[i]);
    }
    array_push(new_path, label);
    gmui_treeview_push(window, new_path);
    
    return [ is_open, clicked ];
}

function gmui_tree_leaf(label, selected = false) {
    if (!global.gmui.initialized || !global.gmui.current_window) return false;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
    
    var current_path = gmui_treeview_get_current_path(window);
    var _depth = gmui_treeview_get_depth(window);
    
    // Calculate indent
    var indent = _depth * style.treeview_indent;
    var item_height = style.treeview_item_height;
    
    // Calculate node bounds
    var node_x = dc.cursor_x + indent;
    var node_y = dc.cursor_y;
    var node_width = window.width - style.window_padding[0] * 2 - indent;
    var node_bounds = [node_x, node_y, node_x + node_width, node_y + item_height];
    
    // Check for mouse interaction
    var mouse_over = gmui_is_mouse_over_window(window) && 
                     gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, 
                                         global.gmui.mouse_pos[1] - window.y, 
                                         node_bounds) && !global.gmui.is_hovering_element;
    
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
    
    // Draw node background based on state
    var bg_color, text_color;
    
    if (!window.active) {
        bg_color = style.treeview_bg_color;
        text_color = style.treeview_text_disabled_color;
    } else if (selected) {
        if (is_active) {
            bg_color = style.treeview_active_bg_color;
        } else if (mouse_over) {
            bg_color = style.treeview_selected_hover_bg_color;
        } else {
            bg_color = style.treeview_selected_bg_color;
        }
        text_color = style.treeview_text_selected_color;
    } else {
        if (is_active) {
            bg_color = style.treeview_active_bg_color;
        } else if (mouse_over) {
            bg_color = style.treeview_hover_bg_color;
        } else {
            bg_color = style.treeview_bg_color;
        }
        text_color = style.treeview_text_color;
    }
    
    // Draw node background
    gmui_add_rect(node_x, node_y, node_width, item_height, bg_color);
    
    // Draw label (indented to align with parent nodes' labels)
    var text_size = gmui_calc_text_size(label);
    var text_x = node_x + style.treeview_indent;
    var text_y = node_y + (item_height - text_size[1]) / 2;
    gmui_add_text(text_x, text_y, label, text_color);
    
    // Update cursor position
    dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x = dc.cursor_start_x;
    dc.cursor_y += item_height + style.treeview_spacing;
    dc.line_height = max(dc.line_height, item_height);
    
    // NOTE: We don't push/pop for leaf nodes - they don't affect the depth hierarchy
    return clicked && window.active;
}

function gmui_tree_node_end() {
    var window = global.gmui.current_window;
    gmui_treeview_pop(window);
}

function gmui_tree_node_ex(label, selected = false) {
    if (!global.gmui.initialized || !global.gmui.current_window) return [false, false, false];
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
    
    // Get current treeview context
    var current_path = gmui_treeview_get_current_path();
    var node_id = gmui_treeview_node_id(current_path);
    var is_open = gmui_treeview_is_node_open(current_path);
    var _depth = gmui_treeview_get_depth();
    
    // Calculate indent
    var indent = _depth * style.treeview_indent;
    var item_height = style.treeview_item_height;
    
    // Calculate node bounds
    var node_x = dc.cursor_x + indent;
    var node_y = dc.cursor_y;
    var node_width = window.width - style.window_padding[0] * 2 - indent;
    var node_bounds = [node_x, node_y, node_x + node_width, node_y + item_height];
    
    // Check for mouse interaction
    var mouse_over = gmui_is_mouse_over_window(window) && 
                     gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, 
                                         global.gmui.mouse_pos[1] - window.y, 
                                         node_bounds) && !global.gmui.is_hovering_element;
    
    var clicked = false;
    var is_active = false;
    var arrow_clicked = false;
    
    if (mouse_over && window.active) {
		global.gmui.is_hovering_element = true;
        if (global.gmui.mouse_down[0]) {
            is_active = true;
        }
        if (global.gmui.mouse_released[0]) {
            clicked = true;
            
            // Check if click was on arrow
            var arrow_x = node_x + style.treeview_indent - style.treeview_arrow_size - 4;
            var arrow_y = node_y + (item_height - style.treeview_arrow_size) / 2;
            var arrow_bounds = [arrow_x, arrow_y, arrow_x + style.treeview_arrow_size, arrow_y + style.treeview_arrow_size];
            
            if (gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, 
                                    global.gmui.mouse_pos[1] - window.y, 
                                    arrow_bounds)) {
                arrow_clicked = true;
                gmui_treeview_toggle_node(current_path);
                is_open = !is_open;
            }
        }
    }
    
    // Draw node background based on state
    var bg_color, text_color;
    
    if (!window.active) {
        bg_color = style.treeview_bg_color;
        text_color = style.treeview_text_disabled_color;
    } else if (selected) {
        if (is_active) {
            bg_color = style.treeview_active_bg_color;
        } else if (mouse_over) {
            bg_color = style.treeview_selected_hover_bg_color;
        } else {
            bg_color = style.treeview_selected_bg_color;
        }
        text_color = style.treeview_text_selected_color;
    } else {
        if (is_active) {
            bg_color = style.treeview_active_bg_color;
        } else if (mouse_over) {
            bg_color = style.treeview_hover_bg_color;
        } else {
            bg_color = style.treeview_bg_color;
        }
        text_color = style.treeview_text_color;
    }
    
    // Draw node background
    gmui_add_rect(node_x, node_y, node_width, item_height, bg_color);
    
    // Draw arrow
    var arrow_x = node_x + style.treeview_indent - style.treeview_arrow_size - 4;
    var arrow_y = node_y + (item_height - style.treeview_arrow_size) / 2;
    
    var arrow_color = style.treeview_arrow_color;
    if (mouse_over && window.active) {
        if (is_active) {
            arrow_color = style.treeview_arrow_active_color;
        } else {
            arrow_color = style.treeview_arrow_hover_color;
        }
    }
    
    // Draw arrow (triangle)
    if (is_open) {
        // Down arrow
        var arrow_points = [
            [arrow_x, arrow_y],
            [arrow_x + style.treeview_arrow_size, arrow_y],
            [arrow_x + style.treeview_arrow_size / 2, arrow_y + style.treeview_arrow_size]
        ];
    } else {
        // Right arrow
        var arrow_points = [
            [arrow_x, arrow_y],
            [arrow_x + style.treeview_arrow_size, arrow_y + style.treeview_arrow_size / 2],
            [arrow_x, arrow_y + style.treeview_arrow_size]
        ];
    }
    
    // Draw filled triangle
    gmui_add_triangle(arrow_points[0][0], arrow_points[0][1],
                     arrow_points[1][0], arrow_points[1][1],
                     arrow_points[2][0], arrow_points[2][1],
                     arrow_color);
    
    // Draw label
    var text_size = gmui_calc_text_size(label);
    var text_x = node_x + style.treeview_indent;
    var text_y = node_y + (item_height - text_size[1]) / 2;
    gmui_add_text(text_x, text_y, label, text_color);
    
    // Update cursor position
    dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x = dc.cursor_start_x;
    dc.cursor_y += item_height + style.treeview_spacing;
    dc.line_height = max(dc.line_height, item_height);
    
    // Push new context for children
    var new_path = [];
    for (var i = 0; i < array_length(current_path); i++) {
        array_push(new_path, current_path[i]);
    }
    array_push(new_path, label);
    gmui_treeview_push(new_path);
    
    return [is_open, clicked && !arrow_clicked, selected];
}

function gmui_tree_node_reset() {
    if (!global.gmui.initialized || !global.gmui.current_window) return;
    
    var window = global.gmui.current_window;
    // Clear the treeview stack to reset to depth 0
    window.treeview_stack = [];
}

function gmui_collapsing_header(label, is_open) {
    if (!global.gmui.initialized || !global.gmui.current_window) return [is_open, false];
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
    
    // Calculate header size
    var text_size = gmui_calc_text_size(label);
    var header_width = window.width - style.window_padding[0] * 2;
    var header_height = style.collapsible_header_height;
    
    // Calculate header bounds
    var header_x = dc.cursor_x;
    var header_y = dc.cursor_y;
    var header_bounds = [header_x, header_y, header_x + header_width, header_y + header_height];
    
    // Check for mouse interaction
    var mouse_over = gmui_is_mouse_over_window(window) && 
                     gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, 
                                         global.gmui.mouse_pos[1] - window.y, 
                                         header_bounds) && !global.gmui.is_hovering_element;
    
    var clicked = false;
    var is_active = false;
    
    if (mouse_over && window.active) {
		global.gmui.is_hovering_element = true;
        if (global.gmui.mouse_down[0]) {
            is_active = true;
        }
        if (global.gmui.mouse_released[0]) {
            clicked = true;
            is_open = !is_open;
        }
    }
    
    // Draw header based on state
    var bg_color, border_color, text_color, arrow_color;
    
    if (!window.active) {
        bg_color = style.collapsible_header_bg_color;
        border_color = style.collapsible_header_border_color;
        text_color = style.collapsible_header_text_color;
        arrow_color = style.collapsible_header_arrow_color;
    } else if (is_active) {
        bg_color = style.collapsible_header_active_bg_color;
        border_color = style.collapsible_header_border_color;
        text_color = style.collapsible_header_text_color;
        arrow_color = style.collapsible_header_arrow_active_color;
    } else if (mouse_over) {
        bg_color = style.collapsible_header_hover_bg_color;
        border_color = style.collapsible_header_border_color;
        text_color = style.collapsible_header_text_color;
        arrow_color = style.collapsible_header_arrow_hover_color;
    } else {
        bg_color = style.collapsible_header_bg_color;
        border_color = style.collapsible_header_border_color;
        text_color = style.collapsible_header_text_color;
        arrow_color = style.collapsible_header_arrow_color;
    }
    
    // Draw header background
    gmui_add_rect(header_x, header_y, header_width, header_height, bg_color);
    
    // Draw border
    if (style.collapsible_header_border_size > 0) {
        gmui_add_rect_outline(header_x, header_y, header_width, header_height, 
                            border_color, style.collapsible_header_border_size);
    }
    
    // Draw arrow
    var arrow_x = header_x + style.collapsible_header_padding[0];
    var arrow_y = header_y + (header_height - style.collapsible_header_arrow_size) / 2;
    
    // Draw arrow (triangle)
    if (is_open) {
        // Down arrow
        var arrow_points = [
            [arrow_x, arrow_y],
            [arrow_x + style.collapsible_header_arrow_size, arrow_y],
            [arrow_x + style.collapsible_header_arrow_size / 2, arrow_y + style.collapsible_header_arrow_size]
        ];
    } else {
        // Right arrow
        var arrow_points = [
            [arrow_x, arrow_y],
            [arrow_x + style.collapsible_header_arrow_size, arrow_y + style.collapsible_header_arrow_size / 2],
            [arrow_x, arrow_y + style.collapsible_header_arrow_size]
        ];
    }
    
    // Draw filled triangle
    gmui_add_triangle(arrow_points[0][0], arrow_points[0][1],
                     arrow_points[1][0], arrow_points[1][1],
                     arrow_points[2][0], arrow_points[2][1],
                     arrow_color);
    
    // Draw label
    var text_x = arrow_x + style.collapsible_header_arrow_size + style.collapsible_header_padding[0];
    var text_y = header_y + (header_height - text_size[1]) / 2;
    gmui_add_text(text_x, text_y, label, text_color);
    
    // Update cursor position
    dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x = dc.cursor_start_x;
    dc.cursor_y += header_height + style.item_spacing[1];
    dc.line_height = max(dc.line_height, header_height);
    
    // If open, add content padding
    if (is_open) {
        dc.cursor_x += style.collapsible_header_content_padding[0];
        dc.cursor_y += style.collapsible_header_content_padding[1];
    }
    
    return [is_open, clicked];
}

function gmui_collapsing_header_end() {
    if (!global.gmui.initialized || !global.gmui.current_window) return;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
    
    // Remove content padding and move to next line
    dc.cursor_x = dc.cursor_start_x;
    dc.cursor_y += style.collapsible_header_content_padding[1];
    gmui_new_line();
}