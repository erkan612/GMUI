

// button
function gmui_button(text, font = undefined) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("button");
    
    var text_size = gmui_calculate_text_size(text);
    
    widget.width = max(style.button_min_width, text_size[0] + style.button_padding_h * 2);
    widget.height = max(style.button_min_height, text_size[1] + style.button_padding_v * 2);
    
	var released = false;
	var _font = gmui_resolve_font(widget, font);
	
	if (gmui_widget_is_callable(widget)) {
		var mouse_interaction = gmui_widget_mouse_interactive_behaviour(widget);
		
	    var hovered = mouse_interaction.is_hovering;
	    var active = mouse_interaction.is_active;
	    released = mouse_interaction.is_pressed;
    
	    var bg_color = style.button_color_idle;
	    if (active) bg_color = style.button_color_active;
	    else if (hovered) bg_color = style.button_color_hovered;
    
	    gmui_add_roundrect(widget.x, widget.y, widget.x + widget.width, widget.y + widget.height, false, bg_color, 1, style.button_rounding);
	    gmui_add_roundrect(widget.x, widget.y, widget.x + widget.width, widget.y + widget.height, true, style.button_border_color, 1, style.button_rounding);
    
	    var text_x = widget.x + (widget.width - text_size[0]) / 2;
	    var text_y = widget.y + (widget.height - text_size[1]) / 2;
	    gmui_add_text(text, text_x, text_y, style.button_text_color, style.button_text_alpha, _font);
	};
    
    gmui_end_widget(widget, true);
	
    return released;
};

function gmui_button_disabled(text, width = -1, height = -1, font = undefined) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("button");
    
    var _font = gmui_resolve_font(widget, font);
    var text_size = gmui_calculate_text_size(text, _font);
    
    widget.width = width > 0 ? width : max(style.button_min_width, text_size[0] + style.button_padding_h * 2);
    widget.height = height > 0 ? height : max(style.button_min_height, text_size[1] + style.button_padding_v * 2);
    
    if (gmui_widget_is_callable(widget)) {
        var bg_color = make_color_rgb(40, 40, 40);
        var border_color = make_color_rgb(60, 60, 60);
        var text_color = style.text_disabled_color;
        
        gmui_add_roundrect(widget.x, widget.y, widget.x + widget.width, widget.y + widget.height, false, bg_color, 1, style.button_rounding);
        gmui_add_roundrect(widget.x, widget.y, widget.x + widget.width, widget.y + widget.height, true, border_color, 1, style.button_rounding);
        
        var text_x = widget.x + (widget.width - text_size[0]) / 2;
        var text_y = widget.y + (widget.height - text_size[1]) / 2;
        gmui_add_text(text, text_x, text_y, text_color, 1, _font);
    }
    
    gmui_end_widget(widget);
    return false;
};

function gmui_button_size(text, width, height, font = undefined) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("button");
    
    var text_size = gmui_calculate_text_size(text);
    
    widget.width = width > 0 ? max(style.button_min_width, width) : max(style.button_min_width, text_size[0] + style.button_padding_h * 2);
    widget.height = height > 0 ? max(style.button_min_height, height) : max(style.button_min_height, text_size[1] + style.button_padding_v * 2);
    
	var released = false;
	var _font = gmui_resolve_font(widget, font);
	
	if (gmui_widget_is_callable(widget)) {
		var mouse_interaction = gmui_widget_mouse_interactive_behaviour(widget);
		
	    var hovered = mouse_interaction.is_hovering;
	    var active = mouse_interaction.is_active;
	    released = mouse_interaction.is_pressed;
    
	    var bg_color = style.button_color_idle;
	    if (active) bg_color = style.button_color_active;
	    else if (hovered) bg_color = style.button_color_hovered;
    
	    gmui_add_roundrect(widget.x, widget.y, widget.x + widget.width, widget.y + widget.height, false, bg_color, 1, style.button_rounding);
	    gmui_add_roundrect(widget.x, widget.y, widget.x + widget.width, widget.y + widget.height, true, style.button_border_color, 1, style.button_rounding);
    
	    var text_x = widget.x + (widget.width - text_size[0]) / 2;
	    var text_y = widget.y + (widget.height - text_size[1]) / 2;
	    gmui_add_text(text, text_x, text_y, style.button_text_color, style.button_text_alpha, _font);
	};
    
    gmui_end_widget(widget, true);
	
    return released;
};

function gmui_button_small(text, font = undefined) {
	return gmui_button_size(text, global.gmui.style.button_min_width, global.gmui.style.button_min_height, font);
};

function gmui_button_large(text, font = undefined) {
	var text_size = gmui_calculate_text_size(text, font);
	return gmui_button_size(text, text_size[0] * 1.2, text_size[1] * 1.2, font);
};

function gmui_button_width(text, width, font = undefined) {
	return gmui_button_size(text, width, -1, font);
};

function gmui_button_fill(text, height = -1, font = undefined) {
    var gmui = global.gmui;
    var style = gmui.style;
	var container = global.gmui.current_container;
	var available_width = container.width - style.container_padding_h * 2 - container.context.indent_level - (container.context.new_line_requested ? 0 : container.context.cursor_x - style.element_spacing_h);
    return gmui_button_size(text, available_width, height, font);
};

function gmui_button_arrow(direction, width = -1, height = -1) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("button");
    
    var btn_size = 24;
    widget.width = width > 0 ? width : btn_size;
    widget.height = height > 0 ? height : btn_size;
    
    var released = false;
    
    if (gmui_widget_is_callable(widget)) {
		var mouse_interaction = gmui_widget_mouse_interactive_behaviour(widget);
		
	    var hovered = mouse_interaction.is_hovering;
	    var active = mouse_interaction.is_active;
	    released = mouse_interaction.is_pressed;
        
        var bg_color = style.button_color_idle;
        if (active) bg_color = style.button_color_active;
        else if (hovered) bg_color = style.button_color_hovered;
        
        gmui_add_roundrect(widget.x, widget.y, widget.x + widget.width, widget.y + widget.height, false, bg_color, 1, style.button_rounding);
        gmui_add_roundrect(widget.x, widget.y, widget.x + widget.width, widget.y + widget.height, true, style.button_border_color, 1, style.button_rounding);
        
        var cx = widget.x + widget.width / 2;
        var cy = widget.y + widget.height / 2;
        var arrow_size = min(widget.width, widget.height) / 4;
        var arrow_color = style.button_text_color;
        
        switch (direction) {
            case 0: // up
                gmui_add_triangle(cx + arrow_size, cy, cx - arrow_size, cy - arrow_size, cx - arrow_size, cy + arrow_size, arrow_color);
                break;
            case 1: // down
                gmui_add_triangle(cx, cy + arrow_size, cx - arrow_size, cy - arrow_size, cx + arrow_size, cy - arrow_size, arrow_color);
                break;
            case 2: // left
                gmui_add_triangle(cx - arrow_size, cy, cx + arrow_size, cy - arrow_size, cx + arrow_size, cy + arrow_size, arrow_color);
                break;
            case 3: // right
                gmui_add_triangle(cx, cy - arrow_size, cx - arrow_size, cy + arrow_size, cx + arrow_size, cy + arrow_size, arrow_color);
                break;
        }
    }
    
    gmui_end_widget(widget, true);
    return released;
};

function gmui_button_repeat(text, font = undefined) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("button");
    
    var text_size = gmui_calculate_text_size(text);
    
    widget.width = max(style.button_min_width, text_size[0] + style.button_padding_h * 2);
    widget.height = max(style.button_min_height, text_size[1] + style.button_padding_v * 2);
    
	var active = false;
	var _font = gmui_resolve_font(widget, font);
	
	if (gmui_widget_is_callable(widget)) {
		var mouse_interaction = gmui_widget_mouse_interactive_behaviour(widget);
		
	    var hovered = mouse_interaction.is_hovering;
	    active = mouse_interaction.is_active;
	    var released = mouse_interaction.is_pressed;
    
	    var bg_color = style.button_color_idle;
	    if (active) bg_color = style.button_color_active;
	    else if (hovered) bg_color = style.button_color_hovered;
    
	    gmui_add_roundrect(widget.x, widget.y, widget.x + widget.width, widget.y + widget.height, false, bg_color, 1, style.button_rounding);
	    gmui_add_roundrect(widget.x, widget.y, widget.x + widget.width, widget.y + widget.height, true, style.button_border_color, 1, style.button_rounding);
    
	    var text_x = widget.x + (widget.width - text_size[0]) / 2;
	    var text_y = widget.y + (widget.height - text_size[1]) / 2;
	    gmui_add_text(text, text_x, text_y, style.button_text_color, style.button_text_alpha, _font);
	};
    
    gmui_end_widget(widget, true);
	
    return active;
};

function gmui_button_invisible(text = "", width = 32, height = 32, trigger_visuals = true, font = undefined) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("button");
    
    var text_size = gmui_calculate_text_size(text);
    
    widget.width = max(style.button_min_width, text_size[0] + style.button_padding_h * 2, width);
    widget.height = max(style.button_min_height, text_size[1] + style.button_padding_v * 2, height);
    
	var released = false;
	var _font = gmui_resolve_font(widget, font);
	
	if (gmui_widget_is_callable(widget)) {
		var mouse_interaction = gmui_widget_mouse_interactive_behaviour(widget);
		
	    var hovered = mouse_interaction.is_hovering;
	    var active = mouse_interaction.is_active;
	    released = mouse_interaction.is_pressed;
    
	    var bg_color = style.button_color_idle;
	    if (active) bg_color = style.button_color_active;
	    else if (hovered) bg_color = style.button_color_hovered;
		
		if (trigger_visuals && (active || hovered)) {
		    gmui_add_roundrect(widget.x, widget.y, widget.x + widget.width, widget.y + widget.height, false, bg_color, 1, style.button_rounding);
		    gmui_add_roundrect(widget.x, widget.y, widget.x + widget.width, widget.y + widget.height, true, style.button_border_color, 1, style.button_rounding);
		}
    
	    var text_x = widget.x + (widget.width - text_size[0]) / 2;
	    var text_y = widget.y + (widget.height - text_size[1]) / 2;
	    gmui_add_text(text, text_x, text_y, style.button_text_color, style.button_text_alpha, _font);
	};
    
    gmui_end_widget(widget, true);
	
    return released;
};

function gmui_button_arrow_up(w = -1, h = -1)    { return gmui_button_arrow(0, w, h); };
function gmui_button_arrow_down(w = -1, h = -1)  { return gmui_button_arrow(1, w, h); };
function gmui_button_arrow_left(w = -1, h = -1)  { return gmui_button_arrow(2, w, h); };
function gmui_button_arrow_right(w = -1, h = -1) { return gmui_button_arrow(3, w, h); };

function gmui_button_minus(width = 24, height = 24, font = undefined) {
	var gmui = global.gmui;
	var style = gmui.style;
	var old_min_width = style.button_min_width;
	var old_min_height = style.button_min_height;
	style.button_min_width = 1;
	style.button_min_height = 1;
	
	var button_result = gmui_button_size("-", width, height, font);
	
	style.button_min_width = old_min_width;
	style.button_min_height = old_min_height;
	
	return button_result;
};

function gmui_button_plus(width = 24, height = 24, font = undefined) {
	var gmui = global.gmui;
	var style = gmui.style;
	var old_min_width = style.button_min_width;
	var old_min_height = style.button_min_height;
	style.button_min_width = 1;
	style.button_min_height = 1;
	
	var button_result = gmui_button_size("+", width, height, font);
	
	style.button_min_width = old_min_width;
	style.button_min_height = old_min_height;
	
	return button_result;
};

function gmui_button_icon(sprite, subimg = 0, width = 32, height = 32) {
	var gmui = global.gmui;
	var style = gmui.style;
	var widget = gmui_begin_widget("button_icon");
	widget.width = width;
	widget.height = height;
	var released = false;
	
	if (gmui_widget_is_callable(widget)) {
		var mouse_interaction = gmui_widget_mouse_interactive_behaviour(widget);
		var hovered = mouse_interaction.is_hovering;
		var active = mouse_interaction.is_active;
		released = mouse_interaction.is_pressed;
		
		var bg_color = style.button_color_idle;
		if (active) bg_color = style.button_color_active;
		else if (hovered) bg_color = style.button_color_hovered;
		
		gmui_add_roundrect(widget.x, widget.y, widget.x + width, widget.y + height, false, bg_color, 1, style.button_rounding);
		gmui_add_roundrect(widget.x, widget.y, widget.x + width, widget.y + height, true, style.button_border_color, 1, style.button_rounding);
		
		var img_w = sprite_get_width(sprite);
		var img_h = sprite_get_height(sprite);
		var sx = widget.x + (width - img_w) / 2;
		var sy = widget.y + (height - img_h) / 2;
		gmui_add_sprite(sprite, subimg, sx, sy);
	}
	gmui_end_widget(widget, true);
	return released;
};

function gmui_button_icon1(sprite, subimg = 0, width = -1, height = -1, tilt = c_white, alpha = 1) {
	var gmui = global.gmui;
	var style = gmui.style;
	var widget = gmui_begin_widget("button_icon");
		
	var img_w = sprite_get_width(sprite);
	var img_h = sprite_get_height(sprite);
	var _width = width == -1 ? img_w : width;
	var _height = height == -1 ? img_h : height;
	var xscale = 1 / (img_w / _width);
	var yscale = 1 / (img_h / _height);
	widget.width = _width + 4;
	widget.height = _height + 4;
	var released = false;
	
	if (gmui_widget_is_callable(widget)) {
		var mouse_interaction = gmui_widget_mouse_interactive_behaviour(widget);
		var hovered = mouse_interaction.is_hovering;
		var active = mouse_interaction.is_active;
		released = mouse_interaction.is_pressed;
		
		var bg_color = style.button_color_idle;
		if (active) bg_color = style.button_color_active;
		else if (hovered) bg_color = style.button_color_hovered;
		
		if (active || hovered) {
			gmui_add_roundrect(widget.x, widget.y, widget.x + widget.width, widget.y + widget.height, true, style.button_border_color, 1, style.button_rounding);
		}
		
		if (active) {
			gmui_add_roundrect(widget.x, widget.y, widget.x + widget.width, widget.y + widget.height, false, bg_color, 1, style.button_rounding);
		}
		
		var sx = widget.x + (widget.width - img_w) / 2;
		var sy = widget.y + (widget.height - img_h) / 2;
		gmui_add_sprite_ext(sprite, subimg, sx, sy, xscale, yscale, 0, tilt, alpha);
	}
	gmui_end_widget(widget, true);
	return released;
};

function gmui_button_icon_only(sprite, subimg = 0, width = -1, height = -1) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("button_icon");
    
    var img_w = width > 0 ? width : sprite_get_width(sprite);
    var img_h = height > 0 ? height : sprite_get_height(sprite);
    
    widget.width = img_w + style.image_button_padding_h * 2;
    widget.height = img_h + style.image_button_padding_v * 2;
    
    var released = false;
    
    if (gmui_widget_is_callable(widget)) {
        var mouse = gmui_widget_mouse_interactive_behaviour(widget);
        var hovered = mouse.is_hovering;
        var active = mouse.is_active;
        released = mouse.is_pressed;
        
        var bg_color = style.image_button_bg_color;
        if (active) bg_color = style.image_button_bg_active_color;
        else if (hovered) bg_color = style.image_button_bg_hover_color;
        
        gmui_add_roundrect(widget.x, widget.y, widget.x + widget.width, widget.y + widget.height, 
                          false, bg_color, 1, style.image_button_rounding);
        gmui_add_roundrect(widget.x, widget.y, widget.x + widget.width, widget.y + widget.height, 
                          true, style.image_button_border_color, 1, style.image_button_rounding);
        
        var sx = widget.x + (widget.width - img_w) / 2;
        var sy = widget.y + (widget.height - img_h) / 2;
        gmui_add_sprite(sprite, subimg, sx, sy);
    }
    
    gmui_end_widget(widget, true);
    return released;
};

function gmui_image_button_animated(sprite, frame_count, frame_delay = 4, width = -1, height = -1) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("button_icon_animated");
    
    var img_w = width > 0 ? width : sprite_get_width(sprite) / frame_count;
    var img_h = height > 0 ? height : sprite_get_height(sprite);
    
    widget.width = img_w + style.image_button_padding_h * 2;
    widget.height = img_h + style.image_button_padding_v * 2;
    
    var released = false;
    var anim_frame = floor(current_time / (1000 / 60 * frame_delay)) % frame_count;
    
    if (gmui_widget_is_callable(widget)) {
        var mouse = gmui_widget_mouse_interactive_behaviour(widget);
        var hovered = mouse.is_hovering;
        var active = mouse.is_active;
        released = mouse.is_pressed;
        
        var bg_color = style.image_button_bg_color;
        if (active) bg_color = style.image_button_bg_active_color;
        else if (hovered) bg_color = style.image_button_bg_hover_color;
        
        gmui_add_roundrect(widget.x, widget.y, widget.x + widget.width, widget.y + widget.height, 
                          false, bg_color, 1, style.image_button_rounding);
        gmui_add_roundrect(widget.x, widget.y, widget.x + widget.width, widget.y + widget.height, 
                          true, style.image_button_border_color, 1, style.image_button_rounding);
        
        var sx = widget.x + (widget.width - img_w) / 2;
        var sy = widget.y + (widget.height - img_h) / 2;
        
        if (hovered || active) {
            anim_frame = (anim_frame + 1) % frame_count;
        }
        
        gmui_add_sprite(sprite, anim_frame, sx, sy);
    }
    
    gmui_end_widget(widget, true);
    return released;
};

function gmui_button_icon_text(sprite, subimg, text, width = -1, height = -1, font = undefined) {
	var gmui = global.gmui;
	var style = gmui.style;
	var widget = gmui_begin_widget("button_icon_text");
	var _font = gmui_resolve_font(widget, font);
	var text_size = gmui_calculate_text_size(text, _font);
	var img_w = sprite_get_width(sprite);
	var img_h = sprite_get_height(sprite);
	var gap = 8;
	
	var calc_w = img_w + gap + text_size[0] + style.button_padding_h * 2;
	var calc_h = max(img_h, text_size[1]) + style.button_padding_v * 2;
	
	widget.width = width > 0 ? width : calc_w;
	widget.height = height > 0 ? height : calc_h;
	var released = false;
	
	if (gmui_widget_is_callable(widget)) {
		var mouse_interaction = gmui_widget_mouse_interactive_behaviour(widget);
		var hovered = mouse_interaction.is_hovering;
		var active = mouse_interaction.is_active;
		released = mouse_interaction.is_pressed;
		
		var bg_color = style.button_color_idle;
		if (active) bg_color = style.button_color_active;
		else if (hovered) bg_color = style.button_color_hovered;
		
		gmui_add_roundrect(widget.x, widget.y, widget.x + widget.width, widget.y + widget.height, false, bg_color, 1, style.button_rounding);
		gmui_add_roundrect(widget.x, widget.y, widget.x + widget.width, widget.y + widget.height, true, style.button_border_color, 1, style.button_rounding);
		
		var sy = widget.y + (widget.height - img_h) / 2;
		gmui_add_sprite(sprite, subimg, widget.x + style.button_padding_h, sy);
		
		var text_x = widget.x + style.button_padding_h + img_w + gap;
		var text_y = widget.y + (widget.height - text_size[1]) / 2;
		gmui_add_text(text, text_x, text_y, style.button_text_color, style.button_text_alpha, _font);
	}
	gmui_end_widget(widget, true);
	return released;
};

function gmui_button_danger(text, width = -1, height = -1, font = undefined) {
	var gmui = global.gmui;
	var style = gmui.style;
	var widget = gmui_begin_widget("button_danger");
	
	var _font = gmui_resolve_font(widget, font);
	var text_size = gmui_calculate_text_size(text, _font);
	
	widget.width = width > 0 ? width : max(style.button_min_width, text_size[0] + style.button_padding_h * 2);
	widget.height = height > 0 ? height : max(style.button_min_height, text_size[1] + style.button_padding_v * 2);
	var released = false;
	
	if (gmui_widget_is_callable(widget)) {
		var mouse_interaction = gmui_widget_mouse_interactive_behaviour(widget);
		var hovered = mouse_interaction.is_hovering;
		var active = mouse_interaction.is_active;
		released = mouse_interaction.is_pressed;
		
		var idle_col = make_color_rgb(180, 50, 50);
		var hover_col = make_color_rgb(220, 70, 70);
		var active_col = make_color_rgb(140, 30, 30);
		var border_col = make_color_rgb(100, 20, 20);
		
		var bg_color = idle_col;
		if (active) bg_color = active_col;
		else if (hovered) bg_color = hover_col;
		
		gmui_add_roundrect(widget.x, widget.y, widget.x + widget.width, widget.y + widget.height, false, bg_color, 1, style.button_rounding);
		gmui_add_roundrect(widget.x, widget.y, widget.x + widget.width, widget.y + widget.height, true, border_col, 1, style.button_rounding);
		
		var text_x = widget.x + (widget.width - text_size[0]) / 2;
		var text_y = widget.y + (widget.height - text_size[1]) / 2;
		gmui_add_text(text, text_x, text_y, c_white, 1, _font);
	};
	gmui_end_widget(widget, true);
	return released;
};

function gmui_button_success(text, width = -1, height = -1, font = undefined) {
	var gmui = global.gmui;
	var style = gmui.style;
	var widget = gmui_begin_widget("button_danger");
	
	var _font = gmui_resolve_font(widget, font);
	var text_size = gmui_calculate_text_size(text, _font);
	
	widget.width = width > 0 ? width : max(style.button_min_width, text_size[0] + style.button_padding_h * 2);
	widget.height = height > 0 ? height : max(style.button_min_height, text_size[1] + style.button_padding_v * 2);
	var released = false;
	
	if (gmui_widget_is_callable(widget)) {
		var mouse_interaction = gmui_widget_mouse_interactive_behaviour(widget);
		var hovered = mouse_interaction.is_hovering;
		var active = mouse_interaction.is_active;
		released = mouse_interaction.is_pressed;
		
		var idle_col = make_color_rgb(50, 160, 80);
		var hover_col = make_color_rgb(70, 190, 100);
		var active_col = make_color_rgb(35, 120, 60);
		var border_col = make_color_rgb(30, 100, 50);
		
		var bg_color = idle_col;
		if (active) bg_color = active_col;
		else if (hovered) bg_color = hover_col;
		
		gmui_add_roundrect(widget.x, widget.y, widget.x + widget.width, widget.y + widget.height, false, bg_color, 1, style.button_rounding);
		gmui_add_roundrect(widget.x, widget.y, widget.x + widget.width, widget.y + widget.height, true, border_col, 1, style.button_rounding);
		
		var text_x = widget.x + (widget.width - text_size[0]) / 2;
		var text_y = widget.y + (widget.height - text_size[1]) / 2;
		gmui_add_text(text, text_x, text_y, c_white, 1, _font);
	};
	gmui_end_widget(widget, true);
	return released;
};

function gmui_button_hold(text, hold_time_ms = 500, width = -1, height = -1, font = undefined) {
	var gmui = global.gmui;
	var style = gmui.style;
	var widget = gmui_begin_widget("button_hold");
	
	var _font = gmui_resolve_font(widget, font);
	var text_size = gmui_calculate_text_size(text, _font);
	
	widget.width = width > 0 ? width : max(style.button_min_width, text_size[0] + style.button_padding_h * 2);
	widget.height = height > 0 ? height : max(style.button_min_height, text_size[1] + style.button_padding_v * 2);
	
	var widget_id = widget.id;
	if (!ds_map_exists(gmui.cache, widget_id + "_hold_start")) {
		gmui.cache[? widget_id + "_hold_start"] = 0;
	}
	
	var released = false;
	var progress = 0;
	
	if (gmui_widget_is_callable(widget)) {
		var mouse_interaction = gmui_widget_mouse_interactive_behaviour(widget);
		var hovered = mouse_interaction.is_hovering;
		var active = mouse_interaction.is_active;
		
		if (active && hovered) {
			if (gmui.cache[? widget_id + "_hold_start"] == 0) {
				gmui.cache[? widget_id + "_hold_start"] = current_time;
			}
			var elapsed = current_time - gmui.cache[? widget_id + "_hold_start"];
			progress = clamp(elapsed / max(1, hold_time_ms), 0, 1);
			
			if (progress >= 1.0) {
				released = true;
				gmui.cache[? widget_id + "_hold_start"] = 0;
				gmui.input.active_widget_id = undefined; 
			}
		} else {
			gmui.cache[? widget_id + "_hold_start"] = 0;
		}
		
		var bg_color = style.button_color_idle;
		if (active) bg_color = style.button_color_active;
		else if (hovered) bg_color = style.button_color_hovered;
		
		gmui_add_roundrect(widget.x, widget.y, widget.x + widget.width, widget.y + widget.height, false, bg_color, 1, style.button_rounding);
		
		if (progress > 0) {
			var fill_w = widget.width * progress;
			var progress_col = make_color_rgb(255, 150, 50);
			gmui_add_roundrect(widget.x, widget.y, widget.x + fill_w, widget.y + widget.height, false, progress_col, 0.4, style.button_rounding);
		}
		
		gmui_add_roundrect(widget.x, widget.y, widget.x + widget.width, widget.y + widget.height, true, style.button_border_color, 1, style.button_rounding);
		
		var text_x = widget.x + (widget.width - text_size[0]) / 2;
		var text_y = widget.y + (widget.height - text_size[1]) / 2;
		gmui_add_text(text, text_x, text_y, style.button_text_color, style.button_text_alpha, _font);
	};
	gmui_end_widget(widget, true);
	return released;
};

function gmui_button_primary(text, width = -1, height = -1, font = undefined) {
	var gmui = global.gmui;
	var style = gmui.style;
	var widget = gmui_begin_widget("button_primary");
	var _font = gmui_resolve_font(widget, font);
	var text_size = gmui_calculate_text_size(text, _font);
	
	widget.width = width > 0 ? width : max(style.button_min_width, text_size[0] + style.button_padding_h * 2);
	widget.height = height > 0 ? height : max(style.button_min_height, text_size[1] + style.button_padding_v * 2);
	var released = false;
	
	if (gmui_widget_is_callable(widget)) {
		var mouse_interaction = gmui_widget_mouse_interactive_behaviour(widget);
		var hovered = mouse_interaction.is_hovering;
		var active = mouse_interaction.is_active;
		released = mouse_interaction.is_pressed;
		
		var idle_col = style.color_accent;
		var hover_col = style.color_accent_hover;
		var active_col = style.color_accent_pressed;
		var border_col = style.color_accent_dark;
		
		var bg_color = idle_col;
		if (active) bg_color = active_col;
		else if (hovered) bg_color = hover_col;
		
		gmui_add_roundrect(widget.x, widget.y, widget.x + widget.width, widget.y + widget.height, false, bg_color, 1, style.button_rounding);
		gmui_add_roundrect(widget.x, widget.y, widget.x + widget.width, widget.y + widget.height, true, border_col, 1, style.button_rounding);
		
		var text_x = widget.x + (widget.width - text_size[0]) / 2;
		var text_y = widget.y + (widget.height - text_size[1]) / 2;
		gmui_add_text(text, text_x, text_y, c_white, 1, _font);
	};
	gmui_end_widget(widget, true);
	return released;
};

