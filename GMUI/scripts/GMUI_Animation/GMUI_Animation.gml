

// ANIMATIONS
/*
* testing experimental feature, trying out if an independent api can be built
* if it succeeds, more features can be implemented without interacting/interrupting internal functionality
* gives more freedom, exploration and less error prone improvement
* most of this is taken from an old project of mine, had to tweak some functions
*/

// enums
enum gmui_animation_ease {
	LINEAR,
	IN_QUAD,
	OUT_QUAD,
	IN_OUT_QUAD,
	IN_CUBIC,
	OUT_CUBIC,
	IN_OUT_CUBIC,
	IN_QUART,
	OUT_QUART,
	IN_OUT_QUART,
	IN_QUINT,
	OUT_QUINT,
	IN_OUT_QUINT,
	IN_SINE,
	OUT_SINE,
	IN_OUT_SINE,
	IN_EXPO,
	OUT_EXPO,
	IN_OUT_EXPO,
	IN_CIRC,
	OUT_CIRC,
	IN_OUT_CIRC,
	IN_ELASTIC,
	OUT_ELASTIC,
	IN_OUT_ELASTIC,
	IN_BACK,
	OUT_BACK,
	IN_OUT_BACK,
	IN_BOUNCE,
	OUT_BOUNCE,
	IN_OUT_BOUNCE,
	CUSTOM,
	TOTAL
}

enum gmui_animation_repeat_mode {
	NONE,
	LOOP,
	PING_PONG,
	PING_PONG_ONCE
}

enum gmui_animation_tween_direction {
	FORWARD,
	BACKWARD
}

enum gmui_animation_tween_state {
	IDLE,
	PLAYING,
	PAUSED,
	COMPLETED,
	KILLED
}

enum gmui_animation_value_type {
	REAL,
	COLOR3,
	COLOR4,
	VECTOR2,
	VECTOR3,
	VECTOR4,
	ARRAY,
	CUSTOM
}

enum gmui_animation_tween_flags {
	NONE						= 0,
	OVERRIDE_EXISTING			= 1 << 0,
	DELETE_ON_COMPLETE			= 1 << 1,
	IGNORE_TIME_SCALE			= 1 << 2,
	REVERSE_EASE_ON_PINGPONG	= 1 << 3,
	CLAMP_VALUES				= 1 << 4,
	SYNC_TO_AUDIO				= 1 << 5
}

// init
function gmui_animation_init() {
	var gmui = global.gmui;
	var cache = gmui.cache;
	
	var gmui_animation = {
		tweens: [],
		tweens_map: ds_map_create(),
		groups: ds_map_create(),
		timelines: ds_map_create(),
		global_time_scale: 1.0,
		active_tweens: 0,
		total_tweens_created: 0,
		default_easing: gmui_animation_ease.IN_OUT_QUAD,
		default_duration: 300000,
	};
	
	cache[? "__gmui_anim"] = gmui_animation;
	array_push(gmui_get_update_calls(), gmui_animation_update);
	array_push(gmui_get_cleanup_calls(), gmui_animation_cleanup);
}

function gmui_animation_get() {
	var gmui = global.gmui;
	var cache = gmui.cache;
	return cache[? "__gmui_anim"];
}

function gmui_animation_init_check_safe() {
	if (gmui_animation_get() == undefined) { gmui_animation_init(); }
}

// value lerp functions
function gmui_animation_lerp_color3(_c1, _c2, _t) {
	var _r = lerp(color_get_red(_c1), color_get_red(_c2), _t);
	var _g = lerp(color_get_green(_c1), color_get_green(_c2), _t);
	var _b = lerp(color_get_blue(_c1), color_get_blue(_c2), _t);
	return make_color_rgb(_r, _g, _b);
}

function gmui_animation_lerp_color4(_c1, _c2, _t) {
	var _a1 = gmui_color_rgba_to_array(_c1);
	var _a2 = gmui_color_rgba_to_array(_c2);
	var _r = lerp(_a1[0], _a2[0], _t);
	var _g = lerp(_a1[1], _a2[1], _t);
	var _b = lerp(_a1[2], _a2[2], _t);
	var _a = lerp(_a1[3], _a2[3], _t);
	return gmui_make_color_rgba(_r, _g, _b, _a);
}

function gmui_animation_lerp_vector2(_v1, _v2, _t) {
	return [lerp(_v1[0], _v2[0], _t), lerp(_v1[1], _v2[1], _t)];
}

function gmui_animation_lerp_vector3(_v1, _v2, _t) {
	return [lerp(_v1[0], _v2[0], _t), lerp(_v1[1], _v2[1], _t), lerp(_v1[2], _v2[2], _t)];
}

function gmui_animation_lerp_vector4(_v1, _v2, _t) {
	return [lerp(_v1[0], _v2[0], _t), lerp(_v1[1], _v2[1], _t), lerp(_v1[2], _v2[2], _t), lerp(_v1[3], _v2[3], _t)];
}

function gmui_animation_lerp_array(_a1, _a2, _t) {
	var _len = min(array_length(_a1), array_length(_a2));
	var _result = array_create(_len);
	for (var i = 0; i < _len; i++) {
		_result[i] = lerp(_a1[i], _a2[i], _t);
	}
	return _result;
}

// type detection
function gmui_animation_detect_value_type(_value) {
	if (is_array(_value)) {
		var _len = array_length(_value);
		switch (_len) {
			case 2: return gmui_animation_value_type.VECTOR2;
			case 3: return gmui_animation_value_type.VECTOR3;
			case 4: return gmui_animation_value_type.VECTOR4;
			default: return gmui_animation_value_type.ARRAY;
		}
	}
	return gmui_animation_value_type.REAL;
}

function gmui_animation_get_lerp_function(_type) {
	switch (_type) {
		case gmui_animation_value_type.COLOR3: return method({}, gmui_animation_lerp_color3);
		case gmui_animation_value_type.COLOR4: return method({}, gmui_animation_lerp_color4);
		case gmui_animation_value_type.VECTOR2: return method({}, gmui_animation_lerp_vector2);
		case gmui_animation_value_type.VECTOR3: return method({}, gmui_animation_lerp_vector3);
		case gmui_animation_value_type.VECTOR4: return method({}, gmui_animation_lerp_vector4);
		case gmui_animation_value_type.ARRAY: return method({}, gmui_animation_lerp_array);
		default: return undefined;
	}
}

function gmui_animation_is_value_simple(_type) {
	return (_type == gmui_animation_value_type.REAL || _type == gmui_animation_value_type.COLOR3);
}

function gmui_animation_is_value_array_type(_type) {
	return (_type == gmui_animation_value_type.VECTOR2 || 
	        _type == gmui_animation_value_type.VECTOR3 || 
	        _type == gmui_animation_value_type.VECTOR4 || 
	        _type == gmui_animation_value_type.ARRAY);
}

// value manipulation (helpers)
function gmui_animation_lerp_values(_start, _end, _type, _t, _lerp_func) {
	if (_lerp_func != undefined) {
		return _lerp_func(_start, _end, _t);
	}
	switch (_type) {
		case gmui_animation_value_type.COLOR3: return gmui_animation_lerp_color3(_start, _end, _t);
		case gmui_animation_value_type.COLOR4: return gmui_animation_lerp_color4(_start, _end, _t);
		case gmui_animation_value_type.VECTOR2: return gmui_animation_lerp_vector2(_start, _end, _t);
		case gmui_animation_value_type.VECTOR3: return gmui_animation_lerp_vector3(_start, _end, _t);
		case gmui_animation_value_type.VECTOR4: return gmui_animation_lerp_vector4(_start, _end, _t);
		case gmui_animation_value_type.ARRAY: return gmui_animation_lerp_array(_start, _end, _t);
		default: return lerp(_start, _end, _t);
	}
}

function gmui_animation_add_scalar_to_value(_value, _type, _scalar) {
	switch (_type) {
		case gmui_animation_value_type.REAL:
			return _value + _scalar;
		case gmui_animation_value_type.VECTOR2:
			return [_value[0] + _scalar, _value[1] + _scalar];
		case gmui_animation_value_type.VECTOR3:
			return [_value[0] + _scalar, _value[1] + _scalar, _value[2] + _scalar];
		case gmui_animation_value_type.VECTOR4:
			return [_value[0] + _scalar, _value[1] + _scalar, _value[2] + _scalar, _value[3] + _scalar];
		default:
			return _value;
	}
}

function gmui_animation_clamp_values(_value, _start, _end, _type) {
	if (!gmui_animation_is_value_simple(_type) && !gmui_animation_is_value_array_type(_type)) return _value;
	
	if (_type == gmui_animation_value_type.REAL) {
		var _min = min(_start, _end);
		var _max = max(_start, _end);
		return clamp(_value, _min, _max);
	}
	
	if (gmui_animation_is_value_array_type(_type)) {
		var _result = array_create(array_length(_value));
		for (var i = 0; i < array_length(_value); i++) {
			var _min = min(_start[i], _end[i]);
			var _max = max(_start[i], _end[i]);
			_result[i] = clamp(_value[i], _min, _max);
		}
		return _result;
	}
	
	return _value;
}

