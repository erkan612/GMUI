/*********************************************************************************************
*                                        MIT License                                         *
*--------------------------------------------------------------------------------------------*
* Copyright (c) 2026 erkan612                                                                *
*                                                                                            *
* Permission is hereby granted, free of charge, to any person obtaining a copy of this       *
* software and associated documentation files (the "Software"), to deal in the Software      *
* without restriction, including without limitation the rights to use, copy, modify, merge,  *
* publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons *
* to whom the Software is furnished to do so, subject to the following conditions:           *
*                                                                                            *
* The above copyright notice and this permission notice shall be included in all copies or   *
* substantial portions of the Software.                                                      *
*                                                                                            *
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,        *
* INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR   *
* PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE  *
* FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR       *
* OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER     *
* DEALINGS IN THE SOFTWARE.                                                                  *
**********************************************************************************************
*--------------------------------------------------------------------------------------------*
*   						***************************************                          *
*   						   ██████╗ ███╗   ███╗██╗   ██╗██╗		                         *
*   						  ██╔════╝ ████╗ ████║██║   ██║██║		                         *
*   						  ██║  ███╗██╔████╔██║██║   ██║██║		                         *
*   						  ██║   ██║██║╚██╔╝██║██║   ██║██║		                         *
*   						  ╚██████╔╝██║ ╚═╝ ██║╚██████╔╝██║		                         *
*   						   ╚═════╝ ╚═╝     ╚═╝ ╚═════╝ ╚═╝		                         *
*   						 GameMaker Immediate Mode UI Library	                         *
*   						            Version 2.4.99					                     *
*   																                         *
*   						            by erkan612					                         *
*   						=======================================	                         *
*   						A feature rich Immediate-Mode UI system	                         *
*   						             for GameMaker				                         *
*   						=======================================	                         *
*   						***************************************                          *
*********************************************************************************************/

// CORE
function gmui_init(init_profile = gmui_get_default_profile(), visual_calls = undefined) {
	global.gmui = {
		containers: ds_map_create(),
		containers_sorted: [ ],
		current_container: undefined,
		container_stack: ds_stack_create(),
		scissor_stack: ds_stack_create(),
		last_widget: undefined,
		calls: [ ],
		cache: ds_map_create(),
		z_layers: {
	        background: { base: 0,		highest: 0,		},
	        normal:		{ base: 1000,	highest: 1000,	},
	        modal_bg:   { base: 2000,	highest: 2000,	},
	        popup:      { base: 2500,	highest: 2500,	},
	    },
		window_tab_connection_counter: 0,
		profile: init_profile,
		
		input: {
			// mouse
			m_x: 0,
			m_y: 0,
			m_pressed: false,
			m_released: false,
			m_held: false,
			m_wheel: 0,
			hovered_widget_id: undefined,
			focused_widget_id: undefined,
			active_widget_id: undefined, // for pressed state tracking
			dont_clear_active_widget_id: false,
			hovered_container: undefined,
			hovered_container_array: [ ],
			hovered_window: undefined,
			any_element_hovered: false,
			
			// keyboard
			k_pressed: false,
			k_key: 0,
			k_lastchar: "",
			k_lastkey: 0,
			k_control: false,
			k_shift: false,
			k_alt: false,
		},
		
		visual_calls: undefined,
	};
	
	gmui_style_init();
	
	global.gmui.cache[? "_last_detached_tab"] = undefined;
	global.gmui.cache[? "__update_calls"] = [ ];
	global.gmui.cache[? "__cleanup_calls"] = [ ];
	
	global.gmui.visual_calls = gmui_get_default_visual_calls();
	if (visual_calls != undefined) {
		var struct_names = variable_struct_get_names(visual_calls);
		for (var i = 0; i < array_length(struct_names); i++) {
			var name = struct_names[i];
			global.gmui.visual_calls[$ name] = visual_calls[$ name];
		};
	}
};

function gmui_get() {
	return global.gmui;
};

function gmui_get_update_calls() {
	return global.gmui.cache[? "__update_calls"];
};

function gmui_get_cleanup_calls() {
	return global.gmui.cache[? "__cleanup_calls"];
};

