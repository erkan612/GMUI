

// CONTEXT MENU
function gmui_begin_context_menu(name, width = 160) {
    var gmui = global.gmui;
    var input = gmui.input;
    
    var window = undefined;
    var is_first_frame = !ds_map_exists(gmui.containers, name);
    window = gmui_container_get(name, undefined);
    if (is_first_frame) {
        gmui_begin_window(name, 0, 0, width, 320, gmui_window_flags.NO_CLOSE | gmui_window_flags.NO_COLLAPSE | gmui_window_flags.NO_TITLE_BAR);
        gmui_end_window();
        window.is_enabled = false;
        window.layer = gmui_layer.POPUP;
		window.state[? "ctx_sub"] = undefined;
		window.state[? "ctx_sub_state_key"] = undefined;
		window.state[? "ctx_previous"] = undefined;
    };
    
    if (!window.is_enabled) { return false; };
    
    var result = gmui_begin_window(name, 0, 0, width, 320, gmui_window_flags.NO_CLOSE | gmui_window_flags.NO_COLLAPSE | gmui_window_flags.NO_TITLE_BAR | gmui_window_flags.NO_BORDERS);
    gmui_container_bring_to_front(name);
    
    gmui_style_push_multi({
        container_padding_h: 0,
        container_padding_v: 0,
        element_spacing_h: 0,
        element_spacing_v: 0,
    });
    
    window.content_container.context.cursor_x = 0;
    window.content_container.context.cursor_y = 0;
    
    return result;
};

function gmui_end_context_menu() {
    var gmui = global.gmui;
    var input = gmui.input;
    var container = gmui.current_container;
    var window = container.parent;
	
    gmui_style_pop_multi(["container_padding_h", "container_padding_v", "element_spacing_h", "element_spacing_v"]);
    gmui_end_window();
    
    if (window.is_enabled && input.m_pressed) {
		var order = gmui_context_menu_get_order(window);
		var contains = false;
		for (var i = 0; i < array_length(order); i++) {
			var ctx = order[i];
			if (ctx.content_container == input.hovered_container) { contains = true; break; };
		};
		if (!contains) { gmui_context_menu_close(window.name); };
    };
	
	gmui_container_set_size(window.name, window.width, container.context.cursor_y + container.context.line_height); // needs a proper way
};

function gmui_context_menu_open(name, x = -1, y = -1) {
    var window = gmui_container_get(name, undefined);
    if (window != undefined && !window.is_enabled) {
        window.is_enabled = true;
        var xx = x < 0 ? global.gmui.input.m_x : x;
        var yy = y < 0 ? global.gmui.input.m_y : y;
        
        var sw = surface_get_width(application_surface);
        var sh = surface_get_height(application_surface);
        if (xx + window.width > sw) xx = sw - window.width - 4;
        if (yy + window.height > sh) yy = sh - window.height - 4;
        xx = max(0, xx);
        yy = max(0, yy);
        
        window.x = xx;
        window.y = yy;
        gmui_container_bring_to_front(name);
    }
};

function _gmui_context_menu_close_subs(ctx) {
	if (ctx == undefined) { return; };
	var sub = ctx.state[? "ctx_sub"];
	_gmui_context_menu_close_subs(sub.state[? "ctx_sub"]); // from head to tail
	if (sub != undefined) {
		var state_key = ctx.state[? "ctx_sub_state_key"];
		if (state_key != undefined) { ctx.state[? state_key] = false; };
		_gmui_context_menu_close(ctx.name);
	}
	
	var prev = ctx.state[? "ctx_previous"];
	if (prev != undefined) {
		var state_key = ctx.state[? "ctx_sub_state_key"];
		if (state_key != undefined) { ctx.state[? state_key] = false; };
		_gmui_context_menu_close(ctx.name);
	}
};

function _gmui_context_menu_close(name) {
    var window = gmui_container_get(name, undefined);
    if (window != undefined && window.is_enabled) {
        window.is_enabled = false;
    }
};

function gmui_context_menu_close1(name) {
    var window = gmui_container_get(name, undefined);
    _gmui_context_menu_close_subs(window);
	_gmui_context_menu_close(window.name);
};

