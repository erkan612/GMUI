# GMUI - GameMaker ImGui-like UI Library

A comprehensive, single-file ImGui-inspired UI library for GameMaker Studio 2.3+. GMUI provides a complete immediate-mode GUI system with windows, buttons, sliders, text inputs, color pickers, tree views, and much more.

## Features

- 🪟 **Window Management**: Draggable, resizable windows with title bars
- 🎨 **Rich Widget Set**: Buttons, sliders, checkboxes, textboxes, color pickers, tree views, and more
- ⌨️ **Advanced Input**: Full keyboard support for textboxes with selection, copy/paste, and navigation
- 🎯 **Immediate Mode**: Simple, intuitive API that feels natural to use
- 🎮 **GameMaker Native**: Built specifically for GML with no external dependencies
- 🎨 **Customizable**: Extensive styling system with colors, sizes, and spacing
- 📱 **Responsive**: Auto-layout with scrollbars and flexible sizing
- 🔧 **Extensible**: Modular architecture for easy customization

## Installation

```gml
// Simply include the main GMUI file in your project
#include "GMUI/gmui_main.gml"
```

## Quick Start

```gml
// Create Event
gmui_init();

// Step Event  
gmui_update();

// Draw Event
gmui_render();

// Example usage in any object or script
if (gmui_begin("My Window", 100, 100, 400, 300)) {
    gmui_text("Hello GMUI!");
    if (gmui_button("Click Me")) {
        show_debug_message("Button clicked!");
    }
    gmui_end();
}
```

## Core Concepts

### Immediate Mode Design

GMUI uses immediate mode, meaning you describe your UI every frame. This makes the API simple and intuitive:

```gml
// UI is declared directly in your draw logic
if (gmui_button("Action")) {
    // Handle click immediately
    perform_action();
}
```

### Window System

Windows are the main containers for your UI:

```gml
// Create a window
if (gmui_begin("Settings", 50, 50, 300, 400)) {
    // UI elements go here
    gmui_text("Window content");
    gmui_end();
}

// Windows with flags for customization
var flags = gmui_window_flags.NO_RESIZE | gmui_window_flags.ALWAYS_AUTO_RESIZE;
if (gmui_begin("Toolbox", 400, 100, 200, 0, flags)) {
    gmui_text("Auto-resizing window");
    gmui_end();
}
```

## API Reference

### Core Functions

```gml
// Initialization
gmui_init()           // Initialize the UI system
gmui_update()         // Update input and state (call in step event)
gmui_render()         // Render all UI (call in draw event)
gmui_cleanup()        // Clean up resources

// Window management
gmui_begin(name, x, y, width, height, flags)  // Start a window
gmui_end()            // End a window
```

### Basic Elements

```gml
// Text
gmui_text("Hello World")                    // Regular text
gmui_text_disabled("Disabled text")         // Grayed out text
gmui_label_text("FPS", string(fps))         // Label with value

// Buttons
gmui_button("Standard")                     // Standard button
gmui_button_small("Small")                  // Small button
gmui_button_large("Large")                  // Large button  
gmui_button_disabled("Disabled")            // Non-interactive button

// Layout
gmui_same_line()                           // Place next element on same line
gmui_new_line()                            // Move to next line
gmui_separator()                           // Horizontal separator
gmui_dummy(width, height)                  // Empty space
```

### Form Elements

```gml
// Checkboxes
var checked = gmui_checkbox("Enable Feature", checked)

// Sliders  
var value = gmui_slider("Volume", value, 0, 100)

// Text Input
var text = gmui_textbox(text, "Enter text...")

// Numeric Input
var number = gmui_input_float(number, 0.1, 0, 10)
var integer = gmui_input_int(integer, 1, 0, 100)

// Selectables
var selected = gmui_selectable("Option 1", selected)
```

### Advanced Elements

```gml
// Tree Views
if (gmui_tree_node_begin("Category", is_open)) {
    gmui_tree_leaf("Item 1", selected)
    gmui_tree_leaf("Item 2", selected)
    gmui_tree_node_end()
}

// Collapsible Headers
var [is_open, clicked] = gmui_collapsing_header("Settings", is_open)
if (is_open) {
    gmui_text("Expanded content")
    gmui_collapsing_header_end()
}

// Color Pickers
var color = gmui_color_edit_4("Background", color)
```

