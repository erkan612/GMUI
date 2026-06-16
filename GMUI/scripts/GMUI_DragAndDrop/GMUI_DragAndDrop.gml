

// DRAG (simplified)
function gmui_default_drag_draw(info, widget) {
    var gmui = global.gmui;
    var style = gmui.style;
    var input = gmui.input;
    
    var old_color = draw_get_color();
    var old_alpha = draw_get_alpha();
    
    var label = is_string(info) ? info : string(info);
    var pad_h = style.drag_preview_padding_h;
    var pad_v = style.drag_preview_padding_v;
    var text_w = string_width(label);
    var text_h = string_height(label);
    
    var w = text_w + pad_h * 2;
    var h = text_h + pad_v * 2;
    
    var x1 = input.m_x + style.drag_preview_offset_x;
    var y1 = input.m_y + style.drag_preview_offset_y;
    var x2 = x1 + w;
    var y2 = y1 + h;
    
    draw_set_color(style.drag_preview_bg_color);
    draw_set_alpha(style.drag_preview_alpha);
    draw_rectangle(x1, y1, x2, y2, false);
    
    draw_set_color(style.drag_preview_border_color);
    draw_set_alpha(1);
    draw_rectangle(x1, y1, x2, y2, true);
    
    draw_set_color(style.drag_preview_text_color);
    draw_set_alpha(1);
    draw_text(x1 + pad_h, y1 + pad_v, label);
    
    draw_set_alpha(old_alpha);
    draw_set_color(old_color);
}

function gmui_drag(info = undefined, handlers = undefined, widget = undefined) {
	var gmui = global.gmui;
	var input = gmui.input;
	
	var _handlers = handlers ?? {
		on_drag_start: undefined, // Triggeers when the drag starts, after the widget copied, given info and widget.
		on_drag_end: undefined, // Triggers when the drag ends(user releases), given info and widget.
		on_drag_draw: gmui_default_drag_draw, // Triggers internal, when the drag is detected between GMUI and GML frame so basic GML can be used as well as GMUI. Given info and widget.
	};
    if (!variable_struct_exists(_handlers, "on_drag_start")) { _handlers.on_drag_start = undefined; }
    if (!variable_struct_exists(_handlers, "on_drag_end")) { _handlers.on_drag_end = undefined; }
    if (!variable_struct_exists(_handlers, "on_drag_draw")) { _handlers.on_drag_draw = gmui_default_drag_draw; }
	
	var key_clicked = "__widget_drag_clicked";
	var key_click_pos = "__widget_drag_click_pos";
	var key_drag_state = "__widget_drag_state";
	var key_drag_widget = "__widget_drag_widget";
	var key_drag_draw = "__widget_drag_draw";
	var key_drag_info = "__widget_drag_info";
	
	if (!ds_map_exists(gmui.cache, key_clicked)) {
		gmui.cache[? key_clicked] = false;
	}
	if (!ds_map_exists(gmui.cache, key_click_pos)) {
		gmui.cache[? key_click_pos] = [ 0, 0 ];
	}
	if (!ds_map_exists(gmui.cache, key_drag_state)) {
		gmui.cache[? key_drag_state] = "";
	}
	if (!ds_map_exists(gmui.cache, key_drag_widget)) {
		gmui.cache[? key_drag_widget] = undefined;
	}
	if (!ds_map_exists(gmui.cache, key_drag_draw)) {
		gmui.cache[? key_drag_draw] = _handlers.on_drag_draw;
	}
	if (!ds_map_exists(gmui.cache, key_drag_info)) {
		gmui.cache[? key_drag_info] = "";
	}
	
	var _widget = widget ?? gmui_widget_get_last();
	
	var is_hovering = input.hovered_widget_id == _widget.id;
	var is_clicked = gmui.cache[? key_clicked];
	var click_pos = gmui.cache[? key_click_pos];
	var state = gmui.cache[? key_drag_state];
	var drag_widget = gmui.cache[? key_drag_widget];
	var drag_draw = gmui.cache[? key_drag_draw];
	var drag_info = gmui.cache[? key_drag_info];
	
	if (is_hovering && gmui_input_mouse_pressed() && !is_clicked) {
		is_clicked = true;
		click_pos[0] = input.m_x;
		click_pos[1] = input.m_y;
	}
	
	if (gmui_input_mouse_released() && is_clicked) {
		is_clicked = false;
	}
	
	if (gmui_input_mouse_released() && state == "dragging") {
		state = "";
		if (_handlers.on_drag_end != undefined) { _handlers.on_drag_end(drag_info, drag_widget); };
		drag_widget = undefined;
		drag_info = undefined;
	}
	
	var drag_threshold = 4;
	if (is_clicked && (abs(click_pos[0] - input.m_x) >= drag_threshold || abs(click_pos[1] - input.m_y) >= drag_threshold) && state != "dragging") {
		state = "dragging";
		drag_widget = _widget;
		drag_info = info ?? drag_widget.id;
		if (_handlers.on_drag_start != undefined) { _handlers.on_drag_start(drag_info, drag_widget); };
	}
	
	gmui.cache[? key_clicked] = is_clicked;
	gmui.cache[? key_click_pos] = click_pos;
	gmui.cache[? key_drag_state] = state;
	gmui.cache[? key_drag_widget] = drag_widget;
	gmui.cache[? key_drag_draw] = drag_draw;
	gmui.cache[? key_drag_info] = drag_info;
};