function gmui_animation_snap_value(_value, _end, _type, _threshold, _to_integer) {
	if (_type == gmui_animation_value_type.REAL) {
		if (_threshold > 0 && abs(_end - _value) <= _threshold) return _end;
		if (_to_integer) return round(_value);
		return _value;
	}
	
	if (gmui_animation_is_value_array_type(_type)) {
		var _result = array_create(array_length(_value));
		var _is_close = true;
		
		for (var i = 0; i < array_length(_value); i++) {
			if (_threshold > 0 && abs(_end[i] - _value[i]) <= _threshold) {
				_result[i] = _end[i];
			} else {
				_result[i] = _to_integer ? round(_value[i]) : _value[i];
				if (_result[i] != _end[i]) _is_close = false;
			}
		}
		
		if (_is_close && _threshold > 0) return _end;
		return _result;
	}
	
	return _value;
}

function gmui_animation_process_value(_value, _type, _processor) {
	if (_processor == undefined) return _value;
	
	if (_type == gmui_animation_value_type.REAL) {
		return _processor(_value);
	}
	
	if (gmui_animation_is_value_array_type(_type)) {
		var _result = array_create(array_length(_value));
		for (var i = 0; i < array_length(_value); i++) {
			_result[i] = _processor(_value[i]);
		}
		return _result;
	}
	
	return _value;
}

// create tween
function gmui_animation_remove_existing_tween(_id) {
	var _anim = gmui_animation_get();
	var _tweens = _anim.tweens;
	
	for (var i = 0; i < array_length(_tweens); i++) {
		if (_tweens[i] != undefined && _tweens[i].id == _id) {
			var _old = _tweens[i];
			if (_old.group != undefined) {
				var _group_list = ds_map_find_value(_anim.groups, _old.group);
				if (_group_list != undefined) {
					var _idx = array_get_index(_group_list, _id);
					if (_idx >= 0) array_delete(_group_list, _idx, 1);
				}
			}
			if (_old.state == gmui_animation_tween_state.PLAYING) _anim.active_tweens--;
			array_delete(_tweens, i, 1);
			ds_map_delete(_anim.tweens_map, _id);
			return true;
		}
	}
	return false;
}

function gmui_animation_create(_id, _start_val, _end_val, _duration = -1) {
	gmui_animation_init_check_safe();
	var _anim = gmui_animation_get();
	
	if (_duration < 0) { _duration = _anim.default_duration; }
	
	var _detected_type = gmui_animation_detect_value_type(_start_val);
	
	if (!is_array(_start_val) && _start_val >= 0 && _start_val <= 16777215) { // 16777215 ?
		// default is REAL for numbers, can be changed to COLOR3/COLOR4 by user
	}
	
	var _tween = {
		id: _id,
		group: undefined,
		
		value_type: _detected_type,
		start_value: _start_val,
		current_value: _start_val,
		end_value: _end_val,
		original_start: _start_val,
		original_end: _end_val,
		
		value_lerp: gmui_animation_get_lerp_function(_detected_type),
		value_processor: undefined,
		
		duration: _duration,
		elapsed: 0,
		delay: 0,
		direction: gmui_animation_tween_direction.FORWARD,
		
		use_system_delta: true,
		dt_override: undefined,
		time_scale_override: 1.0,
		
		easing: _anim.default_easing,
		easing_custom: undefined,
		easing_power: 1.0,
		easing_intensity: 1.0,
		
		state: gmui_animation_tween_state.IDLE,
		completed: false,
		
		repeat_mode: gmui_animation_repeat_mode.NONE,
		repeat_count: 0,
		repeat_delay: 0,
		repeat_elapsed: 0,
		repeat_even_only: false,
		
		ping_pong_forward: true,
		
		flags: gmui_animation_tween_flags.DELETE_ON_COMPLETE | gmui_animation_tween_flags.CLAMP_VALUES,
		oscillation_amplitude: 0,
		oscillation_frequency: 0,
		oscillation_phase: 0,
		noise_amount: 0,
		noise_seed: 0,
		
		snap_threshold: 0,
		snap_to_integer: false,
		
		on_start: undefined,
		on_update: undefined,
		on_complete: undefined,
		on_repeat: undefined,
		on_pingpong: undefined,
		on_pause: undefined,
		on_resume: undefined,
		on_kill: undefined,
		on_direction_change: undefined,
		
		user_data: undefined,
		
		creation_time: current_time,
		update_count: 0,
	};
	
	if (_tween.delay > 0) {
		_tween.elapsed = -_tween.delay;
	}
	
	if (_tween.direction == gmui_animation_tween_direction.BACKWARD) {
		var _temp = _tween.start_value;
		_tween.start_value = _tween.end_value;
		_tween.end_value = _temp;
		_tween.elapsed = _tween.duration;
	}
	
	array_push(_anim.tweens, _tween);
	ds_map_add(_anim.tweens_map, _id, _tween);
	_anim.total_tweens_created++;
	
	return _tween;
}

// configuration functions
function gmui_animation_set_easing(_id, _easing) {
	var _tween = ds_map_find_value(gmui_animation_get().tweens_map, _id);
	if (_tween != undefined) { _tween.easing = _easing; }
	return _tween;
}

function gmui_animation_set_custom_ease(_id, _func) {
	var _tween = ds_map_find_value(gmui_animation_get().tweens_map, _id);
	if (_tween != undefined) {
		_tween.easing = gmui_animation_ease.CUSTOM;
		_tween.easing_custom = method({}, _func);
	}
	return _tween;
}

function gmui_animation_set_repeat(_id, _count, _delay = 0, _even_only = false) {
	var _tween = ds_map_find_value(gmui_animation_get().tweens_map, _id);
	if (_tween != undefined) {
		_tween.repeat_mode = gmui_animation_repeat_mode.LOOP;
		_tween.repeat_count = _count;
		_tween.repeat_delay = _delay;
		_tween.repeat_even_only = _even_only;
	}
	return _tween;
}

function gmui_animation_set_pingpong(_id, _count = -1, _reverse_ease = true) {
	var _tween = ds_map_find_value(gmui_animation_get().tweens_map, _id);
	if (_tween != undefined) {
		_tween.repeat_mode = gmui_animation_repeat_mode.PING_PONG;
		_tween.repeat_count = _count;
		_tween.ping_pong_forward = true;
		if (_reverse_ease) {
			_tween.flags |= gmui_animation_tween_flags.REVERSE_EASE_ON_PINGPONG;
		}
	}
	return _tween;
}

function gmui_animation_set_pingpong_once(_id, _reverse_ease = true) {
	var _tween = ds_map_find_value(gmui_animation_get().tweens_map, _id);
	if (_tween != undefined) {
		_tween.repeat_mode = gmui_animation_repeat_mode.PING_PONG_ONCE;
		_tween.repeat_count = 1;
		_tween.ping_pong_forward = true;
		if (_reverse_ease) {
			_tween.flags |= gmui_animation_tween_flags.REVERSE_EASE_ON_PINGPONG;
		}
	}
	return _tween;
}

function gmui_animation_set_delay(_id, _delay) {
	var _tween = ds_map_find_value(gmui_animation_get().tweens_map, _id);
	if (_tween != undefined) {
		_tween.delay = _delay;
		_tween.elapsed = -_delay;
	}
	return _tween;
}

function gmui_animation_set_time_scale(_id, _scale) {
	var _tween = ds_map_find_value(gmui_animation_get().tweens_map, _id);
	if (_tween != undefined) { _tween.time_scale_override = _scale; }
	return _tween;
}

function gmui_animation_set_callbacks(_id, _on_start = undefined, _on_update = undefined, _on_complete = undefined) {
	var _tween = ds_map_find_value(gmui_animation_get().tweens_map, _id);
	if (_tween != undefined) {
		if (_on_start != undefined) _tween.on_start = method({}, _on_start);
		if (_on_update != undefined) _tween.on_update = method({}, _on_update);
		if (_on_complete != undefined) _tween.on_complete = method({}, _on_complete);
	}
	return _tween;
}

function gmui_animation_set_value_type(_id, _type) {
	var _tween = ds_map_find_value(gmui_animation_get().tweens_map, _id);
	if (_tween != undefined) {
		_tween.value_type = _type;
		_tween.value_lerp = gmui_animation_get_lerp_function(_type);
	}
	return _tween;
}

function gmui_animation_set_oscillation(_id, _amplitude, _frequency, _phase = 0) {
	var _tween = ds_map_find_value(gmui_animation_get().tweens_map, _id);
	if (_tween != undefined) {
		_tween.oscillation_amplitude = _amplitude;
		_tween.oscillation_frequency = _frequency;
		_tween.oscillation_phase = _phase;
	}
	return _tween;
}

function gmui_animation_set_noise(_id, _amount, _seed = 0) {
	var _tween = ds_map_find_value(gmui_animation_get().tweens_map, _id);
	if (_tween != undefined) {
		_tween.noise_amount = _amount;
		_tween.noise_seed = _seed;
	}
	return _tween;
}

function gmui_animation_set_snap(_id, _threshold, _to_integer = false) {
	var _tween = ds_map_find_value(gmui_animation_get().tweens_map, _id);
	if (_tween != undefined) {
		_tween.snap_threshold = _threshold;
		_tween.snap_to_integer = _to_integer;
	}
	return _tween;
}

function gmui_animation_set_flags(_id, _flags) {
	var _tween = ds_map_find_value(gmui_animation_get().tweens_map, _id);
	if (_tween != undefined) { _tween.flags = _flags; }
	return _tween;
}

function gmui_animation_add_flags(_id, _flags) {
	var _tween = ds_map_find_value(gmui_animation_get().tweens_map, _id);
	if (_tween != undefined) { _tween.flags |= _flags; }
	return _tween;
}

