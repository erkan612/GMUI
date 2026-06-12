

// line plot
function gmui_plot_lines(values, count, width = -1, height = 120, show_points = true) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("plot_lines");
    var container = widget.container;
    
    var plot_width = width > 0 ? width : container.width - style.container_padding_h * 2 - container.context.indent_level;
    var plot_height = height;
    
    widget.width = plot_width;
    widget.height = plot_height;
    
    if (gmui_widget_is_callable(widget)) {
        var min_val = values[0];
        var max_val = values[0];
        for (var i = 1; i < count; i++) {
            min_val = min(min_val, values[i]);
            max_val = max(max_val, values[i]);
        }
        
        var range = max_val - min_val;
        if (range <= 0) range = 1;
        min_val -= range * 0.1;
        max_val += range * 0.1;
        
        gmui_add_rectangle(widget.x, widget.y, widget.x + plot_width, widget.y + plot_height, false, style.plot_bg_color, 1);
        if (style.plot_border_size > 0) {
            gmui_add_rectangle(widget.x, widget.y, widget.x + plot_width, widget.y + plot_height, true, style.plot_border_color, 1);
        }
        
        for (var i = 0; i <= style.plot_grid_steps; i++) {
            var gy = widget.y + plot_height - (i * plot_height / style.plot_grid_steps);
            gmui_add_line(widget.x, gy, widget.x + plot_width, gy, style.plot_grid_color, style.plot_grid_thickness);
        }
        
        if (min_val <= 0 && max_val >= 0) {
            var zero_y = widget.y + plot_height * (1 - (-min_val) / (max_val - min_val));
            gmui_add_line(widget.x, zero_y, widget.x + plot_width, zero_y, style.plot_grid_color, max(1, style.plot_grid_thickness));
        }
        
        if (style.plot_fill_enabled && count > 1) {
            for (var i = 0; i < count - 1; i++) {
                var fx1 = widget.x + (i * plot_width / (count - 1));
                var fx2 = widget.x + ((i + 1) * plot_width / (count - 1));
                var fy1 = widget.y + plot_height * (1 - (values[i] - min_val) / (max_val - min_val));
                var fy2 = widget.y + plot_height * (1 - (values[i + 1] - min_val) / (max_val - min_val));
                var fbot = widget.y + plot_height;
                
                var fill_color = make_color_rgb(
                    color_get_red(style.plot_fill_color),
                    color_get_green(style.plot_fill_color),
                    color_get_blue(style.plot_fill_color)
                );
                
                gmui_add_triangle(fx1, fy1, fx2, fy2, fx2, fbot, fill_color, style.plot_fill_alpha);
                gmui_add_triangle(fx1, fy1, fx2, fbot, fx1, fbot, fill_color, style.plot_fill_alpha);
            }
        }
        
        if (count > 1) {
            for (var i = 0; i < count; i++) {
                var px = widget.x + (i * plot_width / (count - 1));
                var py = widget.y + plot_height * (1 - (values[i] - min_val) / (max_val - min_val));
                
                if (i > 0) {
                    var prev_px = widget.x + ((i - 1) * plot_width / (count - 1));
                    var prev_py = widget.y + plot_height * (1 - (values[i - 1] - min_val) / (max_val - min_val));
                    gmui_add_line(prev_px, prev_py, px, py, style.plot_line_color, style.plot_line_thickness);
                }
                
                if (show_points) {
                    gmui_add_rectangle(px - 2, py - 2, px + 2, py + 2, false, style.plot_point_color, 1);
                }
            }
        }
    }
    
    gmui_end_widget(widget);
    return true;
};

// bar chart
function gmui_plot_bars(values, count, width = -1, height = 120) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("plot_bars");
    var container = widget.container;
    
    var plot_width = width > 0 ? width : container.width - style.container_padding_h * 2 - container.context.indent_level;
    var plot_height = height;
    
    widget.width = plot_width;
    widget.height = plot_height;
    
    if (gmui_widget_is_callable(widget)) {
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
        
        var range = max_val - min_val;
        if (range == 0) { range = 1; max_val = min_val + 1; }
        
        gmui_add_rectangle(widget.x, widget.y, widget.x + plot_width, widget.y + plot_height, false, style.plot_bg_color, 1);
        if (style.plot_border_size > 0) {
            gmui_add_rectangle(widget.x, widget.y, widget.x + plot_width, widget.y + plot_height, true, style.plot_border_color, 1);
        }
        
        if (count > 0) {
            var bar_full_width = plot_width / count;
            var bar_spacing = max(1, bar_full_width * style.plot_bar_spacing_ratio);
            var bar_width = bar_full_width - bar_spacing;
            
            for (var i = 0; i < count; i++) {
                var bx = widget.x + i * bar_full_width + bar_spacing / 2;
                var bar_height = plot_height * ((values[i] - min_val) / range);
                var by = widget.y + plot_height - bar_height;
                
                var bar_color = style.plot_bar_color;
                if (style.plot_bar_gradient) {
                    var normal = (values[i] - min_val) / range;
                    bar_color = _gmui_lerp_color(style.plot_bar_min_color, style.plot_bar_max_color, normal);
                }
                
                gmui_add_rectangle(bx, by, bx + bar_width, by + bar_height, false, bar_color, 1);
                
                if (style.plot_bar_border_size > 0) {
                    gmui_add_rectangle(bx, by, bx + bar_width, by + bar_height, true, style.plot_bar_border_color, 1);
                }
            }
        }
    }
    
    gmui_end_widget(widget);
    return true;
};

// histogram
function gmui_plot_histogram(values, count, width = -1, height = 120, bins = 10) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("plot_histogram");
    var container = widget.container;
    
    var plot_width = width > 0 ? width : container.width - style.container_padding_h * 2 - container.context.indent_level;
    var plot_height = height;
    
    widget.width = plot_width;
    widget.height = plot_height;
    
    if (gmui_widget_is_callable(widget)) {
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
        
        var bin_counts = array_create(bins, 0);
        var bin_range = max_val - min_val;
        if (bin_range == 0) bin_range = 1;
        
        for (var i = 0; i < count; i++) {
            var bin_index = clamp(floor((values[i] - min_val) / bin_range * bins), 0, bins - 1);
            bin_counts[bin_index]++;
        }
        
        var max_bin_count = 0;
        for (var i = 0; i < bins; i++) {
            max_bin_count = max(max_bin_count, bin_counts[i]);
        }
        if (max_bin_count == 0) max_bin_count = 1;
        
        gmui_add_rectangle(widget.x, widget.y, widget.x + plot_width, widget.y + plot_height, false, style.plot_bg_color, 1);
        gmui_add_rectangle(widget.x, widget.y, widget.x + plot_width, widget.y + plot_height, true, style.plot_border_color, 1);
        
        var bar_full_width = plot_width / bins;
        var bar_spacing = max(1, bar_full_width * 0.1);
        var bar_width = bar_full_width - bar_spacing;
        
        for (var i = 0; i < bins; i++) {
            var bx = widget.x + i * bar_full_width + bar_spacing / 2;
            var bar_height = plot_height * (bin_counts[i] / max_bin_count);
            var by = widget.y + plot_height - bar_height;
            
            var normalized = bin_counts[i] / max_bin_count;
            var bar_color = make_color_rgb(100 + normalized * 155, 200, 100);
            
            gmui_add_rectangle(bx, by, bx + bar_width, by + bar_height, false, bar_color, 1);
            gmui_add_rectangle(bx, by, bx + bar_width, by + bar_height, true, style.plot_bar_border_color, 1);
        }
    }
    
    gmui_end_widget(widget);
    return true;
};

function gmui_plot_histogram_normalized(values, count, width = -1, height = 120, bins = 10, font = undefined) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("plot_histogram_norm");
    var container = widget.container;
    
    var plot_width = width > 0 ? width : container.width - style.container_padding_h * 2 - container.context.indent_level;
    var plot_height = height;
    widget.width = plot_width;
    widget.height = plot_height;
    var _font = gmui_resolve_font(widget, font);
    
    if (gmui_widget_is_callable(widget) && count > 0) {
        var min_val = values[0];
        var max_val = values[0];
        for (var i = 1; i < count; i++) {
            min_val = min(min_val, values[i]);
            max_val = max(max_val, values[i]);
        }
        
        var bin_counts = array_create(bins, 0);
        var bin_range = max_val - min_val;
        if (bin_range == 0) bin_range = 1;
        
        for (var i = 0; i < count; i++) {
            var bin_index = clamp(floor((values[i] - min_val) / bin_range * bins), 0, bins - 1);
            bin_counts[bin_index]++;
        }
        
		var max_bin_count = 0;
        for (var i = 0; i < bins; i++) {
            max_bin_count = max(max_bin_count, bin_counts[i]);
        }
        if (max_bin_count == 0) max_bin_count = 1;
		
        gmui_add_rectangle(widget.x, widget.y, widget.x + plot_width, widget.y + plot_height, false, style.plot_bg_color, 1);
        gmui_add_rectangle(widget.x, widget.y, widget.x + plot_width, widget.y + plot_height, true, style.plot_border_color, 1);
        
        var bar_full_width = plot_width / bins;
        var bar_spacing = max(1, bar_full_width * 0.1);
        var bar_width = bar_full_width - bar_spacing;
        
        for (var i = 0; i < bins; i++) {
            var bx = widget.x + i * bar_full_width + bar_spacing / 2;
            
            var pct = count > 0 ? (bin_counts[i] / count) : 0;
            var bar_height = plot_height * pct;
            var by = widget.y + plot_height - bar_height;
            
			var normalized = bin_counts[i] / max_bin_count;
            var bar_color = make_color_rgb(100 + normalized * 155, 200, 100);
            
            gmui_add_rectangle(bx, by, bx + bar_width, by + bar_height, false, bar_color, 1);
            gmui_add_rectangle(bx, by, bx + bar_width, by + bar_height, true, style.plot_bar_border_color, 1);
            
            if (bar_height > 14) {
                var text = string_format(pct * 100, 1, 1) + "%";
                var text_size = gmui_calculate_text_size(text, _font);
                var tx = bx + (bar_width - text_size[0]) / 2;
                var ty = by + (bar_height - text_size[1]) / 2;
                gmui_add_text(text, tx, ty, style.plot_bar_text_color, 1, _font);
            }
        }
    }
    gmui_end_widget(widget);
    return true;
}

