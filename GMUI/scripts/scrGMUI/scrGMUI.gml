// GMUI - ImGui-like UI Library for GameMaker
// Single file implementation

global.gmui = undefined;

// Window flags
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

// Initialize gmui system (call once in create event)
function gmui_init() {
    if (global.gmui == undefined) {
        global.gmui = {
            initialized: true,
			is_hovering_element: false,
			recent_scissor: undefined,
			treeview_stack: [],
			treeview_open_nodes: ds_map_create(),
			active_slider: undefined,
			active_textbox: undefined,
			textbox_id: undefined,
			textbox_cursor_timer: 0,
			textbox_cursor_visible: true,
            windows: {},
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
			    scroll_wheel_speed: 30
            },
            font: draw_get_font()
        };
    }
}

// Window state
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

// Get or create window
function gmui_get_window(name) {
    if (!global.gmui.initialized) return undefined;
    
    if (!variable_struct_exists(global.gmui.windows, name)) {
        global.gmui.windows[$ name] = gmui_window_state();
        global.gmui.windows[$ name].name = name;
    }
    return global.gmui.windows[$ name];
}

// Create window surface
function gmui_create_surface(window) {
    if (surface_exists(window.surface)) surface_free(window.surface);
    window.surface = surface_create(max(1, window.width), max(1, window.height));
    window.surface_dirty = true;
    return window.surface != -1;
}

