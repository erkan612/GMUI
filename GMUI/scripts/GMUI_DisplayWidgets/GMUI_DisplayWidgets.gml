

// text
function gmui_text(text, font = undefined) {
	var gmui = global.gmui;
	var style = gmui.style;
	var widget = gmui_begin_widget("text");
	
	var text_size = gmui_calculate_text_size(text);
	widget.width = text_size[0];
	widget.height = text_size[1];
	
	var _font = gmui_resolve_font(widget, font);
	
	if (gmui_widget_is_callable(widget)) {
		gmui_add_text(text, widget.x, widget.y, style.text_color, style.text_alpha, _font);
	};
	
	gmui_end_widget(widget);
};

function gmui_text_disabled(text, font = undefined) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("text");
    
    var _font = gmui_resolve_font(widget, font);
    var text_size = gmui_calculate_text_size(text, _font);
    widget.width = text_size[0];
    widget.height = text_size[1];
    
    if (gmui_widget_is_callable(widget)) {
        gmui_add_text(text, widget.x, widget.y, style.text_disabled_color, style.text_alpha, _font);
    }
    
    gmui_end_widget(widget);
};

function gmui_text_colored(text, color, font = undefined) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("text");
    
    var _font = gmui_resolve_font(widget, font);
    var text_size = gmui_calculate_text_size(text, _font);
    widget.width = text_size[0];
    widget.height = text_size[1];
    
    if (gmui_widget_is_callable(widget)) {
        gmui_add_text(text, widget.x, widget.y, color, style.text_alpha, _font);
    }
    
    gmui_end_widget(widget);
};

function gmui_text_bullet(text, font = undefined) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("text");
    
    var _font = gmui_resolve_font(widget, font);
    var text_size = gmui_calculate_text_size(text, _font);
    var bullet_size = style.text_bullet_size;
    var bullet_spacing = style.text_bullet_spacing;
    
    widget.width = bullet_size + bullet_spacing + text_size[0];
    widget.height = max(bullet_size, text_size[1]);
    
    if (gmui_widget_is_callable(widget)) {
        gmui_add_rectangle(widget.x, widget.y + text_size[1] / 2 - bullet_size / 2, 
                          widget.x + bullet_size, widget.y + text_size[1] / 2 + bullet_size / 2,
                          false, style.text_color, 1);
        
        gmui_add_text(text, widget.x + bullet_size + bullet_spacing, widget.y, style.text_color, style.text_alpha, _font);
    }
    
    gmui_end_widget(widget);
};

function gmui_text_wrap(text, width = -1, font = undefined) {
    var gmui = global.gmui;
    var style = gmui.style;
    var container = gmui.current_container;
    var widget = gmui_begin_widget("text");
    
    var _font = gmui_resolve_font(widget, font);
    var wrap_width = width;
    if (wrap_width <= 0) {
        wrap_width = container.width - style.container_padding_h * 2 - container.context.indent_level - widget.x;
    }
    
    var lines = [];
    var words = string_split(text, " ");
    var current_line = "";
    var total_height = 0;
    var max_line_width = 0;
    var line_height = gmui_calculate_text_size("W", _font)[1];
    
    for (var i = 0; i < array_length(words); i++) {
        var test_line = current_line == "" ? words[i] : current_line + " " + words[i];
        var test_width = gmui_calculate_text_size(test_line, _font)[0];
        
        if (test_width <= wrap_width || current_line == "") {
            current_line = test_line;
        } else {
            array_push(lines, current_line);
            max_line_width = max(max_line_width, gmui_calculate_text_size(current_line, _font)[0]);
            total_height += line_height + style.element_spacing_v;
            current_line = words[i];
        }
    }
    
    if (current_line != "") {
        array_push(lines, current_line);
        max_line_width = max(max_line_width, gmui_calculate_text_size(current_line, _font)[0]);
    }
    total_height += line_height;
    
    widget.width = max_line_width;
    widget.height = total_height;
    
    if (gmui_widget_is_callable(widget)) {
        var line_y = widget.y;
        for (var i = 0; i < array_length(lines); i++) {
            gmui_add_text(lines[i], widget.x, line_y, style.text_color, style.text_alpha, _font);
            line_y += line_height + style.element_spacing_v;
        }
    }
    
    gmui_end_widget(widget);
    return array_length(lines);
};

