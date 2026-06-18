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
gmui_animation_init();

toggle = true;

math_set_epsilon(0.00000001);

gmui_docking_create_dockspace("My Editor");
gmui_docking_add_tab("My Editor", gmui_docking_pane_dir.PANE_RIGHT, "Inspector",  0.25);
gmui_docking_add_tab("My Editor", gmui_docking_pane_dir.PANE_TOP, "Toolbar",  0.25);
gmui_docking_add_tab("My Editor", gmui_docking_pane_dir.PANE_CENTER, "Settings");
gmui_docking_add_tab("My Editor", gmui_docking_pane_dir.PANE_LEFT,   "Hierarchy", 0.2);
gmui_docking_add_tab("My Editor", gmui_docking_pane_dir.PANE_LEFT,   "Materials", 0.2);
gmui_docking_add_tab("My Editor", gmui_docking_pane_dir.PANE_CENTER, "Scene");
gmui_docking_add_tab("My Editor", gmui_docking_pane_dir.PANE_BOTTOM, "Assets",  0.25);
gmui_docking_add_tab("My Editor", gmui_docking_pane_dir.PANE_BOTTOM, "Output",  0.25);