

// CONTAINER
function gmui_container_get(name, parent = undefined) {
	var gmui = global.gmui;
	var map = parent == undefined ? gmui.containers : parent.containers;
	
	if (map[? name] == undefined) {
		map[? name] = {
			name: name,
			x_origin: 0,
			y_origin: 0,
			x: 0,
			y: 0,
			width: 100,
			height: 100,
			
			initialized: false,
			
			layer: gmui_layer.NORMAL,
			z_index: 0,
			z_interaction_enabled: false,
		
			use_surface: true,
			surface: -1,
			surface_flag: false,
			ignore_surface_flag_once: false,
			surface_dirty: true,
			surface_sleep: false,
			animation_flag: false,
			
			use_scissor: gmui.profile.container_properties.use_scissor,
		
			containers: ds_map_create(),
			containers_sorted: [ ],
			calls: [ ],
			late_calls_enabled: false,
			late_calls: [ ],
		
			parent: undefined,
			
			context: {
				cursor_x: 0,
				cursor_y: 0,
				line_height: 0,
				new_line_requested: false,
				same_line_requested: false,
				indent_level: 0,
				widget_counter: 0,
				previous_widget_counter: 0,
				columns_counter: 0,
				rows_counter: 0,
				ignore_cursor_advance_once: false,
				needs_horizontal_scrollbar: false,
				needs_vertical_scrollbar: false,
				flow: false,
			},
			
			widgets: [ ],
			last_widget: undefined,
			focused_widget: undefined,
			hovered_widget: undefined,
			current_widget: undefined,
			widget_flag: false,
			widget_map: ds_map_create(),
			widget_flag_layout_changed: false,
			
			is_active: false,
			is_enabled: true,
			
			is_mouse_hovering: false,
			
			scrolling_enabled: true,
			scrolling_enabled_vertical: true,
			scrolling_enabled_horizontal: true,
			scroll_x: 0,
			scroll_y: 0,
			scroll_speed: 20,
			scroll_widget_horizontal: true,
			scroll_widget_vertical: true,
			
			content_width: 0,
			content_height: 0,
			
			state: ds_map_create(),
			
			ignore_round_style: false,
			
			background_enabled: true,
			background_draw_func: gmui_default_background_draw_call,
			
			mask_enabled: false,
			mask_surface: -1,
			mask_draw_func: gmui_default_mask_draw_call,
		};
		
		gmui_append_structure(map[? name], global.gmui.profile.container_properties);
	}
	
	var container = map[? name];
	
	return container;
};

function gmui_container_enable_late_calls(container = undefined) {
	var c = container ?? global.gmui.current_container;
	c.late_calls_enabled = true;
};

function gmui_container_disable_late_calls(container = undefined) {
	var c = container ?? global.gmui.current_container;
	c.late_calls_enabled = false;
};

function gmui_container_surface_flag_enable(container = undefined) { 
    var c = container ?? global.gmui.current_container;
    if (c != undefined && !c.surface_flag) { 
        c.surface_flag = true; 
        c.surface_dirty = true;
    } 
};

function gmui_container_surface_flag_disable(container = undefined) { 
    var c = container ?? global.gmui.current_container;
    if (c != undefined) { 
        c.surface_flag = false; 
    } 
};

function gmui_container_surface_flag_toggle(container = undefined) { 
    var c = container ?? global.gmui.current_container;
    if (c != undefined) {
        c.surface_flag = !c.surface_flag;
        if (c.surface_flag) { c.surface_dirty = true; }
    } 
    return c.surface_flag;
};

function gmui_container_surface_dirty(container = undefined) { 
    var c = container ?? global.gmui.current_container;
    if (c != undefined && c.surface_flag) { 
        c.surface_dirty = true; 
    } 
};

function gmui_container_surface_flag_enable_recursive(container = undefined) { 
    var c = container ?? global.gmui.current_container;
    if (c == undefined) return;
    
    c.surface_flag = true;
    c.surface_dirty = true;
    
    var children = ds_map_values_to_array(c.containers);
    for (var i = 0; i < array_length(children); i++) {
        gmui_container_surface_flag_enable_recursive(children[i]);
    }
};

function gmui_container_surface_flag_disable_recursive(container = undefined) { 
    var c = container ?? global.gmui.current_container;
    if (c == undefined) return;
    
    c.surface_flag = false;
    
    var children = ds_map_values_to_array(c.containers);
    for (var i = 0; i < array_length(children); i++) {
        gmui_container_surface_flag_disable_recursive(children[i]);
    }
};

function gmui_container_get_context() {
	var container = global.gmui.current_container;
	if (container == undefined) return undefined;
	
	return {
		cursor_x: container.context.cursor_x,
		cursor_y: container.context.cursor_y,
		line_height: container.context.line_height,
		remaining_width: container.width - container.context.cursor_x,
		remaining_height: container.height - container.context.cursor_y,
	};
};

