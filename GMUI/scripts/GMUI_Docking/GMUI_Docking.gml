

// DOCKING
enum gmui_docking_node_type {
	SPLIT 					= 0,
	LEAF 					= 1,
};

enum gmui_docking_split_axis {
	HORIZONTAL				= 0,
	VERTICAL				= 1,
};

enum gmui_docking_split_side {
	BEFORE					= 0,
	AFTER					= 1,
};

enum gmui_docking_zone_direction {
	CENTER					= 0,
	LEFT					= 1,
	RIGHT					= 2,
	TOP						= 3,
	BOTTOM					= 4,
};

function gmui_docking_create_dockspace(name) {
    var window = gmui_window_get(name);
    if (!ds_map_exists(window.state, "__dock")) {
        window.state[? "__dock"] = {
            root:     undefined,
            node_map: ds_map_create(),
            id_counter: 0,
        };
    }
    if (!ds_map_exists(global.gmui.cache, "__dockspace_names")) {
        global.gmui.cache[? "__dockspace_names"] = [];
    }
    if (!array_contains(global.gmui.cache[? "__dockspace_names"], name)) {
        array_push(global.gmui.cache[? "__dockspace_names"], name);
    }
    return window.state[? "__dock"];
}

function _gmui_dock_new_id(dock) {
    var _id = "node_" + string(dock.id_counter);
    dock.id_counter++;
    return _id;
}

function gmui_dock_split(dock, parent_node, direction, ratios, child_index = 0) {
    var node = {
        id:         _gmui_dock_new_id(dock),
        type:       gmui_docking_node_type.SPLIT,
        direction:  direction, // gmui_docking_split_axis.HORIZONTAL = horizontal split (columns), gmui_docking_split_axis.VERTICAL = vertical split (rows)
        children:   [ ],
        ratios:     ratios,
        parent:     parent_node,
        drag_sep:   -1,
        drag_start: 0,
    };

    var sum = 0;
    for (var i = 0; i < array_length(ratios); i++) { sum += ratios[i]; }
    if (sum != 1.0) {
        for (var i = 0; i < array_length(ratios); i++) { node.ratios[i] /= sum; }
    }

    dock.node_map[? node.id] = node;

    if (parent_node == undefined) {
        dock.root = node;
    } else {
        while (array_length(parent_node.children) <= child_index) {
            array_push(parent_node.children, undefined);
        }
        parent_node.children[child_index] = node;
    }

    return node;
}

function gmui_dock_leaf(dock, parent_node, child_index) {
    var node = {
        id:       _gmui_dock_new_id(dock),
        type:     gmui_docking_node_type.LEAF,
        tab_name: "__dock_leaf_" + _gmui_dock_new_id(dock),
        tab_idx:  0,
        parent:   parent_node,
    };

    dock.node_map[? node.id] = node;

    if (parent_node == undefined) {
        dock.root = node;
    } else {
        while (array_length(parent_node.children) <= child_index) {
            array_push(parent_node.children, undefined);
        }
        parent_node.children[child_index] = node;
    }

    return node;
}

function gmui_dock_add_tab(dock, leaf_node, label) {
    if (leaf_node == undefined || leaf_node.type != gmui_docking_node_type.LEAF) { return; }
    gmui_tab_add(leaf_node.tab_name, label);
}

function gmui_dock_remove_tab(dock, leaf_node, label) {
    if (leaf_node == undefined || leaf_node.type != gmui_docking_node_type.LEAF) { return; }
    gmui_tab_delete(leaf_node.tab_name, label);
    var td = gmui_tab_get_data(leaf_node.tab_name);
    if (td == undefined || array_length(td.labels) == 0) {
        _gmui_dock_collapse_leaf(dock, leaf_node);
    }
}