## Complete Examples

### Settings Window

```gml
// Create Event
gmui_init();

// Step Event
gmui_update();

// Draw Event
gmui_render();

if (gmui_begin("Game Settings", 20, 20, 350, 400)) {
    gmui_text("Graphics Settings");
    gmui_separator();
    
    // Checkboxes
    global.fullscreen = gmui_checkbox("Fullscreen", global.fullscreen);
    global.vsync = gmui_checkbox("VSync", global.vsync);
    
    gmui_separator();
    gmui_text("Audio Settings");
    
    // Sliders
    global.master_volume = gmui_slider("Master Volume", global.master_volume, 0, 100);
    global.music_volume = gmui_slider("Music Volume", global.music_volume, 0, 100);
    global.sfx_volume = gmui_slider("SFX Volume", global.sfx_volume, 0, 100);
    
    gmui_separator();
    gmui_text("Gameplay");
    
    // Input fields
    global.player_name = gmui_textbox(global.player_name, "Enter name");
    global.game_speed = gmui_input_float(global.game_speed, 0.1, 0.5, 3.0);
    
    gmui_separator();
    
    // Action buttons
    if (gmui_button("Apply Settings")) {
        apply_settings();
    }
    gmui_same_line();
    if (gmui_button("Reset to Defaults")) {
        reset_settings();
    }
    
    gmui_end();
}
```

### File Browser with Tree View

```gml
if (gmui_begin("File Browser", 400, 100, 300, 400)) {
    gmui_tree_node_reset(); // Reset tree depth
    
    if (gmui_tree_node_begin("Project", project_open)) {
        if (gmui_tree_node_begin("Sprites", sprites_open)) {
            if (gmui_tree_leaf("spr_player", selected_file == "spr_player")) {
                selected_file = "spr_player";
            }
            if (gmui_tree_leaf("spr_enemy", selected_file == "spr_enemy")) {
                selected_file = "spr_enemy";
            }
            gmui_tree_node_end();
        }
        
        if (gmui_tree_node_begin("Scripts", scripts_open)) {
            if (gmui_tree_leaf("obj_player", selected_file == "obj_player")) {
                selected_file = "obj_player";
            }
            gmui_tree_node_end();
        }
        
        gmui_tree_node_end();
    }
    
    gmui_separator();
    gmui_text("Selected: " + selected_file);
    
    gmui_end();
}
```

### Color Picker Tool

```gml
var color_picker_open = false;
var current_color = c_white;

if (gmui_begin("Color Tool", 500, 200, 320, 200)) {
    // Color preview and picker button
    current_color = gmui_color_edit_4("Color", current_color);
    
    gmui_separator();
    
    // RGB sliders
    var rgb = gmui_color_rgba_to_array(current_color);
    gmui_text("RGB Channels:");
    rgb[0] = gmui_slider("Red", rgb[0], 0, 255);
    rgb[1] = gmui_slider("Green", rgb[1], 0, 255); 
    rgb[2] = gmui_slider("Blue", rgb[2], 0, 255);
    current_color = gmui_array_to_color_rgba(rgb);
    
    gmui_separator();
    
    // Color presets
    gmui_text("Presets:");
    if (gmui_color_button(c_red, 30)) { current_color = c_red; }
    gmui_same_line();
    if (gmui_color_button(c_green, 30)) { current_color = c_green; }
    gmui_same_line();
    if (gmui_color_button(c_blue, 30)) { current_color = c_blue; }
    gmui_same_line();
    if (gmui_color_button(c_yellow, 30)) { current_color = c_yellow; }
    
    gmui_end();
}
```

## Window Flags

GMUI provides extensive window customization through flags:

