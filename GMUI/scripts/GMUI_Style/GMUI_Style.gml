

function gmui_style_init() {
	gmui_style_apply_ruler();
};

function gmui_style_apply_ruler
(
	_ruler = {
		color_bg_dominant: make_color_rgb(32, 32, 32),
		color_bg_secondary: make_color_rgb(45, 45, 45),
		color_bg_tertiary: make_color_rgb(55, 55, 55),
		
		color_front_base: make_color_rgb(220, 220, 220),
		color_front_hover: make_color_rgb(255, 255, 255),
		color_front_active: make_color_rgb(180, 180, 180),
		
		color_widget_base: make_color_rgb(70, 70, 70),
		color_widget_hover: make_color_rgb(90, 90, 90),
		color_widget_active: make_color_rgb(50, 50, 50),
		
		color_accent: make_color_rgb(100, 100, 255),
		color_accent_hover: make_color_rgb(128, 128, 255),
		color_accent_pressed: make_color_rgb(16, 16, 128),
		color_accent_alt: make_color_rgb(100, 150, 255),
		color_accent_dark: make_color_rgb(65, 105, 225),
		color_accent_light: make_color_rgb(75, 115, 235),
		
		color_text_primary: make_color_rgb(220, 220, 220),
		color_text_secondary: make_color_rgb(180, 180, 180),
		color_text_disabled: make_color_rgb(128, 128, 128),
		color_text_bright: make_color_rgb(255, 255, 255),
		
		color_border: make_color_rgb(60, 60, 60),
		color_border_light: make_color_rgb(100, 100, 100),
		color_border_dark: make_color_rgb(80, 80, 80),
		
		toast_success: make_color_rgb(40, 120, 40),
		toast_error: make_color_rgb(180, 50, 50),
		toast_info: make_color_rgb(50, 100, 180),
		toast_warning: make_color_rgb(180, 150, 30),
		
		plot_bar_max: make_color_rgb(255, 100, 100),
		plot_box_median: make_color_rgb(255, 100, 100),
		plot_outlier: make_color_rgb(255, 100, 100),
		plot_waterfall_increase: make_color_rgb(100, 200, 100),
		plot_waterfall_decrease: make_color_rgb(255, 100, 100),
		plot_gauge_fill: make_color_rgb(100, 200, 100),
		plot_gauge_needle: make_color_rgb(255, 100, 100),
		
		plot_palette: [
		    make_color_rgb(255, 100, 100),
		    make_color_rgb(100, 200, 255),
		    make_color_rgb(100, 255, 100),
		    make_color_rgb(255, 200, 50),
		    make_color_rgb(200, 100, 255),
		    make_color_rgb(50, 255, 255),
		    make_color_rgb(255, 150, 50),
		    make_color_rgb(150, 150, 255),
		],
		
		plot_stacked_colors: [
		    make_color_rgb(100, 150, 255),
		    make_color_rgb(255, 150, 100),
		    make_color_rgb(100, 255, 150),
		    make_color_rgb(255, 200, 50),
		    make_color_rgb(200, 100, 255),
		],
		
		plot_heatmap_gradient: [
		    make_color_rgb(50, 50, 150),
		    make_color_rgb(50, 180, 220),
		    make_color_rgb(50, 220, 100),
		    make_color_rgb(220, 220, 50),
		    make_color_rgb(220, 120, 50),
		    make_color_rgb(220, 50, 50),
		],
		
		plot_heatmap_cold: make_color_rgb(50, 50, 255),
		plot_heatmap_hot: make_color_rgb(255, 50, 50),
		
		spacing_tiny: 2,
		spacing_small: 4,
		spacing_medium: 8,
		spacing_large: 12,
		spacing_xlarge: 16,
		
		rounding_container: 0,
		rounding_widget: 4,
		rounding_small: 2,
		rounding_medium: 3,
		rounding_large: 4,
		rounding_pill: 12,
		
		scroll_speed: 30,
		drag_sensitivity: 0.1,
		knob_sensitivity: 0.004,
		tooltip_delay: 500,
		toast_duration: 3000,
		toast_position: "top-center",
	}
) 
{
    var _bg_dom = _ruler.color_bg_dominant;
    var _bg_sec = _ruler.color_bg_secondary;
    var _bg_ter = _ruler.color_bg_tertiary;
	
	var _fr_base = _ruler.color_front_base;
	var _fr_hover = _ruler.color_front_hover;
	var _fr_active = _ruler.color_front_active;
    
    var _widget_base = _ruler.color_widget_base;
    var _widget_hover = _ruler.color_widget_hover;
    var _widget_active = _ruler.color_widget_active;
    
    var _accent = _ruler.color_accent;
    var _accent_hover = _ruler.color_accent_hover;
    var _accent_pressed = _ruler.color_accent_pressed;
    var _accent_alt = _ruler.color_accent_alt;
    var _accent_dark = _ruler.color_accent_dark;
    var _accent_light = _ruler.color_accent_light;
    
    var _text_primary = _ruler.color_text_primary;
    var _text_secondary = _ruler.color_text_secondary;
    var _text_disabled = _ruler.color_text_disabled;
    var _text_bright = _ruler.color_text_bright;
    
    var _border = _ruler.color_border;
    var _border_light = _ruler.color_border_light;
    var _border_dark = _ruler.color_border_dark;
    
    var _cursor = _ruler.color_front_base;
    var _selection = _ruler.color_accent;
    var _arrow = _ruler.color_front_base;
    var _arrow_hover = _ruler.color_front_hover;
    var _arrow_active = _ruler.color_front_active;
    var _selected_text_bright = _ruler.color_text_bright;
    
    var _toast_success = _ruler.toast_success;
    var _toast_error = _ruler.toast_error;
    var _toast_info = _ruler.toast_info;
    var _toast_warning = _ruler.toast_warning;
    
    var _plot_bar_max = _ruler.plot_bar_max;
    var _plot_box_median = _ruler.plot_box_median;
    var _plot_outlier = _ruler.plot_outlier;
    var _plot_waterfall_increase = _ruler.plot_waterfall_increase;
    var _plot_waterfall_decrease = _ruler.plot_waterfall_decrease;
    var _plot_gauge_fill = _ruler.plot_gauge_fill;
    var _plot_gauge_needle = _ruler.plot_gauge_needle;
    
    var _plot_palette = _ruler.plot_palette;
    var _plot_stacked = _ruler.plot_stacked_colors;
    var _heatmap_gradient = _ruler.plot_heatmap_gradient;
    var _heatmap_cold = _ruler.plot_heatmap_cold;
    var _heatmap_hot = _ruler.plot_heatmap_hot;
    
    var _sp_tiny = _ruler.spacing_tiny;
    var _sp_small = _ruler.spacing_small;
    var _sp_medium = _ruler.spacing_medium;
    var _sp_large = _ruler.spacing_large;
    var _sp_xlarge = _ruler.spacing_xlarge;
    
    var _round_container = _ruler.rounding_container;
    var _round_widget = _ruler.rounding_widget;
    var _round_small = _ruler.rounding_small;
    var _round_med = _ruler.rounding_medium;
    var _round_large = _ruler.rounding_large;
    var _round_pill = _ruler.rounding_pill;
	
    global.gmui.style = {
		color_bg_dominant:		_ruler.color_bg_dominant,
		color_bg_secondary:		_ruler.color_bg_secondary,
		color_bg_tertiary:		_ruler.color_bg_tertiary,
		
		color_front_base:		_ruler.color_front_base,
		color_front_hover:		_ruler.color_front_hover,
		color_front_active:		_ruler.color_front_active,
		
		color_widget_base:		_ruler.color_widget_base,
		color_widget_hover:		_ruler.color_widget_hover,
		color_widget_active:	_ruler.color_widget_active,
		
		color_accent:			_ruler.color_accent,
		color_accent_hover:		_ruler.color_accent_hover,
		color_accent_pressed:	_ruler.color_accent_pressed,
		color_accent_alt:		_ruler.color_accent_alt,
		color_accent_dark:		_ruler.color_accent_dark,
		color_accent_light:		_ruler.color_accent_light,
		
		color_text_primary:		_ruler.color_text_primary,
		color_text_secondary:	_ruler.color_text_secondary,
		color_text_disabled:	_ruler.color_text_disabled,
		color_text_bright:		_ruler.color_text_bright,
		
		color_border:			_ruler.color_border,
		color_border_light:		_ruler.color_border_light,
		color_border_dark:		_ruler.color_border_dark,
		
        // fonts (-5 = inherit directly from global.gmui.style.font, undefined = inherit from global.gmui.style.font_... if set, if not then inherit from global.gmui.style.font)
        font: -1,
        font_text: undefined,
        font_button: undefined,
        font_checkbox: undefined,
        font_textbox: undefined,
        font_collapsing_header: undefined,
        font_tab_item: undefined,
        font_selectable: undefined,
        font_separator: undefined,
        font_label: undefined,
        font_progress_bar: undefined,
        font_progress_circular: undefined,
        font_tooltip: undefined,
        font_image_button: undefined,
        font_plot: undefined,
        font_knob: undefined,
        font_multiselect: undefined,
        font_kv_list: undefined,
        font_window_title: undefined,
        
        // container
        container_background_color: _bg_dom,
        container_outline_color: _border,
        container_rounding: _round_container,
        container_padding_v: _sp_medium,
        container_padding_h: _sp_medium,
        element_spacing_h: _sp_medium,
        element_spacing_v: _sp_small,
        
        // general text
        text_color: _text_primary,
        text_alpha: 1,
        text_disabled_color: _text_disabled,
        
        // clickable text
        text_clickable_color_idle: _accent,
        text_clickable_color_active: _accent_pressed,
        text_clickable_color_hover: _accent_hover,
        
        // bullet text
        text_bullet_size: 6,
        text_bullet_spacing: _sp_small,
        
        // button
        button_color_idle: _widget_base,
        button_color_hovered: _widget_hover,
        button_color_active: _widget_active,
        button_text_color: _text_primary,
        button_text_alpha: 1,
        button_border_color: _border_light,
        button_padding_h: _sp_medium,
        button_padding_v: _sp_small,
        button_rounding: _round_widget,
        button_border_size: 1,
        button_min_width: 80,
        button_min_height: 24,
        
        // checkbox
        checkbox_color_idle: _widget_base,
        checkbox_color_hovered: _widget_hover,
        checkbox_color_active: _widget_active,
        checkbox_border_color: _border_light,
        checkbox_checkmark_color: _fr_base,
        checkbox_text_color: _text_primary,
        checkbox_text_alpha: 1,
        checkbox_padding: _sp_small,
        checkbox_size: 16,
        checkbox_rounding: _round_small,
        checkbox_border_size: 1,
        
        // scrollbar
        scrollbar_track_color: _bg_sec,
        scrollbar_thumb_color: _widget_base,
        scrollbar_thumb_hovered_color: _widget_hover,
        scrollbar_thumb_active_color: _accent_alt,
        scrollbar_width: 8,
        scrollbar_padding: -8,
        scrollbar_min_thumb_size: 30,
        scrollbar_rounding: _round_large,
        scroll_speed: _ruler.scroll_speed,
        
        // slider
        slider_track_height: 6,
        slider_track_color: _bg_ter,
        slider_track_fill_color: _accent,
        slider_track_rounding: _round_med,
        
        slider_handle_width: 12,
        slider_handle_height: 20,
        slider_handle_color: _ruler.color_front_base,
        slider_handle_hovered_color: _ruler.color_front_hover,
        slider_handle_active_color: _ruler.color_front_active,
        slider_handle_border_color: _border_light,
        slider_handle_rounding: _round_med,
        
        // textbox
        textbox_color: _bg_ter,
        textbox_border_color: _border_dark,
        textbox_focused_border_color: _accent,
        textbox_text_color: _text_primary,
        textbox_placeholder_color: _text_disabled,
        textbox_cursor_color: _text_primary,
        textbox_selection_color: _ruler.color_accent_pressed,
        textbox_padding_h: _sp_small,
        textbox_padding_v: _sp_small,
        textbox_rounding: _round_widget,
        textbox_border_size: 1,
        textbox_cursor_width: 1,
        textbox_height: 24,
        
        // drag textbox
        drag_textbox_color: _bg_ter,
        drag_textbox_border_color: _border_dark,
        drag_textbox_focused_border_color: _accent,
        drag_textbox_text_color: _text_primary,
        drag_textbox_drag_color: _accent,
        drag_textbox_drag_hotzone: 8,
        drag_textbox_sensitivity: _ruler.drag_sensitivity,
        
        // collapsing header
        collapsing_header_height: 24,
        collapsing_header_color: _border,
        collapsing_header_hovered_color: _widget_hover,
        collapsing_header_active_color: _widget_active,
        collapsing_header_border_color: _border_light,
        collapsing_header_text_color: _text_primary,
        collapsing_header_arrow_color: _arrow,
        collapsing_header_arrow_size: 8,
        collapsing_header_padding: _sp_medium,
        collapsing_header_rounding: _round_widget,
        collapsing_header_indent: _sp_large,
        
        // separator
        separator_color: _border,
        separator_thickness: 1,
        separator_text_color: _text_disabled,
        separator_gap: _sp_medium,
        
        // selectable
        selectable_min_height: 24,
        selectable_min_width: 192,
        selectable_color: _widget_active,
        selectable_hovered_color: _widget_base,
        selectable_active_color: _widget_active,
        selectable_selected_color: _accent_dark,
        selectable_selected_hovered_color: _accent_light,
        selectable_text_color: _text_primary,
        selectable_text_selected_color: _selected_text_bright,
        selectable_rounding: _round_widget,
        selectable_padding_h: _sp_medium,
        selectable_padding_v: _sp_small,
        
        // tabs
        tab_bar_height: 24,
        tab_item_color: _widget_active,
        tab_item_hovered_color: _widget_base,
        tab_item_active_color: _widget_active,
        tab_item_selected_color: _accent_alt,
        tab_item_text_color: _text_primary,
        tab_item_selected_text_color: _selected_text_bright,
        tab_item_padding_h: _sp_large,
        tab_item_padding_v: _sp_small,
        tab_item_rounding: _round_widget,
        tab_item_spacing: _sp_tiny,
        tab_item_min_width: 80,
		tab_item_rounding: _round_large,
        
        // window
        window_title_height: 24,
        window_title_color_idle: _widget_active,
        window_title_hover_color: _border,
        window_title_active_color: _widget_active,
        window_title_text_color: _text_primary,
        window_close_button_size: 16,
        window_close_button_color_idle: make_color_rgb(150, 150, 150),
        window_close_button_hover_color: make_color_rgb(220, 100, 100),
        window_close_button_active_color: make_color_rgb(180, 80, 80),
        window_collapse_button_size: 6,
        window_collapse_button_color_idle: _arrow,
        window_collapse_button_hover_color: _arrow_hover,
        window_collapse_button_active_color: _arrow_active,
        
        // window menu bar
		window_menu_height: 24,
		window_menu_bg_color: _ruler.color_bg_secondary,
		window_menu_button_hover_color: _ruler.color_widget_hover,
		window_menu_button_active_color: _ruler.color_widget_active,
		window_menu_text_color: _ruler.color_text_primary,
		window_menu_separator_color: _ruler.color_border,
		window_menu_button_padding_h: 10,
		window_menu_button_padding_v: 4,
		window_menu_button_rounding: _ruler.rounding_medium,
		window_menu_text_color_hover: _ruler.color_text_bright,
		window_menu_text_color_active: _ruler.color_text_bright,
		
		// columns
		columns_separator_width:        1,
		columns_separator_width_hover:  1,
		columns_separator_width_active: 1,
		columns_separator_color:        _ruler.color_border,
		columns_separator_color_hover:  _ruler.color_text_disabled,
		columns_separator_color_active: _ruler.color_accent,
		columns_separator_grab_pad:     4,
		columns_min_ratio:              0.05,
        
        // context menu
        context_menu_item_height: 22,
        context_menu_item_color: _bg_sec,
        context_menu_item_color_hover: _widget_base,
        context_menu_item_color_active: _widget_active,
        context_menu_text_color: _text_primary,
        context_menu_shortcut_color: _text_secondary,
        context_menu_arrow_color: _arrow,
        context_menu_padding_h: _sp_medium,
		
		// docking
		dock_separator_thickness:   5,
		dock_separator_grab_pad:    4,
		dock_separator_color:       _ruler.color_border,
		dock_separator_color_hover: _ruler.color_text_disabled,
		dock_separator_color_active: _ruler.color_accent,
		dock_min_ratio:             0.05,

		dock_tab_bar_height:        26,
		dock_tab_bar_bg:            _ruler.color_bg_secondary,
		dock_tab_color:             _ruler.color_bg_secondary,
		dock_tab_color_hover:       _ruler.color_widget_hover,
		dock_tab_color_active:      _ruler.color_widget_active,
		dock_tab_text_color:        _ruler.color_text_disabled,
		dock_tab_text_color_active: _ruler.color_text_primary,
		dock_tab_rounding:          3,
		dock_tab_padding_h:         10,

		dock_zone_size:             48,
		dock_zone_color:            _ruler.color_accent,
		dock_zone_color_hover:      _ruler.color_accent,
		dock_zone_alpha:            0.25,
		dock_zone_alpha_hover:      0.65,
		dock_zone_rounding:         4,
		dock_zone_icon_color:       make_color_rgb(255, 255, 255),
        
        // tooltip
        tooltip_background_color: _bg_sec,
        tooltip_border_color: _border_light,
        tooltip_text_color: _text_primary,
        tooltip_text_alpha: 1,
        tooltip_padding_h: _sp_medium,
        tooltip_padding_v: _sp_small,
        tooltip_mouse_padding_h: _sp_large,
        tooltip_mouse_padding_v: _sp_large,
        tooltip_line_padding_v: _sp_small,
        tooltip_rounding: _round_widget,
        tooltip_delay: _ruler.tooltip_delay,
        tooltip_min_width: 100,
        
        // progress bar
        progress_bar_height: 20,
        progress_bar_background_color: _bg_ter,
        progress_bar_fill_color: _accent_alt,
        progress_bar_border_color: _border_dark,
        progress_bar_text_color: _text_primary,
        progress_bar_rounding: _round_widget,
        progress_bar_border_size: 1,
        
        // circular progress
        progress_circular_size: 40,
        progress_circular_thickness: 4,
        progress_circular_bg_color: _bg_ter,
        progress_circular_fill_color: _accent_alt,
        progress_circular_text_color: _text_primary,
        
        // combo box
        combo_height: 24,
        combo_color: _bg_ter,
        combo_border_color: _border_dark,
        combo_hover_color: _border,
        combo_text_color: _text_primary,
        combo_placeholder_color: _text_disabled,
        combo_arrow_color: _arrow,
        combo_arrow_size: 8,
        combo_padding_h: _sp_medium,
        combo_rounding: _round_widget,
        combo_border_size: 1,
        combo_dropdown_max_height: 200,
        combo_item_height: 24,
        combo_item_color: _bg_sec,
        combo_item_hover_color: _widget_base,
        combo_item_text_color: _text_primary,
        
        // color picker
        color_picker_width: 200,
        color_picker_height: 150,
        color_picker_hue_height: 16,
        color_picker_alpha_height: 16,
        color_picker_preview_size: 30,
        color_picker_padding: _sp_medium,
        color_picker_gap: _sp_small,
        color_picker_border_color: _border_dark,
        color_picker_border_size: 1,
        color_picker_rounding: _round_widget,
        color_button_size: 20,
        color_button_border_color: _border_light,
        color_button_hover_border_color: _text_secondary,
        
        // image button
        image_button_padding_h: _sp_small,
        image_button_padding_v: _sp_small,
        image_button_bg_color: _widget_base,
        image_button_bg_hover_color: _widget_hover,
        image_button_bg_active_color: _widget_active,
        image_button_border_color: _border_light,
        image_button_rounding: _round_widget,
        image_button_border_size: 1,
        
        // toggle switch
        toggle_width: 44,
        toggle_height: 24,
        toggle_padding: 3,
        toggle_color_idle: _widget_base,
        toggle_color_active: _accent_alt,
        toggle_color_hover: _widget_hover,
        toggle_knob_color: _fr_base,
        toggle_knob_size: 18,
        toggle_rounding: _round_pill,
        
        // knob/dial
        knob_size: 64,
        knob_outer_ring: 6,
        knob_track_thickness: 5,
        knob_start_angle: 140,
        knob_sweep_angle: 260,
        knob_bg_color: _bg_ter,
        knob_outer_ring_color: _bg_sec,
        knob_track_color: _bg_ter,
        knob_fill_color: _accent_alt,
        knob_indicator_color: _text_bright,
        knob_indicator_thickness: 3,
        knob_indicator_length: 0.65,
        knob_center_color: _bg_dom,
        knob_center_size: 0.55,
        knob_text_color: _text_primary,
        knob_drag_sensitivity: _ruler.knob_sensitivity,
        
        // color palette
        color_palette_swatch_size: 24,
        color_palette_swatch_spacing: _sp_tiny,
        color_palette_swatch_bg_color: _bg_ter,
        color_palette_swatch_border_color: _border_dark,
        color_palette_swatch_hover_border: _text_bright,
        color_palette_swatch_selected_border: _text_bright,
        color_palette_swatch_selected_thickness: 3,
        color_palette_cols: 8,
        
        // multi-select list
        multiselect_item_height: 24,
        multiselect_item_color: _bg_sec,
        multiselect_item_hover_color: _bg_ter,
        multiselect_item_selected_color: _accent_dark,
        multiselect_checkbox_size: 14,
        multiselect_checkbox_spacing: _sp_small,
        multiselect_text_color: _text_primary,
        multiselect_text_selected_color: _text_bright,
        multiselect_alternate_color: _bg_ter,
        
        // toast/notification
        toast_padding_h: _sp_large,
        toast_padding_v: _sp_medium,
        toast_rounding: _round_widget,
        toast_success_color: _toast_success,
        toast_error_color: _toast_error,
        toast_info_color: _toast_info,
        toast_warning_color: _toast_warning,
        toast_text_color: _text_bright,
        toast_duration: _ruler.toast_duration,
        toast_max_width: 400,
        toast_margin: _sp_large,
        toast_gap: _sp_medium,
        toast_position: _ruler.toast_position,
        
        // key-value list
        kv_row_height: 22,
        kv_key_color: _text_secondary,
        kv_value_color: _text_primary,
        kv_separator_color: _border,
        kv_key_width_ratio: 0.4,
        
        // date picker
        date_picker_header_height: 28,
        date_picker_cell_size: 28,
        date_picker_header_color: _bg_sec,
        date_picker_header_text_color: _text_primary,
        date_picker_cell_color: _bg_sec,
        date_picker_cell_hover_color: _widget_base,
        date_picker_cell_selected_color: _accent_dark,
        date_picker_cell_today_color: _accent_alt,
        date_picker_cell_other_month: _text_disabled,
        date_picker_cell_text_color: _text_primary,
        date_picker_cell_selected_text: _text_bright,
        date_picker_weekday_color: _text_secondary,
        date_picker_arrow_color: _arrow,
        date_picker_arrow_hover_color: _arrow_hover,
        
        // radio button
        radio_size: 16,
        radio_color_idle: _widget_base,
        radio_color_hovered: _widget_hover,
        radio_color_active: _widget_active,
        radio_border_color: _border_light,
        radio_dot_color: _fr_base,
        radio_text_color: _text_primary,
        radio_text_alpha: 1,
        radio_padding: _sp_small,
        
        // plot generic
        plot_bg_color: _bg_ter,
        plot_border_color: _border_dark,
        plot_border_size: 1,
        plot_grid_color: _bg_sec,
        plot_grid_thickness: 1,
        plot_grid_steps: 5,
        plot_line_color: _accent_alt,
        plot_line_thickness: 2,
        plot_point_color: _accent_alt,
        plot_fill_color: _accent_alt,
        plot_fill_alpha: 0.15,
        plot_fill_enabled: true,
        plot_bar_color: _accent_alt,
        plot_bar_border_color: _border_dark,
        plot_bar_border_size: 1,
        plot_bar_rounding: _round_small,
        plot_bar_spacing_ratio: 0.2,
        plot_bar_gradient: true,
        plot_bar_min_color: _accent_alt,
        plot_bar_max_color: _plot_bar_max,
        plot_text_color: _text_secondary,
        plot_bar_text_color: _text_bright,
        
        // plot pie
        plot_pie_start_angle: -90,
        plot_pie_donut_ratio: 0,
        plot_pie_explode_distance: 5,
        plot_pie_show_labels: true,
        plot_pie_show_percentages: true,
        plot_pie_min_percentage: 5,
        plot_pie_label_color: _text_bright,
        plot_pie_label_bg_color: _bg_dom,
        plot_pie_label_bg_alpha: 0.7,
        plot_pie_color_palette: _plot_palette,
        
        // plot area
        plot_area_color: _accent_alt,
        plot_area_alpha: 0.3,
        plot_area_line_color: _accent_alt,
        plot_area_line_thickness: 2,
        
        // plot stacked
        plot_stacked_bar_colors: _plot_stacked,
        
        // plot group
        plot_grouped_bar_spacing: 0.15,
        plot_grouped_bar_gap: 2,
        
        // plot heatmap
        plot_heatmap_cell_size: 20,
        plot_heatmap_cell_spacing: 1,
        plot_heatmap_cold_color: _heatmap_cold,
        plot_heatmap_hot_color: _heatmap_hot,
        plot_heatmap_show_values: false,
        plot_heatmap_text_color: _text_bright,
        plot_heatmap_gradient: _heatmap_gradient,
        plot_heatmap_legend_width: 16,
        plot_heatmap_legend_gap: _sp_medium,
        plot_heatmap_legend_text_color: _text_secondary,
        plot_heatmap_legend_tick_count: 5,
        
        // plot radar/spider
        plot_radar_axis_color: _border_dark,
        plot_radar_grid_color: _bg_sec,
        plot_radar_fill_alpha: 0.2,
        plot_radar_grid_levels: 4,
        plot_radar_label_offset: 15,
        plot_radar_point_size: 4,
        plot_radar_line_thickness: 2,
        
        // plot box
        plot_box_width: 30,
        plot_box_color: _accent_alt,
        plot_box_median_color: _plot_box_median,
        plot_box_whisker_color: _text_secondary,
        plot_box_outlier_color: _plot_outlier,
        plot_box_outlier_size: 3,
        plot_box_line_thickness: 1,
        plot_box_show_outliers: true,
        
        // plot funnel
        plot_funnel_color: _accent_alt,
        plot_funnel_border_color: _border_dark,
        plot_funnel_border_size: 1,
        plot_funnel_gap: _sp_small,
        plot_funnel_show_values: true,
        plot_funnel_text_color: _text_bright,
        
        // plot waterfall
        plot_waterfall_increase_color: _plot_waterfall_increase,
        plot_waterfall_decrease_color: _plot_waterfall_decrease,
        plot_waterfall_total_color: _accent_alt,
        plot_waterfall_connector_color: _text_secondary,
        plot_waterfall_connector_thickness: 1,
        plot_waterfall_bar_alpha: 0.85,
        
        // plot bubble
        plot_bubble_min_size: 4,
        plot_bubble_max_size: 40,
        plot_bubble_alpha: 0.7,
        plot_bubble_border_color: _text_bright,
        plot_bubble_border_size: 1,
        
        // plot gantt
        plot_gantt_bar_height: 20,
        plot_gantt_bar_spacing: _sp_small,
        plot_gantt_bar_rounding: _round_med,
        plot_gantt_row_label_width: 100,
        plot_gantt_header_height: 24,
        plot_gantt_header_color: _border,
        plot_gantt_header_text_color: _text_primary,
        
        // plot error
        plot_error_color: _text_secondary,
        plot_error_thickness: 1,
        plot_error_cap_width: _sp_small,
        
        // plot gauge
        plot_gauge_size: 150,
        plot_gauge_thickness: 15,
        plot_gauge_start_angle: 135,
        plot_gauge_sweep_angle: 270,
        plot_gauge_bg_color: _bg_sec,
        plot_gauge_fill_color: _plot_gauge_fill,
        plot_gauge_empty_color: _bg_ter,
        plot_gauge_needle_color: _plot_gauge_needle,
        plot_gauge_needle_thickness: 2,
        plot_gauge_text_color: _text_primary,
        plot_gauge_label_color: _text_secondary,
        plot_gauge_show_ticks: true,
        plot_gauge_tick_count: 5,
        plot_gauge_tick_color: _text_secondary,
        
        // plot table
        plot_table_header_bg: _border,
        plot_table_header_text_color: _text_primary,
        plot_table_row_bg: _bg_sec,
        plot_table_row_alt_bg: _bg_sec,
        plot_table_text_color: _text_primary,
        plot_table_border_color: _border_dark,
        plot_table_border_size: 1,
        plot_table_cell_padding_h: _sp_medium,
        plot_table_cell_padding_v: _sp_tiny,
        plot_table_row_height: 22,
        plot_table_header_height: 26,
        
        // tree view
        tree_item_height: 22,
        tree_indent: _sp_large,
        tree_arrow_size: 8,
        tree_arrow_color: _arrow,
        tree_arrow_hover_color: _arrow_hover,
        tree_item_color: _bg_sec,
        tree_item_hover_color: _widget_base,
        tree_item_selected_color: _accent_dark,
        tree_item_text_color: _text_primary,
        tree_item_selected_text_color: _text_bright,
    };
};