function gmui_begin_drag(info = undefined, handlers = undefined) {
    var gmui = global.gmui;
    
    var _handlers = handlers ?? {
        on_drag_start: undefined,
        on_drag_end: undefined,
        on_drag_draw: gmui_default_drag_draw,
    };
    if (!variable_struct_exists(_handlers, "on_drag_start")) { _handlers.on_drag_start = undefined; }
    if (!variable_struct_exists(_handlers, "on_drag_end")) { _handlers.on_drag_end = undefined; }
    if (!variable_struct_exists(_handlers, "on_drag_draw")) { _handlers.on_drag_draw = gmui_default_drag_draw; }
    
    if (!ds_map_exists(gmui.cache, "__drop_stack")) {
        gmui.cache[? "__drop_stack"] = ds_stack_create();
    }
    var stack = gmui.cache[? "__drop_stack"];
    
    ds_stack_push(stack, {
        widget_start_index: array_length(gmui.current_container.widgets),
        info: info,
        handlers: _handlers,
    });
};

function gmui_end_drag() {
    var gmui = global.gmui;
    var input = gmui.input;
    
    if (!ds_map_exists(gmui.cache, "__drop_stack")) { return; }
    var stack = gmui.cache[? "__drop_stack"];
    if (ds_stack_empty(stack)) { return; }
    
    var ctx = ds_stack_pop(stack);
    var _handlers = ctx.handlers;
    var info = ctx.info;
    var widgets = gmui.current_container.widgets;
    var start_idx = ctx.widget_start_index;
    var end_idx = array_length(widgets);
    
    var key_clicked    = "__widget_drag_clicked";
    var key_click_pos  = "__widget_drag_click_pos";
    var key_drag_state = "__widget_drag_state";
    var key_drag_widget= "__widget_drag_widget";
    var key_drag_draw  = "__widget_drag_draw";
    var key_drag_info  = "__widget_drag_info";
    
    if (!ds_map_exists(gmui.cache, key_clicked))     { gmui.cache[? key_clicked] = false; }
    if (!ds_map_exists(gmui.cache, key_click_pos))   { gmui.cache[? key_click_pos] = [0, 0]; }
    if (!ds_map_exists(gmui.cache, key_drag_state))  { gmui.cache[? key_drag_state] = ""; }
    if (!ds_map_exists(gmui.cache, key_drag_widget)) { gmui.cache[? key_drag_widget] = undefined; }
    if (!ds_map_exists(gmui.cache, key_drag_draw))   { gmui.cache[? key_drag_draw] = _handlers.on_drag_draw; }
    if (!ds_map_exists(gmui.cache, key_drag_info))   { gmui.cache[? key_drag_info] = ""; }
    
    var is_clicked  = gmui.cache[? key_clicked];
    var click_pos   = gmui.cache[? key_click_pos];
    var state       = gmui.cache[? key_drag_state];
    var drag_widget = gmui.cache[? key_drag_widget];
    var drag_info   = gmui.cache[? key_drag_info];
    
    var hovered_widget = undefined;
    for (var i = start_idx; i < end_idx; i++) {
        var w = widgets[i];
        if (input.hovered_widget_id == w.id) {
            hovered_widget = w;
            break;
        }
    }
    
    if (hovered_widget != undefined && gmui_input_mouse_pressed() && !is_clicked) {
        is_clicked = true;
        click_pos[0] = input.m_x;
        click_pos[1] = input.m_y;
        gmui.cache[? "__drop_pending_widget"] = hovered_widget;
    }
    
    if (gmui_input_mouse_released() && is_clicked) {
        is_clicked = false;
    }
    
    if (gmui_input_mouse_released() && state == "dragging") {
        if (_handlers.on_drag_end != undefined) { _handlers.on_drag_end(drag_info, drag_widget); }
        state = "";
        drag_widget = undefined;
        drag_info = undefined;
    }
    
	var drag_threshold = 4;
    var pending_widget = gmui.cache[? "__drop_pending_widget"];
    if (is_clicked && pending_widget != undefined && (abs(click_pos[0] - input.m_x) >= drag_threshold || abs(click_pos[1] - input.m_y) >= drag_threshold) && state != "dragging") {
        state = "dragging";
        drag_widget = pending_widget;
        drag_info = info ?? drag_widget.id;
        if (_handlers.on_drag_start != undefined) { _handlers.on_drag_start(drag_info, drag_widget); }
    }
    
    gmui.cache[? key_clicked]     = is_clicked;
    gmui.cache[? key_click_pos]   = click_pos;
    gmui.cache[? key_drag_state]  = state;
    gmui.cache[? key_drag_widget] = drag_widget;
    gmui.cache[? key_drag_draw]   = _handlers.on_drag_draw;
    gmui.cache[? key_drag_info]   = drag_info;
};