function gmui_get_default_profile(type = gmui_default_profile.ANIMATION) {
	var profile = undefined;
	switch (type) {
	case gmui_default_profile.ANIMATION: {
		profile = {
			column_row_properties: {
				background_enabled: false,
				use_surface: false,
				use_scissor: true,
				animation_flag: false,
			},
			container_properties: {
				use_surface: true,
				surface_flag: false,
				surface_sleep: false,
				use_scissor: true,
				animation_flag: false,
			},
		};
	} break;
	case gmui_default_profile.CACHED1: {
		profile = {
			column_row_properties: {
				background_enabled: false,
				use_surface: true,
				surface_flag: true,
				use_scissor: true,
				animation_flag: false,
			},
			container_properties: {
				use_surface: false,
				surface_flag: true,
				surface_sleep: false,
				use_scissor: true,
				animation_flag: false,
			},
		};
	} break;
	case gmui_default_profile.CACHED2: {
		profile = {
			column_row_properties: {
				background_enabled: false,
				use_surface: true,
				surface_flag: true,
				surface_sleep: true,
				use_scissor: true,
				animation_flag: false,
			},
			container_properties: {
				use_surface: false,
				surface_flag: true,
				surface_sleep: true,
				use_scissor: true,
				animation_flag: false,
			},
		};
	} break;
	case gmui_default_profile.BALANCED: {
		profile = {
			column_row_properties: {
				background_enabled: false,
				use_surface: true,
				surface_flag: true,
				surface_sleep: true,
				use_scissor: true,
				animation_flag: true,
			},
			container_properties: {
				use_surface: false,
				surface_flag: true,
				surface_sleep: true,
				use_scissor: true,
				animation_flag: true,
			},
		};
	} break;
	};
	return profile;
};

function gmui_set_profile(profile) {
	global.gmui.profile = profile;
};

function gmui_update() {
	var gmui = global.gmui;
	var input = gmui.input;
	
	gmui_render_toast();
	
	//gmui.containers_sorted = ds_map_values_to_array(gmui.containers);
	//array_sort(gmui.containers_sorted, function(a, b) { return a.z_index - b.z_index; });
	//for (var i = 0; i < array_length(gmui.containers_sorted); i++) {
	//	var container = gmui.containers_sorted[i];
	//	if (!container.is_enabled) { continue; };
	//	gmui_container_calculate_mouse_hovering(container);
	//	gmui_container_sort_z_index(container);
	//};
	
	input.hovered_container = undefined;
	input.hovered_container_array = [ ];
	
	{
		var current_size = ds_map_size(gmui.containers);
	    if (array_length(gmui.containers_sorted) != current_size) {
	        gmui.containers_sorted = ds_map_values_to_array(gmui.containers);
	        array_sort(gmui.containers_sorted, function(a, b) { return a.z_index - b.z_index; });
	    }
    
	    for (var i = 0; i < array_length(gmui.containers_sorted); i++) {
	        var container = gmui.containers_sorted[i];
	        if (!container.is_enabled || !container.is_active) { continue; };
	        gmui_container_sort_z_index(container);
	        gmui_container_calculate_mouse_hovering(container);
			container.is_active = false;
	    };
	}
	
	gmui_update_input();
	
	input.any_element_hovered = (gmui.input.hovered_widget_id != undefined);
    
    gmui_handle_scroll_bubble();
	
	var update_calls = gmui.cache[? "__update_calls"];
	for (var i = 0; i < array_length(update_calls); i++) {
		var call = update_calls[i];
		call();
	};
};

