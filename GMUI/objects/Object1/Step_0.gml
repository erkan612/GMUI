gmui_update();
//gmui_demo();
//gmui_style_editor();
//gmui_animation_demo();

if (gmui_begin("WINS Demo", 100, 100, 720, 360)) {
	if (gmui_begin_flex(gmui_split_dir.HORIZONTAL, [ 0.3, 0.4, 0.3 ], undefined, gmui_flow_direction.UP)) {
		if (gmui_begin_flex_child()) {
			gmui_button_size("Button on child 0!", gmui_get_available_width(), gmui_get_available_height());
			gmui_end_flex_child();
		}
		if (gmui_begin_flex(gmui_split_dir.VERTICAL, [ 0.3, 0.4, 0.3 ], undefined, gmui_flow_direction.RIGHT)) {
			if (gmui_begin_flex_child()) {
				gmui_button_size("Button on child 1:0!", gmui_get_available_width(), gmui_get_available_height());
				gmui_end_flex_child();
			}
			if (gmui_begin_flex_child()) {
				gmui_button_size("Button on child 1:1!", gmui_get_available_width(), gmui_get_available_height());
				gmui_end_flex_child();
			}
			if (gmui_begin_flex_child()) {
				gmui_button_size("Button on child 1:2!", gmui_get_available_width(), gmui_get_available_height());
				gmui_end_flex_child();
			}
			gmui_end_flex();
		}
		if (gmui_begin_flex_child()) {
			gmui_button_size("Button on child 2!", gmui_get_available_width(), gmui_get_available_height());
			gmui_end_flex_child();
		}
		gmui_end_flex();
	}
	gmui_end();
}

/*
if (gmui_begin("Demo", 100, 100, 360, 180)) {
	toggle = gmui_animated_toggle(toggle);
	
	gmui_end();
}

if (gmui_begin_context_menu("Ctx_File", 300)) {
	gmui_context_menu_item("New Project", "Ctrl+N");
	gmui_context_menu_item("Open Project", "Ctrl+O");
	gmui_context_menu_item("Import Project");
	if (gmui_begin_context_menu_sub("Recent Projects")) {
		gmui_context_menu_item("./TestProject.yyp");
		gmui_context_menu_item("./UIstuff.yyp");
		gmui_context_menu_item("./PlatformarSample.yyp");
		gmui_end_context_menu_sub();
	}
	
	gmui_context_menu_separator();
	
	gmui_context_menu_item("Save Project", "Ctrl+N");
	gmui_context_menu_item("Save Project As", "Ctrl+Shift+N");
	if (gmui_begin_context_menu_sub("Export Project As")) {
		gmui_context_menu_item("YYZ");
		gmui_context_menu_item("As Template");
		gmui_end_context_menu_sub();
	}
	
	gmui_context_menu_separator();
	gmui_context_menu_item("New IDE");
	
	gmui_context_menu_separator();
	gmui_context_menu_item("Preferences");
	
	gmui_context_menu_separator();
	gmui_context_menu_item("Exit");
	
	gmui_end_context_menu();
}

if (gmui_begin_context_menu("Ctx_Edit", 300)) {
	gmui_context_menu_item("Undo", "Ctrl+Z");
	gmui_context_menu_item("Redo", "Ctrl+Y");
	gmui_context_menu_item("Find & Replace", "Ctrl+Shift+F");
	
	gmui_end_context_menu();
}

if (gmui_begin_context_menu("Ctx_Windows", 300)) {
	gmui_context_menu_item_disabled("item disabled", "Ctrl+Ctrl");
	gmui_context_menu_item_checkbox_disabled("checkbox disabled", true);
	gmui_context_menu_item_checkbox_disabled("checkbox disabled", false);
	gmui_context_menu_item_radio_disabled("radio disabled", true);
	gmui_context_menu_item_radio_disabled("radio disabled", false);
	gmui_begin_context_menu_sub_disabled("sub disabled");
	
	gmui_end_context_menu();
}

if (gmui_begin_context_menu("Ctx_Help", 300)) {
	gmui_context_menu_item("Open Manual", "F1");
	gmui_context_menu_item("Open Welcome Tab");
	gmui_context_menu_item("Knowledge Base");
	gmui_context_menu_item("Contact Us");
	gmui_context_menu_item("Upload a Bug/Ticket Sample");
	gmui_context_menu_item("Report a GameMaker Bug");
	gmui_context_menu_item("Open Log in Explorer");
	gmui_context_menu_separator();
	gmui_context_menu_item("GameMaker.io");
	gmui_context_menu_item("GameMaker Community");
	gmui_context_menu_separator();
	gmui_context_menu_item("Release Notes");
	gmui_context_menu_item("Release SDKs");
	gmui_context_menu_separator();
	gmui_context_menu_item("Open Project in Explorer");
	gmui_context_menu_separator();
	gmui_context_menu_item("Refresh System Fonts");
	gmui_context_menu_item("Licenses");
	gmui_context_menu_item("Check for Update");
	gmui_context_menu_item("About");
	
	gmui_end_context_menu();
}

if (gmui_begin("editor", 100, 100, 1280, 720)) {
	gmui_window_menu([
		gmui_menu_item("File", "Ctx_File"),
		gmui_menu_item("Edit", "Ctx_Edit"),
		gmui_menu_item("Windows", "Ctx_Windows"),
		gmui_menu_item("Help", "Ctx_Help"),
	]);
	
	if (gmui_begin_wins("main_split", gmui_split_dir.HORIZONTAL, [ 0.7, 0.3 ])) {
		if (gmui_begin_wins_pane(0)) {
			if (gmui_begin_wins("top_split", gmui_split_dir.VERTICAL, [ 0.2, 0.5, 0.3 ])) {
				if (gmui_begin_wins_pane(0)) {
					gmui_end_wins_pane();
				}
		
				if (gmui_begin_wins_pane(1)) {
					gmui_end_wins_pane();
				}
		
				if (gmui_begin_wins_pane(2)) {
					gmui_end_wins_pane();
				}
		
				gmui_end_wins();
			}
			
			gmui_end_wins_pane();
		}
		
		if (gmui_begin_wins_pane(1)) {
			gmui_end_wins_pane();
		}
		
		gmui_end_wins();
	}
	
	gmui_end();
}