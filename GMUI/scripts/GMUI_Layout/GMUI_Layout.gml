

// LAYOUT
function gmui_newline() {
	var gmui = global.gmui;
	var container = gmui.current_container;
	var context = container.context;
	
	context.new_line_requested = true;
};

function gmui_sameline() {
	var gmui = global.gmui;
	var container = gmui.current_container;
	var context = container.context;
	
	context.new_line_requested = false;
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