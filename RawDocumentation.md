# GMUI - Raw Documentation

Complete function reference with parameters, return values, and usage examples.

---

## Core Functions

### gmui_init()
Initializes the GMUI system.

**Parameters:** None

**Returns:** Nothing

**Example:**
```gml
gmui_init();
```

---

### gmui_update()
Updates input state and processes UI containers. Call this in the Step event before building UI.

**Parameters:** None

**Returns:** Nothing

**Example:**
```gml
gmui_update();
```

---

### gmui_draw_gui()
Renders all UI elements. Call this in the Draw event.

**Parameters:** None

**Returns:** Nothing

**Example:**
```gml
gmui_draw_gui();
```

---

### gmui_cleanup()
Destroys all GMUI data structures. Call when closing the game.

**Parameters:** None

**Returns:** Nothing

**Example:**
```gml
gmui_cleanup();
```

---

### gmui_get_font()
Returns the current default font.

**Parameters:** None

**Returns:** Font resource or -1 if not set

**Example:**
```gml
var font = gmui_get_font();
```

---

### gmui_set_font(font)
Sets the default font for all widgets.

**Parameters:**
- `font` (font) - Font resource to use

**Returns:** Nothing

**Example:**
```gml
gmui_set_font(Font1);
```

---

## Window Functions

### gmui_begin(name, x, y, width, height, flags)
Alias for gmui_begin_window().

**Parameters:**
- `name` (string) - Window title
- `x` (real) - X position
- `y` (real) - Y position
- `width` (real) - Window width
- `height` (real) - Window height
- `flags` (int, optional) - Window flags

**Returns:** bool - True if content should be drawn

**Example:**
```gml
if (gmui_begin("My Window", 100, 100, 400, 300)) {
    gmui_end();
}
```

---

### gmui_begin_window(name, x, y, width, height, flags)
Creates a resizable, movable window with title bar.

**Parameters:**
- `name` (string) - Window title (also used as unique identifier)
- `x` (real) - X position
- `y` (real) - Y position
- `width` (real) - Window width
- `height` (real) - Window height
- `flags` (int, optional) - Window flags

**Returns:** bool - True if window content should be drawn

**Example:**
```gml
if (gmui_begin_window("Settings", 200, 200, 300, 200)) {
    gmui_text("Settings content");
    gmui_end_window();
}
```

---

### gmui_end_window()
Closes the current window.

**Parameters:** None

**Returns:** Nothing

---

### gmui_window_menu(menu_array)
Creates a menu bar inside the current window.

**Parameters:**
- `menu_array` (array) - 2D array of [label, context_menu_name]

**Returns:** Nothing

**Example:**
```gml
gmui_window_menu([
    ["File", "file_menu"],
    ["Edit", "edit_menu"],
    ["Help", ""]
]);
```

---

### Window Flags (gmui_window_flags)

| Flag | Value | Description |
|------|-------|-------------|
| NONE | 0 | No flags |
| NO_TITLE_BAR | 1 << 0 | Hide title bar |
| NO_MOVE_WITH_MOUSE | 1 << 1 | Disable dragging |
| NO_CLOSE | 1 << 2 | Hide close button |
| NO_COLLAPSE | 1 << 3 | Hide collapse button |
| NO_SCROLL | 1 << 4 | Disable window scrolling |
| NO_BORDERS | 1 << 5 | Hide window borders |
| NO_BORDER_RESIZE | 1 << 6 | Disable border resizing |

---

## Container Functions

### gmui_begin_container(name, x, y, width, height)
Creates a nested container.

**Parameters:**
- `name` (string) - Container identifier
- `x` (real, optional) - X position
- `y` (real, optional) - Y position
- `width` (real, optional) - Container width
- `height` (real, optional) - Container height

**Returns:** bool - True if container should be drawn

**Example:**
```gml
if (gmui_begin_container("panel", 10, 10, 200, 100)) {
    gmui_text("Inside panel");
    gmui_end_container();
}
```

---

### gmui_end_container()
Closes the current container.

**Parameters:** None

**Returns:** Nothing

---

### gmui_container_get(name, parent)
Gets a container by name.

**Parameters:**
- `name` (string) - Container name
- `parent` (struct, optional) - Parent container

**Returns:** struct - Container object

**Example:**
```gml
var win = gmui_container_get("My Window");
win.is_enabled = false;
```

---

### gmui_container_bring_to_front(name)
Brings a container to the front of its layer.

**Parameters:**
- `name` (string) - Container name

**Returns:** Nothing

---

### gmui_container_send_to_back(name)
Sends a container to the back of its layer.

**Parameters:**
- `name` (string) - Container name

**Returns:** Nothing

---

### gmui_container_set_pos(name, x, y, parent)
Sets container position.

**Parameters:**
- `name` (string) - Container name
- `x` (real) - X position
- `y` (real) - Y position
- `parent` (struct, optional) - Parent container

**Returns:** Nothing

---

### gmui_container_set_size(name, w, h, parent)
Sets container size.

**Parameters:**
- `name` (string) - Container name
- `w` (real) - Width
- `h` (real) - Height
- `parent` (struct, optional) - Parent container

**Returns:** Nothing

---

### gmui_container_set_bounds(name, x, y, w, h, parent)
Sets container position and size.

**Parameters:**
- `name` (string) - Container name
- `x` (real) - X position
- `y` (real) - Y position
- `w` (real) - Width
- `h` (real) - Height
- `parent` (struct, optional) - Parent container

**Returns:** Nothing

---

### gmui_container_get_bounds(name, parent)
Gets container bounds.

**Parameters:**
- `name` (string) - Container name
- `parent` (struct, optional) - Parent container

**Returns:** array - [x, y, width, height]

---

### gmui_container_enable(name, parent)
Enables a container.

**Parameters:**
- `name` (string) - Container name
- `parent` (struct, optional) - Parent container

**Returns:** Nothing

---

### gmui_container_disable(name, parent)
Disables a container.

**Parameters:**
- `name` (string) - Container name
- `parent` (struct, optional) - Parent container

**Returns:** Nothing

---

### gmui_container_toggle(name, parent)
Toggles container enabled state.

**Parameters:**
- `name` (string) - Container name
- `parent` (struct, optional) - Parent container