function _gmui_dock_collapse_leaf(dock, leaf_node) {
    gmui_tab_destroy(leaf_node.tab_name);
    ds_map_delete(dock.node_map, leaf_node.id);

    var parent = leaf_node.parent;
    if (parent == undefined) {
        dock.root = undefined;
        return;
    }

    var idx = -1;
    for (var i = 0; i < array_length(parent.children); i++) {
        if (parent.children[i] == leaf_node) { idx = i; break; }
    }
    if (idx < 0) { return; }

    array_delete(parent.children, idx, 1);
    var ratio_idx = min(idx, array_length(parent.ratios) - 1);
    if (array_length(parent.ratios) > 0) {
        array_delete(parent.ratios, ratio_idx, 1);
    }

    var sum = 0;
    for (var i = 0; i < array_length(parent.ratios); i++) { sum += parent.ratios[i]; }
    if (sum > 0) {
        for (var i = 0; i < array_length(parent.ratios); i++) { parent.ratios[i] /= sum; }
    } else if (array_length(parent.ratios) == 0) {
        // no ratios needed for 1 child
    }

    var remaining = array_length(parent.children);

    if (remaining == 0) {
        _gmui_dock_collapse_split(dock, parent);
    } else if (remaining == 1) {
        var survivor    = parent.children[0];
        survivor.parent = parent.parent;
        if (parent.parent == undefined) {
            dock.root = survivor;
        } else {
            var gp = parent.parent;
            for (var i = 0; i < array_length(gp.children); i++) {
                if (gp.children[i] == parent) { gp.children[i] = survivor; break; }
            }
        }
        ds_map_delete(dock.node_map, parent.id);
    }
    // if remaining >= 2, ratios are already renormalized
}

function _gmui_dock_collapse_split(dock, split_node) {
    ds_map_delete(dock.node_map, split_node.id);
    var parent = split_node.parent;
    if (parent == undefined) {
        dock.root = undefined;
        return;
    }
    var idx = -1;
    for (var i = 0; i < array_length(parent.children); i++) {
        if (parent.children[i] == split_node) { idx = i; break; }
    }
    if (idx < 0) { return; }
    array_delete(parent.children, idx, 1);
    array_delete(parent.ratios, idx, 1);
    var sum = 0;
    for (var i = 0; i < array_length(parent.ratios); i++) { sum += parent.ratios[i]; }
    if (sum > 0) {
        for (var i = 0; i < array_length(parent.ratios); i++) { parent.ratios[i] /= sum; }
    }
    if (array_length(parent.children) == 1) {
        var survivor = parent.children[0];
        survivor.parent = parent.parent;
        if (parent.parent == undefined) {
            dock.root = survivor;
        } else {
            var gp = parent.parent;
            for (var i = 0; i < array_length(gp.children); i++) {
                if (gp.children[i] == parent) { gp.children[i] = survivor; break; }
            }
        }
        ds_map_delete(dock.node_map, parent.id);
    }
}

function _gmui_dock_split_leaf(dock, leaf_node, direction, side) { // direction: gmui_docking_split_axis.HORIZONTAL or gmui_docking_split_axis.VERTICAL, side: gmui_docking_split_side.BEFORE or gmui_docking_split_side.AFTER (where new leaf goes)
    var new_leaf = {
        id:       _gmui_dock_new_id(dock),
        type:     gmui_docking_node_type.LEAF,
        tab_name: "__dock_leaf_" + _gmui_dock_new_id(dock),
        tab_idx:  0,
        parent:   undefined,
    };
    dock.node_map[? new_leaf.id] = new_leaf;

    var split = {
        id:        _gmui_dock_new_id(dock),
        type:      gmui_docking_node_type.SPLIT,
        direction: direction,
        children:  (side == gmui_docking_split_side.BEFORE) ? [new_leaf, leaf_node] : [leaf_node, new_leaf],
        ratios:    [0.5, 0.5],
        parent:    leaf_node.parent,
        drag_sep:  -1,
        drag_start: 0,
    };
    dock.node_map[? split.id] = split;

    new_leaf.parent  = split;
    leaf_node.parent = split;

    if (split.parent == undefined) {
        dock.root = split;
    } else {
        var p = split.parent;
        for (var i = 0; i < array_length(p.children); i++) {
            if (p.children[i] == leaf_node) { p.children[i] = split; break; }
        }
    }

    return new_leaf;
}