/*
function gmui_begin_container(name, x = 0, y = 0, width = 100, height = 100, is_nested = true) {
	var gmui = global.gmui;
	var parent = is_nested ? gmui.current_container : undefined;
	var container = gmui_container_get(name, parent);
	var style = gmui.style;
	
	if (!container.is_enabled) { return false; };
	
	container.parent = parent;
	
	if (array_contains(gmui.input.hovered_container_array, container) && container.parent == undefined == gmui.input.m_pressed && container.z_interaction_enabled && ds_map_size(gmui.containers) > 0) {
        container.z_index = gmui.highest_z_index + 1;
	};
	
	if (container.parent != undefined && container.parent.context.new_line_requested && !container.parent.context.ignore_cursor_advance_once) {
		container.parent.context.cursor_y += container.parent.context.line_height + global.gmui.style.element_spacing_v;
		container.parent.context.line_height = 0;
		container.parent.context.new_line_requested = false;
		container.parent.context.cursor_x = global.gmui.style.container_padding_h + container.parent.context.indent_level;
	};
	
	var _x = x;
	var _y = y;
	
	if (container.parent != undefined) {
		_x = container.parent.context.cursor_x;
		_y = container.parent.context.cursor_y;
		
		if (container.parent.scrolling_enabled) {
			_x -= container.parent.scroll_x;
			_y -= container.parent.scroll_y;
		};
	};
	
	container.x = _x;
	container.y = _y;
	container.width = width;
	container.height = height;
	
	if (!container.initialized) { container.initialized = true; };
	
	if (container.parent != undefined && !container.parent.use_surface) {
        container.x_origin = container.parent.x + container.parent.x_origin;
        container.y_origin = container.parent.y + container.parent.y_origin;
    };
	
	container.context.cursor_x = style.container_padding_h;
	container.context.cursor_y = style.container_padding_v;
	container.context.line_height = 0;
	container.context.new_line_requested = false;
	
	container.context.widget_counter = 0;
	
	container.is_active = true;
	
	gmui.current_container = container;
	ds_stack_push(gmui.container_stack, container);
	
	gmui_container_scroll_wheel(container);
	
	if (container.scrolling_enabled && (container.content_height > container.height || container.content_width > container.width)) {
        var need_vertical = container.content_height > container.height;
        var need_horizontal = container.content_width > container.width;
        
        if (need_vertical || need_horizontal) {
            var sb_thickness = gmui.style.scrollbar_width + gmui.style.scrollbar_padding * 2;
            var saved_cursor_x = container.context.cursor_x;
            var saved_cursor_y = container.context.cursor_y;
            var saved_newline = container.context.new_line_requested;
            
            if (need_vertical) {
                container.context.cursor_x = container.width - sb_thickness - gmui.style.container_padding_h;
                container.context.cursor_y = gmui.style.container_padding_v;
                container.context.new_line_requested = false;
                
                container.scroll_y = gmui_scrollbar_vertical(
                    container.scroll_y,
                    0,
                    max(0, container.content_height - container.height),
                    container.height - gmui.style.container_padding_v * 2
                );
            }
            
            if (need_horizontal) {
                container.context.cursor_x = gmui.style.container_padding_h;
                container.context.cursor_y = container.height - sb_thickness - gmui.style.container_padding_v;
                container.context.new_line_requested = false;
                
                container.scroll_x = gmui_scrollbar_horizontal(
                    container.scroll_x,
                    0,
                    max(0, container.content_width - container.width),
                    container.width - gmui.style.container_padding_h * 2
                );
            }
            
            container.context.cursor_x = saved_cursor_x;
            container.context.cursor_y = saved_cursor_y;
            container.context.new_line_requested = saved_newline;
        }
    }
	
	container.content_width = 0;
	container.content_height = 0;
	
	return true;
};

function gmui_end_container() {
	var gmui = global.gmui;
	var container = global.gmui.current_container;
	
	var previous_container = ds_stack_pop(gmui.container_stack);
	var current_container = ds_stack_top(gmui.container_stack);
	gmui.current_container = current_container;
    
    if (current_container != undefined) {
		if (!current_container.context.ignore_cursor_advance_once) {
			current_container.context.cursor_x += previous_container.width + gmui.style.element_spacing_h;
			current_container.context.line_height = max(current_container.context.line_height, previous_container.height);
			
			gmui_newline();
			
			current_container.content_width = max(current_container.content_width, current_container.context.cursor_x);
			current_container.content_height = max(current_container.content_height, current_container.context.cursor_y + current_container.context.line_height);
		}
		else {
			current_container.context.ignore_cursor_advance_once = false;
		};
    }
};

function gmui_begin_container_plain(name, x = 0, y = 0, width = 100, height = 100) { // meant to be used by widgets such as dropdowns, hovers, popups etc.
	return gmui_begin_container(name, x, y, width, height, false);
};

function gmui_end_container_plain() {
    gmui_end_container();
};
*/

