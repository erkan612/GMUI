# Getting Started with GMUI

In this documentation, we will learn GMUI step by step!

## Course 1 - Starting with Windows

Lets start by installing GMUI and creating our first UI!

Download the latest release:
https://github.com/erkan612/GMUI/releases

Import the GMUI folder into your project

Create a UI object dedicated to GMUI functions

We need 4 main events to use GMUI
+ Create Event - to setup GMUI and create our retained variables
+ Step Event - to create our UI dynamically
+ Draw GUI Event - to render our UI
+ Clean Up Event - to free GMUI cache

Lets start by initializing GMUI in Create Event
```gml
gmui_init();
```

Now to update it in Step Event
```gml
gmui_update();
```

To draw our UI
```gml
gmui_render();
```

And to clean up the cahce
```gml
gmui_cleanup();
```

If we are to run this code it should execute without any issues but we wont see any results because there are no UI elements, yet!

First lets understand how GMUI works...

We can not create UI elements on their own, they need a canvas to work with, in this case we have windows

They are not particularly called windows but because their behaviour is quite flexible by default they act like window, they are actually a canvas

To create a window we use ``gmui_begin()`` and ``gmui_end()`` then we proceed to create our UI in between those two function.

The declaration of ``gmui_begin()`` as follows

``function gmui_begin(name, x = 0, y = 0, w = 512, h = 256, flags = 0) -> boolean;``

If there are no problems, it should return true. To make sure there are no erros we will use it inside an ``if`` statement and put ``gmui_end()`` in the end.

Note that we must create our UI after the all of ``gmui_update()``, here is the complete step event code

```gml
gmui_update();

if (gmui_begin("Test Window")) {
    // We will add our UI elements here
    gmui_end();
}
```

If we are to run this code, it should execute without any errors and we should see a blank window. In first look it would make you think that this can be only work with as if its just a window but I would like to remind you that its a flexible canvas and its behaviour can be changed, we can remove its resizable feature, its close button, its title, its background and so on. and we can do all this just by changing its flags(``gmui_window_flags`` and ``gmui_pre_window_flags``), we will learn more about them in the following courses.
## Course 2 - Buttons

Now lets learn about buttons...

The basic button as follows
``gmui_button(text, [width], [height]) -> boolean``
+ returns true when clicked
+ if not provided, length is being calculated depending on given text
+ aligns the text in the center

Others
``gmui_button_invisible(text, width, height) -> boolean``
``gmui_button_width(text, width) -> boolean``
``gmui_button_width_fill(text, width) -> boolean``
``gmui_button_small(text) -> boolean``
``gmui_button_large(text) -> boolean``
``gmui_button_disabled(text, [width], [height]) -> boolean``

Now lets put this into an example

The code below has a basic window, and a button. When being clicked, sends a debug message saying "Hello World!"
```gml
if (gmui_begin("Test Window")) {
    if (gmui_button("Click Me!")) {
        show_debug_message("Hello World!");
    }
    gmui_end();
}
```

Layout is being managed by the window automaticly, after an element it will go into next line automaticly.
```gml
if (gmui_begin("Test Window")) {
    gmui_button("Line 1");
    gmui_button("Line 2");
    gmui_end();
}
```

If we want the next element in the same line we need to use ``gmui_same_line()``
```gml
if (gmui_begin("Test Window")) {
    gmui_button("Line 1");
    gmui_same_line();
    gmui_button("Line 1");
    
    gmui_button("Line 2");
    gmui_end();
}
```

## Course 3 - Texts

The text function as follows
``gmui_text(text)``

Others
``gmui_text_disabled(text)``
``gmui_text_bullet(text)``
``gmui_text_wrap(text)``
``gmui_label_text(label, text)``

An example as follows
```gml
if (gmui_begin("Test Window")) {
    gmui_text("Hello World!");
    gmui_end();
}
```

## Course 4 - Input Elements

As input elements we have various options
+ ``gmui_checkbox()``
+ ``gmui_checkbox_box()``
+ ``gmui_checkbox_disabled()``
+ ``gmui_slider()``
+ ``gmui_slider_disabled()``
+ ``gmui_textbox()``
+ ``gmui_input_int()``
+ ``gmui_input_float()``
+ ``gmui_combo()``