function gmui_begin_dockspace(dock_name, handler, x = 0, y = 0, width = 1280, height = 720, flags = 0, vertical_shift = 0) {
    var begin_result = gmui_begin(dock_name, x, y, width, height, flags);
    if (!begin_result) { return false; }
    var cache = global.gmui.cache;
    if (!ds_map_exists(cache, "__dockspace_stack")) {
        cache[? "__dockspace_stack"] = [];
    }
    array_push(cache[? "__dockspace_stack"], {
        handler:        handler,
        vertical_shift: vertical_shift,
        dock_name:      dock_name,
    });
    return true;
}

function gmui_end_dockspace() {
    var cache = global.gmui.cache;
    var stack = cache[? "__dockspace_stack"];
    if (stack == undefined || array_length(stack) == 0) { gmui_end(); return; }
    var top = stack[array_length(stack) - 1];
    array_pop(stack);
    gmui_docking_handle_dock(top.dock_name, top.handler, top.vertical_shift);
    gmui_end();
}

function gmui_dockspace(dock_name, handler, window_menus = undefined, toolbar_st = undefined, x = 0, y = 0, width = 1280, height = 720, flags = 0) {
    var vertical_shift = 0;
    if (window_menus != undefined) { vertical_shift += global.gmui.style.window_menu_height; }
    if (toolbar_st   != undefined) { vertical_shift += toolbar_st.height; }

    if (gmui_begin_dockspace(dock_name, handler, x, y, width, height, flags, vertical_shift)) {
        if (vertical_shift != 0) {
            gmui_style_push("container_padding_h", 0);
            gmui_style_push("container_padding_v", 0);
            gmui_cursor_set(0, 0);
            if (window_menus != undefined) {
                gmui_window_menu(window_menus);
                if (toolbar_st != undefined) { gmui_cursor_set(0, global.gmui.style.window_menu_height); }
            }
            if (toolbar_st != undefined) {
                if (window_menus == undefined) { gmui_cursor_set(0, 0); }
                if (gmui_begin_child(dock_name + "_toolbar", gmui_get_available_width(), toolbar_st.height)) {
                    gmui_style_push("element_spacing_h", 2);
                    global.gmui.current_container.context.flow = true;
                    gmui_cursor_set(0, 0);
                    toolbar_st.handler();
                    gmui_style_pop("element_spacing_h");
                    gmui_end_child();
                }
            }
            gmui_style_pop("container_padding_h");
            gmui_style_pop("container_padding_v");
        }
        gmui_end_dockspace();
    }
}