function gmui_text_label(label, value, font = undefined) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("label");
    
    var _font = gmui_resolve_font(widget, font);
    var label_text = label + ": ";
    var label_size = gmui_calculate_text_size(label_text, _font);
    var value_size = gmui_calculate_text_size(value, _font);
    
    widget.width = label_size[0] + value_size[0];
    widget.height = max(label_size[1], value_size[1]);
    
    if (gmui_widget_is_callable(widget)) {
        gmui_add_text(label_text, widget.x, widget.y, style.text_disabled_color, style.text_alpha, _font);
        gmui_add_text(value, widget.x + label_size[0], widget.y, style.text_color, style.text_alpha, _font);
    }
    
    gmui_end_widget(widget);
};

// separator
function gmui_separator() { // TODO: if new line requested, align the line in the middle of the line
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("separator");
    var container = widget.container;
    
	var available_width = container.width - style.container_padding_h * 2 - container.context.indent_level - (container.context.new_line_requested ? 0 : container.context.cursor_x - style.element_spacing_h);
    
    widget.width = available_width;
    widget.height = style.separator_thickness + style.element_spacing_v;
    
	if (gmui_widget_is_callable(widget)) {
	    gmui_add_rectangle(
	        widget.x, widget.y + style.element_spacing_v / 2,
	        widget.x + available_width, widget.y + style.element_spacing_v / 2 + style.separator_thickness,
	        false,
	        style.separator_color, 1
	    );
	};
    
    gmui_end_widget(widget);
};

function gmui_separator_vertical(stay = true, new_line = false, height = -1) {
    if (stay) { gmui_sameline(); };
	
	var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("separator");
    var container = widget.container;
    
	var available_height = height <= 0 ? container.context.line_height : height;
    
    widget.width = style.separator_thickness + style.element_spacing_h;
    widget.height = available_height;
    
	if (gmui_widget_is_callable(widget)) {
	    gmui_add_rectangle(
	        widget.x + style.element_spacing_h / 2, widget.y,
	        widget.x + style.element_spacing_h / 2 + style.separator_thickness, widget.y + available_height,
	        false,
	        style.separator_color, 1
	    );
	};
    
    gmui_end_widget(widget);
	
	if (!new_line) { gmui_sameline(); };
};

function gmui_separator_text(text, font = undefined) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("separator_text");
    var container = widget.container;
    
    var text_size = gmui_calculate_text_size(text);
    var available_width = container.width - style.container_padding_h * 2 - container.context.indent_level;
    var gap = style.separator_gap;
    var line_y = text_size[1] / 2;
    
    widget.width = available_width;
    widget.height = text_size[1] + style.element_spacing_v;
	
	var _font = gmui_resolve_font(widget, font);
    
	if (gmui_widget_is_callable(widget)) {
	    var line_width = (available_width - text_size[0] - gap * 2) / 2;
    
	    if (line_width > 0) {
	        gmui_add_rectangle(
	            widget.x, widget.y + line_y,
	            widget.x + line_width, widget.y + line_y + style.separator_thickness,
	            false,
	            style.separator_color, 1
	        );
        
	        gmui_add_rectangle(
	            widget.x + line_width + gap + text_size[0] + gap, widget.y + line_y,
	            widget.x + available_width, widget.y + line_y + style.separator_thickness,
	            false,
	            style.separator_color, 1
	        );
	    }
    
	    var text_x = widget.x + (available_width - text_size[0]) / 2;
	    gmui_add_text(text, text_x, widget.y, style.separator_text_color, 1, _font);
	};
    
    gmui_end_widget(widget);
};

