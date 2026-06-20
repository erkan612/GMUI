

// PROFILE
function gmui_get_default_profile(type = gmui_default_profile.ANIMATION) {
	var profile = undefined;
	switch (type) {
	case gmui_default_profile.ANIMATION: {
		profile = {
			column_row_properties: {
				background_enabled: false,
				use_surface: false,
				use_scissor: true,
				animation_flag: false,
			},
			container_properties: {
				use_surface: true,
				surface_flag: false,
				surface_sleep: false,
				use_scissor: true,
				animation_flag: false,
				mask_enabled: true,
			},
		};
	} break;
	case gmui_default_profile.CACHED_LEVEL1: {
		profile = {
			column_row_properties: {
				background_enabled: false,
				use_surface: true,
				surface_flag: true,
				use_scissor: true,
				animation_flag: false,
				mask_enabled: true,
			},
			container_properties: {
				use_surface: false,
				surface_flag: true,
				surface_sleep: false,
				use_scissor: true,
				animation_flag: false,
				mask_enabled: true,
			},
		};
	} break;
	case gmui_default_profile.CACHED_LEVEL2: {
		profile = {
			column_row_properties: {
				background_enabled: false,
				use_surface: true,
				surface_flag: true,
				surface_sleep: true,
				use_scissor: true,
				animation_flag: false,
				mask_enabled: true,
			},
			container_properties: {
				use_surface: true,
				surface_flag: true,
				surface_sleep: true,
				use_scissor: true,
				animation_flag: false,
				mask_enabled: false,
			},
		};
	} break;
	case gmui_default_profile.CACHED_LEVEL3: {
		profile = {
			column_row_properties: {
				background_enabled: false,
				use_surface: true,
				surface_flag: true,
				surface_sleep: true,
				use_scissor: true,
				animation_flag: false,
				mask_enabled: true,
			},
			container_properties: {
				use_surface: true,
				surface_flag: true,
				surface_sleep: true,
				use_scissor: true,
				animation_flag: false,
				mask_enabled: false,
				widget_flag: true,
			},
		};
	} break;
	case gmui_default_profile.BALANCED: {
		profile = {
			column_row_properties: {
				background_enabled: false,
				use_surface: true,
				surface_flag: true,
				surface_sleep: true,
				use_scissor: true,
				animation_flag: true,
			},
			container_properties: {
				use_surface: true,
				surface_flag: true,
				surface_sleep: true,
				use_scissor: true,
				animation_flag: true,
				mask_enabled: true,
			},
		};
	} break;
	};
	return profile;
};

function gmui_set_profile(profile) {
	global.gmui.profile = profile;
};