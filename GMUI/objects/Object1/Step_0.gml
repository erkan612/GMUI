gmui_update();
gmui_demo();
gmui_style_editor();

if (gmui_begin("test window", 100, 100, 500, 500)) {
	//if (gmui_begin_collapsing_header("test header")) {
	//	if (gmui_begin_sleeper("optimized zone")) {
	//		repeat (100) { gmui_button("Click Me!"); };
	//		gmui_end_sleeper();
	//	}
	//	gmui_end_collapsing_header();
	//}
	gmui_sleeper_header(
		"test sleeper header", 
		function() {
			str = gmui_textbox(str);
			va = gmui_input_int(va);
			vb = gmui_input_float(vb, 0.00000001, undefined, undefined, undefined, undefined, 8);
			color = gmui_color_picker_3(color);
			if (gmui_button("Click Me!")) { show_debug_message("Hello World!"); }
		}
	);
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
	
	if (gmui_begin_child("toolbar", gmui_get_available_width(), 32)) {
		gmui_style_push("container_padding_h", 2);
		gmui_style_push("element_spacing_h", 2);
		gmui_cursor_set_x(2);
		gmui_cursor_set_y(2);
		
		gmui_get().current_container.scrolling_enabled = false;
		
		gmui_button_icon1(GMUI_Icon);
		gmui_sameline();
		gmui_button_icon1(GMUI_Icon);
		gmui_separator_vertical();
		gmui_button_icon1(GMUI_Icon);
		
		gmui_style_pop("element_spacing_h");
		gmui_style_pop("container_padding_h");
		
		gmui_end_child();
	}
	if (gmui_begin_wins("main_split", gmui_split_dir.HORIZONTAL, [ 0.7, 0.3 ])) {
		if (gmui_begin_wins_pane(0)) {
			if (gmui_begin_wins("top_split", gmui_split_dir.VERTICAL, [ 0.2, 0.5, 0.3 ])) {
				if (gmui_begin_wins_pane(0, { use_surface: true, surface_flag: true, surface_sleep: true })) {
					left_panel_idx = gmui_tabs("left_panel", left_panel_idx, undefined, undefined, "editor_global_tab_group", undefined, gmui_tab_flags.LEAVE_ONE);
					handle_pane(gmui_tab_get_label("left_panel", left_panel_idx));
					
					gmui_end_wins_pane();
				}
		
				if (gmui_begin_wins_pane(1, { use_surface: true, surface_flag: true, surface_sleep: true })) {
					middle_panel_idx = gmui_tabs("middle_panel", middle_panel_idx, undefined, undefined, "editor_global_tab_group", undefined, gmui_tab_flags.LEAVE_ONE);
					handle_pane(gmui_tab_get_label("middle_panel", middle_panel_idx));
					
					gmui_end_wins_pane();
				}
		
				if (gmui_begin_wins_pane(2, { use_surface: true, surface_flag: true, surface_sleep: true })) {
					right_panel_idx = gmui_tabs("right_panel", right_panel_idx, undefined, undefined, "editor_global_tab_group", undefined, gmui_tab_flags.LEAVE_ONE);
					handle_pane(gmui_tab_get_label("right_panel", right_panel_idx));
					
					gmui_end_wins_pane();
				}
		
				gmui_end_wins();
			}
			
			gmui_end_wins_pane();
		}
		
		if (gmui_begin_wins_pane(1, { use_surface: true, surface_flag: true, surface_sleep: true })) {
			bottom_panel_idx = gmui_tabs("bottom_panel", bottom_panel_idx, undefined, undefined, "editor_global_tab_group", undefined, gmui_tab_flags.LEAVE_ONE);
			handle_pane(gmui_tab_get_label("bottom_panel", bottom_panel_idx));
			
			gmui_end_wins_pane();
		}
		
		gmui_end_wins();
	}
	
	gmui_end();
}