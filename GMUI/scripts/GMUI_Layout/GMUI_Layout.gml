

// LAYOUT
function gmui_newline() {
	var gmui = global.gmui;
	var container = gmui.current_container;
	var context = container.context;
	
	context.new_line_requested = true;
	context.same_line_requested = false;
};

function gmui_sameline() {
	var gmui = global.gmui;
	var container = gmui.current_container;
	var context = container.context;
	
	context.new_line_requested = false;
	context.same_line_requested = true;
};

function gmui_indent(amount) {
    var gmui = global.gmui;
    var context = gmui.current_container.context;
    context.indent_level += amount;
};

function gmui_unindent(amount) {
    var gmui = global.gmui;
    var context = gmui.current_container.context;
    context.indent_level -= amount;
};

function gmui_spacing() {
    gmui_dummy(0, global.gmui.style.element_spacing_v);
};

function gmui_spacing_h() {
    gmui_dummy(global.gmui.style.element_spacing_h, 0);
};

function gmui_indent_push(amount = -1) {
    var style = global.gmui.style;
    var indent_amount = amount > 0 ? amount : style.spacing_large;
    gmui_indent(indent_amount);
};

function gmui_indent_pop(amount = -1) {
    var style = global.gmui.style;
    var indent_amount = amount > 0 ? amount : style.spacing_large;
    gmui_unindent(indent_amount);
};

function gmui_cursor_set(x, y) {
	if (global.gmui.current_container == undefined) { return; };
	gmui_container_cursor_advance(global.gmui.current_container);
	global.gmui.current_container.context.cursor_x = x;
	global.gmui.current_container.context.cursor_y = y;
};

function gmui_cursor_set_x(x) {
	if (global.gmui.current_container == undefined) { return; };
	gmui_container_cursor_advance(global.gmui.current_container);
	global.gmui.current_container.context.cursor_x = x;
};

function gmui_cursor_set_y(y) {
	if (global.gmui.current_container == undefined) { return; };
	gmui_container_cursor_advance(global.gmui.current_container);
	global.gmui.current_container.context.cursor_y = y;
};

function gmui_cursor_get() {
	if (global.gmui.current_container == undefined) { return; };
	return {
		x: global.gmui.current_container.context.cursor_x,
		y: global.gmui.current_container.context.cursor_y,
	};
};

function gmui_cursor_get_x() {
	if (global.gmui.current_container == undefined) { return; };
	return global.gmui.current_container.context.cursor_x;
};

function gmui_cursor_get_y() {
	if (global.gmui.current_container == undefined) { return; };
	return global.gmui.current_container.context.cursor_y;
};

function gmui_cursor_get_line_height() {
    return global.gmui.current_container.context.line_height;
}

function gmui_cursor_set_line_height(height) {
    global.gmui.current_container.context.line_height = height;
}

function gmui_get_available_width(container = undefined) {
    var gmui = global.gmui;
    var style = gmui.style;
	var _container = container ?? gmui.current_container;
	
	if (_container == undefined) { return -1; }
	
	if (_container.context.new_line_requested) {
		return _container.width - style.container_padding_h * 2;
	}
	else {
		return _container.width - style.container_padding_h - _container.context.cursor_x;
	};
};

function gmui_get_available_height(container = undefined) {
    var gmui = global.gmui;
    var style = gmui.style;
	var _container = container ?? gmui.current_container;
	
	if (_container == undefined) { return -1; }
	
	return _container.height - style.container_padding_v - (_container.context.same_line_requested ? 0 : _container.context.cursor_y + _container.context.line_height);
};