

// DRAW
function gmui_get_default_visual_calls() {
	return {
		// misc
		draw_set_font: draw_set_font,
		draw_set_halign: draw_set_halign,
		draw_set_valign: draw_set_valign,
		draw_primitive_begin: draw_primitive_begin,
		draw_primitive_end: draw_primitive_end,
		draw_vertex: draw_vertex,
		vertex_color: draw_vertex_color,
		scrolling_set_value: function(value) {
			global.gmui.current_container.scrolling_enabled = value;
		},
		scissor_begin: gmui_begin_scissor,
		scissor_isolated: gmui_push_scissor_isolated,
		scissor_end: gmui_end_scissor,
		call_function: function(func, params) { func(params); },
		
		// draw
		draw_text: function(x, y, text, color, alpha, font) {
			var old_color = draw_get_colour();
			var old_alpha = draw_get_alpha();
			draw_set_color(color);
			draw_set_alpha(alpha);
			if (font != undefined) {
				var old_font = draw_get_font();
				draw_set_font(font);
				draw_text(x, y, text);
				draw_set_font(old_font);
			} else {
				draw_text(x, y, text);
			}
			draw_set_colour(old_color);
			draw_set_alpha(old_alpha);
		},
		
		draw_rectangle: function(x1, y1, x2, y2, outline, color, alpha) {
			var old_color = draw_get_colour();
			var old_alpha = draw_get_alpha();
			draw_set_color(color);
			draw_set_alpha(alpha);
			draw_rectangle(x1, y1, x2, y2, outline);
			draw_set_colour(old_color);
			draw_set_alpha(old_alpha);
		},
		
		draw_roundrect: function(x1, y1, x2, y2, outline, color, alpha, rounding) {
			var old_color = draw_get_colour();
			var old_alpha = draw_get_alpha();
			draw_set_color(color);
			draw_set_alpha(alpha);
			var r = rounding;
			draw_roundrect_ext(x1, y1, x2, y2, r, r, outline);
			draw_set_colour(old_color);
			draw_set_alpha(old_alpha);
		},
		
		draw_line: function(x1, y1, x2, y2, color, alpha) {
			var old_color = draw_get_colour();
			var old_alpha = draw_get_alpha();
			draw_set_color(color);
			draw_set_alpha(alpha);
			draw_line(x1, y1, x2, y2);
			draw_set_colour(old_color);
			draw_set_alpha(old_alpha);
		},
		
		draw_line_width: function(x1, y1, x2, y2, width, color, alpha) {
			var old_color = draw_get_colour();
			var old_alpha = draw_get_alpha();
			draw_set_color(color);
			draw_set_alpha(alpha);
			draw_line_width(x1, y1, x2, y2, width);
			draw_set_colour(old_color);
			draw_set_alpha(old_alpha);
		},
		
		draw_circle: function(x, y, r, outline, color, alpha) {
			var old_color = draw_get_colour();
			var old_alpha = draw_get_alpha();
			draw_set_color(color);
			draw_set_alpha(alpha);
			draw_circle(x, y, r, outline);
			draw_set_colour(old_color);
			draw_set_alpha(old_alpha);
		},
		
		draw_sprite: function(sprite, subimg, x, y, color, alpha) {
			var old_color = draw_get_colour();
			var old_alpha = draw_get_alpha();
			draw_set_color(color);
			draw_set_alpha(alpha);
			draw_sprite(sprite, subimg, x, y);
			draw_set_colour(old_color);
			draw_set_alpha(old_alpha);
		},
		
		draw_sprite_ext: draw_sprite_ext,
		
		draw_surface: function(id, x, y, color, alpha) {
			var old_color = draw_get_colour();
			var old_alpha = draw_get_alpha();
			draw_set_color(color);
			draw_set_alpha(alpha);
			draw_surface(id, x, y);
			draw_set_colour(old_color);
			draw_set_alpha(old_alpha);
		},
		
		draw_surface_ext: draw_surface_ext,
		
		draw_triangle: function(x1, y1, x2, y2, x3, y3, color, alpha, outline) {
			var old_color = draw_get_colour();
			var old_alpha = draw_get_alpha();
			draw_set_color(color);
			draw_set_alpha(alpha);
			draw_triangle(x1, y1, x2, y2, x3, y3, outline);
			draw_set_colour(old_color);
			draw_set_alpha(old_alpha);
		},
		
		draw_shader_rect: function(x1, y1, x2, y2, shader, uniforms) {
			shader_set(shader);
			for (var j = 0; j < array_length(uniforms); j++) {
				var u = uniforms[j];
				switch (u.type) {
					case "float":
						shader_set_uniform_f(shader_get_uniform(shader, u.name), u.value);
						break;
					case "vec2":
						shader_set_uniform_f(shader_get_uniform(shader, u.name), u.value[0], u.value[1]);
						break;
					case "vec3":
						shader_set_uniform_f(shader_get_uniform(shader, u.name), u.value[0], u.value[1], u.value[2]);
						break;
					case "vec4":
						shader_set_uniform_f(shader_get_uniform(shader, u.name), u.value[0], u.value[1], u.value[2], u.value[3]);
						break;
				}
			}
			draw_primitive_begin_texture(pr_trianglelist, -1);
			draw_vertex_texture(x1, y2, 0, 1);
			draw_vertex_texture(x1, y1, 0, 0);
			draw_vertex_texture(x2, y1, 1, 0);
			draw_vertex_texture(x2, y2, 1, 1);
			draw_vertex_texture(x1, y2, 0, 1);
			draw_vertex_texture(x2, y1, 1, 0);
			draw_primitive_end();
			shader_reset();
		},
		
		draw_rect_expensive: _gmui_draw_rounded_rectangle_directional,
	};
};

