gmui_update();

gmui_demo();
var demoWindow = gmui_get_window("GMUI Demo & Documentation");

if (global.gmui.frame_count == 1) {
	demoWindow.open = !demoWindow.open;
};

gmui_add_modal("Message", function(window) {
	gmui_text("Hello World!");
	if (gmui_button_width_fill("OK")) { gmui_close_modal("Message"); };
});

gmui_add_modal("Hey!", function(window) {
	gmui_text("Hello " + txD1 + "!");
	if (gmui_button_width_fill("OK")) { gmui_close_modal("Hey!"); };
});

gmui_add_context_menu("Context Menu", function(window) {
	gmui_context_menu_item("Item A");
	if (gmui_context_menu_item_sub("Sub 1")) {
		gmui_context_menu_item("Item 1");
		gmui_end();
	}
	gmui_separator();
	gmui_context_menu_item("Item B");
	if (gmui_context_menu_item_sub("Sub 2")) {
		gmui_context_menu_item("Item 2");
		gmui_end();
	}
	gmui_context_menu_item("Item C");
});

if (mouse_check_button_pressed(mb_right)) {
	gmui_open_context_menu("Context Menu");
};

gmui_add_context_menu("Menu Context File", function(window) {
	gmui_context_menu_item("New", "Ctrl+N");
	gmui_context_menu_item("Open", "Ctrl+O");
	gmui_context_menu_item("Save", "Ctrl+S");
	gmui_context_menu_item("Save As", "Ctrl+Shift+S");
	if (gmui_context_menu_item_sub("Recent Projects...")) {
		gmui_context_menu_item("C:\\user\\me\\editor");
		gmui_context_menu_item("C:\\user\\me\\loader");
		gmui_context_menu_item("C:\\user\\me\\test");
		gmui_end();
	}
});

gmui_add_context_menu("Menu Context Edit", function(window) {
	gmui_context_menu_item("Move");
	gmui_context_menu_item("Scale");
	gmui_context_menu_item("Rotate");
	gmui_context_menu_item("New Object");
	gmui_context_menu_item("Undo");
	gmui_context_menu_item("Redo");
});

if (gmui_begin_menu("test menu")) {
	gmui_menu_item("File", "Menu Context File");
	gmui_menu_item("Edit", "Menu Context Edit");
	gmui_end_menu();
};

if (gmui_begin("Demo Window", 100, 100, 768, 256, gmui_window_flags.AUTO_VSCROLL | gmui_window_flags.SCROLL_WITH_MOUSE_WHEEL)) {
	var oldSpacingX = global.gmui.style.item_spacing[0];
	var oldRounding = global.gmui.style.selectable_rounding;
	global.gmui.style.selectable_rounding = -1;
	global.gmui.style.item_spacing[0] = 0;
	if (gmui_selectable("Example 1", tabIdx == 1)) { tabIdx = 1; }; gmui_same_line();
	if (gmui_selectable("Example 2", tabIdx == 2)) { tabIdx = 2; }; gmui_same_line();
	if (gmui_selectable("Example 3", tabIdx == 3)) { tabIdx = 3; }; gmui_same_line();
	if (gmui_selectable("Example 4", tabIdx == 4)) { tabIdx = 4; }; gmui_same_line();
	if (gmui_selectable("Example 5", tabIdx == 5)) { tabIdx = 5; }; gmui_same_line();
	if (gmui_selectable("Example 6", tabIdx == 6)) { tabIdx = 6; }; gmui_separator();
	global.gmui.style.item_spacing[0] = oldSpacingX;
	global.gmui.style.selectable_rounding = oldRounding;
	
	switch (tabIdx) {
	case 1: {
		if (gmui_button("Click Me!")) { gmui_open_modal("Message"); };
		if (gmui_button("Show/Hide Demo Window")) { demoWindow.open = !demoWindow.open; gmui_bring_window_to_front(demoWindow); };
	} break;
	
	case 2: {
		gmui_text("Hello! I'm GMUI! and you?");
		txD1 = gmui_textbox(txD1, "Enter your name");
		if ((gmui_button("Enter") || (gmui_textbox_id() == gmui_get_focused_textbox_id() && keyboard_check_pressed(vk_enter))) && txD1 != "") {
			gmui_clear_textbox_focus();
			gmui_open_modal("Hey!");
		};
	} break;
	
	case 3: {
		var ac1 = gmui_collapsing_header("Vector 2", c1);
		c1 = ac1[0];
		if (c1) {
			gmui_text("X "); gmui_same_line(); v2[0] = gmui_input_int(v2[0]);
			gmui_same_line();
			gmui_text("Y "); gmui_same_line(); v2[1] = gmui_input_int(v2[1]);
			
			gmui_collapsing_header_end();
		};
		
		var ac2 = gmui_collapsing_header("Vector 3", c2);
		c2 = ac2[0];
		if (c2) {
			gmui_text("X "); gmui_same_line(); v3[0] = gmui_input_int(v3[0]);
			gmui_same_line();
			gmui_text("Y "); gmui_same_line(); v3[1] = gmui_input_int(v3[1]);
			gmui_same_line();
			gmui_text("Z "); gmui_same_line(); v3[2] = gmui_input_int(v3[2]);

			gmui_collapsing_header_end();
		};
		
		var ac3 = gmui_collapsing_header("Vector 4", c3);
		c3 = ac3[0];
		if (c3) {
			gmui_text("X "); gmui_same_line(); v4[0] = gmui_input_int(v4[0]);
			gmui_same_line();
			gmui_text("Y "); gmui_same_line(); v4[1] = gmui_input_int(v4[1]);
			gmui_same_line();
			gmui_text("Z "); gmui_same_line(); v4[2] = gmui_input_int(v4[2]);
			gmui_same_line();
			gmui_text("W "); gmui_same_line(); v4[3] = gmui_input_int(v4[3]);

			gmui_collapsing_header_end();
		};
	} break;
	
	case 4: {
		buttonc4 = gmui_color_button_4("Button Color 4", buttonc4);
		editc4 = gmui_color_edit_4("Edit 4", editc4);
	} break;
	
	case 5: {
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
		
		gmui_separator();
		
		var demo_items = ["Option 1", "Option 2", "Option 3", "Option 4", "Option 5"];
		
		combo_index = gmui_combo("Simple Combo", combo_index, demo_items);
	} break;
	
	case 6: {
		gmui_text("Lite Search Demonstration");
		searchText = gmui_textbox(searchText, "Search...", global.gmui.current_window.width - global.gmui.style.window_padding[0] * 2);
		if (gmui_textbox_id() == gmui_get_focused_textbox_id() && string_length(gmui_get_focused_textbox_text()) > 2 && keyboard_check(vk_anykey)) {
			searchResults = gmui_ls_search_hybrid(gmui_get_focused_textbox_text()); // update the list
			show_debug_message("List Updated! " + string(counter));
			counter++;
		}
		else if (string_length(gmui_get_focused_textbox_text()) <= 2 && array_length(searchResults) != 0) {
			searchResults = [ ];
		}
		if (array_length(searchResults) > 0) {
			array_foreach(searchResults, function(e, i) {
				gmui_text(e.document.text);
			});
		}
		else {
			array_foreach(ds_map_values_to_array(global.gmui.lite_search.documents), function(e, i) {
				gmui_text(e.text);
			});
		}
	} break;
	};
	
	gmui_end();
};