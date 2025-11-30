/*Currently noticed problems
* With the Update of GM-2024.14.1.210 surfaces seem to being destroyed in the first frame so gmui_surface and gmui_add_surface can be a bit struggle
* horizontal scrolling is problematic with collapsing headers(and their elements)
* some style variables are not being applied
*/

/*TODO
* optimize
* add cache system to keep some data instead of recreating and recalculating every frame
* add sleep mode for surfaces using cache system
* fix gmui_add_surface with cahce system
* add context menus
* add pre-made window flags eg gmui_pre_window_flags.WINS_WINDOW
---------------------------------
gmui_begin_context_menu()
gmui_menu_item("Cut", "Ctrl+X")
gmui_menu_separator()
gmui_end_context_menu()
---------------------------------
* some elements with ready label account texts start with prefix '##' must be fixed
*/

/*Features added before release
* parent node of wins is now resizable with gmui_wins_resize_parent_node()
* custom colors of wins in global.gmui.style
* fixed visuals of table background
* fixed the bug with window flag always auto resize not scaling up
* bug fixes on gmui_textbox
* bug fixes on gmui_combo
* added pre-made window flags eg gmui_pre_window_flags.WINS_WINDOW
*/

gmui_init();

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

nameData = "";

isFirstFrame = true;

winsFrame = undefined;






