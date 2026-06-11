# GMUI

**Immediate-mode GUI framework for GameMaker**

Native GML implementation of immediate-mode UI paradigm. No extensions. No DLLs.

---

```gml
// One window. Two buttons. Three lines of code.
if (gmui_begin_window("Demo", 100, 100, 300, 200)) {
    if (gmui_button("Click me")) { /* action */ }
    gmui_end_window();
}
```

---

## What is GMUI?

GMUI brings the immediate-mode GUI paradigm to GameMaker. Instead of retaining UI state between frames, you declare your UI every frame. This eliminates callback hell, simplifies dynamic interfaces, and makes UI code as straightforward as drawing primitives.

---

## Features

- **Windows** – Standalone Windows or basic Containers
- **Widgets** – Buttons, checkboxes, sliders, knobs, textboxes, combo boxes, color pickers, date pickers... (in total 70+)
- **Layout** – Columns, rows, auto layouts, indentation, docking (WINS)
- **Data** – 20+ chart types, tree views, list boxes, key-value lists
- **Interaction** – Tooltips, toast notifications, context menus, modal popups
- **Styling** – Complete theming system with live demo style editor

---

## Quick Example

```gml
// Create event
gmui_init();
selected = 0;

// Step event
gmui_update();

if (gmui_begin_window("Inventory", 50, 50, 400, 300)) {
    selected = gmui_list_box(selected, items, 10);
    
    if (gmui_button("Equip")) {
        equip_item(items[selected]);
    }
    gmui_end_window();
}

// Draw event  
gmui_draw_gui();
```

---

## Documentation

- **[Getting Started](GettingStarted.md)**
- **[Full Documentation](Documentation.md)**
- **[API Reference](RawDocumentation.md)**
