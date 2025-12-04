gmui_update();

if (global.gmui.frame_count == 1) {
	winsFrame = gmui_wins_node_create(0, global.gmui.style.menu_height, surface_get_width(application_surface), surface_get_height(application_surface) - global.gmui.style.menu_height);
	
	var split = gmui_wins_node_split(winsFrame, gmui_wins_split_dir.DOWN, 0.3);
	var nodeExplorer = split[0];
	var node = split[1];
	
	split = gmui_wins_node_split(node, gmui_wins_split_dir.LEFT, 0.2);
	var nodeHierarchy = split[0];
	node = split[1];
	
	split = gmui_wins_node_split(node, gmui_wins_split_dir.RIGHT, 0.3);
	var nodeInfo = split[0];
	var nodeView = split[1];
	
	gmui_wins_node_set(nodeExplorer, "Explorer");
	gmui_wins_node_set(nodeHierarchy, "Hierarchy");
	gmui_wins_node_set(nodeInfo, "Info");
	gmui_wins_node_set(nodeView, "View");
}

gmui_wins_node_update(winsFrame);
gmui_wins_handle_splitters(winsFrame);

if (gmui_begin("Explorer", undefined, undefined, undefined, undefined, gmui_pre_window_flags.WINS_SET)) {
	gmui_text_bullet(global.gmui.current_window.name);
	gmui_end();
}

if (gmui_begin("Hierarchy", undefined, undefined, undefined, undefined, gmui_pre_window_flags.WINS_SET)) {
	gmui_text_bullet(global.gmui.current_window.name);
	gmui_end();
}

if (gmui_begin("Info", undefined, undefined, undefined, undefined, gmui_pre_window_flags.WINS_SET)) {
	gmui_text_bullet(global.gmui.current_window.name);
	gmui_end();
}

if (gmui_begin("View", undefined, undefined, undefined, undefined, gmui_pre_window_flags.WINS_SET)) {
	gmui_text_bullet(global.gmui.current_window.name);
	gmui_end();
}

if (gmui_begin_menu("Window Menu")) {
	gmui_menu_item("File");
	gmui_menu_item("Edit");
	gmui_menu_item("Help");
	gmui_end_menu();
}