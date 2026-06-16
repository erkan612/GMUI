

// ROWS
function gmui_begin_rows(count, ratios = undefined, width = 200) {
    var gmui   = global.gmui;
    var parent = gmui.current_container;

    gmui_container_cursor_advance(parent);

    var row_idx = parent.context.rows_counter;
    parent.context.rows_counter++;
    var state_key = "__row_" + string(row_idx);

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

    var sep_h   = gmui.style.rows_separator_height;
    var avail_h = gmui_get_available_height() - sep_h * (count - 1);
	
    if (!variable_struct_exists(gmui, "_row_stack")) gmui[$ "_row_stack"] = [];
	
    var actual_width = width;
    if (width == -1) {
        actual_width = gmui_get_available_width();
    }

    array_push(gmui[$ "_row_stack"], {
        parent:      parent,
        state_key:   state_key,
        state:       state,
        count:       count,
        avail_h:     avail_h,
        sep_h:       sep_h,
        width:       actual_width,
        origin_x:    parent.context.cursor_x,
        origin_y:    parent.context.cursor_y,
        current_row: -1,
    });
	
	return true;
}

function gmui_end_row() {
    var gmui  = global.gmui;
    var frame = gmui[$ "_row_stack"][array_length(gmui[$ "_row_stack"]) - 1];

    frame.parent.context.ignore_cursor_advance_once = true;
    gmui_end_container();
};

function gmui_begin_row(idx, properties = undefined) {
    var gmui  = global.gmui;
    var frame = gmui[$ "_row_stack"][array_length(gmui[$ "_row_stack"]) - 1];
    var state = frame.state;
    var sep_h = frame.sep_h;

    frame.current_row = idx;

    var y_off = frame.origin_y;
    for (var i = 0; i < idx; i++) {
        y_off += floor(frame.avail_h * state.ratios[i]) + sep_h;
    }
    var row_h = (idx == frame.count - 1)
        ? (frame.origin_y + frame.avail_h + sep_h * (frame.count - 1)) - y_off
        : floor(frame.avail_h * state.ratios[idx]);
	
	row_h = round(row_h);

    gmui.current_container = frame.parent;
    var row = gmui_container_get("_row_" + frame.state_key + "_" + string(idx), gmui.current_container);
    if (!row.initialized) {
		var profile_properties = variable_struct_get(global.gmui.profile, "column_row_properties");
		if (profile_properties != undefined) {
			var keys = variable_struct_get_names(profile_properties);
			for (var i = 0; i < array_length(keys); i++) {
				row[$ keys[i]] = profile_properties[$ keys[i]];
			};
		}
		
		if (properties != undefined) {
			var keys = variable_struct_get_names(properties);
			for (var i = 0; i < array_length(keys); i++) {
				row[$ keys[i]] = properties[$ keys[i]];
			};
		}
    }

    frame.parent.context.cursor_x = frame.origin_x;
    frame.parent.context.cursor_y = y_off;
    frame.parent.context.new_line_requested = false;
    frame.parent.context.ignore_cursor_advance_once = true;
	
	return gmui_begin_container("_row_" + frame.state_key + "_" + string(idx), 0, 0, frame.width, row_h);
}

