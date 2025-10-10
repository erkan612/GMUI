// Initialization, main loop, window management
global.gmui = undefined;

enum gmui_window_flags {
    NONE = 0,
    NO_TITLE_BAR = 1 << 0,
    NO_RESIZE = 1 << 1,
    NO_MOVE = 1 << 2,
    NO_SCROLLBAR = 1 << 3,
    NO_COLLAPSE = 1 << 4,
    ALWAYS_AUTO_RESIZE = 1 << 5,
    NO_BACKGROUND = 1 << 6,
    NO_SAVED_SETTINGS = 1 << 7,
    NO_MOUSE_INPUTS = 1 << 8,
    MENU_BAR = 1 << 9,
    HORIZONTAL_SCROLLBAR = 1 << 10,
    NO_FOCUS_ON_APPEARING = 1 << 11,
    NO_BRING_TO_FRONT_ON_FOCUS = 1 << 12,
    ALWAYS_VERTICAL_SCROLLBAR = 1 << 13,
    ALWAYS_HORIZONTAL_SCROLLBAR = 1 << 14,
    ALWAYS_USE_WINDOW_PADDING = 1 << 15,
    NO_NAV_INPUTS = 1 << 16,
    NO_NAV_FOCUS = 1 << 17,
    UNSAVED_DOCUMENT = 1 << 18,
    NO_CLOSE = 1 << 19,
    
    // Scrollbar flags
    VERTICAL_SCROLL = 1 << 20,
    HORIZONTAL_SCROLL = 1 << 21,
    AUTO_SCROLL = 1 << 22,           // Automatically show scrollbars when needed
    ALWAYS_SCROLLBARS = 1 << 23,     // Always show scrollbars (even when not needed)
    SCROLL_WITH_MOUSE_WHEEL = 1 << 24, // Enable mouse wheel scrolling
    SCROLLBAR_LEFT = 1 << 25,        // Place vertical scrollbar on left side
    SCROLLBAR_TOP = 1 << 26,         // Place horizontal scrollbar on top
}

function gmui_get() { return global.gmui; };

function gmui_init() {
    if (global.gmui == undefined) {
        global.gmui = {
            initialized: true,
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
                window_rounding: 0,
                window_border_size: 1,
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
				color_picker_rounding: 4,
				color_picker_border_size: 1,
				color_picker_border_color: make_color_rgb(80, 80, 80),

				// Color button styles
				color_button_size: 20,
				color_button_rounding: 4,
				color_button_border_size: 1,
				color_button_border_color: make_color_rgb(100, 100, 100),
				color_button_hover_border_color: make_color_rgb(150, 150, 150),
				color_button_active_border_color: make_color_rgb(200, 200, 200),

				// Color edit styles
				color_edit_height: 24,
				color_edit_rounding: 4,
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
				shader_checkerboard: -1
            },
            font: draw_get_font(),
			styler: {
				button: function(data) { gmui_add_rect(data.x, data.y, data.width, data.height, data.color); },
			}
        };
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
		ds_list_add(global.gmui.windows, window);
    };
	
    return window;
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
    
    // Handle initial positioning
    if (window.first_frame) {
        if (x != -1) { window.x = x; window.initial_x = x; }
        if (y != -1) { window.y = y; window.initial_y = y; }
        if (w != -1) { window.width = w; window.initial_width = w; }
        if (h != -1) { window.height = h; window.initial_height = h; }
        window.first_frame = false;
    } else if (!no_move) {
        if (x != -1) window.x = x;
        if (y != -1) window.y = y;
        if (w != -1) window.width = w;
        if (h != -1) window.height = h;
    }
    
    window.flags = flags;
    window.active = true;
    window.treeview_stack = [];//
    
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
    
    window.draw_list = [];
    array_push(global.gmui.window_stack, window);
    global.gmui.current_window = window;
    
    // Draw background
    if ((flags & gmui_window_flags.NO_BACKGROUND) == 0) {
        gmui_add_rect_alpha(0, 0, window.width, window.height, global.gmui.style.background_color, global.gmui.style.background_alpha);
        if (global.gmui.style.window_border_size > 0) {
            gmui_add_rect_outline_alpha(0, 0, window.width, window.height, global.gmui.style.border_color, global.gmui.style.window_border_size, global.gmui.style.background_alpha);
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
		window.width = window.max_cursor_x;
		window.height = window.max_cursor_y;
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
			ds_list_delete(global.gmui.windows, ds_list_find_index(global.gmui.windows, gmui_get_window(_id)))
			global.gmui.to_delete_color_picker = false;
		};
    }
}

function gmui_cleanup() {
    if (global.gmui && global.gmui.initialized) {
        for (var i = 0; i < ds_list_size(global.gmui.windows); i++) {
            var window = global.gmui.windows[| i];
            if (surface_exists(window.surface)) surface_free(window.surface);
            // Destroy the treeview_open_nodes for this window
            if (ds_exists(window.treeview_open_nodes, ds_type_map)) {
                ds_map_destroy(window.treeview_open_nodes);
            }
        }
		ds_list_destroy(global.gmui.windows);
        global.gmui = undefined;
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