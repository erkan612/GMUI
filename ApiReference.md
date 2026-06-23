# GMUI API Reference

## Table of Contents

- [Core](#core) — 15 functions (GMUI_Core.gml)
- [Style](#style) — 20 functions (GMUI_Style.gml)
- [Color](#color) — 30 functions (GMUI_Color.gml)
- [Input](#input) — 15 functions (GMUI_Input.gml)
- [Draw / Visual Calls](#draw--visual-calls) — 4 functions (GMUI_Draw.gml)
- [Layout](#layout) — 18 functions (GMUI_Layout.gml)
- [Flex Layout](#flex-layout) — 6 functions (GMUI_Flex.gml)
- [Widget (base)](#widget-base) — 9 functions (GMUI_Widget.gml)
- [Container](#container) — 55 functions (GMUI_Container.gml)
- [Window](#window) — 9 functions (GMUI_Window.gml)
- [Window Menu](#window-menu) — 2 functions (GMUI_WindowMenu.gml)
- [Docking](#docking) — 10 functions (GMUI_Docking.gml)
- [WINS](#wins) — 7 functions (GMUI_WINS.gml)
- [Rows](#rows) — 5 functions (GMUI_Rows.gml)
- [Columns](#columns) — 5 functions (GMUI_Columns.gml)
- [Display Widgets](#display-widgets) — 30 functions (GMUI_DisplayWidgets.gml)
- [Input Widgets](#input-widgets) — 121 functions (GMUI_InputWidgets.gml)
- [Plot Widgets](#plot-widgets) — 24 functions (GMUI_PlotWidgets.gml)
- [Context Menu](#context-menu) — 24 functions (GMUI_ContextMenu.gml)
- [Popup](#popup) — 10 functions (GMUI_Popup.gml)
- [Drag and Drop](#drag-and-drop) — 11 functions (GMUI_DragAndDrop.gml)
- [Animation](#animation) — 139 functions (GMUI_Animation.gml)
- [Sleeper](#sleeper) — 2 functions (GMUI_Sleeper.gml)
- [Calls](#calls) — 28 functions (GMUI_Calls.gml)
- [Misc](#misc) — 16 functions (GMUI_Misc.gml)
- [Profile](#profile) — 2 functions (GMUI_Profile.gml)
- [Demo](#demo) — 2 functions (GMUI_Demo.gml)
- [Anim Tests (object script)](#anim-tests-object-script) — 1 functions (cAnimTests.gml)

---


## Core (`GMUI_Core.gml`)

- `gmui_get()`
- `gmui_get_cache()`
- `gmui_cache_get(name)`
- `gmui_cache_set(name, value)`
- `gmui_get_update_calls()`
- `gmui_get_cleanup_calls()`
- `gmui_update()`
- `gmui_draw_gui()`
- `gmui_get_font()`
- `gmui_set_font(font)`
- `gmui_begin(name, x = -1, y = -1, width = -1, height = -1, flags = 0)`
- `gmui_end()`
- `gmui_begin_child(name, width = -1, height = -1)`
- `gmui_end_child()`
- `gmui_cleanup()`

## Style (`GMUI_Style.gml`)


**STYLE**

- `gmui_style_init()`
- `gmui_style_apply_ruler(_ruler = undefined)`
- `gmui_style_apply_theme_dark()`
- `gmui_style_apply_theme_light()`
- `gmui_style_apply_theme_dark_gray()`
- `gmui_style_apply_theme_cyan()`
- `gmui_style_apply_theme_emerald()`
- `gmui_style_apply_theme_amber()`
- `gmui_style_apply_theme_crimson()`
- `gmui_style_push(key, value)`
- `gmui_style_pop(key)`
- `gmui_style_push_multi(map)`
- `gmui_style_pop_multi(keys_array)`
- `gmui_style_get(key)`
- `gmui_style_set(key, value)`
- `gmui_style_scope(key, value, func)`
- `gmui_style_scope_multi(map, func)`
- `gmui_with_style(key, value, func)`
- `gmui_with_style_multi(style_map, func)`
- `gmui_get_style()`

## Color (`GMUI_Color.gml`)


**space conversion**

- `gmui_hsv_to_rgb(h, s, v)`
- `gmui_rgb_to_hsv(r, g, b)`
- `gmui_color_to_hsv(color)`
- `gmui_color_from_hsv(hsv)`
- `gmui_make_color_rgba(r, g, b, a)`
- `gmui_color_rgba_get_red(color)`
- `gmui_color_rgba_get_green(color)`
- `gmui_color_rgba_get_blue(color)`
- `gmui_color_rgba_get_alpha(color)`
- `gmui_color_rgb_to_rgba(color, alpha = 255)`
- `gmui_color_rgba_to_rgb(color)`

**array stuff**

- `gmui_color_rgba_to_array(color)`
- `gmui_color_rgb_to_array(color)`
- `gmui_color_rgba_from_array(arr)`

**manipulation**

- `gmui_color_scale(color, factor)`
- `gmui_color_lighten(color, factor)`
- `gmui_color_darken(color, factor)`
- `gmui_color_set_alpha(color, alpha)`
- `gmui_color_shift_hue(color, delta)`
- `gmui_color_saturate(color, factor)`
- `gmui_color_premultiply_alpha(color)`

**interpolation**

- `gmui_color_lerp(color1, color2, t)`
- `gmui_lerp_rgba_gradient(gradient, t)`

**parsing**

- `gmui_color_from_hex(hex_str)`
- `gmui_color_rgba_from_hex(hex_str)`
- `gmui_color_to_hex(color)`
- `gmui_color_rgba_to_hex(color)`
- `gmui_color_rgba_to_css(color)`
- `gmui_color_rgba_from_css(css_str)`
- `gmui_color_from_name(name)`

## Input (`GMUI_Input.gml`)


**INPUT**

- `gmui_update_input()`

**Mouse**

- `gmui_input_mouse_pressed()`
- `gmui_input_mouse_released()`
- `gmui_input_mouse_held()`
- `gmui_input_mouse_x()`
- `gmui_input_mouse_y()`
- `gmui_input_is_hovered(x, y, width, height)`

**Keyboard**

- `gmui_input_key_pressed()`
- `gmui_input_key()`
- `gmui_input_lastchar()`
- `gmui_input_lastkey()`
- `gmui_input_ctrl()`
- `gmui_input_shift()`
- `gmui_input_alt()`
- `gmui_input_key_held(key)`

## Draw / Visual Calls (`GMUI_Draw.gml`)


**DRAW**

- `gmui_get_default_visual_calls()`
- `gmui_get_high_quality_visual_calls()`
- `gmui_default_background_draw_call(container, x1, y1, x2, y2)`
- `gmui_default_mask_draw_call(container, x1, y1, x2, y2)`

## Layout (`GMUI_Layout.gml`)


**LAYOUT**

- `gmui_newline()`
- `gmui_sameline()`
- `gmui_indent(amount)`
- `gmui_unindent(amount)`
- `gmui_spacing()`
- `gmui_spacing_h()`
- `gmui_indent_push(amount = -1)`
- `gmui_indent_pop(amount = -1)`
- `gmui_cursor_set(x, y)`
- `gmui_cursor_set_x(x)`
- `gmui_cursor_set_y(y)`
- `gmui_cursor_get()`
- `gmui_cursor_get_x()`
- `gmui_cursor_get_y()`
- `gmui_cursor_get_line_height()`
- `gmui_cursor_set_line_height(height)`
- `gmui_get_available_width(container = undefined)`
- `gmui_get_available_height(container = undefined)`

## Flex Layout (`GMUI_Flex.gml`)


**FLEX (WINS wrapper)**

- `gmui_begin_flex(direction, ratios = undefined, resize_enabled = true, flow = undefined)`
- `gmui_end_flex()`
- `gmui_begin_flex_child()`
- `gmui_end_flex_child()`
- `gmui_begin_flex_child_flow()`
- `gmui_end_flex_child_flow()`

## Widget (base) (`GMUI_Widget.gml`)


**WIDGETS**

- `gmui_begin_widget(type = "unnamed", id = undefined)`
- `gmui_end_widget(widget, is_interactive = false)`
- `gmui_widget_is_callable(widget)`
- `gmui_widget_is_visible(widget)`
- `gmui_widget_is_hovered(widget, _offset)`
- `gmui_widget_is_pressed(widget)`
- `gmui_widget_is_active(widget)`
- `gmui_widget_mouse_interactive_behaviour(widget)`
- `gmui_widget_get_last()`

## Container (`GMUI_Container.gml`)


**CONTAINER**

- `gmui_container_get(name, parent = undefined)`
- `gmui_container_enable_late_calls(container = undefined)`
- `gmui_container_disable_late_calls(container = undefined)`
- `gmui_container_surface_flag_enable(container = undefined)`
- `gmui_container_surface_flag_disable(container = undefined)`
- `gmui_container_surface_flag_toggle(container = undefined)`
- `gmui_container_surface_dirty(container = undefined)`
- `gmui_container_surface_flag_enable_recursive(container = undefined)`
- `gmui_container_surface_flag_disable_recursive(container = undefined)`
- `gmui_container_get_context()`
- `gmui_begin_container(name, x = 0, y = 0, width = 100, height = 100, is_nested = true)`
- `gmui_end_container()`
- `gmui_begin_container_plain(name, x = 0, y = 0, width = 100, height = 100)`
- `gmui_end_container_plain()`
- `gmui_begin_container(name, x = 0, y = 0, width = 100, height = 100)`
- `gmui_end_container()`
- `gmui_begin_container_plain(name, x, y, width, height)`
- `gmui_end_container_plain()`
- `gmui_begin_container_flow(name, x = 0, y = 0, width = 100, height = 100)`
- `gmui_end_container_flow()`
- `gmui_container_surface_create(container, format = surface_rgba8unorm, refresh = false)`
- `gmui_container_surface_free(container)`
- `gmui_handle_container_calls(container)`
- `gmui_container_early_exit_cleanup(container)`
- `gmui_draw_container(container)`
- `gmui_get_container_screen_offset(container)`
- `gmui_container_sort_z_index(container)`
- `gmui_container_calculate_mouse_hovering(container)`
- `gmui_handle_scroll_bubble()`
- `gmui_container_ignore_cursor_advance_once(container = undefined)`
- `gmui_container_cursor_advance(container = undefined)`
- `gmui_container_destroy(container)`
- `gmui_container_is_active(name, parent = undefined)`
- `gmui_container_enable(name, parent = undefined)`
- `gmui_container_disable(name, parent = undefined)`
- `gmui_container_toggle(name, parent = undefined)`
- `gmui_container_set_pos(name, x, y, parent = undefined)`
- `gmui_container_get_screen_pos(name, parent = undefined)`
- `gmui_container_set_size(name, w, h, parent = undefined)`
- `gmui_container_set_width(name, w, parent = undefined)`
- `gmui_container_set_height(name, h, parent = undefined)`
- `gmui_container_get_size(name, parent = undefined)`
- `gmui_container_set_bounds(name, x, y, w, h, parent = undefined)`
- `gmui_container_get_bounds(name, parent = undefined)`
- `gmui_container_bring_to_front(name, parent = undefined)`
- `gmui_container_send_to_back(name)`
- `gmui_container_set_z(name, z, parent = undefined)`
- `gmui_container_get_z(name, parent = undefined)`
- `gmui_container_set_surface(name, enable, parent = undefined)`
- `gmui_container_is_hovered(name, parent = undefined)`
- `gmui_group(name, func)`
- `gmui_group_ex(name, width, height, func)`
- `gmui_child(name, width, height, func)`
- `gmui_scrolling_child(name, width, height, func)`
- `gmui_container_animation_detected(container = undefined)`

## Window (`GMUI_Window.gml`)


**WINDOW**

- `gmui_window_get(name)`
- `gmui_begin_window(name, x = -1, y = -1, width = -1, height = -1, flags = 0)`
- `gmui_end_window()`
- `gmui_default_window_border_handler(window)`
- `gmui_default_window_title_handler(window)`
- `gmui_center_window(name)`
- `gmui_window_toggle(name)`
- `gmui_window_is_open(name)`
- `gmui_window_change_name(window, new_name)`

## Window Menu (`GMUI_WindowMenu.gml`)


**WINDOW MENU**

- `gmui_window_menu(menu_array)`
- `gmui_menu_item(text, ctx_name)`

## Docking (`GMUI_Docking.gml`)

- `gmui_docking_create_dockspace(name)`
- `gmui_dock_split(dock, parent_node, direction, ratios, child_index = 0)`
- `gmui_dock_leaf(dock, parent_node, child_index)`
- `gmui_dock_add_tab(dock, leaf_node, label)`
- `gmui_dock_remove_tab(dock, leaf_node, label)`
- `gmui_begin_dockspace(dock_name, handler, x = 0, y = 0, width = 1280, height = 720, flags = 0, vertical_shift = 0)`
- `gmui_end_dockspace()`
- `gmui_dockspace(dock_name, handler, window_menus = undefined, toolbar_st = undefined, x = 0, y = 0, width = 1280, height = 720, flags = 0)`
- `gmui_docking_handle_dock(dock_name, handler, vertical_shift = 0)`
- `gmui_docking_draw_drop_zones(dock_name)`

## WINS (`GMUI_WINS.gml`)


**WINS**

- `gmui_begin_wins_space()`
- `gmui_end_wins_space()`
- `gmui_begin_wins(name, direction, ratios = undefined, resize_enabled = true)`
- `gmui_begin_wins_pane(index, properties = undefined, flow = false)`
- `gmui_end_wins_pane()`
- `gmui_end_wins()`
- `gmui_get_current_wins_pane()`

## Rows (`GMUI_Rows.gml`)


**ROWS**

- `gmui_begin_rows(count, ratios = undefined, width = 200, resize_enabled = true)`
- `gmui_end_row()`
- `gmui_begin_row(idx, properties = undefined, flow = false)`
- `gmui_end_rows()`
- `gmui_auto_row(columns, row_count, row_ratios = undefined, col_width = 28, show_separators = false, resize_enable = true)`

## Columns (`GMUI_Columns.gml`)


**COLUMNS**

- `gmui_begin_columns(count, ratios = undefined, height = 200, resize_enabled = true)`
- `gmui_end_column()`
- `gmui_begin_column(idx, properties = undefined, flow = false)`
- `gmui_end_columns()`
- `gmui_auto_column(rows, column_count, column_ratios = undefined, row_height = 28, show_separators = false, resize_enable = true)`

## Display Widgets (`GMUI_DisplayWidgets.gml`)


**text**

- `gmui_text(text, font = undefined)`
- `gmui_text_disabled(text, font = undefined)`
- `gmui_text_colored(text, color, font = undefined)`
- `gmui_text_bullet(text, font = undefined)`
- `gmui_text_wrap(text, width = -1, font = undefined)`
- `gmui_text_label(label, value, font = undefined)`

**separator**

- `gmui_separator()`
- `gmui_separator_vertical(stay = true, new_line = false, height = -1)`
- `gmui_separator_text(text, font = undefined)`
- `gmui_separator_text_left(text, font = undefined)`

**dummy**

- `gmui_dummy(width, height)`

**image**

- `gmui_sprite(sprite, subimg = 0, width = -1, height = -1)`
- `gmui_surface(surface)`

**progress**

- `gmui_progress_bar(value, min_val = 0, max_val = 1, width = -1, show_text = true, font = undefined)`
- `gmui_progress_bar_indeterminate(width = -1)`
- `gmui_progress_circular(value, min_val = 0, max_val = 1, size = -1, show_text = true, font = undefined)`
- `gmui_progress_spinner(size = -1, thickness = -1)`
- `gmui_progress(value, max_val, width = -1, show_text = true, font = undefined)`
- `gmui_progress_percent(percent, width = -1, show_text = true, font = undefined)`

**tooltip**

- `gmui_tooltip(text, widget = undefined, width = -1, color = undefined, font = undefined)`
- `gmui_tooltip_on_last(text, width = -1, font = undefined)`
- `gmui_tooltip_on_hover(widget, text, width = -1, font = undefined)`
- `gmui_set_tooltip(text, x = -1, y = -1, width = -1, font = undefined)`

**toast notification**

- `gmui_toast_push(message, type = "info", duration = -1)`
- `gmui_toast_info(message, duration = -1)`
- `gmui_toast_success(message, duration = -1)`
- `gmui_toast_warning(message, duration = -1)`
- `gmui_toast_error(message, duration = -1)`

**toast render**

- `gmui_render_toast(font = undefined)`

**spinner**

- `gmui_spinner(size = 16, thickness = 2)`

## Input Widgets (`GMUI_InputWidgets.gml`)


**button**

- `gmui_button(text, font = undefined)`
- `gmui_button_disabled(text, width = -1, height = -1, font = undefined)`
- `gmui_button_size(text, width, height, font = undefined)`
- `gmui_button_small(text, font = undefined)`
- `gmui_button_large(text, font = undefined)`
- `gmui_button_width(text, width, font = undefined)`
- `gmui_button_fill(text, height = -1, font = undefined)`
- `gmui_button_arrow(direction, width = -1, height = -1)`
- `gmui_button_repeat(text, font = undefined)`
- `gmui_button_invisible(text = "", width = 32, height = 32, trigger_visuals = true, font = undefined)`
- `gmui_button_arrow_up(w = -1, h = -1)`
- `gmui_button_arrow_down(w = -1, h = -1)`
- `gmui_button_arrow_left(w = -1, h = -1)`
- `gmui_button_arrow_right(w = -1, h = -1)`
- `gmui_button_minus(width = 24, height = 24, font = undefined)`
- `gmui_button_plus(width = 24, height = 24, font = undefined)`
- `gmui_button_icon(sprite, subimg = 0, width = 32, height = 32)`
- `gmui_button_icon1(sprite, subimg = 0, width = -1, height = -1, tint = c_white, alpha = 1)`
- `gmui_button_icon_only(sprite, subimg = 0, width = -1, height = -1)`
- `gmui_image_button_animated(sprite, frame_count, frame_delay = 4, width = -1, height = -1)`
- `gmui_button_icon_text(sprite, subimg, text, width = -1, height = -1, font = undefined)`
- `gmui_button_danger(text, width = -1, height = -1, font = undefined)`
- `gmui_button_success(text, width = -1, height = -1, font = undefined)`
- `gmui_button_hold(text, hold_time_ms = 500, width = -1, height = -1, font = undefined)`
- `gmui_button_primary(text, width = -1, height = -1, font = undefined)`
- `gmui_button_ghost(text, width = -1, height = -1, font = undefined)`
- `gmui_button_toggle(text, is_active, width = -1, height = -1, font = undefined)`
- `gmui_button_loading(text, is_loading, width = -1, height = -1, font = undefined)`
- `gmui_button_if(condition, text, font = undefined)`
- `gmui_button_primary_if(condition, text, width = -1, height = -1, font = undefined)`
- `gmui_button_danger_if(condition, text, width = -1, height = -1, font = undefined)`
- `gmui_button_success_if(condition, text, width = -1, height = -1, font = undefined)`
- `gmui_button_ghost_if(condition, text, width = -1, height = -1, font = undefined)`

**checkbox**

- `gmui_checkbox(checked, label = "", font = undefined)`
- `gmui_checkbox_disabled(checked, label = "", font = undefined)`
- `gmui_checkbox_danger(checked, label = "", font = undefined)`
- `gmui_checkbox_success(checked, label = "", font = undefined)`
- `gmui_checkbox_flags(value, flag, label = "", font = undefined)`

**selectable**

- `gmui_selectable(label, selected, width = global.gmui.style.selectable_min_width, font = undefined)`
- `gmui_selectable_disabled(label, selected = false, width = -1, font = undefined)`
- `gmui_selectable1(label, selected, width = -1, font = undefined)`

**slider**

- `gmui_slider(value, min_val, max_val, width = 200)`
- `gmui_slider_label(value, label, min_val, max_val, width = 200)`

**slidebar**

- `gmui_slidebar(value, min_val, max_val, width = 200, show_text = true, font = undefined)`
- `gmui_slidebar_label(value, label, min_val, max_val, width = 200, show_text = true, font = undefined)`
- `gmui_slider_disabled(value, min_val, max_val, width = 200)`
- `gmui_slider_int(value, min_val, max_val, width = 200)`
- `gmui_slider_percent(value, width = 200)`
- `gmui_slider_normalized(value, width = 200)`

**link-style text**

- `gmui_text_clickable(text, font = undefined)`

**image button**

- `gmui_image_button(sprite, subimg = 0, width = -1, height = -1)`
- `gmui_image_button_labeled(sprite, label, subimg = 0, width = -1, height = -1, font = undefined)`
- `gmui_image_button_tinted(sprite, subimg, tint_color, width = -1, height = -1)`

**toggle switch**

- `gmui_toggle(value)`
- `gmui_toggle_disabled(value)`
- `gmui_toggle_danger(value)`
- `gmui_toggle_success(value)`
- `gmui_toggle_flags(value, flag)`

**knob/dial**

- `gmui_knob(value, min_val, max_val, size = -1, label = "", font = undefined)`
- `gmui_knob_int(value, min_val, max_val, size = -1, label = "", font = undefined)`
- `gmui_knob_percent(value, size = -1, label = "", font = undefined)`

**color palette - grid of preset swatches**

- `gmui_color_palette(selected_color, colors, count, cols = -1)`

**multi-select list**

- `gmui_multiselect(selected, items, item_count, width = -1, height = -1, font = undefined)`

**key-value list**

- `gmui_kv_list(items, count, width = -1, font = undefined)`

**radio button**

- `gmui_radio(label, selected, font = undefined)`
- `gmui_radio_disabled(label, selected = false, font = undefined)`
- `gmui_radio_enum(label, selected_enum, enum_value, font = undefined)`

**radio group**

- `gmui_radio_group(labels, selected_index, font = undefined)`

**textbox**

- `gmui_textbox(text, placeholder = "", width = 200, is_password = false, font = undefined)`
- `gmui_textbox_label(text, label, placeholder = "", width = 200, is_password = false, font = undefined)`
- `gmui_textbox_disabled(text, placeholder = "", width = 200, is_password = false, font = undefined)`
- `gmui_textbox_password(text, placeholder = "", width = 200, font = undefined)`
- `gmui_textbox_disabled_password(text, placeholder = "", width = 200, font = undefined)`
- `gmui_textbox_multiline(text, place_holder = "", width = 200, height = 200, font = undefined)`
- `gmui_input_float(value, step = 1, min_val = -1000000, max_val = 1000000, width = 150, color_identifier = undefined, dec = 8, font = undefined)`
- `gmui_input_float_label(value, label, step = 1, min_val = -1000000, max_val = 1000000, width = 150, color_identifier = undefined, dec = 4, font = undefined)`
- `gmui_input_float_disabled(value, width = 150, font = undefined)`
- `gmui_input_int(value, step = 1, min_val = -1000000, max_val = 1000000, width = 150, color_identifier = undefined, font = undefined)`
- `gmui_input_int_label(value, label, step = 1, min_val = -1000000, max_val = 1000000, width = 150, color_identifier = undefined, font = undefined)`
- `gmui_input_int_disabled(value, width = 150, font = undefined)`

**collapsing header**

- `gmui_begin_collapsing_header_height(label, height, default_open = false, font = undefined)`
- `gmui_begin_collapsing_header(label, default_open = false, font = undefined)`
- `gmui_begin_collapsing_header_ex(label, default_open = false, font = undefined)`
- `gmui_sleeper_header(label, body, default_open = false, is_sleeper = true, font = undefined)`
- `gmui_end_collapsing_header()`
- `gmui_collapsing_group(label, default_open, func, font = undefined)`
- `gmui_collapsing_group_ex(label, default_open, func, font = undefined)`

**scrolling**

- `gmui_scrollbar_vertical(value, min_val, max_val, length, thickness = undefined)`
- `gmui_scrollbar_horizontal(value, min_val, max_val, length, thickness = undefined)`

**tree view**

- `gmui_begin_tree(name)`
- `gmui_begin_tree_node(label, default_open = false, font = -5)`
- `gmui_tree_leaf(label, font = -5)`
- `gmui_end_tree_node()`
- `gmui_end_tree()`
- `gmui_tree_get_selected()`

**combo box**

- `gmui_combo(selected_index, items, item_count, placeholder = "Select...", width = 200)`
- `gmui_combo_disabled(selected_index, items, item_count, placeholder = "Select...", width = 200)`

**color button**

- `gmui_color_button(color, size = -1, is_rgba = true, tooltip = true)`
- `gmui_color_button_3(color, size = -1)`
- `gmui_color_button_4(color, size = -1)`

**color picker**

- `gmui_color_picker(color, open_id)`
- `gmui_color_picker_rgb(color, open_id)`

**color pick**

- `gmui_color_pick(color, id = "", button_size = -1)`
- `gmui_color_pick_rgb(color, id = "", button_size = -1)`
- `gmui_color_picker_4(color, button_size = -1)`
- `gmui_color_picker_3(color, button_size = -1)`
- `gmui_color_edit_3(color, label = "", total_width = 240, font_label = undefined, font_input = undefined)`
- `gmui_color_edit_4(color, label = "", total_width = 240, font_label = undefined, font_input = undefined)`

**date picker [year, month, day]**

- `gmui_date_picker(date_array, font = undefined)`
- `gmui_date_picker_simple(date_array, font = undefined)`
- `gmui_date_picker_today()`

**list box**

- `gmui_list_box(selected, items, item_count, multi_select = false, width = -1, font = undefined)`

**tabs**

- `gmui_tabs(name, selected_index, width = -1, height = -1, group = "", handlers = undefined, flags = 0, font = undefined)`
- `gmui_tab_get_data(name)`
- `gmui_tab_get_label(name, index)`
- `gmui_tab_set_labels(name, labels)`
- `gmui_tab_add(name, label)`
- `gmui_tab_delete(name, label)`
- `gmui_tab_destroy(name)`
- `gmui_get_last_detached_tab()`
- `gmui_tab_insert(name, label, index)`

## Plot Widgets (`GMUI_PlotWidgets.gml`)


**line plot**

- `gmui_plot_lines(values, count, width = -1, height = 120, show_points = true)`

**bar chart**

- `gmui_plot_bars(values, count, width = -1, height = 120)`

**histogram**

- `gmui_plot_histogram(values, count, width = -1, height = 120, bins = 10)`
- `gmui_plot_histogram_normalized(values, count, width = -1, height = 120, bins = 10, font = undefined)`

**scatter plot**

- `gmui_plot_scatter(x_values, y_values, count, width = -1, height = 120)`

**stem plot**

- `gmui_plot_stem(values, labels, count, width = -1, height = 120, radius = 3, color = undefined, font = undefined)`

**stair plot**

- `gmui_plot_stair(values, count, width = -1, height = 120, mode = "post")`

**pie chart**

- `gmui_plot_pie(values, labels, count, width = -1, height = 200, show_legend = undefined, font = undefined)`

**donut chart**

- `gmui_plot_donut(values, labels, count, width = -1, height = 200, donut_ratio = 0.5, show_legend = undefined)`

**exploded pie chart**

- `gmui_plot_pie_exploded(values, labels, count, width = -1, height = 200, explode_all = false, show_legend = undefined)`

**area chart**

- `gmui_plot_area(series, series_count, values_per_series, width = -1, height = 120)`

**stacked bar chart**

- `gmui_plot_stacked_bars(series, series_count, values_per_series, width = -1, height = 120)`

**grouped bar chart**

- `gmui_plot_grouped_bars(series, series_count, values_per_series, width = -1, height = 120)`

**heatmap**

- `gmui_plot_heatmap(values, rows, cols, width = -1, height = -1, font = undefined)`

**radar chart**

- `gmui_plot_radar(series, series_count, values_per_series, labels, size = 200, font = undefined)`

**box plot**

- `gmui_plot_box(datasets, dataset_count, labels, width = -1, height = 200, font = undefined)`

**funnel chart**

- `gmui_plot_funnel(values, labels, count, width = -1, height = 200, font = undefined)`

**waterfall chart**

- `gmui_plot_waterfall(values, labels, count, width = -1, height = 200, font = undefined)`

**bubble chart**

- `gmui_plot_bubble(x_values, y_values, size_values, count, width = -1, height = 200)`

**gantt chart**

- `gmui_plot_gantt(tasks, task_count, start_times, end_times, colors, _today, width = -1, font = undefined)`

**error bars**

- `gmui_plot_error_bars(x_values, y_values, low_values, high_values, count, width = -1, height = 200)`

**gauge**

- `gmui_plot_gauge(value, min_val, max_val, label = "", size = -1, font = undefined)`

**table plot**

- `gmui_plot_table(headers, data, rows, cols, width = -1, font = undefined)`

**legend(stand alone)**

- `gmui_plot_legend(labels, colors, count, columns = 1, width = -1)`

## Context Menu (`GMUI_ContextMenu.gml`)


**CONTEXT MENU**

- `gmui_begin_context_menu(name, width = 160)`
- `gmui_end_context_menu()`
- `gmui_context_menu_open(name, x = -1, y = -1)`
- `gmui_context_menu_close1(name)`
- `gmui_context_menu_close11(name)`
- `gmui_context_menu_get_order_first(ctx)`
- `gmui_context_menu_get_order_last(ctx)`
- `gmui_context_menu_get_order(ctx)`
- `gmui_context_menu_get_order_a_to_b_forward_reversed(a, b)`
- `gmui_context_menu_get_order_a_to_b_backward_reversed(a, b)`
- `gmui_context_menu_close_forward(name)`
- `gmui_context_menu_close_backward(name)`
- `gmui_context_menu_close(name)`
- `gmui_context_menu_item(text, short_cut = undefined, font = undefined)`
- `gmui_context_menu_item_disabled(text, short_cut = undefined, font = undefined)`
- `gmui_context_menu_item_checkbox(text, checked)`
- `gmui_context_menu_item_checkbox_disabled(text, checked)`
- `gmui_context_menu_item_radio(text, selected)`
- `gmui_context_menu_item_radio_disabled(text, selected)`
- `gmui_begin_context_menu_sub(text)`
- `gmui_begin_context_menu_sub_disabled(text)`
- `gmui_end_context_menu_sub()`
- `gmui_context_menu_item_if(condition, text, short_cut = undefined, font = undefined)`
- `gmui_context_menu_separator()`

## Popup (`GMUI_Popup.gml`)


**POPUP**

- `gmui_begin_popup(name, is_modal = false, width = 320, height = 160, flags = gmui_window_flags.NONE)`
- `gmui_end_popup()`
- `gmui_popup_open(name, x = -1, y = -1)`
- `gmui_popup_close(name)`
- `gmui_popup_is_open(name)`
- `gmui_popup_toggle(name)`
- `gmui_modal_popup(name, width, height, func)`
- `gmui_modal_popup_auto(name, func)`
- `gmui_popup(name, width, height, func)`
- `gmui_popup_auto(name, func)`

## Drag and Drop (`GMUI_DragAndDrop.gml`)


**DRAG (simplified)**

- `gmui_default_drag_draw(info, widget)`
- `gmui_drag(info = undefined, handlers = undefined, widget = undefined)`
- `gmui_begin_drag(info = undefined, handlers = undefined)`
- `gmui_end_drag()`

**DRAG N DROP (DearImGUI style)**

- `gmui_begin_drag_drop_source(widget = undefined)`
- `gmui_end_drag_drop_source()`
- `gmui_set_drag_drop_payload(type, data)`
- `gmui_get_drag_drop_payload()`
- `gmui_begin_drag_drop_target(widget = undefined)`
- `gmui_end_drag_drop_target()`
- `gmui_accept_drag_drop_payload(type)`

## Animation (`GMUI_Animation.gml`)


**init**

- `gmui_animation_init()`
- `gmui_animation_get()`
- `gmui_animation_init_check_safe()`

**value lerp functions**

- `gmui_animation_lerp_color3(_c1, _c2, _t)`
- `gmui_animation_lerp_color4(_c1, _c2, _t)`
- `gmui_animation_lerp_vector2(_v1, _v2, _t)`
- `gmui_animation_lerp_vector3(_v1, _v2, _t)`
- `gmui_animation_lerp_vector4(_v1, _v2, _t)`
- `gmui_animation_lerp_array(_a1, _a2, _t)`

**type detection**

- `gmui_animation_detect_value_type(_value)`
- `gmui_animation_get_lerp_function(_type)`
- `gmui_animation_is_value_simple(_type)`
- `gmui_animation_is_value_array_type(_type)`

**value manipulation (helpers)**

- `gmui_animation_lerp_values(_start, _end, _type, _t, _lerp_func)`
- `gmui_animation_add_scalar_to_value(_value, _type, _scalar)`
- `gmui_animation_clamp_values(_value, _start, _end, _type)`
- `gmui_animation_snap_value(_value, _end, _type, _threshold, _to_integer)`
- `gmui_animation_process_value(_value, _type, _processor)`

**create tween**

- `gmui_animation_remove_existing_tween(_id)`
- `gmui_animation_create(_id, _start_val, _end_val, _duration = -1)`

**configuration functions**

- `gmui_animation_set_easing(_id, _easing)`
- `gmui_animation_set_custom_ease(_id, _func)`
- `gmui_animation_set_repeat(_id, _count, _delay = 0, _even_only = false)`
- `gmui_animation_set_pingpong(_id, _count = -1)`
- `gmui_animation_set_pingpong_once(_id)`
- `gmui_animation_set_delay(_id, _delay)`
- `gmui_animation_set_time_scale(_id, _scale)`
- `gmui_animation_set_callbacks(_id, _on_start = undefined, _on_update = undefined, _on_complete = undefined)`
- `gmui_animation_set_value_type(_id, _type)`
- `gmui_animation_set_oscillation(_id, _amplitude, _frequency, _phase = 0)`
- `gmui_animation_set_noise(_id, _amount, _seed = 0)`
- `gmui_animation_set_snap(_id, _threshold, _to_integer = false)`
- `gmui_animation_set_flags(_id, _flags)`
- `gmui_animation_add_flags(_id, _flags)`
- `gmui_animation_set_group(_id, _group_name)`
- `gmui_animation_set_user_data(_id, _data)`

**tween control**

- `gmui_animation_play(_id)`
- `gmui_animation_pause(_id)`
- `gmui_animation_resume(_id)`
- `gmui_animation_toggle(_id)`
- `gmui_animation_stop(_id, _go_to_end = false)`
- `gmui_animation_kill_group(_group_name)`
- `gmui_animation_kill_all()`
- `gmui_animation_reverse(_id)`
- `gmui_animation_seek(_id, _progress)`

**value getters**

- `gmui_animation_get_value(_id)`
- `gmui_animation_get_progress(_id)`
- `gmui_animation_is_playing(_id)`
- `gmui_animation_exists(_id)`

**global settings**

- `gmui_animation_set_global_time_scale(_scale)`
- `gmui_animation_get_global_time_scale()`

**update call**

- `gmui_animation_update()`
- `gmui_animation_complete_tween(_tween)`

**easing functions**

- `gmui_animation_get_eased_value(_tween, _t)`
- `gmui_animation_ease_out_bounce(_t)`

**convenience/quick start functions**

- `gmui_animation_tween(_id, _from, _to, _duration = -1, _easing = undefined)`
- `gmui_animation_tween_start(_id, _from, _to, _duration = -1, _easing = undefined)`
- `gmui_animation_tween_internal(_id, _from, _to, _duration, _easing)`
- `gmui_animation_pulse(_id, _base_value, _pulse_to, _duration = 200000, _easing = undefined)`
- `gmui_animation_pulse_start(_id, _base_value, _pulse_to, _duration = 200000, _easing = undefined)`
- `gmui_animation_shake(_id, _center_value, _intensity, _duration = 100000, _frequency = 4)`
- `gmui_animation_shake_start(_id, _center_value, _intensity, _duration = 100000, _frequency = 4)`

**queue**

- `gmui_animation_queue(_id, _from, _to, _duration = -1, _easing = undefined)`
- `gmui_animation_queue_clear(_id)`
- `gmui_animation_get_queue_count(_id)`

**stagger**

- `gmui_animation_stagger(_ids, _from, _to, _duration = -1, _stagger = 100000, _easing = undefined)`
- `gmui_animation_stagger_ex(_items, _duration = -1, _stagger = 100000, _easing = undefined)`

**per axis easing**

- `gmui_animation_set_easing_per_axis(_id, _easings)`

**wiggle**

- `gmui_animation_wiggle(_id, _center, _amplitude, _frequency = 2, _duration = -1)`
- `gmui_animation_wiggle_start(_id, _center, _amplitude, _frequency = 2, _duration = -1)`

**timeline**

- `gmui_animation_timeline(_id, _keyframes, _loop = false, _default_easing = undefined)`
- `gmui_animation_timeline_start(_id, _keyframes, _loop = false, _default_easing = undefined)`
- `gmui_animation_keyframe(_time, _value, _easing = undefined)`
- `gmui_animation_spring_update(_current, _target, _velocity, _tension = 0.5, _friction = 0.3, _mass = 1.0, _dt = -1)`
- `gmui_animation_spring(_id, _from, _to, _tension = 0.5, _friction = 0.3, _mass = 1.0, _precision = 0.001)`
- `gmui_animation_spring_start(_id, _from, _to, _tension = 0.5, _friction = 0.3, _mass = 1.0, _precision = 0.001)`
- `gmui_animation_perlin_noise(_x, _seed = 0)`
- `gmui_animation_perlin_wiggle(_id, _center, _amplitude = 0.5, _speed = 1, _seed = 0, _duration = -1)`
- `gmui_animation_perlin_wiggle_start(_id, _center, _amplitude = 0.5, _speed = 1, _seed = 0, _duration = -1)`

**rotation & transform helpers**

- `gmui_animation_lerp_angle(_from, _to, _t)`
- `gmui_animation_tween_angle(_id, _from, _to, _duration = -1, _easing = undefined)`
- `gmui_animation_tween_angle_start(_id, _from, _to, _duration = -1, _easing = undefined)`
- `gmui_animation_tween_scale(_id, _from_x, _from_y, _to_x, _to_y, _duration = -1, _easing = undefined)`
- `gmui_animation_tween_position(_id, _from_x, _from_y, _to_x, _to_y, _duration = -1, _easing = undefined)`

**clip system**

- `gmui_animation_clip_begin(_name)`
- `gmui_animation_clip_key_float(_clip, _time, _value, _easing = undefined)`
- `gmui_animation_clip_key_vector2(_clip, _time, _value, _easing = undefined)`
- `gmui_animation_clip_key_color3(_clip, _time, _value, _easing = undefined)`
- `gmui_animation_clip_key_color4(_clip, _time, _value, _easing = undefined)`
- `gmui_animation_clip_set_loop(_clip, _loop, _direction = undefined)`
- `gmui_animation_clip_on_complete(_clip, _callback)`
- `gmui_animation_clip_on_marker(_clip, _callback)`
- `gmui_animation_clip_chain(_clip, _next_clip_name)`
- `gmui_animation_clip_set_stagger(_clip, _count, _delay_per_item, _initial_delay = 0)`
- `gmui_animation_clip_end(_clip)`

**clip playback**

- `gmui_animation_clip_play(_clip_name, _target_id)`
- `gmui_animation_clip_stop(_target_id)`
- `gmui_animation_clip_is_playing(_target_id)`
- `gmui_animation_clip_get_float(_target_id)`
- `gmui_animation_clip_get_vector2(_target_id)`
- `gmui_animation_clip_get_color3(_target_id)`
- `gmui_animation_clip_get_color4(_target_id)`

**motion path**

- `gmui_animation_path_begin(_name, _start)`
- `gmui_animation_path_quadratic_to(_path, _control, _end)`
- `gmui_animation_path_cubic_to(_path, _control1, _control2, _end)`
- `gmui_animation_path_end(_path)`
- `gmui_animation_path_evaluate(_path, _t)`
- `gmui_animation_tween_path(_id, _path_name, _duration = -1, _easing = undefined)`
- `gmui_animation_tween_path_start(_id, _path_name, _duration = -1, _easing = undefined)`

**utility stuff**

- `gmui_animation_lerp(_a, _b, _t)`
- `gmui_animation_remap(_value, _from_start, _from_end, _to_start, _to_end)`
- `gmui_animation_get_active_count()`
- `gmui_animation_get_total_count()`

**cleanup**

- `gmui_animation_cleanup()`

**type specific creation**

- `gmui_animation_tween_color3_start(_id, _from_color, _to_color, _duration = -1, _easing = undefined)`
- `gmui_animation_tween_color3(_id, _from_color, _to_color, _duration = -1, _easing = undefined)`
- `gmui_animation_tween_color4_start(_id, _from_color, _to_color, _duration = -1, _easing = undefined)`
- `gmui_animation_tween_color4(_id, _from_color, _to_color, _duration = -1, _easing = undefined)`
- `gmui_animation_tween_vector2_start(_id, _from_vec2, _to_vec2, _duration = -1, _easing = undefined)`
- `gmui_animation_tween_vector2(_id, _from_vec2, _to_vec2, _duration = -1, _easing = undefined)`
- `gmui_animation_tween_vector3_start(_id, _from_vec3, _to_vec3, _duration = -1, _easing = undefined)`
- `gmui_animation_tween_vector3(_id, _from_vec3, _to_vec3, _duration = -1, _easing = undefined)`
- `gmui_animation_tween_vector4_start(_id, _from_vec4, _to_vec4, _duration = -1, _easing = undefined)`
- `gmui_animation_tween_vector4(_id, _from_vec4, _to_vec4, _duration = -1, _easing = undefined)`
- `gmui_animation_tween_array_start(_id, _from_array, _to_array, _duration = -1, _easing = undefined)`
- `gmui_animation_tween_array(_id, _from_array, _to_array, _duration = -1, _easing = undefined)`
- `gmui_animation_tween_int(_id, _from, _to, _duration = -1, _easing = undefined)`
- `gmui_animation_tween_int_start(_id, _from, _to, _duration = -1, _easing = undefined)`

**bezier paths**

- `gmui_animation_bezier_cubic(_p0, _p1, _p2, _p3, _t)`
- `gmui_animation_bezier_quadratic(_p0, _p1, _p2, _t)`
- `gmui_animation_bezier_cubic_2d(_p0, _p1, _p2, _p3, _t)`
- `gmui_animation_catmull_rom(_points, _t, _loop = false)`
- `gmui_animation_tween_bezier(_id, _p0, _p1, _p2, _p3, _duration = -1, _easing = undefined)`
- `gmui_animation_tween_bezier_start(_id, _p0, _p1, _p2, _p3, _duration = -1, _easing = undefined)`
- `gmui_animation_tween_bezier_2d(_id, _p0, _p1, _p2, _p3, _duration = -1, _easing = undefined)`
- `gmui_animation_tween_bezier_2d_start(_id, _p0, _p1, _p2, _p3, _duration = -1, _easing = undefined)`
- `gmui_animation_tween_spline(_id, _points, _duration = -1, _loop = false, _easing = undefined)`
- `gmui_animation_tween_spline_start(_id, _points, _duration = -1, _loop = false, _easing = undefined)`

**demo**

- `gmui_animation_demo()`

## Sleeper (`GMUI_Sleeper.gml`)


**SLEEPER**

- `gmui_begin_sleeper(name)`
- `gmui_end_sleeper()`

## Calls (`GMUI_Calls.gml`)


**CALLS**

- `gmui_add_call(type, params)`
- `gmui_handle_call(call, origin_x = 0, origin_y = 0)`

**Misc Calls**

- `gmui_add_font_set(font)`
- `gmui_add_halign_set(halign)`
- `gmui_add_valign_set(valign)`
- `gmui_add_primitive_type_set(type)`
- `gmui_add_call_function(func)`
- `gmui_add_primitive_end()`
- `gmui_add_vertex(x, y)`
- `gmui_add_vertex_color(x, y, color, alpha = 1)`
- `gmui_add_scrolling_disable()`
- `gmui_add_scrolling_enable()`
- `gmui_add_scissor_begin(x, y = -1, w = -1, h = -1)`
- `gmui_add_scissor_begin_isolated(x, y = -1, w = -1, h = -1)`
- `gmui_add_scissor_end()`

**Draw Calls**

- `gmui_add_text(text, x, y, color = c_white, alpha = 1, font = undefined)`
- `gmui_add_rectangle(x1, y1, x2, y2, outline, color = c_white, alpha = 1)`
- `gmui_add_roundrect(x1, y1, x2, y2, outline, color = c_white, alpha = 1, rounding = -1)`
- `gmui_add_line(x1, y1, x2, y2, color = c_white, alpha = 1)`
- `gmui_add_line_width(x1, y1, x2, y2, width, color = c_white, alpha = 1)`
- `gmui_add_circle(x, y, r, outline, color = c_white, alpha = 1)`
- `gmui_add_sprite(sprite, subimg, x, y, color = c_white, alpha = 1)`
- `gmui_add_sprite_ext(sprite, subimg, x, y, xscale, yscale, rot, color, alpha)`
- `gmui_add_surface(id, x, y, color = c_white, alpha = 1)`
- `gmui_add_surface_ext(id, x, y, xscale, yscale, rot, color, alpha)`
- `gmui_add_triangle(x1, y1, x2, y2, x3, y3, color = c_white, alpha = 1, outline = false)`
- `gmui_add_shader_rect(x1, y1, x2, y2, shader, uniforms)`
- `gmui_add_rect_expensive(x1, y1, x2, y2, color, direction, radius, filled = true, segments = -1, alpha = 1)`

## Misc (`GMUI_Misc.gml`)


**Misc**

- `gmui_calculate_text_size(text, font = undefined)`
- `gmui_resolve_font(widget, font = -1)`
- `gmui_begin_scissor(x, y, w, h)`
- `gmui_push_scissor_isolated(x, y, w, h)`
- `gmui_end_scissor()`
- `gmui_get_layer_data(layer_enum)`
- `gmui_is_container_or_parent(container, hovered_container)`
- `gmui_if(condition, func)`
- `gmui_if_else(condition, if_func, else_func)`
- `gmui_debug_window(name, x, y, width, height, func)`
- `gmui_debug_text(value, label = "", font = undefined)`
- `gmui_debug_separator(font = undefined)`
- `gmui_debug_separator1()`
- `gmui_is_widget_hovering_at(widget, x, y)`
- `gmui_get_current_container()`
- `gmui_append_structure(source, target)`

## Profile (`GMUI_Profile.gml`)


**PROFILE**

- `gmui_get_default_profile(type = gmui_default_profile.REAL_TIME)`
- `gmui_set_profile(profile)`

## Demo (`GMUI_Demo.gml`)


**DEMO**

- `gmui_demo()`

**STYLE EDITOR**

- `gmui_style_editor()`

## Anim Tests (object script) (`cAnimTests.gml`)


**ANIMATION SAMPLES**

- `gmui_animated_toggle(value)`