Lets put them into an example
```gml
if (gmui_begin("Test Window", 100, 100, 400, 300)) {
    c1 = gmui_checkbox("Checkbox Label", c1);
    c2 = gmui_checkbox_box(c2);
	gmui_checkbox_disabled("Disabled Checkbox", c3);
	
	sliderVal = gmui_slider("Slider Label", sliderVal, 0, 100);
	gmui_slider_disabled("Disabled Slider", sliderVal, 0, 100);
	
	nameData = gmui_textbox(nameData, "A Placeholder text");
	
	v2[0] = gmui_input_int(v2[0]);
	gmui_same_line();
	v2[1] = gmui_input_int(v2[1]);
	
	v2[0] = gmui_input_float(v2[0]);
	gmui_same_line();
	v2[1] = gmui_input_float(v2[1]);
	
	combo_index = gmui_combo("Combo Label", combo_index, [ "Item 1", "Item 2", "Item 3" ]);
    gmui_end();
}
```

## Course 5 - Layout Management

We dont have many options for layout management but we do have enough to build our UI or to build custom tools for layout management.

+ ``gmui_same_line()`` - moves the cursor back to the previous line after an element call
+ ``gmui_dummy(width, height)`` - adds empty space with given size
+ ``gmui_seperator()`` - a horizontal line

## Course 6 - Colors and Color Picker

GMUI uses custom color formatting

we have various functions to conver GameMaker RGB to GMUI RGBA and back to GameMaker RGB plus to convert them into an array.

GMUI also has a built in color picker.

Color Helpers
+ ``gmui_lerp_color()``
+ ``gmui_make_color_rgba()``
+ ``gmui_rgba_to_hsva()``
+ ``gmui_hsva_to_rgba()``
+ ``gmui_color_rgba_to_array()``
+ ``gmui_array_to_color_rgba()``
+ ``gmui_color_rgba_to_color_rgb()``
+ ``gmui_color_rgb_to_color_rgba()``

Color Buttons
+ ``gmui_color_button()`` -> a rectangle with color, returns true when clicked
+ ``gmui_color_button_4()`` -> a rectangle with color, opens color picker when clicked
+ ``gmui_color_edit_4()`` -> a rectangle with color along with rgba input edits, opens color picker when clicked
## Course 7 - Containers

In GMUI we can use Tree View and Collapsing Headers as containers.

All though there is no point using Tree View as a container for buttons or other elements except Tree Nodes since we have Collapsing Headers(but we still can if we want to).

Now lets take a look at usage example of Tree View
```gml
if (gmui_begin("Test Window")) {
	gmui_tree_node_reset();
	var nodeBegin1 = gmui_tree_node_begin("Begin 1", treeIdx == "Begin 1");
	treeIdx = nodeBegin1[1] ? "Begin 1" : treeIdx;
	if (nodeBegin1[0]) {
		var nodeBegin11 = gmui_tree_node_begin("Begin 1.1", treeIdx == "Begin 1.1");
		treeIdx = nodeBegin11[1] ? "Begin 1.1" : treeIdx;
		if (nodeBegin11[0]) {
			if (gmui_tree_leaf("Leaf 1 of Begin 1.1", treeIdx == "Leaf 1 of Begin 1.1")) { treeIdx = "Leaf 1 of Begin 1.1"; };
		};
		gmui_tree_node_end();
		
		var nodeBegin12 = gmui_tree_node_begin("Begin 1.2", treeIdx == "Begin 1.2");
		treeIdx = nodeBegin12[1] ? "Begin 1.2" : treeIdx;
		if (nodeBegin12[0]) {
			if (gmui_tree_leaf("Leaf 1 of Begin 1.2", treeIdx == "Leaf 1 of Begin 1.2")) { treeIdx = "Leaf 1 of Begin 1.2"; };
		};
		gmui_tree_node_end();
	};
	gmui_tree_node_end();
}
```

+ We need to call ``gmui_tree_node_reset()`` everytime before making a root node
+ ``gmui_tree_node_begin()`` returns an array of two. the first element being being if the node is either open or not and second being if its clicked or not
+ ``gmui_tree_leaf()`` works same as ``gmui_selectable()``, returns true when being clicked

## Course 8 - Data Tables

We can use Data Tables as visualization.

Here is an example

Create Event:
```gml
table_data = [
    ["Apple", "Fruit", "1.20", "100"],
    ["Banana", "Fruit", "0.80", "150"],
    ["Carrot", "Vegetable", "1.50", "75"],
    ["Broccoli", "Vegetable", "2.00", "60"]
];

columns = ["Name", "Category", "Price", "Stock"];
selected_row = -1;
```