function gmui_begin_container(name, x = 0, y = 0, width = 100, height = 100) {
	var gmui = global.gmui;
	var container = gmui_container_get(name, gmui.current_container);
	var style = gmui.style;
	
	if ((container.surface_flag && !container.ignore_surface_flag_once) && array_contains(gmui.input.hovered_container_array, container)) { container.surface_dirty = true; if (variable_struct_exists(container, "content_container") && container.content_container.surface_flag) { container.content_container.surface_dirty = true; }; };
	
	if (!container.is_enabled) { return false; };
	
	container.parent = gmui.current_container;
	
	//if (array_contains(gmui.input.hovered_container_array, container) && container.parent == undefined && gmui.input.m_pressed && container.z_interaction_enabled && ds_map_size(gmui.containers) > 0) {
    //    container.z_index = gmui.highest_z_index + 1;
	//};
	
	if (container.parent != undefined && container.parent.context.new_line_requested && !container.parent.context.ignore_cursor_advance_once) { // new line
		container.parent.context.cursor_y += container.parent.context.line_height + global.gmui.style.element_spacing_v;
		container.parent.context.line_height = 0;
		container.parent.context.new_line_requested = false;
		container.parent.context.cursor_x = global.gmui.style.container_padding_h + container.parent.context.indent_level;
	}
	if (container.parent != undefined && container.parent.context.same_line_requested && !container.parent.context.ignore_cursor_advance_once) { // same line
		container.parent.context.cursor_x += global.gmui.style.element_spacing_h;
		container.parent.context.same_line_requested = false;
	}
	
	var _x = x;
	var _y = y;
	
	if (container.parent != undefined) {
		_x = container.parent.context.cursor_x;
		_y = container.parent.context.cursor_y;
		
		if (container.parent.scrolling_enabled) {
			_x -= container.parent.scroll_x;
			_y -= container.parent.scroll_y;
		};
	};
	
	container.x = _x;
	container.y = _y;
	if (container.width != width || container.height != height) {
	    container.width = width;
	    container.height = height;
		gmui_container_surface_create(container, undefined, true);
		if ((container.surface_flag && !container.ignore_surface_flag_once)) { container.surface_dirty = true; };
	};
	
	if (!container.initialized) { container.initialized = true; };
	
	if (container.parent != undefined && !container.parent.use_surface) {
        container.x_origin = container.parent.x + container.parent.x_origin;
        container.y_origin = container.parent.y + container.parent.y_origin;
    };
	
	container.context.cursor_x = style.container_padding_h;
	container.context.cursor_y = style.container_padding_v;
	container.context.line_height = 0;
	container.context.new_line_requested = false;
	container.context.same_line_requested = false;
    container.context.ignore_cursor_advance_once = false;
	container.context.widget_counter = 0;
	container.context.columns_counter = 0;
	container.context.rows_counter = 0;
    container.context.indent_level = 0;
	
    container.last_widget = undefined;
	container.is_active = true;
	
	gmui.current_container = container;
	ds_stack_push(gmui.container_stack, container);
	
	//gmui_container_scroll_wheel(container);
	
	//var need_vertical_scrollbar = container.content_height > container.height - style.container_padding_v * 2;
	//var need_horizontal_scrollbar = container.content_width > container.width - style.container_padding_h * 2;
	if (container.scrolling_enabled && (container.context.needs_vertical_scrollbar || container.context.needs_horizontal_scrollbar)) {
        var need_vertical = container.context.needs_vertical_scrollbar && container.scrolling_enabled_vertical && container.scroll_widget_vertical;
        var need_horizontal = container.context.needs_horizontal_scrollbar && container.scrolling_enabled_horizontal && container.scroll_widget_horizontal;
        
        if (need_vertical || need_horizontal) {
            var sb_thickness = gmui.style.scrollbar_width;
            var saved_cursor_x = container.context.cursor_x;
            var saved_cursor_y = container.context.cursor_y;
            var saved_newline = container.context.new_line_requested;
            
            if (need_vertical) {
                container.context.cursor_x = container.width - sb_thickness - gmui.style.scrollbar_padding;
                container.context.cursor_y = gmui.style.container_padding_v + gmui.style.scrollbar_padding;
                container.context.new_line_requested = false;
                
                container.scroll_y = gmui_scrollbar_vertical(
                    container.scroll_y,
                    0,
                    max(0, container.content_height + style.container_padding_v * 2 - container.height),
                    container.height - gmui.style.container_padding_v * 2 - gmui.style.scrollbar_padding * 2
                );
            }
            
            if (need_horizontal) {
                container.context.cursor_x = gmui.style.container_padding_h + gmui.style.scrollbar_padding;
                container.context.cursor_y = container.height - sb_thickness - gmui.style.scrollbar_padding;
                container.context.new_line_requested = false;
                
                container.scroll_x = gmui_scrollbar_horizontal(
                    container.scroll_x,
                    0,
                    max(0, container.content_width + style.container_padding_h * 2 - container.width),
                    container.width - gmui.style.container_padding_h * 2 - gmui.style.scrollbar_padding * 2
                );
            }
            
            container.context.cursor_x = saved_cursor_x;
            container.context.cursor_y = saved_cursor_y;
            container.context.new_line_requested = saved_newline;
        }
    }
	
	if ((container.surface_flag && !container.ignore_surface_flag_once) && container.surface_sleep && !container.surface_dirty) { gmui_end_container(); return false; };
	
	container.content_width = 0;
	container.content_height = 0;
	
	return true;
};

function gmui_end_container() {
	var gmui = global.gmui;
	var container = global.gmui.current_container;
	
	if (container.scrolling_enabled) {
		if (!container.scrolling_enabled_horizontal || !container.context.needs_horizontal_scrollbar && container.scroll_x != 0) {
			container.scroll_x = 0;
		}
		if (!container.scrolling_enabled_vertical || !container.context.needs_vertical_scrollbar && container.scroll_y != 0) {
			container.scroll_y = 0;
		}
	}
	
	var previous_container = ds_stack_pop(gmui.container_stack);
	var current_container = ds_stack_top(gmui.container_stack);
	gmui.current_container = current_container;
    
    if (current_container != undefined) {
		if (!current_container.context.ignore_cursor_advance_once) {
			current_container.context.cursor_x += previous_container.width;
			current_container.context.line_height = max(current_container.context.line_height, previous_container.height);
			
			gmui_newline();
			
			current_container.content_width = max(current_container.content_width, current_container.context.cursor_x - gmui.style.container_padding_h);
			current_container.content_height = max(current_container.content_height, current_container.context.cursor_y + current_container.context.line_height - gmui.style.container_padding_v);
			
			current_container.context.needs_horizontal_scrollbar = current_container.content_width > current_container.width - gmui.style.container_padding_h * 2;
			current_container.context.needs_vertical_scrollbar = current_container.content_height > current_container.height - gmui.style.container_padding_v * 2;
		}
		else {
			current_container.context.ignore_cursor_advance_once = false;
		};
		
		global.gmui.last_widget = previous_container;
    }
};