// scatter plot
function gmui_plot_scatter(x_values, y_values, count, width = -1, height = 120) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("plot_scatter");
    var container = widget.container;
    
    var plot_width = width > 0 ? width : container.width - style.container_padding_h * 2 - container.context.indent_level;
    var plot_height = height;
    
    widget.width = plot_width;
    widget.height = plot_height;
    
    if (gmui_widget_is_callable(widget)) {
        var min_x = x_values[0], max_x = x_values[0];
        var min_y = y_values[0], max_y = y_values[0];
        for (var i = 1; i < count; i++) {
            min_x = min(min_x, x_values[i]); max_x = max(max_x, x_values[i]);
            min_y = min(min_y, y_values[i]); max_y = max(max_y, y_values[i]);
        }
        
        var x_range = max_x - min_x; if (x_range == 0) x_range = 1;
        var y_range = max_y - min_y; if (y_range == 0) y_range = 1;
        min_x -= x_range * 0.05; max_x += x_range * 0.05;
        min_y -= y_range * 0.05; max_y += y_range * 0.05;
        
        gmui_add_rectangle(widget.x, widget.y, widget.x + plot_width, widget.y + plot_height, false, style.plot_bg_color, 1);
        gmui_add_rectangle(widget.x, widget.y, widget.x + plot_width, widget.y + plot_height, true, style.plot_border_color, 1);
        
        var point_size = 4;
        for (var i = 0; i < count; i++) {
            var px = widget.x + ((x_values[i] - min_x) / (max_x - min_x)) * plot_width;
            var py = widget.y + plot_height - ((y_values[i] - min_y) / (max_y - min_y)) * plot_height;
            gmui_add_rectangle(px - point_size / 2, py - point_size / 2, px + point_size / 2, py + point_size / 2, false, style.plot_line_color, 1);
        }
    }
    
    gmui_end_widget(widget);
    return true;
};

// stem plot
function gmui_plot_stem(values, labels, count, width = -1, height = 120, radius = 3, color = undefined, font = undefined) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("plot_stem");
    var container = widget.container;
    
    var plot_width = width > 0 ? width : container.width - style.container_padding_h * 2 - container.context.indent_level;
    var plot_height = height;
    var stem_color = color == undefined ? style.plot_line_color : color;
    
    var label_height = 0;
    if (!is_undefined(labels)) {
        label_height = gmui_calculate_text_size("W")[1] + 4;
    }
    
    widget.width = plot_width;
    widget.height = plot_height + label_height;
	
	var _font = gmui_resolve_font(widget, font);
    
    if (gmui_widget_is_callable(widget)) {
        var min_val = values[0], max_val = values[0];
        for (var i = 1; i < count; i++) {
            min_val = min(min_val, values[i]);
            max_val = max(max_val, values[i]);
        }
        if (min_val == max_val) max_val = min_val + 1;
        
        gmui_add_rectangle(widget.x - 4, widget.y - radius, widget.x + plot_width + 4, widget.y + plot_height + radius, false, style.plot_bg_color, 1);
        gmui_add_rectangle(widget.x - 4, widget.y - radius, widget.x + plot_width + 4, widget.y + plot_height + radius, true, style.plot_border_color, 1);
        
        var step = plot_width / max(count - 1, 1);
        
        for (var i = 0; i < count; i++) {
            var t = (values[i] - min_val) / (max_val - min_val);
            var sx = widget.x + i * step + step / 2;
            var sy = widget.y + plot_height - t * plot_height;
            
            gmui_add_line(sx, widget.y + plot_height, sx, sy, stem_color, 1);
            
            gmui_add_circle(sx, sy, radius, false, stem_color, 1);
            
            if (!is_undefined(labels) && i < array_length(labels)) {
                var text_size = gmui_calculate_text_size(labels[i]);
                gmui_add_text(labels[i], sx - text_size[0] / 2, widget.y + plot_height + 2, style.plot_text_color, 1, _font);
            }
        }
    }
    
    gmui_end_widget(widget);
    return true;
};

// stair plot
function gmui_plot_stair(values, count, width = -1, height = 120, mode = "post") {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("plot_stair");
    var container = widget.container;
    
    var plot_width = width > 0 ? width : container.width - style.container_padding_h * 2 - container.context.indent_level;
    var plot_height = height;
    
    widget.width = plot_width;
    widget.height = plot_height;
    
    if (gmui_widget_is_callable(widget)) {
        var min_val = values[0], max_val = values[0];
        for (var i = 1; i < count; i++) {
            min_val = min(min_val, values[i]);
            max_val = max(max_val, values[i]);
        }
        
        var range = max_val - min_val;
        if (range == 0) range = 1;
        min_val -= range * 0.1;
        max_val += range * 0.1;
        
        gmui_add_rectangle(widget.x, widget.y, widget.x + plot_width, widget.y + plot_height, false, style.plot_bg_color, 1);
        if (style.plot_border_size > 0) {
            gmui_add_rectangle(widget.x, widget.y, widget.x + plot_width, widget.y + plot_height, true, style.plot_border_color, 1);
        }
        
        if (min_val <= 0 && max_val >= 0) {
            var zy = widget.y + plot_height * (1 - (-min_val) / (max_val - min_val));
            gmui_add_line(widget.x, zy, widget.x + plot_width, zy, style.plot_grid_color, style.plot_grid_thickness);
        }
        
        if (count >= 2) {
            var inv = 1 / (count - 1);
            var prev_x = 0;
            var prev_y = 0;
            
            for (var i = 0; i < count; i++) {
                var sx = widget.x + (i * inv) * plot_width;
                var sy = widget.y + plot_height * (1 - (values[i] - min_val) / (max_val - min_val));
                
                if (i > 0) {
                    if (mode == "pre") {
                        gmui_add_line(prev_x, prev_y, sx, prev_y, style.plot_line_color, style.plot_line_thickness);
                        gmui_add_line(sx, prev_y, sx, sy, style.plot_line_color, style.plot_line_thickness);
                    } else {
                        gmui_add_line(prev_x, prev_y, prev_x, sy, style.plot_line_color, style.plot_line_thickness);
                        gmui_add_line(prev_x, sy, sx, sy, style.plot_line_color, style.plot_line_thickness);
                    }
                }
                
                prev_x = sx;
                prev_y = sy;
            }
        }
    }
    
    gmui_end_widget(widget);
    return true;
};