// DRAG N DROP (DearImGUI style)
function gmui_begin_drag_drop_source(widget = undefined) {
    var gmui = global.gmui;
    var input = gmui.input;
    
    var key_clicked   = "__dnd_clicked";
    var key_click_pos = "__dnd_click_pos";
    var key_state     = "__dnd_state";
    var key_widget    = "__dnd_widget";
    
    if (!ds_map_exists(gmui.cache, key_clicked))   { gmui.cache[? key_clicked] = false; }
    if (!ds_map_exists(gmui.cache, key_click_pos)) { gmui.cache[? key_click_pos] = [0, 0]; }
    if (!ds_map_exists(gmui.cache, key_state))     { gmui.cache[? key_state] = ""; }
    if (!ds_map_exists(gmui.cache, key_widget))    { gmui.cache[? key_widget] = undefined; }
    
    var _widget = widget ?? gmui_widget_get_last();
    
    var is_hovering = gmui_is_widget_hovering_at(_widget, input.m_x, input.m_y);
    
    var is_clicked  = gmui.cache[? key_clicked];
    var click_pos   = gmui.cache[? key_click_pos];
    var state_before = gmui.cache[? key_state];
    var state       = state_before;
    var drag_widget = gmui.cache[? key_widget];
    
    if (is_hovering && gmui_input_mouse_pressed() && !is_clicked && state == "") {
        is_clicked = true;
        click_pos[0] = input.m_x;
        click_pos[1] = input.m_y;
        gmui.cache[? "__dnd_pending_widget"] = _widget;
    }
    
    if (gmui_input_mouse_released() && is_clicked) {
        is_clicked = false;
    }
    
    var pending_widget = gmui.cache[? "__dnd_pending_widget"];
    var drag_threshold = 4;
    if (is_clicked && pending_widget != undefined && pending_widget.id == _widget.id && state != "dragging"
        && (abs(click_pos[0] - input.m_x) >= drag_threshold || abs(click_pos[1] - input.m_y) >= drag_threshold)) {
        state = "dragging";
        drag_widget = _widget;
    }
    
    gmui.cache[? key_clicked] = is_clicked;
    gmui.cache[? key_click_pos] = click_pos;
    gmui.cache[? key_state] = state;
    gmui.cache[? key_widget] = drag_widget;
    
    var result = (state == "dragging" && drag_widget != undefined && drag_widget.id == _widget.id);
	if (result) { gmui_container_animation_detected(); };
    return result;
};

function gmui_end_drag_drop_source() {
    var gmui = global.gmui;
    
    if (gmui_input_mouse_released()) {
        var state = gmui.cache[? "__dnd_state"];
        if (state == "dragging") {
            gmui.cache[? "__dnd_state"] = "dropped";
        }
    }
};

function gmui_set_drag_drop_payload(type, data) {
    var gmui = global.gmui;
    gmui.cache[? "__dnd_payload_type"] = type;
    gmui.cache[? "__dnd_payload_data"] = data;
};

function gmui_get_drag_drop_payload() {
    var gmui = global.gmui;
    if (gmui.cache[? "__dnd_state"] != "dragging") { return undefined; }
    return {
        type: gmui.cache[? "__dnd_payload_type"],
        data: gmui.cache[? "__dnd_payload_data"],
    };
};

function gmui_begin_drag_drop_target(widget = undefined) {
    var gmui = global.gmui;
    var input = gmui.input;
    
    var state = gmui.cache[? "__dnd_state"];
    if (state != "dragging" && state != "dropped") { return false; }
    
    var _widget = widget ?? gmui_widget_get_last();
    
    var hovering = point_in_rectangle(
        input.m_x, input.m_y,
        _widget.screen_x, _widget.screen_y,
        _widget.screen_x + _widget.width, _widget.screen_y + _widget.height
    );
    
    if (!hovering) { return false; }
    
    gmui.cache[? "__dnd_target_widget"] = _widget;
    
    if (state == "dragging") {
        var style = gmui.style;
        gmui_add_rectangle(
            _widget.x, _widget.y,
            _widget.x + _widget.width, _widget.y + _widget.height,
            true, style.color_accent_hover, 1
        );
    }
    
    return true;
};

function gmui_end_drag_drop_target() {
};

function gmui_accept_drag_drop_payload(type) {
    var gmui = global.gmui;
    
    var state = gmui.cache[? "__dnd_state"];
    if (state != "dropped") { return undefined; }
    
    var payload_type = gmui.cache[? "__dnd_payload_type"];
    if (payload_type != type) { return undefined; }
    
    var target_widget = gmui.cache[? "__dnd_target_widget"];
    var drag_widget = gmui.cache[? "__dnd_widget"];
    if (target_widget == undefined || drag_widget == undefined || target_widget.id == drag_widget.id) { return undefined; }
    
    var data = gmui.cache[? "__dnd_payload_data"];
    
    gmui.cache[? "__dnd_consumed"] = true;
    
    return {
        type: payload_type,
        data: data,
    };
};