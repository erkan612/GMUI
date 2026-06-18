gmui_update();

gmui_dockspace(
	"My Editor",
	function(tab_name) {
		switch (tab_name) {
		case "Hierarchy": {
			gmui_text("Hierarchy content");
		} break;
		case "Toolbar": {
			gmui_text("Toolbar content");
		} break;
		case "Materials": {
			gmui_text("Materials content");
		} break;
		case "Settings": {
			gmui_text("Settings content");
		} break;
		case "Scene": {
			gmui_text("Scene content");
			mti = gmui_textbox_multiline(mti);
		} break;
		case "Assets": {
			gmui_text("Assets content");
		} break;
		case "Output": {
			gmui_text("Output content");
		} break;
		case "Inspector": {
			gmui_text("Inspector content");
		} break;
		}
	},
	[
		gmui_menu_item("File", "Ctx_File"),
		gmui_menu_item("Edit", "Ctx_Edit"),
		gmui_menu_item("Windows", "Ctx_Windows"),
		gmui_menu_item("Help", "Ctx_Help"),
	],
	{
		height: 28, 
		handler: function() {
			gmui_cursor_set_x(4);
			gmui_button_icon1(GMUI_Icon, undefined, undefined, undefined, gmui_get().style.color_accent);
			gmui_button_icon1(GMUI_Icon, undefined, undefined, undefined, gmui_get().style.color_accent);
			gmui_button_icon1(GMUI_Icon, undefined, undefined, undefined, gmui_get().style.color_accent);
			gmui_button_icon1(GMUI_Icon, undefined, undefined, undefined, gmui_get().style.color_accent);
			gmui_separator_vertical();
			gmui_button_icon1(GMUI_Icon, undefined, undefined, undefined, gmui_get().style.color_accent);
			gmui_button_icon1(GMUI_Icon, undefined, undefined, undefined, gmui_get().style.color_accent);
			gmui_button_icon1(GMUI_Icon, undefined, undefined, undefined, gmui_get().style.color_accent);
			gmui_separator_vertical();
			gmui_button_icon1(GMUI_Icon, undefined, undefined, undefined, gmui_get().style.color_accent);
			gmui_button_icon1(GMUI_Icon, undefined, undefined, undefined, gmui_get().style.color_accent);
			gmui_button_icon1(GMUI_Icon, undefined, undefined, undefined, gmui_get().style.color_accent);
			gmui_button_icon1(GMUI_Icon, undefined, undefined, undefined, gmui_get().style.color_accent);
			gmui_separator_vertical();
			gmui_button_icon1(GMUI_Icon, undefined, undefined, undefined, gmui_get().style.color_accent);
		}
	},
	0, 0,
	1280, 720,
	gmui_window_flags.NONE
);

if (gmui_begin_context_menu("Ctx_File", 300)) {
	gmui_context_menu_item("New Project", "Ctrl+N");
	gmui_context_menu_item("Open Project", "Ctrl+O");
	gmui_context_menu_item("Import Project");
	if (gmui_begin_context_menu_sub("Recent Projects")) {
		gmui_context_menu_item("./TestProject.yyp");
		gmui_context_menu_item("./UIstuff.yyp");
		gmui_context_menu_item("./PlatformarSample.yyp");
		gmui_end_context_menu_sub();
	}
	
	gmui_context_menu_separator();
	
	gmui_context_menu_item("Save Project", "Ctrl+N");
	gmui_context_menu_item("Save Project As", "Ctrl+Shift+N");
	if (gmui_begin_context_menu_sub("Export Project As")) {
		gmui_context_menu_item("YYZ");
		gmui_context_menu_item("As Template");
		gmui_end_context_menu_sub();
	}
	
	gmui_context_menu_separator();
	gmui_context_menu_item("New IDE");
	
	gmui_context_menu_separator();
	gmui_context_menu_item("Preferences");
	
	gmui_context_menu_separator();
	gmui_context_menu_item("Exit");
	
	gmui_end_context_menu();
}

if (gmui_begin_context_menu("Ctx_Edit", 300)) {
	gmui_context_menu_item("Undo", "Ctrl+Z");
	gmui_context_menu_item("Redo", "Ctrl+Y");
	gmui_context_menu_item("Find & Replace", "Ctrl+Shift+F");
	
	gmui_end_context_menu();
}

if (gmui_begin_context_menu("Ctx_Windows", 300)) {
	gmui_context_menu_item_disabled("item disabled", "Ctrl+Ctrl");
	gmui_context_menu_item_checkbox_disabled("checkbox disabled", true);
	gmui_context_menu_item_checkbox_disabled("checkbox disabled", false);
	gmui_context_menu_item_radio_disabled("radio disabled", true);
	gmui_context_menu_item_radio_disabled("radio disabled", false);
	gmui_begin_context_menu_sub_disabled("sub disabled");
	
	gmui_end_context_menu();
}

if (gmui_begin_context_menu("Ctx_Help", 300)) {
	gmui_context_menu_item("Open Manual", "F1");
	gmui_context_menu_item("Open Welcome Tab");
	gmui_context_menu_item("Knowledge Base");
	gmui_context_menu_item("Contact Us");
	gmui_context_menu_item("Upload a Bug/Ticket Sample");
	gmui_context_menu_item("Report a GameMaker Bug");
	gmui_context_menu_item("Open Log in Explorer");
	gmui_context_menu_separator();
	gmui_context_menu_item("GameMaker.io");
	gmui_context_menu_item("GameMaker Community");
	gmui_context_menu_separator();
	gmui_context_menu_item("Release Notes");
	gmui_context_menu_item("Release SDKs");
	gmui_context_menu_separator();
	gmui_context_menu_item("Open Project in Explorer");
	gmui_context_menu_separator();
	gmui_context_menu_item("Refresh System Fonts");
	gmui_context_menu_item("Licenses");
	gmui_context_menu_item("Check for Update");
	gmui_context_menu_item("About");
	
	gmui_end_context_menu();
}