// pie chart
function gmui_plot_pie(values, labels, count, width = -1, height = 200, show_legend = undefined, font = undefined) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("plot_pie");
    var container = widget.container;
    
    var _font = gmui_resolve_font(widget, font);
    
    var _show_legend = (show_legend == undefined) ? style.plot_legend_enabled : show_legend;
    var has_legend = _show_legend && !is_undefined(labels) && count > 0;
    
    var plot_width = width > 0 ? width : container.width - style.container_padding_h * 2 - container.context.indent_level;
    var plot_height = height;
    
    var pie_area_width = has_legend ? floor(plot_width * 0.6) : plot_width;
    var legend_area_width = plot_width - pie_area_width;
    
    widget.width = plot_width;
    widget.height = plot_height;
    
    if (gmui_widget_is_callable(widget)) {
        var total = 0;
        for (var i = 0; i < count; i++) total += values[i];
        if (total == 0) total = 1;
        
        var cx = widget.x + pie_area_width / 2;
        var cy = widget.y + plot_height / 2;
        var radius = min(pie_area_width, plot_height) / 2 - 10;
        var inner_radius = radius * style.plot_pie_donut_ratio;
        
        gmui_add_rectangle(widget.x, widget.y, widget.x + plot_width, widget.y + plot_height, false, style.plot_bg_color, 1);
        if (style.plot_border_size > 0) {
            gmui_add_rectangle(widget.x, widget.y, widget.x + plot_width, widget.y + plot_height, true, style.plot_border_color, 1);
        }
        
        var current_angle = style.plot_pie_start_angle * pi / 180;
        
        for (var i = 0; i < count; i++) {
            var slice_percentage = values[i] / total;
            var slice_angle = 2 * pi * slice_percentage;
            
            var color_index = i % array_length(style.plot_pie_color_palette);
            var slice_color = style.plot_pie_color_palette[color_index];
            
            _gmui_draw_pie_slice(cx, cy, inner_radius, radius, current_angle, current_angle + slice_angle, slice_color);
            
            if (style.plot_pie_show_labels && (slice_percentage * 100 >= style.plot_pie_min_percentage)) {
                var mid_angle = current_angle + slice_angle / 2;
                var label_radius = radius * 0.7;
                var lx = cx + cos(mid_angle) * label_radius;
                var ly = cy - sin(mid_angle) * label_radius;
                
                var label_text = string_format(slice_percentage * 100, 1, 1) + "%";
                if (!style.plot_pie_show_percentages && !is_undefined(labels) && i < array_length(labels)) {
                    label_text = labels[i];
                }
                
                var text_size = gmui_calculate_text_size(label_text);
                
                var bg_pad = 2;
                gmui_add_rectangle(
                    lx - text_size[0] / 2 - bg_pad, ly - text_size[1] / 2 - bg_pad,
                    lx + text_size[0] / 2 + bg_pad, ly + text_size[1] / 2 + bg_pad,
                    false,
                    make_color_rgb(
                        color_get_red(style.plot_pie_label_bg_color),
                        color_get_green(style.plot_pie_label_bg_color),
                        color_get_blue(style.plot_pie_label_bg_color)
                    ),
                    style.plot_pie_label_bg_alpha
                );
                
                gmui_add_text(label_text, lx - text_size[0] / 2, ly - text_size[1] / 2, style.plot_pie_label_color, 1, _font);
            }
            
            current_angle += slice_angle;
        }
        
        if (inner_radius > 0) {
            gmui_add_circle(cx, cy, inner_radius, false, style.plot_bg_color, 1);
        }
        
        if (has_legend) {
            var legend_swatch_size = style.plot_legend_swatch_size;
            var legend_gap = style.plot_legend_gap;
            var legend_inset = style.plot_legend_inset;
            var legend_padding = style.container_padding_h;
            var legend_item_height = max(legend_swatch_size, gmui_calculate_text_size("W", _font)[1]);
            
            var legend_x = widget.x + pie_area_width;
            var legend_bg_x = legend_x + legend_inset;
            var legend_bg_w = legend_area_width - legend_inset * 2;
            var legend_bg_y = widget.y + legend_inset;
            var legend_bg_h = plot_height - legend_inset * 2;
            var legend_content_x = legend_bg_x + legend_padding;
            var legend_content_width = legend_bg_w - legend_padding * 2;
            
            gmui_add_rectangle(legend_bg_x, legend_bg_y, legend_bg_x + legend_bg_w, legend_bg_y + legend_bg_h, false, style.plot_legend_bg_color, 1);
            
            var total_legend_h = count * legend_item_height + (count - 1) * legend_gap;
            var legend_start_y = legend_bg_y + max(legend_padding, (legend_bg_h - total_legend_h) / 2);
            
            for (var i = 0; i < count; i++) {
                var item_y = legend_start_y + i * (legend_item_height + legend_gap);
                var color_index = i % array_length(style.plot_pie_color_palette);
                var swatch_color = style.plot_pie_color_palette[color_index];
                
                gmui_add_rectangle(
                    legend_content_x, item_y + (legend_item_height - legend_swatch_size) / 2,
                    legend_content_x + legend_swatch_size, item_y + (legend_item_height - legend_swatch_size) / 2 + legend_swatch_size,
                    false, swatch_color, 1
                );
                gmui_add_rectangle(
                    legend_content_x, item_y + (legend_item_height - legend_swatch_size) / 2,
                    legend_content_x + legend_swatch_size, item_y + (legend_item_height - legend_swatch_size) / 2 + legend_swatch_size,
                    true, style.plot_legend_swatch_border_color, 1
                );
                
                var display_label = labels[i];
                if (style.plot_pie_show_percentages) {
                    var pct = string_format((values[i] / total) * 100, 1, 1) + "%";
                    display_label = display_label + " (" + pct + ")";
                }
                
                var max_label_w = legend_content_width - legend_swatch_size - 6;
                var label_size = gmui_calculate_text_size(display_label, _font);
                if (label_size[0] > max_label_w) {
                    for (var len = string_length(display_label); len > 0; len--) {
                        var test = string_copy(display_label, 1, len) + "...";
                        if (gmui_calculate_text_size(test, _font)[0] <= max_label_w) {
                            display_label = test;
                            break;
                        }
                    }
                }
                
                var label_x = legend_content_x + legend_swatch_size + 6;
                var label_y = item_y + (legend_item_height - gmui_calculate_text_size(display_label, _font)[1]) / 2;
                gmui_add_text(display_label, label_x, label_y, style.plot_legend_text_color, 1, _font);
            }
        }
    }
    
    gmui_end_widget(widget);
    return true;
};

// donut chart
function gmui_plot_donut(values, labels, count, width = -1, height = 200, donut_ratio = 0.5, show_legend = undefined) {
    var style = global.gmui.style;
    var saved_ratio = style.plot_pie_donut_ratio;
    style.plot_pie_donut_ratio = donut_ratio;
    var result = gmui_plot_pie(values, labels, count, width, height, show_legend);
    style.plot_pie_donut_ratio = saved_ratio;
    return result;
};

// exploded pie chart
function gmui_plot_pie_exploded(values, labels, count, width = -1, height = 200, explode_all = false, show_legend = undefined) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("plot_pie");
    var container = widget.container;
    
    var _font = gmui_resolve_font(widget, undefined);
    
    var _show_legend = (show_legend == undefined) ? style.plot_legend_enabled : show_legend;
    var has_legend = _show_legend && !is_undefined(labels) && count > 0;
    
    var plot_width = width > 0 ? width : container.width - style.container_padding_h * 2 - container.context.indent_level;
    var plot_height = height;
    
    var pie_area_width = has_legend ? floor(plot_width * 0.6) : plot_width;
    var legend_area_width = plot_width - pie_area_width;
    
    widget.width = plot_width;
    widget.height = plot_height;
    
    if (gmui_widget_is_callable(widget)) {
        var total = 0;
        for (var i = 0; i < count; i++) total += values[i];
        if (total == 0) total = 1;
        
        var cx = widget.x + pie_area_width / 2;
        var cy = widget.y + plot_height / 2;
        var radius = min(pie_area_width, plot_height) / 2 - 20;
        var inner_radius = radius * style.plot_pie_donut_ratio;
        var explode_dist = style.plot_pie_explode_distance;
        
        gmui_add_rectangle(widget.x, widget.y, widget.x + plot_width, widget.y + plot_height, false, style.plot_bg_color, 1);
        if (style.plot_border_size > 0) {
            gmui_add_rectangle(widget.x, widget.y, widget.x + plot_width, widget.y + plot_height, true, style.plot_border_color, 1);
        }
        
        var current_angle = style.plot_pie_start_angle * pi / 180;
        
        for (var i = 0; i < count; i++) {
            var slice_percentage = values[i] / total;
            var slice_angle = 2 * pi * slice_percentage;
            
            var should_explode = explode_all || (slice_percentage >= 0.25);
            var offset = should_explode ? explode_dist : 0;
            var mid_angle = current_angle + slice_angle / 2;
            var ex = cx + cos(mid_angle) * offset;
            var ey = cy - sin(mid_angle) * offset;
            
            var color_index = i % array_length(style.plot_pie_color_palette);
            var slice_color = style.plot_pie_color_palette[color_index];
            
            _gmui_draw_pie_slice(ex, ey, inner_radius, radius, current_angle, current_angle + slice_angle, slice_color);
            
            if (style.plot_pie_show_labels && (slice_percentage * 100 >= style.plot_pie_min_percentage)) {
                var label_radius = radius * 0.7;
                var lx = ex + cos(mid_angle) * label_radius;
                var ly = ey - sin(mid_angle) * label_radius;
                
                var label_text = string_format(slice_percentage * 100, 1, 1) + "%";
                if (!style.plot_pie_show_percentages && !is_undefined(labels) && i < array_length(labels)) {
                    label_text = labels[i];
                }
                
                var text_size = gmui_calculate_text_size(label_text);
                
                var bg_pad = 2;
                gmui_add_rectangle(
                    lx - text_size[0] / 2 - bg_pad, ly - text_size[1] / 2 - bg_pad,
                    lx + text_size[0] / 2 + bg_pad, ly + text_size[1] / 2 + bg_pad,
                    false,
                    make_color_rgb(
                        color_get_red(style.plot_pie_label_bg_color),
                        color_get_green(style.plot_pie_label_bg_color),
                        color_get_blue(style.plot_pie_label_bg_color)
                    ),
                    style.plot_pie_label_bg_alpha
                );
                
                gmui_add_text(label_text, lx - text_size[0] / 2, ly - text_size[1] / 2, style.plot_pie_label_color, 1, _font);
            }
            
            current_angle += slice_angle;
        }
        
        if (has_legend) {
            var legend_swatch_size = style.plot_legend_swatch_size;
            var legend_gap = style.plot_legend_gap;
            var legend_inset = style.plot_legend_inset;
            var legend_padding = style.container_padding_h;
            var legend_item_height = max(legend_swatch_size, gmui_calculate_text_size("W", _font)[1]);
            
            var legend_x = widget.x + pie_area_width;
            var legend_bg_x = legend_x + legend_inset;
            var legend_bg_w = legend_area_width - legend_inset * 2;
            var legend_bg_y = widget.y + legend_inset;
            var legend_bg_h = plot_height - legend_inset * 2;
            var legend_content_x = legend_bg_x + legend_padding;
            var legend_content_width = legend_bg_w - legend_padding * 2;
            
            gmui_add_rectangle(legend_bg_x, legend_bg_y, legend_bg_x + legend_bg_w, legend_bg_y + legend_bg_h, false, style.plot_legend_bg_color, 1);
            
            var total_legend_h = count * legend_item_height + (count - 1) * legend_gap;
            var legend_start_y = legend_bg_y + max(legend_padding, (legend_bg_h - total_legend_h) / 2);
            
            for (var i = 0; i < count; i++) {
                var item_y = legend_start_y + i * (legend_item_height + legend_gap);
                var color_index = i % array_length(style.plot_pie_color_palette);
                var swatch_color = style.plot_pie_color_palette[color_index];
                
                gmui_add_rectangle(
                    legend_content_x, item_y + (legend_item_height - legend_swatch_size) / 2,
                    legend_content_x + legend_swatch_size, item_y + (legend_item_height - legend_swatch_size) / 2 + legend_swatch_size,
                    false, swatch_color, 1
                );
                gmui_add_rectangle(
                    legend_content_x, item_y + (legend_item_height - legend_swatch_size) / 2,
                    legend_content_x + legend_swatch_size, item_y + (legend_item_height - legend_swatch_size) / 2 + legend_swatch_size,
                    true, style.plot_legend_swatch_border_color, 1
                );
                
                var display_label = labels[i];
                if (style.plot_pie_show_percentages) {
                    var pct = string_format((values[i] / total) * 100, 1, 1) + "%";
                    display_label = display_label + " (" + pct + ")";
                }
                
                var max_label_w = legend_content_width - legend_swatch_size - 6;
                var label_size = gmui_calculate_text_size(display_label, _font);
                if (label_size[0] > max_label_w) {
                    for (var len = string_length(display_label); len > 0; len--) {
                        var test = string_copy(display_label, 1, len) + "...";
                        if (gmui_calculate_text_size(test, _font)[0] <= max_label_w) {
                            display_label = test;
                            break;
                        }
                    }
                }
                
                var label_x = legend_content_x + legend_swatch_size + 6;
                var label_y = item_y + (legend_item_height - gmui_calculate_text_size(display_label, _font)[1]) / 2;
                gmui_add_text(display_label, label_x, label_y, style.plot_legend_text_color, 1, _font);
            }
        }
    }
    
    gmui_end_widget(widget);
    return true;
};

