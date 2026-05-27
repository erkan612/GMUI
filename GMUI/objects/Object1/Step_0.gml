gmui_update();

if (gmui_begin_popup("test popup", undefined, undefined, false)) {
	if (gmui_button_fill("Ok")) { gmui_popup_close("test popup"); };
	gmui_end_popup();
};

if (gmui_begin_context_menu("test context menu")) {
    if (gmui_context_menu_item("New File", "Ctrl+N")) {
        show_debug_message("New File");
    }
    if (gmui_context_menu_item("Open", "Ctrl+O")) {
        show_debug_message("Open");
    }
    
    gmui_separator_text("more stuff");
    
    menu_check = gmui_context_menu_item_checkbox("Enable Feature", menu_check);
    
    if (gmui_context_menu_item_radio("Option A", menu_radio == 0)) menu_radio = 0;
    if (gmui_context_menu_item_radio("Option B", menu_radio == 1)) menu_radio = 1;
	
    if (gmui_begin_context_menu_sub("sub_menu")) {
        gmui_context_menu_item("Sub Item 1");
        gmui_context_menu_item("Sub Item 2");
        gmui_context_menu_item("Sub Item 3");
        gmui_end_context_menu_sub("sub_menu");
    }
	
    gmui_separator_text("the end");
    
	gmui_end_context_menu();
};

if (mouse_check_button_released(mb_right)) {
	gmui_context_menu_open("test context menu");
};