function gmui_animation_set_group(_id, _group_name) {
	var _tween = ds_map_find_value(gmui_animation_get().tweens_map, _id);
	var _anim = gmui_animation_get();
	
	if (_tween != undefined) {
		_tween.group = _group_name;
		var _group_list = ds_map_find_value(_anim.groups, _group_name);
		if (_group_list == undefined) {
			_group_list = [];
			ds_map_add(_anim.groups, _group_name, _group_list);
		}
		array_push(_group_list, _id);
	}
	return _tween;
}

function gmui_animation_set_user_data(_id, _data) {
	var _tween = ds_map_find_value(gmui_animation_get().tweens_map, _id);
	if (_tween != undefined) { _tween.user_data = _data; }
	return _tween;
}

// tween control
function gmui_animation_play(_id) {
	var _tween = ds_map_find_value(gmui_animation_get().tweens_map, _id);
	if (_tween != undefined && _tween.state == gmui_animation_tween_state.IDLE) {
		_tween.state = gmui_animation_tween_state.PLAYING;
		var _anim = gmui_animation_get();
		_anim.active_tweens++;
		if (_tween.on_start != undefined) { _tween.on_start(_tween); }
	}
}

function gmui_animation_pause(_id) {
	var _tween = ds_map_find_value(gmui_animation_get().tweens_map, _id);
	if (_tween != undefined && _tween.state == gmui_animation_tween_state.PLAYING) {
		_tween.state = gmui_animation_tween_state.PAUSED;
		var _anim = gmui_animation_get();
		_anim.active_tweens--;
		if (_tween.on_pause != undefined) { _tween.on_pause(_tween); }
	}
}

function gmui_animation_resume(_id) {
	var _tween = ds_map_find_value(gmui_animation_get().tweens_map, _id);
	if (_tween != undefined && _tween.state == gmui_animation_tween_state.PAUSED) {
		_tween.state = gmui_animation_tween_state.PLAYING;
		var _anim = gmui_animation_get();
		_anim.active_tweens++;
		if (_tween.on_resume != undefined) { _tween.on_resume(_tween); }
	}
}

function gmui_animation_toggle(_id) {
	var _tween = ds_map_find_value(gmui_animation_get().tweens_map, _id);
	if (_tween != undefined) {
		if (_tween.state == gmui_animation_tween_state.PLAYING) {
			gmui_animation_pause(_id);
		} else if (_tween.state == gmui_animation_tween_state.PAUSED) {
			gmui_animation_resume(_id);
		}
	}
}

function gmui_animation_stop(_id, _go_to_end = false) {
	var _anim = gmui_animation_get();
	var _tween = ds_map_find_value(_anim.tweens_map, _id);
	if (_tween != undefined) {
		if (_go_to_end) {
			_tween.current_value = _tween.end_value;
		}
		if (_tween.state == gmui_animation_tween_state.PLAYING) {
			_anim.active_tweens--;
		}
		_tween.state = gmui_animation_tween_state.KILLED;
		_tween.completed = true;
		
		ds_map_delete(_anim.tweens_map, _id);
		
		if (_tween.group != undefined) {
			var _group_list = ds_map_find_value(_anim.groups, _tween.group);
			if (_group_list != undefined) {
				var _group_idx = array_get_index(_group_list, _id);
				if (_group_idx >= 0) {
					array_delete(_group_list, _group_idx, 1);
				}
			}
		}
		
		if (_tween.on_kill != undefined) { _tween.on_kill(_tween); }
	}
}

function gmui_animation_kill_group(_group_name) {
	var _anim = gmui_animation_get();
	var _group_list = ds_map_find_value(_anim.groups, _group_name);
	if (_group_list != undefined) {
		for (var i = array_length(_group_list) - 1; i >= 0; i--) {
			gmui_animation_stop(_group_list[i], false);
		}
	}
}

function gmui_animation_kill_all() {
	var _anim = gmui_animation_get();
	var _tweens = _anim.tweens;
	for (var i = array_length(_tweens) - 1; i >= 0; i--) {
		var _tween = _tweens[i];
		if (_tween != undefined && _tween.state == gmui_animation_tween_state.PLAYING) {
			gmui_animation_stop(_tween.id, false);
		}
	}
}

function gmui_animation_reverse(_id) {
	var _tween = ds_map_find_value(gmui_animation_get().tweens_map, _id);
	if (_tween != undefined && _tween.state == gmui_animation_tween_state.PLAYING) {
		var _temp = _tween.start_value;
		_tween.start_value = _tween.end_value;
		_tween.end_value = _temp;
		_tween.elapsed = max(0, _tween.duration - _tween.elapsed);
		if (_tween.on_direction_change != undefined) { _tween.on_direction_change(_tween); }
	}
}

function gmui_animation_seek(_id, _progress) {
	var _tween = ds_map_find_value(gmui_animation_get().tweens_map, _id);
	if (_tween != undefined) {
		_progress = clamp(_progress, 0, 1);
		_tween.elapsed = _tween.duration * _progress;
		var _eased = gmui_animation_get_eased_value(_tween, _progress);
		_tween.current_value = gmui_animation_lerp_values(_tween.start_value, _tween.end_value, _tween.value_type, _eased, _tween.value_lerp);
	}
}

// value getters
function gmui_animation_get_value(_id) {
	gmui_animation_init_check_safe();
	var _tween = ds_map_find_value(gmui_animation_get().tweens_map, _id);
	if (_tween != undefined) { return _tween.current_value; }
	return undefined;
}

function gmui_animation_get_progress(_id) {
	var _tween = ds_map_find_value(gmui_animation_get().tweens_map, _id);
	if (_tween != undefined && _tween.duration > 0) {
		return clamp(_tween.elapsed / _tween.duration, 0, 1);
	}
	return 0;
}

function gmui_animation_is_playing(_id) {
	var _tween = ds_map_find_value(gmui_animation_get().tweens_map, _id);
	return (_tween != undefined && _tween.state == gmui_animation_tween_state.PLAYING);
}

function gmui_animation_exists(_id) {
	var _tween = ds_map_find_value(gmui_animation_get().tweens_map, _id);
	return (_tween != undefined && _tween.state != gmui_animation_tween_state.KILLED);
}

// global settings
function gmui_animation_set_global_time_scale(_scale) {
	var _anim = gmui_animation_get();
	if (_anim != undefined) { _anim.global_time_scale = _scale; }
}

function gmui_animation_get_global_time_scale() {
	var _anim = gmui_animation_get();
	if (_anim != undefined) { return _anim.global_time_scale; }
	return 1.0;
}

// update call
function gmui_animation_update() {
	var _anim = gmui_animation_get();
	if (_anim == undefined) { return false; }
	
	var _tweens = _anim.tweens;
	
	for (var i = 0; i < array_length(_tweens); i++) {
		var _tween = _tweens[i];
		if (_tween == undefined || _tween.state == gmui_animation_tween_state.KILLED) continue;
		if (_tween.state != gmui_animation_tween_state.PLAYING) continue;
		
		var _dt = _tween.use_system_delta ? delta_time : _tween.dt_override;
		
		if (!(_tween.flags & gmui_animation_tween_flags.IGNORE_TIME_SCALE)) {
			_dt *= _anim.global_time_scale;
		}
		_dt *= _tween.time_scale_override;
		
		if (_tween.direction == gmui_animation_tween_direction.BACKWARD) {
			_dt = -_dt;
		}
		
		_tween.elapsed += _dt;
		_tween.update_count++;
		
		if (_tween.elapsed < 0) continue;
		
		var _progress = (_tween.duration > 0) ? (_tween.elapsed / _tween.duration) : 1.0;
		
		if (_tween.direction == gmui_animation_tween_direction.BACKWARD && _progress <= 0.0) {
			_tween.current_value = _tween.end_value;
			gmui_animation_complete_tween(_tween);
			continue;
		}
		
		if (_progress >= 1.0) {
			if (_tween.repeat_mode == gmui_animation_repeat_mode.LOOP && 
			    (_tween.repeat_count == -1 || _tween.repeat_count > 0)) {
				
				if (_tween.repeat_count > 0) {
					_tween.repeat_count--;
				}
				
				if (_tween.repeat_delay > 0) {
					_tween.repeat_elapsed = 0;
					_tween.elapsed = -_tween.repeat_delay;
					_progress = 0;
				} else {
					_tween.elapsed = _tween.elapsed - _tween.duration;
					_progress = _tween.elapsed / _tween.duration;
				}
				
				if (_tween.on_repeat != undefined) { _tween.on_repeat(_tween); }
				
			} else if (_tween.repeat_mode == gmui_animation_repeat_mode.PING_PONG || 
			           _tween.repeat_mode == gmui_animation_repeat_mode.PING_PONG_ONCE) {
				
				if (_tween.repeat_count == -1 || _tween.repeat_count > 0) {
					if (_tween.repeat_count > 0) {
						_tween.repeat_count--;
					}
					
					_tween.ping_pong_forward = !_tween.ping_pong_forward;
					var _temp = _tween.start_value;
					_tween.start_value = _tween.end_value;
					_tween.end_value = _temp;
					
					if (_tween.repeat_delay > 0) {
						_tween.repeat_elapsed = 0;
						_tween.elapsed = -_tween.repeat_delay;
					} else {
						_tween.elapsed = _tween.elapsed - _tween.duration;
					}
					_progress = _tween.elapsed / _tween.duration;
					
					if (_tween.on_pingpong != undefined) { _tween.on_pingpong(_tween); }
				} else {
					_tween.current_value = _tween.end_value;
					gmui_animation_complete_tween(_tween);
					continue;
				}
			} else {
				_tween.current_value = _tween.end_value;
				gmui_animation_complete_tween(_tween);
				continue;
			}
		}
		
		var _eased_progress = gmui_animation_get_eased_value(_tween, clamp(_progress, 0, 1));
		
		_tween.current_value = gmui_animation_lerp_values(_tween.start_value, _tween.end_value, _tween.value_type, _eased_progress, _tween.value_lerp);
		
		if (_tween.oscillation_amplitude > 0) {
			var _osc = sin(_progress * _tween.oscillation_frequency * 2 * pi + _tween.oscillation_phase) * _tween.oscillation_amplitude * (1 - _progress);
			_tween.current_value = gmui_animation_add_scalar_to_value(_tween.current_value, _tween.value_type, _osc);
		}
		
		if (_tween.noise_amount > 0 && (gmui_animation_is_value_simple(_tween.value_type) || gmui_animation_is_value_array_type(_tween.value_type))) {
			random_set_seed(_tween.noise_seed + _tween.update_count);
			var _noise = random_range(-_tween.noise_amount, _tween.noise_amount);
			_tween.current_value = gmui_animation_add_scalar_to_value(_tween.current_value, _tween.value_type, _noise);
		}
		
		_tween.current_value = gmui_animation_snap_value(_tween.current_value, _tween.end_value, _tween.value_type, _tween.snap_threshold, _tween.snap_to_integer);
		
		_tween.current_value = gmui_animation_process_value(_tween.current_value, _tween.value_type, _tween.value_processor);
		
		if (_tween.flags & gmui_animation_tween_flags.CLAMP_VALUES) {
			_tween.current_value = gmui_animation_clamp_values(_tween.current_value, _tween.start_value, _tween.end_value, _tween.value_type);
		}
		
		if (_tween.on_update != undefined) { _tween.on_update(_tween); }
	}
	
	for (var i = array_length(_tweens) - 1; i >= 0; i--) {
		var _tween = _tweens[i];
		if (_tween == undefined) { array_delete(_tweens, i, 1); continue; }
		if (_tween.state != gmui_animation_tween_state.COMPLETED && _tween.state != gmui_animation_tween_state.KILLED) continue;
		
		if (ds_map_find_value(_anim.tweens_map, _tween.id) != undefined) {
			ds_map_delete(_anim.tweens_map, _tween.id);
		}
		if (_tween.group != undefined) {
			var _group_list = ds_map_find_value(_anim.groups, _tween.group);
			if (_group_list != undefined) {
				var _group_idx = array_get_index(_group_list, _tween.id);
				if (_group_idx >= 0) { array_delete(_group_list, _group_idx, 1); }
			}
		}
		array_delete(_tweens, i, 1);
	}
	
	return true;
}