function gmui_end_rows(resize_enabled = true) {
    var gmui  = global.gmui;
    var stack = gmui[$ "_row_stack"];
    var frame = stack[array_length(stack) - 1];
    array_pop(stack);

    var state = frame.state;
    var style = global.gmui.style;
    var input = gmui.input;
    var sep_h = frame.sep_h;

    if (frame.current_row >= 0) {
        frame.parent.context.ignore_cursor_advance_once = true;
        //gmui_end_container();
    }
    gmui.current_container = frame.parent;

    var grab_pad    = style.rows_separator_grab_pad;
    var offset      = gmui_get_container_screen_offset(frame.parent);
    var hovered_sep = -1;
    var y_cursor    = frame.origin_y;

	if (resize_enabled) {
	    for (var i = 0; i < frame.count - 1; i++) {
	        y_cursor += floor(frame.avail_h * state.ratios[i]);
	        var sx1 = offset[0] + frame.origin_x - frame.parent.scroll_x;
	        var sx2 = sx1 + frame.width;
	        var sy = offset[1] + y_cursor - frame.parent.scroll_y;
	        if (point_in_rectangle(input.m_x, input.m_y, sx1, sy - grab_pad, sx2, sy + sep_h + grab_pad) && (frame.parent.parent == undefined
	        ? array_contains(gmui.input.hovered_container_array, frame.parent)
	        : array_contains(gmui.input.hovered_container_array, frame.parent.parent)) && gmui.input.active_widget_id == undefined) {
	            hovered_sep = i;
	            if (input.m_pressed) {
	                state.drag_sep   = i;
	                state.drag_start = input.m_y;
	            }
	        }
	        y_cursor += sep_h;
	    }
	}

    if (state.drag_sep >= 0 && input.m_held) {
        var delta    = (input.m_y - state.drag_start) / frame.avail_h;
        state.drag_start = input.m_y;
        var i        = state.drag_sep;
        var j        = i + 1;
        var min_r    = style.rows_min_ratio;
        var combined = state.ratios[i] + state.ratios[j];
        state.ratios[i] = clamp(state.ratios[i] + delta, min_r, combined - min_r);
        state.ratios[j] = combined - state.ratios[i];
    }
    if (!input.m_held) state.drag_sep = -1;

    y_cursor = frame.origin_y;
    for (var i = 0; i < frame.count - 1; i++) {
        y_cursor += floor(frame.avail_h * state.ratios[i]);
        var col, h;
        if (state.drag_sep == i) {
            col = style.rows_separator_color_active;
            h   = style.rows_separator_height_active;
        } else if (hovered_sep == i) {
            col = style.rows_separator_color_hover;
            h   = style.rows_separator_height_hover;
        } else {
            col = style.rows_separator_color;
            h   = sep_h;
        }
        var draw_y = y_cursor + floor((sep_h - h) / 2);
        gmui_add_rectangle(frame.origin_x, draw_y, frame.origin_x + frame.width, draw_y + h, false, col, 1);
        y_cursor += sep_h;
    }

    frame.parent.context.cursor_x    = frame.origin_x + frame.width;
    frame.parent.context.cursor_y    = style.container_padding_v;
    frame.parent.context.line_height  = 0;
    frame.parent.context.new_line_requested = false;
    //frame.parent.content_width = max(frame.parent.content_width, frame.origin_x + frame.width + style.container_padding_h);
}

function gmui_auto_row(columns, row_count, row_ratios = undefined, col_width = 28, show_separators = false, resize_enable = true) {
    gmui_container_cursor_advance();
    
    var rows = [];
    var old_container_padding = global.gmui.style.container_padding_v;
    
    gmui_style_push("container_padding_h", 0);
    
    for (var r = 0; r < row_count; r++) {
        rows[r] = [];
        for (var c = 0; c < array_length(columns); c++) {
            var col = columns[c];
            if (r < array_length(col)) {
                array_push(rows[r], col[r]);
            } else {
                array_push(rows[r], undefined);
            }
        }
    }
    
    var ratios = row_ratios;
    if (ratios == undefined) {
        ratios = [];
        for (var r = 0; r < row_count; r++) {
            array_push(ratios, 1 / row_count);
        }
    }
    
    var total_width = array_length(columns) * col_width + global.gmui.style.container_padding_h * 2;
    
    var row_containers = [];
    
    if (gmui_begin_rows(row_count, ratios, total_width)) {
	    for (var r = 0; r < row_count; r++) {
	        if (gmui_begin_column(r)) {
				var row_container = global.gmui.current_container;
		        array_push(row_containers, row_container);
        
		        var row = rows[r];
        
		        for (var c = 0; c < array_length(row); c++) {
		            if (c > 0) gmui_sameline();
            
		            var cell_widgets = row[c];
		            if (cell_widgets == undefined) continue;
            
		            if (show_separators && c > 0) {
		                var sep_x = global.gmui.style.container_padding_h + col_width * c - global.gmui.style.element_spacing_h / 2;
		                gmui_add_line(sep_x, 0, sep_x, row_container.height, global.gmui.style.separator_color, 1);
		            }
            
		            for (var w = 0; w < array_length(cell_widgets); w++) {
		                if (w > 0) gmui_newline();
                
		                var cell = cell_widgets[w];
                
		                var widget_name = "gmui_" + cell.widget;
		                var widget_function = real(asset_get_index(widget_name));
                
		                if (widget_function < 0) {
		                    show_debug_message("auto row: unknown widget - " + widget_name);
		                    continue;
		                }
                
		                var call_params = [];
		                if (variable_struct_exists(cell, "params")) {
		                    for (var i = 0; i < array_length(cell.params); i++) {
		                        array_push(call_params, cell.params[i]);
		                    }
		                }
                
		                gmui_container_cursor_advance();
		                gmui_cursor_set_x(global.gmui.style.container_padding_h + col_width * c);
                
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
				gmui_end_column();
			}
			else {
		        array_push(row_containers, undefined); // to keep the array consistent
			}
	    }
    
	    gmui_end_rows(resize_enable);
	}
    
    gmui_style_pop("container_padding_h");
    
    return row_containers;
}