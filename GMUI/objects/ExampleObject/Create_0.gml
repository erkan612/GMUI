/*Currently noticed problems
* With the Update of GM-2024.14.1.210 surfaces seem to being destroyed in the first frame so gmui_surface and gmui_add_surface can not be used
* gmui_demo is outdated and use of functions are not proper
* horizontal scrolling is problematic with collapsing headers(and their elements)
*/

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

nameData = "";

