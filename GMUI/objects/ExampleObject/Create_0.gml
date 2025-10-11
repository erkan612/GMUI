gmui_init();

scroll_x = 0;
scroll_y = 0;

contentHeight = 0;

tabIdx = 1;
treeIdx = undefined;

txD1 = "";

c1 = false;
c2 = false;
c3 = false;

v2 = [ 0, 0 ];
v3 = [ 0, 0, 0 ];
v4 = [ 0, 0, 0, 0 ];

gmui_get().font = fnCascadiaCode;

editc4 = gmui_make_color_rgba(0, 0, 255, 255);
buttonc4 = gmui_make_color_rgba(255, 0, 255, 255);

combo_index = 0;
list_index = 0;

gmui_add_modal("Message", function(window) {
	gmui_text("Hello World!");
	if (gmui_button_width("OK", 300 - gmui_get().style.item_spacing[0] * 2)) { gmui_close_modal("Message"); };
});