**Returns:** bool - New enabled state

---

### gmui_container_is_active(name, parent)
Checks if container is active.

**Parameters:**
- `name` (string) - Container name
- `parent` (struct, optional) - Parent container

**Returns:** bool - True if active

---

### gmui_container_is_hovered(name, parent)
Checks if mouse is hovering over container.

**Parameters:**
- `name` (string) - Container name
- `parent` (struct, optional) - Parent container

**Returns:** bool - True if hovered

---

### gmui_get_container_screen_offset(container)
Gets container's screen position.

**Parameters:**
- `container` (struct) - Container object

**Returns:** array - [x, y]

---

### gmui_get_available_width()
Returns remaining width in current container.

**Parameters:** None

**Returns:** real - Available width

---

## Display Widgets

### gmui_text(text, font)
Draws text.

**Parameters:**
- `text` (string) - Text to display
- `font` (font, optional) - Font override

**Returns:** Nothing

---

### gmui_text_colored(text, color, font)
Draws colored text.

**Parameters:**
- `text` (string) - Text to display
- `color` (color) - Text color
- `font` (font, optional) - Font override

**Returns:** Nothing

---

### gmui_text_disabled(text, font)
Draws disabled (gray) text.

**Parameters:**
- `text` (string) - Text to display
- `font` (font, optional) - Font override

**Returns:** Nothing

---

### gmui_text_bullet(text, font)
Draws text with a bullet point.

**Parameters:**
- `text` (string) - Text to display
- `font` (font, optional) - Font override

**Returns:** Nothing

---

### gmui_text_wrap(text, width, font)
Draws wrapped text.

**Parameters:**
- `text` (string) - Text to display
- `width` (real, optional) - Wrap width
- `font` (font, optional) - Font override

**Returns:** int - Number of lines

---

### gmui_text_label(label, value, font)
Draws label: value pair.

**Parameters:**
- `label` (string) - Label text
- `value` (string) - Value text
- `font` (font, optional) - Font override

**Returns:** Nothing

---

### gmui_text_clickable(text, font)
Draws clickable link-style text.

**Parameters:**
- `text` (string) - Text to display
- `font` (font, optional) - Font override

**Returns:** bool - True if clicked

---

### gmui_sprite(sprite, subimg, width, height)
Draws a sprite.

**Parameters:**
- `sprite` (sprite) - Sprite resource
- `subimg` (real, optional) - Sub-image
- `width` (real, optional) - Display width
- `height` (real, optional) - Display height

**Returns:** Nothing

---

### gmui_surface(surface)
Draws a surface.

**Parameters:**
- `surface` (surface) - Surface ID

**Returns:** Nothing

---

## Button Widgets

### gmui_button(text, font)
Standard button.

**Parameters:**
- `text` (string) - Button label
- `font` (font, optional) - Font override

**Returns:** bool - True if clicked

---

### gmui_button_primary(text, font)
Primary accent-colored button.

**Parameters:**
- `text` (string) - Button label
- `font` (font, optional) - Font override

**Returns:** bool - True if clicked

---

### gmui_button_success(text, font)
Green success button.

**Parameters:**
- `text` (string) - Button label
- `font` (font, optional) - Font override

**Returns:** bool - True if clicked

---

### gmui_button_danger(text, font)
Red danger button.

**Parameters:**
- `text` (string) - Button label
- `font` (font, optional) - Font override

**Returns:** bool - True if clicked

---

### gmui_button_ghost(text, font)
Transparent ghost button.

**Parameters:**
- `text` (string) - Button label
- `font` (font, optional) - Font override

**Returns:** bool - True if clicked

---

### gmui_button_toggle(text, is_active, font)
Toggle button that stays pressed.

**Parameters:**
- `text` (string) - Button label
- `is_active` (bool) - Current state
- `font` (font, optional) - Font override

**Returns:** bool - New state

---

### gmui_button_loading(text, is_loading, font)
Button with loading animation.

**Parameters:**
- `text` (string) - Button label
- `is_loading` (bool) - Loading state
- `font` (font, optional) - Font override

**Returns:** bool - True if clicked (only when not loading)

---

### gmui_button_hold(text, hold_time_ms, font)
Button that requires holding.

**Parameters:**
- `text` (string) - Button label
- `hold_time_ms` (real, default: 500) - Required hold time
- `font` (font, optional) - Font override

**Returns:** bool - True when hold completes

---

### gmui_button_arrow(direction, width, height)
Arrow button.

**Parameters:**
- `direction` (int) - 0=up, 1=down, 2=left, 3=right
- `width` (real, optional) - Button width
- `height` (real, optional) - Button height

**Returns:** bool - True if clicked

---

### gmui_button_minus(width, height)
Minus button.

**Parameters:**
- `width` (real, optional) - Button width
- `height` (real, optional) - Button height

**Returns:** bool - True if clicked

---

### gmui_button_plus(width, height)
Plus button.

**Parameters:**
- `width` (real, optional) - Button width
- `height` (real, optional) - Button height

**Returns:** bool - True if clicked

---

### gmui_button_icon(sprite, subimg, width, height)
Icon-only button.

**Parameters:**
- `sprite` (sprite) - Sprite resource
- `subimg` (real, optional) - Sub-image
- `width` (real, optional) - Button width
- `height` (real, optional) - Button height

**Returns:** bool - True if clicked

---

### gmui_button_icon_text(sprite, subimg, text, width, height, font)
Icon with text button.

**Parameters:**
- `sprite` (sprite) - Sprite resource
- `subimg` (real, optional) - Sub-image
- `text` (string) - Button label
- `width` (real, optional) - Button width
- `height` (real, optional) - Button height
- `font` (font, optional) - Font override

**Returns:** bool - True if clicked

---

### gmui_button_width(text, width, font)
Button with custom width.

**Parameters:**
- `text` (string) - Button label
- `width` (real) - Button width
- `font` (font, optional) - Font override

**Returns:** bool - True if clicked

---

### gmui_button_size(text, width, height, font)
Button with custom size.

**Parameters:**
- `text` (string) - Button label
- `width` (real) - Button width
- `height` (real) - Button height
- `font` (font, optional) - Font override

**Returns:** bool - True if clicked

---