function gmui_animation_complete_tween(_tween) {
	_tween.state = gmui_animation_tween_state.COMPLETED;
	_tween.completed = true;
	var _anim = gmui_animation_get();
	_anim.active_tweens--;
	
	if (_tween.on_complete != undefined) { _tween.on_complete(_tween); }
}

// easing functions
function gmui_animation_get_eased_value(_tween, _t) {
	var _easing = _tween.easing;
	var _intensity = _tween.easing_intensity;
	
	if (_tween.flags & gmui_animation_tween_flags.REVERSE_EASE_ON_PINGPONG && !_tween.ping_pong_forward) {
		_t = 1 - _t;
	}
	
	_t = clamp(power(clamp(_t, 0, 1), _tween.easing_power), 0, 1);
	
	var _result = 0;
	
	switch (_easing) {
		case gmui_animation_ease.LINEAR:				_result  = _t;																															break;
		case gmui_animation_ease.IN_QUAD:				_result  = power(_t, 2);																												break;
		case gmui_animation_ease.OUT_QUAD:				_result  = -_t * (_t - 2);																												break;
		case gmui_animation_ease.IN_OUT_QUAD:			_result  = (_t < 0.5) ? 2 * power(_t, 2) : -1 + (4 - 2 * _t) * _t;																		break;
		case gmui_animation_ease.IN_CUBIC:				_result  = power(_t, 3);																												break;
		case gmui_animation_ease.OUT_CUBIC:				_t		-= 1; _result = power(_t, 3) + 1;																								break;
		case gmui_animation_ease.IN_OUT_CUBIC:			_result  = (_t < 0.5) ? 4 * power(_t, 3) : power(2 * _t - 2, 3) * 0.5 + 1;																break;
		case gmui_animation_ease.IN_QUART:				_result  = power(_t, 4);																												break;
		case gmui_animation_ease.OUT_QUART:				_t		-= 1; _result = -(power(_t, 4) - 1);																							break;
		case gmui_animation_ease.IN_OUT_QUART:			_result  = (_t < 0.5) ? 8 * power(_t, 4) : -1/2 * power(2 * _t - 2, 4) + 1;																break;
		case gmui_animation_ease.IN_QUINT:				_result  = power(_t, 5);																												break;
		case gmui_animation_ease.OUT_QUINT:				_t		-= 1; _result = power(_t, 5) + 1;																								break;
		case gmui_animation_ease.IN_OUT_QUINT:			_result  = (_t < 0.5) ? 16 * power(_t, 5) : power(2 * _t - 2, 5) * 0.5 + 1;																break;
		case gmui_animation_ease.IN_SINE:				_result  = -cos(_t * pi / 2) + 1;																										break;
		case gmui_animation_ease.OUT_SINE:				_result  = sin(_t * pi / 2);																											break;
		case gmui_animation_ease.IN_OUT_SINE:			_result  = -(cos(pi * _t) - 1) / 2;																										break;
		case gmui_animation_ease.IN_EXPO:				_result  = (_t == 0) ? 0 : power(2, 10 * (_t - 1));																						break;
		case gmui_animation_ease.OUT_EXPO:				_result  = (_t == 1) ? 1 : -power(2, -10 * _t) + 1;																						break;
		case gmui_animation_ease.IN_OUT_EXPO:
			if (_t == 0 || _t == 1) { _result = _t; break; }
			_result = (_t < 0.5) ? power(2, 20 * _t - 10) / 2 : (2 - power(2, -20 * _t + 10)) / 2;
			break;
		case gmui_animation_ease.IN_CIRC:				_result  = -(sqrt(1 - power(_t, 2)) - 1);																								break;
		case gmui_animation_ease.OUT_CIRC: _t -= 1;		_result  = sqrt(1 - power(_t, 2));																										break;
		case gmui_animation_ease.IN_OUT_CIRC:			_result  = (_t < 0.5) ? (1 - sqrt(1 - power(2 * _t, 2))) / 2 : (sqrt(1 - power(-2 * _t + 2, 2)) + 1) / 2;								break;
		case gmui_animation_ease.IN_ELASTIC:
			if (_t == 0 || _t == 1) { _result = _t; break; }
			var _p = 0.3 * _intensity;
			_result = -power(2, 10 * (_t - 1)) * sin((_t - 1 - _p / 4) * (2 * pi) / _p);
			break;
		case gmui_animation_ease.OUT_ELASTIC:
			if (_t == 0 || _t == 1) { _result = _t; break; }
			_result = power(2, -10 * _t) * sin((_t - 1) * (2 * pi) / (0.3 * _intensity)) + 1;
			break;
		case gmui_animation_ease.IN_OUT_ELASTIC:
			if (_t == 0 || _t == 1) { _result = _t; break; }
			_t *= 2; var _p2 = 0.45 * _intensity;
			if (_t < 1) { _result = -0.5 * power(2, 10 * (_t - 1)) * sin((_t - 1 - _p2 / 4) * (2 * pi) / _p2); }
			else { _result = power(2, -10 * (_t - 1)) * sin((_t - 1 - _p2 / 4) * (2 * pi) / _p2) * 0.5 + 1; }
			break;
		case gmui_animation_ease.IN_BACK:
			var _s = 1.70158 * _intensity;
			_result = _t * _t * ((_s + 1) * _t - _s);
			break;
		case gmui_animation_ease.OUT_BACK:
			_t -= 1; var _s2 = 1.70158 * _intensity;
			_result = _t * _t * ((_s2 + 1) * _t + _s2) + 1;
			break;
		case gmui_animation_ease.IN_OUT_BACK:
			var _s3 = 1.70158 * _intensity; _t *= 2;
			if (_t < 1) { _result = 0.5 * _t * _t * ((_s3 * 1.525 + 1) * _t - _s3 * 1.525); }
			else { _t -= 2; _result = 0.5 * (_t * _t * ((_s3 * 1.525 + 1) * _t + _s3 * 1.525) + 2); }
			break;
		case gmui_animation_ease.IN_BOUNCE:				_result  = 1 - gmui_animation_ease_out_bounce(1 - _t);																					break;
		case gmui_animation_ease.OUT_BOUNCE:			_result  = gmui_animation_ease_out_bounce(_t);																							break;
		case gmui_animation_ease.IN_OUT_BOUNCE:			_result  = (_t < 0.5) ? (1 - gmui_animation_ease_out_bounce(1 - 2 * _t)) / 2 : (1 + gmui_animation_ease_out_bounce(2 * _t - 1)) / 2;	break;
		case gmui_animation_ease.CUSTOM:
			if (_tween.easing_custom != undefined) { _result = _tween.easing_custom(_t); }
			else { _result = _t; }
			break;
		default: _result = _t; break;
	}
	
	return clamp(_result, 0, 1);
}

