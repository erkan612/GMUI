gmui_init();

scroll_x = 0;
scroll_y = 0;

contentHeight = 0;

tabIdx = 1;

txD1 = "";

c1 = false;
c2 = false;
c3 = false;

v2 = [ 0, 0 ];
v3 = [ 0, 0, 0 ];
v4 = [ 0, 0, 0, 0 ];

global.gmui.font = fnCascadiaCode;

editc4 = gmui_make_color_rgba(0, 0, 255, 255);
buttonc4 = gmui_make_color_rgba(255, 0, 255, 255);

/*
	GMUI/
	├── Core/
	│   ├── gmui_core.gml          # Initialization, main loop, window management
	│   ├── gmui_input.gml         # Input handling, mouse/keyboard processing
	│   └── gmui_render.gml        # Rendering, surface management
	├── Elements/
	│   ├── gmui_basic.gml         # Text, labels, separators, buttons
	│   ├── gmui_forms.gml         # Checkboxes, sliders, textboxes, drag inputs
	│   ├── gmui_containers.gml    # Treeviews, collapsible headers, selectables
	│   └── gmui_color.gml         # Color picker, color buttons
	├── Layout/
	│   ├── gmui_layout.gml        # Cursor management, spacing, alignment
	│   └── gmui_scroll.gml        # Scrollbars, scrolling behavior
	├── Styles/
	│   ├── gmui_style.gml         # Style definitions, colors, sizing
	│   └── gmui_shaders.gml       # Shader-based rendering for gradients
	└── Utilities/
	    ├── gmui_math.gml          # Color conversions, math helpers
	    └── gmui_helpers.gml       # Utility functions, state management
*/