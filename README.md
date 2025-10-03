# GMUI - GameMaker UI Library

A lightweight ImGui-style immediate mode UI library for GameMaker. Single file implementation with full keyboard/mouse support and customizable themes.

![GMUI Demo](https://img.shields.io/badge/GameMaker-2022P+-blue) ![License](https://img.shields.io/badge/License-MIT-green)

## Features

- 🪟 **Window Management**: Draggable, resizable windows with title bars
- 🎨 **Multiple Elements**: Buttons, checkboxes, sliders, textboxes, labels, separators
- ⌨️ **Full Keyboard Support**: Textboxes with standard shortcuts (Ctrl+C, Ctrl+V, etc.)
- 🎯 **Mouse Interactions**: Click, drag, hover states for all elements
- 🌈 **Theme System**: Multiple built-in color presets + customizable styles
- 📱 **Flexible Layout**: Automatic positioning with manual control options
- 🚀 **Single File**: Easy to integrate into any GameMaker project

## Quick Start

### Installation

1. Copy the `gmui_scripts.gml` file into your project
2. Call initialization in your game's create event:

```gml
// In Create Event
gmui_init();
```

### Basic Usage

```gml
// In Step Event
gmui_update_input();

if (gmui_begin("My Window", 100, 100, 400, 300)) {
    gmui_text("Hello GMUI!");
    
    if (gmui_button("Click Me")) {
        show_debug_message("Button clicked!");
    }
    
    my_checkbox = gmui_checkbox("Enable Feature", my_checkbox);
    my_value = gmui_slider("Volume", my_value, 0, 100);
    
    var text_result = gmui_textbox(my_text, "Enter text...");
    my_text = text_result[0];
    if (text_result[1]) {
        show_debug_message("Text changed: " + my_text);
    }
}
gmui_end();

// In Draw Event
gmui_render();
```

## API Reference

### Core Functions

| Function | Description |
|----------|-------------|
| `gmui_init()` | Initialize the UI system |
| `gmui_update_input()` | Update input state (call in step) |
| `gmui_render()` | Render all UI (call in draw) |
| `gmui_cleanup()` | Clean up resources |

### Window Management

```gml
// Create a window
if (gmui_begin(name, x, y, width, height, flags)) {
    // UI elements here
}
gmui_end();

// Window flags
gmui_window_flags.NO_TITLE_BAR
gmui_window_flags.NO_RESIZE
gmui_window_flags.NO_MOVE
gmui_window_flags.NO_CLOSE
// ... and more
```

### UI Elements

#### Basic Elements
- `gmui_text(text)` - Display text
- `gmui_text_disabled(text)` - Display disabled text
- `gmui_label_text(label, text)` - Label with value
- `gmui_separator()` - Horizontal separator
- `gmui_same_line()` - Keep next element on same line
- `gmui_new_line()` - Move to next line
- `gmui_dummy(width, height)` - Empty space

#### Interactive Elements
- `gmui_button(label)` - Basic button
- `gmui_button_small(label)` - Small button
- `gmui_button_large(label)` - Large button
- `gmui_button_width(label, width)` - Fixed width button
- `gmui_button_disabled(label)` - Disabled button

- `gmui_checkbox(label, value)` - Checkbox with label
- `gmui_checkbox_box(value)` - Checkbox without label
- `gmui_checkbox_disabled(label, value)` - Disabled checkbox

- `gmui_slider(label, value, min, max)` - Slider control
- `gmui_slider_disabled(label, value, min, max)` - Disabled slider

- `gmui_textbox(text, placeholder, width)` - Single-line text input
- `gmui_textbox_disabled(text, placeholder, width)` - Disabled textbox

### Textbox Features

GMUI textboxes support standard keyboard shortcuts:

- **Arrow Keys**: Navigate cursor
- **Shift + Arrows**: Select text
- **Ctrl+A**: Select all
- **Ctrl+C**: Copy selection
- **Ctrl+X**: Cut selection  
- **Ctrl+V**: Paste
- **Backspace/Delete**: Remove text
- **Home/End**: Jump to start/end

#### Textbox Focus Management
```gml
// Check if any textbox is focused
if (gmui_is_any_textbox_focused()) {
    // Do something...
}

// Check specific textbox focus
var textbox_id = gmui_generate_textbox_id("Window", "username");
if (gmui_is_textbox_focused(textbox_id)) {
    // Username textbox is focused
}

// Clear focus programmatically
gmui_clear_textbox_focus();
```

### Layout Control

```gml
// Manual positioning
gmui_set_window_position("Window", x, y);
gmui_set_window_size("Window", width, height);
gmui_reset_window("Window"); // Reset to initial size

// Inline layout
gmui_button("First"); gmui_same_line();
gmui_button("Second"); gmui_same_line(); 
gmui_button("Third");
```

### Themes

```gml
// Apply built-in theme
gmui_set_preset("dark");      // Dark theme (default)
gmui_set_preset("light");     // Light theme
gmui_set_preset("cyberpunk"); // Cyberpunk colors
gmui_set_preset("pastel");    // Pastel colors
gmui_set_preset("forest");    // Green forest theme
gmui_set_preset("ocean");     // Blue ocean theme  
gmui_set_preset("sunset");    // Orange/red theme
gmui_set_preset("terminal");  // Green terminal theme

// Customize individual colors
global.gmui.style.background_color = make_color_rgb(255, 0, 0);
global.gmui.style.text_color = make_color_rgb(255, 255, 255);
// ... etc
```

## Complete Example

```gml
// Create Event
gmui_init();
gmui_set_preset("dark");

my_checkbox = false;
my_slider = 50;
my_text = "";

// Step Event  
gmui_update_input();

if (gmui_begin("Control Panel", 50, 50, 350, 400)) {
    gmui_text("Application Settings");
    gmui_separator();
    
    gmui_text("General:");
    my_checkbox = gmui_checkbox("Enable Sound", my_checkbox);
    my_slider = gmui_slider("Volume", my_slider, 0, 100);
    
    gmui_separator();
    gmui_text("User Profile:");
    
    var text_result = gmui_textbox(my_text, "Enter your name", 200);
    my_text = text_result[0];
    
    gmui_button_small("Save"); gmui_same_line();
    gmui_button_small("Load"); gmui_same_line();
    gmui_button_small("Reset");
    
    if (gmui_button_large("Apply Changes")) {
        show_debug_message("Settings applied!");
    }
}
gmui_end();

// Draw Event
gmui_render();
```

## Advanced Usage

### Custom Window Flags
```gml
var flags = gmui_window_flags.NO_RESIZE | gmui_window_flags.NO_MOVE;
if (gmui_begin("Fixed Window", 100, 100, 300, 200, flags)) {
    gmui_text("This window cannot be moved or resized");
}
gmui_end();
```

### Manual Textbox IDs
```gml
var username_id = gmui_generate_textbox_id("Login", "username");
var result = gmui_textbox(username, "Username", 150, username_id);
username = result[0];

if (gmui_is_textbox_focused(username_id)) {
    gmui_text_disabled("P↳ Enter your username");
}
```

## Style Customization

All style properties are accessible through `global.gmui.style`:

```gml
// Window styles
global.gmui.style.background_color
global.gmui.style.border_color
global.gmui.style.window_padding
global.gmui.style.window_rounding

// Button styles  
global.gmui.style.button_bg_color
global.gmui.style.button_hover_bg_color
global.gmui.style.button_text_color
global.gmui.style.button_padding

// Textbox styles
global.gmui.style.textbox_bg_color
global.gmui.style.textbox_focused_border_color
global.gmui.style.textbox_cursor_color

// And many more...
```

## Requirements

- GameMaker 2022.1 or later
- No extensions required

## License

MIT License - feel free to use in personal and commercial projects.

## Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues for bugs and feature requests.

---

**GMUI** - Making UI development in GameMaker simple and powerful! 🎮
