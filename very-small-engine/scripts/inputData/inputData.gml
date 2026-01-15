#macro vk_capslock (20)

function __keyboard_keynames(ind=undefined) {
	static dat = (function() {
		var arr = array_create(256, undefined);
		
		arr[vk_space] = "Space";
		arr[vk_shift] = "Shift";
		arr[vk_control] = "Control";
		arr[vk_alt] = "Alt";
		arr[vk_enter] = "Enter";
		arr[vk_up] = "Up";
		arr[vk_down] = "Down";
		arr[vk_left] = "Left";
		arr[vk_right] = "Right";
		arr[vk_backspace] = "Backspace";
		arr[vk_tab] = "Tab";
		arr[vk_insert] = "Insert";
		arr[vk_delete] = "Delete";
		arr[vk_pageup] = "Page Up";
		arr[vk_pagedown] = "Page Down";
		arr[vk_home] = "Home";
		arr[vk_end] = "End";
		arr[vk_escape] = "Escape";
		arr[vk_printscreen] = "Print Screen";
		arr[vk_f1] = "F1";
		arr[vk_f2] = "F2";
		arr[vk_f3] = "F3";
		arr[vk_f4] = "F4";
		arr[vk_f5] = "F5";
		arr[vk_f6] = "F6";
		arr[vk_f7] = "F7";
		arr[vk_f8] = "F8";
		arr[vk_f9] = "F9";
		arr[vk_f10] = "F10";
		arr[vk_f11] = "F11";
		arr[vk_f12] = "F12";
		arr[vk_lshift] = "Left Shift";
		arr[vk_rshift] = "Right Shift";
		arr[vk_lcontrol] = "Left Control";
		arr[vk_rcontrol] = "Right Control";
		arr[vk_lalt] = "Left Alt";
		arr[vk_ralt] = "Right Alt";
		arr[vk_capslock] = "Caps Lock";
		//numpad keys
		arr[96] = "0";
		arr[97] = "1";
		arr[98] = "2";
		arr[99] = "3";
		arr[100] = "4";
		arr[101] = "5";
		arr[102] = "6";
		arr[103] = "7";
		arr[104] = "8";
		arr[105] = "9";
		arr[106] = "*";
		arr[107] = "+";
		arr[109] = "-";
		arr[110] = ".";
		arr[111] = "/";
		//misc keys
		arr[186] = ";";
		arr[187] = "=";
		arr[188] = ",";
		arr[189] = "-";
		arr[190] = ".";
		arr[191] = "/";
		arr[192] = "`";
		arr[219] = "[";
		arr[220] = "\\";
		arr[221] = "]";
		arr[222] = "'";
		// A-Z 0-9
		var a = ord("A");
		repeat(26) {
			arr[a] = chr(a);
			a++;
		}
		var z = ord("0");
		repeat(10) {
			arr[z] = chr(z);
			z++;
		}
		
		return arr;
	})();
	
	// return empty string if key index is invalid
	if (ind != undefined) {
		if (ind < 0 || ind >= array_length(dat)) return "";
		return dat[ind] ?? "";
	}
	
	// if no input, just return entire array
	return dat;
}

function __keyboard_keymap() {
	static dat = __bimap(__keyboard_keynames());
	return dat;
}

#macro LSTICK_UP (9001)
#macro LSTICK_DOWN (9002)
#macro LSTICK_LEFT (9003)
#macro LSTICK_RIGHT (9004)

#macro RSTICK_UP (9005)
#macro RSTICK_DOWN (9006)
#macro RSTICK_LEFT (9007)
#macro RSTICK_RIGHT (9008)

function __gamepad_types() {
	static types = (function() {
		var arr = [ ];
		arr[ GAMEPAD_TYPE.XBOX ] = "xb";
		arr[ GAMEPAD_TYPE.PLAYSTATION ] = "ps";
	})();
	return types;
}

function __gamepad_buttons() {
	static dat = [
		gp_face1, gp_face2, gp_face3, gp_face4,
		gp_shoulderl, gp_shoulderlb, gp_shoulderr, gp_shoulderrb,
		gp_select, gp_start,
		gp_stickl, gp_stickr,
		gp_padu, gp_padd, gp_padl, gp_padr,
		
		LSTICK_UP, LSTICK_DOWN, LSTICK_LEFT, LSTICK_RIGHT,
		RSTICK_UP, RSTICK_DOWN, RSTICK_LEFT, RSTICK_RIGHT,
	];
}

function __gamepad_butnames(ind=undefined) {
	static dat = (function() {
		var arr = [];
		arr[ GAMEPAD_TYPE.XBOX ] = [
			"A", "B", "X", "Y",
			"LB", "RB", "LT", "RT",
			"SELECT", "START",
			"LC", "RC",
			"D-Pad Up", "D-Pad Down", "D-Pad Left", "D-Pad Right",
			
			"L-Stick Up", "L-Stick Down", "L-Stick Left", "L-Stick Right",
			"R-Stick Up", "R-Stick Down", "R-Stick Left", "R-Stick Right",
		];
		arr[ GAMEPAD_TYPE.PLAYSTATION ] = [
			"Cross", "Circle", "Square", "Triangle",
			"L1", "R1", "L2", "R2",
			"SELECT", "START",
			"L3", "R3",
			"D-Pad Up", "D-Pad Down", "D-Pad Left", "D-Pad Right",
			
			"L-Stick Up", "L-Stick Down", "L-Stick Left", "L-Stick Right",
			"R-Stick Up", "R-Stick Down", "R-Stick Left", "R-Stick Right",
		];
	})();
	
	if (ind != undefined) {
		return dat[ __get_gamepad_type() ][ ind ];
	}
	
	return dat;
}

//function __gamepad_butmap() {
//	static dat = {};//__bimap(__gamepad_butnames());
//	return dat;
	
//}



function __bimap(arr, result = { }) {
	for (var i = 0; i < array_length(arr); i++) {
		if (arr[i] != undefined) {
			var key = string(arr[i]);
			result[$ key] = i;
		}
	}
	return result;
}