function gmui_button_ghost(text, width = -1, height = -1, font = undefined) {
	var gmui = global.gmui;
	var style = gmui.style;
	var widget = gmui_begin_widget("button_ghost");
	var _font = gmui_resolve_font(widget, font);
	var text_size = gmui_calculate_text_size(text, _font);
	
	widget.width = width > 0 ? width : max(style.button_min_width, text_size[0] + style.button_padding_h * 2);
	widget.height = height > 0 ? height : max(style.button_min_height, text_size[1] + style.button_padding_v * 2);
	var released = false;
	
	if (gmui_widget_is_callable(widget)) {
		var mouse_interaction = gmui_widget_mouse_interactive_behaviour(widget);
		var hovered = mouse_interaction.is_hovering;
		var active = mouse_interaction.is_active;
		released = mouse_interaction.is_pressed;
		
		var text_col = style.color_text_primary;
		var border_col = style.color_border_light;
		var bg_alpha = 0.0;
		
		if (active) {
			bg_alpha = 0.2;
			border_col = style.color_accent_pressed;
		} else if (hovered) {
			bg_alpha = 0.1;
			border_col = style.color_accent;
			text_col = style.color_accent_hover;
		}
		
		gmui_add_roundrect(widget.x, widget.y, widget.x + widget.width, widget.y + widget.height, false, style.color_widget_base, bg_alpha, style.button_rounding);
		gmui_add_roundrect(widget.x, widget.y, widget.x + widget.width, widget.y + widget.height, true, border_col, 1, style.button_rounding);
		
		var text_x = widget.x + (widget.width - text_size[0]) / 2;
		var text_y = widget.y + (widget.height - text_size[1]) / 2;
		gmui_add_text(text, text_x, text_y, text_col, 1, _font);
	};
	gmui_end_widget(widget, true);
	return released;
};

function gmui_button_toggle(text, is_active, width = -1, height = -1, font = undefined) {
	var gmui = global.gmui;
	var style = gmui.style;
	var widget = gmui_begin_widget("button_toggle");
	var _font = gmui_resolve_font(widget, font);
	var text_size = gmui_calculate_text_size(text, _font);
	
	widget.width = width > 0 ? width : max(style.button_min_width, text_size[0] + style.button_padding_h * 2);
	widget.height = height > 0 ? height : max(style.button_min_height, text_size[1] + style.button_padding_v * 2);
	var released = false;
	
	if (gmui_widget_is_callable(widget)) {
		var mouse_interaction = gmui_widget_mouse_interactive_behaviour(widget);
		var hovered = mouse_interaction.is_hovering;
		var active = mouse_interaction.is_active;
		released = mouse_interaction.is_pressed;
		
		var bg_color = is_active ? style.color_accent : style.button_color_idle;
		var text_col = is_active ? c_white : style.button_text_color;
		var border_col = is_active ? style.color_accent_dark : style.button_border_color;
		
		if (!is_active) {
			if (active) bg_color = style.button_color_active;
			else if (hovered) bg_color = style.button_color_hovered;
		}
		
		gmui_add_roundrect(widget.x, widget.y, widget.x + widget.width, widget.y + widget.height, false, bg_color, 1, style.button_rounding);
		gmui_add_roundrect(widget.x, widget.y, widget.x + widget.width, widget.y + widget.height, true, border_col, 1, style.button_rounding);
		
		var text_x = widget.x + (widget.width - text_size[0]) / 2;
		var text_y = widget.y + (widget.height - text_size[1]) / 2;
		gmui_add_text(text, text_x, text_y, text_col, 1, _font);
	};
	gmui_end_widget(widget, true);
	
	return released ? !is_active : is_active;
};

function gmui_button_loading(text, is_loading, width = -1, height = -1, font = undefined) {
	var gmui = global.gmui;
	var style = gmui.style;
	var widget = gmui_begin_widget("button_loading");
	var _font = gmui_resolve_font(widget, font);
	var text_size = gmui_calculate_text_size(text, _font);
	
	widget.width = width > 0 ? width : max(style.button_min_width, text_size[0] + style.button_padding_h * 2 + (is_loading ? 20 : 0));
	widget.height = height > 0 ? height : max(style.button_min_height, text_size[1] + style.button_padding_v * 2);
	var released = false;
	
	if (gmui_widget_is_callable(widget)) {
		var mouse_interaction = gmui_widget_mouse_interactive_behaviour(widget);
		var hovered = !is_loading && mouse_interaction.is_hovering;
		var active = !is_loading && mouse_interaction.is_active;
		released = !is_loading && mouse_interaction.is_pressed;
		
		var bg_color = is_loading ? style.color_widget_active : style.button_color_idle;
		if (!is_loading && active) bg_color = style.button_color_active;
		else if (!is_loading && hovered) bg_color = style.button_color_hovered;
		
		gmui_add_roundrect(widget.x, widget.y, widget.x + widget.width, widget.y + widget.height, false, bg_color, 1, style.button_rounding);
		gmui_add_roundrect(widget.x, widget.y, widget.x + widget.width, widget.y + widget.height, true, style.button_border_color, 1, style.button_rounding);
		
		var _text = text;
		var offset_x = 0;
		
		if (is_loading) {
			var dots = floor((current_time / 400) % 4);
			_text = text + string_repeat(".", dots);
			offset_x = -10;
		}
		
		var text_x = widget.x + (widget.width - text_size[0]) / 2 + offset_x;
		var text_y = widget.y + (widget.height - text_size[1]) / 2;
		
		var final_alpha = is_loading ? 0.7 : 1.0;
		gmui_add_text(_text, text_x, text_y, style.button_text_color, final_alpha, _font);
	};
	gmui_end_widget(widget, true);
	return released;
};

function gmui_button_if(condition, text, font = undefined) {
    if (condition) {
        return gmui_button(text, font);
    }
    return false;
};

function gmui_button_primary_if(condition, text, width = -1, height = -1, font = undefined) {
    if (condition) {
        return gmui_button_primary(text, width, height, font);
    }
    return false;
};

function gmui_button_danger_if(condition, text, width = -1, height = -1, font = undefined) {
    if (condition) {
        return gmui_button_danger(text, width, height, font);
    }
    return false;
};

function gmui_button_success_if(condition, text, width = -1, height = -1, font = undefined) {
    if (condition) {
        return gmui_button_success(text, width, height, font);
    }
    return false;
};

function gmui_button_ghost_if(condition, text, width = -1, height = -1, font = undefined) {
    if (condition) {
        return gmui_button_ghost(text, width, height, font);
    }
    return false;
};

// checkbox
function gmui_checkbox(checked, label = "", font = undefined) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("checkbox");
    
    var box_size = style.checkbox_size;
    var padding = style.checkbox_padding;
    
    var text_size = label == "" ? [0, 0] : gmui_calculate_text_size(label);
    
    widget.width = box_size + padding + text_size[0];
    widget.height = max(box_size, text_size[1]);
	
	var _font = gmui_resolve_font(widget, font);
    
	if (gmui_widget_is_callable(widget)) {
		var mouse_interaction = gmui_widget_mouse_interactive_behaviour(widget);
		
	    var hovered = mouse_interaction.is_hovering;
	    var active = mouse_interaction.is_active;
	    var released = mouse_interaction.is_pressed;
    
	    if (hovered && released) checked = !checked;
    
	    var bg_color = style.checkbox_color_idle;
	    if (hovered) {
			bg_color = style.checkbox_color_hovered
		}
		else if (released) {
			bg_color = style.checkbox_color_active;
		};
    
	    gmui_add_roundrect(widget.x, widget.y, widget.x + box_size, widget.y + box_size, false, bg_color, 1, style.checkbox_rounding);
	    gmui_add_roundrect(widget.x, widget.y, widget.x + box_size, widget.y + box_size, true, style.checkbox_border_color, 1, style.checkbox_rounding);
    
	    if (checked) {
	        var inset = 3;
	        var mx = widget.x + box_size / 2;
	        var my = widget.y + box_size / 2;
	        gmui_add_line_width(widget.x + inset, my, mx - 1, widget.y + box_size - inset, 2, style.checkbox_checkmark_color);
	        gmui_add_line_width(mx - 1, widget.y + box_size - inset, widget.x + box_size - inset, widget.y + inset, 2, style.checkbox_checkmark_color);
	    }
    
	    if (label != "") {
	        gmui_add_text(label, widget.x + box_size + padding, widget.y, style.checkbox_text_color, style.checkbox_text_alpha, _font);
	    }
	};
    
    gmui_end_widget(widget, true);
	
    return checked;
};

function gmui_checkbox_disabled(checked, label = "", font = undefined) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("checkbox");
    
    var box_size = style.checkbox_size;
    var padding = style.checkbox_padding;
    var _font = gmui_resolve_font(widget, font);
    var text_size = label == "" ? [0, 0] : gmui_calculate_text_size(label, _font);
    
    widget.width = box_size + padding + text_size[0];
    widget.height = max(box_size, text_size[1]);
    
    if (gmui_widget_is_callable(widget)) {
        var bg_color = make_color_rgb(40, 40, 40);
        var border_color = make_color_rgb(60, 60, 60);
        var check_color = make_color_rgb(100, 100, 100);
        
        gmui_add_roundrect(widget.x, widget.y, widget.x + box_size, widget.y + box_size, false, bg_color, 1, style.checkbox_rounding);
        gmui_add_roundrect(widget.x, widget.y, widget.x + box_size, widget.y + box_size, true, border_color, 1, style.checkbox_rounding);
        
        if (checked) {
            var pad = 3;
            var x1 = widget.x + pad + 1;
            var y1 = widget.y + box_size / 2;
            var x2 = widget.x + box_size / 2;
            var y2 = widget.y + box_size - pad - 1;
            var x3 = widget.x + box_size - pad;
            var y3 = widget.y + pad + 1;
            
            for (var t = -1; t <= 1; t++) {
                gmui_add_line(x1 + t, y1, x2 + t, y2, check_color, 1);
                gmui_add_line(x2 + t, y2, x3 + t, y3, check_color, 1);
            }
        }
        
        if (label != "") {
            gmui_add_text(label, widget.x + box_size + padding, widget.y, style.text_disabled_color, 1, _font);
        }
    }
    
    gmui_end_widget(widget);
    return checked;
};

function gmui_checkbox_danger(checked, label = "", font = undefined) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("checkbox_danger");
    var _font = gmui_resolve_font(widget, font);
    var label_size = label != "" ? gmui_calculate_text_size(label, _font) : [0, 0];
    var box_size = style.checkbox_size;
    var padding = style.checkbox_padding;
    
    widget.width = box_size + padding + label_size[0];
    widget.height = max(box_size, label_size[1]);
    var new_checked = checked;
    
    if (gmui_widget_is_callable(widget)) {
        var mouse = gmui_widget_mouse_interactive_behaviour(widget);
        var hovered = mouse.is_hovering;
        var active = mouse.is_active;
        var released = mouse.is_pressed;
        if (hovered && released) new_checked = !checked;
        
        var idle = make_color_rgb(180, 50, 50);
        var hover = make_color_rgb(220, 70, 70);
        var active_col = make_color_rgb(140, 30, 30);
        var border = make_color_rgb(100, 20, 20);
        var check_col = c_white;
        
        var bg = idle;
        if (active) bg = active_col;
        else if (hovered) bg = hover;
        if (new_checked) bg = active_col;
        
        gmui_add_roundrect(widget.x, widget.y, widget.x + box_size, widget.y + box_size, false, bg, 1, style.checkbox_rounding);
        gmui_add_roundrect(widget.x, widget.y, widget.x + box_size, widget.y + box_size, true, border, 1, style.checkbox_rounding);
        
        if (new_checked) {
            var p = 3;
            var mid = widget.x + box_size / 2;
            gmui_add_line_width(widget.x + p + 1, widget.y + box_size / 2, mid, widget.y + box_size - p - 1, 2, check_col);
            gmui_add_line_width(mid, widget.y + box_size - p - 1, widget.x + box_size - p, widget.y + p + 1, 2, check_col);
        }
        if (label != "") {
            gmui_add_text(label, widget.x + box_size + padding, widget.y + (widget.height - label_size[1]) / 2, make_color_rgb(220, 200, 200), 1, _font);
        }
    }
    gmui_end_widget(widget, true);
    return new_checked;
}

function gmui_checkbox_success(checked, label = "", font = undefined) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("checkbox_success");
    var _font = gmui_resolve_font(widget, font);
    var label_size = label != "" ? gmui_calculate_text_size(label, _font) : [0, 0];
    var box_size = style.checkbox_size;
    var padding = style.checkbox_padding;
    
    widget.width = box_size + padding + label_size[0];
    widget.height = max(box_size, label_size[1]);
    var new_checked = checked;
    
    if (gmui_widget_is_callable(widget)) {
        var mouse = gmui_widget_mouse_interactive_behaviour(widget);
        var hovered = mouse.is_hovering;
        var active = mouse.is_active;
        var released = mouse.is_pressed;
        if (hovered && released) new_checked = !checked;
        
        var idle = make_color_rgb(50, 160, 80);
        var hover = make_color_rgb(70, 190, 100);
        var active_col = make_color_rgb(35, 120, 60);
        var border = make_color_rgb(30, 100, 50);
        var check_col = c_white;
        
        var bg = idle;
        if (active) bg = active_col;
        else if (hovered) bg = hover;
        if (new_checked) bg = active_col;
        
        gmui_add_roundrect(widget.x, widget.y, widget.x + box_size, widget.y + box_size, false, bg, 1, style.checkbox_rounding);
        gmui_add_roundrect(widget.x, widget.y, widget.x + box_size, widget.y + box_size, true, border, 1, style.checkbox_rounding);
        
        if (new_checked) {
            var p = 3;
            var mid = widget.x + box_size / 2;
            gmui_add_line_width(widget.x + p + 1, widget.y + box_size / 2, mid, widget.y + box_size - p - 1, 2, check_col);
            gmui_add_line_width(mid, widget.y + box_size - p - 1, widget.x + box_size - p, widget.y + p + 1, 2, check_col);
        }
        if (label != "") {
            gmui_add_text(label, widget.x + box_size + padding, widget.y + (widget.height - label_size[1]) / 2, make_color_rgb(180, 230, 190), 1, _font);
        }
    }
    gmui_end_widget(widget, true);
    return new_checked;
}

function gmui_checkbox_flags(value, flag, label = "", font = undefined) {
    var new_value = gmui_checkbox((value & flag) != 0, label, font);
    if (new_value != ((value & flag) != 0)) {
        if (new_value) {
            return value | flag;
        } else {
            return value & ~flag;
        }
    }
    return value;
};

// selectable
function gmui_selectable(label, selected, width = global.gmui.style.selectable_min_width, font = undefined) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("selectable");
    var container = widget.container;
	
    var text_size = gmui_calculate_text_size(label);
    var available_width = container.width - style.container_padding_h * 2 - container.context.indent_level;
    var item_width = width <= 0 ? available_width : (style.selectable_min_width < text_size[0] + style.selectable_padding_h * 2 ? text_size[0] + style.selectable_padding_h * 2 : style.selectable_min_width);
    var item_height = max(style.selectable_min_height, text_size[1] + style.selectable_padding_v * 2);
    
    widget.width = item_width;
    widget.height = item_height;
	
	var released = false;
	var _font = gmui_resolve_font(widget, font);
    
	if (gmui_widget_is_callable(widget)) {
		var mouse_interaction = gmui_widget_mouse_interactive_behaviour(widget);
		
	    var hovered = mouse_interaction.is_hovering;
	    var active = mouse_interaction.is_active;
	    released = mouse_interaction.is_pressed;
    
	    var bg_color = style.selectable_color;
	    var text_color = style.selectable_text_color;
    
	    if (selected) {
	        if (active) {
	            bg_color = style.selectable_active_color;
	        } else if (hovered) {
	            bg_color = style.selectable_selected_hovered_color;
	        } else {
	            bg_color = style.selectable_selected_color;
	        }
	        text_color = style.selectable_text_selected_color;
	    } else {
	        if (active) {
	            bg_color = style.selectable_active_color;
	        } else if (hovered) {
	            bg_color = style.selectable_hovered_color;
	        }
	    }
    
	    gmui_add_roundrect(
	        widget.x, widget.y,
	        widget.x + item_width, widget.y + item_height,
	        false,
	        bg_color, 1,
	        style.selectable_rounding
	    );
    
	    var text_x = widget.x + (item_width - text_size[0]) / 2;
	    var text_y = widget.y + (item_height - text_size[1]) / 2;
	    gmui_add_text(label, text_x, text_y, text_color, 1, _font);
	};
    
    gmui_end_widget(widget, true);
    
    return released && !selected;
};

function gmui_selectable_disabled(label, selected = false, width = -1, font = undefined) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("selectable");
    var container = widget.container;
    
    var _font = gmui_resolve_font(widget, font);
    var text_size = gmui_calculate_text_size(label, _font);
    var available_width = container.width - style.container_padding_h * 2 - container.context.indent_level;
    var item_width = width > 0 ? width : available_width;
    var item_height = max(style.selectable_min_height, text_size[1] + style.selectable_padding_v * 2);
    
    widget.width = item_width;
    widget.height = item_height;
    
    if (gmui_widget_is_callable(widget)) {
        var bg_color = selected ? make_color_rgb(50, 60, 90) : make_color_rgb(35, 35, 35);
        var text_color = selected ? make_color_rgb(180, 180, 220) : style.text_disabled_color;
        
        gmui_add_roundrect(widget.x, widget.y, widget.x + item_width, widget.y + item_height, false, bg_color, 1, style.selectable_rounding);
        
        var text_x = widget.x + (item_width - text_size[0]) / 2;
        var text_y = widget.y + (item_height - text_size[1]) / 2;
        gmui_add_text(label, text_x, text_y, text_color, 1, _font);
    }
    
    gmui_end_widget(widget);
    return false;
};

function gmui_selectable1(label, selected, width = -1, font = undefined) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("selectable");
    var container = widget.container;
	
    var text_size = gmui_calculate_text_size(label);
    var available_width = container.width - style.container_padding_h * 2 - container.context.indent_level;
    var item_width = 1;
	if (width == -1) {
		item_width = text_size[0] + style.selectable_padding_h * 2;
	}
	else if (width == -2) {
		item_width = available_width;
	}
	else {
		item_width = width;
	};
    var item_height = max(style.selectable_min_height, text_size[1] + style.selectable_padding_v * 2);
    
    widget.width = item_width;
    widget.height = item_height;
	
	var released = false;
	var _font = gmui_resolve_font(widget, font);
    
	if (gmui_widget_is_callable(widget)) {
		var mouse_interaction = gmui_widget_mouse_interactive_behaviour(widget);
		
	    var hovered = mouse_interaction.is_hovering;
	    var active = mouse_interaction.is_active;
	    released = mouse_interaction.is_pressed;
    
	    var bg_color = style.selectable_color;
	    var text_color = style.selectable_text_color;
    
	    if (selected) {
	        if (active) {
	            bg_color = style.selectable_active_color;
	        } else if (hovered) {
	            bg_color = style.selectable_selected_hovered_color;
	        } else {
	            bg_color = style.selectable_selected_color;
	        }
	        text_color = style.selectable_text_selected_color;
	    } else {
	        if (active) {
	            bg_color = style.selectable_active_color;
	        } else if (hovered) {
	            bg_color = style.selectable_hovered_color;
	        }
	    }
    
	    gmui_add_roundrect(
	        widget.x, widget.y,
	        widget.x + item_width, widget.y + item_height,
	        false,
	        bg_color, 1,
	        style.selectable_rounding
	    );
    
	    var text_x = widget.x + style.selectable_padding_h;
	    var text_y = widget.y + (item_height - text_size[1]) / 2;
	    gmui_add_text(label, text_x, text_y, text_color, 1, _font);
	};
    
    gmui_end_widget(widget, true);
    
    return released && !selected;
};

// slider
function gmui_slider(value, min_val, max_val, width = 200) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("slider");
    
    var track_height = style.slider_track_height;
    var handle_width = style.slider_handle_width;
    var handle_height = style.slider_handle_height;
    
    widget.width = width;
    widget.height = max(track_height, handle_height);
    
	if (gmui_widget_is_callable(widget)) {
	    var track_x = widget.x;
	    var track_y = widget.y + (widget.height - track_height) / 2;
	    var track_width = width;
    
	    var range = max_val - min_val;
	    if (range == 0) range = 1;
	    var normalized = (value - min_val) / range;
	    normalized = clamp(normalized, 0, 1);
    
	    var handle_x = track_x + (track_width - handle_width) * normalized;
	    var handle_y = widget.y + (widget.height - handle_height) / 2;
    
		var mouse_interaction = gmui_widget_mouse_interactive_behaviour(widget);
		
	    var hovered = mouse_interaction.is_hovering;
	    var active = mouse_interaction.is_active;
	    var released = mouse_interaction.is_pressed;
	    var slider_id = widget.id;
    
	    if (hovered && gmui_input_mouse_pressed()) {
	        var click_x = gmui.input.m_x - gmui_get_container_screen_offset(widget.container)[0];
	        var local_x = click_x - track_x - handle_width / 2;
	        var new_normalized = local_x / (track_width - handle_width);
	        new_normalized = clamp(new_normalized, 0, 1);
	        value = min_val + new_normalized * range;
        
	        gmui.input.active_widget_id = slider_id;
	        widget.container._slider_drag_start_value = value;
	        widget.container._slider_drag_start_mouse_x = gmui.input.m_x;
	    }
    
	    if (gmui.input.active_widget_id == slider_id && gmui.input.m_held) {
	        var mouse_dx = gmui.input.m_x - widget.container._slider_drag_start_mouse_x;
	        var value_delta = (mouse_dx / (track_width - handle_width)) * range;
	        value = widget.container._slider_drag_start_value + value_delta;
	        value = clamp(value, min_val, max_val);
        
	        normalized = (value - min_val) / range;
	        handle_x = track_x + (track_width - handle_width) * normalized;
	    }
    
	    var offset = gmui_get_container_screen_offset(widget.container);
	    var screen_handle_x = offset[0] + widget.x + (track_width - handle_width) * normalized;
	    var screen_handle_y = offset[1] + widget.y + (widget.height - handle_height) / 2;
	    var handle_hovered = point_in_rectangle(
	        gmui.input.m_x, gmui.input.m_y,
	        screen_handle_x, screen_handle_y,
	        screen_handle_x + handle_width, screen_handle_y + handle_height
	    ) && widget.container.is_mouse_hovering;
    
	    gmui_add_roundrect(
	        track_x, track_y,
	        track_x + track_width, track_y + track_height,
	        false,
	        style.slider_track_color, 1,
	        style.slider_track_rounding
	    );
    
	    if (normalized > 0) {
	        gmui_add_roundrect(
	            track_x, track_y,
	            track_x + (track_width - handle_width) * normalized + handle_width / 2, track_y + track_height,
	            false,
	            style.slider_track_fill_color, 1,
	            style.slider_track_rounding
	        );
	    }
    
	    var handle_color = style.slider_handle_color;
	    if (gmui.input.active_widget_id == slider_id && gmui.input.m_held) {
	        handle_color = style.slider_handle_active_color;
	    } else if (handle_hovered) {
	        handle_color = style.slider_handle_hovered_color;
	    }
    
	    gmui_add_roundrect(
	        handle_x, handle_y,
	        handle_x + handle_width, handle_y + handle_height,
	        false,
	        handle_color, 1,
	        style.slider_handle_rounding
	    );
    
	    gmui_add_roundrect(
	        handle_x, handle_y,
	        handle_x + handle_width, handle_y + handle_height,
	        true,
	        style.slider_handle_border_color, 1,
	        style.slider_handle_rounding
	    );
	};
    
    gmui_end_widget(widget, true);
    
    return value;
};

function gmui_slider_disabled(value, min_val, max_val, width = 200) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("slider");
    
    var track_height = style.slider_track_height;
    var handle_width = style.slider_handle_width;
    var handle_height = style.slider_handle_height;
    
    widget.width = width;
    widget.height = max(track_height, handle_height);
    
    if (gmui_widget_is_callable(widget)) {
        var normalized = clamp((value - min_val) / (max_val - min_val), 0, 1);
        var track_x = widget.x;
        var track_y = widget.y + (widget.height - track_height) / 2;
        var handle_x = track_x + (width - handle_width) * normalized;
        var handle_y = widget.y + (widget.height - handle_height) / 2;
        
        gmui_add_roundrect(track_x, track_y, track_x + width, track_y + track_height, false, make_color_rgb(40, 40, 40), 1, style.slider_track_rounding);
        
        if (normalized > 0) {
            gmui_add_roundrect(track_x, track_y, track_x + (width - handle_width) * normalized + handle_width / 2, track_y + track_height, false, make_color_rgb(60, 60, 80), 1, style.slider_track_rounding);
        }
        
        gmui_add_roundrect(handle_x, handle_y, handle_x + handle_width, handle_y + handle_height, false, make_color_rgb(100, 100, 100), 1, style.slider_handle_rounding);
        gmui_add_roundrect(handle_x, handle_y, handle_x + handle_width, handle_y + handle_height, true, make_color_rgb(70, 70, 70), 1, style.slider_handle_rounding);
    }
    
    gmui_end_widget(widget);
    return value;
};

function gmui_slider_int(value, min_val, max_val, width = 200) {
    return round(gmui_slider(value, min_val, max_val, width));
};

function gmui_slider_percent(value, width = 200) {
    return gmui_slider(value, 0, 100, width);
};

function gmui_slider_normalized(value, width = 200) {
    return gmui_slider(value, 0, 1, width);
};

// link-style text
function gmui_text_clickable(text, font = undefined) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("text");
    
    var _font = gmui_resolve_font(widget, font);
    var text_size = gmui_calculate_text_size(text, _font);
    widget.width = text_size[0];
    widget.height = text_size[1];
    
    var released = false;
    
    if (gmui_widget_is_callable(widget)) {
		var mouse_interaction = gmui_widget_mouse_interactive_behaviour(widget);
		
	    var hovered = mouse_interaction.is_hovering;
	    var active = mouse_interaction.is_active;
	    released = mouse_interaction.is_pressed;
        
        var color = style.text_clickable_color_idle;
        if (active) {
            color = style.text_clickable_color_active;
        } else if (hovered) {
            color = style.text_clickable_color_hover;
        }
        
        gmui_add_text(text, widget.x, widget.y, color, style.text_alpha, _font);
        
        gmui_add_line(widget.x, widget.y + text_size[1] + 1, widget.x + text_size[0], widget.y + text_size[1] + 1, color, 1);
    }
    
    gmui_end_widget(widget, true);
    return released;
};

// image button
function gmui_image_button(sprite, subimg = 0, width = -1, height = -1) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("image_button");
    
    var img_w = width > 0 ? width : sprite_get_width(sprite);
    var img_h = height > 0 ? height : sprite_get_height(sprite);
    
    widget.width = img_w + style.image_button_padding_h * 2;
    widget.height = img_h + style.image_button_padding_v * 2;
    
    var released = false;
    
    if (gmui_widget_is_callable(widget)) {
        var hovered = gmui_widget_is_hovered(widget);
        gmui_widget_is_pressed(widget);
        released = hovered && gmui_input_mouse_released();
        
        var bg_color = style.image_button_bg_color;
        if (gmui_widget_is_active(widget)) {
            bg_color = style.image_button_bg_active_color;
        } else if (hovered) {
            bg_color = style.image_button_bg_hover_color;
        }
        
        gmui_add_roundrect(widget.x, widget.y, widget.x + widget.width, widget.y + widget.height, false, bg_color, 1, style.image_button_rounding);
        gmui_add_roundrect(widget.x, widget.y, widget.x + widget.width, widget.y + widget.height, true, style.image_button_border_color, 1, style.image_button_rounding);
        
        var sx = widget.x + (widget.width - img_w) / 2;
        var sy = widget.y + (widget.height - img_h) / 2;
        gmui_add_sprite(sprite, subimg, sx, sy);
    }
    
    gmui_end_widget(widget, true);
    return released;
};

function gmui_image_button_labeled(sprite, label, subimg = 0, width = -1, height = -1, font = undefined) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("image_button");
    
    var _font = gmui_resolve_font(widget, font);
    var img_w = sprite_get_width(sprite);
    var img_h = sprite_get_height(sprite);
    var text_size = gmui_calculate_text_size(label, _font);
    var gap = 6;
    
    var total_w = img_w + gap + text_size[0] + style.image_button_padding_h * 2;
    var total_h = max(img_h, text_size[1]) + style.image_button_padding_v * 2;
    
    widget.width = width > 0 ? width : total_w;
    widget.height = height > 0 ? height : total_h;
    
    var released = false;
    
    if (gmui_widget_is_callable(widget)) {
        var hovered = gmui_widget_is_hovered(widget);
        gmui_widget_is_pressed(widget);
        released = hovered && gmui_input_mouse_released();
        
        var bg_color = style.image_button_bg_color;
        if (gmui_widget_is_active(widget)) {
            bg_color = style.image_button_bg_active_color;
        } else if (hovered) {
            bg_color = style.image_button_bg_hover_color;
        }
        
        gmui_add_roundrect(widget.x, widget.y, widget.x + widget.width, widget.y + widget.height, false, bg_color, 1, style.image_button_rounding);
        gmui_add_roundrect(widget.x, widget.y, widget.x + widget.width, widget.y + widget.height, true, style.image_button_border_color, 1, style.image_button_rounding);
        
        var sy = widget.y + (widget.height - img_h) / 2;
        gmui_add_sprite(sprite, subimg, widget.x + style.image_button_padding_h, sy);
        
        var text_y = widget.y + (widget.height - text_size[1]) / 2;
        var text_x = widget.x + style.image_button_padding_h + img_w + gap;
        gmui_add_text(label, text_x, text_y, style.button_text_color, 1, _font);
    }
    
    gmui_end_widget(widget, true);
    return released;
};

