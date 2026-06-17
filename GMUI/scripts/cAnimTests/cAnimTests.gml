

// ANIMATION SAMPLES
function gmui_animated_toggle(value) {
	var gmui = global.gmui;
	var widget = gmui_begin_widget("toggle");
	
	widget.width = 56;
	widget.height = 28;
		
	var anchor_pos_begin = 0;
	var anchor_pos_end = 28;
	var bg_color_begin = make_color_rgb(80, 80, 90);
	var bg_color_end = make_color_rgb(100, 200, 100);
	
	var prev_state = gmui_cache_get(widget.id + "_toggle_prev_state") ?? value;
	var anchor_fallback_pos = gmui_cache_get(widget.id + "_toggle_animation_fallback") ?? (value ? anchor_pos_end : anchor_pos_begin);
	var bg_fallback_color = gmui_cache_get(widget.id + "_color_animation_fallback") ?? (value ? bg_color_end : bg_color_begin);
	
	if (gmui_widget_is_callable(widget)) {
		var mouse_intr = gmui_widget_mouse_interactive_behaviour(widget);
		var is_hovering = mouse_intr.is_hovering;
		var is_active = mouse_intr.is_active;
		var is_clicked = mouse_intr.is_pressed;
		
		if (is_clicked) {
			value = !value;
		}
		
		var anchor_target_to = value ? anchor_pos_end : anchor_pos_begin;
		var anchor_target_from = value ? anchor_pos_begin : anchor_pos_end;
		var bg_color_to = value ? bg_color_end : bg_color_begin;
		var bg_color_from = value ? bg_color_begin : bg_color_end;
		
		var is_value_changed = value != prev_state;
		
		if (is_value_changed) {
			gmui_cache_set(widget.id + "_toggle_prev_state", value);
			
			gmui_animation_spring(widget.id + "_animation_spring", anchor_target_from, anchor_target_to, 1.0, 0.6);
			gmui_animation_tween_color3_start(widget.id + "_animation_color", bg_color_from, bg_color_to, 200000, gmui_animation_ease.OUT_QUAD);
		}
		
		var anchor_pos = 0;
		var bg_color = 0;
		
		var anchor_anim_pos = gmui_animation_get_value(widget.id + "_animation_spring");
		if (anchor_anim_pos == undefined) {
			anchor_pos = anchor_fallback_pos;
		}
		else {
			anchor_pos = anchor_anim_pos;
			anchor_fallback_pos = anchor_anim_pos;
		}
		
		var bg_anim_color = gmui_animation_get_value(widget.id + "_animation_color");
		if (bg_anim_color == undefined) {
			bg_color = bg_fallback_color;
		}
		else {
			bg_color = bg_anim_color;
			bg_fallback_color = bg_anim_color;
		}
		
		gmui_add_roundrect(widget.x, widget.y, widget.x + widget.width, widget.y + widget.height, false, bg_color, 1, 14);
		
		var anchor_x = widget.x + 4 + anchor_pos;
		gmui_add_circle(anchor_x + 10, widget.y + 14, 10, false, c_white, 1);
		gmui_add_circle(anchor_x + 10, widget.y + 14, 10, true, make_color_rgb(200, 200, 200), 1);
	}
	
	gmui_cache_set(widget.id + "_toggle_animation_fallback", anchor_fallback_pos);
	gmui_cache_set(widget.id + "_color_animation_fallback", bg_fallback_color);
	
	gmui_end_widget(widget);
	
	return value;
}