function gmui_separator_text_left(text, font = undefined) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("separator_text_left");
    var container = widget.container;
    
    var text_size = gmui_calculate_text_size(text);
    var available_width = container.width - style.container_padding_h * 2 - container.context.indent_level;
    var gap = style.separator_gap;
    var line_y = text_size[1] / 2;
    
    widget.width = available_width;
    widget.height = text_size[1] + style.element_spacing_v;
	
	var _font = gmui_resolve_font(widget, font);
    
	if (gmui_widget_is_callable(widget)) {
	    var line_start = widget.x + text_size[0] + gap;
	    var line_width = available_width - text_size[0] - gap;
    
	    if (line_width > 0) {
	        gmui_add_rectangle(
	            line_start, widget.y + line_y,
	            widget.x + available_width, widget.y + line_y + style.separator_thickness,
	            false,
	            style.separator_color, 1
	        );
	    }
    
	    gmui_add_text(text, widget.x, widget.y, style.separator_text_color, 1, _font);
	};
    
    gmui_end_widget(widget);
};

// dummy
function gmui_dummy(width, height) {
    var gmui = global.gmui;
    var widget = gmui_begin_widget("dummy");
	
	widget.width = width;
	widget.height = height;
	
    gmui_end_widget(widget);
};

// image
function gmui_sprite(sprite, subimg = 0, width = -1, height = -1) {
    var gmui = global.gmui;
    var widget = gmui_begin_widget("sprite");
    
    var sw = width > 0 ? width : sprite_get_width(sprite);
    var sh = height > 0 ? height : sprite_get_height(sprite);
    widget.width = sw;
    widget.height = sh;
    
    if (gmui_widget_is_callable(widget)) {
		var xscale = width != -1 ? sprite_get_width(GMUI_Icon) / width : 1;
		var yscale = height != -1 ? sprite_get_height(GMUI_Icon) / height : 1;
        gmui_add_sprite_ext(sprite, subimg, widget.x, widget.y,  1 / xscale, 1 / yscale, 0, c_white, 1);
    }
    
    gmui_end_widget(widget);
};

function gmui_surface(surface) {
    var gmui = global.gmui;
    var widget = gmui_begin_widget("surface");
    
    var sw = surface_get_width(surface);
    var sh = surface_get_height(surface);
    widget.width = sw;
    widget.height = sh;
    
    if (gmui_widget_is_callable(widget)) {
        gmui_add_surface(surface, widget.x, widget.y);
    }
    
    gmui_end_widget(widget);
};

// progress
function gmui_progress_bar(value, min_val = 0, max_val = 1, width = -1, show_text = true, font = undefined) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("progress_bar");
    var container = widget.container;
    
    var bar_width = width > 0 ? width : container.width - style.container_padding_h * 2 - container.context.indent_level;
    var bar_height = style.progress_bar_height;
    
    widget.width = bar_width;
    widget.height = bar_height;
	
	var _font = gmui_resolve_font(widget, font);
    
    if (gmui_widget_is_callable(widget)) {
        var normalized = clamp((value - min_val) / (max_val - min_val), 0, 1);
        var fill_width = (bar_width - style.progress_bar_border_size * 2) * normalized;
        
        gmui_add_roundrect(
            widget.x, widget.y,
            widget.x + bar_width, widget.y + bar_height,
            false,
            style.progress_bar_background_color, 1,
            style.progress_bar_rounding
        );
        
        if (fill_width > 0) {
            gmui_add_roundrect(
                widget.x + style.progress_bar_border_size, widget.y + style.progress_bar_border_size,
                widget.x + style.progress_bar_border_size + fill_width, widget.y + bar_height - style.progress_bar_border_size,
                false,
                style.progress_bar_fill_color, 1,
                style.progress_bar_rounding
            );
        }
        
        if (style.progress_bar_border_size > 0) {
            gmui_add_roundrect(
                widget.x, widget.y,
                widget.x + bar_width, widget.y + bar_height,
                true,
                style.progress_bar_border_color, 1,
                style.progress_bar_rounding
            );
        }
        
        if (show_text) {
            var text = string(floor(normalized * 100)) + "%";
            var text_size = gmui_calculate_text_size(text);
            var text_x = widget.x + (bar_width - text_size[0]) / 2;
            var text_y = widget.y + (bar_height - text_size[1]) / 2;
            gmui_add_text(text, text_x, text_y, style.progress_bar_text_color, 1, _font);
        }
    }
    
    gmui_end_widget(widget);
    return value;
};