function gmui_image_button_tinted(sprite, subimg, tint_color, width = -1, height = -1) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("image_button");
    
    var img_w = width > 0 ? width : sprite_get_width(sprite);
    var img_h = height > 0 ? height : sprite_get_height(sprite);
    
    widget.width = img_w + style.image_button_padding_h * 2;
    widget.height = img_h + style.image_button_padding_v * 2;
    
    var released = false;
    
    if (gmui_widget_is_callable(widget)) {
        var hovered = gmui_widget_is_hovered(widget);
        gmui_widget_is_pressed(widget);
        released = hovered && gmui_input_mouse_released();
        
        var bg_color = style.image_button_bg_color;
        if (gmui_widget_is_active(widget)) {
            bg_color = style.image_button_bg_active_color;
        } else if (hovered) {
            bg_color = style.image_button_bg_hover_color;
        }
        
        gmui_add_roundrect(widget.x, widget.y, widget.x + widget.width, widget.y + widget.height, false, bg_color, 1, style.image_button_rounding);
        gmui_add_roundrect(widget.x, widget.y, widget.x + widget.width, widget.y + widget.height, true, style.image_button_border_color, 1, style.image_button_rounding);
        
        var sx = widget.x + (widget.width - img_w) / 2;
        var sy = widget.y + (widget.height - img_h) / 2;
        
        var tr = color_get_red(tint_color) / 255;
        var tg = color_get_green(tint_color) / 255;
        var tb = color_get_blue(tint_color) / 255;
        gmui_add_sprite(sprite, subimg, sx, sy, make_color_rgb(tr * 255, tg * 255, tb * 255), 1);
    }
    
    gmui_end_widget(widget, true);
    return released;
};

// toggle switch
function gmui_toggle(value) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("toggle");
    
    var toggle_w = style.toggle_width;
    var toggle_h = style.toggle_height;
    var knob_size = style.toggle_knob_size;
    var padding = style.toggle_padding;
    
    widget.width = toggle_w;
    widget.height = toggle_h;
    
    if (gmui_widget_is_callable(widget)) {
        var mouse_interaction = gmui_widget_mouse_interactive_behaviour(widget);
        var hovered = mouse_interaction.is_hovering;
        var released = mouse_interaction.is_pressed;
        
        if (released) value = !value;
        
        var bg_color = style.toggle_color_idle;
        if (value) {
            bg_color = style.toggle_color_active;
        } else if (hovered) {
            bg_color = style.toggle_color_hover;
        }
        
        gmui_add_roundrect(widget.x, widget.y, widget.x + toggle_w, widget.y + toggle_h, false, bg_color, 1, style.toggle_rounding);
        
        var knob_x = value ? widget.x + toggle_w - knob_size - padding : widget.x + padding;
        var knob_y = widget.y + (toggle_h - knob_size) / 2;
        
        gmui_add_roundrect(knob_x, knob_y, knob_x + knob_size, knob_y + knob_size, false, style.toggle_knob_color, 1, knob_size / 2);
    }
    
    gmui_end_widget(widget, true);
    return value;
};

function gmui_toggle_disabled(value) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("toggle");
    
    widget.width = style.toggle_width;
    widget.height = style.toggle_height;
    
    if (gmui_widget_is_callable(widget)) {
        var bg_color = value ? make_color_rgb(60, 80, 130) : make_color_rgb(50, 50, 50);
        var knob_color = make_color_rgb(150, 150, 150);
        
        gmui_add_roundrect(widget.x, widget.y, widget.x + style.toggle_width, widget.y + style.toggle_height, false, bg_color, 1, style.toggle_rounding);
        
        var knob_x = value ? widget.x + style.toggle_width - style.toggle_knob_size - style.toggle_padding : widget.x + style.toggle_padding;
        var knob_y = widget.y + (style.toggle_height - style.toggle_knob_size) / 2;
        gmui_add_roundrect(knob_x, knob_y, knob_x + style.toggle_knob_size, knob_y + style.toggle_knob_size, false, knob_color, 1, style.toggle_knob_size / 2);
    }
    
    gmui_end_widget(widget);
    return value;
};

function gmui_toggle_danger(value) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("toggle_danger");
    var toggle_w = style.toggle_width;
    var toggle_h = style.toggle_height;
    var knob_size = style.toggle_knob_size;
    var padding = style.toggle_padding;
    
    widget.width = toggle_w;
    widget.height = toggle_h;
    var new_value = value;
    
    if (gmui_widget_is_callable(widget)) {
        var mouse = gmui_widget_mouse_interactive_behaviour(widget);
        if (mouse.is_hovering && mouse.is_pressed) new_value = !value;
        
        var idle = make_color_rgb(180, 50, 50);
        var hover = make_color_rgb(220, 70, 70);
        var active_col = make_color_rgb(140, 30, 30);
        var off_bg = style.color_widget_base;
        var knob = c_white;
        
        var bg = value ? idle : off_bg;
        if (value && mouse.is_hovering) bg = hover;
        if (value && mouse.is_active) bg = active_col;
        if (!value && mouse.is_hovering) bg = style.color_widget_hover;
        
        gmui_add_roundrect(widget.x, widget.y, widget.x + toggle_w, widget.y + toggle_h, false, bg, 1, style.toggle_rounding);
        
        var knob_x = value ? widget.x + toggle_w - knob_size - padding : widget.x + padding;
        var knob_y = widget.y + (toggle_h - knob_size) / 2;
        gmui_add_roundrect(knob_x, knob_y, knob_x + knob_size, knob_y + knob_size, false, knob, 1, knob_size / 2);
    }
    gmui_end_widget(widget, true);
    return new_value;
}

function gmui_toggle_success(value) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("toggle_success");
    var toggle_w = style.toggle_width;
    var toggle_h = style.toggle_height;
    var knob_size = style.toggle_knob_size;
    var padding = style.toggle_padding;
    
    widget.width = toggle_w;
    widget.height = toggle_h;
    var new_value = value;
    
    if (gmui_widget_is_callable(widget)) {
        var mouse = gmui_widget_mouse_interactive_behaviour(widget);
        if (mouse.is_hovering && mouse.is_pressed) new_value = !value;
        
        var idle = make_color_rgb(50, 160, 80);
        var hover = make_color_rgb(70, 190, 100);
        var active_col = make_color_rgb(35, 120, 60);
        var off_bg = style.color_widget_base;
        var knob = c_white;
        
        var bg = value ? idle : off_bg;
        if (value && mouse.is_hovering) bg = hover;
        if (value && mouse.is_active) bg = active_col;
        if (!value && mouse.is_hovering) bg = style.color_widget_hover;
        
        gmui_add_roundrect(widget.x, widget.y, widget.x + toggle_w, widget.y + toggle_h, false, bg, 1, style.toggle_rounding);
        
        var knob_x = value ? widget.x + toggle_w - knob_size - padding : widget.x + padding;
        var knob_y = widget.y + (toggle_h - knob_size) / 2;
        gmui_add_roundrect(knob_x, knob_y, knob_x + knob_size, knob_y + knob_size, false, knob, 1, knob_size / 2);
    }
    gmui_end_widget(widget, true);
    return new_value;
}

function gmui_toggle_flags(value, flag) {
    var new_value = gmui_toggle((value & flag) != 0);
    if (new_value != ((value & flag) != 0)) {
        if (new_value) {
            return value | flag;
        } else {
            return value & ~flag;
        }
    }
    return value;
};

// knob/dial
function gmui_knob(value, min_val, max_val, size = -1, label = "", font = undefined) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("knob");
    
    var knob_size = size > 0 ? size : style.knob_size;
    var radius = knob_size / 2;
    var knob_id = widget.id;
    
    widget.width = knob_size;
    widget.height = knob_size + (label != "" ? gmui_calculate_text_size("W")[1] + 6 : 0);
	
    var _font = gmui_resolve_font(widget, font);
    
    if (gmui_widget_is_callable(widget)) {
        var cx = widget.x + radius;
        var cy = widget.y + radius;
        
        var normalized = clamp((value - min_val) / (max_val - min_val), 0, 1);
        var start_angle = style.knob_start_angle * pi / 180;
        var sweep_angle = style.knob_sweep_angle * pi / 180;
        var fill_angle = start_angle + sweep_angle * normalized;
        
        var hovered = gmui_widget_is_hovered(widget);
        
        if (hovered && gmui_input_mouse_pressed()) {
            gmui.input.active_widget_id = knob_id;
            widget.container._knob_start_value = value;
            widget.container._knob_start_mouse_y = gmui.input.m_y;
        }
        if (gmui.input.active_widget_id == knob_id && gmui.input.m_held) {
            var dy = widget.container._knob_start_mouse_y - gmui.input.m_y;
            var range = max_val - min_val;
            value = widget.container._knob_start_value + dy * style.knob_drag_sensitivity * range;
            value = clamp(value, min_val, max_val);
            normalized = (value - min_val) / range;
        }
        fill_angle = start_angle + sweep_angle * normalized;
        
        var outer_r = radius - 2;
        var outer_ring_r = outer_r - style.knob_outer_ring;
        var track_outer = outer_ring_r;
        var track_inner = track_outer - style.knob_track_thickness;
        var center_r = track_inner * style.knob_center_size;
        
        gmui_add_circle(cx, cy, outer_r, false, style.knob_outer_ring_color, 1);
        gmui_add_circle(cx, cy, outer_r, true, make_color_rgb(40, 40, 40), 1);
        
        _gmui_draw_arc(cx, cy, track_inner, track_outer, start_angle, start_angle + sweep_angle, style.knob_track_color, 48);
        
        if (normalized > 0) {
            _gmui_draw_arc(cx, cy, track_inner, track_outer, start_angle, fill_angle, style.knob_fill_color, 48);
        }
        
        gmui_add_circle(cx, cy, center_r, false, style.knob_center_color, 1);
        gmui_add_circle(cx, cy, center_r, true, make_color_rgb(50, 50, 50), 1);
        
        var ind_angle = fill_angle;
        var ind_start = center_r * 0.3;
        var ind_end = track_inner * style.knob_indicator_length;
        var ix1 = cx + cos(ind_angle) * ind_start;
        var iy1 = cy - sin(ind_angle) * ind_start;
        var ix2 = cx + cos(ind_angle) * ind_end;
        var iy2 = cy - sin(ind_angle) * ind_end;
        
        gmui_add_line(ix1, iy1, ix2, iy2, style.knob_indicator_color, style.knob_indicator_thickness);
        
        var value_text = string_format(value, 1, 0);
        var text_size = gmui_calculate_text_size(value_text);
        gmui_add_text(value_text, cx - text_size[0] / 2, cy - text_size[1] / 2, style.knob_text_color, 1, _font);
        
        if (label != "") {
            var label_size = gmui_calculate_text_size(label);
            gmui_add_text(label, cx - label_size[0] / 2, widget.y + knob_size + 2, style.plot_gauge_label_color, 1, _font);
        }
    }
    
    gmui_end_widget(widget, true);
    return value;
};

function gmui_knob_int(value, min_val, max_val, size = -1, label = "", font = undefined) {
    return round(gmui_knob(value, min_val, max_val, size, label, font));
};

function gmui_knob_percent(value, size = -1, label = "", font = undefined) {
    return gmui_knob(value, 0, 100, size, label, font);
};

// color palette - grid of preset swatches
function gmui_color_palette(selected_color, colors, count, cols = -1) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("color_palette");
    var container = widget.container;
    
    var swatch_size = style.color_palette_swatch_size;
    var spacing = style.color_palette_swatch_spacing;
    var num_cols = cols > 0 ? cols : style.color_palette_cols;
    var cell_size = swatch_size + spacing * 2;
    var num_rows = ceil(count / num_cols);
    
    var total_w = num_cols * cell_size;
    var total_h = num_rows * cell_size;
    
    widget.width = total_w;
    widget.height = total_h;
    
    var new_color = selected_color;
    
    if (gmui_widget_is_callable(widget)) {
		gmui_add_rectangle(widget.x, widget.y, widget.x + widget.width, widget.y + widget.height, false, style.color_palette_swatch_bg_color, 1);
		gmui_add_rectangle(widget.x, widget.y, widget.x + widget.width, widget.y + widget.height, true, style.color_palette_swatch_border_color, 1);
        
		var offset = gmui_get_container_screen_offset(container);
        
        for (var i = 0; i < count; i++) {
            var col = i % num_cols;
            var row = i div num_cols;
            
            var sx = widget.x + col * cell_size + spacing;
            var sy = widget.y + row * cell_size + spacing;
            
            var screen_sx = offset[0] + sx - container.scroll_x;
            var screen_sy = offset[1] + sy - container.scroll_y;
            
            var sw_hovered = container.is_mouse_hovering &&
                gmui.input.m_x >= screen_sx && gmui.input.m_x <= screen_sx + swatch_size &&
                gmui.input.m_y >= screen_sy && gmui.input.m_y <= screen_sy + swatch_size;
            
            if (sw_hovered && gmui_input_mouse_pressed()) {
                container.state[? "_palette_pressed"] = i;
            }
            
            if (gmui_input_mouse_released() && container.state[? "_palette_pressed"] == i && sw_hovered) {
                new_color = colors[i];
                container.state[? "_palette_pressed"] = undefined;
            }
            
            var is_selected = (colors[i] == selected_color);
            var is_pressed = (container.state[? "_palette_pressed"] == i);
            
            var r = color_get_red(colors[i]);
            var g = color_get_green(colors[i]);
            var b = color_get_blue(colors[i]);
            var a = ((colors[i] >> 24) & 255);
            if (a == 0) a = 255;
            
            gmui_add_rectangle(sx, sy, sx + swatch_size, sy + swatch_size, false, make_color_rgb(r, g, b), a / 255);
            
            var border_color = style.color_palette_swatch_border_color;
            var border_thick = 1;
            
            if (is_selected) {
                border_color = style.color_palette_swatch_selected_border;
                border_thick = style.color_palette_swatch_selected_thickness;
            } else if (sw_hovered || is_pressed) {
                border_color = style.color_palette_swatch_hover_border;
            }
            
            gmui_add_rectangle(sx, sy, sx + swatch_size, sy + swatch_size, true, border_color, border_thick);
        }
    }
    
    gmui_end_widget(widget);
    return new_color;
};

// multi-select list
function gmui_multiselect(selected, items, item_count, width = -1, height = -1, font = undefined) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("multiselect");
    var container = widget.container;
    
    var item_height = style.multiselect_item_height;
    var list_width = width > 0 ? width : container.width - style.container_padding_h * 2 - container.context.indent_level;
    var list_height = height > 0 ? height : min(300, item_count * item_height);
    
    widget.width = list_width;
    widget.height = list_height;
    
    var _font = gmui_resolve_font(widget, font);
    
    if (gmui_widget_is_callable(widget)) {
        var offset = gmui_get_container_screen_offset(container);
        var checkbox_size = style.multiselect_checkbox_size;
        var check_spacing = style.multiselect_checkbox_spacing;
        
        gmui_add_rectangle(widget.x, widget.y, widget.x + list_width, widget.y + list_height, false, style.combo_color, 1);
        gmui_add_rectangle(widget.x, widget.y, widget.x + list_width, widget.y + list_height, true, style.combo_border_color, 1);
        
        for (var i = 0; i < item_count; i++) {
            var iy = widget.y + i * item_height;
            
            var screen_iy = offset[1] + iy - container.scroll_y;
            var screen_ix = offset[0] + widget.x - container.scroll_x;
            
            var item_hovered = gmui.input.hovered_container != undefined && gmui.input.hovered_container.name == widget.container.name &&
                gmui.input.m_y >= screen_iy && gmui.input.m_y <= screen_iy + item_height &&
                gmui.input.m_x >= screen_ix && gmui.input.m_x <= screen_ix + list_width;
            
            if (item_hovered && gmui_input_mouse_pressed()) {
                container.state[? "_ms_pressed"] = i;
            }
            
            if (gmui_input_mouse_released() && container.state[? "_ms_pressed"] == i && item_hovered) {
                var item_key = items[i];
                if (ds_map_exists(selected, item_key)) {
                    ds_map_delete(selected, item_key);
                } else {
                    ds_map_add(selected, item_key, true);
                }
                container.state[? "_ms_pressed"] = undefined;
            }
            
            var is_selected = ds_map_exists(selected, items[i]);
            var is_pressed = (container.state[? "_ms_pressed"] == i);
            
            var bg_color = style.multiselect_item_color;
            if (is_selected) bg_color = style.multiselect_item_selected_color;
            else if (item_hovered || is_pressed) bg_color = style.multiselect_item_hover_color;
            
            gmui_add_rectangle(widget.x, iy, widget.x + list_width, iy + item_height, false, bg_color, 1);
            
            var cbx = widget.x + check_spacing;
            var cby = iy + (item_height - checkbox_size) / 2;
            
            gmui_add_rectangle(cbx, cby, cbx + checkbox_size, cby + checkbox_size, false, is_selected ? style.checkbox_color_active : style.checkbox_color_idle, 1);
            gmui_add_rectangle(cbx, cby, cbx + checkbox_size, cby + checkbox_size, true, style.checkbox_border_color, 1);
            
            if (is_selected) {
                var inset = 2;
                var mx = cbx + checkbox_size / 2;
                var my = cby + checkbox_size / 2;
                gmui_add_line_width(cbx + inset, my, mx - 1, cby + checkbox_size - inset, 2, style.checkbox_checkmark_color);
                gmui_add_line_width(mx - 1, cby + checkbox_size - inset, cbx + checkbox_size - inset, cby + inset, 2, style.checkbox_checkmark_color);
            }
            
            var text_color = is_selected ? style.multiselect_text_selected_color : style.multiselect_text_color;
            var text_x = cbx + checkbox_size + check_spacing;
            var text_size = gmui_calculate_text_size(items[i], _font);
            var text_y = iy + (item_height - text_size[1]) / 2;
            
            var max_width = list_width - text_x - check_spacing;
            var display_text = items[i];
            if (text_size[0] > max_width) {
                for (var len = string_length(display_text); len > 0; len--) {
                    var test = string_copy(display_text, 1, len) + "...";
                    if (gmui_calculate_text_size(test, _font)[0] <= max_width) {
                        display_text = test;
                        break;
                    }
                }
            }
            
            gmui_add_text(display_text, text_x, text_y, text_color, 1, _font);
        }
    }
    
    gmui_end_widget(widget);
    return selected;
};

// key-value list
function gmui_kv_list(items, count, width = -1, font = undefined) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("kv_list");
    var container = widget.container;
    
    var list_width = width > 0 ? width : container.width - style.container_padding_h * 2 - container.context.indent_level;
    var row_height = style.kv_row_height;
    var key_width = list_width * style.kv_key_width_ratio;
    var value_width = list_width - key_width;
    
    widget.width = list_width;
    widget.height = count * row_height;
    
    var _font = gmui_resolve_font(widget, font);
    
    if (gmui_widget_is_callable(widget)) {
        for (var i = 0; i < count; i++) {
            var ry = widget.y + i * row_height;
            
            if (i % 2 == 0) {
                gmui_add_rectangle(widget.x, ry, widget.x + list_width, ry + row_height, false, make_color_rgb(40, 40, 40), 1);
            }
            
            if (i > 0) {
                gmui_add_line(widget.x, ry, widget.x + list_width, ry, style.kv_separator_color, 1);
            }
            
            var item = items[i];
            var key = item[0];
            var value = string(item[1]);
            
            var key_size = gmui_calculate_text_size(key, _font);
            var key_x = widget.x + 8;
            var key_y = ry + (row_height - key_size[1]) / 2;
            gmui_add_text(key, key_x, key_y, style.kv_key_color, 1, _font);
            
            var value_size = gmui_calculate_text_size(value, _font);
            var value_x = widget.x + key_width;
            var value_y = ry + (row_height - value_size[1]) / 2;
            
            var max_val_w = value_width - 8;
            var display_value = value;
            if (value_size[0] > max_val_w) {
                for (var len = string_length(value); len > 0; len--) {
                    var test = string_copy(value, 1, len) + "...";
                    if (gmui_calculate_text_size(test, _font)[0] <= max_val_w) {
                        display_value = test;
                        break;
                    }
                }
            }
            
            gmui_add_text(display_value, value_x, value_y, style.kv_value_color, 1, _font);
        }
    }
    
    gmui_end_widget(widget);
    return true;
};

// radio button
function gmui_radio(label, selected, font = undefined) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("radio");
    
    var radio_size = style.radio_size;
    var padding = style.radio_padding;
    var _font = gmui_resolve_font(widget, font);
    
    var text_size = label == "" ? [0, 0] : gmui_calculate_text_size(label, _font);
    
    widget.width = radio_size + padding + text_size[0];
    widget.height = max(radio_size, text_size[1]);
    
    var clicked = false;
    
    if (gmui_widget_is_callable(widget)) {
        var hovered = gmui_widget_is_hovered(widget);
        gmui_widget_is_pressed(widget);
        var active = gmui_widget_is_active(widget);
        var released = hovered && gmui_input_mouse_released();
        
        if (released) clicked = true;
        
        var bg_color = style.radio_color_idle;
        if (active) bg_color = style.radio_color_active;
        else if (hovered) bg_color = style.radio_color_hovered;
        
        var rx = widget.x;
        var ry = widget.y + (widget.height - radio_size) / 2;
        
        gmui_add_circle(rx + radio_size / 2, ry + radio_size / 2, radio_size / 2, false, bg_color, 1);
        gmui_add_circle(rx + radio_size / 2, ry + radio_size / 2, radio_size / 2, true, style.radio_border_color, 1);
        
        if (selected) {
            var dot_size = radio_size / 2.5;
            gmui_add_circle(rx + radio_size / 2, ry + radio_size / 2, dot_size / 2, false, style.radio_dot_color, 1);
        }
        
        if (label != "") {
            var tx = rx + radio_size + padding;
            var ty = widget.y + (widget.height - text_size[1]) / 2;
            gmui_add_text(label, tx, ty, style.radio_text_color, style.radio_text_alpha, _font);
        }
    }
    
    gmui_end_widget(widget, true);
    return clicked;
};

function gmui_radio_disabled(label, selected = false, font = undefined) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("radio");
    
    var radio_size = style.radio_size;
    var padding = style.radio_padding;
    var _font = gmui_resolve_font(widget, font);
    var text_size = label == "" ? [0, 0] : gmui_calculate_text_size(label, _font);
    
    widget.width = radio_size + padding + text_size[0];
    widget.height = max(radio_size, text_size[1]);
    
    if (gmui_widget_is_callable(widget)) {
        var rx = widget.x;
        var ry = widget.y + (widget.height - radio_size) / 2;
        var bg_color = make_color_rgb(40, 40, 40);
        var border_color = make_color_rgb(60, 60, 60);
        var dot_color = make_color_rgb(100, 100, 100);
        var text_color = style.text_disabled_color;
        
        gmui_add_circle(rx + radio_size / 2, ry + radio_size / 2, radio_size / 2, false, bg_color, 1);
        gmui_add_circle(rx + radio_size / 2, ry + radio_size / 2, radio_size / 2, true, border_color, 1);
        
        if (selected) {
            gmui_add_circle(rx + radio_size / 2, ry + radio_size / 2, radio_size / 4, false, dot_color, 1);
        }
        
        if (label != "") {
            gmui_add_text(label, rx + radio_size + padding, widget.y + (widget.height - text_size[1]) / 2, text_color, 1, _font);
        }
    }
    
    gmui_end_widget(widget);
    return false;
};

function gmui_radio_enum(label, selected_enum, enum_value, font = undefined) {
    if (gmui_radio(label, selected_enum == enum_value, font)) {
        return enum_value;
    }
    return selected_enum;
};

// radio group
function gmui_radio_group(labels, selected_index, font = undefined) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("radio_group");
    var container = widget.container;
    
    var _font = gmui_resolve_font(widget, font);
    var max_width = 0;
    var total_height = 0;
    var radio_size = style.radio_size;
    var padding = style.radio_padding;
    
    for (var i = 0; i < array_length(labels); i++) {
        var text_size = gmui_calculate_text_size(labels[i], _font);
        max_width = max(max_width, radio_size + padding + text_size[0]);
        total_height += max(radio_size, text_size[1]) + style.element_spacing_v;
    }
    
    widget.width = max_width;
    widget.height = total_height;
    
    if (gmui_widget_is_callable(widget)) {
        for (var i = 0; i < array_length(labels); i++) {
            var text_size = gmui_calculate_text_size(labels[i], _font);
            var item_h = max(radio_size, text_size[1]);
            var ry = widget.y + i * (item_h + style.element_spacing_v);
            var rx = widget.x;
            
            var item_hovered = gmui.input.m_x >= gmui_get_container_screen_offset(container)[0] + rx - container.scroll_x &&
                               gmui.input.m_x <= gmui_get_container_screen_offset(container)[0] + rx + widget.width - container.scroll_x &&
                               gmui.input.m_y >= gmui_get_container_screen_offset(container)[1] + ry - container.scroll_y &&
                               gmui.input.m_y <= gmui_get_container_screen_offset(container)[1] + ry + item_h - container.scroll_y;
            
            if (item_hovered && gmui_input_mouse_pressed()) {
                container.state[? "_radio_pressed"] = i;
            }
            
            if (gmui_input_mouse_released() && container.state[? "_radio_pressed"] == i && item_hovered) {
                selected_index = i;
                container.state[? "_radio_pressed"] = undefined;
            }
            
            var is_selected = (i == selected_index);
            var is_pressed = (container.state[? "_radio_pressed"] == i);
            
            var bg_color = style.radio_color_idle;
            if (is_pressed) bg_color = style.radio_color_active;
            else if (item_hovered) bg_color = style.radio_color_hovered;
            
            gmui_add_circle(rx + radio_size / 2, ry + item_h / 2, radio_size / 2, false, bg_color, 1);
            gmui_add_circle(rx + radio_size / 2, ry + item_h / 2, radio_size / 2, true, style.radio_border_color, 1);
            
            if (is_selected) {
                var dot_size = radio_size / 2.5;
                gmui_add_circle(rx + radio_size / 2, ry + item_h / 2, dot_size / 2, false, style.radio_dot_color, 1);
            }
            
            var tx = rx + radio_size + padding;
            var ty = ry + (item_h - text_size[1]) / 2;
            gmui_add_text(labels[i], tx, ty, style.radio_text_color, style.radio_text_alpha, _font);
        }
    }
    
    gmui_end_widget(widget);
    return selected_index;
};