// area chart
function gmui_plot_area(series, series_count, values_per_series, width = -1, height = 120) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("plot_area");
    var container = widget.container;
    
    var plot_width = width > 0 ? width : container.width - style.container_padding_h * 2 - container.context.indent_level;
    var plot_height = height;
    
    widget.width = plot_width;
    widget.height = plot_height;
    
    if (gmui_widget_is_callable(widget)) {
        var min_val = series[0][0], max_val = series[0][0];
        for (var s = 0; s < series_count; s++) {
            for (var i = 0; i < values_per_series; i++) {
                min_val = min(min_val, series[s][i]);
                max_val = max(max_val, series[s][i]);
            }
        }
        
        var range = max_val - min_val;
        if (range <= 0) range = 1;
        min_val -= range * 0.05;
        max_val += range * 0.05;
        
        gmui_add_rectangle(widget.x, widget.y, widget.x + plot_width, widget.y + plot_height, false, style.plot_bg_color, 1);
        if (style.plot_border_size > 0) {
            gmui_add_rectangle(widget.x, widget.y, widget.x + plot_width, widget.y + plot_height, true, style.plot_border_color, 1);
        }
        
        for (var i = 0; i <= style.plot_grid_steps; i++) {
            var gy = widget.y + plot_height - (i * plot_height / style.plot_grid_steps);
            gmui_add_line(widget.x, gy, widget.x + plot_width, gy, style.plot_grid_color, style.plot_grid_thickness);
        }
        
        if (min_val <= 0 && max_val >= 0) {
            var zy = widget.y + plot_height * (1 - (-min_val) / (max_val - min_val));
            gmui_add_line(widget.x, zy, widget.x + plot_width, zy, style.plot_grid_color, max(1, style.plot_grid_thickness));
        }
        
        for (var s = series_count - 1; s >= 0; s--) {
            var values = series[s];
            var color_index = s % array_length(style.plot_pie_color_palette);
            var series_color = style.plot_pie_color_palette[color_index];
            var alpha = 0.25 + (s / series_count) * 0.15; // TODO: add the difference into styles
            
            var fill_color = make_color_rgb(
                color_get_red(series_color),
                color_get_green(series_color),
                color_get_blue(series_color)
            );
            
            var bot = widget.y + plot_height;
            
            for (var i = 0; i < values_per_series - 1; i++) {
                var x1 = widget.x + (i * plot_width / (values_per_series - 1));
                var x2 = widget.x + ((i + 1) * plot_width / (values_per_series - 1));
                var y1 = widget.y + plot_height * (1 - (values[i] - min_val) / (max_val - min_val));
                var y2 = widget.y + plot_height * (1 - (values[i + 1] - min_val) / (max_val - min_val));
                
                gmui_add_triangle(x1, y1, x2, y2, x2, bot, fill_color, alpha);
                gmui_add_triangle(x1, y1, x2, bot, x1, bot, fill_color, alpha);
            }
            
            for (var i = 0; i < values_per_series; i++) {
                var px = widget.x + (i * plot_width / (values_per_series - 1));
                var py = widget.y + plot_height * (1 - (values[i] - min_val) / (max_val - min_val));
                
                if (i > 0) {
                    var prev_x = widget.x + ((i - 1) * plot_width / (values_per_series - 1));
                    var prev_y = widget.y + plot_height * (1 - (values[i - 1] - min_val) / (max_val - min_val));
                    gmui_add_line(prev_x, prev_y, px, py, series_color, style.plot_area_line_thickness);
                }
            }
        }
    }
    
    gmui_end_widget(widget);
    return true;
};

// stacked bar chart
function gmui_plot_stacked_bars(series, series_count, values_per_series, width = -1, height = 120) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("plot_stacked_bars");
    var container = widget.container;
    
    var plot_width = width > 0 ? width : container.width - style.container_padding_h * 2 - container.context.indent_level;
    var plot_height = height;
    
    widget.width = plot_width;
    widget.height = plot_height;
    
    if (gmui_widget_is_callable(widget)) {
        gmui_add_rectangle(widget.x, widget.y, widget.x + plot_width, widget.y + plot_height, false, style.plot_bg_color, 1);
        if (style.plot_border_size > 0) {
            gmui_add_rectangle(widget.x, widget.y, widget.x + plot_width, widget.y + plot_height, true, style.plot_border_color, 1);
        }
        
        var max_total = 0;
        for (var i = 0; i < values_per_series; i++) {
            var total = 0;
            for (var s = 0; s < series_count; s++) {
                total += series[s][i];
            }
            max_total = max(max_total, total);
        }
        if (max_total == 0) max_total = 1;
        
        var bar_full_width = plot_width / values_per_series;
        var bar_spacing = max(1, bar_full_width * 0.2);
        var bar_width = bar_full_width - bar_spacing;
        
        for (var i = 0; i < values_per_series; i++) {
            var bx = widget.x + i * bar_full_width + bar_spacing / 2;
            var stack_y = widget.y + plot_height;
            
            for (var s = 0; s < series_count; s++) {
                var value = series[s][i];
                var segment_height = (value / max_total) * plot_height;
                var sy = stack_y - segment_height;
                
                var color_index = s % array_length(style.plot_stacked_bar_colors);
                var bar_color = style.plot_stacked_bar_colors[color_index];
                
                gmui_add_rectangle(bx, sy, bx + bar_width, stack_y, false, bar_color, 1);
                gmui_add_rectangle(bx, sy, bx + bar_width, stack_y, true, style.plot_bar_border_color, 1);
                
                stack_y = sy;
            }
        }
    }
    
    gmui_end_widget(widget);
    return true;
};

// grouped bar chart
function gmui_plot_grouped_bars(series, series_count, values_per_series, width = -1, height = 120) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("plot_grouped_bars");
    var container = widget.container;
    
    var plot_width = width > 0 ? width : container.width - style.container_padding_h * 2 - container.context.indent_level;
    var plot_height = height;
    
    widget.width = plot_width;
    widget.height = plot_height;
    
    if (gmui_widget_is_callable(widget)) {
        var max_val = 0;
        for (var s = 0; s < series_count; s++) {
            for (var i = 0; i < values_per_series; i++) {
                max_val = max(max_val, series[s][i]);
            }
        }
        if (max_val == 0) max_val = 1;
        max_val *= 1.1;
        
        gmui_add_rectangle(widget.x, widget.y, widget.x + plot_width, widget.y + plot_height, false, style.plot_bg_color, 1);
        if (style.plot_border_size > 0) {
            gmui_add_rectangle(widget.x, widget.y, widget.x + plot_width, widget.y + plot_height, true, style.plot_border_color, 1);
        }
        
        for (var i = 1; i <= style.plot_grid_steps; i++) {
            var gy = widget.y + plot_height - (i * plot_height / style.plot_grid_steps);
            gmui_add_line(widget.x, gy, widget.x + plot_width, gy, style.plot_grid_color, style.plot_grid_thickness);
        }
        
        var group_width = plot_width / values_per_series;
        var group_spacing = group_width * style.plot_grouped_bar_spacing;
        var group_inner = group_width - group_spacing;
        var bar_width = (group_inner - style.plot_grouped_bar_gap * (series_count - 1)) / series_count;
        
        for (var i = 0; i < values_per_series; i++) {
            var gx = widget.x + i * group_width + group_spacing / 2;
            
            for (var s = 0; s < series_count; s++) {
                var value = series[s][i];
                var bar_height = (value / max_val) * plot_height;
                var bx = gx + s * (bar_width + style.plot_grouped_bar_gap);
                var by = widget.y + plot_height - bar_height;
                
                var color_index = s % array_length(style.plot_pie_color_palette);
                var bar_color = style.plot_pie_color_palette[color_index];
                
                gmui_add_rectangle(bx, by, bx + bar_width, by + bar_height, false, bar_color, 1);
                gmui_add_rectangle(bx, by, bx + bar_width, by + bar_height, true, style.plot_bar_border_color, 1);
            }
        }
    }
    
    gmui_end_widget(widget);
    return true;
};

