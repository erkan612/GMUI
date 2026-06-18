/*
* WARNING!
* this object is not meant to be a sample
* it is used to detect bugs and to test features
* if you have this, that means you have downloaded the project as zip
* instead of importing the *.yymps file
* do not take this object as a sample
* it does not aim to demonstrate anything
*/

gmui_init(gmui_get_default_profile(gmui_default_profile.BALANCED));

mti = "multi\nline\ntextbox!!!!";

math_set_epsilon(0.00000001);

gmui_docking_create_dockspace("My Editor");

gmui_docking_add_pane("My Editor", gmui_docking_pane_dir.PANE_RIGHT, 0.25);
gmui_docking_add_pane("My Editor", gmui_docking_pane_dir.PANE_CENTER, 0.25);
gmui_docking_add_pane("My Editor", gmui_docking_pane_dir.PANE_LEFT, 0.25);
gmui_docking_add_pane("My Editor", gmui_docking_pane_dir.PANE_BOTTOM, 0.25);

gmui_docking_add_tab("My Editor", gmui_docking_pane_dir.PANE_LEFT,   "Hierarchy");
gmui_docking_add_tab("My Editor", gmui_docking_pane_dir.PANE_LEFT,   "Materials");
gmui_docking_add_tab("My Editor", gmui_docking_pane_dir.PANE_BOTTOM, "Assets");
gmui_docking_add_tab("My Editor", gmui_docking_pane_dir.PANE_BOTTOM, "Output");
gmui_docking_add_tab("My Editor", gmui_docking_pane_dir.PANE_RIGHT, "Inspector");
gmui_docking_add_tab("My Editor", gmui_docking_pane_dir.PANE_CENTER, "Scene");
gmui_docking_add_tab("My Editor", gmui_docking_pane_dir.PANE_CENTER, "Settings");

color = gmui_make_color_rgba(100, 255, 100, 255);