// textbox
function gmui_textbox(text, placeholder = "", width = 200, is_password = false, font = undefined) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("textbox");
    
    var textbox_height = style.textbox_height;
    var padding_h = style.textbox_padding_h;
    var padding_v = style.textbox_padding_v;
    
    widget.width = width;
    widget.height = textbox_height;
    
    var _font = gmui_resolve_font(widget, font);
    var container = widget.container;
    
    if (!variable_struct_exists(container, "_tb_counter")) {
        container._tb_counter = 0;
    }
    var tb_id = container._tb_counter;
    container._tb_counter++;
    var state_prefix = "_tb" + string(tb_id) + "_";
    
    if (!variable_struct_exists(container, state_prefix + "cursor")) {
        variable_struct_set(container, state_prefix + "cursor", string_length(text));
        variable_struct_set(container, state_prefix + "cursor_start", string_length(text));
        variable_struct_set(container, state_prefix + "cursor_alpha", 1);
        variable_struct_set(container, state_prefix + "scroll_x", 0);
    }
    
    var cursor = variable_struct_get(container, state_prefix + "cursor");
    var cursor_start = variable_struct_get(container, state_prefix + "cursor_start");
    var cursor_alpha = variable_struct_get(container, state_prefix + "cursor");
    var scroll_x = variable_struct_get(container, state_prefix + "scroll_x");
    var textbox_id = widget.id;
    var is_focused = (gmui.input.focused_widget_id == textbox_id);
    var text_full_width = string_width(text);
    
    if (!is_focused) cursor = string_length(text);
    
    if (gmui_widget_is_callable(widget)) {
        var hovered = gmui_widget_is_hovered(widget);
        
        if (hovered && gmui_input_mouse_pressed()) {
            gmui.input.focused_widget_id = textbox_id;
            is_focused = true;
            
            var offset = gmui_get_container_screen_offset(container);
            var click_x = gmui.input.m_x - offset[0] - widget.x - padding_h + scroll_x + container.scroll_x;
            cursor = _gmui_textbox_get_cursor_pos(text, click_x);
			cursor_start = cursor;
        }
		
		if (is_focused && gmui_input_mouse_held()) {
            var offset = gmui_get_container_screen_offset(container);
            var click_x = gmui.input.m_x - offset[0] - widget.x - padding_h + scroll_x + container.scroll_x;
            cursor = _gmui_textbox_get_cursor_pos(text, click_x);
		};
        
        if (gmui_input_mouse_pressed() && !hovered && is_focused) {
            gmui.input.focused_widget_id = undefined;
            is_focused = false;
        }
        
        if (is_focused) {
			container.ignore_surface_flag_once = true;
			if (gmui_input_key_pressed()) {
			    var char = gmui_input_lastchar();
			    var key = gmui_input_key();
			    var keycode = gmui_input_lastkey();
			    var byte = string_byte_at(char, 1);
    
			    var is_ignored_key = (keycode == vk_shift || keycode == vk_lshift || keycode == vk_rshift ||
                       keycode == vk_control || keycode == vk_lcontrol || keycode == vk_rcontrol ||
                       keycode == vk_alt || keycode == vk_lalt || keycode == vk_ralt ||
                       keycode == vk_left || keycode == vk_right || keycode == vk_up || keycode == vk_down ||
                       keycode == vk_home || keycode == vk_end || keycode == vk_backspace || keycode == vk_delete ||
                       keycode == vk_enter || keycode == vk_escape || keycode == vk_tab ||
                       keycode == 20 || keycode == vk_insert || keycode == vk_pageup || keycode == vk_pagedown);
				
				if (gmui_input_ctrl() && gmui_input_key_pressed()) {
				    var s = min(cursor, cursor_start);
				    var e = max(cursor, cursor_start);
				    var count = e - s;
    
				    switch (key) {
				        case ord("A"):
				            cursor_start = 0;
				            cursor = string_length(text);
				            break;
				        case ord("C"):
				            if (count > 0) {
				                clipboard_set_text(string_copy(text, s + 1, count));
				            } else if (text != "") {
				                clipboard_set_text(text);
				            }
				            break;
				        case ord("X"):
				            if (count > 0) {
				                clipboard_set_text(string_copy(text, s + 1, count));
				                text = string_delete(text, s + 1, count);
				                cursor = s;
				                cursor_start = cursor;
				            } else if (text != "") {
				                clipboard_set_text(text);
				                text = "";
				                cursor = 0;
				                cursor_start = 0;
				            }
				            break;
				        case ord("V"):
				            if (count > 0) {
				                text = string_delete(text, s + 1, count);
				                cursor = s;
				                cursor_start = cursor;
				            }
				            var paste = clipboard_get_text();
				            if (paste != "") {
				                text = string_insert(paste, text, cursor + 1);
				                cursor += string_length(paste);
				                cursor_start = cursor;
				            }
				            break;
				    }
				}
				
			    switch (key) {
			        case vk_backspace:
						if (cursor == cursor_start && cursor != 0) {
				            text = string_delete(text, cursor, 1);
							cursor--;
						}
						else if (cursor != cursor_start && cursor != 0) {
							var s = min(cursor, cursor_start);
							var e = max(cursor, cursor_start);
							var count = e - s;
							text = string_delete(text, s + 1, count);
							cursor_start = cursor;
						}
			            break;
			        case vk_delete:
						if (cursor == cursor_start && cursor != string_length(text)) {
				            text = string_delete(text, cursor + 1, 1);
						}
						else if (cursor != cursor_start && cursor != string_length(text)) {
							var s = min(cursor, cursor_start);
							var e = max(cursor, cursor_start);
							var count = e - s;
							text = string_delete(text, s + 1, count);
							cursor_start = cursor;
						}
			            break;
			        case vk_left:
			            cursor--;
						if (!gmui_input_key_held(vk_shift)) { cursor_start = cursor; }
			            break;
			        case vk_right:
			            cursor++;
						if (!gmui_input_key_held(vk_shift)) { cursor_start = cursor; }
			            break;
			        case vk_home:
			            cursor = 0;
			            break;
			        case vk_end:
			            cursor = string_length(text);
			            break;
			    }
    
			    if (!is_ignored_key && char != "" && byte >= 32 && byte <= 126) {
				    if (cursor != cursor_start) {
				        var s = min(cursor, cursor_start);
				        var e = max(cursor, cursor_start);
				        var count = e - s;
				        text = string_delete(text, s + 1, count);
				        cursor = s;
				        cursor_start = cursor;
				    }
    
				    text = string_insert(char, text, cursor + 1);
				    cursor++;
				    cursor_start = cursor;
				}
			}
        }
        
        var view_width = width - padding_h * 2;
        var cursor_x = string_width(string_copy(text, 1, cursor));
        text_full_width = string_width(text);
        
        if (cursor_x - scroll_x > view_width - style.textbox_cursor_width) {
            scroll_x = cursor_x - view_width + style.textbox_cursor_width;
        }
        if (cursor_x - scroll_x < 0) {
            scroll_x = cursor_x;
        }
        scroll_x = clamp(scroll_x, 0, max(0, text_full_width - view_width));
        
        variable_struct_set(container, state_prefix + "cursor", max(min(cursor, string_length(text)), 0));
        variable_struct_set(container, state_prefix + "cursor_start", max(min(cursor_start, string_length(text)), 0));
        variable_struct_set(container, state_prefix + "scroll_x", scroll_x);
        
        var bg_color = style.textbox_color;
        var border_color = is_focused ? style.textbox_focused_border_color : style.textbox_border_color;
        if (hovered && !is_focused) border_color = make_color_rgb(100, 100, 100);
        
        gmui_add_roundrect(widget.x, widget.y, widget.x + width, widget.y + textbox_height, false, bg_color, 1, style.textbox_rounding);
        gmui_add_roundrect(widget.x, widget.y, widget.x + width, widget.y + textbox_height, true, border_color, 1, style.textbox_rounding);
		
		if (is_focused && cursor != cursor_start) {
			var letter_width = gmui_calculate_text_size("W", _font)[0] / 2;
			var start_pos = min(cursor, cursor_start);
			var end_pos = max(cursor, cursor_start);
			var s_x = widget.x + padding_h + string_width(string_copy(text, 1, start_pos)) - scroll_x - 2;
			var e_x = widget.x + padding_h + string_width(string_copy(text, 1, end_pos)) - scroll_x - 2;
			gmui_add_roundrect(s_x, widget.y + 2, e_x, widget.y + textbox_height - 2, false, style.textbox_selection_color, 1, 0);
		}
        
        var clip_x = widget.x + padding_h;
        var clip_y = widget.y + padding_v;
        var clip_w = width - padding_h * 2;
        var clip_h = textbox_height - padding_v * 2;
        
		if (container.use_surface) {
			gmui_add_scissor_begin_isolated(clip_x, clip_y, clip_w, clip_h);
		}
		else {
			gmui_add_scissor_begin(clip_x, clip_y, clip_w, clip_h);
		}
        
        var display_text = text;
        var display_color = style.textbox_text_color;
        var text_y = widget.y + (textbox_height - gmui_calculate_text_size("W", _font)[1]) / 2;
        
        if (text == "" && !is_focused && placeholder != "") {
            display_text = placeholder;
            display_color = style.textbox_placeholder_color;
        }
        
		if (is_password && text != "") {
			gmui_add_text(string_repeat(style.textbox_password_char, string_length(text)), widget.x + padding_h - scroll_x, text_y, display_color, 1, _font);
		}
		else {
			gmui_add_text(display_text, widget.x + padding_h - scroll_x, text_y, display_color, 1, _font);
		}
        
        if (is_focused) {
			cursor_alpha = ((sin(current_time / 200) + 1) / 2) * 0.7 + 0.3;
            var cur_x = widget.x + padding_h + string_width(string_copy(text, 1, cursor)) - scroll_x - 2;
			if (text == "") { cur_x += 2 };
            gmui_add_rectangle(cur_x, widget.y + padding_v, cur_x + style.textbox_cursor_width, widget.y + textbox_height - padding_v, false, style.textbox_cursor_color, cursor_alpha);
        }
        
        gmui_add_scissor_end();
    }
    
    gmui_end_widget(widget, true);
    return text;
};

function gmui_textbox_disabled(text, placeholder = "", width = 200, is_password = false, font = undefined) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("textbox");
    
    var textbox_height = style.textbox_height;
    var _font = gmui_resolve_font(widget, font);
    
    widget.width = width;
    widget.height = textbox_height;
    
    if (gmui_widget_is_callable(widget)) {
        gmui_add_roundrect(widget.x, widget.y, widget.x + width, widget.y + textbox_height, false, make_color_rgb(30, 30, 30), 1, style.textbox_rounding);
        gmui_add_roundrect(widget.x, widget.y, widget.x + width, widget.y + textbox_height, true, make_color_rgb(60, 60, 60), 1, style.textbox_rounding);
        
        var display_text = text;
        if (text == "" && placeholder != "") display_text = placeholder;
        
        var text_y = widget.y + (textbox_height - gmui_calculate_text_size("W", _font)[1]) / 2;
		if (is_password && text != "") {
			gmui_add_text(string_repeat(style.textbox_password_char, string_length(text)), widget.x + style.textbox_padding_h, text_y, style.text_disabled_color, 1, _font);
		}
		else {
			gmui_add_text(display_text, widget.x + style.textbox_padding_h, text_y, style.text_disabled_color, 1, _font);
		}
    }
    
    gmui_end_widget(widget);
    return text;
};

function gmui_textbox_password(text, placeholder = "", width = 200, font = undefined) {
	return gmui_textbox(text, placeholder, width, true, font);
};

function gmui_textbox_disabled_password(text, placeholder = "", width = 200, font = undefined) {
	return gmui_textbox_disabled(text, placeholder, width, true, font);
};

function gmui_input_float(value, step = 1, min_val = -1000000, max_val = 1000000, width = 120, color_identifier = undefined, dec = 8, font = undefined) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("input_float");
    
    var textbox_height = style.textbox_height;
    var padding_h = style.textbox_padding_h;
    var padding_v = style.textbox_padding_v;
    var drag_zone = style.drag_textbox_drag_hotzone;
    
    widget.width = width;
    widget.height = textbox_height;
    
    var _font = gmui_resolve_font(widget, font);
    var container = widget.container;
    
    if (!variable_struct_exists(container, "_tb_counter")) {
        container._tb_counter = 0;
    }
    var tb_id = container._tb_counter;
    container._tb_counter++;
    var state_prefix = "_if" + string(tb_id) + "_";
    
    if (!variable_struct_exists(container, state_prefix + "cursor")) {
        variable_struct_set(container, state_prefix + "cursor", 0);
        variable_struct_set(container, state_prefix + "cursor_start", 0);
        variable_struct_set(container, state_prefix + "scroll_x", 0);
        variable_struct_set(container, state_prefix + "text", string_format(value, 1, dec));
    }
    
    var cursor = variable_struct_get(container, state_prefix + "cursor");
    var cursor_start = variable_struct_get(container, state_prefix + "cursor_start");
    var scroll_x = variable_struct_get(container, state_prefix + "scroll_x");
    var text = variable_struct_get(container, state_prefix + "text");
    var textbox_id = widget.id;
    var drag_id = textbox_id + "_drag";
    var is_focused = (gmui.input.focused_widget_id == textbox_id);
    var is_dragging = (gmui.input.active_widget_id == drag_id);
    
    if (!is_focused && !is_dragging) {
        cursor = string_length(text);
    }
	
	if (!is_focused && !is_dragging) { variable_struct_set(container, state_prefix + "text", string_format(value, 1, dec)); };
    
    if (gmui_widget_is_callable(widget)) {
        var hovered = gmui_widget_is_hovered(widget);
        var offset = gmui_get_container_screen_offset(container);
        
        var screen_drag_x = offset[0] + widget.x + width - drag_zone - container.scroll_x;
        var over_drag = gmui.input.m_x >= screen_drag_x && gmui.input.m_x <= screen_drag_x + drag_zone &&
                        gmui.input.m_y >= offset[1] + widget.y - container.scroll_y &&
                        gmui.input.m_y <= offset[1] + widget.y + textbox_height - container.scroll_y;
        
        if (over_drag && gmui_input_mouse_pressed()) {
            gmui.input.active_widget_id = drag_id;
            gmui.input.hovered_widget_id = drag_id;
            gmui.input.focused_widget_id = undefined;
            container._if_drag_start_value = value;
            container._if_drag_start_mx = gmui.input.m_x;
            is_dragging = true;
            is_focused = false;
        }
        
        if (is_dragging && gmui.input.m_held) {
			container.ignore_surface_flag_once = true;
            var dx = gmui.input.m_x - container._if_drag_start_mx;
            value = container._if_drag_start_value + dx * style.drag_textbox_sensitivity * step;
            value = clamp(value, min_val, max_val);
            text = _gmui_format_float(value, dec);
        }
        
        if (is_dragging && gmui.input.m_released) {
            gmui.input.active_widget_id = undefined;
            is_dragging = false;
        }
        
        if (hovered && !over_drag && gmui_input_mouse_pressed()) {
            gmui.input.focused_widget_id = textbox_id;
            is_focused = true;
            
            var local_mx = gmui.input.m_x - offset[0] - widget.x - padding_h + scroll_x + container.scroll_x;
            cursor = _gmui_textbox_get_cursor_pos(text, local_mx);
            cursor_start = cursor;
        }
        
        if (is_focused && gmui_input_mouse_held()) {
            var local_mx = gmui.input.m_x - offset[0] - widget.x - padding_h + scroll_x + container.scroll_x;
            cursor = _gmui_textbox_get_cursor_pos(text, local_mx);
        }
        
        if (gmui_input_mouse_pressed() && !hovered && !is_dragging && is_focused) {
            gmui.input.focused_widget_id = undefined;
            is_focused = false;
            if (text != "" && text != "-" && text != ".") {
                value = clamp(real(text), min_val, max_val);
                text = _gmui_format_float(value, dec);
            } else {
                text = _gmui_format_float(value, dec);
            }
        }
        
        if (is_focused) {
		container.ignore_surface_flag_once = true;
            if (gmui_input_ctrl() && gmui_input_key_pressed()) {
                var key = gmui_input_key();
                var s = min(cursor, cursor_start);
                var e = max(cursor, cursor_start);
                var count = e - s;
                
                switch (key) {
                    case ord("A"): cursor_start = 0; cursor = string_length(text); break;
                    case ord("C"): if (count > 0) clipboard_set_text(string_copy(text, s + 1, count)); break;
                    case ord("X"):
                        if (count > 0) {
                            clipboard_set_text(string_copy(text, s + 1, count));
                            text = string_delete(text, s + 1, count);
                            cursor = s; cursor_start = cursor;
                        }
                        break;
                    case ord("V"):
                        if (count > 0) { text = string_delete(text, s + 1, count); cursor = s; cursor_start = cursor; }
                        var paste = clipboard_get_text();
                        if (paste != "") {
                            text = string_insert(paste, text, cursor + 1);
                            cursor += string_length(paste);
                            cursor_start = cursor;
                        }
                        break;
                }
            }
            
            if (gmui_input_key_pressed()) {
                var char = gmui_input_lastchar();
                var key = gmui_input_key();
                var keycode = gmui_input_lastkey();
                
                var is_ignored = (keycode == vk_shift || keycode == vk_lshift || keycode == vk_rshift ||
                                  keycode == vk_control || keycode == vk_lcontrol || keycode == vk_rcontrol ||
                                  keycode == vk_alt || keycode == vk_lalt || keycode == vk_ralt ||
                                  keycode == 20);
                
                switch (key) {
                    case vk_backspace:
                        if (cursor == cursor_start && cursor > 0) { text = string_delete(text, cursor, 1); cursor--; cursor_start = cursor; }
                        else if (cursor != cursor_start) {
                            var s = min(cursor, cursor_start), e = max(cursor, cursor_start);
                            text = string_delete(text, s + 1, e - s);
                            cursor = s; cursor_start = cursor;
                        }
                        break;
                    case vk_delete:
                        if (cursor == cursor_start && cursor < string_length(text)) { text = string_delete(text, cursor + 1, 1); }
                        else if (cursor != cursor_start) {
                            var s = min(cursor, cursor_start), e = max(cursor, cursor_start);
                            text = string_delete(text, s + 1, e - s);
                            cursor = s; cursor_start = cursor;
                        }
                        break;
                    case vk_left:
                        cursor--;
                        if (!gmui_input_shift()) cursor_start = cursor;
                        break;
                    case vk_right:
                        cursor++;
                        if (!gmui_input_shift()) cursor_start = cursor;
                        break;
                    case vk_home: cursor = 0; if (!gmui_input_shift()) cursor_start = cursor; break;
                    case vk_end: cursor = string_length(text); if (!gmui_input_shift()) cursor_start = cursor; break;
                    case vk_enter: case vk_escape:
                        gmui.input.focused_widget_id = undefined;
                        is_focused = false;
                        if (text != "" && text != "-" && text != ".") value = clamp(real(text), min_val, max_val);
                        text = _gmui_format_float(value, dec);
                        break;
                }
                
                var byte = string_byte_at(char, 1);
                if (!is_ignored && key != vk_backspace && key != vk_delete && key != vk_left && key != vk_right &&
                    key != vk_home && key != vk_end && key != vk_enter && key != vk_escape) {
                    if (byte >= 48 && byte <= 57) { // 0-9
                        if (cursor != cursor_start) {
                            var s = min(cursor, cursor_start), e = max(cursor, cursor_start);
                            text = string_delete(text, s + 1, e - s);
                            cursor = s; cursor_start = cursor;
                        }
                        text = string_insert(char, text, cursor + 1);
                        cursor++; cursor_start = cursor;
                    } else if (char == "-" && cursor == 0 && !string_pos("-", text)) {
                        if (cursor != cursor_start) {
                            var s = min(cursor, cursor_start), e = max(cursor, cursor_start);
                            text = string_delete(text, s + 1, e - s);
                            cursor = s; cursor_start = cursor;
                        }
                        text = string_insert("-", text, cursor + 1);
                        cursor++; cursor_start = cursor;
                    } else if (char == "." && !string_pos(".", text)) {
                        if (cursor != cursor_start) {
                            var s = min(cursor, cursor_start), e = max(cursor, cursor_start);
                            text = string_delete(text, s + 1, e - s);
                            cursor = s; cursor_start = cursor;
                        }
                        text = string_insert(".", text, cursor + 1);
                        cursor++; cursor_start = cursor;
                    }
                }
            }
        }
        
        cursor = clamp(cursor, 0, string_length(text));
        cursor_start = clamp(cursor_start, 0, string_length(text));
        var view_width = width - padding_h * 2 - drag_zone;
        var cursor_x = string_width(string_copy(text, 1, cursor));
        var text_full_width = string_width(text);
        
        if (cursor_x - scroll_x > view_width - 2) scroll_x = cursor_x - view_width + 2;
        if (cursor_x - scroll_x < 0) scroll_x = cursor_x;
        scroll_x = clamp(scroll_x, 0, max(0, text_full_width - view_width));
        
        variable_struct_set(container, state_prefix + "cursor", cursor);
        variable_struct_set(container, state_prefix + "cursor_start", cursor_start);
        variable_struct_set(container, state_prefix + "scroll_x", scroll_x);
        variable_struct_set(container, state_prefix + "text", text);
        
        var bg_color = style.drag_textbox_color;
        var border_color = style.drag_textbox_border_color;
        if (is_focused) border_color = style.drag_textbox_focused_border_color;
        else if (is_dragging) border_color = style.drag_textbox_drag_color;
        else if (hovered) border_color = make_color_rgb(120, 120, 120);
        
        gmui_add_roundrect(widget.x, widget.y, widget.x + width, widget.y + textbox_height, false, bg_color, 1, style.textbox_rounding);
        gmui_add_roundrect(widget.x, widget.y, widget.x + width, widget.y + textbox_height, true, border_color, 1, style.textbox_rounding);
		if (color_identifier == undefined || color_identifier >= 0) {
			gmui_add_rectangle(widget.x, widget.y, widget.x + 2, widget.y + textbox_height, false, color_identifier == undefined ? c_ltgray : color_identifier, 1);
		}
        
        if (is_focused && cursor != cursor_start) {
            var s = min(cursor, cursor_start), e = max(cursor, cursor_start);
            var s_x = widget.x + padding_h + string_width(string_copy(text, 1, s)) - scroll_x;
            var e_x = widget.x + padding_h + string_width(string_copy(text, 1, e)) - scroll_x;
            gmui_add_rectangle(s_x, widget.y + 2, e_x, widget.y + textbox_height - 2, false, style.textbox_selection_color, 1);
        }
        
        var drag_x = widget.x + width - drag_zone;
		var drag_cx = widget.x + width - drag_zone / 2;
		var dot_size = 2;
		var dot_spacing = 4;
		var dot_start_y = widget.y + (textbox_height - (dot_size * 3 + dot_spacing * 2)) / 2;

		var dot_color = over_drag || is_dragging ? style.drag_textbox_drag_color : style.drag_textbox_border_color;

		for (var d = 0; d < 3; d++) {
		    var dy = dot_start_y + d * (dot_size + dot_spacing);
		    gmui_add_rectangle(drag_cx - dot_size / 2, dy, drag_cx + dot_size / 2, dy + dot_size, false, dot_color, 1);
		}
        gmui_add_line(drag_x, widget.y + 4, drag_x, widget.y + textbox_height - 4,
                      over_drag || is_dragging ? style.drag_textbox_drag_color : style.drag_textbox_border_color, 1);
        
        gmui_add_scissor_begin(widget.x + padding_h, widget.y + padding_v, width - padding_h * 2 - drag_zone, textbox_height - padding_v * 2);
        
        var text_y = widget.y + (textbox_height - gmui_calculate_text_size("W", _font)[1]) / 2;
        gmui_add_text(text, widget.x + padding_h - scroll_x, text_y, style.drag_textbox_text_color, 1, _font);
        
        if (is_focused) {
            var cursor_alpha = ((sin(current_time / 200) + 1) / 2) * 0.7 + 0.3;
            var cur_x = widget.x + padding_h + string_width(string_copy(text, 1, cursor)) - scroll_x;
			if (text == "") { cur_x += 2 };
            gmui_add_rectangle(cur_x, widget.y + padding_v, cur_x + style.textbox_cursor_width, widget.y + textbox_height - padding_v, false, style.textbox_cursor_color, cursor_alpha);
        }
        
        gmui_add_scissor_end();
    }
    
    gmui_end_widget(widget, true);
    return value;
};

function gmui_input_float_disabled(value, width = 120, font = undefined) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("input_float");
    
    var textbox_height = style.textbox_height;
    var _font = gmui_resolve_font(widget, font);
    
    widget.width = width;
    widget.height = textbox_height;
    
    if (gmui_widget_is_callable(widget)) {
        gmui_add_roundrect(widget.x, widget.y, widget.x + width, widget.y + textbox_height, false, make_color_rgb(30, 30, 30), 1, style.textbox_rounding);
        gmui_add_roundrect(widget.x, widget.y, widget.x + width, widget.y + textbox_height, true, make_color_rgb(60, 60, 60), 1, style.textbox_rounding);
        
        var text = string_format(value, 1, 4);
        var text_y = widget.y + (textbox_height - gmui_calculate_text_size("W", _font)[1]) / 2;
        gmui_add_text(text, widget.x + style.textbox_padding_h, text_y, style.text_disabled_color, 1, _font);
    }
    
    gmui_end_widget(widget);
    return value;
};