function gmui_style_init1() {
	global.gmui.style = {
		// (-5 = inherit directly from global.gmui.style.font, undefined = inherit from global.gmui.style.font_... if set, if not then inherit from global.gmui.style.font)
		font: -1,
		font_text: undefined,
		font_button: undefined,
		font_checkbox: undefined,
		font_textbox: undefined,
		font_collapsing_header: undefined,
		font_tab_item: undefined,
		font_selectable: undefined,
		font_separator: undefined,
		font_label: undefined,
		font_progress_bar: undefined,
		font_progress_circular: undefined,
		font_tooltip: undefined,
		font_image_button: undefined,
		font_plot: undefined,
		//font_plot_title: -5,
		//font_plot_label: -5,
		font_knob: undefined,
		font_multiselect: undefined,
		font_kv_list: undefined,
		font_window_title: undefined,
		
		// container
		container_background_color: make_color_rgb(32, 32, 32),
		container_outline_color: make_color_rgb(60, 60, 60),
		container_rounding: 0,
		container_padding_v: 8,
		container_padding_h: 8,
		element_spacing_h: 8,
		element_spacing_v: 4,
		
		// general text
		text_color: make_color_rgb(220, 220, 220),
		text_alpha: 1,
		text_disabled_color: make_color_rgb(128, 128, 128),
		
		// clickable text
		text_clickable_color_idle: make_color_rgb(100, 100, 255),
		text_clickable_color_active: make_color_rgb(16, 16, 128),
		text_clickable_color_hover: make_color_rgb(128, 128, 255),
		
		// bullet text
		text_bullet_size: 6,
		text_bullet_spacing: 6,
		
		// button
		button_color_idle: make_color_rgb(70, 70, 70),
		button_color_hovered: make_color_rgb(90, 90, 90),
		button_color_active: make_color_rgb(50, 50, 50),
		button_text_color: make_color_rgb(220, 220, 220),
		button_text_alpha: 1,
		button_border_color: make_color_rgb(100, 100, 100),
		button_padding_h: 8,
		button_padding_v: 4,
		button_rounding: 4,
		button_border_size: 1,
		button_min_width: 80,
		button_min_height: 24,
		
		// checkbox
		checkbox_color_idle: make_color_rgb(70, 70, 70),
		checkbox_color_hovered: make_color_rgb(90, 90, 90),
		checkbox_color_active: make_color_rgb(50, 50, 50),
		checkbox_border_color: make_color_rgb(100, 100, 100),
		checkbox_checkmark_color: make_color_rgb(220, 220, 220),
		checkbox_text_color: make_color_rgb(220, 220, 220),
		checkbox_text_alpha: 1,
		checkbox_padding: 4,
		checkbox_size: 16,
		checkbox_rounding: 2,
		checkbox_border_size: 1,
		
		// scrollbar
		scrollbar_track_color: make_color_rgb(40, 40, 40),
		scrollbar_thumb_color: make_color_rgb(100, 100, 100),
		scrollbar_thumb_hovered_color: make_color_rgb(120, 120, 120),
		scrollbar_thumb_active_color: make_color_rgb(140, 140, 140),
		scrollbar_width: 8,
		scrollbar_padding: -8,
		scrollbar_min_thumb_size: 30,
		scrollbar_rounding: 4,
		scroll_speed: 30,
		
		// slider
		slider_track_height: 6,
		slider_track_color: make_color_rgb(50, 50, 50),
		slider_track_fill_color: make_color_rgb(100, 100, 255),
		slider_track_rounding: 3,
		
		slider_handle_width: 12,
		slider_handle_height: 20,
		slider_handle_color: make_color_rgb(200, 200, 200),
		slider_handle_hovered_color: make_color_rgb(230, 230, 230),
		slider_handle_active_color: make_color_rgb(180, 180, 180),
		slider_handle_border_color: make_color_rgb(100, 100, 100),
		slider_handle_rounding: 3,
		
		// textbox
		textbox_color: make_color_rgb(40, 40, 40),
		textbox_border_color: make_color_rgb(80, 80, 80),
		textbox_focused_border_color: make_color_rgb(100, 100, 255),
		textbox_text_color: make_color_rgb(220, 220, 220),
		textbox_placeholder_color: make_color_rgb(128, 128, 128),
		textbox_cursor_color: make_color_rgb(220, 220, 220),
		textbox_selection_color: make_color_rgb(60, 60, 140),
		textbox_padding_h: 4,
		textbox_padding_v: 4,
		textbox_rounding: 4,
		textbox_border_size: 1,
		textbox_cursor_width: 2,
		textbox_height: 24,
		
		// drag textbox
		drag_textbox_color: make_color_rgb(40, 40, 40),
		drag_textbox_border_color: make_color_rgb(80, 80, 80),
		drag_textbox_focused_border_color: make_color_rgb(100, 100, 255),
		drag_textbox_text_color: make_color_rgb(220, 220, 220),
		drag_textbox_drag_color: make_color_rgb(100, 100, 255),
		drag_textbox_drag_hotzone: 8,
		drag_textbox_sensitivity: 0.1,
		
		// collapsing header
		collapsing_header_height: 24,
		collapsing_header_color: make_color_rgb(60, 60, 60),
		collapsing_header_hovered_color: make_color_rgb(80, 80, 80),
		collapsing_header_active_color: make_color_rgb(50, 50, 50),
		collapsing_header_border_color: make_color_rgb(100, 100, 100),
		collapsing_header_text_color: make_color_rgb(220, 220, 220),
		collapsing_header_arrow_color: make_color_rgb(200, 200, 200),
		collapsing_header_arrow_size: 8,
		collapsing_header_padding: 8,
		collapsing_header_rounding: 4,
		collapsing_header_indent: 16,
		
		// separator
		separator_color: make_color_rgb(60, 60, 60),
		separator_thickness: 1,
		separator_text_color: make_color_rgb(100, 100, 100),
		separator_gap: 8,
		
		// selectable
		selectable_min_height: 24,
		selectable_min_width: 192,
		selectable_color: make_color_rgb(50, 50, 50),
		selectable_hovered_color: make_color_rgb(70, 70, 70),
		selectable_active_color: make_color_rgb(40, 40, 40),
		selectable_selected_color: make_color_rgb(65, 105, 225),
		selectable_selected_hovered_color: make_color_rgb(75, 115, 235),
		selectable_text_color: make_color_rgb(220, 220, 220),
		selectable_text_selected_color: make_color_rgb(255, 255, 255),
		selectable_rounding: 4,
		selectable_padding_h: 8,
		selectable_padding_v: 4,
		
		// tabs
		tab_bar_height: 32,
		tab_item_color: make_color_rgb(50, 50, 50),
		tab_item_hovered_color: make_color_rgb(70, 70, 70),
		tab_item_active_color: make_color_rgb(40, 40, 40),
		tab_item_selected_color: make_color_rgb(100, 150, 255),
		tab_item_text_color: make_color_rgb(220, 220, 220),
		tab_item_selected_text_color: make_color_rgb(255, 255, 255),
		tab_item_padding_h: 12,
		tab_item_padding_v: 6,
		tab_item_rounding: 4,
		tab_item_spacing: 2,
		tab_item_min_width: 80,
		
		// window
        window_title_height: 24,
        window_title_color_idle: make_color_rgb(50, 50, 50),
        window_title_hover_color: make_color_rgb(60, 60, 60),
        window_title_active_color: make_color_rgb(40, 40, 40),
        window_title_text_color: make_color_rgb(220, 220, 220),
        window_close_button_size: 16,
        window_close_button_color_idle: make_color_rgb(150, 150, 150),
        window_close_button_hover_color: make_color_rgb(220, 100, 100),
        window_close_button_active_color: make_color_rgb(180, 80, 80),
        window_collapse_button_size: 6,
        window_collapse_button_color_idle: make_color_rgb(220, 220, 220),
        window_collapse_button_hover_color: make_color_rgb(255, 255, 255),
        window_collapse_button_active_color: make_color_rgb(200, 200, 200),
		
		// context menu
		context_menu_item_height: 22,
		context_menu_item_color: make_color_rgb(45, 45, 45),
		context_menu_item_color_hover: make_color_rgb(70, 70, 70),
		context_menu_item_color_active: make_color_rgb(50, 50, 50),
		context_menu_text_color: make_color_rgb(220, 220, 220),
		context_menu_shortcut_color: make_color_rgb(150, 150, 150),
		context_menu_arrow_color: make_color_rgb(180, 180, 180),
		context_menu_padding_h: 10,
		
		// tooltip
		tooltip_background_color: make_color_rgb(50, 50, 50),
		tooltip_border_color: make_color_rgb(100, 100, 100),
		tooltip_text_color: make_color_rgb(220, 220, 220),
		tooltip_text_alpha: 1,
		tooltip_padding_h: 8,
		tooltip_padding_v: 4,
		tooltip_mouse_padding_h: 16,
		tooltip_mouse_padding_v: 16,
		tooltip_line_padding_v: 4,
		tooltip_rounding: 4,
		tooltip_delay: 500, // ms before showing
		tooltip_min_width: 100,
		
		// progress bar
		progress_bar_height: 20,
		progress_bar_background_color: make_color_rgb(50, 50, 50),
		progress_bar_fill_color: make_color_rgb(100, 150, 255),
		progress_bar_border_color: make_color_rgb(80, 80, 80),
		progress_bar_text_color: make_color_rgb(220, 220, 220),
		progress_bar_rounding: 4,
		progress_bar_border_size: 1,
		
		// circular progress
		progress_circular_size: 40,
		progress_circular_thickness: 4,
		progress_circular_bg_color: make_color_rgb(50, 50, 50),
		progress_circular_fill_color: make_color_rgb(100, 150, 255),
		progress_circular_text_color: make_color_rgb(220, 220, 220),
		
		// combo box
		combo_height: 24,
		combo_color: make_color_rgb(40, 40, 40),
		combo_border_color: make_color_rgb(80, 80, 80),
		combo_hover_color: make_color_rgb(60, 60, 60),
		combo_text_color: make_color_rgb(220, 220, 220),
		combo_placeholder_color: make_color_rgb(128, 128, 128),
		combo_arrow_color: make_color_rgb(180, 180, 180),
		combo_arrow_size: 8,
		combo_padding_h: 8,
		combo_rounding: 4,
		combo_border_size: 1,
		combo_dropdown_max_height: 200,
		combo_item_height: 24,
		combo_item_color: make_color_rgb(50, 50, 50),
		combo_item_hover_color: make_color_rgb(70, 70, 70),
		combo_item_text_color: make_color_rgb(220, 220, 220),
		
		// color picker
		color_picker_width: 200,
		color_picker_height: 150,
		color_picker_hue_height: 16,
		color_picker_alpha_height: 16,
		color_picker_preview_size: 30,
		color_picker_padding: 8,
		color_picker_gap: 6,
		color_picker_border_color: make_color_rgb(80, 80, 80),
		color_picker_border_size: 1,
		color_picker_rounding: 4,
		color_button_size: 20,
		color_button_border_color: make_color_rgb(100, 100, 100),
		color_button_hover_border_color: make_color_rgb(150, 150, 150),
		
		// image button
		image_button_padding_h: 4,
		image_button_padding_v: 4,
		image_button_bg_color: make_color_rgb(70, 70, 70),
		image_button_bg_hover_color: make_color_rgb(90, 90, 90),
		image_button_bg_active_color: make_color_rgb(50, 50, 50),
		image_button_border_color: make_color_rgb(100, 100, 100),
		image_button_rounding: 4,
		image_button_border_size: 1,
		
		// toggle switch
		toggle_width: 44,
		toggle_height: 24,
		toggle_padding: 3,
		toggle_color_idle: make_color_rgb(70, 70, 70),
		toggle_color_active: make_color_rgb(100, 150, 255),
		toggle_color_hover: make_color_rgb(90, 90, 90),
		toggle_knob_color: make_color_rgb(220, 220, 220),
		toggle_knob_size: 18,
		toggle_rounding: 12,
		toggle_animation_speed: 0.15,
		
		// knob/dial
		knob_size: 64,
		knob_outer_ring: 6,
		knob_track_thickness: 5,
		knob_start_angle: 140,
		knob_sweep_angle: 260,
		knob_bg_color: make_color_rgb(35, 35, 35),
		knob_outer_ring_color: make_color_rgb(55, 55, 55),
		knob_track_color: make_color_rgb(45, 45, 45),
		knob_fill_color: make_color_rgb(100, 160, 255),
		knob_indicator_color: make_color_rgb(255, 255, 255),
		knob_indicator_thickness: 3,
		knob_indicator_length: 0.65,
		knob_center_color: make_color_rgb(25, 25, 25),
		knob_center_size: 0.55,
		knob_text_color: make_color_rgb(220, 220, 220),
		knob_drag_sensitivity: 0.004,
		
		// color palette
		color_palette_swatch_size: 24,
		color_palette_swatch_spacing: 3,
		color_palette_swatch_bg_color: make_color_rgb(25, 25, 25),
		color_palette_swatch_border_color: make_color_rgb(80, 80, 80),
		color_palette_swatch_border_color: make_color_rgb(100, 100, 100),
		color_palette_swatch_hover_border: make_color_rgb(255, 255, 255),
		color_palette_swatch_selected_border: make_color_rgb(255, 255, 255),
		color_palette_swatch_selected_thickness: 3,
		color_palette_cols: 8,
		
		// multi-select list
		multiselect_item_height: 24,
		multiselect_item_color: make_color_rgb(50, 50, 50),
		multiselect_item_hover_color: make_color_rgb(70, 70, 70),
		multiselect_item_selected_color: make_color_rgb(65, 105, 225),
		multiselect_checkbox_size: 14,
		multiselect_checkbox_spacing: 6,
		multiselect_text_color: make_color_rgb(220, 220, 220),
		multiselect_text_selected_color: make_color_rgb(255, 255, 255),
		multiselect_alternate_color: make_color_rgb(40, 40, 40),
		
		// toast/notification
		toast_padding_h: 12,
		toast_padding_v: 8,
		toast_rounding: 6,
		toast_success_color: make_color_rgb(40, 120, 40),
		toast_error_color: make_color_rgb(180, 50, 50),
		toast_info_color: make_color_rgb(50, 100, 180),
		toast_warning_color: make_color_rgb(180, 150, 30),
		toast_text_color: make_color_rgb(255, 255, 255),
		toast_duration: 3000,
		toast_max_width: 400,
		toast_margin: 16,
		toast_gap: 8,
		toast_position: "top-center", // "top-left", "top-center", "top-right", "bottom-left", "bottom-center", "bottom-right", "middle-center"
		
		// key-value list
		kv_row_height: 22,
		kv_key_color: make_color_rgb(150, 150, 150),
		kv_value_color: make_color_rgb(220, 220, 220),
		kv_separator_color: make_color_rgb(50, 50, 50),
		kv_key_width_ratio: 0.4,
		
		// date picker
		date_picker_header_height: 28,
		date_picker_cell_size: 28,
		date_picker_header_color: make_color_rgb(50, 50, 50),
		date_picker_header_text_color: make_color_rgb(220, 220, 220),
		date_picker_cell_color: make_color_rgb(45, 45, 45),
		date_picker_cell_hover_color: make_color_rgb(70, 70, 70),
		date_picker_cell_selected_color: make_color_rgb(65, 105, 225),
		date_picker_cell_today_color: make_color_rgb(100, 150, 255),
		date_picker_cell_other_month: make_color_rgb(80, 80, 80),
		date_picker_cell_text_color: make_color_rgb(220, 220, 220),
		date_picker_cell_selected_text: make_color_rgb(255, 255, 255),
		date_picker_weekday_color: make_color_rgb(150, 150, 150),
		date_picker_arrow_color: make_color_rgb(200, 200, 200),
		date_picker_arrow_hover_color: make_color_rgb(255, 255, 255),
		
		// radio button
		radio_size: 16,
		radio_color_idle: make_color_rgb(70, 70, 70),
		radio_color_hovered: make_color_rgb(90, 90, 90),
		radio_color_active: make_color_rgb(50, 50, 50),
		radio_border_color: make_color_rgb(100, 100, 100),
		radio_dot_color: make_color_rgb(220, 220, 220),
		radio_text_color: make_color_rgb(220, 220, 220),
		radio_text_alpha: 1,
		radio_padding: 6,
		
		// plot generic
		plot_bg_color: make_color_rgb(25, 25, 25),
		plot_border_color: make_color_rgb(80, 80, 80),
		plot_border_size: 1,
		plot_grid_color: make_color_rgb(50, 50, 50),
		plot_grid_thickness: 1,
		plot_grid_steps: 5,
		plot_line_color: make_color_rgb(100, 200, 255),
		plot_line_thickness: 2,
		plot_point_color: make_color_rgb(100, 200, 255),
		plot_fill_color: make_color_rgb(100, 200, 255),
		plot_fill_alpha: 0.15,
		plot_fill_enabled: true,
		plot_bar_color: make_color_rgb(100, 150, 255),
		plot_bar_border_color: make_color_rgb(80, 80, 80),
		plot_bar_border_size: 1,
		plot_bar_rounding: 2,
		plot_bar_spacing_ratio: 0.2,
		plot_bar_gradient: true,
		plot_bar_min_color: make_color_rgb(100, 100, 255),
		plot_bar_max_color: make_color_rgb(255, 100, 100),
		plot_text_color: make_color_rgb(150, 150, 150),
		plot_bar_text_color: make_color_rgb(255, 255, 255),
		
		// plot pie
		plot_pie_start_angle: -90,
		plot_pie_donut_ratio: 0,
		plot_pie_explode_distance: 5,
		plot_pie_show_labels: true,
		plot_pie_show_percentages: true,
		plot_pie_min_percentage: 5,
		plot_pie_label_color: make_color_rgb(255, 255, 255),
		plot_pie_label_bg_color: make_color_rgb(0, 0, 0),
		plot_pie_label_bg_alpha: 0.7,
		plot_pie_color_palette: [
		    make_color_rgb(255, 100, 100),
		    make_color_rgb(100, 200, 255),
		    make_color_rgb(100, 255, 100),
		    make_color_rgb(255, 200, 50),
		    make_color_rgb(200, 100, 255),
		    make_color_rgb(50, 255, 255),
		    make_color_rgb(255, 150, 50),
		    make_color_rgb(150, 150, 255),
		],
		
		// plot area
		plot_area_color: make_color_rgb(100, 200, 255),
		plot_area_alpha: 0.3,
		plot_area_line_color: make_color_rgb(100, 200, 255),
		plot_area_line_thickness: 2,
		
		// plot stacked
		plot_stacked_bar_colors: [
		    make_color_rgb(100, 150, 255),
		    make_color_rgb(255, 150, 100),
		    make_color_rgb(100, 255, 150),
		    make_color_rgb(255, 200, 50),
		    make_color_rgb(200, 100, 255),
		],
		
		// plot group
		plot_grouped_bar_spacing: 0.15,
		plot_grouped_bar_gap: 2,
		
		// plot heatmap
		plot_heatmap_cell_size: 20,
		plot_heatmap_cell_spacing: 1,
		plot_heatmap_cold_color: make_color_rgb(50, 50, 255),
		plot_heatmap_hot_color: make_color_rgb(255, 50, 50),
		plot_heatmap_show_values: false,
		plot_heatmap_text_color: make_color_rgb(255, 255, 255),
		plot_heatmap_gradient: [
		    make_color_rgb(50, 50, 150),     // deep blue (coldest)
		    make_color_rgb(50, 180, 220),    // cyan
		    make_color_rgb(50, 220, 100),    // green
		    make_color_rgb(220, 220, 50),    // yellow
		    make_color_rgb(220, 120, 50),    // orange
		    make_color_rgb(220, 50, 50),     // red (hottest)
		],
		plot_heatmap_legend_width: 16,
		plot_heatmap_legend_gap: 8,
		plot_heatmap_legend_text_color: make_color_rgb(200, 200, 200),
		plot_heatmap_legend_tick_count: 5,
		
		// plot radar/spider 
		plot_radar_axis_color: make_color_rgb(80, 80, 80),
		plot_radar_grid_color: make_color_rgb(50, 50, 50),
		plot_radar_fill_alpha: 0.2,
		plot_radar_grid_levels: 4,
		plot_radar_label_offset: 15,
		plot_radar_point_size: 4,
		plot_radar_line_thickness: 2,
		
		// plot box
		plot_box_width: 30,
		plot_box_color: make_color_rgb(100, 150, 255),
		plot_box_median_color: make_color_rgb(255, 100, 100),
		plot_box_whisker_color: make_color_rgb(200, 200, 200),
		plot_box_outlier_color: make_color_rgb(255, 100, 100),
		plot_box_outlier_size: 3,
		plot_box_line_thickness: 1,
		plot_box_show_outliers: true,
		
		// plot funnel
		plot_funnel_color: make_color_rgb(100, 150, 255),
		plot_funnel_border_color: make_color_rgb(80, 80, 80),
		plot_funnel_border_size: 1,
		plot_funnel_gap: 4,
		plot_funnel_show_values: true,
		plot_funnel_text_color: make_color_rgb(255, 255, 255),
		
		// plot waterfall
		plot_waterfall_increase_color: make_color_rgb(100, 200, 100),
		plot_waterfall_decrease_color: make_color_rgb(255, 100, 100),
		plot_waterfall_total_color: make_color_rgb(100, 150, 255),
		plot_waterfall_connector_color: make_color_rgb(200, 200, 200),
		plot_waterfall_connector_thickness: 1,
		plot_waterfall_bar_alpha: 0.85,
		
		// plot bubble
		plot_bubble_min_size: 4,
		plot_bubble_max_size: 40,
		plot_bubble_alpha: 0.7,
		plot_bubble_border_color: make_color_rgb(255, 255, 255),
		plot_bubble_border_size: 1,
		
		// plot gnatt
		plot_gantt_bar_height: 20,
		plot_gantt_bar_spacing: 4,
		plot_gantt_bar_rounding: 3,
		plot_gantt_row_label_width: 100,
		plot_gantt_header_height: 24,
		plot_gantt_header_color: make_color_rgb(60, 60, 60),
		plot_gantt_header_text_color: make_color_rgb(220, 220, 220),
		
		// plot error
		plot_error_color: make_color_rgb(200, 200, 200),
		plot_error_thickness: 1,
		plot_error_cap_width: 6,
		
		// plot gauge
		plot_gauge_size: 150,
		plot_gauge_thickness: 15,
		plot_gauge_start_angle: 135,
		plot_gauge_sweep_angle: 270,
		plot_gauge_bg_color: make_color_rgb(50, 50, 50),
		plot_gauge_fill_color: make_color_rgb(100, 200, 100),
		plot_gauge_empty_color: make_color_rgb(40, 40, 40),
		plot_gauge_needle_color: make_color_rgb(255, 100, 100),
		plot_gauge_needle_thickness: 2,
		plot_gauge_text_color: make_color_rgb(220, 220, 220),
		plot_gauge_label_color: make_color_rgb(150, 150, 150),
		plot_gauge_show_ticks: true,
		plot_gauge_tick_count: 5,
		plot_gauge_tick_color: make_color_rgb(200, 200, 200),
		
		// plot table
		plot_table_header_bg: make_color_rgb(60, 60, 60),
		plot_table_header_text_color: make_color_rgb(220, 220, 220),
		plot_table_row_bg: make_color_rgb(50, 50, 50),
		plot_table_row_alt_bg: make_color_rgb(45, 45, 45),
		plot_table_text_color: make_color_rgb(220, 220, 220),
		plot_table_border_color: make_color_rgb(80, 80, 80),
		plot_table_border_size: 1,
		plot_table_cell_padding_h: 8,
		plot_table_cell_padding_v: 3,
		plot_table_row_height: 22,
		plot_table_header_height: 26,
		
		// tree view
		tree_item_height: 22,
		tree_indent: 20,
		tree_arrow_size: 8,
		tree_arrow_color: make_color_rgb(200, 200, 200),
		tree_arrow_hover_color: make_color_rgb(255, 255, 255),
		tree_item_color: make_color_rgb(50, 50, 50),
		tree_item_hover_color: make_color_rgb(70, 70, 70),
		tree_item_selected_color: make_color_rgb(65, 105, 225),
		tree_item_text_color: make_color_rgb(220, 220, 220),
		tree_item_selected_text_color: make_color_rgb(255, 255, 255),
	};
};

