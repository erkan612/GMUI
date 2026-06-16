

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
	var _type = widget.type;
	if (font == - 5) {
		return gmui.style.font;
	}
	else if (font == undefined) {
		return variable_struct_get(gmui.style, "font_" + _type);
	}
	else {
		return font;
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

function _gmui_format_float(val, dec = 4) {
    var text = string_format(val, 1, dec);
    while (string_length(text) > 1 && string_char_at(text, string_length(text)) == "0" && string_pos(".", text) > 0) {
        text = string_copy(text, 1, string_length(text) - 1);
    }
    if (string_char_at(text, string_length(text)) == ".") text = string_copy(text, 1, string_length(text) - 1);
    return text;
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

function gmui_is_widget_hovering_at(widget, x, y) {
	return point_in_rectangle(x, y, widget.screen_x, widget.screen_y, widget.screen_x + widget.width, widget.screen_y + widget.height) && array_contains(global.gmui.input.hovered_container_array, widget.container);
};

function gmui_get_current_container() {
	return global.gmui.current_container;
};

function gmui_append_structure(source, target) {
	if (source == undefined || target == undefined) { return; };
	var names = variable_struct_get_names(target);
	for (var i = 0; i < array_length(names); i++) {
		var name = names[i];
		source[$ name] = target[$ name];
	};
};