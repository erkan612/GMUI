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

function gmui_apply_theme_earth_bronze() {
    var s = global.gmui.style;

    // -------------------------------------------------
    // PALETTE
    // -------------------------------------------------
    // #d1b187 (209,177,135)  light sand
    // #c77b58 (199,123,88)   warm clay
    // #ae5d40 (174,93,64)    rust
    // #79444a (121,68,74)    dark rose
    // #4b3d44 (75,61,68)     dark plum
    // #ba9158 (186,145,88)   golden ochre
    // #927441 (146,116,65)   brown ochre
    // #4d4539 (77,69,57)     dark olive
    // #77743b (119,116,59)   moss
    // #b3a555 (179,165,85)   muted gold
    // #d2c9a5 (210,201,165)  ivory
    // #8caba1 (140,171,161)  soft teal
    // #4b726e (75,114,110)   deep teal
    // #574852 (87,72,82)     mauve shadow
    // #847875 (132,120,117)  warm gray
    // #ab9b8e (171,155,142)  taupe

    // -------------------------------------------------
    // CORE
    // -------------------------------------------------
    s.background_color        = make_color_rgb(75,61,68);
    s.border_color            = make_color_rgb(121,68,74);
    s.text_color              = make_color_rgb(210,201,165);
    s.text_disabled_color     = make_color_rgb(132,120,117);

    // -------------------------------------------------
    // WINDOW / TITLE BAR
    // -------------------------------------------------
    s.title_bar_color         = make_color_rgb(87,72,82);
    s.title_bar_hover_color   = make_color_rgb(121,68,74);
    s.title_bar_active_color  = make_color_rgb(77,69,57);
    s.title_text_color        = s.text_color;

    // -------------------------------------------------
    // BUTTONS
    // -------------------------------------------------
    s.button_bg_color             = make_color_rgb(186,145,88);
    s.button_hover_bg_color       = make_color_rgb(209,177,135);
    s.button_active_bg_color      = make_color_rgb(146,116,65);
    s.button_border_color         = make_color_rgb(121,68,74);
    s.button_hover_border_color   = make_color_rgb(174,93,64);
    s.button_active_border_color  = make_color_rgb(121,68,74);
    s.button_text_color           = make_color_rgb(75,61,68);

    s.button_disabled_bg_color    = make_color_rgb(132,120,117);
    s.button_disabled_border_color= make_color_rgb(87,72,82);
    s.button_disabled_text_color  = make_color_rgb(210,201,165);

    // -------------------------------------------------
    // CHECKBOX
    // -------------------------------------------------
    s.checkbox_bg_color            = make_color_rgb(186,145,88);
    s.checkbox_border_color        = make_color_rgb(121,68,74);
    s.checkbox_hover_bg_color      = make_color_rgb(209,177,135);
    s.checkbox_hover_border_color  = make_color_rgb(174,93,64);
    s.checkbox_active_bg_color     = make_color_rgb(146,116,65);
    s.checkbox_active_border_color = make_color_rgb(121,68,74);
    s.checkbox_disabled_bg_color   = make_color_rgb(132,120,117);
    s.checkbox_disabled_border_color = make_color_rgb(87,72,82);
    s.checkbox_check_color         = make_color_rgb(210,201,165);
    s.checkbox_text_color          = s.text_color;
    s.checkbox_text_disabled_color = make_color_rgb(132,120,117);

    // -------------------------------------------------
    // SLIDER
    // -------------------------------------------------
    s.slider_track_bg_color        = make_color_rgb(77,69,57);
    s.slider_track_border_color    = make_color_rgb(121,68,74);
    s.slider_track_fill_color      = make_color_rgb(140,171,161);

    s.slider_handle_bg_color       = make_color_rgb(209,177,135);
    s.slider_handle_border_color   = make_color_rgb(121,68,74);
    s.slider_handle_hover_bg_color = make_color_rgb(210,201,165);
    s.slider_handle_hover_border_color = make_color_rgb(174,93,64);
    s.slider_handle_active_bg_color= make_color_rgb(186,145,88);
    s.slider_handle_active_border_color = make_color_rgb(121,68,74);
    s.slider_handle_disabled_bg_color   = make_color_rgb(132,120,117);
    s.slider_handle_disabled_border_color = make_color_rgb(87,72,82);

    s.slider_text_color            = s.text_color;
    s.slider_text_disabled_color   = make_color_rgb(132,120,117);

    // -------------------------------------------------
    // TEXTBOX
    // -------------------------------------------------
    s.textbox_bg_color             = make_color_rgb(87,72,82);
    s.textbox_border_color         = make_color_rgb(121,68,74);
    s.textbox_focused_border_color = make_color_rgb(140,171,161);
    s.textbox_text_color           = s.text_color;
    s.textbox_placeholder_color    = make_color_rgb(171,155,142);
    s.textbox_cursor_color         = s.text_color;
    s.textbox_selection_color      = make_color_rgb(75,114,110);

    // -------------------------------------------------
    // DRAG TEXTBOX
    // -------------------------------------------------
    s.drag_textbox_bg_color            = make_color_rgb(87,72,82);
    s.drag_textbox_border_color        = make_color_rgb(121,68,74);
    s.drag_textbox_focused_border_color= make_color_rgb(140,171,161);
    s.drag_textbox_text_color          = s.text_color;
    s.drag_textbox_placeholder_color   = make_color_rgb(171,155,142);
    s.drag_textbox_cursor_color        = s.text_color;
    s.drag_textbox_selection_color     = make_color_rgb(75,114,110);
    s.drag_textbox_drag_color          = make_color_rgb(186,145,88);

    // -------------------------------------------------
    // SELECTABLE
    // -------------------------------------------------
    s.selectable_bg_color           = make_color_rgb(87,72,82);
    s.selectable_hover_bg_color     = make_color_rgb(121,68,74);
    s.selectable_active_bg_color    = make_color_rgb(77,69,57);
    s.selectable_selected_bg_color  = make_color_rgb(140,171,161);
    s.selectable_selected_hover_bg_color = make_color_rgb(75,114,110);

    s.selectable_border_color       = make_color_rgb(121,68,74);
    s.selectable_hover_border_color = make_color_rgb(174,93,64);
    s.selectable_active_border_color= make_color_rgb(121,68,74);
    s.selectable_selected_border_color = make_color_rgb(75,114,110);

    s.selectable_text_color         = s.text_color;
    s.selectable_text_selected_color= make_color_rgb(75,61,68);
    s.selectable_text_disabled_color= make_color_rgb(132,120,117);

    // -------------------------------------------------
    // TREEVIEW
    // -------------------------------------------------
    s.treeview_bg_color             = make_color_rgb(87,72,82);
    s.treeview_hover_bg_color       = make_color_rgb(121,68,74);
    s.treeview_active_bg_color      = make_color_rgb(77,69,57);
    s.treeview_selected_bg_color    = make_color_rgb(140,171,161);
    s.treeview_selected_hover_bg_color = make_color_rgb(75,114,110);

    s.treeview_border_color         = make_color_rgb(121,68,74);
    s.treeview_text_color           = s.text_color;
    s.treeview_text_selected_color  = make_color_rgb(75,61,68);
    s.treeview_text_disabled_color  = make_color_rgb(132,120,117);

    s.treeview_arrow_color          = make_color_rgb(210,201,165);
    s.treeview_arrow_hover_color    = make_color_rgb(209,177,135);
    s.treeview_arrow_active_color   = make_color_rgb(186,145,88);

    // -------------------------------------------------
    // COLLAPSIBLE HEADER
    // -------------------------------------------------
    s.collapsible_header_bg_color        = make_color_rgb(87,72,82);
    s.collapsible_header_hover_bg_color  = make_color_rgb(121,68,74);
    s.collapsible_header_active_bg_color = make_color_rgb(77,69,57);
    s.collapsible_header_border_color    = make_color_rgb(121,68,74);
    s.collapsible_header_text_color      = s.text_color;

    s.collapsible_header_arrow_color        = make_color_rgb(210,201,165);
    s.collapsible_header_arrow_hover_color  = make_color_rgb(209,177,135);
    s.collapsible_header_arrow_active_color = make_color_rgb(186,145,88);

    // -------------------------------------------------
    // SCROLLBAR
    // -------------------------------------------------
    s.scrollbar_background_color  = make_color_rgb(77,69,57);
    s.scrollbar_anchor_color      = make_color_rgb(186,145,88);
    s.scrollbar_anchor_hover_color= make_color_rgb(209,177,135);
    s.scrollbar_anchor_active_color=make_color_rgb(146,116,65);
	
	// -------------------------------------------------
    // COMBO / DROPDOWN
    // -------------------------------------------------
    s.combo_bg_color                 = make_color_rgb(87,72,82);
    s.combo_hover_bg_color           = make_color_rgb(121,68,74);
    s.combo_active_bg_color          = make_color_rgb(77,69,57);
    s.combo_disabled_bg_color        = make_color_rgb(132,120,117);

    s.combo_border_color             = make_color_rgb(121,68,74);
    s.combo_hover_border_color       = make_color_rgb(174,93,64);
    s.combo_active_border_color      = make_color_rgb(121,68,74);
    s.combo_disabled_border_color    = make_color_rgb(87,72,82);

    s.combo_text_color               = s.text_color;
    s.combo_disabled_text_color      = make_color_rgb(132,120,117);

    s.combo_arrow_color              = make_color_rgb(210,201,165);
    s.combo_arrow_hover_color        = make_color_rgb(209,177,135);
    s.combo_arrow_active_color       = make_color_rgb(186,145,88);

    // Dropdown list
    s.combo_popup_bg_color           = make_color_rgb(87,72,82);
    s.combo_popup_border_color       = make_color_rgb(121,68,74);

    s.combo_item_bg_color            = make_color_rgb(87,72,82);
    s.combo_item_hover_bg_color      = make_color_rgb(121,68,74);
    s.combo_item_selected_bg_color   = make_color_rgb(140,171,161);
    s.combo_item_selected_hover_bg_color = make_color_rgb(75,114,110);

    s.combo_item_text_color          = s.text_color;
    s.combo_item_selected_text_color = make_color_rgb(75,61,68);
    s.combo_item_disabled_text_color = make_color_rgb(132,120,117);

    // -------------------------------------------------
    // TABS
    // -------------------------------------------------
    s.tab_bg_color              = make_color_rgb(87,72,82);
    s.tab_hover_bg_color        = make_color_rgb(121,68,74);
    s.tab_active_bg_color       = make_color_rgb(146,116,65);
    s.tab_selected_bg_color     = make_color_rgb(140,171,161);
    s.tab_border_color          = make_color_rgb(121,68,74);

    s.tab_text_color            = s.text_color;
    s.tab_selected_text_color   = make_color_rgb(75,61,68);
    s.tab_disabled_text_color   = make_color_rgb(132,120,117);

    // -------------------------------------------------
    // TOOLTIP
    // -------------------------------------------------
    s.tooltip_background_color      = make_color_rgb(77,69,57);
    s.tooltip_hover_background_color= make_color_rgb(121,68,74);
    s.tooltip_border_color          = make_color_rgb(121,68,74);
    s.tooltip_text_color            = s.text_color;
	
    s.tooltip_message_background_color= make_color_rgb(77,69,57);
    s.tooltip_message_border_color    = make_color_rgb(121,68,74);
    s.tooltip_message_text_color      = s.text_color;

    // -------------------------------------------------
    // TABLE
    // -------------------------------------------------
    s.table_bg_color            = make_color_rgb(87,72,82);
    s.table_border_color        = make_color_rgb(121,68,74);

    s.table_header_bg_color     = make_color_rgb(121,68,74);
    s.table_header_hover_bg_color = make_color_rgb(174,93,64);
    s.table_header_border_color = make_color_rgb(121,68,74);
    s.table_header_text_color   = s.text_color;

    s.table_row_bg_color        = make_color_rgb(87,72,82);
    s.table_row_hover_bg_color  = make_color_rgb(121,68,74);
    s.table_row_selected_bg_color = make_color_rgb(140,171,161);
    s.table_row_border_color    = make_color_rgb(121,68,74);
    s.table_row_text_color      = s.text_color;
    s.table_row_selected_text_color = make_color_rgb(75,61,68);

    // -------------------------------------------------
    // PLOTS (fully themed)
    // -------------------------------------------------
    s.plot_bg_color             = make_color_rgb(75,61,68);
    s.plot_border_color         = make_color_rgb(121,68,74);
    s.plot_grid_color           = make_color_rgb(121,68,74);
    s.plot_text_color           = make_color_rgb(171,155,142);
    s.plot_axis_label_color     = s.text_color;

    s.plot_line_color           = make_color_rgb(140,171,161);
    s.plot_point_color          = make_color_rgb(186,145,88);
    s.plot_fill_color           = gmui_make_color_rgba(140,171,161, 40);

    s.plot_bar_color            = make_color_rgb(186,145,88);
    s.plot_bar_border_color     = make_color_rgb(121,68,74);

    s.plot_histogram_color      = make_color_rgb(179,165,85);
    s.plot_scatter_color        = make_color_rgb(199,123,88);
    s.plot_trendline_color      = make_color_rgb(209,177,135);

    // -------------------------------------------------
    // CONTEXT MENU
    // -------------------------------------------------
    s.context_menu_item_hover_bg_color = make_color_rgb(121,68,74);
    s.context_menu_item_text_color     = s.text_color;
    s.context_menu_item_short_cut_text_color = make_color_rgb(171,155,142);
}