function gmui_progress_bar_indeterminate(width = -1) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("progress_bar");
    var container = widget.container;
    
    var bar_width = width > 0 ? width : container.width - style.container_padding_h * 2 - container.context.indent_level;
    var bar_height = style.progress_bar_height;
    
    widget.width = bar_width;
    widget.height = bar_height;
    
    if (gmui_widget_is_callable(widget)) {
        var time = current_time / 1000;
        var anim = (sin(time * 3) * 0.5 + 0.5);
        var bar_size = bar_width * 0.3;
        var bar_pos = (bar_width - bar_size) * anim;
        
        gmui_add_roundrect(
            widget.x, widget.y,
            widget.x + bar_width, widget.y + bar_height,
            false,
            style.progress_bar_background_color, 1,
            style.progress_bar_rounding
        );
        
        gmui_add_roundrect(
            widget.x + bar_pos, widget.y + style.progress_bar_border_size,
            widget.x + bar_pos + bar_size, widget.y + bar_height - style.progress_bar_border_size,
            false,
            style.progress_bar_fill_color, 1,
            style.progress_bar_rounding
        );
        
        if (style.progress_bar_border_size > 0) {
            gmui_add_roundrect(
                widget.x, widget.y,
                widget.x + bar_width, widget.y + bar_height,
                true,
                style.progress_bar_border_color, 1,
                style.progress_bar_rounding
            );
        }
    }
    
    gmui_end_widget(widget);
};

function gmui_progress_circular(value, min_val = 0, max_val = 1, size = -1, show_text = true, font = undefined) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("progress_circular");
    
    var circle_size = size > 0 ? size : style.progress_circular_size;
    var thickness = style.progress_circular_thickness;
    var radius = circle_size / 2;
    
    widget.width = circle_size;
    widget.height = circle_size;
	
	var _font = gmui_resolve_font(widget, font);
    
    if (gmui_widget_is_callable(widget)) {
        var normalized = clamp((value - min_val) / (max_val - min_val), 0, 1);
        var cx = widget.x + radius;
        var cy = widget.y + radius;
        
        gmui_add_circle(cx, cy, radius, true, style.progress_circular_bg_color, 1);
        
        if (normalized > 0) { // simplified
            var segments = max(8, floor(normalized * style.progress_circular_segments));
            var angle_step = (2 * pi * normalized) / segments;
            var start_angle = -pi / 2;
            
            for (var i = 0; i < segments; i++) {
                var a1 = start_angle + i * angle_step;
                var a2 = start_angle + (i + 1) * angle_step;
                
                var x1 = cx + cos(a1) * (radius - thickness);
                var y1 = cy + sin(a1) * (radius - thickness);
                var x2 = cx + cos(a1) * radius;
                var y2 = cy + sin(a1) * radius;
                var x3 = cx + cos(a2) * radius;
                var y3 = cy + sin(a2) * radius;
                var x4 = cx + cos(a2) * (radius - thickness);
                var y4 = cy + sin(a2) * (radius - thickness);
                
                gmui_add_triangle(x1, y1, x2, y2, x3, y3, style.progress_circular_fill_color);
                gmui_add_triangle(x1, y1, x3, y3, x4, y4, style.progress_circular_fill_color);
            }
        }
        
        if (show_text) {
            var text = string(floor(normalized * 100)) + "%";
            var text_size = gmui_calculate_text_size(text);
            var text_x = cx - text_size[0] / 2;
            var text_y = cy - text_size[1] / 2;
            gmui_add_text(text, text_x, text_y, style.progress_circular_text_color, 1, _font);
        }
    }
    
    gmui_end_widget(widget);
    return value;
};

