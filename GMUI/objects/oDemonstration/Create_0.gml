/*Currently noticed problems
* horizontal scrolling is problematic with filling elements(collapsing headers, tree nodes, button width fills etc)
* some style variables are not in use
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

winsFrame = undefined;


