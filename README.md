# GMUI - ImGui-like UI Library for GameMaker
*A lightweight, immediate-mode GUI library for GameMaker*

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-GameMaker-green.svg)]()
[![Version](https://img.shields.io/badge/version-1.0.0-orange.svg)]()

---

## Table of Contents
- [Introduction](#introduction)
- [Setup & Basic Usage](#setup-and-basic-usage)
- [Core Concepts](#core-concepts)
- [UI Elements](#ui-elements)
- [Layout System](#layout-system)
- [Advanced Features](#advanced-features)
- [API Reference](#api-reference)
- [Best Practices](#best-practices)
- [Performance Tips](#performance-tips)
- [Examples](#step-by-step-examples)
- [Examples: Simple Button](#simple-button)
- [Examples: Settings Panel](#settings-panel)
- [Examples: Simple Contact Form](#simple-contact-form)
- [Examples: Color Picker](#color-picker)
- [Stylizing](#stylizing)
- [Notes](#notes)

---

## Introduction
**GMUI** is a lightweight **ImGui-inspired UI library for GameMaker** that provides an **immediate-mode interface** for creating dynamic user interfaces.  

Features:
- Immediate-mode architecture (define UI each frame)
- Built-in input handling and state management
- Extensive styling options
- Wide variety of UI components (buttons, checkboxes, sliders, textboxes, etc.)
- Window management with dragging and resizing
- Scrollable content areas
- Color picker with HSV/RGB support
- Treeview and collapsible headers

---

## Setup and Basic Usage

```gml
// Initialization (call once in Create Event)
gmui_init();

// Update input (call in Step Event)
gmui_update();

// UI Creation and Rendering (call in Draw Event)
if (gmui_begin("My Window", 100, 100, 400, 300)) {
    gmui_text("Hello World!");
    if (gmui_button("Click Me")) {
        // Handle button click
    }
    gmui_end();
}
gmui_render();

// Cleanup (call when done)
gmui_cleanup();
```

---

## Core Concepts

**Window Flags**
```gml
enum gmui_window_flags {
    NONE = 0,
    NO_TITLE_BAR = 1 << 0,
    NO_RESIZE = 1 << 1,
    NO_MOVE = 1 << 2,
    NO_SCROLLBAR = 1 << 3,
    NO_COLLAPSE = 1 << 4,
    ALWAYS_AUTO_RESIZE = 1 << 5,
    NO_BACKGROUND = 1 << 6,
    VERTICAL_SCROLL = 1 << 20,
    HORIZONTAL_SCROLL = 1 << 21,
    AUTO_SCROLL = 1 << 22,
    SCROLL_WITH_MOUSE_WHEEL = 1 << 24
};
```

**Element States**
- Elements automatically handle hover, active, and disabled states
- Input is processed automatically through `gmui_update()`
- Focus management for textboxes and interactive elements

---

## UI Elements

**Button**
```gml
if (gmui_button("Click Me")) {
    show_debug_message("Button clicked!");
}

// Disabled button
gmui_button_disabled("Can't Click");

// Small and large variants
gmui_button_small("Small");
gmui_button_large("Large");

// Custom size
gmui_button_width("Wide Button", 200);
```

**Checkbox**
```gml
var checked = true;
checked = gmui_checkbox("Enable Feature", checked);

// Checkbox without label
checked = gmui_checkbox_box(checked);

// Disabled checkbox
gmui_checkbox_disabled("Disabled Option", checked);
```

**Slider**
```gml
var value = 50;
value = gmui_slider("Volume", value, 0, 100);

// Custom width
value = gmui_slider("Brightness", value, 0, 100, 200);

// Disabled slider
gmui_slider_disabled("Locked Setting", value, 0, 100);
```

**Textbox**
```gml
var text = "Hello";
text = gmui_textbox(text, "Enter text...");

// Check if any textbox is focused
if (gmui_is_any_textbox_focused()) {
    // Handle global text input
}

// Clear focus programmatically
gmui_clear_textbox_focus();
```

**Numeric Input with Drag**
```gml
var float_value = 1.5;
float_value = gmui_input_float(float_value, 0.1, 0, 10, 120, "Enter value");

var int_value = 5;
int_value = gmui_input_int(int_value, 1, 0, 100, 120, "Enter integer");
```

**Selectable**
```gml
var selected = false;
if (gmui_selectable("Selectable Item", selected)) {
    selected = !selected;
}

// Small and large variants
gmui_selectable_small("Small Item", false);
gmui_selectable_large("Large Item", false);

// Custom size
gmui_selectable_width("Wide Item", false, 200);
```

**Text Elements**
```gml
gmui_text("Normal text");
gmui_text_disabled("Disabled text");
gmui_label_text("FPS", string(fps));
```

**Separator and Spacing**
```gml
gmui_separator();
gmui_dummy(20, 20); // Empty space
gmui_same_line(); // Place next element on same line
```

---

## Advanced Controls

**Color Picker**
```gml
var color = make_color_rgb(255, 0, 0);
color = gmui_color_edit_4("Color", color);

// Color button (opens picker on click)
if (gmui_color_button(color)) {
    // Color picker will open automatically
}
```

**Treeview**
```gml
if (gmui_tree_node_begin("Parent Node", false)) {
    if (gmui_tree_leaf("Child Item 1")) {
        show_debug_message("Child 1 clicked");
    }
    if (gmui_tree_leaf("Child Item 2")) {
        show_debug_message("Child 2 clicked");
    }
    gmui_tree_node_end();
}
```

**Collapsible Headers**
```gml
var is_open = true;
var result = gmui_collapsing_header("Settings", is_open);
is_open = result[0];
if (result[1]) {
    // Header was clicked
}

if (is_open) {
    gmui_text("Settings content here");
    // ... more elements
}
gmui_collapsing_header_end();
```

---

## Layout System

**Window Management**
```gml
// Create window with flags
if (gmui_begin("My Window", 100, 100, 400, 300, 
    gmui_window_flags.NO_RESIZE | gmui_window_flags.VERTICAL_SCROLL)) {
    
    // Window content
    gmui_text("Scrollable content");
    // ... more elements
    
    gmui_end();
}
```

**Manual Layout Control**
```gml
// Get current cursor position
var cursor = gmui_get_cursor();
show_debug_message("Current position: " + string(cursor[0]) + ", " + string(cursor[1]));

// Set cursor position manually
gmui_set_cursor(50, 100);

// Force new line
gmui_new_line();
```

**Scrolling**
```gml
// Create window with scrolling
if (gmui_begin("Scrollable Window", 100, 100, 300, 200, 
    gmui_window_flags.VERTICAL_SCROLL | gmui_window_flags.SCROLL_WITH_MOUSE_WHEEL)) {
    
    // Add enough content to require scrolling
    for (var i = 0; i < 20; i++) {
        gmui_text("Item " + string(i));
    }
    
    gmui_end();
}
```

---

## Advanced Features

**Custom Styling**

```gml
// Access and modify global styles
gmui_get().style.button_bg_color = make_color_rgb(70, 70, 70);
gmui_get().style.button_hover_bg_color = make_color_rgb(90, 90, 90);
gmui_get().style.button_active_bg_color = make_color_rgb(50, 50, 50);
gmui_get().style.text_color = make_color_rgb(220, 220, 220);

// Modify window styles
gmui_get().style.window_padding = [8, 8];
gmui_get().style.item_spacing = [8, 4];
gmui_get().style.window_rounding = 4;
```

**Scrollbar Customization**
```gml
// Customize scrollbar appearance
gmui_get().style.scrollbar_width = 12;
gmui_get().style.scrollbar_background_color = make_color_rgb(40, 40, 40);
gmui_get().style.scrollbar_anchor_color = make_color_rgb(100, 100, 100);
gmui_get().style.scrollbar_anchor_hover_color = make_color_rgb(120, 120, 120);
```

**Shader Support**
```gml
// Color picker uses shaders for performance
// Make sure these shaders are loaded:
// - shdHue (hue gradient)
// - shdSaturationBrightness (saturation/brightness area)
// - shdAlphaGradient (alpha gradient)
// - shdCheckerboard (transparency pattern)
```

---

## API Reference

**Core Functions**
- `gmui_init()` - Initialize the UI system
- `gmui_update()` - Update input and state (call in Step Event)
- `gmui_render()` - Render all UI (call in Draw Event)
- `gmui_cleanup()` - Clean up resources

**Window Management**
- `gmui_begin(name, x, y, width, height, flags)` - Start a window
- `gmui_end()` - End a window
- `gmui_set_window_position(name, x, y)` - Move window
- `gmui_set_window_size(name, width, height)` - Resize window
- `gmui_reset_window(name)` - Reset to initial size/position

**Input Functions**
- `gmui_is_any_textbox_focused()` - Check if any textbox has focus
- `gmui_get_focused_textbox_id()` - Get focused textbox ID
- `gmui_clear_textbox_focus()` - Remove focus from textboxes

**Layout Functions**
- `gmui_same_line()` - Place next element on same line
- `gmui_new_line()` - Move to next line
- `gmui_get_cursor()` - Get current cursor position
- `gmui_set_cursor(x, y)` - Set cursor position
- `gmui_dummy(width, height)` - Add empty space

**Scissor Testing**
- `gmui_begin_scissor(x, y, w, h)` - Begin clipping region
- `gmui_end_scissor()` - End clipping region
- `gmui_scissor_group(x, y, w, h, func)` - Execute function with scissor

---

## Best Practices
1. Always call `gmui_init()` once at startup and `gmui_cleanup()` when done
2. Call `gmui_update()` in Step Event and `gmui_render()` in Draw Event
3. Use window flags to control behavior (resizing, scrolling, etc.)
4. Handle textbox focus properly using the provided functions
5. Use scrolling for content that exceeds window size
6. Group related elements together logically
7. Use appropriate element variants (small/large) for your layout

---

## Performance Tips
- Use `NO_BACKGROUND` flag for windows if you don't need the background
- Avoid creating extremely large windows with many elements
- Use scrolling instead of auto-resize for dynamic content
- Limit the number of active windows when possible
- Use `gmui_scissor_group()` to clip complex content
- Consider using `NO_TITLE_BAR` for simple overlays

## Step by Step Examples

# Simple Button

We start by initializing our UI system in the Create Event:
```gml
gmui_init();
```

In the Step Event, we update input:
```gml
gmui_update();
```

In the Draw Event, we create and render our UI:
```gml
if (gmui_begin("Simple Example", 100, 100, 300, 200)) {
    if (gmui_button("Click Me!")) {
        show_debug_message("Hello World!");
    }
    gmui_end();
}
gmui_render();
```

When done, clean up in the Clean Up Event:
```gml
gmui_cleanup();
```

Here's the complete code:

**Create Event:**
```gml
gmui_init();
```

**Step Event:**
```gml
gmui_update();
```

**Draw Event:**
```gml
if (gmui_begin("Simple Example", 100, 100, 300, 200)) {
    if (gmui_button("Click Me!")) {
        show_debug_message("Hello World!");
    }
    gmui_end();
}
gmui_render();
```

**Clean Up Event:**
```gml
gmui_cleanup();
```

---

# Settings Panel

Let's create a settings panel with various controls:

```gml
// In Create Event
gmui_init();

// Global variables to store settings
global.music_volume = 80;
global.sfx_volume = 60;
global.fullscreen = false;
global.vsync = true;
```

```gml
// In Draw Event
if (gmui_begin("Settings", 50, 50, 350, 400)) {
    
    gmui_text("Audio Settings");
    gmui_separator();
    
    // Music volume slider
    global.music_volume = gmui_slider("Music Volume", global.music_volume, 0, 100, 200);
    
    // SFX volume slider
    global.sfx_volume = gmui_slider("SFX Volume", global.sfx_volume, 0, 100, 200);
    
    gmui_new_line();
    gmui_text("Video Settings");
    gmui_separator();
    
    // Checkboxes for video options
    global.fullscreen = gmui_checkbox("Fullscreen", global.fullscreen);
    global.vsync = gmui_checkbox("VSync", global.vsync);
    
    gmui_new_line();
    gmui_text("Game Settings");
    gmui_separator();
    
    // Input fields for game settings
    var player_name = "Player";
    player_name = gmui_textbox(player_name, "Enter player name");
    
    var sensitivity = 0.5;
    sensitivity = gmui_input_float("Sensitivity", sensitivity, 0.1, 2.0, 0.1, 150);
    
    gmui_new_line();
    
    // Action buttons
    if (gmui_button("Apply Settings")) {
        // Apply settings to game
        window_set_fullscreen(global.fullscreen);
        // ... other setting applications
        show_debug_message("Settings applied!");
    }
    
    gmui_same_line();
    
    if (gmui_button("Reset to Defaults")) {
        global.music_volume = 80;
        global.sfx_volume = 60;
        global.fullscreen = false;
        global.vsync = true;
    }
    
    gmui_end();
}
gmui_render();
```

---

# Simple Contact Form

```gml
// In Draw Event
if (gmui_begin("Contact Form", 100, 50, 400, 350)) {
    
    gmui_text("Please fill out the form below:");
    gmui_separator();
    
    // Name field
    static name = "";
    name = gmui_textbox(name, "Your name");
    
    // Email field
    static email = "";
    email = gmui_textbox(email, "your.email@example.com");
    
    // Subject dropdown (using selectables)
    static subject = "";
    gmui_text("Subject:");
    if (gmui_selectable("General Inquiry", subject == "General Inquiry")) {
        subject = "General Inquiry";
    }
    if (gmui_selectable("Technical Support", subject == "Technical Support")) {
        subject = "Technical Support";
    }
    if (gmui_selectable("Feature Request", subject == "Feature Request")) {
        subject = "Feature Request";
    }
    
    gmui_new_line();
    
    // Message (multi-line)
    static message = "";
    gmui_text("Message:");
    // For multi-line text, you'd need to handle this specially
    // as gmui_textbox doesn't natively support multi-line
    
    gmui_new_line();
    
    // Submit button
    if (gmui_button_large("Send Message")) {
        if (name != "" && email != "" && subject != "" && message != "") {
            show_debug_message("Message sent!");
            show_debug_message("From: " + name);
            show_debug_message("Email: " + email);
            show_debug_message("Subject: " + subject);
            show_debug_message("Message: " + message);
            
            // Clear form
            name = "";
            email = "";
            subject = "";
            message = "";
        } else {
            show_debug_message("Please fill all fields!");
        }
    }
    
    gmui_end();
}
gmui_render();
```

---

# Color Picker

```gml
// In Create Event
gmui_init();

// Global color variable
global.current_color = make_color_rgb(255, 128, 64);
```

```gml
// In Draw Event
if (gmui_begin("Color Picker Demo", 50, 50, 500, 400)) {
    
    gmui_text("Color Customization");
    gmui_separator();
    
    // Color editor
    global.current_color = gmui_color_edit_4("Primary Color", global.current_color);
    
    gmui_new_line();
    gmui_separator();
    gmui_new_line();
    
    // Preview the color
    gmui_text("Color Preview:");
    if (gmui_color_button(global.current_color, 60)) {
        // Color button opens picker on click
    }
    
    gmui_same_line();
    gmui_dummy(20, 0);
    gmui_same_line();
    
    // Show RGB values
    var color_array = gmui_color_rgba_to_array(global.current_color);
    gmui_label_text("R", string(color_array[0]));
    gmui_label_text("G", string(color_array[1]));
    gmui_label_text("B", string(color_array[2]));
    gmui_label_text("A", string(color_array[3]));
    
    gmui_new_line();
    
    // Color presets
    gmui_text("Presets:");
    gmui_same_line();
    
    if (gmui_color_button(make_color_rgb(255, 0, 0), 20)) {
        global.current_color = make_color_rgb(255, 0, 0);
    }
    gmui_same_line();
    
    if (gmui_color_button(make_color_rgb(0, 255, 0), 20)) {
        global.current_color = make_color_rgb(0, 255, 0);
    }
    gmui_same_line();
    
    if (gmui_color_button(make_color_rgb(0, 0, 255), 20)) {
        global.current_color = make_color_rgb(0, 0, 255);
    }
    gmui_same_line();
    
    if (gmui_color_button(make_color_rgb(255, 255, 0), 20)) {
        global.current_color = make_color_rgb(255, 255, 0);
    }
    
    gmui_new_line();
    gmui_separator();
    gmui_new_line();
    
    // Apply color to something
    if (gmui_button("Apply Color")) {
        // Apply the color to your game objects
        show_debug_message("Color applied: " + string(color_array[0]) + 
                          ", " + string(color_array[1]) + 
                          ", " + string(color_array[2]));
    }
    
    gmui_end();
}
gmui_render();
```

---

# Stylizing

GMUI provides extensive styling options through the global style structure:

```gml
// Customize the overall theme
var style = gmui_get().style;

// Window styling
style.background_color = make_color_rgb(45, 45, 48);
style.background_alpha = 255;
style.border_color = make_color_rgb(60, 60, 60);
style.window_padding = [8, 8];
style.window_rounding = 4;

// Text colors
style.text_color = make_color_rgb(220, 220, 220);
style.text_disabled_color = make_color_rgb(128, 128, 128);

// Button styling
style.button_bg_color = make_color_rgb(70, 70, 70);
style.button_hover_bg_color = make_color_rgb(90, 90, 90);
style.button_active_bg_color = make_color_rgb(50, 50, 50);
style.button_text_color = make_color_rgb(220, 220, 220);
style.button_rounding = 4;
style.button_border_size = 1;

// Slider styling
style.slider_track_bg_color = make_color_rgb(70, 70, 70);
style.slider_track_fill_color = make_color_rgb(100, 100, 255);
style.slider_handle_bg_color = make_color_rgb(200, 200, 200);

// Textbox styling
style.textbox_bg_color = make_color_rgb(40, 40, 40);
style.textbox_border_color = make_color_rgb(80, 80, 80);
style.textbox_focused_border_color = make_color_rgb(100, 100, 255);

// Create a dark theme
function setup_dark_theme() {
    var style = gmui_get().style;
    
    // Dark background colors
    style.background_color = make_color_rgb(30, 30, 35);
    style.button_bg_color = make_color_rgb(60, 60, 70);
    style.textbox_bg_color = make_color_rgb(40, 40, 45);
    
    // Accent colors
    style.button_hover_bg_color = make_color_rgb(80, 80, 90);
    style.slider_track_fill_color = make_color_rgb(65, 105, 225);
    style.textbox_focused_border_color = make_color_rgb(65, 105, 225);
}

// Call this after gmui_init()
setup_dark_theme();
```

You can also create custom element styles by modifying individual style properties:

```gml
// Create a custom button style
function create_primary_button_style() {
    var style = gmui_get().style;
    
    // Save original values
    var original_bg = style.button_bg_color;
    var original_hover = style.button_hover_bg_color;
    var original_active = style.button_active_bg_color;
    
    // Set primary colors
    style.button_bg_color = make_color_rgb(0, 120, 215);
    style.button_hover_bg_color = make_color_rgb(0, 140, 235);
    style.button_active_bg_color = make_color_rgb(0, 100, 195);
    
    // Create button with primary style
    if (gmui_button("Primary Action")) {
        // Handle click
    }
    
    // Restore original style
    style.button_bg_color = original_bg;
    style.button_hover_bg_color = original_hover;
    style.button_active_bg_color = original_active;
}

// Usage in your UI
if (gmui_begin("Styled UI", 100, 100, 300, 200)) {
    create_primary_button_style();
    gmui_end();
}
```

---

# Notes

**Performance Considerations:**
- GMUI uses immediate-mode rendering, which recreates the UI every frame
- Complex UIs with many elements may impact performance
- Use scrolling and visibility flags to manage complex interfaces
- Consider using `NO_BACKGROUND` flags for overlay elements

**Input Handling:**
- GMUI automatically handles mouse and keyboard input
- Textboxes support selection, copy/paste, and cursor navigation
- Use `gmui_is_any_textbox_focused()` to check if text input should be blocked

**Window Management:**
- Windows can be dragged and resized (unless disabled with flags)
- Multiple windows are automatically managed with z-ordering
- Window state is preserved between frames

**Shader Requirements:**
- The color picker requires specific shaders to be loaded:
  - `shdHue` - Hue gradient bar
  - `shdSaturationBrightness` - Saturation/brightness area
  - `shdAlphaGradient` - Alpha gradient
  - `shdCheckerboard` - Transparency pattern

**Best Practices:**
- Always call `gmui_init()` before creating any UI
- Call `gmui_update()` in Step Event and `gmui_render()` in Draw Event
- Use appropriate window flags for your use case
- Clean up with `gmui_cleanup()` when done with the UI system
- Test your UI at different resolutions and aspect ratios
