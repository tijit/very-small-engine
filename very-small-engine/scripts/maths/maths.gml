function rounded(n) {
	return floor(n+0.5);
}

function modulo(a, b) {
	return (b+a%b)%b;
}

function lineDist1D(ax0, ax1, bx0, bx1) {
	return max(0, ax0 - bx1, bx0 - ax1);
}

// signed version, negative = more overlap
function slineDist1D(ax0, ax1, bx0, bx1) {
	return max(ax0 - bx1, bx0 - ax1);
}