function gmui_begin_container_plain(name, x, y, width, height) { // meant to be used by widgets such as dropdowns, hovers, popups etc.
    var gmui = global.gmui;
	var container = gmui_container_get(name, undefined);
    var style = gmui.style;
	
	if (!container.is_enabled) { return false; };
	
	if ((container.surface_flag && !container.ignore_surface_flag_once) && array_contains(gmui.input.hovered_container_array, container)) { container.surface_dirty = true; if (variable_struct_exists(container, "content_container") && container.content_container.surface_flag) { container.content_container.surface_dirty = true; }; };
	
    container.parent = undefined;
	
	//if (array_contains(gmui.input.hovered_container_array, container) && container.parent == undefined && gmui.input.m_pressed && container.z_interaction_enabled && ds_map_size(gmui.containers) > 0) {
    //    container.z_index = gmui.highest_z_index + 1;
	//};
    
    container.x = x;
    container.y = y;
	if (container.width != width || container.height != height) {
	    container.width = width;
	    container.height = height;
		gmui_container_surface_create(container, undefined, true);
		if ((container.surface_flag && !container.ignore_surface_flag_once)) { container.surface_dirty = true; };
	};
	
	if (!container.initialized) { container.initialized = true; };
	
	if (container.parent == undefined && 
	    array_contains(gmui.input.hovered_container_array, container) && 
	    gmui.input.m_pressed && 
	    container.z_interaction_enabled) {
	    gmui_container_bring_to_front(container.name);
	}
    
    container.x_origin = 0;
    container.y_origin = 0;
    
    container.context.cursor_x = style.container_padding_h;
    container.context.cursor_y = style.container_padding_v;
    container.context.line_height = 0;
    container.context.new_line_requested = false;
    container.context.same_line_requested = false;
    container.context.indent_level = 0;
    container.context.widget_counter = 0;
	container.context.columns_counter = 0;
	container.context.rows_counter = 0;
    container.context.ignore_cursor_advance_once = false;
    
    //container.content_width = 0;
    //container.content_height = 0;
    container.last_widget = undefined;
    container.is_active = true;
    
    gmui.current_container = container;
    ds_stack_push(gmui.container_stack, container);
    
    //gmui_container_scroll_wheel(container);
    
	//var need_vertical_scrollbar = container.content_height > container.height - style.container_padding_v * 2;
	//var need_horizontal_scrollbar = container.content_width > container.width - style.container_padding_h * 2;
	if (container.scrolling_enabled && (container.context.needs_vertical_scrollbar || container.context.needs_horizontal_scrollbar)) {
        var need_vertical = container.context.needs_vertical_scrollbar && container.scrolling_enabled_vertical && container.scroll_widget_vertical;
        var need_horizontal = container.context.needs_horizontal_scrollbar && container.scrolling_enabled_horizontal && container.scroll_widget_horizontal;
        
        if (need_vertical || need_horizontal) {
            var sb_thickness = gmui.style.scrollbar_width;
            var saved_cursor_x = container.context.cursor_x;
            var saved_cursor_y = container.context.cursor_y;
            var saved_newline = container.context.new_line_requested;
            
            if (need_vertical) {
                container.context.cursor_x = container.width - sb_thickness - gmui.style.scrollbar_padding;
                container.context.cursor_y = gmui.style.container_padding_v + gmui.style.scrollbar_padding;
                container.context.new_line_requested = false;
                
                container.scroll_y = gmui_scrollbar_vertical(
                    container.scroll_y,
                    0,
                    max(0, container.content_height + style.container_padding_v * 2 - container.height),
                    container.height - gmui.style.container_padding_v * 2 - gmui.style.scrollbar_padding * 2
                );
            }
            
            if (need_horizontal) {
                container.context.cursor_x = gmui.style.container_padding_h + gmui.style.scrollbar_padding;
                container.context.cursor_y = container.height - sb_thickness - gmui.style.scrollbar_padding;
                container.context.new_line_requested = false;
                
                container.scroll_x = gmui_scrollbar_horizontal(
                    container.scroll_x,
                    0,
                    max(0, container.content_width + style.container_padding_h * 2 - container.width),
                    container.width - gmui.style.container_padding_h * 2 - gmui.style.scrollbar_padding * 2
                );
            }
            
            container.context.cursor_x = saved_cursor_x;
            container.context.cursor_y = saved_cursor_y;
            container.context.new_line_requested = saved_newline;
        }
    }
	
	if ((container.surface_flag && !container.ignore_surface_flag_once) && container.surface_sleep && !container.surface_dirty) { gmui_end_container_plain(); return false; };
    
    container.content_width = 0;
    container.content_height = 0;
	
    return true;
};

function gmui_end_container_plain() {
    var gmui = global.gmui;
    var container = gmui.current_container;
    
    ds_stack_pop(gmui.container_stack);
    gmui.current_container = ds_stack_top(gmui.container_stack);
};

