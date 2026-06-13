

// DEMO
function gmui_demo() {
    if (gmui_begin("GMUI Demo & Documentation", 50, 100, 800, 400)) {
        gmui_text("GMUI - Immediate-mode UI Framework for GameMaker");
        
        gmui_separator();
        
        gmui_separator_text_left("Display Widgets");
        
        if (gmui_begin_collapsing_header("Text & Label Widgets")) {
            if (gmui_begin_collapsing_header_ex("Basic Text")) {
                gmui_text("This is normal text using default style");
                gmui_text_disabled("This is disabled text (grayed out)");
                gmui_text_colored("This is colored text!", make_color_rgb(100, 200, 255));
                gmui_text_bullet("This is bullet point text");
                gmui_text_wrap("This is wrapped text that automatically breaks lines when it exceeds the container width. Useful for longer descriptions and help text.");
                gmui_text_label("FPS Counter", floor(fps_real));
                gmui_text_label("Mouse Position", string(device_mouse_x_to_gui(0)) + ", " + string(device_mouse_y_to_gui(0)));
                gmui_end_collapsing_header();
            }
            
            if (gmui_begin_collapsing_header_ex("Clickable Text", false)) {
                static click_count = 0;
                if (gmui_text_clickable("Click me! (This is clickable text)")) {
                    click_count++;
                    gmui_toast_push("Clickable text clicked! Count: " + string(click_count), "info");
                }
                gmui_text("Click count: " + string(click_count));
                
                if (gmui_text_clickable("Reset counter")) {
                    click_count = 0;
                    gmui_toast_push("Counter reset", "success");
                }
                gmui_end_collapsing_header();
            }
            
            if (gmui_begin_collapsing_header_ex("Images & Sprites", false)) {
                gmui_text("Image/Sprite display widget:");
				gmui_sameline();
                gmui_sprite(GMUI_Icon);
                gmui_end_collapsing_header();
            }
            
            gmui_end_collapsing_header();
        }
        
        if (gmui_begin_collapsing_header("Progress Indicators")) {
            static progress_linear = 0.65;
            static progress_circular = 0.75;
            static progress_anim = 0;
            static anim_timer = 0;
            
            if (gmui_begin_collapsing_header_ex("Linear Progress Bars")) {
                gmui_progress_bar(progress_linear, 0, 1, 300, true);
                gmui_progress_bar_indeterminate(300);
                gmui_text("Value control:");
                progress_linear = gmui_slider(progress_linear, 0, 1, 300);
                gmui_end_collapsing_header();
            }
            
            if (gmui_begin_collapsing_header_ex("Circular Progress")) {
                gmui_progress_circular(progress_circular, 0, 1, 60, true);
                gmui_sameline();
                gmui_progress_spinner(50, 4);
                gmui_sameline();
                gmui_spinner(24);
                gmui_text("Value control:");
                progress_circular = gmui_slider(progress_circular, 0, 1, 300);
                gmui_end_collapsing_header();
            }
            
            gmui_end_collapsing_header();
        }
        
        if (gmui_begin_collapsing_header("Separators & Layout Helpers")) {
            if (gmui_begin_collapsing_header_ex("Basic Separator")) {
                gmui_text("Above separator");
                gmui_separator();
                gmui_text("Below separator");
                gmui_end_collapsing_header();
            }
            
            if (gmui_begin_collapsing_header_ex("Text Separators")) {
                gmui_separator_text("Centered Text");
                gmui_separator_text_left("Left-Aligned Text");
                gmui_end_collapsing_header();
            }
            
            if (gmui_begin_collapsing_header_ex("Vertical Separator")) {
                gmui_text("Left side");
                gmui_separator_vertical(true);
                gmui_text("Right side");
                gmui_end_collapsing_header();
            }
            
            gmui_end_collapsing_header();
        }
        
        gmui_separator_text_left("Input Widgets");
        
        if (gmui_begin_collapsing_header("Buttons")) {
            if (gmui_begin_collapsing_header_ex("Standard Buttons")) {
                static button_count = 0;
                
                if (gmui_button("Normal Button")) {
                    button_count++;
                    gmui_toast_push("Normal button clicked!", "info");
                }
                gmui_sameline();
                if (gmui_button_primary("Primary Button")) {
                    gmui_toast_push("Primary action!", "success");
                }
				
                if (gmui_button_success("Success Button")) {
                    gmui_toast_push("Success action!", "success");
                }
                gmui_sameline();
                if (gmui_button_danger("Danger Button")) {
                    gmui_toast_push("Dangerous action!", "error");
                }
				
                if (gmui_button_ghost("Ghost Button")) {
                    gmui_toast_push("Ghost button clicked!", "info");
                }
                gmui_sameline();
                if (gmui_button_invisible("Invisible Button")) {
                    gmui_toast_push("Invisible button clicked!", "info");
                }
                
                gmui_text("Button click count: " + string(button_count));
                gmui_end_collapsing_header();
            }
            
            if (gmui_begin_collapsing_header_ex("Toggle & Loading Buttons")) {
                static toggle_state = false;
                static loading_state = false;
                
                toggle_state = gmui_button_toggle("Toggle Button", toggle_state);
                gmui_sameline();
                gmui_text(toggle_state ? "ON" : "OFF");
                
                if (gmui_button_loading("Loading Button", loading_state)) {
                    loading_state = true;
                    gmui_toast_push("Loading started...", "info");
                    gmui_add_call_function(function() {
                        gmui_add_call_function(function() {
                            gmui_toast_push("Loading complete!", "success");
                        });
                    });
                }
                
                gmui_end_collapsing_header();
            }
            
            if (gmui_begin_collapsing_header_ex("Hold and Repeat Buttons")) {
                static hold_triggered = false;
                static repeat_triggered = false;
                static repeat_count = 0;;
                
                if (gmui_button_hold("Hold to reset")) {
                    hold_triggered = true;
                    gmui_toast_push("Hold confirmed!", "success");
                }
                
                if (hold_triggered) {
                    gmui_text_colored("Repeat counter reset!", make_color_rgb(100, 255, 100));
                }
				
				repeat_triggered = gmui_button_repeat("Hold to Repeat");
				if (repeat_triggered) {
					repeat_count++;
                    gmui_text_colored($"Action count: {repeat_count}", make_color_rgb(100, 255, 100));
				}
                gmui_end_collapsing_header();
            }
            
            if (gmui_begin_collapsing_header_ex("Arrow & Icon Buttons")) {
                gmui_text("Arrow Buttons:");
                gmui_button_arrow_up(32, 32);
                gmui_sameline();
                gmui_button_arrow_down(32, 32);
                gmui_sameline();
                gmui_button_arrow_left(32, 32);
                gmui_sameline();
                gmui_button_arrow_right(32, 32);
                
                gmui_text("Plus/Minus Buttons:");
                gmui_button_plus(32, 32);
                gmui_sameline();
                gmui_button_minus(32, 32);
                
                gmui_text("Icon Button (with sprite):");
                gmui_button_icon(GMUI_Icon);
                gmui_button_icon1(GMUI_Icon);
                gmui_button_icon_text(GMUI_Icon, 0, "Icon Button", 150, 32);
                gmui_end_collapsing_header();
            }
            
            gmui_end_collapsing_header();
        }
        
        if (gmui_begin_collapsing_header("Checkboxes & Toggles")) {
            static check_normal = true;
            static check_success = false;
            static check_danger = false;
            static toggle_normal = false;
            static toggle_success = true;
            static toggle_danger = false;
            
            if (gmui_begin_collapsing_header_ex("Checkboxes")) {
                check_normal = gmui_checkbox(check_normal, "Normal Checkbox");
                check_success = gmui_checkbox_success(check_success, "Success Checkbox");
                check_danger = gmui_checkbox_danger(check_danger, "Danger Checkbox");
                gmui_checkbox_disabled(true, "Disabled Checkbox (checked)");
                gmui_checkbox_disabled(false, "Disabled Checkbox (unchecked)");
                gmui_end_collapsing_header();
            }
            
            if (gmui_begin_collapsing_header_ex("Toggle Switches")) {
                toggle_normal = gmui_toggle(toggle_normal);
                gmui_sameline();
                gmui_text("Normal Toggle");
                
                toggle_success = gmui_toggle_success(toggle_success);
                gmui_sameline();
                gmui_text("Success Toggle");
                
                toggle_danger = gmui_toggle_danger(toggle_danger);
                gmui_sameline();
                gmui_text("Danger Toggle");
                
                gmui_toggle_disabled(true);
                gmui_sameline();
                gmui_text("Disabled Toggle (ON)");
                
                gmui_toggle_disabled(false);
                gmui_sameline();
                gmui_text("Disabled Toggle (OFF)");
                gmui_end_collapsing_header();
            }
            
            gmui_end_collapsing_header();
        }
        
        if (gmui_begin_collapsing_header("Selection Widgets")) {
            if (gmui_begin_collapsing_header_ex("Radio Buttons")) {
                static radio_selected = 0;
                
                gmui_text("Individual Radio Buttons:");
                if (gmui_radio("Option A", radio_selected == 0)) radio_selected = 0;
                gmui_sameline();
                if (gmui_radio("Option B", radio_selected == 1)) radio_selected = 1;
                gmui_sameline();
                if (gmui_radio("Option C", radio_selected == 2)) radio_selected = 2;
                
                gmui_text("Radio Group:");
                static radio_options = ["Apple", "Banana", "Cherry", "Date"];
                static radio_group_selected = 0;
                radio_group_selected = gmui_radio_group(radio_options, radio_group_selected);
                gmui_text("Selected: " + radio_options[radio_group_selected]);
                
                gmui_radio_disabled("Disabled Radio", false);
                gmui_end_collapsing_header();
            }
            
            if (gmui_begin_collapsing_header_ex("Selectable List")) {
                static selectable_items = ["Item A", "Item B", "Item C", "Item D", "Item E"];
                static selectable_selected = 0;
                
                for (var i = 0; i < 5; i++) {
                    if (gmui_selectable(selectable_items[i], selectable_selected == i, 150)) {
                        selectable_selected = i;
                    }
                    gmui_sameline();
                }
                gmui_text("Selected: " + selectable_items[selectable_selected]);
                gmui_selectable_disabled("Disabled Item", false, 150);
                gmui_end_collapsing_header();
            }
            
            if (gmui_begin_collapsing_header_ex("Combo Box (Dropdown)")) {
                static combo_items = ["Red", "Green", "Blue", "Yellow", "Purple", "Orange"];
                static combo_selected = 0;
                
                combo_selected = gmui_combo(combo_selected, combo_items, 6, "Select color...", 200);
                gmui_text("Selected: " + combo_items[combo_selected]);
                gmui_combo_disabled(2, combo_items, 6, "Disabled Combo", 200);
                gmui_end_collapsing_header();
            }
            
            gmui_end_collapsing_header();
        }
        
        if (gmui_begin_collapsing_header("Text & Numeric Inputs")) {
            if (gmui_begin_collapsing_header_ex("Textboxes")) {
                static text_normal = "Hello GMUI!";
                static text_placeholder = "";
                static text_password = "";
                
                text_normal = gmui_textbox(text_normal, "Enter text...", 300);
                text_placeholder = gmui_textbox(text_placeholder, "Type something here", 300);
                gmui_textbox_disabled("Disabled textbox content", "Placeholder", 300);
                gmui_text("Text length: " + string(string_length(text_normal)));
                gmui_end_collapsing_header();
            }
            
            if (gmui_begin_collapsing_header_ex("Numeric Inputs (Drag-enabled)")) {
                static int_value = 42;
                static float_value = 3.14159;
                static range_value = 50;
                
                gmui_text("Integer Input (drag right side):");
                int_value = gmui_input_int(int_value, 1, -100, 100, 150);
                
                gmui_text("Float Input:");
                float_value = gmui_input_float(float_value, 0.1, -1000, 1000, 150);
                
                gmui_text("Bounded Range:");
                range_value = gmui_input_int(range_value, 5, 0, 100, 150);
                
                gmui_input_int_disabled(75, 150);
                gmui_input_float_disabled(3.14159, 150);
                
                gmui_end_collapsing_header();
            }
            
            if (gmui_begin_collapsing_header_ex("Sliders")) {
                static slider_val = 50;
				
				gmui_text("Basic");
				slider_val = gmui_slider(slider_val, 0, 100, 300);
				
				gmui_text("Disabled (Grayed Out)");
                gmui_slider_disabled(75, 0, 100, 300);
                gmui_end_collapsing_header();
            }
            
            if (gmui_begin_collapsing_header_ex("Knobs (Rotary Dials)")) {
                static knob_volume = 75;
                static knob_pan = 0;
                static knob_treble = 50;
                
                knob_volume = gmui_knob(knob_volume, 0, 100, 80, "Volume");
                gmui_sameline();
                knob_pan = gmui_knob(knob_pan, -100, 100, 80, "Pan");
                gmui_sameline();
                knob_treble = gmui_knob(knob_treble, 0, 100, 80, "Treble");
                
                gmui_text("Volume: " + string(knob_volume) + "%");
                gmui_end_collapsing_header();
            }
            
            gmui_end_collapsing_header();
        }
        
        gmui_separator_text_left("Advanced Widgets");
        
        if (gmui_begin_collapsing_header("Color Widgets")) {
            if (gmui_begin_collapsing_header_ex("Color Picker")) {
                static color = gmui_make_color_rgba(100, 150, 255, 255);
				var color_array = gmui_color_rgba_to_array(color);
				gmui_text("Red:"); gmui_sameline(); color_array[0] = gmui_input_int(color_array[0], 1, 0, 255);
				gmui_sameline();
				gmui_text("Green:"); gmui_sameline(); color_array[1] = gmui_input_int(color_array[1], 1, 0, 255);
				gmui_sameline();
				gmui_text("Blue:"); gmui_sameline(); color_array[2] = gmui_input_int(color_array[2], 1, 0, 255);
				gmui_sameline();
				gmui_text("Alpha:"); gmui_sameline(); color_array[3] = gmui_input_int(color_array[3], 1, 0, 255);
                color = gmui_color_rgba_from_array(color_array);
                color = gmui_color_pick(color, "demo_picker");
                gmui_end_collapsing_header();
            }
            
            if (gmui_begin_collapsing_header_ex("Color Palette")) {
                static palette_colors = [
                    make_color_rgb(255, 100, 100), make_color_rgb(100, 255, 100),
                    make_color_rgb(100, 100, 255), make_color_rgb(255, 255, 100),
                    make_color_rgb(255, 100, 255), make_color_rgb(100, 255, 255),
                    make_color_rgb(255, 200, 100), make_color_rgb(200, 100, 255),
                    make_color_rgb(100, 200, 200), make_color_rgb(200, 200, 100),
                    make_color_rgb(200, 100, 200), make_color_rgb(150, 150, 150)
                ];
                static palette_selected = palette_colors[0];
                
                palette_selected = gmui_color_palette(palette_selected, palette_colors, 12, 6);
                gmui_text("Selected: ");
                var r = color_get_red(palette_selected);
                var g = color_get_green(palette_selected);
                var b = color_get_blue(palette_selected);
				gmui_color_button(gmui_make_color_rgba(r, g, b, 255));
                gmui_end_collapsing_header();
            }
            
            if (gmui_begin_collapsing_header_ex("Color Button")) {
                static demo_color = gmui_make_color_rgba(100, 200, 100, 255);
                static click_log = "";
                
                if (gmui_color_button(demo_color, 32)) {
                    click_log = "Color button clicked!";
                }
                gmui_sameline();
                gmui_text(click_log);
                gmui_end_collapsing_header();
            }
            
            gmui_end_collapsing_header();
        }
        
        if (gmui_begin_collapsing_header("List & Multi-Select Widgets")) {
            if (gmui_begin_collapsing_header_ex("List Box (Single Select)")) {
                static list_items = ["Apple", "Banana", "Cherry", "Date", "Elderberry", "Fig", "Grape"];
                static single_select = 0;
                
                single_select = gmui_list_box(single_select, list_items, 7, false, 200);
                gmui_text("Selected: " + list_items[single_select]);
                gmui_end_collapsing_header();
            }
            
            if (gmui_begin_collapsing_header_ex("List Box (Multi-Select, Control, Shift, Control+Shift)")) {
                static multi_items = ["Apple", "Banana", "Cherry", "Date", "Elderberry"];
                static multi_select = ds_map_create();
                
                static multi_init = false;
                if (!multi_init) {
                    ds_map_add(multi_select, "Apple", true);
                    ds_map_add(multi_select, "Cherry", true);
					multi_init = true;
                }
                
                multi_select = gmui_list_box(multi_select, multi_items, 5, true, 200);
                
                var count = 0;
                var selected_str = "";
                for (var i = 0; i < 5; i++) {
                    if (ds_map_exists(multi_select, multi_items[i])) {
                        count++;
                        if (selected_str != "") selected_str += ", ";
                        selected_str += multi_items[i];
                    }
                }
                gmui_text(string(count) + " items selected: " + selected_str);
                gmui_end_collapsing_header();
            }
            
            if (gmui_begin_collapsing_header_ex("Multi-Select Custom")) {
                static ms_items = ["Option 1", "Option 2", "Option 3", "Option 4", "Option 5", "Option 6"];
                static ms_selected = ds_map_create();
                
                static ms_init = false;
                if (!ms_init) {
                    ds_map_add(ms_selected, "Option 2", true);
                    ds_map_add(ms_selected, "Option 4", true);
					ms_init = true;
                }
                
                ms_selected = gmui_multiselect(ms_selected, ms_items, 6, 220, 150);
                
                var ms_count = 0;
                for (var i = 0; i < 6; i++) {
                    if (ds_map_exists(ms_selected, ms_items[i])) ms_count++;
                }
                gmui_text(string(ms_count) + " of 6 selected");
                gmui_end_collapsing_header();
            }
            
            if (gmui_begin_collapsing_header_ex("Key-Value List")) {
                static kv_data = [
                    ["Name", "GMUI"],
                    ["Version", "2.x"],
                    ["Author", "erkan612"],
                    ["License", "MIT"],
                    ["Widgets", "50+"],
                    ["Plots", "20+"],
                    ["Status", "Active"]
                ];
                gmui_kv_list(kv_data, 7);
                gmui_end_collapsing_header();
            }
            
            gmui_end_collapsing_header();
        }
        
        if (gmui_begin_collapsing_header("Date & Time Widgets")) {
            static selected_date = [date_get_year(date_current_datetime()),
                                    date_get_month(date_current_datetime()),
                                    date_get_day(date_current_datetime())];
            
            selected_date = gmui_date_picker(selected_date);
            gmui_text("Selected Date: " + string(selected_date[2]) + "/" +
                     string(selected_date[1]) + "/" + string(selected_date[0]));
            gmui_end_collapsing_header();
        }
        
        if (gmui_begin_collapsing_header("Tree View")) {
            static tree_selected = -1;
            
            gmui_begin_tree("demo_tree");
            
            if (gmui_begin_tree_node("Project Files")) {
                gmui_tree_leaf("main.gml");
                gmui_tree_leaf("player.gml");
                gmui_tree_leaf("enemy.gml");
                
                if (gmui_begin_tree_node("Assets")) {
                    gmui_tree_leaf("player_sprite.png");
                    gmui_tree_leaf("background.png");
                    gmui_tree_leaf("tileset.png");
                    
                    if (gmui_begin_tree_node("Audio")) {
                        gmui_tree_leaf("music.ogg");
                        gmui_tree_leaf("sfx_jump.wav");
                        gmui_tree_leaf("sfx_coin.wav");
                        gmui_end_tree_node();
                    }
                    gmui_end_tree_node();
                }
                gmui_end_tree_node();
            }
            
            if (gmui_begin_tree_node("Settings")) {
                gmui_tree_leaf("config.ini");
                gmui_tree_leaf("keybinds.json");
                gmui_tree_leaf("graphics.ini");
                gmui_end_tree_node();
            }
            
            gmui_tree_leaf("README.md");
            gmui_tree_leaf("LICENSE");
            
            gmui_end_tree();
            
            gmui_end_collapsing_header();
        }
        
        if (gmui_begin_collapsing_header("Tabs")) {
            static tab_labels = ["Widgets", "Layout", "Style", "Info"];
            static selected_tab = 0;
			static tab_init = false;
            
			if (!tab_init) {
				gmui_tab_add("demo_tabs", "Widgets");
				gmui_tab_add("demo_tabs", "Layout");
				gmui_tab_add("demo_tabs", "Style");
				gmui_tab_add("demo_tabs", "Info");
				tab_init = true;
			}
			
            selected_tab = gmui_tabs("demo_tabs", selected_tab, -1, -1, "tab_demo_group");
			var tab_name = gmui_tab_get_label("demo_tabs", selected_tab);
            
            if (tab_name == "Widgets") {
                gmui_text("Widgets Tab Content");
                static demo_check = false;
                demo_check = gmui_checkbox(demo_check, "Example checkbox");
                if (gmui_button("Example Button")) {
                    gmui_toast_push("Button in tab clicked!", "info");
                }
            } else if (tab_name == "Layout") {
                gmui_text("Layout Tab Content");
                gmui_text("Demonstrating nested content in tabs");
                if (gmui_begin_collapsing_header("Nested Section", false)) {
                    gmui_text("This is inside a collapsing header within a tab!");
                    gmui_end_collapsing_header();
                }
            } else if (tab_name == "Style") {
                gmui_text("Style Tab Content");
                gmui_text("Style customization options would go here");
                static style_preview = 50;
                style_preview = gmui_slider(style_preview, 0, 100, 200);
            } else if (tab_name == "Info") {
                gmui_text("Info Tab Content");
                gmui_text("Tab system supports:");
                gmui_text_bullet("Drag & drop reordering");
                gmui_text_bullet("Close buttons");
                gmui_text_bullet("Tab groups for cross-bar dragging");
                gmui_text_bullet("Detaching tabs to floating windows");
            }
            
            gmui_end_collapsing_header();
        }
        
        gmui_separator_text_left("Plot Widgets");
        
        if (gmui_begin_collapsing_header("Line & Bar Charts")) {
            static line_data = [25, 45, 30, 60, 40, 80, 55, 35, 70, 50, 65, 40];
            static bar_data = [120, 200, 150, 80, 240, 180, 90, 160];
            
            if (gmui_begin_collapsing_header_ex("Line Plot")) {
                gmui_plot_lines(line_data, 12, -1, 150, true);
                gmui_end_collapsing_header();
            }
            
            if (gmui_begin_collapsing_header_ex("Bar Chart")) {
                gmui_plot_bars(bar_data, 8, -1, 150);
                gmui_end_collapsing_header();
            }
            
            if (gmui_begin_collapsing_header_ex("Histogram")) {
                static hist_data = [5, 12, 8, 15, 9, 11, 7, 13, 10, 6, 14, 8, 12, 9, 11, 7, 10, 13, 8, 6];
                gmui_plot_histogram(hist_data, 20, -1, 150, 8);
                gmui_end_collapsing_header();
            }
            
            if (gmui_begin_collapsing_header_ex("Scatter Plot")) {
                static scatter_x = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
                static scatter_y = [2, 4, 5, 4, 5, 7, 8, 7, 9, 8, 10, 9, 12, 11, 13];
                gmui_plot_scatter(scatter_x, scatter_y, 15, -1, 150);
                gmui_end_collapsing_header();
            }
            
            gmui_end_collapsing_header();
        }
        
        if (gmui_begin_collapsing_header("Pie & Donut Charts")) {
            static pie_values = [25, 20, 15, 30, 10];
            static pie_labels = ["Red", "Blue", "Green", "Yellow", "Purple"];
            
            if (gmui_begin_collapsing_header_ex("Pie Chart")) {
                gmui_plot_pie(pie_values, pie_labels, 5, -1, 200, true);
                gmui_end_collapsing_header();
            }
            
            if (gmui_begin_collapsing_header_ex("Donut Chart")) {
                gmui_plot_donut(pie_values, pie_labels, 5, -1, 200, 0.5, true);
                gmui_end_collapsing_header();
            }
            
            if (gmui_begin_collapsing_header_ex("Exploded Pie")) {
                gmui_plot_pie_exploded(pie_values, pie_labels, 5, -1, 200, false, true);
                gmui_end_collapsing_header();
            }
            
            gmui_end_collapsing_header();
        }
        
        if (gmui_begin_collapsing_header("Area & Stacked Charts")) {
            if (gmui_begin_collapsing_header_ex("Area Chart")) {
                static area_series = [
                    [10, 20, 30, 25, 35, 45, 40, 50, 45, 55],
                    [25, 35, 40, 45, 50, 55, 60, 65, 55, 70],
                    [40, 50, 55, 60, 65, 70, 75, 80, 70, 85]
                ];
                gmui_plot_area(area_series, 3, 10, -1, 150);
                gmui_end_collapsing_header();
            }
            
            if (gmui_begin_collapsing_header_ex("Stacked Bar Chart")) {
                static stacked_series = [
                    [20, 35, 30, 45, 25, 40, 35, 30],
                    [15, 25, 20, 30, 35, 20, 25, 30],
                    [10, 15, 25, 20, 15, 25, 20, 15]
                ];
                gmui_plot_stacked_bars(stacked_series, 3, 8, -1, 150);
                gmui_end_collapsing_header();
            }
            
            if (gmui_begin_collapsing_header_ex("Grouped Bar Chart")) {
                static grouped_series = [
                    [45, 60, 55, 70, 50, 65, 75, 55],
                    [30, 45, 40, 55, 35, 50, 60, 40],
                    [20, 30, 25, 40, 30, 35, 45, 30]
                ];
                gmui_plot_grouped_bars(grouped_series, 3, 8, -1, 150);
                gmui_end_collapsing_header();
            }
            
            gmui_end_collapsing_header();
        }
        
        if (gmui_begin_collapsing_header("Specialized Charts")) {
            if (gmui_begin_collapsing_header_ex("Heatmap")) {
                static heatmap_data = [
                    [5, 12, 8, 15, 9, 11, 7, 13],
                    [10, 6, 14, 8, 12, 9, 11, 7],
                    [15, 9, 11, 7, 13, 10, 6, 14],
                    [8, 12, 9, 11, 7, 13, 10, 6],
                    [14, 8, 12, 9, 11, 7, 13, 10],
                    [6, 14, 8, 12, 9, 11, 7, 13]
                ];
                gmui_plot_heatmap(heatmap_data, 6, 8, -1, -1);
                gmui_end_collapsing_header();
            }
            
            if (gmui_begin_collapsing_header_ex("Radar/Spider Chart")) {
                static radar_series = [
                    [80, 90, 60, 70, 85, 75],
                    [50, 70, 80, 60, 55, 65]
                ];
                static radar_labels = ["Speed", "Power", "Defense", "Agility", "Stamina", "Magic"];
                gmui_plot_radar(radar_series, 2, 6, radar_labels, 250);
                gmui_end_collapsing_header();
            }
            
            if (gmui_begin_collapsing_header_ex("Gauge/Speedometer")) {
                static gauge_value = 65;
                gauge_value = gmui_plot_gauge(gauge_value, 0, 100, "km/h", 150);
				gmui_text("Value:");
				gmui_sameline();
                gauge_value = gmui_slider(gauge_value, 0, 100, 200);
                gmui_end_collapsing_header();
            }
            
            if (gmui_begin_collapsing_header_ex("Waterfall Chart")) {
                static waterfall_values = [100, -30, 50, -20, 40, -10, 30, -15, 25, 60];
                static waterfall_labels = ["Start", "Costs", "Sales", "Returns", "Refunds", "Fees", "Tax", "Adj", "Bonus", "Total"];
                gmui_plot_waterfall(waterfall_values, waterfall_labels, 10, -1, 150);
                gmui_end_collapsing_header();
            }
            
            if (gmui_begin_collapsing_header_ex("Box Plot")) {
                static box_data = [
                    [45, 52, 48, 55, 50, 47, 53, 49, 51, 46, 54, 50, 48, 52, 49],
                    [60, 65, 58, 62, 70, 63, 61, 59, 64, 66, 62, 68, 60, 63, 61],
                    [40, 42, 38, 45, 43, 41, 39, 44, 42, 40, 43, 41, 38, 44, 42]
                ];
                static box_labels = ["Group A", "Group B", "Group C"];
                gmui_plot_box(box_data, 3, box_labels, -1, 150);
                gmui_end_collapsing_header();
            }
            
            if (gmui_begin_collapsing_header_ex("Funnel Chart")) {
                static funnel_values = [1000, 800, 600, 400, 200, 50];
                static funnel_labels = ["Views", "Clicks", "Signups", "Trials", "Purchases", "Renewals"];
                gmui_plot_funnel(funnel_values, funnel_labels, 6, -1, 150);
                gmui_end_collapsing_header();
            }
            
            if (gmui_begin_collapsing_header_ex("Table Plot")) {
                static tbl_headers = ["Name", "Score", "Rank", "Status"];
                static tbl_data = [
                    ["Alice", "95", "1st", "Pass"],
                    ["Bob", "87", "2nd", "Pass"],
                    ["Charlie", "78", "3rd", "Pass"],
                    ["Diana", "72", "4th", "Pass"],
                    ["Eve", "65", "5th", "Fail"]
                ];
                gmui_plot_table(tbl_headers, tbl_data, 5, 4, -1);
                gmui_end_collapsing_header();
            }
            
            if (gmui_begin_collapsing_header_ex("Legend")) {
                static legend_labels = ["Series A", "Series B", "Series C", "Series D"];
                static legend_colors = [
                    make_color_rgb(255, 100, 100),
                    make_color_rgb(100, 200, 255),
                    make_color_rgb(100, 255, 100),
                    make_color_rgb(255, 200, 50)
                ];
                gmui_plot_legend(legend_labels, legend_colors, 4, 2, 300);
                gmui_end_collapsing_header();
            }
            
            gmui_end_collapsing_header();
        }
        
        gmui_separator_text_left("Other Features");
        
        if (gmui_begin_collapsing_header("Tooltips")) {
            gmui_text("Hover over the buttons below to see tooltips:");
            
            if (gmui_button("Button with Tooltip")) {
                gmui_toast_push("Button clicked!", "info");
            }
            gmui_tooltip("This is a standard tooltip that appears after a short delay", gmui_widget_get_last(), 250);
            
            gmui_sameline();
            if (gmui_button_primary("Another Button")) {
                gmui_toast_push("Another button clicked!", "info");
            }
            gmui_tooltip("Tooltips can have custom width and will auto-wrap text", gmui_widget_get_last(), 250);
            
            gmui_text("Clickable text with tooltip:");
            if (gmui_text_clickable("Click here")) {
                gmui_toast_push("Text clicked!", "info");
            }
            gmui_tooltip("This tooltip is attached to clickable text", gmui_widget_get_last(), 250);
            
            gmui_end_collapsing_header();
        }
        
        if (gmui_begin_collapsing_header("Toast Notifications")) {
            gmui_text("Click buttons to show different toast types:");
            
            if (gmui_button("Info Toast")) {
                gmui_toast_push("This is an informational message", "info");
            }
            gmui_sameline();
            if (gmui_button_success("Success Toast")) {
                gmui_toast_push("Operation completed successfully!", "success");
            }
            gmui_sameline();
            if (gmui_button_danger("Error Toast")) {
                gmui_toast_push("Something went wrong!", "error");
            }
            gmui_sameline();
            if (gmui_button_primary("Warning Toast")) {
                gmui_toast_push("This is a warning message", "warning");
            }
            
            gmui_text("Custom duration toast (5 seconds):");
            if (gmui_button("Long Toast")) {
                gmui_toast_push("This toast stays for 5 seconds", "info", 5000);
            }
            
            gmui_end_collapsing_header();
        }
        
        if (gmui_begin_collapsing_header("Context Menus")) {
            gmui_text("Right-click to open a context menu!");
            
            if (mouse_check_button_released(mb_right)) {
                gmui_context_menu_open("demo_context_menu");
            }
            
            if (gmui_begin_context_menu("demo_context_menu", 180, 200)) {
                if (gmui_context_menu_item("New File", "Ctrl+N")) {
                    gmui_toast_push("New File", "info");
                }
                if (gmui_context_menu_item("Open", "Ctrl+O")) {
                    gmui_toast_push("Open", "info");
                }
                if (gmui_context_menu_item("Save", "Ctrl+S")) {
                    gmui_toast_push("Save", "info");
                }
                gmui_separator_text("Options");
                
                static ctx_check = false;
                ctx_check = gmui_context_menu_item_checkbox("Enable Feature", ctx_check);
                
                static ctx_radio = 0;
                if (gmui_context_menu_item_radio("Option A", ctx_radio == 0)) ctx_radio = 0;
                if (gmui_context_menu_item_radio("Option B", ctx_radio == 1)) ctx_radio = 1;
                
                if (gmui_begin_context_menu_sub("Sub Menu")) {
                    gmui_context_menu_item("Sub Item 1");
                    gmui_context_menu_item("Sub Item 2");
                    gmui_end_context_menu_sub();
                }
                
                gmui_end_context_menu();
            }
            
            gmui_end_collapsing_header();
        }
        
        if (gmui_begin_collapsing_header("Popups")) {
            if (gmui_button("Open Popup")) {
                gmui_popup_open("demo_popup");
            }
            
            if (gmui_begin_popup("demo_popup", false)) {
                gmui_text("This is a popup window!");
                gmui_text("It can contain any widgets.");
                if (gmui_button("Ok")) {
                    gmui_popup_close("demo_popup");
                }
                gmui_end_popup();
            }
            
            gmui_end_collapsing_header();
        }
		
        if (gmui_begin_collapsing_header("Collapsing Headers (Nested)")) {
            gmui_text("Demonstrating nested collapsing headers:");
            
            if (gmui_begin_collapsing_header("Level 1")) {
                gmui_text("Content at level 1");
                
                if (gmui_begin_collapsing_header("Level 2")) {
                    gmui_text("Content at level 2");
                    
                    if (gmui_begin_collapsing_header("Level 3")) {
                        gmui_text("Deep nested content");
                        if (gmui_button("Button at depth 3")) {
                            gmui_toast_push("Deep button clicked!", "info");
                        }
                        gmui_end_collapsing_header();
                    }
                    
                    gmui_end_collapsing_header();
                }
                
                gmui_end_collapsing_header();
            }
            
            gmui_end_collapsing_header();
        }
        
        gmui_end();
    }
}