function gmui_draw_gui() {
	var gmui = global.gmui;
	var input = gmui.input;
	
	gmui_begin_scissor(0, 0, surface_get_width(application_surface), surface_get_height(application_surface));
	
	var old_blend_mode = gpu_get_blendmode();
	gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_one, bm_inv_src_alpha);
	
	for (var i = 0; i < array_length(gmui.containers_sorted); i++) {
		var container = gmui.containers_sorted[i];
		if (!container.is_active || !container.is_enabled) { continue; };
		//gmui.highest_z_index = max(container.z_index, gmui.highest_z_index);
		container.z_index = min(max(container.z_index, gmui_get_layer_data(container.layer).base), gmui_get_layer_data(container.layer).highest);
		gmui_draw_container(container);
	};
	
	_gmui_draw_detached_tab();
	
	var widget_drag_state = gmui.cache[? "__widget_drag_state"];
	var widget_drag_draw = gmui.cache[? "__widget_drag_draw"];
	var widget_drag_widget = gmui.cache[? "__widget_drag_widget"];
	var widget_drag_info = gmui.cache[? "__widget_drag_info"];
	if (widget_drag_state != undefined && widget_drag_state == "dragging" && widget_drag_draw != undefined && widget_drag_widget != undefined) {
		widget_drag_draw(widget_drag_info, widget_drag_widget);
	}
	
	for (var i = 0; i < array_length(gmui.calls); i++) {
		var call = gmui.calls[i];
		gmui_handle_call(call);
	};
	
	gpu_set_blendmode(old_blend_mode);
	
	gmui_end_scissor();
	
	ds_stack_clear(gmui.container_stack);
	ds_stack_clear(gmui.scissor_stack);
	gmui.containers_sorted = [ ];
	gmui.last_widget = undefined;
	gmui.calls = [ ];
	
	if (input.m_pressed && input.hovered_widget_id == undefined) {
		input.active_widget_id = undefined;
	}
	
	if (input.m_released && !input.dont_clear_active_widget_id) {
		input.active_widget_id = undefined;
	}
	
	var dnd_state = gmui.cache[? "__dnd_state"];
	if (dnd_state == "dropped") {
	    if (gmui.cache[? "__dnd_consumed"] == true || true) {
	        gmui.cache[? "__dnd_state"] = "";
	        gmui.cache[? "__dnd_widget"] = undefined;
	        gmui.cache[? "__dnd_target_widget"] = undefined;
	        gmui.cache[? "__dnd_payload_type"] = undefined;
	        gmui.cache[? "__dnd_payload_data"] = undefined;
	        gmui.cache[? "__dnd_consumed"] = false;
	        gmui.cache[? "__dnd_pending_widget"] = undefined;
	    }
	}
};

function gmui_get_font() {
    return global.gmui.font;
};

function gmui_set_font(font) {
    global.gmui.font = font;
};

function gmui_begin(name, x = -1, y = -1, width = -1, height = -1, flags = 0) {
	return gmui_begin_window(name, x, y, width, height, flags);
};

function gmui_end() {
	gmui_end_window();
};

function gmui_begin_child(name, width = -1, height = -1) {
	return gmui_begin_container(name, -1, -1, width <=0 ? gmui_get_available_width() : width, height <= 0 ? gmui_get_available_height() : height);
};

function gmui_end_child() {
	gmui_end_container();
};

function gmui_cleanup() {
    var gmui = global.gmui;
	
	var cleanup_calls = gmui.cache[? "__cleanup_calls"];
	if (cleanup_calls != undefined) {
		for (var i = 0; i < array_length(cleanup_calls); i++) {
			var call = cleanup_calls[i];
			call();
		};
	}
    
    var top_level = ds_map_keys_to_array(gmui.containers);
    for (var i = 0; i < array_length(top_level); i++) {
        var container = gmui.containers[? top_level[i]];
        gmui_container_destroy(container);
    }
    ds_map_destroy(gmui.containers);
    
    ds_stack_destroy(gmui.container_stack);
    ds_stack_destroy(gmui.scissor_stack);
    
    if (ds_map_exists(gmui.cache, "_style_stack")) {
        var style_stack = gmui.cache[? "_style_stack"];
        if (ds_map_exists(style_stack, style_stack)) { };
        ds_map_destroy(style_stack);
    }
    
    if (ds_map_exists(gmui.cache, "_tab_group_registry")) {
        var registry = gmui.cache[? "_tab_group_registry"];
        var group_keys = ds_map_keys_to_array(registry);
        for (var i = 0; i < array_length(group_keys); i++) {
            ds_map_destroy(registry[? group_keys[i]]);
        }
        ds_map_destroy(registry);
    }
    
    ds_map_destroy(gmui.cache);
    
    global.gmui = { };
};