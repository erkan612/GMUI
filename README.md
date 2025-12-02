# GMUI - GameMaker Immediate Mode UI Library

A feature-rich, immediate mode UI system for GameMaker. GMUI provides a comprehensive set of UI components with a clean, intuitive API that feels natural to GameMaker developers.

![GMUI Demo](https://img.shields.io/badge/GameMaker-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

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

## Screenshots
<img width="1305" height="724" alt="gmui_demo" src="https://github.com/user-attachments/assets/3a83e442-f2e9-4c36-839f-d92476e8c15d" />
<img width="2183" height="937" alt="simplistic_editor_tab_details" src="https://github.com/user-attachments/assets/2416ec1e-aa29-4944-b937-282e6977c79a" />
<img width="2192" height="937" alt="simplistic_editor" src="https://github.com/user-attachments/assets/adf5c0d1-5e8a-4988-90f3-4e04d6e23224" />
<img width="1300" height="716" alt="demo_tab_example5" src="https://github.com/user-attachments/assets/cbd5fcc8-d950-4393-8d7b-10e6b21e8aff" />
<img width="1301" height="723" alt="demo_tab_example4" src="https://github.com/user-attachments/assets/ae3bb123-acc1-45aa-8656-5d32888afea7" />
<img width="1297" height="721" alt="demo_tab_example3" src="https://github.com/user-attachments/assets/db3664c2-6df5-4967-bdaf-417ac7844a93" />
<img width="1299" height="721" alt="demo_tab_example2" src="https://github.com/user-attachments/assets/b5a47dce-34a9-41fb-8683-eb2df979b493" />
<img width="1301" height="720" alt="demo_tab_example1" src="https://github.com/user-attachments/assets/9566c393-069c-464d-b801-c8fc8177c153" />

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
- Label with Value

## Buttons
- Button
- Invisible Button
- Full Width Button
- Small Button
- Large Button
- Fixed Width Button
- Disabled Button

## Checkboxes
- Checkbox with Label
- Disabled Checkbox
- Standalone Checkbox

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
- Table (Begin)
- Table Row
- Table (End)
- Table Controls

## Plotting & Charts
- Line Plot
- Bar Chart
- Histogram
- Scatter Plot

## Window Splitting System - WINS
- Window Split Node
- Window Split Management
- Splitter Dragging & Resizing
- Splitter Visuals

## Modal System
- Modal Management
- Modal Open
- Modal Close

## Image Display
- Sprite Display
- Surface Display

## Custom Drawing Primitives
- Rectangle
- Rectangle with Alpha
- Rectangle Outline
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
- Surface Cache

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

## Complete Example (Simplistic Editor)

Here's a comprehensive example showing multiple features:

```gml
// CREATE EVENT
gmui_init();

winsFrame = undefined;

objectCreateTextInput = "";
objectCreateComboIndex = 0;

objects = array_create(0);
selectedObject = undefined;

collapsingHeaderOpenTransform = true;

surfaceView = undefined;

GetObject = function(name) {
	for (var i = 0; i < array_length(objects); i++) {
	    if (objects[i].name == name) { return objects[i]; };
	}
	return undefined;
};

GetObjectIndex = function(name) {
	for (var i = 0; i < array_length(objects); i++) {
	    if (objects[i].name == name) { return i; };
	}
	return undefined;
};

// STEP EVENT
gmui_update();

if (global.gmui.frame_count == 1) {
	winsFrame = gmui_wins_node_create(0, 0, 1310, 700);
	
	var split = gmui_wins_node_split(winsFrame, gmui_wins_split_dir.LEFT, 0.2);
	var nodeDetails = split[0];
	var node = split[1];
	
	split = gmui_wins_node_split(node, gmui_wins_split_dir.LEFT, 0.7);
	var nodeView = split[0];
	var nodeInfo = split[1];
	
	gmui_wins_node_set(nodeDetails, "Details");
	gmui_wins_node_set(nodeView, "View");
	gmui_wins_node_set(nodeInfo, "Info");
}

var temp = gmui_get_window("View");
var viewCurrentSize = [ temp.width, temp.height ];
gmui_wins_node_update(winsFrame);
gmui_wins_draw_splitters(winsFrame);

gmui_add_modal("Change Object Name", function(window) {
	gmui_tab_width(8);
	
	gmui_text("Object Name");
	gmui_same_line();
	gmui_tab(13);
	objectCreateTextInput = gmui_textbox(objectCreateTextInput, "Enter a name..");
	if ((gmui_button_width_fill("OK") || (keyboard_check_pressed(vk_enter) && gmui_textbox_id() == gmui_get_focused_textbox_id()) || keyboard_check_pressed(vk_enter)) && objectCreateTextInput != "") {
		var index = GetObjectIndex(selectedObject);
		objects[index].name = objectCreateTextInput;
		selectedObject = objectCreateTextInput;
		
		gmui_close_modal("Change Object Name");
	};
}, undefined, undefined, undefined, undefined, gmui_pre_window_flags.MODAL_SET);

gmui_add_modal("Select an Object", function(window) {
	gmui_text_wrapped("Please select an object to delete");
	if (gmui_button_width_fill("OK")) { gmui_close_modal("Select an Object"); };
}, undefined, undefined, undefined, undefined, gmui_pre_window_flags.MODAL_SET);

gmui_add_modal("Delete Object", function(window) {
	gmui_text_wrapped("Are you sure you want to delete this object?");
	if (gmui_button_width_fill("Delete")) { array_delete(objects, GetObjectIndex(selectedObject), 1); selectedObject = undefined; gmui_close_modal("Delete Object"); };
	if (gmui_button_width_fill("Cancel")) { gmui_close_modal("Delete Object"); };
}, undefined, undefined, undefined, undefined, gmui_pre_window_flags.MODAL_SET);

gmui_add_modal("Create Object", function(window) {
	gmui_tab_width(8);
	
	gmui_text("Object Name");
	gmui_same_line();
	gmui_tab(13);
	objectCreateTextInput = gmui_textbox(objectCreateTextInput, "Enter a name..");
	
	var types = [ "Box", "Circle" ];
	gmui_text("Type");
	gmui_same_line();
	gmui_tab(13);
	objectCreateComboIndex = gmui_combo("", objectCreateComboIndex, types);
	
	if ((gmui_button_width_fill("OK") || (keyboard_check_pressed(vk_enter) && gmui_textbox_id() == gmui_get_focused_textbox_id()) || keyboard_check_pressed(vk_enter)) && objectCreateTextInput != "") {
		var selectedType = types[objectCreateComboIndex];
		
		var object = {
			name: objectCreateTextInput,
			type: selectedType,
			x: 100,
			y: 100,
			width: 100,
			height: 100,
		};
		
		array_push(objects, object);
		
		gmui_close_modal("Create Object");
	};
	if (gmui_button_width_fill("Cancel")) { gmui_close_modal("Create Object"); };
}, undefined, undefined, undefined, undefined, gmui_pre_window_flags.MODAL_SET);

if (gmui_begin("Details", undefined, undefined, undefined, undefined, gmui_pre_window_flags.WINS)) {
	gmui_text(gmui_get().current_window.name); 
	gmui_same_line(); 
	if (gmui_button("+", 16, 16)) {
		gmui_open_modal("Create Object");
	}
	gmui_same_line(); 
	if (gmui_button("-", 16, 16)) {
		if (selectedObject != undefined && selectedObject != "Root") { gmui_open_modal("Delete Object"); }else { gmui_open_modal("Select an Object"); };
	}
	gmui_separator();
	
	var treeNode = gmui_tree_node_begin("Root", selectedObject == "Root");
	selectedObject = treeNode[1] ? "Root" : selectedObject;
	
	if (treeNode[0]) {
		for (var i = 0; i < array_length(objects); i++) {
			var object = objects[i];
			if (gmui_tree_leaf(object.name, selectedObject == object.name)) { selectedObject = object.name; };
		};
	};
	
	gmui_tree_node_end();
	
	gmui_end();
};

if (gmui_begin("View", undefined, undefined, undefined, undefined, gmui_pre_window_flags.WINS)) {
	gmui_text(gmui_get().current_window.name);
	gmui_separator();
	
	var availableWidth = gmui_get().current_window.width - gmui_get().current_window.dc.cursor_x - gmui_get().style.window_padding[0];
	var availableHeight = gmui_get().current_window.height - gmui_get().current_window.dc.cursor_y - gmui_get().style.window_padding[1];
	if (!surface_exists(surfaceView)) {
		surfaceView = surface_create(availableWidth, availableHeight);
	}
	else if (gmui_get().current_window.width != viewCurrentSize[0] || gmui_get().current_window.height != viewCurrentSize[1]) {
		surface_free(surfaceView);
		surfaceView = surface_create(availableWidth, availableHeight);
	};
	gmui_surface(surfaceView);
	
	gmui_end();
};

if (gmui_begin("Info", undefined, undefined, undefined, undefined, gmui_pre_window_flags.WINS)) {
	gmui_text(gmui_get().current_window.name);
	gmui_separator();
	
	var object = GetObject(selectedObject);
	
	if (selectedObject != undefined && selectedObject != "Root" && object != undefined) {
		gmui_text(selectedObject);
		gmui_same_line();
		if (gmui_button("Change")) { gmui_open_modal("Change Object Name"); };
		
		var header = gmui_collapsing_header("Transform", collapsingHeaderOpenTransform);
		collapsingHeaderOpenTransform = header[1] ? !collapsingHeaderOpenTransform : collapsingHeaderOpenTransform;
		if (header[0]) {
			gmui_text("Position");
			gmui_text("X");
			gmui_same_line();
			object.x = gmui_input_int(object.x, undefined, -1000, 1000);
			gmui_same_line();
			gmui_text("Y");
			gmui_same_line();
			object.y = gmui_input_int(object.y, undefined, -1000, 1000);
			
			gmui_text("Size");
			gmui_text("W");
			gmui_same_line();
			object.width = gmui_input_int(object.width, undefined, -1000, 1000);
			gmui_same_line();
			gmui_text("H");
			gmui_same_line();
			object.height = gmui_input_int(object.height, undefined, -1000, 1000);
			
			gmui_collapsing_header_end();
		};
	}
	else {
		gmui_text_disabled("Select an object");
	};
	
	gmui_end();
};

// DRAW GUI EVENT
gmui_render();

surface_set_target(surfaceView);
draw_clear_alpha(c_white, 0);

draw_set_colour(c_dkgray);
var gridSize = 32;
for (var i = 0; i <= surface_get_width(surfaceView); i += gridSize) {
	draw_line(i, 0, i, surface_get_height(surfaceView));
};
for (var i = 0; i <= surface_get_height(surfaceView); i += gridSize) {
	draw_line(0, i, surface_get_width(surfaceView), i);
};
draw_set_colour(c_white);

for (var i = 0; i < array_length(objects); i++) {
    var object = objects[i];
	
	switch (object.type) {
	case "Box": {
		draw_rectangle(object.x, object.y, object.x + object.width, object.y + object.height, false);
	} break;
	case "Circle": {
		draw_ellipse(object.x, object.y, object.x + object.width, object.y + object.height, false);
	} break;
	};
}

surface_reset_target();

// Clean-Up Event
gmui_cleanup();
surface_free(surfaceView);
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