```gml
enum gmui_window_flags {
    NONE = 0,
    NO_TITLE_BAR = 1 << 0,           // No title bar
    NO_RESIZE = 1 << 1,              // Cannot be resized
    NO_MOVE = 1 << 2,                // Cannot be moved
    NO_SCROLLBAR = 1 << 3,           // No scrollbars
    NO_COLLAPSE = 1 << 4,            // Cannot be collapsed
    ALWAYS_AUTO_RESIZE = 1 << 5,     // Auto-resize to content
    NO_BACKGROUND = 1 << 6,          // No background
    VERTICAL_SCROLL = 1 << 20,       // Enable vertical scrolling
    HORIZONTAL_SCROLL = 1 << 21,     // Enable horizontal scrolling
    AUTO_SCROLL = 1 << 22,           // Auto-show scrollbars when needed
    // ... and many more
}

// Usage example
var flags = gmui_window_flags.NO_RESIZE | gmui_window_flags.NO_COLLAPSE;
if (gmui_begin("Fixed Window", 100, 100, 200, 150, flags)) {
    gmui_text("This window cannot be resized or collapsed");
    gmui_end();
}
```

## Styling and Customization

### Global Style

```gml
// Access and modify the global style
var style = global.gmui.style;

// Modify colors
style.background_color = make_color_rgb(40, 40, 60);
style.text_color = make_color_rgb(240, 240, 240);
style.button_bg_color = make_color_rgb(80, 80, 120);

// Modify sizes and spacing
style.window_padding = [12, 12];
style.item_spacing = [10, 6];
style.button_rounding = 8;

// Modify specific element styles
style.slider_track_fill_color = make_color_rgb(100, 150, 255);
style.checkbox_check_color = make_color_rgb(0, 200, 100);
```

### Custom Theme Example

```gml
function setup_dark_theme() {
    var style = global.gmui.style;
    
    // Dark background colors
    style.background_color = make_color_rgb(30, 30, 40);
    style.button_bg_color = make_color_rgb(60, 60, 80);
    style.textbox_bg_color = make_color_rgb(40, 40, 50);
    
    // Accent colors
    style.button_hover_bg_color = make_color_rgb(80, 80, 120);
    style.slider_track_fill_color = make_color_rgb(100, 150, 255);
    style.selectable_selected_bg_color = make_color_rgb(70, 100, 200);
    
    // Text colors
    style.text_color = make_color_rgb(220, 220, 220);
    style.text_disabled_color = make_color_rgb(120, 120, 120);
    
    // Rounding
    style.window_rounding = 8;
    style.button_rounding = 6;
    style.textbox_rounding = 4;
}

// Call in create event after gmui_init()
setup_dark_theme();
```

## Advanced Features

### Text Input with Validation

```gml
// Numeric-only textbox with validation
function validated_float_input(value, min_val, max_val) {
    var new_value = gmui_input_float(value, 0.1, min_val, max_val, 100, "Enter number");
    
    // Additional validation
    if (global.gmui.active_textbox == undefined && (new_value < min_val || new_value > max_val)) {
        new_value = clamp(new_value, min_val, max_val);
    }
    
    return new_value;
}

// Usage
health = validated_float_input(health, 0, 100);
```

### Dynamic UI Layout

```gml
// Responsive layout that adapts to window size
if (gmui_begin("Adaptive Layout", 50, 50, 400, -1)) {
    var window_width = global.gmui.current_window.width;
    var button_width = (window_width - global.gmui.style.window_padding[0] * 2 - 
                       global.gmui.style.item_spacing[0] * 2) / 3;
    
    // Three equal-width buttons
    if (gmui_button("Left", button_width)) { /* action */ }
    gmui_same_line();
    if (gmui_button("Center", button_width)) { /* action */ }
    gmui_same_line(); 
    if (gmui_button("Right", button_width)) { /* action */ }
    
    gmui_end();
}
```

### Custom Composite Widgets

```gml
// Create a labeled slider widget
function labeled_slider(label, value, min_val, max_val, format = "{0}") {
    gmui_text(label + ":");
    gmui_same_line();
    var new_value = gmui_slider("", value, min_val, max_val, 150);
    gmui_same_line();
    gmui_text(string_format(format, new_value));
    return new_value;
}

// Usage
volume = labeled_slider("Volume", volume, 0, 100, "{0}%");
brightness = labeled_slider("Brightness", brightness, 0, 1, "{0:.2f}");
```