function gmui_input_int(value, step = 1, min_val = -1000000, max_val = 1000000, width = 120, color_identifier = undefined, font = undefined) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("input_int");
    
    var textbox_height = style.textbox_height;
    var padding_h = style.textbox_padding_h;
    var padding_v = style.textbox_padding_v;
    var drag_zone = style.drag_textbox_drag_hotzone;
    
    widget.width = width;
    widget.height = textbox_height;
    
    var _font = gmui_resolve_font(widget, font);
    var container = widget.container;
    
    if (!variable_struct_exists(container, "_tb_counter")) {
        container._tb_counter = 0;
    }
    var tb_id = container._tb_counter;
    container._tb_counter++;
    var state_prefix = "_ii" + string(tb_id) + "_";
    
    if (!variable_struct_exists(container, state_prefix + "cursor")) {
        variable_struct_set(container, state_prefix + "cursor", 0);
        variable_struct_set(container, state_prefix + "cursor_start", 0);
        variable_struct_set(container, state_prefix + "scroll_x", 0);
        variable_struct_set(container, state_prefix + "text", string(value));
    }
	
    var cursor = variable_struct_get(container, state_prefix + "cursor");
    var cursor_start = variable_struct_get(container, state_prefix + "cursor_start");
    var scroll_x = variable_struct_get(container, state_prefix + "scroll_x");
    var text = variable_struct_get(container, state_prefix + "text");
    var textbox_id = widget.id;
    var drag_id = textbox_id + "_drag";
    var is_focused = (gmui.input.focused_widget_id == textbox_id);
    var is_dragging = (gmui.input.active_widget_id == drag_id);
    
    if (!is_focused && !is_dragging) {
        cursor = string_length(text);
    }
	
	if (!is_focused && !is_dragging) { variable_struct_set(container, state_prefix + "text", string(value)); };
    
    if (gmui_widget_is_callable(widget)) {
        var hovered = gmui_widget_is_hovered(widget);
        var offset = gmui_get_container_screen_offset(container);
        
        var screen_drag_x = offset[0] + widget.x + width - drag_zone - container.scroll_x;
        var over_drag = gmui.input.m_x >= screen_drag_x && gmui.input.m_x <= screen_drag_x + drag_zone &&
                        gmui.input.m_y >= offset[1] + widget.y - container.scroll_y &&
                        gmui.input.m_y <= offset[1] + widget.y + textbox_height - container.scroll_y;
        
        if (over_drag && gmui_input_mouse_pressed()) {
            gmui.input.active_widget_id = drag_id;
            gmui.input.hovered_widget_id = drag_id;
            gmui.input.focused_widget_id = undefined;
            container._ii_drag_start_value = value;
            container._ii_drag_start_mx = gmui.input.m_x;
            is_dragging = true;
            is_focused = false;
        }
        
        if (is_dragging && gmui.input.m_held) {
			container.ignore_surface_flag_once = true;
            var dx = gmui.input.m_x - container._ii_drag_start_mx;
            value = container._ii_drag_start_value + round(dx * style.drag_textbox_sensitivity) * step;
            value = clamp(value, min_val, max_val);
            text = string(value);
        }
        
        if (is_dragging && gmui.input.m_released) {
            gmui.input.active_widget_id = undefined;
            is_dragging = false;
            value = floor(value);
            text = string(value);
        }
        
        if (hovered && !over_drag && gmui_input_mouse_pressed()) {
            gmui.input.focused_widget_id = textbox_id;
            is_focused = true;
            
            var local_mx = gmui.input.m_x - offset[0] - widget.x - padding_h + scroll_x + container.scroll_x;
            cursor = _gmui_textbox_get_cursor_pos(text, local_mx);
            cursor_start = cursor;
        }
        
        if (is_focused && gmui_input_mouse_held()) {
            var local_mx = gmui.input.m_x - offset[0] - widget.x - padding_h + scroll_x + container.scroll_x;
            cursor = _gmui_textbox_get_cursor_pos(text, local_mx);
        }
        
        if (gmui_input_mouse_pressed() && !hovered && !is_dragging && is_focused) {
            gmui.input.focused_widget_id = undefined;
            is_focused = false;
            if (text != "" && text != "-") {
                value = clamp(floor(real(text)), min_val, max_val);
                text = string(value);
            } else {
                text = string(value);
            }
        }
        
        if (is_focused) {
		container.ignore_surface_flag_once = true;
            if (gmui_input_ctrl() && gmui_input_key_pressed()) {
                var key = gmui_input_key();
                var s = min(cursor, cursor_start);
                var e = max(cursor, cursor_start);
                var count = e - s;
                
                switch (key) {
                    case ord("A"): cursor_start = 0; cursor = string_length(text); break;
                    case ord("C"): if (count > 0) clipboard_set_text(string_copy(text, s + 1, count)); break;
                    case ord("X"):
                        if (count > 0) {
                            clipboard_set_text(string_copy(text, s + 1, count));
                            text = string_delete(text, s + 1, count);
                            cursor = s; cursor_start = cursor;
                        }
                        break;
                    case ord("V"):
                        if (count > 0) { text = string_delete(text, s + 1, count); cursor = s; cursor_start = cursor; }
                        var paste = clipboard_get_text();
                        if (paste != "") {
                            var filtered = "";
                            for (var i = 1; i <= string_length(paste); i++) {
                                var ch = string_char_at(paste, i);
                                var by = string_byte_at(ch, 1);
                                if ((by >= 48 && by <= 57) || (ch == "-" && cursor == 0 && !string_pos("-", text))) {
                                    filtered += ch;
                                }
                            }
                            if (filtered != "") {
                                text = string_insert(filtered, text, cursor + 1);
                                cursor += string_length(filtered);
                                cursor_start = cursor;
                            }
                        }
                        break;
                }
            }
            
            if (gmui_input_key_pressed()) {
                var char = gmui_input_lastchar();
                var key = gmui_input_key();
                var keycode = gmui_input_lastkey();
                
                var is_ignored = (keycode == vk_shift || keycode == vk_lshift || keycode == vk_rshift ||
                                  keycode == vk_control || keycode == vk_lcontrol || keycode == vk_rcontrol ||
                                  keycode == vk_alt || keycode == vk_lalt || keycode == vk_ralt ||
                                  keycode == 20);
                
                switch (key) {
                    case vk_backspace:
                        if (cursor == cursor_start && cursor > 0) { text = string_delete(text, cursor, 1); cursor--; cursor_start = cursor; }
                        else if (cursor != cursor_start) {
                            var s = min(cursor, cursor_start), e = max(cursor, cursor_start);
                            text = string_delete(text, s + 1, e - s);
                            cursor = s; cursor_start = cursor;
                        }
                        break;
                    case vk_delete:
                        if (cursor == cursor_start && cursor < string_length(text)) { text = string_delete(text, cursor + 1, 1); }
                        else if (cursor != cursor_start) {
                            var s = min(cursor, cursor_start), e = max(cursor, cursor_start);
                            text = string_delete(text, s + 1, e - s);
                            cursor = s; cursor_start = cursor;
                        }
                        break;
                    case vk_left:
                        cursor--;
                        if (!gmui_input_shift()) cursor_start = cursor;
                        break;
                    case vk_right:
                        cursor++;
                        if (!gmui_input_shift()) cursor_start = cursor;
                        break;
                    case vk_home: cursor = 0; if (!gmui_input_shift()) cursor_start = cursor; break;
                    case vk_end: cursor = string_length(text); if (!gmui_input_shift()) cursor_start = cursor; break;
                    case vk_enter: case vk_escape:
                        gmui.input.focused_widget_id = undefined;
                        is_focused = false;
                        if (text != "" && text != "-") value = clamp(floor(real(text)), min_val, max_val);
                        text = string(value);
                        break;
                }
                
                var byte = string_byte_at(char, 1);
                if (!is_ignored && key != vk_backspace && key != vk_delete && key != vk_left && key != vk_right &&
                    key != vk_home && key != vk_end && key != vk_enter && key != vk_escape) {
                    if (byte >= 48 && byte <= 57) { // 0-9
                        if (cursor != cursor_start) {
                            var s = min(cursor, cursor_start), e = max(cursor, cursor_start);
                            text = string_delete(text, s + 1, e - s);
                            cursor = s; cursor_start = cursor;
                        }
                        text = string_insert(char, text, cursor + 1);
                        cursor++; cursor_start = cursor;
                    } else if (char == "-" && cursor == 0 && !string_pos("-", text)) {
                        if (cursor != cursor_start) {
                            var s = min(cursor, cursor_start), e = max(cursor, cursor_start);
                            text = string_delete(text, s + 1, e - s);
                            cursor = s; cursor_start = cursor;
                        }
                        text = string_insert("-", text, cursor + 1);
                        cursor++; cursor_start = cursor;
                    }
                }
            }
        }
        
        cursor = clamp(cursor, 0, string_length(text));
        cursor_start = clamp(cursor_start, 0, string_length(text));
        var view_width = width - padding_h * 2 - drag_zone;
        var cursor_x = string_width(string_copy(text, 1, cursor));
        var text_full_width = string_width(text);
        
        if (cursor_x - scroll_x > view_width - 2) scroll_x = cursor_x - view_width + 2;
        if (cursor_x - scroll_x < 0) scroll_x = cursor_x;
        scroll_x = clamp(scroll_x, 0, max(0, text_full_width - view_width));
        
        variable_struct_set(container, state_prefix + "cursor", cursor);
        variable_struct_set(container, state_prefix + "cursor_start", cursor_start);
        variable_struct_set(container, state_prefix + "scroll_x", scroll_x);
        variable_struct_set(container, state_prefix + "text", text);
        
        var bg_color = style.drag_textbox_color;
        var border_color = style.drag_textbox_border_color;
        if (is_focused) border_color = style.drag_textbox_focused_border_color;
        else if (is_dragging) border_color = style.drag_textbox_drag_color;
        else if (hovered) border_color = make_color_rgb(120, 120, 120);
        
        gmui_add_roundrect(widget.x, widget.y, widget.x + width, widget.y + textbox_height, false, bg_color, 1, style.textbox_rounding);
        gmui_add_roundrect(widget.x, widget.y, widget.x + width, widget.y + textbox_height, true, border_color, 1, style.textbox_rounding);
		if (color_identifier == undefined || color_identifier >= 0) {
			gmui_add_rectangle(widget.x, widget.y, widget.x + 2, widget.y + textbox_height, false, color_identifier == undefined ? c_ltgray : color_identifier, 1);
		}
        
        if (is_focused && cursor != cursor_start) {
            var s = min(cursor, cursor_start), e = max(cursor, cursor_start);
            var s_x = widget.x + padding_h + string_width(string_copy(text, 1, s)) - scroll_x;
            var e_x = widget.x + padding_h + string_width(string_copy(text, 1, e)) - scroll_x;
            gmui_add_rectangle(s_x, widget.y + 2, e_x, widget.y + textbox_height - 2, false, style.textbox_selection_color, 1);
        }
        
        var drag_x = widget.x + width - drag_zone;
		var drag_cx = widget.x + width - drag_zone / 2;
		var dot_size = 2;
		var dot_spacing = 4;
		var dot_start_y = widget.y + (textbox_height - (dot_size * 3 + dot_spacing * 2)) / 2;

		var dot_color = over_drag || is_dragging ? style.drag_textbox_drag_color : style.drag_textbox_border_color;

		for (var d = 0; d < 3; d++) {
		    var dy = dot_start_y + d * (dot_size + dot_spacing);
		    gmui_add_rectangle(drag_cx - dot_size / 2, dy, drag_cx + dot_size / 2, dy + dot_size, false, dot_color, 1);
		}
        gmui_add_line(drag_x, widget.y + 4, drag_x, widget.y + textbox_height - 4,
                      over_drag || is_dragging ? style.drag_textbox_drag_color : style.drag_textbox_border_color, 1);
        
        gmui_add_scissor_begin(widget.x + padding_h, widget.y + padding_v, width - padding_h * 2 - drag_zone, textbox_height - padding_v * 2);
        
        var text_y = widget.y + (textbox_height - gmui_calculate_text_size("W", _font)[1]) / 2;
        gmui_add_text(text, widget.x + padding_h - scroll_x, text_y, style.drag_textbox_text_color, 1, _font);
        
        if (is_focused) {
            var cursor_alpha = ((sin(current_time / 200) + 1) / 2) * 0.7 + 0.3;
            var cur_x = widget.x + padding_h + string_width(string_copy(text, 1, cursor)) - scroll_x;
			if (text == "") { cur_x += 2 };
            gmui_add_rectangle(cur_x, widget.y + padding_v, cur_x + style.textbox_cursor_width, widget.y + textbox_height - padding_v, false, style.textbox_cursor_color, cursor_alpha);
        }
        
        gmui_add_scissor_end();
    }
    
    gmui_end_widget(widget, true);
    return value;
};

function gmui_input_int_disabled(value, width = 120, font = undefined) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("input_int");
    
    var textbox_height = style.textbox_height;
    var _font = gmui_resolve_font(widget, font);
    
    widget.width = width;
    widget.height = textbox_height;
    
    if (gmui_widget_is_callable(widget)) {
        gmui_add_roundrect(widget.x, widget.y, widget.x + width, widget.y + textbox_height, false, make_color_rgb(30, 30, 30), 1, style.textbox_rounding);
        gmui_add_roundrect(widget.x, widget.y, widget.x + width, widget.y + textbox_height, true, make_color_rgb(60, 60, 60), 1, style.textbox_rounding);
        
        var text = string_format(value, 1, 4);
        var text_y = widget.y + (textbox_height - gmui_calculate_text_size("W", _font)[1]) / 2;
        gmui_add_text(text, widget.x + style.textbox_padding_h, text_y, style.text_disabled_color, 1, _font);
    }
    
    gmui_end_widget(widget);
    return value;
};

// collapsing header
function gmui_begin_collapsing_header_height(label, height, default_open = false, font = undefined) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("collapsing_header");
    var container = widget.container;
    
    var state_key = label + "_open";
    if (container.state[? state_key] == undefined) {
        container.state[? state_key] = default_open;
    }
    
    var open = container.state[? state_key];
    
    var header_width = container.width - style.container_padding_h * 2 - container.context.indent_level;
    var header_height = height;
    
    widget.width = header_width;
    widget.height = header_height;
	
	var _font = gmui_resolve_font(widget, font);
    
	if (gmui_widget_is_callable(widget)) {
		var mouse_interaction = gmui_widget_mouse_interactive_behaviour(widget);
		
	    var hovered = mouse_interaction.is_hovering;
	    var active = mouse_interaction.is_active;
	    var released = mouse_interaction.is_pressed;
    
	    if (released) {
	        open = !open;
	        container.state[? state_key] = open;
	    }
    
	    var bg_color = style.collapsing_header_color;
	    if (active) {
	        bg_color = style.collapsing_header_active_color;
	    } else if (hovered) {
	        bg_color = style.collapsing_header_hovered_color;
	    }
    
	    gmui_add_roundrect(
	        widget.x, widget.y,
	        widget.x + header_width, widget.y + header_height,
	        false,
	        bg_color, 1,
	        style.collapsing_header_rounding
	    );
    
	    gmui_add_roundrect(
	        widget.x, widget.y,
	        widget.x + header_width, widget.y + header_height,
	        true,
	        style.collapsing_header_border_color, 1,
	        style.collapsing_header_rounding
	    );
    
		var arrow_padding = style.collapsing_header_padding;
		var arrow_size = style.collapsing_header_arrow_size;
		var arrow_x = widget.x + arrow_padding;
		var arrow_y = widget.y + header_height / 2;
		var arrow_color = style.collapsing_header_arrow_color;
		var half = arrow_size / 2;

		if (open) {
		    gmui_add_triangle(
		        arrow_x, arrow_y - half,				// top-left
		        arrow_x + arrow_size, arrow_y - half,	// top-right
		        arrow_x + half, arrow_y + half,			// bottom-center
		        arrow_color
		    );
		} else {
		    gmui_add_triangle(
		        arrow_x, arrow_y - half,				// top
		        arrow_x + arrow_size, arrow_y,			// right-center
		        arrow_x, arrow_y + half,				// bottom
		        arrow_color
		    );
		}
    
	    var text_x = arrow_x + arrow_size + arrow_padding;
	    var text_size = gmui_calculate_text_size(label);
	    var text_y = widget.y + (header_height - text_size[1]) / 2;
	    gmui_add_text(label, text_x, text_y, style.collapsing_header_text_color, 1, _font);
	};
    
    gmui_end_widget(widget, true);
    
    if (open) {
        gmui_indent(style.collapsing_header_indent);
    }
    
    return open;
};

function gmui_begin_collapsing_header(label, default_open = false, font = undefined) {
	return gmui_begin_collapsing_header_height(label, global.gmui.style.collapsing_header_height);
};
function gmui_begin_collapsing_header_ex(label, default_open = false, font = undefined) {
	return gmui_begin_collapsing_header_height(label, global.gmui.style.collapsing_header_height_ex);
};

function gmui_sleeper_header(label, body, default_open = false, is_sleeper = true, font = undefined) {
	if (gmui_begin_collapsing_header(label, default_open)) {
		if (is_sleeper) {
			if (gmui_begin_sleeper("sleeper_body_collapsing_header_" + label)) {
				body();
				gmui_end_sleeper();
			}
		}
		else {
			body();
		}
		gmui_end_collapsing_header();
	}
};

function gmui_end_collapsing_header() {
    var style = global.gmui.style;
    gmui_unindent(style.collapsing_header_indent);
};

function gmui_collapsing_group(label, default_open, func, font = undefined) {
    if (gmui_begin_collapsing_header(label, default_open, font)) {
        func();
        gmui_end_collapsing_header();
        return true;
    }
    return false;
};

function gmui_collapsing_group_ex(label, default_open, func, font = undefined) {
    if (gmui_begin_collapsing_header_ex(label, default_open, font)) {
        func();
        gmui_end_collapsing_header();
        return true;
    }
    return false;
};

// scrolling
function gmui_scrollbar_vertical(value, min_val, max_val, length, thickness = undefined) {
	gmui_container_ignore_cursor_advance_once();
	
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("scrollbar_vertical");
	
	widget.container.late_calls_enabled = true;
    
    var sb_thickness = thickness == undefined ? style.scrollbar_width : thickness;
    var sb_padding = style.scrollbar_padding;
    
    widget.width = sb_thickness + sb_padding * 2;
    widget.height = length;
    
    var track_x = widget.x;
    var track_y = widget.y;
    var track_width = sb_thickness;
    var track_height = length;
    
    var range = max_val - min_val;
    var thumb_height = max(style.scrollbar_min_thumb_size, track_height * (length / (length + range)));
    var thumb_ratio = (value - min_val) / max(1, range);
    var thumb_y = track_y + (track_height - thumb_height) * thumb_ratio;
    
	var mouse_interaction = gmui_widget_mouse_interactive_behaviour(widget);
	var hovered = mouse_interaction.is_hovering;
	var active = mouse_interaction.is_active;
	var released = mouse_interaction.is_pressed;
    var scrollbar_id = widget.id;
	
    var offset = gmui_get_container_screen_offset(widget.container);
    var screen_thumb_x = offset[0] + widget.x + sb_padding;
    var screen_thumb_y = offset[1] + widget.y + (track_height - thumb_height) * thumb_ratio;
    var thumb_hovered = point_in_rectangle(
        gmui.input.m_x, gmui.input.m_y,
        screen_thumb_x, screen_thumb_y,
        screen_thumb_x + sb_thickness, screen_thumb_y + thumb_height
    ) && gmui_is_container_or_parent(widget.container, gmui.input.hovered_container);
	
	if (hovered || thumb_hovered) { gmui.input.hovered_widget_id = scrollbar_id; }
    
    if (thumb_hovered && gmui_input_mouse_pressed()) {
        gmui.input.active_widget_id = scrollbar_id;
        widget.container._sb_drag_start_y = gmui.input.m_y;
        widget.container._sb_drag_start_value = value;
    }
    
    //if (hovered && gmui_input_mouse_pressed() && !thumb_hovered) {
	//    var click_y = gmui.input.m_y - (offset[1] + widget.y);
	//    var new_ratio = (click_y - thumb_height / 2) / (track_height - thumb_height);
	//    value = min_val + new_ratio * range;
	//    value = clamp(value, min_val, max_val);
    //}
    
    if (gmui.input.active_widget_id == scrollbar_id && gmui.input.m_held && (variable_struct_exists(widget.container, "_sb_drag_start_x") && variable_struct_exists(widget.container, "_sb_drag_start_value"))) {
        var dy = gmui.input.m_y - widget.container._sb_drag_start_y;
        var thumb_range = track_height - thumb_height;
        if (thumb_range > 0) {
            value = widget.container._sb_drag_start_value + (dy / thumb_range) * range;
            value = clamp(value, min_val, max_val);
        }
    }
    
	gmui_add_scrolling_disable();
	
    gmui_add_roundrect(
        track_x, track_y,
        track_x + track_width, track_y + track_height,
        false,
        style.scrollbar_track_color, 1, 
		style.scrollbar_rounding
    );
    
    var thumb_color = style.scrollbar_thumb_color;
    if (gmui.input.active_widget_id == scrollbar_id && gmui.input.m_held) {
        thumb_color = style.scrollbar_thumb_active_color;
    } else if (thumb_hovered) {
        thumb_color = style.scrollbar_thumb_hovered_color;
    }
    
    gmui_add_roundrect(
        track_x, track_y + (track_height - thumb_height) * thumb_ratio,
        track_x + track_width, track_y + (track_height - thumb_height) * thumb_ratio + thumb_height,
        false,
        thumb_color, 1, 
		style.scrollbar_rounding
    );
    
	gmui_add_scrolling_enable();
    
    gmui_end_widget(widget);
	
	widget.container.late_calls_enabled = false;
    
    return value;
};

function gmui_scrollbar_horizontal(value, min_val, max_val, length, thickness = undefined) {
	gmui_container_ignore_cursor_advance_once();
	
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("scrollbar_horizontal");
	
	widget.container.late_calls_enabled = true;
    
    var sb_thickness = thickness == undefined ? style.scrollbar_width : thickness;
    var sb_padding = style.scrollbar_padding;
    
    widget.width = length;
    widget.height = sb_thickness + sb_padding * 2;
    
    var track_x = widget.x;
    var track_y = widget.y;
    var track_width = length;
    var track_height = sb_thickness;
    
    var range = max_val - min_val;
    var thumb_width = max(style.scrollbar_min_thumb_size, track_width * (length / (length + range)));
    var thumb_ratio = (value - min_val) / max(1, range);
    var thumb_x = track_x + (track_width - thumb_width) * thumb_ratio;
    
	var mouse_interaction = gmui_widget_mouse_interactive_behaviour(widget);
	var hovered = mouse_interaction.is_hovering;
	var active = mouse_interaction.is_active;
	var released = mouse_interaction.is_pressed;
    var scrollbar_id = widget.id;
    
    var offset = gmui_get_container_screen_offset(widget.container);
    var screen_thumb_x = offset[0] + widget.x + (track_width - thumb_width) * thumb_ratio;
    var screen_thumb_y = offset[1] + widget.y + sb_padding;
    var thumb_hovered = point_in_rectangle(
        gmui.input.m_x, gmui.input.m_y,
        screen_thumb_x, screen_thumb_y,
        screen_thumb_x + thumb_width, screen_thumb_y + sb_thickness
    ) && gmui_is_container_or_parent(widget.container, gmui.input.hovered_container);
	
	if (hovered || thumb_hovered) { gmui.input.hovered_widget_id = scrollbar_id; }
    
    if (thumb_hovered && gmui_input_mouse_pressed()) {
        gmui.input.active_widget_id = scrollbar_id;
        widget.container._sb_drag_start_x = gmui.input.m_x;
        widget.container._sb_drag_start_value = value;
    }
    
    //if (hovered && gmui_input_mouse_pressed() && !thumb_hovered) {
    //    var click_x = gmui.input.m_x - (offset[0] + widget.x);
    //    var new_ratio = (click_x - thumb_width / 2) / (track_width - thumb_width);
    //    value = min_val + new_ratio * range;
    //    value = clamp(value, min_val, max_val);
    //}
    
    if (gmui.input.active_widget_id == scrollbar_id && gmui.input.m_held && (variable_struct_exists(widget.container, "_sb_drag_start_x") && variable_struct_exists(widget.container, "_sb_drag_start_value"))) {
        var dx = gmui.input.m_x - widget.container._sb_drag_start_x;
        var thumb_range = track_width - thumb_width;
        if (thumb_range > 0) {
            value = widget.container._sb_drag_start_value + (dx / thumb_range) * range;
            value = clamp(value, min_val, max_val);
        }
    }
    
	gmui_add_scrolling_disable();
    
    gmui_add_roundrect(
        track_x, track_y,
        track_x + track_width, track_y + track_height,
        false,
        style.scrollbar_track_color, 1, 
		style.scrollbar_rounding
    );
    
    var thumb_color = style.scrollbar_thumb_color;
    if (gmui.input.active_widget_id == scrollbar_id && gmui.input.m_held) {
        thumb_color = style.scrollbar_thumb_active_color;
    } else if (thumb_hovered) {
        thumb_color = style.scrollbar_thumb_hovered_color;
    }
    
    gmui_add_roundrect(
        track_x + (track_width - thumb_width) * thumb_ratio, track_y,
        track_x + (track_width - thumb_width) * thumb_ratio + thumb_width, track_y + track_height,
        false,
        thumb_color, 1, 
		style.scrollbar_rounding
    );
    
	gmui_add_scrolling_enable();
    
    gmui_end_widget(widget);
	
	widget.container.late_calls_enabled = false;
    
    return value;
};

// tree view
function gmui_begin_tree(name) {
    var gmui = global.gmui;
    var container = gmui.current_container;
	
	gmui_container_cursor_advance();
	gmui_style_push("element_spacing_v", 0);
    
    var sel_key    = "_tree_selected_" + name;
    var stack_key  = "_tree_stack_" + name;
    var nodes_key  = "_tree_open_nodes_" + name;

    if (!ds_map_exists(container.state, stack_key)) {
        container.state[? stack_key]  = [];
        container.state[? sel_key]    = undefined;
        container.state[? nodes_key]  = ds_map_create();
    }
    
    var stack = container.state[? stack_key];
    array_push(stack, { depth: 0, tree_name: name });
    container.state[? stack_key] = stack;
    
    container.state[? "_tree_active"] = name;
    
    return true;
};

function gmui_begin_tree_node(label, default_open = false, font = -5) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("tree_node");
    var container = widget.container;
    
    var tree_name  = container.state[? "_tree_active"];
    var stack_key  = "_tree_stack_" + tree_name;
    var sel_key    = "_tree_selected_" + tree_name;
    var nodes_key  = "_tree_open_nodes_" + tree_name;

    var stack = container.state[? stack_key];
    if (array_length(stack) == 0) {
        gmui_end_widget(widget);
        return false;
    }
    
    var node_state = stack[array_length(stack) - 1];
    var _depth = node_state.depth;
    var node_id = label + "_d" + string(_depth);
    var open_nodes = container.state[? nodes_key];
    
    var open = default_open;
    if (ds_map_exists(open_nodes, node_id)) {
        open = open_nodes[? node_id];
    } else {
        open_nodes[? node_id] = default_open;
    }
    
    var item_height = style.tree_item_height;
    var item_width = container.width - style.container_padding_h * 2 - container.context.indent_level;
    var indent = _depth * style.tree_indent;
    
    widget.width = item_width;
    widget.height = item_height;
    
    var clicked = false;
    var _font = gmui_resolve_font(widget, font);
    
    if (gmui_widget_is_callable(widget)) {
        var hovered = gmui_widget_is_hovered(widget);
        gmui_widget_is_pressed(widget);
        var released = hovered && gmui_input_mouse_released();
        
        var arrow_x = widget.x + indent;
        var arrow_y = widget.y + item_height / 2;
        var arrow_size = style.tree_arrow_size;
        var arrow_half = arrow_size / 2;
        
        var offset = gmui_get_container_screen_offset(widget.container);
		var screen_arrow_x = offset[0] + arrow_x;
		var arrow_hover = hovered && gmui.input.m_x >= screen_arrow_x && gmui.input.m_x <= screen_arrow_x + arrow_size + 4;
        
		var arrow_press_key = "_tree_arrow_pressed_" + tree_name;
		var label_press_key = "_tree_label_pressed_" + tree_name;

		if (arrow_hover && gmui_input_mouse_pressed()) {
		    container.state[? arrow_press_key] = node_id;
		}
		if (gmui_input_mouse_released() && container.state[? arrow_press_key] == node_id && arrow_hover) {
		    open = !open;
		    open_nodes[? node_id] = open;
		    container.state[? arrow_press_key] = undefined;
		}
		if (gmui_input_mouse_released() && container.state[? arrow_press_key] == node_id && !arrow_hover) {
		    container.state[? arrow_press_key] = undefined;
		}
		
		if (hovered && !arrow_hover && gmui_input_mouse_pressed()) {
		    container.state[? label_press_key] = node_id;
		}
		if (gmui_input_mouse_released() && container.state[? label_press_key] == node_id && hovered && !arrow_hover) {
		    clicked = true;
		    container.state[? sel_key] = node_id;
		    container.state[? label_press_key] = undefined;
		}
		
        var bg_color = style.tree_item_color;
        var is_selected = (container.state[? sel_key] == node_id);
        if (is_selected) {
            bg_color = style.tree_item_selected_color;
        } else if (hovered) {
            bg_color = style.tree_item_hover_color;
        }
        
        gmui_add_rectangle(widget.x, widget.y, widget.x + item_width, widget.y + item_height, false, bg_color, 1);
        
        var arrow_color = arrow_hover ? style.tree_arrow_hover_color : style.tree_arrow_color;
        if (open) {
            gmui_add_triangle(arrow_x, arrow_y - arrow_half, arrow_x + arrow_size, arrow_y - arrow_half, arrow_x + arrow_half, arrow_y + arrow_half, arrow_color);
        } else {
            gmui_add_triangle(arrow_x, arrow_y - arrow_half, arrow_x + arrow_size, arrow_y, arrow_x, arrow_y + arrow_half, arrow_color);
        }
        
        var text_x = arrow_x + arrow_size + 4;
        var text_size = gmui_calculate_text_size(label, _font);
        var text_y = widget.y + (item_height - text_size[1]) / 2;
        var text_color = is_selected ? style.tree_item_selected_text_color : style.tree_item_text_color;
        gmui_add_text(label, text_x, text_y, text_color, 1, _font);
    }
    
    gmui_end_widget(widget);
    
	if (open) {
	    array_push(stack, { depth: _depth + 1, node_id: node_id, open: open, tree_name: tree_name });
	    container.state[? stack_key] = stack;
	}
    container.state[? stack_key] = stack;
    
    return open;
};