// Update input (call in step event)
function gmui_update_input() {
    if (!global.gmui.initialized) return;
    
    global.gmui.mouse_pos = [mouse_x, mouse_y];
    
	var mbArray = [ mb_left, mb_right, mb_middle, mb_side1, mb_side2 ];
	
    for (var i = 0; i < 5; i++) {
        global.gmui.mouse_clicked[i] = mouse_check_button_pressed(mbArray[i]);
        global.gmui.mouse_released[i] = mouse_check_button_released(mbArray[i]);
        global.gmui.mouse_down[i] = mouse_check_button(mbArray[i]);
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
}

function gmui_update() {
	global.gmui.is_hovering_element = false;
	gmui_update_input();
};

// Begin window
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
    window.treeview_stack = [];
    
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
        gmui_add_rect(0, 0, window.width, window.height, global.gmui.style.background_color);
        if (global.gmui.style.window_border_size > 0) {
            gmui_add_rect_outline(0, 0, window.width, window.height, global.gmui.style.border_color, global.gmui.style.window_border_size);
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

// End window
function gmui_end() {
    if (!global.gmui.initialized || array_length(global.gmui.window_stack) == 0) return;
    
    var window = global.gmui.current_window;
    var flags = window.flags;
    
    // Update max cursor position for content size calculation
    window.max_cursor_x = max(window.max_cursor_x, window.dc.cursor_x - window.dc.scroll_offset_x);
    window.max_cursor_y = max(window.max_cursor_y, window.dc.cursor_y - window.dc.scroll_offset_y);
    
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
}

// Add sprite to draw list
function gmui_add_sprite(x, y, w, h, sprite, subimg = 0) {
    if (!global.gmui.initialized || !global.gmui.current_window) return;
    array_push(global.gmui.current_window.draw_list, {
        type: "sprite", spr: sprite, x: x, y: y, width: w, height: h, index: subimg
    });
}

// Add rect to draw list
function gmui_add_rect(x, y, w, h, col) {
    if (!global.gmui.initialized || !global.gmui.current_window) return;
    array_push(global.gmui.current_window.draw_list, {
        type: "rect", x: x, y: y, width: w, height: h, color: col
    });
}

// Add rect outline
function gmui_add_rect_outline(x, y, w, h, col, thickness) {
    if (!global.gmui.initialized || !global.gmui.current_window) return;
    array_push(global.gmui.current_window.draw_list, {
        type: "rect_outline", x: x, y: y, width: w, height: h, color: col, thickness: thickness
    });
}

// Add text to draw list
function gmui_add_text(x, y, text, col) {
    if (!global.gmui.initialized || !global.gmui.current_window) return;
    array_push(global.gmui.current_window.draw_list, {
        type: "text", x: x, y: y, text: text, color: col
    });
}

// Get text size
function gmui_calc_text_size(text) {
    return [string_width(text), string_height(text)];
}

// Text element
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

// Disabled text
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

// Label text
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

// Same Line
function gmui_same_line() {
    if (!global.gmui.initialized || !global.gmui.current_window) return;
    
    var dc = global.gmui.current_window.dc;
	dc.cursor_x = dc.cursor_previous_x;
	dc.cursor_y = dc.cursor_previous_y;
}

// In gmui_new_line function, update max cursor tracking:
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

// Separator
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

// Dummy
function gmui_dummy(w, h) {
    if (!global.gmui.initialized || !global.gmui.current_window) return;
    
    var dc = global.gmui.current_window.dc;
	dc.cursor_previous_x = dc.cursor_x;
    dc.cursor_x += w;
    dc.line_height = max(dc.line_height, h);
}

// Render window surface
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
                
            case "rect_outline":
                draw_set_color(cmd.color);
                draw_rectangle(cmd.x, cmd.y, cmd.x + cmd.width, cmd.y + cmd.height, true);
                break;
                
            case "text":
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

// Render all UI (call in draw event)
function gmui_render() {
    if (!global.gmui.initialized) return;
    
    var names = variable_struct_get_names(global.gmui.windows);
    for (var i = 0; i < array_length(names); i++) {
        var window = global.gmui.windows[$ names[i]];
        if (window.active && window.open) {
            gmui_render_surface(window);
            draw_surface(window.surface, window.x, window.y);
            window.active = false;
        }
    }
}

// Cleanup
function gmui_cleanup() {
    if (global.gmui && global.gmui.initialized) {
        var names = variable_struct_get_names(global.gmui.windows);
        for (var i = 0; i < array_length(names); i++) {
            var window = global.gmui.windows[$ names[i]];
            if (surface_exists(window.surface)) surface_free(window.surface);
            // Destroy the treeview_open_nodes for this window
            if (ds_exists(window.treeview_open_nodes, ds_type_map)) {
                ds_map_destroy(window.treeview_open_nodes);
            }
        }
        global.gmui = undefined;
    }
}

// Button element - returns true when clicked
function gmui_button(label, width = -1, height = -1) {
    if (!global.gmui.initialized || !global.gmui.current_window) return false;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
    
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
        if (global.gmui.mouse_down[0]) {
            is_active = true;
        }
        if (global.gmui.mouse_released[0]) {
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
    gmui_add_rect(button_x, button_y, button_width, button_height, bg_color);
    
    // Draw border
    if (style.button_border_size > 0) {
        gmui_add_rect_outline(button_x, button_y, button_width, button_height, border_color, style.button_border_size);
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

// Small button variant
function gmui_button_small(label) {
    return gmui_button(label, -1, 20);
}

// Large button variant  
function gmui_button_large(label) {
    return gmui_button(label, -1, 32);
}

// Button with custom width
function gmui_button_width(label, width) {
    return gmui_button(label, width, -1);
}

// Utility function: Check if mouse is over a window
function gmui_is_mouse_over_window(window) {
    var mx = global.gmui.mouse_pos[0];
    var my = global.gmui.mouse_pos[1];
    return (mx >= window.x && mx <= window.x + window.width &&
            my >= window.y && my <= window.y + window.height);
}

// Utility function: Check if point is in rectangle
function gmui_is_point_in_rect(point_x, point_y, rect) {
    return (point_x >= rect[0] && point_x <= rect[2] &&
            point_y >= rect[1] && point_y <= rect[3]);
}

// Add this function for disabled buttons
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
    gmui_add_rect(button_x, button_y, button_width, button_height, style.button_disabled_bg_color);
    
    if (style.button_border_size > 0) {
        gmui_add_rect_outline(button_x, button_y, button_width, button_height, style.button_disabled_border_color, style.button_border_size);
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
        if (global.gmui.mouse_down[0]) {
            close_color = style.close_button_active_color;
        } else {
            close_color = style.close_button_hover_color;
        }
        
        // Close window on click
        if (global.gmui.mouse_released[0]) {
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
    
    // Handle dragging
    if (can_move && has_title_bar && window.title_bar_hovered) {
        if (global.gmui.mouse_clicked[0]) {
            window.is_dragging = true;
            window.drag_offset_x = mouse_x_in_window;
            window.drag_offset_y = mouse_y_in_window;
            window.title_bar_active = true;
            
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
}

// Add line drawing function (for close button X)
function gmui_add_line(x1, y1, x2, y2, col, thickness) {
    if (!global.gmui.initialized || !global.gmui.current_window) return;
    
    // Simple line implementation using rectangles
    var angle = point_direction(x1, y1, x2, y2);
    var length = point_distance(x1, y1, x2, y2);
    
    // Draw a rotated rectangle for the line
    var center_x = (x1 + x2) / 2;
    var center_y = (y1 + y2) / 2;
    
    array_push(global.gmui.current_window.draw_list, {
        type: "line", 
        x1: x1, y1: y1, x2: x2, y2: y2, 
        color: col, thickness: thickness
    });
}

// Add helper function to set window position manually
function gmui_set_window_position(name, x, y) {
    if (!global.gmui.initialized) return false;
    
    var window = gmui_get_window(name);
    if (!window) return false;
    
    window.x = x;
    window.y = y;
    return true;
}

// Add helper function to set window size manually
function gmui_set_window_size(name, width, height) {
    if (!global.gmui.initialized) return false;
    
    var window = gmui_get_window(name);
    if (!window) return false;
    
    window.width = max(global.gmui.style.window_min_size[0], width);
    window.height = max(global.gmui.style.window_min_size[1], height);
    gmui_create_surface(window); // Recreate surface with new size
    return true;
}

// Add helper function to reset window to initial position/size
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

// Checkbox element - returns true when toggled
function gmui_checkbox(label, value) {
    if (!global.gmui.initialized || !global.gmui.current_window) return value;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
    
    // Calculate total size needed
    var text_size = gmui_calc_text_size(label);
    var total_width = text_size[0] + style.checkbox_spacing + style.checkbox_size;
    var total_height = max(style.checkbox_size, text_size[1]);
    
    // Check if checkbox fits on current line, otherwise move to new line
    if (dc.cursor_x + total_width > window.width - style.window_padding[0] && dc.cursor_x > dc.cursor_start_x) {
        gmui_new_line();
    }
    
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
        if (global.gmui.mouse_down[0]) {
            is_active = true;
        }
        if (global.gmui.mouse_released[0]) {
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
    gmui_add_rect(checkbox_x, checkbox_y, style.checkbox_size, style.checkbox_size, bg_color);
    
    // Draw border
    if (style.checkbox_border_size > 0) {
        gmui_add_rect_outline(checkbox_x, checkbox_y, style.checkbox_size, style.checkbox_size, 
                            border_color, style.checkbox_border_size);
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

// Disabled checkbox variant
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
    gmui_add_rect(checkbox_x, checkbox_y, style.checkbox_size, style.checkbox_size, 
                 style.checkbox_disabled_bg_color);
    
    if (style.checkbox_border_size > 0) {
        gmui_add_rect_outline(checkbox_x, checkbox_y, style.checkbox_size, style.checkbox_size, 
                            style.checkbox_disabled_border_color, style.checkbox_border_size);
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

// Checkbox without label (just the box)
function gmui_checkbox_box(value, size = -1) {
    if (!global.gmui.initialized || !global.gmui.current_window) return value;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
    
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
        if (global.gmui.mouse_down[0]) {
            is_active = true;
        }
        if (global.gmui.mouse_released[0]) {
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
    gmui_add_rect(checkbox_x, checkbox_y, checkbox_size, checkbox_size, bg_color);
    
    if (style.checkbox_border_size > 0) {
        gmui_add_rect_outline(checkbox_x, checkbox_y, checkbox_size, checkbox_size, 
                            border_color, style.checkbox_border_size);
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

// Slider element - returns true when value changes
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
    gmui_add_rect(track_bounds[0], track_bounds[1], slider_width, style.slider_track_height, track_bg_color);
    
    // Draw track fill
    if (window.active) {
        var fill_width = (handle_x - slider_x) + style.slider_handle_width / 2;
        gmui_add_rect(track_bounds[0], track_bounds[1], fill_width, style.slider_track_height, style.slider_track_fill_color);
    }
    
    // Draw track border
    if (style.slider_track_border_size > 0) {
        var track_border_color = window.active ? style.slider_track_border_color : make_color_rgb(70, 70, 70);
        gmui_add_rect_outline(track_bounds[0], track_bounds[1], slider_width, style.slider_track_height, track_border_color, style.slider_track_border_size);
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
    gmui_add_rect(handle_x, handle_y, style.slider_handle_width, style.slider_handle_height, handle_bg_color);
    
    if (style.slider_handle_border_size > 0) {
        gmui_add_rect_outline(handle_x, handle_y, style.slider_handle_width, style.slider_handle_height, handle_border_color, style.slider_handle_border_size);
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
    gmui_add_rect(slider_x, track_y, slider_width, style.slider_track_height, make_color_rgb(50, 50, 50));
    
    // Draw disabled track fill (partial)
    var fill_width = (handle_x - slider_x) + style.slider_handle_width / 2;
    gmui_add_rect(slider_x, track_y, fill_width, style.slider_track_height, make_color_rgb(80, 80, 80));
    
    // Draw track border
    if (style.slider_track_border_size > 0) {
        gmui_add_rect_outline(slider_x, track_y, slider_width, style.slider_track_height, make_color_rgb(70, 70, 70), style.slider_track_border_size);
    }
    
    // Draw disabled handle
    gmui_add_rect(handle_x, handle_y, style.slider_handle_width, style.slider_handle_height, style.slider_handle_disabled_bg_color);
    
    if (style.slider_handle_border_size > 0) {
        gmui_add_rect_outline(handle_x, handle_y, style.slider_handle_width, style.slider_handle_height, style.slider_handle_disabled_border_color, style.slider_handle_border_size);
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

// Textbox element - returns [text, changed]
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
    if (dc.cursor_x + textbox_width > window.width - style.window_padding[0] && dc.cursor_x > dc.cursor_start_x) {
        gmui_new_line();
    }
    
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
	            drag_start_pos: 0  // Add this for drag tracking
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
    
    gmui_add_rect(textbox_x, textbox_y, textbox_width, textbox_height, bg_color);
    
    // Draw border
    if (style.textbox_border_size > 0) {
        gmui_add_rect_outline(textbox_x, textbox_y, textbox_width, textbox_height, 
                            border_color, style.textbox_border_size);
    }
    
    // Create a surface for text clipping
    var text_surface = -1;
    var text_area_width = textbox_width - style.textbox_padding[0] * 2;
    
    if (surface_exists(window.surface)) {
        text_surface = surface_create(text_area_width, text_size[1]);
        if (surface_exists(text_surface)) {
            surface_set_target(text_surface);
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
                    draw_rectangle(prefix_width, 0, prefix_width + selected_width, text_size[1], false);
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
					draw_set_alpha((sin(current_time / 200) * 0.5 + 0.5) * 0.3 + 0.7);
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
    if (surface_exists(text_surface)) {
        // Add surface to draw list
        array_push(window.draw_list, {
            type: "surface",
            surface: text_surface,
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

// Helper function to set cursor position from mouse click
function textbox_set_cursor_from_click(textbox, click_x) {
    var text = textbox.text;
    var len = string_length(text);
    
    // Handle empty text or click at very beginning
    if (len == 0 || click_x <= 0) {
        textbox.cursor_pos = 0;
        return;
    }
    
    // Handle click beyond text width
    var total_width = string_width(text);
    if (click_x >= total_width) {
        textbox.cursor_pos = len;
        return;
    }
    
    // Binary search for the closest character position
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

// Helper function to handle mouse drag for text selection
function textbox_handle_mouse_drag(textbox, drag_x) {
    var text = textbox.text;
    var len = string_length(text);
    
    // Handle drag at the very beginning
    if (drag_x <= 0) {
        textbox.cursor_pos = 0;
    }
    // Handle drag at the very end
    else if (drag_x >= string_width(text)) {
        textbox.cursor_pos = len;
    }
    // Find position within text
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
    
    // Update selection based on drag start position and current cursor
    if (textbox.cursor_pos < textbox.drag_start_pos) {
        textbox.selection_start = textbox.cursor_pos;
        textbox.selection_length = textbox.drag_start_pos - textbox.cursor_pos;
    } else {
        textbox.selection_start = textbox.drag_start_pos;
        textbox.selection_length = textbox.cursor_pos - textbox.drag_start_pos;
    }
}

/// @function gmui_is_any_textbox_focused()
/// @desc Returns true if any textbox in the UI currently has focus
/// @return {bool} True if a textbox is focused
function gmui_is_any_textbox_focused() {
    if (!global.gmui.initialized) return false;
    return global.gmui.active_textbox != undefined;
}

/// @function gmui_get_focused_textbox_id()
/// @desc Returns the ID of the currently focused textbox, or undefined if none
/// @return {string|undefined} The focused textbox ID
function gmui_get_focused_textbox_id() {
    if (!global.gmui.initialized || global.gmui.active_textbox == undefined) return undefined;
    return global.gmui.active_textbox.id;
}

/// @function gmui_is_textbox_focused(textbox_id)
/// @desc Check if a specific textbox is focused by its ID
/// @param {string} textbox_id The textbox ID to check
/// @return {bool} True if the specified textbox is focused
function gmui_is_textbox_focused(textbox_id) {
    if (!global.gmui.initialized || global.gmui.active_textbox == undefined) return false;
    return global.gmui.active_textbox.id == textbox_id;
}

/// @function gmui_get_focused_textbox_text()
/// @desc Returns the text content of the currently focused textbox
/// @return {string} The text content, or empty string if no textbox is focused
function gmui_get_focused_textbox_text() {
    if (!global.gmui.initialized || global.gmui.active_textbox == undefined) return "";
    return global.gmui.active_textbox.text;
}

/// @function gmui_clear_textbox_focus()
/// @desc Clears focus from any currently focused textbox
function gmui_clear_textbox_focus() {
    if (!global.gmui.initialized) return;
    global.gmui.active_textbox = undefined;
}

// Selectable element - returns true when clicked/selected
function gmui_selectable(label, selected, width = -1, height = -1) {
    if (!global.gmui.initialized || !global.gmui.current_window) return false;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
    
    // Calculate selectable size
    var text_size = gmui_calc_text_size(label);
    var selectable_width = max(text_size[0] + style.selectable_padding[0] * 2, width > 0 ? width : 0);
    var selectable_height = max(style.selectable_height, height > 0 ? height : 0);
    
    // Use custom size if provided, otherwise use text-based size
    if (width <= 0) selectable_width = text_size[0] + style.selectable_padding[0] * 2;
    if (height <= 0) selectable_height = style.selectable_height;
    
    // Check if selectable fits on current line
    if (dc.cursor_x + selectable_width > window.width - style.window_padding[0] && dc.cursor_x > dc.cursor_start_x) {
        gmui_new_line();
    }
    
    // Calculate selectable bounds
    var selectable_x = dc.cursor_x;
    var selectable_y = dc.cursor_y;
    var selectable_bounds = [selectable_x, selectable_y, selectable_x + selectable_width, selectable_y + selectable_height];
    
    // Check for mouse interaction
    var mouse_over = gmui_is_mouse_over_window(window) && 
                     gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, global.gmui.mouse_pos[1] - window.y, selectable_bounds) && !global.gmui.is_hovering_element;
    
    var clicked = false;
    var is_active = false;
    
    if (mouse_over && window.active) {
		global.gmui.is_hovering_element = true;
        if (global.gmui.mouse_down[0]) {
            is_active = true;
        }
        if (global.gmui.mouse_released[0]) {
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
    gmui_add_rect(selectable_x, selectable_y, selectable_width, selectable_height, bg_color);
    
    // Draw border
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
    
    return clicked && window.active;
}

// Disabled selectable variant
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

// Small selectable variant
function gmui_selectable_small(label, selected) {
    return gmui_selectable(label, selected, -1, 20);
}

// Large selectable variant  
function gmui_selectable_large(label, selected) {
    return gmui_selectable(label, selected, -1, 32);
}

// Selectable with custom width
function gmui_selectable_width(label, selected, width) {
    return gmui_selectable(label, selected, width, -1);
}

// Treeview utility functions

// Generate a unique ID for a tree node
function gmui_treeview_node_id(window, path_array) {
    var _id = window.name + "_";
    for (var i = 0; i < array_length(path_array); i++) {
        _id += string(path_array[i]) + "/";
    }
    return _id;
}

// Check if a tree node is open
function gmui_treeview_is_node_open(window, path_array) {
    var node_id = gmui_treeview_node_id(window, path_array);
    return ds_map_exists(global.gmui.treeview_open_nodes, node_id) && global.gmui.treeview_open_nodes[? node_id];
}

// Toggle a tree node open/closed
function gmui_treeview_toggle_node(window, path_array) {
    var node_id = gmui_treeview_node_id(window, path_array);
    if (ds_map_exists(global.gmui.treeview_open_nodes, node_id)) {
        global.gmui.treeview_open_nodes[? node_id] = !global.gmui.treeview_open_nodes[? node_id];
    } else {
        ds_map_add(global.gmui.treeview_open_nodes, node_id, true);
    }
}

// Set a tree node open state
function gmui_treeview_set_node_open(window, path_array, open) {
    var node_id = gmui_treeview_node_id(window, path_array);
    if (ds_map_exists(global.gmui.treeview_open_nodes, node_id)) {
        global.gmui.treeview_open_nodes[? node_id] = open;
    } else {
        ds_map_add(global.gmui.treeview_open_nodes, node_id, open);
    }
}

// Push treeview context
function gmui_treeview_push(window, path_array) {
    array_push(window.treeview_stack, path_array);
}

// Pop treeview context
function gmui_treeview_pop(window) {
    if (array_length(window.treeview_stack) > 0) {
        array_pop(window.treeview_stack);
    }
}

// Get current treeview depth
function gmui_treeview_get_depth(window) {
    return array_length(window.treeview_stack);
}

// Get current treeview path
function gmui_treeview_get_current_path(window) {
    if (array_length(window.treeview_stack) == 0) return [];
    
    var current = window.treeview_stack[array_length(window.treeview_stack) - 1];
    var path = [];
    for (var i = 0; i < array_length(current); i++) {
        array_push(path, current[i]);
    }
    return path;
}

// Treeview node - returns [is_open, is_clicked, is_selected]
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
    
    if (mouse_over && window.active) {
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

// Add triangle to draw list (filled)
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

// Treeview node - returns true if node is open and should render children
function gmui_tree_node_begin(label, selected = false) {
    if (!global.gmui.initialized || !global.gmui.current_window) return false;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
    
    // Get current treeview context
    var current_path = gmui_treeview_get_current_path(window);
    var is_open = gmui_treeview_is_node_open(window, current_path);
    var _depth = gmui_treeview_get_depth(window);
    
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
                gmui_treeview_toggle_node(window, current_path);
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
    gmui_treeview_push(window, new_path);
    
    return [ is_open, clicked ];
}

// Tree leaf node (no children) - returns true if clicked
function gmui_tree_leaf(label, selected = false) {
    if (!global.gmui.initialized || !global.gmui.current_window) return false;
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
    
    var current_path = gmui_treeview_get_current_path(window);
    var _depth = gmui_treeview_get_depth(window);
    
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
    
    if (mouse_over && window.active) {
		global.gmui.is_hovering_element = true;
        if (global.gmui.mouse_down[0]) {
            is_active = true;
        }
        if (global.gmui.mouse_released[0]) {
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

// End a tree node
function gmui_tree_node_end() {
    var window = global.gmui.current_window;
    gmui_treeview_pop(window);
}

// Get tree node state - returns [is_open, was_clicked, is_selected]
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

// Reset treeview depth for a new root node
function gmui_tree_node_reset() {
    if (!global.gmui.initialized || !global.gmui.current_window) return;
    
    var window = global.gmui.current_window;
    // Clear the treeview stack to reset to depth 0
    window.treeview_stack = [];
}

// Collapsible header - returns [is_open, was_clicked]
function gmui_collapsing_header(label, is_open) {
    if (!global.gmui.initialized || !global.gmui.current_window) return [is_open, false];
    
    var window = global.gmui.current_window;
    var dc = window.dc;
    var style = global.gmui.style;
    
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
        if (global.gmui.mouse_down[0]) {
            is_active = true;
        }
        if (global.gmui.mouse_released[0]) {
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
    gmui_add_rect(header_x, header_y, header_width, header_height, bg_color);
    
    // Draw border
    if (style.collapsible_header_border_size > 0) {
        gmui_add_rect_outline(header_x, header_y, header_width, header_height, 
                            border_color, style.collapsible_header_border_size);
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

// End collapsible header - call this after the content when header is open
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

// Add scissor to draw list
function gmui_add_scissor(x, y, w, h) {
    if (!global.gmui.initialized || !global.gmui.current_window) return;
    array_push(global.gmui.current_window.draw_list, {
        type: "scissor", x: x, y: y, width: w, height: h
    });
}

// Reset scissor
function gmui_add_scissor_reset() {
    if (!global.gmui.initialized || !global.gmui.current_window) return;
    array_push(global.gmui.current_window.draw_list, {
        type: "scissor_reset"
    });
}

// Begin scissor region - clip all subsequent drawing to the specified rectangle
function gmui_begin_scissor(x, y, w, h) {
    gmui_add_scissor(x, y, w, h);
	return true;
}

// End scissor region - reset clipping
function gmui_end_scissor() {
    gmui_add_scissor_reset();
}

// Scissor group - execute a function with scissor region active
function gmui_scissor_group(x, y, w, h, func) {
    gmui_begin_scissor(x, y, w, h);
    func();
    gmui_end_scissor();
}

/// @function gmui_handle_scrollbars(window)
/// @desc Handle scrollbar drawing and interaction for a window
/// @param {struct} window Window object
function gmui_handle_scrollbars(window) {
    var flags = window.flags;
    var style = global.gmui.style;
    
    // Check scrollbar conditions
    var has_vertical_scroll = (flags & gmui_window_flags.VERTICAL_SCROLL) != 0;
    var has_horizontal_scroll = (flags & gmui_window_flags.HORIZONTAL_SCROLL) != 0;
    var auto_scroll = (flags & gmui_window_flags.AUTO_SCROLL) != 0;
    var always_scrollbars = (flags & gmui_window_flags.ALWAYS_SCROLLBARS) != 0;
    var scroll_with_wheel = (flags & gmui_window_flags.SCROLL_WITH_MOUSE_WHEEL) != 0;
    
    var scrollbar_width = style.scrollbar_width;
    var content_area_width = window.width;
    var content_area_height = window.height - window.dc.title_bar_height;
    
    // Determine if scrollbars are needed
    var needs_vertical = has_vertical_scroll || (auto_scroll && window.content_height > content_area_height);
    var needs_horizontal = has_horizontal_scroll || (auto_scroll && window.content_width > content_area_width);
    
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

/// @function gmui_draw_vertical_scrollbar(window, content_width, content_height)
/// @desc Draw and handle vertical scrollbar
/// @param {struct} window Window object
/// @param {number} content_width Width of content area
/// @param {number} content_height Height of content area
function gmui_draw_vertical_scrollbar(window, content_width, content_height) {
    var style = global.gmui.style;
    var scrollbar_width = style.scrollbar_width;
    
    // Calculate scrollbar position
    var scrollbar_x = (window.flags & gmui_window_flags.SCROLLBAR_LEFT) != 0 ? 0 : content_width;
    var scrollbar_y = window.dc.title_bar_height;
    var scrollbar_height = content_height;
    
    // Draw scrollbar background
    gmui_add_rect(scrollbar_x, scrollbar_y, scrollbar_width, scrollbar_height, 
                 style.scrollbar_background_color);
    
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
    
    gmui_add_rect(scrollbar_x, anchor_y, scrollbar_width, anchor_height, anchor_color);
}

/// @function gmui_draw_horizontal_scrollbar(window, content_width, content_height)
/// @desc Draw and handle horizontal scrollbar
/// @param {struct} window Window object
/// @param {number} content_width Width of content area
/// @param {number} content_height Height of content area
function gmui_draw_horizontal_scrollbar(window, content_width, content_height) {
    var style = global.gmui.style;
    var scrollbar_height = style.scrollbar_width;
    
    // Calculate scrollbar position
    var scrollbar_x = 0;
    var scrollbar_y = (window.flags & gmui_window_flags.SCROLLBAR_TOP) != 0 ? 
        window.dc.title_bar_height : window.height - scrollbar_height;
    
    var scrollbar_width = content_width;
    
    // Draw scrollbar background
    gmui_add_rect(scrollbar_x, scrollbar_y, scrollbar_width, scrollbar_height, 
                 style.scrollbar_background_color);
    
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
    
    gmui_add_rect(anchor_x, scrollbar_y, anchor_width, scrollbar_height, anchor_color);
}

/// @function gmui_is_scrollbar_interacting(window, bounds)
/// @desc Check if mouse is interacting with scrollbar
/// @param {struct} window Window object
/// @param {array} bounds Scrollbar bounds [x1, y1, x2, y2]
/// @return {bool} True if interacting
function gmui_is_scrollbar_interacting(window, bounds) {
    return gmui_is_mouse_over_window(window) && 
           gmui_is_point_in_rect(global.gmui.mouse_pos[0] - window.x, 
                               global.gmui.mouse_pos[1] - window.y, 
                               bounds);
}

/// @function gmui_set_scroll_position(window_name, scroll_x, scroll_y)
/// @desc Set scroll position for a window
/// @param {string} window_name Window name
/// @param {number} scroll_x Horizontal scroll position
/// @param {number} scroll_y Vertical scroll position
function gmui_set_scroll_position(window_name, scroll_x, scroll_y) {
    if (!global.gmui.initialized) return false;
    
    var window = gmui_get_window(window_name);
    if (!window) return false;
    
    window.scroll_x = scroll_x;
    window.scroll_y = scroll_y;
    
    return true;
}

/// @function gmui_get_scroll_position(window_name)
/// @desc Get current scroll position for a window
/// @param {string} window_name Window name
/// @return {array} [scroll_x, scroll_y] or undefined
function gmui_get_scroll_position(window_name) {
    if (!global.gmui.initialized) return undefined;
    
    var window = gmui_get_window(window_name);
    if (!window) return undefined;
    
    return [window.scroll_x, window.scroll_y];
}

/// @function gmui_scroll_to_bottom(window_name)
/// @desc Scroll to the bottom of a window
/// @param {string} window_name Window name
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

/// @function gmui_scroll_to_top(window_name)
/// @desc Scroll to the top of a window
/// @param {string} window_name Window name
function gmui_scroll_to_top(window_name) {
    if (!global.gmui.initialized) return false;
    
    var window = gmui_get_window(window_name);
    if (!window) return false;
    
    window.scroll_y = 0;
    
    return true;
}