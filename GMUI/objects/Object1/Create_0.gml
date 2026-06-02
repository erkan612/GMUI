gmui_init();
global.gmui.style.font = Font1;

my_check = false;
my_slider_value = 0;
my_text = "";
selected_idx = -1;
line_values = [25, 45, 30, 60, 40, 80, 55, 35, 70, 50, 65, 40, 55, 75, 45];
bar_values = [120, 200, 150, 80, 240, 180, 90, 160];
hist_values = [5, 12, 8, 15, 9, 11, 7, 13, 10, 6, 14, 8, 12, 9, 11, 7, 10, 13, 8, 6];
scatter_x = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
scatter_y = [2, 4, 5, 4, 5, 7, 8, 7, 9, 8, 10, 9, 12, 11, 13];
stem_vals = [0.2, 0.5, 0.8, 0.3, 0.9, 0.4, 0.7, 0.6, 1.0, 0.5];
stem_lbls = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J"];
stair_values = [25, 45, 30, 60, 40, 80, 55, 35, 70, 50];
pie_values = [25, 20, 15, 30, 10];
pie_labels = ["Red", "Blue", "Green", "Yellow", "Purple"];
area_series = [
    [10, 20, 30, 25, 35, 45, 40, 50, 45, 55],  // bottom layer
    [25, 35, 40, 45, 50, 55, 60, 65, 55, 70],  // middle layer
    [40, 50, 55, 60, 65, 70, 75, 80, 70, 85],  // top layer
];
stacked_series = [
    [20, 35, 30, 45, 25, 40, 35, 30],  // series 1
    [15, 25, 20, 30, 35, 20, 25, 30],  // series 2
    [10, 15, 25, 20, 15, 25, 20, 15],  // series 3
];
grouped_series = [
    [45, 60, 55, 70, 50, 65, 75, 55],  // product A
    [30, 45, 40, 55, 35, 50, 60, 40],  // product B
    [20, 30, 25, 40, 30, 35, 45, 30],  // product C
];
heatmap_data = [
    [5,  12, 8,  15, 9,  11, 7,  13],
    [10, 6,  14, 8,  12, 9,  11, 7 ],
    [15, 9,  11, 7,  13, 10, 6,  14],
    [8,  12, 9,  11, 7,  13, 10, 6 ],
    [14, 8,  12, 9,  11, 7,  13, 10],
    [6,  14, 8,  12, 9,  11, 7,  13],
    [11, 7,  13, 10, 6,  14, 8,  12],
    [9,  11, 7,  13, 10, 6,  14, 8 ],
];
radar_series = [
    [80, 90, 60, 70, 85, 75],  // series 1
    [50, 70, 80, 60, 55, 65],  // series 2
];
radar_labels = ["Speed", "Power", "Defense", "Agility", "Stamina", "Magic"];
box_data = [
    [45, 52, 48, 55, 50, 47, 53, 49, 51, 46, 54, 50, 48, 52, 49],
    [60, 65, 58, 62, 70, 63, 61, 59, 64, 66, 62, 68, 60, 63, 61],
    [40, 42, 38, 45, 43, 41, 39, 44, 42, 40, 43, 41, 38, 44, 42],
];
box_labels = ["Group A", "Group B", "Group C"];
funnel_values = [1000, 800, 600, 400, 200, 50];
funnel_labels = ["Views", "Clicks", "Signups", "Trials", "Purchases", "Renewals"];
waterfall_values = [100, -30, 50, -20, 40, -10, 30, -15, 25, 60];
waterfall_labels = ["Start", "Costs", "Sales", "Returns", "Refunds", "Fees", "Tax", "Adj", "Bonus", "Total"];
bubble_x = [10, 25, 45, 30, 60, 50, 35, 70, 55, 40];
bubble_y = [15, 35, 50, 40, 65, 55, 45, 75, 60, 50];
bubble_s = [8,  15, 30, 20, 10, 50, 25, 40, 35, 12];
gantt_tasks = ["Planning", "Design", "Development", "Testing", "Deployment", "Review"];
gantt_starts = [0, 5, 12, 28, 35, 40];
gantt_ends =   [5, 14, 30, 36, 42, 48];
err_x = [1, 2, 3, 4, 5, 6];
err_y = [25, 45, 30, 60, 40, 55];
err_low = [20, 38, 25, 52, 35, 48];
err_high = [30, 52, 35, 68, 48, 62];
gauge_value = 65;
tbl_headers = ["Name", "Score", "Rank", "Status"];
tbl_data = [
    ["Alice",    "95", "1st", "Pass"],
    ["Bob",      "87", "2nd", "Pass"],
    ["Charlie",  "78", "3rd", "Pass"],
    ["Diana",    "72", "4th", "Pass"],
    ["Eve",      "65", "5th", "Fail"],
    ["Frank",    "58", "6th", "Fail"],
];
combo_items = ["Apple", "Banana", "Cherry", "Date", "Elderberry", "Fig", "Grape"];
combo_selected = 0;
my_color = gmui_make_color_rgba(255, 128, 64, 255);
toggled = false;
volume = 75;
pan = 0;
palette_colors = [
    make_color_rgb(255, 100, 100), make_color_rgb(100, 255, 100), make_color_rgb(100, 100, 255),
    make_color_rgb(255, 255, 100), make_color_rgb(255, 100, 255), make_color_rgb(100, 255, 255),
    make_color_rgb(255, 200, 100), make_color_rgb(200, 100, 255), make_color_rgb(100, 255, 200),
    make_color_rgb(255, 150, 150), make_color_rgb(150, 255, 150), make_color_rgb(150, 150, 255),
    make_color_rgb(200, 200, 200), make_color_rgb(150, 150, 150), make_color_rgb(100, 100, 100),
    make_color_rgb(50, 50, 50),
];
my_palette_color = palette_colors[0];
ms_items = ["Apple", "Banana", "Cherry", "Date", "Elderberry", "Fig", "Grape", "Honeydew"];
ms_selected = ds_map_create();
properties = [
    ["Name", "Player One"],
    ["Health", 100],
    ["Level", 42],
    ["Experience", 15840],
    ["Gold", 9999],
    ["Status", "Active"],
    ["Class", "Warrior"],
    ["Guild", "Dragon Slayers"],
];
my_date = [date_get_year(date_current_datetime()), date_get_month(date_current_datetime()), date_get_day(date_current_datetime())]; // year, month, day
options = ["Option A", "Option B", "Option C", "Option D"];
selected_option = 0;
tx1 = "test textbox";
tx2 = "";
my_int = 33;
my_float = 5.5;
list_items = ["Apple", "Banana", "Cherry", "Date", "Elderberry", "Fig", "Grape", "Honeydew", "Kiwi", "Lemon", "Mango", "Nectarine"];
single_select = -1;
multi_select = ds_map_create();
menu_check = false;
menu_radio = 0;
tab_idx = 0;
tabs = [ "General", "Gameplay", "Profile" ];
gmui_tab_add("settings", "General");
gmui_tab_add("settings", "Gameplay");
gmui_tab_add("settings", "Profile");
is_first_frame = true;
wins_frame = undefined;


