function saveFileString(fname, text) {
	var buffer = buffer_create(1024, buffer_grow, 1);
	
	buffer_write(buffer, buffer_string, text);
	buffer_save(buffer, fname);
	
	buffer_delete(buffer);
}

function loadFileString(fname) {
	var result;
	var f = buffer_load(fname);
	
	result = buffer_read(f, buffer_string);
	
	buffer_delete(f);
	return result;
}

function structSaveToFile(fname, struct) {
	saveFileString(fname, base64_encode(json_stringify(struct)));
}

function structLoadFromFile(fname) {
	var f = buffer_load(fname);
	var fileText = buffer_read(f, buffer_string);
	var json =  base64_decode(fileText);
	buffer_delete(f);
	
	return json_parse(json);
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
