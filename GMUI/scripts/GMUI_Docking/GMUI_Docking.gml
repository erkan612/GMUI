

// DOCKING
enum gmui_docking_pane_dir {
    PANE_CENTER = 0,
    PANE_LEFT   = 1,
    PANE_RIGHT  = 2,
    PANE_TOP    = 3,
    PANE_BOTTOM = 4,
}

function gmui_docking_create_dockspace(name) {
    var window = gmui_window_get(name);
    if (!ds_map_exists(window.state, "__dock")) {
        window.state[? "__dock"] = {
            panes:      ds_map_create(),
            pane_order: [ ],
        };
    }
	if (!ds_map_exists(global.gmui.cache, "__dockspace_names")) {
		global.gmui.cache[? "__dockspace_names"] = [ ];
	}
	array_push(global.gmui.cache[? "__dockspace_names"], name);
}

function gmui_docking_add_pane(dock_name, pane, ratio = 0.25) {
    var window = gmui_window_get(dock_name);
    var dock   = window.state[? "__dock"];
    if (dock == undefined) { return; }

    if (!ds_map_exists(dock.panes, pane)) {
        dock.panes[? pane] = {
            tab_idx: 0,
            ratio:   ratio,
        };
        if (pane != gmui_docking_pane_dir.PANE_CENTER && !array_contains(dock.pane_order, pane)) {
            array_push(dock.pane_order, pane);
        }
    } else {
        dock.panes[? pane].ratio = ratio;
    }
}

function gmui_docking_add_tab(dock_name, pane, label, ratio = 0.25) {
    var window = gmui_window_get(dock_name);
    var dock   = window.state[? "__dock"];
    if (dock == undefined) { return; }

    if (!ds_map_exists(dock.panes, pane)) {
        gmui_docking_add_pane(dock_name, pane, ratio);
    }

    var tab_name = dock_name + "_pane_" + string(pane) + "_tabs";
    gmui_tab_add(tab_name, label);
}

function gmui_docking_remove_tab(dock_name, pane, label) {
    var window   = gmui_window_get(dock_name);
    var dock     = window.state[? "__dock"];
    var tab_name = dock_name + "_pane_" + string(pane) + "_tabs";
    
    gmui_tab_delete(tab_name, label);
    
    var tab_data = gmui_tab_get_data(tab_name);
    var is_empty = (tab_data == undefined || !variable_struct_exists(tab_data, "labels") 
                 || array_length(tab_data.labels) == 0);
    
    if (array_length(gmui_tab_get_data(tab_name).labels) == 0) {
        var idx = array_get_index(dock.pane_order, pane);
        if (idx >= 0) { array_delete(dock.pane_order, idx, 1); }
        ds_map_delete(dock.panes, pane);
		gmui_tab_destroy(tab_name);
    }
}

function gmui_begin_dockspace(dock_name, handler, x = 0, y = 0, width = 1280, height = 720, flags = 0, vertical_shift = 0) {
	var begin_result = gmui_begin(dock_name, x, y, width, height, flags);
	if (!begin_result) { return false; };
	global.gmui.cache[? "__dockspace_avaiting_handler"] = handler;
	global.gmui.cache[? "__dockspace_avaiting_vertical_shift"] = vertical_shift;
	return true;
};

function gmui_end_dockspace() {
	gmui_docking_handle_dock(global.gmui.cache[? "__dockspace_avaiting_handler"], global.gmui.cache[? "__dockspace_avaiting_vertical_shift"]);
	global.gmui.cache[? "__dockspace_avaiting_handler"] = undefined;
	global.gmui.cache[? "__dockspace_avaiting_vertical_shift"] = 0;
	gmui_end();
};

