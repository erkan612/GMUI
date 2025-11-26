gmui_update();

gmui_demo();
var demoWindow = gmui_get_window("GMUI Demo & Documentation");

if (isFirstFrame) {
	demoWindow.open = !demoWindow.open;
	
	isFirstFrame = false;
};

gmui_add_modal("Message", function(window) {
	gmui_text("Hello World!");
	if (gmui_button_width_fill("OK")) { gmui_close_modal("Message"); };
});

gmui_add_modal("Hey!", function(window) {
	gmui_text("Hello " + txD1 + "!");
	if (gmui_button_width_fill("OK")) { gmui_close_modal("Hey!"); };
});

if (gmui_begin("Demo Window", 100, 100, 768, 256, gmui_window_flags.AUTO_VSCROLL | gmui_window_flags.AUTO_HSCROLL | gmui_window_flags.SCROLL_WITH_MOUSE_WHEEL)) {
	var oldSpacingX = global.gmui.style.item_spacing[0];
	var oldRounding = global.gmui.style.selectable_rounding;
	global.gmui.style.selectable_rounding = -1;
	global.gmui.style.item_spacing[0] = 0;
	if (gmui_selectable("Example 1", tabIdx == 1)) { tabIdx = 1; }; gmui_same_line();
	if (gmui_selectable("Example 2", tabIdx == 2)) { tabIdx = 2; }; gmui_same_line();
	if (gmui_selectable("Example 3", tabIdx == 3)) { tabIdx = 3; }; gmui_same_line();
	if (gmui_selectable("Example 4", tabIdx == 4)) { tabIdx = 4; }; gmui_same_line();
	if (gmui_selectable("Example 5", tabIdx == 5)) { tabIdx = 5; }; gmui_separator();
	global.gmui.style.item_spacing[0] = oldSpacingX;
	global.gmui.style.selectable_rounding = oldRounding;
	
	switch (tabIdx) {
	case 1: {
		if (gmui_button("Click Me!")) { gmui_open_modal("Message"); };
		if (gmui_button("Show/Hide Demo Window")) { demoWindow.open = !demoWindow.open; };
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
	};
	
	gmui_end();
};