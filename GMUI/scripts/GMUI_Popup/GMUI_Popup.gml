

// POPUP
function gmui_begin_popup(name, is_modal = false, width = 320, height = 160, flags = gmui_window_flags.NONE) {
    var gmui = global.gmui;
    var input = gmui.input;
    
	var window = undefined;
	var is_first_frame = !ds_map_exists(gmui.containers, name);
    window = gmui_container_get(name, undefined);
	if (is_first_frame) {
		gmui_begin_window(name, surface_get_width(application_surface) / 2 - width / 2, surface_get_height(application_surface) / 2 - height / 2, width, height, flags); // initialize first
		gmui_end_window();
		window.is_enabled = false;
		var bg_container = gmui_container_get(name + "_popup_background");
		bg_container.background_draw_func = function(container, x1, y1, x2, y2) {
			var old_alpha = draw_get_alpha();
			var old_color = draw_get_color();
			draw_set_color(c_black);
			draw_set_alpha(0.75);
			draw_rectangle(x1, y1, x2, y2, false);
			draw_set_alpha(old_alpha);
			draw_set_color(old_color);
		};
		bg_container.layer = gmui_layer.MODAL_BG;
		window.layer = gmui_layer.POPUP;
	};
    
    if (!window.is_enabled) { return false; };
	
	if (is_modal) {
		gmui_begin_container_plain(name + "_popup_background", 0, 0, surface_get_width(application_surface), surface_get_height(application_surface));
		gmui_end_container_plain();
		gmui_container_bring_to_front(name + "_popup_background");
	}
	
	var result = gmui_begin_window(name, surface_get_width(application_surface) / 2 - width / 2, surface_get_height(application_surface) / 2 - height / 2, width, height, flags);
	gmui_container_bring_to_front(name);
	
	return result;
};

function gmui_end_popup() {
    gmui_end_window();
};

function gmui_popup_open(name, x = -1, y = -1) {
    var window = gmui_container_get(name, undefined);
    if (window != undefined && !window.is_enabled) {
        window.is_enabled = true;
	    var xx = x < 0 ? surface_get_width(application_surface) / 2 - window.width / 2 : x;
	    var yy = y < 0 ? surface_get_height(application_surface) / 2 - window.height / 2 : y;
        window.x = xx;
        window.y = yy;
		gmui_container_bring_to_front(name);
    }
};

function gmui_popup_close(name) {
    var window = gmui_container_get(name, undefined);
    if (window != undefined && window.is_enabled) {
        window.is_enabled = false;
    }
};

function gmui_popup_is_open(name) {
    return gmui_container_get(name, undefined).is_enabled;
};

function gmui_popup_toggle(name) {
    var window = gmui_container_get(name, undefined);
    if (window != undefined) {
        window.is_enabled = !window.is_enabled;
        if (window.is_enabled) { gmui_popup_open(name); } else { gmui_popup_close(name); };
    }
    return window.is_enabled;
};

function gmui_modal_popup(name, width, height, func) {
    if (gmui_begin_popup(name, true, width, height)) {
        func();
        gmui_end_popup();
        return true;
    }
    return false;
};

function gmui_modal_popup_auto(name, func) {
    var style = global.gmui.style;
    if (gmui_begin_popup(name, true, undefined, undefined, gmui_window_flags.AUTO_RESIZE_HORIZONTAL | gmui_window_flags.AUTO_RESIZE_VERTICAL)) {
        func();
        gmui_end_popup();
        return true;
    }
    return false;
};

function gmui_popup(name, width, height, func) {
    if (gmui_begin_popup(name, false, width, height)) {
        func();
        gmui_end_popup();
        return true;
    }
    return false;
};

function gmui_popup_auto(name, func) {
    var style = global.gmui.style;
    if (gmui_begin_popup(name, false, undefined, undefined, gmui_window_flags.AUTO_RESIZE_HORIZONTAL | gmui_window_flags.AUTO_RESIZE_VERTICAL)) {
        func();
        gmui_end_popup();
        return true;
    }
    return false;
};