function gmui_docking_handle_dock(handler, vertical_shift = 0) {
    var gmui    = global.gmui;
    var style   = gmui.style;
    var input   = gmui.input;
    var dock_name = gmui.current_container.parent.name;
    var window  = gmui_window_get(dock_name);
    var dock    = window.state[? "__dock"];
    if (dock == undefined) { return; }

    if (!variable_struct_exists(dock, "drag_pane"))  { dock.drag_pane  = -1; }
    if (!variable_struct_exists(dock, "drag_start")) { dock.drag_start = 0;  }

    var content = gmui.current_container;
    var offset  = gmui_get_container_screen_offset(content);
    var cx = 0;
    var cy = vertical_shift;
    var cw = content.width;
    var ch = content.height - vertical_shift;

    var splitters = [];

    var sep_w        = style.columns_separator_width;
    var sep_h        = style.rows_separator_height;
    var grab_pad     = style.columns_separator_grab_pad;
    var min_ratio    = style.columns_min_ratio;

    var center_has_tabs = false;
    if (ds_map_exists(dock.panes, gmui_docking_pane_dir.PANE_CENTER)) {
        var tab_name_center = dock_name + "_pane_" + string(gmui_docking_pane_dir.PANE_CENTER) + "_tabs";
        var center_data = gmui_tab_get_data(tab_name_center);
        center_has_tabs = (center_data != undefined && variable_struct_exists(center_data, "labels") 
                       && array_length(center_data.labels) > 0);
    }
	
    var pane_order_len = array_length(dock.pane_order);

	for (var i = 0; i < array_length(dock.pane_order); i++) {
	    var pane_dir  = dock.pane_order[i];
	    var pane_data = dock.panes[? pane_dir];
	    var tab_name  = dock_name + "_pane_" + string(pane_dir) + "_tabs";

	    if (array_length(gmui_tab_get_data(tab_name).labels) == 0) { continue; }

	    gmui.current_container = content;

	    var is_last_pane = (i == array_length(dock.pane_order) - 1);
	    var ratio_override = pane_data.ratio;
	    if (is_last_pane && !center_has_tabs) {
	        ratio_override = 0.999;
	    }

        switch (pane_dir) {
        case gmui_docking_pane_dir.PANE_LEFT: {
            var pw    = floor(cw * ratio_override);
            var inset = style.columns_separator_inset ?? 2;
            _gmui_docking_draw_pane(dock_name, pane_dir, tab_name, cx, cy, pw - inset, ch, pane_data, handler);
			if (center_has_tabs || (i != array_length(dock.pane_order) - 1)) {
	            array_push(splitters, {
	                pane_dir: pane_dir, x: cx + pw - inset, y: cy,
	                w: sep_w, h: ch, is_vertical: true, avail: cw,
	            });
			}
            cx += pw + inset; cw -= pw + inset * 2;
        } break;

        case gmui_docking_pane_dir.PANE_RIGHT: {
            var pw    = floor(cw * ratio_override);
            var inset = style.columns_separator_inset ?? 2;
            _gmui_docking_draw_pane(dock_name, pane_dir, tab_name, cx + cw - pw + inset, cy, pw - inset, ch, pane_data, handler);
			if (center_has_tabs || (i != array_length(dock.pane_order) - 1)) {
	            array_push(splitters, {
	                pane_dir: pane_dir, x: cx + cw - pw - inset, y: cy,
	                w: sep_w, h: ch, is_vertical: true, avail: cw,
	            });
			}
            cw -= pw + inset * 2;
        } break;

        case gmui_docking_pane_dir.PANE_TOP: {
            var ph    = floor(ch * ratio_override);
            var inset = style.rows_separator_inset ?? 2;
            _gmui_docking_draw_pane(dock_name, pane_dir, tab_name, cx, cy, cw, ph - inset, pane_data, handler);
			if (center_has_tabs || (i != array_length(dock.pane_order) - 1)) {
	            array_push(splitters, {
	                pane_dir: pane_dir, x: cx, y: cy + ph - inset,
	                w: cw, h: sep_h, is_vertical: false, avail: ch,
	            });
			}
            cy += ph + inset; ch -= ph + inset * 2;
        } break;

        case gmui_docking_pane_dir.PANE_BOTTOM: {
            var ph    = floor(ch * ratio_override);
            var inset = style.rows_separator_inset ?? 2;
            _gmui_docking_draw_pane(dock_name, pane_dir, tab_name, cx, cy + ch - ph + inset, cw, ph - inset, pane_data, handler);
			if (center_has_tabs || (i != array_length(dock.pane_order) - 1)) {
			    array_push(splitters, {
			        pane_dir: pane_dir, x: cx, y: cy + ch - ph - inset,
			        w: cw, h: sep_h, is_vertical: false, avail: ch,
			    });
			}
            ch -= ph + inset * 2;
        } break;
        case gmui_docking_pane_dir.PANE_CENTER: {
            _gmui_docking_draw_pane(dock_name, pane_dir, tab_name, cx, cy, cw, ch, pane_data, handler);
        } break;
        }
    }

    if (center_has_tabs) {
        var pane_data = dock.panes[? gmui_docking_pane_dir.PANE_CENTER];
        var tab_name  = dock_name + "_pane_" + string(gmui_docking_pane_dir.PANE_CENTER) + "_tabs";
        gmui.current_container = content;
        _gmui_docking_draw_pane(dock_name, gmui_docking_pane_dir.PANE_CENTER, tab_name, cx, cy, cw, ch, pane_data, handler);
    }

    gmui.current_container = content;
    var hovered_pane = -1;

    for (var i = 0; i < array_length(splitters); i++) {
        var sp   = splitters[i];
        var sx   = offset[0] + sp.x - content.scroll_x;
        var sy   = offset[1] + sp.y - content.scroll_y;

        var hit = point_in_rectangle(
            input.m_x, input.m_y,
            sx - grab_pad, sy - grab_pad,
            sx + sp.w + grab_pad, sy + sp.h + grab_pad
        );
        var content_hovered = array_contains(input.hovered_container_array, content)
            || array_contains(input.hovered_container_array, content.parent);

        if (hit && content_hovered && input.active_widget_id == undefined) {
            hovered_pane = sp.pane_dir;
            if (input.m_pressed) {
                dock.drag_pane  = sp.pane_dir;
                dock.drag_start = sp.is_vertical ? input.m_x : input.m_y;
            }
        }
    }

    if (dock.drag_pane >= 0 && input.m_held) {
        var pane_data = dock.panes[? dock.drag_pane];
        for (var i = 0; i < array_length(splitters); i++) {
            if (splitters[i].pane_dir == dock.drag_pane) {
                var sp    = splitters[i];
                var delta = sp.is_vertical
                    ? (input.m_x - dock.drag_start) / sp.avail
                    : (input.m_y - dock.drag_start) / sp.avail;

                if (dock.drag_pane == gmui_docking_pane_dir.PANE_RIGHT
                ||  dock.drag_pane == gmui_docking_pane_dir.PANE_BOTTOM) {
                    delta = -delta;
                }

                pane_data.ratio = clamp(pane_data.ratio + delta, min_ratio, 1 - min_ratio);
                dock.drag_start = sp.is_vertical ? input.m_x : input.m_y;
                break;
            }
        }
    }
    if (!input.m_held) { dock.drag_pane = -1; }

	global.gmui.current_container.late_calls_enabled = true;
    for (var i = 0; i < array_length(splitters); i++) {
        var sp  = splitters[i];
        var col = (dock.drag_pane == sp.pane_dir)  ? style.columns_separator_color_active
                : ((hovered_pane  == sp.pane_dir)   ? style.columns_separator_color_hover
                : style.columns_separator_color);
        var draw_w = sp.is_vertical   ? style.columns_separator_width_active : sp.w;
        var draw_h = sp.is_vertical   ? sp.h : style.rows_separator_height_active;
        var draw_x = sp.x + floor((sp.w - draw_w) / 2);
        var draw_y = sp.y + floor((sp.h - draw_h) / 2);
        gmui_add_rectangle(draw_x, draw_y, draw_x + draw_w, draw_y + draw_h, false, col, 1);
    }
	global.gmui.current_container.late_calls_enabled = false;
}