// heatmap
function gmui_plot_heatmap(values, rows, cols, width = -1, height = -1, font = undefined) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("plot_heatmap");
    var container = widget.container;
    
    var cell_size = style.plot_heatmap_cell_size;
    var spacing = style.plot_heatmap_cell_spacing;
    var legend_width = style.plot_heatmap_legend_width;
    var legend_gap = style.plot_heatmap_legend_gap;
    
    var grid_width = cols * (cell_size + spacing) + spacing;
    var grid_height = rows * (cell_size + spacing) + spacing;
    var plot_width = width > 0 ? width : grid_width + legend_width + legend_gap;
    var plot_height = height > 0 ? height : max(grid_height, 100);
    
    widget.width = plot_width;
    widget.height = plot_height;
	
	var _font = gmui_resolve_font(widget, font);
    
    if (gmui_widget_is_callable(widget)) {
        var min_val = values[0][0], max_val = values[0][0];
        for (var r = 0; r < rows; r++) {
            for (var c = 0; c < cols; c++) {
                min_val = min(min_val, values[r][c]);
                max_val = max(max_val, values[r][c]);
            }
        }
        
        var range = max_val - min_val;
        if (range == 0) range = 1;
        
        gmui_add_rectangle(widget.x, widget.y, widget.x + plot_width, widget.y + plot_height, false, style.plot_bg_color, 1);
        
        for (var r = 0; r < rows; r++) {
            for (var c = 0; c < cols; c++) {
                var cx = widget.x + spacing + c * (cell_size + spacing);
                var cy = widget.y + spacing + r * (cell_size + spacing);
                
                var t = (values[r][c] - min_val) / range;
                var cell_color = _gmui_lerp_color_gradient(style.plot_heatmap_gradient, t);
                
                gmui_add_rectangle(cx, cy, cx + cell_size, cy + cell_size, false, cell_color, 1);
                
                if (style.plot_heatmap_show_values) {
                    var text = string_format(values[r][c], 1, 1);
                    var text_size = gmui_calculate_text_size(text);
                    var tx = cx + (cell_size - text_size[0]) / 2;
                    var ty = cy + (cell_size - text_size[1]) / 2;
                    var text_color = t > 0.5 ? make_color_rgb(0, 0, 0) : style.plot_heatmap_text_color;
                    gmui_add_text(text, tx, ty, text_color, 1, _font);
                }
            }
        }
        
        var legend_x = widget.x + grid_width + legend_gap;
        var legend_y = widget.y + spacing;
        var legend_height = grid_height - spacing * 2;
        
        var legend_steps = 32;
        var step_h = legend_height / legend_steps;
        for (var i = 0; i < legend_steps; i++) {
            var t = 1 - (i / legend_steps); // top = hot, bottom = cold
            var step_color = _gmui_lerp_color_gradient(style.plot_heatmap_gradient, t);
            var sy = legend_y + i * step_h;
            gmui_add_rectangle(legend_x, sy, legend_x + legend_width, sy + step_h + 1, false, step_color, 1);
        }
        
        gmui_add_rectangle(legend_x, legend_y, legend_x + legend_width, legend_y + legend_height, true, style.plot_border_color, 1);
        
        var tick_count = style.plot_heatmap_legend_tick_count;
        for (var i = 0; i <= tick_count; i++) {
            var t = i / tick_count;
            var tick_val = min_val + t * range;
            var tick_y = legend_y + legend_height - t * legend_height;
            
            gmui_add_line(legend_x + legend_width, tick_y, legend_x + legend_width + 4, tick_y, style.plot_heatmap_legend_text_color, 1);
            
            var tick_text = string_format(tick_val, 1, 1);
            var text_size = gmui_calculate_text_size(tick_text);
            gmui_add_text(tick_text, legend_x + legend_width + 6, tick_y - text_size[1] / 2, style.plot_heatmap_legend_text_color, 1, _font);
        }
    }
    
    gmui_end_widget(widget);
    return true;
};

// radar chart
function gmui_plot_radar(series, series_count, values_per_series, labels, size = 200, font = undefined) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("plot_radar");
    var container = widget.container;
    
    var plot_size = size;
    
    widget.width = plot_size;
    widget.height = plot_size;
	
	var _font = gmui_resolve_font(widget, font);
    
    if (gmui_widget_is_callable(widget)) {
        var cx = widget.x + plot_size / 2;
        var cy = widget.y + plot_size / 2;
        var radius = plot_size / 2 - 30;
        var angle_step = (2 * pi) / values_per_series;
        var start_angle = -pi / 2;
        
        var max_val = 0;
        for (var s = 0; s < series_count; s++) {
            for (var i = 0; i < values_per_series; i++) {
                max_val = max(max_val, series[s][i]);
            }
        }
        if (max_val == 0) max_val = 1;
        
        gmui_add_rectangle(widget.x, widget.y, widget.x + plot_size, widget.y + plot_size, false, style.plot_bg_color, 1);
        
        for (var level = 1; level <= style.plot_radar_grid_levels; level++) {
            var grid_radius = radius * (level / style.plot_radar_grid_levels);
            
            for (var i = 0; i < values_per_series; i++) {
                var a1 = start_angle + i * angle_step;
                var a2 = start_angle + (i + 1) * angle_step;
                
                var x1 = cx + cos(a1) * grid_radius;
                var y1 = cy + sin(a1) * grid_radius;
                var x2 = cx + cos(a2) * grid_radius;
                var y2 = cy + sin(a2) * grid_radius;
                
                gmui_add_line(x1, y1, x2, y2, style.plot_radar_grid_color, 1);
            }
        }
        
        for (var i = 0; i < values_per_series; i++) {
            var angle = start_angle + i * angle_step;
            var ax = cx + cos(angle) * radius;
            var ay = cy + sin(angle) * radius;
            
            gmui_add_line(cx, cy, ax, ay, style.plot_radar_axis_color, 1);
            
            if (i < array_length(labels)) {
                var label_radius = radius + style.plot_radar_label_offset;
                var lx = cx + cos(angle) * label_radius;
                var ly = cy + sin(angle) * label_radius;
                var text_size = gmui_calculate_text_size(labels[i]);
                
                var tx = lx - text_size[0] / 2;
                var ty = ly - text_size[1] / 2;
                
                gmui_add_text(labels[i], tx, ty, style.plot_text_color, 1, _font);
            }
        }
        
        for (var s = series_count - 1; s >= 0; s--) {
            var values = series[s];
            var color_index = s % array_length(style.plot_pie_color_palette);
            var series_color = style.plot_pie_color_palette[color_index];
            
            var fill_color = make_color_rgb(
                color_get_red(series_color),
                color_get_green(series_color),
                color_get_blue(series_color)
            );
            
            var points = [];
            for (var i = 0; i < values_per_series; i++) {
                var angle = start_angle + i * angle_step;
                var dist = radius * (values[i] / max_val);
                var px = cx + cos(angle) * dist;
                var py = cy + sin(angle) * dist;
                array_push(points, [px, py]);
            }
            
            for (var i = 1; i < array_length(points) - 1; i++) {
                gmui_add_triangle(
                    points[0][0], points[0][1],
                    points[i][0], points[i][1],
                    points[i + 1][0], points[i + 1][1],
                    fill_color, style.plot_radar_fill_alpha
                );
            }
            
            for (var i = 0; i < array_length(points); i++) {
                var next = (i + 1) % array_length(points);
                gmui_add_line(
                    points[i][0], points[i][1],
                    points[next][0], points[next][1],
                    series_color, style.plot_radar_line_thickness
                );
            }
            
            for (var i = 0; i < array_length(points); i++) {
                var ps = style.plot_radar_point_size;
                gmui_add_rectangle(
                    points[i][0] - ps / 2, points[i][1] - ps / 2,
                    points[i][0] + ps / 2, points[i][1] + ps / 2,
                    false, series_color, 1
                );
            }
        }
    }
    
    gmui_end_widget(widget);
    return true;
};

// box plot
function gmui_plot_box(datasets, dataset_count, labels, width = -1, height = 200, font = undefined) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("plot_box");
    var container = widget.container;
    
    var plot_width = width > 0 ? width : container.width - style.container_padding_h * 2 - container.context.indent_level;
    var plot_height = height;
	
	var label_height = 0;
	if (!is_undefined(labels)) {
	    label_height = gmui_calculate_text_size("W")[1] + 6;
	}
    
    widget.width = plot_width;
    widget.height = plot_height + label_height;
	
	var _font = gmui_resolve_font(widget, font);
    
    if (gmui_widget_is_callable(widget)) {
        var global_min = infinity;
        var global_max = -infinity;
        for (var d = 0; d < dataset_count; d++) {
            var values = datasets[d];
            for (var i = 0; i < array_length(values); i++) {
                global_min = min(global_min, values[i]);
                global_max = max(global_max, values[i]);
            }
        }
        
        var range = global_max - global_min;
        if (range == 0) range = 1;
        global_min -= range * 0.05;
        global_max += range * 0.05;
        
        gmui_add_rectangle(widget.x, widget.y, widget.x + plot_width, widget.y + plot_height, false, style.plot_bg_color, 1);
        if (style.plot_border_size > 0) {
            gmui_add_rectangle(widget.x, widget.y, widget.x + plot_width, widget.y + plot_height, true, style.plot_border_color, 1);
        }
        
        for (var i = 1; i <= style.plot_grid_steps; i++) {
            var gy = widget.y + plot_height - (i * plot_height / style.plot_grid_steps);
            gmui_add_line(widget.x, gy, widget.x + plot_width, gy, style.plot_grid_color, style.plot_grid_thickness);
        }
        
        var spacing = plot_width / dataset_count;
        
        for (var d = 0; d < dataset_count; d++) {
            var quartiles = _gmui_quartiles(datasets[d]);
            var actual_low = quartiles[0];
            var q1 = quartiles[1];
            var _median = quartiles[2];
            var q3 = quartiles[3];
            var actual_high = quartiles[4];
            var outliers = quartiles[5];
            
            var cx = widget.x + spacing * d + spacing / 2;
            var box_width = style.plot_box_width;
            var bx = cx - box_width / 2;
            
            var y_low = widget.y + plot_height * (1 - (actual_low - global_min) / (global_max - global_min));
            var y_q1 = widget.y + plot_height * (1 - (q1 - global_min) / (global_max - global_min));
            var y_med = widget.y + plot_height * (1 - (_median - global_min) / (global_max - global_min));
            var y_q3 = widget.y + plot_height * (1 - (q3 - global_min) / (global_max - global_min));
            var y_high = widget.y + plot_height * (1 - (actual_high - global_min) / (global_max - global_min));
            
            var color_index = d % array_length(style.plot_pie_color_palette);
            var box_color = style.plot_pie_color_palette[color_index];
            
            gmui_add_line(cx, y_low, cx, y_q1, style.plot_box_whisker_color, style.plot_box_line_thickness);
            gmui_add_line(cx, y_q3, cx, y_high, style.plot_box_whisker_color, style.plot_box_line_thickness);
            
            var cap_width = box_width / 2;
            gmui_add_line(cx - cap_width, y_low, cx + cap_width, y_low, style.plot_box_whisker_color, style.plot_box_line_thickness);
            gmui_add_line(cx - cap_width, y_high, cx + cap_width, y_high, style.plot_box_whisker_color, style.plot_box_line_thickness);
            
            gmui_add_rectangle(bx, y_q3, bx + box_width, y_q1, false, box_color, 1);
            gmui_add_rectangle(bx, y_q3, bx + box_width, y_q1, true, style.plot_bar_border_color, 1);
            
            gmui_add_line(bx, y_med, bx + box_width, y_med, style.plot_box_median_color, max(1, style.plot_box_line_thickness + 1));
            
            if (style.plot_box_show_outliers) {
                for (var o = 0; o < array_length(outliers); o++) {
                    var oy = widget.y + plot_height * (1 - (outliers[o] - global_min) / (global_max - global_min));
                    var os = style.plot_box_outlier_size;
                    gmui_add_rectangle(cx - os / 2, oy - os / 2, cx + os / 2, oy + os / 2, false, style.plot_box_outlier_color, 1);
                }
            }
            
            if (d < array_length(labels)) {
                var text_size = gmui_calculate_text_size(labels[d]);
                var tx = cx - text_size[0] / 2;
                var ty = widget.y + plot_height + 4;
                gmui_add_text(labels[d], tx, ty, style.plot_text_color, 1, _font);
            }
        }
    }
    
    gmui_end_widget(widget);
    return true;
};