### gmui_button_fill(text, height, font)
Button that fills available width.

**Parameters:**
- `text` (string) - Button label
- `height` (real, optional) - Button height
- `font` (font, optional) - Font override

**Returns:** bool - True if clicked

---

## Checkbox & Toggle Widgets

### gmui_checkbox(checked, label, font)
Standard checkbox.

**Parameters:**
- `checked` (bool) - Current state
- `label` (string) - Checkbox label
- `font` (font, optional) - Font override

**Returns:** bool - New state

---

### gmui_checkbox_success(checked, label, font)
Green success checkbox.

**Parameters:**
- `checked` (bool) - Current state
- `label` (string) - Checkbox label
- `font` (font, optional) - Font override

**Returns:** bool - New state

---

### gmui_checkbox_danger(checked, label, font)
Red danger checkbox.

**Parameters:**
- `checked` (bool) - Current state
- `label` (string) - Checkbox label
- `font` (font, optional) - Font override

**Returns:** bool - New state

---

### gmui_checkbox_disabled(checked, label, font)
Disabled checkbox.

**Parameters:**
- `checked` (bool) - Current state
- `label` (string) - Checkbox label
- `font` (font, optional) - Font override

**Returns:** bool - Original state (no interaction)

---

### gmui_toggle(value)
Toggle switch.

**Parameters:**
- `value` (bool) - Current state

**Returns:** bool - New state

---

### gmui_toggle_success(value)
Green success toggle.

**Parameters:**
- `value` (bool) - Current state

**Returns:** bool - New state

---

### gmui_toggle_danger(value)
Red danger toggle.

**Parameters:**
- `value` (bool) - Current state

**Returns:** bool - New state

---

### gmui_toggle_disabled(value)
Disabled toggle.

**Parameters:**
- `value` (bool) - Current state

**Returns:** bool - Original state

---

## Radio Widgets

### gmui_radio(label, selected, font)
Individual radio button.

**Parameters:**
- `label` (string) - Radio label
- `selected` (bool) - Current state
- `font` (font, optional) - Font override

**Returns:** bool - True if clicked (should set this as selected)

---

### gmui_radio_group(labels, selected_index, font)
Radio button group.

**Parameters:**
- `labels` (array) - Radio option labels
- `selected_index` (int) - Currently selected index
- `font` (font, optional) - Font override

**Returns:** int - New selected index

---

### gmui_radio_disabled(label, selected, font)
Disabled radio button.

**Parameters:**
- `label` (string) - Radio label
- `selected` (bool) - Current state
- `font` (font, optional) - Font override

**Returns:** bool - False (no interaction)

---

## Input Widgets

### gmui_textbox(text, placeholder, width, font)
Text input field.

**Parameters:**
- `text` (string) - Current text
- `placeholder` (string) - Placeholder text when empty
- `width` (real, optional) - Field width
- `font` (font, optional) - Font override

**Returns:** string - New text

---

### gmui_textbox_disabled(text, placeholder, width, font)
Disabled textbox.

**Parameters:**
- `text` (string) - Current text
- `placeholder` (string) - Placeholder text
- `width` (real, optional) - Field width
- `font` (font, optional) - Font override

**Returns:** string - Original text

---

### gmui_input_int(value, step, min, max, width, font)
Integer input with drag-to-adjust.

**Parameters:**
- `value` (int) - Current value
- `step` (int, default: 1) - Increment step
- `min` (int, default: -1000000) - Minimum value
- `max` (int, default: 1000000) - Maximum value
- `width` (real, optional) - Field width
- `font` (font, optional) - Font override

**Returns:** int - New value

---

### gmui_input_float(value, step, min, max, width, font)
Float input with drag-to-adjust.

**Parameters:**
- `value` (real) - Current value
- `step` (real, default: 0.1) - Increment step
- `min` (real, default: -1000000) - Minimum value
- `max` (real, default: 1000000) - Maximum value
- `width` (real, optional) - Field width
- `font` (font, optional) - Font override

**Returns:** real - New value

---

### gmui_input_int_disabled(value, width, font)
Disabled integer input.

**Parameters:**
- `value` (int) - Current value
- `width` (real, optional) - Field width
- `font` (font, optional) - Font override

**Returns:** int - Original value

---

### gmui_input_float_disabled(value, width, font)
Disabled float input.

**Parameters:**
- `value` (real) - Current value
- `width` (real, optional) - Field width
- `font` (font, optional) - Font override

**Returns:** real - Original value

---

## Slider & Knob Widgets

### gmui_slider(value, min_val, max_val, width)
Horizontal slider.

**Parameters:**
- `value` (real) - Current value
- `min_val` (real) - Minimum value
- `max_val` (real) - Maximum value
- `width` (real, default: 200) - Slider width

**Returns:** real - New value

---

### gmui_slider_disabled(value, min_val, max_val, width)
Disabled slider.

**Parameters:**
- `value` (real) - Current value
- `min_val` (real) - Minimum value
- `max_val` (real) - Maximum value
- `width` (real, default: 200) - Slider width

**Returns:** real - Original value

---

### gmui_knob(value, min_val, max_val, size, label, font)
Rotary knob/dial.

**Parameters:**
- `value` (real) - Current value
- `min_val` (real) - Minimum value
- `max_val` (real) - Maximum value
- `size` (real, optional) - Knob size in pixels
- `label` (string, optional) - Label below knob
- `font` (font, optional) - Font override

**Returns:** real - New value

---

## Selection Widgets

### gmui_selectable(label, selected, width, font)
Selectable list item.

**Parameters:**
- `label` (string) - Item label
- `selected` (bool) - Current state
- `width` (real, optional) - Item width
- `font` (font, optional) - Font override

**Returns:** bool - True if clicked (should select this)

---

### gmui_selectable_disabled(label, selected, width, font)
Disabled selectable.

**Parameters:**
- `label` (string) - Item label
- `selected` (bool) - Current state
- `width` (real, optional) - Item width
- `font` (font, optional) - Font override

**Returns:** bool - False (no interaction)

---

### gmui_combo(selected_index, items, item_count, placeholder, width)
Dropdown combo box.

