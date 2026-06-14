

// WINS
function gmui_begin_wins(name, direction, ratios = undefined) {
    var gmui = global.gmui;
    var cache = gmui.cache;
    
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
    
    if (direction == gmui_split_dir.VERTICAL) {
        gmui_begin_columns(array_length(cache[? split_id].ratios), cache[? split_id].ratios, -1);
    } else {
        gmui_begin_rows(array_length(cache[? split_id].ratios), cache[? split_id].ratios, -1);
    }
    
    return true;
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
    
    if (state.direction == gmui_split_dir.VERTICAL) {
        gmui_set_column(index, properties);
    } else {
        gmui_set_row(index, properties);
    }
    
    return true;
}

function gmui_end_wins_pane() {
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