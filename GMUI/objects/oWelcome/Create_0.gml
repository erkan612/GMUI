gmui_init();

winsFrame = undefined;

objectList = [
	{
		name:		"Ground",
		type:		0, // 0 = Static Mesh, 1 = Dynamic Mesh
		position:	[ 0, 0, 0 ],
		rotation:	[ 0, 0, 0 ],
		scale:		[ 1, 1, 1 ],
		color:		gmui_make_color_rgba(255, 255, 255, 255),
	},
	{
		name:		"Box",
		type:		0, // 0 = Static Mesh, 1 = Dynamic Mesh
		position:	[ 22, 10, 4 ],
		rotation:	[ 90, 240, 30 ],
		scale:		[ 1, 1, 1 ],
		color:		gmui_make_color_rgba(255, 255, 255, 255),
	},
	{
		name:		"Player",
		type:		1, // 0 = Static Mesh, 1 = Dynamic Mesh
		position:	[ 10, 10, 4 ],
		rotation:	[ 0, 0, 0 ],
		scale:		[ 1, 1, 1 ],
		color:		gmui_make_color_rgba(255, 255, 255, 255),
	},
];

selectedObject = undefined;