function gmui_context_menu_close11(name) {
	var ctx = gmui_container_get(name, undefined);
	var sub = ctx.state[? "ctx_sub"];
	var prev = ctx.state[? "ctx_previous"];
	
	if (sub != undefined) {
		var state_key = ctx.state[? "ctx_sub_state_key"];
		if (state_key != undefined) { ctx.state[? state_key] = false; };
		gmui_context_menu_close(sub.name);
	}
	
	if (prev != undefined) {
		var state_key = prev.state[? "ctx_sub_state_key"];
		if (state_key != undefined) { prev.state[? state_key] = false; };
		gmui_context_menu_close(prev.name);
	}
};

function gmui_context_menu_get_order_first(ctx) {
	if (ctx.state[? "ctx_previous"] != undefined) { return gmui_context_menu_get_order_first(ctx.state[? "ctx_previous"]); };
	return ctx;
};

function gmui_context_menu_get_order_last(ctx) {
	if (ctx.state[? "ctx_sub"] != undefined) { return gmui_context_menu_get_order_last(ctx.state[? "ctx_sub"]); };
	return ctx;
};

function gmui_context_menu_get_order(ctx) {
	var first = gmui_context_menu_get_order_first(ctx);
	var last = gmui_context_menu_get_order_last(ctx);
	var order = [ ];
	array_push(order, first);
	if (first == last) { return order; };
	while (first.state[? "ctx_sub"] != last) {
		array_push(order, first.state[? "ctx_sub"]);
	};
	array_push(order, last);
	return order;
};

function gmui_context_menu_get_order_a_to_b_forward_reversed(a, b) {
    var order = [];
    if (a == b) { return order; }
    
    var current = a;
    while (current.state[? "ctx_sub"] != b) {
        array_push(order, current.state[? "ctx_sub"]);
        current = current.state[? "ctx_sub"];
        if (current == undefined) { break; }
    }
    array_push(order, current);
    return order;
};

function gmui_context_menu_get_order_a_to_b_backward_reversed(a, b) {
	var order = [ ];
	
	var current = a;
	while (current.state[? "ctx_previous"] != b) {
		array_push(order, current.state[? "ctx_previous"]);
		current = current.state[? "ctx_previous"];
	};
	array_push(order, current);
};

function gmui_context_menu_close_forward(name) {
	var _start = gmui_container_get(name, undefined);
	var _end = gmui_context_menu_get_order_last(_start);
	var order = gmui_context_menu_get_order_a_to_b_forward_reversed(_start, _end);
	array_foreach(order, function(e, i) {
		e.is_enabled = false;
		if (e.state[? "ctx_sub_state_key"] != undefined) { e.state[? e.state[? "ctx_sub_state_key"]] = false; };
	});
};

function gmui_context_menu_close_backward(name) {
	var _start = gmui_container_get(name, undefined);
	var _end = gmui_context_menu_get_order_first(_start);
	var order = array_reverse(gmui_context_menu_get_order_a_to_b_backward_reversed(_start, _end));
	array_foreach(order, function(e, i) {
		e.is_enabled = false;
		if (e.state[? "ctx_sub_state_key"] != undefined) { e.state[? e.state[? "ctx_sub_state_key"]] = false; };
	});
};

function gmui_context_menu_close(name) {
	var ctx = gmui_container_get(name, undefined);
	if (ctx == undefined) { return; };
	var order = gmui_context_menu_get_order(ctx);
	array_foreach(order, function(e, i) {
		e.is_enabled = false;
		if (e.state[? "ctx_sub_state_key"] != undefined) { e.state[? e.state[? "ctx_sub_state_key"]] = false; };
	});
};