if (gmui_begin_window("test window", 100, 100, 500, 300)) {
	//gmui_add_text("Hello World!", 10, 10);
	
	//global.gmui.current_container.use_scissor = true;
	//global.gmui.current_container.use_surface = true;
	//global.gmui.current_container.background_enabled = true;
	//global.gmui.current_container.mask_enabled = true;
	//global.gmui.current_container.z_interaction_enabled = true;
	
	tab_idx = gmui_tabs("settings", tab_idx, undefined, 20);
	
	if (gmui_button("open popup")) { gmui_popup_open("test popup"); };
	
	tx1 = gmui_textbox(tx1, "write something");
	tx2 = gmui_textbox(tx2, "write something");
	my_float = gmui_input_float(my_float, 0.01);
	my_int = gmui_input_int(my_int);
	
	//single_select = gmui_list_box(list_items, 12, single_select, false, -1, 100);
	gmui_text("Forced Single-Select ListBox");
	single_select = gmui_list_box(single_select, list_items, array_length(list_items), false);
	gmui_text("Optional Multi-Select ListBox");
	multi_select = gmui_list_box(multi_select, list_items, array_length(list_items), true);
	
	gmui_button_width("tettetet", 800);
	
	if (gmui_begin_container("wtwtwt", undefined, undefined, 200, 200)) {
		gmui_button_width("tettetet", 800);
		gmui_end_container();
	};
	
	if (gmui_begin_container("qwewqewqew")) {
		gmui_button_width("tettetet", 800);
		gmui_end_container();
	};
	
	gmui_progress_bar(35, 0, 100, 300, true);
	gmui_progress_bar_indeterminate();
	gmui_progress_spinner();
	gmui_progress_circular(65, 0, 100, 100, true);
	
	gmui_text("normal text");
	gmui_text_bullet("bullet text");
	gmui_text_colored("colored text", c_red);
	gmui_text_disabled("disabled text");
	gmui_text_label("label text", 22);
	if (gmui_text_clickable("clickable text")) { show_debug_message("kaboom!"); };
	gmui_tooltip("a text that is clickable", gmui_widget_get_last(), 500);
	if (gmui_text_clickable("clickable text1")) { show_debug_message("kaboom!1"); };
	gmui_tooltip("a text that is clickable1", gmui_widget_get_last(), 500);
	
	gmui_button("classic button");
	gmui_button_width("custom width button", 220);
	gmui_button_size("custom size button", 180, 180);
	//gmui_sameline();
	gmui_button_fill("fill button");
	gmui_button_arrow(0);
	gmui_sameline();
	gmui_button_arrow(1);
	gmui_sameline();
	gmui_button_arrow(2);
	gmui_sameline();
	gmui_button_arrow(3);
	gmui_sameline();
	gmui_button_minus();
	gmui_sameline();
	gmui_button_plus();
	
	toggled = gmui_toggle(toggled);
	
	volume = gmui_knob(volume, 0, 100, -1, "Volume");
	gmui_sameline();
	pan = gmui_knob(pan, -100, 100, 50, "Pan");
	
	my_palette_color = gmui_color_palette(my_palette_color, palette_colors, array_length(palette_colors));
	
	ms_selected = gmui_multiselect(ms_selected, ms_items, 8, -1, 200);
	
	if (gmui_button_fill("show notification(info)")) {
		gmui_toast_push("hey there!", "info");
	}
	
	if (gmui_button_fill("show notification(success)")) {
		gmui_toast_push("hey there!", "success");
	}
	
	if (gmui_button_fill("show notification(warning)")) {
		gmui_toast_push("hey there!", "warning");
	}
	
	if (gmui_button_fill("show notification(error)")) {
		gmui_toast_push("hey there!", "error");
	}
	
	gmui_text("Key-Value List");
	gmui_kv_list(properties, array_length(properties), -1);
	
	my_date = gmui_date_picker(my_date);
	gmui_text("Selected: " + string(my_date[2]) + "/" + string(my_date[1]) + "/" + string(my_date[0]));
	
	selected_option = gmui_radio_group(options, selected_option);
	gmui_text("Selected: " + options[selected_option]);
	
	combo_selected = gmui_combo(combo_selected, combo_items, 7);
	
	my_color = gmui_color_pick(my_color);
	
	gmui_separator();
	
	gmui_tree_begin("browser");

	if (gmui_tree_node("Folder A", true)) {
	    gmui_tree_leaf("File A1");
	    gmui_tree_leaf("File A2");
    
	    if (gmui_tree_node("Subfolder")) {
	        gmui_tree_leaf("File A3");
	        gmui_tree_leaf("File A4");
	        gmui_tree_node_end();
	    }
    
	    gmui_tree_node_end();
	}

	if (gmui_tree_node("Folder B")) {
	    gmui_tree_leaf("File B1");
	    gmui_tree_node_end();
	}

	gmui_tree_leaf("Root File 1");

	gmui_tree_end();
	
	gmui_separator();
	
	gmui_text("Line Plot");
    gmui_plot_lines(line_values, array_length(line_values), -1, 150, true);
    
    gmui_separator();
    
    gmui_text("Bar Chart");
    gmui_plot_bars(bar_values, array_length(bar_values), -1, 150);
    
    gmui_separator();
    
    gmui_text("Histogram (8 bins)");
    gmui_plot_histogram(hist_values, array_length(hist_values), -1, 150, 8);
    
    gmui_separator();
    
    gmui_text("Scatter Plot");
    gmui_plot_scatter(scatter_x, scatter_y, array_length(scatter_x), -1, 150);
    
    gmui_separator();
    
    gmui_text("Stem Plot");
    gmui_plot_stem(stem_vals, stem_lbls, array_length(stem_vals), -1, 150, 4, c_lime);
    
    gmui_separator();
    
    gmui_text("Stair Plot (POST)");
	gmui_plot_stair(stair_values, array_length(stair_values), -1, 150, "post");
    
    gmui_separator();
    
    gmui_text("Stair Plot (PRE)");
	gmui_plot_stair(stair_values, array_length(stair_values), -1, 150, "pre");
    
    gmui_separator();
    
    gmui_text("Pie Chart");
	gmui_plot_pie(pie_values, pie_labels, array_length(pie_values), 300, 200);
    
    gmui_separator();
    
    gmui_text("Donut Chart");
	gmui_plot_donut(pie_values, pie_labels, array_length(pie_values), 300, 200, 0.5);
    
    gmui_separator();
    
    gmui_text("Exploded Pie");
	gmui_plot_pie_exploded(pie_values, pie_labels, array_length(pie_values), 300, 200, false);
    
    gmui_separator();
    
    gmui_text("Area Chart");
	gmui_plot_area(area_series, 3, 10, -1, 150);
	
	gmui_separator();
    
    gmui_text("Stacked Bar Chart");
	gmui_plot_stacked_bars(stacked_series, 3, 8, -1, 150);
	
	gmui_separator();
    
    gmui_text("Grouped Bar Chart");
	gmui_plot_grouped_bars(grouped_series, 3, 8, -1, 150);
	
	gmui_separator();
    
    gmui_text("Heatmap Chart");
	gmui_plot_heatmap(heatmap_data, 8, 8, -1, -1);
	
	gmui_separator();
    
    gmui_text("Radar/Spider Chart");
	gmui_plot_radar(radar_series, 2, 6, radar_labels, 250);
	
	gmui_separator();
    
    gmui_text("Box Plot");
	gmui_plot_box(box_data, 3, box_labels, -1, 200);
	
	gmui_separator();
    
    gmui_text("Funnel Chart");
	gmui_plot_funnel(funnel_values, funnel_labels, 6, 300, 250);
	
	gmui_separator();
    
    gmui_text("Waterfall Chart");
	gmui_plot_waterfall(waterfall_values, waterfall_labels, 10, -1, 200);
	
	gmui_separator();
    
    gmui_text("Bubble Chart");
	gmui_plot_bubble(bubble_x, bubble_y, bubble_s, 10, -1, 200);
	
	gmui_separator();
    
    gmui_text("Gnatt Chart");
	gmui_plot_gantt(gantt_tasks, 6, gantt_starts, gantt_ends, undefined, 14, -1);
	
	gmui_separator();
    
    gmui_text("Error Bars");
	gmui_plot_error_bars(err_x, err_y, err_low, err_high, 6, -1, 200);
	
	gmui_separator();
    
    gmui_text("Gauge/Speedometer Chart");
	gmui_plot_gauge(gauge_value, 0, 100, "km/h", 200);
	gauge_value = gmui_slider(gauge_value, 0, 100, 200);
	
	gmui_separator();
    
    gmui_text("Table Plot");
	gmui_plot_table(tbl_headers, tbl_data, 6, 4, -1);
	
	gmui_separator();
	
	//gmui_begin_tab_bar("settings");
	//for (var i = 0; i < array_length(tab_names); i++) {
	//    gmui_tab_item(tab_names[i], i);
	//	gmui_sameline();
	//}
	//tab_idx = gmui_end_tab_bar();
	
	gmui_text("Hello World!");
	gmui_sameline();
	if (gmui_button("Click Me!")) { show_debug_message("Hello there!"); };
	gmui_button("Some Button");
	my_check = gmui_checkbox(my_check, "Some setting");
	my_slider_value = gmui_slider(my_slider_value, -50, 50);
	//my_text = gmui_textbox1(my_text, "say some!");
	
	if (gmui_begin_collapsing_header("Lines")) {
		if (gmui_begin_collapsing_header("Buttons")) {
			for (var i = 0; i < 300; i++) {
		        gmui_button("Button " + string(i));
		    };
			gmui_end_collapsing_header();
		};
		
		for (var i = 0; i < 300; i++) {
	        gmui_text("Line " + string(i));
	    };
		
		gmui_end_collapsing_header();
	};
	
	if (gmui_begin_collapsing_header("Selectables")) {
		for (var i = 0; i < 300; i++) {
	        if (gmui_selectable("Selectables " + string(i), selected_idx == i)) { selected_idx = i; };
	    };
		
		gmui_end_collapsing_header();
	};
	
	gmui_end_window();
};

