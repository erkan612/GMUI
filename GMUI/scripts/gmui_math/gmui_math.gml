// Color conversions, math helpers
function gmui_make_color_rgba(r, g, b, a) {
    r = clamp(r, 0, 255);
    g = clamp(g, 0, 255);
    b = clamp(b, 0, 255);
    a = clamp(a, 0, 255);

    // Combine RGBA into a single 32-bit integer
    return (a << 24) | (r << 16) | (g << 8) | b;
}

function gmui_rgba_to_hsva(r, g, b, a)
{
    // Normalize RGB to [0, 1]
    var rf = r / 255;
    var gf = g / 255;
    var bf = b / 255;

    // Find min/max
    var maxc = max(rf, max(gf, bf));
    var minc = min(rf, min(gf, bf));
    var delta = maxc - minc;

    var h, s, v;
    v = maxc;

    // Saturation
    if (maxc == 0) s = 0;
    else s = delta / maxc;

    // Hue
    if (delta == 0) {
        h = 0;
    } else if (maxc == rf) {
        h = ((gf - bf) / delta) % 6;
    } else if (maxc == gf) {
        h = ((bf - rf) / delta) + 2;
    } else {
        h = ((rf - gf) / delta) + 4;
    }

    h = (h / 6);
    if (h < 0) h += 1;

	return [h, s, v, a];
}

function gmui_hsva_to_rgba(h, s, v, a)
{
    h = frac(h) * 6; // ensure hue in [0,6)
    var i = floor(h);
    var f = h - i;
    var p = v * (1 - s);
    var q = v * (1 - s * f);
    var t = v * (1 - s * (1 - f));

    var rf, gf, bf;
    switch (i) {
        case 0: rf = v; gf = t; bf = p; break;
        case 1: rf = q; gf = v; bf = p; break;
        case 2: rf = p; gf = v; bf = t; break;
        case 3: rf = p; gf = q; bf = v; break;
        case 4: rf = t; gf = p; bf = v; break;
        default: rf = v; gf = p; bf = q; break;
    }

    return [
        clamp(rf * 255, 0, 255),
        clamp(gf * 255, 0, 255),
        clamp(bf * 255, 0, 255),
        clamp(a, 0, 255)
    ];
}

function gmui_color_rgba_to_array(color) {
	var a = (color >> 24) & 255;
	var r = (color >> 16) & 255;
	var g = (color >> 8) & 255;
	var b = color & 255;
    return [r, g, b, a];
}

function gmui_array_to_color_rgba(rgba) {
    var r = clamp(rgba[0], 0, 255);
    var g = clamp(rgba[1], 0, 255);
    var b = clamp(rgba[2], 0, 255);
    var a = clamp(rgba[3], 0, 255);
    return gmui_make_color_rgba(r, g, b, a);
}

function gmui_color_rgba_to_color_rgb(rgba) {
	var a = (rgba >> 24) & 255;
	var r = (rgba >> 16) & 255;
	var g = (rgba >> 8) & 255;
	var b = rgba & 255;
	return make_color_rgb(r, g, b);
};