function gmui_context_menu_item(text, short_cut = undefined, font = undefined) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("context_menu_item");
    var container = widget.container;
    
    var _font = gmui_resolve_font(widget, font);
    var item_height = style.context_menu_item_height;
    
    widget.width = container.width;
    widget.height = item_height;
    
    var released = false;
    
    if (gmui_widget_is_visible(widget)) {
        var mouse_interaction = gmui_widget_mouse_interactive_behaviour(widget);
        var hovered = mouse_interaction.is_hovering;
        var active = mouse_interaction.is_active;
        released = mouse_interaction.is_pressed;
        
        var bg_color = style.context_menu_item_color;
        if (active) bg_color = style.context_menu_item_color_active;
        else if (hovered) bg_color = style.context_menu_item_color_hover;
        
        gmui_add_rectangle(widget.x, widget.y, widget.x + widget.width, widget.y + item_height, false, bg_color, 1);
        
        var text_size = gmui_calculate_text_size(text, _font);
        var text_y = widget.y + (item_height - text_size[1]) / 2;
        gmui_add_text(text, widget.x + style.context_menu_padding_h, text_y, style.context_menu_text_color, 1, _font);
        
        if (short_cut != undefined) {
            var sc_size = gmui_calculate_text_size(short_cut, _font);
            var sc_x = widget.x + widget.width - sc_size[0] - style.context_menu_padding_h;
            var sc_y = widget.y + (item_height - sc_size[1]) / 2;
            gmui_add_text(short_cut, sc_x, sc_y, style.context_menu_shortcut_color, 1, _font);
        }
    }
    
    gmui_end_widget(widget, true);
    
    if (released) {
        gmui_context_menu_close(gmui.current_container.parent.name);
    }
    
    return released;
};

function gmui_context_menu_item_checkbox(text, checked) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("context_menu_checkbox");
    var container = widget.container;
    
    var item_height = style.context_menu_item_height;
    var check_size = 12;
    var check_spacing = 6;
    
    widget.width = container.width;
    widget.height = item_height;
    
    if (gmui_widget_is_visible(widget)) {
        var mouse_interaction = gmui_widget_mouse_interactive_behaviour(widget);
        var hovered = mouse_interaction.is_hovering;
        var active = mouse_interaction.is_active;
        var released = mouse_interaction.is_pressed;
        
        if (released) checked = !checked;
        
        var bg_color = style.context_menu_item_color;
        if (active) bg_color = style.context_menu_item_color_active;
        else if (hovered) bg_color = style.context_menu_item_color_hover;
        
        gmui_add_rectangle(widget.x, widget.y, widget.x + widget.width, widget.y + item_height, false, bg_color, 1);
        
        var cbx = widget.x + style.context_menu_padding_h;
        var cby = widget.y + (item_height - check_size) / 2;
        
        gmui_add_rectangle(cbx, cby, cbx + check_size, cby + check_size, false, checked ? style.checkbox_color_active : style.checkbox_color_idle, 1);
        gmui_add_rectangle(cbx, cby, cbx + check_size, cby + check_size, true, style.checkbox_border_color, 1);
        
        if (checked) {
            var mx = cbx + check_size / 2;
            var my = cby + check_size / 2;
            gmui_add_line(cbx + 2, my, mx, cby + check_size - 2, style.checkbox_checkmark_color, 1.5);
            gmui_add_line(mx, cby + check_size - 2, cbx + check_size - 2, cby + 2, style.checkbox_checkmark_color, 1.5);
        }
        
        var text_x = cbx + check_size + check_spacing;
        var text_size = gmui_calculate_text_size(text);
        var text_y = widget.y + (item_height - text_size[1]) / 2;
        gmui_add_text(text, text_x, text_y, style.context_menu_text_color, 1);
    }
    
    gmui_end_widget(widget, true);
    return checked;
};