function gmui_style_push(key, value) {
    var gmui = global.gmui;
    
    if (!ds_map_exists(gmui.cache, "_style_stack")) {
        gmui.cache[? "_style_stack"] = ds_map_create();
    }
    
    var stack = gmui.cache[? "_style_stack"];
    
    if (!ds_map_exists(stack, key)) {
        stack[? key] = [];
    }
    
    var key_stack = stack[? key];
    array_push(key_stack, variable_struct_get(gmui.style, key));
    variable_struct_set(gmui.style, key, value);
};

function gmui_style_pop(key) {
    var gmui = global.gmui;
    
    if (!ds_map_exists(gmui.cache, "_style_stack")) return;
    
    var stack = gmui.cache[? "_style_stack"];
    if (!ds_map_exists(stack, key)) return;
    
    var key_stack = stack[? key];
    if (array_length(key_stack) == 0) return;
    
    var previous = array_pop(key_stack);
    variable_struct_set(gmui.style, key, previous);
};

function gmui_style_push_multi(map) {
    var keys = variable_struct_get_names(map);
    for (var i = 0; i < array_length(keys); i++) {
        gmui_style_push(keys[i], variable_struct_get(map, keys[i]));
    }
};

function gmui_style_pop_multi(keys_array) {
    for (var i = 0; i < array_length(keys_array); i++) {
        gmui_style_pop(keys_array[i]);
    }
};

function gmui_style_get(key) {
    return variable_struct_get(global.gmui.style, key);
};

function gmui_style_set(key, value) {
    variable_struct_set(global.gmui.style, key, value);
};

function gmui_style_scope(key, value, func) {
    gmui_style_push(key, value);
    func();
    gmui_style_pop(key);
};

function gmui_style_scope_multi(map, func) {
    gmui_style_push_multi(map);
    func();
    var keys = variable_struct_get_names(map);
    gmui_style_pop_multi(keys);
};