function gmui_begin_container_flow(name, x = 0, y = 0, width = 100, height = 100) {
	var gmui = global.gmui;
	var container = gmui_container_get(name, gmui.current_container);
	container.context.flow = true;
	return gmui_begin_container(name, x, y, width, height);
};

function gmui_end_container_flow() {
	gmui_end_container();
};

function gmui_container_surface_create(container, format = surface_rgba8unorm, refresh = false) {
	if (surface_exists(container.surface)) {
		if (refresh) {
			surface_free(container.surface);
		}
		else {
			return;
		};
	};
	container.surface = surface_create(max(container.width, 1), max(container.height, 1), format);
};

function gmui_container_surface_free(container) {
	if (surface_exists(container.surface)) { surface_free(container.surface); };
};

function gmui_handle_container_calls(container) {
	var gmui = global.gmui;
	var style = gmui.style;
	
	gmui.current_container = container;
	var calls = container.calls;
	for (var i = 0, n = array_length(calls); i < n; i++) {
	    var call = calls[i];
		var origin_x = 0;
		var origin_y = 0;
	
		if (!surface_exists(container.surface)) {
		    origin_x = container.x + container.x_origin;
		    origin_y = container.y + container.y_origin;
		}
		if (container.scrolling_enabled) {
		    origin_x -= container.scroll_x;
		    origin_y -= container.scroll_y;
		}
	
		gmui_handle_call(call, origin_x, origin_y);
	};
	
	if (container.widget_flag) {
		for (var i = 0, n = array_length(container.widgets); i < n; i++) {
			var widget = container.widgets[i];
			if (!gmui_widget_is_visible(widget) || !widget.is_active) { continue; }
			for (var j = 0; j < array_length(widget.calls); j++) {
				var call = widget.calls[j];
				var origin_x = 0;
				var origin_y = 0;
	
				if (!surface_exists(container.surface)) {
				    origin_x = container.x + container.x_origin;
				    origin_y = container.y + container.y_origin;
				}
				if (container.scrolling_enabled) {
				    origin_x -= container.scroll_x;
				    origin_y -= container.scroll_y;
				}
	
				gmui_handle_call(call, origin_x, origin_y);
			};
			widget.is_active = false;
		};
	}
	
	gmui.current_container = undefined;
	
	for (var i = 0, n = array_length(container.containers_sorted); i < n; i++) {
		var c = container.containers_sorted[i];
		if (!c.is_active || !c.is_enabled) { continue; };
	
		gmui_draw_container(c);
	};
	
	gmui.current_container = container;
	var late_calls = container.late_calls;
	for (var i = 0, n = array_length(late_calls); i < n; i++) {
	    var call = late_calls[i];
		var origin_x = 0;
		var origin_y = 0;
	
		if (!surface_exists(container.surface)) {
		    origin_x = container.x + container.x_origin;
		    origin_y = container.y + container.y_origin;
		}
		if (container.scrolling_enabled) {
		    origin_x -= container.scroll_x;
		    origin_y -= container.scroll_y;
		}
	
		gmui_handle_call(call, origin_x, origin_y);
	};
};

function gmui_container_early_exit_cleanup(container) {
	if (container.context.previous_widget_counter != container.context.widget_counter) {
		container.widget_flag_layout_changed = true;
	};
	container.context.previous_widget_counter = container.context.widget_counter;
    if (!container.widget_flag) { container.widgets = [ ]; ds_map_clear(container.widget_map); };
	container.calls = [ ];
	container.late_calls = [ ];
	if (variable_struct_exists(container, "_tb_counter")) { variable_struct_remove(container, "_tb_counter"); };
	if (variable_struct_exists(container, "_lb_counter")) { variable_struct_remove(container, "_lb_counter"); };
	if (container.ignore_surface_flag_once) { container.ignore_surface_flag_once = false; };
	if (container.ignore_round_style) { gmui_style_pop("container_rounding"); };
    for (var i = 0, n = array_length(container.containers_sorted); i < n; i++) {
        var c = container.containers_sorted[i];
        if (!c.is_active || !c.is_enabled) { continue; };
        gmui_container_early_exit_cleanup(c);
    };
    container.containers_sorted = [ ];
};