// STYLE EDITOR
function gmui_style_editor() {
    if (!gmui_begin("Style Editor", 100, 100, 550, 500)) return;
    
    static style_editor_init = false;
    static ruler = {};
    static selected_tab = 0;
    
    if (!style_editor_init) {
        var style = global.gmui.style;
        ruler = {
            color_bg_dominant: style.color_bg_dominant,
            color_bg_secondary: style.color_bg_secondary,
            color_bg_tertiary: style.color_bg_tertiary,
            
            color_front_base: style.color_front_base,
            color_front_hover: style.color_front_hover,
            color_front_active: style.color_front_active,
            
            color_widget_base: style.color_widget_base,
            color_widget_hover: style.color_widget_hover,
            color_widget_active: style.color_widget_active,
            
            color_accent: style.color_accent,
            color_accent_hover: style.color_accent_hover,
            color_accent_pressed: style.color_accent_pressed,
            color_accent_alt: style.color_accent_alt,
            color_accent_dark: style.color_accent_dark,
            color_accent_light: style.color_accent_light,
            
            color_text_primary: style.color_text_primary,
            color_text_secondary: style.color_text_secondary,
            color_text_disabled: style.color_text_disabled,
            color_text_bright: style.color_text_bright,
            
            color_border: style.color_border,
            color_border_light: style.color_border_light,
            color_border_dark: style.color_border_dark,
            
            toast_success: style.toast_success_color,
            toast_error: style.toast_error_color,
            toast_info: style.toast_info_color,
            toast_warning: style.toast_warning_color,
            
            spacing_tiny: style.spacing_tiny,
            spacing_small: style.spacing_small,
            spacing_medium: style.spacing_medium,
            spacing_large: style.spacing_large,
            spacing_xlarge: style.spacing_xlarge,
            
            rounding_container: style.rounding_container,
            rounding_widget: style.rounding_widget,
            rounding_small: style.rounding_small,
            rounding_medium: style.rounding_medium,
            rounding_large: style.rounding_large,
            rounding_pill: style.rounding_pill,
            
            scroll_speed: style.scroll_speed,
            drag_sensitivity: style.drag_textbox_sensitivity,
            knob_sensitivity: style.knob_drag_sensitivity,
            tooltip_delay: style.tooltip_delay,
            toast_duration: style.toast_duration,
            toast_position: style.toast_position,
        };
        
        gmui_tab_add("style_editor_tabs", "Colors");
        gmui_tab_add("style_editor_tabs", "Spacing");
        gmui_tab_add("style_editor_tabs", "Rounding");
        gmui_tab_add("style_editor_tabs", "Timing");
        
        style_editor_init = true;
    }
    
    gmui_text("Presets:");
    gmui_sameline();
    
    if (gmui_button_ghost("Dark")) {
        ruler = {
            color_bg_dominant: make_color_rgb(24, 24, 24),
            color_bg_secondary: make_color_rgb(30, 30, 30),
            color_bg_tertiary: make_color_rgb(36, 36, 36),
            color_front_base: make_color_rgb(225, 225, 225),
            color_front_hover: make_color_rgb(255, 255, 255),
            color_front_active: make_color_rgb(190, 190, 190),
            color_widget_base: make_color_rgb(42, 42, 42),
            color_widget_hover: make_color_rgb(48, 48, 48),
            color_widget_active: make_color_rgb(36, 36, 36),
            color_accent: make_color_rgb(70, 130, 180),
            color_accent_hover: make_color_rgb(100, 160, 210),
            color_accent_pressed: make_color_rgb(50, 100, 150),
            color_accent_alt: make_color_rgb(90, 150, 200),
            color_accent_dark: make_color_rgb(40, 90, 140),
            color_accent_light: make_color_rgb(130, 180, 220),
            color_text_primary: make_color_rgb(225, 225, 225),
            color_text_secondary: make_color_rgb(170, 170, 170),
            color_text_disabled: make_color_rgb(110, 110, 110),
            color_text_bright: make_color_rgb(255, 255, 255),
            color_border: make_color_rgb(52, 52, 52),
            color_border_light: make_color_rgb(68, 68, 68),
            color_border_dark: make_color_rgb(40, 40, 40),
            toast_success: make_color_rgb(60, 160, 90),
            toast_error: make_color_rgb(210, 80, 80),
            toast_info: make_color_rgb(80, 130, 220),
            toast_warning: make_color_rgb(220, 180, 70),
            spacing_tiny: 2,
            spacing_small: 4,
            spacing_medium: 8,
            spacing_large: 12,
            spacing_xlarge: 16,
            rounding_container: 0,
            rounding_widget: 4,
            rounding_small: 2,
            rounding_medium: 3,
            rounding_large: 4,
            rounding_pill: 12,
            scroll_speed: 30,
            drag_sensitivity: 0.1,
            knob_sensitivity: 0.004,
            tooltip_delay: 500,
            toast_duration: 3000,
            toast_position: "top-center",
        };
    }
    
    gmui_sameline();
    
    if (gmui_button_primary("Light")) {
        ruler = {
            color_bg_dominant: make_color_rgb(240, 240, 240),
            color_bg_secondary: make_color_rgb(235, 235, 235),
            color_bg_tertiary: make_color_rgb(225, 225, 225),
            color_front_base: make_color_rgb(30, 30, 30),
            color_front_hover: make_color_rgb(0, 0, 0),
            color_front_active: make_color_rgb(60, 60, 60),
            color_widget_base: make_color_rgb(215, 215, 215),
            color_widget_hover: make_color_rgb(205, 205, 205),
            color_widget_active: make_color_rgb(225, 225, 225),
            color_accent: make_color_rgb(70, 130, 180),
            color_accent_hover: make_color_rgb(90, 150, 200),
            color_accent_pressed: make_color_rgb(50, 110, 160),
            color_accent_alt: make_color_rgb(85, 145, 195),
            color_accent_dark: make_color_rgb(45, 95, 145),
            color_accent_light: make_color_rgb(120, 170, 215),
            color_text_primary: make_color_rgb(30, 30, 30),
            color_text_secondary: make_color_rgb(80, 80, 80),
            color_text_disabled: make_color_rgb(140, 140, 140),
            color_text_bright: make_color_rgb(255, 255, 255),
            color_border: make_color_rgb(200, 200, 200),
            color_border_light: make_color_rgb(215, 215, 215),
            color_border_dark: make_color_rgb(180, 180, 180),
            toast_success: make_color_rgb(60, 160, 90),
            toast_error: make_color_rgb(210, 80, 80),
            toast_info: make_color_rgb(80, 130, 220),
            toast_warning: make_color_rgb(220, 180, 70),
            spacing_tiny: 2,
            spacing_small: 4,
            spacing_medium: 8,
            spacing_large: 12,
            spacing_xlarge: 16,
            rounding_container: 0,
            rounding_widget: 4,
            rounding_small: 2,
            rounding_medium: 3,
            rounding_large: 4,
            rounding_pill: 12,
            scroll_speed: 30,
            drag_sensitivity: 0.1,
            knob_sensitivity: 0.004,
            tooltip_delay: 500,
            toast_duration: 3000,
            toast_position: "top-center",
        };
    }
    
    gmui_separator();
    
    selected_tab = gmui_tabs("style_editor_tabs", selected_tab, -1, -1, "style_editor_group");
    var tab_name = gmui_tab_get_label("style_editor_tabs", selected_tab);
    
    if (tab_name == "Colors") {
        if (gmui_begin_collapsing_header("Background Colors", false)) {
            _gmui_edit_color_group(ruler, [
                { label: "BG Dominant", prop: "color_bg_dominant" },
                { label: "BG Secondary", prop: "color_bg_secondary" },
                { label: "BG Tertiary", prop: "color_bg_tertiary" }
            ]);
            gmui_end_collapsing_header();
        }
        
        if (gmui_begin_collapsing_header("Front Colors", false)) {
            _gmui_edit_color_group(ruler, [
                { label: "Front Base", prop: "color_front_base" },
                { label: "Front Hover", prop: "color_front_hover" },
                { label: "Front Active", prop: "color_front_active" }
            ]);
            gmui_end_collapsing_header();
        }
        
        if (gmui_begin_collapsing_header("Widget Colors", false)) {
            _gmui_edit_color_group(ruler, [
                { label: "Widget Base", prop: "color_widget_base" },
                { label: "Widget Hover", prop: "color_widget_hover" },
                { label: "Widget Active", prop: "color_widget_active" }
            ]);
            gmui_end_collapsing_header();
        }
        
        if (gmui_begin_collapsing_header("Accent Colors", false)) {
            _gmui_edit_color_group(ruler, [
                { label: "Accent", prop: "color_accent" },
                { label: "Accent Hover", prop: "color_accent_hover" },
                { label: "Accent Pressed", prop: "color_accent_pressed" },
                { label: "Accent Alt", prop: "color_accent_alt" },
                { label: "Accent Dark", prop: "color_accent_dark" },
                { label: "Accent Light", prop: "color_accent_light" }
            ]);
            gmui_end_collapsing_header();
        }
        
        if (gmui_begin_collapsing_header("Text Colors", false)) {
            _gmui_edit_color_group(ruler, [
                { label: "Text Primary", prop: "color_text_primary" },
                { label: "Text Secondary", prop: "color_text_secondary" },
                { label: "Text Disabled", prop: "color_text_disabled" },
                { label: "Text Bright", prop: "color_text_bright" }
            ]);
            gmui_end_collapsing_header();
        }
        
        if (gmui_begin_collapsing_header("Border Colors", false)) {
            _gmui_edit_color_group(ruler, [
                { label: "Border", prop: "color_border" },
                { label: "Border Light", prop: "color_border_light" },
                { label: "Border Dark", prop: "color_border_dark" }
            ]);
            gmui_end_collapsing_header();
        }
        
        if (gmui_begin_collapsing_header("Toast Colors", false)) {
            _gmui_edit_color_group(ruler, [
                { label: "Toast Success", prop: "toast_success" },
                { label: "Toast Error", prop: "toast_error" },
                { label: "Toast Info", prop: "toast_info" },
                { label: "Toast Warning", prop: "toast_warning" }
            ]);
            gmui_end_collapsing_header();
        }
    }
    
    if (tab_name == "Spacing") {
        gmui_text("Spacing Values (px)");
        gmui_separator();
        
        _gmui_edit_value_group(ruler, [
            { label: "Tiny", prop: "spacing_tiny", min: 0, max: 32 },
            { label: "Small", prop: "spacing_small", min: 0, max: 32 },
            { label: "Medium", prop: "spacing_medium", min: 0, max: 32 },
            { label: "Large", prop: "spacing_large", min: 0, max: 32 },
            { label: "X-Large", prop: "spacing_xlarge", min: 0, max: 32 }
        ]);
        
        gmui_separator();
        gmui_text("Sensitivity");
        
        _gmui_edit_float_group(ruler, [
            { label: "Drag Sensitivity", prop: "drag_sensitivity", min: 0.01, max: 1.0, step: 0.01 },
            { label: "Knob Sensitivity", prop: "knob_sensitivity", min: 0.0001, max: 0.1, step: 0.0001 },
            { label: "Scroll Speed", prop: "scroll_speed", min: 10, max: 100, step: 1 }
        ]);
    }
    
    if (tab_name == "Rounding") {
        gmui_text("Rounding Values (px)");
        gmui_separator();
        
        _gmui_edit_value_group(ruler, [
            { label: "Container", prop: "rounding_container", min: 0, max: 16 },
            { label: "Widget", prop: "rounding_widget", min: 0, max: 16 },
            { label: "Small", prop: "rounding_small", min: 0, max: 16 },
            { label: "Medium", prop: "rounding_medium", min: 0, max: 16 },
            { label: "Large", prop: "rounding_large", min: 0, max: 16 },
            { label: "Pill", prop: "rounding_pill", min: 0, max: 32 }
        ]);
    }
    
    if (tab_name == "Timing") {
        gmui_text("Timing Values (ms)");
        gmui_separator();
        
        _gmui_edit_value_group(ruler, [
            { label: "Tooltip Delay", prop: "tooltip_delay", min: 100, max: 2000 },
            { label: "Toast Duration", prop: "toast_duration", min: 1000, max: 10000 }
        ]);
        
        gmui_separator();
        gmui_text("Toast Position");
        var pos_options = ["top-left", "top-center", "top-right", "bottom-left", "bottom-center", "bottom-right", "middle-center"];
        var pos_index = 0;
        for (var i = 0; i < array_length(pos_options); i++) {
            if (ruler.toast_position == pos_options[i]) pos_index = i;
        }
        pos_index = gmui_combo(pos_index, pos_options, array_length(pos_options), "Select position", 200);
        ruler.toast_position = pos_options[pos_index];
    }
    
    gmui_separator();
    if (gmui_button_fill("Apply Style")) {
        gmui_style_apply_ruler(ruler);
        gmui_toast_push("Style applied!", "success");
    }
    
    gmui_end();
}