function gmui_animation_ease_out_bounce(_t) {
	var _n1 = 7.5625, _d1 = 2.75;
	if (_t < 1 / _d1) { return _n1 * _t * _t; }
	else if (_t < 2 / _d1) { _t -= 1.5 / _d1; return _n1 * _t * _t + 0.75; }
	else if (_t < 2.5 / _d1) { _t -= 2.25 / _d1; return _n1 * _t * _t + 0.9375; }
	else { _t -= 2.625 / _d1; return _n1 * _t * _t + 0.984375; }
}

// convenience/quick start functions
function gmui_animation_tween(_id, _from, _to, _duration = -1, _easing = undefined) {
	gmui_animation_init_check_safe();
	var _exists = ds_map_find_value(gmui_animation_get().tweens_map, _id);
	if (_exists != undefined && _exists.state != gmui_animation_tween_state.KILLED) { return gmui_animation_get_value(_id); }
	gmui_animation_tween_start(_id, _from, _to, _duration, _easing);
	return gmui_animation_get_value(_id);
}

function gmui_animation_tween_start(_id, _from, _to, _duration = -1, _easing = undefined) {
	gmui_animation_init_check_safe();
	gmui_animation_remove_existing_tween(_id);
	return gmui_animation_tween_internal(_id, _from, _to, _duration, _easing);
}

function gmui_animation_tween_internal(_id, _from, _to, _duration, _easing) {
	var _tween = gmui_animation_create(_id, _from, _to, _duration);
	
	var _anim = gmui_animation_get();
	var _existing = ds_map_find_value(_anim.tweens_map, _id);
	
	if (_existing != undefined && _tween.flags & gmui_animation_tween_flags.OVERRIDE_EXISTING) {
		gmui_animation_remove_existing_tween(_id);
		_tween = gmui_animation_create(_id, _from, _to, _duration);
	}
	
	if (_easing != undefined) { gmui_animation_set_easing(_id, _easing); }
	
	_tween.state = gmui_animation_tween_state.PLAYING;
	_anim.active_tweens++;
	
	if (_tween.on_start != undefined) { _tween.on_start(_tween); }
	
	return _tween;
}

function gmui_animation_pulse(_id, _base_value, _pulse_to, _duration = 200000, _easing = undefined) {
	var _tween = gmui_animation_tween_start(_id, _base_value, _pulse_to, _duration, _easing);
	gmui_animation_set_pingpong_once(_id, true);
	return _tween;
}

function gmui_animation_shake(_id, _center_value, _intensity, _duration = 100000, _frequency = 4) {
	var _tween = gmui_animation_create(_id, _center_value, _center_value, _duration);
	_tween.oscillation_amplitude = _intensity;
	_tween.oscillation_frequency = _frequency;
	_tween.flags = _tween.flags & ~gmui_animation_tween_flags.CLAMP_VALUES;
	_tween.state = gmui_animation_tween_state.PLAYING;
	gmui_animation_get().active_tweens++;
	return _tween;
}

// utility stuff
function gmui_animation_lerp(_a, _b, _t) { return _a + (_b - _a) * clamp(_t, 0, 1); }

function gmui_animation_remap(_value, _from_start, _from_end, _to_start, _to_end) {
	return gmui_animation_lerp(_to_start, _to_end, (_value - _from_start) / (_from_end - _from_start));
}

function gmui_animation_get_active_count() {
	var _anim = gmui_animation_get();
	return (_anim != undefined) ? _anim.active_tweens : 0;
}

function gmui_animation_get_total_count() {
	var _anim = gmui_animation_get();
	return (_anim != undefined) ? _anim.total_tweens_created : 0;
}

// cleanup
function gmui_animation_cleanup() {
	var _anim = gmui_animation_get();
	if (_anim == undefined) { return; }
	
	var _group_keys = ds_map_keys_to_array(_anim.groups);
	for (var g = 0; g < array_length(_group_keys); g++) {
		ds_map_delete(_anim.groups, _group_keys[g]);
	}
	ds_map_destroy(_anim.groups);
	ds_map_destroy(_anim.tweens_map);
	
	var _timeline_keys = ds_map_keys_to_array(_anim.timelines);
	for (var t = 0; t < array_length(_timeline_keys); t++) {
		ds_map_delete(_anim.timelines, _timeline_keys[t]);
	}
	ds_map_destroy(_anim.timelines);
	
	_anim.tweens = [];
}

// type specific creation
function gmui_animation_tween_color3_start(_id, _from_color, _to_color, _duration = -1, _easing = undefined) {
	gmui_animation_init_check_safe();
	gmui_animation_remove_existing_tween(_id);
	var _tween = gmui_animation_create(_id, _from_color, _to_color, _duration);
	_tween.value_type = gmui_animation_value_type.COLOR3;
	_tween.value_lerp = method({}, gmui_animation_lerp_color3);
	if (_easing != undefined) gmui_animation_set_easing(_id, _easing);
	_tween.state = gmui_animation_tween_state.PLAYING;
	gmui_animation_get().active_tweens++;
	return _tween;
}

function gmui_animation_tween_color3(_id, _from_color, _to_color, _duration = -1, _easing = undefined) {
	gmui_animation_init_check_safe();
	var _exists = ds_map_find_value(gmui_animation_get().tweens_map, _id);
	if (_exists != undefined && _exists.state != gmui_animation_tween_state.KILLED) { return gmui_animation_get_value(_id); }
	gmui_animation_tween_color3_start(_id, _from_color, _to_color, _duration, _easing);
	return gmui_animation_get_value(_id);
}

function gmui_animation_tween_color4_start(_id, _from_color, _to_color, _duration = -1, _easing = undefined) {
	gmui_animation_init_check_safe();
	gmui_animation_remove_existing_tween(_id);
	var _tween = gmui_animation_create(_id, _from_color, _to_color, _duration);
	_tween.value_type = gmui_animation_value_type.COLOR4;
	_tween.value_lerp = method({}, gmui_animation_lerp_color4);
	if (_easing != undefined) gmui_animation_set_easing(_id, _easing);
	_tween.state = gmui_animation_tween_state.PLAYING;
	gmui_animation_get().active_tweens++;
	return _tween;
}

function gmui_animation_tween_color4(_id, _from_color, _to_color, _duration = -1, _easing = undefined) {
	gmui_animation_init_check_safe();
	var _exists = ds_map_find_value(gmui_animation_get().tweens_map, _id);
	if (_exists != undefined && _exists.state != gmui_animation_tween_state.KILLED) { return gmui_animation_get_value(_id); }
	gmui_animation_tween_color4_start(_id, _from_color, _to_color, _duration, _easing);
	return gmui_animation_get_value(_id);
}

function gmui_animation_tween_vector2_start(_id, _from_vec2, _to_vec2, _duration = -1, _easing = undefined) {
	gmui_animation_init_check_safe();
	gmui_animation_remove_existing_tween(_id);
	var _tween = gmui_animation_create(_id, _from_vec2, _to_vec2, _duration);
	_tween.value_type = gmui_animation_value_type.VECTOR2;
	_tween.value_lerp = gmui_animation_get_lerp_function(gmui_animation_value_type.VECTOR2);
	if (_easing != undefined) gmui_animation_set_easing(_id, _easing);
	_tween.state = gmui_animation_tween_state.PLAYING;
	gmui_animation_get().active_tweens++;
	return _tween;
}

function gmui_animation_tween_vector2(_id, _from_vec2, _to_vec2, _duration = -1, _easing = undefined) {
	gmui_animation_init_check_safe();
	var _exists = ds_map_find_value(gmui_animation_get().tweens_map, _id);
	if (_exists != undefined && _exists.state != gmui_animation_tween_state.KILLED) { return gmui_animation_get_value(_id); }
	gmui_animation_tween_vector2_start(_id, _from_vec2, _to_vec2, _duration, _easing);
	return gmui_animation_get_value(_id);
}

function gmui_animation_tween_vector3_start(_id, _from_vec3, _to_vec3, _duration = -1, _easing = undefined) {
	gmui_animation_init_check_safe();
	gmui_animation_remove_existing_tween(_id);
	var _tween = gmui_animation_create(_id, _from_vec3, _to_vec3, _duration);
	_tween.value_type = gmui_animation_value_type.VECTOR3;
	_tween.value_lerp = gmui_animation_get_lerp_function(gmui_animation_value_type.VECTOR3);
	if (_easing != undefined) gmui_animation_set_easing(_id, _easing);
	_tween.state = gmui_animation_tween_state.PLAYING;
	gmui_animation_get().active_tweens++;
	return _tween;
}

function gmui_animation_tween_vector3(_id, _from_vec3, _to_vec3, _duration = -1, _easing = undefined) {
	gmui_animation_init_check_safe();
	var _exists = ds_map_find_value(gmui_animation_get().tweens_map, _id);
	if (_exists != undefined && _exists.state != gmui_animation_tween_state.KILLED) { return gmui_animation_get_value(_id); }
	gmui_animation_tween_vector3_start(_id, _from_vec3, _to_vec3, _duration, _easing);
	return gmui_animation_get_value(_id);
}

function gmui_animation_tween_vector4_start(_id, _from_vec4, _to_vec4, _duration = -1, _easing = undefined) {
	gmui_animation_init_check_safe();
	gmui_animation_remove_existing_tween(_id);
	var _tween = gmui_animation_create(_id, _from_vec4, _to_vec4, _duration);
	_tween.value_type = gmui_animation_value_type.VECTOR4;
	_tween.value_lerp = gmui_animation_get_lerp_function(gmui_animation_value_type.VECTOR4);
	if (_easing != undefined) gmui_animation_set_easing(_id, _easing);
	_tween.state = gmui_animation_tween_state.PLAYING;
	gmui_animation_get().active_tweens++;
	return _tween;
}

