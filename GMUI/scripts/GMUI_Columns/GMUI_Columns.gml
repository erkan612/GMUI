

// COLUMNS
function gmui_begin_columns(count, ratios = undefined, height = 200) {
    var gmui   = global.gmui;
    var parent = gmui.current_container;

    gmui_container_cursor_advance(parent);

    var col_idx = parent.context.columns_counter;
    parent.context.columns_counter++;
    var state_key = "__col_" + string(col_idx);

    if (!ds_map_exists(parent.state, state_key)) {
        var init_ratios = array_create(count, 1 / count);
        if (ratios != undefined) {
            var ratio_sum = 0;
            for (var i = 0; i < count; i++) ratio_sum += ratios[i];
            for (var i = 0; i < count; i++) init_ratios[i] = ratios[i] / ratio_sum;
        }
        parent.state[? state_key] = {
            ratios:     init_ratios,
            drag_sep:   -1,
            drag_start: 0,
        };
    }
    var state = parent.state[? state_key];

    var sep_w   = gmui.style.columns_separator_width;
    var avail_w = parent.width - gmui.style.container_padding_h * 2 - sep_w * (count - 1);
	
    if (!variable_struct_exists(gmui, "_col_stack")) gmui[$ "_col_stack"] = [];
	
    var actual_height = height;
    if (height == -1) {
        actual_height = parent.height - gmui.style.container_padding_v * 2 - parent.context.cursor_y;
    }

    array_push(gmui[$ "_col_stack"], {
        parent:      parent,
        state_key:   state_key,
        state:       state,
        count:       count,
        avail_w:     avail_w,
        sep_w:       sep_w,
        height:      actual_height,
        origin_x:    parent.context.cursor_x,
        origin_y:    parent.context.cursor_y,
        current_col: -1,
    });
}

function gmui_set_column(idx) {
    var gmui  = global.gmui;
    var frame = gmui[$ "_col_stack"][array_length(gmui[$ "_col_stack"]) - 1];
    var state = frame.state;
    var sep_w = frame.sep_w;

    if (frame.current_col >= 0) {
        frame.parent.context.ignore_cursor_advance_once = true;
        gmui_end_container();
    }
    frame.current_col = idx;

    var x_off = frame.origin_x;
    for (var i = 0; i < idx; i++) {
        x_off += floor(frame.avail_w * state.ratios[i]) + sep_w;
    }
    var col_w = (idx == frame.count - 1)
        ? (frame.origin_x + frame.avail_w + sep_w * (frame.count - 1)) - x_off
        : floor(frame.avail_w * state.ratios[idx]);

    frame.parent.context.cursor_x = x_off;
    frame.parent.context.cursor_y = frame.origin_y;
    frame.parent.context.new_line_requested = false;
    frame.parent.context.ignore_cursor_advance_once = true;

    gmui.current_container = frame.parent;
	var col = gmui_container_get("_col_" + frame.state_key + "_" + string(idx), gmui.current_container);
	if (!col.initialized) {
		col.background_enabled = false;
	    col.use_surface        = false;
	    col.use_scissor        = true;
	    col.scrolling_enabled  = true;
	}
    gmui_begin_container("_col_" + frame.state_key + "_" + string(idx), 0, 0, col_w, frame.height);
	//global.gmui.current_container.context.cursor_x = 0;
	//global.gmui.current_container.context.cursor_y = 0;
}

