gmui_init(gmui_get_default_profile(gmui_default_profile.BALANCED), gmui_get_high_quality_visual_calls());
gmui_animation_init();

color = c_red;
str = "";
val = 0.5;
va = 50;
vb = 50.1234;

tx = 0;
gmui_tab_add("test tab", "test 1");
gmui_tab_add("test tab", "test 2");
gmui_tab_add("test tab", "test 3");
gmui_tab_add("test tab", "test 4");

math_set_epsilon(0.00000001);

gmui_tab_add("left_panel", "Hierarchy");
gmui_tab_add("left_panel", "Materials");

gmui_tab_add("right_panel", "Inspector");

gmui_tab_add("bottom_panel", "Assets");
gmui_tab_add("bottom_panel", "Output");
gmui_tab_add("bottom_panel", "Command Line");

gmui_tab_add("middle_panel", "Scene");
gmui_tab_add("middle_panel", "Settings");

left_panel_idx = 0;
right_panel_idx = 0;
bottom_panel_idx = 0;
middle_panel_idx = 0;

handle_pane = function(label) {
	switch (label) {
	case "Hierarchy": {
		gmui_begin_tree("hierarchy_tree");
		
		if (gmui_begin_tree_node("Scene", true)) {
			gmui_tree_leaf("Cube");
			gmui_tree_leaf("Plane");
			gmui_tree_leaf("Sky");
			if (gmui_begin_tree_node("Player")) {
				gmui_tree_leaf("Weapon");
				gmui_tree_leaf("Armor");
				
				gmui_end_tree_node();
			}
			
			gmui_end_tree_node();
		}
		
		gmui_end_tree();
	} break;
	case "Materials": {
		gmui_begin_tree("materials_tree");
		
		gmui_tree_leaf("Default_Material");
		gmui_tree_leaf("Sky_Material");
		gmui_tree_leaf("Character_Material");
		
		gmui_end_tree();
	} break;
	case "Inspector": {
		gmui_text("Name:");
		gmui_sameline();
		gmui_textbox("Player");
		gmui_separator();
		var columns = gmui_auto_column(
			[
				[ [ { widget: "text", params: [ "Position" ] } ], [ { widget: "input_float", params: [ 220.4275, undefined, undefined, undefined, 120, c_red ] }, { widget: "input_float", params: [ 12.1121, undefined, undefined, undefined, 120, c_green ] }, { widget: "input_float", params: [ 322.5431, undefined, undefined, undefined, 120, c_blue ] } ] ], 
				[ [ { widget: "text", params: [ "Rotation" ] } ], [ { widget: "input_float", params: [ 0, undefined, undefined, undefined, 120, c_red        ] }, { widget: "input_float", params: [ 90, undefined, undefined, undefined, 120, c_green      ] }, { widget: "input_float", params: [ 180, undefined, undefined, undefined, 120, c_blue      ] } ] ], 
				[ [ { widget: "text", params: [ "Scale"    ] } ], [ { widget: "input_float", params: [ 1, undefined, undefined, undefined, 120, c_red        ] }, { widget: "input_float", params: [ 1, undefined, undefined, undefined, 120, c_green       ] }, { widget: "input_float", params: [ 1, undefined, undefined, undefined, 120, c_blue        ] } ] ], 
			],
			2,
			[ 0.2, 0.6 ]
		);
		if (array_length(columns) > 0 && columns[0] != undefined) {
			columns[0].background_enabled = true;
			columns[0].background_draw_func = function(c, x1, y1, x2, y2) {
				draw_set_color(make_color_rgb(40, 40, 40));
				draw_rectangle(x1, y1, x2 - global.gmui.style.container_padding_h, y2, false);
				draw_set_color(c_white);
			}
		}
	} break;
	case "Assets": {
		if (gmui_begin_wins("bottom_split", gmui_split_dir.VERTICAL, [ 0.2, 0.8 ])) {
			if (gmui_begin_wins_pane(0)) {
				gmui_end_wins_pane();
			}
			
			if (gmui_begin_wins_pane(1)) {
				// source
				gmui_selectable("abc.txt", false);
				if (gmui_begin_drag_drop_source()) {
				    gmui_set_drag_drop_payload("FILE_ITEM", "C:/");
					gmui_set_tooltip("abc.txt");
				    gmui_end_drag_drop_source();
				}

				// target
				gmui_selectable("def.txt", false);
				if (gmui_begin_drag_drop_target()) {
				    var payload = gmui_accept_drag_drop_payload("FILE_ITEM");
				    if (payload != undefined) {
						show_debug_message($"dropped payload: {payload}");
				    }
				    gmui_end_drag_drop_target();
				}
				
				gmui_button("Drag Me!");
				gmui_drag("Dragging Button");
				
				gmui_end_wins_pane();
			}
			
			gmui_end_wins();
		}
	} break;
	case "Output": {
	} break;
	case "Command Line": {
	} break;
	case "Scene": {
	} break;
	case "Settings": {
	} break;
	}
};