/*
if (gmui_begin_container("a test", 750, 150, 300, 400)) {
	global.gmui.current_container.z_interaction_enabled = true;
	gmui_end_container();
};

if (gmui_begin_container("test", 100, 200, 700, 500)) {
	//gmui_add_text("Hello World!", 10, 10);
	
	//global.gmui.current_container.use_scissor = true;
	global.gmui.current_container.use_surface = true;
	global.gmui.current_container.background_enabled = true;
	global.gmui.current_container.mask_enabled = true;
	global.gmui.current_container.z_interaction_enabled = true;
	
	tx1 = gmui_textbox(tx1, "write something");
	tx2 = gmui_textbox(tx2, "write something");
	my_float = gmui_input_float(my_float);
	my_int = gmui_input_int(my_int);
	
	gmui_button_width("tettetet", 800);
	
	if (gmui_begin_container("wtwtwt")) {
		gmui_button_width("tettetet", 800);
		gmui_end_container();
	};
	
	gmui_progress_bar(35, 0, 100, 300, true);
	gmui_progress_bar_indeterminate();
	gmui_progress_spinner();
	gmui_progress_circular(65, 0, 100, 100, true);
	
	gmui_text("normal text");
	gmui_text_bullet("bullet text");
	gmui_text_colored("colored text", c_red);
	gmui_text_disabled("disabled text");
	gmui_text_label("label text", 22);
	if (gmui_text_clickable("clickable text")) { show_debug_message("kaboom!"); };
	gmui_tooltip("a text that is clickable", gmui_widget_get_last(), 500);
	
	gmui_button("classic button");
	gmui_button_width("custom width button", 220);
	gmui_button_size("custom size button", 180, 180);
	//gmui_sameline();
	gmui_button_fill("fill button");
	gmui_button_arrow(0);
	gmui_sameline();
	gmui_button_arrow(1);
	gmui_sameline();
	gmui_button_arrow(2);
	gmui_sameline();
	gmui_button_arrow(3);
	gmui_sameline();
	gmui_button_minus();
	gmui_sameline();
	gmui_button_plus();
	
	toggled = gmui_toggle(toggled);
	
	volume = gmui_knob(volume, 0, 100, -1, "Volume");
	gmui_sameline();
	pan = gmui_knob(pan, -100, 100, 50, "Pan");
	
	my_palette_color = gmui_color_palette(my_palette_color, palette_colors, array_length(palette_colors));
	
	ms_selected = gmui_multiselect(ms_items, 8, ms_selected, -1, 200);
	
	if (gmui_button_fill("show notification(info)")) {
		gmui_toast_push("hey there!", "info");
	}
	
	if (gmui_button_fill("show notification(success)")) {
		gmui_toast_push("hey there!", "success");
	}
	
	if (gmui_button_fill("show notification(warning)")) {
		gmui_toast_push("hey there!", "warning");
	}
	
	if (gmui_button_fill("show notification(error)")) {
		gmui_toast_push("hey there!", "error");
	}
	
	gmui_text("Key-Value List");
	gmui_kv_list(properties, array_length(properties), -1);
	
	my_date = gmui_date_picker(my_date);
	gmui_text("Selected: " + string(my_date[2]) + "/" + string(my_date[1]) + "/" + string(my_date[0]));
	
	selected_option = gmui_radio_group(options, selected_option);
	gmui_text("Selected: " + options[selected_option]);
	
	combo_selected = gmui_combo(combo_selected, combo_items, 7);
	
	my_color = gmui_color_pick(my_color);
	
	gmui_separator();
	
	gmui_tree_begin("browser");

	if (gmui_tree_node("Folder A", true)) {
	    gmui_tree_leaf("File A1");
	    gmui_tree_leaf("File A2");
    
	    if (gmui_tree_node("Subfolder")) {
	        gmui_tree_leaf("File A3");
	        gmui_tree_leaf("File A4");
	        gmui_tree_node_end();
	    }
    
	    gmui_tree_node_end();
	}

	if (gmui_tree_node("Folder B")) {
	    gmui_tree_leaf("File B1");
	    gmui_tree_node_end();
	}

	gmui_tree_leaf("Root File 1");

	gmui_tree_end();
	
	gmui_separator();
	
	gmui_text("Line Plot");
    gmui_plot_lines(line_values, array_length(line_values), -1, 150, true);
    
    gmui_separator();
    
    gmui_text("Bar Chart");
    gmui_plot_bars(bar_values, array_length(bar_values), -1, 150);
    
    gmui_separator();
    
    gmui_text("Histogram (8 bins)");
    gmui_plot_histogram(hist_values, array_length(hist_values), -1, 150, 8);
    
    gmui_separator();
    
    gmui_text("Scatter Plot");
    gmui_plot_scatter(scatter_x, scatter_y, array_length(scatter_x), -1, 150);
    
    gmui_separator();
    
    gmui_text("Stem Plot");
    gmui_plot_stem(stem_vals, stem_lbls, array_length(stem_vals), -1, 150, 4, c_lime);
    
    gmui_separator();
    
    gmui_text("Stair Plot (POST)");
	gmui_plot_stair(stair_values, array_length(stair_values), -1, 150, "post");
    
    gmui_separator();
    
    gmui_text("Stair Plot (PRE)");
	gmui_plot_stair(stair_values, array_length(stair_values), -1, 150, "pre");
    
    gmui_separator();
    
    gmui_text("Pie Chart");
	gmui_plot_pie(pie_values, pie_labels, array_length(pie_values), 300, 200);
    
    gmui_separator();
    
    gmui_text("Donut Chart");
	gmui_plot_donut(pie_values, pie_labels, array_length(pie_values), 300, 200, 0.5);
    
    gmui_separator();
    
    gmui_text("Exploded Pie");
	gmui_plot_pie_exploded(pie_values, pie_labels, array_length(pie_values), 300, 200, false);
    
    gmui_separator();
    
    gmui_text("Area Chart");
	gmui_plot_area(area_series, 3, 10, -1, 150);
	
	gmui_separator();
    
    gmui_text("Stacked Bar Chart");
	gmui_plot_stacked_bars(stacked_series, 3, 8, -1, 150);
	
	gmui_separator();
    
    gmui_text("Grouped Bar Chart");
	gmui_plot_grouped_bars(grouped_series, 3, 8, -1, 150);
	
	gmui_separator();
    
    gmui_text("Heatmap Chart");
	gmui_plot_heatmap(heatmap_data, 8, 8, -1, -1);
	
	gmui_separator();
    
    gmui_text("Radar/Spider Chart");
	gmui_plot_radar(radar_series, 2, 6, radar_labels, 250);
	
	gmui_separator();
    
    gmui_text("Box Plot");
	gmui_plot_box(box_data, 3, box_labels, -1, 200);
	
	gmui_separator();
    
    gmui_text("Funnel Chart");
	gmui_plot_funnel(funnel_values, funnel_labels, 6, 300, 250);
	
	gmui_separator();
    
    gmui_text("Waterfall Chart");
	gmui_plot_waterfall(waterfall_values, waterfall_labels, 10, -1, 200);
	
	gmui_separator();
    
    gmui_text("Bubble Chart");
	gmui_plot_bubble(bubble_x, bubble_y, bubble_s, 10, -1, 200);
	
	gmui_separator();
    
    gmui_text("Gnatt Chart");
	gmui_plot_gantt(gantt_tasks, 6, gantt_starts, gantt_ends, undefined, 14, -1);
	
	gmui_separator();
    
    gmui_text("Error Bars");
	gmui_plot_error_bars(err_x, err_y, err_low, err_high, 6, -1, 200);
	
	gmui_separator();
    
    gmui_text("Gauge/Speedometer Chart");
	gmui_plot_gauge(gauge_value, 0, 100, "km/h", 200);
	gauge_value = gmui_slider(gauge_value, 0, 100, 200);
	
	gmui_separator();
    
    gmui_text("Table Plot");
	gmui_plot_table(tbl_headers, tbl_data, 6, 4, -1);
	
	gmui_separator();
	
	//gmui_begin_tab_bar("settings");
	//for (var i = 0; i < array_length(tab_names); i++) {
	//    gmui_tab_item(tab_names[i], i);
	//	gmui_sameline();
	//}
	//tab_idx = gmui_end_tab_bar();
	
	gmui_text("Hello World!");
	gmui_sameline();
	if (gmui_button("Click Me!")) { show_debug_message("Hello there!"); };
	gmui_button("Some Button");
	my_check = gmui_checkbox(my_check, "Some setting");
	my_slider_value = gmui_slider(my_slider_value, -50, 50);
	//my_text = gmui_textbox1(my_text, "say some!");
	
	if (gmui_begin_collapsing_header("Lines")) {
		if (gmui_begin_collapsing_header("Buttons")) {
			for (var i = 0; i < 300; i++) {
		        gmui_button("Button " + string(i));
		    };
			gmui_end_collapsing_header();
		};
		
		for (var i = 0; i < 300; i++) {
	        gmui_text("Line " + string(i));
	    };
		
		gmui_end_collapsing_header();
	};
	
	if (gmui_begin_collapsing_header("Selectables")) {
		for (var i = 0; i < 300; i++) {
	        if (gmui_selectable("Selectables " + string(i), selected_idx == i)) { selected_idx = i; };
	    };
		
		gmui_end_collapsing_header();
	};
	
	gmui_end_container();
};