## Performance Tips

1. **Minimize Window Count**: Use fewer windows with more content rather than many small windows
2. **Use Flags Wisely**: `ALWAYS_AUTO_RESIZE` can cause layout recalculation every frame
3. **Batch Updates**: Update game state based on UI changes in step event, not draw event
4. **Reuse Windows**: Keep window references and reuse them when possible

```gml
// Good: Single window with sections
if (gmui_begin("Game UI", 0, 0, 200, room_height)) {
    draw_player_stats();
    draw_inventory();
    draw_quest_log();
    gmui_end();
}

// Avoid: Many small windows
if (gmui_begin("Stats", 0, 0, 200, 100)) { /* ... */ gmui_end(); }
if (gmui_begin("Inventory", 0, 110, 200, 150)) { /* ... */ gmui_end(); }
if (gmui_begin("Quests", 0, 270, 200, 150)) { /* ... */ gmui_end(); }
```

## Common Patterns

### Modal Dialogs

```gml
// Simple message box implementation
function message_box(title, message) {
    var result = false;
    var flags = gmui_window_flags.NO_RESIZE | gmui_window_flags.NO_MOVE;
    
    // Center the dialog
    var width = 300, height = 150;
    var x = (room_width - width) / 2;
    var y = (room_height - height) / 2;
    
    if (gmui_begin(title, x, y, width, height, flags)) {
        gmui_text(message);
        gmui_new_line();
        gmui_new_line();
        
        if (gmui_button("OK", 80)) {
            result = true;
            // Close this dialog by not calling gmui_begin next frame
        }
        gmui_same_line();
        gmui_dummy(20, 0);
        gmui_same_line();
        if (gmui_button("Cancel", 80)) {
            result = false;
            // Close dialog
        }
        
        gmui_end();
    }
    
    return result;
}
```

### Tooltips

```gml
// Simple tooltip implementation
function show_tooltip(text) {
    if (global.gmui.is_hovering_element && global.gmui.mouse_pos) {
        var mx = global.gmui.mouse_pos[0] + 10;
        var my = global.gmui.mouse_pos[1] + 10;
        
        if (gmui_begin("##tooltip", mx, my, 200, -1, gmui_window_flags.NO_TITLE_BAR | 
                       gmui_window_flags.NO_RESIZE | gmui_window_flags.NO_MOVE)) {
            gmui_text(text);
            gmui_end();
        }
    }
}

// Usage
gmui_text("Hover me");
if (gmui_is_mouse_over_window(global.gmui.current_window) && 
    gmui_is_point_in_rect(/* check bounds */)) {
    show_tooltip("This is a helpful tooltip!");
}
```

## Troubleshooting

### Common Issues

1. **UI not appearing**: Make sure to call `gmui_render()` in the draw event
2. **Input not working**: Call `gmui_update()` in the step event
3. **Memory leaks**: Call `gmui_cleanup()` when switching rooms or ending the game
4. **Performance issues**: Reduce window count and avoid `ALWAYS_AUTO_RESIZE` on complex windows

### Debugging Tips

```gml
// Add debug information to your UI
if (gmui_begin("Debug Info", room_width - 250, 10, 240, 120)) {
    gmui_label_text("FPS", string(fps));
    gmui_label_text("Mouse", string(global.gmui.mouse_pos[0]) + ", " + string(global.gmui.mouse_pos[1]));
    gmui_label_text("Windows", string(ds_list_size(global.gmui.windows)));
    gmui_label_text("Hovering", string(global.gmui.is_hovering_element));
    gmui_end();
}
```

## License

GMUI is provided under the MIT License. Feel free to use, modify, and distribute in your projects.

## Contributing

GMUI is designed to be extensible. To add new widgets:

1. Add element functions in the appropriate category file
2. Update the style structure for new styling options  
3. Add drawing commands to the render system
4. Update input handling if needed

## Support

For bugs, feature requests, or contributions, please open an issue on the GitHub repository.

---

**GMUI** - Bringing professional UI tools to GameMaker developers. 🚀