function gmui_draw_container(container) {
	var gmui = global.gmui;
	var style = gmui.style;
	
	if (!container.is_enabled || !container.is_active) { return; };
	
	if (container.ignore_round_style) { gmui_style_push("container_rounding", 0); };
	
	if (container.use_surface) { gmui_container_surface_create(container); if (container.mask_enabled && !surface_exists(container.mask_surface)) { container.mask_surface = surface_create(container.width, container.height); }; } 
	else if (surface_exists(container.surface)) { gmui_container_surface_free(container); if (surface_exists(container.mask_surface)) { surface_free(container.mask_surface); }; };
	
	if (container.use_surface && (container.surface_flag && !container.ignore_surface_flag_once) && !container.surface_dirty) {
	    draw_surface(container.surface, container.x + container.x_origin, container.y + container.y_origin);
	    gmui_container_early_exit_cleanup(container);
		return;
	};
	
	if (container.parent != undefined && container.parent.use_surface && container.use_surface) { surface_reset_target(); };
	if (surface_exists(container.surface)) { surface_set_target(container.surface); draw_clear_alpha(c_black, 0); gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_one, bm_inv_src_alpha); };
	
	if (container.use_scissor) {
	    var scissor_x = container.use_surface ? 0 : container.x + container.x_origin;
	    var scissor_y = container.use_surface ? 0 : container.y + container.y_origin;
	    var scissor_w = container.width;
	    var scissor_h = container.height;
    
	    if (container.use_surface) {
	        gmui_push_scissor_isolated(scissor_x, scissor_y, scissor_w, scissor_h);
	    } else {
	        gmui_begin_scissor(scissor_x, scissor_y, scissor_w, scissor_h);
	    }
	} else if (container.use_surface) {
	    var scissor_x = container.use_surface ? 0 : container.x + container.x_origin;
	    var scissor_y = container.use_surface ? 0 : container.y + container.y_origin;
	    var scissor_w = container.width;
	    var scissor_h = container.height;
		
	    gmui_push_scissor_isolated(scissor_x, scissor_y, scissor_w, scissor_h);
	};
	
	var use_scroll = container.scrolling_enabled;
	var background_origin_x = 0;
	var background_origin_y = 0;
	if (!surface_exists(container.surface)) {
	    background_origin_x = container.x + container.x_origin;
	    background_origin_y = container.y + container.y_origin;
	}
	if (use_scroll) {
	    background_origin_x -= container.scroll_x;
	    background_origin_y -= container.scroll_y;
	}
	
	if (container.background_enabled) {
		if (container.background_draw_func != undefined) { container.background_draw_func(container, background_origin_x + container.scroll_x, background_origin_y + container.scroll_y, background_origin_x + container.scroll_x + container.width, background_origin_y + container.scroll_y + container.height); };
		if (container.mask_enabled && container.use_surface) {
			surface_set_target(container.mask_surface);
			draw_clear_alpha(c_black, 0);
			if (container.mask_draw_func != undefined) { container.mask_draw_func(container, background_origin_x + container.scroll_x, background_origin_y + container.scroll_y, background_origin_x + container.scroll_x + container.width, background_origin_y + container.scroll_y + container.height); };
			surface_reset_target();
		}
	}
	
	gmui_handle_container_calls(container);
	
	if (container.context.previous_widget_counter != container.context.widget_counter) {
		container.widget_flag_layout_changed = true;
	};
	container.context.previous_widget_counter = container.context.widget_counter;
    if (!container.widget_flag) { container.widgets = [ ]; ds_map_clear(container.widget_map); };
	container.calls = [ ];
	container.late_calls = [ ];
	if (variable_struct_exists(container, "_tb_counter")) { variable_struct_remove(container, "_tb_counter"); };
	if (variable_struct_exists(container, "_lb_counter")) { variable_struct_remove(container, "_lb_counter"); };
	
	gmui.current_container = undefined;
	
	if (container.use_scissor || container.use_surface) {
		gmui_end_scissor();
	};
	
	if (container.mask_enabled && container.use_surface) {
		var old_blend = gpu_get_blendmode();
		gpu_set_blendmode(bm_subtract);
		draw_surface(container.mask_surface, 0, 0);
		gpu_set_blendmode(old_blend);
	}
	
	if (container.use_surface) { surface_reset_target(); };
	if (container.parent != undefined && container.parent.use_surface && container.use_surface) { surface_set_target(container.parent.surface); };
	
	container.containers_sorted = [ ];
	container.is_mouse_hovering = false;
	
	if (container.use_surface) {
		draw_surface(container.surface, container.x + container.x_origin, container.y + container.y_origin);
	};
	
	if ((container.surface_flag && !container.ignore_surface_flag_once)) { container.surface_dirty = false; };
	if (container.ignore_surface_flag_once) { container.ignore_surface_flag_once = false; };
	if (container.ignore_round_style) { gmui_style_pop("container_rounding"); };
	if (container.widget_flag_layout_changed) {
		container.widgets = [ ];
		ds_map_clear(container.widget_map);
		container.widget_flag_layout_changed = false;
	};
};

function gmui_get_container_screen_offset(container) {
	var offset_x = 0;
	var offset_y = 0;
	
	var current = container;
	while (current != undefined) {
		offset_x += current.x;
		offset_y += current.y;
		current = current.parent;
	}
	
	return [offset_x, offset_y];
};

function gmui_container_sort_z_index(container) {
	//container.containers_sorted = ds_map_values_to_array(container.containers);
	//array_sort(container.containers_sorted, function(a, b) { return a.z_index - b.z_index; });
	//for (var i = 0; i < array_length(container.containers_sorted); i++) {
	//	var c = container.containers_sorted[i];
	//	if (!c.is_enabled) { continue; };
	//	gmui_container_calculate_mouse_hovering(c);
	//	gmui_container_sort_z_index(c);
	//};
	
	var current_size = ds_map_size(container.containers);
    if (array_length(container.containers_sorted) != current_size) {
        container.containers_sorted = ds_map_values_to_array(container.containers);
        array_sort(container.containers_sorted, function(a, b) { return a.z_index - b.z_index; });
    }
    for (var i = 0; i < array_length(container.containers_sorted); i++) {
        var c = container.containers_sorted[i];
        gmui_container_sort_z_index(c);
    };
};

