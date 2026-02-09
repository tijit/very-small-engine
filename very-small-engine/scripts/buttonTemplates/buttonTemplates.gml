function buttonTemplateToggle(option, textTrue="On", textFalse="Off") {
	self.option = option;
	self.textTrue = textTrue;
	self.textFalse = textFalse;
	
	updateText = function() {
		text2 = gameSettings(option) ? textTrue : textFalse;
	};
	updateText();
	
	onPress = function() {
		gameSettings(option, !gameSettings(option));
		updateText();
		applySettings();
		if (onChange != undefined) onChange();
	};
	onLeft = function() {
		onPress();
	};
	onRight = function() {
		onPress();
	};
}

function buttonTemplateSlider(option, isPercentage=true, increment=0.1, low=0, high=1) {
	self.option = option;
	self.isPercentage = isPercentage;
	self.increment = increment;
	self.low = low;
	self.high = high;
	
	updateText = function() {
		var val = gameSettings(option);
		if (isPercentage) {
			val = rounded( 100 * (val - low) / (high - low) );
			text2 = $"{val}%";
		}
		else {
			text2 = $"{val}";
		}
	};
	updateText();
	
	changeValue = function(sgn) {
		var val = gameSettings(option);
		val += sgn * increment;
		val = clamp(val, low, high);
		
		gameSettings(option, val);
		updateText();
		applySettings();
		
		if (onChange != undefined) onChange();
	};
	onLeft = function() {
		changeValue(-1);
	};
	onRight = function() {
		changeValue(+1);
	};
}
