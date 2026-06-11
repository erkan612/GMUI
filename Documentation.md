# GMUI - Full Documentation

---

## Table of Contents

1. [Core Concepts](#core-concepts)
2. [Windows](#windows)
3. [Widgets](#widgets)
4. [Layout](#layout)
5. [WINS Docking](#wins-docking)
6. [Tabs](#tabs)
7. [Charts](#charts)
8. [Popups & Context Menus](#popups--context-menus)
9. [Styling](#styling)
10. [Containers](#containers)
11. [Input Handling](#input-handling)
12. [Tooltips & Toasts](#tooltips--toasts)

---

## Core Concepts

### Immediate Mode

GMUI uses immediate-mode rendering. You declare your UI every frame:

```gml
// Step event
gmui_update();

if (gmui_begin_window("Window", 0, 0, 200, 100)) {
    if (gmui_button("Click")) {
        // action
    }
    gmui_end_window();
}

// Draw event
gmui_draw_gui();
```

The framework collects UI calls in Step and renders them in Draw.

### Z-Layers

Windows and containers exist in four layers:

| Layer | Base | Use |
|-------|------|-----|
| BACKGROUND | 0 | Reserved |
| NORMAL | 1000 | Regular windows |
| MODAL_BG | 2000 | Modal dimming overlays |
| POPUP | 2500 | Popups, context menus, tooltips |

### Containers

Every UI element lives in a container. Containers provide:
- Scrolling
- Background rendering
- Surface caching
- Masking
- Child management

---

## Windows

### Basic Window

```gml
if (gmui_begin_window("Title", x, y, width, height, flags)) {
    // widgets
    gmui_end_window();
}
```

### Window Flags

```gml
enum gmui_window_flags {
    NONE = 0,
    NO_TITLE_BAR = 1 << 0,
    NO_MOVE_WITH_MOUSE = 1 << 1,
    NO_CLOSE = 1 << 2,
    NO_COLLAPSE = 1 << 3,
    NO_SCROLL = 1 << 4,
    NO_BORDERS = 1 << 5,
    NO_BORDER_RESIZE = 1 << 6,
}

// Example
gmui_begin_window("No close button", 0, 0, 200, 100, gmui_window_flags.NO_CLOSE);
```

### Window Operations

```gml
// Bring to front
gmui_container_bring_to_front("Window Name");

// Close window from code
var win = gmui_container_get("Window Name");
win.is_enabled = false;

// Get/set position
gmui_container_set_pos("Window Name", 100, 200);
var pos = gmui_container_get_screen_pos("Window Name");

// Get/set size
gmui_container_set_size("Window Name", 400, 300);
var size = gmui_container_get_size("Window Name");
```

### Window Menu Bar

```gml
gmui_window_menu([
    [ "File", "file_context_menu" ],
    [ "Edit", "edit_context_menu" ],
    [ "View", "" ],  // empty string = no menu
    [ "Help", "help_context_menu" ]
]);
```

---

## Widgets

### Text

```gml
gmui_text("Normal text");
gmui_text_colored("Colored text", c_red);
gmui_text_disabled("Disabled text");
gmui_text_bullet("Bullet point");
gmui_text_wrap("Long text that will wrap automatically", 200);
gmui_text_label("Label", "Value");
if (gmui_text_clickable("Clickable link")) {
    // action
}
```

### Buttons

| Function | Description |
|----------|-------------|
| `gmui_button(text)` | Standard button |
| `gmui_button_primary(text)` | Accent-colored button |
| `gmui_button_success(text)` | Green success button |
| `gmui_button_danger(text)` | Red danger button |
| `gmui_button_ghost(text)` | Transparent button |
| `gmui_button_toggle(text, state)` | Toggle button |
| `gmui_button_loading(text, loading)` | Loading state button |
| `gmui_button_hold(text, hold_ms)` | Hold to confirm |
| `gmui_button_arrow(direction)` | Arrow button (0=up,1=down,2=left,3=right) |
| `gmui_button_minus()` | Minus button |
| `gmui_button_plus()` | Plus button |
| `gmui_button_icon(sprite)` | Icon button |
| `gmui_button_icon_text(sprite, text)` | Icon with text |

```gml
if (gmui_button("Click")) { /* action */ }
if (gmui_button_primary("Save")) { /* save */ }
if (gmui_button_danger("Delete")) { /* delete */ }

static toggled = false;
toggled = gmui_button_toggle("Toggle", toggled);

if (gmui_button_hold("Hold to Confirm", 800)) {
    // confirmed after 800ms hold
}
```

### Checkboxes & Toggles

```gml
// Checkbox
global.option = gmui_checkbox(global.option, "Enable");
global.option = gmui_checkbox_success(global.option, "Success");
global.option = gmui_checkbox_danger(global.option, "Danger");
gmui_checkbox_disabled(true, "Disabled");

// Toggle switch
global.setting = gmui_toggle(global.setting);
global.setting = gmui_toggle_success(global.setting);
global.setting = gmui_toggle_danger(global.setting);
gmui_toggle_disabled(true);
```

### Radio Buttons

```gml
// Individual
if (gmui_radio("Option A", global.selected == 0)) global.selected = 0;

// Radio group
global.options = ["A", "B", "C"];
global.selected = gmui_radio_group(global.options, global.selected);
```

### Text Input

```gml
global.text = gmui_textbox(global.text, "placeholder", 200);
gmui_textbox_disabled(global.text, "placeholder", 200);
```

### Numeric Input

```gml
global.value = gmui_input_int(global.value, step, min, max, width);
global.value = gmui_input_float(global.value, step, min, max, width);
gmui_input_int_disabled(global.value, width);
gmui_input_float_disabled(global.value, width);
```

### Sliders & Knobs

```gml
global.value = gmui_slider(global.value, min, max, width);
gmui_slider_disabled(global.value, min, max, width);

global.knob = gmui_knob(global.knob, min, max, size, label);
```

### Selectable

```gml
if (gmui_selectable("Item", global.selected == i, width)) {
    global.selected = i;
}
gmui_selectable_disabled("Disabled", false, width);
```

### Combo Box (Dropdown)

```gml
global.items = ["A", "B", "C"];
global.selected = gmui_combo(global.selected, global.items, 3);
gmui_combo_disabled(global.selected, global.items, 3);
```

### List Box

```gml
// Single select
global.selected = gmui_list_box(global.selected, items, count, false, width);

// Multi-select
global.selected_map = gmui_list_box(global.selected_map, items, count, true, width);
```

### Multi-Select

```gml
global.selected = gmui_multiselect(global.selected, items, count, width, height);
```

### Key-Value List

```gml
global.kv_data = [
    ["Name", "Player"],
    ["Level", 42],
    ["Health", 100]
];
gmui_kv_list(global.kv_data, 3, width);
```

### Collapsing Header

```gml
if (gmui_begin_collapsing_header("Section", true)) {
    gmui_text("Content inside");
    gmui_end_collapsing_header();
}

if (gmui_begin_collapsing_header_ex("Compact Section", false)) {
    gmui_text("Smaller header");
    gmui_end_collapsing_header();
}
```

### Tree View

```gml
gmui_tree_begin("tree_id");

if (gmui_tree_node("Folder A", true)) {
    gmui_tree_leaf("File 1");
    gmui_tree_leaf("File 2");
    
    if (gmui_tree_node("Subfolder")) {
        gmui_tree_leaf("File 3");
        gmui_tree_node_end();
    }
    gmui_tree_node_end();
}

gmui_tree_leaf("Root File");
gmui_tree_end();
```

### Progress Indicators

```gml
gmui_progress_bar(value, min, max, width, show_text);
gmui_progress_bar_indeterminate(width);
gmui_progress_circular(value, min, max, size, show_text);
gmui_progress_spinner(size, thickness);
gmui_spinner(size);
```

### Color Widgets

```gml
// Color picker (returns RGBA)
global.color = gmui_color_pick(global.color, "picker_id");

// Color palette (grid of preset colors)
global.color = gmui_color_palette(global.color, colors_array, count, cols);

// Color button
if (gmui_color_button(global.color, size)) {
    // action
}
```

### Date Picker

```gml
// date_array = [year, month, day]
global.date = gmui_date_picker(global.date);
```

---

## Layout

### Same Line & New Line

```gml
gmui_text("Left");
gmui_sameline();
gmui_text("Right");

gmui_newline();
gmui_text("New line");
```

### Indentation

```gml
gmui_indent(16);
gmui_text("Indented");
gmui_unindent(16);
```

### Separators

```gml
gmui_separator();
gmui_separator_vertical();
gmui_separator_text("Centered Text");
gmui_separator_text_left("Left Text");
```

### Columns

```gml
gmui_begin_columns(3, [0.3, 0.4, 0.3], height);

gmui_set_column(0);
gmui_text("Column 1");

gmui_set_column(1);
gmui_text("Column 2");

gmui_set_column(2);
gmui_text("Column 3");

gmui_end_columns();
```

### Rows

```gml
gmui_begin_rows(3, [0.3, 0.4, 0.3], width);

gmui_set_row(0);
gmui_text("Row 1");

gmui_set_row(1);
gmui_text("Row 2");

gmui_set_row(2);
gmui_text("Row 3");

gmui_end_rows();
```

### Auto Columns (Form Layout)

```gml
// Automatically creates vertical columns from row-major data
gmui_auto_column([
    [ 
        { widget: "text", params: [ "Name:" ] },
        { widget: "textbox", params: [ global.name, "Enter name" ], variable_owner: global, variable_name: "name" },
        { widget: "text", params: [ "Optional help text" ] }
    ],
    [ 
        { widget: "text", params: [ "Level:" ] },
        { widget: "input_int", params: [ global.level, 1, 1, 99 ], variable_owner: global, variable_name: "level" }
    ]
], 3);
```

### Dummy (Empty Space)

```gml
gmui_dummy(width, height);
```

### Sprite & Surface

```gml
gmui_sprite(sprite_index, subimg, width, height);
gmui_surface(surface_id);
```

---

## WINS Docking

Split windows into resizable panes.

```gml
if (gmui_begin_wins("name", gmui_split_dir.HORIZONTAL, [0.3, 0.7])) {
    
    if (gmui_begin_wins_pane(0)) {
        gmui_text("Left pane (30%)");
        gmui_end_wins_pane();
    }
    
    if (gmui_begin_wins_pane(1)) {
        gmui_text("Right pane (70%)");
        
        // Nested vertical split
        if (gmui_begin_wins("nested", gmui_split_dir.VERTICAL, [0.5, 0.5])) {
            
            if (gmui_begin_wins_pane(0)) {
                gmui_text("Top right");
                gmui_end_wins_pane();
            }
            
            if (gmui_begin_wins_pane(1)) {
                gmui_text("Bottom right");
                gmui_end_wins_pane();
            }
            
            gmui_end_wins();
        }
        
        gmui_end_wins_pane();
    }
    
    gmui_end_wins();
}
```

### Split Directions

| Direction | Result |
|-----------|--------|
| `gmui_split_dir.HORIZONTAL` | Top/Bottom split (rows) |
| `gmui_split_dir.VERTICAL` | Left/Right split (columns) |

### Get Current Pane Container

```gml
var pane = gmui_get_current_wins_pane();
if (pane != undefined) {
    pane.background_enabled = true;
}
```

---

## Tabs

### Basic Tabs

```gml
// Add tabs first
gmui_tab_add("my_tabs", "General");
gmui_tab_add("my_tabs", "Graphics");
gmui_tab_add("my_tabs", "Audio");

// Draw tabs
global.selected = gmui_tabs("my_tabs", global.selected, width, height, "group_name");

// Get current tab label
var label = gmui_tab_get_label("my_tabs", global.selected);
```

### Tab Flags

```gml
enum gmui_tab_flags {
    NONE = 0,
    NO_MOVE = 1 << 0,    // Disable drag reordering
    NO_CLOSE = 1 << 1,   // Disable close buttons
}

gmui_tabs("my_tabs", selected, -1, -1, "", gmui_tab_flags.NO_CLOSE);
```

### Tab Operations

```gml
// Add tab
gmui_tab_add("my_tabs", "New Tab");

// Insert tab at index
gmui_tab_insert("my_tabs", "Inserted Tab", 2);

// Delete tab by label
gmui_tab_delete("my_tabs", "General");

// Set all labels at once
gmui_tab_set_labels("my_tabs", ["Tab1", "Tab2", "Tab3"]);
```

### Drag & Drop

Tabs support:
- Drag to reorder within same bar
- Drag to different tab bar (same group name)
- Drag outside to detach as floating window

Use `group_name` parameter to enable cross-bar dragging:

```gml
// Both tab bars with same group can exchange tabs
gmui_tabs("toolbox", 0, -1, -1, "main_group");
gmui_tabs("properties", 0, -1, -1, "main_group");
```

### Detach Handlers

```gml
var handlers = {
    on_empty_detach: function(tab_data, detached_label) {
        // Called when tab is detached to empty space
        // Return -1 to delete, or implement custom behavior
    },
    on_bar_attach: function(source_data, target_data) {
        // Called when tab moves to another bar
    },
    on_tab_close: function(tab_data, closed_label) {
        // Called when tab is closed
    },
    on_tab_select: function(tab_data, selected_label) {
        // Called when tab is selected
    }
};

gmui_tabs("my_tabs", selected, -1, -1, "group", handlers, flags);
```

---

## Charts

### Line Plot

```gml
gmui_plot_lines(values, count, width, height, show_points);
```

### Bar Chart

```gml
gmui_plot_bars(values, count, width, height);
```

### Histogram

```gml
gmui_plot_histogram(values, count, width, height, bins);
gmui_plot_histogram_normalized(values, count, width, height, bins);
```

### Scatter Plot

```gml
gmui_plot_scatter(x_values, y_values, count, width, height);
```

### Stem Plot

```gml
gmui_plot_stem(values, labels, count, width, height, radius, color);
```

### Stair Plot

```gml
// mode: "pre" or "post"
gmui_plot_stair(values, count, width, height, mode);
```

### Pie & Donut Charts

```gml
gmui_plot_pie(values, labels, count, width, height, show_legend);
gmui_plot_donut(values, labels, count, width, height, donut_ratio, show_legend);
gmui_plot_pie_exploded(values, labels, count, width, height, explode_all, show_legend);
```

### Area Chart

```gml
// series: 2D array [series_index][value_index]
gmui_plot_area(series, series_count, values_per_series, width, height);
```

### Stacked Bar Chart

```gml
gmui_plot_stacked_bars(series, series_count, values_per_series, width, height);
```

### Grouped Bar Chart

```gml
gmui_plot_grouped_bars(series, series_count, values_per_series, width, height);
```

### Heatmap

```gml
// data: 2D array [row][col]
gmui_plot_heatmap(data, rows, cols, width, height);
```

### Radar/Spider Chart

```gml
gmui_plot_radar(series, series_count, values_per_series, labels, size);
```

### Box Plot

```gml
gmui_plot_box(datasets, dataset_count, labels, width, height);
```

### Funnel Chart

```gml
gmui_plot_funnel(values, labels, count, width, height);
```

### Waterfall Chart

```gml
gmui_plot_waterfall(values, labels, count, width, height);
```

### Bubble Chart

```gml
gmui_plot_bubble(x_values, y_values, size_values, count, width, height);
```

### Gantt Chart

```gml
gmui_plot_gantt(tasks, task_count, start_times, end_times, colors, today_line, width);
```

### Error Bars

```gml
gmui_plot_error_bars(x_values, y_values, low_values, high_values, count, width, height);
```

### Gauge/Speedometer

```gml
global.value = gmui_plot_gauge(global.value, min, max, label, size);
```

### Table Plot

```gml
gmui_plot_table(headers, data, rows, cols, width);
```

### Legend (Standalone)

```gml
gmui_plot_legend(labels, colors, count, columns, width);
```

---

## Popups & Context Menus

### Modal Popup

```gml
if (gmui_button("Open")) {
    gmui_popup_open("my_popup");
}

if (gmui_begin_popup("my_popup", 300, 200, true)) {
    gmui_text("Modal content");
    
    if (gmui_button("Close")) {
        gmui_popup_close("my_popup");
    }
    
    gmui_end_popup();
}
```

### Non-Modal Popup

```gml
if (gmui_begin_popup("my_popup", 300, 200, false)) {
    // Non-modal, can interact with background
    gmui_end_popup();
}
```

### Popup Operations

```gml
gmui_popup_open("popup_name");
gmui_popup_close("popup_name");
gmui_popup_toggle("popup_name");
var is_open = gmui_popup_is_open("popup_name");
```

### Context Menu

```gml
// Open on right-click (in Step event)
if (mouse_check_button_released(mb_right)) {
    gmui_context_menu_open("my_menu", x, y);  // x,y optional
}

if (gmui_begin_context_menu("my_menu", 180, 200)) {
    
    // Basic item
    if (gmui_context_menu_item("New File", "Ctrl+N")) {
        // action
    }
    
    gmui_separator_text("Options");
    
    // Checkbox item
    global.enabled = gmui_context_menu_item_checkbox("Enable", global.enabled);
    
    // Radio items
    if (gmui_context_menu_item_radio("Option A", global.radio == 0)) global.radio = 0;
    if (gmui_context_menu_item_radio("Option B", global.radio == 1)) global.radio = 1;
    
    // Sub-menu
    if (gmui_begin_context_menu_sub("Sub Menu")) {
        gmui_context_menu_item("Sub Item 1");
        gmui_context_menu_item("Sub Item 2");
        gmui_end_context_menu_sub();
    }
    
    gmui_end_context_menu();
}
```

### Context Menu Close

```gml
gmui_context_menu_close("menu_name");      // Close specific menu
gmui_context_menu_close_forward("name");   // Close menu and all sub-menus forward
gmui_context_menu_close_backward("name");  // Close menu and all parent menus
```

---

## Styling

### Style Editor

```gml
// Open interactive style editor window
gmui_style_editor();
```

### Apply Ruler Preset

```gml
gmui_style_apply_ruler({
    // Colors
    color_bg_dominant: make_color_rgb(24, 24, 24),
    color_bg_secondary: make_color_rgb(30, 30, 30),
    color_accent: make_color_rgb(70, 130, 180),
    color_text_primary: make_color_rgb(225, 225, 225),
    
    // Spacing
    spacing_tiny: 2,
    spacing_small: 4,
    spacing_medium: 8,
    spacing_large: 12,
    spacing_xlarge: 16,
    
    // Rounding
    rounding_container: 0,
    rounding_widget: 4,
    rounding_pill: 12,
    
    // Timing
    tooltip_delay: 500,
    toast_duration: 3000,
    toast_position: "top-center"
});
```

### Individual Style Properties

```gml
// Get/set style values
var color = gmui_style_get("button_color_idle");
gmui_style_set("button_color_idle", make_color_rgb(255, 0, 0));

// Temporary style override
gmui_style_scope("button_padding_h", 16, function() {
    gmui_button("Big padding button");
});
```

### Predefined Themes

```gml
// Dark theme (default)
gmui_style_apply_ruler({ /* dark values */ });

// Light theme
gmui_style_apply_ruler({ /* light values */ });
```

---

## Containers

### Custom Containers

```gml
if (gmui_begin_container("name", x, y, width, height)) {
    // widgets
    gmui_end_container();
}
```

### Container Properties

```gml
var container = gmui.current_container;

// Enable/disable
container.is_enabled = false;

// Background
container.background_enabled = true;
container.background_draw_func = function(c, x1, y1, x2, y2) {
    draw_set_color(c_red);
    draw_rectangle(x1, y1, x2, y2, false);
};

// Scrolling
container.scrolling_enabled = true;
container.scroll_x = 0;
container.scroll_y = 0;
container.scroll_speed = 30;

// Surface caching
container.use_surface = true;

// Masking
container.mask_enabled = true;
container.mask_draw_func = function(c, x1, y1, x2, y2) {
    // mask drawing
};
```

### Container Operations

```gml
// Get container
var c = gmui_container_get("name", parent);

// Position & size
gmui_container_set_pos("name", x, y);
gmui_container_set_size("name", w, h);
gmui_container_set_bounds("name", x, y, w, h);
var bounds = gmui_container_get_bounds("name");

// Z-order
gmui_container_bring_to_front("name");
gmui_container_send_to_back("name");
gmui_container_set_z("name", z);
var z = gmui_container_get_z("name");

// Enable/disable
gmui_container_enable("name");
gmui_container_disable("name");
var active = gmui_container_is_active("name");

// Check hover
var hovered = gmui_container_is_hovered("name");
```

---

## Input Handling

### Mouse Input

```gml
// Get mouse state
var pressed = gmui_input_mouse_pressed();
var held = gmui_input_mouse_held();
var released = gmui_input_mouse_released();
var x = gmui_input_mouse_x();
var y = gmui_input_mouse_y();

// Check hover over area
var hovering = gmui_input_is_hovered(x, y, width, height);
```

### Keyboard Input

```gml
var pressed = gmui_input_key_pressed();
var key = gmui_input_key();
var lastchar = gmui_input_lastchar();
var ctrl = gmui_input_ctrl();
var shift = gmui_input_shift();
var alt = gmui_input_alt();
var held = gmui_input_key_held(vk_space);
```

---

## Tooltips & Toasts

### Basic Tooltip

```gml
if (gmui_button("Hover me")) { /* action */ }
gmui_tooltip("This button does something", gmui_widget_get_last(), 200);
```

### Toast Notifications

```gml
// Types: "info", "success", "error", "warning"
gmui_toast_push("Message here", "info");
gmui_toast_push("Custom duration", "success", 5000);
```

### Toast Configuration

```gml
// Positions: "top-left", "top-center", "top-right", 
//           "bottom-left", "bottom-center", "bottom-right", "middle-center"

global.gmui.style.toast_position = "bottom-center";
global.gmui.style.toast_duration = 3000;