function gmui_tree_leaf(label, font = -5) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("tree_leaf");
    var container = widget.container;
    
    var tree_name  = container.state[? "_tree_active"];
    var stack_key  = "_tree_stack_" + tree_name;
    var sel_key    = "_tree_selected_" + tree_name;

    var stack = container.state[? stack_key];
    if (array_length(stack) == 0) {
        gmui_end_widget(widget);
        return false;
    }
    
    var node_state = stack[array_length(stack) - 1];
    var _depth = node_state.depth;
    var node_id = label + "_d" + string(_depth);
    
    var item_height = style.tree_item_height;
    var item_width = container.width - style.container_padding_h * 2 - container.context.indent_level;
    var indent = _depth * style.tree_indent + style.tree_arrow_size + 4;
    
    widget.width = item_width;
    widget.height = item_height;
    
    var clicked = false;
    var _font = gmui_resolve_font(widget, font);
    
    if (gmui_widget_is_callable(widget)) {
        var hovered = gmui_widget_is_hovered(widget);
        gmui_widget_is_pressed(widget);
        
        var leaf_press_key = "_tree_leaf_pressed_" + tree_name;

		if (hovered && gmui_input_mouse_pressed()) {
		    container.state[? leaf_press_key] = node_id;
		}

		var released = gmui_input_mouse_released() && container.state[? leaf_press_key] == node_id && hovered;

		if (released) {
		    clicked = true;
		    container.state[? sel_key] = node_id;
		    container.state[? leaf_press_key] = undefined;
		}
		
        var is_selected = (container.state[? sel_key] == node_id);
        var bg_color = is_selected ? style.tree_item_selected_color : (hovered ? style.tree_item_hover_color : style.tree_item_color);
        var text_color = is_selected ? style.tree_item_selected_text_color : style.tree_item_text_color;
        
        gmui_add_rectangle(widget.x, widget.y, widget.x + item_width, widget.y + item_height, false, bg_color, 1);
        
        var text_x = widget.x + indent;
        var text_size = gmui_calculate_text_size(label, _font);
        var text_y = widget.y + (item_height - text_size[1]) / 2;
        gmui_add_text(label, text_x, text_y, text_color, 1, _font);
    }
    
    gmui_end_widget(widget);
    return clicked;
};

function gmui_end_tree_node() {
    var container = global.gmui.current_container;
    var tree_name = container.state[? "_tree_active"];
    var stack_key = "_tree_stack_" + tree_name;
    var stack = container.state[? stack_key];
    if (array_length(stack) > 1) {
        array_pop(stack);
        container.state[? stack_key] = stack;
    }
};

function gmui_end_tree() {
    var container = global.gmui.current_container;
    var tree_name = container.state[? "_tree_active"];
    container.state[? "_tree_stack_" + tree_name] = [];
    container.state[? "_tree_active"] = undefined;
	gmui_style_pop("element_spacing_v");
};

function gmui_tree_get_selected() {
    var container = global.gmui.current_container;
    var tree_name = container.state[? "_tree_active"];
    var selected_id = container.state[? "_tree_selected_" + tree_name];
    
    if (selected_id != undefined) {
        var last_underscore = string_pos("_d", selected_id);
        if (last_underscore > 0) {
            return string_copy(selected_id, 1, last_underscore - 1);
        }
        return selected_id;
    }
    return undefined;
}

// combo box
function gmui_combo(selected_index, items, item_count, placeholder = "Select...", width = 200) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("combo");
    var container = widget.container;
    
    var combo_height = style.combo_height;
    var combo_id = widget.id;
    
    widget.width = width;
    widget.height = combo_height;
    
    var released = false;
    var open = false;
    var new_index = selected_index;
    
	var screen_x = 0;
	var screen_y = 0;
	
    if (gmui_widget_is_callable(widget)) {
        var hovered = gmui_widget_is_hovered(widget);
        var offset = gmui_get_container_screen_offset(widget.container);
        screen_x = offset[0] + widget.x;
        screen_y = offset[1] + widget.y;
        
        open = (gmui.input.focused_widget_id == combo_id);
        
        if (hovered && gmui_input_mouse_pressed()) {
            container.state[? "_combo_pressed"] = combo_id;
        }
        
        if (gmui_input_mouse_released() && container.state[? "_combo_pressed"] == combo_id && hovered) {
            var dd_name = combo_id + "_dd";
            var dd_container = gmui_container_get(dd_name, undefined);
            if (open) {
                gmui.input.focused_widget_id = undefined;
                open = false;
				dd_container.is_enabled = false;
            } else {
                gmui.input.focused_widget_id = combo_id;
                open = true;
				dd_container.is_enabled = true;
            }
            container.state[? "_combo_pressed"] = undefined;
        }
        
        if (open && gmui_input_mouse_pressed() && !hovered) {
            var dd_name = combo_id + "_dd";
            var dd_container = gmui_container_get(dd_name, undefined);
            if (!dd_container.is_mouse_hovering) {
                gmui.input.focused_widget_id = undefined;
                open = false;
				dd_container.is_enabled = false;
            }
        }
        
        var bg_color = style.combo_color;
        var border_color = style.combo_border_color;
        if (open) {
            bg_color = style.combo_hover_color;
        } else if (hovered) {
            bg_color = style.combo_hover_color;
            border_color = make_color_rgb(120, 120, 120);
        }
        
        gmui_add_roundrect(widget.x, widget.y, widget.x + width, widget.y + combo_height, false, bg_color, 1, style.combo_rounding);
        gmui_add_roundrect(widget.x, widget.y, widget.x + width, widget.y + combo_height, true, border_color, 1, style.combo_rounding);
        
        var display_text = placeholder;
        var display_color = style.combo_placeholder_color;
        if (selected_index >= 0 && selected_index < item_count) {
            display_text = items[selected_index];
            display_color = style.combo_text_color;
        }
        
        var text_y = widget.y + (combo_height - gmui_calculate_text_size("W")[1]) / 2;
        gmui_add_text(display_text, widget.x + style.combo_padding_h, text_y, display_color, 1);
        
        var arrow_x = widget.x + width - style.combo_arrow_size - 8;
        var arrow_y = widget.y + combo_height / 2;
        var arrow_half = style.combo_arrow_size / 2;
        
        if (open) {
            gmui_add_triangle(arrow_x, arrow_y + arrow_half, arrow_x + style.combo_arrow_size, arrow_y + arrow_half, arrow_x + arrow_half, arrow_y - arrow_half, style.combo_arrow_color); // up arrow
        } else {
            gmui_add_triangle(arrow_x, arrow_y - arrow_half, arrow_x + style.combo_arrow_size, arrow_y - arrow_half, arrow_x + arrow_half, arrow_y + arrow_half, style.combo_arrow_color); // down arrow
        }
    }
    
    gmui_end_widget(widget, true);
    
    if (open) {
	    var dd_name = combo_id + "_dd";
	    var dd_width = width;
	    var dd_height = min(style.combo_dropdown_max_height, item_count * style.combo_item_height);

	    var current_offset = gmui_get_container_screen_offset(widget.container);
	    var dd_x = current_offset[0] + widget.x - widget.container.scroll_x;
	    var dd_y = current_offset[1] + widget.y - widget.container.scroll_y + combo_height;
    
	    var screen_h = surface_get_height(application_surface);
	    if (dd_y + dd_height > screen_h) {
	        dd_y = current_offset[1] + widget.y - widget.container.scroll_y - dd_height;
	    }
    
	    var screen_w = surface_get_width(application_surface);
	    if (dd_x + dd_width > screen_w) {
	        dd_x = screen_w - dd_width - 4;
	    }
    
	    dd_x = max(0, dd_x);
	    dd_y = max(0, dd_y);
		
		if (gmui_begin_container_plain(dd_name, dd_x, dd_y, dd_width, dd_height)) {
		    var dd = gmui.current_container;
			dd.layer = gmui_layer.POPUP;
		    //dd.z_index = gmui.highest_z_index + 1;
		    dd.scrolling_enabled = true;
		    dd.use_scissor = true;
    
		    var saved_spacing_h = style.element_spacing_h;
		    var saved_spacing_v = style.element_spacing_v;
		    style.element_spacing_h = 0;
		    style.element_spacing_v = 0;
    
		    dd.context.cursor_x = 0;
		    dd.context.cursor_y = 0;
    
		    dd.context.cursor_x = 0;
		    dd.context.cursor_y = 0;
		    dd.context.line_height = 0;
		    dd.context.new_line_requested = false;
		    dd.context.indent_level = 0;
    
		    gmui_add_rectangle(0, 0, dd_width, dd_height, false, style.combo_color, 1);
		    gmui_add_rectangle(0, 0, dd_width, dd_height, true, style.combo_border_color, 1);
    
		    for (var i = 0; i < item_count; i++) {
		        var item_widget = gmui_begin_widget("combo_item");
		        item_widget.width = dd_width;
		        item_widget.height = style.combo_item_height;
        
		        if (gmui_widget_is_callable(item_widget)) {
		            var item_hovered = gmui_widget_is_hovered(item_widget);
            
		            if (item_hovered && gmui_input_mouse_pressed()) {
		                dd.state[? "_item_pressed"] = i;
		            }
            
		            if (gmui_input_mouse_released() && dd.state[? "_item_pressed"] == i && item_hovered) {
		                new_index = i;
		                gmui.input.focused_widget_id = undefined;
		                open = false;
						dd.is_enabled = false;
		                dd.state[? "_item_pressed"] = undefined;
		            }
            
		            var item_bg = style.combo_item_color;
		            if (i == selected_index) {
		                item_bg = style.selectable_selected_color;
		            } else if (item_hovered) {
		                item_bg = style.combo_item_hover_color;
		            }
            
		            gmui_add_rectangle(0, item_widget.y, dd_width, item_widget.y + style.combo_item_height, false, item_bg, 1);
            
		            var item_text_size = gmui_calculate_text_size(items[i]);
		            var item_text_y = item_widget.y + (style.combo_item_height - item_text_size[1]) / 2;
		            gmui_add_text(items[i], style.combo_padding_h, item_text_y, style.combo_item_text_color, 1);
		        }
        
		        gmui_end_widget(item_widget);
		    }
    
		    style.element_spacing_h = saved_spacing_h;
		    style.element_spacing_v = saved_spacing_v;
    
		    dd.content_height = dd.context.cursor_y;
		    gmui_end_container_plain();
		}
    }
    
    return new_index;
};

function gmui_combo_disabled(selected_index, items, item_count, placeholder = "Select...", width = 200) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("combo");
    
    var combo_height = style.combo_height;
    
    widget.width = width;
    widget.height = combo_height;
    
    if (gmui_widget_is_callable(widget)) {
        gmui_add_roundrect(widget.x, widget.y, widget.x + width, widget.y + combo_height, false, make_color_rgb(30, 30, 30), 1, style.combo_rounding);
        gmui_add_roundrect(widget.x, widget.y, widget.x + width, widget.y + combo_height, true, make_color_rgb(60, 60, 60), 1, style.combo_rounding);
        
        var display_text = placeholder;
        if (selected_index >= 0 && selected_index < item_count) display_text = items[selected_index];
        
        var text_y = widget.y + (combo_height - gmui_calculate_text_size("W")[1]) / 2;
        gmui_add_text(display_text, widget.x + style.combo_padding_h, text_y, style.text_disabled_color, 1);
        
        var arrow_x = widget.x + width - style.combo_arrow_size - 8;
        var arrow_y = widget.y + combo_height / 2;
        var arrow_half = style.combo_arrow_size / 2;
        gmui_add_triangle(arrow_x, arrow_y - arrow_half, arrow_x + style.combo_arrow_size, arrow_y - arrow_half, arrow_x + arrow_half, arrow_y + arrow_half, make_color_rgb(100, 100, 100));
    }
    
    gmui_end_widget(widget);
    return selected_index;
};

// color button
function gmui_color_button(color, size = -1, is_rgba = true) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("color_button");
    
    var btn_size = size > 0 ? size : style.color_button_size;
    widget.width = btn_size;
    widget.height = btn_size;
    
    var pressed = false;
    var color_id = widget.id;
    
    if (gmui_widget_is_callable(widget)) {
        var hovered = gmui_widget_is_hovered(widget);
        
        if (hovered && gmui_input_mouse_pressed()) {
            widget.container.state[? "_cb_pressed"] = color_id;
        }
        
        if (gmui_input_mouse_released() && widget.container.state[? "_cb_pressed"] == color_id && hovered) {
            pressed = true;
            widget.container.state[? "_cb_pressed"] = undefined;
        }
        
		var r, g, b, a = 255;
		if (is_rgba) {
			r = ((color) & 255);
			g = ((color >> 8) & 255);
			b = ((color >> 16) & 255);
			a = ((color >> 24) & 255);
		}
		else {
			r = color_get_red(color);
			g = color_get_green(color);
			b = color_get_blue(color);
		}
		
        var border_color = style.color_button_border_color;
        if (hovered) border_color = style.color_button_hover_border_color;
        
        gmui_add_shader_rect(widget.x, widget.y, widget.x + btn_size, widget.y + btn_size, GMUI_SHADER_CHECKERBOARD, [
            { type: "vec2", name: "u_size", value: [btn_size, btn_size] }
        ]);
        
        gmui_add_rectangle(widget.x, widget.y, widget.x + btn_size, widget.y + btn_size, false, make_color_rgb(r, g, b), a / 255);
        
        gmui_add_rectangle(widget.x, widget.y, widget.x + btn_size, widget.y + btn_size, true, border_color, 1);
    }
    
    gmui_end_widget(widget, true);
    return pressed;
};

// color picker
function gmui_color_picker(color, open_id) {
    var gmui = global.gmui;
    var style = gmui.style;
    var container = gmui.current_container;
    
    var hsv = gmui_rgb_to_hsv(color_get_red(color), color_get_green(color), color_get_blue(color));
    var alpha = ((color >> 24) & 255);
    if (alpha == 0) alpha = 255;
    
    var state_key = "_cp_" + open_id;
    if (container.state[? state_key] == undefined) {
        container.state[? state_key] = {
            hue: hsv[0],
            saturation: hsv[1],
            brightness: hsv[2],
            alpha: alpha,
        };
    }
    
    var st = container.state[? state_key];
    var hue = st.hue;
    var saturation = st.saturation;
    var brightness = st.brightness;
    var _alpha = st.alpha;
    
    var picker_w = style.color_picker_width;
    var picker_h = style.color_picker_height;
    var hue_h = style.color_picker_hue_height;
    var alpha_h = style.color_picker_alpha_height;
    var padding = style.color_picker_padding;
    var gap = style.color_picker_gap;
    var preview_size = style.color_picker_preview_size;
    
    var total_w = picker_w + padding * 2;
    var total_h = padding + picker_h + gap + hue_h + gap + alpha_h + gap + preview_size + padding;
    
    var widget = gmui_begin_widget("color_picker");
    widget.width = total_w;
    widget.height = total_h;
    
    var new_color = color;
    
    if (gmui_widget_is_callable(widget)) {
        var sx = widget.x + padding;
        var sy = widget.y + padding;
        var hue_y = sy + picker_h + gap;
        var alpha_y = hue_y + hue_h + gap;
        var preview_y = alpha_y + alpha_h + gap;
        
        var hovered = gmui_widget_is_hovered(widget);
        var offset = gmui_get_container_screen_offset(widget.container);
        var screen_x = offset[0] + widget.x + padding;
        var screen_y = offset[1] + widget.y + padding;
        
        gmui_add_shader_rect(sx, sy, sx + picker_w, sy + picker_h, GMUI_SHADER_SATURATION_BRIGHTNESS, [
            { type: "float", name: "u_hue", value: hue }
        ]);
        gmui_add_rectangle(sx, sy, sx + picker_w, sy + picker_h, true, style.color_picker_border_color, 1);
        
        var sb_cx = sx + saturation * picker_w;
        var sb_cy = sy + (1 - brightness) * picker_h;
        gmui_add_rectangle(sb_cx - 4, sb_cy - 4, sb_cx + 4, sb_cy + 4, true, c_white, 1);
        gmui_add_rectangle(sb_cx - 3, sb_cy - 3, sb_cx + 3, sb_cy + 3, true, c_black, 1);
        
        var sb_hover = hovered && gmui.input.m_x >= screen_x && gmui.input.m_x <= screen_x + picker_w &&
                                 gmui.input.m_y >= screen_y && gmui.input.m_y <= screen_y + picker_h;
        
        if (sb_hover && gmui_input_mouse_pressed()) {
            container.state[? "_cp_dragging"] = "sb";
        }
        
        if (container.state[? "_cp_dragging"] == "sb" && gmui.input.m_held) {
            saturation = clamp((gmui.input.m_x - screen_x) / picker_w, 0, 1);
            brightness = clamp(1 - (gmui.input.m_y - screen_y) / picker_h, 0, 1);
        }
        
        gmui_add_shader_rect(sx, hue_y, sx + picker_w, hue_y + hue_h, GMUI_SHADER_HUE, []);
        gmui_add_rectangle(sx, hue_y, sx + picker_w, hue_y + hue_h, true, style.color_picker_border_color, 1);
        
        var hue_cx = sx + hue * picker_w;
        gmui_add_rectangle(hue_cx - 2, hue_y - 2, hue_cx + 2, hue_y + hue_h + 2, true, c_white, 1);
        
        var hue_hover = hovered && gmui.input.m_x >= screen_x && gmui.input.m_x <= screen_x + picker_w &&
                                  gmui.input.m_y >= screen_y + picker_h + gap && gmui.input.m_y <= screen_y + picker_h + gap + hue_h;
        
        if (hue_hover && gmui_input_mouse_pressed()) {
            container.state[? "_cp_dragging"] = "hue";
        }
        
        if (container.state[? "_cp_dragging"] == "hue" && gmui.input.m_held) {
            hue = clamp((gmui.input.m_x - screen_x) / picker_w, 0, 1);
        }
        
        var rgb = gmui_hsv_to_rgb(hue, saturation, brightness);
        gmui_add_shader_rect(sx, alpha_y, sx + picker_w, alpha_y + alpha_h, GMUI_SHADER_CHECKERBOARD, [
            { type: "vec2", name: "u_size", value: [picker_w, alpha_h] }
        ]);	
        gmui_add_shader_rect(sx, alpha_y, sx + picker_w, alpha_y + alpha_h, GMUI_SHADER_ALPHA_GRADIENT, [
            { type: "vec3", name: "u_color", value: [rgb[0] / 255, rgb[1] / 255, rgb[2] / 255] }
        ]);
        gmui_add_rectangle(sx, alpha_y, sx + picker_w, alpha_y + alpha_h, true, style.color_picker_border_color, 1);
        
        var alpha_cx = sx + (_alpha / 255) * picker_w;
        gmui_add_rectangle(alpha_cx - 2, alpha_y - 2, alpha_cx + 2, alpha_y + alpha_h + 2, true, c_white, 1);
        
        var alpha_hover = hovered && gmui.input.m_x >= screen_x && gmui.input.m_x <= screen_x + picker_w &&
                                    gmui.input.m_y >= screen_y + picker_h + gap + hue_h + gap &&
                                    gmui.input.m_y <= screen_y + picker_h + gap + hue_h + gap + alpha_h;
        
        if (alpha_hover && gmui_input_mouse_pressed()) {
            container.state[? "_cp_dragging"] = "alpha";
        }
        
        if (container.state[? "_cp_dragging"] == "alpha" && gmui.input.m_held) {
            _alpha = clamp((gmui.input.m_x - screen_x) / picker_w * 255, 0, 255);
        }
        
        if (gmui_input_mouse_released()) {
            container.state[? "_cp_dragging"] = undefined;
        }
        
        gmui_add_shader_rect(sx, preview_y, sx + preview_size, preview_y + preview_size, GMUI_SHADER_CHECKERBOARD, [
            { type: "vec2", name: "u_size", value: [preview_size, preview_size] }
        ]);
        
        gmui_add_rectangle(sx, preview_y, sx + preview_size, preview_y + preview_size, false, make_color_rgb(rgb[0], rgb[1], rgb[2]), _alpha / 255);
        gmui_add_rectangle(sx, preview_y, sx + preview_size, preview_y + preview_size, true, style.color_picker_border_color, 1);
        
        var hex_text = string_format(rgb[0], 1, 0) + ", " + string_format(rgb[1], 1, 0) + ", " + string_format(rgb[2], 1, 0) + ", " + string_format(_alpha, 1, 0);
        gmui_add_text(hex_text, sx + preview_size + gap, preview_y + (preview_size - gmui_calculate_text_size("W")[1]) / 2, style.text_color, 1);
        
        //new_color = make_color_rgb(rgb[0], rgb[1], rgb[2]);
        new_color = gmui_make_color_rgba(rgb[0], rgb[1], rgb[2], floor(_alpha));
    }
    
    st.hue = hue;
    st.saturation = saturation;
    st.brightness = brightness;
    st.alpha = _alpha;
    container.state[? state_key] = st;
    
    gmui_end_widget(widget);
    return new_color;
};

function gmui_color_picker_rgb(color, open_id) {
    var gmui = global.gmui;
    var style = gmui.style;
    var container = gmui.current_container;
    
    var hsv = gmui_rgb_to_hsv(color_get_red(color), color_get_green(color), color_get_blue(color));
    var alpha = 255;
    
    var state_key = "_cp_" + open_id;
    if (container.state[? state_key] == undefined) {
        container.state[? state_key] = {
            hue: hsv[0],
            saturation: hsv[1],
            brightness: hsv[2],
            alpha: alpha,
        };
    }
    
    var st = container.state[? state_key];
    var hue = st.hue;
    var saturation = st.saturation;
    var brightness = st.brightness;
    var _alpha = st.alpha;
    
    var picker_w = style.color_picker_width;
    var picker_h = style.color_picker_height;
    var hue_h = style.color_picker_hue_height;
    var alpha_h = style.color_picker_alpha_height;
    var padding = style.color_picker_padding;
    var gap = style.color_picker_gap;
    var preview_size = style.color_picker_preview_size;
    
    var total_w = picker_w + padding * 2;
    var total_h = padding + picker_h + gap + hue_h + gap + preview_size + padding;
    
    var widget = gmui_begin_widget("color_picker");
    widget.width = total_w;
    widget.height = total_h;
    
    var new_color = color;
    
    if (gmui_widget_is_callable(widget)) {
        var sx = widget.x + padding;
        var sy = widget.y + padding;
        var hue_y = sy + picker_h + gap;
        var preview_y = hue_y + hue_h + gap;
        
        var hovered = gmui_widget_is_hovered(widget);
        var offset = gmui_get_container_screen_offset(widget.container);
        var screen_x = offset[0] + widget.x + padding;
        var screen_y = offset[1] + widget.y + padding;
        
        gmui_add_shader_rect(sx, sy, sx + picker_w, sy + picker_h, GMUI_SHADER_SATURATION_BRIGHTNESS, [
            { type: "float", name: "u_hue", value: hue }
        ]);
        gmui_add_rectangle(sx, sy, sx + picker_w, sy + picker_h, true, style.color_picker_border_color, 1);
        
        var sb_cx = sx + saturation * picker_w;
        var sb_cy = sy + (1 - brightness) * picker_h;
        gmui_add_rectangle(sb_cx - 4, sb_cy - 4, sb_cx + 4, sb_cy + 4, true, c_white, 1);
        gmui_add_rectangle(sb_cx - 3, sb_cy - 3, sb_cx + 3, sb_cy + 3, true, c_black, 1);
        
        var sb_hover = hovered && gmui.input.m_x >= screen_x && gmui.input.m_x <= screen_x + picker_w &&
                                 gmui.input.m_y >= screen_y && gmui.input.m_y <= screen_y + picker_h;
        
        if (sb_hover && gmui_input_mouse_pressed()) {
            container.state[? "_cp_dragging"] = "sb";
        }
        
        if (container.state[? "_cp_dragging"] == "sb" && gmui.input.m_held) {
            saturation = clamp((gmui.input.m_x - screen_x) / picker_w, 0, 1);
            brightness = clamp(1 - (gmui.input.m_y - screen_y) / picker_h, 0, 1);
        }
        
        gmui_add_shader_rect(sx, hue_y, sx + picker_w, hue_y + hue_h, GMUI_SHADER_HUE, []);
        gmui_add_rectangle(sx, hue_y, sx + picker_w, hue_y + hue_h, true, style.color_picker_border_color, 1);
        
        var hue_cx = sx + hue * picker_w;
        gmui_add_rectangle(hue_cx - 2, hue_y - 2, hue_cx + 2, hue_y + hue_h + 2, true, c_white, 1);
        
        var hue_hover = hovered && gmui.input.m_x >= screen_x && gmui.input.m_x <= screen_x + picker_w &&
                                  gmui.input.m_y >= screen_y + picker_h + gap && gmui.input.m_y <= screen_y + picker_h + gap + hue_h;
        
        if (hue_hover && gmui_input_mouse_pressed()) {
            container.state[? "_cp_dragging"] = "hue";
        }
        
        if (container.state[? "_cp_dragging"] == "hue" && gmui.input.m_held) {
            hue = clamp((gmui.input.m_x - screen_x) / picker_w, 0, 1);
        }
        
        var rgb = gmui_hsv_to_rgb(hue, saturation, brightness);
        //gmui_add_shader_rect(sx, alpha_y, sx + picker_w, alpha_y + alpha_h, GMUI_SHADER_CHECKERBOARD, [
        //    { type: "vec2", name: "u_size", value: [picker_w, alpha_h] }
        //]);	
        //gmui_add_shader_rect(sx, alpha_y, sx + picker_w, alpha_y + alpha_h, GMUI_SHADER_ALPHA_GRADIENT, [
        //    { type: "vec3", name: "u_color", value: [rgb[0] / 255, rgb[1] / 255, rgb[2] / 255] }
        //]);
        //gmui_add_rectangle(sx, alpha_y, sx + picker_w, alpha_y + alpha_h, true, style.color_picker_border_color, 1);
        
        //var alpha_cx = sx + (_alpha / 255) * picker_w;
        //gmui_add_rectangle(alpha_cx - 2, alpha_y - 2, alpha_cx + 2, alpha_y + alpha_h + 2, true, c_white, 1);
        
        //var alpha_hover = hovered && gmui.input.m_x >= screen_x && gmui.input.m_x <= screen_x + picker_w &&
        //                            gmui.input.m_y >= screen_y + picker_h + gap + hue_h + gap &&
        //                            gmui.input.m_y <= screen_y + picker_h + gap + hue_h + gap + alpha_h;
        
        //if (alpha_hover && gmui_input_mouse_pressed()) {
        //    container.state[? "_cp_dragging"] = "alpha";
        //}
        
        //if (container.state[? "_cp_dragging"] == "alpha" && gmui.input.m_held) {
        //    _alpha = clamp((gmui.input.m_x - screen_x) / picker_w * 255, 0, 255);
        //}
        
        if (gmui_input_mouse_released()) {
            container.state[? "_cp_dragging"] = undefined;
        }
        
        gmui_add_shader_rect(sx, preview_y, sx + preview_size, preview_y + preview_size, GMUI_SHADER_CHECKERBOARD, [
            { type: "vec2", name: "u_size", value: [preview_size, preview_size] }
        ]);
        
        gmui_add_rectangle(sx, preview_y, sx + preview_size, preview_y + preview_size, false, make_color_rgb(rgb[0], rgb[1], rgb[2]), _alpha / 255);
        gmui_add_rectangle(sx, preview_y, sx + preview_size, preview_y + preview_size, true, style.color_picker_border_color, 1);
        
        var hex_text = string_format(rgb[0], 1, 0) + ", " + string_format(rgb[1], 1, 0) + ", " + string_format(rgb[2], 1, 0) + ", " + string_format(_alpha, 1, 0);
        gmui_add_text(hex_text, sx + preview_size + gap, preview_y + (preview_size - gmui_calculate_text_size("W")[1]) / 2, style.text_color, 1);
        
        //new_color = make_color_rgb(rgb[0], rgb[1], rgb[2]);
        new_color = make_color_rgb(rgb[0], rgb[1], rgb[2]);
    }
    
    st.hue = hue;
    st.saturation = saturation;
    st.brightness = brightness;
    st.alpha = _alpha;
    container.state[? state_key] = st;
    
    gmui_end_widget(widget);
    return new_color;
};

