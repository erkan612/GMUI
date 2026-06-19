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
color = gmui_make_color_rgba(100, 255, 100, 255);

math_set_epsilon(0.00000001);

var dockspace = gmui_docking_create_dockspace("editor");
var root   = gmui_dock_split(dockspace, undefined, gmui_docking_split_axis.HORIZONTAL, [0.2, 0.6, 0.2]);
var left   = gmui_dock_leaf(dockspace, root, 0);
var mid    = gmui_dock_split(dockspace, root, gmui_docking_split_axis.VERTICAL, [0.7, 0.3], 1);
var scene  = gmui_dock_leaf(dockspace, mid, 0);
var bottom = gmui_dock_leaf(dockspace, mid, 1);
var right  = gmui_dock_leaf(dockspace, root, 2);

gmui_dock_add_tab(dockspace, left,   "Hierarchy");
gmui_dock_add_tab(dockspace, left,   "Materials");
gmui_dock_add_tab(dockspace, scene,  "Scene");
gmui_dock_add_tab(dockspace, scene,  "Settings");
gmui_dock_add_tab(dockspace, bottom, "Assets");
gmui_dock_add_tab(dockspace, bottom, "Output");
gmui_dock_add_tab(dockspace, right,  "Inspector");