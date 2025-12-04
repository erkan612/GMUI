/*Currently noticed problems
* With the Update of GM-2024.14.1.210 surfaces seem to being destroyed in the first frame so gmui_surface and gmui_add_surface can be a bit struggle
* horizontal scrolling is problematic with filling elements(collapsing headers, tree nodes, button width fills etc)
* some style variables are not in use
* GC cant catch up and builds up tiny bit of extra memory usage in time
*/

/*
* creating new arrays as 'my_array = [ ... ]'
* creating new arrays as 'ds_map_values_to_array' or others
* cleaning arrays as 'my_array = [ ]'
* everyframe, causes GC to fall behind and increases the memory usage
* to fix this, create static arrays in global.gmui.cache and instead if settings them to '[ ]' to clean up, use 'array_delete' or 'gmui_array_clean' to clean the entirety of an array
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




