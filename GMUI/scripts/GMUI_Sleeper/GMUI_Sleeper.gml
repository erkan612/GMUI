

// SLEEPER
function gmui_begin_sleeper(name) {
	var gmui = global.gmui;
	var container = gmui.current_container;
	var target_container = gmui_container_get(name, global.gmui.current_container);
	target_container.background_enabled = false;
	target_container.use_scissor = false;
	target_container.scrolling_enabled = false;
	target_container.use_surface = true;
	target_container.surface_flag = true;
	target_container.surface_sleep = true;
	if (!ds_map_exists(target_container.state, "_sleeper_auto_calc_width")) {
		target_container.state[? "_sleeper_auto_calc_width"] = true;
	}
	if (!ds_map_exists(target_container.state, "_sleeper_auto_calc_height")) {
		target_container.state[? "_sleeper_auto_calc_height"] = true;
	}
	if (!ds_map_exists(target_container.state, "_sleeper_saved_width")) {
		target_container.state[? "_sleeper_saved_width"] = 10;
	}
	if (!ds_map_exists(target_container.state, "_sleeper_saved_height")) {
		target_container.state[? "_sleeper_saved_height"] = 10;
	}
	var saved_width = target_container.state[? "_sleeper_saved_width"];
	var saved_height = target_container.state[? "_sleeper_saved_height"];
	var begin_result = gmui_begin_container(name, undefined, undefined, saved_width, saved_height);
	if (begin_result) {
		gmui_style_push("container_padding_h", 0);
		gmui_style_push("container_padding_v", 0);
		gmui_cursor_set(0, 0);
		return true;
	}
	else {
		return false;
	}
};

function gmui_end_sleeper() {
	var container = global.gmui.current_container;
	gmui_style_pop("container_padding_v");
	gmui_style_pop("container_padding_h");
	gmui_end_container();
	if (container.state[? "_sleeper_auto_calc_width"] || container.state[? "_sleeper_auto_calc_height"]) {
		var new_width = max(container.content_width, 1);
		var new_height = max(container.content_height, 1);
		gmui_container_set_size(container.name, new_width, new_height);
		container.state[? "_sleeper_saved_width"] = new_width;
		container.state[? "_sleeper_saved_height"] = new_height;
	}
};