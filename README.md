# GMUI - GameMaker Immediate Mode UI Library

A feature-rich, immediate mode UI system for GameMaker. GMUI provides a comprehensive set of UI components with a clean, intuitive API that feels natural to GameMaker developers.

![GMUI Demo](https://img.shields.io/badge/GameMaker-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

## 🚀 Features

- **Immediate Mode Architecture** - Simple, frame-based UI creation
- **Comprehensive Component Set** - Buttons, inputs, sliders, color pickers, tree views, and more
- **Window Management** - Draggable, resizable windows with z-ordering
- **Modal System** - Popup dialogs with background dimming
- **Advanced Layout** - Flexible positioning, scrolling, and grouping
- **Customizable Styling** - Extensive theming options
- **Shader Integration** - Hardware-accelerated color pickers
- **Input Handling** - Full mouse and keyboard support

## 📸 Screenshots
<img width="2183" height="937" alt="simplistic_editor_tab_details" src="https://github.com/user-attachments/assets/2416ec1e-aa29-4944-b937-282e6977c79a" />
<img width="2192" height="937" alt="simplistic_editor" src="https://github.com/user-attachments/assets/adf5c0d1-5e8a-4988-90f3-4e04d6e23224" />
<img width="1300" height="716" alt="demo_tab_example5" src="https://github.com/user-attachments/assets/cbd5fcc8-d950-4393-8d7b-10e6b21e8aff" />
<img width="1301" height="723" alt="demo_tab_example4" src="https://github.com/user-attachments/assets/ae3bb123-acc1-45aa-8656-5d32888afea7" />
<img width="1297" height="721" alt="demo_tab_example3" src="https://github.com/user-attachments/assets/db3664c2-6df5-4967-bdaf-417ac7844a93" />
<img width="1299" height="721" alt="demo_tab_example2" src="https://github.com/user-attachments/assets/b5a47dce-34a9-41fb-8683-eb2df979b493" />
<img width="1301" height="720" alt="demo_tab_example1" src="https://github.com/user-attachments/assets/9566c393-069c-464d-b801-c8fc8177c153" />


## 📦 Installation

1. Copy the GMUI script files into your GameMaker project
2. Import the provided shaders for color picker functionality
3. Call `gmui_init()` in your initialization code

```gml
// Create Event
gmui_init();
```

## 🎯 Quick Start

```gml
// Step Event
gmui_update();

if (gmui_begin("My Window", 100, 100, 400, 300)) {
    gmui_text("Hello GMUI!");
    
    static my_value = 50;
    my_value = gmui_slider("Value", my_value, 0, 100);
    
    if (gmui_button("Click Me")) {
        show_debug_message("Button clicked!");
    }
    
    gmui_end();
}

// Draw GUI Event
gmui_render();
```

## 📚 Core Concepts

### Immediate Mode
GMUI uses immediate mode paradigm - you create UI elements every frame. This makes the API simple and predictable:

```gml
// UI is created frame by frame
if (gmui_button("Press Me")) {
    // This code runs only when button is clicked
    handle_button_press();
}
```

### Window Management
Windows are the containers for your UI. They can be dragged, resized, and stacked:

```gml
// Basic window
if (gmui_begin("Window Title", x, y, width, height, flags)) {
    // UI elements go here
    gmui_end();
}

// Window with scrollbars
var flags = gmui_window_flags.AUTO_VSCROLL | gmui_window_flags.SCROLL_WITH_MOUSE_WHEEL;
if (gmui_begin("Scrollable Window", 100, 100, 300, 200, flags)) {
    // Content that can scroll
    for (var i = 0; i < 50; i++) {
        gmui_selectable("Item " + string(i), false);
    }
    gmui_end();
}
```

## 🎨 UI Components

### Basic Elements

```gml
// Text
gmui_text("Hello World!");
gmui_text_disabled("Disabled text");
gmui_label_text("FPS", string(room_speed));

// Buttons
if (gmui_button("Standard Button")) { }
if (gmui_button_small("Small")) { }
if (gmui_button_large("Large")) { }
gmui_button_disabled("Disabled");

// Checkboxes
static checked = false;
checked = gmui_checkbox("Enable feature", checked);
checked = gmui_checkbox_box(checked); // Checkbox without label

// Selectables
static selected_index = 0;
for (var i = 0; i < 3; i++) {
    if (gmui_selectable("Option " + string(i), selected_index == i)) {
        selected_index = i;
    }
}
```

### Input Controls

```gml
// Text input
static text_value = "";
text_value = gmui_textbox(text_value, "Enter text...");

// Numeric input
static int_value = 42;
static float_value = 3.14;
int_value = gmui_input_int(int_value, 1, 0, 100); // value, step, min, max
float_value = gmui_input_float(float_value, 0.1, 0.0, 10.0);

// Sliders
static slider_value = 50;
slider_value = gmui_slider("Intensity", slider_value, 0, 100, 200); // label, value, min, max, width

// Combo boxes
static combo_index = 0;
var items = ["Option 1", "Option 2", "Option 3"];
combo_index = gmui_combo("Choose option", combo_index, items);
```

### Color Tools

```gml
// Color buttons and pickers
static color_value = gmui_make_color_rgba(255, 128, 64, 255);
color_value = gmui_color_button_4("My Color", color_value);
color_value = gmui_color_edit_4("Edit Color", color_value);

// Simple color button
if (gmui_color_button(c_red, 20)) {
    // Red color button clicked
}
```

### Layout & Organization

```gml
// Collapsible headers
static header_open = true;
var header_state = gmui_collapsing_header("Settings", header_open);
header_open = header_state[0];
if (header_open) {
    // Settings content
    gmui_text("Various settings here...");
    gmui_collapsing_header_end();
}

// Tree views
gmui_tree_node_reset();
var node_state = gmui_tree_node_begin("Parent Node", false);
if (node_state[0]) {
    if (gmui_tree_leaf("Child Item", false)) {
        // Child clicked
    }
    gmui_tree_node_end();
}

// Same line layout
gmui_button("Button A"); gmui_same_line();
gmui_button("Button B"); gmui_same_line();
gmui_button("Button C");

// Separators and spacing
gmui_text("Section 1");
gmui_separator();
gmui_text("Section 2");
gmui_dummy(100, 20); // Add empty space
```

## 🪟 Advanced Features

### Modal Dialogs

```gml
// Create modal (typically in step event)
gmui_add_modal("confirm_dialog", function(window) {
    gmui_text("Are you sure you want to delete?");
    if (gmui_button_width_fill("Yes")) {
        // Perform action
        gmui_close_modal("confirm_dialog");
    }
    gmui_same_line();
    if (gmui_button_width_fill("No")) {
        gmui_close_modal("confirm_dialog");
    }
}, 200, 200, 300, 120, gmui_window_flags.NO_RESIZE);

// Open modal when needed
if (gmui_button("Delete Item")) {
    gmui_open_modal("confirm_dialog");
}
```

### Custom Styling

```gml
// Modify global styles
var style = global.gmui.style;
style.window_padding = [12, 12];
style.button_rounding = 8;
style.button_bg_color = make_color_rgb(65, 105, 225);
style.text_color = make_color_rgb(240, 240, 240);

// Temporary style changes
var old_spacing = style.item_spacing[0];
style.item_spacing[0] = 0;
// Create tightly packed elements
style.item_spacing[0] = old_spacing; // Restore
```

### Window Flags

```gml
// Common flag combinations
var flags = gmui_window_flags.NONE; // Default behavior

// No title bar or resize
flags = gmui_window_flags.NO_TITLE_BAR | gmui_window_flags.NO_RESIZE;

// Scrollable window
flags = gmui_window_flags.AUTO_VSCROLL | gmui_window_flags.SCROLL_WITH_MOUSE_WHEEL;

// Popup window
flags = gmui_window_flags.POPUP | gmui_window_flags.NO_RESIZE;

if (gmui_begin("Custom Window", 100, 100, 300, 200, flags)) {
    gmui_end();
}
```

## 🔧 API Reference

### Core Functions

| Function | Description |
|----------|-------------|
| `gmui_init()` | Initialize the UI system |
| `gmui_update()` | Update input state (call in step event) |
| `gmui_render()` | Render all UI (call in draw event) |
| `gmui_cleanup()` | Clean up resources |
| `gmui_get()` | Get global GMUI state |

### Window Management

| Function | Description |
|----------|-------------|
| `gmui_begin(name, x, y, w, h, flags)` | Start a window |
| `gmui_end()` | End current window |
| `gmui_add_modal(name, callback, x, y, w, h, flags, onBgClick)` | Create modal dialog |
| `gmui_open_modal(name)` | Open existing modal |
| `gmui_close_modal(name)` | Close modal |

### Layout Functions

| Function | Description |
|----------|-------------|
| `gmui_same_line()` | Place next item on same line |
| `gmui_new_line()` | Move to next line |
| `gmui_separator()` | Draw horizontal separator |
| `gmui_dummy(w, h)` | Add empty space |
| `gmui_get_cursor()` | Get current cursor position |
| `gmui_set_cursor(x, y)` | Set cursor position |

### Input State

| Function | Description |
|----------|-------------|
| `gmui_is_any_textbox_focused()` | Check if any textbox has focus |
| `gmui_get_focused_textbox_id()` | Get ID of focused textbox |
| `gmui_clear_textbox_focus()` | Remove focus from textbox |

## 🎨 Styling Reference

The style system is highly customizable through `global.gmui.style`:

```gml
var style = global.gmui.style;

// Colors
style.background_color = make_color_rgb(30, 30, 30);
style.text_color = make_color_rgb(220, 220, 220);
style.button_bg_color = make_color_rgb(70, 70, 70);
style.button_hover_bg_color = make_color_rgb(90, 90, 90);

// Sizing
style.window_padding = [8, 8];
style.item_spacing = [8, 4];
style.button_padding = [8, 4];
style.button_min_size = [80, 24];

// Borders and rounding
style.window_rounding = 0;
style.button_rounding = 4;
style.window_border_size = 1;
style.button_border_size = 1;
```

## 🔄 Event Flow

Proper GMUI usage follows this sequence:

```gml
// CREATE EVENT
gmui_init();

// STEP EVENT  
gmui_update();

// Create modals (optional)
gmui_add_modal("my_modal", function(window) {
    // Modal content
});

// Create windows
if (gmui_begin("Main Window", 100, 100, 400, 300)) {
    // UI elements
    gmui_end();
}

// DRAW GUI EVENT
gmui_render();
```

## 🚀 Complete Example

Here's a comprehensive example showing multiple features:

```gml
// CREATE EVENT
gmui_init();

// State variables
static tab_index = 0;
static player_name = "";
static player_level = 1;
static player_color = gmui_make_color_rgba(255, 100, 100, 255);
static settings_open = true;

// STEP EVENT
gmui_update();

// Main application window
if (gmui_begin("Character Editor", 50, 50, 600, 400, 
    gmui_window_flags.AUTO_VSCROLL | gmui_window_flags.SCROLL_WITH_MOUSE_WHEEL)) {
    
    // Tab bar
    var tabs = ["Basic", "Appearance", "Skills", "Inventory"];
    for (var i = 0; i < array_length(tabs); i++) {
        if (gmui_selectable(tabs[i], tab_index == i)) {
            tab_index = i;
        }
        if (i < array_length(tabs) - 1) gmui_same_line();
    }
    gmui_separator();
    
    // Tab content
    switch (tab_index) {
        case 0: // Basic
            player_name = gmui_textbox(player_name, "Enter character name");
            player_level = gmui_input_int(player_level, 1, 1, 100);
            gmui_label_text("Experience", "0 / 1000");
            break;
            
        case 1: // Appearance
            player_color = gmui_color_edit_4("Hair Color", player_color);
            gmui_slider("Height", 1.75, 1.0, 2.5);
            gmui_slider("Weight", 70, 40, 150);
            break;
            
        case 2: // Skills
            var skills = ["Strength", "Dexterity", "Intelligence", "Wisdom"];
            for (var i = 0; i < array_length(skills); i++) {
                gmui_label_text(skills[i], "10");
                gmui_same_line();
                if (gmui_button("+##" + string(i))) {
                    // Increase skill
                }
                gmui_same_line();
                if (gmui_button("-##" + string(i))) {
                    // Decrease skill
                }
            }
            break;
    }
    
    gmui_end();
}

// Settings window (always visible)
if (gmui_begin("Settings", 700, 50, 250, 200, gmui_window_flags.NO_RESIZE)) {
    var settings = gmui_collapsing_header("Graphics", settings_open);
    settings_open = settings[0];
    if (settings_open) {
        gmui_checkbox("VSync", true);
        gmui_checkbox("Fullscreen", false);
        gmui_slider("Brightness", 0.8, 0.0, 1.0);
        gmui_collapsing_header_end();
    }
    gmui_end();
}

// DRAW GUI EVENT
gmui_render();
```

## 🛠️ Troubleshooting

### Common Issues

**UI not appearing?**
- Make sure to call `gmui_init()` in create event
- Call `gmui_update()` in step event and `gmui_render()` in draw GUI event
- Check that windows are created between `gmui_begin()` and `gmui_end()`

**Input not working?**
- Verify `gmui_update()` is called before any UI creation
- Check that windows are active and not behind other windows

**Performance issues?**
- Use scrolling only when necessary
- Avoid creating excessive hidden UI elements
- Use `gmui_window_flags.NO_BACKGROUND` for simple overlays

## 📄 License

MIT License - feel free to use in personal and commercial projects.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues for bugs and feature requests.

## 📞 Support

If you encounter any issues or have questions:
1. Check this documentation
2. Look at the example code provided
3. Open an issue on GitHub

---

**GMUI** - Powering beautiful interfaces in GameMaker projects everywhere! 🎮
