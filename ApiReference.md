# GMUI API Reference

---

## Table of Contents

1. [Lifecycle](#lifecycle)
2. [Windows](#windows)
3. [Containers & Children](#containers--children)
4. [Layout](#layout)
5. [Columns](#columns)
6. [Rows](#rows)
7. [Split Panes (WINS)](#split-panes-wins)
8. [Display Widgets](#display-widgets)
9. [Input Widgets](#input-widgets)
10. [Plots](#plots)
11. [Context Menu](#context-menu)
12. [Popup](#popup)
13. [Window Menu](#window-menu)
14. [Tabs](#tabs)
15. [Style](#style)
16. [Input Queries](#input-queries)
17. [Container Utilities](#container-utilities)
18. [Color Utilities](#color-utilities)
19. [Debug Helpers](#debug-helpers)
20. [Enums & Flags](#enums--flags)

---

## Lifecycle

### `gmui_init()`
Initialises the global GMUI state. Call once at game start (e.g. Create event of a persistent controller object).

### `gmui_update()`
Processes mouse hovering, z-ordering, and scroll bubbling. Call once per step **before** drawing.

### `gmui_draw_gui()`
Draws all active containers. Call once in the **Draw GUI** event.

### `gmui_cleanup()`
Frees all GMUI data structures. Call on game end or when tearing down the UI entirely.

### `gmui_set_font(font)`
Sets the global fallback font used by all widgets.

### `gmui_get_font()`  
Returns the current global font.

---

## Windows

Windows are the top-level draggable, resizable panels.

### `gmui_begin(name, x, y, width, height, flags)` → `bool`
Alias for `gmui_begin_window`. Returns `true` if the window is open and not collapsed.

### `gmui_end()`
Alias for `gmui_end_window`. Must be called when `gmui_begin` returned `true`.

### `gmui_begin_window(name, x, y, width, height, flags)` → `bool`
Opens a window. `x`, `y`, `width`, `height` are only applied on the **first** frame; subsequent frames retain the user-dragged/resized values.  
Returns `false` if the window is collapsed or disabled — do not call `gmui_end_window` in that case.

| Parameter | Default | Notes |
|-----------|---------|-------|
| `name` | — | Unique string ID. Also used as the title bar label. |
| `x` | `-1` | Initial X position (`-1` = 0). |
| `y` | `-1` | Initial Y position (`-1` = 0). |
| `width` | `-1` | Initial width (clamped to `window_min_width`). |
| `height` | `-1` | Initial height (clamped to `window_min_height`). |
| `flags` | `0` | Bitfield from `gmui_window_flags`. |

### `gmui_end_window()`
Closes the currently open window begun with `gmui_begin_window`.

### `gmui_center_window(name)`
Moves the named window to the centre of the application surface.

### `gmui_window_toggle(name)` → `bool`
Toggles the window's enabled state. Returns the new state.

### `gmui_window_is_open(name)` → `bool`
Returns `true` if the window exists and is enabled.

### `gmui_window_change_name(window, new_name)`
Renames a window container (updates the ds_map key).

---

## Containers & Children

Containers are the building blocks beneath windows. Most are managed automatically, but you can push/pop child containers manually.

### `gmui_begin_child(name, width, height)` → `bool`
Pushes a scrollable child region. Returns `true` if enabled.

### `gmui_end_child()`
Pops the child container.

### `gmui_child(name, width, height, func)` → `bool`
Inline helper: opens a child, calls `func()`, closes it. Returns `true` on success.

### `gmui_scrolling_child(name, width, height, func)` → `bool`
Same as `gmui_child` but forces `scrolling_enabled = true`.

### `gmui_group(name, func)`
Opens a container, calls `func()`, closes it. No explicit size — fits content.

### `gmui_group_ex(name, width, height, func)`
Same as `gmui_group` with an explicit size.

### Container Management

| Function | Description |
|----------|-------------|
| `gmui_container_enable(name, parent)` | Enable a container. |
| `gmui_container_disable(name, parent)` | Disable a container. |
| `gmui_container_toggle(name, parent)` → `bool` | Toggle and return new state. |
| `gmui_container_is_active(name, parent)` → `bool` | Returns `true` if enabled. |
| `gmui_container_is_hovered(name, parent)` → `bool` | Returns `true` if mouse is over it. |
| `gmui_container_set_pos(name, x, y, parent)` | Set position. |
| `gmui_container_set_size(name, w, h, parent)` | Set size (recreates surface if used). |
| `gmui_container_set_width(name, w, parent)` | Set width only. |
| `gmui_container_set_height(name, h, parent)` | Set height only. |
| `gmui_container_set_bounds(name, x, y, w, h, parent)` | Set pos + size. |
| `gmui_container_get_size(name, parent)` → `[w, h]` | Get size as array. |
| `gmui_container_get_bounds(name, parent)` → `[x, y, w, h]` | Get pos + size. |
| `gmui_container_get_screen_pos(name, parent)` → `[x, y]` | Get absolute screen position. |
| `gmui_container_set_z(name, z, parent)` | Set z-index directly. |
| `gmui_container_get_z(name, parent)` → `real` | Get z-index. |
| `gmui_container_bring_to_front(name)` | Bring to top of its layer. |
| `gmui_container_send_to_back(name)` | Send to bottom of its layer. |
| `gmui_container_destroy(container)` | Fully destroy a container and its children. |
| `gmui_container_get_context()` → `struct` | Returns `{ cursor_x, cursor_y, line_height, remaining_width, remaining_height }`. |
| `gmui_container_ignore_cursor_advance_once(container)` | Skip the next automatic cursor advance. |
| `gmui_container_cursor_advance(container)` | Manually trigger a pending line-advance. |

### Surface Flags

| Function | Description |
|----------|-------------|
| `gmui_container_surface_flag_enable(container)` | Enable surface caching. |
| `gmui_container_surface_flag_disable(container)` | Disable surface caching. |
| `gmui_container_surface_flag_toggle(container)` → `bool` | Toggle and return new state. |
| `gmui_container_surface_dirty(container)` | Mark surface as needing redraw. |
| `gmui_container_surface_flag_enable_recursive(container)` | Enable for container and all children. |
| `gmui_container_surface_flag_disable_recursive(container)` | Disable for container and all children. |

### Late Calls

| Function | Description |
|----------|-------------|
| `gmui_container_enable_late_calls(container)` | Draw late-registered calls last (e.g. overlays). |
| `gmui_container_disable_late_calls(container)` | Disable late-call mode. |

---

## Layout

Layout helpers control cursor position and line flow inside the active container.

### `gmui_newline()`
Requests a new line. The cursor advances on the next widget or explicit advance.

### `gmui_sameline()`
Cancels a pending newline, keeping the next widget on the same horizontal line.

### `gmui_indent(amount)`
Increases the horizontal indent level by `amount` pixels.

### `gmui_unindent(amount)`
Decreases the horizontal indent level by `amount` pixels.

### `gmui_indent_push(amount)`
Push indent by `amount` (defaults to `style.spacing_large`).

### `gmui_indent_pop(amount)`
Pop indent by `amount` (defaults to `style.spacing_large`).

### `gmui_spacing()`
Inserts a vertical gap equal to `style.element_spacing_v`.

### `gmui_spacing_h()`
Inserts a horizontal gap equal to `style.element_spacing_h`.

### `gmui_cursor_set(x, y)`
Set the cursor to an explicit local position.

### `gmui_cursor_set_x(x)` / `gmui_cursor_set_y(y)`
Set only X or Y of the cursor.

### `gmui_cursor_get()` → `{ x, y }`
Get current cursor position.

### `gmui_cursor_get_x()` / `gmui_cursor_get_y()` → `real`
Get individual cursor coordinates.

### `gmui_get_available_width()` → `real`
Returns the remaining horizontal space in the current container from the cursor.

---

## Columns

Horizontally-split panels with drag-resizable separators. Each column is its own scrollable container.

### `gmui_begin_columns(count, ratios, height)`
Begin a column layout with `count` columns.

| Parameter | Default | Notes |
|-----------|---------|-------|
| `count` | — | Number of columns. |
| `ratios` | `undefined` | Array of relative widths. Auto-normalised. Defaults to equal split. |
| `height` | `200` | Total height. Pass `-1` to fill remaining container height. |

### `gmui_set_column(idx)`
Switch the active draw target to column `idx` (0-based). Opens the column's sub-container.

### `gmui_end_columns()`
Finishes the column layout and draws separators.

**Typical usage:**
```gml
gmui_begin_columns(2, [0.4, 0.6], 300);
  gmui_set_column(0);
    gmui_text("Left panel");
  gmui_set_column(1);
    gmui_text("Right panel");
gmui_end_columns();
```

---

## Rows

Vertically-split panels with drag-resizable separators. Mirror API to Columns.

### `gmui_begin_rows(count, ratios, width)`
Begin a row layout.

| Parameter | Default | Notes |
|-----------|---------|-------|
| `count` | — | Number of rows. |
| `ratios` | `undefined` | Array of relative heights. |
| `width` | `200` | Total width. Pass `-1` to fill remaining. |

### `gmui_set_row(idx)`
Switch active draw target to row `idx` (0-based).

### `gmui_end_rows()`
Finishes the row layout and draws separators.

### `gmui_auto_row(columns, row_count, row_ratios, col_width)` → `array`
Declarative helper. Accepts a 2D descriptor array and calls widget functions automatically.

---

## Split Panes (WINS)

High-level wrapper around Columns/Rows for named, persistent split layouts.

### `gmui_begin_wins(name, direction, ratios)` → `bool`
Begin a split pane group.

| Parameter | Default | Notes |
|-----------|---------|-------|
| `name` | — | Unique ID for this split. |
| `direction` | — | `gmui_split_dir.VERTICAL` or `gmui_split_dir.HORIZONTAL`. |
| `ratios` | `[0.5, 0.5]` | Initial ratios. |

### `gmui_begin_wins_pane(index)` → `bool`
Activate pane at `index`.

### `gmui_end_wins_pane()`
No-op marker for readability.

### `gmui_end_wins()`
End the split group.

### `gmui_get_current_wins_pane()` → `container`
Returns the container of the currently active pane.

**Typical usage:**
```gml
gmui_begin_wins("main_split", gmui_split_dir.VERTICAL);
  gmui_begin_wins_pane(0);
    gmui_text("Pane A");
  gmui_end_wins_pane();
  gmui_begin_wins_pane(1);
    gmui_text("Pane B");
  gmui_end_wins_pane();
gmui_end_wins();
```

---

## Display Widgets

Display widgets are read-only — they draw information but do not return values.

### Text

| Function | Signature | Description |
|----------|-----------|-------------|
| `gmui_text` | `(text, font)` | Standard text. |
| `gmui_text_disabled` | `(text, font)` | Greyed-out text. |
| `gmui_text_colored` | `(text, color, font)` | Text with explicit color. |
| `gmui_text_bullet` | `(text, font)` | Text preceded by a bullet square. |
| `gmui_text_wrap` | `(text, width, font)` → `line_count` | Word-wrapped text. `width=-1` fills container. |
| `gmui_text_label` | `(label, value, font)` | `"label: value"` pair with distinct colors. |

### Separators

| Function | Signature | Description |
|----------|-----------|-------------|
| `gmui_separator` | `()` | Full-width horizontal line. |
| `gmui_separator_vertical` | `(stay, new_line, height)` | Vertical separator. `stay=true` keeps sameline. |
| `gmui_separator_text` | `(text, font)` | Horizontal rule with centred text label. |

### Progress

| Function | Signature | Description |
|----------|-----------|-------------|
| `gmui_progress_bar` | `(value, min_val, max_val, width, show_text, font)` | Horizontal bar. |
| `gmui_progress_bar_indeterminate` | `(width)` | Animated marching bar. |
| `gmui_progress_circular` | `(value, min_val, max_val, size, show_text, font)` | Circular arc progress. |
| `gmui_progress_spinner` | `(size, thickness)` | Animated spinning arc. |
| `gmui_progress` | `(value, max_val, width, show_text, font)` | Shorthand: min=0. |
| `gmui_progress_percent` | `(percent, width, show_text, font)` | Shorthand: 0–1 normalised. |
| `gmui_spinner` | `(size, thickness)` | Lightweight spinning arc widget. |

### Other

| Function | Signature | Description |
|----------|-----------|-------------|
| `gmui_dummy` | `(width, height)` | Invisible spacer widget that occupies layout space. |
| `gmui_image` | `(sprite, subimg, width, height)` | Draws a sprite, scaled to fit. |
| `gmui_tooltip` | `(text, widget, width, font)` | Shows a floating tooltip when `widget` is hovered. |
| `gmui_tooltip_on_last` | `(text, width, font)` | Attaches tooltip to the last-rendered widget. |
| `gmui_tooltip_on_hover` | `(widget, text, width, font)` | Alias for `gmui_tooltip`. |

### Toast Notifications

| Function | Signature | Description |
|----------|-----------|-------------|
| `gmui_toast_push` | `(message, type, duration)` | Push a toast. `type` = `"info"`, `"success"`, `"warning"`, `"error"`. |
| `gmui_toast_info` | `(message, duration)` | Info toast shorthand. |
| `gmui_toast_success` | `(message, duration)` | Success toast shorthand. |
| `gmui_toast_warning` | `(message, duration)` | Warning toast shorthand. |
| `gmui_toast_error` | `(message, duration)` | Error toast shorthand. |

Toast position and duration are configured through `style.toast_position` and `style.toast_duration`.

---

## Input Widgets

Input widgets return a new value each frame reflecting user interaction.

### Buttons

| Function | Returns | Description |
|----------|---------|-------------|
| `gmui_button(text, font)` | `bool` | Standard button. `true` on click. |
| `gmui_button_size(text, width, height, font)` | `bool` | Button with explicit size. |
| `gmui_button_fill(text, height, font)` | `bool` | Button fills available container width. |
| `gmui_button_width(text, width, font)` | `bool` | Width-only override. |
| `gmui_button_small(text, font)` | `bool` | Minimum-size button. |
| `gmui_button_large(text, font)` | `bool` | 1.2× text-size button. |
| `gmui_button_disabled(text, width, height, font)` | `bool` | Non-interactive, greyed out. Always returns `false`. |
| `gmui_button_repeat(text, font)` | `bool` | Returns `true` every frame while held. |
| `gmui_button_hold(text, hold_time_ms, width, height, font)` | `bool` | Returns `true` only after held for `hold_time_ms`. Shows progress fill. |
| `gmui_button_invisible(text, width, height, trigger_visuals, font)` | `bool` | Transparent hitbox, optional hover visuals. |
| `gmui_button_toggle(text, is_active, width, height, font)` | `bool` | Returns the new toggled state. Highlights when active. |
| `gmui_button_loading(text, is_loading, width, height, font)` | `bool` | Shows animated dots while `is_loading`. |
| `gmui_button_danger(text, width, height, font)` | `bool` | Red destructive button. |
| `gmui_button_success(text, width, height, font)` | `bool` | Green success button. |
| `gmui_button_primary(text, width, height, font)` | `bool` | Accent-coloured primary button. |
| `gmui_button_ghost(text, width, height, font)` | `bool` | Transparent border-only button. |
| `gmui_button_arrow(direction, width, height)` | `bool` | Arrow button. `direction`: 0=up, 1=down, 2=left, 3=right. |
| `gmui_button_arrow_up/down/left/right(w, h)` | `bool` | Directional arrow shorthands. |
| `gmui_button_plus(width, height, font)` | `bool` | `+` button. |
| `gmui_button_minus(width, height, font)` | `bool` | `-` button. |
| `gmui_button_icon(sprite, subimg, width, height)` | `bool` | Icon-only button with background. |
| `gmui_button_icon1(sprite, subimg, width, height, tilt, alpha)` | `bool` | Icon button, shows background only on hover/active. |
| `gmui_button_icon_only(sprite, subimg, width, height)` | `bool` | Padded icon button. |
| `gmui_button_icon_animated(sprite, frame_count, frame_delay, width, height)` | `bool` | Animated sprite button. |
| `gmui_button_icon_text(sprite, subimg, text, width, height, font)` | `bool` | Icon + label button. |

Conditional variants (only draw if condition is `true`, otherwise return `false`):  
`gmui_button_if`, `gmui_button_primary_if`, `gmui_button_danger_if`, `gmui_button_success_if`, `gmui_button_ghost_if`

---

### Checkbox

| Function | Returns | Description |
|----------|---------|-------------|
| `gmui_checkbox(checked, label, font)` | `bool` | Standard checkbox. Returns the new checked state. |
| `gmui_checkbox_danger(checked, label, font)` | `bool` | Red-coloured checkbox. |
| `gmui_checkbox_success(checked, label, font)` | `bool` | Green-coloured checkbox. |
| `gmui_checkbox_flags(value, flag, label, font)` | `real` | Checkbox bound to a bitmask flag. Returns the new bitmask. |

---

### Radio Button

| Function | Returns | Description |
|----------|---------|-------------|
| `gmui_radio(label, selected, font)` | `bool` | Returns `true` if this radio was clicked (use to set selected index). |

---

### Toggle Switch

| Function | Returns | Description |
|----------|---------|-------------|
| `gmui_toggle(value)` | `bool` | On/off toggle. Returns new state. |
| `gmui_toggle_disabled(value)` | `bool` | Non-interactive toggle. |
| `gmui_toggle_danger(value)` | `bool` | Red toggle. |
| `gmui_toggle_success(value)` | `bool` | Green toggle. |
| `gmui_toggle_flags(value, flag)` | `real` | Toggle bound to a bitmask flag. |

---

### Selectable

A clickable row, typically used inside lists.

| Function | Returns | Description |
|----------|---------|-------------|
| `gmui_selectable(label, selected, width, font)` | `bool` | Returns `true` when clicked while not selected. |
| `gmui_selectable1(label, selected, width, font)` | `bool` | Left-aligned text variant. `width=-1` = text width, `width=-2` = full width. |
| `gmui_selectable_disabled(label, selected, width, font)` | `bool` | Non-interactive. Always `false`. |

---

### Slider

| Function | Returns | Description |
|----------|---------|-------------|
| `gmui_slider(value, min_val, max_val, width)` | `real` | Horizontal drag slider. |
| `gmui_slider_disabled(value, min_val, max_val, width)` | `real` | Non-interactive slider. |

---

### Knob / Dial

| Function | Returns | Description |
|----------|---------|-------------|
| `gmui_knob(value, min_val, max_val, size, label, font)` | `real` | Circular rotary control. Drag vertically to adjust. |

---

### Text Input

| Function | Returns | Description |
|----------|---------|-------------|
| `gmui_textbox(text, placeholder, width, is_password, font)` | `string` | Single-line text field with cursor, selection, clipboard. |
| `gmui_textbox_disabled(text, placeholder, width, is_password, font)` | `string` | Non-interactive text field. |
| `gmui_input_float(value, width, font)` | `real` | Drag-or-type float input. |
| `gmui_input_float_disabled(value, width, font)` | `real` | Non-interactive float display. |
| `gmui_input_int(value, step, min_val, max_val, width, color_identifier, font)` | `real` | Drag-or-type integer input. Right edge is drag zone. |
| `gmui_input_int_disabled(value, width, font)` | `real` | Non-interactive integer display. |

---

### Dropdown / Combo

| Function | Returns | Description |
|----------|---------|-------------|
| `gmui_combo(selected_index, items, item_count, placeholder, width)` | `real` | Dropdown with a floating list. Returns new selected index. |
| `gmui_combo_disabled(selected_index, items, item_count, placeholder, width)` | `real` | Non-interactive combo. |

---

### List Box

| Function | Returns | Description |
|----------|---------|-------------|
| `gmui_list_box(selected, items, item_count, multi_select, width, font)` | `real or ds_map` | Scrollable item list. Returns selected index (single) or ds_map of selected keys (multi). |

---

### Multi-Select List

| Function | Returns | Description |
|----------|---------|-------------|
| `gmui_multiselect(selected, items, item_count, width, height, font)` | `ds_map` | Checkbox list with multiple selections. Pass a ds_map; returns modified ds_map. |

---

### Key-Value List

| Function | Returns | Description |
|----------|---------|-------------|
| `gmui_kv_list(items, count, width, font)` | `bool` | Read-only two-column list. `items` is an array of `[key, value]` pairs. |

---

### Collapsing Header

| Function | Returns | Description |
|----------|---------|-------------|
| `gmui_begin_collapsing_header(label, default_open, font)` | `bool` | Arrow header; returns open state. Indents content when open. |
| `gmui_begin_collapsing_header_ex(label, default_open, font)` | `bool` | Boxed variant with background and border. |
| `gmui_end_collapsing_header()` | — | Removes indent added by the header. |
| `gmui_collapsing_group(label, default_open, func, font)` | `bool` | Inline helper — opens header, calls `func()`, closes it. |
| `gmui_collapsing_group_ex(label, default_open, func, font)` | `bool` | Ex variant of above. |

---

### Scrollbars

Scrollbars are normally automatic, but can be placed manually.

| Function | Returns | Description |
|----------|---------|-------------|
| `gmui_scrollbar_vertical(value, min_val, max_val, length, thickness)` | `real` | Manual vertical scrollbar. Returns new scroll value. |
| `gmui_scrollbar_horizontal(value, min_val, max_val, length, thickness)` | `real` | Manual horizontal scrollbar. |

---

### Tree View

```gml
gmui_tree_begin("my_tree");
  if (gmui_tree_node("Parent", true)) {
    gmui_tree_leaf("Child A");
    gmui_tree_leaf("Child B");
    gmui_tree_end_node();
  }
gmui_tree_end("my_tree");
```

| Function | Returns | Description |
|----------|---------|-------------|
| `gmui_tree_begin(name)` | `bool` | Initialise a tree view. |
| `gmui_tree_node(label, default_open, font)` | `bool` | Expandable node. Returns open state. |
| `gmui_tree_leaf(label, font)` | `bool` | Non-expandable leaf item. Returns `true` if clicked. |
| `gmui_tree_end_node()` | — | Close a previously opened tree node scope. |
| `gmui_tree_end(name)` | — | Finish the tree view. |

---

### Color

| Function | Returns | Description |
|----------|---------|-------------|
| `gmui_color_button(color, size, is_rgba)` | `bool` | Colored square button. Returns `true` on click. |
| `gmui_color_picker(color, open_id)` | `real` | HSV + alpha picker widget (inline). Returns new color. |
| `gmui_color_picker_rgb(color, open_id)` | `real` | RGB variant (no alpha). |
| `gmui_color_pick(color, id)` | `real` | Color button that opens a floating picker on click (RGBA). |
| `gmui_color_pick_rgb(color, id)` | `real` | RGB variant of `gmui_color_pick`. |
| `gmui_color_picker_4(color)` | `real` | Alias for `gmui_color_pick`. |
| `gmui_color_picker_3(color)` | `real` | Alias for `gmui_color_pick_rgb`. |
| `gmui_color_edit_3(color, label, font_label, font_input)` | `real` | Color picker + RGB int inputs, with optional label. |
| `gmui_color_edit_4(color, label, font_label, font_input)` | `real` | RGBA variant of above. |
| `gmui_color_palette(color, colors, count, ...)` | `real` | Swatch palette picker. Returns selected color. |

---

### Date Picker

| Function | Returns | Description |
|----------|---------|-------------|
| `gmui_date_picker(date_array, font)` | `[year, month, day]` | Calendar widget. Accepts and returns `[year, month, day]`. Supports month/year/decade drill-down. |

---

### Image Buttons

| Function | Returns | Description |
|----------|---------|-------------|
| `gmui_image_button(sprite, subimg, width, height)` | `bool` | Sprite button. |
| `gmui_image_button_labeled(sprite, label, subimg, width, height, font)` | `bool` | Sprite + text label. |
| `gmui_image_button_tinted(sprite, subimg, tint_color, width, height)` | `bool` | Tinted sprite button. |
| `gmui_image_button_animated(sprite, frame_count, frame_delay, width, height)` | `bool` | Animates on hover/active. |

---

## Plots

All plot widgets are read-only.

| Function | Signature | Description |
|----------|-----------|-------------|
| `gmui_plot_lines` | `(values, count, width, height, show_points)` | Line chart. |
| `gmui_plot_bars` | `(values, count, width, height)` | Vertical bar chart. |
| `gmui_plot_histogram` | `(values, count, width, height, bins)` | Histogram. |
| `gmui_plot_histogram_normalized` | `(values, count, width, height, bins, font)` | Normalised histogram with y-axis labels. |
| `gmui_plot_scatter` | `(x_values, y_values, count, width, height)` | Scatter plot. |
| `gmui_plot_stem` | `(values, labels, count, width, height, radius, color, font)` | Stem plot. |
| `gmui_plot_stair` | `(values, count, width, height, mode)` | Staircase line. `mode`: `"pre"` or `"post"`. |
| `gmui_plot_pie` | `(values, labels, count, width, height, show_legend, font)` | Pie chart. |
| `gmui_plot_donut` | `(values, labels, count, width, height, donut_ratio, show_legend)` | Donut chart. |
| `gmui_plot_pie_exploded` | `(values, labels, count, width, height, explode_all, show_legend)` | Exploded pie chart. |
| `gmui_plot_area` | `(series, series_count, values_per_series, width, height)` | Area chart (multi-series). |
| `gmui_plot_stacked_bars` | `(series, series_count, values_per_series, width, height)` | Stacked bar chart. |
| `gmui_plot_grouped_bars` | `(series, series_count, values_per_series, width, height)` | Grouped bar chart. |
| `gmui_plot_heatmap` | `(values, rows, cols, width, height, font)` | Heatmap grid. |
| `gmui_plot_radar` | `(series, series_count, values_per_series, labels, size, font)` | Radar/spider chart. |
| `gmui_plot_box` | `(datasets, dataset_count, labels, width, height, font)` | Box-and-whisker plot. |
| `gmui_plot_funnel` | `(values, labels, count, width, height, font)` | Funnel chart. |
| `gmui_plot_waterfall` | `(values, labels, count, width, height, font)` | Waterfall chart. |
| `gmui_plot_bubble` | `(x_values, y_values, size_values, count, width, height)` | Bubble chart. |
| `gmui_plot_gantt` | `(tasks, task_count, start_times, end_times, colors, today, width, font)` | Gantt chart. |
| `gmui_plot_error_bars` | `(x_values, y_values, low_values, high_values, count, width, height)` | Error bar chart. |
| `gmui_plot_gauge` | `(value, min_val, max_val, label, size, font)` | Semicircular gauge. |
| `gmui_plot_table` | `(headers, data, rows, cols, width, font)` | Tabular data display. |
| `gmui_plot_legend` | `(labels, colors, count, columns, width)` | Standalone legend block. |

---

## Context Menu

Context menus are hidden windows that appear on demand and close when the user clicks outside them.

### Lifecycle

```gml
// Open on right-click
if (mouse_check_button_pressed(mb_right)) {
    gmui_context_menu_open("my_ctx");
}

// Declare each frame
if (gmui_begin_context_menu("my_ctx")) {
    if (gmui_context_menu_item("Cut", "Ctrl+X"))   { /* ... */ }
    if (gmui_context_menu_item("Copy", "Ctrl+C"))  { /* ... */ }
    gmui_context_menu_separator();
    if (gmui_context_menu_item("Paste", "Ctrl+V")) { /* ... */ }
    gmui_end_context_menu();
}
```

| Function | Returns | Description |
|----------|---------|-------------|
| `gmui_begin_context_menu(name, width, height)` | `bool` | Open the draw scope. Returns `true` if visible. |
| `gmui_end_context_menu()` | — | Close the draw scope. Auto-resizes to content. |
| `gmui_context_menu_open(name, x, y)` | — | Enable and position the menu. `x/y=-1` uses mouse position. |
| `gmui_context_menu_close(name)` | — | Close the menu and all sub-menus in the chain. |
| `gmui_context_menu_item(text, short_cut, font)` | `bool` | Standard item. Returns `true` when clicked (auto-closes menu). |
| `gmui_context_menu_item_checkbox(text, checked)` | `bool` | Checkbox item. Returns new checked state. |
| `gmui_context_menu_item_radio(text, selected)` | `bool` | Radio item. Returns `true` when clicked. |
| `gmui_context_menu_item_if(condition, text, short_cut, font)` | `bool` | Conditional item. |
| `gmui_context_menu_separator()` | — | Horizontal separator inside the menu. |
| `gmui_begin_context_menu_sub(text)` | `bool` | Opens a nested sub-menu. Returns open state. |
| `gmui_end_context_menu_sub()` | — | Closes the sub-menu scope. |

---

## Popup

Popups are centred windows that appear on demand, optionally with a dimming modal overlay.

```gml
if (gmui_button("Open Dialog")) {
    gmui_popup_open("confirm_dialog");
}

if (gmui_begin_popup("confirm_dialog", true, 300, 120)) {
    gmui_text("Are you sure?");
    if (gmui_button("Yes")) { gmui_popup_close("confirm_dialog"); }
    gmui_sameline();
    if (gmui_button("No"))  { gmui_popup_close("confirm_dialog"); }
    gmui_end_popup();
}
```

| Function | Returns | Description |
|----------|---------|-------------|
| `gmui_begin_popup(name, is_modal, width, height, flags)` | `bool` | Open popup scope. `is_modal=true` draws a dark overlay. |
| `gmui_end_popup()` | — | Close popup scope. |
| `gmui_popup_open(name, x, y)` | — | Enable and position the popup. |
| `gmui_popup_close(name)` | — | Disable the popup. |
| `gmui_popup_toggle(name)` | `bool` | Toggle and return new state. |
| `gmui_popup_is_open(name)` | `bool` | Query visibility. |
| `gmui_modal_popup(name, width, height, func)` | `bool` | Inline modal: opens, calls `func()`, closes. |
| `gmui_modal_popup_auto(name, func)` | `bool` | Auto-sizing modal. |
| `gmui_popup(name, width, height, func)` | `bool` | Inline non-modal popup. |
| `gmui_popup_auto(name, func)` | `bool` | Auto-sizing non-modal popup. |

---

## Window Menu

A horizontal menu bar rendered inside a window, backed by context menus.

```gml
if (gmui_begin("My Window", ...)) {
    gmui_window_menu([
        gmui_menu_item("File", "ctx_file"),
        gmui_menu_item("Edit", "ctx_edit"),
        gmui_menu_item("Help", ""),  // label-only, no dropdown
    ]);
    // ... rest of window content
    gmui_end();
}
```

| Function | Returns | Description |
|----------|---------|-------------|
| `gmui_window_menu(menu_array)` | — | Renders the menu bar. `menu_array` is an array of `[label, context_menu_name]` pairs. |
| `gmui_menu_item(text, ctx_name)` | `[text, ctx_name]` | Helper to build a menu entry struct. |

---

## Tabs

A tab bar with drag-to-reorder, detach, and re-attach support.

```gml
var sel = gmui_tabs("my_tabs", selected_index);
if (sel != selected_index) { selected_index = sel; }

// Render content for the active tab
switch (selected_index) {
    case 0: gmui_text("Tab A content"); break;
    case 1: gmui_text("Tab B content"); break;
}
```

### `gmui_tabs(name, selected_index, width, height, group, handlers, flags, font)` → `real`
The main tab bar widget. Returns the currently selected tab index.

| Parameter | Default | Notes |
|-----------|---------|-------|
| `name` | — | Unique ID. |
| `selected_index` | — | Currently active tab index. |
| `width` | `-1` | Width (fills available). |
| `height` | `-1` | Height. |
| `group` | `""` | Drag-group name. Tabs can be transferred between bars in the same group. |
| `handlers` | `undefined` | Optional struct with custom draw callbacks. |
| `flags` | `0` | Bitfield from `gmui_tab_flags`. |
| `font` | `undefined` | Font override. |

### Tab Management

| Function | Description |
|----------|-------------|
| `gmui_tab_add(name, label)` | Append a tab with the given label. |
| `gmui_tab_delete(name, label)` | Remove a tab by label. |
| `gmui_tab_insert(name, label, index)` | Insert a tab at a specific index. |
| `gmui_tab_set_labels(name, labels)` | Replace all tab labels at once. |
| `gmui_tab_get_label(name, index)` → `string` | Get the label at `index`. |
| `gmui_get_last_detached_tab()` → `struct` | Returns info about the most recently detached tab (`{ bar_name, label, index }`), or `undefined`. |

---

## Style

### Reading & Writing

| Function | Description |
|----------|-------------|
| `gmui_style_get(key)` | Returns the current value of a style property. |
| `gmui_style_set(key, value)` | Sets a style property directly. |

### Push / Pop

Temporarily override style values and restore them afterward.

| Function | Description |
|----------|-------------|
| `gmui_style_push(key, value)` | Push a single style override. |
| `gmui_style_pop(key)` | Pop and restore the previous value. |
| `gmui_style_push_multi(map)` | Push multiple overrides from a struct. |
| `gmui_style_pop_multi(keys_array)` | Pop multiple overrides by key array. |
| `gmui_style_scope(key, value, func)` | Push, call `func()`, pop. |
| `gmui_style_scope_multi(map, func)` | Multi-key scope. |
| `gmui_with_style(key, value, func)` | Alias for `gmui_style_scope`. |
| `gmui_with_style_multi(style_map, func)` | Alias for `gmui_style_scope_multi`. |

### Theming

| Function | Description |
|----------|-------------|
| `gmui_style_apply_ruler(ruler)` | Apply a complete theme. Pass a struct with ruler color keys, or `undefined` to reset to default dark theme. |

**Example — temporary spacing change:**
```gml
gmui_style_push("element_spacing_v", 0);
gmui_text("Tight");
gmui_text("Rows");
gmui_style_pop("element_spacing_v");
```

---

## Input Queries

These functions query the input state captured by `gmui_update_input()`.

### Mouse

| Function | Returns | Description |
|----------|---------|-------------|
| `gmui_input_mouse_pressed()` | `bool` | Left button just pressed. |
| `gmui_input_mouse_released()` | `bool` | Left button just released. |
| `gmui_input_mouse_held()` | `bool` | Left button held. |
| `gmui_input_mouse_x()` | `real` | Mouse GUI X. |
| `gmui_input_mouse_y()` | `real` | Mouse GUI Y. |
| `gmui_input_is_hovered(x, y, width, height)` | `bool` | Point-in-rect test using GUI mouse position. |

### Keyboard

| Function | Returns | Description |
|----------|---------|-------------|
| `gmui_input_key_pressed()` | `bool` | Any key just pressed. |
| `gmui_input_key()` | `real` | Current `keyboard_key`. |
| `gmui_input_lastchar()` | `string` | `keyboard_lastchar`. |
| `gmui_input_lastkey()` | `real` | `keyboard_lastkey`. |
| `gmui_input_ctrl()` | `bool` | Control held. |
| `gmui_input_shift()` | `bool` | Shift held. |
| `gmui_input_alt()` | `bool` | Alt held (also toggles horizontal scroll). |
| `gmui_input_key_held(key)` | `bool` | Arbitrary key held (`keyboard_check`). |

---

## Color Utilities

GMUI uses a packed RGBA integer format (`R | G<<8 | B<<16 | A<<24`) distinct from GML's native `make_color_rgb`.

| Function | Returns | Description |
|----------|---------|-------------|
| `gmui_make_color_rgba(r, g, b, a)` | `real` | Pack RGBA into GMUI format. |
| `gmui_color_rgba_get_red(color)` | `real` | Extract red channel. |
| `gmui_color_rgba_get_green(color)` | `real` | Extract green channel. |
| `gmui_color_rgba_get_blue(color)` | `real` | Extract blue channel. |
| `gmui_color_rgba_get_alpha(color)` | `real` | Extract alpha channel. |
| `gmui_color_rgb_to_rgba(color, alpha)` | `real` | Convert GML RGB color to GMUI RGBA. |
| `gmui_color_rgba_to_rgb(color)` | `real` | Convert GMUI RGBA to GML RGB. |
| `gmui_color_rgba_to_array(color)` | `[r,g,b,a]` | Unpack to array. |
| `gmui_color_rgb_to_array(color)` | `[r,g,b]` | Unpack GML color to array. |
| `gmui_color_rgba_from_array(arr)` | `real` | Pack from `[r,g,b,a]` array. |
| `gmui_color_set_alpha(color, alpha)` | `real` | Replace alpha in a GMUI RGBA color. |
| `gmui_color_lighten(color, factor)` | `real` | Scale RGB channels up. |
| `gmui_color_darken(color, factor)` | `real` | Alias for `gmui_color_lighten`. |
| `gmui_color_lerp(color1, color2, t)` | `real` | Linearly interpolate two GMUI RGBA colors. |
| `gmui_hsv_to_rgb(h, s, v)` | `[r,g,b]` | Convert HSV (0–1) to RGB (0–255). |
| `gmui_rgb_to_hsv(r, g, b)` | `[h,s,v]` | Convert RGB (0–255) to HSV (0–1). |

---

## Debug Helpers

| Function | Description |
|----------|-------------|
| `gmui_debug_window(name, x, y, width, height, func)` | Opens a window, calls `func()` inside it. |
| `gmui_debug_text(value, label, font)` | Renders `string(value)`, with optional label prefix. |
| `gmui_debug_separator(font)` | Draws separators around `"--- DEBUG ---"`. |
| `gmui_if(condition, func)` | Calls `func()` only if `condition` is `true`. |
| `gmui_if_else(condition, if_func, else_func)` | Conditional branch helper. |

---

## Enums & Flags

### `gmui_window_flags`

Combine with `|` and pass as the `flags` parameter of `gmui_begin_window`.

| Flag | Description |
|------|-------------|
| `NONE` | Default. |
| `NO_TITLE_BAR` | Hide the title bar. |
| `NO_MOVE_WITH_MOUSE` | Prevent dragging. |
| `NO_CLOSE` | Hide the close button. |
| `NO_COLLAPSE` | Hide the collapse button. |
| `NO_SCROLL` | Disable scrolling in the content area. |
| `NO_BORDERS` | Hide window borders. |
| `NO_BORDER_RESIZE` | Disable border drag-to-resize. |
| `AUTO_RESIZE_HORIZONTAL` | Auto-fit width to content each frame. |
| `AUTO_RESIZE_VERTICAL` | Auto-fit height to content each frame. |

### `gmui_tab_flags`

| Flag | Description |
|------|-------------|
| `NONE` | Default. |
| `NO_MOVE` | Disable tab drag-to-reorder. |
| `NO_CLOSE` | Hide close buttons on tabs. |

### `gmui_layer`

Controls z-stacking group.

| Value | Description |
|-------|-------------|
| `BACKGROUND` | Drawn behind everything. |
| `NORMAL` | Standard windows and containers. |
| `MODAL_BG` | Modal dimming overlays. |
| `POPUP` | Dropdowns, context menus, popups. |

### `gmui_split_dir`

| Value | Description |
|-------|-------------|
| `HORIZONTAL` | Rows (split top–bottom). |
| `VERTICAL` | Columns (split left–right). |

### `gmui_corner_direction`

Bitmask for which corners of a rounded rect to round.

| Value | Corners |
|-------|---------|
| `TOP_LEFT` | Top-left only. |
| `TOP_RIGHT` | Top-right only. |
| `BOTTOM_LEFT` | Bottom-left only. |
| `BOTTOM_RIGHT` | Bottom-right only. |
| `UP` | Top-left + top-right. |
| `DOWN` | Bottom-left + bottom-right. |
| `LEFT` | Top-left + bottom-left. |
| `RIGHT` | Top-right + bottom-right. |
| `ALL` | All four corners. |
| `NONE` | No rounding (sharp corners). |
