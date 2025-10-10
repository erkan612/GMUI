function gmui_update_input() {
    if (!global.gmui.initialized) return;
    
    global.gmui.mouse_pos = [device_mouse_x_to_gui(0), device_mouse_y_to_gui(0)];
    
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
}

function gmui_update() {
	global.gmui.is_hovering_element = false;
	gmui_update_input();
};