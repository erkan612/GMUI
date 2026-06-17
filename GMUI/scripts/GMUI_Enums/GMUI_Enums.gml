

enum gmui_corner_direction {
	TOP_LEFT						= 1 << 0,
	TOP_RIGHT						= 1 << 1,
	
	BOTTOM_LEFT						= 1 << 2,
	BOTTOM_RIGHT					= 1 << 3,
	
	UP								= gmui_corner_direction.TOP_LEFT		| gmui_corner_direction.TOP_RIGHT,
	DOWN							= gmui_corner_direction.BOTTOM_LEFT		| gmui_corner_direction.BOTTOM_RIGHT,
	RIGHT							= gmui_corner_direction.TOP_RIGHT		| gmui_corner_direction.BOTTOM_RIGHT,
	LEFT							= gmui_corner_direction.TOP_LEFT		| gmui_corner_direction.BOTTOM_LEFT,
	ALL								= gmui_corner_direction.TOP_LEFT		| gmui_corner_direction.TOP_RIGHT		| gmui_corner_direction.BOTTOM_LEFT				| gmui_corner_direction.BOTTOM_RIGHT,
	NONE							= 0,
};

enum gmui_window_flags {
    NONE							= 0,
    NO_TITLE_BAR					= 1 << 0,
    NO_MOVE_WITH_MOUSE				= 1 << 1,
    NO_CLOSE						= 1 << 2,
    NO_COLLAPSE						= 1 << 3,
    NO_SCROLL						= 1 << 4,
    NO_BORDERS						= 1 << 5,
    NO_BORDER_RESIZE				= 1 << 6,
    AUTO_RESIZE_HORIZONTAL			= 1 << 7,
    AUTO_RESIZE_VERTICAL			= 1 << 8,
};

enum gmui_tab_flags {
	NONE							= 0,
	NO_MOVE							= 1 << 0,
	NO_CLOSE						= 1 << 1,
	LEAVE_ONE						= 1 << 2,
};

enum gmui_layer {
    BACKGROUND						= 0,
    NORMAL							= 1,
    MODAL_BG						= 2,
    POPUP							= 3,
}

enum gmui_split_dir {
	HORIZONTAL						= 0,
	VERTICAL						= 1,
};
enum gmui_default_profile {
	ANIMATION						= 0,
	CACHED1							= 1,
	CACHED2							= 2,
	BALANCED						= 3,
};

enum gmui_flow_direction {
	LEFT							= 0,
	RIGHT							= 1,
	UP								= 2,
	DOWN							= 3,
};