

// ANIMATIONS

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
	TOTAL,
}

enum gmui_animation_repeat_mode {
	NONE,
	LOOP,
	PING_PONG,
	PING_PONG_ONCE,
}

enum gmui_animation_tween_direction {
	FORWARD,
	BACKWARD,
}

enum gmui_animation_tween_state {
	IDLE,
	PLAYING,
	PAUSED,
	COMPLETED,
	KILLED,
}

enum gmui_animation_value_type {
	REAL,
	COLOR3,
	COLOR4,
	VECTOR2,
	VECTOR3,
	VECTOR4,
	ARRAY,
	INT,
	CUSTOM,
}

enum gmui_animation_tween_flags {
	NONE						= 0,
	OVERRIDE_EXISTING			= 1 << 0,
	DELETE_ON_COMPLETE			= 1 << 1,
	IGNORE_TIME_SCALE			= 1 << 2,
	REVERSE_EASE_ON_PINGPONG	= 1 << 3, // [[DEPRECATED]]
	CLAMP_VALUES				= 1 << 4,
	SYNC_TO_AUDIO				= 1 << 5,
	QUEUE						= 1 << 6,
	REPEAT_RESET_ON_DELAY		= 1 << 7,
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
		clips: ds_map_create(),
		paths: ds_map_create(),
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
		case gmui_animation_value_type.INT: return undefined;
		default: return undefined;
	}
}

