gmui_update();

var screen_width = surface_get_width(application_surface);
var screen_height = surface_get_height(application_surface);

if (global.gmui.frame_count == 1) {
	wins_frame = gmui_wins_node_create(0, global.gmui.style.menu_height + 32, screen_width, screen_height - (global.gmui.style.menu_height + 32));
	
	var split = gmui_wins_node_split(wins_frame, gmui_wins_split_dir.RIGHT, 0.7);
	var usageDemonstrationWindow = split[0];
	var inspectionWindow = split[1];
	
	gmui_wins_node_set(usageDemonstrationWindow, "Usage Demonstration Window");
	gmui_wins_node_set(inspectionWindow, "Inspection Window");
}

gmui_wins_node_update(wins_frame);
gmui_wins_handle_splitters(wins_frame);

if (gmui_begin_menu("Menu")) {
	gmui_menu_item("File");
	gmui_menu_item("About");
	gmui_end_menu();
}

if (gmui_begin("Toolbox Window", 0, global.gmui.style.menu_height, screen_width, 32, gmui_pre_window_flags.TOOLBOX)) {
	var old_spacing = global.gmui.style.item_spacing[0];
	global.gmui.style.item_spacing[0] = 0;
	
	global.gmui.current_window.dc.cursor_x = 4;
	global.gmui.current_window.dc.cursor_y = 0;
	
	gmui_image_button1(sIconHome, 0, 32, 32);
	gmui_same_line();
	gmui_image_button1(sIconFolder, 0, 32, 32);
	gmui_same_line();
	
	gmui_end();
	
	global.gmui.style.item_spacing[0] = old_spacing;
}

if (gmui_begin("Inspection Window", undefined, undefined, undefined, undefined, gmui_pre_window_flags.WINS_SET_VERTICAL)) {
	gmui_text_bullet("General Info");
	gmui_separator();
	
	gmui_text_wrap("GMUI is a feature-rich Immediate-Mode UI library for GameMaker.");
	gmui_text_wrap("It follows an immediate-mode architecture.");
	gmui_text_wrap("UI logic becomes predictable and easy to manage.");
	gmui_text_wrap("Complex interfaces are fully supported, including windows, layouts, tables, and charts.");
	
	gmui_end();
}

if (gmui_begin("Usage Demonstration Window", undefined, undefined, undefined, undefined, gmui_pre_window_flags.WINS_SET_VERTICAL)) {
	gmui_text_bullet("Usage Demonstrations");
	gmui_separator();
	
	gmui_cache_try("demo_tabs", [ "Buttons", "Checkboxes", "Radioboxes", "Text Inputs", "Progress Bars" ]);
	gmui_cache_try("tab_index", 0);
	
	gmui_cache_set("tab_index", gmui_tabs_fixed_width(gmui_cache_get("demo_tabs"), gmui_cache_get("tab_index"), 128));
	var tab_name = gmui_cache_get("demo_tabs")[gmui_cache_get("tab_index")];
	
	switch (tab_name) {
	case "Buttons": {
		gmui_separator_text1("Basic");
		gmui_button("Normal"); gmui_same_line();
		gmui_button_width("Fixed", 170); gmui_same_line();
		gmui_button_small("Small"); gmui_same_line();
		gmui_button_large("Large");
		gmui_button_width_fill("Fill");
		
		gmui_separator_text1("Arrow");
		gmui_arrow_button(gmui_arrow_direction.UP, 32, 32); gmui_same_line();
        gmui_arrow_button(gmui_arrow_direction.RIGHT, 32, 32); gmui_same_line();
        gmui_arrow_button(gmui_arrow_direction.DOWN, 32, 32); gmui_same_line();
        gmui_arrow_button(gmui_arrow_direction.LEFT, 32, 32);
        gmui_arrow_button_double_horizontal(48, 32); gmui_same_line();
        gmui_arrow_button_double_vertical(32, 48);
		
		gmui_separator_text1("Image");
		gmui_image_button(sIconHome); gmui_same_line();
		gmui_image_button1(sIconHome, 0, 32, 32);
		gmui_image_button_labeled(sIconFolder, "Labeled");
		gmui_image_button_tinted(sIconTick, 0, c_green); gmui_same_line();
		gmui_image_button_tinted(sIconCross, 0, c_red);
	} break;
	
	case "Checkboxes": {
	} break;
	};
	
	gmui_end();
}

gmui_demo();

// I'm too lazy to bring it further


