**Parameters:**
- `selected_index` (int) - Currently selected index
- `items` (array) - Item labels
- `item_count` (int) - Number of items
- `placeholder` (string, optional) - Placeholder text
- `width` (real, optional) - Combo width

**Returns:** int - New selected index

---

### gmui_combo_disabled(selected_index, items, item_count, placeholder, width)
Disabled combo box.

**Parameters:**
- `selected_index` (int) - Currently selected index
- `items` (array) - Item labels
- `item_count` (int) - Number of items
- `placeholder` (string, optional) - Placeholder text
- `width` (real, optional) - Combo width

**Returns:** int - Original index

---

### gmui_list_box(selected, items, item_count, multi_select, width, font)
List box with single or multi-select.

**Parameters:**
- `selected` (int or ds_map) - Selected index (single) or ds_map of selected items (multi)
- `items` (array) - Item labels
- `item_count` (int) - Number of items
- `multi_select` (bool, default: false) - Enable multi-select
- `width` (real, optional) - List width
- `font` (font, optional) - Font override

**Returns:** int or ds_map - New selection

---

### gmui_multiselect(selected, items, item_count, width, height, font)
Multi-select list with checkboxes.

**Parameters:**
- `selected` (ds_map) - Map of selected items
- `items` (array) - Item labels
- `item_count` (int) - Number of items
- `width` (real, optional) - List width
- `height` (real, optional) - List height
- `font` (font, optional) - Font override

**Returns:** ds_map - Updated selection map

---

### gmui_kv_list(items, count, width, font)
Key-value property list.

**Parameters:**
- `items` (array) - 2D array of [key, value] pairs
- `count` (int) - Number of items
- `width` (real, optional) - List width
- `font` (font, optional) - Font override

**Returns:** bool - True

---

## Progress Widgets

### gmui_progress_bar(value, min_val, max_val, width, show_text, font)
Progress bar.

**Parameters:**
- `value` (real) - Current value
- `min_val` (real, default: 0) - Minimum value
- `max_val` (real, default: 1) - Maximum value
- `width` (real, optional) - Bar width
- `show_text` (bool, default: true) - Show percentage text
- `font` (font, optional) - Font override

**Returns:** real - Original value

---

### gmui_progress_bar_indeterminate(width)
Animated indeterminate progress bar.

**Parameters:**
- `width` (real, optional) - Bar width

**Returns:** Nothing

---

### gmui_progress_circular(value, min_val, max_val, size, show_text, font)
Circular progress indicator.

**Parameters:**
- `value` (real) - Current value
- `min_val` (real, default: 0) - Minimum value
- `max_val` (real, default: 1) - Maximum value
- `size` (real, optional) - Indicator size
- `show_text` (bool, default: true) - Show percentage text
- `font` (font, optional) - Font override

**Returns:** real - Original value

---

### gmui_progress_spinner(size, thickness)
Animated loading spinner.

**Parameters:**
- `size` (real, optional) - Spinner size
- `thickness` (real, optional) - Line thickness

**Returns:** Nothing

---

### gmui_spinner(size, thickness)
Small loading spinner.

**Parameters:**
- `size` (real, default: 16) - Spinner size
- `thickness` (real, default: 2) - Line thickness

**Returns:** Nothing

---

## Color Widgets

### gmui_color_pick(color, id)
Color picker with dropdown.

**Parameters:**
- `color` (int) - RGBA color value
- `id` (string, default: "unnamed") - Picker identifier

**Returns:** int - New RGBA color

---

### gmui_color_palette(selected_color, colors, count, cols)
Grid of preset color swatches.

**Parameters:**
- `selected_color` (int) - Currently selected color (RGB)
- `colors` (array) - Array of RGB colors
- `count` (int) - Number of colors
- `cols` (int, optional) - Number of columns

**Returns:** int - New selected color

---

### gmui_color_button(color, size)
Color preview button.

**Parameters:**
- `color` (int) - RGBA color value
- `size` (real, optional) - Button size

**Returns:** bool - True if clicked

---

## Date Picker

### gmui_date_picker(date_array, font)
Date picker widget.

**Parameters:**
- `date_array` (array) - [year, month, day]
- `font` (font, optional) - Font override

**Returns:** array - New [year, month, day]

---

## Layout Functions

### gmui_newline()
Force next widget to new line.

**Parameters:** None

**Returns:** Nothing

---

### gmui_sameline()
Keep next widget on same line.

**Parameters:** None

**Returns:** Nothing

---

### gmui_indent(amount)
Increase indent level.

**Parameters:**
- `amount` (real) - Indent amount in pixels

**Returns:** Nothing

---

### gmui_unindent(amount)
Decrease indent level.

**Parameters:**
- `amount` (real) - Indent amount in pixels

**Returns:** Nothing

---

### gmui_separator()
Horizontal separator line.

**Parameters:** None

**Returns:** Nothing

---

### gmui_separator_vertical(stay, new_line, height)
Vertical separator line.

**Parameters:**
- `stay` (bool, default: true) - Stay on same line
- `new_line` (bool, default: false) - Force new line after
- `height` (real, optional) - Separator height

**Returns:** Nothing

---

### gmui_separator_text(text, font)
Horizontal separator with centered text.

**Parameters:**
- `text` (string) - Text to display
- `font` (font, optional) - Font override

**Returns:** Nothing

---

### gmui_separator_text_left(text, font)
Horizontal separator with left-aligned text.

**Parameters:**
- `text` (string) - Text to display
- `font` (font, optional) - Font override

**Returns:** Nothing

---

### gmui_dummy(width, height)
Empty space.

**Parameters:**
- `width` (real) - Width
- `height` (real) - Height

**Returns:** Nothing

---

## Columns & Rows

### gmui_begin_columns(count, ratios, height)
Start horizontal columns layout.

**Parameters:**
- `count` (int) - Number of columns
- `ratios` (array, optional) - Width ratios (sums to 1)
- `height` (real, default: 200) - Column height

**Returns:** Nothing

---

### gmui_set_column(idx)
Switch to column index.

**Parameters:**
- `idx` (int) - Column index (0-based)

**Returns:** Nothing

---

### gmui_end_columns()
End columns layout.

**Parameters:** None

**Returns:** Nothing

---

### gmui_begin_rows(count, ratios, width)
Start vertical rows layout.