function _gmui_docking_draw_pane(dock_name, pane_dir, tab_name, px, py, pw, ph, pane_data, handler) {
    var gmui  = global.gmui;
    var style = gmui.style;
    var parent = gmui.current_container;

    gmui.current_container = parent;
    parent.context.cursor_x = px;
    parent.context.cursor_y = py;
    parent.context.new_line_requested  = false;
    parent.context.same_line_requested = false;
    parent.context.ignore_cursor_advance_once = true;
	

    var pane_name = dock_name + "_pane_" + string(pane_dir);
    if (!gmui_begin_container(pane_name, 0, 0, pw, ph)) {
		return;
	}

    var pane_container = gmui.current_container;
    pane_container.use_scissor      = true;
    pane_container.scrolling_enabled = false;

	//var tab_flags = (pane_dir == gmui_docking_pane_dir.PANE_CENTER) 
	//    ? gmui_tab_flags.LEAVE_ONE 
	//    : 0;
	var tab_flags = 0;

	pane_data.tab_idx = gmui_tabs(
	    tab_name,
	    pane_data.tab_idx,
	    pw,
	    style.tab_bar_height,
	    dock_name + "_tab_group",
	    {
			on_empty_detach: method({ dock_name: dock_name, pane_dir: pane_dir }, function(tab_data, detached_label) {
			    var cache       = global.gmui.cache;
			    var drop_zones  = cache[? "_dock_drop_zone"];
			    var target_pane = (drop_zones != undefined) ? drop_zones[? dock_name] : -1;

			    if (target_pane == undefined || target_pane < 0 || target_pane == pane_dir) {
					return;
				}

			    var window    = gmui_window_get(dock_name);
			    var dock      = window.state[? "__dock"];
			    var def_ratio = 0.25;
			    if (ds_map_exists(dock.panes, target_pane)) {
			        def_ratio = dock.panes[? target_pane].ratio;
			    }
			    gmui_docking_remove_tab(dock_name, pane_dir, detached_label);
			    gmui_docking_add_tab(dock_name, target_pane, detached_label, def_ratio);
			}),
			on_bar_attach: method({ dock_name: dock_name, pane_dir: pane_dir }, function(tab_data, other_data) {
			    var window = gmui_window_get(dock_name);
			    var dock   = window.state[? "__dock"];
			    var cache  = global.gmui.cache;
    
			    var target_pane = -1;
			    var all_dirs = [
			        gmui_docking_pane_dir.PANE_LEFT,
			        gmui_docking_pane_dir.PANE_RIGHT,
			        gmui_docking_pane_dir.PANE_TOP,
			        gmui_docking_pane_dir.PANE_BOTTOM,
			        gmui_docking_pane_dir.PANE_CENTER,
			    ];
			    for (var i = 0; i < array_length(all_dirs); i++) {
			        var dir      = all_dirs[i];
			        var tn       = dock_name + "_pane_" + string(dir) + "_tabs";
			        var ck       = "_tabs_data_" + tn;
			        if (!ds_map_exists(cache, ck)) { continue; }
			        if (cache[? ck] == other_data) {
			            target_pane = dir;
			            break;
			        }
			    }

			    if (target_pane < 0 || target_pane == pane_dir) { return; }

			    var moved_label = other_data.labels[other_data.selected];

			    var def_ratio = 0.25;
			    if (ds_map_exists(dock.panes, target_pane)) {
			        def_ratio = dock.panes[? target_pane].ratio;
			    }
			    gmui_docking_remove_tab(dock_name, pane_dir, moved_label);
			    gmui_docking_add_tab(dock_name, target_pane, moved_label, def_ratio);
			}),
	        on_tab_select:   undefined,
	        on_tab_close: method({ dock_name: dock_name, pane_dir: pane_dir }, function(tab_data, closed_label) {
	            gmui_docking_remove_tab(dock_name, pane_dir, closed_label);
	        }),
	    },
	    tab_flags
	);

    var content_h = ph - style.tab_bar_height - style.element_spacing_v;
    pane_container.context.cursor_x = 0;
    pane_container.context.cursor_y = style.tab_bar_height + style.element_spacing_v;
    pane_container.context.new_line_requested  = false;
    pane_container.context.ignore_cursor_advance_once = true;
	
	var content_c = gmui_container_get(pane_name + "_content", pane_container);
	content_c.surface_flag = false; // its bound to its parent
	content_c.surface_sleep = false;

    if (gmui_begin_container(pane_name + "_content", 0, 0, pw, content_h)) {
        gmui.current_container.use_scissor      = true;
        gmui.current_container.scrolling_enabled = true;

	    var tab_data = gmui_tab_get_data(tab_name);
	    if (is_undefined(tab_data) || !variable_struct_exists(tab_data, "labels") || array_length(tab_data.labels) == 0) {
	        pane_container.context.ignore_cursor_advance_once = true;
	        return;
	    }

        var labels       = gmui_tab_get_data(tab_name).labels;
        var active_label = labels[clamp(pane_data.tab_idx, 0, array_length(labels) - 1)];
        if (handler != undefined) { handler(active_label); }

        pane_container.context.ignore_cursor_advance_once = true;
        gmui_end_container();
    }

    parent.context.ignore_cursor_advance_once = true;
    gmui_end_container();
    gmui.current_container = parent;
}

