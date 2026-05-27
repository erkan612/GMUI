

// INPUT
function gmui_update_input() {
	var gmui = global.gmui;
	var input = gmui.input;
	
	input.m_wheel = mouse_wheel_up() - mouse_wheel_down();
	input.m_x = device_mouse_x_to_gui(0);
	input.m_y = device_mouse_y_to_gui(0);
	input.m_pressed = mouse_check_button_pressed(mb_left);
	input.m_released = mouse_check_button_released(mb_left);
	input.m_held = mouse_check_button(mb_left);
    
    input.k_pressed = keyboard_check_pressed(vk_anykey);
    input.k_key = keyboard_key;
    input.k_lastchar = keyboard_lastchar;
    input.k_lastkey = keyboard_lastkey;
    input.k_control = keyboard_check(vk_control);
    input.k_shift = keyboard_check(vk_shift);
    input.k_alt = keyboard_check(vk_alt);
	
	input.hovered_widget_id = undefined;
};

// Mouse
function gmui_input_mouse_pressed() {
	return global.gmui.input.m_pressed;
};

function gmui_input_mouse_released() {
	return global.gmui.input.m_released;
};

function gmui_input_mouse_held() {
	return global.gmui.input.m_held;
};

function gmui_input_mouse_x() {
	return global.gmui.input.m_x;
};

function gmui_input_mouse_y() {
	return global.gmui.input.m_y;
};

function gmui_input_is_hovered(x, y, width, height) {
	var gmui = global.gmui;
	return point_in_rectangle(gmui.input.m_x, gmui.input.m_y, x, y, x + width, y + height);
};

// Keyboard
function gmui_input_key_pressed() {
    return global.gmui.input.k_pressed;
};

function gmui_input_key() {
    return global.gmui.input.k_key;
};

function gmui_input_lastchar() {
    return global.gmui.input.k_lastchar;
};

function gmui_input_lastkey() {
    return global.gmui.input.k_lastkey;
};

function gmui_input_ctrl() {
    return global.gmui.input.k_control;
};

function gmui_input_shift() {
    return global.gmui.input.k_shift;
};

function gmui_input_alt() {
    return global.gmui.input.k_alt;
};

function gmui_input_key_held(key) {
    return keyboard_check(key);
}