**Parameters:**
- `count` (int) - Number of rows
- `ratios` (array, optional) - Height ratios (sums to 1)
- `width` (real, default: 200) - Row width

**Returns:** Nothing

---

### gmui_set_row(idx)
Switch to row index.

**Parameters:**
- `idx` (int) - Row index (0-based)

**Returns:** Nothing

---

### gmui_end_rows()
End rows layout.

**Parameters:** None

**Returns:** Nothing

---

### gmui_auto_column(rows, column_count, column_ratios, row_height)
Auto layout that transposes rows to columns.

**Parameters:**
- `rows` (array) - 2D array of cell structs
- `column_count` (int) - Number of columns
- `column_ratios` (array, optional) - Column width ratios
- `row_height` (real, default: 24) - Height per row

**Returns:** array - Column container references

**Cell Struct Fields:**
- `widget` (string) - Widget name without "gmui_"
- `params` (array, optional) - Widget parameters
- `variable_owner` (struct, optional) - Owner for variable binding
- `variable_name` (string, optional) - Variable name for binding

**Example:**
```gml
var cols = gmui_auto_column([
    [
        { widget: "text", params: [ "Name:" ] },
        { widget: "textbox", params: [ global.name, "Enter name" ], variable_owner: global, variable_name: "name" }
    ],
    [
        { widget: "text", params: [ "Level:" ] },
        { widget: "input_int", params: [ global.level, 1, 1, 99 ], variable_owner: global, variable_name: "level" }
    ]
], 2);
```

---

### gmui_auto_row(columns, row_count, row_ratios, col_width)
Auto layout that transposes columns to rows.

**Parameters:**
- `columns` (array) - 2D array of cell structs
- `row_count` (int) - Number of rows
- `row_ratios` (array, optional) - Row height ratios
- `col_width` (real, default: 24) - Width per column

**Returns:** array - Row container references

---

## WINS Docking

### gmui_begin_wins(name, direction, ratios)
Start a split pane container.

**Parameters:**
- `name` (string) - Split identifier
- `direction` (int) - gmui_split_dir.HORIZONTAL or VERTICAL
- `ratios` (array, optional) - Pane size ratios

**Returns:** bool - True

---

### gmui_begin_wins_pane(index)
Start a pane within a split.

**Parameters:**
- `index` (int) - Pane index (0-based)

**Returns:** bool - True if pane created

---

### gmui_end_wins_pane()
End current pane.

**Parameters:** None

**Returns:** Nothing

---

### gmui_end_wins()
End split container.

**Parameters:** None

**Returns:** Nothing

---

### gmui_get_current_wins_pane()
Get current pane container.

**Parameters:** None

**Returns:** struct or undefined - Current pane container

---

### Split Directions (gmui_split_dir)

| Value | Description |
|-------|-------------|
| `gmui_split_dir.HORIZONTAL` | Top/Bottom split |
| `gmui_split_dir.VERTICAL` | Left/Right split |

---

## Tabs

### gmui_tabs(name, selected_index, width, height, group, handlers, flags, font)
Tab bar widget.

**Parameters:**
- `name` (string) - Tab bar identifier
- `selected_index` (int) - Currently selected tab
- `width` (real, optional) - Tab bar width
- `height` (real, optional) - Tab bar height
- `group` (string, optional) - Group for cross-bar dragging
- `handlers` (struct, optional) - Event handlers
- `flags` (int, optional) - Tab flags
- `font` (font, optional) - Font override

**Returns:** int - New selected index

**Handlers Struct:**
```gml
{
    on_empty_detach: function(tab_data, detached_label),
    on_bar_attach: function(source_data, target_data),
    on_tab_close: function(tab_data, closed_label),
    on_tab_select: function(tab_data, selected_label)
}
```

---

### gmui_tab_add(name, label)
Add a tab.

**Parameters:**
- `name` (string) - Tab bar identifier
- `label` (string) - Tab label

**Returns:** Nothing

---

### gmui_tab_insert(name, label, index)
Insert tab at index.

**Parameters:**
- `name` (string) - Tab bar identifier
- `label` (string) - Tab label
- `index` (int) - Insert position

**Returns:** Nothing

---

### gmui_tab_delete(name, label)
Delete tab by label.

**Parameters:**
- `name` (string) - Tab bar identifier
- `label` (string) - Tab label to delete

**Returns:** bool - True if deleted

---

### gmui_tab_set_labels(name, labels)
Set all tabs at once.

**Parameters:**
- `name` (string) - Tab bar identifier
- `labels` (array) - Array of tab labels

**Returns:** Nothing

---

### gmui_tab_get_label(name, index)
Get tab label at index.

**Parameters:**
- `name` (string) - Tab bar identifier
- `index` (int) - Tab index

**Returns:** string or undefined - Tab label

---

### Tab Flags (gmui_tab_flags)

| Flag | Value | Description |
|------|-------|-------------|
| NONE | 0 | No flags |
| NO_MOVE | 1 << 0 | Disable drag reordering |
| NO_CLOSE | 1 << 1 | Disable close buttons |

---

## Tree View

### gmui_tree_begin(name)
Start tree view.

**Parameters:**
- `name` (string) - Tree identifier

**Returns:** bool - True

---

### gmui_tree_node(label, default_open, font)
Tree node (collapsible).

**Parameters:**
- `label` (string) - Node label
- `default_open` (bool, default: false) - Initial open state
- `font` (font, optional) - Font override

**Returns:** bool - True if node is open

---

### gmui_tree_leaf(label, font)
Tree leaf (non-collapsible item).

**Parameters:**
- `label` (string) - Leaf label
- `font` (font, optional) - Font override

**Returns:** bool - True if clicked

---

### gmui_tree_node_end()
End current tree node.

**Parameters:** None

**Returns:** Nothing

---

### gmui_tree_end()
End tree view.

**Parameters:** None

**Returns:** Nothing

---

## Collapsing Header

### gmui_begin_collapsing_header(label, default_open, font)
Start collapsible section.

**Parameters:**
- `label` (string) - Header label
- `default_open` (bool, default: false) - Initial open state
- `font` (font, optional) - Font override

**Returns:** bool - True if open (draw content)

---