function gmui_animation_tween_vector4(_id, _from_vec4, _to_vec4, _duration = -1, _easing = undefined) {
	gmui_animation_init_check_safe();
	var _exists = ds_map_find_value(gmui_animation_get().tweens_map, _id);
	if (_exists != undefined && _exists.state != gmui_animation_tween_state.KILLED) { return gmui_animation_get_value(_id); }
	gmui_animation_tween_vector4_start(_id, _from_vec4, _to_vec4, _duration, _easing);
	return gmui_animation_get_value(_id);
}

function gmui_animation_tween_array_start(_id, _from_array, _to_array, _duration = -1, _easing = undefined) {
	gmui_animation_init_check_safe();
	gmui_animation_remove_existing_tween(_id);
	var _tween = gmui_animation_create(_id, _from_array, _to_array, _duration);
	_tween.value_type = gmui_animation_value_type.ARRAY;
	_tween.value_lerp = gmui_animation_get_lerp_function(gmui_animation_value_type.ARRAY);
	if (_easing != undefined) gmui_animation_set_easing(_id, _easing);
	_tween.state = gmui_animation_tween_state.PLAYING;
	gmui_animation_get().active_tweens++;
	return _tween;
}

function gmui_animation_tween_array(_id, _from_array, _to_array, _duration = -1, _easing = undefined) {
	gmui_animation_init_check_safe();
	var _exists = ds_map_find_value(gmui_animation_get().tweens_map, _id);
	if (_exists != undefined && _exists.state != gmui_animation_tween_state.KILLED) { return gmui_animation_get_value(_id); }
	gmui_animation_tween_array_start(_id, _from_array, _to_array, _duration, _easing);
	return gmui_animation_get_value(_id);
}

