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
tab_idx1 = 0;
tabs1 = [ "General", "Gameplay", "Profile" ];
gmui_tab_add("settings1", "General1");
gmui_tab_add("settings1", "Gameplay1");
gmui_tab_add("settings1", "Profile1");
button_toggle = false;
button_loading = false;
my_check1 = false;
my_check2 = false;
toggled1 = false;
toggled2 = false;
my_slider_value1 = 50;


/* unexpected mouse behavior from:
tabs
column separators
*/

/*
add textbox input color specification
fix textbox selection glitching
complete the fonts
*/

/*
gmui_auto_column(rows, columns_count)
gmui_auto_column(
	[
		[ { widget: "text", params: [ "BG Color" ] }, { widget: "color_picker", variable_owner: Object1, variable_name: "auto_layout_bg_color" }, { widget: "input_int", params: [ Object1.auto_layout_bg_color ], variable_owner: Object1, variable_name: "auto_layout_bg_color" }, ],
	],
	1
);

---

docking

---

advanced tooltip:
- gmui_begin_tooltip() - gmui_end_tooltip()
- gmui_tooltip_advanced(name, widget_id)

---

style editor

---

demo
*/

















