function saveFileString(fname, text) {
	var buffer = buffer_create(1024, buffer_grow, 1);
	var str = "";
	try {
		str = buffer_write(buffer, buffer_string, text);
		//show_debug_message($"buffer write result: {str}");
		buffer_save(buffer, fname);
	}
	catch (e) {
		show_debug_message($"failed to save file: {fname}");
	}
	
	buffer_delete(buffer);
}

function loadFileString(fname) {
	try {
		var result;
		var f = buffer_load(fname);
		
		result = buffer_read(f, buffer_string);
		
		buffer_delete(f);
		return result;
	}
	catch (e) {
		show_debug_message($"failed to load file: {fname}");
		return "";
	}
}

function structSaveToFile(fname, struct) {
	saveFileString(fname, base64_encode(json_stringify(struct)));
}

function structLoadFromFile(fname) {
	try {
		var f = buffer_load(fname);
		var fileText = buffer_read(f, buffer_string);
		var json =  base64_decode(fileText);
		buffer_delete(f);
		
		return json_parse(json);
	}
	catch (e) {
		show_debug_message($"failed to load file: {fname}");
		return { };
	}
}

/// @desc deep copies struct information, shallow copy array refs
function structCopy(dest, src) {
	var names = variable_struct_get_names(src);
	var i = 0; repeat(array_length(names)) {
		var name = names[i++];
		if (is_struct(src[$ name])) {
			// deep copy structs
			dest[$ name] = { };
			structCopy(dest[$ name], src[$ name]);
		}
		else {
			dest[$ name] = src[$ name] ?? dest[$ name];
		}
	}
	return dest;
}

function __hello_cat() {
	show_debug_message("meow :3c");
}
