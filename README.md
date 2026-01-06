# GMUI - GameMaker Immediate Mode UI Library

A feature-rich, immediate mode UI system for GameMaker. GMUI provides a comprehensive set of UI components with a clean, intuitive API that feels natural to GameMaker developers.

![GMUI Demo](https://img.shields.io/badge/GameMaker-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

## Version Compatibility

| **IDE Version** | **Status** | **Description** |
|-----------------|------------|-----------------|
| 2024.14        | ⚠️ | Memory Issues |
| 2024.13        | ❌ | Memory Issues, Build Issues |
| 2024.11        | ✔️ | No Issue Detected |
| 2024.8        | ✔️ | No Issue Detected |

## Main Features

- **Immediate-mode API** - UI elements return interaction results immediately, simplifying state management
- **Full Window Management** - Title bars, resizing, dragging, close buttons, and z-ordering
- **Comprehensive Widget Set** - Buttons, sliders, checkboxes, textboxes, color pickers, comboboxes, and more
- **Advanced Layout System** - Cursor-based positioning with `same_line()`, `new_line()`, and separators
- **Smart Scrolling** - Both manual and auto-scrolling with fully customizable scrollbars
- **Extensive Styling System** - Complete theme customization with hundreds of style options
- **Modal Windows & Dialogs** - Popups, modal dialogs, and context-sensitive overlays
- **Tree Views** - Collapsible hierarchical structures with selection support
- **Data Tables** - Sortable, selectable tables with alternating rows and hover effects
- **Plotting & Charts** - Line plots, bar charts, histograms, and scatter plots for data visualization
- **Split Pane System** - Advanced window splitting ("WINS") with draggable dividers
- **Context Menus** - Right-click menus with sub-menus and keyboard shortcuts
- **Lite Search** - An integrated search engine

## Screenshots
<img width="1295" height="721" alt="ss1" src="https://github.com/user-attachments/assets/45669680-95c2-42ba-88d7-3a89bce53668" />
<img width="1299" height="722" alt="ss2" src="https://github.com/user-attachments/assets/41c73ea3-ce72-4fd0-92ba-ed42536647bd" />
<img width="1298" height="718" alt="ss3" src="https://github.com/user-attachments/assets/a3d707bc-d73d-4c93-8356-2f8c7a3e1cd0" />

## Quick Start

```gml
// Create Event
gmui_init();
my_value = 50;

// Step Event
gmui_update();

if (gmui_begin("My Window", 100, 100, 400, 300)) {
    gmui_text("Hello GMUI!");
    
    my_value = gmui_slider("Value", my_value, 0, 100);
    
    if (gmui_button("Click Me")) {
        show_debug_message("Button clicked!");
    }
    
    gmui_end();
}

// Draw GUI Event
gmui_render();
```

## Core Concepts

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

## UI Components/Elements and Features

## Windows & Layout
- Window
- Modal Window
- Popup Window
- Same Line
- New Line
- Separator
- Dummy Space
- Cursor Positioning
- Tab Width & Positioning
- Scrolling Container
- Scrollbar

## Text Elements
- Text
- Disabled Text
- Bulleted Text
- Wrapped Text
- Clickable Text
- Label with Value

## Buttons
- Button
- Invisible Button
- Full Width Button
- Small Button
- Large Button
- Fixed Width Button
- Disabled Button
- Image Button
- Image Button Labeled
- Image Button Tinted
- Arrow Button

## Checkboxes
- Checkbox with Label
- Disabled Checkbox
- Standalone Checkbox
- Checkbox Group

## Radioboxes
- Radiobox with Label
- Disabled Radiobox
- Standalone Radiobox
- Radiobox Group

## Sliders
- Slider
- Disabled Slider

## Text Input
- Textbox
- Float Input
- Integer Input

## Dropdowns
- Combobox
- Simple Combobox
- Label-less Combobox
- Combobox Dropdown

## Color Pickers
- Color Button
- Color Editor (4 channels)
- Color Button (4 channels)
- Color Picker Popup
- Color Picker Trigger

## Selectable Items
- Selectable
- Disabled Selectable
- Small Selectable
- Large Selectable
- Fixed Width Selectable

## Tree Views
- Tree Node (Begin)
- Tree Node (End)
- Tree Node (Extended)
- Tree Node (Single)
- Tree Leaf
- Tree Node Reset

## Collapsible Sections
- Collapsing Header
- Collapsing Header End

## Data Tables
- Basic Data Table

## Plotting & Charts
- Line Plot
- Bar Chart
- Histogram
- Scatter Plot
- Stem Plot
- Stair Plot
- Pie Plot
- Pie Plot (Donut)
- Pie Plot (Exploded)

## Window Splitting System - WINS
- Window Split Node
- Window Split Management
- Splitter Dragging & Resizing
- Splitter Visuals

## Modal System
- Basic Modal Management

## Window Menu
- Basic Menu Item

# Context Menu
- Context Menu Item
- Context Menu Sub Item

## Image Display
- Sprite Display
- Surface Display

## Custom Drawing Primitives
- Rectangle
- Rectangle with Alpha
- Rectangle Outline
- Rectangle Expensive
- Rounded Rectangle
- Rounded Rectangle Outline
- Line
- Triangle
- Text Drawing

## Shaders & Effects
- Shader Rectangle
- Color Picker Shaders

## Scissor Clipping
- Scissor Region

## Focus Management
- Textbox Focus Check
- Focused Textbox ID
- Textbox Focus Status
- Focused Textbox Text
- Clear Textbox Focus

## Window Management
- Bring Window to Front
- Send Window to Back
- Top Window
- Window Z-Order
- Set Window Z-Order
- All Windows Sorted

## Cache System
- Surface Caching with Sleep Timer
- Basic Variable Cahcing

## Demo & Debug
- Demo Window

## API Reference

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

## Styling Reference

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

## Event Flow

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

## Troubleshooting

### Common Issues

**UI not appearing?**
- Make sure to call `gmui_init()` in create event
- Call `gmui_update()` in step event and `gmui_render()` in draw GUI event
- Check that windows are created between `gmui_begin()` and `gmui_end()`

**Input not working?**
- Verify `gmui_update()` is called before any UI creation
- Check that windows are active and not behind a visible dimming window

**Performance issues?**
- Use scrolling only when necessary
- Avoid creating excessive hidden UI elements
- Use `gmui_window_flags.NO_BACKGROUND` for simple overlays

## License

MIT License - feel free to use in personal and commercial projects.

## Support

If you encounter any issues or have questions:
1. Check the documentation
2. Look at the example codes provided
3. Open an issue on GitHub
4. Reach me on discord (erkan612)

---

**GMUI**

