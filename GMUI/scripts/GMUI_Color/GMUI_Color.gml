

// COLOR
function gmui_hsv_to_rgb(h, s, v) {
    h = frac(h) * 6;
    var i = floor(h);
    var f = h - i;
    var p = v * (1 - s);
    var q = v * (1 - s * f);
    var t = v * (1 - s * (1 - f));
    
    var r, g, b;
    switch (i) {
        case 0: r = v; g = t; b = p; break;
        case 1: r = q; g = v; b = p; break;
        case 2: r = p; g = v; b = t; break;
        case 3: r = p; g = q; b = v; break;
        case 4: r = t; g = p; b = v; break;
        default: r = v; g = p; b = q; break;
    }
    
    return [clamp(r * 255, 0, 255), clamp(g * 255, 0, 255), clamp(b * 255, 0, 255)];
};

function gmui_rgb_to_hsv(r, g, b) {
    var rf = r / 255, gf = g / 255, bf = b / 255;
    var maxc = max(rf, max(gf, bf));
    var minc = min(rf, min(gf, bf));
    var delta = maxc - minc;
    
    var h = 0, s = 0, v = maxc;
    
    if (delta != 0) {
        s = delta / maxc;
        if (maxc == rf) h = ((gf - bf) / delta) % 6;
        else if (maxc == gf) h = ((bf - rf) / delta) + 2;
        else h = ((rf - gf) / delta) + 4;
        h /= 6;
        if (h < 0) h += 1;
    }
    
    return [h, s, v];
};

function gmui_make_color_rgba(r, g, b, a) {
    r = clamp(r, 0, 255);
    g = clamp(g, 0, 255);
    b = clamp(b, 0, 255);
    a = clamp(a, 0, 255);
    
    return (r) | (g << 8) | (b << 16) | (a << 24);
}

function gmui_color_rgba_get_red(color) {
    return color & 255;
}

function gmui_color_rgba_get_green(color) {
    return (color >> 8) & 255;
}

function gmui_color_rgba_get_blue(color) {
    return (color >> 16) & 255;
}

function gmui_color_rgba_get_alpha(color) {
    return (color >> 24) & 255;
}

function gmui_color_rgb_to_rgba(color, alpha = 255) {
    return gmui_make_color_rgba(
        color_get_red(color),
        color_get_green(color),
        color_get_blue(color),
        alpha
    );
}

function gmui_color_rgba_to_rgb(color) {
    return make_color_rgb(
        gmui_color_rgba_get_red(color),
        gmui_color_rgba_get_green(color),
        gmui_color_rgba_get_blue(color)
    );
}

function gmui_color_rgba_to_array(color) {
    return [
        gmui_color_rgba_get_red(color),
        gmui_color_rgba_get_green(color),
        gmui_color_rgba_get_blue(color),
        gmui_color_rgba_get_alpha(color)
    ];
}

function gmui_color_rgb_to_array(color) {
    return [
        color_get_red(color),
        color_get_green(color),
        color_get_blue(color)
    ];
}

function gmui_color_rgba_from_array(arr) {
    return gmui_make_color_rgba(arr[0], arr[1], arr[2], arr[3]);
}

function gmui_color_lighten(color, factor) {
    var r = clamp(gmui_color_rgba_get_red(color) * factor, 0, 255);
    var g = clamp(gmui_color_rgba_get_green(color) * factor, 0, 255);
    var b = clamp(gmui_color_rgba_get_blue(color) * factor, 0, 255);
    var a = gmui_color_rgba_get_alpha(color);
    return gmui_make_color_rgba(r, g, b, a);
};

function gmui_color_darken(color, factor) {
    return gmui_color_lighten(color, factor);
};

function gmui_color_lerp(color1, color2, t) {
    t = clamp(t, 0, 1);
    var a1 = gmui_color_rgba_to_array(color1);
    var a2 = gmui_color_rgba_to_array(color2);
    return gmui_make_color_rgba(
        lerp(a1[0], a2[0], t),
        lerp(a1[1], a2[1], t),
        lerp(a1[2], a2[2], t),
        lerp(a1[3], a2[3], t)
    );
};

function gmui_color_set_alpha(color, alpha) {
    return (clamp(alpha, 0, 255) << 24) | (color & 0xFFFFFF);
};

function gmui_color_get_alpha_rgb(color) {
    return 255;
};

function _gmui_lerp_color_gradient(gradient, t) {
    t = clamp(t, 0, 1);
    var stops = array_length(gradient);
    if (stops == 1) return gradient[0];
    
    var segment = t * (stops - 1);
    var index = floor(segment);
    var _frac = segment - index;
    
    if (index >= stops - 1) return gradient[stops - 1];
    
    return _gmui_lerp_color(gradient[index], gradient[index + 1], _frac);
};

function _gmui_lerp_color(c1, c2, t) {
    t = clamp(t, 0, 1);
    var r = lerp(color_get_red(c1), color_get_red(c2), t);
    var g = lerp(color_get_green(c1), color_get_green(c2), t);
    var b = lerp(color_get_blue(c1), color_get_blue(c2), t);
    return make_color_rgb(r, g, b);
};