function gmui_progress_spinner(size = -1, thickness = -1) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("progress_spinner");
    
    var circle_size = size > 0 ? size : style.progress_circular_size;
    var _thickness = thickness > 0 ? thickness : style.progress_circular_thickness;
    var radius = circle_size / 2;
    
    widget.width = circle_size;
    widget.height = circle_size;
    
    if (gmui_widget_is_callable(widget)) {
        var cx = widget.x + radius;
        var cy = widget.y + radius;
        var time = current_time / 1000;
        var angle_offset = (time * 2 * pi) % (2 * pi);
        var arc_length = pi * 1.2;
        
        var segments = style.progress_circular_segments;
        var angle_step = arc_length / segments;
        
        for (var i = 0; i < segments; i++) {
            var a1 = angle_offset + i * angle_step;
            var a2 = angle_offset + (i + 1) * angle_step;
            var alpha = 0.3 + (i / segments) * 0.7;
            
            var x1 = cx + cos(a1) * (radius - _thickness);
            var y1 = cy + sin(a1) * (radius - _thickness);
            var x2 = cx + cos(a1) * radius;
            var y2 = cy + sin(a1) * radius;
            var x3 = cx + cos(a2) * radius;
            var y3 = cy + sin(a2) * radius;
            var x4 = cx + cos(a2) * (radius - _thickness);
            var y4 = cy + sin(a2) * (radius - _thickness);
            
            var seg_color = make_color_rgb(
                color_get_red(style.progress_circular_fill_color),
                color_get_green(style.progress_circular_fill_color),
                color_get_blue(style.progress_circular_fill_color)
            );
            
            gmui_add_triangle(x1, y1, x2, y2, x3, y3, seg_color, alpha);
            gmui_add_triangle(x1, y1, x3, y3, x4, y4, seg_color, alpha);
        }
    }
    
    gmui_end_widget(widget);
};

function gmui_progress(value, max_val, width = -1, show_text = true, font = undefined) {
    return gmui_progress_bar(value, 0, max_val, width, show_text, font);
};

function gmui_progress_percent(percent, width = -1, show_text = true, font = undefined) {
    return gmui_progress_bar(percent, 0, 100, width, show_text, font);
};

// tooltip
function gmui_tooltip(text, widget, width = -1, font = undefined) {
	var gmui = global.gmui;
	var style = gmui.style;
	var input = gmui.input;
	var container = gmui.current_container;
    
	var text_size = gmui_calculate_text_size(text);
    var tooltip_width = width > style.tooltip_min_width ? min(width, text_size[0]) : style.tooltip_min_width;
    var tooltip_height = 0;
	
	var hovered = gmui_widget_is_hovered(widget);
	
	if (hovered) {
        if (gmui.cache[? widget.id + "_tt_start_time"] == undefined) {
            gmui.cache[? widget.id + "_tt_start_time"] = current_time;
        }
    } else {
        gmui.cache[? widget.id + "_tt_start_time"] = current_time;
    }
    
    var show_tooltip = hovered && current_time - gmui.cache[? widget.id + "_tt_start_time"] >= style.tooltip_delay;
	
	gmui.current_container = undefined;
	
	if (show_tooltip) {
		var _font = font == -5 ? gmui.style.font : (font == undefined ? gmui.style.font_text : font);
	    var wrap_width = tooltip_width;
    
	    var lines = [];
	    var words = string_split(text, " ");
	    var current_line = "";
	    var total_height = 0;
	    var max_line_width = 0;
	    var line_height = text_size[1];
    
	    for (var i = 0; i < array_length(words); i++) {
	        var test_line = current_line == "" ? words[i] : current_line + " " + words[i];
	        var test_width = gmui_calculate_text_size(test_line, _font)[0];
        
	        if (test_width <= wrap_width || current_line == "") {
	            current_line = test_line;
	        } else {
	            array_push(lines, current_line);
	            max_line_width = max(max_line_width, gmui_calculate_text_size(current_line, _font)[0]);
	            total_height += line_height + style.element_spacing_v;
	            current_line = words[i];
	        }
	    }
    
	    if (current_line != "") {
	        array_push(lines, current_line);
	        max_line_width = max(max_line_width, gmui_calculate_text_size(current_line, _font)[0]);
	    }
	    total_height += line_height;
		
		tooltip_height = string_replace_all(string_replace_all(text, "\n", ""), "\r", "") == "" ? style.tooltip_padding_v * 2 : total_height;
    
		var tx = input.m_x;
		var ty = input.m_y;
		var sw = surface_get_width(application_surface);
		var sh = surface_get_height(application_surface);
		
		if (tx + tooltip_width  > sw) { tx -= tooltip_width  + style.tooltip_mouse_padding_h; } else { tx += style.tooltip_mouse_padding_v; };
		if (ty + tooltip_height > sh) { ty -= tooltip_height + style.tooltip_mouse_padding_v; } else { ty += style.tooltip_mouse_padding_h; };
		
		gmui_add_roundrect(tx, ty, tx + tooltip_width + style.tooltip_padding_h * 2, ty + tooltip_height + style.tooltip_padding_v * 2,
                          false, style.tooltip_background_color, 1, style.tooltip_rounding);
        gmui_add_roundrect(tx, ty, tx + tooltip_width + style.tooltip_padding_h * 2, ty + tooltip_height + style.tooltip_padding_v * 2,
                          true, style.tooltip_border_color, 1, style.tooltip_rounding);
    
	    var line_y = ty + style.tooltip_padding_v;
	    for (var i = 0; i < array_length(lines); i++) {
	        gmui_add_text(lines[i], tx + style.tooltip_padding_h, line_y, style.text_color, style.text_alpha, _font);
	        line_y += line_height + style.element_spacing_v;
	    }
	}
	
	gmui.current_container = container;
};