function gmui_container_calculate_mouse_hovering(container) {
	//var gmui = global.gmui;
	//var offset = gmui_get_container_screen_offset(container);
	//
	//var local_mx = gmui.input.m_x - offset[0];
	//var local_my = gmui.input.m_y - offset[1];
	//
	//container.is_mouse_hovering = point_in_rectangle(
	//    local_mx, local_my, 
	//    0, 0,
	//    container.width, 
	//    container.height
	//) && (container.parent != undefined ? container.parent.is_mouse_hovering : true);
	
	var gmui = global.gmui;
    var offset = gmui_get_container_screen_offset(container);
    
    var local_mx = gmui.input.m_x - offset[0];
    var local_my = gmui.input.m_y - offset[1];
    
    container.is_mouse_hovering = point_in_rectangle(
        local_mx, local_my, 
        0, 0,
        container.width, 
        container.height
    ) && (container.parent != undefined ? container.parent.is_mouse_hovering : true);
    
    if (container.is_mouse_hovering) {
		//if (gmui.input.hovered_container == undefined) { gmui.input.hovered_container = container; };
        gmui.input.hovered_container = container;
		if (container.parent == undefined) { gmui.input.hovered_container_array = [ container ]; };
		//if (gmui.input.hovered_container == undefined || gmui.input.hovered_container == container.parent) {
		//	gmui.input.hovered_container = container;
		//}
		for (var i = 0; i < array_length(container.containers_sorted); i++) {
            var c = container.containers_sorted[i];
            if (!c.is_enabled || !c.is_active) { continue; };
            gmui_container_calculate_mouse_hovering(c);
			if (c.is_mouse_hovering && array_length(gmui.input.hovered_container_array) >= 1) { array_push(gmui.input.hovered_container_array, c); };
			c.is_active = false;
		}
    };
};

//function gmui_container_scroll_wheel(container) {
//    var gmui = global.gmui;
//    if (gmui.input.hovered_container != container) return;
//    container.scroll_x -= gmui.input.m_wheel * container.scroll_speed * gmui_input_alt();
//    container.scroll_y -= gmui.input.m_wheel * container.scroll_speed * !gmui_input_alt();
//    var max_scroll_y = max(0, container.content_height - container.height);
//    var max_scroll_x = max(0, container.content_width - container.width);
//    container.scroll_x = clamp(container.scroll_x, 0, max_scroll_x);
//    container.scroll_y = clamp(container.scroll_y, 0, max_scroll_y);
//};

function gmui_handle_scroll_bubble() {
    var gmui = global.gmui;
	var style = gmui.style;
    var input = gmui.input;
    
    if (input.m_wheel == 0) return;
    
    var current = input.hovered_container;
    
    while (current != undefined && current.scrolling_enabled) {
		var need_vertical_scrollbar = current.context.needs_vertical_scrollbar && current.scrolling_enabled_vertical;
		var need_horizontal_scrollbar = current.context.needs_horizontal_scrollbar && current.scrolling_enabled_horizontal;
		if (need_vertical_scrollbar) {
            var max_scroll_y = max(0, current.content_height + style.container_padding_v * 2 - current.height);
            var scroll_y_amount = -input.m_wheel * current.scroll_speed * !gmui_input_alt();
            var new_scroll_y = clamp(current.scroll_y + scroll_y_amount, 0, max_scroll_y);
            if (new_scroll_y != current.scroll_y) {
                current.scroll_y = new_scroll_y;
                return;
            }
		}
		if (need_horizontal_scrollbar) {
            var max_scroll_x = max(0, current.content_width + style.container_padding_h * 2 - current.width);
            var scroll_x_amount = -input.m_wheel * current.scroll_speed * gmui_input_alt();
            var new_scroll_x = clamp(current.scroll_x + scroll_x_amount, 0, max_scroll_x);
            if (new_scroll_x != current.scroll_x) {
                current.scroll_x = new_scroll_x;
                return;
            }
		}
        current = current.parent;
    }
}

function gmui_container_ignore_cursor_advance_once(container = undefined) {
	if (container == undefined) {
		global.gmui.current_container.context.ignore_cursor_advance_once = true;
	}
	else {
		container.context.ignore_cursor_advance_once = true
	};
};

function gmui_container_cursor_advance(container = undefined) {
	var c = container ?? global.gmui.current_container;
	if (c == undefined) { return; };
	var context = c.context;
	if (c.context.flow && c.last_widget != undefined && context.cursor_x + c.last_widget.width < c.width - global.gmui.style.container_padding_h * 2) { // as long as it fits, keep it on the same line
		gmui_sameline();
	}
	if (context.new_line_requested && !context.ignore_cursor_advance_once) { // new line
		context.cursor_y += context.line_height + global.gmui.style.element_spacing_v;
		context.line_height = 0;
		context.new_line_requested = false;
		context.cursor_x = global.gmui.style.container_padding_h + context.indent_level;
	}
	if (context.same_line_requested && !context.ignore_cursor_advance_once) { // same line
		context.cursor_x += global.gmui.style.element_spacing_h;
		context.same_line_requested = false;
	}
};

function gmui_container_destroy(container) {
    var gmui = global.gmui;
    
    if (surface_exists(container.surface)) { surface_free(container.surface); }
    if (surface_exists(container.mask_surface)) { surface_free(container.mask_surface); }
    
    container.calls = [];
    container.late_calls = [];
    container.widgets = [];
    container.containers_sorted = [];
    
    if (ds_map_exists(container.state, "_tree_open_nodes")) {
        ds_map_destroy(container.state[? "_tree_open_nodes"]);
    }
    
    if (container.parent == undefined) { ds_map_delete(gmui.containers, container.name); }
    
    if (ds_map_size(container.containers) > 0) {
        var e_a = ds_map_keys_to_array(container.containers);
        for (var i = 0; i < array_length(e_a); i++) {
            var c = container.containers[? e_a[i]];
            gmui_container_destroy(c);
        }
    }
    
    ds_map_destroy(container.containers);
    ds_map_destroy(container.widget_map);
    ds_map_destroy(container.state);
};