function _gmui_edit_color_group(ruler_struct, color_items) {
    var count = array_length(color_items);
    var style = global.gmui.style;
    
    var text_height = gmui_calculate_text_size("W")[1];
    var color_btn_height = 20;
    var rgb_height = style.textbox_height;
    var row_height = max(text_height, max(color_btn_height, rgb_height)) + style.element_spacing_v;
    var total_height = count * row_height;
    
    gmui_begin_columns(3, [0.3, 0.15, 0.55], total_height);
    
    gmui_set_column(0);
    for (var i = 0; i < count; i++) {
        gmui_text(color_items[i].label);
    }
    
    gmui_set_column(1);
    for (var i = 0; i < count; i++) {
        var current_color = variable_struct_get(ruler_struct, color_items[i].prop);
        var rgba_color = gmui_color_rgb_to_rgba(current_color, 255);
        rgba_color = gmui_color_pick(rgba_color, color_items[i].prop);
        var r = gmui_color_rgba_get_red(rgba_color);
        var g = gmui_color_rgba_get_green(rgba_color);
        var b = gmui_color_rgba_get_blue(rgba_color);
        variable_struct_set(ruler_struct, color_items[i].prop, make_color_rgb(r, g, b));
    }
    
    gmui_set_column(2);
    for (var i = 0; i < count; i++) {
        var current_color = variable_struct_get(ruler_struct, color_items[i].prop);
        var r = color_get_red(current_color);
        var g = color_get_green(current_color);
        var b = color_get_blue(current_color);
        
        gmui_text("R:");
        gmui_sameline();
        var new_r = gmui_input_int(r, 1, 0, 255, 40, c_red);
        gmui_sameline();
        gmui_text("G:");
        gmui_sameline();
        var new_g = gmui_input_int(g, 1, 0, 255, 40, c_green);
        gmui_sameline();
        gmui_text("B:");
        gmui_sameline();
        var new_b = gmui_input_int(b, 1, 0, 255, 40, c_blue);
        
        if (new_r != r || new_g != g || new_b != b) {
            variable_struct_set(ruler_struct, color_items[i].prop, make_color_rgb(new_r, new_g, new_b));
        }
    }
    
    gmui_end_columns();
}