function gmui_tooltip_on_last(text, width = -1, font = undefined) {
    var last = global.gmui.last_widget;
    if (last != undefined) {
        gmui_tooltip(text, last, width, font);
    }
};

function gmui_tooltip_on_hover(widget, text, width = -1, font = undefined) {
    gmui_tooltip(text, widget, width, font);
};

function gmui_set_tooltip(text, x = -1, y = -1, width = -1, font = undefined) { // immediate variationn
    var gmui = global.gmui;
    var style = gmui.style;
    var input = gmui.input;
    var container = gmui.current_container;
    
    var text_size = gmui_calculate_text_size(text);
    var tooltip_width = width > style.tooltip_min_width ? min(width, text_size[0]) : style.tooltip_min_width;
    var tooltip_height = 0;
    
    gmui.current_container = undefined;
    
    var _font = font == -5 ? gmui.style.font : (font == undefined ? gmui.style.font_text : font);
    var wrap_width = tooltip_width;
    
    var lines = [];
    var words = string_split(text, " ");
    var current_line = "";
    var total_height = 0;
    var max_line_width = 0;
    var line_height = text_size[1];
    
    for (var i = 0; i < array_length(words); i++) {
        var test_line = current_line == "" ? words[i] : current_line + " " + words[i];
        var test_width = gmui_calculate_text_size(test_line, _font)[0];
        
        if (test_width <= wrap_width || current_line == "") {
            current_line = test_line;
        } else {
            array_push(lines, current_line);
            max_line_width = max(max_line_width, gmui_calculate_text_size(current_line, _font)[0]);
            total_height += line_height + style.element_spacing_v;
            current_line = words[i];
        }
    }
    
    if (current_line != "") {
        array_push(lines, current_line);
        max_line_width = max(max_line_width, gmui_calculate_text_size(current_line, _font)[0]);
    }
    total_height += line_height;
    
    tooltip_height = string_replace_all(string_replace_all(text, "\n", ""), "\r", "") == "" ? style.tooltip_padding_v * 2 : total_height;
    
    var tx = x < 0 || x == undefined ? input.m_x : x;
    var ty = y < 0 || y == undefined ? input.m_y : y;
    var sw = surface_get_width(application_surface);
    var sh = surface_get_height(application_surface);
    
    if (tx + tooltip_width  > sw) { tx -= tooltip_width  + style.tooltip_mouse_padding_h; } else { tx += style.tooltip_mouse_padding_v; };
    if (ty + tooltip_height > sh) { ty -= tooltip_height + style.tooltip_mouse_padding_v; } else { ty += style.tooltip_mouse_padding_h; };
    
    gmui_add_roundrect(tx, ty, tx + tooltip_width + style.tooltip_padding_h * 2, ty + tooltip_height + style.tooltip_padding_v * 2,
                      false, style.tooltip_background_color, 1, style.tooltip_rounding);
    gmui_add_roundrect(tx, ty, tx + tooltip_width + style.tooltip_padding_h * 2, ty + tooltip_height + style.tooltip_padding_v * 2,
                      true, style.tooltip_border_color, 1, style.tooltip_rounding);
    
    var line_y = ty + style.tooltip_padding_v;
    for (var i = 0; i < array_length(lines); i++) {
        gmui_add_text(lines[i], tx + style.tooltip_padding_h, line_y, style.text_color, style.text_alpha, _font);
        line_y += line_height + style.element_spacing_v;
    }
    
    gmui.current_container = container;
};

