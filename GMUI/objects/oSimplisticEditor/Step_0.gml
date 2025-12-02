gmui_update();

if (global.gmui.frame_count == 1) {
	winsFrame = gmui_wins_node_create(0, 0, 1310, 700);
	
	var split = gmui_wins_node_split(winsFrame, gmui_wins_split_dir.LEFT, 0.2);
	var nodeDetails = split[0];
	var node = split[1];
	
	split = gmui_wins_node_split(node, gmui_wins_split_dir.LEFT, 0.7);
	var nodeView = split[0];
	var nodeInfo = split[1];
	
	gmui_wins_node_set(nodeDetails, "Details");
	gmui_wins_node_set(nodeView, "View");
	gmui_wins_node_set(nodeInfo, "Info");
}

var temp = gmui_get_window("View");
var viewCurrentSize = [ temp.width, temp.height ];
gmui_wins_node_update(winsFrame);
gmui_wins_handle_splitters(winsFrame);

gmui_add_modal("Change Object Name", function(window) {
	gmui_tab_width(8);
	
	gmui_text("Object Name");
	gmui_same_line();
	gmui_tab(13);
	objectCreateTextInput = gmui_textbox(objectCreateTextInput, "Enter a name..");
	if ((gmui_button_width_fill("OK") || (keyboard_check_pressed(vk_enter) && gmui_textbox_id() == gmui_get_focused_textbox_id()) || keyboard_check_pressed(vk_enter)) && objectCreateTextInput != "") {
		var index = GetObjectIndex(selectedObject);
		objects[index].name = objectCreateTextInput;
		selectedObject = objectCreateTextInput;
		
		gmui_close_modal("Change Object Name");
	};
}, undefined, undefined, undefined, undefined, gmui_pre_window_flags.MODAL_SET);

gmui_add_modal("Select an Object", function(window) {
	gmui_text_wrapped("Please select an object to delete");
	if (gmui_button_width_fill("OK")) { gmui_close_modal("Select an Object"); };
}, undefined, undefined, undefined, undefined, gmui_pre_window_flags.MODAL_SET);

gmui_add_modal("Delete Object", function(window) {
	gmui_text_wrapped("Are you sure you want to delete this object?");
	if (gmui_button_width_fill("Delete")) { array_delete(objects, GetObjectIndex(selectedObject), 1); selectedObject = undefined; gmui_close_modal("Delete Object"); };
	if (gmui_button_width_fill("Cancel")) { gmui_close_modal("Delete Object"); };
}, undefined, undefined, undefined, undefined, gmui_pre_window_flags.MODAL_SET);

gmui_add_modal("Create Object", function(window) {
	gmui_tab_width(8);
	
	gmui_text("Object Name");
	gmui_same_line();
	gmui_tab(13);
	objectCreateTextInput = gmui_textbox(objectCreateTextInput, "Enter a name..");
	
	var types = [ "Box", "Circle" ];
	gmui_text("Type");
	gmui_same_line();
	gmui_tab(13);
	objectCreateComboIndex = gmui_combo("", objectCreateComboIndex, types);
	
	if ((gmui_button_width_fill("OK") || (keyboard_check_pressed(vk_enter) && gmui_textbox_id() == gmui_get_focused_textbox_id()) || keyboard_check_pressed(vk_enter)) && objectCreateTextInput != "") {
		var selectedType = types[objectCreateComboIndex];
		
		var object = {
			name: objectCreateTextInput,
			type: selectedType,
			x: 100,
			y: 100,
			width: 100,
			height: 100,
		};
		
		array_push(objects, object);
		
		gmui_close_modal("Create Object");
	};
	if (gmui_button_width_fill("Cancel")) { gmui_close_modal("Create Object"); };
}, undefined, undefined, undefined, undefined, gmui_pre_window_flags.MODAL_SET);

if (gmui_begin("Details", undefined, undefined, undefined, undefined, gmui_pre_window_flags.WINS)) {
	gmui_text(gmui_get().current_window.name); 
	gmui_same_line(); 
	if (gmui_button("+", 16, 16)) {
		gmui_open_modal("Create Object");
	}
	gmui_same_line(); 
	if (gmui_button("-", 16, 16)) {
		if (selectedObject != undefined && selectedObject != "Root") { gmui_open_modal("Delete Object"); }else { gmui_open_modal("Select an Object"); };
	}
	gmui_separator();
	
	var treeNode = gmui_tree_node_begin("Root", selectedObject == "Root");
	selectedObject = treeNode[1] ? "Root" : selectedObject;
	
	if (treeNode[0]) {
		for (var i = 0; i < array_length(objects); i++) {
			var object = objects[i];
			if (gmui_tree_leaf(object.name, selectedObject == object.name)) { selectedObject = object.name; };
		};
	};
	
	gmui_tree_node_end();
	
	gmui_end();
};

if (gmui_begin("View", undefined, undefined, undefined, undefined, gmui_pre_window_flags.WINS)) {
	gmui_text(gmui_get().current_window.name);
	gmui_separator();
	
	var availableWidth = gmui_get().current_window.width - gmui_get().current_window.dc.cursor_x - gmui_get().style.window_padding[0];
	var availableHeight = gmui_get().current_window.height - gmui_get().current_window.dc.cursor_y - gmui_get().style.window_padding[1];
	if (!surface_exists(surfaceView)) {
		surfaceView = surface_create(availableWidth, availableHeight);
	}
	else if (gmui_get().current_window.width != viewCurrentSize[0] || gmui_get().current_window.height != viewCurrentSize[1]) {
		surface_free(surfaceView);
		surfaceView = surface_create(availableWidth, availableHeight);
	};
	gmui_surface(surfaceView);
	
	gmui_end();
};

if (gmui_begin("Info", undefined, undefined, undefined, undefined, gmui_pre_window_flags.WINS)) {
	gmui_text(gmui_get().current_window.name);
	gmui_separator();
	
	var object = GetObject(selectedObject);
	
	if (selectedObject != undefined && selectedObject != "Root" && object != undefined) {
		gmui_text(selectedObject);
		gmui_same_line();
		if (gmui_button("Change")) { gmui_open_modal("Change Object Name"); };
		
		var header = gmui_collapsing_header("Transform", collapsingHeaderOpenTransform);
		collapsingHeaderOpenTransform = header[1] ? !collapsingHeaderOpenTransform : collapsingHeaderOpenTransform;
		if (header[0]) {
			gmui_text("Position");
			gmui_text("X");
			gmui_same_line();
			object.x = gmui_input_int(object.x, undefined, -1000, 1000);
			gmui_same_line();
			gmui_text("Y");
			gmui_same_line();
			object.y = gmui_input_int(object.y, undefined, -1000, 1000);
			
			gmui_text("Size");
			gmui_text("W");
			gmui_same_line();
			object.width = gmui_input_int(object.width, undefined, -1000, 1000);
			gmui_same_line();
			gmui_text("H");
			gmui_same_line();
			object.height = gmui_input_int(object.height, undefined, -1000, 1000);
			
			gmui_collapsing_header_end();
		};
	}
	else {
		gmui_text_disabled("Select an object");
	};
	
	gmui_end();
};