function _gmui_edit_value_group(ruler_struct, value_items) {
    var count = array_length(value_items);
    var style = global.gmui.style;
    
    var text_height = gmui_calculate_text_size("W")[1];
    var input_height = style.textbox_height;
    var row_height = max(text_height, input_height) + style.element_spacing_v;
    var total_height = count * row_height;
    
    gmui_begin_columns(2, [0.4, 0.6], total_height);
    
    gmui_set_column(0);
    for (var i = 0; i < count; i++) {
        gmui_text(value_items[i].label);
    }
    
    gmui_set_column(1);
    for (var i = 0; i < count; i++) {
        var value = variable_struct_get(ruler_struct, value_items[i].prop);
        var new_value = gmui_input_int(value, 1, value_items[i].min, value_items[i].max, 100);
        if (new_value != value) {
            variable_struct_set(ruler_struct, value_items[i].prop, new_value);
        }
    }
    
    gmui_end_columns();
}

function _gmui_edit_float_group(ruler_struct, float_items) {
    var count = array_length(float_items);
    var style = global.gmui.style;
    
    var text_height = gmui_calculate_text_size("W")[1];
    var input_height = style.textbox_height;
    var row_height = max(text_height, input_height) + style.element_spacing_v;
    var total_height = count * row_height;
    
    gmui_begin_columns(2, [0.4, 0.6], total_height);
    
    gmui_set_column(0);
    for (var i = 0; i < count; i++) {
        gmui_text(float_items[i].label);
    }
    
    gmui_set_column(1);
    for (var i = 0; i < count; i++) {
        var value = variable_struct_get(ruler_struct, float_items[i].prop);
        var new_value = gmui_input_float(value, float_items[i].step, float_items[i].min, float_items[i].max, 120);
        if (new_value != value) {
            variable_struct_set(ruler_struct, float_items[i].prop, new_value);
        }
    }
    
    gmui_end_columns();
}