function gmui_get_high_quality_visual_calls() {
	return {
		// Misc
		draw_set_font: draw_set_font,
		draw_set_halign: draw_set_halign,
		draw_set_valign: draw_set_valign,
		draw_primitive_begin: draw_primitive_begin,
		draw_primitive_end: draw_primitive_end,
		draw_vertex: draw_vertex,
		vertex_color: draw_vertex_color,
		scrolling_set_value: function(value) {
			global.gmui.current_container.scrolling_enabled = value;
		},
		scissor_begin: gmui_begin_scissor,
		scissor_isolated: gmui_push_scissor_isolated,
		scissor_end: gmui_end_scissor,
		call_function: function(func, params) { func(params); },
		
		draw_text: function(x, y, text, color, alpha, font) {
			var _sx = round(x);
			var _sy = round(y);
			draw_set_color(color);
			draw_set_alpha(alpha);
			if (font != undefined) { draw_set_font(font); }
			draw_text(_sx, _sy, text);
		},
		
		draw_rectangle: function(x1, y1, x2, y2, outline, color, alpha) {
			draw_set_color(color);
			draw_set_alpha(alpha);
			if (outline) {
				var _x1 = floor(x1) + 0.5;
				var _y1 = floor(y1) + 0.5;
				var _x2 = ceil(x2) - 0.5;
				var _y2 = ceil(y2) - 0.5;
				draw_rectangle(_x1, _y1, _x2, _y2, true);
			} else {
				draw_rectangle(x1, y1, x2, y2, false);
			}
		},
		
		draw_roundrect: function(x1, y1, x2, y2, outline, color, alpha, rounding) {
			draw_set_color(color);
			draw_set_alpha(alpha);
			var r = (rounding >= 0) ? rounding : gmui_style_get("rounding");
			if (outline) {
				_gmui_draw_rounded_rectangle_directional(x1, y1, x2, y2, r, gmui_corner_direction.ALL, false, 24);
				_gmui_draw_rounded_rectangle_directional(x1+1, y1+1, x2-1, y2-1, max(0, r-1), gmui_corner_direction.ALL, false, 24);
			} else {
				_gmui_draw_rounded_rectangle_directional(x1, y1, x2, y2, r, gmui_corner_direction.ALL, true, 24);
			}
		},
		
		draw_line: function(x1, y1, x2, y2, color, alpha) {
			draw_set_color(color);
			draw_set_alpha(alpha);
			var _dx = x2 - x1;
			var _dy = y2 - y1;
			var _len = sqrt(_dx * _dx + _dy * _dy);
			if (_len < 0.5) { return; }
			
			var _nx = _dx / _len;
			var _ny = _dy / _len;
			var _px = -_ny * 0.5;
			var _py = _nx * 0.5;
			
			draw_primitive_begin(pr_trianglelist);
			draw_vertex_color(x1 + _px, y1 + _py, color, alpha);
			draw_vertex_color(x1 - _px, y1 - _py, color, alpha);
			draw_vertex_color(x2 + _px, y2 + _py, color, alpha);
			draw_vertex_color(x2 + _px, y2 + _py, color, alpha);
			draw_vertex_color(x1 - _px, y1 - _py, color, alpha);
			draw_vertex_color(x2 - _px, y2 - _py, color, alpha);
			draw_primitive_end();
		},
		
		draw_line_width: function(x1, y1, x2, y2, width, color, alpha) {
			draw_set_color(color);
			draw_set_alpha(alpha);
			if (width <= 1) {
				var _vc = gmui_get_default_visual_calls();
				_vc.draw_line(x1, y1, x2, y2, color, alpha);
				return;
			}
			
			var _dx = x2 - x1;
			var _dy = y2 - y1;
			var _len = sqrt(_dx * _dx + _dy * _dy);
			if (_len < 0.5) { return; }
			
			var _nx = _dx / _len;
			var _ny = _dy / _len;
			var _px = -_ny * width * 0.5;
			var _py = _nx * width * 0.5;
			
			draw_primitive_begin(pr_trianglelist);
			draw_vertex_color(x1 + _px, y1 + _py, color, alpha);
			draw_vertex_color(x1 - _px, y1 - _py, color, alpha);
			draw_vertex_color(x2 + _px, y2 + _py, color, alpha);
			draw_vertex_color(x2 + _px, y2 + _py, color, alpha);
			draw_vertex_color(x1 - _px, y1 - _py, color, alpha);
			draw_vertex_color(x2 - _px, y2 - _py, color, alpha);
			draw_primitive_end();
			
			draw_set_color(color);
			draw_set_alpha(alpha);
			draw_circle(x1, y1, width * 0.5, false);
			draw_circle(x2, y2, width * 0.5, false);
		},
		
		draw_circle: function(x, y, r, outline, color, alpha) {
			draw_set_color(color);
			draw_set_alpha(alpha);
			var _segments = max(24, r * 2);
			if (outline) {
				draw_set_alpha(alpha * 0.5);
				draw_circle(x, y, r + 0.5, true);
				draw_circle(x, y, r - 0.5, true);
				draw_set_alpha(alpha);
				draw_circle(x, y, r, true);
			} else {
				draw_circle(x, y, r, false);
			}
		},
		
		draw_sprite: function(sprite, subimg, x, y, color, alpha) {
			draw_set_color(color);
			draw_set_alpha(alpha);
			draw_sprite(sprite, subimg, floor(x), floor(y));
		},
		
		draw_sprite_ext: function(sprite, subimg, x, y, xscale, yscale, rot, color, alpha) {
			draw_sprite_ext(sprite, subimg, x, y, xscale, yscale, rot, color, alpha);
		},
		
		draw_surface: function(id, x, y, color, alpha) {
			draw_set_color(color);
			draw_set_alpha(alpha);
			draw_surface(id, floor(x), floor(y));
		},
		
		draw_surface_ext: function(id, x, y, xscale, yscale, rot, color, alpha) {
			draw_surface_ext(id, x, y, xscale, yscale, rot, color, alpha);
		},
		
		draw_triangle: function(x1, y1, x2, y2, x3, y3, color, alpha, outline) {
			draw_set_color(color);
			draw_set_alpha(alpha);
			if (outline) {
				draw_triangle(x1, y1, x2, y2, x3, y3, true);
				draw_set_alpha(alpha * 0.3);
				draw_triangle(x1, y1, x2, y2, x3, y3, false);
				draw_set_alpha(alpha);
			} else {
				draw_triangle(x1, y1, x2, y2, x3, y3, false);
			}
		},
		
		draw_shader_rect: function(x1, y1, x2, y2, shader, uniforms) {
			shader_set(shader);
			for (var j = 0; j < array_length(uniforms); j++) {
				var u = uniforms[j];
				switch (u.type) {
					case "float":
						shader_set_uniform_f(shader_get_uniform(shader, u.name), u.value);
						break;
					case "vec2":
						shader_set_uniform_f(shader_get_uniform(shader, u.name), u.value[0], u.value[1]);
						break;
					case "vec3":
						shader_set_uniform_f(shader_get_uniform(shader, u.name), u.value[0], u.value[1], u.value[2]);
						break;
					case "vec4":
						shader_set_uniform_f(shader_get_uniform(shader, u.name), u.value[0], u.value[1], u.value[2], u.value[3]);
						break;
				}
			}
			draw_primitive_begin_texture(pr_trianglelist, -1);
			draw_vertex_texture(x1, y2, 0, 1);
			draw_vertex_texture(x1, y1, 0, 0);
			draw_vertex_texture(x2, y1, 1, 0);
			draw_vertex_texture(x2, y2, 1, 1);
			draw_vertex_texture(x1, y2, 0, 1);
			draw_vertex_texture(x2, y1, 1, 0);
			draw_primitive_end();
			shader_reset();
		},
		
		draw_rect_expensive: _gmui_draw_rounded_rectangle_directional,
	};
};