function gmui_end_columns(resize_enabled = true) {
    var gmui  = global.gmui;
    var stack = gmui[$ "_col_stack"];
    var frame = stack[array_length(stack) - 1];
    array_pop(stack);

    var state = frame.state;
    var style = global.gmui.style;
    var input = gmui.input;
    var sep_w = frame.sep_w;

    if (frame.current_col >= 0) {
        frame.parent.context.ignore_cursor_advance_once = true;
        gmui_end_container();
    }
    gmui.current_container = frame.parent;

    var grab_pad    = style.columns_separator_grab_pad;
    var offset      = gmui_get_container_screen_offset(frame.parent);
    var hovered_sep = -1;
    var x_cursor    = frame.origin_x;

	if (resize_enabled) {
	    for (var i = 0; i < frame.count - 1; i++) {
	        x_cursor += floor(frame.avail_w * state.ratios[i]);
	        var sx = offset[0] + x_cursor - frame.parent.scroll_x;
	        var sy1 = offset[1] + frame.origin_y - frame.parent.scroll_y;
	        var sy2 = sy1 + frame.height;
	        if (point_in_rectangle(input.m_x, input.m_y, sx - grab_pad, sy1, sx + sep_w + grab_pad, sy2) && (frame.parent.parent == undefined
	        ? array_contains(gmui.input.hovered_container_array, frame.parent)
	        : array_contains(gmui.input.hovered_container_array, frame.parent.parent)) && gmui.input.active_widget_id == undefined) {
	            hovered_sep = i;
	            if (input.m_pressed) {
	                state.drag_sep   = i;
	                state.drag_start = input.m_x;
	            }
	        }
	        x_cursor += sep_w;
	    }
	}

    if (state.drag_sep >= 0 && input.m_held) {
        var delta    = (input.m_x - state.drag_start) / frame.avail_w;
        state.drag_start = input.m_x;
        var i        = state.drag_sep;
        var j        = i + 1;
        var min_r    = style.columns_min_ratio;
        var combined = state.ratios[i] + state.ratios[j];
        state.ratios[i] = clamp(state.ratios[i] + delta, min_r, combined - min_r);
        state.ratios[j] = combined - state.ratios[i];
    }
    if (!input.m_held) state.drag_sep = -1;

    x_cursor = frame.origin_x;
    for (var i = 0; i < frame.count - 1; i++) {
        x_cursor += floor(frame.avail_w * state.ratios[i]);
        var col, w;
        if (state.drag_sep == i) {
            col = style.columns_separator_color_active;
            w   = style.columns_separator_width_active;
        } else if (hovered_sep == i) {
            col = style.columns_separator_color_hover;
            w   = style.columns_separator_width_hover;
        } else {
            col = style.columns_separator_color;
            w   = sep_w;
        }
        var draw_x = x_cursor + floor((sep_w - w) / 2);
        gmui_add_rectangle(draw_x, frame.origin_y, draw_x + w, frame.origin_y + frame.height, false, col, 1);
        x_cursor += sep_w;
    }

    frame.parent.context.cursor_x    = style.container_padding_h;
    frame.parent.context.cursor_y    = frame.origin_y + frame.height;
    frame.parent.context.line_height  = 0;
    frame.parent.context.new_line_requested = true;
    frame.parent.content_height = max(frame.parent.content_height, frame.origin_y + frame.height + style.container_padding_v);
}

function gmui_auto_column(rows, column_count, column_ratios = undefined, row_height = 28, show_separators = false, resize_enable = true) {
	gmui_container_cursor_advance();
	
    var columns = [];
	var old_container_padding = global.gmui.style.container_padding_h;
	
	gmui_style_push("container_padding_v", 0);
    
    for (var c = 0; c < column_count; c++) {
        columns[c] = [];
        for (var r = 0; r < array_length(rows); r++) {
            var row = rows[r];
            if (c < array_length(row)) {
                array_push(columns[c], row[c]);
            } else {
                array_push(columns[c], undefined);
            }
        }
    }
    
    var ratios = column_ratios;
    if (ratios == undefined) {
        ratios = [];
        for (var c = 0; c < column_count; c++) {
            array_push(ratios, 1 / column_count);
        }
    }
    
    var total_height = array_length(rows) * row_height + global.gmui.style.container_padding_v * 2;
    
    gmui_begin_columns(column_count, ratios, total_height);
    
    var column_containers = [];
    
    for (var c = 0; c < column_count; c++) {
        gmui_set_column(c);
        
        var col_container = global.gmui.current_container;
        array_push(column_containers, col_container);
        
        var column = columns[c];
        
        for (var r = 0; r < array_length(column); r++) {
            if (r > 0) gmui_newline();
            
            var cell_widgets = column[r];
            if (cell_widgets == undefined) continue;
            
			if (show_separators && r > 0) {
                var sep_y = global.gmui.style.container_padding_v + row_height * r - global.gmui.style.element_spacing_v / 2;
                gmui_add_line(0, sep_y, col_container.width, sep_y, global.gmui.style.separator_color, 1);
            }
			
            for (var w = 0; w < array_length(cell_widgets); w++) {
                if (w > 0) gmui_sameline();
                
                var cell = cell_widgets[w];
                
                var widget_name = "gmui_" + cell.widget;
                var widget_function = real(asset_get_index(widget_name));
                
                if (widget_function < 0) {
                    show_debug_message("auto column: unknown widget - " + widget_name);
                    continue;
                }
                
                var call_params = [];
                if (variable_struct_exists(cell, "params")) {
                    for (var i = 0; i < array_length(cell.params); i++) {
                        array_push(call_params, cell.params[i]);
                    }
                }
				
				gmui_container_cursor_advance();
				gmui_cursor_set_y(global.gmui.style.container_padding_v + row_height * r);
                
                if (variable_struct_exists(cell, "variable_owner") && 
                    variable_struct_exists(cell, "variable_name")) {
                    var current_value = cell.variable_owner[$ cell.variable_name];
                    array_push(call_params, current_value);
                    
                    var result = method_call(widget_function, call_params);
                    cell.variable_owner[$ cell.variable_name] = result;
                } else {
                    method_call(widget_function, call_params);
                }
            }
        }
    }
    
    gmui_end_columns(resize_enable);
	
	gmui_style_pop("container_padding_v");
    
    return column_containers;
}