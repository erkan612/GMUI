function CreateSurfaceFromSprite(sprite, subimg = 0) {
    if (!sprite_exists(sprite)) {
        show_debug_message("Error: Invalid sprite index provided to CreateSurfaceFromSprite");
        return undefined;
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