function _gmui_draw_pie_slice(cx, cy, inner_radius, outer_radius, start_angle, end_angle, color) {
	var q = 48; //16;
    var segments = max(3, floor(abs(end_angle - start_angle) * q / (2 * pi)));
    var angle_step = (end_angle - start_angle) / segments;
    
    for (var i = 0; i < segments; i++) {
        var a1 = start_angle + i * angle_step;
        var a2 = start_angle + (i + 1) * angle_step;
        
        var x1 = cx + cos(a1) * outer_radius;
        var y1 = cy - sin(a1) * outer_radius;
        var x2 = cx + cos(a2) * outer_radius;
        var y2 = cy - sin(a2) * outer_radius;
        
        if (inner_radius > 0) {
            var x3 = cx + cos(a2) * inner_radius;
            var y3 = cy - sin(a2) * inner_radius;
            var x4 = cx + cos(a1) * inner_radius;
            var y4 = cy - sin(a1) * inner_radius;
            
            gmui_add_triangle(x1, y1, x2, y2, x3, y3, color);
            gmui_add_triangle(x1, y1, x3, y3, x4, y4, color);
        } else {
            gmui_add_triangle(cx, cy, x1, y1, x2, y2, color);
        }
    }
};

function _gmui_draw_arc(cx, cy, inner_radius, outer_radius, start_angle, end_angle, color, segments) {
    var angle_step = (end_angle - start_angle) / segments;
    
    for (var i = 0; i < segments; i++) {
        var a1 = start_angle + i * angle_step;
        var a2 = start_angle + (i + 1) * angle_step;
        
        var x1 = cx + cos(a1) * outer_radius;
        var y1 = cy - sin(a1) * outer_radius;
        var x2 = cx + cos(a2) * outer_radius;
        var y2 = cy - sin(a2) * outer_radius;
        var x3 = cx + cos(a2) * inner_radius;
        var y3 = cy - sin(a2) * inner_radius;
        var x4 = cx + cos(a1) * inner_radius;
        var y4 = cy - sin(a1) * inner_radius;
        
        gmui_add_triangle(x1, y1, x2, y2, x3, y3, color);
        gmui_add_triangle(x1, y1, x3, y3, x4, y4, color);
    }
};