// demo
function gmui_animation_demo() {
    if (gmui_begin("Animation System Demo", 50, 50, 550, 500)) {
        gmui_text("GMUI Animation System - Feature Demo");
        gmui_separator();
        
        gmui_text_label("Active Tweens", gmui_animation_get_active_count());
        gmui_text_label("Total Created", gmui_animation_get_total_count());
        gmui_text_label("Global Time Scale", gmui_animation_get_global_time_scale());
        
        static global_ts = 1.0;
        global_ts = gmui_slider(global_ts, 0, 3, gmui_get_available_width());
        if (global_ts != gmui_animation_get_global_time_scale()) {
            gmui_animation_set_global_time_scale(global_ts);
        }
        gmui_text($"Global Time Scale: {string_format(global_ts, 1, 2)}x");
        
        gmui_separator_text_left("Basic Tweens");
        
        if (gmui_begin_collapsing_header("Basic Tween Types", true)) {
            
            if (gmui_begin_collapsing_header_ex("Real Value Tween")) {
                if (gmui_button("Start Linear")) {
                    gmui_animation_tween("demo_real", 0, 1, 1000000, gmui_animation_ease.LINEAR);
                }
                gmui_sameline();
                if (gmui_button("Start Bounce")) {
                    gmui_animation_tween("demo_real", 0, 1, 1000000, gmui_animation_ease.OUT_BOUNCE);
                }
                gmui_sameline();
                if (gmui_button("Start Elastic")) {
                    gmui_animation_tween("demo_real", 0, 1, 1000000, gmui_animation_ease.OUT_ELASTIC);
                }
                
                var val = gmui_animation_get_value("demo_real") ?? 0;
                gmui_text($"Value: {string_format(val, 1, 3)}");
                gmui_progress(val, 1, gmui_get_available_width(), true);
                
                gmui_end_collapsing_header();
            }
            
            if (gmui_begin_collapsing_header_ex("Color3 Tween (RGB)")) {
                static demo_color3_fallback = c_black;
                
                if (gmui_button("Red → Blue")) {
                    demo_color3_fallback = gmui_animation_tween_color3("demo_color3", c_red, c_blue, 1500000, gmui_animation_ease.IN_OUT_QUAD);
                }
                gmui_sameline();
                if (gmui_button("Yellow → Purple")) {
                    demo_color3_fallback = gmui_animation_tween_color3("demo_color3", c_yellow, c_purple, 1500000, gmui_animation_ease.IN_OUT_QUAD);
                }
                
                var col = gmui_animation_get_value("demo_color3");
                if (col == undefined) { col = demo_color3_fallback; }
                else { demo_color3_fallback = col; }
                
                gmui_color_button_3(col, 32);
                gmui_sameline();
                gmui_text($"R:{string(color_get_red(col))} G:{string(color_get_green(col))} B:{string(color_get_blue(col))}");
                
                gmui_end_collapsing_header();
            }
            
            if (gmui_begin_collapsing_header_ex("Color4 Tween (RGBA)")) {
                static demo_color4_fallback = gmui_make_color_rgba(255, 100, 50, 128);
                
                if (gmui_button("Fade In")) {
                    demo_color4_fallback = gmui_animation_tween_color4("demo_color4", 
                        gmui_make_color_rgba(255, 100, 50, 0),
                        gmui_make_color_rgba(255, 100, 50, 255),
                        1000000);
                }
                gmui_sameline();
                if (gmui_button("Fade Out")) {
                    demo_color4_fallback = gmui_animation_tween_color4("demo_color4", 
                        gmui_make_color_rgba(255, 100, 50, 255),
                        gmui_make_color_rgba(255, 100, 50, 0),
                        1000000);
                }
                
                var col4 = gmui_animation_get_value("demo_color4");
                if (col4 == undefined) { col4 = demo_color4_fallback; }
                else { demo_color4_fallback = col4; }
                
                var arr4 = gmui_color_rgba_to_array(col4);
                gmui_color_button_4(col4, 32);
                gmui_sameline();
                gmui_text($"R:{string(arr4[0])} G:{string(arr4[1])} B:{string(arr4[2])} A:{string(arr4[3])}");
                
                gmui_end_collapsing_header();
            }
            
            if (gmui_begin_collapsing_header_ex("Vector2 Tween")) {
                if (gmui_button("Move Corner → Corner")) {
                    gmui_animation_tween_vector2("demo_vec2", [0, 0], [1, 1], 1500000, gmui_animation_ease.IN_OUT_BACK);
                }
                gmui_sameline();
                if (gmui_button("Bounce")) {
                    gmui_animation_tween_vector2("demo_vec2", [0, 0], [1, 1], 1500000, gmui_animation_ease.OUT_BOUNCE);
                }
                
                var v2 = gmui_animation_get_value("demo_vec2") ?? [0, 0];
                gmui_text($"X: {string_format(v2[0], 1, 3)}  Y: {string_format(v2[1], 1, 3)}");
                gmui_progress(v2[0], 1, gmui_get_available_width(), true);
                gmui_progress(v2[1], 1, gmui_get_available_width(), true);
                
                gmui_end_collapsing_header();
            }
            
            if (gmui_begin_collapsing_header_ex("Vector3 Tween")) {
                if (gmui_button("Animate 3D")) {
                    gmui_animation_tween_vector3("demo_vec3", [0, 0, 0], [1, 1, 1], 1500000, gmui_animation_ease.IN_OUT_QUAD);
                }
                
                var v3 = gmui_animation_get_value("demo_vec3") ?? [0, 0, 0];
                gmui_text($"X: {string_format(v3[0], 1, 2)}  Y: {string_format(v3[1], 1, 2)}  Z: {string_format(v3[2], 1, 2)}");
                gmui_progress(v3[0], 1, gmui_get_available_width(), true);
                gmui_progress(v3[1], 1, gmui_get_available_width(), true);
                gmui_progress(v3[2], 1, gmui_get_available_width(), true);
                
                gmui_end_collapsing_header();
            }
            
            if (gmui_begin_collapsing_header_ex("Array Tween")) {
                if (gmui_button("Animate Array")) {
                    gmui_animation_tween_array("demo_array", [0, 50, 100], [255, 0, 50], 1500000);
                }
                
                var arr = gmui_animation_get_value("demo_array") ?? [0, 50, 100];
                for (var i = 0; i < array_length(arr); i++) {
                    gmui_text($"  [{string(i)}]: {string_format(arr[i], 1, 1)}");
                }
                
                gmui_end_collapsing_header();
            }
            
            gmui_end_collapsing_header();
        }
        
        gmui_separator_text_left("Easing Functions");
        
        if (gmui_begin_collapsing_header("Easing Showcase")) {
            static ease_index = 0;
            
            var easing_names = [
                "LINEAR", "IN_QUAD", "OUT_QUAD", "IN_OUT_QUAD",
                "IN_CUBIC", "OUT_CUBIC", "IN_OUT_CUBIC",
                "IN_QUART", "OUT_QUART", "IN_OUT_QUART",
                "IN_QUINT", "OUT_QUINT", "IN_OUT_QUINT",
                "IN_SINE", "OUT_SINE", "IN_OUT_SINE",
                "IN_EXPO", "OUT_EXPO", "IN_OUT_EXPO",
                "IN_CIRC", "OUT_CIRC", "IN_OUT_CIRC",
                "IN_ELASTIC", "OUT_ELASTIC", "IN_OUT_ELASTIC",
                "IN_BACK", "OUT_BACK", "IN_OUT_BACK",
                "IN_BOUNCE", "OUT_BOUNCE", "IN_OUT_BOUNCE"
            ];
            
            if (gmui_button("Next Easing →")) {
                ease_index = (ease_index + 1) % array_length(easing_names);
                gmui_animation_tween("demo_easing_show", 0, 1, 1500000, ease_index);
            }
            gmui_sameline();
            if (gmui_button("Restart Current")) {
                gmui_animation_tween("demo_easing_show", 0, 1, 1500000, ease_index);
            }
            
            gmui_text($"Current: {easing_names[ease_index]} (enum value: {string(ease_index)})");
            var ev = gmui_animation_get_value("demo_easing_show") ?? 0;
            gmui_progress(ev, 1, gmui_get_available_width(), true);
            
            if (gmui_button("Try Elastic")) {
                ease_index = gmui_animation_ease.OUT_ELASTIC;
                gmui_animation_tween("demo_easing_show", 0, 1, 1500000, ease_index);
            }
            gmui_sameline();
            if (gmui_button("Try Bounce")) {
                ease_index = gmui_animation_ease.OUT_BOUNCE;
                gmui_animation_tween("demo_easing_show", 0, 1, 1500000, ease_index);
            }
            gmui_sameline();
            if (gmui_button("Try Back")) {
                ease_index = gmui_animation_ease.IN_OUT_BACK;
                gmui_animation_tween("demo_easing_show", 0, 1, 1500000, ease_index);
            }
            
            gmui_end_collapsing_header();
        }
        
        gmui_separator_text_left("Repeat & Ping-Pong");
        
        if (gmui_begin_collapsing_header("Repeat & Loop Modes")) {
            
            if (gmui_begin_collapsing_header_ex("Repeat (3 times)")) {
                if (gmui_button("Start Repeat")) {
                    gmui_animation_tween("demo_repeat", 0, 1, 500000, gmui_animation_ease.LINEAR);
                    gmui_animation_set_repeat("demo_repeat", 2);
                }
                gmui_sameline();
                if (gmui_button("Stop")) {
                    gmui_animation_stop("demo_repeat", false);
                }
                
                var rv = gmui_animation_get_value("demo_repeat") ?? 0;
                gmui_text($"Value: {string_format(rv, 1, 3)}");
                gmui_progress(rv, 1, gmui_get_available_width(), true);
                
                gmui_end_collapsing_header();
            }
            
            if (gmui_begin_collapsing_header_ex("Infinite Loop")) {
                if (gmui_button("Start Infinite")) {
                    gmui_animation_tween("demo_infinite", 0, 1, 500000, gmui_animation_ease.LINEAR);
                    gmui_animation_set_repeat("demo_infinite", -1);
                }
                gmui_sameline();
                if (gmui_button("Kill")) {
                    gmui_animation_stop("demo_infinite", false);
                }
                
                var iv = gmui_animation_get_value("demo_infinite") ?? 0;
                gmui_text($"Value: {string_format(iv, 1, 3)}");
                gmui_progress(iv, 1, gmui_get_available_width(), true);
                
                gmui_end_collapsing_header();
            }
            
            if (gmui_begin_collapsing_header_ex("Repeat with Delay (500ms pause)")) {
                if (gmui_button("Start Delayed Repeat")) {
                    gmui_animation_tween("demo_repeat_delay", 0, 1, 500000, gmui_animation_ease.IN_OUT_QUAD);
                    gmui_animation_set_repeat("demo_repeat_delay", 3, 500000);
                }
                
                var rdv = gmui_animation_get_value("demo_repeat_delay") ?? 0;
                gmui_text($"Value: {string_format(rdv, 1, 3)}");
                gmui_progress(rdv, 1, gmui_get_available_width(), true);
                
                gmui_end_collapsing_header();
            }
            
            if (gmui_begin_collapsing_header_ex("Ping-Pong")) {
                if (gmui_button("Start Ping-Pong")) {
                    gmui_animation_tween("demo_pingpong", 0, 1, 600000, gmui_animation_ease.IN_OUT_QUAD);
                    gmui_animation_set_pingpong("demo_pingpong", -1);
                }
                gmui_sameline();
                if (gmui_button("Kill")) {
                    gmui_animation_stop("demo_pingpong", false);
                }
                
                var pv = gmui_animation_get_value("demo_pingpong") ?? 0;
                gmui_text($"Value: {string_format(pv, 1, 3)}");
                gmui_progress(pv, 1, gmui_get_available_width(), true);
                
                gmui_end_collapsing_header();
            }
            
            if (gmui_begin_collapsing_header_ex("Pulse (Ping-Pong Once)")) {
                if (gmui_button("Pulse!")) {
                    gmui_animation_pulse("demo_pulse", 1.0, 1.3, 300000, gmui_animation_ease.IN_OUT_BACK);
                }
                
                var pv2 = gmui_animation_get_value("demo_pulse") ?? 1.0;
                gmui_text($"Scale: {string_format(pv2, 1, 3)}");
                gmui_progress(pv2, 1.3, gmui_get_available_width(), true);
                
                gmui_end_collapsing_header();
            }
            
            gmui_end_collapsing_header();
        }
        
        gmui_separator_text_left("Tween Control");
        
        if (gmui_begin_collapsing_header("Playback Control")) {
            
            if (gmui_begin_collapsing_header_ex("Pause / Resume / Toggle")) {
                if (gmui_button("Start Long Tween")) {
                    gmui_animation_tween("demo_control", 0, 1, 5000000, gmui_animation_ease.LINEAR);
                }
                
                if (gmui_button("Pause")) { gmui_animation_pause("demo_control"); }
                gmui_sameline();
                if (gmui_button("Resume")) { gmui_animation_resume("demo_control"); }
                gmui_sameline();
                if (gmui_button("Toggle")) { gmui_animation_toggle("demo_control"); }
                
                var cv = gmui_animation_get_value("demo_control") ?? 0;
                var cp = gmui_animation_get_progress("demo_control");
                gmui_text($"Value: {string_format(cv, 1, 3)} | Progress: {string_format(cp * 100, 1, 0)}%");
                gmui_text($"Playing: {gmui_animation_is_playing("demo_control")}");
                gmui_progress(cv, 1, gmui_get_available_width(), true);
                
                gmui_end_collapsing_header();
            }
            
            if (gmui_begin_collapsing_header_ex("Seek to Position")) {
                if (gmui_button("Start 5s Tween")) {
                    gmui_animation_tween("demo_seek", 0, 1, 5000000, gmui_animation_ease.LINEAR);
                }
                
                static seek_val = 0.5;
                seek_val = gmui_slider(seek_val, 0, 1, gmui_get_available_width());
                if (gmui_button("Jump to Position")) {
                    gmui_animation_seek("demo_seek", seek_val);
                }
                
                var sv = gmui_animation_get_value("demo_seek") ?? 0;
                gmui_text($"Value: {string_format(sv, 1, 3)}");
                gmui_progress(sv, 1, gmui_get_available_width(), true);
                
                gmui_end_collapsing_header();
            }
            
            if (gmui_begin_collapsing_header_ex("Reverse Direction")) {
                if (gmui_button("Start Tween")) {
                    gmui_animation_tween("demo_reverse", 0, 1, 3000000, gmui_animation_ease.IN_OUT_QUAD);
                }
                gmui_sameline();
                if (gmui_button("Reverse!")) {
                    gmui_animation_reverse("demo_reverse");
                }
                
                var rev = gmui_animation_get_value("demo_reverse") ?? 0;
                gmui_text($"Value: {string_format(rev, 1, 3)}");
                gmui_progress(rev, 1, gmui_get_available_width(), true);
                
                gmui_end_collapsing_header();
            }
            
            if (gmui_begin_collapsing_header_ex("Delayed Start (1 second)")) {
                if (gmui_button("Start Delayed")) {
                    gmui_animation_create("demo_delay", 0, 1, 1500000);
                    gmui_animation_set_delay("demo_delay", 1000000);
                    gmui_animation_set_easing("demo_delay", gmui_animation_ease.OUT_ELASTIC);
                    gmui_animation_play("demo_delay");
                }
                
                var dv = gmui_animation_get_value("demo_delay") ?? 0;
                gmui_text($"Value: {string_format(dv, 1, 3)}");
                gmui_progress(dv, 1, gmui_get_available_width(), true);
                
                gmui_end_collapsing_header();
            }
            
            if (gmui_begin_collapsing_header_ex("Per-Tween Time Scale")) {
                if (gmui_button("0.5x (Slow)")) {
                    gmui_animation_tween("demo_tscale", 0, 1, 2000000, gmui_animation_ease.LINEAR);
                    gmui_animation_set_time_scale("demo_tscale", 0.5);
                }
                gmui_sameline();
                if (gmui_button("2x (Fast)")) {
                    gmui_animation_tween("demo_tscale", 0, 1, 2000000, gmui_animation_ease.LINEAR);
                    gmui_animation_set_time_scale("demo_tscale", 2.0);
                }
                gmui_sameline();
                if (gmui_button("Normal")) {
                    gmui_animation_tween("demo_tscale", 0, 1, 2000000, gmui_animation_ease.LINEAR);
                }
                
                var tsv = gmui_animation_get_value("demo_tscale") ?? 0;
                gmui_text($"Value: {string_format(tsv, 1, 3)}");
                gmui_progress(tsv, 1, gmui_get_available_width(), true);
                
                gmui_end_collapsing_header();
            }
            
			if (gmui_begin_collapsing_header_ex("Stop Options")) {
			    static demo_stop_fallback = 0;
    
			    if (gmui_button("Start Tween")) {
			        gmui_animation_tween("demo_stop", 0, 1, 3000000, gmui_animation_ease.LINEAR);
			    }
    
			    if (gmui_button("Stop (Go to End)")) {
			        gmui_animation_stop("demo_stop", true);
			    }
			    gmui_sameline();
			    if (gmui_button("Stop (Keep Position)")) {
			        gmui_animation_stop("demo_stop", false);
			    }
    
			    var stv = gmui_animation_get_value("demo_stop");
			    if (stv == undefined) { stv = demo_stop_fallback; }
			    else { demo_stop_fallback = stv; }
    
			    gmui_text($"Value: {string_format(stv, 1, 3)}");
			    gmui_text($"Exists: {gmui_animation_exists("demo_stop")}");
			    gmui_progress(stv, 1, gmui_get_available_width(), true);
    
			    gmui_end_collapsing_header();
			}
            
            if (gmui_begin_collapsing_header_ex("Group Control")) {
                if (gmui_button("Create 5 Group Tweens")) {
                    for (var i = 0; i < 5; i++) {
                        var _id = "demo_group_" + string(i);
                        gmui_animation_tween(_id, 0, 1, 1000000 + i * 300000, gmui_animation_ease.LINEAR);
                        gmui_animation_set_group(_id, "demo_group");
                    }
                }
                gmui_sameline();
                if (gmui_button("Kill Group")) {
                    gmui_animation_kill_group("demo_group");
                }
                gmui_sameline();
                if (gmui_button("Kill ALL")) {
                    gmui_animation_kill_all();
                }
                
                for (var i = 0; i < 5; i++) {
                    var gv = gmui_animation_get_value("demo_group_" + string(i)) ?? 0;
                    gmui_progress(gv, 1, gmui_get_available_width(), true);
                }
                
                gmui_end_collapsing_header();
            }
            
            gmui_end_collapsing_header();
        }
        
        gmui_separator_text_left("Advanced Features");
        
        if (gmui_begin_collapsing_header("Effects & Modifiers")) {
            
            if (gmui_begin_collapsing_header_ex("Oscillation (Wobble)")) {
                if (gmui_button("Start Wobbling Tween")) {
                    gmui_animation_tween("demo_osc", 0, 1, 2000000, gmui_animation_ease.IN_OUT_QUAD);
                    gmui_animation_set_oscillation("demo_osc", 0.2, 8, 0);
                }
                
                var ov = gmui_animation_get_value("demo_osc") ?? 0;
                gmui_text($"Value: {string_format(ov, 1, 3)}");
                gmui_progress(clamp(ov, 0, 1), 1, gmui_get_available_width(), true);
                
                gmui_end_collapsing_header();
            }
            
            if (gmui_begin_collapsing_header_ex("Shake Effect")) {
                if (gmui_button("Shake!")) {
                    gmui_animation_shake("demo_shake", 0.5, 0.3, 500000, 10);
                }
                
                var shv = gmui_animation_get_value("demo_shake") ?? 0.5;
                gmui_text($"Value: {string_format(shv, 1, 3)}");
                gmui_progress(clamp(shv, 0, 1), 1, gmui_get_available_width(), true);
                
                gmui_end_collapsing_header();
            }
            
            if (gmui_begin_collapsing_header_ex("Noise (Jitter)")) {
                if (gmui_button("Start Noisy Tween")) {
                    gmui_animation_tween("demo_noise", 0, 1, 2000000, gmui_animation_ease.LINEAR);
                    gmui_animation_set_noise("demo_noise", 0.1, 42);
                }
                
                var nv = gmui_animation_get_value("demo_noise") ?? 0;
                gmui_text($"Value: {string_format(nv, 1, 3)}");
                gmui_progress(clamp(nv, 0, 1), 1, gmui_get_available_width(), true);
                
                gmui_end_collapsing_header();
            }
            
            if (gmui_begin_collapsing_header_ex("Snap to Integer")) {
                if (gmui_button("Start Snap Tween")) {
                    gmui_animation_tween("demo_snap", 0, 10, 3000000, gmui_animation_ease.IN_OUT_QUAD);
                    gmui_animation_set_snap("demo_snap", 0, true);
                }
                
                var snv = gmui_animation_get_value("demo_snap") ?? 0;
                gmui_text($"Value: {string_format(snv, 1, 0)} (snapped to integer)");
                gmui_progress(snv, 10, gmui_get_available_width(), true);
                
                gmui_end_collapsing_header();
            }
            
            if (gmui_begin_collapsing_header_ex("Snap to End (threshold 0.15)")) {
                if (gmui_button("Start Snap-Threshold Tween")) {
                    gmui_animation_tween("demo_snap_th", 0, 1, 2000000, gmui_animation_ease.LINEAR);
                    gmui_animation_set_snap("demo_snap_th", 0.15, false);
                }
                
                var stv = gmui_animation_get_value("demo_snap_th") ?? 0;
                gmui_text($"Value: {string_format(stv, 1, 3)}");
                gmui_progress(stv, 1, gmui_get_available_width(), true);
                
                gmui_end_collapsing_header();
            }
            
            if (gmui_begin_collapsing_header_ex("Custom Easing Function")) {
                if (gmui_button("Start Custom Ease (sin)")) {
                    gmui_animation_create("demo_custom", 0, 1, 2000000);
                    gmui_animation_set_custom_ease("demo_custom", function(t) {
                        return sin(t * pi / 2);
                    });
                    gmui_animation_play("demo_custom");
                }
                
                var cev = gmui_animation_get_value("demo_custom") ?? 0;
                gmui_text($"Value: {string_format(cev, 1, 3)}");
                gmui_text("Easing: sin(t * pi/2)");
                gmui_progress(cev, 1, gmui_get_available_width(), true);
                
                gmui_end_collapsing_header();
            }
            
            if (gmui_begin_collapsing_header_ex("Easing Intensity (Back ease)")) {
                static intensity = 1.7;
                intensity = gmui_slider(intensity, 0.1, 5, gmui_get_available_width());
                gmui_text($"Intensity: {string_format(intensity, 1, 2)}");
                
                if (gmui_button("Start with Intensity")) {
                    var t = gmui_animation_create("demo_intensity", 0, 1, 1500000);
                    t.easing = gmui_animation_ease.IN_OUT_BACK;
                    t.easing_intensity = intensity;
                    gmui_animation_play("demo_intensity");
                }
                
                var inv = gmui_animation_get_value("demo_intensity") ?? 0;
                gmui_progress(inv, 1, gmui_get_available_width(), true);
                
                gmui_end_collapsing_header();
            }
            
            gmui_end_collapsing_header();
        }
        
        gmui_separator_text_left("Safe vs Start API");
        
        if (gmui_begin_collapsing_header("Safe vs Start (Override Demo)")) {
            gmui_text("Safe (default) — won't restart if already running:");
            gmui_text("  gmui_animation_tween(\"id\", ...)");
            gmui_text("Start — always creates new tween:");
            gmui_text("  gmui_animation_tween_start(\"id\", ...)");
            
            gmui_separator();
            
            if (gmui_button("Safe: Animate (won't restart)")) {
                gmui_animation_tween("demo_safe", 0, 1, 1500000, gmui_animation_ease.LINEAR);
            }
            gmui_sameline();
            if (gmui_button("Start: Animate (always restarts)")) {
                gmui_animation_tween_start("demo_safe", 0, 1, 1500000, gmui_animation_ease.LINEAR);
            }
            
            var sfv = gmui_animation_get_value("demo_safe") ?? 0;
            gmui_text($"Value: {string_format(sfv, 1, 3)}");
            gmui_progress(sfv, 1, gmui_get_available_width(), true);
            gmui_text("Spam the Safe button — it won't jump back to 0!");
            
            gmui_end_collapsing_header();
        }
        
        gmui_separator_text_left("Callbacks");
        
        if (gmui_begin_collapsing_header("Callback Demo")) {
            static callback_log = "";
            
            if (gmui_button("Start Callback Tween")) {
                gmui_animation_create("demo_callbacks", 0, 1, 2000000);
                gmui_animation_set_callbacks("demo_callbacks",
                    function(tween) {
                        show_debug_message("Started!");
                    },
                    function(tween) {
                        show_debug_message($"Progress: {string_format(tween.current_value, 1, 2)}");
                    },
                    function(tween) {
                        show_debug_message("Completed!");
                    }
                );
                gmui_animation_play("demo_callbacks");
            }
            
            var cbv = gmui_animation_get_value("demo_callbacks") ?? 0;
            gmui_text($"Value: {string_format(cbv, 1, 3)}");
            gmui_text($"Callback says: {callback_log}");
            gmui_progress(cbv, 1, gmui_get_available_width(), true);
            
            gmui_end_collapsing_header();
        }
        
        gmui_separator_text_left("Utility");
        
        if (gmui_begin_collapsing_header("Utility Functions")) {
            gmui_text_label("Active Tweens", gmui_animation_get_active_count());
            gmui_text_label("Total Created", gmui_animation_get_total_count());
            gmui_text_label("Global Time Scale", gmui_animation_get_global_time_scale());
            
            gmui_text("gmui_animation_lerp(0, 100, 0.5) = " + string(gmui_animation_lerp(0, 100, 0.5)));
            gmui_text("gmui_animation_remap(50, 0, 100, 0, 1) = " + string(gmui_animation_remap(50, 0, 100, 0, 1)));
            
            if (gmui_button_danger("Kill ALL Tweens")) {
                gmui_animation_kill_all();
            }
            
            gmui_end_collapsing_header();
        }
        
        gmui_end();
    }
}