function gmui_docking_handle_dock(dock_name, handler, vertical_shift = 0) {
    var gmui    = global.gmui;
    var window  = gmui_window_get(dock_name);
    var dock    = window.state[? "__dock"];
    if (dock == undefined || dock.root == undefined) { return; }
	
	dock._vertical_shift = vertical_shift;

    var content = gmui.current_container;
    var px = 0;
    var py = vertical_shift;
    var pw = content.width;
    var ph = content.height - vertical_shift;

    if (!variable_struct_exists(dock, "_splitters")) { dock._splitters = [ ]; }
    dock._splitters = [ ];

    _gmui_dock_render_node(dock_name, dock, dock.root, content, px, py, pw, ph, handler);

    var style   = gmui.style;
    var input   = gmui.input;
    var offset  = gmui_get_container_screen_offset(content);
    var grab_pad = style.columns_separator_grab_pad;
    var min_ratio = style.columns_min_ratio;
    var hovered_sep = "";

    for (var i = 0; i < array_length(dock._splitters); i++) {
        var sp = dock._splitters[i];
        var sx = offset[0] + sp.x - content.scroll_x;
        var sy = offset[1] + sp.y - content.scroll_y;
        var hit = point_in_rectangle(input.m_x, input.m_y,
            sx - grab_pad, sy - grab_pad,
            sx + sp.w + grab_pad, sy + sp.h + grab_pad);
        var content_hovered = array_contains(input.hovered_container_array, content)
            || array_contains(input.hovered_container_array, content.parent);

        if (hit && content_hovered && input.active_widget_id == undefined) {
            hovered_sep = sp.node_id + "_" + string(sp.sep_idx);
            if (input.m_pressed) {
                sp.node.drag_sep   = sp.sep_idx;
                sp.node.drag_start = sp.is_vertical ? input.m_x : input.m_y;
            }
        }
    }

    for (var i = 0; i < array_length(dock._splitters); i++) {
	    var sp   = dock._splitters[i];
	    var node = sp.node;
	    if (node.drag_sep != sp.sep_idx) { continue; }
	    if (!input.m_held) { node.drag_sep = -1; continue; }

	    var delta = sp.is_vertical
	        ? (input.m_x - node.drag_start) / sp.avail
	        : (input.m_y - node.drag_start) / sp.avail;
	    node.drag_start = sp.is_vertical ? input.m_x : input.m_y;

	    var a = sp.sep_idx;
	    var b = sp.sep_idx + 1;
	    var combined = node.ratios[a] + node.ratios[b];

	    var old_a_px = node.ratios[a] * sp.avail;
	    var old_b_px = node.ratios[b] * sp.avail;

	    node.ratios[a] = clamp(node.ratios[a] + delta, min_ratio, combined - min_ratio);
	    node.ratios[b] = combined - node.ratios[a];

	    var new_a_px = node.ratios[a] * sp.avail;
	    var new_b_px = node.ratios[b] * sp.avail;

	    _gmui_dock_compensate_edge(node.children[a], old_a_px, new_a_px, "last", sp.is_vertical);
	    _gmui_dock_compensate_edge(node.children[b], old_b_px, new_b_px, "first", sp.is_vertical);
	}
    if (!input.m_held) {
        var keys = ds_map_keys_to_array(dock.node_map);
        for (var i = 0; i < array_length(keys); i++) {
            var n = dock.node_map[? keys[i]];
            if (n.type == gmui_docking_node_type.SPLIT) { n.drag_sep = -1; }
        }
    }

    gmui.current_container = content;
    gmui.current_container.late_calls_enabled = true;
    for (var i = 0; i < array_length(dock._splitters); i++) {
        var sp      = dock._splitters[i];
        var sep_key = sp.node_id + "_" + string(sp.sep_idx);
        var is_drag = (sp.node.drag_sep == sp.sep_idx);
        var is_hov  = (hovered_sep == sep_key);
        var col     = is_drag ? style.columns_separator_color_active
                    : (is_hov  ? style.columns_separator_color_hover
                    : style.columns_separator_color);
        var draw_w  = sp.is_vertical ? style.columns_separator_width_active : sp.w;
        var draw_h  = sp.is_vertical ? sp.h : style.rows_separator_height_active;
        var draw_x  = sp.x + floor((sp.w - draw_w) / 2);
        var draw_y  = sp.y + floor((sp.h - draw_h) / 2);
        gmui_add_rectangle(draw_x, draw_y, draw_x + draw_w, draw_y + draw_h, false, col, 1);
    }
    gmui.current_container.late_calls_enabled = false;
}

