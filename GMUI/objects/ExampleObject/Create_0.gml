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
list_index = 0;

sprSurf = CreateSurfaceFromSprite(Sprite1);

function CreateSurfaceFromSprite(sprite, subimg = 0) {
    if (!sprite_exists(sprite)) {
        show_debug_message("Error: Invalid sprite index provided to sprite_get_surface");
        return -1;
    }
    
    var spr_width = sprite_get_width(sprite);
    var spr_height = sprite_get_height(sprite);
    
    var surf = surface_create(spr_width, spr_height);
    
    surface_set_target(surf);
    
    draw_clear_alpha(c_black, 0);
    
    draw_sprite(sprite, subimg, 0, 0);
    
    surface_reset_target();
    
    return surf;
};