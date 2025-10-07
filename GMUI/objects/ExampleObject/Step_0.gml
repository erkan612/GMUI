gmui_update();

if (gmui_begin("Demo Window", 100, 100, 768, 256, gmui_window_flags.AUTO_SCROLL | gmui_window_flags.SCROLL_WITH_MOUSE_WHEEL)) {
	var oldSpacingX = global.gmui.style.item_spacing[0];
	global.gmui.style.item_spacing[0] = 0;
	if (gmui_selectable("Example 1", tabIdx == 1)) { tabIdx = 1; }; gmui_same_line();
	if (gmui_selectable("Example 2", tabIdx == 2)) { tabIdx = 2; }; gmui_same_line();
	if (gmui_selectable("Example 3", tabIdx == 3)) { tabIdx = 3; }; gmui_separator();
	global.gmui.style.item_spacing[0] = oldSpacingX;
	
	switch (tabIdx) {
	case 1: {
		if (gmui_button("Click Me!")) { show_debug_message("Hello World!"); };
		//cbc = gmui_color_button(cbc, 64);
		cbc = gmui_color_edit_4("test", cbc);
	} break;
	
	case 2: {
		gmui_text("Hello! I'm GMUI! and you?");
		txD1 = gmui_textbox(txD1, "Enter your name");
		if (gmui_button("Enter") || (gmui_textbox_id() == gmui_get_focused_textbox_id() && keyboard_check_pressed(vk_enter))) { show_message("Hello " + txD1 + "!"); };
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
	};
	
	gmui_end();
};

//var windowName = "Demo Window";
//
//// Initialize scroll variables if they don't exist
//if (!variable_struct_exists(global, "scroll_demo")) {
//    global.scroll_demo = {
//        scroll_y: 0,
//        content_height: 0,
//        is_dragging: false,
//        drag_offset: 0
//    };
//}
//
//if (gmui_begin(windowName)) {
//    var currentWindow = gmui_get_window(windowName);
//    var scrollbarWidth = 16;
//    
//    // Apply scroll to content
//    currentWindow.dc.cursor_y -= global.scroll_demo.scroll_y;
//    
//    // Clip content area
//    gmui_begin_scissor(0, global.gmui.style.title_bar_height, 
//                      currentWindow.width - scrollbarWidth,  // Leave space for scrollbar
//                      currentWindow.height - global.gmui.style.title_bar_height);
//    
//    // Your scrollable content
//    gmui_button("Click Me!");
//    gmui_button("Click Me!");
//    gmui_button("Click Me!");
//    gmui_button("Click Me!");
//    gmui_button("Click Me!");
//    gmui_button("Click Me!");
//    gmui_button("Click Me!");
//    gmui_button("Click Me!");
//    gmui_button("Click Me!");
//    gmui_button("Click Me!");
//    gmui_button("Click Me!");
//    gmui_button("Click Me!");
//    
//    // Track actual content height for better scrollbar calculation
//    //var actualContentHeight = currentWindow.dc.cursor_y + global.scroll_demo.scroll_y;
//	contentHeight = currentWindow.dc.cursor_y - global.gmui.style.title_bar_height + global.scroll_demo.scroll_y;
//    //if (actualContentHeight > estimatedContentHeight) {
//    //    estimatedContentHeight = actualContentHeight;
//    //}
//    
//    gmui_end_scissor();
//    var scrollbarColorBackground = make_color_rgb(40, 40, 40);
//    var scrollbarColorAnchor = make_color_rgb(100, 100, 100);
//    var scrollbarColorAnchorHover = make_color_rgb(120, 120, 120);
//    var scrollbarColorAnchorActive = make_color_rgb(140, 140, 140);
//    
//    // Calculate scrollable area
//    var scrollAreaX = currentWindow.width - scrollbarWidth;
//    var scrollAreaY = global.gmui.style.title_bar_height;
//    var scrollAreaHeight = currentWindow.height - global.gmui.style.title_bar_height;
//    
//    // Draw scrollbar background
//    gmui_add_rect(scrollAreaX, scrollAreaY, scrollbarWidth, scrollAreaHeight, scrollbarColorBackground);
//    
//    // Calculate content height (you'll need to track this)
//    // For this demo, let's assume we have 12 buttons at 30px each + spacing
//    //var estimatedContentHeight = 12 * 30 + 12 * global.gmui.style.item_spacing[1];
//    
//    // Calculate anchor size and position
//    var viewportRatio = scrollAreaHeight / contentHeight;
//    var anchorHeight = max(30, scrollAreaHeight * viewportRatio);
//    var maxScroll = max(0, contentHeight - scrollAreaHeight);
//    
//    // Normalize scroll position
//    global.scroll_demo.scroll_y = clamp(global.scroll_demo.scroll_y, 0, maxScroll);
//    var scrollPercent = (maxScroll > 0) ? global.scroll_demo.scroll_y / maxScroll : 0;
//    
//    var anchorY = scrollAreaY + (scrollAreaHeight - anchorHeight) * scrollPercent;
//    var anchorBounds = [scrollAreaX, anchorY, scrollAreaX + scrollbarWidth, anchorY + anchorHeight];
//    
//    // Check for scrollbar interaction
//    var mouseOverScrollbar = gmui_is_mouse_over_window(currentWindow) && 
//                            gmui_is_point_in_rect(global.gmui.mouse_pos[0] - currentWindow.x, 
//                                                global.gmui.mouse_pos[1] - currentWindow.y, 
//                                                [scrollAreaX, scrollAreaY, scrollAreaX + scrollbarWidth, scrollAreaY + scrollAreaHeight]);
//    
//    var mouseOverAnchor = mouseOverScrollbar && 
//                         gmui_is_point_in_rect(global.gmui.mouse_pos[0] - currentWindow.x, 
//                                             global.gmui.mouse_pos[1] - currentWindow.y, 
//                                             anchorBounds);
//    
//    // Handle mouse wheel scrolling
//    if (gmui_is_mouse_over_window(currentWindow) && !global.scroll_demo.is_dragging) {
//        if (mouse_wheel_down()) {
//            global.scroll_demo.scroll_y += 30;
//        }
//        if (mouse_wheel_up()) {
//            global.scroll_demo.scroll_y -= 30;
//        }
//    }
//    
//    // Handle anchor dragging
//    if (mouseOverAnchor && global.gmui.mouse_clicked[0]) {
//        global.scroll_demo.is_dragging = true;
//        global.scroll_demo.drag_offset = (global.gmui.mouse_pos[1] - currentWindow.y) - anchorY;
//    }
//    
//    if (global.scroll_demo.is_dragging) {
//        if (global.gmui.mouse_down[0]) {
//            var mouseYInScrollbar = (global.gmui.mouse_pos[1] - currentWindow.y) - global.scroll_demo.drag_offset;
//            var normalizedY = (mouseYInScrollbar - scrollAreaY) / (scrollAreaHeight - anchorHeight);
//            global.scroll_demo.scroll_y = normalizedY * maxScroll;
//        } else {
//            global.scroll_demo.is_dragging = false;
//        }
//    }
//	
//	global.scroll_demo.scroll_y = clamp(global.scroll_demo.scroll_y, 0, maxScroll);
//    
//    // Draw anchor based on state
//    var anchorColor = scrollbarColorAnchor;
//    if (global.scroll_demo.is_dragging) {
//        anchorColor = scrollbarColorAnchorActive;
//    } else if (mouseOverAnchor) {
//        anchorColor = scrollbarColorAnchorHover;
//    }
//    
//    gmui_add_rect(scrollAreaX, anchorY, scrollbarWidth, anchorHeight, anchorColor);
//
//    gmui_end();
//}