function _gmui_dock_render_node(dock_name, dock, node, content, px, py, pw, ph, handler) {
    if (node == undefined) { return; }
    if (pw <= 0 || ph <= 0) { return; }
    if (node.type == gmui_docking_node_type.LEAF) {
        _gmui_dock_render_leaf(dock_name, dock, node, content, px, py, pw, ph, handler);
        return;
    }

    var style    = global.gmui.style;
    var sep_w    = style.columns_separator_width;
    var sep_h    = style.rows_separator_height;
    var inset_h  = style.columns_separator_inset ?? 2;
    var inset_v  = style.rows_separator_inset ?? 2;
    var is_horiz = (node.direction == gmui_docking_split_axis.HORIZONTAL);
    var n        = array_length(node.children);
    if (n == 0) { return; }

    var sep_size  = is_horiz ? sep_w : sep_h;
    var avail     = is_horiz ? pw : ph;
    var total_sep = sep_size * (n - 1);
    var cursor    = is_horiz ? px : py;

    var children_snap = array_create(n);
	array_copy(children_snap, 0, node.children, 0, n);
    var ratios_snap   = array_create(n);
	array_copy(ratios_snap, 0, node.ratios, 0, min(array_length(node.ratios), n));

    var child_rects = array_create(n);
    for (var i = 0; i < n; i++) {
        var ratio = (i < array_length(ratios_snap)) ? ratios_snap[i] : (1.0 / n);
        var size  = floor((avail - total_sep) * ratio);
        if (i == n - 1) {
            size = max(1, (is_horiz ? (px + pw) : (py + ph)) - cursor);
        }
        if (is_horiz) {
            child_rects[i] = { x: cursor, y: py, w: max(1, size - inset_h), h: ph };
        } else {
            child_rects[i] = { x: px, y: cursor, w: pw, h: max(1, size - inset_v) };
        }
        cursor += size + sep_size;
    }

    var splitter_cursor = is_horiz ? px : py;
    for (var i = 0; i < n - 1; i++) {
        var ratio = (i < array_length(ratios_snap)) ? ratios_snap[i] : (1.0 / n);
        var size  = floor((avail - total_sep) * ratio);
        var sp = {
            node:        node,
            node_id:     node.id,
            sep_idx:     i,
            is_vertical: is_horiz,
            avail:       avail - total_sep,
        };
        if (is_horiz) {
            sp.x = splitter_cursor + size - inset_h;
            sp.y = py; sp.w = sep_w; sp.h = ph;
        } else {
            sp.x = px; sp.y = splitter_cursor + size - inset_v;
            sp.w = pw; sp.h = sep_h;
        }
        array_push(dock._splitters, sp);
        splitter_cursor += size + sep_size;
    }

    for (var i = 0; i < array_length(children_snap); i++) {
        var r = child_rects[i];
        _gmui_dock_render_node(dock_name, dock, children_snap[i], content, r.x, r.y, r.w, r.h, handler);
    }
}