function _gmui_draw_rounded_rectangle_directional(x1, y1, x2, y2, radius, direction, filled, segments) {
    var _x1 = min(x1, x2);
    var _y1 = min(y1, y2);
    var _x2 = max(x1, x2);
    var _y2 = max(y1, y2);
    
    var w = _x2 - _x1;
    var h = _y2 - _y1;
    var r = min(radius, w * 0.5);
    r = min(r, h * 0.5);
    
    var tl = (direction & 1) != 0;  // TOP_LEFT
    var tr = (direction & 2) != 0;  // TOP_RIGHT
    var br = (direction & 4) != 0;  // BOTTOM_RIGHT
    var bl = (direction & 8) != 0;  // BOTTOM_LEFT
    
    var seg = segments;
    if (seg <= 0) seg = max(8, ceil(r / 2));
    
    if (filled) {
        draw_rectangle(_x1 + (tl || bl ? r : 0), _y1 + (tl || tr ? r : 0), _x2 - (tr || br ? r : 0), _y2 - (bl || br ? r : 0), false);
        
        draw_rectangle(_x1 + (tl ? r : 0), _y1, _x2 - (tr ? r : 0), _y1 + r, false); // top
        draw_rectangle(_x1 + (bl ? r : 0), _y2 - r, _x2 - (br ? r : 0), _y2, false); // bottom
        draw_rectangle(_x1, _y1 + (tl ? r : 0), _x1 + r, _y2 - (bl ? r : 0), false); // left
        draw_rectangle(_x2 - r, _y1 + (tr ? r : 0), _x2, _y2 - (br ? r : 0), false); // right
        
        var step = 90 / seg;
        if (tl) {
            draw_primitive_begin(pr_trianglefan);
            draw_vertex(_x1 + r, _y1 + r);
            for (var a = 180; a <= 270; a += step) {
                var rad = degtorad(a);
                draw_vertex(_x1 + r + cos(rad) * r, _y1 + r + sin(rad) * r);
            }
            draw_primitive_end();
        }
        if (tr) {
            draw_primitive_begin(pr_trianglefan);
            draw_vertex(_x2 - r, _y1 + r);
            for (var a = 270; a <= 360; a += step) {
                var rad = degtorad(a);
                draw_vertex(_x2 - r + cos(rad) * r, _y1 + r + sin(rad) * r);
            }
            draw_primitive_end();
        }
        if (br) {
            draw_primitive_begin(pr_trianglefan);
            draw_vertex(_x2 - r, _y2 - r);
            for (var a = 0; a <= 90; a += step) {
                var rad = degtorad(a);
                draw_vertex(_x2 - r + cos(rad) * r, _y2 - r + sin(rad) * r);
            }
            draw_primitive_end();
        }
        if (bl) {
            draw_primitive_begin(pr_trianglefan);
            draw_vertex(_x1 + r, _y2 - r);
            for (var a = 90; a <= 180; a += step) {
                var rad = degtorad(a);
                draw_vertex(_x1 + r + cos(rad) * r, _y2 - r + sin(rad) * r);
            }
            draw_primitive_end();
        }
        return;
    }
    
    draw_primitive_begin(pr_linestrip);
    if (tl) {
        draw_vertex(_x1 + r, _y1);
        for (var a = 180; a <= 270; a += 90 / seg) {
            var rad = degtorad(a);
            draw_vertex(_x1 + r + cos(rad) * r, _y1 + r + sin(rad) * r);
        }
    } else {
        draw_vertex(_x1, _y1);
    }
    
    if (tr) {
        draw_vertex(_x2 - r, _y1);
        for (var a = 270; a <= 360; a += 90 / seg) {
            var rad = degtorad(a);
            draw_vertex(_x2 - r + cos(rad) * r, _y1 + r + sin(rad) * r);
        }
    } else {
        draw_vertex(_x2, _y1);
    }
    
    if (br) {
        draw_vertex(_x2, _y2 - r);
        for (var a = 0; a <= 90; a += 90 / seg) {
            var rad = degtorad(a);
            draw_vertex(_x2 - r + cos(rad) * r, _y2 - r + sin(rad) * r);
        }
    } else {
        draw_vertex(_x2, _y2);
    }
    
    if (bl) {
        draw_vertex(_x1 + r, _y2);
        for (var a = 90; a <= 180; a += 90 / seg) {
            var rad = degtorad(a);
            draw_vertex(_x1 + r + cos(rad) * r, _y2 - r + sin(rad) * r);
        }
    } else {
        draw_vertex(_x1, _y2);
    }
    
    draw_vertex(_x1, _y1 + (tl ? r : 0));
    draw_primitive_end();
};

function gmui_default_background_draw_call(container, x1, y1, x2, y2) {
	var gmui = global.gmui;
	var style = gmui.style;
	
	var old_bg_color = draw_get_colour();
	draw_set_color(style.container_background_color);
	draw_roundrect_ext(x1, y1, x2, y2, style.container_rounding, style.container_rounding, false);
	draw_set_color(style.container_outline_color);
	draw_roundrect_ext(x1 + 1, y1 + 1, x2, y2, style.container_rounding, style.container_rounding, true);
	draw_set_color(old_bg_color);
};

function gmui_default_mask_draw_call(container, x1, y1, x2, y2) {
	var gmui = global.gmui;
	var style = gmui.style;
	
	var old_bg_color = draw_get_colour();
	var old_blend = gpu_get_blendmode();
	
	gpu_set_blendmode(bm_reverse_subtract);
	draw_set_color(c_white);
	draw_rectangle(x1, y1, x2, y2, false);
	draw_set_color(c_black);
	draw_roundrect_ext(x1, y1, x2, y2, style.container_rounding, style.container_rounding, false);
	draw_set_color(old_bg_color);
	gpu_set_blendmode(old_blend);
};