// color pick
function gmui_color_pick(color, id = "") {
    var gmui = global.gmui;
    var style = gmui.style;
    var container = gmui.current_container;
	
	// feather ignore once GM1008
	if (id == "") { id = "color_picker_widget_count_" + string(container.context.widget_counter) + "_"; };
    
    var picker_id = "color_pick_" + id + "_" + container.name;
    
    if (container.state[? picker_id + "_open"] == undefined) {
        container.state[? picker_id + "_open"] = false;
    }
    
    var open = container.state[? picker_id + "_open"];
    var new_color = color;
    
	var pc = gmui.containers[? picker_id + "_dd"];
	
    if (gmui_color_button(color)) {
        open = !open;
        container.state[? picker_id + "_open"] = open;
		if (pc != undefined) {
			pc.is_enabled = true;
		};
    }
	
	if (!open) {
		if (pc != undefined) {
			pc.is_enabled = false;
		};
	}
    
    if (open) {
		container.ignore_surface_flag_once = true;
        var offset = gmui_get_container_screen_offset(container);
        var picker_padding = style.color_picker_padding;
        var picker_w = style.color_picker_width + picker_padding * 2;
        var picker_h = style.color_picker_height + style.color_picker_hue_height + style.color_picker_alpha_height + style.color_picker_preview_size + picker_padding * 2 + style.color_picker_gap * 3;
        
        var px = offset[0] + gmui.current_container.context.cursor_x - container.scroll_x;
        var py = offset[1] + gmui.current_container.context.cursor_y - container.scroll_y + style.combo_height;
        
        var sw = surface_get_width(application_surface);
        var sh = surface_get_height(application_surface);
        if (px + picker_w > sw) px = sw - picker_w - 4;
        if (py + picker_h > sh) py = py - picker_h - style.combo_height - 4;
        px = max(0, px);
        py = max(0, py);
        
        var dd_name = picker_id + "_dd";
        
		if (gmui_begin_container_plain(dd_name, px, py, picker_w, picker_h)) {
		    var dd = gmui.current_container;
			dd.layer = gmui_layer.POPUP;
		    //dd.z_index = gmui.highest_z_index + 1;
		    dd.scrolling_enabled = false;
		    dd.use_scissor = true;
    
		    dd.context.cursor_x = 0;
		    dd.context.cursor_y = 0;
		    dd.context.line_height = 0;
		    dd.context.new_line_requested = false;
		    dd.context.indent_level = 0;
    
		    var saved_sh = style.element_spacing_h;
		    var saved_sv = style.element_spacing_v;
		    style.element_spacing_h = 0;
		    style.element_spacing_v = 0;
    
		    gmui_add_rectangle(0, 0, picker_w, picker_h, false, style.container_background_color, 1);
		    gmui_add_rectangle(0, 0, picker_w, picker_h, true, style.color_picker_border_color, 1);
    
		    new_color = gmui_color_picker(color, picker_id);
    
		    style.element_spacing_h = saved_sh;
		    style.element_spacing_v = saved_sv;
    
		    gmui_end_container_plain();
		}
        
        if (gmui_input_mouse_pressed()) {
            var dd_container = gmui_container_get(dd_name, undefined);
            if (dd_container != undefined && !dd_container.is_mouse_hovering) {
                open = false;
                container.state[? picker_id + "_open"] = false;
            }
        }
    }
    
    return new_color;
};

function gmui_color_pick_rgb(color, id = "") {
    var gmui = global.gmui;
    var style = gmui.style;
    var container = gmui.current_container;
	
	// feather ignore once GM1008
	if (id == "") { id = "color_picker_widget_count_" + string(container.context.widget_counter) + "_"; };
    
    var picker_id = "color_pick_" + id + "_" + container.name;
    
    if (container.state[? picker_id + "_open"] == undefined) {
        container.state[? picker_id + "_open"] = false;
    }
    
    var open = container.state[? picker_id + "_open"];
    var new_color = color;
    
	var pc = gmui.containers[? picker_id + "_dd"];
	
    if (gmui_color_button(color, undefined, false)) {
        open = !open;
        container.state[? picker_id + "_open"] = open;
		if (pc != undefined) {
			pc.is_enabled = true;
		};
		is_focused = true;
    }
	
	if (!open) {
		if (pc != undefined) {
			pc.is_enabled = false;
		};
	}
    
    if (open) {
		container.ignore_surface_flag_once = true;
        var offset = gmui_get_container_screen_offset(container);
        var picker_padding = style.color_picker_padding;
        var picker_w = style.color_picker_width + picker_padding * 2;
        var picker_h = style.color_picker_height + style.color_picker_hue_height + style.color_picker_preview_size + picker_padding + style.color_picker_gap * 3;
        
        var px = offset[0] + gmui.current_container.context.cursor_x - container.scroll_x;
        var py = offset[1] + gmui.current_container.context.cursor_y - container.scroll_y + style.combo_height;
        
        var sw = surface_get_width(application_surface);
        var sh = surface_get_height(application_surface);
        if (px + picker_w > sw) px = sw - picker_w - 4;
        if (py + picker_h > sh) py = py - picker_h - style.combo_height - 4;
        px = max(0, px);
        py = max(0, py);
        
        var dd_name = picker_id + "_dd";
        
		if (gmui_begin_container_plain(dd_name, px, py, picker_w, picker_h)) {
		    var dd = gmui.current_container;
			dd.layer = gmui_layer.POPUP;
		    //dd.z_index = gmui.highest_z_index + 1;
		    dd.scrolling_enabled = false;
		    dd.use_scissor = true;
    
		    dd.context.cursor_x = 0;
		    dd.context.cursor_y = 0;
		    dd.context.line_height = 0;
		    dd.context.new_line_requested = false;
		    dd.context.indent_level = 0;
    
		    var saved_sh = style.element_spacing_h;
		    var saved_sv = style.element_spacing_v;
		    style.element_spacing_h = 0;
		    style.element_spacing_v = 0;
    
		    gmui_add_rectangle(0, 0, picker_w, picker_h, false, style.container_background_color, 1);
		    gmui_add_rectangle(0, 0, picker_w, picker_h, true, style.color_picker_border_color, 1);
    
		    new_color = gmui_color_picker_rgb(color, picker_id);
    
		    style.element_spacing_h = saved_sh;
		    style.element_spacing_v = saved_sv;
    
		    gmui_end_container_plain();
		}
        
        if (gmui_input_mouse_pressed()) {
            var dd_container = gmui_container_get(dd_name, undefined);
            if (dd_container != undefined && !dd_container.is_mouse_hovering) {
                open = false;
                container.state[? picker_id + "_open"] = false;
            }
        }
    }
    
    return new_color;
};

function gmui_color_picker_4(color) {
	return gmui_color_pick(color);
};

function gmui_color_picker_3(color) {
	return gmui_color_pick_rgb(color);
};

function gmui_color_edit_3(color, label = "", font_label = undefined, font_input = undefined) {
    var new_color = color;
    
    if (label != "") {
        gmui_text(label, font_label);
        gmui_sameline();
    }
	
	new_color = gmui_color_picker_3(new_color);
    gmui_sameline();
    
    var rgb = gmui_color_rgb_to_array(new_color);
    gmui_sameline();
    rgb[0] = gmui_input_int(rgb[0], 1, 0, 255, 40, c_red, font_input);
    gmui_sameline();
    rgb[1] = gmui_input_int(rgb[1], 1, 0, 255, 40, c_green, font_input);
    gmui_sameline();
    rgb[2] = gmui_input_int(rgb[2], 1, 0, 255, 40, c_blue, font_input);
    
    return make_color_rgb(rgb[0], rgb[1], rgb[2]);
};

function gmui_color_edit_4(color, label = "", font_label = undefined, font_input = undefined) {
    var new_color = color;
    
    if (label != "") {
        gmui_text(label, font_label);
        gmui_sameline();
    }
	
	new_color = gmui_color_picker_4(new_color);
    gmui_sameline();
    
    var rgba = gmui_color_rgba_to_array(new_color);
    gmui_sameline();
    rgba[0] = gmui_input_int(rgba[0], 1, 0, 255, 40, c_red, font_input);
    gmui_sameline();
    rgba[1] = gmui_input_int(rgba[1], 1, 0, 255, 40, c_green, font_input);
    gmui_sameline();
    rgba[2] = gmui_input_int(rgba[2], 1, 0, 255, 40, c_blue, font_input);
    gmui_sameline();
    rgba[3] = gmui_input_int(rgba[3], 1, 0, 255, 40, c_white, font_input);
    
    return gmui_color_rgba_from_array(rgba);
};

// date picker [year, month, day]
function gmui_date_picker(date_array, font = undefined) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("date_picker");
    var container = widget.container;
    
    var cell_size = style.date_picker_cell_size;
    var header_h = style.date_picker_header_height;
    var cols = 7;
    var rows = 7; // header + 6 rows max
    var total_w = cols * cell_size;
    var total_h = header_h + rows * cell_size;
    
    widget.width = total_w;
    widget.height = total_h;
    
    var _font = gmui_resolve_font(widget, font);
    
    var year = date_array[0];
    var month = date_array[1];
    var day = date_array[2];
    
	var state_key = "_dp_" + widget.id;
	if (container.state[? state_key] == undefined) {
	    container.state[? state_key] = { view_year: year, view_month: month, view_mode: 0, has_selection: false };
	}
	var st = container.state[? state_key];
	var view_year = st.view_year;
	var view_month = st.view_month;
	var view_mode = st.view_mode;
	var has_selection = st.has_selection;

	var new_date = date_array;

	if (gmui_widget_is_callable(widget)) {
	    var offset = gmui_get_container_screen_offset(container);
	    var screen_x = offset[0] + widget.x - container.scroll_x;
	    var screen_y = offset[1] + widget.y - container.scroll_y;
    
	    var today = date_current_datetime();
	    var today_year = date_get_year(today);
	    var today_month = date_get_month(today);
	    var today_day = date_get_day(today);
    
	    var month_names = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
	    var month_short = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
	    var day_names = ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"];
    
	    gmui_add_rectangle(widget.x, widget.y, widget.x + total_w, widget.y + header_h, false, style.date_picker_header_color, 1);
    
	    var title_text;
	    if (view_mode == 0) {
	        title_text = month_names[view_month - 1] + " " + string(view_year);
	    } else if (view_mode == 1) {
	        title_text = string(view_year);
	    } else {
	        var decade_start = view_year - (view_year % 10);
	        title_text = string(decade_start) + " - " + string(decade_start + 9);
	    }
    
	    var title_size = gmui_calculate_text_size(title_text, _font);
	    var title_x = widget.x + (total_w - title_size[0]) / 2;
	    var title_y = widget.y + (header_h - title_size[1]) / 2;
    
	    var title_hover = gmui.input.m_x >= screen_x + title_x - widget.x && gmui.input.m_x <= screen_x + title_x - widget.x + title_size[0] &&
	                      gmui.input.m_y >= screen_y + title_y - widget.y && gmui.input.m_y <= screen_y + title_y - widget.y + title_size[1];
    
	    gmui_add_text(title_text, title_x, title_y, title_hover ? style.date_picker_arrow_hover_color : style.date_picker_header_text_color, 1, _font);
    
	    if (title_hover && gmui_input_mouse_released()) {
	        view_mode = (view_mode + 1) % 3;
	        if (view_mode == 2) {
	            view_year = view_year - (view_year % 10);
	        }
	    }
    
	    var arrow_size = 8;
	    var arrow_y = widget.y + header_h / 2;
	    var left_ax = widget.x + 12;
	    var left_aw = arrow_size + 6;
    
	    var left_hover = gmui.input.m_x >= screen_x + left_ax - widget.x && gmui.input.m_x <= screen_x + left_ax - widget.x + left_aw &&
	                     gmui.input.m_y >= screen_y + arrow_y - arrow_size - widget.y && gmui.input.m_y <= screen_y + arrow_y + arrow_size - widget.y;
    
	    var arrow_color = left_hover ? style.date_picker_arrow_hover_color : style.date_picker_arrow_color;
	    gmui_add_triangle(left_ax + arrow_size, arrow_y - arrow_size/2, left_ax, arrow_y, left_ax + arrow_size, arrow_y + arrow_size/2, arrow_color);
    
	    if (left_hover && gmui_input_mouse_released()) {
	        if (view_mode == 0) {
	            view_month--;
	            if (view_month < 1) { view_month = 12; view_year--; }
	        } else if (view_mode == 1) {
	            view_year--;
	        } else {
	            view_year -= 10;
	        }
	    }
    
	    var right_ax = widget.x + total_w - 12 - arrow_size;
	    var right_aw = arrow_size + 6;
    
	    var right_hover = gmui.input.m_x >= screen_x + right_ax - widget.x && gmui.input.m_x <= screen_x + right_ax - widget.x + right_aw &&
	                      gmui.input.m_y >= screen_y + arrow_y - arrow_size - widget.y && gmui.input.m_y <= screen_y + arrow_y + arrow_size - widget.y;
    
	    arrow_color = right_hover ? style.date_picker_arrow_hover_color : style.date_picker_arrow_color;
	    gmui_add_triangle(right_ax, arrow_y - arrow_size/2, right_ax + arrow_size, arrow_y, right_ax, arrow_y + arrow_size/2, arrow_color);
    
	    if (right_hover && gmui_input_mouse_released()) {
	        if (view_mode == 0) {
	            view_month++;
	            if (view_month > 12) { view_month = 1; view_year++; }
	        } else if (view_mode == 1) {
	            view_year++;
	        } else {
	            view_year += 10;
	        }
	    }
    
	    if (view_mode == 0) {
	        for (var d = 0; d < 7; d++) {
	            var dx = widget.x + d * cell_size;
	            var dy = widget.y + header_h;
	            var dtxt_size = gmui_calculate_text_size(day_names[d], _font);
	            gmui_add_text(day_names[d], dx + (cell_size - dtxt_size[0]) / 2, dy + (cell_size - dtxt_size[1]) / 2, style.date_picker_weekday_color, 1, _font);
	        }
        
	        var first_day = date_get_weekday(date_create_datetime(view_year, view_month, 1, 0, 0, 0)) - 1;
	        if (first_day < 0) first_day = 6;
        
	        var days_in_month = date_days_in_month(date_create_datetime(view_year, view_month, 1, 0, 0, 0));
	        var prev_month_days = date_days_in_month(date_create_datetime(view_month == 1 ? view_year - 1 : view_year, view_month == 1 ? 12 : view_month - 1, 1, 0, 0, 0));
        
	        for (var r = 0; r < 6; r++) {
	            for (var c = 0; c < 7; c++) {
	                var cell_index = r * 7 + c;
	                var cell_day = cell_index - first_day + 1;
	                var is_current_month = cell_day >= 1 && cell_day <= days_in_month;
                
	                var display_day = cell_day;
	                if (cell_day < 1) display_day = prev_month_days + cell_day;
	                if (cell_day > days_in_month) display_day = cell_day - days_in_month;
                
	                var cx = widget.x + c * cell_size;
	                var cy = widget.y + header_h + cell_size + r * cell_size;
                
	                var cell_hover = gmui.input.m_x >= screen_x + cx - widget.x && gmui.input.m_x <= screen_x + cx - widget.x + cell_size &&
	                                 gmui.input.m_y >= screen_y + cy - widget.y && gmui.input.m_y <= screen_y + cy - widget.y + cell_size;
                
	                var is_today = is_current_month && view_year == today_year && view_month == today_month && cell_day == today_day;
	                var is_selected = has_selection && view_year == year && view_month == month && cell_day == day && is_current_month;
                
	                var bg_color = style.date_picker_cell_color;
	                var text_color = style.date_picker_cell_text_color;
                
	                if (!is_current_month) text_color = style.date_picker_cell_other_month;
	                if (is_selected) {
	                    bg_color = style.date_picker_cell_selected_color;
	                    text_color = style.date_picker_cell_selected_text;
	                } else if (is_today && is_current_month) {
	                    bg_color = style.date_picker_cell_today_color;
	                } else if (cell_hover && is_current_month) {
	                    bg_color = style.date_picker_cell_hover_color;
	                }
                
	                gmui_add_rectangle(cx, cy, cx + cell_size, cy + cell_size, false, bg_color, 1);
                
	                var cell_text = string(display_day);
	                var cell_text_size = gmui_calculate_text_size(cell_text, _font);
	                gmui_add_text(cell_text, cx + (cell_size - cell_text_size[0]) / 2, cy + (cell_size - cell_text_size[1]) / 2, text_color, 1, _font);
                
	                if (cell_hover && is_current_month && gmui_input_mouse_released()) {
	                    new_date = [view_year, view_month, cell_day];
						has_selection = true;
	                    view_mode = 0;
	                }
	            }
	        }
        
	    } else if (view_mode == 1) {
	        for (var m = 0; m < 12; m++) {
	            var col = m % 4;
	            var row = m div 4;
	            var cell_w = total_w / 4;
	            var cell_h = (total_h - header_h) / 3;
            
	            var mx = widget.x + col * cell_w;
	            var my = widget.y + header_h + row * cell_h;
            
	            var m_hover = gmui.input.m_x >= screen_x + mx - widget.x && gmui.input.m_x <= screen_x + mx - widget.x + cell_w &&
	                          gmui.input.m_y >= screen_y + my - widget.y && gmui.input.m_y <= screen_y + my - widget.y + cell_h;
            
	            var is_current = has_selection && (view_year == year && (m + 1) == month);
	            var is_today_month = (view_year == today_year && (m + 1) == today_month);
            
	            var bg_color = style.date_picker_cell_color;
	            if (is_current) bg_color = style.date_picker_cell_selected_color;
	            else if (m_hover) bg_color = style.date_picker_cell_hover_color;
	            else if (is_today_month) bg_color = style.date_picker_cell_today_color;
            
	            gmui_add_rectangle(mx, my, mx + cell_w, my + cell_h, false, bg_color, 1);
            
	            var m_text = month_short[m];
	            var m_text_size = gmui_calculate_text_size(m_text, _font);
	            gmui_add_text(m_text, mx + (cell_w - m_text_size[0]) / 2, my + (cell_h - m_text_size[1]) / 2, style.date_picker_cell_text_color, 1, _font);
            
	            if (m_hover && gmui_input_mouse_released()) {
	                view_month = m + 1;
	                view_mode = 0;
	            }
	        }
        
	    } else {
		    var decade_start = view_year - (view_year % 10);
    
		    for (var _y = decade_start; _y <= decade_start + 11; _y++) {
		        var index = _y - decade_start;
		        var col = index % 4;
		        var row = index div 4;
		        var cell_w = total_w / 4;
		        var cell_h = (total_h - header_h) / 3;
        
		        var yx = widget.x + col * cell_w;
		        var yy = widget.y + header_h + row * cell_h;
        
		        var y_hover = gmui.input.m_x >= screen_x + yx - widget.x && gmui.input.m_x <= screen_x + yx - widget.x + cell_w &&
		                      gmui.input.m_y >= screen_y + yy - widget.y && gmui.input.m_y <= screen_y + yy - widget.y + cell_h;
        
		        var is_current = has_selection && (_y == year);
		        var is_today_year = (_y == today_year);
        
		        var bg_color = style.date_picker_cell_color;
		        if (is_current) bg_color = style.date_picker_cell_selected_color;
		        else if (y_hover) bg_color = style.date_picker_cell_hover_color;
		        else if (is_today_year) bg_color = style.date_picker_cell_today_color;
        
		        gmui_add_rectangle(yx, yy, yx + cell_w, yy + cell_h, false, bg_color, 1);
        
		        var y_text = string(_y);
		        var y_text_size = gmui_calculate_text_size(y_text, _font);
		        gmui_add_text(y_text, yx + (cell_w - y_text_size[0]) / 2, yy + (cell_h - y_text_size[1]) / 2, style.date_picker_cell_text_color, 1, _font);
        
		        if (y_hover && gmui_input_mouse_released()) {
		            view_year = _y;
		            view_mode = 1;
		        }
		    }
	    }
	}

	container.state[? state_key] = { 
	    view_year: view_year, 
	    view_month: view_month, 
	    view_mode: view_mode,
	    has_selection: has_selection
	};
    gmui_end_widget(widget);
    return new_date;
};

function gmui_date_picker_simple(date_array, font = undefined) {
    return gmui_date_picker(date_array, font);
};

function gmui_date_picker_today() {
    var today = date_current_datetime();
    return [date_get_year(today), date_get_month(today), date_get_day(today)];
};

// list box
function gmui_list_box(selected, items, item_count, multi_select = false, width = -1, font = undefined) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("list_box");
    var container = widget.container;
    
    var list_width = width > 0 ? width : container.width - style.container_padding_h * 2 - container.context.indent_level;
    var row_height = style.kv_row_height;
    
    widget.width = list_width;
    widget.height = item_count * row_height;
    
    var _font = gmui_resolve_font(widget, font);
    var ctrl_held = gmui_input_ctrl();
    var shift_held = gmui_input_shift();
    
    var state_key = "_lb_pressed_" + widget.id;
    var last_key = "_lb_last_" + widget.id;
    
    if (container.state[? last_key] == undefined) {
        container.state[? last_key] = multi_select ? (ds_map_size(selected) > 0 ? item_count : 0) : selected;
    }
    var last_click = container.state[? last_key];
    
    if (gmui_widget_is_callable(widget)) {
        var offset = gmui_get_container_screen_offset(container);
        
        for (var i = 0; i < item_count; i++) {
            var ry = widget.y + i * row_height;
            var item_text = items[i];
            
            if (i % 2 == 0) {
                gmui_add_rectangle(widget.x, ry, widget.x + list_width, ry + row_height, false, style.multiselect_alternate_color, 1);
            }
            
            if (i > 0) {
                gmui_add_line(widget.x, ry, widget.x + list_width, ry, style.kv_separator_color, 1);
            }
            
            var screen_ry = offset[1] + ry - container.scroll_y;
            var screen_rx = offset[0] + widget.x - container.scroll_x;
            var item_hovered = container.is_mouse_hovering && gmui.input.active_widget_id == undefined && gmui.input.hovered_widget_id == undefined &&
                gmui.input.m_y >= screen_ry && gmui.input.m_y <= screen_ry + row_height &&
                gmui.input.m_x >= screen_rx && gmui.input.m_x <= screen_rx + list_width;
            
            var is_selected = multi_select ? ds_map_exists(selected, item_text) : (selected == i);
            
            if (item_hovered && gmui_input_mouse_pressed()) {
                container.state[? state_key] = i;
            }
            
            if (gmui_input_mouse_released() && container.state[? state_key] == i && item_hovered) {
                if (multi_select) {
                    if (shift_held && last_click >= 0 && last_click < item_count) {
                        var start = min(last_click, i);
                        var _end = max(last_click, i);
                        
                        if (!ctrl_held) {
                            ds_map_clear(selected);
                        }
                        
                        for (var j = start; j <= _end; j++) {
                            ds_map_add(selected, items[j], true);
                        }
                    } else if (ctrl_held) {
                        if (is_selected) {
                            ds_map_delete(selected, item_text);
                        } else {
                            ds_map_add(selected, item_text, true);
                        }
                        last_click = i;
                    } else {
                        ds_map_clear(selected);
                        ds_map_add(selected, item_text, true);
                        last_click = i;
                    }
                } else {
                    selected = i;
                }
                container.state[? last_key] = last_click;
                container.state[? state_key] = undefined;
            }
            
            if (gmui_input_mouse_released() && container.state[? state_key] == i && !item_hovered) {
                container.state[? state_key] = undefined;
            }
            
            is_selected = multi_select ? ds_map_exists(selected, item_text) : (selected == i);
            
            if (is_selected) {
                gmui_add_rectangle(widget.x, ry, widget.x + list_width, ry + row_height, false, style.multiselect_item_selected_color, 1);
            } else if (item_hovered) {
                gmui_add_rectangle(widget.x, ry, widget.x + list_width, ry + row_height, false, c_white, 0.5);
            }
            
            var text_color = is_selected ? style.multiselect_text_selected_color : style.multiselect_text_color;
            var text_size = gmui_calculate_text_size(item_text, _font);
            var text_y = ry + (row_height - text_size[1]) / 2;
            
            var max_w = list_width - 16;
            var display_text = item_text;
            if (text_size[0] > max_w) {
                for (var len = string_length(display_text); len > 0; len--) {
                    var test = string_copy(display_text, 1, len) + "...";
                    if (gmui_calculate_text_size(test, _font)[0] <= max_w) {
                        display_text = test;
                        break;
                    }
                }
            }
            
            gmui_add_text(display_text, widget.x + 8, text_y, text_color, 1, _font);
        }
    }
    
    gmui_end_widget(widget, true);
    return selected;
};

