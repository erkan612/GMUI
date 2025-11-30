gmui_init();

winsFrame = undefined;

objectCreateTextInput = "";
objectCreateComboIndex = 0;

objects = array_create(0);
selectedObject = undefined;

collapsingHeaderOpenTransform = true;

surfaceView = undefined;

GetObject = function(name) {
	for (var i = 0; i < array_length(objects); i++) {
	    if (objects[i].name == name) { return objects[i]; };
	}
	return undefined;
};

GetObjectIndex = function(name) {
	for (var i = 0; i < array_length(objects); i++) {
	    if (objects[i].name == name) { return i; };
	}
	return undefined;
};