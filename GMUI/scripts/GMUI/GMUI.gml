/**************************************
   ██████╗ ███╗   ███╗██╗   ██╗██╗
  ██╔════╝ ████╗ ████║██║   ██║██║
  ██║  ███╗██╔████╔██║██║   ██║██║
  ██║   ██║██║╚██╔╝██║██║   ██║██║
  ╚██████╔╝██║ ╚═╝ ██║╚██████╔╝██║
   ╚═════╝ ╚═╝     ╚═╝ ╚═════╝ ╚═╝
 GameMaker Immediate Mode UI Library
           Version 1.7.22
           
           by erkan612
=======================================
A feature rich Immediate-Mode UI system
             for GameMaker
=======================================
**************************************/

/************************************
 * CORE
 ***********************************/
//////////////////////////////////////
// CORE (Initialization, main loop, window management)
//////////////////////////////////////
global.gmui = undefined;

enum gmui_window_flags {
    NONE							= 0,
    NO_TITLE_BAR					= 1 << 0,
    NO_RESIZE						= 1 << 1,
    NO_MOVE							= 1 << 2,
    NO_SCROLLBAR					= 1 << 3,
    NO_COLLAPSE						= 1 << 4,
    ALWAYS_AUTO_RESIZE				= 1 << 5,
    NO_BACKGROUND					= 1 << 6,
    NO_SAVED_SETTINGS				= 1 << 7,
    NO_MOUSE_INPUTS					= 1 << 8,
    MENU_BAR						= 1 << 9,
    HORIZONTAL_SCROLLBAR			= 1 << 10,
    NO_FOCUS_ON_APPEARING			= 1 << 11,
    NO_BRING_TO_FRONT_ON_FOCUS		= 1 << 12,
    ALWAYS_VERTICAL_SCROLLBAR		= 1 << 13,
    ALWAYS_HORIZONTAL_SCROLLBAR		= 1 << 14,
    ALWAYS_USE_WINDOW_PADDING		= 1 << 15,
    NO_NAV_INPUTS					= 1 << 16,
    NO_NAV_FOCUS					= 1 << 17,
    UNSAVED_DOCUMENT				= 1 << 18,
    NO_CLOSE						= 1 << 19,
    VERTICAL_SCROLL					= 1 << 20,
    HORIZONTAL_SCROLL				= 1 << 21,
    AUTO_SCROLL						= 1 << 22,           
    ALWAYS_SCROLLBARS				= 1 << 23,     
    SCROLL_WITH_MOUSE_WHEEL			= 1 << 24, 
    SCROLLBAR_LEFT					= 1 << 25,        
    SCROLLBAR_TOP					= 1 << 26,         
    POPUP							= 1 << 27,
    AUTO_HSCROLL					= 1 << 28,
    AUTO_VSCROLL					= 1 << 29,
	NO_MOVE_DEPTH					= 1 << 30,
	NO_BORDER						= 1 << 31,
}

enum gmui_pre_window_flags {
	MODAL_DEFAULT					= gmui_window_flags.NO_CLOSE			| gmui_window_flags.NO_RESIZE			| gmui_window_flags.NO_COLLAPSE					| gmui_window_flags.POPUP, 
	MODAL_SET						= gmui_pre_window_flags.MODAL_DEFAULT	| gmui_window_flags.ALWAYS_AUTO_RESIZE, 
	CANVAS							= gmui_window_flags.NO_TITLE_BAR		| gmui_window_flags.NO_RESIZE, 
	CANVAS_CLEAN					= gmui_window_flags.NO_BACKGROUND		| gmui_window_flags.NO_TITLE_BAR		| gmui_window_flags.NO_RESIZE					| gmui_window_flags.NO_BORDER, 
	CONTEXT_MENU					= gmui_pre_window_flags.CANVAS			| gmui_window_flags.POPUP				| gmui_window_flags.AUTO_VSCROLL				| gmui_window_flags.SCROLL_WITH_MOUSE_WHEEL, 
	SUB_CONTEXT_MENU				= gmui_pre_window_flags.CANVAS			| gmui_window_flags.AUTO_VSCROLL		| gmui_window_flags.SCROLL_WITH_MOUSE_WHEEL, 
	MENU							= gmui_pre_window_flags.CANVAS			| gmui_window_flags.NO_MOVE_DEPTH, 
	WINS							= gmui_pre_window_flags.CANVAS			| gmui_window_flags.NO_MOVE_DEPTH, 
	WINS_SET						= gmui_pre_window_flags.WINS			| gmui_window_flags.AUTO_SCROLL			| gmui_window_flags.SCROLL_WITH_MOUSE_WHEEL, 
	WINS_SET_VERTICAL				= gmui_pre_window_flags.WINS			| gmui_window_flags.AUTO_VSCROLL		| gmui_window_flags.SCROLL_WITH_MOUSE_WHEEL, 
	WINS_SET_HORIZONTAL				= gmui_pre_window_flags.WINS			| gmui_window_flags.AUTO_HSCROLL		| gmui_window_flags.SCROLL_WITH_MOUSE_WHEEL, 
};

function gmui_get() { return global.gmui; };

function gmui_init() {
    if (global.gmui == undefined) {
        global.gmui = {
            initialized: true,
			last_pressed_clickable_id: undefined, // meant for release-action elements
			context_menu_cache: ds_map_create(),
			current_context_menu_last_available_sub_pos: [ 0, 0 ],
			current_context_menu: undefined,
			current_context_menu_bg: undefined,
			cache_surfaces: ds_map_create(),
			cache: ds_map_create(),
			wins_gap: 4,
			table_sort_column: -1,
			table_sort_ascending: true,
			tables: ds_map_create(),
			tab_width: 32,
			to_delete_combo: false,
			z_order_counter: 0,
            window_z_order: ds_priority_create(),
			modals: ds_list_create(),
			to_delete_color_picker: false,
			is_hovering_element: false,
			hovering_window: undefined,
			recent_scissor: undefined,
			treeview_stack: [],
			treeview_open_nodes: ds_map_create(),
			active_slider: undefined,
			active_textbox: undefined,
			active_drag_textbox: undefined,
			textbox_id: undefined,
			drag_textbox_id: undefined,
			drag_textbox_start_value: 0,
			drag_textbox_start_mouse_x: 0,
			textbox_cursor_timer: 0,
			textbox_cursor_visible: true,
            windows: ds_list_create(),
            window_stack: [],
            current_window: undefined,
            mouse_pos: [0, 0],
            mouse_down: [false, false, false, false, false],
            mouse_clicked: [false, false, false, false, false],
            mouse_released: [false, false, false, false, false],
            frame_count: 0,
            style: {
                window_padding: [8, 8],
                window_rounding: 8,
                window_min_size: [32, 32],
                background_color: make_color_rgb(30, 30, 30),
				background_alpha: 255,
                border_color: make_color_rgb(60, 60, 60),
                item_spacing: [8, 4],
                item_inner_spacing: [4, 4],
                text_color: make_color_rgb(220, 220, 220),
                text_disabled_color: make_color_rgb(128, 128, 128),
				
				// Button styles
                button_rounding: 4,
                button_border_size: 1,
                button_text_color: make_color_rgb(220, 220, 220),
                button_bg_color: make_color_rgb(70, 70, 70),
                button_border_color: make_color_rgb(100, 100, 100),
                button_hover_bg_color: make_color_rgb(90, 90, 90),
                button_hover_border_color: make_color_rgb(120, 120, 120),
                button_active_bg_color: make_color_rgb(50, 50, 50),
                button_active_border_color: make_color_rgb(80, 80, 80),
                button_disabled_bg_color: make_color_rgb(40, 40, 40),
                button_disabled_border_color: make_color_rgb(60, 60, 60),
                button_disabled_text_color: make_color_rgb(128, 128, 128),
                
                // Button padding (horizontal, vertical)
                button_padding: [8, 4],
                
                // Minimum button size
                button_min_size: [80, 24],
				
                // Title bar styles
                title_bar_height: 24,
                title_bar_color: make_color_rgb(50, 50, 50),
                title_bar_hover_color: make_color_rgb(60, 60, 60),
                title_bar_active_color: make_color_rgb(40, 40, 40),
                title_text_color: make_color_rgb(220, 220, 220),
                title_text_align: "left", // "left", "center", "right"
                title_padding: [8, 4],
                
                // Close button styles
                close_button_size: 16,
                close_button_color: make_color_rgb(150, 150, 150),
                close_button_hover_color: make_color_rgb(220, 100, 100),
                close_button_active_color: make_color_rgb(180, 80, 80),
                
                // Window resize handle
                resize_handle_size: 8,
				
				// Checkbox
				checkbox_size: 16,
				checkbox_border_size: 1,
				checkbox_rounding: 2,
				checkbox_bg_color: make_color_rgb(70, 70, 70),
				checkbox_border_color: make_color_rgb(100, 100, 100),
				checkbox_hover_bg_color: make_color_rgb(90, 90, 90),
				checkbox_hover_border_color: make_color_rgb(120, 120, 120),
				checkbox_active_bg_color: make_color_rgb(50, 50, 50),
				checkbox_active_border_color: make_color_rgb(80, 80, 80),
				checkbox_disabled_bg_color: make_color_rgb(40, 40, 40),
				checkbox_disabled_border_color: make_color_rgb(60, 60, 60),
				checkbox_check_color: make_color_rgb(220, 220, 220),
				checkbox_text_color: make_color_rgb(220, 220, 220),
				checkbox_text_disabled_color: make_color_rgb(128, 128, 128),
				checkbox_spacing: 4, // Space between checkbox and label
				
				// Slider styles
				slider_track_height: 4,
				slider_track_rounding: 2,
				slider_track_border_size: 0,
				slider_track_bg_color: make_color_rgb(70, 70, 70),
				slider_track_border_color: make_color_rgb(100, 100, 100),
				slider_track_fill_color: make_color_rgb(100, 100, 255),
				slider_handle_width: 12,
				slider_handle_height: 20,
				slider_handle_rounding: 4,
				slider_handle_border_size: 1,
				slider_handle_bg_color: make_color_rgb(200, 200, 200),
				slider_handle_border_color: make_color_rgb(100, 100, 100),
				slider_handle_hover_bg_color: make_color_rgb(230, 230, 230),
				slider_handle_hover_border_color: make_color_rgb(120, 120, 120),
				slider_handle_active_bg_color: make_color_rgb(180, 180, 180),
				slider_handle_active_border_color: make_color_rgb(80, 80, 80),
				slider_handle_disabled_bg_color: make_color_rgb(100, 100, 100),
				slider_handle_disabled_border_color: make_color_rgb(60, 60, 60),
				slider_text_color: make_color_rgb(220, 220, 220),
				slider_text_disabled_color: make_color_rgb(128, 128, 128),
				slider_spacing: 4, // Space between slider and label (if any)
				
				// WINS
				wins_splitter_color: make_color_rgb(60, 60, 60),
				wins_splitter_hover_color: make_color_rgb(100, 100, 100),
				wins_splitter_active_color: make_color_rgb(100, 100, 255),
				
				// Textbox styles
				textbox_bg_color: make_color_rgb(40, 40, 40),
				textbox_border_color: make_color_rgb(80, 80, 80),
				textbox_focused_border_color: make_color_rgb(100, 100, 255),
				textbox_text_color: make_color_rgb(220, 220, 220),
				textbox_placeholder_color: make_color_rgb(128, 128, 128),
				textbox_cursor_color: make_color_rgb(220, 220, 220),
				textbox_selection_color: make_color_rgb(60, 60, 140),
				textbox_padding: [4, 4],
				textbox_rounding: 4,
				textbox_border_size: 1,
				textbox_cursor_width: 2,

				// Drag Textbox styles
				drag_textbox_bg_color: make_color_rgb(40, 40, 40),
				drag_textbox_border_color: make_color_rgb(80, 80, 80),
				drag_textbox_focused_border_color: make_color_rgb(100, 100, 255),
				drag_textbox_text_color: make_color_rgb(220, 220, 220),
				drag_textbox_placeholder_color: make_color_rgb(128, 128, 128),
				drag_textbox_cursor_color: make_color_rgb(220, 220, 220),
				drag_textbox_selection_color: make_color_rgb(60, 60, 140),
				drag_textbox_padding: [4, 4],
				drag_textbox_rounding: 4,
				drag_textbox_border_size: 1,
				drag_textbox_cursor_width: 2,
				drag_textbox_drag_sensitivity: 0.1, // How fast values change when dragging
				drag_textbox_drag_color: make_color_rgb(100, 100, 255), // Color when dragging
				drag_textbox_drag_hotzone_width: 8, // Width of the right-side drag area
				
				// Selectable styles
				selectable_height: 24,
				selectable_rounding: 4,
				selectable_border_size: 1,
				selectable_bg_color: make_color_rgb(70, 70, 70),
				selectable_border_color: make_color_rgb(100, 100, 100),
				selectable_hover_bg_color: make_color_rgb(90, 90, 90),
				selectable_hover_border_color: make_color_rgb(120, 120, 120),
				selectable_active_bg_color: make_color_rgb(50, 50, 50),
				selectable_active_border_color: make_color_rgb(80, 80, 80),
				selectable_selected_bg_color: make_color_rgb(65, 105, 225), // Royal blue
				selectable_selected_border_color: make_color_rgb(85, 125, 245),
				selectable_selected_hover_bg_color: make_color_rgb(75, 115, 235),
				selectable_selected_hover_border_color: make_color_rgb(95, 135, 255),
				selectable_disabled_bg_color: make_color_rgb(40, 40, 40),
				selectable_disabled_border_color: make_color_rgb(60, 60, 60),
				selectable_text_color: make_color_rgb(220, 220, 220),
				selectable_text_disabled_color: make_color_rgb(128, 128, 128),
				selectable_text_selected_color: make_color_rgb(255, 255, 255),
				selectable_padding: [8, 4],
				
				// Treeview styles
				treeview_spacing: 1,
				treeview_indent: 20,
				treeview_item_height: 24,
				treeview_arrow_size: 8,
				treeview_arrow_color: make_color_rgb(200, 200, 200),
				treeview_arrow_hover_color: make_color_rgb(255, 255, 255),
				treeview_arrow_active_color: make_color_rgb(180, 180, 180),
				treeview_bg_color: make_color_rgb(50, 50, 50),
				treeview_hover_bg_color: make_color_rgb(70, 70, 70),
				treeview_active_bg_color: make_color_rgb(60, 60, 60),
				treeview_selected_bg_color: make_color_rgb(65, 105, 225),
				treeview_selected_hover_bg_color: make_color_rgb(75, 115, 235),
				treeview_border_color: make_color_rgb(80, 80, 80),
				treeview_text_color: make_color_rgb(220, 220, 220),
				treeview_text_selected_color: make_color_rgb(255, 255, 255),
				treeview_text_disabled_color: make_color_rgb(128, 128, 128),
				
				// Collapsible header styles
			    collapsible_header_height: 24,
			    collapsible_header_rounding: 4,
			    collapsible_header_border_size: 1,
			    collapsible_header_bg_color: make_color_rgb(60, 60, 60),
			    collapsible_header_hover_bg_color: make_color_rgb(80, 80, 80),
			    collapsible_header_active_bg_color: make_color_rgb(50, 50, 50),
			    collapsible_header_border_color: make_color_rgb(100, 100, 100),
			    collapsible_header_text_color: make_color_rgb(220, 220, 220),
			    collapsible_header_arrow_size: 8,
			    collapsible_header_arrow_color: make_color_rgb(200, 200, 200),
			    collapsible_header_arrow_hover_color: make_color_rgb(255, 255, 255),
			    collapsible_header_arrow_active_color: make_color_rgb(180, 180, 180),
			    collapsible_header_padding: [8, 4],
			    collapsible_header_content_padding: [4, 4],
				
				// Scrollbar styles
			    scrollbar_width: 16,
			    scrollbar_background_color: make_color_rgb(40, 40, 40),
			    scrollbar_anchor_color: make_color_rgb(100, 100, 100),
			    scrollbar_anchor_hover_color: make_color_rgb(120, 120, 120),
			    scrollbar_anchor_active_color: make_color_rgb(140, 140, 140),
			    scrollbar_min_anchor_size: 30,
			    scrollbar_margin: 2,
			    scrollbar_rounding: 4,
			    scroll_wheel_speed: 30,
				
				// Color picker styles (updated)
				color_picker_width: 200,
				color_picker_height: 200,
				color_picker_hue_height: 20,
				color_picker_alpha_height: 20,
				color_picker_preview_size: 40,
				color_picker_padding: 8,
				color_picker_border_size: 1,
				color_picker_border_color: make_color_rgb(80, 80, 80),

				// Color button styles
				color_button_size: 20,
				color_button_border_size: 1,
				color_button_border_color: make_color_rgb(100, 100, 100),
				color_button_hover_border_color: make_color_rgb(150, 150, 150),
				color_button_active_border_color: make_color_rgb(200, 200, 200),

				// Color edit styles
				color_edit_height: 24,
				color_edit_border_size: 1,
				color_edit_border_color: make_color_rgb(80, 80, 80),
				color_edit_focused_border_color: make_color_rgb(100, 100, 255),
				color_edit_text_color: make_color_rgb(220, 220, 220),
				color_edit_bg_color: make_color_rgb(40, 40, 40),
				color_edit_padding: [4, 4],

				// Shader handles
				shader_hue: -1,
				shader_saturation_brightness: -1,
				shader_alpha: -1,
				shader_checkerboard: -1,
				
				// Combobox styles
				combo_height: 24,
				combo_rounding: 4,
				combo_border_size: 1,
				combo_bg_color: make_color_rgb(40, 40, 40),
				combo_border_color: make_color_rgb(80, 80, 80),
				combo_hover_bg_color: make_color_rgb(60, 60, 60),
				combo_hover_border_color: make_color_rgb(100, 100, 100),
				combo_active_bg_color: make_color_rgb(50, 50, 50),
				combo_active_border_color: make_color_rgb(90, 90, 90),
				combo_text_color: make_color_rgb(220, 220, 220),
				combo_placeholder_color: make_color_rgb(128, 128, 128),
				combo_arrow_color: make_color_rgb(180, 180, 180),
				combo_arrow_hover_color: make_color_rgb(220, 220, 220),
				combo_arrow_size: 8,
				combo_padding: [8, 4],
				combo_dropdown_bg_color: make_color_rgb(50, 50, 50),
				combo_dropdown_border_color: make_color_rgb(80, 80, 80),
				combo_dropdown_rounding: 4,
				combo_dropdown_max_height: 200,
				combo_item_height: 24,
				combo_item_bg_color: make_color_rgb(50, 50, 50),
				combo_item_hover_bg_color: make_color_rgb(70, 70, 70),
				combo_item_selected_bg_color: make_color_rgb(65, 105, 225),
				combo_item_text_color: make_color_rgb(220, 220, 220),
				combo_item_selected_text_color: make_color_rgb(255, 255, 255),
				
				// Table styles
				table_bg_color: make_color_rgb(40, 40, 40),
				table_border_color: make_color_rgb(80, 80, 80),
				table_border_size: 1,

				// Header styles
				table_header_height: 28,
				table_header_bg_color: make_color_rgb(60, 60, 60),
				table_header_hover_bg_color: make_color_rgb(80, 80, 80),
				table_header_border_color: make_color_rgb(100, 100, 100),
				table_header_text_color: make_color_rgb(220, 220, 220),
				table_header_text_align: "center", // "left", "center", "right"

				// Row styles
				table_row_height: 24,
				table_row_bg_color: make_color_rgb(50, 50, 50),
				table_row_hover_bg_color: make_color_rgb(70, 70, 70),
				table_row_selected_bg_color: make_color_rgb(65, 105, 225),
				table_row_border_color: make_color_rgb(80, 80, 80),
				table_row_text_color: make_color_rgb(220, 220, 220),
				table_row_selected_text_color: make_color_rgb(255, 255, 255),
				table_row_text_padding: 8,

				// Sort indicator styles
				table_sort_arrow_color: make_color_rgb(200, 200, 200),
				table_sort_arrow_size: 8,

				// Alternating row colors
				table_alternate_row_bg_color: make_color_rgb(45, 45, 45),
				table_alternate_row_hover_bg_color: make_color_rgb(65, 65, 65),

				// Scrollbar styles for tables
				table_scrollbar_width: 12,
				table_scrollbar_color: make_color_rgb(100, 100, 100),
				table_scrollbar_hover_color: make_color_rgb(120, 120, 120),

				// Cell styles
				table_cell_padding: [4, 2],
				table_cell_border_color: make_color_rgb(70, 70, 70),
				
				table_flags: {
				    ALTERNATE_ROWS: 1 << 0,
				    BORDERED_CELLS: 1 << 1,
				    RESIZABLE_COLUMNS: 1 << 2,
				    HOVERABLE_ROWS: 1 << 3,
				    SORTABLE_HEADERS: 1 << 4,
				    STRIPED: 1 << 5, // Same as ALTERNATE_ROWS but more descriptive
				},
				
				// Plotting & Chart styles
				plot_bg_color: make_color_rgb(25, 25, 25),
				plot_border_color: make_color_rgb(80, 80, 80),
				plot_border_size: 1,
				plot_padding: [4, 4],

				// Grid styles
				plot_grid_color: make_color_rgb(50, 50, 50),
				plot_grid_thickness: 1,
				plot_grid_steps: 5, // Number of grid lines

				// Text styles
				plot_text_color: make_color_rgb(150, 150, 150),
				plot_text_size: -1, // Use default font size if -1
				plot_axis_label_color: make_color_rgb(180, 180, 180),

				// Line plot styles
				plot_line_color: make_color_rgb(100, 200, 255),
				plot_line_thickness: 2,
				plot_line_smooth: true,
				plot_point_color: make_color_rgb(100, 200, 255),
				plot_point_size: 4,
				plot_fill_color: gmui_make_color_rgba(100, 200, 255, 30),
				plot_fill_enabled: true,

				// Bar chart styles
				plot_bar_color: make_color_rgb(100, 150, 255),
				plot_bar_border_color: make_color_rgb(80, 80, 80),
				plot_bar_border_size: 1,
				plot_bar_rounding: 2,
				plot_bar_spacing_ratio: 0.1, // 10% spacing between bars
				plot_bar_gradient: true, // Color gradient based on value
				plot_bar_min_color: make_color_rgb(100, 100, 255), // For gradient
				plot_bar_max_color: make_color_rgb(255, 100, 100), // For gradient

				// Histogram styles
				plot_histogram_color: make_color_rgb(100, 200, 100),
				plot_histogram_border_color: make_color_rgb(80, 80, 80),
				plot_histogram_border_size: 1,
				plot_histogram_default_bins: 10,
				plot_histogram_spacing_ratio: 0.1,

				// Scatter plot styles
				plot_scatter_color: make_color_rgb(255, 100, 100),
				plot_scatter_size: 4,
				plot_scatter_rounding: 2,
				plot_scatter_border_color: make_color_rgb(200, 200, 200),
				plot_scatter_border_size: 1,

				// Trend line styles (for scatter plots)
				plot_trendline_color: make_color_rgb(255, 200, 50),
				plot_trendline_thickness: 1,
				plot_trendline_enabled: true,

				// Annotation styles
				plot_annotation_bg_color: gmui_make_color_rgba(0, 0, 0, 180),
				plot_annotation_text_color: make_color_rgb(255, 255, 255),
				plot_annotation_padding: [4, 2],
				plot_annotation_rounding: 2,

				// Legend styles
				plot_legend_bg_color: gmui_make_color_rgba(0, 0, 0, 180),
				plot_legend_text_color: make_color_rgb(255, 255, 255),
				plot_legend_padding: [8, 4],
				plot_legend_rounding: 4,
				plot_legend_position: "top-right", // "top-left", "top-right", "bottom-left", "bottom-right"

				// Tooltip styles (for interactive plots)
				plot_tooltip_bg_color: gmui_make_color_rgba(0, 0, 0, 220),
				plot_tooltip_text_color: make_color_rgb(255, 255, 255),
				plot_tooltip_border_color: make_color_rgb(100, 100, 100),
				plot_tooltip_border_size: 1,
				plot_tooltip_padding: [6, 3],
				plot_tooltip_rounding: 3,

				// Color palettes for multiple series
				plot_color_palette: [
				    make_color_rgb(255, 100, 100),  // Red
				    make_color_rgb(100, 200, 255),  // Blue
				    make_color_rgb(100, 255, 100),  // Green
				    make_color_rgb(255, 200, 50),   // Yellow
				    make_color_rgb(200, 100, 255),  // Purple
				    make_color_rgb(50, 255, 255),   // Cyan
				    make_color_rgb(255, 150, 50),   // Orange
				    make_color_rgb(150, 150, 255)   // Light Blue
				],

				// Animation styles
				plot_animation_duration: 0.5, // seconds
				plot_animation_easing: "easeOut", // "linear", "easeIn", "easeOut", "easeInOut"
				
				// Context Menu
				context_menu_item_hover_bg_color: make_color_rgb(60, 60, 60),
				context_menu_item_text_color: make_color_rgb(220, 220, 220),
				context_menu_item_short_cut_text_color: make_color_rgb(150, 150, 150),
				context_menu_item_height: 20,
				context_menu_sub_arrow_thickness: 3,
				
				// Window Menu
				menu_height: 20,
				menu_button_active_bg_color: make_colour_rgb(90, 90, 90),
				menu_button_hover_bg_color: make_colour_rgb(60, 60, 60),
				menu_text_color: make_colour_rgb(220, 220, 220),
				menu_button_padding: 4,
				menu_button_rounding: -1,
                
                // Progress bar styles
                progress_bar_height: 20,
                progress_bar_rounding: 4,
                progress_bar_border_size: 1,
                progress_bar_bg_color: make_color_rgb(50, 50, 50),
                progress_bar_border_color: make_color_rgb(80, 80, 80),
                progress_bar_fill_color: make_color_rgb(100, 150, 255),
                progress_bar_fill_hover_color: make_color_rgb(120, 170, 255),
                progress_bar_fill_active_color: make_color_rgb(80, 130, 235),
                progress_bar_text_color: make_color_rgb(220, 220, 220),
                progress_bar_text_disabled_color: make_color_rgb(128, 128, 128),
                
                // Circular progress bar styles
                progress_circular_size: 40,
                progress_circular_thickness: 4,
                progress_circular_bg_color: make_color_rgb(50, 50, 50),
                progress_circular_fill_color: make_color_rgb(100, 150, 255),
                progress_circular_fill_hover_color: make_color_rgb(120, 170, 255),
                progress_circular_text_color: make_color_rgb(220, 220, 220),
                progress_circular_text_size: -1, // Use default if -1
                progress_circular_show_text: true,
                progress_circular_animation_speed: 1.0, // 1.0 = normal speed
                
                // Progress bar text options
                progress_text_format: "percentage", // "percentage", "fraction", "value", "custom", "none"
                progress_text_position: "center", // "left", "center", "right", "inside", "outside"
                progress_text_padding: [4, 0],
                
                // Progress bar states
                progress_animated: true,
                progress_animation_duration: 0.3, // seconds
                progress_animation_easing: "linear", // "linear", "easeIn", "easeOut", "easeInOut"
                
                // Gradient options (for linear progress bars)
                progress_gradient_enabled: false,
                progress_gradient_start_color: make_color_rgb(100, 150, 255),
                progress_gradient_end_color: make_color_rgb(50, 100, 200),
                progress_gradient_direction: "horizontal", // "horizontal", "vertical", "diagonal"
            },
            font: draw_get_font(),
			styler: { // TODO: do this...
				button: function(data) { gmui_add_rect(data.x, data.y, data.width, data.height, data.color); }, // here's an example
			},
			lite_search: undefined,
        };
		
		gmui_ls_init();
		
		gmui_cache_set("array.cache_surfaces.values", array_create(0));
		gmui_cache_set("array.mouse_pos", array_create(2));
		gmui_cache_set("array.mb_array", [ mb_left, mb_right, mb_middle, mb_side1, mb_side2 ]);
    }
}

function gmui_window_state() {
    return {
        name: "",
        x: 0, y: 0, width: 0, height: 0,
        initial_x: 0, initial_y: 0, initial_width: 0, initial_height: 0, // Store initial values
        flags: 0, open: true, active: false,
        surface: -1, surface_dirty: true,
        draw_list: [],
		rounding: true,
        
        // Title bar state
        title_bar_hovered: false,
        title_bar_active: false,
        drag_offset_x: 0,
        drag_offset_y: 0,
        is_dragging: false,
        is_resizing: false,
        resize_corner: 0, // 0=none, 1=top-left, 2=top-right, 3=bottom-left, 4=bottom-right
        
        // Double click detection
        last_click_time: 0,
		
		// Combobox state
        active_combo: undefined,
        combo_items: undefined,
        combo_items_count: 0,
        combo_current_index: -1,
        combo_width: 0,
		
		// Scroll state
        scroll_x: 0,
        scroll_y: 0,
        content_width: 0,
        content_height: 0,
        scrollbar_dragging: false,
        scrollbar_drag_offset: 0,
        scrollbar_drag_axis: 0, // 0 = vertical, 1 = horizontal
		
		// Color picker state
		active_color_picker: undefined,
		color_picker_value: [1, 1, 1, 1],
		color_picker_hue: 0,
		color_picker_saturation: 1,
		color_picker_brightness: 1,
		color_picker_alpha: 1,
		color_picker_dragging: false,
		color_picker_drag_type: 0, // 0 = none, 1 = hue, 2 = saturation/brightness, 3 = alpha
		
		z_index: 0,  // Current z-index (higher = more front)
        z_id: 0,     // Unique ID for priority queue
        
        // Track content size for scroll calculations
        max_cursor_x: 0,
        max_cursor_y: 0,
        
        // Track if window has been positioned for the first time
        first_frame: true,
        
        dc: {
            cursor_x: 0, cursor_y: 0,
            cursor_previous_x: 0, cursor_previous_y: 0,
            cursor_start_x: 0, cursor_start_y: 0,
            line_height: 0, item_width: 0, previous_line_height: 0,
            
            // Title bar takes up space at the top
            title_bar_height: 0,
            
            // Scroll offset for content
            scroll_offset_x: 0,
            scroll_offset_y: 0
        },

        // Treeview state
        treeview_stack: [],
        treeview_open_nodes: ds_map_create()
    };
}

function gmui_get_window(name) {
    if (!global.gmui.initialized) return undefined;
	
	var window = undefined;
	for (var i = 0; i < ds_list_size(global.gmui.windows); i++) {
		var w = global.gmui.windows[| i];
		if (w.name == name) { window = w; };
	};
    
    if (window == undefined) {
        window = gmui_window_state();
        window.name = name;
        
        // Initialize z-order
        global.gmui.z_order_counter++;
        window.z_id = global.gmui.z_order_counter;
        window.z_index = global.gmui.z_order_counter;
        
        ds_list_add(global.gmui.windows, window);
        ds_priority_add(global.gmui.window_z_order, window, window.z_index);
    };
	
    return window;
}

function gmui_get_window_idx(name) {
    if (!global.gmui.initialized) return undefined;
	
	var idx = -1;
	for (var i = 0; i < ds_list_size(global.gmui.windows); i++) {
		var w = global.gmui.windows[| i];
		if (w.name == name) { idx = i; };
	};
	
    return idx;
}

function gmui_get_windows() {
    if (!global.gmui.initialized) return undefined;
	
    return global.gmui.windows;
}

function gmui_create_surface(window) {
    if (surface_exists(window.surface)) surface_free(window.surface);
    window.surface = surface_create(max(1, window.width), max(1, window.height));
    window.surface_dirty = true;
    return window.surface != -1;
}

function gmui_begin(name, x = 0, y = 0, w = 512, h = 256, flags = 0) {
    if (!global.gmui.initialized) return false;
    
    var window = gmui_get_window(name);
    if (!window) return false;
    
    var no_move = (flags & gmui_window_flags.NO_MOVE) == 0;
	var no_border = (flags & gmui_window_flags.NO_BORDER) != 0;
	var is_popup = (flags & gmui_window_flags.POPUP) != 0;
    
    // Handle initial positioning
    if (window.first_frame) {
        if (x != -1) { window.x = x; window.initial_x = x; }
        if (y != -1) { window.y = y; window.initial_y = y; }
        if (w != -1) { window.width = w; window.initial_width = w; }
        if (h != -1) { window.height = h; window.initial_height = h; }
        window.first_frame = false;
		
		if (is_popup) { window.open = false; }; // if its a popup, initiate as closed
    } else if (!no_move) {
        if (x != -1) window.x = x;
        if (y != -1) window.y = y;
        if (w != -1) window.width = w;
        if (h != -1) window.height = h;
    }
    
    window.flags = flags;
    window.active = true;
    gmui_array_clear(window.treeview_stack);
    
    // Reset max cursor for content size calculation
    window.max_cursor_x = 0;
    window.max_cursor_y = 0;
    
    // Calculate title bar height
    var has_title_bar = (flags & gmui_window_flags.NO_TITLE_BAR) == 0;
    var title_bar_height = has_title_bar ? global.gmui.style.title_bar_height : 0;
    
    // Check if scrollbars are enabled
    var has_vertical_scroll = (flags & gmui_window_flags.VERTICAL_SCROLL) != 0;
    var has_horizontal_scroll = (flags & gmui_window_flags.HORIZONTAL_SCROLL) != 0;
    var auto_scroll = (flags & gmui_window_flags.AUTO_SCROLL) != 0;
    var always_scrollbars = (flags & gmui_window_flags.ALWAYS_SCROLLBARS) != 0;
    
    // Calculate available space for content (accounting for scrollbars)
    var scrollbar_width = global.gmui.style.scrollbar_width;
    var content_width = window.width;
    var content_height = window.height - title_bar_height;
    
    if (has_vertical_scroll || (auto_scroll && always_scrollbars)) {
        content_width -= scrollbar_width;
    }
    if (has_horizontal_scroll || (auto_scroll && always_scrollbars)) {
        content_height -= scrollbar_width;
    }
    
    // Recreate surface if size changed
    var size_changed = window.width != w || window.height != h;
    if ((size_changed && !no_move) || !surface_exists(window.surface)) {
		surface_free(window.surface);
        gmui_create_surface(window);
    } else {
        window.surface_dirty = true;
    }
    
    // Reset DC with title bar offset and scroll
    var dc = window.dc;
    dc.cursor_x = global.gmui.style.window_padding[0];
    dc.cursor_y = global.gmui.style.window_padding[1] + title_bar_height;
    dc.cursor_start_x = dc.cursor_x;
    dc.cursor_start_y = dc.cursor_y;
    dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_previous_y = dc.cursor_y;
    dc.line_height = 0;
    dc.item_width = 0;
    dc.title_bar_height = title_bar_height;
    
    // Apply scroll offsets
    dc.scroll_offset_x = -window.scroll_x;
    dc.scroll_offset_y = -window.scroll_y;
    dc.cursor_x += dc.scroll_offset_x;
    dc.cursor_y += dc.scroll_offset_y;
    
	gmui_array_clear(window.draw_list);
    array_push(global.gmui.window_stack, window);
    global.gmui.current_window = window;
    
    // Draw background
    if ((flags & gmui_window_flags.NO_BACKGROUND) == 0) {
        gmui_add_rect_alpha(0, 0, window.width, window.height, global.gmui.style.background_color, global.gmui.style.background_alpha);
		if (!no_border) {
			gmui_add_rect_round_outline_alpha(0, 0, window.width - 1.5, window.height - 1.5, global.gmui.style.border_color, window.rounding ? global.gmui.style.window_rounding * 2 - 1 : -1, 1, global.gmui.style.background_alpha); // -1.5 is so stupid but works like a fucking charm
		}
    }
    
    // Draw title bar if enabled
    if (has_title_bar) {
        gmui_draw_title_bar(window, name);
    }
    
    // Setup scissor for content area (accounts for scrollbars)
    var scissor_x = 0;
    var scissor_y = title_bar_height;
    var scissor_width = content_width;
    var scissor_height = content_height;
    
    gmui_begin_scissor(scissor_x, scissor_y, scissor_width, scissor_height);
    
    // Handle window interaction (dragging, resizing)
    gmui_handle_window_interaction(window);
    
    return window.open;
}

function gmui_begin_menu(name, x = -1, y = -1, w = -1, h = -1, flags = gmui_pre_window_flags.MENU) {
	var style = global.gmui.style;
	
	if (x == -1) { x = 0; };
	if (y == -1) { y = 0; };
	if (w == -1) { w = surface_get_width(application_surface); };
	if (h == -1) { h = style.menu_height; };
	
	var begin_result = gmui_begin(name, x, y, w, h, flags);
	global.gmui.current_window.rounding = false;
	
	return begin_result;
};

function gmui_end_menu() {
	var window = global.gmui.current_window;
	var style = global.gmui.style;
	
	gmui_add_line(0, window.height - 1, window.width, window.height - 1, style.border_color, 1);
	
	gmui_end();
};

function gmui_begin_modal(name, x, y, w, h, flags, onBgClick = undefined) {
	if (gmui_begin(name + "_modal_background", 0, 0, surface_get_width(application_surface), surface_get_height(application_surface), gmui_window_flags.NO_TITLE_BAR | gmui_window_flags.NO_RESIZE | gmui_window_flags.NO_BACKGROUND | gmui_window_flags.NO_MOVE | gmui_window_flags.POPUP)) {
		if (gmui_is_mouse_over_window(global.gmui.current_window) && global.gmui.mouse_clicked[0] && onBgClick != undefined) { onBgClick(global.gmui.current_window); };
		gmui_end();
	};
	//gmui_bring_window_to_front(gmui_get_window(name + "_modal_background"));
	var result = gmui_begin(name, x, y, w, h, flags);
	//gmui_bring_window_to_front(gmui_get_window(name));
	return result;
};

function gmui_begin_sub_context_menu(name, x, y, w = 200, h = 200, flags = gmui_pre_window_flags.SUB_CONTEXT_MENU) {
	var parent = global.gmui.current_window;
	var result = gmui_begin(name, x, y, w, h, flags);
	global.gmui.current_window.z_index = parent.z_index;
	global.gmui.current_window.x = x;
	global.gmui.current_window.y = y;
	return result;
};

function gmui_open_modal(name) {
	var idx = gmui_get_window_idx(name + "_modal_background");
	gmui_get_windows()[| idx    ].open = true;
	gmui_get_windows()[| idx + 1].open = true;
	gmui_bring_window_to_front(gmui_get_windows()[| idx]);
	gmui_bring_window_to_front(gmui_get_windows()[| idx + 1]);
};

function gmui_close_modal(name) {
	var idx = gmui_get_window_idx(name + "_modal_background");
	gmui_get_windows()[| idx    ].open = false;
	gmui_get_windows()[| idx + 1].open = false;
};

function gmui_add_modal(name, call, x = -1, y = -1, w = 300, h = 100, flags = gmui_pre_window_flags.MODAL_DEFAULT, onBgClick = undefined) {
	ds_list_add(global.gmui.modals, [ name, call, x, y, w, h, flags, onBgClick ]);
};

function gmui_add_context_menu(name, call, x = -1, y = -1, w = 200, h = 200, flags = gmui_pre_window_flags.CONTEXT_MENU) {
	var onBgClick = function(window) {
		var _name = string_delete(window.name, string_length(window.name) - string_length("_modal_background") + 1, string_length("_modal_background"));
		gmui_close_context_menu(_name);
	};
	
	gmui_add_modal(name, call, x, y, w, h, flags, onBgClick);
};

function gmui_open_context_menu(name, x = -1, y = -1) {
	// use mouse coordinates if not given
	if (x == -1) { x = global.gmui.mouse_pos[0]; };
	if (y == -1) { y = global.gmui.mouse_pos[1]; };
	
	gmui_open_modal(name);
	gmui_set_window_position(name, x, y);
	
	array_foreach(ds_map_keys_to_array(global.gmui.context_menu_cache), function(e, i) {
		global.gmui.context_menu_cache[? e] = false;
	});
};

function gmui_close_context_menu(name) {
	gmui_close_modal(name);
};

function gmui_end(_no_repeat = false) {
    if (!global.gmui.initialized || array_length(global.gmui.window_stack) == 0) return;
    
    var window = global.gmui.current_window;
    var flags = window.flags;
	var style = global.gmui.style;
    
    // Update max cursor position for content size calculation
    window.max_cursor_x = max(window.max_cursor_x, window.dc.cursor_x - window.dc.scroll_offset_x);
    window.max_cursor_y = max(window.max_cursor_y, window.dc.cursor_y - window.dc.scroll_offset_y);
	
	// Auto Resize
	var always_auto_resize = (flags & gmui_window_flags.ALWAYS_AUTO_RESIZE) != 0;
	if (always_auto_resize) {
		var resize_surface = window.width != window.max_cursor_x || window.height != window.max_cursor_y;
		window.width = window.max_cursor_x;
		window.height = window.max_cursor_y;
		if (resize_surface) { gmui_create_surface(window); };
	};
    
    // Calculate content dimensions
    window.content_width = window.max_cursor_x + global.gmui.style.window_padding[0];
    window.content_height = window.max_cursor_y + global.gmui.style.window_padding[1];
    
    // End content scissor
    gmui_end_scissor();
    
    // Handle scrollbars
    gmui_handle_scrollbars(window);
    
    array_pop(global.gmui.window_stack);
    global.gmui.current_window = array_length(global.gmui.window_stack) > 0 ? 
        global.gmui.window_stack[array_length(global.gmui.window_stack) - 1] : undefined;
    
    // Handle color picker if active
    if (window.active_color_picker != undefined && !_no_repeat) {
		var picker_width = style.color_picker_width;
		var picker_height = style.color_picker_height + style.color_picker_hue_height + style.color_picker_alpha_height + style.color_picker_padding * 4;
		var _id = "###" + window.name + "_color_picker";
		if (gmui_begin(_id, global.gmui.mouse_pos[0], global.gmui.mouse_pos[1], picker_width, picker_height, gmui_window_flags.NO_TITLE_BAR | gmui_window_flags.NO_RESIZE)) {
			var w = global.gmui.current_window;
			
			w.active_color_picker			= window.active_color_picker;
			w.color_picker_value			= window.color_picker_value;
			w.color_picker_hue				= window.color_picker_hue;
			w.color_picker_saturation		= window.color_picker_saturation;
			w.color_picker_brightness		= window.color_picker_brightness;
			w.color_picker_alpha			= window.color_picker_alpha;
			w.color_picker_dragging			= window.color_picker_dragging;
			w.color_picker_drag_type		= window.color_picker_drag_type;
			
			gmui_color_picker();
			
			window.active_color_picker		= w.active_color_picker;
			window.color_picker_value		= w.color_picker_value;
			window.color_picker_hue			= w.color_picker_hue;
			window.color_picker_saturation	= w.color_picker_saturation;
			window.color_picker_brightness	= w.color_picker_brightness;
			window.color_picker_alpha		= w.color_picker_alpha;
			window.color_picker_dragging	= w.color_picker_dragging;
			window.color_picker_drag_type	= w.color_picker_drag_type;
			
			gmui_end(true);
		};
		if (global.gmui.to_delete_color_picker) {
			ds_list_delete(global.gmui.windows, ds_list_find_index(global.gmui.windows, gmui_get_window(_id)));
			global.gmui.to_delete_color_picker = false;
		};
    }
	
	if (window.active_combo != undefined && !_no_repeat) {
		var _id = "###" + window.name + "_combo_dropdown";
        var dropdown_height = min(style.combo_dropdown_max_height, window.combo_items_count * style.combo_item_height);
        var dropdown_width = window.combo_width;
		
		var dropdown_x = window.x + window.combo_x;
        var dropdown_y = window.y + window.combo_y + window.combo_height;
		
		var screen_height = surface_get_height(application_surface);
        if (dropdown_y + dropdown_height > screen_height) {
            dropdown_y = window.y + window.combo_y - dropdown_height;
        }
		
		if (gmui_begin(_id, dropdown_x, dropdown_y, dropdown_width, dropdown_height, gmui_window_flags.NO_TITLE_BAR | gmui_window_flags.NO_RESIZE)) {
			var w = global.gmui.current_window;
			
			w.active_combo				= window.active_combo;
			w.combo_items				= window.combo_items;
			w.combo_items_count			= window.combo_items_count;
			w.combo_current_index		= window.combo_current_index;
			w.combo_width				= window.combo_width;
			w.combo_x					= window.combo_x;
			w.combo_y					= window.combo_y;
			w.combo_height				= window.combo_height;
            
            gmui_combo_dropdown();
			
			window.active_combo			= w.active_combo;
			window.combo_items			= w.combo_items;
			window.combo_items_count	= w.combo_items_count;
			window.combo_current_index  = w.combo_current_index;
			window.combo_width			= w.combo_width;
			window.combo_x				= w.combo_x;
			window.combo_y				= w.combo_y;
			window.combo_height			= w.combo_height;
            
            gmui_end(true);
		};
		if (global.gmui.to_delete_combo) {
			ds_list_delete(global.gmui.windows, ds_list_find_index(global.gmui.windows, gmui_get_window(_id)));
			global.gmui.to_delete_combo = false;
		};
	};
}

function gmui_cleanup() {
    if (global.gmui && global.gmui.initialized) {
        // Clean up windows
        for (var i = 0; i < ds_list_size(global.gmui.windows); i++) {
            var window = global.gmui.windows[| i];
            
            // Free surface
            if (surface_exists(window.surface)) surface_free(window.surface);
            
            // Free window's treeview_open_nodes
            if (ds_exists(window.treeview_open_nodes, ds_type_map)) {
                ds_map_destroy(window.treeview_open_nodes);
            }
        }
		ds_list_destroy(global.gmui.modals);
        ds_list_destroy(global.gmui.windows);
        
        // Clean up z-order data structure
        if (ds_exists(global.gmui.window_z_order, ds_type_priority)) {
            ds_priority_destroy(global.gmui.window_z_order);
        }
        
        // Clean up global treeview_open_nodes
        if (ds_exists(global.gmui.treeview_open_nodes, ds_type_map)) {
            ds_map_destroy(global.gmui.treeview_open_nodes);
        }
        
		// Clean up cache
		gmui_cleanup_cache();
		
        // Clean up cache surfaces
        var cache_keys = ds_map_keys_to_array(global.gmui.cache_surfaces);
        for (var i = 0; i < array_length(cache_keys); i++) {
            var surface_data = global.gmui.cache_surfaces[? cache_keys[i]];
            if (surface_exists(surface_data.surface)) {
                surface_free(surface_data.surface);
            }
        }
		
		// Clean up cache
		ds_map_destroy(global.gmui.cache);
		ds_map_destroy(global.gmui.context_menu_cache);
		
		// Clean up table map
		if (ds_exists(global.gmui.tables, ds_type_map)) {
			ds_map_destroy(global.gmui.tables);
		}
		
		// Clean the search engine
		gmui_ls_cleanup();
        
        global.gmui = undefined;
    }
}

function gmui_cleanup_cache() {
    var to_delete = [];
    var keys = ds_map_keys_to_array(global.gmui.cache_surfaces);
    for (var i = 0; i < array_length(keys); i++) {
        var key = keys[i];
        var surface_data = global.gmui.cache_surfaces[? key];
        var difference = current_time - surface_data.time_start;
        if (difference >= surface_data.sleep_timer * 1000) {
            if (surface_exists(surface_data.surface)) {
                surface_free(surface_data.surface);
            }
            array_push(to_delete, key);
        }
    }
    
    for (var i = 0; i < array_length(to_delete); i++) {
        ds_map_delete(global.gmui.cache_surfaces, to_delete[i]);
        gmui_cache_delete(to_delete[i]);
    }
}

function gmui_set_window_position(name, x, y) {
    if (!global.gmui.initialized) return false;
    
    var window = gmui_get_window(name);
    if (!window) return false;
    
    window.x = x;
    window.y = y;
    return true;
}

function gmui_set_window_size(name, width, height) {
    if (!global.gmui.initialized) return false;
    
    var window = gmui_get_window(name);
    if (!window) return false;
    
    window.width = max(global.gmui.style.window_min_size[0], width);
    window.height = max(global.gmui.style.window_min_size[1], height);
    gmui_create_surface(window); // Recreate surface with new size
    return true;
}

function gmui_reset_window(name) {
    if (!global.gmui.initialized) return false;
    
    var window = gmui_get_window(name);
    if (!window) return false;
    
    window.x = window.initial_x;
    window.y = window.initial_y;
    window.width = window.initial_width;
    window.height = window.initial_height;
    window.first_frame = true; // Allow repositioning on next begin
    gmui_create_surface(window);
    return true;
}

//////////////////////////////////////
// INPUT
//////////////////////////////////////
function gmui_update_input() {
    if (!global.gmui.initialized) return;
    
	var mouse_pos = gmui_cache_get("array.mouse_pos");
	
    global.gmui.mouse_pos[0] = device_mouse_x_to_gui(0);
    global.gmui.mouse_pos[1] = device_mouse_y_to_gui(0);
    
	var mb_array = gmui_cache_get("array.mb_array");
	
    for (var i = 0; i < 5; i++) {
        global.gmui.mouse_clicked[i] = mouse_check_button_pressed(mb_array[i]);
        global.gmui.mouse_released[i] = mouse_check_button_released(mb_array[i]);
        global.gmui.mouse_down[i] = mouse_check_button(mb_array[i]);
    }
    
    global.gmui.frame_count++;
	
	window_set_cursor(cr_arrow);
	
	// Handle textbox input if one is active
	if (global.gmui.active_textbox != undefined) {
	    var textbox = global.gmui.active_textbox;
    
	    // Reset changed flag
	    textbox.changed = false;
    
	    // Handle keyboard input - only process on press, not hold
	    var key_pressed = keyboard_check_pressed(vk_anykey);
    
	    if (key_pressed) {
	        // Handle special keys
	        var char = keyboard_lastchar;
	        var key = keyboard_key;
	        var keycode = keyboard_lastkey;
        
	        // Check if this is a modifier key that should be ignored
	        var is_modifier = (keycode == vk_shift || keycode == vk_control || keycode == vk_alt || 
	                          keycode == vk_lshift || keycode == vk_rshift || 
	                          keycode == vk_lcontrol || keycode == vk_rcontrol ||
	                          keycode == vk_lalt || keycode == vk_ralt);
        
	        // Ignore modifier keys alone
	        if (!is_modifier) {
	            // Backspace
	            if (key == vk_backspace) {
	                if (textbox.selection_length > 0) {
	                    // Delete selection
	                    textbox.text = string_delete(textbox.text, textbox.selection_start + 1, textbox.selection_length);
	                    textbox.cursor_pos = textbox.selection_start;
	                    textbox.selection_length = 0;
	                    textbox.changed = true;
	                } else if (textbox.cursor_pos > 0) {
	                    textbox.text = string_delete(textbox.text, textbox.cursor_pos, 1);
	                    textbox.cursor_pos--;
	                    textbox.changed = true;
	                }
	            }
	            // Delete
	            else if (key == vk_delete) {
	                if (textbox.selection_length > 0) {
	                    textbox.text = string_delete(textbox.text, textbox.selection_start + 1, textbox.selection_length);
	                    textbox.cursor_pos = textbox.selection_start;
	                    textbox.selection_length = 0;
	                    textbox.changed = true;
	                } else if (textbox.cursor_pos < string_length(textbox.text)) {
	                    textbox.text = string_delete(textbox.text, textbox.cursor_pos + 1, 1);
	                    textbox.changed = true;
	                }
	            }
				// Left arrow
				else if (key == vk_left) {
				    if (keyboard_check(vk_shift)) {
				        // Shift+Left: Extend selection left
				        if (textbox.cursor_pos > 0) {
				            if (textbox.selection_length == 0) {
				                // No existing selection - start selecting left
				                textbox.selection_start = textbox.cursor_pos - 1;
				                textbox.selection_length = 1;
				                textbox.cursor_pos--;
				            } else if (textbox.cursor_pos == textbox.selection_start + textbox.selection_length) {
				                // Cursor at end of selection - shrink from right
				                textbox.selection_length--;
				                textbox.cursor_pos--;
				            } else if (textbox.cursor_pos == textbox.selection_start) {
				                // Cursor at start of selection - extend left
				                textbox.selection_start--;
				                textbox.selection_length++;
				                textbox.cursor_pos--;
				            }
				        }
				    } else {
				        // Left without shift: move cursor and clear selection
				        if (textbox.cursor_pos > 0) {
				            textbox.cursor_pos--;
				        }
				        textbox.selection_length = 0;
				    }
				}
				// Right arrow
				else if (key == vk_right) {
				    if (keyboard_check(vk_shift)) {
				        // Shift+Right: Extend selection right
				        if (textbox.cursor_pos < string_length(textbox.text)) {
				            if (textbox.selection_length == 0) {
				                // No existing selection - start selecting right
				                textbox.selection_start = textbox.cursor_pos;
				                textbox.selection_length = 1;
				                textbox.cursor_pos++;
				            } else if (textbox.cursor_pos == textbox.selection_start) {
				                // Cursor at start of selection - shrink from left
				                textbox.selection_start++;
				                textbox.selection_length--;
				                textbox.cursor_pos++;
				            } else if (textbox.cursor_pos == textbox.selection_start + textbox.selection_length) {
				                // Cursor at end of selection - extend right
				                textbox.selection_length++;
				                textbox.cursor_pos++;
				            }
				        }
				    } else {
				        // Right without shift: move cursor and clear selection
				        if (textbox.cursor_pos < string_length(textbox.text)) {
				            textbox.cursor_pos++;
				        }
				        textbox.selection_length = 0;
				    }
				}
	            // Home
	            else if (key == vk_home) {
	                if (keyboard_check(vk_shift)) {
	                    // Select to beginning
	                    textbox.selection_start = 0;
	                    textbox.selection_length = textbox.cursor_pos;
	                } else {
	                    textbox.selection_length = 0;
	                }
	                textbox.cursor_pos = 0;
	            }
	            // End
	            else if (key == vk_end) {
	                var len = string_length(textbox.text);
	                if (keyboard_check(vk_shift)) {
	                    // Select to end
	                    textbox.selection_start = textbox.cursor_pos;
	                    textbox.selection_length = len - textbox.cursor_pos;
	                } else {
	                    textbox.selection_length = 0;
	                }
	                textbox.cursor_pos = len;
	            }
	            // Ctrl+A (select all)
	            else if (keyboard_check(vk_control) && key == ord("A")) {
	                textbox.selection_start = 0;
	                textbox.selection_length = string_length(textbox.text);
	                textbox.cursor_pos = string_length(textbox.text);
	            }
	            // Ctrl+C (copy)
	            else if (keyboard_check(vk_control) && key == ord("C")) {
	                if (textbox.selection_length > 0) {
	                    clipboard_set_text(string_copy(textbox.text, textbox.selection_start + 1, textbox.selection_length));
	                }
	            }
	            // Ctrl+X (cut)
	            else if (keyboard_check(vk_control) && key == ord("X")) {
	                if (textbox.selection_length > 0) {
	                    clipboard_set_text(string_copy(textbox.text, textbox.selection_start + 1, textbox.selection_length));
	                    textbox.text = string_delete(textbox.text, textbox.selection_start + 1, textbox.selection_length);
	                    textbox.cursor_pos = textbox.selection_start;
	                    textbox.selection_length = 0;
	                    textbox.changed = true;
	                }
	            }
	            // Ctrl+V (paste)
	            else if (keyboard_check(vk_control) && key == ord("V")) {
	                var paste_text = clipboard_get_text();
	                if (paste_text != "") {
	                    if (textbox.selection_length > 0) {
	                        textbox.text = string_delete(textbox.text, textbox.selection_start + 1, textbox.selection_length);
	                        textbox.cursor_pos = textbox.selection_start;
	                        textbox.selection_length = 0;
	                    }
	                    textbox.text = string_insert(paste_text, textbox.text, textbox.cursor_pos + 1);
	                    textbox.cursor_pos += string_length(paste_text);
	                    textbox.changed = true;
	                }
	            }
	            // Enter or Escape to defocus
	            else if (key == vk_escape) { // key == vk_enter || key == vk_escape
	                global.gmui.active_textbox = undefined;
	            }
	            // Regular character input
	            else if (char != "" && string_byte_length(char) == 1) {
				    // Filter out control characters and only allow printable characters
				    var byte = string_byte_at(char, 1);
				    if (byte >= 32 && byte <= 126) { // Printable ASCII range
        
				        // Check if this is a digit-only textbox
				        if (textbox.is_digit_only != undefined && textbox.is_digit_only) {
				            // For digit-only textboxes, only allow digits, minus, and decimal
				            var is_digit = (byte >= 48 && byte <= 57); // 0-9
				            var is_minus = (char == "-") && textbox.cursor_pos == 0; // Minus only at start
				            var is_decimal = (char == ".") && (textbox.is_integer_only == undefined || !textbox.is_integer_only); // Decimal only if not integer-only
            
				            if (!is_digit && !is_minus && !is_decimal) {
				                // Invalid character for digit-only textbox, skip
				                //continue;
				            }
            
				            // Additional check for decimal point (only one allowed)
				            if (is_decimal) {
				                var has_decimal = string_pos(".", textbox.text) > 0;
				                if (has_decimal) {
				                    //continue; // Already has decimal, skip
				                }
				            }
				        }
        
				        if (textbox.selection_length > 0) {
				            textbox.text = string_delete(textbox.text, textbox.selection_start + 1, textbox.selection_length);
				            textbox.cursor_pos = textbox.selection_start;
				            textbox.selection_length = 0;
				        }
				        textbox.text = string_insert(char, textbox.text, textbox.cursor_pos + 1);
				        textbox.cursor_pos++;
				        textbox.changed = true;
				    }
				}
	        }
        
	        // Reset cursor blink when typing
	        global.gmui.textbox_cursor_timer = 0;
	        global.gmui.textbox_cursor_visible = true;
	    }
	}
	
	global.gmui.mouse_pos = mouse_pos;
}

function gmui_update() {
	global.gmui.is_hovering_element = false;
	gmui_update_input();
	ds_list_clear(global.gmui.modals);
	var cache_surfaces_values = gmui_cache_get("array.cache_surfaces.values");
	ds_map_values_to_array(global.gmui.cache_surfaces, cache_surfaces_values);
	array_foreach(cache_surfaces_values, function(e, i) {
	    var surface = e;
		var c_time = current_time;
		var difference = c_time - surface.time_start;
		if (difference >= surface.sleep_timer * 1000) {
			gmui_cache_delete(surface.id);
			ds_map_delete(global.gmui.cache_surfaces, surface.id);
		};
	});
	gmui_array_clear(cache_surfaces_values);
};

function gmui_handle_modals() {
	var modals = global.gmui.modals;
	for (var i = 0; i < ds_list_size(modals); i++) {
		var modal = modals[| i];
		var name = modal[0];
		var call = modal[1];
		var wx = modal[2];
		var wy = modal[3];
		var ww = modal[4];
		var wh = modal[5];
		var flags = modal[6];
		var onBgClick = modal[7];
		
		wx = wx == -1 ? surface_get_width(application_surface) / 2 - ww / 2 : wx;
		wy = wy == -1 ? surface_get_height(application_surface) / 2 - wh / 2 : wy;
		
		if (gmui_begin_modal(name, wx, wy, ww, wh, flags, onBgClick)) {
			var is_context_menu = (flags & gmui_pre_window_flags.CONTEXT_MENU) != 0; // this is a temporary solution, if user decides to use custom flags, this method will fail
			if (is_context_menu) {
				global.gmui.current_context_menu = global.gmui.current_window;
				global.gmui.current_context_menu_bg = gmui_get_window(global.gmui.current_context_menu.name + "_modal_background");
			}
			call(gmui_get_window(name));
			gmui_end();
			if (is_context_menu) {
				global.gmui.current_context_menu = undefined;
				global.gmui.current_context_menu_bg = undefined;
			}
		};
	};
};

//////////////////////////////////////
// RENDER (Rendering, surface management)
//////////////////////////////////////
function gmui_render_surface(window) {
    if (!surface_exists(window.surface) || !window.surface_dirty) return;
    
    surface_set_target(window.surface);
    draw_clear_alpha(c_black, 0);
    
    var old_font = draw_get_font();
    draw_set_font(global.gmui.font);
    
    // Track scissor state
    var scissor_enabled = false;
    var scissor_rect = [0, 0, 0, 0];
    
    for (var i = 0; i < array_length(window.draw_list); i++) {
        var cmd = window.draw_list[i];
        
        // Handle scissor commands
        switch (cmd.type) {
            case "scissor":
                gpu_set_scissor(cmd.x, cmd.y, cmd.width, cmd.height);
                scissor_enabled = true;
                scissor_rect = [cmd.x, cmd.y, cmd.width, cmd.height];
                continue; // Skip to next command
                
            case "scissor_reset":
                // Reset scissor by setting it to the entire surface
                gpu_set_scissor(0, 0, window.width, window.height);
                scissor_enabled = false;
                continue; // Skip to next command
        }
        
        // Only process drawing commands if we're not in a scissor command
        switch (cmd.type) {
            case "rect":
                draw_set_color(cmd.color);
                draw_rectangle(cmd.x, cmd.y, cmd.x + cmd.width, cmd.y + cmd.height, false);
                break;
				
            case "rect_alpha":
				draw_set_alpha(cmd.alpha);
                draw_set_color(cmd.color);
                draw_rectangle(cmd.x, cmd.y, cmd.x + cmd.width, cmd.y + cmd.height, false);
                draw_set_alpha(1);
				break;
                
            case "rect_outline":
                draw_set_color(cmd.color);
                draw_rectangle(cmd.x, cmd.y, cmd.x + cmd.width, cmd.y + cmd.height, true);
                break;
            case "rect_outline_alpha":
				draw_set_alpha(cmd.alpha);
                draw_set_color(cmd.color);
                draw_rectangle(cmd.x, cmd.y, cmd.x + cmd.width, cmd.y + cmd.height, true);
                draw_set_alpha(1);
                break;
			
			case "rect_round":
				draw_set_color(cmd.color);
				draw_roundrect_ext(cmd.x, cmd.y, cmd.x + cmd.width, cmd.y + cmd.height, cmd.rounding, cmd.rounding, false);
				break;
			case "rect_round_outline":
				draw_set_color(cmd.color);
				draw_roundrect_ext(cmd.x, cmd.y, cmd.x + cmd.width, cmd.y + cmd.height, cmd.rounding, cmd.rounding, true);
				break;
			case "rect_round_alpha":
				draw_set_alpha(cmd.alpha);
				draw_set_color(cmd.color);
				draw_roundrect_ext(cmd.x, cmd.y, cmd.x + cmd.width, cmd.y + cmd.height, cmd.rounding, cmd.rounding, false);
				draw_set_alpha(1);
				break;
			case "rect_round_outline_alpha":
				draw_set_alpha(cmd.alpha);
				draw_set_color(cmd.color);
				draw_roundrect_ext(cmd.x, cmd.y, cmd.x + cmd.width, cmd.y + cmd.height, cmd.rounding, cmd.rounding, true);
				draw_set_alpha(1);
				break;
                
            case "text":
				if (string_copy(cmd.text, 1, 2) == "##") { break; }; // dont render texts those start with prefix '##'
				var oldBlendMode = gpu_get_blendmode();
				gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_one, bm_inv_src_alpha);
				draw_set_color(cmd.color);
                draw_text(cmd.x, cmd.y, cmd.text);
				gpu_set_blendmode(oldBlendMode);
                break;
                
            case "line":
                draw_set_color(cmd.color);
                draw_line_width(cmd.x1, cmd.y1, cmd.x2, cmd.y2, cmd.thickness);
                break;
                
			case "surface":
			    if (surface_exists(cmd.surface)) {
			        draw_surface(cmd.surface, cmd.x, cmd.y);
			        // Free the surface after drawing (text surfaces are temporary)
			        surface_free(cmd.surface);
			    }
			    break;
                
			case "surface_o":
			    if (surface_exists(cmd.surface)) {
			        draw_surface(cmd.surface, cmd.x, cmd.y);
			    }
			    break;
			    
			case "triangle":
			    draw_set_color(cmd.color);
			    draw_primitive_begin(pr_trianglelist);
			    draw_vertex(cmd.x1, cmd.y1);
			    draw_vertex(cmd.x2, cmd.y2);
			    draw_vertex(cmd.x3, cmd.y3);
			    draw_primitive_end();
			    break;
			    
			case "sprite":
			    draw_sprite_ext(cmd.spr, cmd.index, cmd.x, cmd.y, cmd.width / sprite_get_width(cmd.spr), cmd.height / sprite_get_height(cmd.spr), 0, #ffffff, 1);
			    break;
			
			case "shader_rect":
			    shader_set(cmd.shader);
    
			    // Set uniforms
			    for (var j = 0; j < array_length(cmd.uniforms); j++) {
			        var uniform = cmd.uniforms[j];
			        switch (uniform.type) {
			            case "float":
			                shader_set_uniform_f(shader_get_uniform(cmd.shader, uniform.name), uniform.value);
			                break;
			            case "vec2":
			                shader_set_uniform_f(shader_get_uniform(cmd.shader, uniform.name), uniform.value[0], uniform.value[1]);
			                break;
			            case "vec3":
			                shader_set_uniform_f(shader_get_uniform(cmd.shader, uniform.name), uniform.value[0], uniform.value[1], uniform.value[2]);
			                break;
			            case "vec4":
			                shader_set_uniform_f(shader_get_uniform(cmd.shader, uniform.name), uniform.value[0], uniform.value[1], uniform.value[2], uniform.value[3]);
			                break;
			        }
			    }
    
			    //draw_rectangle(cmd.x, cmd.y, cmd.x + cmd.width, cmd.y + cmd.height, false);
				draw_primitive_begin_texture(pr_trianglelist, -1);
				draw_vertex_texture(cmd.x, cmd.y + cmd.height, 0, 1);
				draw_vertex_texture(cmd.x, cmd.y, 0, 0);
				draw_vertex_texture(cmd.x + cmd.width, cmd.y, 1, 0);
				
				draw_vertex_texture(cmd.x + cmd.width, cmd.y + cmd.height, 1, 1);
				draw_vertex_texture(cmd.x, cmd.y + cmd.height, 0, 1);
				draw_vertex_texture(cmd.x + cmd.width, cmd.y, 1, 0);
				draw_primitive_end();
				
			    shader_reset();
			    break;
        }
    }
    
    // Reset scissor to ensure clean state by setting to full surface
    if (scissor_enabled) {
        gpu_set_scissor(0, 0, window.width, window.height);
    }
    
    draw_set_font(old_font);
    surface_reset_target();
    window.surface_dirty = false;
}

function gmui_render() {
    if (!global.gmui.initialized) return;
	
	gmui_handle_modals();
	
	global.gmui.hovering_window = undefined;

	// Check from highest z-index to lowest (front to back)
	var hover_sorted = ds_priority_create();
	for (var i = 0; i < ds_list_size(global.gmui.windows); i++) {
	    var window = global.gmui.windows[| i];
	    if (window.active && window.open) {
	        ds_priority_add(hover_sorted, window, window.z_index);
	    }
	}

	var hover_count = ds_priority_size(hover_sorted);
	for (var i = 0; i < hover_count; i++) {
	    var window = ds_priority_delete_max(hover_sorted); // Get from highest to lowest
	    var mouse_over = (device_mouse_x_to_gui(0) > window.x && device_mouse_x_to_gui(0) < window.x + window.width) && 
	                    (device_mouse_y_to_gui(0) > window.y && device_mouse_y_to_gui(0) < window.y + window.height);
	    if (mouse_over) { 
	        global.gmui.hovering_window = window; 
	        break; 
	    };
	}

	ds_priority_destroy(hover_sorted);
	
	// Create a list of windows sorted by z-index (lowest first)
    var sorted_windows = ds_priority_create();
    for (var i = 0; i < ds_list_size(global.gmui.windows); i++) {
        var window = global.gmui.windows[| i];
        if (window.active && window.open) {
            ds_priority_add(sorted_windows, window, window.z_index);
        }
    }
    
    // Render windows from lowest z-index to highest (back to front)
    var count = ds_priority_size(sorted_windows);
    for (var i = 0; i < count; i++) {
        var window = ds_priority_delete_min(sorted_windows);
        gmui_render_surface(window);
		
		// //gmui_add_shader_rect(0, 0, window.width, window.height, gmui_shader_roundrect, [ { type: "vec2", name: "u_size", value: [ window.width, window.height ] }, { type: "float", name: "u_radius", value: global.gmui.style.window_rounding }, { type: "float", name: "u_smooth", value: 2 }, { type: "vec4", name: "u_color", value: [ 0, 0, 0, 0 ] } ])
		if (window.rounding) {
			shader_set(gmui_shader_roundrect);
			shader_set_uniform_f(shader_get_uniform(gmui_shader_roundrect, "u_size"), window.width, window.height);
			shader_set_uniform_f(shader_get_uniform(gmui_shader_roundrect, "u_radius"), global.gmui.style.window_rounding);
			shader_set_uniform_f(shader_get_uniform(gmui_shader_roundrect, "u_smooth"), 0);
			shader_set_uniform_f(shader_get_uniform(gmui_shader_roundrect, "u_color"), 1, 1, 1, 1);
	        draw_surface(window.surface, window.x, window.y);
			shader_reset();
		}
		else {
	        draw_surface(window.surface, window.x, window.y);
		}
		
        window.active = false;
    }
    
    ds_priority_destroy(sorted_windows);
	
	if (global.gmui.mouse_released[0] && global.gmui.last_pressed_clickable_id != undefined) {
		global.gmui.last_pressed_clickable_id = undefined;
	}
	
	/////////////////////////////////////
    
    //var names = variable_struct_get_names(global.gmui.windows);
	//var secondaries = array_create(100);
	//var secondariesCount = 0;
	//
	//// hovering
	//global.gmui.hovering_window = undefined;
    //for (var i = ds_list_size(global.gmui.windows) - 1; i >= 0; i--) {
    //    var window = global.gmui.windows[| i];
    //    if (window.active && window.open) {
	//		var mouse_over = (device_mouse_x_to_gui(0) > window.x && device_mouse_x_to_gui(0) < window.x + window.width) && (device_mouse_y_to_gui(0) > window.y && device_mouse_y_to_gui(0) < window.y + window.height);
	//		if (mouse_over) { global.gmui.hovering_window = window; break; };
    //    }
    //}
	//
	//// rendering
    //for (var i = 0; i < ds_list_size(global.gmui.windows); i++) {
    //    var window = global.gmui.windows[| i];
	//	
	//	// push if secondary
	//	if (string_copy(window.name, 1, 3) == "###") {
	//		secondaries[secondariesCount] = window;
	//		secondariesCount++;
	//		continue;
	//	};
	//	
    //    if (window.active && window.open) {
    //        gmui_render_surface(window);
    //        draw_surface(window.surface, window.x, window.y);
    //        window.active = false;
    //    }
    //}
	//
	//// render secondaries
    //for (var i = 0; i < secondariesCount; i++) {
    //    var window = secondaries[i];
	//	
    //    if (window.active && window.open) {
    //        gmui_render_surface(window);
    //        draw_surface(window.surface, window.x, window.y);
    //        window.active = false;
    //    }
    //}
}

function gmui_add_sprite(x, y, w, h, sprite, subimg = 0) {
    if (!global.gmui.initialized || !global.gmui.current_window) return;
    array_push(global.gmui.current_window.draw_list, {
        type: "sprite", spr: sprite, x: x, y: y, width: w, height: h, index: subimg
    });
}

function gmui_add_rect(x, y, w, h, col) {
    if (!global.gmui.initialized || !global.gmui.current_window) return;
    array_push(global.gmui.current_window.draw_list, {
        type: "rect", x: x, y: y, width: w, height: h, color: col
    });
}

function gmui_add_rect_alpha(x, y, w, h, col, a) {
    if (!global.gmui.initialized || !global.gmui.current_window) return;
    array_push(global.gmui.current_window.draw_list, {
        type: "rect_alpha", x: x, y: y, width: w, height: h, color: col, alpha: a
    });
}

function gmui_add_rect_outline(x, y, w, h, col, thickness) {
    if (!global.gmui.initialized || !global.gmui.current_window) return;
    array_push(global.gmui.current_window.draw_list, {
        type: "rect_outline", x: x, y: y, width: w, height: h, color: col, thickness: thickness
    });
}

function gmui_add_rect_outline_alpha(x, y, w, h, col, thickness, a) {
    if (!global.gmui.initialized || !global.gmui.current_window) return;
    array_push(global.gmui.current_window.draw_list, {
        type: "rect_outline", x: x, y: y, width: w, height: h, color: col, thickness: thickness, alpha: a
    });
}

function gmui_add_rect_round(x, y, w, h, col, rnd) {
    if (!global.gmui.initialized || !global.gmui.current_window) return;
    array_push(global.gmui.current_window.draw_list, {
        type: "rect_round", x: x, y: y, width: w, height: h, color: col, rounding: rnd
    });
}

function gmui_add_rect_round_outline(x, y, w, h, col, rnd, thickness) {
    if (!global.gmui.initialized || !global.gmui.current_window) return;
    array_push(global.gmui.current_window.draw_list, {
        type: "rect_round_outline", x: x, y: y, width: w, height: h, color: col, rounding: rnd, thickness: thickness
    });
}

function gmui_add_rect_round_outline_alpha(x, y, w, h, col, rnd, thickness, a) {
    if (!global.gmui.initialized || !global.gmui.current_window) return;
    array_push(global.gmui.current_window.draw_list, {
        type: "rect_round_outline_alpha", x: x, y: y, width: w, height: h, color: col, rounding: rnd, thickness: thickness, alpha: a
    });
}

function gmui_add_rect_round_alpha(x, y, w, h, col, rnd, a) {
    if (!global.gmui.initialized || !global.gmui.current_window) return;
    array_push(global.gmui.current_window.draw_list, {
        type: "rect_round_alpha", x: x, y: y, width: w, height: h, color: col, rounding: rnd, alpha: a
    });
}

function gmui_add_text(x, y, text, col) {
    if (!global.gmui.initialized || !global.gmui.current_window) return;
    array_push(global.gmui.current_window.draw_list, {
        type: "text", x: x, y: y, text: text, color: col
    });
}

function gmui_add_line(x1, y1, x2, y2, col, thickness) {
    if (!global.gmui.initialized || !global.gmui.current_window) return;
    
    array_push(global.gmui.current_window.draw_list, {
        type: "line", 
        x1: x1, y1: y1, x2: x2, y2: y2, 
        color: col, thickness: thickness
    });
}

function gmui_add_triangle(x1, y1, x2, y2, x3, y3, col) {
    if (!global.gmui.initialized || !global.gmui.current_window) return;
    array_push(global.gmui.current_window.draw_list, {
        type: "triangle",
        x1: x1, y1: y1,
        x2: x2, y2: y2, 
        x3: x3, y3: y3,
        color: col
    });
}

function gmui_add_shader_rect(x, y, w, h, shader, uniforms) {
    if (!global.gmui.initialized || !global.gmui.current_window) return;
    array_push(global.gmui.current_window.draw_list, {
        type: "shader_rect",
        x: x, y: y, width: w, height: h,
        shader: shader,
        uniforms: uniforms
    });
}

function gmui_add_surface(x, y, surface) {
    if (!global.gmui.initialized || !global.gmui.current_window) return;
    array_push(global.gmui.current_window.draw_list, {
        type: "surface_o",
        x: x, y: y, surface: surface
    });
};

function gmui_add_circle(x, y, radius, color) {
    if (!global.gmui.initialized || !global.gmui.current_window) return;
    
    // Draw circle using multiple line segments
    var segments = 32;
    var angle_step = 2 * pi / segments;
    
    for (var i = 0; i < segments; i++) {
        var angle1 = i * angle_step;
        var angle2 = (i + 1) * angle_step;
        
        var x1 = x + cos(angle1) * radius;
        var y1 = y + sin(angle1) * radius;
        var x2 = x + cos(angle2) * radius;
        var y2 = y + sin(angle2) * radius;
        
        gmui_add_line(x1, y1, x2, y2, color, 1);
    }
}

function gmui_add_circle_outline(x, y, radius, color, thickness) {
    if (!global.gmui.initialized || !global.gmui.current_window) return;
    
    // Draw circle outline using multiple line segments
    var segments = 32;
    var angle_step = 2 * pi / segments;
    
    for (var i = 0; i < segments; i++) {
        var angle1 = i * angle_step;
        var angle2 = (i + 1) * angle_step;
        
        var x1 = x + cos(angle1) * radius;
        var y1 = y + sin(angle1) * radius;
        var x2 = x + cos(angle2) * radius;
        var y2 = y + sin(angle2) * radius;
        
        gmui_add_line(x1, y1, x2, y2, color, thickness);
    }
}

function gmui_add_arc(x, y, radius, thickness, start_angle, end_angle, color) {
    if (!global.gmui.initialized || !global.gmui.current_window) return;
    
    // Draw arc using line segments
    var segments = 32;
    var total_angle = end_angle - start_angle;
    var angle_step = total_angle / segments;
    
    for (var i = 0; i < segments; i++) {
        var angle1 = start_angle + i * angle_step;
        var angle2 = start_angle + (i + 1) * angle_step;
        
        var x1 = x + cos(angle1) * radius;
        var y1 = y + sin(angle1) * radius;
        var x2 = x + cos(angle2) * radius;
        var y2 = y + sin(angle2) * radius;
        
        gmui_add_line(x1, y1, x2, y2, color, thickness);
    }
}

/************************************
 * ELEMENTS
 ***********************************/
//////////////////////////////////////
// BASIC (Text, labels, buttons)
//////////////////////////////////////
function gmui_progress_bar(label, value, min_value = 0, max_value = 1, width = -1, height = -1, show_text = true) {
    if (!global.gmui.initialized || !global.gmui.current_window) return value;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
    
    // Calculate progress bar size
    var text_size = gmui_calc_text_size(label);
    var bar_height = (height > 0) ? height : style.progress_bar_height;
    var bar_width = (width > 0) ? width : window.width - style.window_padding[0] * 2;
    
    if (label != "") {
        bar_width -= text_size[0] + style.item_spacing[0];
    }
    
    // Total width needed (label + progress bar)
    var total_width = bar_width;
    if (label != "") {
        total_width += text_size[0] + style.item_spacing[0];
    }
    
    var total_height = max(bar_height, text_size[1]);
    
    // Calculate progress bar bounds
    var bar_x = dc.cursor_x;
    var bar_y = dc.cursor_y;
    
    // Draw label if provided
    if (label != "") {
        var label_x = bar_x;
        var label_y = bar_y + (total_height - text_size[1]) / 2;
        gmui_add_text(label_x, label_y, label, style.text_color);
        bar_x += text_size[0] + style.item_spacing[0];
    }
    
    var bar_bounds = [bar_x, bar_y, bar_x + bar_width, bar_y + bar_height];
    
    // Calculate normalized value
    var normalized_value = clamp((value - min_value) / (max_value - min_value), 0, 1);
    var fill_width = bar_width * normalized_value;
    
    // Check for mouse interaction (for hover effects)
    var mouse_over = gmui_is_mouse_over_window(window) && 
                    gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, 
                                        global.gmui.mouse_pos[1] - window.y, 
                                        bar_bounds) && !global.gmui.is_hovering_element;
    
    // Draw progress bar background
    gmui_add_rect_round(bar_x, bar_y, bar_width, bar_height, 
                    style.progress_bar_bg_color, style.progress_bar_rounding);
    
    // Draw border
    if (style.progress_bar_border_size > 0) {
        gmui_add_rect_round_outline(bar_x, bar_y, bar_width, bar_height, 
                                style.progress_bar_border_color, 
                                style.progress_bar_rounding, 
                                style.progress_bar_border_size);
    }
    
    // Draw fill
    if (fill_width > 0) {
        var fill_color = style.progress_bar_fill_color;
        if (mouse_over && window.active) {
            fill_color = style.progress_bar_fill_hover_color;
            global.gmui.is_hovering_element = true;
        }
        
        // Clip fill to rounded rectangle
        if (fill_width >= bar_width) {
            // Full fill
            gmui_add_rect_round(bar_x, bar_y, fill_width, bar_height, 
                            fill_color, style.progress_bar_rounding);
        } else if (fill_width > 0) {
            // Partial fill - need to handle rounded corners
            // For simplicity, draw rectangle with left rounding only
            gmui_add_rect_round(bar_x, bar_y, fill_width, bar_height, 
                            fill_color, style.progress_bar_rounding);
            
            // Draw a small rectangle to cover the right side rounding
            if (fill_width > style.progress_bar_rounding) {
                gmui_add_rect(bar_x + style.progress_bar_rounding, bar_y, 
                            fill_width - style.progress_bar_rounding, bar_height, 
                            fill_color);
            }
        }
        
        // Add gradient if enabled
        if (style.progress_gradient_enabled && fill_width > 0) {
            // Simple gradient implementation - could be improved with shader
            var gradient_steps = 10;
            var step_width = fill_width / gradient_steps;
            
            for (var i = 0; i < gradient_steps; i++) {
                var step_x = bar_x + i * step_width;
                var t = i / (gradient_steps - 1);
                var gradient_color = gmui_lerp_color(
                    style.progress_gradient_start_color,
                    style.progress_gradient_end_color,
                    t
                );
                
                gmui_add_rect(step_x, bar_y, step_width, bar_height, gradient_color);
            }
        }
    }
    
    // Draw progress text
    if (show_text && style.progress_text_format != "none") {
        var text_content = "";
        switch (style.progress_text_format) {
            case "percentage":
                text_content = string(floor(normalized_value * 100)) + "%";
                break;
            case "fraction":
                text_content = string(value) + "/" + string(max_value);
                break;
            case "value":
                text_content = string_format(value, 1, 2);
                break;
            case "custom": // TODO: finish this
                text_content = string(floor(normalized_value * 100)) + "%";
                break;
        }
        
        if (text_content != "") {
            var text_size2 = gmui_calc_text_size(text_content);
            var text_color = window.active ? style.progress_bar_text_color : style.progress_bar_text_disabled_color;
            
            var text_x, text_y;
            
            switch (style.progress_text_position) {
                case "left":
                    text_x = bar_x - text_size2[0] - style.progress_text_padding[0];
                    text_y = bar_y + (bar_height - text_size2[1]) / 2;
                    break;
                    
                case "center":
                    text_x = bar_x + (bar_width - text_size2[0]) / 2;
                    text_y = bar_y + (bar_height - text_size2[1]) / 2;
                    break;
                    
                case "right":
                    text_x = bar_x + bar_width + style.progress_text_padding[0];
                    text_y = bar_y + (bar_height - text_size2[1]) / 2;
                    break;
                    
                case "inside":
                    if (text_size2[0] < fill_width - style.progress_text_padding[0] * 2) {
                        text_x = bar_x + style.progress_text_padding[0];
                    } else if (text_size2[0] < bar_width - style.progress_text_padding[0] * 2) {
                        text_x = bar_x + (bar_width - text_size2[0]) / 2;
                    } else {
                        text_x = bar_x + bar_width + style.progress_text_padding[0];
                    }
                    text_y = bar_y + (bar_height - text_size2[1]) / 2;
                    break;
                    
                case "outside":
                default:
                    text_x = bar_x + bar_width + style.progress_text_padding[0];
                    text_y = bar_y + (bar_height - text_size2[1]) / 2;
                    break;
            }
            
            // Make sure text is visible (contrast)
            if (style.progress_text_position == "inside" && text_x >= bar_x && text_x + text_size2[0] <= bar_x + fill_width) {
                // Text is inside fill area - use light color
                gmui_add_text(text_x, text_y, text_content, make_color_rgb(255, 255, 255));
            } else {
                gmui_add_text(text_x, text_y, text_content, text_color);
            }
        }
    }
    
    // Update cursor position
    dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x += total_width + style.item_spacing[0];
    dc.line_height = max(dc.line_height, total_height);
    
    gmui_new_line();
    
    return value;
}

function gmui_progress_bar_indeterminate(label, width = -1, height = -1) {
    if (!global.gmui.initialized || !global.gmui.current_window) return;
    
    var window = global.gmui.current_window;
    var style = global.gmui.style;
    
    // Calculate animation progress
    var time = current_time / 1000; // Convert to seconds
    var animation_speed = style.progress_circular_animation_speed;
    
    // Create a ping-pong animation for indeterminate bar
    var anim_value = (sin(time * 3 * animation_speed) * 0.5 + 0.5) * 0.7 + 0.3;
    
    // Draw with a special flag or use a fixed value with animation
    return gmui_progress_bar(label, anim_value, 0, 1, width, height, false); // Simplified
}

function gmui_progress_circular(value, min_value = 0, max_value = 1, size = -1, show_text = true) {
    if (!global.gmui.initialized || !global.gmui.current_window) return value;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
    
    // Calculate size
    var circle_size = (size > 0) ? size : style.progress_circular_size;
    var thickness = style.progress_circular_thickness;
    var radius = circle_size / 2;
    
    // Calculate bounds
    var circle_x = dc.cursor_x + radius;
    var circle_y = dc.cursor_y + radius;
    var circle_bounds = [circle_x - radius, circle_y - radius, 
                        circle_x + radius, circle_y + radius];
    
    // Calculate normalized value
    var normalized_value = clamp((value - min_value) / (max_value - min_value), 0, 1);
    var angle = 2 * pi * normalized_value;
    
    // Check for mouse interaction
    var mouse_over = gmui_is_mouse_over_window(window) && 
                    gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, 
                                        global.gmui.mouse_pos[1] - window.y, 
                                        circle_bounds) && !global.gmui.is_hovering_element;
    
    // Draw background circle
    gmui_add_circle_outline(circle_x, circle_y, radius, 
                        style.progress_circular_bg_color, thickness);
    
    // Draw progress arc
    if (normalized_value > 0) {
        var fill_color = style.progress_circular_fill_color;
        if (mouse_over && window.active) {
            fill_color = style.progress_circular_fill_hover_color;
            global.gmui.is_hovering_element = true;
        }
        
        // Draw the arc
        gmui_add_arc(circle_x, circle_y, radius, thickness, 
                    -pi/2, -pi/2 + angle, fill_color);
    }
    
    // Draw text in center
    if (show_text && style.progress_circular_show_text) {
        var text_content = "";
        switch (style.progress_text_format) {
            case "percentage":
                text_content = string(floor(normalized_value * 100)) + "%";
                break;
            case "fraction":
                text_content = string(value) + "/" + string(max_value);
                break;
            case "value":
                text_content = string_format(value, 1, 2);
                break;
            case "custom":
                text_content = string(floor(normalized_value * 100)) + "%";
                break;
            case "none":
                // No text
                break;
        }
        
        if (text_content != "") {
            var text_size = gmui_calc_text_size(text_content);
            var text_color = window.active ? style.progress_circular_text_color : style.text_disabled_color;
            var text_x = circle_x - text_size[0] / 2;
            var text_y = circle_y - text_size[1] / 2;
            
            gmui_add_text(text_x, text_y, text_content, text_color);
        }
    }
    
    // Update cursor position
    dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x += circle_size + style.item_spacing[0];
    dc.line_height = max(dc.line_height, circle_size);
    
    gmui_new_line();
    
    return value;
}

function gmui_progress_spinner(size = -1, thickness = -1) {
    if (!global.gmui.initialized || !global.gmui.current_window) return;
    
    var window = global.gmui.current_window;
    var style = global.gmui.style;
    
    // Calculate animation progress
    var time = current_time / 1000;
    var animation_speed = style.progress_circular_animation_speed;
    
    // Rotating spinner
    var angle_offset = (time * 2 * pi * animation_speed) % (2 * pi);
    var arc_length = pi * 1.5; // 270 degree arc
    
    // Calculate size
    var circle_size = (size > 0) ? size : style.progress_circular_size;
    var circle_thickness = (thickness > 0) ? thickness : style.progress_circular_thickness;
    var radius = circle_size / 2;
    
    var circle_x = global.gmui.current_window.dc.cursor_x + radius;
    var circle_y = global.gmui.current_window.dc.cursor_y + radius;
    
    // Draw rotating arc
    gmui_add_arc(circle_x, circle_y, radius, circle_thickness, 
                angle_offset, angle_offset + arc_length, 
                style.progress_circular_fill_color);
    
    // Update cursor position
    global.gmui.current_window.dc.cursor_previous_x = global.gmui.current_window.dc.cursor_x;
    global.gmui.current_window.dc.cursor_x += circle_size + style.item_spacing[0];
    global.gmui.current_window.dc.line_height = max(global.gmui.current_window.dc.line_height, circle_size);
    
    gmui_new_line();
    
    return true;
}

function gmui_text(text) {
    if (!global.gmui.initialized || !global.gmui.current_window) return false;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var size = gmui_calc_text_size(text);
    
    gmui_add_text(dc.cursor_x, dc.cursor_y, text, global.gmui.style.text_color);
    
	dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x += size[0] + global.gmui.style.item_spacing[0];
    dc.line_height = max(dc.line_height, size[1]);
	
	gmui_new_line();
	
    return false;
}

function gmui_text_bullet(text) {
    if (!global.gmui.initialized || !global.gmui.current_window) return false;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var size = gmui_calc_text_size(text);
    
	gmui_add_rect_round(dc.cursor_x, dc.cursor_y + size[1] / 4, 8, 8, global.gmui.style.text_color, 8);
	
    gmui_add_text(dc.cursor_x + 16, dc.cursor_y, text, global.gmui.style.text_color);
    
	dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x += size[0] + global.gmui.style.item_spacing[0];
    dc.line_height = max(dc.line_height, size[1]);
	
	gmui_new_line();
	
    return false;
}

function gmui_text_wrap(text, wrap_width = -1) {
    if (!global.gmui.initialized || !global.gmui.current_window) return false;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
    
    // Use window width minus padding if no specific width provided
    if (wrap_width == -1) {
        wrap_width = window.width - style.window_padding[0] * 2 - dc.cursor_x;
    }
    
    var words = string_split(text, " ");
    var current_line = "";
    var line_height = 0;
    
    for (var i = 0; i < array_length(words); i++) {
        var word = words[i];
        var test_line = current_line == "" ? word : current_line + " " + word;
        var test_width = string_width(test_line);
        
        if (test_width <= wrap_width || current_line == "") {
            // Word fits on current line (or it's the first word)
            current_line = test_line;
        } else {
            // Word doesn't fit, draw current line and start new line
            if (current_line != "") {
                gmui_add_text(dc.cursor_x, dc.cursor_y, current_line, global.gmui.style.text_color);
                var line_size = gmui_calc_text_size(current_line);
                line_height = max(line_height, line_size[1]);
                
                // Move to next line
                dc.cursor_previous_x = dc.cursor_x;
                dc.cursor_x = dc.cursor_start_x + dc.scroll_offset_x;
                dc.cursor_y += line_height + style.item_spacing[1];
                dc.line_height = 0;
            }
            
            // Start new line with current word
            current_line = word;
        }
    }
    
    // Draw the last line
    if (current_line != "") {
        gmui_add_text(dc.cursor_x, dc.cursor_y, current_line, global.gmui.style.text_color);
        var line_size = gmui_calc_text_size(current_line);
        line_height = max(line_height, line_size[1]);
    }
    
    // Update cursor position
    dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x = dc.cursor_start_x + dc.scroll_offset_x;
    dc.cursor_y += line_height + style.item_spacing[1];
    dc.line_height = 0;
    
    return true;
}

function gmui_text_wrapped(text, wrap_width = -1, color = -1, line_spacing = -1) {
    if (!global.gmui.initialized || !global.gmui.current_window) return false;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
    
    // Use defaults if not specified
    if (wrap_width == -1) {
        wrap_width = window.width - style.window_padding[0] * 2 - dc.cursor_x;
    }
    if (color == -1) {
        color = global.gmui.style.text_color;
    }
    if (line_spacing == -1) {
        line_spacing = style.item_spacing[1];
    }
    
    var words = string_split(text, " ");
    var current_line = "";
    var line_height = 0;
    var lines_drawn = 0;
    
    for (var i = 0; i < array_length(words); i++) {
        var word = words[i];
        var test_line = current_line == "" ? word : current_line + " " + word;
        var test_width = string_width(test_line);
        
        if (test_width <= wrap_width || current_line == "") {
            current_line = test_line;
        } else {
            // Draw current line
            gmui_add_text(dc.cursor_x, dc.cursor_y, current_line, color);
            var line_size = gmui_calc_text_size(current_line);
            line_height = max(line_height, line_size[1]);
            
            // Move to next line
            dc.cursor_previous_x = dc.cursor_x;
            dc.cursor_x = dc.cursor_start_x + dc.scroll_offset_x;
            dc.cursor_y += line_height + line_spacing;
            dc.line_height = 0;
            lines_drawn++;
            
            current_line = word;
        }
    }
    
    // Draw the last line
    if (current_line != "") {
        gmui_add_text(dc.cursor_x, dc.cursor_y, current_line, color);
        var line_size = gmui_calc_text_size(current_line);
        line_height = max(line_height, line_size[1]);
        lines_drawn++;
    }
    
    // Update cursor position
    dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x = dc.cursor_start_x + dc.scroll_offset_x;
    dc.cursor_y += line_height + line_spacing;
    dc.line_height = 0;
    
    return lines_drawn;
}

function gmui_text_disabled(text) {
    if (!global.gmui.initialized || !global.gmui.current_window) return false;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var size = gmui_calc_text_size(text);
    
    gmui_add_text(dc.cursor_x, dc.cursor_y, text, global.gmui.style.text_disabled_color);
    
	dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x += size[0] + global.gmui.style.item_spacing[0];
    dc.line_height = max(dc.line_height, size[1]);
	
	gmui_new_line();
	
    return false;
}

function gmui_label_text(label, text) {
    if (!global.gmui.initialized || !global.gmui.current_window) return false;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var label_size = gmui_calc_text_size(label + ": ");
    var text_size = gmui_calc_text_size(text);
    
    gmui_add_text(dc.cursor_x, dc.cursor_y, label + ": ", global.gmui.style.text_disabled_color);
    gmui_add_text(dc.cursor_x + label_size[0], dc.cursor_y, text, global.gmui.style.text_color);
    
	dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x += label_size[0] + text_size[0] + global.gmui.style.item_spacing[0];
    dc.line_height = max(dc.line_height, max(label_size[1], text_size[1]));
	
	gmui_new_line();
	
    return false;
}

function gmui_context_menu_item(label, short_cut = "") {
    if (!global.gmui.initialized || !global.gmui.current_window) return false;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
    
    // Calculate item size
    var text_size = gmui_calc_text_size(label);
    var button_width = window.width;
    var button_height = style.context_menu_item_height;
    
    // Calculate item bounds
    var button_x = 0;
    var button_y = dc.cursor_y;
    var button_bounds = [button_x, button_y, button_x + button_width, button_y + button_height];
    
    // Check for mouse interaction
    var mouse_over = gmui_is_mouse_over_window(window) && 
                     gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, global.gmui.mouse_pos[1] - window.y, button_bounds) && !global.gmui.is_hovering_element;
    
    var clicked = false;
    
    if (mouse_over) {
		global.gmui.is_hovering_element = true;
        if (global.gmui.mouse_down[0]) {
            clicked = true;
        }
    }
    
    // Draw item based on state
    var bg_color, text_color;
    
    if (mouse_over) {
        // Mouse hovering
        bg_color = style.context_menu_item_hover_bg_color;
        text_color = style.context_menu_item_text_color;
    } else {
        // Normal state
        text_color = style.context_menu_item_text_color;
    }
    
    // Draw item background
	if (mouse_over) {
		gmui_add_rect(button_x, button_y, button_width, button_height, bg_color);
	}
    
    // Draw text
    var text_x = button_x + style.window_padding[0];
    var text_y = button_y + (button_height - text_size[1]) / 2;
    gmui_add_text(text_x, text_y, label, text_color);
	
	// Draw short cut text right aligned
	if (short_cut != "") {
		var sc_size = gmui_calc_text_size(short_cut);
		var sc_x = button_width - sc_size[0] - style.window_padding[0];
		var sc_y = text_y;
		gmui_add_text(sc_x, sc_y, short_cut, style.context_menu_item_short_cut_text_color);
	}
    
    // Update cursor position
    dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x += button_width + style.item_spacing[0];
    dc.line_height = max(dc.line_height, button_height);
	
	gmui_new_line();
	
	if (clicked && window.active) {
		global.gmui.current_context_menu.open = false;
		global.gmui.current_context_menu_bg.open = false;
	}
    
    return clicked && window.active;
}

function gmui_context_menu_item_sub(label) {
    if (!global.gmui.initialized || !global.gmui.current_window) return false;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
	var item_id = "context_menu_item_sub_" + window.name + "_element_id_" + string(dc.cursor_x) + "+" + string(dc.cursor_y) + "_";
	
	var result = false;
	var check = global.gmui.context_menu_cache[? item_id];
	if (check == undefined) {
		check = false;
		global.gmui.context_menu_cache[? item_id] = check;
	};
    
    // Calculate item size
    var text_size = gmui_calc_text_size(label);
    var button_width = window.width;
    var button_height = style.context_menu_item_height;
    
    // Calculate item bounds
    var button_x = 0;
    var button_y = dc.cursor_y;
    var button_bounds = [button_x, button_y, button_x + button_width, button_y + button_height];
    
    // Check for mouse interaction
    var mouse_over = gmui_is_mouse_over_window(window) && 
                     gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, global.gmui.mouse_pos[1] - window.y, button_bounds) && !global.gmui.is_hovering_element;
    
    var clicked = false;
    
    if (mouse_over) {
		global.gmui.is_hovering_element = true;
        if (global.gmui.mouse_clicked[0]) {
            clicked = true;
        }
    }
    
    // Draw item based on state
    var bg_color = style.context_menu_item_hover_bg_color, text_color;
    
    if (mouse_over) {
        // Mouse hovering
        bg_color = style.context_menu_item_hover_bg_color;
        text_color = style.context_menu_item_text_color;
    } else {
        // Normal state
        text_color = style.context_menu_item_text_color;
    }
    
    // Draw item background
	if (mouse_over || check) {
		gmui_add_rect(button_x, button_y, button_width, button_height, bg_color);
	}
    
    // Draw text
    var text_x = button_x + style.window_padding[0];
    var text_y = button_y + (button_height - text_size[1]) / 2;
    gmui_add_text(text_x, text_y, label, text_color);
	
	// Draw the arrow line as indication
	var arrow_x = button_width - style.window_padding[0];
	var arrow_y = button_y + button_height - text_size[1] / 2;
	gmui_add_line(arrow_x, arrow_y, arrow_x - text_size[1] / 4, arrow_y - text_size[1] / 4, style.text_color, style.context_menu_sub_arrow_thickness);
	gmui_add_line(arrow_x, arrow_y, arrow_x - text_size[1] / 4, arrow_y + text_size[1] / 4, style.text_color, style.context_menu_sub_arrow_thickness);
    
    // Update cursor position
    dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x += button_width + style.item_spacing[0];
    dc.line_height = max(dc.line_height, button_height);
	
	gmui_new_line();
	
	if (clicked && window.active) {
		check = !check;
		global.gmui.current_context_menu_last_available_sub_pos = [ window.x + window.width, window.y + button_y ];
	}
	
	if (check && window.active) {
		result = gmui_begin_sub_context_menu("Sub Context Menu" + string(global.gmui.current_context_menu_last_available_sub_pos[0]) + string(global.gmui.current_context_menu_last_available_sub_pos[1]), global.gmui.current_context_menu_last_available_sub_pos[0], global.gmui.current_context_menu_last_available_sub_pos[1]);
	}
	
	if (global.gmui.mouse_clicked[0] && !mouse_over && !gmui_is_mouse_over_window(global.gmui.current_window)) {
		check = false;
	}
	
	global.gmui.context_menu_cache[? item_id] = check;
	
    return result && check && window.active;
}

function gmui_menu_item(label, context_menu_name = undefined) {
    if (!global.gmui.initialized || !global.gmui.current_window) return false;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
	var item_id = "menu_item_" + window.name + "_element_id_" + string(dc.cursor_x) + "+" + string(dc.cursor_y) + "_";
	
	var check = gmui_cache_get(item_id);
	if (check == undefined) {
		check = false;
		gmui_cache_set(item_id, check);
	};
    
    // Calculate button size
    var text_size = gmui_calc_text_size(label);
    var button_width = text_size[0] + style.menu_button_padding * 2;
    var button_height = style.menu_height;
    
    // Calculate button bounds
    var button_x = dc.cursor_x;
    var button_y = 0;
    var button_bounds = [button_x, button_y, button_x + button_width, button_y + button_height];
    
    // Check for mouse interaction
    var mouse_over = gmui_is_mouse_over_window(window) && 
                     gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, global.gmui.mouse_pos[1] - window.y, button_bounds) && !global.gmui.is_hovering_element;
    
    var clicked = false;
    
    if (mouse_over) {
		global.gmui.is_hovering_element = true;
        if (global.gmui.mouse_clicked[0]) {
            clicked = true;
			check = !check;
			
			if (context_menu_name != undefined && check) {
				gmui_open_context_menu(context_menu_name, window.x + button_x, window.y + button_y + button_height);
			}
        }
    }
    
    // Draw button based on state
    var bg_color = style.menu_button_hover_bg_color, text_color = style.menu_text_color;
    
    if (mouse_over && !check) {
        // Mouse hovering
        bg_color = style.menu_button_hover_bg_color;
        text_color = style.button_text_color;
    }
	else if (check) {
		// Active menu is open
        bg_color = style.menu_button_active_bg_color;
        text_color = style.button_text_color;
	}
    
    // Draw button background
	if (mouse_over || check) {
		gmui_add_rect_round(button_x, button_y, button_width, button_height, bg_color, style.menu_button_rounding);
	}
	
	// Draw Border Lines
	gmui_add_line(button_x, button_y, button_x, button_y + button_height, style.border_color, 1);
	gmui_add_line(button_x + button_width, button_y, button_x + button_width, button_y + button_height, style.border_color, 1);
	
	// Close check if clicked outside
	if (global.gmui.mouse_clicked[0] && !mouse_over) {
		check = false;
	}
    
    // Draw text centered
    var text_x = button_x + (button_width - text_size[0]) / 2;
    var text_y = button_y + (button_height - text_size[1]) / 2;
    gmui_add_text(text_x, text_y, label, text_color);
    
    // Update cursor position
    dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x += button_width;
    dc.line_height = max(dc.line_height, button_height);
	
	//gmui_new_line();
	
	gmui_cache_set(item_id, check);
    
    return clicked && window.active;
}

function gmui_button(label, width = -1, height = -1) {
    if (!global.gmui.initialized || !global.gmui.current_window) return false;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
	var element_id = "id_button_" + label + "_" + string(dc.cursor_x) + "_" + string(dc.cursor_y);
    
    // Calculate button size
    var text_size = gmui_calc_text_size(label);
    var button_width = max(style.button_min_size[0], text_size[0] + style.button_padding[0] * 2);
    var button_height = max(style.button_min_size[1], text_size[1] + style.button_padding[1] * 2);
    
    // Use custom size if provided
    if (width > 0) button_width = width;
    if (height > 0) button_height = height;
    
    // Check if button fits on current line, otherwise move to new line
    //if (dc.cursor_x + button_width > window.width - style.window_padding[0] && dc.cursor_x > dc.cursor_start_x) {
    //    gmui_new_line();
    //}
    
    // Calculate button bounds
    var button_x = dc.cursor_x;
    var button_y = dc.cursor_y;
    var button_bounds = [button_x, button_y, button_x + button_width, button_y + button_height];
    
    // Check for mouse interaction
    var mouse_over = gmui_is_mouse_over_window(window) && 
                     gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, global.gmui.mouse_pos[1] - window.y, button_bounds) && !global.gmui.is_hovering_element;
    
    var clicked = false;
    var is_active = false;
    
    if (mouse_over) {
		global.gmui.is_hovering_element = true;
        if (global.gmui.mouse_clicked[0]) {
			global.gmui.last_pressed_clickable_id = element_id;
        }
		if (global.gmui.mouse_down[0] && global.gmui.last_pressed_clickable_id == element_id) {
            is_active = true;
		}
        if (global.gmui.mouse_released[0] && global.gmui.last_pressed_clickable_id == element_id) {
            clicked = true;
        }
    }
    
    // Draw button based on state
    var bg_color, border_color, text_color;
    
    if (!window.active) {
        // Window not active - disabled state
        bg_color = style.button_disabled_bg_color;
        border_color = style.button_disabled_border_color;
        text_color = style.button_disabled_text_color;
    } else if (is_active) {
        // Button being pressed
        bg_color = style.button_active_bg_color;
        border_color = style.button_active_border_color;
        text_color = style.button_text_color;
    } else if (mouse_over) {
        // Mouse hovering
        bg_color = style.button_hover_bg_color;
        border_color = style.button_hover_border_color;
        text_color = style.button_text_color;
    } else {
        // Normal state
        bg_color = style.button_bg_color;
        border_color = style.button_border_color;
        text_color = style.button_text_color;
    }
    
    // Draw button background
    gmui_add_rect_round(button_x, button_y, button_width, button_height, bg_color, style.button_rounding);
    
    // Draw border
    if (style.button_border_size > 0) {
        gmui_add_rect_round_outline(button_x, button_y, button_width, button_height, border_color, style.button_rounding, style.button_border_size);
    }
    
    // Draw text centered
    var text_x = button_x + (button_width - text_size[0]) / 2;
    var text_y = button_y + (button_height - text_size[1]) / 2;
    gmui_add_text(text_x, text_y, label, text_color);
    
    // Update cursor position
    dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x += button_width + style.item_spacing[0];
    dc.line_height = max(dc.line_height, button_height);
	
	gmui_new_line();
    
    return clicked && window.active;
}

function gmui_button_invisible(label, width, height) {
    if (!global.gmui.initialized || !global.gmui.current_window) return false;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
	var element_id = "id_button_" + label + "_" + string(dc.cursor_x) + "_" + string(dc.cursor_y);
    
    // Calculate button size
    var text_size = gmui_calc_text_size(label);
    var button_width = max(style.button_min_size[0], text_size[0] + style.button_padding[0] * 2);
    var button_height = max(style.button_min_size[1], text_size[1] + style.button_padding[1] * 2);
    
    // Use custom size if provided
    if (width > 0) button_width = width;
    if (height > 0) button_height = height;
    
    // Check if button fits on current line, otherwise move to new line
    //if (dc.cursor_x + button_width > window.width - style.window_padding[0] && dc.cursor_x > dc.cursor_start_x) {
    //    gmui_new_line();
    //}
    
    // Calculate button bounds
    var button_x = dc.cursor_x;
    var button_y = dc.cursor_y;
    var button_bounds = [button_x, button_y, button_x + button_width, button_y + button_height];
    
    // Check for mouse interaction
    var mouse_over = gmui_is_mouse_over_window(window) && 
                     gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, global.gmui.mouse_pos[1] - window.y, button_bounds) && !global.gmui.is_hovering_element;
    
    var clicked = false;
    var is_active = false;
    
    if (mouse_over) {
		global.gmui.is_hovering_element = true;
        if (global.gmui.mouse_clicked[0]) {
			global.gmui.last_pressed_clickable_id = element_id;
        }
		if (global.gmui.mouse_down[0] && global.gmui.last_pressed_clickable_id == element_id) {
            is_active = true;
		}
        if (global.gmui.mouse_released[0] && global.gmui.last_pressed_clickable_id == element_id) {
            clicked = true;
        }
    }
    
    // Draw button based on state
    var bg_color, border_color, text_color;
    
    if (!window.active) {
        // Window not active - disabled state
        bg_color = style.button_disabled_bg_color;
        border_color = style.button_disabled_border_color;
        text_color = style.button_disabled_text_color;
    } else if (is_active) {
        // Button being pressed
        bg_color = style.button_active_bg_color;
        border_color = style.button_active_border_color;
        text_color = style.button_text_color;
    } else if (mouse_over) {
        // Mouse hovering
        bg_color = style.button_hover_bg_color;
        border_color = style.button_hover_border_color;
        text_color = style.button_text_color;
    } else {
        // Normal state
        bg_color = style.button_bg_color;
        border_color = style.button_border_color;
        text_color = style.button_text_color;
    }
    
    // Draw text centered
    var text_x = button_x + (button_width - text_size[0]) / 2;
    var text_y = button_y + (button_height - text_size[1]) / 2;
    gmui_add_text(text_x, text_y, label, text_color); // ## prefix can be used
    
    // Update cursor position
    dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x += button_width + style.item_spacing[0];
    dc.line_height = max(dc.line_height, button_height);
	
	gmui_new_line();
    
    return clicked && window.active;
}

function gmui_button_width_fill(label, height = -1) {
	var current_window = global.gmui.current_window;
	var width = current_window.width - global.gmui.style.window_padding[0] * 2;
	var button = gmui_button(label, width, height);
	return button;
}

function gmui_button_small(label) {
    return gmui_button(label, -1, 20);
}

function gmui_button_large(label) {
    return gmui_button(label, -1, 32);
}

function gmui_button_width(label, width) {
    return gmui_button(label, width, -1);
}

function gmui_button_disabled(label, width = -1, height = -1) {
    if (!global.gmui.initialized || !global.gmui.current_window) return false;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
    
    // Calculate button size (same as regular button)
    var text_size = gmui_calc_text_size(label);
    var button_width = max(style.button_min_size[0], text_size[0] + style.button_padding[0] * 2);
    var button_height = max(style.button_min_size[1], text_size[1] + style.button_padding[1] * 2);
    
    if (width > 0) button_width = width;
    if (height > 0) button_height = height;
    
    // Check if button fits on current line
    if (dc.cursor_x + button_width > window.width - style.window_padding[0] && dc.cursor_x > dc.cursor_start_x) {
        gmui_new_line();
    }
    
    var button_x = dc.cursor_x;
    var button_y = dc.cursor_y;
    
    // Draw disabled button
    gmui_add_rect_round(button_x, button_y, button_width, button_height, style.button_disabled_bg_color, style.button_rounding);
    
    if (style.button_border_size > 0) {
        gmui_add_rect_round_outline(button_x, button_y, button_width, button_height, style.button_disabled_border_color, style.button_rounding, style.button_border_size);
    }
    
    // Draw text centered
    var text_x = button_x + (button_width - text_size[0]) / 2;
    var text_y = button_y + (button_height - text_size[1]) / 2;
    gmui_add_text(text_x, text_y, label, style.button_disabled_text_color);
    
    // Update cursor position
    dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x += button_width + style.item_spacing[0];
    dc.line_height = max(dc.line_height, button_height);
	
	gmui_new_line();
    
    return false; // Disabled buttons never return true
}

function gmui_surface(surface) {
    if (!global.gmui.initialized || !global.gmui.current_window) return false;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
    
	gmui_add_surface(dc.cursor_x, dc.cursor_y, surface);
    
    // Update cursor position
    dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x += surface_get_width(surface) + style.item_spacing[0];
    dc.line_height = max(dc.line_height, surface_get_height(surface));
	
	gmui_new_line();
};

function gmui_sprite(sprite, subimg = 0) {
    if (!global.gmui.initialized || !global.gmui.current_window) return false;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
    
	gmui_add_sprite(dc.cursor_x, dc.cursor_y, sprite_get_width(sprite), sprite_get_height(sprite), sprite, subimg);
    
    // Update cursor position
    dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x += surface_get_width(surface) + style.item_spacing[0];
    dc.line_height = max(dc.line_height, surface_get_height(surface));
	
	gmui_new_line();
};

function gmui_sprite_size(sprite, subimg = 0, width = -1, height = -1) {
    if (!global.gmui.initialized || !global.gmui.current_window) return false;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
	
	width = width == -1 ? sprite_get_width(sprite) : width;
	height = height == -1 ? sprite_get_height(sprite) : height;
    
	gmui_add_sprite(dc.cursor_x, dc.cursor_y, width, height, sprite, subimg);
    
    // Update cursor position
    dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x += surface_get_width(surface) + style.item_spacing[0];
    dc.line_height = max(dc.line_height, surface_get_height(surface));
	
	gmui_new_line();
};

//////////////////////////////////////
// COLOR
//////////////////////////////////////
function gmui_color_button(color_rgba, size = -1) {
    if (!global.gmui.initialized || !global.gmui.current_window) return false;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
	var element_id = "id_button_color_" + string(dc.cursor_x) + string(dc.cursor_y);
	
	var arr_rgba = gmui_color_rgba_to_array(color_rgba);
    
    // Calculate button size
    var button_size = size > 0 ? size : style.color_button_size;
    
    // Calculate button bounds
    var button_x = dc.cursor_x;
    var button_y = dc.cursor_y;
    var button_bounds = [button_x, button_y, button_x + button_size, button_y + button_size];
    
    // Check for mouse interaction
    var mouse_over = gmui_is_mouse_over_window(window) && 
                     gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, 
                                         global.gmui.mouse_pos[1] - window.y, 
                                         button_bounds) && !global.gmui.is_hovering_element;
    
    var clicked = false;
    var is_active = false;
    
    if (mouse_over && window.active) {
        global.gmui.is_hovering_element = true;
        if (global.gmui.mouse_clicked[0]) {
            global.gmui.last_pressed_clickable_id = element_id;
        }
        if (global.gmui.mouse_down[0] && global.gmui.last_pressed_clickable_id == element_id) {
            is_active = true;
        }
        if (global.gmui.mouse_released[0] && global.gmui.last_pressed_clickable_id == element_id) {
            clicked = true;
        }
    }
    
    // Draw checkerboard background for transparency
    gmui_draw_checkerboard_shader(button_x, button_y, button_size, button_size);
    
    // Draw color
    gmui_add_rect_alpha(button_x, button_y, button_size, button_size, make_color_rgb(arr_rgba[0], arr_rgba[1], arr_rgba[2]), arr_rgba[3] / 255);
    
    // Draw border based on state
    var border_color = style.color_button_border_color;
    if (is_active) {
        border_color = style.color_button_active_border_color;
    } else if (mouse_over) {
        border_color = style.color_button_hover_border_color;
    }
    
    if (style.color_button_border_size > 0) {
        gmui_add_rect_outline(button_x, button_y, button_size, button_size, 
                            border_color, style.color_button_border_size);
    }
    
    // Update cursor position
    dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x += button_size + style.item_spacing[0];
    dc.line_height = max(dc.line_height, button_size);
    
    gmui_new_line();
    
    return clicked && window.active;
}

function gmui_color_picker_open(rgba) {
    if (!global.gmui.initialized || !global.gmui.current_window) return rgba;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
	
	var color_id = "color_" + string(dc.cursor_x) + "_" + string(dc.cursor_y);
	
    var color_array = gmui_color_rgba_to_array(rgba);
	
	window.active_color_picker = color_id;
	window.color_picker_value = color_array;
	
	// Convert RGB to HSV for the picker
	var hsv = gmui_rgba_to_hsva(color_array[0], color_array[1], color_array[2], 255);
	window.color_picker_hue = hsv[0];
	window.color_picker_saturation = hsv[1];
	window.color_picker_brightness = hsv[2];
	window.color_picker_alpha = color_array[3];
};

function gmui_color_button_4(label, rgba) {
    if (!global.gmui.initialized || !global.gmui.current_window) return rgba;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
    
    // Create a unique ID for this color editor
    var color_edit_id = "color_edit_4_" + string(dc.cursor_x) + "_" + string(dc.cursor_y);
    
    // Convert color to array
    var color_array = gmui_color_rgba_to_array(rgba);
    
    // If this color editor has an active picker, use the picker's value
    if (window.active_color_picker == color_edit_id) {
        color_array = window.color_picker_value;
        rgba = gmui_array_to_color_rgba(color_array);
    }
    
    // Draw label
	if (label != "") {gmui_text(label); gmui_same_line();};
    
    // Draw color preview button
    var preview_clicked = gmui_color_button(rgba, style.color_button_size);
    
    // If color button clicked, open color picker
    if (preview_clicked) {
        window.active_color_picker = color_edit_id;
        window.color_picker_value = color_array;
        
        // Convert RGB to HSV for the picker
        var hsv = gmui_rgba_to_hsva(color_array[0], color_array[1], color_array[2], 255);
        window.color_picker_hue = hsv[0];
        window.color_picker_saturation = hsv[1];
        window.color_picker_brightness = hsv[2];
        window.color_picker_alpha = color_array[3];
    }
    
    // Convert back to color
    var new_color = gmui_array_to_color_rgba(color_array);
    
    // Update picker value if input fields changed
    if (window.active_color_picker == color_edit_id && new_color != rgba) {
        var new_array = gmui_color_rgba_to_array(new_color);
        window.color_picker_value = new_array;
        
        // Update HSV for picker
        var hsv = gmui_rgba_to_hsva(new_array[0], new_array[1], new_array[2], 255);
        window.color_picker_hue = hsv[0];
        window.color_picker_saturation = hsv[1];
        window.color_picker_brightness = hsv[2];
        window.color_picker_alpha = new_array[3];
    }
    
    gmui_new_line();
    
    return new_color;
}

function gmui_color_edit_4(label, rgba) {
    if (!global.gmui.initialized || !global.gmui.current_window) return rgba;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
    
    // Create a unique ID for this color editor
    var color_edit_id = "color_edit_4_" + string(dc.cursor_x) + "_" + string(dc.cursor_y);
    
    // Convert color to array
    var color_array = gmui_color_rgba_to_array(rgba);
    
    // If this color editor has an active picker, use the picker's value
    if (window.active_color_picker == color_edit_id) {
        color_array = window.color_picker_value;
        rgba = gmui_array_to_color_rgba(color_array);
    }
    
    // Draw label
	if (label != "") {gmui_text(label); gmui_same_line();};
    
    // Draw color preview button
    var preview_clicked = gmui_color_button(rgba, style.color_button_size);
    
    // If color button clicked, open color picker
    if (preview_clicked) {
        window.active_color_picker = color_edit_id;
        window.color_picker_value = color_array;
        
        // Convert RGB to HSV for the picker
        var hsv = gmui_rgba_to_hsva(color_array[0], color_array[1], color_array[2], 255);
        window.color_picker_hue = hsv[0];
        window.color_picker_saturation = hsv[1];
        window.color_picker_brightness = hsv[2];
        window.color_picker_alpha = color_array[3];
    }
    
    // Red channel
    gmui_same_line(); gmui_text("R:"); gmui_same_line();
    var new_r = gmui_input_int(color_array[0], 1, 0, 255, 60);
    color_array[0] = clamp(new_r, 0, 255);
    
    // Green channel
    gmui_same_line(); gmui_text("G:"); gmui_same_line();
    var new_g = gmui_input_int(color_array[1], 1, 0, 255, 60);
    color_array[1] = clamp(new_g, 0, 255);
    
    // Blue channel
    gmui_same_line(); gmui_text("B:"); gmui_same_line();
    var new_b = gmui_input_int(color_array[2], 1, 0, 255, 60);
    color_array[2] = clamp(new_b, 0, 255);
    
    // Alpha channel
    gmui_same_line(); gmui_text("A:"); gmui_same_line();
    var new_a = gmui_input_int(color_array[3], 1, 0, 255, 60);
    color_array[3] = clamp(new_a, 0, 255);
    
    // Convert back to color
    var new_color = gmui_array_to_color_rgba(color_array);
    
    // Update picker value if input fields changed
    if (window.active_color_picker == color_edit_id && new_color != rgba) {
        var new_array = gmui_color_rgba_to_array(new_color);
        window.color_picker_value = new_array;
        
        // Update HSV for picker
        var hsv = gmui_rgba_to_hsva(new_array[0], new_array[1], new_array[2], 255);
        window.color_picker_hue = hsv[0];
        window.color_picker_saturation = hsv[1];
        window.color_picker_brightness = hsv[2];
        window.color_picker_alpha = new_array[3];
    }
    
    gmui_new_line();
    
    return new_color;
}

function gmui_color_picker() {
    if (!global.gmui.initialized || !global.gmui.current_window) return false;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
    
    // If no color picker is active for this window, return
    if (window.active_color_picker == undefined) return false;
    
    // Calculate picker position (centered in window)
    var picker_width = style.color_picker_width;
    var picker_height = style.color_picker_height + style.color_picker_hue_height + 
                       style.color_picker_alpha_height + 0/*style.color_picker_preview_size*/ + 
                       style.color_picker_padding * 4;
    
    var picker_x = 0;
    var picker_y = 0;
    
    // Draw color picker background
    gmui_add_rect(picker_x, picker_y, picker_width, picker_height, style.background_color);
    
    // Draw border
    if (style.color_picker_border_size > 0) {
        gmui_add_rect_outline(picker_x, picker_y, picker_width, picker_height, 
                            style.color_picker_border_color, style.color_picker_border_size);
    }
    
    var current_y = picker_y + style.color_picker_padding;
    
    // Draw saturation/brightness area USING SHADER
    var sb_width = picker_width - style.color_picker_padding * 2;
    var sb_height = style.color_picker_height;
    var sb_x = picker_x + style.color_picker_padding;
    var sb_y = current_y;
    
    gmui_draw_saturation_brightness_shader(sb_x, sb_y, sb_width, sb_height, window.color_picker_hue);
    
    // Draw saturation/brightness cursor
    var cursor_x = sb_x + window.color_picker_saturation * sb_width;
    var cursor_y = sb_y + (1 - window.color_picker_brightness) * sb_height;
    
    // Draw crosshair cursor
    gmui_add_rect_outline(cursor_x - 5, cursor_y, 11, 1, make_color_rgb(255, 255, 255), 1);
    gmui_add_rect_outline(cursor_x, cursor_y - 5, 1, 11, make_color_rgb(255, 255, 255), 1);
    gmui_add_rect_outline(cursor_x - 5, cursor_y, 11, 1, make_color_rgb(0, 0, 0), 1);
    gmui_add_rect_outline(cursor_x, cursor_y - 5, 1, 11, make_color_rgb(0, 0, 0), 1);
    
    current_y += sb_height + style.color_picker_padding;
    
    // Draw hue bar USING SHADER
    var hue_x = sb_x;
    var hue_y = current_y;
    var hue_width = sb_width;
    var hue_height = style.color_picker_hue_height;
    
    gmui_draw_hue_bar_shader(hue_x, hue_y, hue_width, hue_height);
    
    // Draw hue cursor
    var hue_cursor_x = hue_x + window.color_picker_hue * hue_width;
    gmui_add_rect_outline(hue_cursor_x - 2, hue_y - 2, 5, hue_height + 4, make_color_rgb(255, 255, 255), 2);
    
    current_y += hue_height + style.color_picker_padding;
    
    // Draw alpha bar USING SHADER
    var alpha_x = sb_x;
    var alpha_y = current_y;
    var alpha_width = sb_width;
    var alpha_height = style.color_picker_alpha_height;
    
    // Draw checkerboard background
    gmui_draw_checkerboard_shader(alpha_x, alpha_y, alpha_width, alpha_height);
    
    // Draw alpha gradient USING SHADER
    var current_rgb = gmui_hsva_to_rgba(window.color_picker_hue, window.color_picker_saturation, window.color_picker_brightness, 255);
    gmui_draw_alpha_bar_shader(alpha_x, alpha_y, alpha_width, alpha_height, current_rgb);
    
    // Draw alpha cursor
    var alpha_cursor_x = alpha_x + window.color_picker_alpha / 255 * alpha_width;
    gmui_add_rect_outline(alpha_cursor_x - 2, alpha_y - 2, 5, alpha_height + 4, make_color_rgb(255, 255, 255), 2);
    
    current_y += alpha_height + style.color_picker_padding;
    
    // Calculate current RGB color from HSV
    var new_rgb = gmui_hsva_to_rgba(window.color_picker_hue, window.color_picker_saturation, window.color_picker_brightness, 255);
    var new_color = gmui_array_to_color_rgba([new_rgb[0], new_rgb[1], new_rgb[2], window.color_picker_alpha]);
    
    // Update the window's color picker value
    window.color_picker_value = [new_rgb[0], new_rgb[1], new_rgb[2], window.color_picker_alpha];
    
    var color_changed = false;
    
    // Handle interaction
    var mouse_over_picker = gmui_is_mouse_over_window(window) && 
                           gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, 
                                               global.gmui.mouse_pos[1] - window.y, 
                                               [picker_x, picker_y, picker_x + picker_width, picker_y + picker_height]);
    
    // Check for clicks outside picker to close it
    if (global.gmui.mouse_clicked[0] && !mouse_over_picker) {
        window.active_color_picker = undefined;
		global.gmui.to_delete_color_picker = true;
    }
    
    // Handle dragging in color areas
    if (mouse_over_picker && global.gmui.mouse_clicked[0]) {
        var _mouse_x = global.gmui.mouse_pos[0] - window.x;
        var _mouse_y = global.gmui.mouse_pos[1] - window.y;
        
        // Check if clicking in saturation/brightness area
        if (gmui_is_point_in_rect(_mouse_x, _mouse_y, [sb_x, sb_y, sb_x + sb_width, sb_y + sb_height])) {
            window.color_picker_dragging = true;
            window.color_picker_drag_type = 2;
            
            var local_x = clamp((_mouse_x - sb_x) / sb_width, 0, 1);
            var local_y = clamp((_mouse_y - sb_y) / sb_height, 0, 1);
            
            window.color_picker_saturation = local_x;
            window.color_picker_brightness = 1 - local_y;
            color_changed = true;
        }
        // Check if clicking in hue bar
        else if (gmui_is_point_in_rect(_mouse_x, _mouse_y, [hue_x, hue_y, hue_x + hue_width, hue_y + hue_height])) {
            window.color_picker_dragging = true;
            window.color_picker_drag_type = 1;
            
            var local_x = clamp((_mouse_x - hue_x) / hue_width, 0, 1);
            window.color_picker_hue = local_x;
            color_changed = true;
        }
        // Check if clicking in alpha bar
        else if (gmui_is_point_in_rect(_mouse_x, _mouse_y, [alpha_x, alpha_y, alpha_x + alpha_width, alpha_y + alpha_height])) {
            window.color_picker_dragging = true;
            window.color_picker_drag_type = 3;
            
            var local_x = clamp((_mouse_x - alpha_x) / alpha_width * 255, 0, 255);
            window.color_picker_alpha = local_x;
            color_changed = true;
        }
    }
    
    // Handle dragging updates
    if (window.color_picker_dragging && global.gmui.mouse_down[0]) {
        var _mouse_x = global.gmui.mouse_pos[0] - window.x;
        var _mouse_y = global.gmui.mouse_pos[1] - window.y;
        
        switch (window.color_picker_drag_type) {
            case 1: // Hue
                var local_x = clamp((_mouse_x - hue_x) / hue_width, 0, 1);
                window.color_picker_hue = local_x;
                color_changed = true;
                break;
                
            case 2: // Saturation/Brightness
                var local_x = clamp((_mouse_x - sb_x) / sb_width, 0, 1);
                var local_y = clamp((_mouse_y - sb_y) / sb_height, 0, 1);
                
                window.color_picker_saturation = local_x;
                window.color_picker_brightness = 1 - local_y;
                color_changed = true;
                break;
                
            case 3: // Alpha
                var local_x = clamp((_mouse_x - alpha_x) / alpha_width * 255, 0, 255);
                window.color_picker_alpha = local_x;
                color_changed = true;
                break;
        }
    } else {
        window.color_picker_dragging = false;
        window.color_picker_drag_type = 0;
    }
    
    return color_changed;
}

function gmui_draw_hue_bar_shader(x, y, w, h) {
    gmui_add_shader_rect(x, y, w, h, gmui_shader_hue, []);
}

function gmui_draw_saturation_brightness_shader(x, y, w, h, hue) {
    gmui_add_shader_rect(x, y, w, h, gmui_shader_saturation_brightness, [
        { type: "float", name: "u_hue", value: hue }
    ]);
}

function gmui_draw_alpha_bar_shader(x, y, w, h, rgb_color) {
    gmui_add_shader_rect(x, y, w, h, gmui_shader_alpha_gradient, [
        { type: "vec3", name: "u_color", value: [rgb_color[0] / 255, rgb_color[1] / 255, rgb_color[2] / 255] }
    ]);
}

function gmui_draw_checkerboard_shader(x, y, w, h) {
    gmui_add_shader_rect(x, y, w, h, gmui_shader_checkerboard, [
        { type: "vec2", name: "u_size", value: [w, h] }
    ]);
}

function gmui_draw_hue_bar(x, y, width, height) {
    var segment_width = width / 6;
    
    // Red to Yellow
    for (var i = 0; i < segment_width; i++) {
        var ratio = i / segment_width;
        var color = make_color_rgb(255, round(255 * ratio), 0);
        gmui_add_rect(x + i, y, 1, height, color);
    }
    
    // Yellow to Green
    for (var i = 0; i < segment_width; i++) {
        var ratio = i / segment_width;
        var color = make_color_rgb(round(255 * (1 - ratio)), 255, 0);
        gmui_add_rect(x + segment_width + i, y, 1, height, color);
    }
    
    // Green to Cyan
    for (var i = 0; i < segment_width; i++) {
        var ratio = i / segment_width;
        var color = make_color_rgb(0, 255, round(255 * ratio));
        gmui_add_rect(x + segment_width * 2 + i, y, 1, height, color);
    }
    
    // Cyan to Blue
    for (var i = 0; i < segment_width; i++) {
        var ratio = i / segment_width;
        var color = make_color_rgb(0, round(255 * (1 - ratio)), 255);
        gmui_add_rect(x + segment_width * 3 + i, y, 1, height, color);
    }
    
    // Blue to Magenta
    for (var i = 0; i < segment_width; i++) {
        var ratio = i / segment_width;
        var color = make_color_rgb(round(255 * ratio), 0, 255);
        gmui_add_rect(x + segment_width * 4 + i, y, 1, height, color);
    }
    
    // Magenta to Red
    for (var i = 0; i < segment_width; i++) {
        var ratio = i / segment_width;
        var color = make_color_rgb(255, 0, round(255 * (1 - ratio)));
        gmui_add_rect(x + segment_width * 5 + i, y, 1, height, color);
    }
}

function gmui_draw_saturation_brightness_area(x, y, width, height, hue) {
    // Draw saturation/brightness gradient
    for (var sy = 0; sy < height; sy++) {
        var brightness = 1 - (sy / height);
        
        for (var sx = 0; sx < width; sx++) {
            var saturation = sx / width;
            var rgb = gmui_hsva_to_rgba(hue, saturation, brightness, 255);
            var color = make_color_rgb(
                round(rgb[0] * 255),
                round(rgb[1] * 255),
                round(rgb[2] * 255)
            );
            gmui_add_rect(x + sx, y + sy, 1, 1, color);
        }
    }
}

function gmui_draw_alpha_bar(x, y, width, height, rgb_color) {
    // Draw checkerboard background for transparency
    var checker_size = 4;
    for (var i = 0; i < width; i += checker_size * 2) {
        for (var j = 0; j < height; j += checker_size * 2) {
            // Draw checkerboard pattern
            gmui_add_rect(x + i, y + j, checker_size, checker_size, make_color_rgb(120, 120, 120));
            gmui_add_rect(x + i + checker_size, y + j + checker_size, checker_size, checker_size, make_color_rgb(120, 120, 120));
            gmui_add_rect(x + i + checker_size, y + j, checker_size, checker_size, make_color_rgb(80, 80, 80));
            gmui_add_rect(x + i, y + j + checker_size, checker_size, checker_size, make_color_rgb(80, 80, 80));
        }
    }
    
    // Draw alpha gradient
    for (var i = 0; i < width; i++) {
        var alpha = i / width;
        var color = gmui_make_color_rgba(
            round(rgb_color[0] * 255),
            round(rgb_color[1] * 255),
            round(rgb_color[2] * 255),
            round(alpha * 255)
        );
        gmui_add_rect(x + i, y, 1, height, color);
    }
}

//////////////////////////////////////
// CONTAINERS (Treeviews, collapsible headers, selectables)
//////////////////////////////////////
function gmui_selectable(label, selected, width = -1, height = -1) {
    if (!global.gmui.initialized || !global.gmui.current_window) return false;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
	var element_id = "id_selectable_" + label + string(dc.cursor_x) + string(dc.cursor_y);
    
    // Calculate selectable size
    var text_size = gmui_calc_text_size(label);
    var selectable_width = max(text_size[0] + style.selectable_padding[0] * 2, width > 0 ? width : 0);
    var selectable_height = max(style.selectable_height, height > 0 ? height : 0);
    
    // Use custom size if provided, otherwise use text-based size
    if (width <= 0) selectable_width = text_size[0] + style.selectable_padding[0] * 2;
    if (height <= 0) selectable_height = style.selectable_height;
    
    // Check if selectable fits on current line
    //if (dc.cursor_x + selectable_width > window.width - style.window_padding[0] && dc.cursor_x > dc.cursor_start_x) {
    //    gmui_new_line();
    //}
    
    // Calculate selectable bounds
    var selectable_x = dc.cursor_x;
    var selectable_y = dc.cursor_y;
    var selectable_bounds = [selectable_x, selectable_y, selectable_x + selectable_width, selectable_y + selectable_height];
    
    // Check for mouse interaction
    var mouse_over = gmui_is_mouse_over_window(window) && 
                     gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, global.gmui.mouse_pos[1] - window.y, selectable_bounds) && !global.gmui.is_hovering_element;
    
    var clicked = false;
    var is_active = false;
    
    if (mouse_over && window.active && !global.gmui.is_hovering_element) {
		global.gmui.is_hovering_element = true;
        if (global.gmui.mouse_clicked[0]) {
            global.gmui.last_pressed_clickable_id = element_id;
        }
        if (global.gmui.mouse_down[0] && global.gmui.last_pressed_clickable_id == element_id) {
            is_active = true;
        }
        if (global.gmui.mouse_released[0] && global.gmui.last_pressed_clickable_id == element_id) {
            clicked = true;
        }
    }
    
    // Draw selectable based on state and selection
    var bg_color, border_color, text_color;
    
    if (!window.active) {
        // Window not active - disabled state
        bg_color = style.selectable_disabled_bg_color;
        border_color = style.selectable_disabled_border_color;
        text_color = style.selectable_text_disabled_color;
    } else if (selected) {
        // Selected state
        if (is_active) {
            bg_color = style.selectable_active_bg_color;
            border_color = style.selectable_active_border_color;
        } else if (mouse_over) {
            bg_color = style.selectable_selected_hover_bg_color;
            border_color = style.selectable_selected_hover_border_color;
        } else {
            bg_color = style.selectable_selected_bg_color;
            border_color = style.selectable_selected_border_color;
        }
        text_color = style.selectable_text_selected_color;
    } else {
        // Not selected state
        if (is_active) {
            bg_color = style.selectable_active_bg_color;
            border_color = style.selectable_active_border_color;
        } else if (mouse_over) {
            bg_color = style.selectable_hover_bg_color;
            border_color = style.selectable_hover_border_color;
        } else {
            bg_color = style.selectable_bg_color;
            border_color = style.selectable_border_color;
        }
        text_color = style.selectable_text_color;
    }
    
    // Draw selectable background
    gmui_add_rect_round(selectable_x, selectable_y, selectable_width, selectable_height, bg_color, style.selectable_rounding);
    
    // Draw border
    if (style.selectable_border_size > 0) {
        gmui_add_rect_round_outline(selectable_x, selectable_y, selectable_width, selectable_height, border_color, style.selectable_rounding, style.selectable_border_size);
    }
    
    // Draw text centered
    var text_x = selectable_x + (selectable_width - text_size[0]) / 2;
    var text_y = selectable_y + (selectable_height - text_size[1]) / 2;
    gmui_add_text(text_x, text_y, label, text_color);
    
    // Update cursor position
    dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x += selectable_width + style.item_spacing[0];
    dc.line_height = max(dc.line_height, selectable_height);
    
    gmui_new_line();
    
    return clicked && window.active;
}

function gmui_selectable_disabled(label, selected, width = -1, height = -1) {
    if (!global.gmui.initialized || !global.gmui.current_window) return false;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
    
    // Calculate selectable size
    var text_size = gmui_calc_text_size(label);
    var selectable_width = max(text_size[0] + style.selectable_padding[0] * 2, width > 0 ? width : 0);
    var selectable_height = max(style.selectable_height, height > 0 ? height : 0);
    
    if (width <= 0) selectable_width = text_size[0] + style.selectable_padding[0] * 2;
    if (height <= 0) selectable_height = style.selectable_height;
    
    // Check if selectable fits on current line
    if (dc.cursor_x + selectable_width > window.width - style.window_padding[0] && dc.cursor_x > dc.cursor_start_x) {
        gmui_new_line();
    }
    
    var selectable_x = dc.cursor_x;
    var selectable_y = dc.cursor_y;
    
    // Draw disabled selectable
    var bg_color = style.selectable_disabled_bg_color;
    var border_color = style.selectable_disabled_border_color;
    var text_color = style.selectable_text_disabled_color;
    
    // If selected, use a darker version of selected color
    if (selected) {
        bg_color = make_color_rgb(40, 60, 120); // Darker blue for disabled selected
        text_color = make_color_rgb(180, 180, 180);
    }
    
    gmui_add_rect(selectable_x, selectable_y, selectable_width, selectable_height, bg_color);
    
    if (style.selectable_border_size > 0) {
        gmui_add_rect_outline(selectable_x, selectable_y, selectable_width, selectable_height, border_color, style.selectable_border_size);
    }
    
    // Draw text centered
    var text_x = selectable_x + (selectable_width - text_size[0]) / 2;
    var text_y = selectable_y + (selectable_height - text_size[1]) / 2;
    gmui_add_text(text_x, text_y, label, text_color);
    
    // Update cursor position
    dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x += selectable_width + style.item_spacing[0];
    dc.line_height = max(dc.line_height, selectable_height);
    
    gmui_new_line();
    
    return false; // Disabled selectables never return true
}

function gmui_selectable_small(label, selected) {
    return gmui_selectable(label, selected, -1, 20);
}

function gmui_selectable_large(label, selected) {
    return gmui_selectable(label, selected, -1, 32);
}

function gmui_selectable_width(label, selected, width) {
    return gmui_selectable(label, selected, width, -1);
}

function gmui_treeview_node_id(window, path_array) {
    var _id = window.name + "_";
    for (var i = 0; i < array_length(path_array); i++) {
        _id += string(path_array[i]) + "/";
    }
    return _id;
}

function gmui_treeview_is_node_open(window, path_array) {
    var node_id = gmui_treeview_node_id(window, path_array);
    return ds_map_exists(global.gmui.treeview_open_nodes, node_id) && global.gmui.treeview_open_nodes[? node_id];
}

function gmui_treeview_toggle_node(window, path_array) {
    var node_id = gmui_treeview_node_id(window, path_array);
    if (ds_map_exists(global.gmui.treeview_open_nodes, node_id)) {
        global.gmui.treeview_open_nodes[? node_id] = !global.gmui.treeview_open_nodes[? node_id];
    } else {
        ds_map_add(global.gmui.treeview_open_nodes, node_id, true);
    }
}

function gmui_treeview_set_node_open(window, path_array, open) {
    var node_id = gmui_treeview_node_id(window, path_array);
    if (ds_map_exists(global.gmui.treeview_open_nodes, node_id)) {
        global.gmui.treeview_open_nodes[? node_id] = open;
    } else {
        ds_map_add(global.gmui.treeview_open_nodes, node_id, open);
    }
}

function gmui_treeview_get_depth(window) {
    if (array_length(window.treeview_stack) == 0) return 0;
    var current_path = window.treeview_stack[array_length(window.treeview_stack) - 1];
    return array_length(current_path) - 1;
}

function gmui_treeview_get_current_path(window) {
    if (array_length(window.treeview_stack) == 0) return [];
    return window.treeview_stack[array_length(window.treeview_stack) - 1];
}

function gmui_treeview_push(window, path_array) {
    array_push(window.treeview_stack, path_array);
}

function gmui_treeview_pop(window) {
    if (array_length(window.treeview_stack) > 0) {
        array_pop(window.treeview_stack);
    }
}

function gmui_tree_node(label, selected = false, leaf = false) {
    if (!global.gmui.initialized || !global.gmui.current_window) return [false, false, false];
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
    
    // Get current treeview context
    var current_path = gmui_treeview_get_current_path();
    var node_id = gmui_treeview_node_id(current_path);
    var is_open = gmui_treeview_is_node_open(current_path);
    var _depth = gmui_treeview_get_depth();
    
    // Calculate indent
    var indent = _depth * style.treeview_indent;
    var item_height = style.treeview_item_height;
    
    // Calculate node bounds
    var node_x = dc.cursor_x + indent;
    var node_y = dc.cursor_y;
    var node_width = window.width - style.window_padding[0] * 2 - indent;
    var node_bounds = [node_x, node_y, node_x + node_width, node_y + item_height];
    
    // Check for mouse interaction
    var mouse_over = gmui_is_mouse_over_window(window) && 
                     gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, 
                                         global.gmui.mouse_pos[1] - window.y, 
                                         node_bounds) && !global.gmui.is_hovering_element;
    
    var clicked = false;
    var is_active = false;
    var arrow_clicked = false;
    
    if (mouse_over && window.active && !global.gmui.is_hovering_element) {
		global.gmui.is_hovering_element = true;
        if (global.gmui.mouse_down[0]) {
            is_active = true;
        }
        if (global.gmui.mouse_released[0]) {
            clicked = true;
            
            // Check if click was on arrow (for non-leaf nodes)
            if (!leaf) {
                var arrow_x = node_x + style.treeview_indent - style.treeview_arrow_size - 4;
                var arrow_y = node_y + (item_height - style.treeview_arrow_size) / 2;
                var arrow_bounds = [arrow_x, arrow_y, arrow_x + style.treeview_arrow_size, arrow_y + style.treeview_arrow_size];
                
                if (gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, 
                                        global.gmui.mouse_pos[1] - window.y, 
                                        arrow_bounds)) {
                    arrow_clicked = true;
                    gmui_treeview_toggle_node(current_path);
                    is_open = !is_open;
                }
            }
        }
    }
    
    // Draw node background based on state
    var bg_color, text_color;
    
    if (!window.active) {
        bg_color = style.treeview_bg_color;
        text_color = style.treeview_text_disabled_color;
    } else if (selected) {
        if (is_active) {
            bg_color = style.treeview_active_bg_color;
        } else if (mouse_over) {
            bg_color = style.treeview_selected_hover_bg_color;
        } else {
            bg_color = style.treeview_selected_bg_color;
        }
        text_color = style.treeview_text_selected_color;
    } else {
        if (is_active) {
            bg_color = style.treeview_active_bg_color;
        } else if (mouse_over) {
            bg_color = style.treeview_hover_bg_color;
        } else {
            bg_color = style.treeview_bg_color;
        }
        text_color = style.treeview_text_color;
    }
    
    // Draw node background
    gmui_add_rect(node_x, node_y, node_width, item_height, bg_color);
    
    // Draw arrow for non-leaf nodes
    if (!leaf) {
        var arrow_x = node_x + style.treeview_indent - style.treeview_arrow_size - 4;
        var arrow_y = node_y + (item_height - style.treeview_arrow_size) / 2;
        
        var arrow_color = style.treeview_arrow_color;
        if (mouse_over && window.active) {
            if (is_active) {
                arrow_color = style.treeview_arrow_active_color;
            } else {
                arrow_color = style.treeview_arrow_hover_color;
            }
        }
        
        // Draw arrow (triangle)
        if (is_open) {
            // Down arrow
            var arrow_points = [
                [arrow_x, arrow_y],
                [arrow_x + style.treeview_arrow_size, arrow_y],
                [arrow_x + style.treeview_arrow_size / 2, arrow_y + style.treeview_arrow_size]
            ];
        } else {
            // Right arrow
            var arrow_points = [
                [arrow_x, arrow_y],
                [arrow_x + style.treeview_arrow_size, arrow_y + style.treeview_arrow_size / 2],
                [arrow_x, arrow_y + style.treeview_arrow_size]
            ];
        }
        
        // Draw filled triangle
        gmui_add_triangle(arrow_points[0][0], arrow_points[0][1],
                         arrow_points[1][0], arrow_points[1][1],
                         arrow_points[2][0], arrow_points[2][1],
                         arrow_color);
    }
    
    // Draw label
    var text_size = gmui_calc_text_size(label);
    var text_x = node_x + style.treeview_indent;
    var text_y = node_y + (item_height - text_size[1]) / 2;
    gmui_add_text(text_x, text_y, label, text_color);
    
    // Update cursor position
    dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x = dc.cursor_start_x;
    dc.cursor_y += item_height;
    dc.line_height = max(dc.line_height, item_height);
    
    return [is_open, clicked && !arrow_clicked, selected];
}

function gmui_tree_node_begin(label, selected = false) {
    if (!global.gmui.initialized || !global.gmui.current_window) return false;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
	var element_id = "id_treenodebegin_" + label + string(dc.cursor_x) + string(dc.cursor_y);
    
    // Get current treeview context - FIXED PATH BUILDING
    var parent_path = array_length(window.treeview_stack) > 0 ? 
        window.treeview_stack[array_length(window.treeview_stack) - 1] : [];
    
    // Create new path by adding current label to parent path
    var new_path = [];
    for (var i = 0; i < array_length(parent_path); i++) {
        array_push(new_path, parent_path[i]);
    }
    array_push(new_path, label);
    
    var node_id = gmui_treeview_node_id(window, new_path);
    var is_open = gmui_treeview_is_node_open(window, new_path);
    var _depth = array_length(new_path) - 1; // Depth is based on path length
    
    // Calculate indent
    var indent = _depth * style.treeview_indent;
    var item_height = style.treeview_item_height;
    
    // Calculate node bounds
    var node_x = dc.cursor_x + indent;
    var node_y = dc.cursor_y;
    var node_width = window.width - style.window_padding[0] * 2 - indent;
    var node_bounds = [node_x, node_y, node_x + node_width, node_y + item_height];
    
    // Check for mouse interaction
    var mouse_over = gmui_is_mouse_over_window(window) && 
                     gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, 
                                         global.gmui.mouse_pos[1] - window.y, 
                                         node_bounds) && !global.gmui.is_hovering_element;
    
    var clicked = false;
    var is_active = false;
    var arrow_clicked = false;
    
    if (mouse_over && window.active) {
        global.gmui.is_hovering_element = true;
        if (global.gmui.mouse_clicked[0]) {
            global.gmui.last_pressed_clickable_id = element_id;
        }
        if (global.gmui.mouse_down[0] && global.gmui.last_pressed_clickable_id == element_id) {
            is_active = true;
        }
        if (global.gmui.mouse_released[0] && global.gmui.last_pressed_clickable_id == element_id) {
            clicked = true;
            
            // Check if click was on arrow
            var arrow_x = node_x + style.treeview_indent - style.treeview_arrow_size - 4;
            var arrow_y = node_y + (item_height - style.treeview_arrow_size) / 2;
            var arrow_bounds = [arrow_x, arrow_y, arrow_x + style.treeview_arrow_size, arrow_y + style.treeview_arrow_size];
            
            if (gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, 
                                    global.gmui.mouse_pos[1] - window.y, 
                                    arrow_bounds)) {
                arrow_clicked = true;
                gmui_treeview_toggle_node(window, new_path);
                is_open = !is_open;
            }
        }
    }
    
    // Draw node background based on state
    var bg_color, text_color;
    
    if (!window.active) {
        bg_color = style.treeview_bg_color;
        text_color = style.treeview_text_disabled_color;
    } else if (selected) {
        if (is_active) {
            bg_color = style.treeview_active_bg_color;
        } else if (mouse_over) {
            bg_color = style.treeview_selected_hover_bg_color;
        } else {
            bg_color = style.treeview_selected_bg_color;
        }
        text_color = style.treeview_text_selected_color;
    } else {
        if (is_active) {
            bg_color = style.treeview_active_bg_color;
        } else if (mouse_over) {
            bg_color = style.treeview_hover_bg_color;
        } else {
            bg_color = style.treeview_bg_color;
        }
        text_color = style.treeview_text_color;
    }
    
    // Draw node background
    gmui_add_rect(node_x, node_y, node_width, item_height, bg_color);
    
    // Draw arrow
    var arrow_x = node_x + style.treeview_indent - style.treeview_arrow_size - 4;
    var arrow_y = node_y + (item_height - style.treeview_arrow_size) / 2;
    
    var arrow_color = style.treeview_arrow_color;
    if (mouse_over && window.active) {
        if (is_active) {
            arrow_color = style.treeview_arrow_active_color;
        } else {
            arrow_color = style.treeview_arrow_hover_color;
        }
    }
    
    // Draw arrow (triangle)
    if (is_open) {
        // Down arrow
        var arrow_points = [
            [arrow_x, arrow_y],
            [arrow_x + style.treeview_arrow_size, arrow_y],
            [arrow_x + style.treeview_arrow_size / 2, arrow_y + style.treeview_arrow_size]
        ];
    } else {
        // Right arrow
        var arrow_points = [
            [arrow_x, arrow_y],
            [arrow_x + style.treeview_arrow_size, arrow_y + style.treeview_arrow_size / 2],
            [arrow_x, arrow_y + style.treeview_arrow_size]
        ];
    }
    
    // Draw filled triangle
    gmui_add_triangle(arrow_points[0][0], arrow_points[0][1],
                     arrow_points[1][0], arrow_points[1][1],
                     arrow_points[2][0], arrow_points[2][1],
                     arrow_color);
    
    // Draw label
    var text_size = gmui_calc_text_size(label);
    var text_x = node_x + style.treeview_indent;
    var text_y = node_y + (item_height - text_size[1]) / 2;
    gmui_add_text(text_x, text_y, label, text_color);
    
    // Update cursor position
    dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x = dc.cursor_start_x;
    dc.cursor_y += item_height + style.treeview_spacing;
    dc.line_height = max(dc.line_height, item_height);
    
    // Push the complete new path to the stack
    array_push(window.treeview_stack, new_path);
    
    return [is_open, clicked && !arrow_clicked];
}

function gmui_tree_leaf(label, selected = false) {
    if (!global.gmui.initialized || !global.gmui.current_window) return false;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
	var element_id = "id_treeleaf_" + label + "_" + string(dc.cursor_x) + "_" + string(dc.cursor_y);
    
    var current_path = gmui_treeview_get_current_path(window);
    var _depth = gmui_treeview_get_depth(window);
    
    // Calculate indent
    var indent = _depth * style.treeview_indent;
    var item_height = style.treeview_item_height;
    
    // Calculate node bounds
    var node_x = dc.cursor_x + indent + style.treeview_indent; // one extra indent
    var node_y = dc.cursor_y;
    var node_width = window.width - style.window_padding[0] * 2 - indent - style.treeview_indent; // one extra indent
    var node_bounds = [node_x, node_y, node_x + node_width, node_y + item_height];
    
    // Check for mouse interaction
    var mouse_over = gmui_is_mouse_over_window(window) && 
                     gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, 
                                         global.gmui.mouse_pos[1] - window.y, 
                                         node_bounds) && !global.gmui.is_hovering_element;
    
    var clicked = false;
    var is_active = false;
    
    if (mouse_over && window.active) {
		global.gmui.is_hovering_element = true;
        if (global.gmui.mouse_clicked[0]) {
            global.gmui.last_pressed_clickable_id = element_id;
        }
        if (global.gmui.mouse_down[0] && global.gmui.last_pressed_clickable_id == element_id) {
            is_active = true;
        }
        if (global.gmui.mouse_released[0] && global.gmui.last_pressed_clickable_id == element_id) {
            clicked = true;
        }
    }
    
    // Draw node background based on state
    var bg_color, text_color;
    
    if (!window.active) {
        bg_color = style.treeview_bg_color;
        text_color = style.treeview_text_disabled_color;
    } else if (selected) {
        if (is_active) {
            bg_color = style.treeview_active_bg_color;
        } else if (mouse_over) {
            bg_color = style.treeview_selected_hover_bg_color;
        } else {
            bg_color = style.treeview_selected_bg_color;
        }
        text_color = style.treeview_text_selected_color;
    } else {
        if (is_active) {
            bg_color = style.treeview_active_bg_color;
        } else if (mouse_over) {
            bg_color = style.treeview_hover_bg_color;
        } else {
            bg_color = style.treeview_bg_color;
        }
        text_color = style.treeview_text_color;
    }
    
    // Draw node background
    gmui_add_rect(node_x, node_y, node_width, item_height, bg_color);
    
    // Draw label (indented to align with parent nodes' labels)
    var text_size = gmui_calc_text_size(label);
    var text_x = node_x + style.treeview_indent;
    var text_y = node_y + (item_height - text_size[1]) / 2;
    gmui_add_text(text_x, text_y, label, text_color);
    
    // Update cursor position
    dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x = dc.cursor_start_x;
    dc.cursor_y += item_height + style.treeview_spacing;
    dc.line_height = max(dc.line_height, item_height);
    
    // NOTE: We don't push/pop for leaf nodes - they don't affect the depth hierarchy
    return clicked && window.active;
}

function gmui_tree_node_end() {
    var window = global.gmui.current_window;
    gmui_treeview_pop(window);
}

function gmui_tree_node_ex(label, selected = false) {
    if (!global.gmui.initialized || !global.gmui.current_window) return [false, false, false];
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
    
    // Get current treeview context
    var current_path = gmui_treeview_get_current_path();
    var node_id = gmui_treeview_node_id(current_path);
    var is_open = gmui_treeview_is_node_open(current_path);
    var _depth = gmui_treeview_get_depth();
    
    // Calculate indent
    var indent = _depth * style.treeview_indent;
    var item_height = style.treeview_item_height;
    
    // Calculate node bounds
    var node_x = dc.cursor_x + indent;
    var node_y = dc.cursor_y;
    var node_width = window.width - style.window_padding[0] * 2 - indent;
    var node_bounds = [node_x, node_y, node_x + node_width, node_y + item_height];
    
    // Check for mouse interaction
    var mouse_over = gmui_is_mouse_over_window(window) && 
                     gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, 
                                         global.gmui.mouse_pos[1] - window.y, 
                                         node_bounds) && !global.gmui.is_hovering_element;
    
    var clicked = false;
    var is_active = false;
    var arrow_clicked = false;
    
    if (mouse_over && window.active) {
		global.gmui.is_hovering_element = true;
        if (global.gmui.mouse_down[0]) {
            is_active = true;
        }
        if (global.gmui.mouse_released[0]) {
            clicked = true;
            
            // Check if click was on arrow
            var arrow_x = node_x + style.treeview_indent - style.treeview_arrow_size - 4;
            var arrow_y = node_y + (item_height - style.treeview_arrow_size) / 2;
            var arrow_bounds = [arrow_x, arrow_y, arrow_x + style.treeview_arrow_size, arrow_y + style.treeview_arrow_size];
            
            if (gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, 
                                    global.gmui.mouse_pos[1] - window.y, 
                                    arrow_bounds)) {
                arrow_clicked = true;
                gmui_treeview_toggle_node(current_path);
                is_open = !is_open;
            }
        }
    }
    
    // Draw node background based on state
    var bg_color, text_color;
    
    if (!window.active) {
        bg_color = style.treeview_bg_color;
        text_color = style.treeview_text_disabled_color;
    } else if (selected) {
        if (is_active) {
            bg_color = style.treeview_active_bg_color;
        } else if (mouse_over) {
            bg_color = style.treeview_selected_hover_bg_color;
        } else {
            bg_color = style.treeview_selected_bg_color;
        }
        text_color = style.treeview_text_selected_color;
    } else {
        if (is_active) {
            bg_color = style.treeview_active_bg_color;
        } else if (mouse_over) {
            bg_color = style.treeview_hover_bg_color;
        } else {
            bg_color = style.treeview_bg_color;
        }
        text_color = style.treeview_text_color;
    }
    
    // Draw node background
    gmui_add_rect(node_x, node_y, node_width, item_height, bg_color);
    
    // Draw arrow
    var arrow_x = node_x + style.treeview_indent - style.treeview_arrow_size - 4;
    var arrow_y = node_y + (item_height - style.treeview_arrow_size) / 2;
    
    var arrow_color = style.treeview_arrow_color;
    if (mouse_over && window.active) {
        if (is_active) {
            arrow_color = style.treeview_arrow_active_color;
        } else {
            arrow_color = style.treeview_arrow_hover_color;
        }
    }
    
    // Draw arrow (triangle)
    if (is_open) {
        // Down arrow
        var arrow_points = [
            [arrow_x, arrow_y],
            [arrow_x + style.treeview_arrow_size, arrow_y],
            [arrow_x + style.treeview_arrow_size / 2, arrow_y + style.treeview_arrow_size]
        ];
    } else {
        // Right arrow
        var arrow_points = [
            [arrow_x, arrow_y],
            [arrow_x + style.treeview_arrow_size, arrow_y + style.treeview_arrow_size / 2],
            [arrow_x, arrow_y + style.treeview_arrow_size]
        ];
    }
    
    // Draw filled triangle
    gmui_add_triangle(arrow_points[0][0], arrow_points[0][1],
                     arrow_points[1][0], arrow_points[1][1],
                     arrow_points[2][0], arrow_points[2][1],
                     arrow_color);
    
    // Draw label
    var text_size = gmui_calc_text_size(label);
    var text_x = node_x + style.treeview_indent;
    var text_y = node_y + (item_height - text_size[1]) / 2;
    gmui_add_text(text_x, text_y, label, text_color);
    
    // Update cursor position
    dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x = dc.cursor_start_x;
    dc.cursor_y += item_height + style.treeview_spacing;
    dc.line_height = max(dc.line_height, item_height);
    
    // Push new context for children
    var new_path = [];
    for (var i = 0; i < array_length(current_path); i++) {
        array_push(new_path, current_path[i]);
    }
    array_push(new_path, label);
    gmui_treeview_push(new_path);
    
    return [is_open, clicked && !arrow_clicked, selected];
}

function gmui_tree_node_reset() {
    if (!global.gmui.initialized || !global.gmui.current_window) return;
    
    var window = global.gmui.current_window;
    // Clear the treeview stack to reset to depth 0
    window.treeview_stack = [];
}

function gmui_collapsing_header(label, is_open) {
    if (!global.gmui.initialized || !global.gmui.current_window) return [is_open, false];
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
	var element_id = "id_collapsingheader_" + label + "_" + string(dc.cursor_x) + "_" + string(dc.cursor_y);
    
    // Calculate header size
    var text_size = gmui_calc_text_size(label);
    var header_width = window.width - style.window_padding[0] * 2;
    var header_height = style.collapsible_header_height;
    
    // Calculate header bounds
    var header_x = dc.cursor_x;
    var header_y = dc.cursor_y;
    var header_bounds = [header_x, header_y, header_x + header_width, header_y + header_height];
    
    // Check for mouse interaction
    var mouse_over = gmui_is_mouse_over_window(window) && 
                     gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, 
                                         global.gmui.mouse_pos[1] - window.y, 
                                         header_bounds) && !global.gmui.is_hovering_element;
    
    var clicked = false;
    var is_active = false;
    
    if (mouse_over && window.active) {
		global.gmui.is_hovering_element = true;
        if (global.gmui.mouse_clicked[0]) {
            global.gmui.last_pressed_clickable_id = element_id;
        }
        if (global.gmui.mouse_down[0] && global.gmui.last_pressed_clickable_id == element_id) {
            is_active = true;
        }
        if (global.gmui.mouse_released[0] && global.gmui.last_pressed_clickable_id == element_id) {
            clicked = true;
            is_open = !is_open;
        }
    }
    
    // Draw header based on state
    var bg_color, border_color, text_color, arrow_color;
    
    if (!window.active) {
        bg_color = style.collapsible_header_bg_color;
        border_color = style.collapsible_header_border_color;
        text_color = style.collapsible_header_text_color;
        arrow_color = style.collapsible_header_arrow_color;
    } else if (is_active) {
        bg_color = style.collapsible_header_active_bg_color;
        border_color = style.collapsible_header_border_color;
        text_color = style.collapsible_header_text_color;
        arrow_color = style.collapsible_header_arrow_active_color;
    } else if (mouse_over) {
        bg_color = style.collapsible_header_hover_bg_color;
        border_color = style.collapsible_header_border_color;
        text_color = style.collapsible_header_text_color;
        arrow_color = style.collapsible_header_arrow_hover_color;
    } else {
        bg_color = style.collapsible_header_bg_color;
        border_color = style.collapsible_header_border_color;
        text_color = style.collapsible_header_text_color;
        arrow_color = style.collapsible_header_arrow_color;
    }
    
    // Draw header background
    gmui_add_rect_round(header_x, header_y, header_width, header_height, bg_color, style.collapsible_header_rounding);
    
    // Draw border
    if (style.collapsible_header_border_size > 0) {
        gmui_add_rect_round_outline(header_x, header_y, header_width, header_height, 
                            border_color, style.collapsible_header_rounding, style.collapsible_header_border_size);
    }
    
    // Draw arrow
    var arrow_x = header_x + style.collapsible_header_padding[0];
    var arrow_y = header_y + (header_height - style.collapsible_header_arrow_size) / 2;
    
    // Draw arrow (triangle)
    if (is_open) {
        // Down arrow
        var arrow_points = [
            [arrow_x, arrow_y],
            [arrow_x + style.collapsible_header_arrow_size, arrow_y],
            [arrow_x + style.collapsible_header_arrow_size / 2, arrow_y + style.collapsible_header_arrow_size]
        ];
    } else {
        // Right arrow
        var arrow_points = [
            [arrow_x, arrow_y],
            [arrow_x + style.collapsible_header_arrow_size, arrow_y + style.collapsible_header_arrow_size / 2],
            [arrow_x, arrow_y + style.collapsible_header_arrow_size]
        ];
    }
    
    // Draw filled triangle
    gmui_add_triangle(arrow_points[0][0], arrow_points[0][1],
                     arrow_points[1][0], arrow_points[1][1],
                     arrow_points[2][0], arrow_points[2][1],
                     arrow_color);
    
    // Draw label
    var text_x = arrow_x + style.collapsible_header_arrow_size + style.collapsible_header_padding[0];
    var text_y = header_y + (header_height - text_size[1]) / 2;
    gmui_add_text(text_x, text_y, label, text_color);
    
    // Update cursor position
    dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x = dc.cursor_start_x;
    dc.cursor_y += header_height + style.item_spacing[1];
    dc.line_height = max(dc.line_height, header_height);
    
    // If open, add content padding
    if (is_open) {
        dc.cursor_x += style.collapsible_header_content_padding[0];
        dc.cursor_y += style.collapsible_header_content_padding[1];
    }
    
    return [is_open, clicked];
}

function gmui_collapsing_header_end() {
    if (!global.gmui.initialized || !global.gmui.current_window) return;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
    
    // Remove content padding and move to next line
    dc.cursor_x = dc.cursor_start_x;
    dc.cursor_y += style.collapsible_header_content_padding[1];
    gmui_new_line();
}

//////////////////////////////////////
// FORMS (Checkboxes, sliders, textboxes, drag inputs)
//////////////////////////////////////
function gmui_checkbox(label, value) {
    if (!global.gmui.initialized || !global.gmui.current_window) return value;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
	var element_id = "id_ceckbox_" + label + "_" + string(dc.cursor_x) + "_" + string(dc.cursor_y);
    
    // Calculate total size needed
    var text_size = gmui_calc_text_size(label);
    var total_width = text_size[0] + style.checkbox_spacing + style.checkbox_size;
    var total_height = max(style.checkbox_size, text_size[1]);
    
    //// Check if checkbox fits on current line, otherwise move to new line
    //if (dc.cursor_x + total_width > window.width - style.window_padding[0] && dc.cursor_x > dc.cursor_start_x) {
    //    gmui_new_line();
    //}
    
    // Calculate label bounds (on the left)
    var label_x = dc.cursor_x;
    var label_y = dc.cursor_y + (total_height - text_size[1]) / 2;
    var label_bounds = [label_x, label_y, label_x + text_size[0], label_y + text_size[1]];
    
    // Calculate checkbox bounds (on the right)
    var checkbox_x = dc.cursor_x + text_size[0] + style.checkbox_spacing;
    var checkbox_y = dc.cursor_y + (total_height - style.checkbox_size) / 2;
    var checkbox_bounds = [checkbox_x, checkbox_y, checkbox_x + style.checkbox_size, checkbox_y + style.checkbox_size];
    
    // Calculate total interactive bounds (label + checkbox)
    var interactive_bounds = [
        label_x, 
        dc.cursor_y, 
        checkbox_x + style.checkbox_size, 
        dc.cursor_y + total_height
    ];
    
    // Check for mouse interaction
    var mouse_over = gmui_is_mouse_over_window(window) && 
                     gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, 
                                         global.gmui.mouse_pos[1] - window.y, 
                                         interactive_bounds) && !global.gmui.is_hovering_element;
    
    var toggled = false;
    var is_active = false;
    
    if (mouse_over && window.active) {
		global.gmui.is_hovering_element = true;
        if (global.gmui.mouse_clicked[0]) {
            global.gmui.last_pressed_clickable_id = element_id;
        }
        if (global.gmui.mouse_down[0] && global.gmui.last_pressed_clickable_id == element_id) {
            is_active = true;
        }
        if (global.gmui.mouse_released[0] && global.gmui.last_pressed_clickable_id == element_id) {
            toggled = true;
            value = !value;
        }
    }
    
    // Draw checkbox based on state
    var bg_color, border_color, text_color;
    
    if (!window.active) {
        // Window not active - disabled state
        bg_color = style.checkbox_disabled_bg_color;
        border_color = style.checkbox_disabled_border_color;
        text_color = style.checkbox_text_disabled_color;
    } else if (is_active) {
        // Checkbox being pressed
        bg_color = style.checkbox_active_bg_color;
        border_color = style.checkbox_active_border_color;
        text_color = style.checkbox_text_color;
    } else if (mouse_over) {
        // Mouse hovering
        bg_color = style.checkbox_hover_bg_color;
        border_color = style.checkbox_hover_border_color;
        text_color = style.checkbox_text_color;
    } else {
        // Normal state
        bg_color = style.checkbox_bg_color;
        border_color = style.checkbox_border_color;
        text_color = style.checkbox_text_color;
    }
    
    // Draw label first (on the left)
    gmui_add_text(label_x, label_y, label, text_color);
    
    // Draw checkbox background (on the right)
    gmui_add_rect_round(checkbox_x, checkbox_y, style.checkbox_size, style.checkbox_size, bg_color, style.checkbox_rounding);
    
    // Draw border
    if (style.checkbox_border_size > 0) {
        gmui_add_rect_round_outline(checkbox_x, checkbox_y, style.checkbox_size, style.checkbox_size, 
                            border_color, style.checkbox_rounding, style.checkbox_border_size);
    }
    
    // Draw checkmark if checked
    if (value) {
        var check_padding = 3;
        var check_x1 = checkbox_x + check_padding;
        var check_y1 = checkbox_y + style.checkbox_size / 2;
        var check_x2 = checkbox_x + style.checkbox_size / 2 - 1;
        var check_y2 = checkbox_y + style.checkbox_size - check_padding;
        var check_x3 = checkbox_x + style.checkbox_size - check_padding;
        var check_y3 = checkbox_y + check_padding;
        
        // Draw checkmark lines
        gmui_add_line(check_x1, check_y1, check_x2, check_y2, style.checkbox_check_color, 2);
        gmui_add_line(check_x2, check_y2, check_x3, check_y3, style.checkbox_check_color, 2);
    }
    
    // Update cursor position
    dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x += total_width + style.item_spacing[0];
    dc.line_height = max(dc.line_height, total_height);
	
	gmui_new_line();
    
    return value;
}

function gmui_checkbox_disabled(label, value) {
    if (!global.gmui.initialized || !global.gmui.current_window) return value;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
    
    // Calculate total size needed
    var text_size = gmui_calc_text_size(label);
    var total_width = text_size[0] + style.checkbox_spacing + style.checkbox_size;
    var total_height = max(style.checkbox_size, text_size[1]);
    
    // Check if checkbox fits on current line
    if (dc.cursor_x + total_width > window.width - style.window_padding[0] && dc.cursor_x > dc.cursor_start_x) {
        gmui_new_line();
    }
    
    // Calculate positions (label on left, checkbox on right)
    var label_x = dc.cursor_x;
    var label_y = dc.cursor_y + (total_height - text_size[1]) / 2;
    var checkbox_x = dc.cursor_x + text_size[0] + style.checkbox_spacing;
    var checkbox_y = dc.cursor_y + (total_height - style.checkbox_size) / 2;
    
    // Draw disabled label first (on the left)
    gmui_add_text(label_x, label_y, label, style.checkbox_text_disabled_color);
    
    // Draw disabled checkbox (on the right)
    gmui_add_rect_round(checkbox_x, checkbox_y, style.checkbox_size, style.checkbox_size, 
                 style.checkbox_disabled_bg_color, style.checkbox_rounding);
    
    if (style.checkbox_border_size > 0) {
        gmui_add_rect_round_outline(checkbox_x, checkbox_y, style.checkbox_size, style.checkbox_size, 
                            style.checkbox_disabled_border_color, style.checkbox_rounding, style.checkbox_border_size);
    }
    
    // Draw checkmark if checked (disabled style)
    if (value) {
        var check_padding = 3;
        var check_x1 = checkbox_x + check_padding;
        var check_y1 = checkbox_y + style.checkbox_size / 2;
        var check_x2 = checkbox_x + style.checkbox_size / 2 - 1;
        var check_y2 = checkbox_y + style.checkbox_size - check_padding;
        var check_x3 = checkbox_x + style.checkbox_size - check_padding;
        var check_y3 = checkbox_y + check_padding;
        
        gmui_add_line(check_x1, check_y1, check_x2, check_y2, style.checkbox_text_disabled_color, 2);
        gmui_add_line(check_x2, check_y2, check_x3, check_y3, style.checkbox_text_disabled_color, 2);
    }
    
    // Update cursor position
    dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x += total_width + style.item_spacing[0];
    dc.line_height = max(dc.line_height, total_height);
	
	gmui_new_line();
    
    return value;
}

function gmui_checkbox_box(value, size = -1) {
    if (!global.gmui.initialized || !global.gmui.current_window) return value;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
	var element_id = "id_ceckbox_box_" + string(dc.cursor_x) + "_" + string(dc.cursor_y);
    
    var checkbox_size = size > 0 ? size : style.checkbox_size;
    
    // Calculate checkbox bounds
    var checkbox_x = dc.cursor_x;
    var checkbox_y = dc.cursor_y;
    var checkbox_bounds = [checkbox_x, checkbox_y, checkbox_x + checkbox_size, checkbox_y + checkbox_size];
    
    // Check for mouse interaction
    var mouse_over = gmui_is_mouse_over_window(window) && 
                     gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, 
                                         global.gmui.mouse_pos[1] - window.y, 
                                         checkbox_bounds) && !global.gmui.is_hovering_element;
    
    var toggled = false;
    var is_active = false;
    
    if (mouse_over && window.active) {
		global.gmui.is_hovering_element = true;
        if (global.gmui.mouse_clicked[0]) {
            global.gmui.last_pressed_clickable_id = element_id;
        }
        if (global.gmui.mouse_down[0] && global.gmui.last_pressed_clickable_id == element_id) {
            is_active = true;
        }
        if (global.gmui.mouse_released[0] && global.gmui.last_pressed_clickable_id == element_id) {
            toggled = true;
            value = !value;
        }
    }
    
    // Draw checkbox based on state
    var bg_color, border_color;
    
    if (!window.active) {
        bg_color = style.checkbox_disabled_bg_color;
        border_color = style.checkbox_disabled_border_color;
    } else if (is_active) {
        bg_color = style.checkbox_active_bg_color;
        border_color = style.checkbox_active_border_color;
    } else if (mouse_over) {
        bg_color = style.checkbox_hover_bg_color;
        border_color = style.checkbox_hover_border_color;
    } else {
        bg_color = style.checkbox_bg_color;
        border_color = style.checkbox_border_color;
    }
    
    // Draw checkbox
    gmui_add_rect_round(checkbox_x, checkbox_y, checkbox_size, checkbox_size, bg_color, style.checkbox_rounding);
    
    if (style.checkbox_border_size > 0) {
        gmui_add_rect_round_outline(checkbox_x, checkbox_y, checkbox_size, checkbox_size, 
                            border_color, style.checkbox_rounding, style.checkbox_border_size);
    }
    
    // Draw checkmark if checked
    if (value) {
        var check_padding = 3 * (checkbox_size / style.checkbox_size); // Scale padding with size
        var check_x1 = checkbox_x + check_padding;
        var check_y1 = checkbox_y + checkbox_size / 2;
        var check_x2 = checkbox_x + checkbox_size / 2 - 1;
        var check_y2 = checkbox_y + checkbox_size - check_padding;
        var check_x3 = checkbox_x + checkbox_size - check_padding;
        var check_y3 = checkbox_y + check_padding;
        
        var check_color = window.active ? style.checkbox_check_color : style.checkbox_text_disabled_color;
        var check_thickness = max(1, floor(2 * (checkbox_size / style.checkbox_size))); // Scale thickness
        
        gmui_add_line(check_x1, check_y1, check_x2, check_y2, check_color, check_thickness);
        gmui_add_line(check_x2, check_y2, check_x3, check_y3, check_color, check_thickness);
    }
    
    // Update cursor position
    dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x += checkbox_size + style.item_spacing[0];
    dc.line_height = max(dc.line_height, checkbox_size);
	
	gmui_new_line();
    
    return value;
}

function gmui_slider(label, value, min_value, max_value, width = -1) {
    if (!global.gmui.initialized || !global.gmui.current_window) return value;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
    
    // Calculate sizes
    var text_size = gmui_calc_text_size(label);
    var slider_width = (width > 0) ? width : 100; // Default width if not specified
    var slider_height = max(style.slider_track_height, style.slider_handle_height);
    
    // Total width needed (text + spacing + slider)
    var total_width = text_size[0] + style.slider_spacing + slider_width;
    var total_height = max(text_size[1], slider_height);
    
    // Check if slider fits on current line
    if (dc.cursor_x + total_width > window.width - style.window_padding[0] && dc.cursor_x > dc.cursor_start_x) {
        gmui_new_line();
    }
    
    // Calculate slider bounds
    var slider_x = dc.cursor_x + text_size[0] + style.slider_spacing;
    var slider_y = dc.cursor_y;
    
    // Calculate track bounds
    var track_y = slider_y + (total_height - style.slider_track_height) / 2;
    var track_bounds = [slider_x, track_y, slider_x + slider_width, track_y + style.slider_track_height];
    
    // Calculate normalized value position
    var normalized_value = (value - min_value) / (max_value - min_value);
    normalized_value = clamp(normalized_value, 0, 1);
    
    // Calculate handle position
    var handle_x = slider_x + (slider_width - style.slider_handle_width) * normalized_value;
    var handle_y = track_y + (style.slider_track_height - style.slider_handle_height) / 2;
    var handle_bounds = [handle_x, handle_y, handle_x + style.slider_handle_width, handle_y + style.slider_handle_height];
    
    // Create a unique ID for this slider using window position and cursor position
    var slider_id = "slider_" + string(window.x) + "_" + string(window.y) + "_" + string(dc.cursor_x) + "_" + string(dc.cursor_y);
    
    // Check for mouse interaction
    var mouse_over = gmui_is_mouse_over_window(window);
    var mouse_over_handle = mouse_over && gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, global.gmui.mouse_pos[1] - window.y, handle_bounds) && !global.gmui.is_hovering_element;
    var mouse_over_track = mouse_over && gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, global.gmui.mouse_pos[1] - window.y, track_bounds) && !global.gmui.is_hovering_element;
    
    var value_changed = false;
    var is_active = false;
    var is_dragging = false;
    
    // Check if this is the active slider being dragged
    if (global.gmui.active_slider == slider_id && global.gmui.mouse_down[0]) {
        is_dragging = true;
        is_active = true;
    }
    
    if ((mouse_over_handle || mouse_over_track) && window.active) {
		global.gmui.is_hovering_element = true;
        if (global.gmui.mouse_clicked[0]) {
            // Start dragging this slider
            global.gmui.active_slider = slider_id;
            is_dragging = true;
            is_active = true;
        }
    }
    
    // If we're dragging, update the value based on mouse position
    if (is_dragging) {
        var mouse_x_in_slider = (global.gmui.mouse_pos[0] - window.x - slider_x) - style.slider_handle_width / 2;
        var new_normalized = clamp(mouse_x_in_slider / (slider_width - style.slider_handle_width), 0, 1);
        var new_value = min_value + new_normalized * (max_value - min_value);
        
        // Only update if value actually changed
        if (abs(new_value - value) > 0.001) {
            value = new_value;
            value_changed = true;
        }
        
        // Update handle position for visual feedback during drag
        normalized_value = (value - min_value) / (max_value - min_value);
        normalized_value = clamp(normalized_value, 0, 1);
        handle_x = slider_x + (slider_width - style.slider_handle_width) * normalized_value;
        handle_bounds = [handle_x, handle_y, handle_x + style.slider_handle_width, handle_y + style.slider_handle_height];
    }
    
    // Stop dragging when mouse is released
    if (global.gmui.mouse_released[0] && global.gmui.active_slider == slider_id) {
        global.gmui.active_slider = undefined;
    }
    
    // Draw label
    var text_color = window.active ? style.slider_text_color : style.slider_text_disabled_color;
    var text_y = dc.cursor_y + (total_height - text_size[1]) / 2;
    gmui_add_text(dc.cursor_x, text_y, label, text_color);
    
    // Draw track background
    var track_bg_color = window.active ? style.slider_track_bg_color : make_color_rgb(50, 50, 50);
    gmui_add_rect_round(track_bounds[0], track_bounds[1], slider_width, style.slider_track_height, track_bg_color, style.slider_track_rounding);
    
    // Draw track fill
    if (window.active) {
        var fill_width = (handle_x - slider_x) + style.slider_handle_width / 2;
        gmui_add_rect_round(track_bounds[0], track_bounds[1], fill_width, style.slider_track_height, style.slider_track_fill_color, style.slider_track_rounding);
    }
    
    // Draw track border
    if (style.slider_track_border_size > 0) {
        var track_border_color = window.active ? style.slider_track_border_color : make_color_rgb(70, 70, 70);
        gmui_add_rect_round_outline(track_bounds[0], track_bounds[1], slider_width, style.slider_track_height, track_border_color, style.slider_track_rounding, style.slider_track_border_size);
    }
    
    // Draw handle based on state
    var handle_bg_color, handle_border_color;
    
    if (!window.active) {
        handle_bg_color = style.slider_handle_disabled_bg_color;
        handle_border_color = style.slider_handle_disabled_border_color;
    } else if (is_dragging) {
        handle_bg_color = style.slider_handle_active_bg_color;
        handle_border_color = style.slider_handle_active_border_color;
    } else if (mouse_over_handle) {
        handle_bg_color = style.slider_handle_hover_bg_color;
        handle_border_color = style.slider_handle_hover_border_color;
    } else {
        handle_bg_color = style.slider_handle_bg_color;
        handle_border_color = style.slider_handle_border_color;
    }
    
    // Draw handle
    gmui_add_rect_round(handle_x, handle_y, style.slider_handle_width, style.slider_handle_height, handle_bg_color, style.slider_handle_rounding);
    
    if (style.slider_handle_border_size > 0) {
        gmui_add_rect_round_outline(handle_x, handle_y, style.slider_handle_width, style.slider_handle_height, handle_border_color, style.slider_handle_rounding, style.slider_handle_border_size);
    }
    
    // Update cursor position
    dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x += total_width + style.item_spacing[0];
    dc.line_height = max(dc.line_height, total_height);
    
    gmui_new_line();
    
    return value;
}

// Disabled slider element
function gmui_slider_disabled(label, value, min_value, max_value, width = -1) {
    if (!global.gmui.initialized || !global.gmui.current_window) return value;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
    
    // Calculate sizes
    var text_size = gmui_calc_text_size(label);
    var slider_width = (width > 0) ? width : 100;
    var slider_height = max(style.slider_track_height, style.slider_handle_height);
    
    // Total width needed (text + spacing + slider)
    var total_width = text_size[0] + style.slider_spacing + slider_width;
    var total_height = max(text_size[1], slider_height);
    
    // Check if slider fits on current line
    if (dc.cursor_x + total_width > window.width - style.window_padding[0] && dc.cursor_x > dc.cursor_start_x) {
        gmui_new_line();
    }
    
    var slider_x = dc.cursor_x + text_size[0] + style.slider_spacing;
    var slider_y = dc.cursor_y;
    
    // Calculate track bounds
    var track_y = slider_y + (total_height - style.slider_track_height) / 2;
    
    // Calculate normalized value position
    var normalized_value = (value - min_value) / (max_value - min_value);
    normalized_value = clamp(normalized_value, 0, 1);
    
    // Calculate handle position
    var handle_x = slider_x + (slider_width - style.slider_handle_width) * normalized_value;
    var handle_y = track_y + (style.slider_track_height - style.slider_handle_height) / 2;
    
    // Draw label
    var text_y = dc.cursor_y + (total_height - text_size[1]) / 2;
    gmui_add_text(dc.cursor_x, text_y, label, style.slider_text_disabled_color);
    
    // Draw disabled track background
    gmui_add_rect_round(slider_x, track_y, slider_width, style.slider_track_height, make_color_rgb(50, 50, 50), style.slider_track_rounding);
    
    // Draw disabled track fill (partial)
    var fill_width = (handle_x - slider_x) + style.slider_handle_width / 2;
    gmui_add_rect_round(slider_x, track_y, fill_width, style.slider_track_height, make_color_rgb(80, 80, 80), style.slider_track_rounding);
    
    // Draw track border
    if (style.slider_track_border_size > 0) {
        gmui_add_rect_round_outline(slider_x, track_y, slider_width, style.slider_track_height, make_color_rgb(70, 70, 70), style.slider_track_rounding, style.slider_track_border_size);
    }
    
    // Draw disabled handle
    gmui_add_rect_round(handle_x, handle_y, style.slider_handle_width, style.slider_handle_height, style.slider_handle_disabled_bg_color, style.slider_handle_rounding);
    
    if (style.slider_handle_border_size > 0) {
        gmui_add_rect_round_outline(handle_x, handle_y, style.slider_handle_width, style.slider_handle_height, style.slider_handle_disabled_border_color, style.slider_handle_rounding, style.slider_handle_border_size);
    }
    
    // Update cursor position
    dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x += total_width + style.item_spacing[0];
    dc.line_height = max(dc.line_height, total_height);
    
    gmui_new_line();
    
    return value;
}

function gmui_textbox_get_cursor_pos_from_x(text, x) {
    var len = string_length(text);
    var current_width = 0;
    for (var i = 1; i <= len; i++) {
        var char = string_char_at(text, i);
        var char_width = string_width(char);
        if (current_width + char_width / 2 > x) {
            return i - 1;
        }
        current_width += char_width;
    }
    return len;
}

function gmui_textbox(text, placeholder = "", width = -1) {
    if (!global.gmui.initialized || !global.gmui.current_window) return text;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
    
    // Calculate textbox size
    var text_size = gmui_calc_text_size("W"); // Use 'W' as reference for height
    var textbox_height = text_size[1] + style.textbox_padding[1] * 2;
    var textbox_width = (width > 0) ? width : 200; // Default width
    
    // Check if textbox fits on current line
    //if (dc.cursor_x + textbox_width > window.width - style.window_padding[0] && dc.cursor_x > dc.cursor_start_x) {
    //    gmui_new_line();
    //}
    
    // Calculate textbox bounds
    var textbox_x = dc.cursor_x;
    var textbox_y = dc.cursor_y;
    var textbox_bounds = [textbox_x, textbox_y, textbox_x + textbox_width, textbox_y + textbox_height];
    
    // Create a unique ID for this textbox
    var textbox_id = "textbox_" + string(window.x) + "_" + string(window.y) + "_" + string(dc.cursor_x) + "_" + string(dc.cursor_y);
	global.gmui.textbox_id = textbox_id;
    
    // Check for mouse interaction
	var mouse_over = gmui_is_mouse_over_window(window) && 
	                 gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, 
	                                     global.gmui.mouse_pos[1] - window.y, 
	                                     textbox_bounds) && !global.gmui.is_hovering_element;

	var clicked = false;
	var changed = false;
	var is_focused = (global.gmui.active_textbox != undefined && global.gmui.active_textbox.id == textbox_id);

	if (mouse_over && window.active) {
		global.gmui.is_hovering_element = true;
	    // Handle mouse press to set cursor position
	    if (global.gmui.mouse_clicked[0]) {
	        clicked = true;
        
	        // Set focus to this textbox
	        global.gmui.active_textbox = {
	            id: textbox_id,
	            text: text,
	            cursor_pos: string_length(text),
	            selection_start: 0,
	            selection_length: 0,
	            changed: false,
	            drag_start_pos: 0,  // Add this for drag tracking
				is_digit_only: false, 
				is_integer_only: false
	        };
	        is_focused = true;
        
	        // Set cursor position based on click
	        var click_x = global.gmui.mouse_pos[0] - window.x - (textbox_x + style.textbox_padding[0]);
	        textbox_set_cursor_from_click(global.gmui.active_textbox, click_x);
        
	        // Reset selection on click
	        global.gmui.active_textbox.selection_start = global.gmui.active_textbox.cursor_pos;
	        global.gmui.active_textbox.selection_length = 0;
	        global.gmui.active_textbox.drag_start_pos = global.gmui.active_textbox.cursor_pos;
	    }
    
	    // Handle text selection with mouse drag
	    if (is_focused && global.gmui.mouse_down[0]) {
	        var drag_x = global.gmui.mouse_pos[0] - window.x - (textbox_x + style.textbox_padding[0]);
        
	        // Only start dragging after initial click
	        if (global.gmui.mouse_down[0] && !global.gmui.mouse_clicked[0]) {
	            textbox_handle_mouse_drag(global.gmui.active_textbox, drag_x);
	        }
	    }
	}

	// Handle focus loss when clicking outside
	if (global.gmui.mouse_clicked[0] && !mouse_over && is_focused) {
	    global.gmui.active_textbox = undefined;
	    is_focused = false;
	}
    
    // Update text if this textbox is focused and changed
    if (is_focused) {
        if (global.gmui.active_textbox.changed) {
            text = global.gmui.active_textbox.text;
            changed = true;
        }
    }
    
    // Draw textbox background
    var bg_color = style.textbox_bg_color;
    var border_color = is_focused ? style.textbox_focused_border_color : style.textbox_border_color;
    
    gmui_add_rect_round(textbox_x, textbox_y, textbox_width, textbox_height, bg_color, style.textbox_rounding);
    
    // Draw border
    if (style.textbox_border_size > 0) {
        gmui_add_rect_round_outline(textbox_x, textbox_y, textbox_width, textbox_height, 
                            border_color, style.textbox_rounding, style.textbox_border_size);
    }
    
    // Create a surface for text clipping
    var text_surface = -1;
    var text_area_width = textbox_width - style.textbox_padding[0] * 2;
	var surface = undefined;
    
    if (surface_exists(window.surface)) {
		surface = gmui_cache_surface_get(textbox_id, text_area_width, text_size[1]);
        //text_surface = surface_create(text_area_width, text_size[1]);
        if (surface_exists(surface.surface)) {
            surface_set_target(surface.surface);
            draw_clear_alpha(c_black, 0);
			var oldBlendMode = gpu_get_blendmode();
			gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_one, bm_inv_src_alpha);
			
			draw_set_color(global.gmui.style.textbox_bg_color);
			draw_rectangle(0, 0, textbox_width, textbox_height, false); // neccessary for text and background blending
            
            var old_font = draw_get_font();
            draw_set_font(global.gmui.font);
            
            // Draw text or placeholder
            if (text == "" && placeholder != "" && !is_focused) {
                draw_set_color(style.textbox_placeholder_color);
                draw_text(0, 0, placeholder);
            } else if (text != "" || is_focused) {
                // Handle text display with cursor and selection
                var display_text = text;
                
                // Draw selection if any
                if (is_focused && global.gmui.active_textbox.selection_length > 0) {
                    var sel_start = global.gmui.active_textbox.selection_start;
                    var sel_length = global.gmui.active_textbox.selection_length;
                    
                    var prefix_text = string_copy(display_text, 1, sel_start);
                    var selected_text = string_copy(display_text, sel_start + 1, sel_length);
                    
                    var prefix_width = string_width(prefix_text);
                    var selected_width = string_width(selected_text);
                    
                    draw_set_color(style.textbox_selection_color);
                    //draw_rectangle(prefix_width, 0, prefix_width + selected_width, text_size[1], false);
					draw_roundrect_ext(prefix_width, 0, prefix_width + selected_width, text_size[1] - 1, style.textbox_rounding, style.textbox_rounding, false);
                }
                
                // Draw text
                draw_set_color(style.textbox_text_color);
                draw_text(0, 0, display_text);
                
                // Draw cursor if focused
                if (is_focused && global.gmui.textbox_cursor_visible) {
                    var cursor_prefix = string_copy(display_text, 1, global.gmui.active_textbox.cursor_pos);
                    var cursor_x = string_width(cursor_prefix);
                    
                    draw_set_color(style.textbox_cursor_color);
                    //draw_rectangle(cursor_x, 0, cursor_x + style.textbox_cursor_width, text_size[1], false);
					draw_set_alpha((sin(current_time / 200) * 0.5 + 0.5) * 0.8 + 0.2);
					draw_line_width(cursor_x, 0, cursor_x, text_size[1], style.textbox_cursor_width);
					draw_set_alpha(1);
                }
            }
            
			gpu_set_blendmode(oldBlendMode);
            draw_set_font(old_font);
            surface_reset_target();
        }
    }
    
    // Draw the text surface
    if (surface_exists(surface.surface)) {
        // Add surface to draw list
        array_push(window.draw_list, {
            type: "surface_o",
            surface: surface.surface,
            x: textbox_x + style.textbox_padding[0],
            y: textbox_y + style.textbox_padding[1]
        });
    }
    
    // Update cursor position
    dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x += textbox_width + style.item_spacing[0];
    dc.line_height = max(dc.line_height, textbox_height);
    
    gmui_new_line();
    
    return text;
}

function gmui_textbox_id() {
	return global.gmui.textbox_id;
};

function textbox_set_cursor_from_click(textbox, click_x) {
    var text = textbox.text;
    var len = string_length(text);
    
    if (len == 0 || click_x <= 0) {
        textbox.cursor_pos = 0;
        return;
    }
    
    var total_width = string_width(text);
    if (click_x >= total_width) {
        textbox.cursor_pos = len;
        return;
    }
    
    var low = 0;
    var high = len;
    var best_pos = len;
    var best_dist = abs(click_x - total_width);
    
    while (low <= high) {
        var mid = (low + high) div 2;
        var prefix = string_copy(text, 1, mid);
        var width = string_width(prefix);
        var dist = abs(click_x - width);
        
        if (dist < best_dist) {
            best_dist = dist;
            best_pos = mid;
        }
        
        if (width < click_x) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
    }
    
    textbox.cursor_pos = best_pos;
}

function textbox_handle_mouse_drag(textbox, drag_x) {
    var text = textbox.text;
    var len = string_length(text);
    
    if (drag_x <= 0) {
        textbox.cursor_pos = 0;
    }
    else if (drag_x >= string_width(text)) {
        textbox.cursor_pos = len;
    }
    else {
        var current_width = 0;
        for (var i = 1; i <= len; i++) {
            var char = string_char_at(text, i);
            var char_width = string_width(char);
            
            if (drag_x >= current_width && drag_x <= current_width + char_width) {
                if (drag_x <= current_width + char_width / 2) {
                    textbox.cursor_pos = i - 1;
                } else {
                    textbox.cursor_pos = i;
                }
                break;
            }
            current_width += char_width;
        }
    }
    
    if (textbox.cursor_pos < textbox.drag_start_pos) {
        textbox.selection_start = textbox.cursor_pos;
        textbox.selection_length = textbox.drag_start_pos - textbox.cursor_pos;
    } else {
        textbox.selection_start = textbox.drag_start_pos;
        textbox.selection_length = textbox.cursor_pos - textbox.drag_start_pos;
    }
}

function gmui_is_any_textbox_focused() {
    if (!global.gmui.initialized) return false;
    return global.gmui.active_textbox != undefined;
}

function gmui_get_focused_textbox_id() {
    if (!global.gmui.initialized || global.gmui.active_textbox == undefined) return undefined;
    return global.gmui.active_textbox.id;
}

function gmui_is_textbox_focused(textbox_id) {
    if (!global.gmui.initialized || global.gmui.active_textbox == undefined) return false;
    return global.gmui.active_textbox.id == textbox_id;
}

function gmui_get_focused_textbox_text() {
    if (!global.gmui.initialized || global.gmui.active_textbox == undefined) return "";
    return global.gmui.active_textbox.text;
}

function gmui_clear_textbox_focus() {
    if (!global.gmui.initialized) return;
    global.gmui.active_textbox = undefined;
}

function gmui_input_float(value, step = 1, min_value = -1000000, max_value = 1000000, width = -1, placeholder = "") {
    if (!global.gmui.initialized || !global.gmui.current_window) return value;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
    
    // Calculate textbox size
    var text_size = gmui_calc_text_size("0"); // Use '0' as reference for height
    var textbox_height = text_size[1] + style.drag_textbox_padding[1] * 2;
    var textbox_width = (width > 0) ? width : 120; // Default width
    
    // Check if textbox fits on current line
    if (dc.cursor_x + textbox_width > window.width - style.window_padding[0] && dc.cursor_x > dc.cursor_start_x) {
        gmui_new_line();
    }
    
    // Calculate textbox bounds
    var textbox_x = dc.cursor_x;
    var textbox_y = dc.cursor_y;
    var textbox_bounds = [textbox_x, textbox_y, textbox_x + textbox_width, textbox_y + textbox_height];
    
    // Calculate drag hotzone (right side of textbox)
    var drag_hotzone_x = textbox_x + textbox_width - style.drag_textbox_drag_hotzone_width;
    var drag_hotzone_bounds = [drag_hotzone_x, textbox_y, textbox_x + textbox_width, textbox_y + textbox_height];
    
    // Create a unique ID for this drag textbox
    var drag_textbox_id = "drag_textbox_" + string(window.x) + "_" + string(window.y) + "_" + string(dc.cursor_x) + "_" + string(dc.cursor_y);
    global.gmui.drag_textbox_id = drag_textbox_id;
    
    // Convert value to string for display/editing
    var value_string = string(value);
    
    // Check for mouse interaction
    var mouse_over = gmui_is_mouse_over_window(window) && 
                     gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, 
                                         global.gmui.mouse_pos[1] - window.y, 
                                         textbox_bounds) && !global.gmui.is_hovering_element;

    var mouse_over_drag_zone = gmui_is_mouse_over_window(window) && 
                               gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, 
                                                   global.gmui.mouse_pos[1] - window.y, 
                                                   drag_hotzone_bounds) && !global.gmui.is_hovering_element;

    var clicked = false;
    var is_focused = (global.gmui.active_textbox != undefined && global.gmui.active_textbox.id == drag_textbox_id);
    var is_dragging = (global.gmui.active_drag_textbox == drag_textbox_id);
    var value_changed = false;

    if (mouse_over && window.active) {
        global.gmui.is_hovering_element = true;
        
        // Handle mouse press
        if (global.gmui.mouse_clicked[0]) {
            clicked = true;
            
            if (mouse_over_drag_zone) {
                // Start dragging
                global.gmui.active_drag_textbox = drag_textbox_id;
                global.gmui.drag_textbox_start_value = value;
                global.gmui.drag_textbox_start_mouse_x = global.gmui.mouse_pos[0];
                is_dragging = true;
                
                // Defocus textbox if it was focused
                if (is_focused) {
                    global.gmui.active_textbox = undefined;
                    is_focused = false;
                }
            } else {
                // Set focus to this textbox for editing
                global.gmui.active_textbox = {
                    id: drag_textbox_id,
                    text: value_string,
                    cursor_pos: string_length(value_string),
                    selection_start: 0,
                    selection_length: 0,
                    changed: false,
                    drag_start_pos: 0,
                    is_digit_only: true, // Flag to indicate digit-only input
					is_integer_only: false
                };
                is_focused = true;
                
                // Set cursor position based on click
                var click_x = global.gmui.mouse_pos[0] - window.x - (textbox_x + style.drag_textbox_padding[0]);
                textbox_set_cursor_from_click(global.gmui.active_textbox, click_x);
                
                // Reset selection on click
                global.gmui.active_textbox.selection_start = global.gmui.active_textbox.cursor_pos;
                global.gmui.active_textbox.selection_length = 0;
                global.gmui.active_textbox.drag_start_pos = global.gmui.active_textbox.cursor_pos;
            }
        }
        
        // Handle text selection with mouse drag (only when focused and not in drag zone)
        if (is_focused && global.gmui.mouse_down[0] && !mouse_over_drag_zone) {
            var drag_x = global.gmui.mouse_pos[0] - window.x - (textbox_x + style.drag_textbox_padding[0]);
            
            // Only start dragging after initial click
            if (global.gmui.mouse_down[0] && !global.gmui.mouse_clicked[0]) {
                textbox_handle_mouse_drag(global.gmui.active_textbox, drag_x);
            }
        }
    }

    // Handle focus loss when clicking outside
    if (global.gmui.mouse_clicked[0] && !mouse_over && is_focused) {
        global.gmui.active_textbox = undefined;
        is_focused = false;
    }
    
    // Handle dragging
    if (is_dragging && global.gmui.mouse_down[0]) {
        var mouse_delta_x = global.gmui.mouse_pos[0] - global.gmui.drag_textbox_start_mouse_x;
        var value_delta = mouse_delta_x * style.drag_textbox_drag_sensitivity * step;
        
        var new_value = global.gmui.drag_textbox_start_value + value_delta;
        
        // Apply step snapping
        if (step != 0) {
            new_value = (new_value / step) * step; // round
        }
        
        // Clamp to min/max
        new_value = clamp(new_value, min_value, max_value);
        
        if (new_value != value) {
            value = new_value;
            value_string = string(value);
            value_changed = true;
        }
        
        // Update cursor to show dragging
        window_set_cursor(cr_size_we);
    } else if (is_dragging && global.gmui.mouse_released[0]) {
        // Stop dragging
        global.gmui.active_drag_textbox = undefined;
        is_dragging = false;
    }
    
    // Update value if this textbox is focused and changed
    if (is_focused) {
        if (global.gmui.active_textbox.changed) {
            // Filter to only allow digits, minus sign, and decimal point
            var filtered_text = "";
            var has_decimal = false;
            var has_minus = false;
            
            for (var i = 1; i <= string_length(global.gmui.active_textbox.text); i++) {
                var char = string_char_at(global.gmui.active_textbox.text, i);
                var byte = string_byte_at(char, 1);
                
                if (byte >= 48 && byte <= 57) { // 0-9
                    filtered_text += char;
                } else if (char == "-" && !has_minus && i == 1) { // Minus sign only at start
                    filtered_text += char;
                    has_minus = true;
                } else if (char == "." && !has_decimal) { // Decimal point only once
                    filtered_text += char;
                    has_decimal = true;
                }
            }
            
            global.gmui.active_textbox.text = filtered_text;
            global.gmui.active_textbox.changed = false;
            
            // Convert back to number if not empty
            if (filtered_text != "" && filtered_text != "-" && filtered_text != ".") {
                var new_num = real(filtered_text);
                if (new_num != value) {
                    value = clamp(new_num, min_value, max_value);
                    value_string = string(value);
                    value_changed = true;
                }
            }
        }
    }
    
    // Draw textbox background
    var bg_color = style.drag_textbox_bg_color;
    var border_color = is_focused ? style.drag_textbox_focused_border_color : 
                      (is_dragging ? style.drag_textbox_drag_color : style.drag_textbox_border_color);
    
    // Highlight drag zone on hover
    if (mouse_over_drag_zone && !is_focused && !is_dragging) {
        bg_color = make_color_rgb(60, 60, 60);
    }
    
    gmui_add_rect_round(textbox_x, textbox_y, textbox_width, textbox_height, bg_color, style.drag_textbox_rounding);
    
    // Draw border
    if (style.drag_textbox_border_size > 0) {
        gmui_add_rect_round_outline(textbox_x, textbox_y, textbox_width, textbox_height, 
                            border_color, style.drag_textbox_rounding, style.drag_textbox_border_size);
    }
    
    // Draw drag zone indicator (vertical line or dots)
    if (!is_focused) {
        var indicator_x = drag_hotzone_x;
        var indicator_color = is_dragging ? style.drag_textbox_drag_color : 
                             (mouse_over_drag_zone ? make_color_rgb(150, 150, 150) : make_color_rgb(100, 100, 100));
        
        // Draw vertical line
        gmui_add_line(indicator_x, textbox_y + 4, indicator_x, textbox_y + textbox_height - 4, 
                     indicator_color, 1);
        
        // Draw dots to indicate drag area
        var dot_spacing = 3;
        var dot_y = textbox_y + (textbox_height / 2) - 3;
        for (var i = 0; i < 3; i++) {
            gmui_add_rect(indicator_x + 2, dot_y + i * dot_spacing, 1, 1, indicator_color);
        }
    }
    
    // Create a surface for text clipping
    var text_surface = -1;
    var text_area_width = textbox_width - style.drag_textbox_padding[0] * 2 - style.drag_textbox_drag_hotzone_width;
	var surface = undefined;
    
    if (surface_exists(window.surface)) {
		surface = gmui_cache_surface_get(drag_textbox_id, text_area_width, text_size[1]);
        //text_surface = surface_create(text_area_width, text_size[1]);
        if (surface_exists(surface.surface)) {
            surface_set_target(surface.surface);
            draw_clear_alpha(c_black, 0);
            var oldBlendMode = gpu_get_blendmode();
            gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_one, bm_inv_src_alpha);
            
            draw_set_color(style.drag_textbox_bg_color);
            draw_rectangle(0, 0, textbox_width, textbox_height, false);
            
            var old_font = draw_get_font();
            draw_set_font(global.gmui.font);
            
            // Draw text or placeholder
            if (value_string == "" && placeholder != "" && !is_focused) {
                draw_set_color(style.drag_textbox_placeholder_color);
                draw_text(0, 0, placeholder);
            } else if (value_string != "" || is_focused) {
                // Handle text display with cursor and selection
                var display_text = is_focused ? global.gmui.active_textbox.text : value_string;
                
                // Draw selection if any
                if (is_focused && global.gmui.active_textbox.selection_length > 0) {
                    var sel_start = global.gmui.active_textbox.selection_start;
                    var sel_length = global.gmui.active_textbox.selection_length;
                    
                    var prefix_text = string_copy(display_text, 1, sel_start);
                    var selected_text = string_copy(display_text, sel_start + 1, sel_length);
                    
                    var prefix_width = string_width(prefix_text);
                    var selected_width = string_width(selected_text);
                    
                    draw_set_color(style.drag_textbox_selection_color);
                    //draw_rectangle(prefix_width, 0, prefix_width + selected_width, text_size[1], false);
                    draw_roundrect_ext(prefix_width, 0, prefix_width + selected_width, text_size[1] - 1, style.drag_textbox_rounding, style.drag_textbox_rounding, false);
                }
                
                // Draw text
                draw_set_color(style.drag_textbox_text_color);
                draw_text(0, 0, display_text);
                
                // Draw cursor if focused
                if (is_focused && global.gmui.textbox_cursor_visible) {
                    var cursor_prefix = string_copy(display_text, 1, global.gmui.active_textbox.cursor_pos);
                    var cursor_x = string_width(cursor_prefix);
                    
                    draw_set_color(style.drag_textbox_cursor_color);
                    draw_set_alpha((sin(current_time / 200) * 0.5 + 0.5) * 0.3 + 0.7);
                    draw_line_width(cursor_x, 0, cursor_x, text_size[1], style.drag_textbox_cursor_width);
                    draw_set_alpha(1);
                }
            }
            
            gpu_set_blendmode(oldBlendMode);
            draw_set_font(old_font);
            surface_reset_target();
        }
    }
    
    // Draw the text surface
    if (surface_exists(surface.surface)) {
        array_push(window.draw_list, {
            type: "surface_o",
            surface: surface.surface,
            x: textbox_x + style.drag_textbox_padding[0],
            y: textbox_y + style.drag_textbox_padding[1]
        });
    }
    
    // Update cursor position
    dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x += textbox_width + style.item_spacing[0];
    dc.line_height = max(dc.line_height, textbox_height);
    
    gmui_new_line();
    
    return value;
}

function gmui_input_int(value, step = 1, min_value = -1000000, max_value = 1000000, width = -1, placeholder = "") {
    if (!global.gmui.initialized || !global.gmui.current_window) return value;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
    
    // Calculate textbox size
    var text_size = gmui_calc_text_size("0");
    var textbox_height = text_size[1] + style.drag_textbox_padding[1] * 2;
    var textbox_width = (width > 0) ? width : 120;
    
    //if (dc.cursor_x + textbox_width > window.width - style.window_padding[0] && dc.cursor_x > dc.cursor_start_x) {
    //    gmui_new_line();
    //}
    
    var textbox_x = dc.cursor_x;
    var textbox_y = dc.cursor_y;
    var textbox_bounds = [textbox_x, textbox_y, textbox_x + textbox_width, textbox_y + textbox_height];
    
    var drag_hotzone_x = textbox_x + textbox_width - style.drag_textbox_drag_hotzone_width;
    var drag_hotzone_bounds = [drag_hotzone_x, textbox_y, textbox_x + textbox_width, textbox_y + textbox_height];
    
    var drag_textbox_id = "drag_int_" + string(window.x) + "_" + string(window.y) + "_" + string(dc.cursor_x) + "_" + string(dc.cursor_y);
    global.gmui.drag_textbox_id = drag_textbox_id;
    
    var value_string = string(floor(value)); // Ensure integer
    
    var mouse_over = gmui_is_mouse_over_window(window) && 
                     gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, 
                                         global.gmui.mouse_pos[1] - window.y, 
                                         textbox_bounds) && !global.gmui.is_hovering_element;

    var mouse_over_drag_zone = gmui_is_mouse_over_window(window) && 
                               gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, 
                                                   global.gmui.mouse_pos[1] - window.y, 
                                                   drag_hotzone_bounds) && !global.gmui.is_hovering_element;

    var clicked = false;
    var is_focused = (global.gmui.active_textbox != undefined && global.gmui.active_textbox.id == drag_textbox_id);
    var is_dragging = (global.gmui.active_drag_textbox == drag_textbox_id);
    var value_changed = false;

    if (mouse_over && window.active) {
        global.gmui.is_hovering_element = true;
        
        if (global.gmui.mouse_clicked[0]) {
            clicked = true;
            
            if (mouse_over_drag_zone) {
                global.gmui.active_drag_textbox = drag_textbox_id;
                global.gmui.drag_textbox_start_value = value;
                global.gmui.drag_textbox_start_mouse_x = global.gmui.mouse_pos[0];
                is_dragging = true;
                
                if (is_focused) {
                    global.gmui.active_textbox = undefined;
                    is_focused = false;
                }
            } else {
                global.gmui.active_textbox = {
                    id: drag_textbox_id,
                    text: value_string,
                    cursor_pos: string_length(value_string),
                    selection_start: 0,
                    selection_length: 0,
                    changed: false,
                    drag_start_pos: 0,
                    is_digit_only: true,
                    is_integer_only: true // Additional flag for integer-only
                };
                is_focused = true;
                
                var click_x = global.gmui.mouse_pos[0] - window.x - (textbox_x + style.drag_textbox_padding[0]);
                textbox_set_cursor_from_click(global.gmui.active_textbox, click_x);
                
                global.gmui.active_textbox.selection_start = global.gmui.active_textbox.cursor_pos;
                global.gmui.active_textbox.selection_length = 0;
                global.gmui.active_textbox.drag_start_pos = global.gmui.active_textbox.cursor_pos;
            }
        }
        
        if (is_focused && global.gmui.mouse_down[0] && !mouse_over_drag_zone) {
            var drag_x = global.gmui.mouse_pos[0] - window.x - (textbox_x + style.drag_textbox_padding[0]);
            
            if (global.gmui.mouse_down[0] && !global.gmui.mouse_clicked[0]) {
                textbox_handle_mouse_drag(global.gmui.active_textbox, drag_x);
            }
        }
    }

    if (global.gmui.mouse_clicked[0] && !mouse_over && is_focused) {
        global.gmui.active_textbox = undefined;
        is_focused = false;
    }
    
    if (is_dragging && global.gmui.mouse_down[0]) {
        var mouse_delta_x = global.gmui.mouse_pos[0] - global.gmui.drag_textbox_start_mouse_x;
        var value_delta = round(mouse_delta_x * style.drag_textbox_drag_sensitivity * step);
        
        var new_value = global.gmui.drag_textbox_start_value + value_delta;
        new_value = clamp(new_value, min_value, max_value);
        
        if (new_value != value) {
            value = new_value;
            value_string = string(value);
            value_changed = true;
        }
        
        window_set_cursor(cr_size_we);
    } else if (is_dragging && global.gmui.mouse_released[0]) {
        global.gmui.active_drag_textbox = undefined;
        is_dragging = false;
    }
    
    if (is_focused) {
        if (global.gmui.active_textbox.changed) {
            // Filter to only allow digits and minus sign (no decimals for integers)
            var filtered_text = "";
            var has_minus = false;
            
            for (var i = 1; i <= string_length(global.gmui.active_textbox.text); i++) {
                var char = string_char_at(global.gmui.active_textbox.text, i);
                var byte = string_byte_at(char, 1);
                
                if (byte >= 48 && byte <= 57) { // 0-9
                    filtered_text += char;
                } else if (char == "-" && !has_minus && i == 1) { // Minus sign only at start
                    filtered_text += char;
                    has_minus = true;
                }
            }
            
            global.gmui.active_textbox.text = filtered_text;
            global.gmui.active_textbox.changed = false;
            
            if (filtered_text != "" && filtered_text != "-") {
                var new_num = real(filtered_text);
                if (floor(new_num) != value) {
                    value = clamp(floor(new_num), min_value, max_value);
                    value_string = string(value);
                    value_changed = true;
                }
            }
        }
    }
    
    var bg_color = style.drag_textbox_bg_color;
    var border_color = is_focused ? style.drag_textbox_focused_border_color : 
                      (is_dragging ? style.drag_textbox_drag_color : style.drag_textbox_border_color);
    
    if (mouse_over_drag_zone && !is_focused && !is_dragging) {
        bg_color = make_color_rgb(60, 60, 60);
    }
    
    gmui_add_rect_round(textbox_x, textbox_y, textbox_width, textbox_height, bg_color, style.drag_textbox_rounding);
    
    if (style.drag_textbox_border_size > 0) {
        gmui_add_rect_round_outline(textbox_x, textbox_y, textbox_width, textbox_height, 
                            border_color, style.drag_textbox_rounding, style.drag_textbox_border_size);
    }
    
    if (!is_focused) {
        var indicator_x = drag_hotzone_x;
        var indicator_color = is_dragging ? style.drag_textbox_drag_color : 
                             (mouse_over_drag_zone ? make_color_rgb(150, 150, 150) : make_color_rgb(100, 100, 100));
        
        gmui_add_line(indicator_x, textbox_y + 4, indicator_x, textbox_y + textbox_height - 4, 
                     indicator_color, 1);
        
        var dot_spacing = 3;
        var dot_y = textbox_y + (textbox_height / 2) - 3;
        for (var i = 0; i < 3; i++) {
            gmui_add_rect(indicator_x + 2, dot_y + i * dot_spacing, 1, 1, indicator_color);
        }
    }
    
    var text_surface = -1;
    var text_area_width = textbox_width - style.drag_textbox_padding[0] * 2 - style.drag_textbox_drag_hotzone_width;
	var surface = undefined;
    
    if (surface_exists(window.surface)) {
		surface = gmui_cache_surface_get(drag_textbox_id, text_area_width, text_size[1]);
        //text_surface = surface_create(text_area_width, text_size[1]);
        if (surface_exists(surface.surface)) {
            surface_set_target(surface.surface);
            draw_clear_alpha(c_black, 0);
            var oldBlendMode = gpu_get_blendmode();
            gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_one, bm_inv_src_alpha);
            
            draw_set_color(style.drag_textbox_bg_color);
            draw_rectangle(0, 0, textbox_width, textbox_height, false);
            
            var old_font = draw_get_font();
            draw_set_font(global.gmui.font);
            
            if (value_string == "" && placeholder != "" && !is_focused) {
                draw_set_color(style.drag_textbox_placeholder_color);
                draw_text(0, 0, placeholder);
            } else if (value_string != "" || is_focused) {
                var display_text = is_focused ? global.gmui.active_textbox.text : value_string;
                
                if (is_focused && global.gmui.active_textbox.selection_length > 0) {
                    var sel_start = global.gmui.active_textbox.selection_start;
                    var sel_length = global.gmui.active_textbox.selection_length;
                    
                    var prefix_text = string_copy(display_text, 1, sel_start);
                    var selected_text = string_copy(display_text, sel_start + 1, sel_length);
                    
                    var prefix_width = string_width(prefix_text);
                    var selected_width = string_width(selected_text);
                    
                    draw_set_color(style.drag_textbox_selection_color);
                    //draw_rectangle(prefix_width, 0, prefix_width + selected_width, text_size[1], false);
                    draw_roundrect_ext(prefix_width, 0, prefix_width + selected_width, text_size[1] - 1, style.drag_textbox_rounding, style.drag_textbox_rounding, false);
                }
                
                draw_set_color(style.drag_textbox_text_color);
                draw_text(0, 0, display_text);
                
                if (is_focused && global.gmui.textbox_cursor_visible) {
                    var cursor_prefix = string_copy(display_text, 1, global.gmui.active_textbox.cursor_pos);
                    var cursor_x = string_width(cursor_prefix);
                    
                    draw_set_color(style.drag_textbox_cursor_color);
                    draw_set_alpha((sin(current_time / 200) * 0.5 + 0.5) * 0.3 + 0.7);
                    draw_line_width(cursor_x, 0, cursor_x, text_size[1], style.drag_textbox_cursor_width);
                    draw_set_alpha(1);
                }
            }
            
            gpu_set_blendmode(oldBlendMode);
            draw_set_font(old_font);
            surface_reset_target();
        }
    }
    
    if (surface_exists(surface.surface)) {
        array_push(window.draw_list, {
            type: "surface_o",
            surface: surface.surface,
            x: textbox_x + style.drag_textbox_padding[0],
            y: textbox_y + style.drag_textbox_padding[1]
        });
    }
    
    dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x += textbox_width + style.item_spacing[0];
    dc.line_height = max(dc.line_height, textbox_height);
    
    gmui_new_line();
    
    return value;
}

function gmui_combo(label, current_index, items, items_count = -1, width = -1, placeholder = "") {
    if (!global.gmui.initialized || !global.gmui.current_window) return current_index;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
	var element_id = "id_combo_" + label + "_" + string(dc.cursor_x) + "_" + string(dc.cursor_y);
    
    // Use array length if items_count not specified
    if (items_count == -1) {
        items_count = array_length(items);
    }
    
    // Calculate combo box size
    var text_size = gmui_calc_text_size("W"); // Reference height
    var combo_height = style.combo_height;
    var combo_width = (width > 0) ? width : 200; // Default width
    
    // Calculate total width needed (label + combo)
    var label_size = gmui_calc_text_size(label + ": ");
    var total_width = label_size[0] + combo_width + style.item_spacing[0];
    
    // Check if combo fits on current line
    //if (dc.cursor_x + total_width > window.width - style.window_padding[0] && dc.cursor_x > dc.cursor_start_x) {
    //    gmui_new_line();
    //}
    
    // Draw label if provided
    var combo_x = dc.cursor_x;
    if (label != "" && string_copy(label, 1, 2) != "##") {
        gmui_add_text(combo_x, dc.cursor_y + (combo_height - label_size[1]) / 2, label, style.text_color);
        combo_x += label_size[0];
    }
    
    // Calculate combo bounds
    var combo_y = dc.cursor_y;
    var combo_bounds = [combo_x, combo_y, combo_x + combo_width, combo_y + combo_height];
    
    // Create unique ID for this combo
    var combo_id = "combo_" + string(window.x) + "_" + string(window.y) + "_" + string(dc.cursor_x) + "_" + string(dc.cursor_y);
    
    // Check if this combo is active (dropdown open)
    var is_active = (window.active_combo == combo_id);
    
    // Check for mouse interaction
    var mouse_over = gmui_is_mouse_over_window(window) && 
                     gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, 
                                         global.gmui.mouse_pos[1] - window.y, 
                                         combo_bounds) && !global.gmui.is_hovering_element;
    
    var clicked = false;
    var is_pressed = false;
    
    if (mouse_over && window.active) {
        global.gmui.is_hovering_element = true;
        if (global.gmui.mouse_clicked[0]) {
            global.gmui.last_pressed_clickable_id = element_id;
        }
        if (global.gmui.mouse_down[0] && global.gmui.last_pressed_clickable_id == element_id) {
            is_pressed = true;
        }
        if (global.gmui.mouse_released[0] && global.gmui.last_pressed_clickable_id == element_id) {
            clicked = true;
			// Open dropdown
			if (window.active_combo != combo_id) {
                window.active_combo = combo_id;
                window.combo_items = items;
                window.combo_items_count = items_count;
                window.combo_current_index = current_index;
                window.combo_width = combo_width;
				window.combo_x = combo_x;
				window.combo_y = combo_y;
				window.combo_height = combo_height;
			};
            // Toggle dropdown
            //if (is_active) {
            //    window.active_combo = undefined;
            //} else {
            //    window.active_combo = combo_id;
            //    // Store combo state for dropdown
            //    window.combo_items = items;
            //    window.combo_items_count = items_count;
            //    window.combo_current_index = current_index;
            //    window.combo_width = combo_width;
            //}
        }
    }
    
    // Close dropdown if clicked outside
    //if (is_active && global.gmui.mouse_clicked[0] && !mouse_over) {
    //    // Check if click is outside the dropdown too
    //    var dropdown_height = min(style.combo_dropdown_max_height, items_count * style.combo_item_height);
    //    var dropdown_bounds = [combo_x, combo_y + combo_height, combo_x + combo_width, combo_y + combo_height + dropdown_height];
    //    var mouse_in_dropdown = gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, 
    //                                                global.gmui.mouse_pos[1] - window.y, 
    //                                                dropdown_bounds);
    //    
    //    if (!mouse_in_dropdown) {
    //        window.active_combo = undefined;
    //    }
    //}
    
    // Draw combo box background
    var bg_color = style.combo_bg_color;
    var border_color = style.combo_border_color;
    
    if (!window.active) {
        bg_color = make_color_rgb(30, 30, 30);
        border_color = make_color_rgb(60, 60, 60);
    } else if (is_pressed) {
        bg_color = style.combo_active_bg_color;
        border_color = style.combo_active_border_color;
    } else if (mouse_over || is_active) {
        bg_color = style.combo_hover_bg_color;
        border_color = style.combo_hover_border_color;
    }
    
    gmui_add_rect_round(combo_x, combo_y, combo_width, combo_height, bg_color, style.combo_rounding);
    
    // Draw border
    if (style.combo_border_size > 0) {
        gmui_add_rect_round_outline(combo_x, combo_y, combo_width, combo_height, border_color, style.combo_rounding, style.combo_border_size);
    }
    
    // Draw current selection text
    var display_text = placeholder;
    var text_color = style.combo_placeholder_color;
    
    if (current_index >= 0 && current_index < items_count) {
        display_text = items[current_index];
        text_color = style.combo_text_color;
    }
    
    var text_padding = style.combo_padding[0];
    var text_x = combo_x + text_padding;
    var text_y = combo_y + (combo_height - text_size[1]) / 2;
    
    // Clip text if too long
    var available_width = combo_width - text_padding * 2 - style.combo_arrow_size - 8;
    var display_text_trimmed = display_text;
    if (string_width(display_text) > available_width) {
        // Find how many characters fit
        for (var len = string_length(display_text); len > 0; len--) {
            var test_text = string_copy(display_text, 1, len) + "...";
            if (string_width(test_text) <= available_width) {
                display_text_trimmed = test_text;
                break;
            }
        }
    }
    
    gmui_add_text(text_x, text_y, display_text_trimmed, text_color);
    
    // Draw dropdown arrow
    var arrow_x = combo_x + combo_width - style.combo_arrow_size - 8;
    var arrow_y = combo_y + (combo_height - style.combo_arrow_size) / 2;
    
    var arrow_color = style.combo_arrow_color;
    if (mouse_over && window.active) {
        arrow_color = style.combo_arrow_hover_color;
    }
    
    // Draw arrow (triangle pointing down)
    var arrow_points = [
        [arrow_x, arrow_y],
        [arrow_x + style.combo_arrow_size, arrow_y],
        [arrow_x + style.combo_arrow_size / 2, arrow_y + style.combo_arrow_size]
    ];
    
    gmui_add_triangle(arrow_points[0][0], arrow_points[0][1],
                     arrow_points[1][0], arrow_points[1][1],
                     arrow_points[2][0], arrow_points[2][1],
                     arrow_color);
    
    // Draw dropdown if active
    //if (is_active && items_count > 0) {
    //    gmui_draw_combo_dropdown(window, combo_id, combo_x, combo_y + combo_height, combo_width);
    //    
    //    // Update current_index if selection changed in dropdown
    //    if (window.combo_current_index != current_index) {
    //        current_index = window.combo_current_index;
    //    }
    //}
	
	if (window.combo_current_index != -1) {
		current_index = window.combo_current_index;
		window.combo_current_index = -1;
	};
    
    // Update cursor position
    dc.cursor_previous_x = dc.cursor_x;
    if (label != "") {
        dc.cursor_x += total_width + style.item_spacing[0];
    } else {
        dc.cursor_x += combo_width + style.item_spacing[0];
    }
    dc.line_height = max(dc.line_height, combo_height);
    
    gmui_new_line();
    
    return current_index;
}

function gmui_combo_dropdown() {
	var window = global.gmui.current_window;
	var combo_id = window.active_combo;
	var cx = 0;
	var cy = 0;
	var width = window.combo_width;
	
    var style = global.gmui.style;
    var items = window.combo_items;
    var items_count = window.combo_items_count;
    
    // Calculate dropdown height
    var max_height = style.combo_dropdown_max_height;
    var item_height = style.combo_item_height;
    var dropdown_height = min(max_height, items_count * item_height);
    
    // Adjust position if dropdown would go off screen
    var screen_height = window_get_height();
    if (cy + dropdown_height > screen_height) {
        cy = max(0, cy - dropdown_height - style.combo_height);
    }
    
    var dropdown_bounds = [cx, cy, cx + width, cy + dropdown_height];
    
    // Draw dropdown background
    gmui_add_rect_round(cx, cy, width - 1, dropdown_height - 1, style.combo_dropdown_bg_color, style.combo_dropdown_rounding);
    
    // Draw border
    if (style.combo_border_size > 0) {
        gmui_add_rect_round_outline(cx, cy, width - 2, dropdown_height - 2, style.combo_dropdown_border_color, style.combo_dropdown_rounding, style.combo_border_size);
    }
    
    // Draw items
    var mouse_over_dropdown = gmui_is_mouse_over_window(window) && 
                              gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, 
                                                  global.gmui.mouse_pos[1] - window.y, 
                                                  dropdown_bounds);
    
	if (global.gmui.mouse_clicked[0] && !mouse_over_dropdown) {
		window.active_combo = undefined;
		global.gmui.to_delete_combo = true;
	}
	
    for (var i = 0; i < items_count; i++) {
        var item_y = cy + i * item_height;
        var item_bounds = [cx, item_y, cx + width, item_y + item_height];
        
        var item_mouse_over = mouse_over_dropdown && 
                              gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, 
                                                  global.gmui.mouse_pos[1] - window.y, 
                                                  item_bounds);
        
        var bg_color = style.combo_item_bg_color;
        var text_color = style.combo_item_text_color;
        
        if (i == window.combo_current_index) {
            bg_color = style.combo_item_selected_bg_color;
            text_color = style.combo_item_selected_text_color;
        } else if (item_mouse_over) {
            bg_color = style.combo_item_hover_bg_color;
        }
        
        // Draw item background
        gmui_add_rect(cx, item_y, width, item_height, bg_color);
        
        // Draw item text
        var text_size = gmui_calc_text_size(items[i]);
        var text_x = cx + style.combo_padding[0];
        var text_y = item_y + (item_height - text_size[1]) / 2;
        
        // Clip text if too long
        var available_width = width - style.combo_padding[0] * 2;
        var display_text = items[i];
        if (string_width(display_text) > available_width) {
            for (var len = string_length(display_text); len > 0; len--) {
                var test_text = string_copy(display_text, 1, len) + "...";
                if (string_width(test_text) <= available_width) {
                    display_text = test_text;
                    break;
                }
            }
        }
        
        gmui_add_text(text_x, text_y, display_text, text_color);
        
        // Handle item selection
        if (item_mouse_over && global.gmui.mouse_clicked[0]) {
            window.combo_current_index = i;
            window.active_combo = undefined; // Close dropdown
			global.gmui.to_delete_combo = true;
        }
    }
}

function gmui_combo_simple(label, current_index, items, width = -1) {
    return gmui_combo(label, current_index, items, -1, width, "Select...");
}

function gmui_combo_no_label(current_index, items, width = -1, placeholder = "") {
    return gmui_combo("", current_index, items, -1, width, placeholder);
}

/************************************
 * DATA TABLES
 ***********************************/

function gmui_begin_table(name, columns, column_count, width = -1, height = -1, flags = 0) { // TODO: if not given, calculate the background height automaticly
    if (!global.gmui.initialized || !global.gmui.current_window) return undefined;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
    
    // Get or create table context
    var table_id = window.name + "_" + name;
    var table_context = undefined;
    
    if (ds_map_exists(global.gmui.tables, table_id)) {
        table_context = global.gmui.tables[? table_id];
        // Update position/size if needed
        table_context.x = dc.cursor_x;
        table_context.y = dc.cursor_y;
        if (width > 0) table_context.width = width;
        if (height > 0) table_context.height = height;
        table_context.flags = flags; // Update flags if changed
		
		// update styles
		table_context.row_height = style.table_row_height;
		table_context.header_height = style.table_header_height;
    } else {
        // Calculate table size
        var table_width = (width > 0) ? width : window.width - style.window_padding[0] * 2;
        var table_height = (height > 0) ? height : 10; // 200
        
        table_context = {
            id: table_id,
            name: name,
            x: dc.cursor_x,
            y: dc.cursor_y,
            width: table_width,
            height: table_height,
            columns: columns,
            column_count: column_count,
            row_height: style.table_row_height,
            header_height: style.table_header_height,
            scroll_y: 0,
            visible_rows: 0,
            selected_row: -1,
            sort_column: -1,
            sort_ascending: true,
            flags: flags,
            column_widths: undefined, // For future resizable columns
            hovered_row: -1,
			row_count: 0,
        };
        
        ds_map_add(global.gmui.tables, table_id, table_context);
    }
    
    // Check if table fits on current line
    if (dc.cursor_x + table_context.width > window.width - style.window_padding[0] && dc.cursor_x > dc.cursor_start_x) {
        gmui_new_line();
        table_context.x = dc.cursor_x;
        table_context.y = dc.cursor_y;
    }
    
    // Draw table background
    gmui_add_rect(table_context.x, table_context.y, table_context.width, table_context.height, style.table_bg_color);
    
    // Draw table border
    if (style.table_border_size > 0) {
        gmui_add_rect_outline(table_context.x, table_context.y, table_context.width, table_context.height, 
                            style.table_border_color, style.table_border_size);
    }
    
    // Draw header
    gmui_draw_table_header(table_context);
    
    // Update cursor position for content area
    dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x = table_context.x;
    dc.cursor_y = table_context.y + table_context.header_height;
    dc.line_height = max(dc.line_height, table_context.height);
    
    // Store table context in window for use in gmui_table_row
    window.current_table = table_context;
    
    // Setup scissor for table content
    //var content_height = table_context.height - table_context.header_height;
    //gmui_begin_scissor(table_context.x, table_context.y + table_context.header_height, table_context.width, content_height); // calculate if it's top goes above title bar's bottom, clip the scissor area
    
    return table_context;
}

function gmui_end_table() {
    if (!global.gmui.initialized || !global.gmui.current_window) return;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    
    if (window.current_table == undefined) return;
    
    var table = window.current_table;
    
    // End scissor
    //gmui_end_scissor();
    
    // Update cursor position after table
    dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x = table.x;
    dc.cursor_y = table.y + table.row_height + table.row_height * (table.row_count) + global.gmui.style.item_spacing[1];
    dc.line_height = 0;
	
	table.row_count = 0;
    
    // Clear current table (but keep the context in the global map)
    window.current_table = undefined;
    
    gmui_new_line();
}

function gmui_draw_table_header(table) {
    var style = global.gmui.style;
    
    // Draw header background
    gmui_add_rect(table.x, table.y, table.width, table.header_height, style.table_header_bg_color);
    
    // Draw header border
    if (style.table_border_size > 0) {
        gmui_add_rect_outline(table.x, table.y, table.width, table.header_height, 
                            style.table_header_border_color, style.table_border_size);
    }
    
    // Calculate column widths
    var column_width = table.width / table.column_count;
    
    // Draw column headers
    for (var i = 0; i < table.column_count; i++) {
        var col_x = table.x + i * column_width;
        var col_bounds = [col_x, table.y, col_x + column_width, table.y + table.header_height];
        
        // Check for header click (sorting) - only if sortable flag is set
        var mouse_over_header = gmui_is_mouse_over_window(global.gmui.current_window) && 
                               gmui_is_point_in_rect(global.gmui.mouse_pos[0] - global.gmui.current_window.x, 
                                                   global.gmui.mouse_pos[1] - global.gmui.current_window.y, 
                                                   col_bounds);
        
        var header_bg_color = style.table_header_bg_color;
        if (mouse_over_header && !global.gmui.is_hovering_element && (table.flags & style.table_flags.SORTABLE_HEADERS)) {
            global.gmui.is_hovering_element = true;
            header_bg_color = style.table_header_hover_bg_color;
            
            if (global.gmui.mouse_released[0]) {
                // Toggle sort
                if (table.sort_column == i) {
                    table.sort_ascending = !table.sort_ascending;
                } else {
                    table.sort_column = i;
                    table.sort_ascending = true;
                }
            }
        }
        
        // Draw header cell background
        gmui_add_rect(col_x, table.y, column_width, table.header_height, header_bg_color);
        
        // Draw column separator if bordered cells flag is set
        if (i > 0 && (table.flags & style.table_flags.BORDERED_CELLS)) {
            gmui_add_line(col_x, table.y, col_x, table.y + table.header_height, 
                         style.table_cell_border_color, 1);
        }
        
        // Draw column text
        var text = table.columns[i];
        var text_size = gmui_calc_text_size(text);
        var text_x = col_x + style.table_cell_padding[0];
        var text_y = table.y + (table.header_height - text_size[1]) / 2; // should also include style.table_cell_padding[0] in the future
        
        // Handle text alignment
        if (style.table_header_text_align == "center") {
            text_x = col_x + (column_width - text_size[0]) / 2;
        } else if (style.table_header_text_align == "right") {
            text_x = col_x + column_width - text_size[0] - style.table_cell_padding[0];
        }
        
        // Draw sort indicator
        if (table.sort_column == i && (table.flags & style.table_flags.SORTABLE_HEADERS)) {
            var sort_indicator = table.sort_ascending ? "" : ""; // TODO
            text += sort_indicator;
            text_size = gmui_calc_text_size(text);
            
            // Recalculate position with sort indicator
            if (style.table_header_text_align == "center") {
                text_x = col_x + (column_width - text_size[0]) / 2;
            } else if (style.table_header_text_align == "right") {
                text_x = col_x + column_width - text_size[0] - style.table_cell_padding[0];
            }
        }
        
        gmui_add_text(text_x, text_y, text, style.table_header_text_color);
    }
}

function gmui_table_row(row_data, row_index) {
    if (!global.gmui.initialized || !global.gmui.current_window) return -1;
    
    var window = global.gmui.current_window;
    if (window.current_table == undefined) return -1;
    
    var table = window.current_table;
    var dc = window.dc;
    var style = global.gmui.style;
    
    // Calculate row position (accounting for scroll)
    var row_y = dc.cursor_y + table.scroll_y;
    var visible_start = table.y + table.header_height;
    var visible_end = visible_start + (table.height - table.header_height);
    
    // Skip rendering if row is not visible
    if (row_y + table.row_height < visible_start || row_y > visible_end) {
        dc.cursor_previous_x = dc.cursor_x;
        dc.cursor_y += table.row_height;
        dc.line_height = max(dc.line_height, table.row_height);
        return -1;
    }
    
    var row_bounds = [table.x, row_y, table.x + table.width, row_y + table.row_height];
    var column_width = table.width / table.column_count;
    
    // Determine row background color
    var bg_color = style.table_row_bg_color;
    
    // Alternate row colors if flag is set
    if ((table.flags & style.table_flags.ALTERNATE_ROWS) && (row_index % 2 == 1)) {
        bg_color = style.table_alternate_row_bg_color;
    }
    
    // Check for row interaction
    var mouse_over_row = gmui_is_mouse_over_window(window) && 
                        gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, 
                                            global.gmui.mouse_pos[1] - window.y, 
                                            row_bounds) && !global.gmui.is_hovering_element;
    
    var clicked = false;
    
    if (mouse_over_row && window.active && (table.flags & style.table_flags.HOVERABLE_ROWS)) {
        global.gmui.is_hovering_element = true;
        table.hovered_row = row_index;
        
        // Use hover colors
        if ((table.flags & style.table_flags.ALTERNATE_ROWS) && (row_index % 2 == 1)) {
            bg_color = style.table_alternate_row_hover_bg_color;
        } else {
            bg_color = style.table_row_hover_bg_color;
        }
        
        if (global.gmui.mouse_released[0]) {
            clicked = true;
            table.selected_row = row_index;
        }
    } else if (mouse_over_row && !(table.flags & style.table_flags.HOVERABLE_ROWS)) {
        global.gmui.is_hovering_element = true;
        if (global.gmui.mouse_released[0]) {
            clicked = true;
            table.selected_row = row_index;
        }
    }
    
    // Selected row color
    if (table.selected_row == row_index) {
        bg_color = style.table_row_selected_bg_color;
    }
    
    // Draw row background
    gmui_add_rect(table.x, row_y, table.width, table.row_height, bg_color);
    
    // Draw row border
    if (style.table_border_size > 0) {
        gmui_add_rect_outline(table.x, row_y, table.width, table.row_height, 
                            style.table_row_border_color, style.table_border_size);
    }
    
    // Draw cell contents
    for (var i = 0; i < table.column_count; i++) {
        var cell_x = table.x + i * column_width;
        
        // Draw cell separator if bordered cells flag is set
        if (i > 0 && (table.flags & style.table_flags.BORDERED_CELLS)) {
            gmui_add_line(cell_x, row_y, cell_x, row_y + table.row_height, 
                         style.table_cell_border_color, 1);
        }
        
        // Draw cell text
        var cell_text = string(row_data[i]);
        var text_size = gmui_calc_text_size(cell_text);
        var text_x = cell_x + style.table_cell_padding[0];
        var text_y = row_y + (table.row_height - text_size[1]) / 2;
        
        // Clip text if too long
        var available_width = column_width - style.table_cell_padding[0] * 2;
        if (text_size[0] > available_width) {
            for (var len = string_length(cell_text); len > 0; len--) {
                var test_text = string_copy(cell_text, 1, len) + "...";
                if (string_width(test_text) <= available_width) {
                    cell_text = test_text;
                    break;
                }
            }
        }
        
        var text_color = (table.selected_row == row_index) ? 
                        style.table_row_selected_text_color : 
                        style.table_row_text_color;
        gmui_add_text(text_x, text_y, cell_text, text_color);
    }
	
	table.row_count++;
    
    // Update cursor position
    dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_y += table.row_height;
    dc.line_height = max(dc.line_height, table.row_height);
    table.visible_rows++;
    
    return clicked ? row_index : -1;
}

function gmui_table_set_scroll(table_context, scroll_y) {
    if (table_context == undefined) return;
    table_context.scroll_y = scroll_y;
}

function gmui_table_get_selected_row(table_context) {
    if (table_context == undefined) return -1;
    return table_context.selected_row;
}

function gmui_table_clear_selection(table_context) {
    if (table_context == undefined) return;
    table_context.selected_row = -1;
}

function gmui_table_cleanup() {
    if (global.gmui.initialized && ds_exists(global.gmui.tables, ds_type_map)) {
        ds_map_clear(global.gmui.tables);
    }
}

//////////////////////////////////////
// PLOTTING & CHARTS
//////////////////////////////////////

function gmui_plot_lines(label, values, count, width = -1, height = 120, show_points = true) {
    if (!global.gmui.initialized || !global.gmui.current_window) return false;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
    
    // Calculate plot size
    var plot_width = (width > 0) ? width : window.width - style.window_padding[0] * 2;
    var plot_height = height;
    
    // Check if plot fits on current line
    //if (dc.cursor_x + plot_width > window.width - style.window_padding[0] && dc.cursor_x > dc.cursor_start_x) {
    //    gmui_new_line();
    //}
    
    var plot_x = dc.cursor_x;
    var plot_y = dc.cursor_y;
    
    // Draw label if provided
    if (label != "") {
        gmui_text(label);
    }
    
    // Calculate data bounds
    var min_val = 0;
    var max_val = 0;
    if (count > 0) {
        min_val = values[0];
        max_val = values[0];
        for (var i = 1; i < count; i++) {
            min_val = min(min_val, values[i]);
            max_val = max(max_val, values[i]);
        }
    }
    
    // Add some padding to data range
    var range = max_val - min_val;
    if (range == 0) range = 1;
    min_val -= range * 0.1;
    max_val += range * 0.1;
    
    // Draw plot background and border
    gmui_add_rect(plot_x, plot_y, plot_width, plot_height, style.plot_bg_color);
    if (style.plot_border_size > 0) {
        gmui_add_rect_outline(plot_x, plot_y, plot_width, plot_height, 
                            style.plot_border_color, style.plot_border_size);
    }
    
    // Draw grid lines
    var grid_steps = style.plot_grid_steps;
    for (var i = 0; i <= grid_steps; i++) {
        var _y = plot_y + plot_height - (i * plot_height / grid_steps);
        var value = min_val + (i * (max_val - min_val) / grid_steps);
        
        // Grid line
        gmui_add_line(plot_x, _y, plot_x + plot_width, _y, 
                     style.plot_grid_color, style.plot_grid_thickness);
        
        // Value label
        //var value_text = string_format(value, 1, 2);
        //var text_size = gmui_calc_text_size(value_text);
        //gmui_add_text(plot_x - text_size[0] - 4, _y - text_size[1] / 2, 
        //             value_text, style.plot_text_color);
    }
    
    // Draw zero line if applicable
    if (min_val <= 0 && max_val >= 0) {
        var zero_y = plot_y + plot_height * (1 - (-min_val) / (max_val - min_val));
        gmui_add_line(plot_x, zero_y, plot_x + plot_width, zero_y, 
                     style.plot_grid_color, style.plot_grid_thickness);
    }
    
    // Draw data lines
    if (count > 1) {
        // Create line path
        var prev_x = 0;
        var prev_y = 0;
        
        for (var i = 0; i < count; i++) {
            var _x = plot_x + (i * plot_width / (count - 1));
            var _y = plot_y + plot_height * (1 - (values[i] - min_val) / (max_val - min_val));
            
            if (i > 0) {
                // Draw line between points
                gmui_add_line(prev_x, prev_y, _x, _y, 
                             style.plot_line_color, style.plot_line_thickness);
            }
            
            // Draw data points if enabled
            if (show_points) {
                gmui_add_rect_round(_x - style.plot_point_size/2, _y - style.plot_point_size/2, 
                                  style.plot_point_size, style.plot_point_size, 
                                  style.plot_point_color, style.plot_point_size/2);
            }
            
            prev_x = _x;
            prev_y = _y;
        }
        
        // Fill area under line if enabled
        if (style.plot_fill_enabled && count >= 2) {
            // Simple fill implementation
            var fill_points = [];
            // Start from bottom left
            array_push(fill_points, [plot_x, plot_y + plot_height]);
            // Add all data points
            for (var i = 0; i < count; i++) {
                var _x = plot_x + (i * plot_width / (count - 1));
                var _y = plot_y + plot_height * (1 - (values[i] - min_val) / (max_val - min_val));
                array_push(fill_points, [_x, _y]);
            }
            // End at bottom right
            array_push(fill_points, [plot_x + plot_width, plot_y + plot_height]);
            
            // Draw filled polygon (simplified as multiple triangles)
            for (var i = 1; i < array_length(fill_points) - 1; i++) {
                gmui_add_triangle(
                    fill_points[0][0], fill_points[0][1],
                    fill_points[i][0], fill_points[i][1],
                    fill_points[i + 1][0], fill_points[i + 1][1],
                    style.plot_fill_color
                );
            }
        }
    } else if (count == 1) {
        // Single point
        var _x = plot_x + plot_width / 2;
        var _y = plot_y + plot_height * (1 - (values[0] - min_val) / (max_val - min_val));
        gmui_add_rect_round(_x - style.plot_point_size/2, _y - style.plot_point_size/2, 
                          style.plot_point_size, style.plot_point_size, 
                          style.plot_point_color, style.plot_point_size/2);
    }
    
    // Update cursor position
    dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x += plot_width + style.item_spacing[0];
    dc.line_height = max(dc.line_height, plot_height + (label != "" ? string_height(label) : 0));
    
    gmui_new_line();
    
    return true;
}

function gmui_plot_bars(label, values, count, width = -1, height = 120) {
    if (!global.gmui.initialized || !global.gmui.current_window) return false;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
    
    // Calculate plot size
    var plot_width = (width > 0) ? width : window.width - style.window_padding[0] * 2;
    var plot_height = height;
    
    if (dc.cursor_x + plot_width > window.width - style.window_padding[0] && dc.cursor_x > dc.cursor_start_x) {
        gmui_new_line();
    }
    
    var plot_x = dc.cursor_x;
    var plot_y = dc.cursor_y;
    
    // Draw label if provided
    if (label != "") {
        gmui_text(label);
    }
    
    // Calculate data bounds
    var min_val = 0;
    var max_val = 0;
    if (count > 0) {
        min_val = values[0];
        max_val = values[0];
        for (var i = 1; i < count; i++) {
            min_val = min(min_val, values[i]);
            max_val = max(max_val, values[i]);
        }
    }
    
    // Ensure we have some range for display
    var range = max_val - min_val;
    if (range == 0) {
        range = 1;
        max_val = min_val + 1;
    }
    
    // Draw plot background and border
    gmui_add_rect(plot_x, plot_y, plot_width, plot_height, style.plot_bg_color);
    if (style.plot_border_size > 0) {
        gmui_add_rect_outline(plot_x, plot_y, plot_width, plot_height, 
                            style.plot_border_color, style.plot_border_size);
    }
    
    // Draw bars
    if (count > 0) {
        var bar_width = plot_width / count;
        var bar_spacing = max(1, bar_width * style.plot_bar_spacing_ratio);
        var actual_bar_width = bar_width - bar_spacing;
        
        for (var i = 0; i < count; i++) {
            var bar_x = plot_x + i * bar_width + bar_spacing / 2;
            var bar_height = plot_height * ((values[i] - min_val) / range);
            var bar_y = plot_y + plot_height - bar_height;
            
            // Choose color
            var bar_color = style.plot_bar_color;
            if (style.plot_bar_gradient) {
                var normalized_value = (values[i] - min_val) / range;
                bar_color = gmui_lerp_color(style.plot_bar_min_color, style.plot_bar_max_color, normalized_value);
            }
            
            // Draw bar
            gmui_add_rect_round(bar_x, bar_y, actual_bar_width, bar_height, 
                              bar_color, style.plot_bar_rounding);
            
            // Draw bar outline
            if (style.plot_bar_border_size > 0) {
                gmui_add_rect_round_outline(bar_x, bar_y, actual_bar_width, bar_height, 
                                          style.plot_bar_border_color, 
                                          style.plot_bar_rounding, 
                                          style.plot_bar_border_size);
            }
            
            // Draw value label on top of bar if there's space
            if (bar_height > 20) {
                var value_text = string_format(values[i], 1, 2);
                var text_size = gmui_calc_text_size(value_text);
                var text_x = bar_x + (actual_bar_width - text_size[0]) / 2;
                var text_y = bar_y + (bar_height - text_size[1]) / 2;
                gmui_add_text(text_x, text_y, value_text, make_color_rgb(255, 255, 255));
            }
        }
    }
    
    // Update cursor position
    dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x += plot_width + style.item_spacing[0];
    dc.line_height = max(dc.line_height, plot_height + (label != "" ? string_height(label) : 0));
    
    gmui_new_line();
    
    return true;
}

function gmui_plot_histogram(label, values, count, width = -1, height = 120, bins = 10) {
    if (!global.gmui.initialized || !global.gmui.current_window) return false;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
    
    // Calculate plot size
    var plot_width = (width > 0) ? width : window.width - style.window_padding[0] * 2;
    var plot_height = height;
    
    if (dc.cursor_x + plot_width > window.width - style.window_padding[0] && dc.cursor_x > dc.cursor_start_x) {
        gmui_new_line();
    }
    
    var plot_x = dc.cursor_x;
    var plot_y = dc.cursor_y;
    
    // Draw label if provided
    if (label != "") {
        gmui_text(label);
    }
    
    // Calculate histogram bins
    var min_val = 0;
    var max_val = 0;
    if (count > 0) {
        min_val = values[0];
        max_val = values[0];
        for (var i = 1; i < count; i++) {
            min_val = min(min_val, values[i]);
            max_val = max(max_val, values[i]);
        }
    }
    
    // Create bins
    var bin_counts = array_create(bins, 0);
    var bin_range = max_val - min_val;
    if (bin_range == 0) bin_range = 1;
    
    for (var i = 0; i < count; i++) {
        var bin_index = clamp(floor((values[i] - min_val) / bin_range * bins), 0, bins - 1);
        bin_counts[bin_index]++;
    }
    
    // Find max bin count for scaling
    var max_bin_count = 0;
    for (var i = 0; i < bins; i++) {
        max_bin_count = max(max_bin_count, bin_counts[i]);
    }
    if (max_bin_count == 0) max_bin_count = 1;
    
    // Draw plot background and border
    gmui_add_rect(plot_x, plot_y, plot_width, plot_height, style.plot_bg_color);
    gmui_add_rect_outline(plot_x, plot_y, plot_width, plot_height, style.border_color, 1);
    
    // Draw histogram bars
    var bar_width = plot_width / bins;
    var bar_spacing = max(1, bar_width * 0.1);
    var actual_bar_width = bar_width - bar_spacing;
    
    for (var i = 0; i < bins; i++) {
        var bar_x = plot_x + i * bar_width + bar_spacing / 2;
        var bar_height = plot_height * (bin_counts[i] / max_bin_count);
        var bar_y = plot_y + plot_height - bar_height;
        
        // Color based on frequency
        var normalized_freq = bin_counts[i] / max_bin_count;
        var bar_color = gmui_make_color_rgba(
            100 + normalized_freq * 155,
            200,
            100,
            255
        );
        
        // Draw bar
        gmui_add_rect(bar_x, bar_y, actual_bar_width, bar_height, bar_color);
        
        // Draw bar outline
        gmui_add_rect_outline(bar_x, bar_y, actual_bar_width, bar_height, 
                            style.plot_histogram_border_color, 1);
        
        // Draw bin range label if there's space
        if (bar_height > 25 && i % max(1, floor(bins / 5)) == 0) {
            var bin_start = min_val + (i * bin_range / bins);
            var bin_end = min_val + ((i + 1) * bin_range / bins);
            var range_text = string_format(bin_start, 1, 1);
            var text_size = gmui_calc_text_size(range_text);
            var text_x = bar_x + (actual_bar_width - text_size[0]) / 2;
            var text_y = plot_y + plot_height + 2;
            gmui_add_text(text_x, text_y, range_text, style.plot_text_color);
        }
    }
    
    // Draw frequency axis labels
    //for (var i = 0; i <= 5; i++) {
    //    var freq = (i * max_bin_count / 5);
    //    var _y = plot_y + plot_height - (i * plot_height / 5);
    //    var freq_text = string(floor(freq));
    //    var text_size = gmui_calc_text_size(freq_text);
    //    gmui_add_text(plot_x - text_size[0] - 4, _y - text_size[1] / 2, freq_text, style.plot_text_color);
    //}
    
    // Update cursor position
    dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x += plot_width + style.item_spacing[0];
    dc.line_height = max(dc.line_height, plot_height + (label != "" ? string_height(label) : 0) + 15);
    
    gmui_new_line();
    
    return true;
}

function gmui_plot_scatter(label, x_values, y_values, count, width = -1, height = 120) {
    if (!global.gmui.initialized || !global.gmui.current_window) return false;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
    
    // Calculate plot size
    var plot_width = (width > 0) ? width : window.width - style.window_padding[0] * 2;
    var plot_height = height;
    
    if (dc.cursor_x + plot_width > window.width - style.window_padding[0] && dc.cursor_x > dc.cursor_start_x) {
        gmui_new_line();
    }
    
    var plot_x = dc.cursor_x;
    var plot_y = dc.cursor_y;
    
    // Draw label if provided
    if (label != "") {
        gmui_text(label);
    }
    
    // Calculate data bounds
    var min_x = 0, max_x = 0, min_y = 0, max_y = 0;
    if (count > 0) {
        min_x = x_values[0]; max_x = x_values[0];
        min_y = y_values[0]; max_y = y_values[0];
        for (var i = 1; i < count; i++) {
            min_x = min(min_x, x_values[i]); max_x = max(max_x, x_values[i]);
            min_y = min(min_y, y_values[i]); max_y = max(max_y, y_values[i]);
        }
    }
    
    // Add padding to ranges
    var x_range = max_x - min_x; if (x_range == 0) x_range = 1;
    var y_range = max_y - min_y; if (y_range == 0) y_range = 1;
    min_x -= x_range * 0.05; max_x += x_range * 0.05;
    min_y -= y_range * 0.05; max_y += y_range * 0.05;
    
    // Draw plot background and border
    gmui_add_rect(plot_x, plot_y, plot_width, plot_height, style.plot_bg_color);
    gmui_add_rect_outline(plot_x, plot_y, plot_width, plot_height, style.border_color, 1);
    
    // Draw scatter points
    if (count > 0) {
        var point_color = style.plot_scatter_color;
        var point_size = style.plot_scatter_size;
        
        for (var i = 0; i < count; i++) {
            var _x = plot_x + ((x_values[i] - min_x) / (max_x - min_x)) * plot_width;
            var _y = plot_y + plot_height - ((y_values[i] - min_y) / (max_y - min_y)) * plot_height;
            
            // Draw point
            gmui_add_rect_round(_x - point_size/2, _y - point_size/2, point_size, point_size, 
                              point_color, point_size/2);
        }
    }
    
    // Update cursor position
    dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x += plot_width + style.item_spacing[0];
    dc.line_height = max(dc.line_height, plot_height + (label != "" ? string_height(label) : 0));
    
    gmui_new_line();
    
    return true;
}

/************************************
 * LAYOUT
 ***********************************/
//////////////////////////////////////
// LAYOUT (Cursor management, spacing, alignment)
//////////////////////////////////////
function gmui_same_line() {
    if (!global.gmui.initialized || !global.gmui.current_window) return;
    
    var dc = global.gmui.current_window.dc;
	dc.cursor_x = dc.cursor_previous_x;
	dc.cursor_y = dc.cursor_previous_y;
}

function gmui_new_line() {
    if (!global.gmui.initialized || !global.gmui.current_window) return;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    
    // Update max cursor position (accounting for scroll offset)
    window.max_cursor_x = max(window.max_cursor_x, dc.cursor_x - dc.scroll_offset_x);
    window.max_cursor_y = max(window.max_cursor_y, dc.cursor_y - dc.scroll_offset_y);
    
    dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_previous_y = dc.cursor_y;
    dc.cursor_x = dc.cursor_start_x + dc.scroll_offset_x;
    dc.cursor_y += dc.line_height + global.gmui.style.item_spacing[1];
    dc.line_height = 0;
}

function gmui_separator() {
    if (!global.gmui.initialized || !global.gmui.current_window) return;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    
    // Move to new line if not at start
    if (dc.cursor_x != dc.cursor_start_x) {
        //gmui_new_line();
    }
    
    var thickness = 1;
    var _y = dc.cursor_y + thickness;
    gmui_add_rect(dc.cursor_start_x, _y, window.width - global.gmui.style.window_padding[0] * 2, thickness, global.gmui.style.border_color);
    
	dc.cursor_previous_y = dc.cursor_y;
    dc.cursor_y += thickness + global.gmui.style.item_spacing[1];
    dc.line_height = 0;
	
	gmui_new_line();
}

function gmui_dummy(w, h) {
    if (!global.gmui.initialized || !global.gmui.current_window) return;
    
    var dc = global.gmui.current_window.dc;
	dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x += w;
    dc.line_height = max(dc.line_height, h);
	
	gmui_new_line();
}

function gmui_get_cursor() {
	if (global.gmui.current_window == undefined) { return; };
	return [ global.gmui.current_window.dc.cursor_x, global.gmui.current_window.dc.cursor_y ];
};

function gmui_set_cursor(x, y) {
	if (global.gmui.current_window == undefined) { return; };
	global.gmui.current_window.dc.cursor_previous_x = global.gmui.current_window.dc.cursor_x;
	global.gmui.current_window.dc.cursor_previous_y = global.gmui.current_window.dc.cursor_y;
	global.gmui.current_window.dc.cursor_x = x;
	global.gmui.current_window.dc.cursor_y = y;
};

function gmui_tab_width(width) {
	global.gmui.tab_width = width;
};

function gmui_tab(idx) {
	global.gmui.current_window.dc.cursor_x = global.gmui.style.window_padding[0] + global.gmui.tab_width * idx;
};

function gmui_calc_text_size(text) {
    return [string_width(text), string_height(text)];
}

//////////////////////////////////////
// SCROLL (Scrollbars, scrolling behavior)
//////////////////////////////////////
function gmui_handle_scrollbars(window) {
    var flags = window.flags;
    var style = global.gmui.style;
    
    // Check scrollbar conditions
    var has_vertical_scroll = (flags & gmui_window_flags.VERTICAL_SCROLL) != 0;
    var has_horizontal_scroll = (flags & gmui_window_flags.HORIZONTAL_SCROLL) != 0;
    var auto_scroll = (flags & gmui_window_flags.AUTO_SCROLL) != 0;
    var auto_vscroll = (flags & gmui_window_flags.AUTO_VSCROLL) != 0;
    var auto_hscroll = (flags & gmui_window_flags.AUTO_HSCROLL) != 0;
    var always_scrollbars = (flags & gmui_window_flags.ALWAYS_SCROLLBARS) != 0;
    var scroll_with_wheel = (flags & gmui_window_flags.SCROLL_WITH_MOUSE_WHEEL) != 0;
    
    var scrollbar_width = style.scrollbar_width;
    var content_area_width = window.width;
    var content_area_height = window.height - window.dc.title_bar_height;
    
    // Determine if scrollbars are needed
    var needs_vertical = has_vertical_scroll || (auto_scroll && window.content_height > content_area_height) || (auto_vscroll && window.content_height > content_area_height);
    var needs_horizontal = has_horizontal_scroll || (auto_scroll && window.content_width > content_area_width) || (auto_hscroll && window.content_width > content_area_width);
    
    var show_vertical = needs_vertical || (always_scrollbars && has_vertical_scroll);
    var show_horizontal = needs_horizontal || (always_scrollbars && has_horizontal_scroll);
    
    // Adjust content area for scrollbars
    content_area_width -= scrollbar_width;
	content_area_height -= scrollbar_width;
	//if (show_vertical) content_area_width -= scrollbar_width;
    //if (show_horizontal) content_area_height -= scrollbar_width;
    
    // Handle vertical scrollbar
    if (show_vertical) {
        gmui_draw_vertical_scrollbar(window, content_area_width, content_area_height);
    }
    
    // Handle horizontal scrollbar
    if (show_horizontal) {
        gmui_draw_horizontal_scrollbar(window, content_area_width, content_area_height);
    }
    
    // Handle mouse wheel scrolling
    if (scroll_with_wheel && gmui_is_mouse_over_window(window)) {
        var wheel_delta = mouse_wheel_down() - mouse_wheel_up();
        if (wheel_delta != 0) {
            window.scroll_y += wheel_delta * style.scroll_wheel_speed;
        }
    }
    
    // Clamp scroll positions
    var max_scroll_x = max(0, window.content_width - content_area_width);
    var max_scroll_y = max(0, window.content_height - content_area_height);
    
    window.scroll_x = clamp(window.scroll_x, 0, max_scroll_x);
    window.scroll_y = clamp(window.scroll_y, 0, max_scroll_y);
}

function gmui_draw_vertical_scrollbar(window, content_width, content_height) {
    var style = global.gmui.style;
    var scrollbar_width = style.scrollbar_width;
    
    // Calculate scrollbar position
    var scrollbar_x = (window.flags & gmui_window_flags.SCROLLBAR_LEFT) != 0 ? 0 : content_width;
    var scrollbar_y = window.dc.title_bar_height;
    var scrollbar_height = content_height;
    
    // Draw scrollbar background
    gmui_add_rect_round(scrollbar_x, scrollbar_y, scrollbar_width - 1, scrollbar_height, 
                 style.scrollbar_background_color, style.scrollbar_rounding);
    
    // Calculate anchor size and position
    var max_scroll = max(0, window.content_height - content_height);
    var viewport_ratio = content_height / window.content_height;
    var anchor_height = max(style.scrollbar_min_anchor_size, scrollbar_height * viewport_ratio);
    
    var scroll_percent = (max_scroll > 0) ? window.scroll_y / max_scroll : 0;
    var anchor_y = scrollbar_y + (scrollbar_height - anchor_height) * scroll_percent;
    
    var anchor_bounds = [scrollbar_x, anchor_y, scrollbar_x + scrollbar_width, anchor_y + anchor_height];
    
    // Handle interaction
    var mouse_over_anchor = gmui_is_scrollbar_interacting(window, anchor_bounds);
	
    // Handle dragging
    if (mouse_over_anchor && global.gmui.mouse_clicked[0]) {
        window.scrollbar_dragging = true;
        window.scrollbar_drag_axis = 0; // vertical
        window.scrollbar_drag_offset = (global.gmui.mouse_pos[1] - window.y) - anchor_y;
    }
    
    if (window.scrollbar_dragging && window.scrollbar_drag_axis == 0) {
        if (global.gmui.mouse_down[0]) {
            var mouse_y_in_scrollbar = (global.gmui.mouse_pos[1] - window.y) - window.scrollbar_drag_offset;
            var normalized_y = (mouse_y_in_scrollbar - scrollbar_y) / (scrollbar_height - anchor_height);
            window.scroll_y = normalized_y * max_scroll;
        } else {
            window.scrollbar_dragging = false;
        }
    }
    
    // Draw anchor
    var anchor_color = style.scrollbar_anchor_color;
    if (window.scrollbar_dragging && window.scrollbar_drag_axis == 0) {
        anchor_color = style.scrollbar_anchor_active_color;
    } else if (mouse_over_anchor) {
        anchor_color = style.scrollbar_anchor_hover_color;
    }
    
    gmui_add_rect_round(scrollbar_x, anchor_y, scrollbar_width - 1, anchor_height, anchor_color, style.scrollbar_rounding);
}

function gmui_draw_horizontal_scrollbar(window, content_width, content_height) {
    var style = global.gmui.style;
    var scrollbar_height = style.scrollbar_width;
    
    // Calculate scrollbar position
    var scrollbar_x = 0;
    var scrollbar_y = (window.flags & gmui_window_flags.SCROLLBAR_TOP) != 0 ? 
        window.dc.title_bar_height : window.height - scrollbar_height;
    
    var scrollbar_width = content_width;
    
    // Draw scrollbar background
    gmui_add_rect_round(scrollbar_x, scrollbar_y, scrollbar_width, scrollbar_height - 1, 
                 style.scrollbar_background_color, style.scrollbar_rounding);
    
    // Calculate anchor size and position
    var max_scroll = max(0, window.content_width - content_width);
    var viewport_ratio = content_width / window.content_width;
    var anchor_width = max(style.scrollbar_min_anchor_size, scrollbar_width * viewport_ratio);
    
    var scroll_percent = (max_scroll > 0) ? window.scroll_x / max_scroll : 0;
    var anchor_x = scrollbar_x + (scrollbar_width - anchor_width) * scroll_percent;
    
    var anchor_bounds = [anchor_x, scrollbar_y, anchor_x + anchor_width, scrollbar_y + scrollbar_height];
    
    // Handle interaction
    var mouse_over_anchor = gmui_is_scrollbar_interacting(window, anchor_bounds);
    
    // Handle dragging
    if (mouse_over_anchor && global.gmui.mouse_clicked[0]) {
        window.scrollbar_dragging = true;
        window.scrollbar_drag_axis = 1; // horizontal
        window.scrollbar_drag_offset = (global.gmui.mouse_pos[0] - window.x) - anchor_x;
    }
    
    if (window.scrollbar_dragging && window.scrollbar_drag_axis == 1) {
        if (global.gmui.mouse_down[0]) {
            var mouse_x_in_scrollbar = (global.gmui.mouse_pos[0] - window.x) - window.scrollbar_drag_offset;
            var normalized_x = (mouse_x_in_scrollbar - scrollbar_x) / (scrollbar_width - anchor_width);
            window.scroll_x = normalized_x * max_scroll;
        } else {
            window.scrollbar_dragging = false;
        }
    }
    
    // Draw anchor
    var anchor_color = style.scrollbar_anchor_color;
    if (window.scrollbar_dragging && window.scrollbar_drag_axis == 1) {
        anchor_color = style.scrollbar_anchor_active_color;
    } else if (mouse_over_anchor) {
        anchor_color = style.scrollbar_anchor_hover_color;
    }
    
    gmui_add_rect_round(anchor_x, scrollbar_y, anchor_width, scrollbar_height - 1, anchor_color, style.scrollbar_rounding);
}

function gmui_is_scrollbar_interacting(window, bounds) {
    return gmui_is_mouse_over_window(window) && 
           gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, 
                               global.gmui.mouse_pos[1] - window.y, 
                               bounds);
}

function gmui_set_scroll_position(window_name, scroll_x, scroll_y) {
    if (!global.gmui.initialized) return false;
    
    var window = gmui_get_window(window_name);
    if (!window) return false;
    
    window.scroll_x = scroll_x;
    window.scroll_y = scroll_y;
    
    return true;
}

function gmui_get_scroll_position(window_name) {
    if (!global.gmui.initialized) return undefined;
    
    var window = gmui_get_window(window_name);
    if (!window) return undefined;
    
    return [window.scroll_x, window.scroll_y];
}

function gmui_scroll_to_bottom(window_name) {
    if (!global.gmui.initialized) return false;
    
    var window = gmui_get_window(window_name);
    if (!window) return false;
    
    var content_area_height = window.height - window.dc.title_bar_height;
    if ((window.flags & gmui_window_flags.HORIZONTAL_SCROLL) != 0) {
        content_area_height -= global.gmui.style.scrollbar_width;
    }
    
    window.scroll_y = max(0, window.content_height - content_area_height);
    
    return true;
}

function gmui_scroll_to_top(window_name) {
    if (!global.gmui.initialized) return false;
    
    var window = gmui_get_window(window_name);
    if (!window) return false;
    
    window.scroll_y = 0;
    
    return true;
}

/************************************
 * UTILITIES
 ***********************************/
//////////////////////////////////////
// HELPERS (Utility functions, state management)
//////////////////////////////////////
function gmui_is_mouse_over_window(window) {
    var mx = global.gmui.mouse_pos[0];
    var my = global.gmui.mouse_pos[1];
    var result = ((mx >= window.x && mx <= window.x + window.width &&
            my >= window.y && my <= window.y + window.height)) && global.gmui.hovering_window == window;
	return result;
}

// Utility function: Check if point is in rectangle
function gmui_is_point_in_rect(point_x, point_y, rect) {
    return (point_x >= rect[0] && point_x <= rect[2] &&
            point_y >= rect[1] && point_y <= rect[3]);
}

// Draw title bar with close button
function gmui_draw_title_bar(window, title) {
    var style = global.gmui.style;
    var flags = window.flags;
    
    // Title bar background
    var title_bar_color = style.title_bar_color;
    if (window.title_bar_hovered) title_bar_color = style.title_bar_hover_color;
    if (window.title_bar_active) title_bar_color = style.title_bar_active_color;
    
    gmui_add_rect(0, 0, window.width, style.title_bar_height, title_bar_color);
    
    // Title text
    var text_size = gmui_calc_text_size(title);
    var text_x = style.title_padding[0];
    var text_y = (style.title_bar_height - text_size[1]) / 2;
    
    // Handle text alignment
    if (style.title_text_align == "center") {
        text_x = (window.width - text_size[0]) / 2;
    } else if (style.title_text_align == "right") {
        text_x = window.width - text_size[0] - style.title_padding[0];
    }
    
    gmui_add_text(text_x, text_y, title, style.title_text_color);
    
    // Close button if not disabled
    var has_close_button = (flags & gmui_window_flags.NO_CLOSE) == 0;
    if (has_close_button) {
        gmui_draw_title_bar_close_button(window);
    }
	
	// Resize
	var can_resize = (flags & gmui_window_flags.NO_RESIZE) == 0;
	if (can_resize) {
		gmui_draw_window_resize(window);
	}
}

// Draw resize triangle
function gmui_draw_window_resize(window) {
	var origin_x = window.width;
	var origin_y = window.height;
	var size = 16;
	var col = global.gmui.style.border_color;
	var thickness = 4;
	
	gmui_add_line(origin_x, origin_y, origin_x, origin_y - size, col, thickness);
	gmui_add_line(origin_x, origin_y, origin_x - size, origin_y, col, thickness);
	gmui_add_line(origin_x - size, origin_y, origin_x, origin_y - size, col, thickness);
}

// Draw close button in title bar
function gmui_draw_title_bar_close_button(window) {
    var style = global.gmui.style;
    var close_size = style.close_button_size;
    var close_padding = 4;
	var element_id = "id_windowclosebutton_" + window.name + "_" + string(window.width) + "_" + string(window.height);
    
    var close_x = window.width - close_size - close_padding;
    var close_y = (style.title_bar_height - close_size) / 2;
    var close_bounds = [close_x, close_y, close_x + close_size, close_y + close_size];
    
    // Check close button interaction
    var mouse_over_close = gmui_is_mouse_over_window(window) && 
                          gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, 
                                              global.gmui.mouse_pos[1] - window.y, close_bounds) && !global.gmui.is_hovering_element;
    
    var close_color = style.close_button_color;
    if (mouse_over_close) {
		global.gmui.is_hovering_element = true;
		
        // Close window on click
        if (global.gmui.mouse_clicked[0]) {
            global.gmui.last_pressed_clickable_id = element_id;
        }
        if (global.gmui.mouse_down[0] && global.gmui.last_pressed_clickable_id == element_id) {
            close_color = style.close_button_active_color;
        } else {
            close_color = style.close_button_hover_color;
        }
        if (global.gmui.mouse_released[0] && global.gmui.last_pressed_clickable_id == element_id) {
            window.open = false;
        }
    }
    
    // Draw close button (X symbol)
    var cross_thickness = 2;
    var cross_padding = 4;
    
    // Draw background circle/rect
    gmui_add_rect(close_x, close_y, close_size, close_size, make_color_rgb(0, 0, 0));
    
    // Draw X symbol
    gmui_add_line(close_x + cross_padding, close_y + cross_padding, 
                 close_x + close_size - cross_padding, close_y + close_size - cross_padding, 
                 close_color, cross_thickness);
    gmui_add_line(close_x + close_size - cross_padding, close_y + cross_padding, 
                 close_x + cross_padding, close_y + close_size - cross_padding, 
                 close_color, cross_thickness);
}

// Handle window dragging and resizing
function gmui_handle_window_interaction(window) {
    var style = global.gmui.style;
    var flags = window.flags;
    var has_title_bar = (flags & gmui_window_flags.NO_TITLE_BAR) == 0;
    var can_move = (flags & gmui_window_flags.NO_MOVE) == 0;
	var can_move_depth = (flags & gmui_window_flags.NO_MOVE_DEPTH) == 0;
    var can_resize = (flags & gmui_window_flags.NO_RESIZE) == 0;
    
    var mouse_x_in_window = global.gmui.mouse_pos[0] - window.x;
    var mouse_y_in_window = global.gmui.mouse_pos[1] - window.y;
    var mouse_over_window = gmui_is_mouse_over_window(window);
    
    // Reset hover states
    window.title_bar_hovered = false;
    
    // Check title bar hover
    if (has_title_bar && mouse_over_window && mouse_y_in_window <= style.title_bar_height && !global.gmui.is_hovering_element) {
        global.gmui.is_hovering_element = true;
		window.title_bar_hovered = true;
    }
    
    // BRING WINDOW TO FRONT ON CLICK
    if (mouse_over_window && global.gmui.mouse_clicked[0] && !global.gmui.is_hovering_element && can_move && can_move_depth) {
        gmui_bring_window_to_front(window);
    }
    
    // Handle dragging
    if (can_move && has_title_bar && window.title_bar_hovered) {
        if (global.gmui.mouse_clicked[0]) {
            window.is_dragging = true;
            window.drag_offset_x = mouse_x_in_window;
            window.drag_offset_y = mouse_y_in_window;
            window.title_bar_active = true;
			gmui_bring_window_to_front(window);
            
            // Double click detection for maximize/restore
			if ((flags & gmui_window_flags.NO_COLLAPSE) == 0) {
	            var ct = current_time;
	            if (ct - window.last_click_time < 300) { // 300ms double click
	                // Toggle between original size and maximized
	                if (window.width == window.initial_width && window.height == window.initial_height) { // goes to collapse
	                    // Maximize (simplified - use room size or screen size)
	                    //window.width = room_width - 20;
	                    //window.height = room_height - 20;
	                    //window.x = 10;
	                    //window.y = 10;
					
						window.height = 30;
	                } else { // goes to uncollapsed
	                    // Restore to initial size
	                    window.x = window.initial_x;
	                    window.y = window.initial_y;
	                    window.width = window.initial_width;
	                    window.height = window.initial_height;
	                }
	                gmui_create_surface(window);
	            }
	            window.last_click_time = ct;
			}
        }
    }
    
    // Handle dragging movement
    if (window.is_dragging && global.gmui.mouse_down[0]) {
        window.x = global.gmui.mouse_pos[0] - window.drag_offset_x;
        window.y = global.gmui.mouse_pos[1] - window.drag_offset_y;
        window.surface_dirty = true; // Mark as dirty since position changed
    } else {
        window.is_dragging = false;
        window.title_bar_active = false;
    }
    
    // Handle resizing
    if (can_resize && mouse_over_window) {
        var resize_margin = 4;
        var near_right = mouse_x_in_window >= window.width - resize_margin;
        var near_bottom = mouse_y_in_window >= window.height - resize_margin;
        
        if ((near_right && near_bottom) && global.gmui.mouse_clicked[0]) {
            window.is_resizing = true;
        }
		
		if (near_right && near_bottom && !global.gmui.is_hovering_element) {
			global.gmui.is_hovering_element = true;
			window_set_cursor(cr_size_nwse);
		}
    }
    
    // Handle resizing movement
    if (window.is_resizing && global.gmui.mouse_down[0]) {
        var new_width = max(global.gmui.style.window_min_size[0], mouse_x_in_window);
        var new_height = max(global.gmui.style.window_min_size[1], mouse_y_in_window);
        
        if (new_width != window.width || new_height != window.height) {
            window.width = new_width;
            window.height = new_height;
            gmui_create_surface(window); // Recreate surface with new size
        }
		
		window_set_cursor(cr_size_nwse);
    } else {
        window.is_resizing = false;
    }
	
	// Handle Scrollbar to make sure elements dont overlap over mouse
	var has_scrollbar_vertical = (window.flags & gmui_window_flags.VERTICAL_SCROLL) != 0 || (window.flags & gmui_window_flags.AUTO_SCROLL) != 0 || (window.flags & gmui_window_flags.AUTO_VSCROLL) != 0;
	var has_scrollbar_horizontal = (window.flags & gmui_window_flags.HORIZONTAL_SCROLLBAR) != 0 || (window.flags & gmui_window_flags.AUTO_SCROLL) != 0 || (window.flags & gmui_window_flags.AUTO_HSCROLL) != 0;
	
	if (has_scrollbar_vertical) {
		var content_width = window.width - style.scrollbar_width;
		var content_height = window.height - window.dc.title_bar_height - style.scrollbar_width;
		var _x = (window.flags & gmui_window_flags.SCROLLBAR_LEFT) != 0 ? 0 : content_width;
		var _y = window.dc.title_bar_height;
		var _width = style.scrollbar_width;
		var _height = content_height;
		
		var anchor_bounds = [_x, _y, _x + _width, _y + _height];
		var mouse_over_anchor = gmui_is_scrollbar_interacting(window, anchor_bounds);
		if (mouse_over_anchor && !global.gmui.is_hovering_element) {
			global.gmui.is_hovering_element = true;
		};
	};
	
	if (has_scrollbar_horizontal) {
		var content_width = window.width - style.scrollbar_width;
		var content_height = window.height - window.dc.title_bar_height - style.scrollbar_width;
		var _x = 0
		var _y = (window.flags & gmui_window_flags.SCROLLBAR_TOP) != 0 ? window.dc.title_bar_height : content_height;
		var _width = content_width;
		var _height = style.scrollbar_width;
		
		var anchor_bounds = [_x, _y, _x + _width, _y + _height];
		var mouse_over_anchor = gmui_is_scrollbar_interacting(window, anchor_bounds);
		if (mouse_over_anchor && !global.gmui.is_hovering_element) {
			global.gmui.is_hovering_element = true;
		};
	};
}

function gmui_add_scissor(x, y, w, h) {
    if (!global.gmui.initialized || !global.gmui.current_window) return;
    array_push(global.gmui.current_window.draw_list, {
        type: "scissor", x: x, y: y, width: w, height: h
    });
}

function gmui_add_scissor_reset() {
    if (!global.gmui.initialized || !global.gmui.current_window) return;
    array_push(global.gmui.current_window.draw_list, {
        type: "scissor_reset"
    });
}

function gmui_begin_scissor(x, y, w, h) {
    gmui_add_scissor(x, y, w, h);
	return true;
}

function gmui_end_scissor() {
    gmui_add_scissor_reset();
}

function gmui_scissor_group(x, y, w, h, func) {
    gmui_begin_scissor(x, y, w, h);
    func();
    gmui_end_scissor();
}

function gmui_bring_window_to_front(window) {
    if (!global.gmui.initialized || !window) return false;
    
    // Increment the global counter and update window z-index
    global.gmui.z_order_counter++;
    window.z_index = global.gmui.z_order_counter;
    
    // Update the priority queue
    if (ds_priority_find_priority(global.gmui.window_z_order, window) != undefined) {
        ds_priority_change_priority(global.gmui.window_z_order, window, window.z_index);
    } else {
        ds_priority_add(global.gmui.window_z_order, window, window.z_index);
    }
    
    return true;
}

function gmui_send_window_to_back(window) {
    if (!global.gmui.initialized || !window) return false;
    
    // Set to lowest possible z-index
    window.z_index = 0;
    
    // Update the priority queue
    if (ds_priority_find_priority(global.gmui.window_z_order, window) != undefined) {
        ds_priority_change_priority(global.gmui.window_z_order, window, window.z_index);
    } else {
        ds_priority_add(global.gmui.window_z_order, window, window.z_index);
    }
    
    return true;
}

function gmui_get_top_window() {
    if (!global.gmui.initialized || ds_priority_size(global.gmui.window_z_order) == 0) 
        return undefined;
    
    return ds_priority_find_max(global.gmui.window_z_order);
}

function gmui_get_window_z_order(window) {
    if (!global.gmui.initialized || !window) return -1;
    return window.z_index;
}

function gmui_set_window_z_order(window_name, z_index) {
    if (!global.gmui.initialized) return false;
    
    var window = gmui_get_window(window_name);
    if (!window) return false;
    
    window.z_index = z_index;
    
    // Update priority queue
    if (ds_priority_find_value(global.gmui.window_z_order, window) != undefined) {
        ds_priority_change_priority(global.gmui.window_z_order, window, z_index);
    } else {
        ds_priority_add(global.gmui.window_z_order, window, z_index);
    }
    
    return true;
}

function gmui_get_all_windows_sorted() {
    if (!global.gmui.initialized) return [];
    
    var sorted = ds_priority_create();
    for (var i = 0; i < ds_list_size(global.gmui.windows); i++) {
        var window = global.gmui.windows[| i];
        ds_priority_add(sorted, window, window.z_index);
    }
    
    var result = [];
    var count = ds_priority_size(sorted);
    for (var i = 0; i < count; i++) {
        array_push(result, ds_priority_delete_min(sorted));
    }
    
    ds_priority_destroy(sorted);
    return result;
}

function gmui_cache_get(id) {
	return global.gmui.cache[? id];
}

function gmui_cache_set(id, data) {
	global.gmui.cache[? id] = data;
}

function gmui_cache_delete(id) {
	ds_map_delete(global.gmui.cache, id);
};

function gmui_cache_surface_get(id, width, height, sleep_timer_seconds = 30) {
    var surface = gmui_cache_get(id);
    
    if (surface == undefined) {
        surface = {
            id: id,
            surface: surface_create(width, height),
            sleep_timer: sleep_timer_seconds,
            time_start: current_time
        };
        global.gmui.cache_surfaces[? id] = surface;
        gmui_cache_set(id, surface);
    };
    
    if (!surface_exists(surface.surface)) {
        surface_free(surface.surface);
        surface.surface = surface_create(width, height);
    };
    
    surface.time_start = current_time;
    
    return surface;
}

function gmui_demo() { // Performance issues due to everything being dumped into one place without optimization, for now best to initialize headers as closed
    if (!global.gmui.initialized) return;
    
	static window_flags = gmui_window_flags.NO_RESIZE | gmui_window_flags.AUTO_VSCROLL | gmui_window_flags.SCROLL_WITH_MOUSE_WHEEL;
	
    if (gmui_begin("GMUI Demo & Documentation", 20, 20, 600, 600, window_flags)) {
        
        // Demo window controls
        gmui_text("GMUI - Immediate-mode UI Library for GameMaker");
        gmui_text_disabled("Interactive demo showing some of the features");
        gmui_separator();
        
        // Window information
		static cho0 = false;
		var header = gmui_collapsing_header("Help & About", cho0);
		cho0 = header[1] ? !cho0 : cho0;
        if (cho0) {
            gmui_text("GMUI provides an immediate-mode UI system for GameMaker.");
            gmui_text("Features:");
            gmui_text_bullet("Windows with dragging and resizing");
            gmui_text_bullet("Comprehensive input handling");
            gmui_text_bullet("Extensive styling options");
            gmui_text_bullet("Multiple UI components");
            gmui_text_bullet("Scrollable content areas");
            gmui_text_bullet("Color picker with HSV/RGB support");
            gmui_text("HOW TO USE:");
            gmui_text("1. Call gmui_init() in Create Event");
            gmui_text("2. Call gmui_update() in Step Event");
            gmui_text("3. Create UI between gmui_begin()/gmui_end() in Step Event");
            gmui_text("4. Call gmui_render() in Draw GUI Event");
            gmui_text("5. Call gmui_cleanup() when done");
            gmui_text("CONTACT:");
			gmui_text("You can contact me from discord, erkan612");
			gmui_text("If you've found a bug or problem, feel free to DM me!");
            gmui_collapsing_header_end();
        }
        
        // Basic widgets
		static cho1 = false;
		header = gmui_collapsing_header("Basic Widgets", cho1);
		cho1 = header[1] ? !cho1 : cho1;
        if (cho1) {
            static basic_int = 0;
            static basic_float = 0.0;
            static basic_text = "Hello GMUI";
            static basic_check = true;
            static basic_selectable = 0;
            
            gmui_text("Buttons");
            if (gmui_button("Button")) { basic_int++; }
            gmui_same_line();
            if (gmui_button("Small", 80, 20)) { basic_int--; }
            gmui_same_line();
            if (gmui_button_large("large")) { basic_int++; }
            gmui_same_line();
            gmui_button_disabled("Disabled");
            
            gmui_text("Checkboxes");
            basic_check = gmui_checkbox("Checkbox", basic_check);
            
            gmui_text("Selectables");
            if (gmui_selectable("Option A", basic_selectable == 0)) { basic_selectable = 0; } gmui_same_line();
            if (gmui_selectable("Option B", basic_selectable == 1)) { basic_selectable = 1; } gmui_same_line();
            if (gmui_selectable("Option C", basic_selectable == 2)) { basic_selectable = 2; }
            
            gmui_new_line();
            gmui_text("Text Input");
            basic_text = gmui_textbox(basic_text, "Enter text...");
            gmui_label_text("Text length", string(string_length(basic_text)));
            
            gmui_text("Numeric Input");
			gmui_text("Integer"); gmui_same_line();
            basic_int = gmui_input_int(basic_int, undefined, -100, 100);
            gmui_same_line();
			gmui_text("Float"); gmui_same_line();
            basic_float = gmui_input_float(basic_float, undefined, -100, 100);
            
            gmui_collapsing_header_end();
        }
        
        // Sliders
		static cho2 = false;
		header = gmui_collapsing_header("Sliders", cho2);
		cho2 = header[1] ? !cho2 : cho2;
        if (cho2) {
            static slider_int = 50;
            static slider_float = 0.5;
            static slider_angle = 0.0;
            
            gmui_text("Sliders");
            slider_int = floor(gmui_slider("Int slider", slider_int, 0, 100, 200));
            slider_float = gmui_slider("Float slider", slider_float, 0.0, 1.0, 200);
            
            gmui_text("Disabled Sliders");
            gmui_slider_disabled("Locked slider", 75, 0, 100, 200);
            
            gmui_collapsing_header_end();
        }
        
        // Progress bars
        static cho_progress = false;
        header = gmui_collapsing_header("Progress Bars", cho_progress);
        cho_progress = header[1] ? !cho_progress : cho_progress;
        if (cho_progress) {
            static progress_value = 0.65;
            static circular_value = 0.75;
            
            gmui_text("Linear Progress Bars");
            
            gmui_progress_bar("Standard", progress_value, 0, 1, 200);
            gmui_progress_bar("With Text", progress_value, 0, 1, 200);
            gmui_progress_bar("Thin", progress_value, 0, 1, 200, 12);
            gmui_progress_bar("No Label", progress_value, 0, 1, 200, -1, false);
            
            gmui_text("Different Values");
            gmui_progress_bar("25%", 0.25, 0, 1, 200);
            gmui_progress_bar("50%", 0.5, 0, 1, 200);
            gmui_progress_bar("75%", 0.75, 0, 1, 200);
            gmui_progress_bar("100%", 1.0, 0, 1, 200);
            
            gmui_text("Indeterminate Progress");
            gmui_progress_bar_indeterminate("Loading...", 200);
            
            gmui_text("Circular Progress Bars");
            
            gmui_same_line();
            gmui_progress_circular(circular_value, 0, 1, 40);
            gmui_same_line();
            gmui_progress_circular(0.25, 0, 1, 40);
            gmui_same_line();
            gmui_progress_circular(0.5, 0, 1, 40);
            gmui_same_line();
            gmui_progress_circular(0.75, 0, 1, 40);
            gmui_same_line();
            gmui_progress_circular(1.0, 0, 1, 40);
            
            gmui_text("Circular Spinners");
            gmui_same_line();
            gmui_progress_spinner(30, 3);
            gmui_same_line();
            gmui_progress_spinner(40, 4);
            gmui_same_line();
            gmui_progress_spinner(50, 5);
            
            gmui_text("Size Variations");
            gmui_same_line();
            gmui_progress_circular(0.65, 0, 1, 30);
            gmui_same_line();
            gmui_progress_circular(0.65, 0, 1, 50);
            gmui_same_line();
            gmui_progress_circular(0.65, 0, 1, 70);
            
            gmui_text("Controls");
            gmui_text("Linear Progress Value"); gmui_same_line();
            progress_value = gmui_slider("", progress_value, 0, 1, 150);
            
            gmui_text("Circular Progress Value"); gmui_same_line();
            circular_value = gmui_slider("", circular_value, 0, 1, 150);
            
            gmui_collapsing_header_end();
        }
        
        // Color Picker
		static cho3 = false;
		header = gmui_collapsing_header("Color Picker", cho3);
		cho3 = header[1] ? !cho3 : cho3;
        if (cho3) {
            static color = gmui_make_color_rgba(255, 128, 64, 255);
            
            gmui_text("Color Editor");
            color = gmui_color_edit_4("Color with inputs", color);
            
            color = gmui_color_button_4("Color Button", color);
            
            gmui_same_line();
            gmui_dummy(10, 0);
            gmui_same_line();
            
            // Show color values
            var color_arr = gmui_color_rgba_to_array(color);
            gmui_label_text("RGB", string(color_arr[0]) + ", " + string(color_arr[1]) + ", " + string(color_arr[2]));
            gmui_label_text("Alpha", string(color_arr[3]));
            
            gmui_text("Color Presets");
            gmui_same_line();
            if (gmui_color_button(gmui_make_color_rgba(255, 0, 0, 255), 20)) { color = gmui_make_color_rgba(255, 0, 0, 255); }
            gmui_same_line();
            if (gmui_color_button(gmui_make_color_rgba(0, 255, 0, 255), 20)) { color = gmui_make_color_rgba(0, 255, 0, 255); }
            gmui_same_line();
            if (gmui_color_button(gmui_make_color_rgba(0, 0, 255, 255), 20)) { color = gmui_make_color_rgba(0, 0, 255, 255); }
            gmui_same_line();
            if (gmui_color_button(gmui_make_color_rgba(255, 255, 0, 255), 20)) { color = gmui_make_color_rgba(255, 255, 0, 255); }
            gmui_same_line();
            if (gmui_color_button(gmui_make_color_rgba(255, 0, 255, 255), 20)) { color = gmui_make_color_rgba(255, 0, 255, 255); }
            gmui_same_line();
            if (gmui_color_button(gmui_make_color_rgba(0, 255, 255, 255), 20)) { color = gmui_make_color_rgba(0, 255, 255, 255); }
            
            gmui_collapsing_header_end();
        }
		
        // Tree View
		static cho4 = false;
		header = gmui_collapsing_header("Tree View", cho4);
		cho4 = header[1] ? !cho4 : cho4;
        if (cho4) {
            gmui_text("Tree View Demo");
            static selected_tree_item = -1;
            
			gmui_tree_node_reset();
			var node = gmui_tree_node_begin("Basic trees", selected_tree_item == "Basic trees");
			selected_tree_item = node[1] ? "Basic trees" : selected_tree_item;
            if (node[0]) {
				node = gmui_tree_node_begin("Node A", selected_tree_item == "Node A");
				selected_tree_item = node[1] ? "Node A" : selected_tree_item;
                if (node[0]) {
                    if (gmui_tree_leaf("Node A.1", selected_tree_item == "Node A.1")) {
						selected_tree_item = "Node A.1";
                    }
                    if (gmui_tree_leaf("Node A.2", selected_tree_item == "Node A.2")) {
						selected_tree_item = "Node A.2";
                    }
                }
				gmui_tree_node_end();
                
				node = gmui_tree_node_begin("Node B", selected_tree_item == "Node B");
				selected_tree_item = node[1] ? "Node B" : selected_tree_item;
                if (node[0]) {
                    if (gmui_tree_leaf("Node B.1", selected_tree_item == "Node B.1")) {
						selected_tree_item = "Node B.1";
                    }
					node = gmui_tree_node_begin("Node B.2", selected_tree_item == "Node B.2");
					selected_tree_item = node[1] ? "Node B.2" : selected_tree_item;
                    if (node[0]) {
                        if (gmui_tree_leaf("Node B.2.1", selected_tree_item == "Node B.2.1")) {
							selected_tree_item = "Node B.2.1";
                        }
                    }
					gmui_tree_node_end();
                }
				gmui_tree_node_end();
            }
			gmui_tree_node_end();
            
            gmui_text("Selectable Tree Items");
            for (var i = 0; i < 5; i++) {
                if (gmui_tree_leaf("Tree Item " + string(i), selected_tree_item == i)) {
                    selected_tree_item = i;
                }
            }
            
            gmui_collapsing_header_end();
        }
        
        // Layout & Groups
		static cho5 = false;
		header = gmui_collapsing_header("Layout & Groups", cho5);
		cho5 = header[1] ? !cho5 : cho5;
        if (cho5) {
            gmui_text("Same Line");
            if (gmui_button("Button A")) { }
            gmui_same_line();
            if (gmui_button("Button B")) { }
            gmui_same_line();
            if (gmui_button("Button C")) { }
            
            gmui_text("Manual Cursor Positioning");
            var cursor_pos = gmui_get_cursor();
            gmui_label_text("Cursor", string(cursor_pos[0]) + ", " + string(cursor_pos[1]));
            
            // Set cursor to specific position
            gmui_set_cursor(300, cursor_pos[1]);
            if (gmui_button("Right Aligned")) { }
            
            // Reset cursor
            gmui_set_cursor(cursor_pos[0], cursor_pos[1] + 40);
            
            gmui_text("Spacing");
            gmui_dummy(100, 20);
            gmui_same_line();
            gmui_text("This text is after dummy space");
            
            gmui_text("Separators");
            gmui_separator();
            gmui_text("Text above separator");
            gmui_separator();
            gmui_text("Text below separator");
            
            gmui_collapsing_header_end();
        }
        
        // Text Display
		static cho6 = false;
		header = gmui_collapsing_header("Text Display", cho6);
		cho6 = header[1] ? !cho6 : cho6;
        if (cho6) {
            gmui_text("This is normal text");
            gmui_text_disabled("This is disabled text");
            
            gmui_label_text("Label", "Value");
            gmui_label_text("FPS", string(room_speed));
            gmui_label_text("Window Size", string(window_get_width()) + "x" + string(window_get_height()));
            gmui_label_text("Mouse Position", string(device_mouse_x_to_gui(0)) + ", " + string(device_mouse_y_to_gui(0)));
            
            gmui_text("Wrapping text demonstration:");
            gmui_text_wrap("This is a longer piece of text that should wrap within the window boundaries and demonstrate how text flows in the GMUI system.");
            
            gmui_collapsing_header_end();
        }
        
        // Input Focus
		static cho7 = false;
		header = gmui_collapsing_header("Input Focus", cho7);
		cho7 = header[1] ? !cho7 : cho7;
        if (cho7) {
            static focus_text1 = "";
            static focus_text2 = "";
            
            gmui_text("Input Focus Demo");
            focus_text1 = gmui_textbox(focus_text1, "First textbox");
            focus_text2 = gmui_textbox(focus_text2, "Second textbox");
            
            if (gmui_is_any_textbox_focused()) {
                gmui_text_disabled("A textbox is currently focused");
                if (gmui_button("Clear Focus")) {
                    gmui_clear_textbox_focus();
                }
            } else {
                gmui_text("No textbox focused");
            }
            
            var focused_id = gmui_get_focused_textbox_id();
            if (focused_id != undefined) {
                gmui_label_text("Focused ID", focused_id);
            }
            
            gmui_collapsing_header_end();
        }
        
        // Window Flags Demo
		static cho8 = false;
		header = gmui_collapsing_header("Window Flags", cho8);
		cho8 = header[1] ? !cho8 : cho8;
        if (cho8) {
			gmui_text("Window Flags Configuration");
			gmui_tab_width(16);
			gmui_text("Title Bar");		gmui_same_line(); gmui_tab(7); if (gmui_button("Toggle")) { window_flags ^= gmui_window_flags.NO_TITLE_BAR;		};
			gmui_text("Resize");		gmui_same_line(); gmui_tab(7); if (gmui_button("Toggle")) { window_flags ^= gmui_window_flags.NO_RESIZE;		};
			gmui_text("Background");	gmui_same_line(); gmui_tab(7); if (gmui_button("Toggle")) { window_flags ^= gmui_window_flags.NO_BACKGROUND;	};
			gmui_text("Move");			gmui_same_line(); gmui_tab(7); if (gmui_button("Toggle")) { window_flags ^= gmui_window_flags.NO_MOVE;			};
            
            gmui_collapsing_header_end();
        }
		
		// Data Tables
		static cho_table = false;
		header = gmui_collapsing_header("Data Tables", cho_table);
		cho_table = header[1] ? !cho_table : cho_table;
		if (cho_table) {
		    static table_data = [
		        ["Apple", "Fruit", "1.20", "100"],
		        ["Banana", "Fruit", "0.80", "150"],
		        ["Carrot", "Vegetable", "1.50", "75"],
		        ["Broccoli", "Vegetable", "2.00", "60"],
		        ["Chicken", "Meat", "8.50", "30"],
		        ["Beef", "Meat", "12.00", "25"],
		        ["Milk", "Dairy", "3.50", "40"],
		        ["Cheese", "Dairy", "5.00", "35"]
		    ];
    
		    static columns = ["Name", "Category", "Price", "Stock"];
		    static current_flags = global.gmui.style.table_flags.ALTERNATE_ROWS | global.gmui.style.table_flags.SORTABLE_HEADERS;
    
		    gmui_text("Styled Data Table Example");
    
		    // Table flags
		    gmui_text("Table Options:");
		    current_flags = gmui_checkbox_box((current_flags & global.gmui.style.table_flags.ALTERNATE_ROWS) != 0) ? 
		        current_flags | global.gmui.style.table_flags.ALTERNATE_ROWS : 
		        current_flags & ~global.gmui.style.table_flags.ALTERNATE_ROWS;
		    gmui_same_line();
		    gmui_text("Alternating Rows");
    
		    current_flags = gmui_checkbox_box((current_flags & global.gmui.style.table_flags.BORDERED_CELLS) != 0) ? 
		        current_flags | global.gmui.style.table_flags.BORDERED_CELLS : 
		        current_flags & ~global.gmui.style.table_flags.BORDERED_CELLS;
		    gmui_same_line();
		    gmui_text("Bordered Cells");
    
		    current_flags = gmui_checkbox_box((current_flags & global.gmui.style.table_flags.HOVERABLE_ROWS) != 0) ? 
		        current_flags | global.gmui.style.table_flags.HOVERABLE_ROWS : 
		        current_flags & ~global.gmui.style.table_flags.HOVERABLE_ROWS;
		    gmui_same_line();
		    gmui_text("Hoverable Rows");
    
		    current_flags = gmui_checkbox_box((current_flags & global.gmui.style.table_flags.SORTABLE_HEADERS) != 0) ? 
		        current_flags | global.gmui.style.table_flags.SORTABLE_HEADERS : 
		        current_flags & ~global.gmui.style.table_flags.SORTABLE_HEADERS;
		    gmui_same_line();
		    gmui_text("Sortable Headers");
    
		    gmui_separator();
    
		    // Create table with current flags
		    var table = gmui_begin_table("demo_table", columns, 4, -1, 200, current_flags);
    
		    // Add rows
		    for (var i = 0; i < array_length(table_data); i++) {
		        var clicked = gmui_table_row(table_data[i], i);
		        if (clicked != -1) {
		            // Selection handled internally
		        }
		    }
    
		    gmui_end_table();
    
		    // Show selection info
		    if (table.selected_row != -1) {
		        gmui_label_text("Selected Row", string(table.selected_row));
		        gmui_label_text("Selected Item", table_data[table.selected_row][0]);
		    } else {
		        gmui_text("Click on a row to select it");
		    }
    
		    // Simple controls
		    if (gmui_button("Clear Selection")) {
		        gmui_table_clear_selection(table);
		    }
    
		    gmui_collapsing_header_end();
		}
		
		// Plotting & Charts Demo
		static cho_plots = false;
		header = gmui_collapsing_header("Plotting & Charts", cho_plots);
		cho_plots = header[1] ? !cho_plots : cho_plots;
		if (cho_plots) {
		    static plot_data = [25, 45, 30, 60, 40, 80, 55, 35, 70, 50];
		    static frame_times = [16.7, 15.2, 18.3, 14.8, 22.1, 16.9, 15.7, 17.2, 19.5, 16.1];
		    static scatter_x = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
		    static scatter_y = [2, 4, 5, 4, 5, 7, 8, 7, 9, 8];
    
		    gmui_text("Data Visualization Examples");
		    gmui_text_disabled("Various chart types with customizable styling");
		    gmui_separator();
    
		    // Line plot example
		    gmui_text("Line Plot - Time Series Data");
		    gmui_plot_lines("Frame Times (ms)", frame_times, array_length(frame_times), -1, 150);
    
		    // Bar chart example
		    gmui_text("Bar Chart - Performance Metrics");
		    gmui_plot_bars("Sensor Readings", plot_data, array_length(plot_data), -1, 150);
    
		    // Histogram example
		    gmui_text("Histogram - Value Distribution");
		    gmui_plot_histogram("Data Distribution", plot_data, array_length(plot_data), -1, 150, 6);
    
		    // Scatter plot example
		    gmui_text("Scatter Plot - Correlation");
		    gmui_plot_scatter("X vs Y Correlation", scatter_x, scatter_y, array_length(scatter_x), -1, 150);
    
		    gmui_collapsing_header_end();
		}
		
        // Style Editor
		static cho9 = false;
		header = gmui_collapsing_header("Style Editor", cho9);
		cho9 = header[1] ? !cho9 : cho9;
		if (cho9) {
		    static style_editor_visible = false;
    
		    if (gmui_button("Show/Hide Style Editor")) {
		        style_editor_visible = !style_editor_visible;
		    }
    
		    if (style_editor_visible) {
		        if (gmui_begin("Style Editor", 650, 20, 400, 500, gmui_window_flags.NO_CLOSE | gmui_window_flags.AUTO_VSCROLL | gmui_window_flags.SCROLL_WITH_MOUSE_WHEEL)) {
		            var style = global.gmui.style;
            
		            gmui_text("Window Padding");
		            gmui_same_line();
		            global.gmui.style.window_padding[0] = gmui_input_int(global.gmui.style.window_padding[0], 1, 0, 50);
		            gmui_same_line();
		            global.gmui.style.window_padding[1] = gmui_input_int(global.gmui.style.window_padding[1], 1, 0, 50);
            
		            gmui_text("Window Rounding");
		            gmui_same_line();
		            global.gmui.style.window_rounding = gmui_input_int(global.gmui.style.window_rounding, 1, 0, 50);
            
		            gmui_text("Window Min Size");
		            gmui_same_line();
		            global.gmui.style.window_min_size[0] = gmui_input_int(global.gmui.style.window_min_size[0], 1, 10, 500);
		            gmui_same_line();
		            global.gmui.style.window_min_size[1] = gmui_input_int(global.gmui.style.window_min_size[1], 1, 10, 500);
            
		            static sBackgroundColor = gmui_color_rgb_to_color_rgba(global.gmui.style.background_color);
		            sBackgroundColor = gmui_color_button_4("Background Color", sBackgroundColor);
		            global.gmui.style.background_color = gmui_color_rgba_to_color_rgb(sBackgroundColor);
            
		            static sBorderColor = gmui_color_rgb_to_color_rgba(global.gmui.style.border_color);
		            sBorderColor = gmui_color_button_4("Border Color", sBorderColor);
		            global.gmui.style.border_color = gmui_color_rgba_to_color_rgb(sBorderColor);
            
		            static sTextColor = gmui_color_rgb_to_color_rgba(global.gmui.style.text_color);
		            sTextColor = gmui_color_button_4("Text Color", sTextColor);
		            global.gmui.style.text_color = gmui_color_rgba_to_color_rgb(sTextColor);
            
		            static sTextDisabledColor = gmui_color_rgb_to_color_rgba(global.gmui.style.text_disabled_color);
		            sTextDisabledColor = gmui_color_button_4("Text Disabled Color", sTextDisabledColor);
		            global.gmui.style.text_disabled_color = gmui_color_rgba_to_color_rgb(sTextDisabledColor);
            
		            static sButtonTextColor = gmui_color_rgb_to_color_rgba(global.gmui.style.button_text_color);
		            sButtonTextColor = gmui_color_button_4("Button Text Color", sButtonTextColor);
		            global.gmui.style.button_text_color = gmui_color_rgba_to_color_rgb(sButtonTextColor);
            
		            static sButtonBgColor = gmui_color_rgb_to_color_rgba(global.gmui.style.button_bg_color);
		            sButtonBgColor = gmui_color_button_4("Button BG Color", sButtonBgColor);
		            global.gmui.style.button_bg_color = gmui_color_rgba_to_color_rgb(sButtonBgColor);
            
		            static sButtonBorderColor = gmui_color_rgb_to_color_rgba(global.gmui.style.button_border_color);
		            sButtonBorderColor = gmui_color_button_4("Button Border Color", sButtonBorderColor);
		            global.gmui.style.button_border_color = gmui_color_rgba_to_color_rgb(sButtonBorderColor);
            
		            static sButtonHoverBgColor = gmui_color_rgb_to_color_rgba(global.gmui.style.button_hover_bg_color);
		            sButtonHoverBgColor = gmui_color_button_4("Button Hover BG", sButtonHoverBgColor);
		            global.gmui.style.button_hover_bg_color = gmui_color_rgba_to_color_rgb(sButtonHoverBgColor);
            
		            static sButtonHoverBorderColor = gmui_color_rgb_to_color_rgba(global.gmui.style.button_hover_border_color);
		            sButtonHoverBorderColor = gmui_color_button_4("Button Hover Border", sButtonHoverBorderColor);
		            global.gmui.style.button_hover_border_color = gmui_color_rgba_to_color_rgb(sButtonHoverBorderColor);
            
		            gmui_text("Button Rounding");
		            gmui_same_line();
		            global.gmui.style.button_rounding = gmui_input_int(global.gmui.style.button_rounding, 1, 0, 50);
            
		            gmui_text("Button Border Size");
		            gmui_same_line();
		            global.gmui.style.button_border_size = gmui_input_int(global.gmui.style.button_border_size, 1, 0, 10);
            
		            gmui_text("Button Padding");
		            gmui_same_line();
		            global.gmui.style.button_padding[0] = gmui_input_int(global.gmui.style.button_padding[0], 1, 0, 50);
		            gmui_same_line();
		            global.gmui.style.button_padding[1] = gmui_input_int(global.gmui.style.button_padding[1], 1, 0, 50);
            
		            gmui_text("Button Min Size");
		            gmui_same_line();
		            global.gmui.style.button_min_size[0] = gmui_input_int(global.gmui.style.button_min_size[0], 1, 10, 500);
		            gmui_same_line();
		            global.gmui.style.button_min_size[1] = gmui_input_int(global.gmui.style.button_min_size[1], 1, 10, 500);
            
		            static sTitleBarColor = gmui_color_rgb_to_color_rgba(global.gmui.style.title_bar_color);
		            sTitleBarColor = gmui_color_button_4("Title Bar Color", sTitleBarColor);
		            global.gmui.style.title_bar_color = gmui_color_rgba_to_color_rgb(sTitleBarColor);
            
		            static sTitleBarHoverColor = gmui_color_rgb_to_color_rgba(global.gmui.style.title_bar_hover_color);
		            sTitleBarHoverColor = gmui_color_button_4("Title Bar Hover", sTitleBarHoverColor);
		            global.gmui.style.title_bar_hover_color = gmui_color_rgba_to_color_rgb(sTitleBarHoverColor);
            
		            static sTitleTextColor = gmui_color_rgb_to_color_rgba(global.gmui.style.title_text_color);
		            sTitleTextColor = gmui_color_button_4("Title Text Color", sTitleTextColor);
		            global.gmui.style.title_text_color = gmui_color_rgba_to_color_rgb(sTitleTextColor);
            
		            gmui_text("Title Bar Height");
		            gmui_same_line();
		            global.gmui.style.title_bar_height = gmui_input_int(global.gmui.style.title_bar_height, 1, 10, 100);
            
		            gmui_text("Title Padding");
		            gmui_same_line();
		            global.gmui.style.title_padding[0] = gmui_input_int(global.gmui.style.title_padding[0], 1, 0, 50);
		            gmui_same_line();
		            global.gmui.style.title_padding[1] = gmui_input_int(global.gmui.style.title_padding[1], 1, 0, 50);
            
		            static sCheckboxBgColor = gmui_color_rgb_to_color_rgba(global.gmui.style.checkbox_bg_color);
		            sCheckboxBgColor = gmui_color_button_4("Checkbox BG Color", sCheckboxBgColor);
		            global.gmui.style.checkbox_bg_color = gmui_color_rgba_to_color_rgb(sCheckboxBgColor);
            
		            static sCheckboxBorderColor = gmui_color_rgb_to_color_rgba(global.gmui.style.checkbox_border_color);
		            sCheckboxBorderColor = gmui_color_button_4("Checkbox Border Color", sCheckboxBorderColor);
		            global.gmui.style.checkbox_border_color = gmui_color_rgba_to_color_rgb(sCheckboxBorderColor);
            
		            static sCheckboxCheckColor = gmui_color_rgb_to_color_rgba(global.gmui.style.checkbox_check_color);
		            sCheckboxCheckColor = gmui_color_button_4("Checkbox Check Color", sCheckboxCheckColor);
		            global.gmui.style.checkbox_check_color = gmui_color_rgba_to_color_rgb(sCheckboxCheckColor);
            
		            gmui_text("Checkbox Size");
		            gmui_same_line();
		            global.gmui.style.checkbox_size = gmui_input_int(global.gmui.style.checkbox_size, 1, 8, 32);
            
		            gmui_text("Checkbox Border Size");
		            gmui_same_line();
		            global.gmui.style.checkbox_border_size = gmui_input_int(global.gmui.style.checkbox_border_size, 1, 0, 10);
            
		            gmui_text("Checkbox Rounding");
		            gmui_same_line();
		            global.gmui.style.checkbox_rounding = gmui_input_int(global.gmui.style.checkbox_rounding, 1, 0, 16);
            
		            static sSliderTrackBgColor = gmui_color_rgb_to_color_rgba(global.gmui.style.slider_track_bg_color);
		            sSliderTrackBgColor = gmui_color_button_4("Slider Track BG", sSliderTrackBgColor);
		            global.gmui.style.slider_track_bg_color = gmui_color_rgba_to_color_rgb(sSliderTrackBgColor);
            
		            static sSliderTrackFillColor = gmui_color_rgb_to_color_rgba(global.gmui.style.slider_track_fill_color);
		            sSliderTrackFillColor = gmui_color_button_4("Slider Track Fill", sSliderTrackFillColor);
		            global.gmui.style.slider_track_fill_color = gmui_color_rgba_to_color_rgb(sSliderTrackFillColor);
            
		            static sSliderHandleBgColor = gmui_color_rgb_to_color_rgba(global.gmui.style.slider_handle_bg_color);
		            sSliderHandleBgColor = gmui_color_button_4("Slider Handle BG", sSliderHandleBgColor);
		            global.gmui.style.slider_handle_bg_color = gmui_color_rgba_to_color_rgb(sSliderHandleBgColor);
            
		            gmui_text("Slider Track Height");
		            gmui_same_line();
		            global.gmui.style.slider_track_height = gmui_input_int(global.gmui.style.slider_track_height, 1, 2, 20);
            
		            gmui_text("Slider Handle Width");
		            gmui_same_line();
		            global.gmui.style.slider_handle_width = gmui_input_int(global.gmui.style.slider_handle_width, 1, 8, 30);
            
		            gmui_text("Slider Handle Height");
		            gmui_same_line();
		            global.gmui.style.slider_handle_height = gmui_input_int(global.gmui.style.slider_handle_height, 1, 10, 40);
            
		            static sTextboxBgColor = gmui_color_rgb_to_color_rgba(global.gmui.style.textbox_bg_color);
		            sTextboxBgColor = gmui_color_button_4("Textbox BG Color", sTextboxBgColor);
		            global.gmui.style.textbox_bg_color = gmui_color_rgba_to_color_rgb(sTextboxBgColor);
            
		            static sTextboxBorderColor = gmui_color_rgb_to_color_rgba(global.gmui.style.textbox_border_color);
		            sTextboxBorderColor = gmui_color_button_4("Textbox Border Color", sTextboxBorderColor);
		            global.gmui.style.textbox_border_color = gmui_color_rgba_to_color_rgb(sTextboxBorderColor);
            
		            static sTextboxTextColor = gmui_color_rgb_to_color_rgba(global.gmui.style.textbox_text_color);
		            sTextboxTextColor = gmui_color_button_4("Textbox Text Color", sTextboxTextColor);
		            global.gmui.style.textbox_text_color = gmui_color_rgba_to_color_rgb(sTextboxTextColor);
            
		            gmui_text("Textbox Padding");
		            gmui_same_line();
		            global.gmui.style.textbox_padding[0] = gmui_input_int(global.gmui.style.textbox_padding[0], 1, 0, 20);
		            gmui_same_line();
		            global.gmui.style.textbox_padding[1] = gmui_input_int(global.gmui.style.textbox_padding[1], 1, 0, 20);
            
		            gmui_text("Textbox Rounding");
		            gmui_same_line();
		            global.gmui.style.textbox_rounding = gmui_input_int(global.gmui.style.textbox_rounding, 1, 0, 10);
					
					static sTableBgColor = gmui_color_rgb_to_color_rgba(global.gmui.style.table_bg_color);
					sTableBgColor = gmui_color_button_4("Table BG Color", sTableBgColor);
					global.gmui.style.table_bg_color = gmui_color_rgba_to_color_rgb(sTableBgColor);

					static sTableHeaderBgColor = gmui_color_rgb_to_color_rgba(global.gmui.style.table_header_bg_color);
					sTableHeaderBgColor = gmui_color_button_4("Header BG Color", sTableHeaderBgColor);
					global.gmui.style.table_header_bg_color = gmui_color_rgba_to_color_rgb(sTableHeaderBgColor);

					static sTableHeaderTextColor = gmui_color_rgb_to_color_rgba(global.gmui.style.table_header_text_color);
					sTableHeaderTextColor = gmui_color_button_4("Header Text Color", sTableHeaderTextColor);
					global.gmui.style.table_header_text_color = gmui_color_rgba_to_color_rgb(sTableHeaderTextColor);

					static sTableRowBgColor = gmui_color_rgb_to_color_rgba(global.gmui.style.table_row_bg_color);
					sTableRowBgColor = gmui_color_button_4("Row BG Color", sTableRowBgColor);
					global.gmui.style.table_row_bg_color = gmui_color_rgba_to_color_rgb(sTableRowBgColor);

					static sTableRowHoverColor = gmui_color_rgb_to_color_rgba(global.gmui.style.table_row_hover_bg_color);
					sTableRowHoverColor = gmui_color_button_4("Row Hover Color", sTableRowHoverColor);
					global.gmui.style.table_row_hover_bg_color = gmui_color_rgba_to_color_rgb(sTableRowHoverColor);

					static sTableRowSelectedColor = gmui_color_rgb_to_color_rgba(global.gmui.style.table_row_selected_bg_color);
					sTableRowSelectedColor = gmui_color_button_4("Row Selected Color", sTableRowSelectedColor);
					global.gmui.style.table_row_selected_bg_color = gmui_color_rgba_to_color_rgb(sTableRowSelectedColor);

					static sTableAltRowColor = gmui_color_rgb_to_color_rgba(global.gmui.style.table_alternate_row_bg_color);
					sTableAltRowColor = gmui_color_button_4("Alt Row BG Color", sTableAltRowColor);
					global.gmui.style.table_alternate_row_bg_color = gmui_color_rgba_to_color_rgb(sTableAltRowColor);

					static sTableAltRowHoverColor = gmui_color_rgb_to_color_rgba(global.gmui.style.table_alternate_row_hover_bg_color);
					sTableAltRowHoverColor = gmui_color_button_4("Alt Row Hover Color", sTableAltRowHoverColor);
					global.gmui.style.table_alternate_row_hover_bg_color = gmui_color_rgba_to_color_rgb(sTableAltRowHoverColor);

					static sTableRowTextColor = gmui_color_rgb_to_color_rgba(global.gmui.style.table_row_text_color);
					sTableRowTextColor = gmui_color_button_4("Row Text Color", sTableRowTextColor);
					global.gmui.style.table_row_text_color = gmui_color_rgba_to_color_rgb(sTableRowTextColor);

					static sTableRowSelectedTextColor = gmui_color_rgb_to_color_rgba(global.gmui.style.table_row_selected_text_color);
					sTableRowSelectedTextColor = gmui_color_button_4("Selected Text Color", sTableRowSelectedTextColor);
					global.gmui.style.table_row_selected_text_color = gmui_color_rgba_to_color_rgb(sTableRowSelectedTextColor);

					static sTableBorderColor = gmui_color_rgb_to_color_rgba(global.gmui.style.table_border_color);
					sTableBorderColor = gmui_color_button_4("Table Border Color", sTableBorderColor);
					global.gmui.style.table_border_color = gmui_color_rgba_to_color_rgb(sTableBorderColor);

					static sTableCellBorderColor = gmui_color_rgb_to_color_rgba(global.gmui.style.table_cell_border_color);
					sTableCellBorderColor = gmui_color_button_4("Cell Border Color", sTableCellBorderColor);
					global.gmui.style.table_cell_border_color = gmui_color_rgba_to_color_rgb(sTableCellBorderColor);

					gmui_text("Row Height"); gmui_same_line();
					global.gmui.style.table_row_height = gmui_input_int(global.gmui.style.table_row_height, 1, 16, 48);

					gmui_text("Header Height"); gmui_same_line();
					global.gmui.style.table_header_height = gmui_input_int(global.gmui.style.table_header_height, 1, 20, 48);

					gmui_text("Cell Padding X"); gmui_same_line();
					global.gmui.style.table_cell_padding[0] = gmui_input_int(global.gmui.style.table_cell_padding[0], 1, 0, 20);

					gmui_text("Cell Padding Y"); gmui_same_line();
					global.gmui.style.table_cell_padding[1] = gmui_input_int(global.gmui.style.table_cell_padding[1], 1, 0, 20);
					
					static sPlotBgColor = gmui_color_rgb_to_color_rgba(global.gmui.style.plot_bg_color);
					sPlotBgColor = gmui_color_button_4("Plot BG Color", sPlotBgColor);
					global.gmui.style.plot_bg_color = gmui_color_rgba_to_color_rgb(sPlotBgColor);

					static sPlotBorderColor = gmui_color_rgb_to_color_rgba(global.gmui.style.plot_border_color);
					sPlotBorderColor = gmui_color_button_4("Plot Border Color", sPlotBorderColor);
					global.gmui.style.plot_border_color = gmui_color_rgba_to_color_rgb(sPlotBorderColor);

					gmui_text("Plot Border Size"); gmui_same_line();
					global.gmui.style.plot_border_size = gmui_input_int(global.gmui.style.plot_border_size, 1, 0, 5);

					static sPlotGridColor = gmui_color_rgb_to_color_rgba(global.gmui.style.plot_grid_color);
					sPlotGridColor = gmui_color_button_4("Grid Color", sPlotGridColor);
					global.gmui.style.plot_grid_color = gmui_color_rgba_to_color_rgb(sPlotGridColor);

					gmui_text("Grid Thickness"); gmui_same_line();
					global.gmui.style.plot_grid_thickness = gmui_input_int(global.gmui.style.plot_grid_thickness, 1, 1, 5);

					gmui_text("Grid Steps"); gmui_same_line();
					global.gmui.style.plot_grid_steps = gmui_input_int(global.gmui.style.plot_grid_steps, 1, 2, 20);

					static sPlotTextColor = gmui_color_rgb_to_color_rgba(global.gmui.style.plot_text_color);
					sPlotTextColor = gmui_color_button_4("Text Color", sPlotTextColor);
					global.gmui.style.plot_text_color = gmui_color_rgba_to_color_rgb(sPlotTextColor);

					static sPlotLineColor = gmui_color_rgb_to_color_rgba(global.gmui.style.plot_line_color);
					sPlotLineColor = gmui_color_button_4("Line Color", sPlotLineColor);
					global.gmui.style.plot_line_color = gmui_color_rgba_to_color_rgb(sPlotLineColor);

					gmui_text("Line Thickness"); gmui_same_line();
					global.gmui.style.plot_line_thickness = gmui_input_int(global.gmui.style.plot_line_thickness, 1, 1, 10);

					static sPlotPointColor = gmui_color_rgb_to_color_rgba(global.gmui.style.plot_point_color);
					sPlotPointColor = gmui_color_button_4("Point Color", sPlotPointColor);
					global.gmui.style.plot_point_color = gmui_color_rgba_to_color_rgb(sPlotPointColor);

					gmui_text("Point Size"); gmui_same_line();
					global.gmui.style.plot_point_size = gmui_input_int(global.gmui.style.plot_point_size, 1, 2, 10);

					static sPlotFillColor = global.gmui.style.plot_fill_color;
					sPlotFillColor = gmui_color_button_4("Fill Color", sPlotFillColor);
					global.gmui.style.plot_fill_color = sPlotFillColor;

					gmui_text("Fill Enabled"); gmui_same_line();
					global.gmui.style.plot_fill_enabled = gmui_checkbox_box(global.gmui.style.plot_fill_enabled);

					static sPlotBarColor = gmui_color_rgb_to_color_rgba(global.gmui.style.plot_bar_color);
					sPlotBarColor = gmui_color_button_4("Bar Color", sPlotBarColor);
					global.gmui.style.plot_bar_color = gmui_color_rgba_to_color_rgb(sPlotBarColor);

					static sPlotBarBorderColor = gmui_color_rgb_to_color_rgba(global.gmui.style.plot_bar_border_color);
					sPlotBarBorderColor = gmui_color_button_4("Bar Border Color", sPlotBarBorderColor);
					global.gmui.style.plot_bar_border_color = gmui_color_rgba_to_color_rgb(sPlotBarBorderColor);

					gmui_text("Bar Border Size"); gmui_same_line();
					global.gmui.style.plot_bar_border_size = gmui_input_int(global.gmui.style.plot_bar_border_size, 1, 0, 5);

					gmui_text("Bar Rounding"); gmui_same_line();
					global.gmui.style.plot_bar_rounding = gmui_input_int(global.gmui.style.plot_bar_rounding, 1, 0, 10);

					gmui_text("Bar Spacing %"); gmui_same_line();
					global.gmui.style.plot_bar_spacing_ratio = gmui_input_float(global.gmui.style.plot_bar_spacing_ratio, 0.01, 0, 0.5, 80);

					gmui_text("Bar Gradient"); gmui_same_line();
					global.gmui.style.plot_bar_gradient = gmui_checkbox_box(global.gmui.style.plot_bar_gradient);

					static sPlotBarMinColor = gmui_color_rgb_to_color_rgba(global.gmui.style.plot_bar_min_color);
					sPlotBarMinColor = gmui_color_button_4("Bar Min Color", sPlotBarMinColor);
					global.gmui.style.plot_bar_min_color = gmui_color_rgba_to_color_rgb(sPlotBarMinColor);

					static sPlotBarMaxColor = gmui_color_rgb_to_color_rgba(global.gmui.style.plot_bar_max_color);
					sPlotBarMaxColor = gmui_color_button_4("Bar Max Color", sPlotBarMaxColor);
					global.gmui.style.plot_bar_max_color = gmui_color_rgba_to_color_rgb(sPlotBarMaxColor);

					static sPlotHistogramColor = gmui_color_rgb_to_color_rgba(global.gmui.style.plot_histogram_color);
					sPlotHistogramColor = gmui_color_button_4("Histogram Color", sPlotHistogramColor);
					global.gmui.style.plot_histogram_color = gmui_color_rgba_to_color_rgb(sPlotHistogramColor);

					gmui_text("Default Bins"); gmui_same_line();
					global.gmui.style.plot_histogram_default_bins = gmui_input_int(global.gmui.style.plot_histogram_default_bins, 1, 3, 20);

					static sPlotScatterColor = gmui_color_rgb_to_color_rgba(global.gmui.style.plot_scatter_color);
					sPlotScatterColor = gmui_color_button_4("Scatter Color", sPlotScatterColor);
					global.gmui.style.plot_scatter_color = gmui_color_rgba_to_color_rgb(sPlotScatterColor);

					gmui_text("Scatter Size"); gmui_same_line();
					global.gmui.style.plot_scatter_size = gmui_input_int(global.gmui.style.plot_scatter_size, 1, 2, 10);
					
					gmui_text("Context Menu Item Height");
					global.gmui.style.context_menu_item_height = gmui_input_int(global.gmui.style.context_menu_item_height, 1, 16, 44);
					
					static sContextMenuItemHoverBgColor = gmui_color_rgb_to_color_rgba(global.gmui.style.context_menu_item_hover_bg_color);
					sContextMenuItemHoverBgColor = gmui_color_button_4("Context Item Hover Bg Color", sContextMenuItemHoverBgColor);
					global.gmui.style.context_menu_item_hover_bg_color = gmui_color_rgba_to_color_rgb(sContextMenuItemHoverBgColor);
					
					static sContextMenuItemTextColor = gmui_color_rgb_to_color_rgba(global.gmui.style.context_menu_item_text_color);
					sContextMenuItemTextColor = gmui_color_button_4("Context Item Text Color", sContextMenuItemTextColor);
					global.gmui.style.context_menu_item_text_color = gmui_color_rgba_to_color_rgb(sContextMenuItemTextColor);
					
					static sContextMenuItemScTextColor = gmui_color_rgb_to_color_rgba(global.gmui.style.context_menu_item_short_cut_text_color);
					sContextMenuItemScTextColor = gmui_color_button_4("Context Item Sc Text Color", sContextMenuItemScTextColor);
					global.gmui.style.context_menu_item_short_cut_text_color = gmui_color_rgba_to_color_rgb(sContextMenuItemScTextColor);
					
					gmui_text("Context Menu Item Sub Arrow Thickness");
					global.gmui.style.context_menu_sub_arrow_thickness = gmui_input_int(global.gmui.style.context_menu_sub_arrow_thickness, 1, 1, 8);
                    
                    static sProgressBarBgColor = gmui_color_rgb_to_color_rgba(global.gmui.style.progress_bar_bg_color);
                    sProgressBarBgColor = gmui_color_button_4("Progress Bar BG", sProgressBarBgColor);
                    global.gmui.style.progress_bar_bg_color = gmui_color_rgba_to_color_rgb(sProgressBarBgColor);
                    
                    static sProgressBarFillColor = gmui_color_rgb_to_color_rgba(global.gmui.style.progress_bar_fill_color);
                    sProgressBarFillColor = gmui_color_button_4("Progress Bar Fill", sProgressBarFillColor);
                    global.gmui.style.progress_bar_fill_color = gmui_color_rgba_to_color_rgb(sProgressBarFillColor);
                    
                    static sProgressBarBorderColor = gmui_color_rgb_to_color_rgba(global.gmui.style.progress_bar_border_color);
                    sProgressBarBorderColor = gmui_color_button_4("Progress Bar Border", sProgressBarBorderColor);
                    global.gmui.style.progress_bar_border_color = gmui_color_rgba_to_color_rgb(sProgressBarBorderColor);
                    
                    gmui_text("Progress Bar Height"); gmui_same_line();
                    global.gmui.style.progress_bar_height = gmui_input_int(global.gmui.style.progress_bar_height, 1, 8, 48);
                    
                    gmui_text("Progress Bar Rounding"); gmui_same_line();
                    global.gmui.style.progress_bar_rounding = gmui_input_int(global.gmui.style.progress_bar_rounding, 1, 0, 20);
                    
                    gmui_text("Progress Bar Border Size"); gmui_same_line();
                    global.gmui.style.progress_bar_border_size = gmui_input_int(global.gmui.style.progress_bar_border_size, 1, 0, 5);
                    
                    // Progress Bar Text
                    static sProgressBarTextColor = gmui_color_rgb_to_color_rgba(global.gmui.style.progress_bar_text_color);
                    sProgressBarTextColor = gmui_color_button_4("Progress Text Color", sProgressBarTextColor);
                    global.gmui.style.progress_bar_text_color = gmui_color_rgba_to_color_rgb(sProgressBarTextColor);
                    
                    // Circular Progress Styles
                    static sProgressCircularBgColor = gmui_color_rgb_to_color_rgba(global.gmui.style.progress_circular_bg_color);
                    sProgressCircularBgColor = gmui_color_button_4("Circular BG Color", sProgressCircularBgColor);
                    global.gmui.style.progress_circular_bg_color = gmui_color_rgba_to_color_rgb(sProgressCircularBgColor);
                    
                    static sProgressCircularFillColor = gmui_color_rgb_to_color_rgba(global.gmui.style.progress_circular_fill_color);
                    sProgressCircularFillColor = gmui_color_button_4("Circular Fill Color", sProgressCircularFillColor);
                    global.gmui.style.progress_circular_fill_color = gmui_color_rgba_to_color_rgb(sProgressCircularFillColor);
                    
                    gmui_text("Circular Size"); gmui_same_line();
                    global.gmui.style.progress_circular_size = gmui_input_int(global.gmui.style.progress_circular_size, 1, 16, 100);
                    
                    gmui_text("Circular Thickness"); gmui_same_line();
                    global.gmui.style.progress_circular_thickness = gmui_input_int(global.gmui.style.progress_circular_thickness, 1, 1, 20);
                    
                    static sProgressCircularTextColor = gmui_color_rgb_to_color_rgba(global.gmui.style.progress_circular_text_color);
                    sProgressCircularTextColor = gmui_color_button_4("Circular Text Color", sProgressCircularTextColor);
                    global.gmui.style.progress_circular_text_color = gmui_color_rgba_to_color_rgb(sProgressCircularTextColor);
                    
                    gmui_text("Show Circular Text"); gmui_same_line();
                    global.gmui.style.progress_circular_show_text = gmui_checkbox_box(global.gmui.style.progress_circular_show_text);
                    
                    gmui_text("Animation Speed"); gmui_same_line();
                    global.gmui.style.progress_circular_animation_speed = gmui_input_float(global.gmui.style.progress_circular_animation_speed, 0.1, 0.1, 5.0, 80);
                    
                    gmui_text("Enable Gradient"); gmui_same_line();
                    global.gmui.style.progress_gradient_enabled = gmui_checkbox_box(global.gmui.style.progress_gradient_enabled);
                    
                    static sProgressGradientStartColor = gmui_color_rgb_to_color_rgba(global.gmui.style.progress_gradient_start_color);
                    sProgressGradientStartColor = gmui_color_button_4("Gradient Start", sProgressGradientStartColor);
                    global.gmui.style.progress_gradient_start_color = gmui_color_rgba_to_color_rgb(sProgressGradientStartColor);
                    
                    static sProgressGradientEndColor = gmui_color_rgb_to_color_rgba(global.gmui.style.progress_gradient_end_color);
                    sProgressGradientEndColor = gmui_color_button_4("Gradient End", sProgressGradientEndColor);
                    global.gmui.style.progress_gradient_end_color = gmui_color_rgba_to_color_rgb(sProgressGradientEndColor);

		            gmui_end();
		        }
		    }
    
		    gmui_collapsing_header_end();
		}
		
        // Demo window footer
        gmui_separator();
        gmui_text("GMUI Demo Window");
        gmui_text_disabled("Right-click to close");
        
        // Close demo window on right-click
        if (gmui_is_mouse_over_window(global.gmui.current_window) && global.gmui.mouse_released[1]) {
            global.gmui.current_window.open = false;
        }
        
        gmui_end();
    }
}

//////////////////////////////////////
// MATH (Color conversions, math helpers)
//////////////////////////////////////
function gmui_array_clear(array) {
	var length = array_length(array);
	if (length == 0) { return; }
	for (var i = 0; i < length; i++) {
	    array_delete(array, i, 1);
		i--;
		length--;
	}
}

function gmui_lerp_color(color1, color2, t) {
    var r1 = color_get_red(color1);
    var g1 = color_get_green(color1);
    var b1 = color_get_blue(color1);
    
    var r2 = color_get_red(color2);
    var g2 = color_get_green(color2);
    var b2 = color_get_blue(color2);
    
    var r = lerp(r1, r2, t);
    var g = lerp(g1, g2, t);
    var b = lerp(b1, b2, t);
    
    return make_color_rgb(r, g, b);
}

function gmui_make_color_rgba(r, g, b, a) {
    r = clamp(r, 0, 255);
    g = clamp(g, 0, 255);
    b = clamp(b, 0, 255);
    a = clamp(a, 0, 255);

    // Combine RGBA into a single 32-bit integer
    return (a << 24) | (r << 16) | (g << 8) | b;
}

function gmui_rgba_to_hsva(r, g, b, a)
{
    // Normalize RGB to [0, 1]
    var rf = r / 255;
    var gf = g / 255;
    var bf = b / 255;

    // Find min/max
    var maxc = max(rf, max(gf, bf));
    var minc = min(rf, min(gf, bf));
    var delta = maxc - minc;

    var h, s, v;
    v = maxc;

    // Saturation
    if (maxc == 0) s = 0;
    else s = delta / maxc;

    // Hue
    if (delta == 0) {
        h = 0;
    } else if (maxc == rf) {
        h = ((gf - bf) / delta) % 6;
    } else if (maxc == gf) {
        h = ((bf - rf) / delta) + 2;
    } else {
        h = ((rf - gf) / delta) + 4;
    }

    h = (h / 6);
    if (h < 0) h += 1;

	return [h, s, v, a];
}

function gmui_hsva_to_rgba(h, s, v, a)
{
    h = frac(h) * 6; // ensure hue in [0,6)
    var i = floor(h);
    var f = h - i;
    var p = v * (1 - s);
    var q = v * (1 - s * f);
    var t = v * (1 - s * (1 - f));

    var rf, gf, bf;
    switch (i) {
        case 0: rf = v; gf = t; bf = p; break;
        case 1: rf = q; gf = v; bf = p; break;
        case 2: rf = p; gf = v; bf = t; break;
        case 3: rf = p; gf = q; bf = v; break;
        case 4: rf = t; gf = p; bf = v; break;
        default: rf = v; gf = p; bf = q; break;
    }

    return [
        clamp(rf * 255, 0, 255),
        clamp(gf * 255, 0, 255),
        clamp(bf * 255, 0, 255),
        clamp(a, 0, 255)
    ];
}

function gmui_color_rgba_to_array(color) {
	var a = (color >> 24) & 255;
	var r = (color >> 16) & 255;
	var g = (color >> 8) & 255;
	var b = color & 255;
    return [r, g, b, a];
}

function gmui_array_to_color_rgba(rgba) {
    var r = clamp(rgba[0], 0, 255);
    var g = clamp(rgba[1], 0, 255);
    var b = clamp(rgba[2], 0, 255);
    var a = clamp(rgba[3], 0, 255);
    return gmui_make_color_rgba(r, g, b, a);
}

function gmui_color_rgba_to_color_rgb(rgba) {
	var a = (rgba >> 24) & 255;
	var r = (rgba >> 16) & 255;
	var g = (rgba >> 8) & 255;
	var b = rgba & 255;
	return make_color_rgb(r, g, b);
};

function gmui_color_rgb_to_color_rgba(rgb, alpha = 255) {
    var r = color_get_red(rgb);
    var g = color_get_green(rgb);
    var b = color_get_blue(rgb);
    return gmui_make_color_rgba(r, g, b, alpha);
}

/************************************
 * STYLES
 ***********************************/
// TODO: DO THIS

/************************************
 * WINS
 ***********************************/

enum gmui_wins_split_dir {
	LEFT,
	RIGHT,
	UP,
	DOWN,
};

enum gmui_wins_cut_axis {
	HORIZONTAL,
	VERTICAL,
};

function gmui_wins_node_create(x, y, width, height, parent = undefined) {
	var node = {
		x: x, 
		y: y, 
		width: width, 
		height: height, 
		children: undefined, 
		ratio: 0.5, 
		cut_axis: undefined, 
		split_direction: undefined, 
		target_window: undefined, 
		parent: parent, 
		is_dragging: false, 
		drag_start_mouse_x: 0, 
		drag_start_mouse_y: 0, 
		drag_start_ratio: 0.5, 
        visual_x: x, 
        visual_y: y, 
        visual_width: width, 
        visual_height: height, 
	};
	
	return node;
};

function gmui_wins_node_split(node, dir, ratio = 0.5) {
    var split_axis = (dir == gmui_wins_split_dir.LEFT || dir == gmui_wins_split_dir.RIGHT) ? 0 : 1;
    var gap = global.gmui.wins_gap;
    
    var primary_node = undefined;
    var secondary_node = undefined;
    
    switch (split_axis) {
    case 0: {
        var usable_width = node.visual_width;
        var primary_width = usable_width * ratio;
        var secondary_width = usable_width * (1.0 - ratio);
        
        var primary_container = undefined;
        var secondary_container = undefined;
        
        if (dir == gmui_wins_split_dir.LEFT) {
            primary_container = [ node.visual_x, node.visual_y, primary_width - gap/2, node.visual_height ];
            secondary_container = [ node.visual_x + primary_width + gap/2, node.visual_y, secondary_width - gap/2, node.visual_height ];
        }
        else if (dir == gmui_wins_split_dir.RIGHT) {
            primary_container = [ node.visual_x + secondary_width + gap/2, node.visual_y, primary_width - gap/2, node.visual_height ];
            secondary_container = [ node.visual_x, node.visual_y, secondary_width - gap/2, node.visual_height ];
        };
        
        primary_node = gmui_wins_node_create(primary_container[0], primary_container[1], primary_container[2], primary_container[3], node);
        secondary_node = gmui_wins_node_create(secondary_container[0], secondary_container[1], secondary_container[2], secondary_container[3], node);
        
        node.cut_axis = gmui_wins_cut_axis.VERTICAL;
        node.ratio = ratio;
        node.split_direction = dir;
        
        node.children = [ primary_node, secondary_node ];
    } break;
    case 1: {
        var usable_height = node.visual_height;
        var primary_height = usable_height * ratio;
        var secondary_height = usable_height * (1.0 - ratio);
        
        var primary_container = undefined;
        var secondary_container = undefined;
        
        if (dir == gmui_wins_split_dir.UP) {
            primary_container = [ node.visual_x, node.visual_y, node.visual_width, primary_height - gap/2 ];
            secondary_container = [ node.visual_x, node.visual_y + primary_height + gap/2, node.visual_width, secondary_height - gap/2 ];
        }
        else if (dir == gmui_wins_split_dir.DOWN) {
            primary_container = [ node.visual_x, node.visual_y + secondary_height + gap/2, node.visual_width, primary_height - gap/2 ];
            secondary_container = [ node.visual_x, node.visual_y, node.visual_width, secondary_height - gap/2 ];
        };
        
        primary_node = gmui_wins_node_create(primary_container[0], primary_container[1], primary_container[2], primary_container[3], node);
        secondary_node = gmui_wins_node_create(secondary_container[0], secondary_container[1], secondary_container[2], secondary_container[3], node);
        
        node.cut_axis = gmui_wins_cut_axis.HORIZONTAL;
        node.ratio = ratio;
        node.split_direction = dir;
        
        node.children = [ primary_node, secondary_node ];
    } break;
    };
    
    return [ primary_node, secondary_node ];
}

function gmui_wins_node_set(node, window_name) {
	var window = gmui_get_window(window_name);
	node.target_window = window;
}

function gmui_wins_node_update(node) {
    // update its children
    if (node.children != undefined) {
        gmui_wins_handle_splitter_drag(node); // update ratio
        
        // recalculate child dimensions based on current parent dimensions and ratio
        gmui_wins_recalculate_children(node);
        
        gmui_wins_node_update(node.children[0]);
        gmui_wins_node_update(node.children[1]);
    };
    
    // update its target window (setting it directly might cause bugs)
    var window = node.target_window;
    if (window != undefined) {
        var resize_surface = window.width != node.visual_width || window.height != node.visual_height;
    
        window.x = node.visual_x;
        window.y = node.visual_y;
        window.width = node.visual_width;
        window.height = node.visual_height;
        if (resize_surface) { gmui_create_surface(window); };
    };
}

function gmui_wins_resize_parent_node(parent_node, x, y, width, height) {
	parent_node.x = x;
	parent_node.y = y;
	parent_node.width = width;
	parent_node.height = height;
	parent_node.visual_x = x + global.gmui.wins_gap / 2;
	parent_node.visual_y = y + global.gmui.wins_gap / 2;
	parent_node.visual_width = parent_node.width + global.gmui.wins_gap / 2;
	parent_node.visual_height = parent_node.height + global.gmui.wins_gap / 2;
};

function gmui_wins_recalculate_children(parent_node) { // should work fine now
    if (parent_node.children == undefined || array_length(parent_node.children) != 2) return;
    
    var child_a = parent_node.children[0];
    var child_b = parent_node.children[1];
    var gap = global.gmui.wins_gap;
    
    if (parent_node.cut_axis == gmui_wins_cut_axis.VERTICAL) {
        // Vertical split - left/right
        var primary_width = parent_node.visual_width * parent_node.ratio;
        var secondary_width = parent_node.visual_width * (1.0 - parent_node.ratio);
        
        var left_child = child_a;
        var right_child = child_b;
        var left_width = primary_width;
        var right_width = secondary_width;
        
        if (parent_node.split_direction == gmui_wins_split_dir.RIGHT) {
            // For RIGHT split:
            // - children[0] is RIGHT (with primary_width = ratio)
            // - children[1] is LEFT (with secondary_width = 1-ratio)
            left_child = child_b;
            right_child = child_a;
            left_width = secondary_width;  // LEFT gets 1-ratio
            right_width = primary_width;   // RIGHT gets ratio
        }
        
        // LEFT child
        left_child.visual_x = parent_node.visual_x;
        left_child.visual_y = parent_node.visual_y;
        left_child.visual_width = left_width - gap/2;
        left_child.visual_height = parent_node.visual_height;
        
        // RIGHT child
        right_child.visual_x = parent_node.visual_x + left_width + gap/2;
        right_child.visual_y = parent_node.visual_y;
        right_child.visual_width = right_width - gap/2;
        right_child.visual_height = parent_node.visual_height;
        
    } else if (parent_node.cut_axis == gmui_wins_cut_axis.HORIZONTAL) {
        // Horizontal split - up/down
        var primary_height = parent_node.visual_height * parent_node.ratio;
        var secondary_height = parent_node.visual_height * (1.0 - parent_node.ratio);
        
        var top_child = child_a;
        var bottom_child = child_b;
        var top_height = primary_height;
        var bottom_height = secondary_height;
        
        if (parent_node.split_direction == gmui_wins_split_dir.DOWN) {
            // For DOWN split:
            // - children[0] is BOTTOM (with primary_height = ratio)
            // - children[1] is TOP (with secondary_height = 1-ratio)
            top_child = child_b;
            bottom_child = child_a;
            top_height = secondary_height;  // TOP gets 1-ratio
            bottom_height = primary_height; // BOTTOM gets ratio
        }
        
        // TOP child
        top_child.visual_x = parent_node.visual_x;
        top_child.visual_y = parent_node.visual_y;
        top_child.visual_width = parent_node.visual_width;
        top_child.visual_height = top_height - gap/2;
        
        // BOTTOM child
        bottom_child.visual_x = parent_node.visual_x;
        bottom_child.visual_y = parent_node.visual_y + top_height + gap/2;
        bottom_child.visual_width = parent_node.visual_width;
        bottom_child.visual_height = bottom_height - gap/2;
    }
    
    // Update actual node dimensions (for splitter calculations)
    child_a.x = child_a.visual_x;
    child_a.y = child_a.visual_y;
    child_a.width = child_a.visual_width;
    child_a.height = child_a.visual_height;
    
    child_b.x = child_b.visual_x;
    child_b.y = child_b.visual_y;
    child_b.width = child_b.visual_width;
    child_b.height = child_b.visual_height;
}

function gmui_wins_handle_splitter_drag(parent_node) { // had to go trough from basics and calculate everything, this should work fine
    if (parent_node.children == undefined || array_length(parent_node.children) != 2) return;
    
    var child_a = parent_node.children[0];
    var child_b = parent_node.children[1];
    
    // Calculate splitter bounds using VISUAL coordinates
    var splitter_bounds = undefined;
    var splitter_size = 8;
    
    if (parent_node.cut_axis == gmui_wins_cut_axis.VERTICAL) {
        // Determine which child is left and which is right
        var left_child = child_a;
        var right_child = child_b;
        if (child_a.visual_x > child_b.visual_x) {
            left_child = child_b;
            right_child = child_a;
        }
        
        var splitter_x = left_child.visual_x + left_child.visual_width;
        splitter_bounds = [
            splitter_x - splitter_size / 2, 
            parent_node.visual_y, 
            splitter_x + splitter_size / 2, 
            parent_node.visual_y + parent_node.visual_height
        ];
        
        // Check if mouse is over splitter (use screen coordinates)
        var mouse_over_splitter = gmui_is_point_in_rect(global.gmui.mouse_pos[0], global.gmui.mouse_pos[1], splitter_bounds) && 
                                 (global.gmui.hovering_window != undefined && global.gmui.hovering_window.name == "##splitters_window");
        
        // Handle dragging
        if (mouse_over_splitter && global.gmui.mouse_clicked[0]) {
            parent_node.is_dragging = true;
            parent_node.drag_start_mouse_x = global.gmui.mouse_pos[0];
            parent_node.drag_start_mouse_y = global.gmui.mouse_pos[1];
            parent_node.drag_start_ratio = parent_node.ratio;
        }
        
        if (parent_node.is_dragging && global.gmui.mouse_down[0]) {
            // Calculate new ratio
            var mouse_delta_x = global.gmui.mouse_pos[0] - parent_node.drag_start_mouse_x;
            var total_width = parent_node.visual_width;
            var ratio_delta = mouse_delta_x / total_width;
            
            // The ratio always represents the size of the LEFT child
            // For LEFT split: ratio = left child width
            // For RIGHT split: ratio = right child width (since children are swapped in recalculate)
            
            if (parent_node.split_direction == gmui_wins_split_dir.LEFT) {
                // LEFT split: dragging right increases left child width
                parent_node.ratio = clamp(parent_node.drag_start_ratio + ratio_delta, 0.01, 0.99);
            } else if (parent_node.split_direction == gmui_wins_split_dir.RIGHT) {
                // RIGHT split: dragging right decreases left child width (increases right child)
                // Since ratio represents right child width for RIGHT splits
                parent_node.ratio = clamp(parent_node.drag_start_ratio - ratio_delta, 0.01, 0.99);
            }
            
            // Recalculate children dimensions immediately during drag
            gmui_wins_recalculate_children(parent_node);
        } else {
            parent_node.is_dragging = false;
        }
        
    } else if (parent_node.cut_axis == gmui_wins_cut_axis.HORIZONTAL) {
        // Determine which child is top and which is bottom
        var top_child = child_a;
        var bottom_child = child_b;
        if (child_a.visual_y > child_b.visual_y) {
            top_child = child_b;
            bottom_child = child_a;
        }
        
        var splitter_y = top_child.visual_y + top_child.visual_height;
        splitter_bounds = [
            parent_node.visual_x, 
            splitter_y - splitter_size / 2, 
            parent_node.visual_x + parent_node.visual_width, 
            splitter_y + splitter_size / 2
        ];
        
        // Check if mouse is over splitter (use screen coordinates)
        var mouse_over_splitter = gmui_is_point_in_rect(global.gmui.mouse_pos[0], global.gmui.mouse_pos[1], splitter_bounds) && 
                                 (global.gmui.hovering_window != undefined && global.gmui.hovering_window.name == "##splitters_window");
        
        // Handle dragging
        if (mouse_over_splitter && global.gmui.mouse_clicked[0]) {
            parent_node.is_dragging = true;
            parent_node.drag_start_mouse_x = global.gmui.mouse_pos[0];
            parent_node.drag_start_mouse_y = global.gmui.mouse_pos[1];
            parent_node.drag_start_ratio = parent_node.ratio;
        }
        
        if (parent_node.is_dragging && global.gmui.mouse_down[0]) {
            // Calculate new ratio
            var mouse_delta_y = global.gmui.mouse_pos[1] - parent_node.drag_start_mouse_y;
            var total_height = parent_node.visual_height;
            var ratio_delta = mouse_delta_y / total_height;
            
            // The ratio always represents the size of the TOP child
            // For UP split: ratio = top child height
            // For DOWN split: ratio = bottom child height (since children are swapped in recalculate)
            
            if (parent_node.split_direction == gmui_wins_split_dir.UP) {
                // UP split: dragging down increases top child height
                parent_node.ratio = clamp(parent_node.drag_start_ratio + ratio_delta, 0.01, 0.99);
            } else if (parent_node.split_direction == gmui_wins_split_dir.DOWN) {
                // DOWN split: dragging down decreases top child height (increases bottom child)
                // Since ratio represents bottom child height for DOWN splits
                parent_node.ratio = clamp(parent_node.drag_start_ratio - ratio_delta, 0.01, 0.99);
            }
            
            // Recalculate children dimensions immediately during drag
            gmui_wins_recalculate_children(parent_node);
        } else {
            parent_node.is_dragging = false;
        }
    }
}

function gmui_wins_handle_splitters(node) {
    if (gmui_begin("##splitters_window", 0, 0, surface_get_width(application_surface), surface_get_height(application_surface), 
                   gmui_window_flags.NO_TITLE_BAR | gmui_window_flags.NO_MOVE | gmui_window_flags.NO_MOVE_DEPTH | gmui_window_flags.NO_RESIZE | gmui_window_flags.NO_SCROLLBAR)) {
        
		global.gmui.current_window.x = 0;
		global.gmui.current_window.y = 0;
		global.gmui.current_window.width = surface_get_width(application_surface);
		global.gmui.current_window.height = surface_get_height(application_surface);
		// might need to recreate surface in case of application window resize
		// but its just a placeholder, shouldnt be a need for it?
		
        gmui_wins_handle_splitters_recursive(node);
		
		if (global.gmui.current_window.z_index != 0) {
			gmui_send_window_to_back(global.gmui.current_window);
		};
        
        gmui_end();
    }
}

function gmui_wins_handle_splitters_recursive(node) {
    if (node.children == undefined || array_length(node.children) != 2) return;
    
    var child_a = node.children[0];
    var child_b = node.children[1];
    var style = global.gmui.style;
    
    var splitter_bounds = undefined;
    var splitter_size = 8;
    
    var splitter_color = style.wins_splitter_color;
    var splitter_hover_color = style.wins_splitter_hover_color;
    var splitter_active_color = style.wins_splitter_active_color;
    
    if (node.cut_axis == gmui_wins_cut_axis.VERTICAL) {
        // Determine which child is actually on the left
        var left_child = child_a;
        var right_child = child_b;
        
        if (child_a.visual_x > child_b.visual_x) { // Just to be sure
            left_child = child_b;
            right_child = child_a;
        }
        
        // Splitter is at the end of the left child
        var splitter_x = left_child.visual_x + left_child.visual_width;
        
        // Use the parent's VISUAL coordinates for bounds
        splitter_bounds = [
            splitter_x - splitter_size / 2, 
            node.visual_y, 
            splitter_x + splitter_size / 2, 
            node.visual_y + node.visual_height
        ];
        
        // Check if mouse is over this splitter
        var mouse_over_splitter = gmui_is_point_in_rect(global.gmui.mouse_pos[0], global.gmui.mouse_pos[1], splitter_bounds) && 
                                 (global.gmui.hovering_window != undefined && global.gmui.hovering_window.name == "##splitters_window");
        
        var is_active = node.is_dragging;
        
        // Choose color based on state
        var draw_color = splitter_color;
        if (is_active) {
            draw_color = splitter_active_color;
        } else if (mouse_over_splitter) {
            draw_color = splitter_hover_color;
        }
        
        // Draw visible splitter line
        // Main line
        gmui_add_line(splitter_x, splitter_bounds[1], splitter_x, splitter_bounds[3], draw_color, 2);
        
        // Handle dots
        var dot_spacing = 6;
        var dot_count = 3;
        var total_dot_height = (dot_count - 1) * dot_spacing;
        var start_y = splitter_bounds[1] + (splitter_bounds[3] - splitter_bounds[1] - total_dot_height) / 2;
        
        for (var i = 0; i < dot_count; i++) {
            var dot_y = start_y + i * dot_spacing;
            gmui_add_rect(splitter_x - 2, dot_y, 4, 4, draw_color);
        }
        
        // Set cursor if hovering
        if (mouse_over_splitter || node.is_dragging) {
            window_set_cursor(cr_size_we);
        }
        
    } else if (node.cut_axis == gmui_wins_cut_axis.HORIZONTAL) {
        // Determine which child is actually on top
        var top_child = child_a;
        var bottom_child = child_b;
        
        if (child_a.visual_y > child_b.visual_y) { // Just to be sure
            top_child = child_b;
            bottom_child = child_a;
        }
        
        // Splitter is at the bottom of the top child
        var splitter_y = top_child.visual_y + top_child.visual_height;
        
        splitter_bounds = [
            node.visual_x, 
            splitter_y - splitter_size / 2, 
            node.visual_x + node.visual_width, 
            splitter_y + splitter_size / 2
        ];
        
        // Check if mouse is over this splitter
        var mouse_over_splitter = gmui_is_point_in_rect(global.gmui.mouse_pos[0], global.gmui.mouse_pos[1], splitter_bounds) && 
                                 (global.gmui.hovering_window != undefined && global.gmui.hovering_window.name == "##splitters_window");
        
        var is_active = node.is_dragging;
        
        // Choose color based on state
        var draw_color = splitter_color;
        if (is_active) {
            draw_color = splitter_active_color;
        } else if (mouse_over_splitter) {
            draw_color = splitter_hover_color;
        }
        
        // Draw visible splitter line
        // Main line
        gmui_add_line(splitter_bounds[0], splitter_y, splitter_bounds[2], splitter_y, draw_color, 2);
        
        // Handle dots
        var dot_spacing = 6;
        var dot_count = 3;
        var total_dot_width = (dot_count - 1) * dot_spacing;
        var start_x = splitter_bounds[0] + (splitter_bounds[2] - splitter_bounds[0] - total_dot_width) / 2;
        
        for (var i = 0; i < dot_count; i++) {
            var dot_x = start_x + i * dot_spacing;
            gmui_add_rect(dot_x, splitter_y - 2, 4, 4, draw_color);
        }
        
        // Set cursor if hovering
        if (mouse_over_splitter || node.is_dragging) {
            window_set_cursor(cr_size_ns);
        }
    }
    
    // Recursively handle splitters for children
    gmui_wins_handle_splitters_recursive(child_a);
    gmui_wins_handle_splitters_recursive(child_b);
}

/************************************
 * GMUILITE SEARCH
 ***********************************/
function gmui_ls_init() { // Being called in gmui_init by default
    if (global.gmui.lite_search == undefined) {
        global.gmui.lite_search = {
            // Core data structures
            inverted_index: ds_map_create(),      // word -> document IDs
            documents: ds_map_create(),           // doc_id -> document data
            word_stats: ds_map_create(),          // word -> frequency stats
            doc_count: 0,
            
            // Configuration
            case_sensitive: false,
            enable_stemming: false,
            min_word_length: 2,
            stop_words: ds_list_create(),
            
            // UI settings
            search_window_width: 400,
            search_window_height: 300,
            max_visible_results: 10,
            result_item_height: 24
        };
        
        // Initialize common stop words
        var _stop_words = ["a", "an", "the", "and", "or", "but", "in", "on", "at", "to", "for", "of", "with", "by"];
        for (var i = 0; i < array_length(_stop_words); i++) {
            ds_list_add(global.gmui.lite_search.stop_words, _stop_words[i]);
        }
    }
}

function gmui_ls_get() {
    return global.gmui.lite_search;
}

function gmui_ls_add_document(_id, _text, _metadata = undefined) {
    if (global.gmui.lite_search == undefined) return false;
    
    var ls = global.gmui.lite_search;
    
    if (is_undefined(_metadata)) {
        _metadata = {
            title: "",
            tags: [],
            timestamp: current_time
        };
    }
    
    // Store document
    ds_map_add(ls.documents, _id, {
        id: _id,
        text: _text,
        metadata: _metadata,
        word_count: 0
    });
    
    // Process and index text
    var _words = _gmui_ls_process_text(_text);
    var _doc_words = ds_map_create();
    
    // Count word frequencies in this document
    for (var i = 0; i < array_length(_words); i++) {
        var _word = _words[i];
        
        if (!ds_map_exists(_doc_words, _word)) {
            ds_map_add(_doc_words, _word, 0);
        }
        ds_map_set(_doc_words, _word, ds_map_find_value(_doc_words, _word) + 1);
    }
    
    // Update inverted index
    var _keys = ds_map_find_first(_doc_words);
    while (!is_undefined(_keys)) {
        var _word = _keys;
        var _freq = ds_map_find_value(_doc_words, _word);
        
        // Add to inverted index
        if (!ds_map_exists(ls.inverted_index, _word)) {
            ds_map_add(ls.inverted_index, _word, ds_map_create());
        }
        
        var _word_docs = ds_map_find_value(ls.inverted_index, _word);
        ds_map_add(_word_docs, _id, _freq);
        
        // Update word statistics
        if (!ds_map_exists(ls.word_stats, _word)) {
            ds_map_add(ls.word_stats, _word, {
                total_frequency: 0,
                document_frequency: 0
            });
        }
        
        var _stats = ds_map_find_value(ls.word_stats, _word);
        _stats.total_frequency += _freq;
        _stats.document_frequency++;
        
        _keys = ds_map_find_next(_doc_words, _keys);
    }
    
    // Update document word count
    var _doc = ds_map_find_value(ls.documents, _id);
    _doc.word_count = ds_map_size(_doc_words);
    
    ds_map_destroy(_doc_words);
    ls.doc_count++;
    
    return true;
}

function gmui_ls_add_document_enhanced(_id, _text, _metadata = undefined) { // includes title and tags to the search
    if (global.gmui.lite_search == undefined) return false;
    
    var ls = global.gmui.lite_search;
    
    if (is_undefined(_metadata)) {
        _metadata = {
            title: "",
            tags: [],
            timestamp: current_time
        };
    }
    
    // Combination
    var _searchable_text = _text;
    
    // Add title (repeat 2x for higher weight)
    if (_metadata.title != "") {
        _searchable_text += " " + _metadata.title + " " + _metadata.title;
    }
    
    // Add tags (repeat 2x for higher weight)
    if (variable_struct_exists(_metadata, "tags")) {
        for (var i = 0; i < array_length(_metadata.tags); i++) {
            _searchable_text += " " + _metadata.tags[i] + " " + _metadata.tags[i];
        }
    }
    
    // Add other metadata fields if you want them searchable
    if (variable_struct_exists(_metadata, "author")) {
        _searchable_text += " " + _metadata.author;
    }
    if (variable_struct_exists(_metadata, "category")) {
        _searchable_text += " " + _metadata.category;
    }
    
    // Now add the document with combined text
    return gmui_ls_add_document(_id, _searchable_text, _metadata);
}

function gmui_ls_add_document_weighted(_id, _text, _metadata = undefined) {
    if (global.gmui.lite_search == undefined) return false;
    
    var ls = global.gmui.lite_search;
    
    if (is_undefined(_metadata)) {
        _metadata = {
            title: "",
            tags: [],
            timestamp: current_time
        };
    }
    
    // Combination
    var _searchable_text = "";
    
    // Content weight: 1x (normal)
    _searchable_text += _text + " ";
    
    // Title weight: 3x (very important)
    if (_metadata.title != "") {
        _searchable_text += _metadata.title + " " + _metadata.title + " " + _metadata.title + " ";
    }
    
    // Tags weight: 2x (important)
    if (variable_struct_exists(_metadata, "tags")) {
        for (var i = 0; i < array_length(_metadata.tags); i++) {
            _searchable_text += _metadata.tags[i] + " " + _metadata.tags[i] + " ";
        }
    }
    
    // Author/description weight: 1x (normal)
    if (variable_struct_exists(_metadata, "author")) {
        _searchable_text += _metadata.author + " ";
    }
    if (variable_struct_exists(_metadata, "description")) {
        _searchable_text += _metadata.description + " ";
    }
    
    // Use original function with weighted text
    return gmui_ls_add_document(_id, _searchable_text, _metadata);
}

function gmui_ls_search(_query, _max_results = -1) {
    if (global.gmui.lite_search == undefined) return [];
    
    var ls = global.gmui.lite_search;
    var _query_terms = _gmui_ls_process_text(_query);
    if (array_length(_query_terms) == 0) {
        return [];
    }
    
    // Get document scores
    var _doc_scores = ds_map_create();
    var _doc_matches = ds_map_create();
    
    for (var i = 0; i < array_length(_query_terms); i++) {
        var _term = _query_terms[i];
        
        if (ds_map_exists(ls.inverted_index, _term)) {
            var _term_docs = ds_map_find_value(ls.inverted_index, _term);
            var _doc_id = ds_map_find_first(_term_docs);
            
            while (!is_undefined(_doc_id)) {
                var _tf = ds_map_find_value(_term_docs, _doc_id);
				
				var _doc_freq = ds_map_find_value(ls.word_stats, _term).document_frequency;
				var _base_score = max(1, 100 - _doc_freq * 10);
				
				//var _doc_freq = ds_map_find_value(ls.word_stats, _term).document_frequency;
				//var _idf = 1.0 / (1.0 + _doc_freq);
				
                //var _idf = log10(ls.doc_count / (1 + ds_map_find_value(ls.word_stats, _term).document_frequency));
                
                // TF-IDF scoring
               // var _score = _tf * _idf;
				var _score = _tf * _base_score;
                
                if (!ds_map_exists(_doc_scores, _doc_id)) {
                    ds_map_add(_doc_scores, _doc_id, 0);
                    ds_map_add(_doc_matches, _doc_id, ds_list_create());
                }
                
                ds_map_set(_doc_scores, _doc_id, ds_map_find_value(_doc_scores, _doc_id) + _score);
                ds_list_add(ds_map_find_value(_doc_matches, _doc_id), _term);
                
                _doc_id = ds_map_find_next(_term_docs, _doc_id);
            }
        }
    }
    
    // Convert to array and sort
    var _results = [];
    var _doc_id = ds_map_find_first(_doc_scores);
    
    while (!is_undefined(_doc_id)) {
        var _doc = ds_map_find_value(ls.documents, _doc_id);
        var _score = ds_map_find_value(_doc_scores, _doc_id);
        var _matched_terms = ds_map_find_value(_doc_matches, _doc_id);
        
        array_push(_results, {
            id: _doc_id,
            score: _score,
            document: _doc,
            matched_terms: _gmui_ls_array_from_list(_matched_terms),
            snippet: _gmui_ls_generate_snippet(_doc.text, _query_terms)
        });
        
        _doc_id = ds_map_find_next(_doc_scores, _doc_id);
    }
    
    // Sort by score (descending)
    array_sort(_results, function(a, b) {
        return b.score - a.score;
    });
    
    // Clean up
    var _doc_id = ds_map_find_first(_doc_matches);
    while (!is_undefined(_doc_id)) {
        ds_list_destroy(ds_map_find_value(_doc_matches, _doc_id));
        _doc_id = ds_map_find_next(_doc_matches, _doc_id);
    }
    
    ds_map_destroy(_doc_scores);
    ds_map_destroy(_doc_matches);
    
    // Limit results
    if (_max_results != -1 && array_length(_results) > _max_results) {
        array_resize(_results, _max_results);
    }
    
    // Store results for UI
    ls.search_results = _results;
    ls.selected_result = -1;
    
    return _results;
}

function gmui_ls_fuzzy_search(_query, _max_results = 50, _threshold = 0.7) {
    if (global.gmui.lite_search == undefined) return [];
    
    var ls = global.gmui.lite_search;
    var _query_terms = _gmui_ls_process_text(_query);
    if (array_length(_query_terms) == 0) {
        return [];
    }
    
    var _results_map = ds_map_create();
    
    // Get all words from index
    var _all_words = ds_map_find_first(ls.inverted_index);
    while (!is_undefined(_all_words)) {
        // Check similarity with each query term
        for (var i = 0; i < array_length(_query_terms); i++) {
            var _similarity = _gmui_ls_calculate_similarity(_all_words, _query_terms[i]);
            
            if (_similarity >= _threshold) {
                // Add documents containing this similar word
                var _term_docs = ds_map_find_value(ls.inverted_index, _all_words);
                var _doc_id = ds_map_find_first(_term_docs);
                
                while (!is_undefined(_doc_id)) {
                    if (!ds_map_exists(_results_map, _doc_id)) {
                        ds_map_add(_results_map, _doc_id, 0);
                    }
                    
                    ds_map_set(_results_map, _doc_id, 
                        ds_map_find_value(_results_map, _doc_id) + _similarity);
                    
                    _doc_id = ds_map_find_next(_term_docs, _doc_id);
                }
            }
        }
        
        _all_words = ds_map_find_next(ls.inverted_index, _all_words);
    }
    
    // Convert to results array
    var _results = [];
    var _doc_id = ds_map_find_first(_results_map);
    
    while (!is_undefined(_doc_id)) {
        var _doc = ds_map_find_value(ls.documents, _doc_id);
        var _score = ds_map_find_value(_results_map, _doc_id);
        
        array_push(_results, {
            id: _doc_id,
            score: _score,
            document: _doc,
            snippet: _gmui_ls_generate_snippet(_doc.text, _query_terms)
        });
        
        _doc_id = ds_map_find_next(_results_map, _doc_id);
    }
    
    // Sort and limit
    array_sort(_results, function(a, b) {
        return b.score - a.score;
    });
    
    ds_map_destroy(_results_map);
    
    if (array_length(_results) > _max_results) {
        array_resize(_results, _max_results);
    }
    
    // Store results for UI
    ls.search_results = _results;
    ls.selected_result = -1;
    
    return _results;
}

function gmui_ls_remove_document(_id) {
    if (global.gmui.lite_search == undefined) return false;
    
    var ls = global.gmui.lite_search;
    
    if (!ds_map_exists(ls.documents, _id)) {
        return false;
    }
    
    // Remove from inverted index
    var _word = ds_map_find_first(ls.inverted_index);
    while (!is_undefined(_word)) {
        var _word_docs = ds_map_find_value(ls.inverted_index, _word);
        
        if (ds_map_exists(_word_docs, _id)) {
            ds_map_delete(_word_docs, _id);
            
            // Update word stats
            var _stats = ds_map_find_value(ls.word_stats, _word);
            _stats.document_frequency--;
            _stats.total_frequency -= ds_map_find_value(_word_docs, _id);
            
            // Remove word if no documents left
            if (ds_map_size(_word_docs) == 0) {
                ds_map_delete(ls.inverted_index, _word);
                ds_map_delete(ls.word_stats, _word);
            }
        }
        
        _word = ds_map_find_next(ls.inverted_index, _word);
    }
    
    // Remove document
    ds_map_delete(ls.documents, _id);
    ls.doc_count--;
    
    return true;
}

function gmui_ls_get_stats() {
    if (global.gmui.lite_search == undefined) return undefined;
    
    var ls = global.gmui.lite_search;
    return {
        document_count: ls.doc_count,
        unique_words: ds_map_size(ls.inverted_index),
        total_words: _gmui_ls_sum_word_frequencies()
    };
}

function gmui_ls_set_config(_case_sensitive, _enable_stemming, _min_word_length) {
    if (global.gmui.lite_search == undefined) return;
    
    var ls = global.gmui.lite_search;
    ls.case_sensitive = _case_sensitive;
    ls.enable_stemming = _enable_stemming;
    ls.min_word_length = _min_word_length;
}

function gmui_ls_add_stop_word(_word) {
    if (global.gmui.lite_search == undefined) return;
    
    var ls = global.gmui.lite_search;
    if (!ls.case_sensitive) {
        _word = string_lower(_word);
    }
    ds_list_add(ls.stop_words, _word);
}

function gmui_ls_get_document(_id) {
    if (global.gmui.lite_search == undefined) return undefined;
    
    var ls = global.gmui.lite_search;
    if (ds_map_exists(ls.documents, _id)) {
        return ds_map_find_value(ls.documents, _id);
    }
    return undefined;
}

function gmui_ls_clear() {
    if (global.gmui.lite_search == undefined) return;
    
    var ls = global.gmui.lite_search;
    
    // Save data
    var _case_sensitive = ls.case_sensitive;
    var _enable_stemming = ls.enable_stemming;
    var _min_word_length = ls.min_word_length;
    var _stop_words = ds_list_create();
    
    for (var i = 0; i < ds_list_size(ls.stop_words); i++) {
        ds_list_add(_stop_words, ds_list_find_value(ls.stop_words, i));
    }
    
    gmui_ls_cleanup();
    
    // Re-initialize
    gmui_ls_init();
    
    // Restore data
    ls = global.gmui.lite_search;
	
    ls.case_sensitive = _case_sensitive;
    ls.enable_stemming = _enable_stemming;
    ls.min_word_length = _min_word_length;
    
    ds_list_clear(ls.stop_words);
    for (var i = 0; i < ds_list_size(_stop_words); i++) {
        ds_list_add(ls.stop_words, ds_list_find_value(_stop_words, i));
    }
    
    ds_list_destroy(_stop_words);
}

function gmui_ls_cleanup() { // Being called by gmui_cleanup by default
    if (global.gmui.lite_search == undefined) return;
    
	var ls = global.gmui.lite_search;
	
    // Destroy all ds_maps in inverted index
    var _word = ds_map_find_first(ls.inverted_index);
    while (!is_undefined(_word)) {
        ds_map_destroy(ds_map_find_value(ls.inverted_index, _word));
        _word = ds_map_find_next(ls.inverted_index, _word);
    }
    
    ds_map_destroy(ls.inverted_index);
    ds_map_destroy(ls.documents);
    ds_map_destroy(ls.word_stats);
    ds_list_destroy(ls.stop_words);
    
    global.gmui.lite_search = undefined;
}

//////////////////////////////////////
// PRIVATE HELPER FUNCTIONS
//////////////////////////////////////

function _gmui_ls_extract_words(_text) {
    var _result = [];
    var _current_word = "";
    var _len = string_length(_text);
    
    for (var i = 1; i <= _len; i++) {
        var _char = string_char_at(_text, i);
        var _code = ord(_char);
        
        // Check if character is alphanumeric (A-Z, a-z, 0-9)
        if ((_code >= 48 && _code <= 57) ||   // 0-9
            (_code >= 65 && _code <= 90) ||   // A-Z
            (_code >= 97 && _code <= 122)) {  // a-z
            _current_word += _char;
        } else {
            // Non-alphanumeric character - end of word
            if (_current_word != "") {
                array_push(_result, _current_word);
                _current_word = "";
            }
        }
    }
    
    // Don't forget the last word
    if (_current_word != "") {
        array_push(_result, _current_word);
    }
    
    return _result;
}

function _gmui_ls_process_text(_text) {
    if (global.gmui.lite_search == undefined) return [];
    
    var ls = global.gmui.lite_search;
    var _result = [];
    
    // Convert to lowercase if not case sensitive
    if (!ls.case_sensitive) {
        _text = string_lower(_text);
    }
    
    // Tokenize - extract words using our custom function
    var _tokens = _gmui_ls_extract_words(_text);
    
    for (var i = 0; i < array_length(_tokens); i++) {
        var _token = _tokens[i];
        
        // Check minimum length
        if (string_length(_token) < ls.min_word_length) {
            continue;
        }
        
        // Check stop words
        if (ds_list_find_index(ls.stop_words, _token) != -1) {
            continue;
        }
        
        // Apply stemming if enabled
        if (ls.enable_stemming) {
            _token = _gmui_ls_stem_word(_token);
        }
        
        array_push(_result, _token);
    }
    
    return _result;
}

function _gmui_ls_string_endswith(_str, _suffix) {
    var _str_len = string_length(_str);
    var _suffix_len = string_length(_suffix);
    
    if (_suffix_len > _str_len) {
        return false;
    }
    
    var _end_part = string_copy(_str, _str_len - _suffix_len + 1, _suffix_len);
    return _end_part == _suffix;
}

function _gmui_ls_stem_word(_word) {
    if (string_length(_word) < 3) return _word;
    
    // Common suffixes
    var _suffixes = ["ing", "ed", "s", "es", "ly", "ment", "ness", "tion"];
    
    for (var i = 0; i < array_length(_suffixes); i++) {
        var _suffix = _suffixes[i];
        if (_gmui_ls_string_endswith(_word, _suffix)) {
            return string_delete(_word, string_length(_word) - string_length(_suffix) + 1, string_length(_suffix));
        }
    }
    
    return _word;
}

function _gmui_ls_generate_snippet(_text, _query_terms, _snippet_length = 200) {
    if (string_length(_text) <= _snippet_length) {
        return _gmui_ls_highlight_terms(_text, _query_terms);
    }
    
    // Find the best position with most query terms
    var _best_pos = 0;
    var _best_score = 0;
    var _text_lower = string_lower(_text);
    
    for (var _pos = 0; _pos < string_length(_text) - _snippet_length; _pos += 50) {
        var _chunk = string_copy(_text_lower, _pos, _snippet_length);
        var _score = 0;
        
        for (var i = 0; i < array_length(_query_terms); i++) {
            if (string_pos(_query_terms[i], _chunk) > 0) {
                _score++;
            }
        }
        
        if (_score > _best_score) {
            _best_score = _score;
            _best_pos = _pos;
        }
    }
    
    var _snippet = string_copy(_text, _best_pos, _snippet_length);
    
    // Add ellipsis if not at beginning
    if (_best_pos > 0) {
        _snippet = "..." + _snippet;
    }
    
    // Add ellipsis if not at end
    if (_best_pos + _snippet_length < string_length(_text)) {
        _snippet += "...";
    }
    
    return _gmui_ls_highlight_terms(_snippet, _query_terms);
}

function _gmui_ls_highlight_terms(_text, _terms) {
    var _result = _text;
    
    for (var i = 0; i < array_length(_terms); i++) {
        var _term = _terms[i];
        var _pos = string_pos(_term, string_lower(_result));
        
        while (_pos > 0) {
            var _before = string_copy(_result, 1, _pos - 1);
            var _match = string_copy(_result, _pos, string_length(_term));
            var _after = string_copy(_result, _pos + string_length(_term), string_length(_result));
            
            _result = _before + "[*" + _match + "*]" + _after;
            _pos = string_pos_ext(_term, string_lower(_result), _pos + string_length(_term) + 4); // +4 for [**]
        }
    }
    
    return _result;
}

function _gmui_ls_strip_highlighting(_text) {
    var _result = _text;
    var _pos = string_pos("[*", _result);
    
    while (_pos > 0) {
        var _end_pos = string_pos_ext("*]", _result, _pos);
        if (_end_pos > 0) {
            var _before = string_copy(_result, 1, _pos - 1);
            var _match = string_copy(_result, _pos + 2, _end_pos - _pos - 2);
            var _after = string_copy(_result, _end_pos + 2, string_length(_result));
            
            _result = _before + _match + _after;
        }
        _pos = string_pos_ext("[*", _result, _pos);
    }
    
    return _result;
}

function _gmui_ls_calculate_similarity(_str1, _str2) {
    if (_str1 == _str2) return 1.0;
    
    // Levenshtein distance based similarity
    var _len1 = string_length(_str1);
    var _len2 = string_length(_str2);
    var _max_len = max(_len1, _len2);
    
    if (_max_len == 0) return 1.0;
    
    var _distance = _gmui_ls_levenshtein_distance(_str1, _str2);
    return 1.0 - (_distance / _max_len);
}

function _gmui_ls_levenshtein_distance(_str1, _str2) {
    var _len1 = string_length(_str1);
    var _len2 = string_length(_str2);
    
    if (_len1 == 0) return _len2;
    if (_len2 == 0) return _len1;
    
    // Create matrix
    var _matrix = array_create(_len1 + 1);
    for (var i = 0; i <= _len1; i++) {
        _matrix[i] = array_create(_len2 + 1);
        _matrix[i][0] = i;
    }
    
    for (var j = 0; j <= _len2; j++) {
        _matrix[0][j] = j;
    }
    
    // Calculate distance
    for (var i = 1; i <= _len1; i++) {
        for (var j = 1; j <= _len2; j++) {
            var _cost = (string_char_at(_str1, i) == string_char_at(_str2, j)) ? 0 : 1;
            _matrix[i][j] = min(
                _matrix[i-1][j] + 1,      // deletion
                _matrix[i][j-1] + 1,      // insertion
                _matrix[i-1][j-1] + _cost // substitution
            );
        }
    }
    
    return _matrix[_len1][_len2];
}

function _gmui_ls_array_from_list(_list) {
    var _arr = array_create(ds_list_size(_list));
    for (var i = 0; i < ds_list_size(_list); i++) {
        _arr[i] = ds_list_find_value(_list, i);
    }
    return _arr;
}

function _gmui_ls_sum_word_frequencies() {
    if (global.gmui.lite_search == undefined) return 0;
    
    var ls = global.gmui.lite_search;
    var _total = 0;
    var _word = ds_map_find_first(ls.word_stats);
    
    while (!is_undefined(_word)) {
        _total += ds_map_find_value(ls.word_stats, _word).total_frequency;
        _word = ds_map_find_next(ls.word_stats, _word);
    }
    
    return _total;
}