Step Event:
```gml
if (gmui_begin("Inventory", 20, 20, 400, 400)) {
    // Create table with flags
    var flags = global.gmui.style.table_flags.ALTERNATE_ROWS | 
                global.gmui.style.table_flags.SORTABLE_HEADERS;
    
    var table = gmui_begin_table("inventory_table", columns, 4, -1, 200, flags);
    
    // Add rows
    for (var i = 0; i < array_length(table_data); i++) {
        var clicked = gmui_table_row(table_data[i], i);
        if (clicked != -1) {
            selected_row = i;
        }
    }
    
    gmui_end_table();
    
    // Show selection info
    if (selected_row != -1) {
        gmui_label_text("Selected Item", table_data[selected_row][0]);
    }
    
    gmui_end();
}
```

## Course 9 - Plotting & Charts

Plots are similar to Data Tables

These are all the Plot functions we have in GMUI
+ ``gmui_plot_lines()``
+ ``gmui_plot_bars()``
+ ``gmui_plot_scatter()``
+ ``gmui_plot_histogram()``

Here's an example of plot lines

Create Event:
```gml
plot_data = [];
for (var i = 0; i < 20; i++) {
    plot_data[i] = sin(i * 0.5) * 50 + 50;
}
```

Step Event:
```gml
if (gmui_begin("Test Window", 20, 20, 400, 400)) {
	gmui_plot_lines("Sin Wave", plot_data, array_length(plot_data), -1, 150);
    gmui_end();
}
```

Example of bar chart

Create Event:
```gml
monthly_sales = [120, 85, 140, 95, 180, 130];
months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"];
```

Step Event:
```gml
if (gmui_begin("Test Window", 20, 20, 400, 400)) {
	gmui_plot_bars("Monthly Sales", monthly_sales, 6, -1, 150);
    gmui_end();
}
```

Scatter Plot

Create Event:
```gml
x_vals = [1, 2, 3, 4, 5, 6, 7, 8];
y_vals = [2, 4, 3, 6, 5, 8, 7, 9];
```

Step Event:
```gml
if (gmui_begin("Test Window", 20, 20, 400, 400)) {
	gmui_plot_scatter("X vs Y", x_vals, y_vals, 8, -1, 150);
    gmui_end();
}
```

Histogram

Create Event:
```gml
scores = [65, 72, 78, 82, 85, 88, 90, 92, 95, 98, 62, 75];
```

Step Event:
```gml
if (gmui_begin("Test Window", 20, 20, 400, 400)) {
	gmui_plot_histogram("Test Scores", scores, array_length(scores), -1, 150, 5);
    gmui_end();
}
```

## Course 10 - Styling & Customization

All the style variables are being contained inside ``global.gmui.style``

Here are some examples

#### Global Style Setup
```gml
var style = global.gmui.style;

// Basic colors
style.background_color = make_color_rgb(20, 25, 30);    // Dark blue-gray
style.text_color = make_color_rgb(220, 220, 220);       // Light gray text
style.border_color = make_color_rgb(60, 70, 80);        // Medium gray borders

// Window styling
style.window_rounding = 12;           // Rounded corners
style.window_padding = [12, 12];      // More padding
style.title_bar_height = 32;          // Taller title bar
```

#### Button Styling
```gml
var style = global.gmui.style;

// Button colors
style.button_bg_color = make_color_rgb(50, 60, 70);         // Normal
style.button_hover_bg_color = make_color_rgb(70, 80, 90);   // Hover
style.button_active_bg_color = make_color_rgb(40, 50, 60);  // Clicked

// Button appearance
style.button_rounding = 8;              // Rounder buttons
style.button_border_size = 2;           // Thicker borders
style.button_min_size = [100, 36];      // Minimum size
style.button_padding = [16, 8];         // More padding inside
```

#### Textbox Styling
```gml
style.textbox_bg_color = make_color_rgb(30, 35, 40);
style.textbox_border_color = make_color_rgb(70, 80, 90);
style.textbox_focused_border_color = make_color_rgb(100, 150, 255);  // Blue focus
style.textbox_rounding = 6;
style.textbox_padding = [8, 6];
```

#### Slider Styling
```gml
style.slider_track_height = 8;
style.slider_track_fill_color = make_color_rgb(100, 150, 255);  // Blue fill
style.slider_handle_width = 20;
style.slider_handle_height = 30;
style.slider_handle_rounding = 6;
```

#### Checkbox Styling
```gml
style.checkbox_size = 20;
style.checkbox_rounding = 4;
style.checkbox_check_color = make_color_rgb(100, 200, 100);  // Green check
```

