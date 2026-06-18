gmui_update();

if (gmui_begin("Debug", 100, 100, 290, 154)) {
	gmui_text($"Hello, world {123}");
	if (gmui_button("Save")) {
		/* Do stuff */
	}
	str = gmui_textbox_label(str, "string");
	float = gmui_slidebar_label(float, "float", 0, 1);
	gmui_end();
}