// funnel chart
function gmui_plot_funnel(values, labels, count, width = -1, height = 200, font = undefined) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("plot_funnel");
    var container = widget.container;
    
    var plot_width = width > 0 ? width : container.width - style.container_padding_h * 2 - container.context.indent_level;
    var plot_height = height;
    
    widget.width = plot_width;
    widget.height = plot_height;
	
	var _font = gmui_resolve_font(widget, font);
    
    if (gmui_widget_is_callable(widget)) {
        var max_val = values[0];
        for (var i = 1; i < count; i++) max_val = max(max_val, values[i]);
        if (max_val == 0) max_val = 1;
        
        var total_height = plot_height - 10;
        var segment_height = total_height / count;
        var gap = style.plot_funnel_gap;
        var usable_height = segment_height - gap;
        
        gmui_add_rectangle(widget.x, widget.y, widget.x + plot_width, widget.y + plot_height, false, style.plot_bg_color, 1);
        
        for (var i = 0; i < count; i++) {
            var ratio = values[i] / max_val;
            var seg_width = plot_width * ratio;
            var sx = widget.x + (plot_width - seg_width) / 2;
            var sy = widget.y + 5 + i * segment_height;
            
            var color_index = i % array_length(style.plot_pie_color_palette);
            var seg_color = style.plot_pie_color_palette[color_index];
            
            var top_width = (i == 0) ? seg_width : (plot_width * (values[i - 1] / max_val));
            var top_sx = widget.x + (plot_width - top_width) / 2;
            
            if (i > 0) {
                var prev_width = plot_width * (values[i - 1] / max_val);
                var prev_sx = widget.x + (plot_width - prev_width) / 2;
                var prev_sy = sy;
                
                gmui_add_rectangle(sx, sy, sx + seg_width, sy + usable_height, false, seg_color, 1);
                gmui_add_rectangle(sx, sy, sx + seg_width, sy + usable_height, true, style.plot_funnel_border_color, 1);
                
                if (prev_sx > sx) {
                    gmui_add_triangle(prev_sx, prev_sy, sx, sy, prev_sx, sy, seg_color);
                } else if (sx > prev_sx) {
                    gmui_add_triangle(sx, prev_sy, prev_sx, prev_sy, sx, sy, seg_color);
                }
                
                var prev_right = prev_sx + prev_width;
                var seg_right = sx + seg_width;
                if (prev_right < seg_right) {
                    gmui_add_triangle(prev_right, prev_sy, seg_right, sy, prev_right, sy, seg_color);
                } else if (seg_right < prev_right) {
                    gmui_add_triangle(seg_right, prev_sy, prev_right, prev_sy, seg_right, sy, seg_color);
                }
            } else {
                gmui_add_rectangle(sx, sy, sx + seg_width, sy + usable_height, false, seg_color, 1);
                gmui_add_rectangle(sx, sy, sx + seg_width, sy + usable_height, true, style.plot_funnel_border_color, 1);
            }
            
            if (style.plot_funnel_show_values) {
                var text = is_undefined(labels) || i >= array_length(labels) ? "" : labels[i] + ": ";
                text += string_format(values[i], 1, 0);
                var text_size = gmui_calculate_text_size(text);
                var tx = widget.x + (plot_width - text_size[0]) / 2;
                var ty = sy + (usable_height - text_size[1]) / 2;
                gmui_add_text(text, tx, ty, style.plot_funnel_text_color, 1, _font);
            }
        }
    }
    
    gmui_end_widget(widget);
    return true;
};

// waterfall chart
function gmui_plot_waterfall(values, labels, count, width = -1, height = 200, font = undefined) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("plot_waterfall");
    var container = widget.container;
    
    var plot_width = width > 0 ? width : container.width - style.container_padding_h * 2 - container.context.indent_level;
    var plot_height = height;
	
	var label_height = 0;
	if (!is_undefined(labels)) {
	    label_height = gmui_calculate_text_size("W")[1] + 6;
	}
    
    widget.width = plot_width;
    widget.height = plot_height + label_height;
	
	var _font = gmui_resolve_font(widget, font);
    
    if (gmui_widget_is_callable(widget)) {
        var running = 0;
        var totals = array_create(count, 0);
        for (var i = 0; i < count; i++) {
            totals[i] = running;
            running += values[i];
        }
        
        var min_val = 0, max_val = 0;
        var cum = 0;
        for (var i = 0; i < count; i++) {
            cum += values[i];
            min_val = min(min_val, cum);
            max_val = max(max_val, cum);
            
            var bar_top = max(totals[i], totals[i] + values[i]);
            max_val = max(max_val, bar_top);
        }
        
        max_val *= 1.1;
        min_val *= min_val < 0 ? 1.1 : 0.9;
        var range = max_val - min_val;
        if (range == 0) range = 1;
        
        gmui_add_rectangle(widget.x, widget.y, widget.x + plot_width, widget.y + plot_height, false, style.plot_bg_color, 1);
        if (style.plot_border_size > 0) {
            gmui_add_rectangle(widget.x, widget.y, widget.x + plot_width, widget.y + plot_height, true, style.plot_border_color, 1);
        }
        
        var zy = widget.y + plot_height * (1 - (0 - min_val) / range);
        gmui_add_line(widget.x, zy, widget.x + plot_width, zy, style.plot_grid_color, style.plot_grid_thickness);
        
        for (var i = 1; i <= style.plot_grid_steps; i++) {
            var gy = widget.y + plot_height - (i * plot_height / style.plot_grid_steps);
            gmui_add_line(widget.x, gy, widget.x + plot_width, gy, style.plot_grid_color, style.plot_grid_thickness);
        }
        
        var bar_full_width = plot_width / count;
        var bar_spacing = max(1, bar_full_width * 0.3);
        var bar_width = bar_full_width - bar_spacing;
        
        for (var i = 0; i < count; i++) {
            var bx = widget.x + i * bar_full_width + bar_spacing / 2;
            var base = totals[i];
            var change = values[i];
            
            var bar_bottom = base;
            var bar_top = base + change;
            
            var y_bottom = widget.y + plot_height * (1 - (bar_bottom - min_val) / range);
            var y_top = widget.y + plot_height * (1 - (bar_top - min_val) / range);
            
            var bar_y = min(y_bottom, y_top);
            var bar_h = abs(y_top - y_bottom);
            
            var bar_color = change >= 0 ? style.plot_waterfall_increase_color : style.plot_waterfall_decrease_color;
            if (i == count - 1) bar_color = style.plot_waterfall_total_color;
            
            gmui_add_rectangle(bx, bar_y, bx + bar_width, bar_y + bar_h, false, bar_color, 1);
            gmui_add_rectangle(bx, bar_y, bx + bar_width, bar_y + bar_h, true, style.plot_bar_border_color, 1);
            
            if (i > 0) {
                var prev_base = totals[i - 1];
                var prev_change = values[i - 1];
                var prev_top = prev_base + prev_change;
                var prev_y = widget.y + plot_height * (1 - (prev_top - min_val) / range);
                var conn_y = widget.y + plot_height * (1 - (base - min_val) / range);
                
                var prev_bx = widget.x + (i - 1) * bar_full_width + bar_spacing / 2 + bar_width;
                gmui_add_line(prev_bx, prev_y, bx, conn_y, style.plot_waterfall_connector_color, style.plot_waterfall_connector_thickness);
            }
            
            if (i < array_length(labels)) {
                var text_size = gmui_calculate_text_size(labels[i]);
                var tx = bx + (bar_width - text_size[0]) / 2;
                var ty = widget.y + plot_height + 4;
                gmui_add_text(labels[i], tx, ty, style.plot_text_color, 1, _font);
            }
            
            var value_text = string_format(change, 1, 0);
            var val_size = gmui_calculate_text_size(value_text);
            if (bar_h > val_size[1] + 4) {
                var vx = bx + (bar_width - val_size[0]) / 2;
                var vy = (y_top < y_bottom) ? y_top + 2 : y_bottom + 2;
                gmui_add_text(value_text, vx, vy, make_color_rgb(255, 255, 255), 1, _font);
            }
        }
    }
    
    gmui_end_widget(widget);
    return true;
};

