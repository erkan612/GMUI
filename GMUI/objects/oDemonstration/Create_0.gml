/*Currently noticed problems
* horizontal scrolling is problematic with filling elements(collapsing headers, tree nodes, button width fills etc)
* some style variables are not in use
* the invisible label prefix('##') is not being applied to some elements
*/

gmui_init(fnCascadiaCode);

wins_frame = undefined;

checkA = false;
checkB = true;
checkC = false;
checkGroupSelected = -1;

radio_selected = 0;
radio_group_selected = 0;
radio_options = ["Option 1", "Option 2", "Option 3", "Option 4"];
horizontal_radio_selected = 0;
horizontal_options = ["H1", "H2", "H3"];
radio_box_selected1 = true;
radio_box_selected2 = false;
radio_box_selected3 = true;

text_input = "";
integer_input = 10;
float_input = 20.45;

mvx = 2;