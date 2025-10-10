// Cursor management, spacing, alignment
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

function gmui_calc_text_size(text) {
    return [string_width(text), string_height(text)];
}