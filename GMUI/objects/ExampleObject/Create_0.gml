/*Currently noticed problems
* With the Update of GM-2024.14.1.210 surfaces seem to being destroyed in the first frame so gmui_surface and gmui_add_surface can be a bit struggle
* horizontal scrolling is problematic with filling elements(collapsing headers, tree nodes, button width fills etc)
* some style variables are not in use
* GC cant catch up and builds up tiny bit of extra memory usage
*/

/*TODO
* textbox sleep timer isnt well structured, timer needs to be reset every time surface being used
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