### gmui_begin_collapsing_header_ex(label, default_open, font)
Compact version of collapsing header.

**Parameters:**
- `label` (string) - Header label
- `default_open` (bool, default: false) - Initial open state
- `font` (font, optional) - Font override

**Returns:** bool - True if open

---

### gmui_end_collapsing_header()
End collapsible section.

**Parameters:** None

**Returns:** Nothing

---

## Popups

### gmui_begin_popup(name, width, height, is_modal)
Start popup window.

**Parameters:**
- `name` (string) - Popup identifier
- `width` (real, default: 320) - Popup width
- `height` (real, default: 160) - Popup height
- `is_modal` (bool, default: false) - Modal mode

**Returns:** bool - True if popup open

---

### gmui_end_popup()
End popup window.

**Parameters:** None

**Returns:** Nothing

---

### gmui_popup_open(name, x, y)
Open popup at position.

**Parameters:**
- `name` (string) - Popup identifier
- `x` (real, optional) - X position
- `y` (real, optional) - Y position

**Returns:** Nothing

---

### gmui_popup_close(name)
Close popup.

**Parameters:**
- `name` (string) - Popup identifier

**Returns:** Nothing

---

### gmui_popup_toggle(name)
Toggle popup open/close.

**Parameters:**
- `name` (string) - Popup identifier

**Returns:** bool - New open state

---

### gmui_popup_is_open(name)
Check if popup is open.

**Parameters:**
- `name` (string) - Popup identifier

**Returns:** bool - True if open

---

## Context Menus

### gmui_begin_context_menu(name, width, height)
Start context menu.

**Parameters:**
- `name` (string) - Menu identifier
- `width` (real, default: 160) - Menu width
- `height` (real, default: 320) - Menu height

**Returns:** bool - True if menu open

---

### gmui_end_context_menu()
End context menu.

**Parameters:** None

**Returns:** Nothing

---

### gmui_context_menu_open(name, x, y)
Open context menu at position.

**Parameters:**
- `name` (string) - Menu identifier
- `x` (real, optional) - X position
- `y` (real, optional) - Y position

**Returns:** Nothing

---

### gmui_context_menu_close(name)
Close context menu.

**Parameters:**
- `name` (string) - Menu identifier

**Returns:** Nothing

---

### gmui_context_menu_item(text, short_cut, font)
Menu item.

**Parameters:**
- `text` (string) - Item label
- `short_cut` (string, optional) - Keyboard shortcut text
- `font` (font, optional) - Font override

**Returns:** bool - True if clicked

---

### gmui_context_menu_item_checkbox(text, checked)
Checkbox menu item.

**Parameters:**
- `text` (string) - Item label
- `checked` (bool) - Current state

**Returns:** bool - New state

---

### gmui_context_menu_item_radio(text, selected)
Radio menu item.

**Parameters:**
- `text` (string) - Item label
- `selected` (bool) - Current state

**Returns:** bool - True if clicked (should select this)

---

### gmui_begin_context_menu_sub(text)
Start sub-menu.

**Parameters:**
- `text` (string) - Sub-menu label

**Returns:** bool - True if sub-menu open

---

### gmui_end_context_menu_sub()
End sub-menu.

**Parameters:** None

**Returns:** Nothing

---

## Tooltips & Toasts

### gmui_tooltip(text, widget, width, font)
Show tooltip on widget hover.

**Parameters:**
- `text` (string) - Tooltip text
- `widget` (struct) - Widget from gmui_widget_get_last()
- `width` (real, optional) - Tooltip width
- `font` (font, optional) - Font override

**Returns:** Nothing

**Example:**
```gml
if (gmui_button("Hover me")) { /* action */ }
gmui_tooltip("This is a tooltip", gmui_widget_get_last());
```

---

### gmui_toast_push(message, type, duration)
Show toast notification.

**Parameters:**
- `message` (string) - Notification message
- `type` (string, default: "info") - "info", "success", "error", "warning"
- `duration` (real, optional) - Display duration in ms

**Returns:** Nothing

---

### gmui_widget_get_last()
Get last created widget.

**Parameters:** None

**Returns:** struct - Last widget

---

## Charts

### gmui_plot_lines(values, count, width, height, show_points)
Line chart.

**Parameters:**
- `values` (array) - Data values
- `count` (int) - Number of values
- `width` (real, optional) - Chart width
- `height` (real, default: 120) - Chart height
- `show_points` (bool, default: true) - Show data points

**Returns:** bool - True

---

### gmui_plot_bars(values, count, width, height)
Bar chart.

**Parameters:**
- `values` (array) - Data values
- `count` (int) - Number of values
- `width` (real, optional) - Chart width
- `height` (real, default: 120) - Chart height

**Returns:** bool - True

---

### gmui_plot_histogram(values, count, width, height, bins)
Histogram.

**Parameters:**
- `values` (array) - Data values
- `count` (int) - Number of values
- `width` (real, optional) - Chart width
- `height` (real, default: 120) - Chart height
- `bins` (int, default: 10) - Number of bins

**Returns:** bool - True

---

### gmui_plot_histogram_normalized(values, count, width, height, bins, font)
Normalized histogram (shows percentages).

**Parameters:**
- `values` (array) - Data values
- `count` (int) - Number of values
- `width` (real, optional) - Chart width
- `height` (real, default: 120) - Chart height
- `bins` (int, default: 10) - Number of bins
- `font` (font, optional) - Font override

**Returns:** bool - True

---

### gmui_plot_scatter(x_values, y_values, count, width, height)
Scatter plot.

**Parameters:**
- `x_values` (array) - X coordinates
- `y_values` (array) - Y coordinates
- `count` (int) - Number of points
- `width` (real, optional) - Chart width
- `height` (real, default: 120) - Chart height

**Returns:** bool - True

---

### gmui_plot_stem(values, labels, count, width, height, radius, color, font)
Stem plot.

**Parameters:**
- `values` (array) - Data values
- `labels` (array) - Point labels
- `count` (int) - Number of points
- `width` (real, optional) - Chart width
- `height` (real, default: 120) - Chart height
- `radius` (real, default: 3) - Point radius
- `color` (color, optional) - Stem color
- `font` (font, optional) - Font override

**Returns:** bool - True

---