// toast notification
function gmui_toast_push(message, type = "info", duration = -1) {
    var gmui = global.gmui;
    var style = gmui.style;
    
    if (!ds_map_exists(gmui.cache, "_toasts")) {
        gmui.cache[? "_toasts"] = [];
    }
    
    array_push(gmui.cache[? "_toasts"], {
        message: message,
        type: type,
        start_time: current_time,
        duration: duration > 0 ? duration : style.toast_duration,
    });
};

function gmui_toast_info(message, duration = -1) {
    gmui_toast_push(message, "info", duration);
};

function gmui_toast_success(message, duration = -1) {
    gmui_toast_push(message, "success", duration);
};

function gmui_toast_warning(message, duration = -1) {
    gmui_toast_push(message, "warning", duration);
};

function gmui_toast_error(message, duration = -1) {
    gmui_toast_push(message, "error", duration);
};

// toast render
function gmui_render_toast(font = undefined) {
    var gmui = global.gmui;
    var style = gmui.style;
    
    if (!ds_map_exists(gmui.cache, "_toasts")) return;
    
    var toasts = gmui.cache[? "_toasts"];
    var screen_w = surface_get_width(application_surface);
    var screen_h = surface_get_height(application_surface);
    var margin = style.toast_margin;
    var gap = style.toast_gap;
    var position = style.toast_position;
    var to_remove = [];
    
    var saved_container = gmui.current_container;
    gmui.current_container = undefined;
    
    var anchor_x, anchor_y, dir_y, dir_x;
    switch (position) {
        case "top-left":     anchor_x = margin;            anchor_y = margin;            dir_y = 1;  dir_x = -1; break;
        case "top-center":   anchor_x = screen_w / 2;      anchor_y = margin;            dir_y = 1;  dir_x = 0;  break;
        case "top-right":    anchor_x = screen_w - margin;  anchor_y = margin;            dir_y = 1;  dir_x = 1;  break;
        case "bottom-left":  anchor_x = margin;            anchor_y = screen_h - margin; dir_y = -1; dir_x = -1; break;
        case "bottom-center":anchor_x = screen_w / 2;      anchor_y = screen_h - margin; dir_y = -1; dir_x = 0;  break;
        case "bottom-right": anchor_x = screen_w - margin; anchor_y = screen_h - margin; dir_y = -1; dir_x = 1;  break;
        case "middle-center":anchor_x = screen_w / 2;      anchor_y = screen_h / 2;      dir_y = -1; dir_x = 0;  break;
        default:             anchor_x = screen_w / 2;      anchor_y = margin;            dir_y = 1;  dir_x = 0;  break;
    }
    
    var _visible = [];
    for (var i = array_length(toasts) - 1; i >= 0; i--) {
        var toast = toasts[i];
        var elapsed = current_time - toast.start_time;
        if (elapsed >= toast.duration) {
            array_push(to_remove, i);
            continue;
        }
        
        var _font = font == -5 ? gmui.style.font : (font == undefined ? gmui.style.font_text : font);
        var text_size = gmui_calculate_text_size(toast.message, _font);
        var toast_w = min(style.toast_max_width, text_size[0] + style.toast_padding_h * 2);
        var toast_h = text_size[1] + style.toast_padding_v * 2;
        
        var tx;
        if (dir_x == 0)      tx = anchor_x - toast_w / 2;
        else if (dir_x == 1) tx = anchor_x - toast_w;
        else                 tx = anchor_x;
        
        array_push(_visible, {
            toast: toast,
            x: tx,
            w: toast_w,
            h: toast_h,
            font: _font,
        });
    }
    
    if (array_length(_visible) == 0) {
        gmui.current_container = saved_container;
        for (var i = 0; i < array_length(to_remove); i++) array_delete(toasts, to_remove[i], 1);
        gmui.cache[? "_toasts"] = toasts;
        return;
    }
    
    for (var i = 0; i < array_length(_visible); i++) {
        var p = _visible[i];
        if (i == 0) {
            p.y = (dir_y > 0) ? anchor_y : anchor_y - p.h;
        } else {
            p.y = _visible[i - 1].y + dir_y * (_visible[i - 1].h + gap);
        }
    }
    
    for (var i = 0; i < array_length(_visible); i++) {
        var p = _visible[i];
        var toast = p.toast;
        var elapsed = current_time - toast.start_time;
        
        var alpha = 1;
        if (elapsed > toast.duration - 500) {
            alpha = 1 - (elapsed - (toast.duration - 500)) / 500;
        }
        
        var text_size = gmui_calculate_text_size(toast.message, p.font);
        
        var bg_color = 0;
        switch (toast.type) {
            case "info":	bg_color = style.toast_info_color;		break;
            case "success": bg_color = style.toast_success_color;	break;
            case "error":	bg_color = style.toast_error_color;		break;
            case "warning": bg_color = style.toast_warning_color;	break;
        }
        
        gmui_add_roundrect(p.x, p.y, p.x + p.w, p.y + p.h, false, bg_color, alpha, style.toast_rounding);
        gmui_add_text(toast.message, p.x + style.toast_padding_h, p.y + (p.h - text_size[1]) / 2, style.toast_text_color, alpha, p.font);
    }
    
    gmui.current_container = saved_container;
    
    for (var i = 0; i < array_length(to_remove); i++) {
        array_delete(toasts, to_remove[i], 1);
    }
    gmui.cache[? "_toasts"] = toasts;
};