/*
better scroll handling
fix modal dithering
complete the fonts
*/

/*
docking
- gmui_dockspace_frame_create(x, y, w, h) ; unlike node, frame has its own dockspace but frame can also be used as node
- gmui_dockspace_node_create(x, y, w, h)
- gmui_dockspace_node_into_frame(node) ; takes a node and converts it into a frame, used for nested frames
- gmui_dockspace_node_split(node, split_axis, ratios) ; ratios is an array, its size declares the amount of split in the given axis
- gmui_dockspace_dock(name, node) ; docks a window with the given name into specified node
- gmui_begin_dockspace(name, x, y, w, h, flags) - gmui_end_dockspace() ; parent dockspace, allows for nested dockspaces, its own docking can be disabled so only its nested dockspaces can be used
- gmui_begin_dockspace_window(name, flags) - gmui_end_dockspace_window() ; basic window that will hold onto position and size of the node that has its given name
- gmui_dockspace_frame_update(node) ; updates the given nodes splitters(resizes, drags/drops and docks etc)

enum gmui_split_dir {
	HORIZONTAL,
	VERTICAL,
};

enum gmui_dockspace_flags {
	NONE = 1 << 0, // default
	WINDOW = 1 << 1, // a docking space that acts as a window with proper title bar and dragging and resizing etc.
	TABS = 1 << 2, // a docking space acts as a window (requires WINDOW flag) and has tabs in its title that also can be dragged and docked
};

// dockspace window uses gmui_window_flags

// step event:
if (is_first_frame) {
	is_first_frame = false;
	
	wins_frame = gmui_dockspace_frame_create(0, 0, 1310, 700);
	var splits = gmui_docking_node_split(wins_frame, gmui_split_dir.HORIZONTAL, [ 0.4, 0.7, 0.3, 1 ]); // result is left to right
	var win0 = splits[0];
	var win1 = splits[1];
	var win2 = splits[2];
	splits = gmui_docking_node_split(splits[3], gmui_split_dir.VERTICAL, [ 1, 1 ]); // result is top to bottom
	var win3 = splits[0];
	wins_frame_nested = gmui_dockspace_node_into_frame(splits[1]);
	splits = gmui_docking_node_split(wins_frame_nested, gmui_split_dir.HORIZONTAL, [ 1, 1 ]);
	var win4 = splits[0];
	var win5 = splits[1];
	
	gmui_dockspace_dock("win1", win1);
	gmui_dockspace_dock("win2", win2);
	gmui_dockspace_dock("win3", win3);
	gmui_dockspace_dock("win4", win4);
	gmui_dockspace_dock("win5", win5);
}

gmui_dockspace_frame_update(wins_frame); // also updates its nested frames ( like wins_frame_nested)

gmui_begin_dockspace(wins_frame);

if (gmui_begin_dockspace_window("win1")) {
	gmui_end_dockspace_window()
}

if (gmui_begin_dockspace_window("win2")) {
	gmui_end_dockspace_window()
}

if (gmui_begin_dockspace_window("win3")) {
	gmui_end_dockspace_window()
}

gmui_begin_dockspace(wins_frame_nested); // nested frames windows can also be docked into their parents spaces or their parents windows can be docked into their nested frames spaces

if (gmui_begin_dockspace_window("win4")) {
	gmui_end_dockspace_window()
}

if (gmui_begin_dockspace_window("win5")) {
	gmui_end_dockspace_window()
}

gmui_end_dockspace();

gmui_end_dockspace();






gmui_begin_dockspace("main", 0, 0, display_get_gui_width(), display_get_gui_height());

if (gmui_dockspace_window("Inspector")) {
    gmui_text("hello");
    gmui_end_window();
}
if (gmui_dockspace_window("Scene")) {
    gmui_text("world");
    gmui_end_window();
}

gmui_end_dockspace();

---

advanced tooltip:
- gmui_begin_tooltip() - gmui_end_tooltip()
- gmui_tooltip_advanced(name, widget_id)

---

style editor

---

demo
*/

