### gmui_plot_stair(values, count, width, height, mode)
Stair step plot.

**Parameters:**
- `values` (array) - Data values
- `count` (int) - Number of values
- `width` (real, optional) - Chart width
- `height` (real, default: 120) - Chart height
- `mode` (string, default: "post") - "pre" or "post"

**Returns:** bool - True

---

### gmui_plot_pie(values, labels, count, width, height, show_legend, font)
Pie chart.

**Parameters:**
- `values` (array) - Slice values
- `labels` (array) - Slice labels
- `count` (int) - Number of slices
- `width` (real, optional) - Chart width
- `height` (real, default: 200) - Chart height
- `show_legend` (bool, optional) - Show legend
- `font` (font, optional) - Font override

**Returns:** bool - True

---

### gmui_plot_donut(values, labels, count, width, height, donut_ratio, show_legend)
Donut chart.

**Parameters:**
- `values` (array) - Slice values
- `labels` (array) - Slice labels
- `count` (int) - Number of slices
- `width` (real, optional) - Chart width
- `height` (real, default: 200) - Chart height
- `donut_ratio` (real, default: 0.5) - Hole size ratio
- `show_legend` (bool, optional) - Show legend

**Returns:** bool - True

---

### gmui_plot_pie_exploded(values, labels, count, width, height, explode_all, show_legend)
Exploded pie chart.

**Parameters:**
- `values` (array) - Slice values
- `labels` (array) - Slice labels
- `count` (int) - Number of slices
- `width` (real, optional) - Chart width
- `height` (real, default: 200) - Chart height
- `explode_all` (bool, default: false) - Explode all slices
- `show_legend` (bool, optional) - Show legend

**Returns:** bool - True

---

### gmui_plot_area(series, series_count, values_per_series, width, height)
Area chart.

**Parameters:**
- `series` (array) - 2D array of series data
- `series_count` (int) - Number of series
- `values_per_series` (int) - Values per series
- `width` (real, optional) - Chart width
- `height` (real, default: 120) - Chart height

**Returns:** bool - True

---

### gmui_plot_stacked_bars(series, series_count, values_per_series, width, height)
Stacked bar chart.

**Parameters:**
- `series` (array) - 2D array of series data
- `series_count` (int) - Number of series
- `values_per_series` (int) - Values per series
- `width` (real, optional) - Chart width
- `height` (real, default: 120) - Chart height

**Returns:** bool - True

---

### gmui_plot_grouped_bars(series, series_count, values_per_series, width, height)
Grouped bar chart.

**Parameters:**
- `series` (array) - 2D array of series data
- `series_count` (int) - Number of series
- `values_per_series` (int) - Values per series
- `width` (real, optional) - Chart width
- `height` (real, default: 120) - Chart height

**Returns:** bool - True

---

### gmui_plot_heatmap(values, rows, cols, width, height, font)
Heatmap.

**Parameters:**
- `values` (array) - 2D array of cell values
- `rows` (int) - Number of rows
- `cols` (int) - Number of columns
- `width` (real, optional) - Chart width
- `height` (real, optional) - Chart height
- `font` (font, optional) - Font override

**Returns:** bool - True

---

### gmui_plot_radar(series, series_count, values_per_series, labels, size, font)
Radar/spider chart.

**Parameters:**
- `series` (array) - 2D array of series data
- `series_count` (int) - Number of series
- `values_per_series` (int) - Values per series
- `labels` (array) - Axis labels
- `size` (real, default: 200) - Chart size
- `font` (font, optional) - Font override

**Returns:** bool - True

---

### gmui_plot_box(datasets, dataset_count, labels, width, height, font)
Box plot.

**Parameters:**
- `datasets` (array) - Array of data arrays
- `dataset_count` (int) - Number of datasets
- `labels` (array) - Dataset labels
- `width` (real, optional) - Chart width
- `height` (real, default: 200) - Chart height
- `font` (font, optional) - Font override

**Returns:** bool - True

---

### gmui_plot_funnel(values, labels, count, width, height, font)
Funnel chart.

**Parameters:**
- `values` (array) - Stage values
- `labels` (array) - Stage labels
- `count` (int) - Number of stages
- `width` (real, optional) - Chart width
- `height` (real, default: 200) - Chart height
- `font` (font, optional) - Font override

**Returns:** bool - True

---

### gmui_plot_waterfall(values, labels, count, width, height, font)
Waterfall chart.

**Parameters:**
- `values` (array) - Change values
- `labels` (array) - Stage labels
- `count` (int) - Number of stages
- `width` (real, optional) - Chart width
- `height` (real, default: 200) - Chart height
- `font` (font, optional) - Font override

**Returns:** bool - True

---

### gmui_plot_bubble(x_values, y_values, size_values, count, width, height)
Bubble chart.

**Parameters:**
- `x_values` (array) - X coordinates
- `y_values` (array) - Y coordinates
- `size_values` (array) - Bubble sizes
- `count` (int) - Number of bubbles
- `width` (real, optional) - Chart width
- `height` (real, default: 200) - Chart height

**Returns:** bool - True

---

### gmui_plot_gantt(tasks, task_count, start_times, end_times, colors, today, width, font)
Gantt chart.

**Parameters:**
- `tasks` (array) - Task labels
- `task_count` (int) - Number of tasks
- `start_times` (array) - Start times
- `end_times` (array) - End times
- `colors` (array, optional) - Task colors
- `today` (real, optional) - Today marker line
- `width` (real, optional) - Chart width
- `font` (font, optional) - Font override

**Returns:** bool - True

---

### gmui_plot_error_bars(x_values, y_values, low_values, high_values, count, width, height)
Error bars chart.

**Parameters:**
- `x_values` (array) - X positions
- `y_values` (array) - Y values (center)
- `low_values` (array) - Lower error bounds
- `high_values` (array) - Upper error bounds
- `count` (int) - Number of points
- `width` (real, optional) - Chart width
- `height` (real, default: 200) - Chart height

**Returns:** bool - True

---

### gmui_plot_gauge(value, min_val, max_val, label, size, font)
Gauge/speedometer chart.

**Parameters:**
- `value` (real) - Current value
- `min_val` (real) - Minimum value
- `max_val` (real) - Maximum value
- `label` (string, default: "") - Gauge label
- `size` (real, optional) - Gauge size
- `font` (font, optional) - Font override

