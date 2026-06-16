

// WIDGETS
function gmui_begin_widget(type = "unnamed") {
	var gmui = global.gmui;
	var container = gmui.current_container;
	var context = container.context;
	
	gmui_container_cursor_advance();
    
    var widget_id = context.widget_counter;
    context.widget_counter++;
	
	var _id = "widget_" + type + "_id_" + container.name + "_" + string(widget_id);
	
	var widget = undefined;
	
	widget = {
		gmui: gmui,
		container: container,
		context: container.context,
		x: container.context.cursor_x,
		y: container.context.cursor_y,
		width: 0,
		height: 0,
		type: type,
		id: _id,
	};
	array_push(container.widgets, widget);
	
	container.current_widget = widget;
	
	return widget;
};

//function gmui_end_widget(widget) {
//	widget.context.cursor_x += widget.width + widget.gmui.style.element_spacing_h;
//	widget.context.line_height = max(widget.context.line_height, widget.height);
//	gmui_newline();
//	
//	widget.container.content_width = max(widget.container.content_width, widget.context.cursor_x);
//	widget.container.content_height = max(widget.container.content_height, widget.context.cursor_y + widget.context.line_height);
//	
//	var gmui = widget.gmui;
//	var offset = gmui_get_container_screen_offset(widget.container);
//	var hovered = gmui_widget_is_hovered(widget);
//	
//	if (hovered) {
//		gmui.input.hovered_widget_id = widget.id;
//	}
//	
//	array_push(widget.container.widgets, {
//		id: widget.id,
//		x: widget.x,
//		y: widget.y,
//		width: widget.width,
//		height: widget.height,
//		screen_x: widget.x + offset[0],
//		screen_y: widget.y + offset[1],
//	});
//};

function gmui_end_widget(widget, is_interactive = false) {
	if (!widget.context.ignore_cursor_advance_once) {
	    widget.context.cursor_x += widget.width;
	    widget.context.line_height = max(widget.context.line_height, widget.height);
	    gmui_newline();
    
	    widget.container.content_width = max(widget.container.content_width, widget.context.cursor_x - widget.gmui.style.container_padding_h);
	    widget.container.content_height = max(widget.container.content_height, widget.context.cursor_y + widget.context.line_height - widget.gmui.style.container_padding_v);
		
		widget.container.context.needs_horizontal_scrollbar = widget.container.content_width > widget.container.width - widget.gmui.style.container_padding_h * 2;
		widget.container.context.needs_vertical_scrollbar = widget.container.content_height > widget.container.height - widget.gmui.style.container_padding_v * 2;
	}
	else {
		widget.context.ignore_cursor_advance_once = false;
	};
    
	global.gmui.last_widget = widget;
	
	var gmui = widget.gmui;
	var offset = gmui_get_container_screen_offset(widget.container);
	var hovered = gmui_widget_is_hovered(widget, offset);
    
	if (hovered) {
	    gmui.input.hovered_widget_id = widget.id;
	}
	
	widget.screen_x = widget.x + offset[0];
	widget.screen_y = widget.y + offset[1];
	
	widget.container.current_widget = undefined;
};

function gmui_widget_is_callable(widget) {
	return gmui_widget_is_visible(widget);
};

function gmui_widget_is_visible(widget) {
    var container = widget.container;
    if (!container.scrolling_enabled) return true;
    
    var wx = widget.x;
    var wy = widget.y;
    var ww = widget.width;
    var wh = widget.height;
    
    var view_x = container.scroll_x;
    var view_y = container.scroll_y;
    var view_w = container.width;
    var view_h = container.height;
    
    return (wx + ww > view_x && wx < view_x + view_w &&
            wy + wh > view_y && wy < view_y + view_h);
};

//function gmui_widget_is_hovered(widget) {
//	var gmui = global.gmui;
//	var offset = gmui_get_container_screen_offset(widget.container);
//	
//	var local_mx = gmui.input.m_x - offset[0];
//	var local_my = gmui.input.m_y - offset[1];
//    
//    if (widget.container.scrolling_enabled) {
//        local_mx += widget.container.scroll_x;
//        local_my += widget.container.scroll_y;
//    }
//	
//	return point_in_rectangle(
//		local_mx, 
//		local_my, 
//		widget.x, 
//		widget.y, 
//		widget.x + widget.width, 
//		widget.y + widget.height
//	) && widget.container.is_mouse_hovering;
//};

function gmui_widget_is_hovered(widget, _offset) {
	var gmui = global.gmui;
    
    if (gmui.input.active_widget_id != undefined && gmui.input.active_widget_id != widget.id) {
        return false;
    }
    
    if (gmui.input.hovered_widget_id != undefined && gmui.input.hovered_widget_id != widget.id) {
        return false;
    }
    
	var offset = is_undefined(_offset) ? gmui_get_container_screen_offset(widget.container) : _offset;
	var local_mx = gmui.input.m_x - offset[0];
	var local_my = gmui.input.m_y - offset[1];
	if (widget.container.scrolling_enabled) {
		local_mx += widget.container.scroll_x;
		local_my += widget.container.scroll_y;
	}
    
    var is_hovered = point_in_rectangle(
		local_mx, local_my,
		widget.x, widget.y,
		widget.x + widget.width, widget.y + widget.height
	) && gmui.input.hovered_container != undefined && gmui.input.hovered_container.name == widget.container.name;
    
    if (is_hovered) {
        gmui.input.hovered_widget_id = widget.id;
    }
    
	return is_hovered;
};

function gmui_widget_is_pressed(widget) {
	var gmui = global.gmui;
	var hovered = gmui_widget_is_hovered(widget);
	if (hovered && gmui_input_mouse_pressed()) {
		gmui.input.active_widget_id = widget.id;
		return true;
	}
	if (gmui_input_mouse_held() && gmui.input.active_widget_id == widget.id) {
		return true;
	}
	return false;
};

function gmui_widget_is_active(widget) {
	var gmui = global.gmui;
	return (gmui.input.active_widget_id == widget.id);
};

function gmui_widget_mouse_interactive_behaviour(widget) {
	var hovered = gmui_widget_is_hovered(widget);
	gmui_widget_is_pressed(widget);
	var active = gmui_widget_is_active(widget);
    
	var released = hovered && active && gmui_input_mouse_released();
    
	return {
		is_hovering: hovered,
		is_active: active,
		is_pressed: released
	};
};

function gmui_widget_get_last() {
	return global.gmui.last_widget;
};

// Elements
/*
basic workflow as follows;

base variables:
var gmui = global.gmui;
var style = gmui.style;
var widget = gmui_begin_widget("text");

widget related variables:
var text_size = gmui_calculate_text_size(text);
var padding_h = style.button_padding_h;
var padding_v = style.button_padding_v;

apply required changes to the widget structure:
widget.width = text_size[0] + padding_h * 2;
widget.height = text_size[1] + padding_v * 2;

input state:
var hovered = gmui_widget_is_hovered(widget);
var active = gmui_widget_is_active(widget);
var pressed = gmui_widget_is_pressed(widget);
var released = hovered && gmui_input_mouse_released();

[do the required drawings with the informations you've calculated]

end the widget:
gmui_end_widget(widget);

[return]
*/





