function _gmui_dock_render_leaf(dock_name, dock, node, content, px, py, pw, ph, handler) {
    var gmui   = global.gmui;
    var style  = gmui.style;
    var parent = content;

    gmui.current_container = parent;
    parent.context.cursor_x = px;
    parent.context.cursor_y = py;
    parent.context.new_line_requested  = false;
    parent.context.same_line_requested = false;
    parent.context.ignore_cursor_advance_once = true;

    var pane_name = dock_name + "_leaf_" + node.id;
    if (!gmui_begin_container(pane_name, 0, 0, pw, ph)) { return; }

    var pane_container = gmui.current_container;
    pane_container.use_scissor      = true;
    pane_container.scrolling_enabled = false;

    node.tab_idx = gmui_tabs(
        node.tab_name,
        node.tab_idx,
        pw,
        style.tab_bar_height,
        dock_name + "_tab_group",
        {
            on_empty_detach: method({ dock_name: dock_name, dock: dock, node: node }, function(tab_data, detached_label) {
                var cache      = global.gmui.cache;
                var drop       = cache[? "_dock_drop"];
                if (drop == undefined || drop.dock_name != dock_name) { return; }

                var target_node = drop.node;
                var zone        = drop.zone;
                if (target_node == undefined) { return; }

                if (zone == gmui_docking_zone_direction.CENTER) {
                    if (target_node == node) { return; }
                    gmui_dock_remove_tab(dock, node, detached_label);
                    gmui_dock_add_tab(dock, target_node, detached_label);
                } else {
                    var dir  = (zone == gmui_docking_zone_direction.LEFT  || zone == gmui_docking_zone_direction.RIGHT)  ? gmui_docking_split_axis.HORIZONTAL : gmui_docking_split_axis.VERTICAL;
                    var side = (zone == gmui_docking_zone_direction.LEFT   || zone == gmui_docking_zone_direction.TOP)    ? gmui_docking_split_side.BEFORE : gmui_docking_split_side.AFTER;
                    var new_leaf = _gmui_dock_split_leaf(dock, target_node, dir, side);
                    gmui_dock_remove_tab(dock, node, detached_label);
                    gmui_dock_add_tab(dock, new_leaf, detached_label);
                }
            }),
            on_bar_attach: method({ dock_name: dock_name, dock: dock, node: node }, function(tab_data, other_data) {
                var cache = global.gmui.cache;
                var keys = ds_map_keys_to_array(dock.node_map);
                var target_node = undefined;
                for (var i = 0; i < array_length(keys); i++) {
                    var n = dock.node_map[? keys[i]];
                    if (n.type != gmui_docking_node_type.LEAF) { continue; }
                    var ck = "_tabs_data_" + n.tab_name;
                    if (ds_map_exists(cache, ck) && cache[? ck] == other_data) {
                        target_node = n;
                        break;
                    }
                }
                if (target_node == undefined || target_node == node) { return; }
                var moved_label = other_data.labels[other_data.selected];
                gmui_dock_remove_tab(dock, node, moved_label);
                gmui_dock_add_tab(dock, target_node, moved_label);
            }),
            on_tab_select: undefined,
            on_tab_close: method({ dock_name: dock_name, dock: dock, node: node }, function(tab_data, closed_label) {
                gmui_dock_remove_tab(dock, node, closed_label);
            }),
        },
        0
    );

    var content_h = ph - style.tab_bar_height - style.element_spacing_v;
    pane_container.context.cursor_x = 0;
    pane_container.context.cursor_y = style.tab_bar_height + style.element_spacing_v;
    pane_container.context.new_line_requested  = false;
    pane_container.context.ignore_cursor_advance_once = true;

    var content_c = gmui_container_get(pane_name + "_content", pane_container);
    content_c.surface_flag  = true;
    content_c.surface_sleep = true;
    content_c.widget_flag   = true;

    if (gmui_begin_container(pane_name + "_content", 0, 0, pw, max(1, content_h))) {
        gmui.current_container.use_scissor      = true;
        gmui.current_container.scrolling_enabled = true;

        var td = gmui_tab_get_data(node.tab_name);
        if (td != undefined && variable_struct_exists(td, "labels") && array_length(td.labels) > 0) {
            var active_label = td.labels[clamp(node.tab_idx, 0, array_length(td.labels) - 1)];
            if (handler != undefined) { handler(active_label); }
        }

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
    if (dock == undefined || dock.root == undefined) { return; }
    var content = window.content_container;
    var offset  = gmui_get_container_screen_offset(content);

    var vertical_shift = variable_struct_exists(dock, "_vertical_shift") ? dock._vertical_shift : 0;
	var hovered_leaf = _gmui_dock_find_leaf_at(dock.root, offset,
	    input.m_x, input.m_y, content,
	    offset[0], offset[1] + vertical_shift, content.width, content.height - vertical_shift);

    cache[? "_dock_drop"] = undefined;

    if (hovered_leaf == undefined) {
        draw_set_alpha(1); draw_set_color(c_white);
        return;
    }

    var leaf_rect = _gmui_dock_get_node_rect(dock, dock.root, hovered_leaf,
        offset[0], offset[1], content.width, content.height);
    if (leaf_rect == undefined) { return; }

    var lx = leaf_rect.x;
    var ly = leaf_rect.y;
    var lw = leaf_rect.w;
    var lh = leaf_rect.h;

    var arrow  = 12;
    var pad    = 10;
    var box_sz = arrow + pad;

    var zones = [
        { zone: gmui_docking_zone_direction.CENTER, mx: lx + lw/2,       my: ly + lh/2       },
        { zone: gmui_docking_zone_direction.LEFT,   mx: lx + lw*0.2,     my: ly + lh/2       },
        { zone: gmui_docking_zone_direction.RIGHT,  mx: lx + lw*0.8,     my: ly + lh/2       },
        { zone: gmui_docking_zone_direction.TOP,    mx: lx + lw/2,        my: ly + lh*0.2     },
        { zone: gmui_docking_zone_direction.BOTTOM, mx: lx + lw/2,        my: ly + lh*0.8     },
    ];

    var hovered_zone = undefined;
    for (var i = 0; i < array_length(zones); i++) {
        var z = zones[i];
        if (point_in_rectangle(input.m_x, input.m_y,
            z.mx - box_sz, z.my - box_sz, z.mx + box_sz, z.my + box_sz)) {
            hovered_zone = z.zone;
            break;
        }
    }

    if (hovered_zone != undefined) {
        cache[? "_dock_drop"] = {
            dock_name: dock_name,
            node:      hovered_leaf,
            zone:      hovered_zone,
        };
    }

    if (hovered_zone != undefined) {
        draw_set_alpha(0.15);
        draw_set_color(style.color_accent);
        //draw_rectangle(lx, ly, lx + lw, ly + lh, false); // still doesnt get the zone right
    }

    var font_prev = draw_get_font();
    draw_set_font(style.font_text ?? style.font);

    for (var i = 0; i < array_length(zones); i++) {
        var z          = zones[i];
        var is_hovered = (z.zone == hovered_zone);
        var bx1 = z.mx - box_sz; var by1 = z.my - box_sz;
        var bx2 = z.mx + box_sz; var by2 = z.my + box_sz;

        draw_set_alpha(is_hovered ? 0.9 : 0.4);
        draw_set_color(style.color_accent);
        draw_rectangle(bx1, by1, bx2, by2, false);
        draw_set_alpha(is_hovered ? 1.0 : 0.7);
        draw_rectangle(bx1, by1, bx2, by2, true);

        draw_set_alpha(is_hovered ? 1.0 : 0.6);
        draw_set_color(is_hovered ? style.color_accent : style.text_color);

        switch (z.zone) {
            case gmui_docking_zone_direction.LEFT:
                draw_triangle(z.mx-arrow, z.my, z.mx+arrow, z.my-arrow, z.mx+arrow, z.my+arrow, false);
                break;
            case gmui_docking_zone_direction.RIGHT:
                draw_triangle(z.mx+arrow, z.my, z.mx-arrow, z.my-arrow, z.mx-arrow, z.my+arrow, false);
                break;
            case gmui_docking_zone_direction.TOP:
                draw_triangle(z.mx, z.my-arrow, z.mx-arrow, z.my+arrow, z.mx+arrow, z.my+arrow, false);
                break;
            case gmui_docking_zone_direction.BOTTOM:
                draw_triangle(z.mx, z.my+arrow, z.mx-arrow, z.my-arrow, z.mx+arrow, z.my-arrow, false);
                break;
            case gmui_docking_zone_direction.CENTER: {
                var cs = arrow/2;
                draw_rectangle(z.mx-cs,    z.my-arrow, z.mx+cs,    z.my+arrow, false);
                draw_rectangle(z.mx-arrow, z.my-cs,    z.mx+arrow, z.my+cs,    false);
            } break;
        }
    }

    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_font(font_prev);
}

function _gmui_dock_find_leaf_at(node, offset, mx, my, content, sx, sy, sw, sh) {
    if (node == undefined) { return undefined; }
    if (sw <= 0 || sh <= 0) { return undefined; }

    if (node.type == gmui_docking_node_type.LEAF) {
        if (point_in_rectangle(mx, my, sx, sy, sx + sw, sy + sh)) {
            return node;
        }
        return undefined;
    }

    var style    = global.gmui.style;
    var sep_w    = style.columns_separator_width;
    var sep_h    = style.rows_separator_height;
    var inset_h  = style.columns_separator_inset ?? 2;
    var inset_v  = style.rows_separator_inset ?? 2;
    var is_horiz = (node.direction == gmui_docking_split_axis.HORIZONTAL);
    var n        = array_length(node.children);
    var sep_size = is_horiz ? sep_w : sep_h;
    var avail    = is_horiz ? sw : sh;
    var total_sep = sep_size * (n - 1);
    var cursor   = is_horiz ? sx : sy;

    for (var i = 0; i < n; i++) {
        var size = floor((avail - total_sep) * node.ratios[i]);
        if (i == n - 1) {
            size = max(1, (is_horiz ? (sx + sw) : (sy + sh)) - cursor);
        }
        var cx = is_horiz ? cursor : sx;
        var cy = is_horiz ? sy     : cursor;
        var cw = is_horiz ? max(1, size - inset_h) : sw;
        var ch = is_horiz ? sh : max(1, size - inset_v);

        var result = _gmui_dock_find_leaf_at(node.children[i], offset, mx, my, content, cx, cy, cw, ch);
        if (result != undefined) { return result; }

        cursor += size + sep_size;
    }
    return undefined;
}

function _gmui_dock_get_node_rect(dock, node, target, sx, sy, sw, sh) {
    if (node == undefined) { return undefined; }
    if (node == target) { return { x: sx, y: sy, w: sw, h: sh }; }
    if (node.type == gmui_docking_node_type.LEAF) { return undefined; }

    var style    = global.gmui.style;
    var sep_w    = style.columns_separator_width;
    var sep_h    = style.rows_separator_height;
    var inset_h  = style.columns_separator_inset ?? 2;
    var inset_v  = style.rows_separator_inset ?? 2;
    var is_horiz = (node.direction == gmui_docking_split_axis.HORIZONTAL);
    var n        = array_length(node.children);
    var sep_size = is_horiz ? sep_w : sep_h;
    var avail    = is_horiz ? sw : sh;
    var total_sep = sep_size * (n - 1);
    var cursor   = is_horiz ? sx : sy;

    for (var i = 0; i < n; i++) {
        var size = floor((avail - total_sep) * node.ratios[i]);
        if (i == n - 1) {
            size = (is_horiz ? (sx + sw) : (sy + sh)) - cursor - 0;
            size = max(1, size);
        }
        var cx = is_horiz ? cursor       : sx;
        var cy = is_horiz ? sy           : cursor;
        var cw = is_horiz ? max(1, size - inset_h) : sw;
        var ch = is_horiz ? sh           : max(1, size - inset_v);

        var result = _gmui_dock_get_node_rect(dock, node.children[i], target, cx, cy, cw, ch);
        if (result != undefined) { return result; }
        cursor += size + sep_size;
    }
    return undefined;
}

function _gmui_dock_compensate_edge(node, old_px, new_px, edge, is_horiz) {
    if (node == undefined) { return; }
    if (node.type != gmui_docking_node_type.SPLIT) { return; }
    if (node.direction != (is_horiz ? gmui_docking_split_axis.HORIZONTAL : gmui_docking_split_axis.VERTICAL)) { return; }

    var n = array_length(node.children);
    if (n < 2) { return; }

    var style    = global.gmui.style;
    var sep_size = is_horiz ? style.columns_separator_width : style.rows_separator_height;
    var old_usable = old_px - sep_size * (n - 1);
    var new_usable = new_px - sep_size * (n - 1);
    if (old_usable <= 0 || new_usable <= 0) { return; }

    var edge_idx = (edge == "last") ? n - 1 : 0;
    var min_r    = style.columns_min_ratio;

    var fixed_px = 0;
    for (var i = 0; i < n; i++) {
        if (i != edge_idx) {
            fixed_px += node.ratios[i] * old_usable;
        }
    }
    var edge_px_new = max(min_r * new_usable, new_usable - fixed_px);

    for (var i = 0; i < n; i++) {
        if (i != edge_idx) {
            node.ratios[i] = (node.ratios[i] * old_usable) / new_usable;
        } else {
            node.ratios[i] = edge_px_new / new_usable;
        }
    }

    var sum = 0;
    for (var i = 0; i < n; i++) { sum += node.ratios[i]; }
    if (sum > 0) {
        for (var i = 0; i < n; i++) { node.ratios[i] /= sum; }
    }

    var old_edge_px = node.ratios[edge_idx] * old_usable;
    var new_edge_px = node.ratios[edge_idx] * new_usable;
    _gmui_dock_compensate_edge(node.children[edge_idx], old_edge_px, new_edge_px, edge, is_horiz);
}