**Returns:** real - Original value

---

### gmui_plot_table(headers, data, rows, cols, width, font)
Table plot.

**Parameters:**
- `headers` (array) - Column headers
- `data` (array) - 2D array of cell data
- `rows` (int) - Number of rows
- `cols` (int) - Number of columns
- `width` (real, optional) - Table width
- `font` (font, optional) - Font override

**Returns:** bool - True

---

### gmui_plot_legend(labels, colors, count, columns, width)
Standalone legend.

**Parameters:**
- `labels` (array) - Legend labels
- `colors` (array) - Legend colors
- `count` (int) - Number of items
- `columns` (int, default: 1) - Number of columns
- `width` (real, optional) - Legend width

**Returns:** Nothing

---

## Style Functions

### gmui_style_editor()
Open interactive style editor window.

**Parameters:** None

**Returns:** Nothing

---

### gmui_style_apply_ruler(ruler)
Apply ruler preset to all styles.

**Parameters:**
- `ruler` (struct) - Ruler with base style values

**Returns:** Nothing

---

### gmui_style_get(key)
Get style value.

**Parameters:**
- `key` (string) - Style property name

**Returns:** mixed - Style value

---

### gmui_style_set(key, value)
Set style value.

**Parameters:**
- `key` (string) - Style property name
- `value` (mixed) - New value

**Returns:** Nothing

---

### gmui_style_push(key, value)
Push style value to stack.

**Parameters:**
- `key` (string) - Style property name
- `value` (mixed) - Temporary value

**Returns:** Nothing

---

### gmui_style_pop(key)
Pop style value from stack.

**Parameters:**
- `key` (string) - Style property name

**Returns:** Nothing

---

### gmui_style_push_multi(map)
Push multiple style values.

**Parameters:**
- `map` (struct) - Key-value pairs

**Returns:** Nothing

---

### gmui_style_pop_multi(keys)
Pop multiple style values.

**Parameters:**
- `keys` (array) - Array of property names

**Returns:** Nothing

---

### gmui_style_scope(key, value, func)
Temporary style override.

**Parameters:**
- `key` (string) - Style property name
- `value` (mixed) - Temporary value
- `func` (function) - Function to execute

**Returns:** Nothing

---

### gmui_style_scope_multi(map, func)
Temporary multiple style overrides.

**Parameters:**
- `map` (struct) - Key-value pairs
- `func` (function) - Function to execute

**Returns:** Nothing

---

## Color Functions

### gmui_make_color_rgba(r, g, b, a)
Create RGBA color.

**Parameters:**
- `r` (int) - Red (0-255)
- `g` (int) - Green (0-255)
- `b` (int) - Blue (0-255)
- `a` (int) - Alpha (0-255)

**Returns:** int - Packed RGBA color

---

### gmui_color_rgba_get_red(color)
Get red component.

**Parameters:**
- `color` (int) - RGBA color

**Returns:** int - Red value (0-255)

---

### gmui_color_rgba_get_green(color)
Get green component.

**Parameters:**
- `color` (int) - RGBA color

**Returns:** int - Green value (0-255)

---

### gmui_color_rgba_get_blue(color)
Get blue component.

**Parameters:**
- `color` (int) - RGBA color

**Returns:** int - Blue value (0-255)

---

### gmui_color_rgba_get_alpha(color)
Get alpha component.

**Parameters:**
- `color` (int) - RGBA color

**Returns:** int - Alpha value (0-255)

---

### gmui_color_rgb_to_rgba(color, alpha)
Convert RGB to RGBA.

**Parameters:**
- `color` (int) - RGB color
- `alpha` (int, default: 255) - Alpha value

**Returns:** int - RGBA color

---

### gmui_color_rgba_to_rgb(color)
Convert RGBA to RGB (discards alpha).

**Parameters:**
- `color` (int) - RGBA color

**Returns:** int - RGB color

---

### gmui_color_rgba_to_array(color)
Convert RGBA to array.

**Parameters:**
- `color` (int) - RGBA color

**Returns:** array - [r, g, b, a]

---

### gmui_color_rgba_from_array(arr)
Convert array to RGBA.

**Parameters:**
- `arr` (array) - [r, g, b, a]

**Returns:** int - RGBA color

---

### gmui_color_lerp(color1, color2, t)
Linear interpolate between colors.

**Parameters:**
- `color1` (int) - Start RGBA color
- `color2` (int) - End RGBA color
- `t` (real) - Interpolation factor (0-1)

**Returns:** int - Interpolated RGBA color

---

### gmui_color_set_alpha(color, alpha)
Set alpha of RGBA color.

**Parameters:**
- `color` (int) - RGBA color
- `alpha` (int) - New alpha (0-255)

**Returns:** int - RGBA color with new alpha

---

## Input Functions

### gmui_input_mouse_pressed()
**Returns:** bool - Left mouse button pressed this frame

---

### gmui_input_mouse_released()
**Returns:** bool - Left mouse button released this frame

---

### gmui_input_mouse_held()
**Returns:** bool - Left mouse button held

---

### gmui_input_mouse_x()
**Returns:** real - Mouse X position in GUI coordinates

---

### gmui_input_mouse_y()
**Returns:** real - Mouse Y position in GUI coordinates

---

### gmui_input_is_hovered(x, y, width, height)
**Returns:** bool - Mouse inside rectangle

---

### gmui_input_key_pressed()
**Returns:** bool - Any key pressed this frame

---

### gmui_input_key()
**Returns:** int - Current key code

---

### gmui_input_lastchar()
**Returns:** string - Last character typed

---

### gmui_input_lastkey()
**Returns:** int - Last key code

---

### gmui_input_ctrl()
**Returns:** bool - Ctrl key held

---

### gmui_input_shift()
**Returns:** bool - Shift key held

---

### gmui_input_alt()
**Returns:** bool - Alt key held

---

### gmui_input_key_held(key)
**Parameters:**
- `key` (int) - Virtual key constant

**Returns:** bool - Key held

---

## Demo

### gmui_demo()
Open interactive demo window showcasing all widgets.

**Parameters:** None

**Returns:** Nothing
