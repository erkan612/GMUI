

// WINS
function gmui_begin_wins_space() {
	var gmui = global.gmui;
	var style = gmui.style;
	var container = gmui.current_container;
	container.context.cursor_x -= style.container_padding_h;
	container.context.cursor_y -= style.container_padding_v;
	gmui_style_push_multi({
		container_padding_h: 0,
		container_padding_v: 0,
	});
};

function gmui_end_wins_space() {
	gmui_style_pop_multi([
		"container_padding_h",
		"container_padding_v",
	]);
};

function gmui_begin_wins(name, direction, ratios = undefined, resize_enabled = true) {
    var gmui = global.gmui;
    var cache = gmui.cache;
	
	gmui_container_cursor_advance();
	
    if (!ds_map_exists(cache, "__split_stack")) {
        cache[? "__split_stack"] = [];
    }
    
    var split_id = "__split_" + name;
    if (!ds_map_exists(cache, split_id)) {
        cache[? split_id] = {
            direction: direction,
            ratios: ratios != undefined ? ratios : [0.5, 0.5],
            current_pane: -1,
        };
    }
    
    var stack = cache[? "__split_stack"];
    array_push(stack, name);
	
	gmui_begin_wins_space();
	
	var begin_result = false;
	
    if (direction == gmui_split_dir.VERTICAL) {
        begin_result = gmui_begin_columns(array_length(cache[? split_id].ratios), cache[? split_id].ratios, -1, resize_enabled);
    } else {
        begin_result = gmui_begin_rows(array_length(cache[? split_id].ratios), cache[? split_id].ratios, -1, resize_enabled);
    }
	
	if (!begin_result) {
		gmui_end_wins_space();
	}
	
	return begin_result;
}

function gmui_begin_wins_pane(index, properties = undefined) {
    var gmui = global.gmui;
    var cache = gmui.cache;
    var stack = cache[? "__split_stack"];
    if (array_length(stack) == 0) return false;
	
    var last_name = stack[array_length(stack) - 1];
    var split_id = "__split_" + last_name;
    var state = cache[? split_id];
    state.current_pane = index;
	
	var begin_result = false;
	
    if (state.direction == gmui_split_dir.VERTICAL) {
        begin_result = gmui_begin_column(index, properties);
    } else {
        begin_result = gmui_begin_row(index, properties);
    }
	
	if (begin_result) {
		gmui_end_wins_space();
		gmui.current_container.context.cursor_x = gmui.style.container_padding_h;
		gmui.current_container.context.cursor_y = gmui.style.container_padding_v;
	}
	
	return begin_result;
}

function gmui_end_wins_pane() {
    var gmui = global.gmui;
    var cache = gmui.cache;
    var stack = cache[? "__split_stack"];
    if (array_length(stack) == 0) return false;
    
    var last_name = stack[array_length(stack) - 1];
    var split_id = "__split_" + last_name;
    var state = cache[? split_id];
	
    if (state.direction == gmui_split_dir.VERTICAL) {
        gmui_end_column();
    } else {
        gmui_end_row();
    }
	
	gmui_begin_wins_space();
}

function gmui_end_wins() {
    var gmui = global.gmui;
    var cache = gmui.cache;
    var stack = cache[? "__split_stack"];
    if (array_length(stack) == 0) return;
    
    var last_name = stack[array_length(stack) - 1];
    var split_id = "__split_" + last_name;
    var state = cache[? split_id];
    
    if (state.direction == gmui_split_dir.VERTICAL) {
        gmui_end_columns();
    } else {
        gmui_end_rows();
    }
	
	gmui_end_wins_space();
    
    array_pop(stack);
    
    ds_map_delete(cache, split_id);
}

function gmui_get_current_wins_pane() {
    var gmui = global.gmui;
    var cache = gmui.cache;
    var stack = cache[? "__split_stack"];
    if (array_length(stack) == 0) return undefined;
    
    var last_name = stack[array_length(stack) - 1];
    var split_id = "__split_" + last_name;
    var state = cache[? split_id];
    
    if (state.direction == gmui_split_dir.VERTICAL) {
        return gmui.current_container;
    } else {
        return gmui.current_container;
    }
}