function gmui_animation_is_value_simple(_type) {
	return (_type == gmui_animation_value_type.REAL || 
	        _type == gmui_animation_value_type.INT || 
	        _type == gmui_animation_value_type.COLOR3);
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
		
		pending_queue: [ ],  // { _from, _to, _duration, _easing }
		easing_per_axis: undefined,  // array of easing types, one per component
		
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

function gmui_animation_set_pingpong(_id, _count = -1) {
	var _tween = ds_map_find_value(gmui_animation_get().tweens_map, _id);
	if (_tween != undefined) {
		_tween.repeat_mode = gmui_animation_repeat_mode.PING_PONG;
		_tween.repeat_count = _count;
		_tween.ping_pong_forward = true;
	}
	return _tween;
}

function gmui_animation_set_pingpong_once(_id) {
	var _tween = ds_map_find_value(gmui_animation_get().tweens_map, _id);
	if (_tween != undefined) {
		_tween.repeat_mode = gmui_animation_repeat_mode.PING_PONG_ONCE;
		_tween.repeat_count = 1;
		_tween.ping_pong_forward = true;
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
				    if (_tween.flags & gmui_animation_tween_flags.REPEAT_RESET_ON_DELAY) {
				        _progress = 0;
				    } else {
				        _progress = 1.0;
				    }
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
					
					//_tween.ping_pong_forward = !_tween.ping_pong_forward;
					//var _temp = _tween.start_value;
					//_tween.start_value = _tween.end_value;
					//_tween.end_value = _temp;
					_tween.ping_pong_forward = !_tween.ping_pong_forward;
			        var _temp = _tween.start_value;
			        _tween.start_value = _tween.end_value;
			        _tween.end_value = _temp;
        
			        if (_tween.repeat_delay > 0) {
			            _tween.repeat_elapsed = 0;
			            _tween.elapsed = -_tween.repeat_delay;
					    if (_tween.flags & gmui_animation_tween_flags.REPEAT_RESET_ON_DELAY) {
					        _progress = 0;
					    } else {
					        _progress = 1.0;
					    }
			        } else {
			            _tween.elapsed = _tween.elapsed - _tween.duration;
            
			            if (_tween.value_type == gmui_animation_value_type.REAL || _tween.value_type == gmui_animation_value_type.INT) {
			                var _range = _tween.end_value - _tween.start_value;
			                if (abs(_range) > 0.00001) {
			                    _tween.elapsed = ((_tween.current_value - _tween.start_value) / _range) * _tween.duration;
			                }
			            }
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
		
		if (_tween.easing_per_axis != undefined && gmui_animation_is_value_array_type(_tween.value_type)) { // per axis easing
			var _len = array_length(_tween.easing_per_axis);
			var _vals = array_create(_len);
			var _start_arr = _tween.start_value;
			var _end_arr = _tween.end_value;
			for (var j = 0; j < _len; j++) {
				var _per_axis_tween = { easing: _tween.easing_per_axis[j], easing_power: _tween.easing_power, easing_intensity: _tween.easing_intensity, easing_custom: undefined, flags: _tween.flags, ping_pong_forward: _tween.ping_pong_forward };
				var _ep = gmui_animation_get_eased_value(_per_axis_tween, clamp(_progress, 0, 1));
				_vals[j] = lerp(_start_arr[j], _end_arr[j], _ep);
			}
			_tween.current_value = _vals;
		} else {
		    var _eased_progress = gmui_animation_get_eased_value(_tween, clamp(_progress, 0, 1));
		    if (_tween.value_type == gmui_animation_value_type.REAL && _tween.value_lerp == undefined) {
		        _tween.current_value = lerp(_tween.start_value, _tween.end_value, _eased_progress);
		    } else {
		        _tween.current_value = gmui_animation_lerp_values(_tween.start_value, _tween.end_value, _tween.value_type, _eased_progress, _tween.value_lerp);
		    }
		}
		
		//if (_tween.oscillation_amplitude > 0) {
		//	var _osc = sin(_progress * _tween.oscillation_frequency * 2 * pi + _tween.oscillation_phase) * _tween.oscillation_amplitude * (1 - _progress);
		//	_tween.current_value = gmui_animation_add_scalar_to_value(_tween.current_value, _tween.value_type, _osc);
		//}
		if (_tween.oscillation_amplitude > 0) {
			var _time = _tween.elapsed / 1000000;
			var _decay = (_tween.duration >= 999999999) ? 1.0 : (1 - _progress);
			var _osc = sin(_time * _tween.oscillation_frequency * 2 * pi + _tween.oscillation_phase) * _tween.oscillation_amplitude * _decay;
			_tween.current_value = gmui_animation_add_scalar_to_value(_tween.current_value, _tween.value_type, _osc);
		}
		
		if (_tween.noise_amount > 0 && (gmui_animation_is_value_simple(_tween.value_type) || gmui_animation_is_value_array_type(_tween.value_type))) {
			random_set_seed(_tween.noise_seed + _tween.update_count);
			var _noise = random_range(-_tween.noise_amount, _tween.noise_amount);
			_tween.current_value = gmui_animation_add_scalar_to_value(_tween.current_value, _tween.value_type, _noise);
		}
		
		if (_tween.value_type == gmui_animation_value_type.INT) { // forces int to be snapped
			_tween.snap_to_integer = true;
		}
		_tween.current_value = gmui_animation_snap_value(_tween.current_value, _tween.end_value, _tween.value_type, _tween.snap_threshold, _tween.snap_to_integer); // snaps all types
		
		_tween.current_value = gmui_animation_process_value(_tween.current_value, _tween.value_type, _tween.value_processor);
		
		if (_tween.flags & gmui_animation_tween_flags.CLAMP_VALUES) {
			//_tween.current_value = gmui_animation_clamp_values(_tween.current_value, _tween.start_value, _tween.end_value, _tween.value_type);
		    var _easing = _tween.easing;
		    var _is_overshoot = (_easing == gmui_animation_ease.IN_ELASTIC || _easing == gmui_animation_ease.OUT_ELASTIC || _easing == gmui_animation_ease.IN_OUT_ELASTIC ||
		                         _easing == gmui_animation_ease.IN_BACK || _easing == gmui_animation_ease.OUT_BACK || _easing == gmui_animation_ease.IN_OUT_BACK ||
		                         _easing == gmui_animation_ease.IN_BOUNCE || _easing == gmui_animation_ease.OUT_BOUNCE || _easing == gmui_animation_ease.IN_OUT_BOUNCE);
    
		    if (!_is_overshoot) {
		        _tween.current_value = gmui_animation_clamp_values(_tween.current_value, _tween.start_value, _tween.end_value, _tween.value_type);
		    }
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
	if (is_array(_tween.pending_queue) && array_length(_tween.pending_queue) > 0) { // should work now ?
		var _q = _tween.pending_queue[0];
		array_delete(_tween.pending_queue, 0, 1);
		
		if (array_length(_tween.pending_queue) == 0) {
			_tween.pending_queue = [];
			_tween.flags &= ~gmui_animation_tween_flags.QUEUE;
		}
		
		_tween.start_value = _tween.current_value;
		_tween.end_value = _q._to;
		_tween.original_start = _tween.current_value;
		_tween.original_end = _q._to;
		_tween.duration = _q._duration;
		_tween.elapsed = 0;
		_tween.delay = 0;
		_tween.repeat_count = 0;
		_tween.repeat_mode = gmui_animation_repeat_mode.NONE;
		_tween.ping_pong_forward = true;
		_tween.completed = false;
		_tween.direction = gmui_animation_tween_direction.FORWARD;
		
		if (_q._easing != undefined) {
			_tween.easing = _q._easing;
		}
		
		_tween.state = gmui_animation_tween_state.PLAYING; // reset
		
		if (_tween.on_start != undefined) { _tween.on_start(_tween); }
		return; // keeps playing
	}
	
	// complete
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
	
	//if (_tween.flags & gmui_animation_tween_flags.REVERSE_EASE_ON_PINGPONG && !_tween.ping_pong_forward) {
	//	_t = 1 - _t;
	//}
	
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
	
	//return clamp(_result, 0, 1);
	return _result; // should fix elastic types not overshooting
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
	gmui_container_animation_detected(gmui_get_current_container());
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
	gmui_animation_init_check_safe();
	gmui_container_animation_detected(gmui_get_current_container());
	
	var _exists = ds_map_find_value(gmui_animation_get().tweens_map, _id);
	if (_exists != undefined && _exists.state != gmui_animation_tween_state.KILLED) { return gmui_animation_get_value(_id); }
	
	gmui_animation_pulse_start(_id, _base_value, _pulse_to, _duration, _easing);
	return gmui_animation_get_value(_id);
}

function gmui_animation_pulse_start(_id, _base_value, _pulse_to, _duration = 200000, _easing = undefined) {
	var _tween = gmui_animation_tween_start(_id, _base_value, _pulse_to, _duration, _easing);
	gmui_animation_set_pingpong_once(_id);
	return _tween;
}

function gmui_animation_shake(_id, _center_value, _intensity, _duration = 100000, _frequency = 4) {
	gmui_animation_init_check_safe();
	gmui_container_animation_detected(gmui_get_current_container());
	
	var _exists = ds_map_find_value(gmui_animation_get().tweens_map, _id);
	if (_exists != undefined && _exists.state != gmui_animation_tween_state.KILLED) { return gmui_animation_get_value(_id); }
	
	gmui_animation_shake_start(_id, _center_value, _intensity, _duration, _frequency);
	return gmui_animation_get_value(_id);
}

function gmui_animation_shake_start(_id, _center_value, _intensity, _duration = 100000, _frequency = 4) {
	var _tween = gmui_animation_create(_id, _center_value, _center_value, _duration);
	_tween.oscillation_amplitude = _intensity;
	_tween.oscillation_frequency = _frequency;
	_tween.flags = _tween.flags & ~gmui_animation_tween_flags.CLAMP_VALUES;
	_tween.state = gmui_animation_tween_state.PLAYING;
	gmui_animation_get().active_tweens++;
	return _tween;
}

// queue
function gmui_animation_queue(_id, _from, _to, _duration = -1, _easing = undefined) {
	gmui_animation_init_check_safe();
	gmui_container_animation_detected(gmui_get_current_container());
	var _anim = gmui_animation_get();
	var _existing = ds_map_find_value(_anim.tweens_map, _id);
	
	if (_existing != undefined && _existing.state == gmui_animation_tween_state.PLAYING) {
		if (!is_array(_existing.pending_queue)) {
			_existing.pending_queue = [];
		}
		array_push(_existing.pending_queue, {
			_from: _from,
			_to: _to,
			_duration: _duration < 0 ? _anim.default_duration : _duration,
			_easing: _easing
		});
		_existing.flags |= gmui_animation_tween_flags.QUEUE;
		return _existing.current_value;
	}
	
	return gmui_animation_tween_start(_id, _from, _to, _duration, _easing);
}

function gmui_animation_queue_clear(_id) {
	var _tween = ds_map_find_value(gmui_animation_get().tweens_map, _id);
	if (_tween != undefined) {
		_tween.pending_queue = [ ];
		_tween.flags &= ~gmui_animation_tween_flags.QUEUE;
	}
}

function gmui_animation_get_queue_count(_id) {
	var _tween = ds_map_find_value(gmui_animation_get().tweens_map, _id);
	if (_tween != undefined && is_array(_tween.pending_queue)) {
		return array_length(_tween.pending_queue);
	}
	return 0;
}

// stagger
function gmui_animation_stagger(_ids, _from, _to, _duration = -1, _stagger = 100000, _easing = undefined) {
	gmui_animation_init_check_safe();
	gmui_container_animation_detected(gmui_get_current_container());
	
	var _count = array_length(_ids);
	for (var i = 0; i < _count; i++) {
		var _tween = gmui_animation_create(_ids[i], _from, _to, _duration);
		_tween.delay = i * _stagger;
		_tween.elapsed = -_tween.delay;
		if (_easing != undefined) {
			_tween.easing = _easing;
		}
		gmui_animation_play(_ids[i]);
	}
}

function gmui_animation_stagger_ex(_items, _duration = -1, _stagger = 100000, _easing = undefined) {
	gmui_animation_init_check_safe();
	gmui_container_animation_detected(gmui_get_current_container());
	
	var _count = array_length(_items);
	for (var i = 0; i < _count; i++) {
		var _item = _items[i];
		var _tween = gmui_animation_create(_item.id, _item.from, _item.to, _duration);
		_tween.delay = i * _stagger;
		_tween.elapsed = -_tween.delay;
		if (_easing != undefined) {
			_tween.easing = _easing;
		}
		gmui_animation_play(_item.id);
	}
}

// per axis easing
function gmui_animation_set_easing_per_axis(_id, _easings) {
	var _tween = ds_map_find_value(gmui_animation_get().tweens_map, _id);
	if (_tween != undefined) {
		_tween.easing_per_axis = _easings;
	}
	return _tween;
}

// wiggle
function gmui_animation_wiggle(_id, _center, _amplitude, _frequency = 2, _duration = -1) {
	gmui_animation_init_check_safe();
	gmui_container_animation_detected(gmui_get_current_container());
	
	var _exists = ds_map_find_value(gmui_animation_get().tweens_map, _id);
	if (_exists != undefined && _exists.state == gmui_animation_tween_state.PLAYING) {
		_exists.oscillation_amplitude = _amplitude;
		_exists.oscillation_frequency = _frequency;
		return gmui_animation_get_value(_id);
	}
	
	gmui_animation_wiggle_start(_id, _center, _amplitude, _frequency, _duration);
	return gmui_animation_get_value(_id);
}

function gmui_animation_wiggle_start(_id, _center, _amplitude, _frequency = 2, _duration = -1) {
	gmui_animation_init_check_safe();
	gmui_container_animation_detected(gmui_get_current_container());
	gmui_animation_remove_existing_tween(_id);
	
	var _tween = gmui_animation_create(_id, _center, _center, _duration < 0 ? 999999999 : _duration);
	_tween.oscillation_amplitude = _amplitude;
	_tween.oscillation_frequency = _frequency;
	_tween.oscillation_phase = 0;
	_tween.flags &= ~gmui_animation_tween_flags.CLAMP_VALUES;
	_tween.state = gmui_animation_tween_state.PLAYING;
	gmui_animation_get().active_tweens++;
	return _tween;
}

// timeline
function gmui_animation_timeline(_id, _keyframes, _loop = false, _default_easing = undefined) {
	gmui_animation_init_check_safe();
	gmui_container_animation_detected(gmui_get_current_container());
	
	var _exists = ds_map_find_value(gmui_animation_get().tweens_map, _id);
	if (_exists != undefined && _exists.state != gmui_animation_tween_state.KILLED) {
		return gmui_animation_get_value(_id);
	}
	
	gmui_animation_timeline_start(_id, _keyframes, _loop, _default_easing);
	return gmui_animation_get_value(_id);
}

function gmui_animation_timeline_start(_id, _keyframes, _loop = false, _default_easing = undefined) {
	gmui_animation_init_check_safe();
	gmui_container_animation_detected(gmui_get_current_container());
	gmui_animation_remove_existing_tween(_id);
	
	var _count = array_length(_keyframes);
	if (_count < 2) {
		//show_debug_message("ERROR: Timeline requires at least 2 keyframes");
		return undefined;
	}
	
	array_sort(_keyframes, function(a, b) { return a.time - b.time; });
	
	var _first = _keyframes[0];
	var _last = _keyframes[_count - 1];
	var _total_duration = _last.time;
	
	var _tween = gmui_animation_create(_id, _first.value, _last.value, _total_duration);
	
	_tween.value_type = gmui_animation_detect_value_type(_first.value);
	
	_tween.timeline_data = {
		keyframes: _keyframes,
		loop: _loop,
		default_easing: _default_easing != undefined ? _default_easing : gmui_animation_ease.LINEAR,
		current_keyframe: 0,
	};
	
	_tween.value_lerp = method(_tween, function(_start, _end, _t) {
		var _td = self.timeline_data;
		var _kfs = _td.keyframes;
		var _count = array_length(_kfs);
		
		if (_td.loop) {
			_t = frac(_t);
		} else {
			_t = clamp(_t, 0, 1);
		}
		
		var _elapsed = _t * self.duration;
		
		var _kf_from = _kfs[0];
		var _kf_to = _kfs[_count - 1];
		
		for (var i = 0; i < _count - 1; i++) {
			if (_elapsed >= _kfs[i].time && _elapsed <= _kfs[i + 1].time) {
				_kf_from = _kfs[i];
				_kf_to = _kfs[i + 1];
				break;
			}
		}
		
		if (_elapsed >= _kfs[_count - 1].time && !_td.loop) {
			return _kfs[_count - 1].value;
		}
		
		var _segment_duration = _kf_to.time - _kf_from.time;
		var _local_t = (_segment_duration > 0) ? (_elapsed - _kf_from.time) / _segment_duration : 0;
		
		var _easing = (_kf_from.easing != undefined) ? _kf_from.easing : _td.default_easing;
		var _ease_tween = {
			easing: _easing,
			easing_power: self.easing_power,
			easing_intensity: self.easing_intensity,
			easing_custom: undefined,
			flags: self.flags,
			ping_pong_forward: self.ping_pong_forward
		};
		var _eased_t = gmui_animation_get_eased_value(_ease_tween, clamp(_local_t, 0, 1));
		
		return gmui_animation_lerp_values(_kf_from.value, _kf_to.value, self.value_type, _eased_t, undefined);
	});
	
	_tween.flags &= ~gmui_animation_tween_flags.CLAMP_VALUES;
	
	if (_loop) {
		gmui_animation_set_repeat(_id, -1);
	}
	
	_tween.state = gmui_animation_tween_state.PLAYING;
	gmui_animation_get().active_tweens++;
	return _tween;
}

function gmui_animation_keyframe(_time, _value, _easing = undefined) {
	return { time: _time, value: _value, easing: _easing };
}

// spring physics
//function gmui_animation_spring_update(_current, _target, _velocity_ref, _tension = 0.5, _friction = 0.3, _mass = 1.0, _dt = -1) {
//	if (_dt < 0) { _dt = delta_time / 1000000; }
	
//	var _force = -_tension * (_current - _target);
//	var _damping = -_friction * _velocity_ref;
//	var _acceleration = (_force + _damping) / _mass;
	
//	_velocity_ref += _acceleration * _dt;
	
//	return _current + _velocity_ref * _dt;
//}
//function gmui_animation_spring_update(_current, _target, _velocity_ref, _tension = 0.5, _friction = 0.3, _mass = 1.0, _dt = -1) {
//	if (_dt < 0) { _dt = delta_time / 1000000; }
	
//	var _stiffness = _tension * 10;
//	var _damping = _friction * 5;
	
//	var _force = (_target - _current) * _stiffness;
//	var _acceleration = _force / _mass;
	
//	_velocity_ref += _acceleration * _dt;
//	_velocity_ref *= (1 - _damping * _dt);
	
//	return _current + _velocity_ref * _dt;
//}
function gmui_animation_spring_update(_current, _target, _velocity, _tension = 0.5, _friction = 0.3, _mass = 1.0, _dt = -1) {
	if (_dt < 0) { _dt = delta_time / 1000000; }
	
	var _omega = _tension * 20;
	var _zeta = _friction;
	
	var _k = _mass * _omega * _omega;
	var _c = 2 * _mass * _omega * _zeta;
	
	var _force = -_k * (_current - _target) - _c * _velocity;
	var _accel = _force / _mass;
	
	var _new_velocity = _velocity + _accel * _dt;
	var _new_value = _current + _new_velocity * _dt;
	
	return [_new_value, _new_velocity];
}

function gmui_animation_spring(_id, _from, _to, _tension = 0.5, _friction = 0.3, _mass = 1.0, _precision = 0.001) {
	gmui_animation_init_check_safe();
	gmui_container_animation_detected(gmui_get_current_container());
	
	var _existing = ds_map_find_value(gmui_animation_get().tweens_map, _id);
	if (_existing != undefined && _existing.state == gmui_animation_tween_state.PLAYING && _existing.spring_data != undefined) {
		_existing.spring_data.target = _to;
		return gmui_animation_get_value(_id);
	}
	
	return gmui_animation_spring_start(_id, _from, _to, _tension, _friction, _mass, _precision);
}

function gmui_animation_spring_start(_id, _from, _to, _tension = 0.5, _friction = 0.3, _mass = 1.0, _precision = 0.001) {
	gmui_animation_init_check_safe();
	gmui_container_animation_detected(gmui_get_current_container());
	gmui_animation_remove_existing_tween(_id);
	
	var _tween = gmui_animation_create(_id, _from, _to, 999999999);
	_tween.value_type = gmui_animation_value_type.REAL;
	_tween.flags &= ~gmui_animation_tween_flags.CLAMP_VALUES;
	
	_tween.spring_data = {
		tension: _tension,
		friction: _friction,
		mass: _mass,
		precision: _precision,
		velocity: 0,
		target: _to,
	};
	
	_tween.value_lerp = method(_tween, function(_start, _end, _t) {
		var _sd = self.spring_data;
		var _dt = delta_time / 1000000;
		var _result = gmui_animation_spring_update(self.current_value, _sd.target, _sd.velocity, _sd.tension, _sd.friction, _sd.mass, _dt);
		
		var _new_val = _result[0];
		var _new_vel = _result[1];
		
		_sd.velocity = _new_vel;
		
		if (abs(_new_vel) < 0.01 && abs(_new_val - _sd.target) < 0.01) {
			_sd.velocity = 0;
			gmui_animation_complete_tween(self);
			return _sd.target;
		}
		
		return _new_val;
	});
	
	_tween.state = gmui_animation_tween_state.PLAYING;
	gmui_animation_get().active_tweens++;
	return _tween;
}

// perlin noise
function _gmui_animation_hash(_n, _s) {
	_n = (_n + _s) * 374761393 + 668265263;
	_n = ((_n >> 16) ^ _n) * 1274126177;
	return ((_n >> 16) ^ _n) % 1000 / 1000;
}

function gmui_animation_perlin_noise(_x, _seed = 0) {
	var _xi = floor(_x);
	var _xf = _x - _xi;
	
	var _hash = _gmui_animation_hash;
	
	var _g0 = _hash(_xi, _seed) * 2 - 1;
	var _g1 = _hash(_xi + 1, _seed) * 2 - 1;
	
	var _u = _xf * _xf * (3 - 2 * _xf);
	
	return lerp(_g0 * _xf, _g1 * (_xf - 1), _u);
}

function gmui_animation_perlin_wiggle(_id, _center, _amplitude = 0.5, _speed = 1, _seed = 0, _duration = -1) {
	gmui_animation_init_check_safe();
	gmui_container_animation_detected(gmui_get_current_container());
	
	var _exists = ds_map_find_value(gmui_animation_get().tweens_map, _id);
	if (_exists != undefined && _exists.state == gmui_animation_tween_state.PLAYING && _exists.perlin_data != undefined) {
		_exists.perlin_data.amplitude = _amplitude;
		_exists.perlin_data.speed = _speed;
		return gmui_animation_get_value(_id);
	}
	
	gmui_animation_perlin_wiggle_start(_id, _center, _amplitude, _speed, _seed, _duration);
	return gmui_animation_get_value(_id);
}

function gmui_animation_perlin_wiggle_start(_id, _center, _amplitude = 0.5, _speed = 1, _seed = 0, _duration = -1) {
	gmui_animation_init_check_safe();
	gmui_container_animation_detected(gmui_get_current_container());
	gmui_animation_remove_existing_tween(_id);
	
	var _tween = gmui_animation_create(_id, _center, _center, _duration < 0 ? 999999999 : _duration);
	_tween.flags &= ~gmui_animation_tween_flags.CLAMP_VALUES;
	
	_tween.perlin_data = {
		center: _center,
		amplitude: _amplitude,
		speed: _speed,
		seed: _seed,
		time_offset: 0,
	};
	
	_tween.value_lerp = method(_tween, function(_start, _end, _t) {
		var _pd = self.perlin_data;
		_pd.time_offset += (delta_time / 1000000) * _pd.speed;
		var _noise = gmui_animation_perlin_noise(_pd.time_offset, _pd.seed);
		return _pd.center + _noise * _pd.amplitude;
	});
	
	_tween.state = gmui_animation_tween_state.PLAYING;
	gmui_animation_get().active_tweens++;
	return _tween;
}

// rotation & transform helpers
function gmui_animation_lerp_angle(_from, _to, _t) {
	var _diff = _to - _from;
	return _from + _diff * _t;
}

function gmui_animation_tween_angle(_id, _from, _to, _duration = -1, _easing = undefined) {
	gmui_animation_init_check_safe();
	gmui_container_animation_detected(gmui_get_current_container());
	
	var _exists = ds_map_find_value(gmui_animation_get().tweens_map, _id);
	if (_exists != undefined && _exists.state != gmui_animation_tween_state.KILLED) {
		return gmui_animation_get_value(_id);
	}
	
	return gmui_animation_tween_angle_start(_id, _from, _to, _duration, _easing);
}

function gmui_animation_tween_angle_start(_id, _from, _to, _duration = -1, _easing = undefined) {
	gmui_animation_init_check_safe();
	gmui_animation_remove_existing_tween(_id);
	
	var _tween = gmui_animation_create(_id, _from, _to, _duration);
	_tween.value_type = gmui_animation_value_type.CUSTOM;
	_tween.flags &= ~gmui_animation_tween_flags.CLAMP_VALUES;
	_tween.user_data = { from: _from, to: _to };
	
	_tween.value_lerp = method(_tween, function(_start, _end, _t) {
		var _ud = self.user_data;
		return gmui_animation_lerp_angle(_ud.from, _ud.to, _t);
	});
	
	if (_easing != undefined) gmui_animation_set_easing(_id, _easing);
	_tween.state = gmui_animation_tween_state.PLAYING;
	gmui_animation_get().active_tweens++;
	return _tween;
}

function gmui_animation_tween_scale(_id, _from_x, _from_y, _to_x, _to_y, _duration = -1, _easing = undefined) {
	return gmui_animation_tween_vector2(_id, [_from_x, _from_y], [_to_x, _to_y], _duration, _easing);
}

function gmui_animation_tween_position(_id, _from_x, _from_y, _to_x, _to_y, _duration = -1, _easing = undefined) {
	return gmui_animation_tween_vector2(_id, [_from_x, _from_y], [_to_x, _to_y], _duration, _easing);
}

// clip system
function gmui_animation_clip_begin(_name) {
	gmui_animation_init_check_safe();
	var _anim = gmui_animation_get();
	
	var _clip = {
		name: _name,
		keyframes: [ ],
		total_duration: 0,
		loop: false,
		loop_direction: gmui_animation_repeat_mode.NONE,
		on_complete: undefined,
		on_marker: undefined,
		next_clip: undefined, // for chaining
	    stagger_count: 0,
	    stagger_delay: 0,
	    stagger_initial: 0,
	};
	
	return _clip;
}

function gmui_animation_clip_key_float(_clip, _time, _value, _easing = undefined) {
	array_push(_clip.keyframes, {
		time: _time,
		value: _value,
		type: gmui_animation_value_type.REAL,
		easing: _easing
	});
	if (_time > _clip.total_duration) {
		_clip.total_duration = _time;
	}
	return _clip;
}

function gmui_animation_clip_key_vector2(_clip, _time, _value, _easing = undefined) {
	array_push(_clip.keyframes, {
		time: _time,
		value: _value,
		type: gmui_animation_value_type.VECTOR2,
		easing: _easing
	});
	if (_time > _clip.total_duration) {
		_clip.total_duration = _time;
	}
	return _clip;
}

function gmui_animation_clip_key_color3(_clip, _time, _value, _easing = undefined) {
	array_push(_clip.keyframes, {
		time: _time,
		value: _value,
		type: gmui_animation_value_type.COLOR3,
		easing: _easing
	});
	if (_time > _clip.total_duration) {
		_clip.total_duration = _time;
	}
	return _clip;
}

function gmui_animation_clip_key_color4(_clip, _time, _value, _easing = undefined) {
	array_push(_clip.keyframes, {
		time: _time,
		value: _value,
		type: gmui_animation_value_type.COLOR4,
		easing: _easing
	});
	if (_time > _clip.total_duration) {
		_clip.total_duration = _time;
	}
	return _clip;
}

function gmui_animation_clip_set_loop(_clip, _loop, _direction = undefined) {
	_clip.loop = _loop;
	_clip.loop_direction = (_direction != undefined) ? _direction : gmui_animation_repeat_mode.LOOP;
	return _clip;
}

function gmui_animation_clip_on_complete(_clip, _callback) {
	_clip.on_complete = _callback;
	return _clip;
}

function gmui_animation_clip_on_marker(_clip, _callback) {
	_clip.on_marker = _callback;
	return _clip;
}

function gmui_animation_clip_chain(_clip, _next_clip_name) {
	_clip.next_clip = _next_clip_name;
	return _clip;
}

function gmui_animation_clip_set_stagger(_clip, _count, _delay_per_item, _initial_delay = 0) {
	_clip.stagger_count = _count;
	_clip.stagger_delay = _delay_per_item;
	_clip.stagger_initial = _initial_delay;
	return _clip;
}

function gmui_animation_clip_end(_clip) {
	var _anim = gmui_animation_get();
	
	if (array_length(_clip.keyframes) < 2) {
		//show_debug_message("ERROR: Clip '" + _clip.name + "' needs at least 2 keyframes");
		return;
	}
	
	array_sort(_clip.keyframes, function(a, b) { return a.time - b.time; });
	
	ds_map_add(_anim.clips, _clip.name, _clip);
	
	//show_debug_message("Clip '" + _clip.name + "' defined with " + string(array_length(_clip.keyframes)) + " keyframes, duration: " + string(_clip.total_duration) + "us");
}

// clip playback
function gmui_animation_clip_play(_clip_name, _target_id) {
	gmui_animation_init_check_safe();
	gmui_container_animation_detected(gmui_get_current_container());
	
	var _anim = gmui_animation_get();
	var _clip = ds_map_find_value(_anim.clips, _clip_name);
	
	if (_clip == undefined) {
		//show_debug_message("ERROR: Clip '" + _clip_name + "' not found");
		return undefined;
	}
	
	if (_clip.stagger_count != undefined && _clip.stagger_count > 1) {
		var _tweens = [];
		for (var s = 0; s < _clip.stagger_count; s++) {
			var _sid = _target_id + "_" + string(s);
			var _kfs = [];
			for (var i = 0; i < array_length(_clip.keyframes); i++) {
				var _kf = _clip.keyframes[i];
				array_push(_kfs, {
					time: _kf.time,
					value: _kf.value,
					easing: _kf.easing
				});
			}
			var _tween = gmui_animation_timeline_start(_sid, _kfs, false);
			var _total_delay = _clip.stagger_initial + s * _clip.stagger_delay;
			_tween.delay = _total_delay;
			_tween.elapsed = -_total_delay;
			
			_tween.clip_data = {
				clip_name: _clip_name,
				loop: _clip.loop,
				loop_direction: _clip.loop_direction,
				next_clip: _clip.next_clip,
				user_on_complete: _clip.on_complete,
				user_on_marker: _clip.on_marker,
				markers_triggered: [],
				original_on_complete: _tween.on_complete,
				original_on_update: _tween.on_update,
				stagger_index: s,
				stagger_total: _clip.stagger_count,
			};
			
			if (_clip.loop) {
				if (_clip.loop_direction == gmui_animation_repeat_mode.PING_PONG) {
					gmui_animation_set_pingpong(_sid, -1);
				} else {
					gmui_animation_set_repeat(_sid, -1);
				}
			}
			
			_tween.on_complete = method(_tween, function(_t) {
				var _cd = self.clip_data;
				if (_cd.user_on_complete != undefined) {
					_cd.user_on_complete(self.id);
				}
				if (_cd.next_clip != undefined && _cd.stagger_index == _cd.stagger_total - 1) {
					gmui_animation_clip_play(_cd.next_clip, string_replace(self.id, "_" + string(_cd.stagger_index), ""));
				}
				if (_cd.original_on_complete != undefined) {
					_cd.original_on_complete(_t);
				}
			});
			
			_tween.on_update = method(_tween, function(_t) {
				var _cd = self.clip_data;
				if (_cd.user_on_marker != undefined) {
					var _clip_ref = ds_map_find_value(gmui_animation_get().clips, _cd.clip_name);
					if (_clip_ref != undefined) {
						for (var i = 0; i < array_length(_clip_ref.keyframes); i++) {
							var _kf_time = _clip_ref.keyframes[i].time;
							var _already = false;
							for (var j = 0; j < array_length(_cd.markers_triggered); j++) {
								if (_cd.markers_triggered[j] == _kf_time) { _already = true; break; }
							}
							if (!_already && self.elapsed >= _kf_time) {
								array_push(_cd.markers_triggered, _kf_time);
								_cd.user_on_marker(self.id, _kf_time);
							}
						}
					}
				}
				if (_cd.original_on_update != undefined) {
					_cd.original_on_update(_t);
				}
			});
			
			array_push(_tweens, _tween);
		}
		return _tweens;
	}
	
	var _kfs = [];
	var _count = array_length(_clip.keyframes);
	for (var i = 0; i < _count; i++) {
		var _kf = _clip.keyframes[i];
		array_push(_kfs, {
			time: _kf.time,
			value: _kf.value,
			easing: _kf.easing
		});
	}
	
	var _tween = gmui_animation_timeline_start(_target_id, _kfs, false);
	
	_tween.clip_data = {
		clip_name: _clip_name,
		loop: _clip.loop,
		loop_direction: _clip.loop_direction,
		next_clip: _clip.next_clip,
		user_on_complete: _clip.on_complete,
		user_on_marker: _clip.on_marker,
		markers_triggered: [],
		original_on_complete: _tween.on_complete,
		original_on_update: _tween.on_update,
		stagger_index: 0,
		stagger_total: 1,
	};
	
	if (_clip.loop) {
		if (_clip.loop_direction == gmui_animation_repeat_mode.PING_PONG) {
			gmui_animation_set_pingpong(_target_id, -1);
		} else {
			gmui_animation_set_repeat(_target_id, -1);
		}
	}
	
	_tween.on_complete = method(_tween, function(_t) {
		var _cd = self.clip_data;
		if (_cd.user_on_complete != undefined) {
			_cd.user_on_complete(self.id);
		}
		if (_cd.next_clip != undefined) {
			gmui_animation_clip_play(_cd.next_clip, self.id);
		}
		if (_cd.original_on_complete != undefined) {
			_cd.original_on_complete(_t);
		}
	});
	
	_tween.on_update = method(_tween, function(_t) {
		var _cd = self.clip_data;
		if (_cd.user_on_marker != undefined) {
			var _clip_ref = ds_map_find_value(gmui_animation_get().clips, _cd.clip_name);
			if (_clip_ref != undefined) {
				for (var i = 0; i < array_length(_clip_ref.keyframes); i++) {
					var _kf_time = _clip_ref.keyframes[i].time;
					var _already = false;
					for (var j = 0; j < array_length(_cd.markers_triggered); j++) {
						if (_cd.markers_triggered[j] == _kf_time) { _already = true; break; }
					}
					if (!_already && self.elapsed >= _kf_time) {
						array_push(_cd.markers_triggered, _kf_time);
						_cd.user_on_marker(self.id, _kf_time);
					}
				}
			}
		}
		if (_cd.original_on_update != undefined) {
			_cd.original_on_update(_t);
		}
	});
	
	return _tween;
}

function gmui_animation_clip_stop(_target_id) {
	gmui_animation_stop(_target_id, false);
}

function gmui_animation_clip_is_playing(_target_id) {
	return gmui_animation_is_playing(_target_id);
}

function gmui_animation_clip_get_float(_target_id) {
	return gmui_animation_get_value(_target_id) ?? 0;
}

function gmui_animation_clip_get_vector2(_target_id) {
	return gmui_animation_get_value(_target_id) ?? [0, 0];
}

function gmui_animation_clip_get_color3(_target_id) {
	return gmui_animation_get_value(_target_id) ?? c_black;
}

function gmui_animation_clip_get_color4(_target_id) {
	return gmui_animation_get_value(_target_id) ?? gmui_make_color_rgba(0, 0, 0, 255);
}

// motion path
function gmui_animation_path_begin(_name, _start) {
	gmui_animation_init_check_safe();
	
	var _path = {
		name: _name,
		points: [_start],
		segments: [], // { type: "quadratic"/"cubic", points: [...] }
	};
	
	return _path;
}

function gmui_animation_path_quadratic_to(_path, _control, _end) {
	array_push(_path.segments, {
		type: "quadratic",
		control: _control,
		end_point: _end
	});
	var _last = _path.points[array_length(_path.points) - 1];
	array_push(_path.points, _end);
	return _path;
}

function gmui_animation_path_cubic_to(_path, _control1, _control2, _end) {
	array_push(_path.segments, {
		type: "cubic",
		control1: _control1,
		control2: _control2,
		end_point: _end
	});
	var _last = _path.points[array_length(_path.points) - 1];
	array_push(_path.points, _end);
	return _path;
}

function gmui_animation_path_end(_path) {
	var _anim = gmui_animation_get();
	ds_map_add(_anim.paths, _path.name, _path);
	//show_debug_message("Path '" + _path.name + "' defined with " + string(array_length(_path.segments)) + " segments");
}

function gmui_animation_path_evaluate(_path, _t) {
	_t = clamp(_t, 0, 1);
	var _seg_count = array_length(_path.segments);
	if (_seg_count == 0) return _path.points[0];
	
	var _seg_t = _t * _seg_count;
	var _seg_idx = floor(_seg_t);
	if (_seg_idx >= _seg_count) _seg_idx = _seg_count - 1;
	var _local_t = _seg_t - _seg_idx;
	
	var _seg = _path.segments[_seg_idx];
	var _start = _path.points[_seg_idx];
	var _end_pt = _seg.end_point;
	
	if (_seg.type == "quadratic") {
		return [
			gmui_animation_bezier_quadratic(_start[0], _seg.control[0], _end_pt[0], _local_t),
			gmui_animation_bezier_quadratic(_start[1], _seg.control[1], _end_pt[1], _local_t)
		];
	} else {
		return gmui_animation_bezier_cubic_2d(_start, _seg.control1, _seg.control2, _end_pt, _local_t);
	}
}

function gmui_animation_tween_path(_id, _path_name, _duration = -1, _easing = undefined) {
	gmui_animation_init_check_safe();
	gmui_container_animation_detected(gmui_get_current_container());
	
	var _exists = ds_map_find_value(gmui_animation_get().tweens_map, _id);
	if (_exists != undefined && _exists.state != gmui_animation_tween_state.KILLED) { return gmui_animation_get_value(_id); }
	
	gmui_animation_tween_path_start(_id, _path_name, _duration, _easing);
	return gmui_animation_get_value(_id);
}

function gmui_animation_tween_path_start(_id, _path_name, _duration = -1, _easing = undefined) {
	gmui_animation_init_check_safe();
	gmui_container_animation_detected(gmui_get_current_container());
	gmui_animation_remove_existing_tween(_id);
	
	var _anim = gmui_animation_get();
	var _path = ds_map_find_value(_anim.paths, _path_name);
	
	if (_path == undefined) {
		//show_debug_message("ERROR: Path '" + _path_name + "' not found");
		return undefined;
	}
	
	var _start = _path.points[0];
	var _end = _path.points[array_length(_path.points) - 1];
	
	var _tween = gmui_animation_create(_id, _start, _end, _duration);
	_tween.value_type = gmui_animation_value_type.VECTOR2;
	_tween.flags &= ~gmui_animation_tween_flags.CLAMP_VALUES;
	_tween.user_data = { path_name: _path_name };
	
	_tween.value_lerp = method(_tween, function(_start, _end, _t) {
		var _path_ref = ds_map_find_value(gmui_animation_get().paths, self.user_data.path_name);
		return gmui_animation_path_evaluate(_path_ref, _t);
	});
	
	if (_easing != undefined) gmui_animation_set_easing(_id, _easing);
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
	
	 var _path_keys = ds_map_keys_to_array(_anim.paths);
	 for (var p = 0; p < array_length(_path_keys); p++) { ds_map_delete(_anim.paths, _path_keys[p]); };
	 ds_map_destroy(_anim.paths);
	
	var _clip_keys = ds_map_keys_to_array(_anim.clips);
	for (var c = 0; c < array_length(_clip_keys); c++) {
	    ds_map_delete(_anim.clips, _clip_keys[c]);
	}
	ds_map_destroy(_anim.clips);
	
	var _group_keys = ds_map_keys_to_array(_anim.groups);
	for (var g = 0; g < array_length(_group_keys); g++) {
		var _key = _group_keys[g];
		var _group_list = _anim.groups[? _key];
		if (_group_list != undefined) {
			_group_list = undefined;
		}
		ds_map_delete(_anim.groups, _key);
	}
	ds_map_destroy(_anim.groups);
	
	ds_map_destroy(_anim.tweens_map);
	
	var _timeline_keys = ds_map_keys_to_array(_anim.timelines);
	for (var t = 0; t < array_length(_timeline_keys); t++) {
		ds_map_delete(_anim.timelines, _timeline_keys[t]);
	}
	ds_map_destroy(_anim.timelines);
	
	_anim.tweens = [ ];
	
	_anim.active_tweens = 0;
	_anim.total_tweens_created = 0;
	_anim.global_time_scale = 1.0;
	_anim.groups = undefined;
	_anim.tweens_map = undefined;
	_anim.timelines = undefined;
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
	gmui_container_animation_detected(gmui_get_current_container());
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
	gmui_container_animation_detected(gmui_get_current_container());
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
	gmui_container_animation_detected(gmui_get_current_container());
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
	gmui_container_animation_detected(gmui_get_current_container());
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
	gmui_container_animation_detected(gmui_get_current_container());
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
	gmui_container_animation_detected(gmui_get_current_container());
	var _exists = ds_map_find_value(gmui_animation_get().tweens_map, _id);
	if (_exists != undefined && _exists.state != gmui_animation_tween_state.KILLED) { return gmui_animation_get_value(_id); }
	gmui_animation_tween_array_start(_id, _from_array, _to_array, _duration, _easing);
	return gmui_animation_get_value(_id);
}

function gmui_animation_tween_int(_id, _from, _to, _duration = -1, _easing = undefined) {
	gmui_animation_init_check_safe();
	gmui_container_animation_detected(gmui_get_current_container());
	var _exists = ds_map_find_value(gmui_animation_get().tweens_map, _id);
	if (_exists != undefined && _exists.state != gmui_animation_tween_state.KILLED) { return gmui_animation_get_value(_id); }
	gmui_animation_tween_int_start(_id, _from, _to, _duration, _easing);
	return gmui_animation_get_value(_id);
}

function gmui_animation_tween_int_start(_id, _from, _to, _duration = -1, _easing = undefined) {
	gmui_animation_init_check_safe();
	gmui_animation_remove_existing_tween(_id);
	var _tween = gmui_animation_create(_id, _from, _to, _duration);
	_tween.value_type = gmui_animation_value_type.INT;
	_tween.snap_to_integer = true;
	if (_easing != undefined) gmui_animation_set_easing(_id, _easing);
	_tween.state = gmui_animation_tween_state.PLAYING;
	gmui_animation_get().active_tweens++;
	return _tween;
}

// bezier paths
function gmui_animation_bezier_cubic(_p0, _p1, _p2, _p3, _t) {
	var _u = 1 - _t;
	var _tt = _t * _t;
	var _uu = _u * _u;
	return _uu * _u * _p0 + 3 * _uu * _t * _p1 + 3 * _u * _tt * _p2 + _tt * _t * _p3;
}

function gmui_animation_bezier_quadratic(_p0, _p1, _p2, _t) {
	var _u = 1 - _t;
	return _u * _u * _p0 + 2 * _u * _t * _p1 + _t * _t * _p2;
}

function gmui_animation_bezier_cubic_2d(_p0, _p1, _p2, _p3, _t) {
	return [
		gmui_animation_bezier_cubic(_p0[0], _p1[0], _p2[0], _p3[0], _t),
		gmui_animation_bezier_cubic(_p0[1], _p1[1], _p2[1], _p3[1], _t)
	];
}

function gmui_animation_catmull_rom(_points, _t, _loop = false) {
	var _count = array_length(_points);
	if (_count < 2) return _points[0];
	
	if (_loop) {
		_t = frac(_t);
	} else {
		_t = clamp(_t, 0, 1);
	}
	
	var _segments = _loop ? _count : _count - 1;
	var _scaled_t = _t * _segments;
	var _idx = floor(_scaled_t);
	var _local_t = _scaled_t - _idx;
	
	var _p0, _p1, _p2, _p3;
	
	if (_loop) {
		_p0 = _points[(_idx - 1 + _count) % _count];
		_p1 = _points[_idx % _count];
		_p2 = _points[(_idx + 1) % _count];
		_p3 = _points[(_idx + 2) % _count];
	} else {
		_idx = clamp(_idx, 0, _count - 2);
		_p0 = (_idx > 0) ? _points[_idx - 1] : _points[0];
		_p1 = _points[_idx];
		_p2 = _points[_idx + 1];
		_p3 = (_idx < _count - 2) ? _points[_idx + 2] : _points[_count - 1];
	}
	
	// catmull-rom formula
	var _tt = _local_t * _local_t;
	var _ttt = _tt * _local_t;
	
	if (is_array(_p0)) {
		var _result = [0, 0];
		for (var i = 0; i < 2; i++) {
			_result[i] = 0.5 * ((2 * _p1[i]) + 
			                     (-_p0[i] + _p2[i]) * _local_t + 
			                     (2 * _p0[i] - 5 * _p1[i] + 4 * _p2[i] - _p3[i]) * _tt + 
			                     (-_p0[i] + 3 * _p1[i] - 3 * _p2[i] + _p3[i]) * _ttt);
		}
		return _result;
	} else {
		return 0.5 * ((2 * _p1) + 
		              (-_p0 + _p2) * _local_t + 
		              (2 * _p0 - 5 * _p1 + 4 * _p2 - _p3) * _tt + 
		              (-_p0 + 3 * _p1 - 3 * _p2 + _p3) * _ttt);
	}
}

function gmui_animation_tween_bezier(_id, _p0, _p1, _p2, _p3, _duration = -1, _easing = undefined) {
	gmui_animation_init_check_safe();
	gmui_container_animation_detected(gmui_get_current_container());
	
	var _exists = ds_map_find_value(gmui_animation_get().tweens_map, _id);
	if (_exists != undefined && _exists.state != gmui_animation_tween_state.KILLED) { return gmui_animation_get_value(_id); }
	
	gmui_animation_tween_bezier_start(_id, _p0, _p1, _p2, _p3, _duration, _easing);
	return gmui_animation_get_value(_id);
}

function gmui_animation_tween_bezier_start(_id, _p0, _p1, _p2, _p3, _duration = -1, _easing = undefined) {
	gmui_animation_init_check_safe();
	gmui_container_animation_detected(gmui_get_current_container());
	gmui_animation_remove_existing_tween(_id);
	
	var _tween = gmui_animation_create(_id, _p0, _p3, _duration);
	_tween.value_type = gmui_animation_value_type.CUSTOM;
	_tween.user_data = { p0: _p0, p1: _p1, p2: _p2, p3: _p3 };
	_tween.value_lerp = method(_tween, function(_start, _end, _t) {
		var _ud = self.user_data;
		return gmui_animation_bezier_cubic(_ud.p0, _ud.p1, _ud.p2, _ud.p3, _t);
	});
	_tween.flags &= ~gmui_animation_tween_flags.CLAMP_VALUES;
	if (_easing != undefined) gmui_animation_set_easing(_id, _easing);
	_tween.state = gmui_animation_tween_state.PLAYING;
	gmui_animation_get().active_tweens++;
	return _tween;
}

function gmui_animation_tween_bezier_2d(_id, _p0, _p1, _p2, _p3, _duration = -1, _easing = undefined) {
	gmui_animation_init_check_safe();
	gmui_container_animation_detected(gmui_get_current_container());
	
	var _exists = ds_map_find_value(gmui_animation_get().tweens_map, _id);
	if (_exists != undefined && _exists.state != gmui_animation_tween_state.KILLED) { return gmui_animation_get_value(_id); }
	
	gmui_animation_tween_bezier_2d_start(_id, _p0, _p1, _p2, _p3, _duration, _easing);
	return gmui_animation_get_value(_id);
}

function gmui_animation_tween_bezier_2d_start(_id, _p0, _p1, _p2, _p3, _duration = -1, _easing = undefined) {
	gmui_animation_init_check_safe();
	gmui_container_animation_detected(gmui_get_current_container());
	gmui_animation_remove_existing_tween(_id);
	
	var _tween = gmui_animation_create(_id, _p0, _p3, _duration);
	_tween.value_type = gmui_animation_value_type.VECTOR2;
	_tween.user_data = { p0: _p0, p1: _p1, p2: _p2, p3: _p3 };
	_tween.value_lerp = method(_tween, function(_start, _end, _t) {
		var _ud = self.user_data;
		return gmui_animation_bezier_cubic_2d(_ud.p0, _ud.p1, _ud.p2, _ud.p3, _t);
	});
	_tween.flags &= ~gmui_animation_tween_flags.CLAMP_VALUES;
	if (_easing != undefined) gmui_animation_set_easing(_id, _easing);
	_tween.state = gmui_animation_tween_state.PLAYING;
	gmui_animation_get().active_tweens++;
	return _tween;
}

function gmui_animation_tween_spline(_id, _points, _duration = -1, _loop = false, _easing = undefined) {
	gmui_animation_init_check_safe();
	gmui_container_animation_detected(gmui_get_current_container());
	
	var _exists = ds_map_find_value(gmui_animation_get().tweens_map, _id);
	if (_exists != undefined && _exists.state != gmui_animation_tween_state.KILLED) { return gmui_animation_get_value(_id); }
	
	gmui_animation_tween_spline_start(_id, _points, _duration, _loop, _easing);
	return gmui_animation_get_value(_id);
}

function gmui_animation_tween_spline_start(_id, _points, _duration = -1, _loop = false, _easing = undefined) {
	gmui_animation_init_check_safe();
	gmui_container_animation_detected(gmui_get_current_container());
	gmui_animation_remove_existing_tween(_id);
	
	var _start = _points[0];
	var _end = _loop ? _points[0] : _points[array_length(_points) - 1];
	
	var _tween = gmui_animation_create(_id, _start, _end, _duration);
	_tween.value_type = is_array(_start) ? gmui_animation_value_type.VECTOR2 : gmui_animation_value_type.REAL;
	_tween.user_data = { points: _points, loop: _loop };
	_tween.value_lerp = method(_tween, function(_s, _e, _t) {
		var _ud = self.user_data;
		return gmui_animation_catmull_rom(_ud.points, _t, _ud.loop);
	});
	_tween.flags &= ~gmui_animation_tween_flags.CLAMP_VALUES;
	if (_easing != undefined) gmui_animation_set_easing(_id, _easing);
	_tween.state = gmui_animation_tween_state.PLAYING;
	gmui_animation_get().active_tweens++;
	return _tween;
}

// demo
function gmui_animation_demo() { // yes, not a visual novelty but the purpose is to demonstrate its functionality
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
                    gmui_animation_tween("demo_real", 0, 1, 1500000, gmui_animation_ease.LINEAR);
                }
                gmui_sameline();
                if (gmui_button("Start Bounce")) {
                    gmui_animation_tween("demo_real", 0, 1, 1500000, gmui_animation_ease.OUT_BOUNCE);
                }
                gmui_sameline();
                if (gmui_button("Start Elastic")) {
                    gmui_animation_tween("demo_real", 0, 1, 1500000, gmui_animation_ease.OUT_ELASTIC);
                }
                
                var val = gmui_animation_get_value("demo_real") ?? 0;
                gmui_text($"Value: {string_format(val, 1, 3)}");
                gmui_progress(val, 1, gmui_get_available_width(), true);
                
                gmui_end_collapsing_header();
            }
			
			if (gmui_begin_collapsing_header_ex("Integer Tween (Auto-Snap)")) {
			    if (gmui_button("0 -> 100")) {
			        gmui_animation_tween_int("demo_int", 0, 100, 2000000, gmui_animation_ease.IN_OUT_QUAD);
			    }
			    gmui_sameline();
			    if (gmui_button("100 -> 0")) {
			        gmui_animation_tween_int("demo_int", 100, 0, 2000000, gmui_animation_ease.OUT_ELASTIC);
			    }
    
			    var iv = gmui_animation_get_value("demo_int") ?? 0;
			    gmui_text($"Value: {string_format(iv, 1, 0)} (always integer)");
			    gmui_progress(iv, 100, gmui_get_available_width(), true);
    
			    gmui_end_collapsing_header();
			}
            
            if (gmui_begin_collapsing_header_ex("Color3 Tween (RGB)")) {
                static demo_color3_fallback = c_black;
                
                if (gmui_button("Red -> Blue")) {
                    demo_color3_fallback = gmui_animation_tween_color3("demo_color3", c_red, c_blue, 1500000, gmui_animation_ease.IN_OUT_QUAD);
                }
                gmui_sameline();
                if (gmui_button("Yellow -> Purple")) {
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
                if (gmui_button("Move Corner -> Corner")) {
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
			
			if (gmui_begin_collapsing_header_ex("Bezier Path")) {
			    if (gmui_button("Cubic Bezier: 0 ->^ 1.5 ->! 0.5 -> 1")) {
			        gmui_animation_tween_bezier("demo_bezier", 0, 1.5, 0.5, 1, 2000000, gmui_animation_ease.LINEAR);
			    }
			    gmui_sameline();
			    if (gmui_button("Overshoot Path")) {
			        gmui_animation_tween_bezier("demo_bezier", 0, 1.3, -0.2, 1, 2000000, gmui_animation_ease.LINEAR);
			    }
    
			    var bv = gmui_animation_get_value("demo_bezier") ?? 0;
			    gmui_text($"Value: {string_format(bv, 1, 3)}");
			    gmui_progress(clamp(bv, 0, 1.5), 1.5, gmui_get_available_width(), true);
			    gmui_text("Path: overshoots then settles");
    
			    gmui_end_collapsing_header();
			}

			if (gmui_begin_collapsing_header_ex("Bezier 2D Path")) {
			    if (gmui_button("Arc Path")) {
			        gmui_animation_tween_bezier_2d("demo_bezier2d", [0, 0], [0.3, 1.2], [0.7, 1.2], [1, 0], 2000000, gmui_animation_ease.LINEAR);
			    }
			    gmui_sameline();
			    if (gmui_button("S-Curve")) {
			        gmui_animation_tween_bezier_2d("demo_bezier2d", [0, 0.5], [0.5, 1.5], [0.5, -0.5], [1, 0.5], 2000000, gmui_animation_ease.LINEAR);
			    }
    
			    var b2d = gmui_animation_get_value("demo_bezier2d") ?? [0, 0];
			    gmui_text($"X: {string_format(b2d[0], 1, 3)}  Y: {string_format(b2d[1], 1, 3)}");
			    gmui_progress(b2d[0], 1, gmui_get_available_width(), true);
			    gmui_progress(b2d[1], 1.5, gmui_get_available_width(), true);
    
			    gmui_end_collapsing_header();
			}

			if (gmui_begin_collapsing_header_ex("Spline Path (Catmull-Rom)")) {
			    if (gmui_button("Through Points")) {
			        var pts = [0, 0.8, 0.3, 1.2, 0.6, 0.4, 1];
			        gmui_animation_tween_spline("demo_spline", pts, 3000000, false, gmui_animation_ease.LINEAR);
			    }
			    gmui_sameline();
			    if (gmui_button("Looping Spline")) {
			        var pts = [0, 0.8, 0.3, 1.2, 0.6, 0.4, 1];
			        gmui_animation_tween_spline("demo_spline", pts, 3000000, true, gmui_animation_ease.LINEAR);
			    }
    
			    var sv = gmui_animation_get_value("demo_spline") ?? 0;
			    gmui_text($"Value: {string_format(sv, 1, 3)}");
			    gmui_progress(clamp(sv, 0, 1.5), 1.5, gmui_get_available_width(), true);
    
			    gmui_end_collapsing_header();
			}
			
			if (gmui_begin_collapsing_header_ex("Timeline Keyframes")) {
			    if (gmui_button("Play Timeline")) {
			        var kfs = [
			            gmui_animation_keyframe(0, 0, gmui_animation_ease.OUT_QUAD),
			            gmui_animation_keyframe(500000, 1, gmui_animation_ease.OUT_BOUNCE),
			            gmui_animation_keyframe(1200000, 0.3, gmui_animation_ease.OUT_ELASTIC),
			            gmui_animation_keyframe(2000000, 1, gmui_animation_ease.IN_OUT_BACK),
			        ];
			        gmui_animation_timeline_start("demo_timeline", kfs, false);
			    }
			    gmui_sameline();
			    if (gmui_button("Loop Timeline")) {
			        var kfs = [
			            gmui_animation_keyframe(0, 0),
			            gmui_animation_keyframe(400000, 1),
			            gmui_animation_keyframe(800000, 0.5),
			            gmui_animation_keyframe(1200000, 1),
			            gmui_animation_keyframe(1600000, 0),
			        ];
			        gmui_animation_timeline_start("demo_timeline", kfs, true);
			    }
			    gmui_sameline();
			    if (gmui_button("Vector2 Timeline")) {
			        var kfs = [
			            gmui_animation_keyframe(0, [0, 0], gmui_animation_ease.OUT_QUAD),
			            gmui_animation_keyframe(500000, [1, 0.8], gmui_animation_ease.OUT_BOUNCE),
			            gmui_animation_keyframe(1000000, [0.5, 0.2], gmui_animation_ease.IN_OUT_BACK),
			            gmui_animation_keyframe(1500000, [1, 1], gmui_animation_ease.OUT_ELASTIC),
			        ];
			        gmui_animation_timeline_start("demo_timeline", kfs, false);
			    }
    
			    var tv = gmui_animation_get_value("demo_timeline");
			    if (is_array(tv)) {
			        gmui_text($"X: {string_format(tv[0], 1, 3)}  Y: {string_format(tv[1], 1, 3)}");
			        gmui_progress(tv[0], 1, gmui_get_available_width(), true);
			        gmui_progress(tv[1], 1, gmui_get_available_width(), true);
			    } else {
			        gmui_text($"Value: {string_format(tv ?? 0, 1, 3)}");
			        gmui_progress(tv ?? 0, 1, gmui_get_available_width(), true);
			    }
    
			    gmui_end_collapsing_header();
			}
			
			if (gmui_begin_collapsing_header_ex("Spring Physics")) {
				static spring_tension = 0.3;
				static spring_friction = 0.3;

				spring_tension = gmui_slider(spring_tension, 0.1, 3, gmui_get_available_width());
				gmui_text($"Tension: {string_format(spring_tension, 1, 2)}");
				spring_friction = gmui_slider(spring_friction, 0.1, 2, gmui_get_available_width());
				gmui_text($"Friction: {string_format(spring_friction, 1, 2)}");
    
			    if (gmui_button("Spring: 0 -> 1")) {
			        gmui_animation_spring("demo_spring", 0, 1, spring_tension, spring_friction);
			    }
			    gmui_sameline();
			    if (gmui_button("Spring: 1 -> 0")) {
			        gmui_animation_spring("demo_spring", 1, 0, spring_tension, spring_friction);
			    }
			    gmui_sameline();
			    if (gmui_button("Bouncy!")) {
			        gmui_animation_spring("demo_spring", 0, 1, spring_tension, spring_friction);
			    }
    
			    var spv = gmui_animation_get_value("demo_spring") ?? 0;
			    gmui_text($"Value: {string_format(spv, 1, 3)}");
			    gmui_progress(spv, 4, gmui_get_available_width(), true);
    
			    gmui_end_collapsing_header();
			}
			
			if (gmui_begin_collapsing_header_ex("Perlin Noise")) {
			    if (gmui_button("Start Perlin")) {
			        gmui_animation_perlin_wiggle("demo_perlin", 0.5, 0.3, 2, 42, -1);
			    }
			    gmui_sameline();
			    if (gmui_button("Faster")) {
			        gmui_animation_perlin_wiggle("demo_perlin", 0.5, 0.3, 5, 123, -1);
			    }
			    gmui_sameline();
			    if (gmui_button("Stop")) {
			        gmui_animation_stop("demo_perlin", false);
			    }
    
			    var pnv = gmui_animation_get_value("demo_perlin") ?? 0.5;
			    gmui_text($"Value: {string_format(pnv, 1, 3)}");
			    gmui_progress(clamp(pnv, 0, 1), 1, gmui_get_available_width(), true);
			    gmui_text("Smooth natural-looking random motion");
    
			    gmui_end_collapsing_header();
			}
			
			if (gmui_begin_collapsing_header_ex("Rotation & Transform")) {
			    static demo_angle_fallback = 0;
    
			    if (gmui_button("Rotate 0° -> 350°")) {
			        gmui_animation_tween_angle("demo_angle", 0, 350, 2000000, gmui_animation_ease.IN_OUT_QUAD);
			    }
			    gmui_sameline();
			    if (gmui_button("Rotate 0° -> 720°")) {
			        gmui_animation_tween_angle("demo_angle", 0, 720, 2000000, gmui_animation_ease.IN_OUT_QUAD);
			    }
			    gmui_sameline();
			    if (gmui_button("Spin!")) {
			        gmui_animation_tween_angle("demo_angle", 0, 360, 1000000, gmui_animation_ease.LINEAR);
			        gmui_animation_set_repeat("demo_angle", -1);
			    }

			    var ang = gmui_animation_get_value("demo_angle");
			    if (ang == undefined) { ang = demo_angle_fallback; }
			    else { demo_angle_fallback = ang; }
    
			    var display_ang = ((ang % 360) + 360) % 360;
			    gmui_text($"Angle: {string_format(display_ang, 1, 1)}° | Raw: {string_format(ang, 1, 1)}°");
			    gmui_progress(display_ang / 360, 1, gmui_get_available_width(), true);

			    gmui_text("Position + Scale (via Vector2):");
			    if (gmui_button("Move & Grow")) {
			        gmui_animation_tween_position("demo_pos", 0, 0, 100, 200, 1500000, gmui_animation_ease.OUT_BOUNCE);
			        gmui_animation_tween_scale("demo_scale", 1, 1, 1.5, 0.8, 1500000, gmui_animation_ease.OUT_ELASTIC);
			    }

			    var pos = gmui_animation_get_value("demo_pos") ?? [0, 0];
			    var scl = gmui_animation_get_value("demo_scale") ?? [1, 1];
			    gmui_text($"Pos: ({string_format(pos[0],1,0)}, {string_format(pos[1],1,0)})");
			    gmui_text($"Scale: ({string_format(scl[0],1,2)}, {string_format(scl[1],1,2)})");

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
            
            if (gmui_button("Next Easing ->")) {
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
			
			if (gmui_begin_collapsing_header_ex("Stagger (Sequential Delay)")) {
			    if (gmui_button("Stagger 5 Bars")) {
			        var ids = [];
			        for (var i = 0; i < 5; i++) {
			            ids[i] = "demo_stagger_" + string(i);
			        }
			        gmui_animation_stagger(ids, 0, 1, 500000, 150000, gmui_animation_ease.OUT_BOUNCE);
			    }
			    gmui_sameline();
			    if (gmui_button("Stagger Ex (Custom)")) {
			        var items = [];
			        for (var i = 0; i < 5; i++) {
			            items[i] = { id: "demo_stagger_" + string(i), from: 0, to: 0.3 + i * 0.15 };
			        }
			        gmui_animation_stagger_ex(items, 600000, 120000, gmui_animation_ease.OUT_ELASTIC);
			    }
    
			    for (var i = 0; i < 5; i++) {
			        var sv = gmui_animation_get_value("demo_stagger_" + string(i)) ?? 0;
			        gmui_progress(sv, 1, gmui_get_available_width(), true);
			    }
    
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
					demo_stop_fallback = 1;
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
        
			if (gmui_begin_collapsing_header_ex("Queue (Chain Tweens)")) {
			    if (gmui_button("Queue: 0->100")) {
			        gmui_animation_queue("demo_queue", 0, 1, 800000, gmui_animation_ease.OUT_QUAD);
			    }
			    gmui_sameline();
			    if (gmui_button("Queue: ->50")) {
			        gmui_animation_queue("demo_queue", gmui_animation_get_value("demo_queue") ?? 1, 0.5, 500000, gmui_animation_ease.OUT_BOUNCE);
			    }
			    gmui_sameline();
			    if (gmui_button("Queue: ->0")) {
			        gmui_animation_queue("demo_queue", gmui_animation_get_value("demo_queue") ?? 0.5, 0, 600000, gmui_animation_ease.IN_OUT_BACK);
			    }
			    gmui_sameline();
			    if (gmui_button("Clear Queue")) {
			        gmui_animation_queue_clear("demo_queue");
			    }
    
			    var qv = gmui_animation_get_value("demo_queue") ?? 0;
			    gmui_text($"Value: {string_format(qv, 1, 3)} | Queued: {gmui_animation_get_queue_count("demo_queue")}");
			    gmui_progress(qv, 1, gmui_get_available_width(), true);
    
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
			
			if (gmui_begin_collapsing_header_ex("Per-Axis Easing (Vector)")) {
			    if (gmui_button("X: Bounce, Y: Linear")) {
			        gmui_animation_tween_vector2("demo_peraxis", [0, 0], [1, 1], 1500000);
			        gmui_animation_set_easing_per_axis("demo_peraxis", [gmui_animation_ease.OUT_BOUNCE, gmui_animation_ease.LINEAR]);
			    }
			    gmui_sameline();
			    if (gmui_button("X: Elastic, Y: Back")) {
			        gmui_animation_tween_vector2("demo_peraxis", [0, 0], [1, 1], 1500000);
			        gmui_animation_set_easing_per_axis("demo_peraxis", [gmui_animation_ease.OUT_ELASTIC, gmui_animation_ease.IN_OUT_BACK]);
			    }
    
			    var pa = gmui_animation_get_value("demo_peraxis") ?? [0, 0];
			    gmui_text($"X: {string_format(pa[0], 1, 3)} (Bounce/Elastic)");
			    gmui_progress(pa[0], 1, gmui_get_available_width(), true);
			    gmui_text($"Y: {string_format(pa[1], 1, 3)} (Linear/Back)");
			    gmui_progress(pa[1], 1, gmui_get_available_width(), true);
    
			    gmui_end_collapsing_header();
			}
			
			if (gmui_begin_collapsing_header_ex("Wiggle (Continuous Oscillation)")) {
			    if (gmui_button("Start Wiggle")) {
			        gmui_animation_wiggle("demo_wiggle", 0.5, 0.25, 3, -1);
			    }
			    gmui_sameline();
			    if (gmui_button("Faster")) {
			        gmui_animation_wiggle("demo_wiggle", 0.5, 0.25, 8, -1);
			    }
			    gmui_sameline();
			    if (gmui_button("Stop")) {
			        gmui_animation_stop("demo_wiggle", false);
			    }
    
			    var wv = gmui_animation_get_value("demo_wiggle") ?? 0.5;
			    gmui_text($"Value: {string_format(wv, 1, 3)} | Playing: {gmui_animation_is_playing("demo_wiggle")}");
			    gmui_progress(clamp(wv, 0, 1), 1, gmui_get_available_width(), true);
    
			    gmui_end_collapsing_header();
			}
			
			if (gmui_begin_collapsing_header_ex("Clips")) {
			    static clips_defined = false;
    
			    if (!clips_defined) {
			        var bounce = gmui_animation_clip_begin("bounce");
			        gmui_animation_clip_key_float(bounce, 0, 1.0, gmui_animation_ease.OUT_ELASTIC);
			        gmui_animation_clip_key_float(bounce, 500000, 1.5, gmui_animation_ease.IN_OUT_CUBIC);
			        gmui_animation_clip_key_float(bounce, 1000000, 1.0, gmui_animation_ease.OUT_BOUNCE);
			        gmui_animation_clip_set_loop(bounce, true, gmui_animation_repeat_mode.PING_PONG);
			        gmui_animation_clip_end(bounce);
        
			        var fade_in = gmui_animation_clip_begin("fade_in");
			        gmui_animation_clip_key_float(fade_in, 0, 0, gmui_animation_ease.OUT_QUAD);
			        gmui_animation_clip_key_float(fade_in, 800000, 1, gmui_animation_ease.LINEAR);
			        gmui_animation_clip_chain(fade_in, "bounce");
			        gmui_animation_clip_end(fade_in);
        
			        clips_defined = true;
			    }
    
			    if (gmui_button("Play 'bounce' Clip")) {
			        gmui_animation_clip_play("bounce", "demo_clip_bounce");
			    }
			    gmui_sameline();
			    if (gmui_button("Play 'fade_in' + 'bounce'")) {
				    gmui_animation_clip_play("fade_in", "demo_clip_chain");
				}
			    gmui_sameline();
			    if (gmui_button("Stop")) {
			        gmui_animation_clip_stop("demo_clip_bounce");
			        gmui_animation_clip_stop("demo_clip_chain");
			    }
    
			    var cv = gmui_animation_clip_get_float("demo_clip_bounce");
			    if (gmui_animation_clip_is_playing("demo_clip_bounce")) {
			        gmui_text($"Bounce: {string_format(cv, 1, 3)}");
			        gmui_progress(cv, 1.5, gmui_get_available_width(), true);
			    }
    
			    var fv = gmui_animation_clip_get_float("demo_clip_chain");
				if (!gmui_animation_clip_is_playing("demo_clip_chain")) {
				    fv = gmui_animation_clip_get_float("demo_clip_chain_next");
				}
				if (gmui_animation_clip_is_playing("demo_clip_chain")) {
				    gmui_text($"Chain: {string_format(fv, 1, 3)}");
				    gmui_progress(fv, 1.5, gmui_get_available_width(), true);
				}
    
			    gmui_end_collapsing_header();
			}
			
			if (gmui_begin_collapsing_header_ex("Clip with Stagger")) {
			    static stagger_clip_defined = false;
			    if (!stagger_clip_defined) {
			        var stagger = gmui_animation_clip_begin("stagger_fade");
			        gmui_animation_clip_key_float(stagger, 0, 0, gmui_animation_ease.OUT_QUAD);
			        gmui_animation_clip_key_float(stagger, 800000, 1, gmui_animation_ease.OUT_BOUNCE);
			        gmui_animation_clip_set_stagger(stagger, 6, 150000);
			        gmui_animation_clip_end(stagger);
			        stagger_clip_defined = true;
			    }
    
			    if (gmui_button("Play Stagger")) {
			        gmui_animation_clip_play("stagger_fade", "demo_stagger_clip");
			    }
    
			    for (var i = 0; i < 6; i++) {
			        var sv = gmui_animation_get_value("demo_stagger_clip_" + string(i)) ?? 0;
			        gmui_progress(sv, 1, gmui_get_available_width(), true);
			    }
    
			    gmui_end_collapsing_header();
			}
			
			if (gmui_begin_collapsing_header_ex("Named Paths")) {
			    static paths_defined = false;
			    if (!paths_defined) {
			        var curve = gmui_animation_path_begin("my_curve", [0, 0]);
			        gmui_animation_path_quadratic_to(curve, [50, -50], [100, 0]);
			        gmui_animation_path_cubic_to(curve, [130, 0], [170, 100], [200, 50]);
			        gmui_animation_path_end(curve);
			        paths_defined = true;
			    }
    
			    if (gmui_button("Play Path")) {
			        gmui_animation_tween_path("demo_named_path", "my_curve", 2000000, gmui_animation_ease.LINEAR);
			    }
    
			    var np = gmui_animation_get_value("demo_named_path") ?? [0, 0];
			    gmui_text($"X: {string_format(np[0], 1, 1)}  Y: {string_format(np[1], 1, 1)}");
			    gmui_progress(np[0], 200, gmui_get_available_width(), true);
			    gmui_progress(np[1], 100, gmui_get_available_width(), true);
    
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