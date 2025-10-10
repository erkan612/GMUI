// Rendering, surface management
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
				
            case "rect_alpha":
				draw_set_alpha(cmd.alpha);
                draw_set_color(cmd.color);
                draw_rectangle(cmd.x, cmd.y, cmd.x + cmd.width, cmd.y + cmd.height, false);
                draw_set_alpha(1);
				break;
                
            case "rect_outline":
                draw_set_color(cmd.color);
                draw_rectangle(cmd.x, cmd.y, cmd.x + cmd.width, cmd.y + cmd.height, true);
                break;
            case "rect_outline_alpha":
				draw_set_alpha(cmd.alpha);
                draw_set_color(cmd.color);
                draw_rectangle(cmd.x, cmd.y, cmd.x + cmd.width, cmd.y + cmd.height, true);
                draw_set_alpha(1);
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
			
			case "shader_rect":
			    shader_set(cmd.shader);
    
			    // Set uniforms
			    for (var j = 0; j < array_length(cmd.uniforms); j++) {
			        var uniform = cmd.uniforms[j];
			        switch (uniform.type) {
			            case "float":
			                shader_set_uniform_f(shader_get_uniform(cmd.shader, uniform.name), uniform.value);
			                break;
			            case "vec2":
			                shader_set_uniform_f(shader_get_uniform(cmd.shader, uniform.name), uniform.value[0], uniform.value[1]);
			                break;
			            case "vec3":
			                shader_set_uniform_f(shader_get_uniform(cmd.shader, uniform.name), uniform.value[0], uniform.value[1], uniform.value[2]);
			                break;
			            case "vec4":
			                shader_set_uniform_f(shader_get_uniform(cmd.shader, uniform.name), uniform.value[0], uniform.value[1], uniform.value[2], uniform.value[3]);
			                break;
			        }
			    }
    
			    //draw_rectangle(cmd.x, cmd.y, cmd.x + cmd.width, cmd.y + cmd.height, false);
				draw_primitive_begin_texture(pr_trianglelist, -1);
				draw_vertex_texture(cmd.x, cmd.y + cmd.height, 0, 1);
				draw_vertex_texture(cmd.x, cmd.y, 0, 0);
				draw_vertex_texture(cmd.x + cmd.width, cmd.y, 1, 0);
				
				draw_vertex_texture(cmd.x + cmd.width, cmd.y + cmd.height, 1, 1);
				draw_vertex_texture(cmd.x, cmd.y + cmd.height, 0, 1);
				draw_vertex_texture(cmd.x + cmd.width, cmd.y, 1, 0);
				draw_primitive_end();
				
			    shader_reset();
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

function gmui_render() {
    if (!global.gmui.initialized) return;
    
    var names = variable_struct_get_names(global.gmui.windows);
	var secondaries = array_create(100);
	var secondariesCount = 0;
	
	// hovering
	global.gmui.hovering_window = undefined;
    for (var i = ds_list_size(global.gmui.windows) - 1; i >= 0; i--) {
        var window = global.gmui.windows[| i];
        if (window.active && window.open) {
			var mouse_over = (device_mouse_x_to_gui(0) > window.x && device_mouse_x_to_gui(0) < window.x + window.width) && (device_mouse_y_to_gui(0) > window.y && device_mouse_y_to_gui(0) < window.y + window.height);
			if (mouse_over) { global.gmui.hovering_window = window; break; };
        }
    }
	
	// rendering
    for (var i = 0; i < ds_list_size(global.gmui.windows); i++) {
        var window = global.gmui.windows[| i];
		
		// push if secondary
		if (string_copy(window.name, 1, 3) == "###") {
			secondaries[secondariesCount] = window;
			secondariesCount++;
			continue;
		};
		
        if (window.active && window.open) {
            gmui_render_surface(window);
            draw_surface(window.surface, window.x, window.y);
            window.active = false;
        }
    }
	
	// render secondaries
    for (var i = 0; i < secondariesCount; i++) {
        var window = secondaries[i];
		
        if (window.active && window.open) {
            gmui_render_surface(window);
            draw_surface(window.surface, window.x, window.y);
            window.active = false;
        }
    }
}

function gmui_add_sprite(x, y, w, h, sprite, subimg = 0) {
    if (!global.gmui.initialized || !global.gmui.current_window) return;
    array_push(global.gmui.current_window.draw_list, {
        type: "sprite", spr: sprite, x: x, y: y, width: w, height: h, index: subimg
    });
}

function gmui_add_rect(x, y, w, h, col) {
    if (!global.gmui.initialized || !global.gmui.current_window) return;
    array_push(global.gmui.current_window.draw_list, {
        type: "rect", x: x, y: y, width: w, height: h, color: col
    });
}

function gmui_add_rect_alpha(x, y, w, h, col, a) {
    if (!global.gmui.initialized || !global.gmui.current_window) return;
    array_push(global.gmui.current_window.draw_list, {
        type: "rect_alpha", x: x, y: y, width: w, height: h, color: col, alpha: a
    });
}

function gmui_add_rect_outline(x, y, w, h, col, thickness) {
    if (!global.gmui.initialized || !global.gmui.current_window) return;
    array_push(global.gmui.current_window.draw_list, {
        type: "rect_outline", x: x, y: y, width: w, height: h, color: col, thickness: thickness
    });
}

function gmui_add_rect_outline_alpha(x, y, w, h, col, thickness, a) {
    if (!global.gmui.initialized || !global.gmui.current_window) return;
    array_push(global.gmui.current_window.draw_list, {
        type: "rect_outline", x: x, y: y, width: w, height: h, color: col, thickness: thickness, alpha: a
    });
}

function gmui_add_text(x, y, text, col) {
    if (!global.gmui.initialized || !global.gmui.current_window) return;
    array_push(global.gmui.current_window.draw_list, {
        type: "text", x: x, y: y, text: text, color: col
    });
}

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

function gmui_add_shader_rect(x, y, w, h, shader, uniforms) {
    if (!global.gmui.initialized || !global.gmui.current_window) return;
    array_push(global.gmui.current_window.draw_list, {
        type: "shader_rect",
        x: x, y: y, width: w, height: h,
        shader: shader,
        uniforms: uniforms
    });
}