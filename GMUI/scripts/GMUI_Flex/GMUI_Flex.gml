

// FLEX (WINS wrapper)
function gmui_begin_flex(direction, ratios = undefined, resize_enabled = true, flow = undefined) {
    var gmui  = global.gmui;
    var cache = gmui.cache;

    if (!ds_map_exists(cache, "__flex_stack")) {
        cache[? "__flex_stack"] = [];
    }
    var stack = cache[? "__flex_stack"];

    var auto_child = (array_length(stack) > 0);
    if (auto_child) {
        if (!gmui_begin_flex_child()) {
            return false;
        }
    }

    var _depth     = array_length(stack);
    var flex_name = "__flex_d" + string(_depth);

    var _ratios = ratios;
    if (_ratios == undefined) {
        _ratios = [0.5, 0.5];
    } else {
        var sum = 0;
        for (var i = 0; i < array_length(_ratios); i++) { sum += _ratios[i]; }
        if (sum != 1.0) {
            var norm = array_create(array_length(_ratios));
            for (var i = 0; i < array_length(_ratios); i++) { norm[i] = _ratios[i] / sum; }
            _ratios = norm;
        }
    }

    array_push(stack, {
        flex_name:   flex_name,
        direction:   direction,
        ratios:      ratios,
        pane_index:  0,
        auto_child:  auto_child,
        flow:        flow,
    });

    var result = gmui_begin_wins(flex_name, direction, ratios, resize_enabled);
    if (!result) {
        array_pop(stack);
        if (auto_child) { gmui_end_flex_child(); }
        return false;
    }

    return true;
}

function gmui_end_flex() {
    var gmui  = global.gmui;
    var cache = gmui.cache;
    var stack = cache[? "__flex_stack"];
    if (stack == undefined || array_length(stack) == 0) { return; }

    var frame = stack[array_length(stack) - 1];
    array_pop(stack);

    gmui_end_wins();

    if (frame.auto_child) {
        gmui_end_flex_child();
    }
}

function gmui_begin_flex_child() {
    var gmui  = global.gmui;
    var cache = gmui.cache;
    var stack = cache[? "__flex_stack"];
    if (stack == undefined || array_length(stack) == 0) { return false; }

    var frame = stack[array_length(stack) - 1];
    var idx   = frame.flow == gmui_flow_direction.LEFT || frame.flow == gmui_flow_direction.UP ? array_length(frame.ratios) - frame.pane_index - 1 : frame.pane_index;
    frame.pane_index++;

    return gmui_begin_wins_pane(idx);
}

function gmui_end_flex_child() {
    gmui_end_wins_pane();
}