function gmui_context_menu_item_radio(text, selected) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("context_menu_radio");
    var container = widget.container;
    
    var item_height = style.context_menu_item_height;
    var radio_size = 12;
    var radio_spacing = 6;
    
    widget.width = container.width;
    widget.height = item_height;
    
    var clicked = false;
    
    if (gmui_widget_is_visible(widget)) {
        var mouse_interaction = gmui_widget_mouse_interactive_behaviour(widget);
        var hovered = mouse_interaction.is_hovering;
        var active = mouse_interaction.is_active;
        var released = mouse_interaction.is_pressed;
        
        if (released) clicked = true;
        
        var bg_color = style.context_menu_item_color;
        if (active) bg_color = style.context_menu_item_color_active;
        else if (hovered) bg_color = style.context_menu_item_color_hover;
        
        gmui_add_rectangle(widget.x, widget.y, widget.x + widget.width, widget.y + item_height, false, bg_color, 1);
        
        var rx = widget.x + style.context_menu_padding_h + radio_size / 2;
        var ry = widget.y + item_height / 2;
        
        gmui_add_circle(rx, ry, radio_size / 2, false, style.radio_color_idle, 1);
        gmui_add_circle(rx, ry, radio_size / 2, true, style.radio_border_color, 1);
        
        if (selected) {
            gmui_add_circle(rx, ry, radio_size / 4, false, style.radio_dot_color, 1);
        }
        
        var text_x = widget.x + style.context_menu_padding_h + radio_size + radio_spacing;
        var text_size = gmui_calculate_text_size(text);
        var text_y = widget.y + (item_height - text_size[1]) / 2;
        gmui_add_text(text, text_x, text_y, style.context_menu_text_color, 1);
    }
    
    gmui_end_widget(widget, true);
    return clicked;
};

function gmui_begin_context_menu_sub(text) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("context_menu_sub");
    var container = widget.container;
    
    var state_key = "_ctx_sub_" + text;
    if (!ds_map_exists(container.parent.state, state_key)) {
        container.parent.state[? state_key] = false;
    }
    
    var open = container.parent.state[? state_key];
    var item_height = style.context_menu_item_height;
    
    widget.width = container.width;
    widget.height = item_height;
    
    if (gmui_widget_is_visible(widget)) {
        var mouse_interaction = gmui_widget_mouse_interactive_behaviour(widget);
        var hovered = mouse_interaction.is_hovering;
        var active = mouse_interaction.is_active;
        var released = mouse_interaction.is_pressed;
        
        if (released) {
            open = !open;
            container.parent.state[? state_key] = open;
        }
        
        var bg_color = style.context_menu_item_color;
        if (active || open) {
            bg_color = style.context_menu_item_color_active;
        } else if (hovered) {
            bg_color = style.context_menu_item_color_hover;
        }
        
        gmui_add_rectangle(widget.x, widget.y, widget.x + widget.width, widget.y + item_height, false, bg_color, 1);
        
        var text_size = gmui_calculate_text_size(text);
        var text_y = widget.y + (item_height - text_size[1]) / 2;
        gmui_add_text(text, widget.x + style.context_menu_padding_h, text_y, style.context_menu_text_color, 1);
        
        var arrow_size = 8;
        var arrow_x = widget.x + widget.width - arrow_size - 8;
        var arrow_y = widget.y + item_height / 2;
        gmui_add_triangle(arrow_x, arrow_y - arrow_size / 2, arrow_x + arrow_size, arrow_y, arrow_x, arrow_y + arrow_size / 2, style.context_menu_arrow_color);
	}
    
    gmui_end_widget(widget, true);
    
    if (open) {
        var sub_menu = gmui_container_get(text, undefined);
        sub_menu.state[? "ctx_previous"] = widget.container.parent;
        var parent_window = widget.container.parent;
        
		var current_sub = parent_window.state[? "ctx_sub"];
		if (current_sub != undefined && current_sub != sub_menu) {
		    var old_state_key = parent_window.state[? "ctx_sub_state_key"];
		    if (old_state_key != undefined) {
		        parent_window.state[? old_state_key] = false;
		    }
		    gmui_context_menu_close_forward(current_sub.name);
		}
        
        sub_menu.is_enabled = true;
        gmui_begin_context_menu(text, widget.container.parent.width);
        sub_menu.is_enabled = false;
        gmui_context_menu_open(text, parent_window.x + parent_window.width, parent_window.y + widget.y);
        parent_window.state[? "ctx_sub"] = sub_menu;
        parent_window.state[? "ctx_sub_state_key"] = state_key;
    }
    
    return open;
};

function gmui_end_context_menu_sub() {
    gmui_end_context_menu();
};

function gmui_context_menu_item_if(condition, text, short_cut = undefined, font = undefined) {
    if (condition) {
        return gmui_context_menu_item(text, short_cut, font);
    }
    return false;
};

function gmui_context_menu_separator() {
    gmui_separator();
};