// bubble chart
function gmui_plot_bubble(x_values, y_values, size_values, count, width = -1, height = 200) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("plot_bubble");
    var container = widget.container;
    
    var plot_width = width > 0 ? width : container.width - style.container_padding_h * 2 - container.context.indent_level;
    var plot_height = height;
    
    widget.width = plot_width;
    widget.height = plot_height;
    
    if (gmui_widget_is_callable(widget)) {
        var min_x = x_values[0], max_x = x_values[0];
        var min_y = y_values[0], max_y = y_values[0];
        var min_s = size_values[0], max_s = size_values[0];
        
        for (var i = 1; i < count; i++) {
            min_x = min(min_x, x_values[i]); max_x = max(max_x, x_values[i]);
            min_y = min(min_y, y_values[i]); max_y = max(max_y, y_values[i]);
            min_s = min(min_s, size_values[i]); max_s = max(max_s, size_values[i]);
        }
        
        var x_range = max_x - min_x; if (x_range == 0) x_range = 1;
        var y_range = max_y - min_y; if (y_range == 0) y_range = 1;
        var s_range = max_s - min_s; if (s_range == 0) s_range = 1;
        
        min_x -= x_range * 0.1; max_x += x_range * 0.1;
        min_y -= y_range * 0.1; max_y += y_range * 0.1;
        
        gmui_add_rectangle(widget.x, widget.y, widget.x + plot_width, widget.y + plot_height, false, style.plot_bg_color, 1);
        if (style.plot_border_size > 0) {
            gmui_add_rectangle(widget.x, widget.y, widget.x + plot_width, widget.y + plot_height, true, style.plot_border_color, 1);
        }
        
        for (var i = 1; i <= style.plot_grid_steps; i++) {
            var gy = widget.y + (i * plot_height / style.plot_grid_steps);
            gmui_add_line(widget.x, gy, widget.x + plot_width, gy, style.plot_grid_color, style.plot_grid_thickness);
            
            var gx = widget.x + (i * plot_width / style.plot_grid_steps);
            gmui_add_line(gx, widget.y, gx, widget.y + plot_height, style.plot_grid_color, style.plot_grid_thickness);
        }
        
        var indices = array_create(count);
		for (var i = 0; i < count; i++) indices[i] = i;

		for (var i = 0; i < count - 1; i++) {
		    for (var j = i + 1; j < count; j++) {
		        if (size_values[indices[i]] < size_values[indices[j]]) {
		            var temp = indices[i];
		            indices[i] = indices[j];
		            indices[j] = temp;
		        }
		    }
		}
        
        for (var j = 0; j < count; j++) {
            var i = indices[j];
            
            var bx = widget.x + ((x_values[i] - min_x) / (max_x - min_x)) * plot_width;
            var by = widget.y + plot_height - ((y_values[i] - min_y) / (max_y - min_y)) * plot_height;
            
            var size_ratio = (size_values[i] - min_s) / s_range;
            var radius = lerp(style.plot_bubble_min_size, style.plot_bubble_max_size, size_ratio) / 2;
            
            var color_index = i % array_length(style.plot_pie_color_palette);
            var bubble_color = style.plot_pie_color_palette[color_index];
            
            var fill_color = make_color_rgb(
                color_get_red(bubble_color),
                color_get_green(bubble_color),
                color_get_blue(bubble_color)
            );
            
            var seg = 24;
            for (var s = 0; s < seg; s++) {
                var a1 = s * 2 * pi / seg;
                var a2 = (s + 1) * 2 * pi / seg;
                
                var x1 = bx + cos(a1) * radius;
                var y1 = by - sin(a1) * radius;
                var x2 = bx + cos(a2) * radius;
                var y2 = by - sin(a2) * radius;
                
                gmui_add_triangle(bx, by, x1, y1, x2, y2, fill_color, style.plot_bubble_alpha);
            }
            
            gmui_add_circle(bx, by, radius, true, style.plot_bubble_border_color, 1);
        }
    }
    
    gmui_end_widget(widget);
    return true;
};

// gantt chart
function gmui_plot_gantt(tasks, task_count, start_times, end_times, colors, _today, width = -1, font = undefined) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("plot_gantt");
    var container = widget.container;
    
    var plot_width = width > 0 ? width : container.width - style.container_padding_h * 2 - container.context.indent_level;
    var bar_height = style.plot_gantt_bar_height;
    var bar_spacing = style.plot_gantt_bar_spacing;
    var row_height = bar_height + bar_spacing;
    var label_width = style.plot_gantt_row_label_width;
    var chart_width = plot_width - label_width;
    
    var min_time = start_times[0], max_time = end_times[0];
    for (var i = 1; i < task_count; i++) {
        min_time = min(min_time, start_times[i]);
        max_time = max(max_time, end_times[i]);
    }
    
    var time_range = max_time - min_time;
    if (time_range == 0) time_range = 1;
    min_time -= time_range * 0.02;
	if (min_time < 0 && start_times[0] >= 0) min_time = 0;
    max_time += time_range * 0.02;
    
    var header_height = style.plot_gantt_header_height;
    var plot_height = header_height + task_count * row_height + bar_spacing;
    
    widget.width = plot_width;
    widget.height = plot_height;
	
	var _font = gmui_resolve_font(widget, font);
    
    if (gmui_widget_is_callable(widget)) {
        gmui_add_rectangle(widget.x, widget.y, widget.x + plot_width, widget.y + plot_height, false, style.plot_bg_color, 1);
        
        var header_x = widget.x + label_width;
        gmui_add_rectangle(header_x, widget.y, header_x + chart_width, widget.y + header_height, false, style.plot_gantt_header_color, 1);
        
        var marker_count = min(5, max(2, floor(chart_width / 60)));
        for (var m = 0; m <= marker_count; m++) {
            var mx = header_x + (m * chart_width / marker_count);
            var time_val = min_time + (m * time_range / marker_count);
            var time_text = string_format(time_val, 1, 0);
            var text_size = gmui_calculate_text_size(time_text);
            
            gmui_add_text(time_text, mx - text_size[0] / 2, widget.y + (header_height - text_size[1]) / 2, style.plot_gantt_header_text_color, 1, _font);
            
            if (m > 0 && m < marker_count) {
                gmui_add_line(mx, widget.y + header_height, mx, widget.y + plot_height, style.plot_grid_color, style.plot_grid_thickness);
            }
        }
        
        var today = _today;
        if (today >= min_time && today <= max_time) {
            var today_x = header_x + ((today - min_time) / (max_time - min_time)) * chart_width;
            gmui_add_line(today_x, widget.y + header_height, today_x, widget.y + plot_height, make_color_rgb(255, 100, 100), 2);
        }
        
        for (var i = 0; i < task_count; i++) {
            var ry = widget.y + header_height + bar_spacing + i * row_height;
            
            if (i < array_length(tasks)) {
                var text_size = gmui_calculate_text_size(tasks[i]);
                var tx = widget.x + label_width - text_size[0] - 4;
                var ty = ry + (bar_height - text_size[1]) / 2;
                gmui_add_text(tasks[i], tx, ty, style.plot_text_color, 1, _font);
            }
            
            var bx = header_x + ((start_times[i] - min_time) / (max_time - min_time)) * chart_width;
            var bw = ((end_times[i] - start_times[i]) / time_range) * chart_width;
            bw = max(bw, 2);
            
            var bar_color = style.plot_bar_color;
            if (!is_undefined(colors) && i < array_length(colors)) {
                bar_color = colors[i];
            } else {
                var color_index = i % array_length(style.plot_pie_color_palette);
                bar_color = style.plot_pie_color_palette[color_index];
            }
            
            gmui_add_rectangle(bx, ry, bx + bw, ry + bar_height, false, bar_color, 1);
            gmui_add_rectangle(bx, ry, bx + bw, ry + bar_height, true, style.plot_bar_border_color, 1);
        }
    }
    
    gmui_end_widget(widget);
    return true;
};

// error bars
function gmui_plot_error_bars(x_values, y_values, low_values, high_values, count, width = -1, height = 200) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("plot_error_bars");
    var container = widget.container;
    
    var plot_width = width > 0 ? width : container.width - style.container_padding_h * 2 - container.context.indent_level;
    var plot_height = height;
    
    widget.width = plot_width;
    widget.height = plot_height;
    
    if (gmui_widget_is_callable(widget)) {
        var min_x = x_values[0], max_x = x_values[0];
        var min_y = low_values[0], max_y = high_values[0];
        
        for (var i = 1; i < count; i++) {
            min_x = min(min_x, x_values[i]); max_x = max(max_x, x_values[i]);
            min_y = min(min_y, low_values[i]); max_y = max(max_y, high_values[i]);
        }
        
        var x_range = max_x - min_x; if (x_range == 0) x_range = 1;
        var y_range = max_y - min_y; if (y_range == 0) y_range = 1;
        min_x -= x_range * 0.1; max_x += x_range * 0.1;
        min_y -= y_range * 0.1; max_y += y_range * 0.1;
        
        gmui_add_rectangle(widget.x, widget.y, widget.x + plot_width, widget.y + plot_height, false, style.plot_bg_color, 1);
        if (style.plot_border_size > 0) {
            gmui_add_rectangle(widget.x, widget.y, widget.x + plot_width, widget.y + plot_height, true, style.plot_border_color, 1);
        }
        
        for (var i = 1; i <= style.plot_grid_steps; i++) {
            var gy = widget.y + (i * plot_height / style.plot_grid_steps);
            gmui_add_line(widget.x, gy, widget.x + plot_width, gy, style.plot_grid_color, style.plot_grid_thickness);
        }
        
        var cap_width = style.plot_error_cap_width;
        
        for (var i = 0; i < count; i++) {
            var ex = widget.x + ((x_values[i] - min_x) / (max_x - min_x)) * plot_width;
            var ey_low = widget.y + plot_height - ((low_values[i] - min_y) / (max_y - min_y)) * plot_height;
            var ey_mid = widget.y + plot_height - ((y_values[i] - min_y) / (max_y - min_y)) * plot_height;
            var ey_high = widget.y + plot_height - ((high_values[i] - min_y) / (max_y - min_y)) * plot_height;
            
            var color_index = i % array_length(style.plot_pie_color_palette);
            var err_color = style.plot_pie_color_palette[color_index];
            
            gmui_add_line(ex, ey_low, ex, ey_high, err_color, style.plot_error_thickness);
            
            gmui_add_line(ex - cap_width / 2, ey_low, ex + cap_width / 2, ey_low, err_color, style.plot_error_thickness);
            
            gmui_add_line(ex - cap_width / 2, ey_high, ex + cap_width / 2, ey_high, err_color, style.plot_error_thickness);
            
            var dot_size = 4;
            gmui_add_rectangle(ex - dot_size / 2, ey_mid - dot_size / 2, ex + dot_size / 2, ey_mid + dot_size / 2, false, err_color, 1);
        }
    }
    
    gmui_end_widget(widget);
    return true;
};

