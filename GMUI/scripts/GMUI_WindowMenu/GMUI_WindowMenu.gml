

// WINDOW MENU
function gmui_window_menu(menu_array) {
    var gmui = global.gmui;
    var style = gmui.style;
    var input  = gmui.input;
    var widget = gmui_begin_widget("window_menu");
    var container = widget.container;

    widget.width  = gmui_get_available_width();
    widget.height = style.window_menu_height;

    if (!ds_map_exists(container.state, "window_menu")) {
        container.state[? "window_menu"] = {
            active_menu: undefined,
            any_open:    false,
        };
    }
    var menu_state = container.state[? "window_menu"];

    var btn_pad_h = style.window_menu_button_padding_h;
    var btn_pad_v = style.window_menu_button_padding_v;
    var btn_rounding = style.window_menu_button_rounding;

    var btn_count = array_length(menu_array);
    var btn_widths = array_create(btn_count, 0);
    var btn_x_starts = array_create(btn_count, 0);
    var cursor_x = 0;
    for (var i = 0; i < btn_count; i++) {
        var label = menu_array[i][0];
        var tw = string_width(label);
        btn_widths[i] = tw + btn_pad_h * 2;
        btn_x_starts[i] = cursor_x;
        cursor_x += btn_widths[i];
    }

    if (gmui_widget_is_callable(widget)) {
        var offset = gmui_get_container_screen_offset(container);

        var origin_sx = offset[0] - container.scroll_x;
        var origin_sy = offset[1] - container.scroll_y;

        gmui_add_rectangle(
            widget.x, widget.y,
            widget.x + widget.width, widget.y + widget.height,
            false, style.window_menu_bg_color, 1
        );

        gmui_add_line(
            widget.x,              widget.y + widget.height - 1,
            widget.x + widget.width, widget.y + widget.height - 1,
            style.window_menu_separator_color, 1
        );

        for (var i = 0; i < btn_count; i++) {
            var label    = menu_array[i][0];
            var ctx_name = menu_array[i][1];
            var bx       = widget.x + btn_x_starts[i];
            var bw       = btn_widths[i];
            var bh       = widget.height;

            var sbx1 = origin_sx + bx;
            var sby1 = origin_sy + widget.y;
            var sbx2 = sbx1 + bw;
            var sby2 = sby1 + bh;

            var btn_hovered = (input.hovered_container == container || array_contains(input.hovered_container_array, container))
                            && point_in_rectangle(input.m_x, input.m_y, sbx1, sby1, sbx2, sby2);

            var is_open = (menu_state.active_menu == label);

            if (btn_hovered && menu_state.any_open && !is_open && ctx_name != "") {
                if (menu_state.active_menu != undefined) {
                    gmui_context_menu_close(menu_state.active_menu == label
                        ? ctx_name
                        : menu_array[_gmui_window_menu_find_idx(menu_array, menu_state.active_menu)][1]);
                }
                gmui_context_menu_open(
                    ctx_name,
                    origin_sx + bx,
                    origin_sy + widget.y + widget.height
                );
                menu_state.active_menu = label;
            }

            if (btn_hovered && input.m_pressed) {
                if (is_open) {
                    if (ctx_name != "") gmui_context_menu_close(ctx_name);
                    menu_state.active_menu = undefined;
                    menu_state.any_open    = false;
                } else {
                    if (menu_state.active_menu != undefined) {
                        var prev_idx = _gmui_window_menu_find_idx(menu_array, menu_state.active_menu);
                        if (prev_idx >= 0 && menu_array[prev_idx][1] != "") {
                            gmui_context_menu_close(menu_array[prev_idx][1]);
                        }
                    }
                    if (ctx_name != "") {
                        gmui_context_menu_open(
                            ctx_name,
                            origin_sx + bx,
                            origin_sy + widget.y + widget.height
                        );
                    }
                    menu_state.active_menu = label;
                    menu_state.any_open    = (ctx_name != "");
                }
            }

            if (is_open && ctx_name != "") {
                var ctx_window = gmui_container_get(ctx_name, undefined);
                if (ctx_window != undefined && !ctx_window.is_enabled) {
                    menu_state.active_menu = undefined;
                    menu_state.any_open    = false;
                    is_open = false;
                }
            }

            var btn_bg_alpha = 0;
            var btn_bg_color = style.window_menu_button_hover_color;

            if (is_open) {
                btn_bg_alpha = 1;
                btn_bg_color = style.window_menu_button_active_color;
            } else if (btn_hovered) {
                btn_bg_alpha = 1;
                btn_bg_color = style.window_menu_button_hover_color;
            }

            if (btn_bg_alpha > 0) {
                var inner_pad = 2;
                if (btn_rounding > 0) {
                    gmui_add_roundrect(
                        bx + inner_pad, widget.y + inner_pad,
                        bx + bw - inner_pad, widget.y + bh - inner_pad,
                        false, btn_bg_color, btn_bg_alpha, btn_rounding
                    );
                } else {
                    gmui_add_rectangle(
                        bx + inner_pad, widget.y + inner_pad,
                        bx + bw - inner_pad, widget.y + bh - inner_pad,
                        false, btn_bg_color, btn_bg_alpha
                    );
                }
            }

            var text_size = gmui_calculate_text_size(label);
            var text_x = bx + btn_pad_h;
            var text_y = widget.y + (bh - text_size[1]) / 2;
            var text_color = is_open
                ? style.window_menu_text_color_active
                : (btn_hovered ? style.window_menu_text_color_hover : style.window_menu_text_color);

            gmui_add_text(label, text_x, text_y, text_color, 1);
        }
    }
	
	if (menu_state.any_open && input.m_pressed) {
	    var clicked_menu_bar = point_in_rectangle(
	        input.m_x, input.m_y,
	        origin_sx + widget.x,
	        origin_sy + widget.y,
	        origin_sx + widget.x + widget.width,
	        origin_sy + widget.y + widget.height
	    );
    
	    if (!clicked_menu_bar) {
	        var active_idx = _gmui_window_menu_find_idx(menu_array, menu_state.active_menu);
	        if (active_idx >= 0 && menu_array[active_idx][1] != "") {
	            var ctx_name = menu_array[active_idx][1];
	            var ctx_win = gmui_container_get(ctx_name, undefined);
	            var clicked_ctx = (ctx_win != undefined && ctx_win.is_mouse_hovering);
	            if (!clicked_ctx) {
	                gmui_context_menu_close(ctx_name);
	                menu_state.active_menu = undefined;
	                menu_state.any_open    = false;
	            }
	        }
	    }
	}

    gmui_end_widget(widget);
}

function _gmui_window_menu_find_idx(menu_array, label) {
    for (var i = 0; i < array_length(menu_array); i++) {
        if (menu_array[i][0] == label) return i;
    }
    return -1;
}

function gmui_menu_item(text, ctx_name) {
    return [text, ctx_name];
};