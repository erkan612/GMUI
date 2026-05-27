

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