if (!keyboard_check(vk_space)) {
	array = [ ]
	for (var i = 0; i < 500; i++) {
		array_push(array, "a value");
	};

	show_debug_message(array_length(array));
	show_debug_message(array[0] + array[1]);
	gc_collect();
}