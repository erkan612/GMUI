# Getting Started with GMUI

---

## Step 1: Import

Use GameMaker's Package Manager to import the GMUI .yymps file.

---

## Step 2: Initialize

Call `gmui_init()` in a controller object's Create event.

```gml
// Create event
gmui_init();
gmui_set_font(Font1);
```

---

## Step 3: Update

Call `gmui_update()` in the Step event.

```gml
// Step event
gmui_update();
```

---

## Step 4: Draw

Call `gmui_draw_gui()` in the Draw event.

```gml
// Draw event
gmui_draw_gui();
```

---

## Step 5: Build UI

After `gmui_update()`, in the same Step event, build your UI.

```gml
// Step event (after gmui_update)
if (gmui_begin_window("My Window", 100, 100, 400, 300)) {
    
    gmui_text("Hello, GMUI!");
    
    if (gmui_button("Click Me")) {
        show_debug_message("Clicked!");
    }
    
    gmui_end_window();
}
```

**Important:** UI code must be in the Step event, after `gmui_update()`. GMUI collects UI calls in Step and draws them in Draw automatically.

---

## Basic Widgets

### Buttons

```gml
if (gmui_button("Click")) {
    // action
}

if (gmui_button_primary("Save")) {
    // save
}

if (gmui_button_danger("Delete")) {
    // delete
}
```

### Input

```gml
// Text input
global.name = gmui_textbox(global.name, "Enter name...");

// Integer input
global.level = gmui_input_int(global.level, 1, 1, 99);

// Slider
global.volume = gmui_slider(global.volume, 0, 100);
```

### Selection

```gml
global.option = gmui_checkbox(global.option, "Enable");
global.setting = gmui_toggle(global.setting);

global.selected = gmui_combo(global.selected, items, 5);
```

### Layout

```gml
gmui_text("Label:");
gmui_sameline();
gmui_button("Button");

gmui_newline();

gmui_auto_column([
    [ { widget: "text", params: [ "Name:" ] }, 
      { widget: "textbox", params: [ global.name, "Enter name" ], variable_owner: global, variable_name: "name" } ]
], 2);
```

---

## WINS Docking

```gml
if (gmui_begin_wins("main", gmui_split_dir.HORIZONTAL, [0.3, 0.7])) {
    
    if (gmui_begin_wins_pane(0)) {
        gmui_text("Left panel");
        gmui_end_wins_pane();
    }
    
    if (gmui_begin_wins_pane(1)) {
        gmui_text("Right panel");
        gmui_end_wins_pane();
    }
    
    gmui_end_wins();
}
```

---

## Charts

```gml
global.line_data = [25, 45, 30, 60, 40];
gmui_plot_lines(global.line_data, 5, 300, 150);

global.pie_values = [25, 20, 15, 30, 10];
global.pie_labels = ["Red", "Blue", "Green", "Yellow", "Purple"];
gmui_plot_pie(global.pie_values, global.pie_labels, 5, 300, 200);
```

---

## Popups

```gml
if (gmui_button("Open Popup")) {
    gmui_popup_open("my_popup");
}

if (gmui_begin_popup("my_popup", 300, 150, true)) {
    gmui_text("Modal popup content");
    if (gmui_button("Close")) {
        gmui_popup_close("my_popup");
    }
    gmui_end_popup();
}
```

---

## Context Menus

```gml
if (mouse_check_button_released(mb_right)) {
    gmui_context_menu_open("my_menu");
}

if (gmui_begin_context_menu("my_menu", 160, 200)) {
    if (gmui_context_menu_item("New", "Ctrl+N")) {
        // action
    }
    if (gmui_context_menu_item("Open", "Ctrl+O")) {
        // action
    }
    gmui_end_context_menu();
}
```

---

## Styling

```gml
// Open the built-in style editor
gmui_style_editor();

// Apply a preset
gmui_style_apply_ruler({
    color_bg_dominant: make_color_rgb(24, 24, 24),
    color_accent: make_color_rgb(70, 130, 180),
    color_text_primary: make_color_rgb(225, 225, 225),
    spacing_medium: 8,
    rounding_widget: 4
});
```

---

## Full Example

```gml
// Controller object - Create event
gmui_init();
gmui_set_font(Font1);

global.name = "";
global.volume = 75;
global.effects = false;

// Controller object - Step event
gmui_update();

if (gmui_begin_window("Settings", 100, 100, 350, 300)) {
    
    global.name = gmui_textbox(global.name, "Enter name", 300);
    global.volume = gmui_slider(global.volume, 0, 100, 300);
    global.effects = gmui_checkbox(global.effects, "Enable Effects");
    
    if (gmui_button_primary("Apply")) {
        gmui_toast_push("Settings saved!", "success");
    }
    
    gmui_end_window();
}

// Controller object - Draw event
gmui_draw_gui();
```

---

## Cleanup

```gml
// Call when closing the game
gmui_cleanup();
```

---

## Next Steps

- Run `gmui_demo()` to see interactive examples
- Open `gmui_style_editor()` to customize the look
- Check the [API Reference](ApiReference.md)

---

## Common Issues

| Issue | Solution |
|-------|----------|
| Nothing appears | `gmui_update()` in Step, `gmui_draw_gui()` in Draw |
| Font not showing | Call `gmui_set_font()` after `gmui_init()` |
| UI code errors | UI must be in Step event after `gmui_update()` |

---