function gmui_container_is_active(name, parent = undefined) {
    var container = gmui_container_get(name, parent);
    return container != undefined && container.is_enabled;
};

function gmui_container_enable(name, parent = undefined) {
    var container = gmui_container_get(name, parent);
    if (container != undefined) {
        container.is_enabled = true;
    }
};

function gmui_container_disable(name, parent = undefined) {
    var container = gmui_container_get(name, parent);
    if (container != undefined) {
        container.is_enabled = false;
    }
};

function gmui_container_toggle(name, parent = undefined) {
    var container = gmui_container_get(name, parent);
    if (container != undefined) {
        container.is_enabled = !container.is_enabled;
    }
    return container.is_enabled;
};

function gmui_container_set_pos(name, x, y, parent = undefined) {
    var container = gmui_container_get(name, parent);
    if (container != undefined) {
        container.x = x;
        container.y = y;
    }
};

function gmui_container_get_screen_pos(name, parent = undefined) {
    var container = gmui_container_get(name, parent);
    if (container != undefined) {
        var offset = gmui_get_container_screen_offset(container);
        return [offset[0], offset[1]];
    }
    return [0, 0];
};

function gmui_container_set_size(name, w, h, parent = undefined) {
    var container = gmui_container_get(name, parent);
    if (container != undefined && (w != container.width || h != container.height)) {
        container.width = max(w, 1);
        container.height = max(h, 1);
        if (container.use_surface) {
			gmui_container_surface_create(container, undefined, true);
        }
    }
};

function gmui_container_set_width(name, w, parent = undefined) {
    var container = gmui_container_get(name, parent);
    if (container != undefined && w != container.width) {
        container.width = max(w, 1);
        if (container.use_surface) {
			gmui_container_surface_create(container, undefined, true);
        }
    }
};

function gmui_container_set_height(name, h, parent = undefined) {
    var container = gmui_container_get(name, parent);
    if (container != undefined && h != container.height) {
        container.height = max(h, 1);
        if (container.use_surface) {
			gmui_container_surface_create(container, undefined, true);
        }
    }
};

function gmui_container_get_size(name, parent = undefined) {
    var container = gmui_container_get(name, parent);
    if (container != undefined) {
        return [container.width, container.height];
    }
    return [0, 0];
};

function gmui_container_set_bounds(name, x, y, w, h, parent = undefined) {
    gmui_container_set_pos(name, x, y, parent);
    gmui_container_set_size(name, w, h, parent);
};

function gmui_container_get_bounds(name, parent = undefined) {
    var container = gmui_container_get(name, parent);
	var pos = [ container.x, container.y ];
    var size = gmui_container_get_size(name, parent);
    return [pos[0], pos[1], size[0], size[1]];
};

function gmui_container_bring_to_front(name, parent = undefined) {
    var container = gmui_container_get(name, parent);
    if (container == undefined) return;
    
    if (container.layer == 2 || container.layer == 0) return;
    
    var layer_data = gmui_get_layer_data(container.layer);
    layer_data.highest++;
    container.z_index = layer_data.base + layer_data.highest;
};

function gmui_container_send_to_back(name) {
    var container = gmui_container_get(name, undefined);
    if (container == undefined) return;
    
    if (container.layer == 0 || container.layer == 2) return;
    
    var layer_data = gmui_get_layer_data(container.layer);
    container.z_index = layer_data.base + 1;
};

function gmui_container_set_z(name, z, parent = undefined) {
    var container = gmui_container_get(name, parent);
    if (container != undefined) {
        container.z_index = z;
    }
};

function gmui_container_get_z(name, parent = undefined) {
    var container = gmui_container_get(name, parent);
    if (container != undefined) {
        return container.z_index;
    }
    return 0;
};

function gmui_container_set_surface(name, enable, parent = undefined) {
    var container = gmui_container_get(name, parent);
    if (container != undefined) {
        container.use_surface = enable;
        if (enable && !surface_exists(container.surface)) {
            container.surface = surface_create(container.width, container.height);
        }
        if (!enable && surface_exists(container.surface)) {
            surface_free(container.surface);
            container.surface = -1;
        }
    }
};

function gmui_container_is_hovered(name, parent = undefined) {
    var container = gmui_container_get(name, parent);
    if (container == undefined) return false;
    return container.is_mouse_hovering;
};

function gmui_group(name, func) {
    gmui_begin_container(name);
    func();
    gmui_end_container();
};

function gmui_group_ex(name, width, height, func) {
    gmui_begin_container(name, undefined, undefined, width, height);
    func();
    gmui_end_container();
};

function gmui_child(name, width, height, func) {
    if (gmui_begin_child(name, width, height)) {
        func();
        gmui_end_child();
        return true;
    }
    return false;
};

function gmui_scrolling_child(name, width, height, func) {
    if (gmui_begin_child(name, width, height)) {
        var container = global.gmui.current_container;
        container.scrolling_enabled = true;
        func();
        gmui_end_child();
        return true;
    }
    return false;
};

function gmui_container_animation_detected(container = undefined) {
	var _container = container ?? global.gmui.current_container;
	if (global.gmui.current_container == undefined) { return; };
	//if (!_container.animation_flag) { return; };
	var current = _container;
	while (current != undefined) {
		current.ignore_surface_flag_once = true;
		current = current.parent;
	};
	global.gmui.ignore_widget_flag_once = true;
};