// tabs
function gmui_tabs(name, selected_index, width = -1, height = -1, group = "", handlers = undefined, flags = 0, font = undefined) {
    var gmui = global.gmui;
    var style = gmui.style;
    var container = gmui.current_container;
    var cache_key = "_tabs_data_" + name;
	
	var _handlers = handlers ?? {
		on_empty_detach: undefined, // given tab_data, detached_label | undefined will be ignored
		on_bar_attach: undefined, // given tab_data, other_data | undefined will revert the changes, -1 will delete te label
		on_tab_close: undefined, // given tab_data, closed_label | undefined will be ignored
		on_tab_select: undefined, // given tab_data, selected_label | undefined will be ignored
	};
	if (!variable_struct_exists(_handlers, "on_empty_detach")) { _handlers.on_empty_detach = undefined; };
	if (!variable_struct_exists(_handlers, "on_bar_attach")) { _handlers.on_bar_attach = undefined; };
	if (!variable_struct_exists(_handlers, "on_tab_close")) { _handlers.on_tab_close = undefined; };
	if (!variable_struct_exists(_handlers, "on_tab_select")) { _handlers.on_tab_select = undefined; };
    
    if (!ds_map_exists(gmui.cache, "_tab_group_registry")) {
        gmui.cache[? "_tab_group_registry"] = ds_map_create();
    }
    var tab_registry = gmui.cache[? "_tab_group_registry"];
    
    if (!ds_map_exists(gmui.cache, cache_key)) {
        gmui.cache[? cache_key] = {
            labels: [],
            selected: 0,
            dragging: -1,
            drag_mouse_offset: 0,
            tab_pressed: -1,
            close_pressed: -1,
            drag_pending: -1,
            drag_start_screen_x: 0,
            drag_start_tab_x: 0,
        };
    }
    
    var tab_data = gmui.cache[? cache_key];
    var tabs = tab_data.labels;
    var _width = width > 0 ? width : container.width - style.container_padding_h * 2 - container.context.indent_level;
    var _height = height > 0 ? height : style.tab_bar_height;
    var close_size = 14;
    var drag_threshold = 4;
    var enable_move = (flags & gmui_tab_flags.NO_MOVE) == 0;
    var enable_close = (flags & gmui_tab_flags.NO_CLOSE) == 0;
	var leave_one = (flags & gmui_tab_flags.LEAVE_ONE) != 0;
    var actual_close_size = enable_close ? close_size : 0;
    
    var detachable = (group != "");
    
    var sel = clamp(tab_data.selected, 0, max(0, array_length(tabs) - 1));
    if (selected_index >= 0 && selected_index < array_length(tabs)) sel = selected_index;
    tab_data.selected = sel;
	
	if (leave_one && array_length(tab_data.labels) < 2) { enable_close = false; detachable = false; enable_move = false; };

	gmui_style_push_multi({
		container_padding_h: 0,
		container_padding_v: 0,
		element_spacing_v: 0,
		element_spacing_h: 0,
		scrollbar_width: 3,
		scrollbar_padding: 0,
	});
	var tabs_container = gmui_container_get(container.name + "_tabs_" + name, container);
	if (!tabs_container.initialized) {
	    tabs_container.scrolling_enabled = true;
	    tabs_container.use_surface = false;
	    tabs_container.use_scissor = true;
	    tabs_container.background_enabled = false;
	}
    if (gmui_begin_container(container.name + "_tabs_" + name, undefined, undefined, _width, _height)) {
        tabs_container.context.cursor_x = 0;
        tabs_container.context.cursor_y = 0;
		
        var _font = gmui_resolve_font({ type: "tabs" }, font);
		
		var pre_tab_count = array_length(tabs);
		var pre_total_width = 0;
		for (var i = 0; i < pre_tab_count; i++) {
		    var text_size = gmui_calculate_text_size(tabs[i], _font);
		    var tw = max(style.tab_item_min_width, text_size[0] + style.tab_item_padding_h * 2 + actual_close_size + 8);
		    pre_total_width += tw + style.tab_item_spacing;
		}
		if (pre_tab_count > 0) pre_total_width -= style.tab_item_spacing;

        
        var widget = gmui_begin_widget("tabs");
        widget.width = max(_width, pre_total_width);
        widget.height = _height;
        var tab_count = array_length(tabs);
        var drag_idx = tab_data.dragging;

        if (group != "") {
            tab_data._tab_group = group;
            var _scr_offset = gmui_get_container_screen_offset(tabs_container);
            var screen_rect = [
                _scr_offset[0] + widget.x - tabs_container.scroll_x,
                _scr_offset[1] + widget.y - tabs_container.scroll_y,
                _scr_offset[0] + widget.x + _width - tabs_container.scroll_x,
                _scr_offset[1] + widget.y + _height - tabs_container.scroll_y,
            ];
            tab_data._screen_rect = screen_rect;
            if (!ds_map_exists(tab_registry, group)) {
                tab_registry[? group] = ds_map_create();
            }
            var group_bars = tab_registry[? group];
            group_bars[? name] = screen_rect;
        }

        var pending_idx = tab_data.drag_pending;
        if (enable_move && pending_idx >= 0 && pending_idx < tab_count) {
            if (gmui.input.m_held && abs(gmui.input.m_x - tab_data.drag_start_screen_x) >= drag_threshold) {
                tab_data.dragging = pending_idx;
                tab_data.drag_mouse_offset = tab_data.drag_start_screen_x - tab_data.drag_start_tab_x;
                drag_idx = pending_idx;
                tab_data.drag_pending = -1;
                tab_data.tab_pressed = -1;
                tab_data.close_pressed = -1;
            }
        }

        if (drag_idx == -1 && gmui_input_mouse_pressed()) {
            var offset = gmui_get_container_screen_offset(tabs_container);
            var press_widths = array_create(tab_count);
            var press_positions = array_create(tab_count);
            var press_total = 0;
            for (var i = 0; i < tab_count; i++) {
                var text_size = gmui_calculate_text_size(tabs[i], _font);
                var tw = max(style.tab_item_min_width, text_size[0] + style.tab_item_padding_h * 2 + actual_close_size + 8);
                press_widths[i] = tw;
                press_positions[i] = press_total;
                press_total += tw + style.tab_item_spacing;
            }
            for (var i = 0; i < tab_count; i++) {
                var base_x = press_positions[i];
                var tab_width = press_widths[i];
                var screen_left = offset[0] + base_x - tabs_container.scroll_x;
                var screen_right = screen_left + tab_width;
                var screen_top = offset[1];
                var screen_bottom = screen_top + _height;
                var in_tab = gmui.input.m_x >= screen_left && gmui.input.m_x <= screen_right &&
                             gmui.input.m_y >= screen_top && gmui.input.m_y <= screen_bottom &&
							 gmui.input.hovered_container == tabs_container && gmui.input.active_widget_id == undefined;
                if (in_tab) {
                    var close_zone_left = screen_right - actual_close_size - 8;
                    var in_close_zone = enable_close && gmui.input.m_x >= close_zone_left;
                    if (in_close_zone) {
                        tab_data.close_pressed = i;
                        tab_data.tab_pressed = -1;
                        tab_data.drag_pending = -1;
                    } else {
                        tab_data.tab_pressed = i;
                        tab_data.close_pressed = -1;
                        if (enable_move) {
                            tab_data.drag_pending = i;
                            tab_data.drag_start_screen_x = gmui.input.m_x;
                            tab_data.drag_start_tab_x = screen_left;
                        } else {
                            tab_data.drag_pending = -1;
                        }
                    }
                    break;
                }
            }
        }

        if (drag_idx == -1 && gmui_input_mouse_released()) {
            var close_idx = tab_data.close_pressed;
            var press_idx = tab_data.tab_pressed;
            var was_pending = (tab_data.drag_pending >= 0);
            
            if (enable_close && close_idx >= 0 && close_idx < tab_count) {
                var offset = gmui_get_container_screen_offset(tabs_container);
                var rel_widths = array_create(tab_count);
                var rel_positions = array_create(tab_count);
                var rel_total = 0;
                for (var i = 0; i < tab_count; i++) {
                    var text_size = gmui_calculate_text_size(tabs[i], _font);
                    var tw = max(style.tab_item_min_width, text_size[0] + style.tab_item_padding_h * 2 + actual_close_size + 8);
                    rel_widths[i] = tw;
                    rel_positions[i] = rel_total;
                    rel_total += tw + style.tab_item_spacing;
                }
                var base_x = rel_positions[close_idx];
                var tab_width = rel_widths[close_idx];
                var screen_left = offset[0] + base_x - tabs_container.scroll_x;
                var screen_right = screen_left + tab_width;
                var close_zone_left = screen_right - actual_close_size - 8;
                var still_in_close = gmui.input.m_x >= close_zone_left &&
                                     gmui.input.m_x <= screen_right &&
                                     gmui.input.m_y >= offset[1] &&
                                     gmui.input.m_y <= offset[1] + _height;
                if (still_in_close) {
					var closed_label = tabs[close_idx];
                    array_delete(tabs, close_idx, 1);
                    tab_data.labels = tabs;
                    if (sel >= array_length(tabs)) sel = max(0, array_length(tabs) - 1);
                    tab_data.selected = sel;
					if (_handlers.on_tab_close != undefined && is_method(_handlers.on_tab_close)) { _handlers.on_tab_close(tab_data, closed_label); };
                }
            }
            else if (press_idx >= 0 && press_idx < tab_count && was_pending) {
                var offset = gmui_get_container_screen_offset(tabs_container);
                var rel_widths = array_create(tab_count);
                var rel_positions = array_create(tab_count);
                var rel_total = 0;
                for (var i = 0; i < tab_count; i++) {
                    var text_size = gmui_calculate_text_size(tabs[i], _font);
                    var tw = max(style.tab_item_min_width, text_size[0] + style.tab_item_padding_h * 2 + actual_close_size + 8);
                    rel_widths[i] = tw;
                    rel_positions[i] = rel_total;
                    rel_total += tw + style.tab_item_spacing;
                }
                var base_x = rel_positions[press_idx];
                var tab_width = rel_widths[press_idx];
                var screen_left = offset[0] + base_x - tabs_container.scroll_x;
                var screen_right = screen_left + tab_width;
                var close_zone_left = screen_right - actual_close_size - 8;
                var still_in_body = gmui.input.m_x >= screen_left &&
                                    gmui.input.m_x < close_zone_left &&
                                    gmui.input.m_y >= offset[1] &&
                                    gmui.input.m_y <= offset[1] + _height;
                if (still_in_body) {
                    sel = press_idx;
                    tab_data.selected = sel;
					if (_handlers.on_tab_select != undefined && is_method(_handlers.on_tab_select)) { _handlers.on_tab_select(tab_data, tab_data.labels[sel]); };
                }
            }
        }

        if (gmui.input.m_released) {
            tab_data.tab_pressed = -1;
            tab_data.close_pressed = -1;
            tab_data.drag_pending = -1;
        }

        tab_count = array_length(tabs);
        
        var tab_widths = array_create(tab_count);
        var tab_positions = array_create(tab_count);
        var total_width = 0;
        var is_tab_detached = drag_idx >= 0 &&
            ds_map_exists(gmui.cache, "_detached_tab_visual") &&
            !is_undefined(gmui.cache[? "_detached_tab_visual"]) &&
            gmui.cache[? "_detached_tab_visual"].active &&
            gmui.cache[? "_detached_tab_visual"].cache_key == cache_key;

        for (var i = 0; i < tab_count; i++) {
            var text_size = gmui_calculate_text_size(tabs[i], _font);
            var tw = max(style.tab_item_min_width, text_size[0] + style.tab_item_padding_h * 2 + actual_close_size + 8);
            tab_widths[i] = tw;
            if (is_tab_detached && i == drag_idx) {
                tab_positions[i] = total_width;
                continue;
            }
            tab_positions[i] = total_width;
            total_width += tw + style.tab_item_spacing;
        }
        if (tab_count > 0 && !is_tab_detached) total_width -= style.tab_item_spacing;
        else if (tab_count > 1 && is_tab_detached) total_width -= style.tab_item_spacing;

        if (drag_idx >= tab_count) {
            drag_idx = -1;
            tab_data.dragging = -1;
        }

        var drag_draw_x = 0;
        var drag_target = drag_idx;

        if (enable_move && drag_idx >= 0 && drag_idx < tab_count && gmui.input.m_held) {
            var detach_gap_vertical = 20;
            var detach_gap_horizontal = 30;
            var offset = gmui_get_container_screen_offset(tabs_container);
            var outside_vertical = (gmui.input.m_y < offset[1] - detach_gap_vertical || gmui.input.m_y > offset[1] + _height + detach_gap_vertical);
            var outside_horizontal = (gmui.input.m_x < offset[0] - detach_gap_horizontal || gmui.input.m_x > offset[0] + _width + detach_gap_horizontal);
            var outside = outside_vertical || outside_horizontal;

            var live_attached = false;
            if (group != "" && ds_map_exists(tab_registry, group)) {
                var group_bars = tab_registry[? group];
                var bar_names = ds_map_keys_to_array(group_bars);
                for (var k = 0; k < array_length(bar_names); k++) {
                    var bar_name = bar_names[k];
                    if (bar_name == name) continue;
                    var target_cache_key = "_tabs_data_" + bar_name;
                    if (!ds_map_exists(gmui.cache, target_cache_key)) continue;
                    var other_data = gmui.cache[? target_cache_key];
                    if (!variable_struct_exists(other_data, "_tab_group")) continue;
                    if (other_data._tab_group != group) continue;
                    var r = group_bars[? bar_name];
                    if (point_in_rectangle(gmui.input.m_x, gmui.input.m_y, r[0], r[1], r[2], r[3])) {
                        var moved_label = tabs[drag_idx];
                        array_delete(tabs, drag_idx, 1);
                        tab_data.labels = tabs;
                        var target_tabs = other_data.labels;
                        var target_count = array_length(target_tabs);
                        var insert_index = target_count;
                        
                        var target_widths = array_create(target_count);
                        var target_positions = array_create(target_count);
                        var target_total = 0;
                        for (var t = 0; t < target_count; t++) {
                            var t_text_size = gmui_calculate_text_size(target_tabs[t], _font);
                            var t_tw = max(style.tab_item_min_width, t_text_size[0] + style.tab_item_padding_h * 2 + actual_close_size + 8);
                            target_widths[t] = t_tw;
                            target_positions[t] = target_total;
                            target_total += t_tw + style.tab_item_spacing;
                        }
                        var mouse_rel_x = gmui.input.m_x - r[0];
                        for (var t = 0; t < target_count; t++) {
                            var tab_center = target_positions[t] + target_widths[t] / 2;
                            if (mouse_rel_x < tab_center) {
                                insert_index = t;
                                break;
                            }
                        }
                        gmui_tab_insert(bar_name, moved_label, insert_index);
                        
                        var mouse_rel_to_tab_left = tab_data.drag_mouse_offset;
                        
                        tab_data.dragging = -1;
                        tab_data.drag_pending = -1;
                        tab_data.tab_pressed = -1;
                        tab_data.close_pressed = -1;
                        
                        other_data.dragging = insert_index;
                        other_data.drag_mouse_offset = mouse_rel_to_tab_left;
                        other_data.drag_pending = -1;
                        other_data.tab_pressed = -1;
                        other_data.close_pressed = -1;
                        other_data.drag_start_screen_x = gmui.input.m_x;
                        other_data.drag_start_tab_x = gmui.input.m_x - mouse_rel_to_tab_left;
                        other_data.selected = insert_index;
                        if (sel >= array_length(tabs)) sel = max(0, array_length(tabs) - 1);
                        tab_data.selected = sel;
                        live_attached = true;
						if (is_method(_handlers.on_bar_attach)) { _handlers.on_bar_attach(tab_data, other_data); };
                        
                        if (ds_map_exists(gmui.cache, "_detached_tab_visual")) {
                            ds_map_delete(gmui.cache, "_detached_tab_visual");
                        }
                        gmui_end_widget(widget, true);
                        gmui_end_container();
                        gmui_style_pop_multi([ "container_padding_h", "container_padding_v", "element_spacing_h", "element_spacing_v", "scrollbar_width", "scrollbar_padding" ]);
						return sel;
                    }
                }
            }

            if (!live_attached && detachable && outside) {
                if (!ds_map_exists(gmui.cache, "_detached_tab_visual") || is_undefined(gmui.cache[? "_detached_tab_visual"]) || !gmui.cache[? "_detached_tab_visual"].active) {
                    gmui.cache[? "_detached_tab_visual"] = {
                        label: tabs[drag_idx],
                        source: name,
                        group: group,
                        width: tab_widths[drag_idx],
                        height: _height,
                        active: true,
                        drag_idx: drag_idx,
                        cache_key: cache_key,
                    };
                }
            } else if (!live_attached) {
                if (ds_map_exists(gmui.cache, "_detached_tab_visual")) {
                    var vis = gmui.cache[? "_detached_tab_visual"];
                    if (!is_undefined(vis) && vis.active && vis.cache_key == cache_key) {
                        ds_map_delete(gmui.cache, "_detached_tab_visual");
                    }
                }
            }

            if (!ds_map_exists(gmui.cache, "_detached_tab_visual") || is_undefined(gmui.cache[? "_detached_tab_visual"]) || !gmui.cache[? "_detached_tab_visual"].active) {
                var container_screen_offset_x = offset[0] - tabs_container.scroll_x;
                var tab_screen_x = gmui.input.m_x - tab_data.drag_mouse_offset;
                drag_draw_x = tab_screen_x - container_screen_offset_x;
                drag_draw_x = clamp(drag_draw_x, -tab_widths[drag_idx] * 0.3, _width - tab_widths[drag_idx] * 0.7);
                var drag_center = drag_draw_x + tab_widths[drag_idx] / 2;
                for (var j = 0; j < tab_count; j++) {
                    if (j == drag_idx) continue;
                    var j_center = tab_positions[j] + tab_widths[j] / 2;
                    if (drag_center > j_center && drag_idx < j) { drag_target = j; }
                    if (drag_center < j_center && drag_idx > j) { drag_target = j; break; }
                }
            }
        }

        if (enable_move && drag_target != drag_idx && drag_idx >= 0 && drag_idx < tab_count && gmui.input.m_held) {
            var moved_tab = tabs[drag_idx];
            array_delete(tabs, drag_idx, 1);
            array_insert(tabs, drag_target, moved_tab);
            tab_data.labels = tabs;
            if (sel == drag_idx) sel = drag_target;
            else if (drag_idx < drag_target && sel > drag_idx && sel <= drag_target) sel--;
            else if (drag_idx > drag_target && sel >= drag_target && sel < drag_idx) sel++;
            tab_data.selected = sel;
            tab_data.dragging = drag_target;
            drag_idx = drag_target;
            total_width = 0;
            for (var k = 0; k < tab_count; k++) {
                tab_positions[k] = total_width;
                total_width += tab_widths[k] + style.tab_item_spacing;
            }
            if (tab_count > 0) total_width -= style.tab_item_spacing;
            
            var apply_offset = gmui_get_container_screen_offset(tabs_container);
            var container_screen_offset_x = apply_offset[0] - tabs_container.scroll_x;
            var new_tab_screen_x = container_screen_offset_x + tab_positions[drag_target];
            tab_data.drag_mouse_offset = gmui.input.m_x - new_tab_screen_x;
        }

        if (gmui.input.m_released && drag_idx >= 0) {
            if (detachable && ds_map_exists(gmui.cache, "_detached_tab_visual")) {
                var vis = gmui.cache[? "_detached_tab_visual"];
                if (!is_undefined(vis) && vis.active && vis.cache_key == cache_key) {
                    var detached_label = tabs[vis.drag_idx];
                    
                    if (_handlers.on_empty_detach == -1) {
                        array_delete(tabs, vis.drag_idx, 1);
                    } 
                    else if (is_method(_handlers.on_empty_detach)) {
                        _handlers.on_empty_detach(tab_data, detached_label);
                    }
                    
                    tab_data.labels = tabs;
                    if (sel >= array_length(tabs)) sel = max(0, array_length(tabs) - 1);
                    tab_data.selected = sel;
                    
                    ds_map_delete(gmui.cache, "_detached_tab_visual");
                    tab_data.dragging = -1;
                    tab_data.drag_pending = -1;
                    tab_data.tab_pressed = -1;
                    tab_data.close_pressed = -1;
                    gmui_end_widget(widget, true);
                    gmui_end_container();
					gmui_style_pop_multi([ "container_padding_h", "container_padding_v", "element_spacing_h", "element_spacing_v", "scrollbar_width", "scrollbar_padding" ]);
                    return sel;
                }
            }
            tab_data.dragging = -1;
            tab_data.drag_pending = -1;
            tab_data.tab_pressed = -1;
            tab_data.close_pressed = -1;
            drag_idx = -1;
        }

        tab_count = array_length(tabs);
        if (tab_count == 0) {
            gmui_end_widget(widget, true);
            gmui_end_container();
			gmui_style_pop_multi([ "container_padding_h", "container_padding_v", "element_spacing_h", "element_spacing_v", "scrollbar_width", "scrollbar_padding" ]);
            return sel;
        }

        for (var i = 0; i < tab_count; i++) {
            var base_x = tab_positions[i];
            var tab_width = tab_widths[i];
            var tab_height = _height;
            var is_selected = (i == sel);
            var is_dragging = (i == drag_idx && gmui.input.m_held);
            
            var is_detached = is_dragging &&
                ds_map_exists(gmui.cache, "_detached_tab_visual") &&
                !is_undefined(gmui.cache[? "_detached_tab_visual"]) &&
                gmui.cache[? "_detached_tab_visual"].active &&
                gmui.cache[? "_detached_tab_visual"].cache_key == cache_key;
            if (is_detached) continue;

            var draw_x = base_x;
            var draw_y = 0;
            if (is_dragging) {
                draw_x = drag_draw_x;
                draw_y = -2;
            }

            var offset = gmui_get_container_screen_offset(tabs_container);
            var screen_left = offset[0] + draw_x - tabs_container.scroll_x;
            var screen_right = screen_left + tab_width;
            var screen_top = offset[1] + draw_y;
            var screen_bottom = screen_top + tab_height;
            var in_tab = !is_dragging && drag_idx == -1 &&
                         gmui.input.m_x >= screen_left && gmui.input.m_x <= screen_right &&
                         gmui.input.m_y >= screen_top && gmui.input.m_y <= screen_bottom &&
						 gmui.input.hovered_container == tabs_container && gmui.input.active_widget_id == undefined;
            var close_zone_left = screen_right - actual_close_size - 8;
            var in_close_zone = enable_close && in_tab && gmui.input.m_x >= close_zone_left;
            var in_body = in_tab && !in_close_zone;
            var alpha = is_dragging ? 0.9 : 1;
            var bg_color = style.tab_item_color;
            var text_color = style.tab_item_text_color;

            if (is_selected) {
                bg_color = style.tab_item_selected_color;
                text_color = style.tab_item_selected_text_color;
            } else if (in_body || in_close_zone || is_dragging) {
                bg_color = style.tab_item_hovered_color;
            }

            if (is_dragging) {
                gmui_add_rectangle(draw_x + 2, draw_y + 2, draw_x + tab_width + 2, draw_y + tab_height + 2, false, make_color_rgb(0, 0, 0), 0.25);
            }

            gmui_add_rect_expensive(
                draw_x, draw_y, draw_x + tab_width, draw_y + tab_height,
                bg_color,
                gmui_corner_direction.TOP_LEFT | gmui_corner_direction.TOP_RIGHT,
                style.tab_item_rounding, true
            );

            if (i > 0 && !is_dragging && drag_idx != i - 1 && drag_idx != i) {
                gmui_add_line(draw_x, draw_y + 6, draw_x, draw_y + tab_height - 6, style.color_border_dark, 1);
            }

            var text_size = gmui_calculate_text_size(tabs[i], _font);
            var max_text_w = tab_width - style.tab_item_padding_h * 2 - actual_close_size - 4;
            var display_text = tabs[i];
            if (text_size[0] > max_text_w) {
                for (var len = string_length(display_text); len > 0; len--) {
                    var test = string_copy(display_text, 1, len) + "...";
                    if (gmui_calculate_text_size(test, _font)[0] <= max_text_w) {
                        display_text = test;
                        break;
                    }
                }
                text_size = gmui_calculate_text_size(display_text, _font);
            }

            var text_x;
            if (enable_close) {
                text_x = draw_x + (tab_width - close_size - 4 - text_size[0]) / 2;
            } else {
                text_x = draw_x + (tab_width - text_size[0]) / 2;
            }
            var text_y = draw_y + (tab_height - text_size[1]) / 2;
            gmui_add_text(display_text, text_x, text_y, text_color, alpha, _font);

            if (enable_close) {
                var close_draw_x = draw_x + tab_width - close_size - 6;
                var close_draw_y = draw_y + (tab_height - close_size) / 2;
                var close_color = style.tab_item_text_color;
                if (in_close_zone) close_color = make_color_rgb(255, 100, 100);
                var cp = 3;
                gmui_add_line(close_draw_x + cp, close_draw_y + cp, close_draw_x + close_size - cp, close_draw_y + close_size - cp, close_color, 1.5);
                gmui_add_line(close_draw_x + close_size - cp, close_draw_y + cp, close_draw_x + cp, close_draw_y + close_size - cp, close_color, 1.5);
            }
        }
        
        gmui_add_rectangle(0, _height - 1, _width, _height, false, style.color_border_dark, 1);
        //tabs_container.content_width = total_width;
		if (gmui.input.hovered_container == tabs_container && gmui.input.m_wheel != 0) {
		    var max_scroll = max(0, total_width - _width);
		    tabs_container.scroll_x = clamp(
		        tabs_container.scroll_x - gmui.input.m_wheel * tabs_container.scroll_speed,
		        0, max_scroll
		    );
		    gmui.input.m_wheel = 0;
		}
        gmui_end_widget(widget, true);
        gmui_end_container();
		gmui_style_pop_multi([ "container_padding_h", "container_padding_v", "element_spacing_h", "element_spacing_v", "scrollbar_width", "scrollbar_padding" ]);
    }
    return sel;
}

function gmui_tab_get_data(name) {
    var gmui = global.gmui;
    var cache_key = "_tabs_data_" + name;
	return gmui.cache[? cache_key];
};

function gmui_tab_get_label(name, index) {
    var gmui = global.gmui;
    var cache_key = "_tabs_data_" + name;
    if (!ds_map_exists(gmui.cache, cache_key)) return undefined;
    var labels = gmui.cache[? cache_key].labels;
    if (array_length(labels) == 0 || index >= array_length(labels)) return undefined;
    return labels[index];
}

function gmui_tab_set_labels(name, labels) {
    var gmui = global.gmui;
    var cache_key = "_tabs_data_" + name;
    gmui.cache[? cache_key] = {
        labels: [],
        selected: 0,
        dragging: -1,
        drag_mouse_offset: 0,
        tab_pressed: -1,
        close_pressed: -1,
        drag_pending: -1,
        drag_start_screen_x: 0,
        drag_start_tab_x: 0,
    };
    for (var i = 0; i < array_length(labels); i++) {
        array_push(gmui.cache[? cache_key].labels, labels[i]);
    }
}

function gmui_tab_add(name, label) {
    var gmui = global.gmui;
    var cache_key = "_tabs_data_" + name;
    if (!ds_map_exists(gmui.cache, cache_key)) {
        gmui.cache[? cache_key] = {
            labels: [],
            selected: 0,
            dragging: -1,
            drag_mouse_offset: 0,
            tab_pressed: -1,
            close_pressed: -1,
            drag_pending: -1,
            drag_start_screen_x: 0,
            drag_start_tab_x: 0,
        };
    }
	if (array_contains(gmui.cache[? cache_key].labels, label)) { return; };
    array_push(gmui.cache[? cache_key].labels, label);
}

function gmui_tab_delete(name, label) {
    var gmui = global.gmui;
    var cache_key = "_tabs_data_" + name;
    if (!ds_map_exists(gmui.cache, cache_key)) return false;
    var tab_data = gmui.cache[? cache_key];
    var tabs = tab_data.labels;
    var index = -1;
    for (var i = 0; i < array_length(tabs); i++) {
        if (tabs[i] == label) {
            index = i;
            break;
        }
    }
    if (index < 0) return false;
    array_delete(tabs, index, 1);
    tab_data.labels = tabs;
    if (tab_data.selected >= array_length(tabs)) {
        tab_data.selected = max(0, array_length(tabs) - 1);
    }
    if (tab_data.dragging == index) tab_data.dragging = -1;
    if (tab_data.drag_pending == index) tab_data.drag_pending = -1;
    if (tab_data.tab_pressed == index) tab_data.tab_pressed = -1;
    if (tab_data.close_pressed == index) tab_data.close_pressed = -1;
    return true;
}

function gmui_get_last_detached_tab() {
    return global.gmui.cache[? "_last_detached_tab"];
}

function gmui_tab_insert(name, label, index) {
    var gmui = global.gmui;
    var cache_key = "_tabs_data_" + name;
    if (!ds_map_exists(gmui.cache, cache_key)) {
        gmui.cache[? cache_key] = {
            labels: [],
            selected: 0,
            dragging: -1,
            drag_mouse_offset: 0,
            tab_pressed: -1,
            close_pressed: -1,
            drag_pending: -1,
            drag_start_screen_x: 0,
            drag_start_tab_x: 0,
        };
    }
    var tabs = gmui.cache[? cache_key].labels;
    var insert_at = clamp(index, 0, array_length(tabs));
    array_insert(tabs, insert_at, label);
    gmui.cache[? cache_key].labels = tabs;
}

function _gmui_draw_detached_tab() {
    var gmui = global.gmui;
    var style = gmui.style;
    if (!ds_map_exists(gmui.cache, "_detached_tab_visual")) return;
    
    var vis = gmui.cache[? "_detached_tab_visual"];
    
    if (is_undefined(vis) || !vis.active) {
        ds_map_delete(gmui.cache, "_detached_tab_visual");
        return;
    }
    
    if (gmui.input.m_released) {
        ds_map_delete(gmui.cache, "_detached_tab_visual");
        return;
    }
    
    if (variable_struct_exists(vis, "group") && vis.group != "") {
        if (ds_map_exists(gmui.cache, "_tab_group_registry")) {
            var tab_registry = gmui.cache[? "_tab_group_registry"];
            if (ds_map_exists(tab_registry, vis.group)) {
                var group_bars = tab_registry[? vis.group];
                var bar_names = ds_map_keys_to_array(group_bars);
                for (var k = 0; k < array_length(bar_names); k++) {
                    var r = group_bars[? bar_names[k]];
                    if (point_in_rectangle(gmui.input.m_x, gmui.input.m_y, r[0], r[1], r[2], r[3])) {
                        return;
                    }
                }
            }
        }
    }
    
    var _x = gmui.input.m_x - vis.width / 2;
    var _y = gmui.input.m_y - vis.height / 2;
    var alpha = 0.85;
    
    draw_set_alpha(0.2 * alpha);
    draw_set_color(c_black);
    draw_rectangle(_x + 2, _y + 2, _x + vis.width + 2, _y + vis.height + 2, false);
    
    var bg_color = style.tab_item_selected_color;
    draw_set_alpha(alpha);
    draw_set_color(bg_color);
    draw_roundrect_ext(_x, _y, _x + vis.width, _y + vis.height, style.tab_item_rounding, style.tab_item_rounding, false);
    
    var display_text = vis.label;
    var text_size = [string_width(display_text), string_height(display_text)];
    var max_text_w = vis.width - style.tab_item_padding_h * 2;
    if (text_size[0] > max_text_w) {
        for (var len = string_length(display_text); len > 0; len--) {
            var test = string_copy(display_text, 1, len) + "...";
            if (string_width(test) <= max_text_w) {
                display_text = test;
                break;
            }
        }
        text_size = [string_width(display_text), string_height(display_text)];
    }
    
    var text_x = _x + (vis.width - text_size[0]) / 2;
    var text_y = _y + (vis.height - text_size[1]) / 2;
    draw_set_color(style.tab_item_selected_text_color);
    draw_set_alpha(alpha);
    draw_text(text_x, text_y, display_text);
    
    draw_set_color(c_black);
    draw_set_alpha(alpha);
    draw_roundrect_ext(_x, _y, _x + vis.width, _y + vis.height, style.tab_item_rounding, style.tab_item_rounding, true);
    draw_set_alpha(1);
}