Here's a Simple Checklist for Styling

1 - Colors
+ ``background_color`` - Window background
+ ``text_color`` - Default text
+ ``border_color`` - Borders everywhere

2 - Rounding
+ ``window_rounding`` - Window corners
+ ``button_rounding`` - Button corners
+ ``textbox_rounding`` - Input field corners

3 - Sizes
+ ``title_bar_height`` - Window top bar
+ ``button_min_size`` - Minimum button size
+ ``window_padding`` - Space inside windows

4 - Special colors
+ ``button_hover_bg_color`` - Button hover
+ ``textbox_focused_border_color`` - Active input field
+ ``slider_track_fill_color`` - Slider fill color

**Pro Tip:** Use style editor in ``gmui_demo()`` to find best style values for your game/app!


## Course 11 - Advanced Topics (Modals, WINS, Caching)

Here we are almost ready to be able to use GMUI fluently!

Now lets learn about Modals, WINS and Caching!

---

Modal are popups with background dimming.

In step event, after calling the ``gmui_update()`` we can use ``gmui_add_modal(name, function(window) {UI body}, [x], [y], [w], [h], [flags], [onBgClick])`` to add a modal and use ``gmui_open_modal(name)``/``gmui_close_modal(name)`` to open/close a modal.

Here's an example

```gml
gmui_add_modal("Message", function(window) {
	gmui_text("Hello World!");
	if (gmui_button_width_fill("OK")) { gmui_close_modal("Message"); };
});
```

---

WINS is a window splitting api, it allows you to dock windows.

Here's an example

```gml
gmui_update();

if (global.gmui.frame_count == 1) {
	winsFrame = gmui_wins_node_create(0, 0, surface_get_width(application_surface), surface_get_height(application_surface));
	
	var split = gmui_wins_node_split(winsFrame, gmui_wins_split_dir.LEFT, 0.3);
	var nodeA = split[0];
	var nodeB = split[1];
	
	split = gmui_wins_node_split(nodeB, gmui_wins_split_dir.UP, 0.7);
	nodeB = split[0];
	var nodeC = split[1];
	
	gmui_wins_node_set(nodeA, "Window A");
	gmui_wins_node_set(nodeB, "Window B");
	gmui_wins_node_set(nodeC, "Window C");
};

gmui_wins_node_update(winsFrame);
gmui_wins_draw_splitters(winsFrame);

if (gmui_begin("Window A", undefined, undefined, undefined, undefined, gmui_pre_window_flags.WINS_SET)) {
	gmui_text_bullet("Demonstrating WINS feature!");
	gmui_end();
};

if (gmui_begin("Window B", undefined, undefined, undefined, undefined, gmui_pre_window_flags.WINS_SET)) {
	gmui_text_bullet("Demonstrating WINS feature!");
	gmui_end();
};

if (gmui_begin("Window C", undefined, undefined, undefined, undefined, gmui_pre_window_flags.WINS_SET)) {
	gmui_text_bullet("Demonstrating WINS feature!");
	gmui_end();
};
```

Now lets understand what is going on here.

First we need to create a main node to begin splitting into peaces and later we will bind them into windows.

To create a node we use ``gmui_wins_node_create(x, y, width, height)``

To split it we use ``gmui_wins_node_split(node, dir, [ratio])`` which will give us an array of two, first being the node that is splitted in the given direction and the seond being splitted in the opposite of given direction.

We proceed to apply this one more time to get all the nodes we need and then we use ``gmui_wins_node_set(node, name)`` to bind them with a window.

Once we are done creating our node interace, we need to continuously update the parent node using ``gmui_wins_node_update(parent_node)`` which will calculate its and its childrens positions and sizes to update their binded windows.

After that we can have our splitted windows but we need to draw and drag/resize our nodes so we call ``gmui_wins_draw_splitters(parent_node)`` after calling ``gmui_wins_node_update(parent_node)``.

---

Since we are creating our UI every frame, we need to cache some of our date, for that we can use the following functions:
+ ``gmui_cache_get(id)``
+ ``gmui_cache_set(id, data)``
+ ``gmui_cache_delete(id)``
+ ``gmui_cache_surface_get(id, width, height)``

Particularly ``gmui_cache_surface_get(id, width, height)``, we use it to create surfaces with sleep timer, by default they have 30 seconds. any time you use ``gmui_cache_surface_get`` to create surface, it will be created in cache and set a timer, if ``gmui_cache_surface_get`` is not called within 30 seconds with specific ``id``, the surface will be deleted from memory.