// spinner
function gmui_spinner(size = 16, thickness = 2) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("spinner");
    
    widget.width = size;
    widget.height = size;
    
    if (gmui_widget_is_callable(widget)) {
        var cx = widget.x + size / 2;
        var cy = widget.y + size / 2;
        var radius = size / 2;
        var inner_radius = radius - thickness;
        
        var time = current_time / 1000;
        var angle_offset = (time * 3 * pi) % (2 * pi);
        var arc_length = pi * 0.8;
        var segments = style.progress_circular_segments;
        var angle_step = arc_length / segments;
        
        for (var i = 0; i < segments; i++) {
            var a1 = angle_offset + i * angle_step;
            var a2 = angle_offset + (i + 1) * angle_step;
            
            var alpha = 0.3 + (i / segments) * 0.7;
            
            var x1 = cx + cos(a1) * inner_radius;
            var y1 = cy - sin(a1) * inner_radius;
            var x2 = cx + cos(a1) * radius;
            var y2 = cy - sin(a1) * radius;
            var x3 = cx + cos(a2) * radius;
            var y3 = cy - sin(a2) * radius;
            var x4 = cx + cos(a2) * inner_radius;
            var y4 = cy - sin(a2) * inner_radius;
            
            var seg_color = style.color_accent;
            gmui_add_triangle(x1, y1, x2, y2, x3, y3, seg_color, alpha);
            gmui_add_triangle(x1, y1, x3, y3, x4, y4, seg_color, alpha);
        }
    }
    gmui_end_widget(widget);
}