function gmui_docking_draw_drop_zones(dock_name) {
    var gmui  = global.gmui;
    var style = gmui.style;
    var input = gmui.input;
    var cache = gmui.cache;

    if (!ds_map_exists(cache, "_detached_tab_visual")) { return; }
    var vis = cache[? "_detached_tab_visual"];
    if (is_undefined(vis) || !vis.active) { return; }
    if (vis.group != dock_name + "_tab_group") { return; }

    var window  = gmui_window_get(dock_name);
    var dock    = window.state[? "__dock"];
    var content = window.content_container;
    var offset  = gmui_get_container_screen_offset(content);

    var cx = offset[0];
    var cy = offset[1];
    var cw = content.width;
    var ch = content.height;

    var pane_rects = ds_map_create();

    var rx = cx, ry = cy, rw = cw, rh = ch;
    for (var i = 0; i < array_length(dock.pane_order); i++) {
        var pane_dir  = dock.pane_order[i];
        var pane_data = dock.panes[? pane_dir];
        var tab_name  = dock_name + "_pane_" + string(pane_dir) + "_tabs";
        if (array_length(gmui_tab_get_data(tab_name).labels) == 0) { continue; }

        switch (pane_dir) {
            case gmui_docking_pane_dir.PANE_LEFT: {
                var pw    = floor(rw * pane_data.ratio);
                var inset = style.columns_separator_inset ?? 2;
                pane_rects[? pane_dir] = [rx, ry, rx + pw - inset, ry + rh];
                rx += pw + inset; rw -= pw + inset * 2;
            } break;
            case gmui_docking_pane_dir.PANE_RIGHT: {
                var pw    = floor(rw * pane_data.ratio);
                var inset = style.columns_separator_inset ?? 2;
                pane_rects[? pane_dir] = [rx + rw - pw + inset, ry, rx + rw, ry + rh];
                rw -= pw + inset * 2;
            } break;
            case gmui_docking_pane_dir.PANE_TOP: {
                var ph    = floor(rh * pane_data.ratio);
                var inset = style.rows_separator_inset ?? 2;
                pane_rects[? pane_dir] = [rx, ry, rx + rw, ry + ph - inset];
                ry += ph + inset; rh -= ph + inset * 2;
            } break;
            case gmui_docking_pane_dir.PANE_BOTTOM: {
                var ph    = floor(rh * pane_data.ratio);
                var inset = style.rows_separator_inset ?? 2;
                pane_rects[? pane_dir] = [rx, ry + rh - ph + inset, rx + rw, ry + rh];
                rh -= ph + inset * 2;
            } break;
        }
    }
    pane_rects[? gmui_docking_pane_dir.PANE_CENTER] = [rx, ry, rx + rw, ry + rh];

    var zone_dirs = [
        gmui_docking_pane_dir.PANE_LEFT,
        gmui_docking_pane_dir.PANE_RIGHT,
        gmui_docking_pane_dir.PANE_TOP,
        gmui_docking_pane_dir.PANE_BOTTOM,
        gmui_docking_pane_dir.PANE_CENTER,
    ];

    var strip = 0.2;
    var fsw = floor(cw * strip);
    var fsh = floor(ch * strip);

    var fallback = ds_map_create();
    fallback[? gmui_docking_pane_dir.PANE_LEFT]   = [cx,            cy,            cx + fsw,       cy + ch        ];
    fallback[? gmui_docking_pane_dir.PANE_RIGHT]  = [cx + cw - fsw, cy,            cx + cw,        cy + ch        ];
    fallback[? gmui_docking_pane_dir.PANE_TOP]    = [cx + fsw,      cy,            cx + cw - fsw,  cy + fsh       ];
    fallback[? gmui_docking_pane_dir.PANE_BOTTOM] = [cx + fsw,      cy + ch - fsh, cx + cw - fsw,  cy + ch        ];
    fallback[? gmui_docking_pane_dir.PANE_CENTER] = [cx + fsw,      cy + fsh,      cx + cw - fsw,  cy + ch - fsh  ];

    var zones = [];
    for (var i = 0; i < array_length(zone_dirs); i++) {
        var dir = zone_dirs[i];
        array_push(zones, [fallback[? dir][0], fallback[? dir][1], fallback[? dir][2], fallback[? dir][3], dir, 0, 0, 0, 0]);
    }

    ds_map_destroy(fallback);
    ds_map_destroy(pane_rects);

    var arrow = 12;
    var pad   = 10;
    for (var i = 0; i < array_length(zones); i++) {
        var z     = zones[i];
        var mid_x = (z[0] + z[2]) / 2;
        var mid_y = (z[1] + z[3]) / 2;
        z[5] = mid_x - arrow - pad;
        z[6] = mid_y - arrow - pad;
        z[7] = mid_x + arrow + pad;
        z[8] = mid_y + arrow + pad;
    }

    var hovered_zone = -1;
    for (var i = 0; i < array_length(zones); i++) {
        var z = zones[i];
        if (point_in_rectangle(input.m_x, input.m_y, z[5], z[6], z[7], z[8])) {
            hovered_zone = z[4];
            break;
        }
    }

    if (!ds_map_exists(cache, "_dock_drop_zone")) { cache[? "_dock_drop_zone"] = ds_map_create(); }
    cache[? "_dock_drop_zone"][? dock_name] = hovered_zone;

    var font_prev = draw_get_font();
    draw_set_font(style.font_text ?? style.font);

    for (var i = 0; i < array_length(zones); i++) {
        var z          = zones[i];
        var is_hovered = (z[4] == hovered_zone);
        var mid_x      = (z[0] + z[2]) / 2;
        var mid_y      = (z[1] + z[3]) / 2;
        var box_x1     = z[5]; var box_y1 = z[6];
        var box_x2     = z[7]; var box_y2 = z[8];

        if (is_hovered) {
            draw_set_alpha(0.25);
            draw_set_color(style.color_accent);
            //draw_rectangle(z[0], z[1], z[2], z[3], false); // tired of this bs, doesnt work properly
        }

        // arrow box
        draw_set_alpha(is_hovered ? 0.9 : 0.4);
        draw_set_color(style.color_accent);
        draw_rectangle(box_x1, box_y1, box_x2, box_y2, false);
        draw_set_alpha(is_hovered ? 1.0 : 0.7);
        draw_rectangle(box_x1, box_y1, box_x2, box_y2, true);

        // arrow
        draw_set_alpha(is_hovered ? 1.0 : 0.6);
        draw_set_color(is_hovered ? style.color_accent : style.text_color);
        switch (z[4]) {
            case gmui_docking_pane_dir.PANE_LEFT:
                draw_triangle(mid_x - arrow, mid_y, mid_x + arrow, mid_y - arrow, mid_x + arrow, mid_y + arrow, false);
                break;
            case gmui_docking_pane_dir.PANE_RIGHT:
                draw_triangle(mid_x + arrow, mid_y, mid_x - arrow, mid_y - arrow, mid_x - arrow, mid_y + arrow, false);
                break;
            case gmui_docking_pane_dir.PANE_TOP:
                draw_triangle(mid_x, mid_y - arrow, mid_x - arrow, mid_y + arrow, mid_x + arrow, mid_y + arrow, false);
                break;
            case gmui_docking_pane_dir.PANE_BOTTOM:
                draw_triangle(mid_x, mid_y + arrow, mid_x - arrow, mid_y - arrow, mid_x + arrow, mid_y - arrow, false);
                break;
            case gmui_docking_pane_dir.PANE_CENTER: {
                var cs = arrow / 2;
                draw_rectangle(mid_x - cs, mid_y - arrow, mid_x + cs, mid_y + arrow, false);
                draw_rectangle(mid_x - arrow, mid_y - cs, mid_x + arrow, mid_y + cs, false);
            } break;
        }
    }

    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_font(font_prev);
}