// gauge
function gmui_plot_gauge(value, min_val, max_val, label = "", size = -1, font = undefined) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("plot_gauge");
    
    var gauge_size = size > 0 ? size : style.plot_gauge_size;
    var thickness = style.plot_gauge_thickness;
    var radius = gauge_size / 2;
    var inner_radius = radius - thickness;
    
    widget.width = gauge_size;
    widget.height = gauge_size;
	
	var _font = gmui_resolve_font(widget, font);
    
    if (gmui_widget_is_callable(widget)) {
        var cx = widget.x + radius;
        var cy = widget.y + radius;
        
        var normalized = clamp((value - min_val) / (max_val - min_val), 0, 1);
        var start_angle = style.plot_gauge_start_angle * pi / 180;
        var sweep_angle = style.plot_gauge_sweep_angle * pi / 180;
        var fill_angle = start_angle + sweep_angle * normalized;
        
        _gmui_draw_arc(cx, cy, inner_radius, radius, start_angle, start_angle + sweep_angle, style.plot_gauge_empty_color, 32);
        
        if (normalized > 0) {
            _gmui_draw_arc(cx, cy, inner_radius, radius, start_angle, fill_angle, style.plot_gauge_fill_color, 32);
        }
        
        if (style.plot_gauge_show_ticks) {
            var tick_count = style.plot_gauge_tick_count;
            for (var i = 0; i <= tick_count; i++) {
                var t = i / tick_count;
                var angle = start_angle + sweep_angle * t;
                var tx1 = cx + cos(angle) * (inner_radius - 4);
                var ty1 = cy - sin(angle) * (inner_radius - 4);
                var tx2 = cx + cos(angle) * (inner_radius - 10);
                var ty2 = cy - sin(angle) * (inner_radius - 10);
                
                gmui_add_line(tx1, ty1, tx2, ty2, style.plot_gauge_tick_color, 1);
                
                var tick_val = min_val + t * (max_val - min_val);
                var tick_text = string_format(tick_val, 1, 0);
                var text_size = gmui_calculate_text_size(tick_text);
                var lx = cx + cos(angle) * (inner_radius - 16) - text_size[0] / 2;
                var ly = cy - sin(angle) * (inner_radius - 16) - text_size[1] / 2;
                gmui_add_text(tick_text, lx, ly, style.plot_gauge_label_color, 1, _font);
            }
        }
        
        var needle_angle = start_angle + sweep_angle * normalized;
        var nx = cx + cos(needle_angle) * (inner_radius * 0.8);
        var ny = cy - sin(needle_angle) * (inner_radius * 0.8);
        
        gmui_add_line(cx, cy, nx, ny, style.plot_gauge_needle_color, style.plot_gauge_needle_thickness);
        
        gmui_add_circle(cx, cy, thickness / 3, false, style.plot_gauge_needle_color, 1);
        
        var value_text = string_format(value, 1, 1);
        var val_size = gmui_calculate_text_size(value_text);
        var vx = cx - val_size[0] / 2;
        var vy = cy + thickness / 2 + 4;
        gmui_add_text(value_text, vx, vy, style.plot_gauge_text_color, 1, _font);
        
        if (label != "") {
            var label_size = gmui_calculate_text_size(label);
            var lx = cx - label_size[0] / 2;
            var ly = cy + thickness / 2 + val_size[1] + 6;
            gmui_add_text(label, lx, ly, style.plot_gauge_label_color, 1, _font);
        }
    }
    
    gmui_end_widget(widget);
    return value;
};

// table plot
function gmui_plot_table(headers, data, rows, cols, width = -1, font = undefined) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("plot_table");
    var container = widget.container;
    
    var plot_width = width > 0 ? width : container.width - style.container_padding_h * 2 - container.context.indent_level;
    var header_height = style.plot_table_header_height;
    var row_height = style.plot_table_row_height;
    var plot_height = header_height + rows * row_height;
    
    widget.width = plot_width;
    widget.height = plot_height;
	
	var _font = gmui_resolve_font(widget, font);
    
    if (gmui_widget_is_callable(widget)) {
        var col_width = plot_width / cols;
        
        gmui_add_rectangle(widget.x, widget.y, widget.x + plot_width, widget.y + header_height, false, style.plot_table_header_bg, 1);
        
        for (var c = 0; c < cols; c++) {
            var hx = widget.x + c * col_width + style.plot_table_cell_padding_h;
            var hy = widget.y + (header_height - gmui_calculate_text_size(headers[c])[1]) / 2;
            gmui_add_text(headers[c], hx, hy, style.plot_table_header_text_color, 1, _font);
            
            if (c > 0) {
                var sx = widget.x + c * col_width;
                gmui_add_line(sx, widget.y, sx, widget.y + plot_height, style.plot_table_border_color, style.plot_table_border_size);
            }
        }
        
        for (var r = 0; r < rows; r++) {
            var ry = widget.y + header_height + r * row_height;
            var bg_color = (r % 2 == 0) ? style.plot_table_row_bg : style.plot_table_row_alt_bg;
            
            gmui_add_rectangle(widget.x, ry, widget.x + plot_width, ry + row_height, false, bg_color, 1);
            
            for (var c = 0; c < cols; c++) {
                var cell_text = string(data[r][c]);
                var text_size = gmui_calculate_text_size(cell_text);
                var cx = widget.x + c * col_width + style.plot_table_cell_padding_h;
                var cy = ry + (row_height - text_size[1]) / 2;
                
                var max_width = col_width - style.plot_table_cell_padding_h * 2;
                if (text_size[0] > max_width) {
                    for (var len = string_length(cell_text); len > 0; len--) {
                        var test = string_copy(cell_text, 1, len) + "...";
                        if (gmui_calculate_text_size(test)[0] <= max_width) {
                            cell_text = test;
                            break;
                        }
                    }
                }
                
                gmui_add_text(cell_text, cx, cy, style.plot_table_text_color, 1, _font);
            }
        }
        
        gmui_add_rectangle(widget.x, widget.y, widget.x + plot_width, widget.y + plot_height, true, style.plot_table_border_color, 1);
        
        gmui_add_line(widget.x, widget.y + header_height, widget.x + plot_width, widget.y + header_height, style.plot_table_border_color, style.plot_table_border_size);
    }
    
    gmui_end_widget(widget);
    return true;
};

// legend(stand alone)
function gmui_plot_legend(labels, colors, count, columns = 1, width = -1) {
    var gmui = global.gmui;
    var style = gmui.style;
    var widget = gmui_begin_widget("plot_legend");
    var container = widget.container;
    
    var swatch_size = style.plot_legend_swatch_size;
    var gap = style.plot_legend_gap;
    var padding = style.container_padding_h;
    var item_height = max(swatch_size, gmui_calculate_text_size("W")[1]);
    
    var max_text_w = 0;
    for (var i = 0; i < count; i++) {
        var tw = gmui_calculate_text_size(labels[i])[0];
        if (tw > max_text_w) max_text_w = tw;
    }
    
    var col_width = swatch_size + gap + max_text_w + padding * 2;
    var plot_w = width > 0 ? width : min(container.width - style.container_padding_h * 2, col_width * columns);
    var actual_cols = min(columns, max(1, floor(plot_w / col_width)));
    
    var rows = ceil(count / actual_cols);
    var plot_h = rows * item_height + (rows > 1 ? (rows - 1) * gap : 0) + padding * 2;
    
    widget.width = plot_w;
    widget.height = plot_h;
    
    if (gmui_widget_is_callable(widget) && count > 0) {
        gmui_add_roundrect(widget.x, widget.y, widget.x + plot_w, widget.y + plot_h, false, style.plot_legend_bg_color, 1, style.rounding_widget);
        gmui_add_roundrect(widget.x, widget.y, widget.x + plot_w, widget.y + plot_h, true, style.plot_border_color, 1, style.rounding_widget);
        
        var final_col_w = plot_w / actual_cols;
        
        for (var i = 0; i < count; i++) {
            var col = i div rows;
            var row = i mod rows;
            
            var cx = widget.x + padding + col * final_col_w;
            var cy = widget.y + padding + row * (item_height + gap);
            
            var c_color = colors[i % array_length(colors)];
            
            var sy = cy + (item_height - swatch_size) / 2;
            gmui_add_roundrect(cx, sy, cx + swatch_size, sy + swatch_size, false, c_color, 1, style.rounding_small);
            gmui_add_roundrect(cx, sy, cx + swatch_size, sy + swatch_size, true, style.plot_legend_swatch_border_color, 1, style.rounding_small);
            
            var tx = cx + swatch_size + gap;
            var ty = cy + (item_height - gmui_calculate_text_size(labels[i])[1]) / 2;
            gmui_add_text(labels[i], tx, ty, style.plot_legend_text_color, 1);
        }
    }
    gmui_end_widget(widget);
}